extends Node2D
## 대전 화면: 캐릭터 2명 배치, 바닥, 화면 벽, 서로 밀어내기
##
## 지금은 카메라가 고정이라 "스테이지 = 화면"이고, 양쪽 벽이 최대 거리 제한 역할을 한다.

const GROUND_Y := 620.0
const WALL_LEFT := 40.0
const WALL_RIGHT := 1240.0

const KO_RESET_FRAMES := 150    # KO 후 다시 시작하기까지 (임시, 라운드 시스템 전까지)

var p1: Fighter
var p2: Fighter
var _ko_timer := 0
var _hitstop := 0               # 남은 히트스톱 프레임 (0보다 크면 둘 다 멈춤)
var _shake := 0                 # 남은 화면 흔들림 프레임
var _sparks: Array = []         # [위치, 남은 프레임, 막혔나] 타격 이펙트
var _camera: Camera2D


func _ready() -> void:
	p1 = _spawn(1, Color(0.85, 0.2, 0.2), 440)
	p2 = _spawn(2, Color(0.2, 0.4, 0.9), 840)
	p1.opponent = p2
	p2.opponent = p1
	# 화면 흔들림용 카메라 (화면 가운데에 고정)
	_camera = Camera2D.new()
	_camera.position = Vector2(640, 360)
	add_child(_camera)


func _unhandled_input(event: InputEvent) -> void:
	# F2: 판정 박스 보기 (초록 = 몸통/피격, 빨강 = 공격)
	if event is InputEventKey and event.pressed and not event.echo \
			and event.physical_keycode == KEY_F2:
		for f in [p1, p2]:
			f.debug_draw_boxes = not f.debug_draw_boxes


func _spawn(player: int, color: Color, x: float) -> Fighter:
	var f := Fighter.new()
	f.player = player
	f.color = color
	f.ground_y = GROUND_Y
	f.position = Vector2(x, GROUND_Y)
	add_child(f)
	return f


## 매 프레임: 1P 이동 → 2P 이동 → 밀어내기 → 공격 판정 (항상 이 순서)
func _physics_process(_delta: float) -> void:
	_update_effects()
	if _hitstop > 0:
		# 히트스톱: 둘 다 멈춘다 (입력은 버퍼에 기억)
		_hitstop -= 1
		p1.tick_frozen()
		p2.tick_frozen()
	else:
		p1.tick()
		p2.tick()
		_resolve_push()
		_resolve_hits()
	_update_ko()
	queue_redraw()


func _update_effects() -> void:
	for spark in _sparks:
		spark[1] -= 1
	_sparks = _sparks.filter(func(spark): return spark[1] > 0)
	if _shake > 0:
		_shake -= 1
		_camera.offset = Vector2(randf_range(-6, 6), randf_range(-6, 6))
	else:
		_camera.offset = Vector2.ZERO


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


## KO가 나오면 잠시 뒤 처음부터 다시 (라운드 시스템은 나중에)
func _update_ko() -> void:
	if p1.state != Fighter.State.KO and p2.state != Fighter.State.KO:
		return
	_ko_timer += 1
	if _ko_timer >= KO_RESET_FRAMES:
		get_tree().reload_current_scene()


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


func _draw() -> void:
	# 배경과 바닥
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.12, 0.12, 0.16))
	draw_rect(Rect2(0, GROUND_Y, 1280, 720 - GROUND_Y), Color(0.25, 0.25, 0.3))
	draw_line(Vector2(0, GROUND_Y), Vector2(1280, GROUND_Y), Color.WHITE, 2.0)
	if p1 == null:
		return
	# 체력바 (1P는 왼쪽에서, 2P는 오른쪽에서 줄어든다)
	_draw_hp_bar(Rect2(40, 640, 540, 28), p1, false)
	_draw_hp_bar(Rect2(700, 640, 540, 28), p2, true)
	_draw_tension_bar(Rect2(40, 676, 300, 14), p1, false)
	_draw_tension_bar(Rect2(940, 676, 300, 14), p2, true)
	# 타격 이펙트: 맞으면 노란 별, 막히면 파란 원
	for spark in _sparks:
		var pos: Vector2 = spark[0]
		var t: float = spark[1] / 10.0
		if spark[2]:
			draw_arc(pos, 30 * (1.5 - t), 0, TAU, 24, Color(0.5, 0.8, 1.0, t), 5.0)
		else:
			for i in 8:
				var dir := Vector2.RIGHT.rotated(i * TAU / 8)
				draw_line(pos + dir * 10, pos + dir * (20 + 40 * (1.0 - t)), Color(1, 0.9, 0.3, t), 5.0)
	if _ko_timer > 0:
		draw_string(ThemeDB.fallback_font, Vector2(0, 330), "K.O.",
				HORIZONTAL_ALIGNMENT_CENTER, 1280, 96, Color.YELLOW)


func _draw_tension_bar(rect: Rect2, f: Fighter, from_right: bool) -> void:
	draw_rect(rect, Color(0.1, 0.1, 0.2))
	var ratio := f.tension / Fighter.MAX_TENSION
	var filled := Rect2(rect.position, Vector2(rect.size.x * ratio, rect.size.y))
	if from_right:
		filled.position.x = rect.end.x - filled.size.x
	# 로만 캔슬 가능(50% 이상)하면 밝은 색
	var rc_ready := f.tension >= Fighter.RC_COST
	draw_rect(filled, Color(0.3, 0.9, 1.0) if rc_ready else Color(0.2, 0.4, 0.7))
	draw_line(Vector2(rect.get_center().x, rect.position.y), Vector2(rect.get_center().x, rect.end.y), Color.WHITE, 2.0)
	draw_rect(rect, Color.WHITE, false, 2.0)
	draw_string(ThemeDB.fallback_font, Vector2(rect.position.x, rect.end.y + 16),
			"TENSION %d%%" % int(f.tension), HORIZONTAL_ALIGNMENT_LEFT, -1, 14)


func _draw_hp_bar(rect: Rect2, f: Fighter, from_right: bool) -> void:
	draw_rect(rect, Color(0.3, 0.05, 0.05))
	var ratio := float(f.hp) / f.max_hp
	var filled := Rect2(rect.position, Vector2(rect.size.x * ratio, rect.size.y))
	if from_right:
		filled.position.x = rect.end.x - filled.size.x
	draw_rect(filled, Color(1.0, 0.8, 0.1))
	draw_rect(rect, Color.WHITE, false, 2.0)
