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
var menu_cursor := 0

var _hitstop := 0               # 남은 히트스톱 프레임 (0보다 크면 둘 다 멈춤)
var _shake := 0                 # 남은 화면 흔들림 프레임
var _sparks: Array = []         # [위치, 남은 프레임, 막혔나] 타격 이펙트
var _camera: Camera2D
var _training_idle := { 1: 0, 2: 0 }  # 트레이닝: 안 맞고 지난 프레임 (체력 회복용)

@onready var _input_debug: Node2D = $InputDebug


func _ready() -> void:
	p1 = _spawn(1)
	p2 = _spawn(2)
	p1.opponent = p2
	p2.opponent = p1
	# 화면 흔들림용 카메라 (화면 가운데에 고정)
	_camera = Camera2D.new()
	_camera.position = Vector2(640, 360)
	add_child(_camera)
	_input_debug.visible = false

	if is_training():
		for f in [p1, p2]:
			f.can_die = false
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
	f.color = info["color"]
	# 같은 캐릭터끼리 붙으면 2P를 어둡게
	if player == 2 and Game.selected[1] == Game.selected[2]:
		f.color = f.color.darkened(0.35)
	f.ground_y = GROUND_Y
	f.position = Vector2(START_X[player], GROUND_Y)
	add_child(f)
	return f


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
	if paused:
		_update_pause_menu()
		queue_redraw()
		return
	if phase == Phase.RESULT:
		_update_result_menu()
		queue_redraw()
		return
	if phase == Phase.FIGHT and Game.menu_pressed("start"):
		paused = true
		menu_cursor = 0
		return

	_update_effects()
	if _hitstop > 0:
		# 히트스톱: 둘 다 멈춘다 (입력은 버퍼에 기억)
		_hitstop -= 1
		p1.tick_frozen()
		p2.tick_frozen()
	elif phase != Phase.VS_INTRO:
		# 1P 이동 → 2P 이동 → 밀어내기 → 공격 판정 (항상 이 순서)
		p1.tick()
		p2.tick()
		_resolve_push()
		_resolve_hits()
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
	_sparks.clear()
	_hitstop = 0


func _update_phase() -> void:
	match phase:
		Phase.VS_INTRO:
			if phase_frame >= VS_FRAMES:
				_start_round()
				_set_phase(Phase.ROUND_INTRO)
		Phase.ROUND_INTRO:
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
	if winner == 0:
		wins[1] += 1
		wins[2] += 1
	else:
		wins[winner] += 1
	_set_input(false)
	_set_phase(Phase.ROUND_END)


## 트레이닝: 시간 무제한, 텐션 항상 최대, 안 맞고 1초 지나면 체력 회복
func _update_training() -> void:
	for f in [p1, p2]:
		f.tension = Fighter.MAX_TENSION
		if f.state == Fighter.State.HITSTUN or f.state == Fighter.State.BLOCKSTUN:
			_training_idle[f.player] = 0
		else:
			_training_idle[f.player] += 1
			if _training_idle[f.player] >= 60:
				f.hp = f.max_hp


# ── 일시정지 / 결과 메뉴 ──────────────────────────────────
const PAUSE_ITEMS := ["resume", "to_char_select", "to_title"]    # Game.STRINGS 키
const RESULT_ITEMS := ["rematch", "to_char_select", "to_title"]


func _update_pause_menu() -> void:
	menu_cursor = _move_menu(menu_cursor, PAUSE_ITEMS.size())
	if Game.menu_pressed("start") or Game.menu_back():
		paused = false
	elif Game.menu_pressed("p"):
		match menu_cursor:
			0: paused = false
			1: Game.goto("char_select")
			2: Game.goto("title")


func _update_result_menu() -> void:
	if phase_frame < 60:  # 결과가 뜨자마자 실수로 누르는 것 방지
		return
	menu_cursor = _move_menu(menu_cursor, RESULT_ITEMS.size())
	if Game.menu_confirm():
		match menu_cursor:
			0: Game.goto("battle")
			1: Game.goto("char_select")
			2: Game.goto("title")


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
		if defender.state == Fighter.State.KO:
			continue
		if attacker.hitbox_rect().intersects(defender.body_rect()):
			var contact := attacker.hitbox_rect().intersection(defender.body_rect()).get_center()
			hits.append([attacker, defender, attacker.current_attack, contact])
	for hit in hits:
		var attacker: Fighter = hit[0]
		var defender: Fighter = hit[1]
		var attack: AttackData = hit[2]
		var contact: Vector2 = hit[3]
		var blocked := defender.receive_attack(attack, attacker.facing)
		attacker.on_attack_connected(blocked)
		_hitstop = maxi(_hitstop, attack.hitstop)
		_sparks.append([contact, 10, blocked])
		if not blocked:
			_shake = maxi(_shake, attack.hitstop)
		# 상대가 벽에 붙어 있어서 못 밀려나면, 대신 때린 쪽이 뒤로 밀려난다
		var half := defender.body_size().x / 2
		if defender.position.x - half <= WALL_LEFT + 1 or defender.position.x + half >= WALL_RIGHT - 1:
			if attacker.is_on_ground():
				attacker.velocity.x = -attack.pushback * attacker.facing


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


func _clamp_to_walls(f: Fighter) -> void:
	var half := f.body_size().x / 2
	f.position.x = clampf(f.position.x, WALL_LEFT + half, WALL_RIGHT - half)


func _update_effects() -> void:
	for spark in _sparks:
		spark[1] -= 1
	_sparks = _sparks.filter(func(spark): return spark[1] > 0)
	if _shake > 0:
		_shake -= 1
		_camera.offset = Vector2(randf_range(-6, 6), randf_range(-6, 6))
	else:
		_camera.offset = Vector2.ZERO


# ── 그리기 ───────────────────────────────────────────────
func _draw() -> void:
	# 배경과 바닥 (Match가 먼저 그리고, 캐릭터는 그 위에 그려진다)
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.12, 0.12, 0.16))
	draw_rect(Rect2(0, GROUND_Y, 1280, 720 - GROUND_Y), Color(0.25, 0.25, 0.3))
	draw_line(Vector2(0, GROUND_Y), Vector2(1280, GROUND_Y), Color.WHITE, 2.0)


## HUD와 연출 글자는 캐릭터보다 위에 그려야 해서 별도 노드(Overlay)가 이 함수를 부른다
func draw_overlay(c: CanvasItem) -> void:
	_draw_sparks(c)
	_draw_hud(c)
	match phase:
		Phase.VS_INTRO:
			_draw_vs(c)
		Phase.ROUND_INTRO:
			if phase_frame < 60:
				var label := "FINAL ROUND" if wins[1] == Game.ROUNDS_TO_WIN - 1 and wins[2] == Game.ROUNDS_TO_WIN - 1 \
						else "ROUND %d" % round_number
				_big_text(c, label, Color.WHITE)
			else:
				_big_text(c, "FIGHT!", Color(1, 0.3, 0.3))
		Phase.ROUND_END:
			_big_text(c, round_result, Color.YELLOW)
		Phase.RESULT:
			_draw_result(c)
	if paused:
		_draw_menu(c, Game.t("pause"), PAUSE_ITEMS)


func _draw_sparks(c: CanvasItem) -> void:
	# 타격 이펙트: 맞으면 노란 별, 막히면 파란 원
	for spark in _sparks:
		var pos: Vector2 = spark[0]
		var t: float = spark[1] / 10.0
		if spark[2]:
			c.draw_arc(pos, 30 * (1.5 - t), 0, TAU, 24, Color(0.5, 0.8, 1.0, t), 5.0)
		else:
			for i in 8:
				var dir := Vector2.RIGHT.rotated(i * TAU / 8)
				c.draw_line(pos + dir * 10, pos + dir * (20 + 40 * (1.0 - t)), Color(1, 0.9, 0.3, t), 5.0)


func _draw_hud(c: CanvasItem) -> void:
	var font := Game.FONT
	# 체력바 (가운데 쪽부터 줄어든다)
	_draw_hp_bar(c, Rect2(30, 30, 530, 32), p1, false)
	_draw_hp_bar(c, Rect2(720, 30, 530, 32), p2, true)
	c.draw_string(font, Vector2(34, 88), p1.display_name, HORIZONTAL_ALIGNMENT_LEFT, -1, 24)
	c.draw_string(font, Vector2(720, 88), p2.display_name, HORIZONTAL_ALIGNMENT_RIGHT, 526, 24)
	# 타이머
	c.draw_rect(Rect2(580, 20, 120, 70), Color(0, 0, 0, 0.6))
	var time_text := "--" if is_training() else str(ceili(maxi(timer_frames, 0) / 60.0))
	c.draw_string(font, Vector2(580, 75), time_text, HORIZONTAL_ALIGNMENT_CENTER, 120, 52, Color.WHITE)
	# 이긴 라운드 수 (● = 이김)
	if not is_training():
		for i in Game.ROUNDS_TO_WIN:
			_draw_round_pip(c, Vector2(545 - i * 26, 78), wins[1] > i)
			_draw_round_pip(c, Vector2(735 + i * 26, 78), wins[2] > i)
	else:
		c.draw_string(font, Vector2(0, 112), Game.t("training"), HORIZONTAL_ALIGNMENT_CENTER, 1280, 20, Color(1, 1, 1, 0.6))
	# 텐션 게이지 (아래쪽)
	_draw_tension_bar(c, Rect2(30, 672, 320, 16), p1, false)
	_draw_tension_bar(c, Rect2(930, 672, 320, 16), p2, true)


func _draw_round_pip(c: CanvasItem, pos: Vector2, won: bool) -> void:
	c.draw_circle(pos, 9, Color.YELLOW if won else Color(0.2, 0.2, 0.2))
	c.draw_arc(pos, 9, 0, TAU, 16, Color.WHITE, 2.0)


func _draw_hp_bar(c: CanvasItem, rect: Rect2, f: Fighter, from_right: bool) -> void:
	c.draw_rect(rect, Color(0.3, 0.05, 0.05))
	var ratio := float(f.hp) / f.max_hp
	var filled := Rect2(rect.position, Vector2(rect.size.x * ratio, rect.size.y))
	if from_right:
		filled.position.x = rect.end.x - filled.size.x
	var col := Color(1.0, 0.8, 0.1) if ratio > 0.25 else Color(1.0, 0.35, 0.2)  # 체력이 적으면 빨갛게
	c.draw_rect(filled, col)
	c.draw_rect(rect, Color.WHITE, false, 2.0)


func _draw_tension_bar(c: CanvasItem, rect: Rect2, f: Fighter, from_right: bool) -> void:
	c.draw_rect(rect, Color(0.1, 0.1, 0.2))
	var ratio := f.tension / Fighter.MAX_TENSION
	var filled := Rect2(rect.position, Vector2(rect.size.x * ratio, rect.size.y))
	if from_right:
		filled.position.x = rect.end.x - filled.size.x
	# 로만 캔슬 가능(50% 이상)하면 밝은 색
	var rc_ready := f.tension >= Fighter.RC_COST
	c.draw_rect(filled, Color(0.3, 0.9, 1.0) if rc_ready else Color(0.2, 0.4, 0.7))
	c.draw_line(Vector2(rect.get_center().x, rect.position.y), Vector2(rect.get_center().x, rect.end.y), Color.WHITE, 2.0)
	c.draw_rect(rect, Color.WHITE, false, 2.0)
	var align := HORIZONTAL_ALIGNMENT_RIGHT if from_right else HORIZONTAL_ALIGNMENT_LEFT
	c.draw_string(Game.FONT, Vector2(rect.position.x, rect.position.y - 6),
			"TENSION %d%%" % int(f.tension), align, rect.size.x, 14)


func _big_text(c: CanvasItem, s: String, color: Color) -> void:
	var font := Game.FONT
	c.draw_rect(Rect2(0, 290, 1280, 120), Color(0, 0, 0, 0.45))
	c.draw_string(font, Vector2(6, 386), s, HORIZONTAL_ALIGNMENT_CENTER, 1280, 96, Color(0, 0, 0, 0.6))
	c.draw_string(font, Vector2(0, 380), s, HORIZONTAL_ALIGNMENT_CENTER, 1280, 96, color)


func _draw_vs(c: CanvasItem) -> void:
	var font := Game.FONT
	var t := minf(phase_frame / 20.0, 1.0)  # 0 → 1: 양쪽에서 미끄러져 들어옴
	c.draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 0.85))
	var slide := (1.0 - t) * 700
	c.draw_rect(Rect2(-slide, 200, 640, 320), Color(p1.color, 0.85))
	c.draw_rect(Rect2(640 + slide, 200, 640, 320), Color(p2.color, 0.85))
	c.draw_string(font, Vector2(-slide, 390), p1.display_name, HORIZONTAL_ALIGNMENT_CENTER, 640, 64)
	c.draw_string(font, Vector2(640 + slide, 390), p2.display_name, HORIZONTAL_ALIGNMENT_CENTER, 640, 64)
	if t >= 1.0:
		c.draw_string(font, Vector2(0, 400), "VS", HORIZONTAL_ALIGNMENT_CENTER, 1280, 120, Color.YELLOW)


func _draw_result(c: CanvasItem) -> void:
	var title: String
	if wins[1] >= Game.ROUNDS_TO_WIN and wins[2] >= Game.ROUNDS_TO_WIN:
		title = Game.t("draw_game")
	elif wins[1] >= Game.ROUNDS_TO_WIN:
		title = Game.t("wins") % [1, p1.display_name]
	else:
		title = Game.t("wins") % [2, p2.display_name]
	_draw_menu(c, title, RESULT_ITEMS if phase_frame >= 60 else [])


func _draw_menu(c: CanvasItem, title: String, items: Array) -> void:
	var font := Game.FONT
	c.draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 0.6))
	c.draw_string(font, Vector2(0, 250), title, HORIZONTAL_ALIGNMENT_CENTER, 1280, 72, Color.YELLOW)
	for i in items.size():
		var y := 360 + i * 60
		var selected := i == menu_cursor
		var s: String = ("> %s <" if selected else "%s") % Game.t(items[i])
		c.draw_string(font, Vector2(0, y), s, HORIZONTAL_ALIGNMENT_CENTER, 1280, 36,
				Color(1, 0.3, 0.35) if selected else Color(0.85, 0.85, 0.9))
