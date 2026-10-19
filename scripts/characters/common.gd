extends Fighter
## COMMON (정보 동아리): 함정과 순간이동으로 상대를 헷갈리게 하는 해커
##
##   5D  패킷 전송   빠른 직선 투사체 (화면에 1개까지)
##   6D  버그 설치   앞 바닥에 함정. 밟으면 오래 경직 (하단, 1개까지)
##   2D  방화벽      앞에 벽. 상대 투사체를 막는다 (1개까지)
##   4D  Ctrl+Z      1초 전 위치로 되감기 (시작 6프레임 무적)
##   OD  블루스크린  (D+HS, 텐션 50%) 넓은 범위 공격. 맞으면 화면이 파래지고 상대가 오래 멈춘다

const CYAN := Color("37d6ff")
const BUG_GREEN := Color("7dff6a")
const BLUE_SCREEN := Color(0.1, 0.35, 1.0, 0.35)

## 투사체가 맞았을 때의 효과 (기술 목록과 별개)
var _packet_hit := AttackData.new("packet", 0, 0, 0, 30, Rect2(), AttackData.Level.MID, 16, 12)
var _bug_hit := AttackData.new("bug", 0, 0, 0, 20, Rect2(), AttackData.Level.LOW, 42, 14)

var _packet: Projectile
var _bug: Projectile
var _wall: Projectile
var _ghost_pos := Vector2.ZERO  # Ctrl+Z 잔상 위치
var _ghost_frames := 0


func _init() -> void:
	# 체력은 조금 낮지만 빠르다
	max_hp = 380
	walk_forward_speed = 4.6
	run_speed = 10.0


func _build_specials() -> void:
	var M := AttackData.Level.MID
	#                                 이름  발생 지속 후딜 데미지 판정    단계 히트 가드
	var a := _add(AttackData.new("5D", 12, 0, 22, 0, Rect2(), M, 0, 0))
	a.event_frame = 12
	a = _add(AttackData.new("6D", 10, 0, 18, 0, Rect2(), M, 0, 0))
	a.event_frame = 10
	a = _add(AttackData.new("2D", 8, 0, 22, 0, Rect2(), M, 0, 0))
	a.event_frame = 8
	a = _add(AttackData.new("4D", 6, 0, 14, 0, Rect2(), M, 0, 0))
	a.event_frame = 6
	a.invuln_frames = 6
	a = _add(AttackData.new("OD", 4, 8, 30, 60, Rect2(10, -220, 420, 220), M, 90, 20))
	a.title = "BLUE SCREEN"
	a.cost = Fighter.RC_COST
	a.invuln_frames = 12
	a.hitstop = 20


func _alive(p: Projectile) -> bool:
	return p != null and is_instance_valid(p) and not p.dead


func _can_use_special(attack_name: String) -> bool:
	if attack_name == "5D":
		return not _alive(_packet)  # 패킷은 화면에 하나만
	return true


func _on_attack_event(attack: AttackData) -> void:
	match attack.name:
		"5D":
			var p := Projectile.new()
			p.kind = "packet"
			p.attack = _packet_hit
			p.size = Vector2(44, 28)
			p.color = CYAN
			p.position = position + Vector2(60 * facing, -110)
			p.velocity = Vector2(11 * facing, 0)
			_packet = p
			spawn(p)
		"6D":
			if _alive(_bug):
				_bug.dead = true  # 새로 깔면 예전 것은 사라짐
			var p := Projectile.new()
			p.kind = "bug"
			p.attack = _bug_hit
			p.size = Vector2(46, 26)
			p.color = BUG_GREEN
			p.position = Vector2(position.x + 170 * facing, ground_y - 13)
			p.lifetime = 360
			p.arm_frames = 20
			p.hits_airborne = false
			_bug = p
			spawn(p)
		"2D":
			if _alive(_wall):
				_wall.dead = true
			var p := Projectile.new()
			p.kind = "wall"
			p.blocks_projectiles = true
			p.size = Vector2(34, 220)
			p.color = CYAN
			p.position = Vector2(position.x + 100 * facing, ground_y - 110)
			p.lifetime = 150
			_wall = p
			spawn(p)
		"4D":
			# Ctrl+Z: 기록된 가장 오래된 위치(약 1초 전)로 되돌아간다. 가로 위치만
			if not history.is_empty():
				_ghost_pos = position
				_ghost_frames = 20
				position.x = history[0].x
				history.clear()
				_face_opponent()


func _on_attack_result(attack: AttackData, blocked: bool) -> void:
	if attack.name == "OD" and not blocked:
		screen_tint.emit(BLUE_SCREEN, 90)


func tick() -> void:
	super()
	if _ghost_frames > 0:
		_ghost_frames -= 1


func _draw() -> void:
	# Ctrl+Z 잔상 (되감기 전 위치에 흐린 몸)
	if _ghost_frames > 0:
		var size := body_size()
		var a := _ghost_frames / 20.0
		draw_rect(Rect2(_ghost_pos - position + Vector2(-size.x / 2, -size.y), size), Color(CYAN, 0.4 * a))
		draw_string(Game.FONT, _ghost_pos - position + Vector2(-60, -size.y - 40), "Ctrl+Z",
				HORIZONTAL_ALIGNMENT_CENTER, 120, 22, Color(CYAN, a))
	super()
