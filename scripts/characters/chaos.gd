extends Fighter
## CHAOS (물리 동아리): 끌어당기고 잡아 던지는 잡기형. 가까이 붙어야 강하다
##
##   5D  만유인력      (역학) 잠깐 동안 상대를 내 쪽으로 끌어당긴다 (데미지 없음)
##   6D  운동량 던지기  (역학) 가드 불가 잡기. 땅에 서 있고 경직 중이 아닌 상대만 잡힌다. 빗나가면 빈틈 큼
##   2D  전자기 펄스   (전자기) 주변에 방전. 맞으면 감전되어 오래 경직
##   4D  양자 터널링   (양자) 상대를 통과해서 등 뒤로 순간이동 (도중 무적)
##   jD  열팽창 폭발   (열역학) 공중에서 아래 대각선으로 뜨거운 증기 폭발
##   OD  블랙홀        (상대성, D+HS, 텐션 50%) 블랙홀이 상대를 빨아들이며 때리고, 마지막에 폭발

const PURPLE := Color("a05cff")
const HEAT := Color("ff7a2a")

## 만유인력이 끌어당기는 힘 (프레임당 픽셀)과 범위
const GRAVITY_PULL := 6.0
const GRAVITY_RANGE := 480.0
## 양자 터널링: 상대 몸 뒤 몇 픽셀에 나타나나
const TUNNEL_BEHIND := 110.0

## 투사체가 맞았을 때의 효과 (기술 목록과 별개)
var _hole_hit := AttackData.new("blackhole", 0, 0, 0, 6, Rect2(), AttackData.Level.MID, 22, 10)
var _burst_hit := AttackData.new("collapse", 0, 0, 0, 45, Rect2(), AttackData.Level.MID, 30, 16)
var _steam_hit := AttackData.new("steam", 0, 0, 0, 35, Rect2(), AttackData.Level.OVERHEAD, 20, 14)

var _hole: Projectile
var _ghost_pos := Vector2.ZERO  # 양자 터널링 잔상 위치
var _ghost_frames := 0


func _init() -> void:
	# 체력 많고 보통 속도
	max_hp = 460
	walk_forward_speed = 3.8
	run_speed = 9.0
	_hole_hit.hitstop = 2  # 여러 번 맞는 기술이라 멈춤을 짧게
	_burst_hit.launch = Vector2(9, -12)


func _build_specials() -> void:
	var M := AttackData.Level.MID
	#                                 이름  발생 지속 후딜 데미지 판정 범위                    단계 히트 가드
	var a := _add(AttackData.new("5D", 10, 22, 16, 0, Rect2(), M, 0, 0))
	a = _add(AttackData.new("6D", 6, 3, 30, 70, Rect2(20, -150, 70, 140), M, 30, 0))
	a.is_throw = true
	a.launch = Vector2(-11, -13)  # 등 뒤로 넘겨 던진다
	a.hitstop = 14
	a = _add(AttackData.new("2D", 9, 8, 24, 32, Rect2(-90, -210, 270, 210), M, 34, 16))
	a.pushback = 10.0
	a = _add(AttackData.new("4D", 6, 0, 12, 0, Rect2(), M, 0, 0))
	a.event_frame = 6
	a.invuln_frames = 14
	a = _add(AttackData.new("jD", 8, 0, 18, 0, Rect2(), M, 0, 0))
	a.event_frame = 8
	a = _add(AttackData.new("OD", 8, 0, 44, 0, Rect2(), M, 0, 0))
	a.title = "BLACK HOLE"
	a.cost = Fighter.RC_COST
	a.invuln_frames = 10
	a.event_frame = 8


## 타입을 안 붙인 이유: 이미 지워진(freed) 투사체가 들어오면 타입 검사에서 오류가 나기 때문
func _alive(p) -> bool:
	return is_instance_valid(p) and not p.dead


func _on_attack_event(attack: AttackData) -> void:
	match attack.name:
		"4D":
			# 양자 터널링: 상대를 통과해서 반대편(등 뒤)에 나타난다
			if opponent != null:
				_ghost_pos = position
				_ghost_frames = 20
				var side := signf(opponent.position.x - position.x)
				if side == 0:
					side = facing
				position.x = clampf(opponent.position.x + side * TUNNEL_BEHIND, 80.0, 1200.0)
				history.clear()
		"jD":
			var p := Projectile.new()
			p.kind = "explosion"
			p.attack = _steam_hit
			p.size = Vector2(120, 120)
			p.color = HEAT
			p.position = position + Vector2(110 * facing, 40)
			p.velocity = Vector2(4.0 * facing, 6.0)
			p.lifetime = 18
			spawn(p)
		"OD":
			var p := Projectile.new()
			p.kind = "blackhole"
			p.attack = _hole_hit
			p.size = Vector2(260, 260)
			p.color = PURPLE
			p.position = Vector2(position.x + 260 * facing, ground_y - 170)
			p.lifetime = 75
			p.rehit_interval = 10
			_hole = p
			spawn(p)


## 전자기 펄스가 맞으면 감전 표시
func _on_attack_result(attack: AttackData, blocked: bool) -> void:
	if attack.name == "2D" and not blocked and opponent != null:
		opponent.shock_frames = attack.hitstun


func tick() -> void:
	super()
	if _ghost_frames > 0:
		_ghost_frames -= 1
	# 만유인력: 지속 시간 동안 상대를 내 쪽으로
	if _in_attack("5D") and state_frame > current_attack.startup \
			and state_frame <= current_attack.startup + current_attack.active:
		pull_opponent(position.x + 90 * facing, GRAVITY_PULL, GRAVITY_RANGE)
	# 블랙홀: 빨아들이다가 사라지는 순간 폭발
	if _alive(_hole):
		pull_opponent(_hole.position.x, 7.0, 650.0)
		if _hole.age >= _hole.lifetime - 1:
			var boom := Projectile.new()
			boom.kind = "explosion"
			boom.attack = _burst_hit
			boom.size = Vector2(300, 300)
			boom.color = PURPLE
			boom.position = _hole.position
			boom.lifetime = 14
			spawn(boom)


func _in_attack(attack_name: String) -> bool:
	return state == State.ATTACK and current_attack != null and current_attack.name == attack_name


func _draw() -> void:
	# 만유인력: 바깥에서 안으로 줄어드는 고리
	if _in_attack("5D") and state_frame > current_attack.startup:
		var center := Vector2(90 * facing, -90)
		for i in 3:
			var t := fmod(state_frame * 0.05 + i / 3.0, 1.0)
			draw_arc(center, GRAVITY_RANGE * 0.5 * (1.0 - t), 0, TAU, 40, Color(PURPLE, 0.5 * t), 4.0)
	# 전자기 펄스: 주변에 퍼지는 번개 고리
	if _in_attack("2D") and current_attack.is_active(state_frame):
		for i in 8:
			var ang := i * TAU / 8 + state_frame * 0.4
			var from := Vector2(0, -100) + Vector2(40, 0).rotated(ang)
			var to := Vector2(0, -100) + Vector2(150, 0).rotated(ang + 0.2)
			draw_line(from, to, Color(1, 0.95, 0.3, 0.9), 3.0)
	# 양자 터널링: 사라진 자리에 흐릿한 잔상 + 확률 구름
	if _ghost_frames > 0:
		var a := _ghost_frames / 20.0
		var size := body_size()
		draw_rect(Rect2(_ghost_pos - position + Vector2(-size.x / 2, -size.y), size), Color(PURPLE, 0.35 * a))
		for i in 6:
			draw_circle(_ghost_pos - position + Vector2(sin(i * 2.1) * 40, -size.y * 0.5 + cos(i * 1.7) * 60),
					10, Color(PURPLE, 0.3 * a))
	super()
