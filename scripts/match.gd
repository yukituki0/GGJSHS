class_name Match
extends Node2D
## 대전 화면: 캐릭터 2명, 라운드 진행, 판정, 화면 연출, HUD
##
## 지금은 카메라가 고정이라 "스테이지 = 화면"이고, 양쪽 벽이 최대 거리 제한 역할을 한다.
##
## 진행 단계:
##   VS 화면(첫 라운드만) → ROUND N → FIGHT! → 싸움 → K.O. / TIME UP → (다음 라운드 or 결과)

enum Phase { VS_INTRO, ROUND_INTRO, FIGHT, ROUND_END, RESULT }

const GROUND_Y := 620.0
const WALL_LEFT := 40.0
const WALL_RIGHT := 1240.0
const START_X := { 1: 440.0, 2: 840.0 }

const VS_FRAMES := 120          # VS 화면
const ROUND_INTRO_FRAMES := 100 # "ROUND N"(앞 60) + "FIGHT!"(뒤 40)
const ROUND_END_FRAMES := 150   # K.O. 표시 후 다음 라운드까지

var p1: Fighter
var p2: Fighter
var phase: Phase = Phase.VS_INTRO
var phase_frame := 0
var round_number := 1
var wins := { 1: 0, 2: 0 }
var timer_frames := 0           # 남은 시간 (프레임)
var round_result := ""          # "K.O." / "TIME UP" / "DOUBLE K.O." / "DRAW"
var paused := false
var show_moves := false         # 일시정지 메뉴에서 기술표를 보는 중
var menu_cursor := 0

var _hitstop := 0               # 남은 히트스톱 프레임 (0보다 크면 둘 다 멈춤)
var _shake := 0                 # 남은 화면 흔들림 프레임
var sparks: Array = []          # [위치, 남은 프레임, 막혔나] 타격 이펙트 (HUD가 그림)
var projectiles: Array[Projectile] = []
var superflash := 0             # 오버드라이브 컷인으로 화면이 멈춘 남은 프레임
var superflash_fighter: Fighter
var superflash_attack: AttackData
var tint_color := Color.TRANSPARENT  # 화면 전체 색 효과 (HUD가 그림)
var tint_frames := 0
var _camera: Camera2D
var _training_idle := { 1: 0, 2: 0 }  # 트레이닝: 안 맞고 지난 프레임 (체력 회복용)
var _stage_texture: Texture2D
var training_settings := false   # 일시정지 중 ⚙ 트레이닝 설정 화면을 보고 있나
var _history: Node2D             # 트레이닝 입력 기록 (트레이닝 아니면 null)

@onready var _input_debug: Node2D = $HudLayer/InputDebug


func _ready() -> void:
	Sfx.play_bgm("bgm_battle")
	if Game.stage_random:
		Game.stage = randi() % Game.STAGES.size()
	_stage_texture = Game.load_texture("res://assets/stages/%s.png" % Game.stage_info()["id"])
	p1 = _spawn(1)
	p2 = _spawn(2)
	p1.opponent = p2
	p2.opponent = p1
	if is_training():
		# 스파·길티 트레이닝처럼 입력 기록 표시 (사람이 조작하는 쪽만)
		_history = Node2D.new()
		_history.set_script(load("res://scripts/input_history.gd"))
		_history.match_node = self
		$HudLayer.add_child(_history)
	# 화면 흔들림용 카메라 (화면 가운데에 고정)
	_camera = Camera2D.new()
	_camera.position = Vector2(640, 360)
	add_child(_camera)
	_input_debug.visible = false

	if is_training():
		for f in [p1, p2]:
			f.can_die = false
		p2.dummy = Game.dummy_mode as Fighter.Dummy  # 2P 자리는 더미 (혼자 연습)
		_start_round()
		_set_phase(Phase.FIGHT)
	else:
		_set_phase(Phase.VS_INTRO)
		_set_input(false)


func is_training() -> bool:
	return Game.mode == Game.Mode.TRAINING


func _spawn(player: int) -> Fighter:
	var info := Game.character(player)
	var f: Fighter = load(info["script"]).new()
	f.player = player
	f.display_name = info["name"]
	if Game.demo:  # 데모: 둘 다 어려움 CPU
		f.brain = CpuBrain.new(CpuBrain.Level.HARD)
		f.display_name = "CPU " + f.display_name
	elif player == 2 and Game.mode == Game.Mode.CPU:
		f.brain = CpuBrain.new(Game.cpu_level)
		f.display_name = "CPU " + f.display_name
	f.color = info["color"]
	f.char_id = info["id"]
	# 같은 캐릭터끼리 붙으면 2P를 어둡게
	if player == 2 and Game.selected[1] == Game.selected[2]:
		f.color = f.color.darkened(0.35)
		f.art_modulate = Color(0.7, 0.75, 0.9)
	f.ground_y = GROUND_Y
	f.position = Vector2(START_X[player], GROUND_Y)
	add_child(f)
	f.projectile_spawned.connect(_on_projectile_spawned)
	f.super_flash.connect(_on_super_flash)
	f.screen_tint.connect(_on_screen_tint)
	return f


func _on_screen_tint(color: Color, frames: int) -> void:
	tint_color = color
	tint_frames = frames


func _on_projectile_spawned(p: Projectile) -> void:
	projectiles.append(p)
	add_child(p)


const SUPERFLASH_FRAMES := 45
const BURST_FLASH_FRAMES := 20     # 버스트는 짧게 (흐름이 끊기지 않게)
var superflash_total := SUPERFLASH_FRAMES  # 이번 컷인의 전체 길이 (HUD 연출 진행도 계산용)


func _on_super_flash(f: Fighter, attack: AttackData) -> void:
	superflash = BURST_FLASH_FRAMES if attack.name == "burst" else SUPERFLASH_FRAMES
	superflash_total = superflash
	superflash_fighter = f
	superflash_attack = attack


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.physical_keycode:
		KEY_F2:  # 판정 박스 + 상태 이름 보기
			for f in [p1, p2]:
				f.debug_draw_boxes = not f.debug_draw_boxes
		KEY_F3:  # 입력 테스트 표시
			_input_debug.visible = not _input_debug.visible


# ── 매 프레임 ─────────────────────────────────────────────
func _physics_process(_delta: float) -> void:
	phase_frame += 1
	# 데모: 아무 버튼이나 누르거나 경기가 끝나면 타이틀로
	if Game.demo and ((phase_frame > 30 and Input.is_anything_pressed()) or phase == Phase.RESULT):
		Game.end_demo()
		return
	if paused:
		_update_pause_menu()
		queue_redraw()
		return
	if phase == Phase.RESULT:
		_update_result_menu()
		queue_redraw()
		return
	if phase == Phase.FIGHT and Game.pause_pressed():
		paused = true
		training_settings = false
		menu_cursor = 0
		return

	_update_effects()
	if superflash > 0:
		# 오버드라이브 컷인: 둘 다 멈춤 (입력은 버퍼에 기억)
		superflash -= 1
		p1.tick_frozen()
		p2.tick_frozen()
	elif _hitstop > 0:
		# 히트스톱: 둘 다 멈춘다 (입력은 버퍼에 기억)
		_hitstop -= 1
		p1.tick_frozen()
		p2.tick_frozen()
	elif phase != Phase.VS_INTRO:
		# 1P 이동 → 2P 이동 → 밀어내기 → 공격 판정 (항상 이 순서)
		p1.tick()
		p2.tick()
		for proj in projectiles.duplicate():  # 도중에 새 투사체가 생길 수 있어서 복사본으로
			proj.tick()
		_resolve_push()
		_resolve_hits()
		_resolve_projectiles()
	_update_phase()
	queue_redraw()


func _set_phase(new_phase: Phase) -> void:
	phase = new_phase
	phase_frame = 0


func _set_input(enabled: bool) -> void:
	p1.input_enabled = enabled
	p2.input_enabled = enabled


func _start_round() -> void:
	p1.reset_for_round(START_X[1])
	p2.reset_for_round(START_X[2])
	timer_frames = Game.ROUND_SECONDS * 60
	round_result = ""
	sparks.clear()
	for proj in projectiles:
		proj.queue_free()
	projectiles.clear()
	_hitstop = 0
	superflash = 0
	tint_frames = 0


func _update_phase() -> void:
	match phase:
		Phase.VS_INTRO:
			if phase_frame >= VS_FRAMES:
				_start_round()
				_set_phase(Phase.ROUND_INTRO)
		Phase.ROUND_INTRO:
			if phase_frame == 60:
				Sfx.play("fight")  # "FIGHT!" 글자와 같이
			if phase_frame >= ROUND_INTRO_FRAMES:
				_set_input(true)
				_set_phase(Phase.FIGHT)
		Phase.FIGHT:
			if is_training():
				_update_training()
			else:
				_update_fight()
		Phase.ROUND_END:
			if phase_frame >= ROUND_END_FRAMES:
				if wins[1] >= Game.ROUNDS_TO_WIN or wins[2] >= Game.ROUNDS_TO_WIN:
					menu_cursor = 0
					_set_phase(Phase.RESULT)
				else:
					round_number += 1
					_start_round()
					_set_phase(Phase.ROUND_INTRO)


func _update_fight() -> void:
	if _hitstop == 0:
		timer_frames -= 1
	var ko1 := p1.state == Fighter.State.KO
	var ko2 := p2.state == Fighter.State.KO
	if ko1 or ko2:
		if ko1 and ko2:
			_end_round(0, "DOUBLE K.O.")
		else:
			_end_round(2 if ko1 else 1, "K.O.")
	elif timer_frames <= 0:
		# 시간 종료: 체력이 많은 쪽 승리
		if p1.hp == p2.hp:
			_end_round(0, "TIME UP")
		else:
			_end_round(1 if p1.hp > p2.hp else 2, "TIME UP")


## winner: 1, 2, 또는 0(무승부 = 둘 다 1승)
func _end_round(winner: int, result: String) -> void:
	round_result = result
	Sfx.play("ko")
	if winner == 0:
		wins[1] += 1
		wins[2] += 1
	else:
		wins[winner] += 1
	_set_input(false)
	_set_phase(Phase.ROUND_END)


## 트레이닝: 시간 무제한, 텐션/마력 항상 최대, 안 맞고 1초 지나면 체력 회복
func _update_training() -> void:
	for f in [p1, p2]:
		f.tension = Fighter.MAX_TENSION
		f.mana = Fighter.MAX_MANA
		if f.state == Fighter.State.HITSTUN or f.state == Fighter.State.BLOCKSTUN:
			_training_idle[f.player] = 0
		else:
			_training_idle[f.player] += 1
			if _training_idle[f.player] >= 60:
				f.hp = f.max_hp


# ── 일시정지 / 결과 메뉴 ──────────────────────────────────
const RESULT_ITEMS := ["rematch", "to_char_select", "to_mode_select", "to_title"]  # Game.STRINGS 키


## 일시정지 메뉴 항목 (트레이닝이면 더미 설정이 추가된다)
func pause_items() -> Array:
	if is_training():
		if training_settings:
			return ["dummy", "hitbox", "input_log", "back"]
		return ["resume", "command_list", "training_settings", "to_char_select", "to_mode_select", "to_title"]
	return ["resume", "command_list", "to_char_select", "to_mode_select", "to_title"]


## 메뉴 항목에 보일 글자 (더미는 현재 설정까지)
func menu_label(key: String) -> String:
	if key == "dummy":
		return "%s: %s" % [Game.t("dummy"), Game.t(Game.DUMMY_KEYS[Game.dummy_mode])]
	if key == "hitbox":
		return "%s: %s" % [Game.t("hitbox"), Game.t("on" if p1.debug_draw_boxes else "off")]
	if key == "training_settings":
		return Game.t("training_settings")  # 앞에 톱니바퀴 아이콘은 battle_hud가 그림
	if key == "input_log":
		return "%s: %s" % [Game.t("input_log"), Game.t("on" if _history != null and _history.visible else "off")]
	return Game.t(key)


func _update_pause_menu() -> void:
	if show_moves:
		if Game.menu_back() or Game.pause_pressed() or Game.menu_pressed("p"):
			show_moves = false
		return
	var items := pause_items()
	menu_cursor = _move_menu(menu_cursor, items.size())
	if Game.pause_pressed() or Game.menu_back():
		if training_settings:  # 설정 화면에서 뒤로 = 일시정지 메뉴로
			training_settings = false
			menu_cursor = 2
		else:
			paused = false
		return
	if not Game.menu_pressed("p"):
		return
	match items[menu_cursor]:
		"resume":
			paused = false
		"dummy":
			# 누를 때마다 다음 동작으로
			Game.dummy_mode = (Game.dummy_mode + 1) % Game.DUMMY_KEYS.size()
			p2.dummy = Game.dummy_mode as Fighter.Dummy
		"hitbox":  # 판정 박스 보기 (F2와 같음)
			var show := not p1.debug_draw_boxes
			for f: Fighter in [p1, p2]:
				f.debug_draw_boxes = show
		"command_list":
			show_moves = true
		"training_settings":  # ⚙ 트레이닝 설정 (더미 / 판정 보기 / 입력 기록)
			training_settings = true
			menu_cursor = 0
		"back":
			training_settings = false
			menu_cursor = 2
		"input_log":  # 입력 기록 켜기/끄기
			if _history != null:
				_history.visible = not _history.visible
		"to_char_select":
			Game.goto("char_select")
		"to_mode_select":
			Game.goto("mode_select")
		"to_title":
			Game.goto("title")


func _update_result_menu() -> void:
	if phase_frame < 60:  # 결과가 뜨자마자 실수로 누르는 것 방지
		return
	menu_cursor = _move_menu(menu_cursor, RESULT_ITEMS.size())
	if Game.menu_confirm():
		match menu_cursor:
			0: Game.goto("battle")
			1: Game.goto("char_select")
			2: Game.goto("mode_select")
			3: Game.goto("title")


func _move_menu(cursor: int, count: int) -> int:
	if Game.menu_pressed("up"):
		return (cursor - 1 + count) % count
	if Game.menu_pressed("down"):
		return (cursor + 1) % count
	return cursor


# ── 판정 ─────────────────────────────────────────────────
## 양쪽 공격을 "먼저 다 검사하고 나서" 적용한다 → 동시에 맞으면 둘 다 맞음(상쇄)
func _resolve_hits() -> void:
	var hits: Array = []  # [공격자, 방어자, 기술, 맞은 위치]
	for pair in [[p1, p2], [p2, p1]]:
		var attacker: Fighter = pair[0]
		var defender: Fighter = pair[1]
		if defender.state == Fighter.State.KO or defender.is_invulnerable():
			continue
		# 잡기는 땅에 서 있고 경직 중이 아닌 상대만 잡힌다
		var atk := attacker.current_attack
		if atk != null and atk.is_throw and (not defender.is_on_ground() \
				or defender.state == Fighter.State.HITSTUN or defender.state == Fighter.State.BLOCKSTUN):
			continue
		var hurt := _touching(attacker.hitbox_rect(), defender)
		if hurt.has_area():
			var contact := attacker.hitbox_rect().intersection(hurt).get_center()
			hits.append([attacker, defender, attacker.current_attack, contact])
	for hit in hits:
		var attacker: Fighter = hit[0]
		var defender: Fighter = hit[1]
		var attack: AttackData = hit[2]
		var contact: Vector2 = hit[3]
		_apply_hit(attacker, defender, attack, contact, attacker.facing)
		# 상대가 벽에 붙어 있어서 못 밀려나면, 대신 때린 쪽이 뒤로 밀려난다
		var half := defender.body_size().x / 2
		if defender.position.x - half <= WALL_LEFT + 1 or defender.position.x + half >= WALL_RIGHT - 1:
			if attacker.is_on_ground():
				attacker.velocity.x = -attack.pushback * attacker.facing


## 맞히기 공통 처리 (몸 공격, 투사체 둘 다). 막혔으면 true
func _apply_hit(attacker: Fighter, defender: Fighter, attack: AttackData, contact: Vector2, dir: int,
		from_super := false) -> bool:
	var blocked := defender.receive_attack(attack, dir, attacker.damage_mult)
	if blocked:
		Sfx.play("guard", -2.0, 0.08)
	elif attack.damage >= 45 or defender.last_hit_counter:  # 카운터는 무거운 타격음 + 더 긴 멈춤
		Sfx.play("hit_heavy", 0.0, 0.05)
	elif attack.damage >= 25:
		Sfx.play("hit_medium", -1.0, 0.08)
	else:
		Sfx.play("hit_light", -2.0, 0.1)
	attacker.on_attack_connected(attack, blocked, from_super)
	_hitstop = maxi(_hitstop, attack.hitstop + (Fighter.COUNTER_HITSTOP if defender.last_hit_counter else 0))
	sparks.append([contact, 10, blocked])
	if not blocked:
		_shake = maxi(_shake, attack.hitstop)
	return blocked


## 투사체: 상대 몸에 맞기, 투사체끼리 부딪히기, 다 된 것 지우기
func _resolve_projectiles() -> void:
	for proj in projectiles:
		if proj.dead or proj.attack == null or not proj.is_armed() or proj.rehit_cd > 0:
			continue
		var target := p2 if proj.shooter == p1 else p1
		if target.state == Fighter.State.KO or target.is_invulnerable():
			continue
		if not proj.hits_airborne and not target.is_on_ground():
			continue
		var hurt := _touching(proj.rect(), target)
		if hurt.has_area():
			var contact := proj.rect().intersection(hurt).get_center()
			_apply_hit(proj.shooter, target, proj.attack, contact, proj.hit_direction(), proj.from_super)
			if proj.rehit_interval > 0:
				proj.rehit_cd = proj.rehit_interval  # 웅덩이처럼 남아서 또 맞힘
			else:
				proj.dead = true
	# 투사체끼리: 방화벽은 상대 투사체를 지우고, 나머지는 서로 상쇄
	for a in projectiles:
		for b in projectiles:
			if a == b or a.dead or b.dead or a.shooter == b.shooter:
				continue
			if not a.rect().intersects(b.rect()):
				continue
			if a.blocks_projectiles and not b.blocks_projectiles:
				b.dead = true
			elif b.blocks_projectiles and not a.blocks_projectiles:
				a.dead = true
			elif not a.blocks_projectiles and not b.blocks_projectiles and a.attack != null and b.attack != null:
				a.dead = true
				b.dead = true
				sparks.append([a.rect().intersection(b.rect()).get_center(), 10, true])
	for proj in projectiles.filter(func(x): return x.dead):
		proj.queue_free()
	projectiles.assign(projectiles.filter(func(x): return not x.dead))


## 두 몸통이 겹치면 반씩 밀어내고, 벽 밖으로 못 나가게 막는다
func _resolve_push() -> void:
	if p1.body_rect().intersects(p2.body_rect()):
		var p1_is_left := p1.position.x < p2.position.x \
				or (p1.position.x == p2.position.x and p1.facing == 1)
		var left := p1 if p1_is_left else p2
		var right := p2 if p1_is_left else p1
		var overlap := left.body_rect().end.x - right.body_rect().position.x
		left.position.x -= overlap / 2
		right.position.x += overlap / 2
		_clamp_to_walls(left)
		_clamp_to_walls(right)
		# 한쪽이 벽에 막혀서 덜 밀렸으면, 나머지를 반대쪽 캐릭터가 마저 밀린다
		overlap = left.body_rect().end.x - right.body_rect().position.x
		if overlap > 0:
			if left.body_rect().position.x <= WALL_LEFT:
				right.position.x += overlap
			else:
				left.position.x -= overlap
	_clamp_to_walls(p1)
	_clamp_to_walls(p2)


## box와 겹치는 f의 맞는 판정 (없으면 크기 0)
func _touching(box: Rect2, f: Fighter) -> Rect2:
	if not box.has_area():
		return Rect2()
	for r: Rect2 in f.hurt_rects():
		if box.intersects(r):
			return r
	return Rect2()


func _clamp_to_walls(f: Fighter) -> void:
	var half := f.body_size().x / 2
	f.position.x = clampf(f.position.x, WALL_LEFT + half, WALL_RIGHT - half)


func _update_effects() -> void:
	for spark in sparks:
		spark[1] -= 1
	sparks = sparks.filter(func(spark): return spark[1] > 0)
	if tint_frames > 0:
		tint_frames -= 1
	if _shake > 0:
		_shake -= 1
		_camera.offset = Vector2(randf_range(-6, 6), randf_range(-6, 6))
	else:
		_camera.offset = Vector2.ZERO
	_update_camera()


## 카메라: 두 캐릭터를 따라가며 확대 (길티기어처럼 캐릭터가 크게 보이게)
## 가까우면 최대 CAMERA_MAX_ZOOM배, 멀어지거나 높이 뛰면 둘 다 보이도록 줄인다 (최소 1배 = 스테이지 전체)
## 게임 판정/거리는 그대로이고 보이는 크기만 바뀐다
const CAMERA_MAX_ZOOM := 1.5
const CAMERA_MARGIN := 260.0     # 캐릭터 바깥으로 보여줄 여유 (가로)
const CAMERA_GROUND_SCREEN_Y := 650.0  # 바닥이 화면에서 이 높이에 오게


func _update_camera() -> void:
	if p1 == null or p2 == null:
		return
	var dist := absf(p1.position.x - p2.position.x)
	var zoom := clampf(1280.0 / (dist + CAMERA_MARGIN * 2.0), 1.0, CAMERA_MAX_ZOOM)
	var top := minf(p1.position.y, p2.position.y) - 280.0  # 머리 위 여유
	zoom = clampf(minf(zoom, CAMERA_GROUND_SCREEN_Y / maxf(1.0, GROUND_Y - top)), 1.0, CAMERA_MAX_ZOOM)
	var z := lerpf(_camera.zoom.x, zoom, 0.08)
	_camera.zoom = Vector2(z, z)
	var half := Vector2(640.0, 360.0) / z
	var x := clampf((p1.position.x + p2.position.x) / 2.0, half.x, 1280.0 - half.x)
	var y := clampf(GROUND_Y - (CAMERA_GROUND_SCREEN_Y - 360.0) / z, half.y, 720.0 - half.y)
	_camera.position = Vector2(x, y)


# ── 그리기 ───────────────────────────────────────────────
## 배경 (Match가 먼저 그리고, 캐릭터와 HUD는 그 위에 그려진다)
## HUD와 연출 글자는 battle_hud.gd가 그린다
func _draw() -> void:
	if is_training():
		_draw_training_stage()
		return
	if _stage_texture != null:
		draw_texture_rect(_stage_texture, Rect2(0, 0, 1280, 720), false)
		return
	# 임시 배경: 위아래 그라데이션 + 바닥
	var info := Game.stage_info()
	var top: Color = info["sky"][0]
	var bottom: Color = info["sky"][1]
	draw_polygon(PackedVector2Array([Vector2(0, 0), Vector2(1280, 0), Vector2(1280, GROUND_Y), Vector2(0, GROUND_Y)]),
			PackedColorArray([top, top, bottom, bottom]))
	draw_rect(Rect2(0, GROUND_Y, 1280, 720 - GROUND_Y), info["floor"])
	draw_line(Vector2(0, GROUND_Y), Vector2(1280, GROUND_Y), Color(1, 1, 1, 0.5), 2.0)
	var name_text: String = info["name"][Game.language]
	Style.text(self, name_text, Vector2(0, GROUND_Y - 200), 64, Color(1, 1, 1, 0.06),
			HORIZONTAL_ALIGNMENT_CENTER, 1280)


## 트레이닝 스테이지: 스파 트레이닝처럼 밝은 격자 방 (거리 감 잡기용)
const GRID := 80.0
func _draw_training_stage() -> void:
	# 벽: 위가 조금 밝은 회색 + 정사각 격자 (4칸마다 굵게)
	draw_polygon(PackedVector2Array([Vector2(-400, -400), Vector2(1680, -400), Vector2(1680, GROUND_Y), Vector2(-400, GROUND_Y)]),
			PackedColorArray([Color("e9ecf1"), Color("e9ecf1"), Color("c3c9d2"), Color("c3c9d2")]))
	var gx := -400.0
	var i := 0
	while gx <= 1680.0:
		var bold := i % 4 == 0
		draw_line(Vector2(gx, -400), Vector2(gx, GROUND_Y), Color(0.45, 0.5, 0.58, 0.55 if bold else 0.25), 2.0 if bold else 1.0)
		gx += GRID
		i += 1
	var gy := GROUND_Y
	i = 0
	while gy >= -400.0:
		var bold := i % 4 == 0
		draw_line(Vector2(-400, gy), Vector2(1680, gy), Color(0.45, 0.5, 0.58, 0.55 if bold else 0.25), 2.0 if bold else 1.0)
		gy -= GRID
		i += 1
	# 바닥: 어두운 회색 + 가운데로 모이는 원근 격자
	draw_rect(Rect2(-400, GROUND_Y, 2080, 720 - GROUND_Y + 400), Color("8f97a3"))
	var vanish := Vector2(640, GROUND_Y - 900)
	for k in range(-12, 13):
		var foot := Vector2(640 + k * GRID * 2, 720 + 200)
		var top := foot.lerp(vanish, (foot.y - GROUND_Y) / (foot.y - vanish.y))
		draw_line(top, foot, Color(0.3, 0.34, 0.4, 0.5), 1.5)
	for k in 5:
		var y := GROUND_Y + pow(k / 4.0, 1.6) * (720 - GROUND_Y + 60)
		draw_line(Vector2(-400, y), Vector2(1680, y), Color(0.3, 0.34, 0.4, 0.45), 1.5)
	draw_line(Vector2(-400, GROUND_Y), Vector2(1680, GROUND_Y), Color(1, 1, 1, 0.8), 3.0)
	# 가운데 표시
	draw_line(Vector2(640, GROUND_Y), Vector2(640, GROUND_Y + 40), Color(1, 0.3, 0.3, 0.7), 3.0)
