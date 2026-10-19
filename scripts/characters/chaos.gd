extends Fighter
## CHAOS (물리 동아리): 끌어당기고 잡아 던지는 잡기형. 가까이 붙어야 강하다
##
##   5D  중력장       잠깐 동안 상대를 내 쪽으로 끌어당긴다 (데미지 없음)
##   6D  운동량 던지기  가드 불가 잡기. 땅에 서 있고 경직 중이 아닌 상대만 잡힌다. 빗나가면 빈틈 큼
##   2D  반발력       주변을 크게 밀쳐내는 넓은 공격
##   4D  등속 운동    바닥을 미끄러지듯 빠르게 앞으로 이동
##   OD  블랙홀       (D+HS, 텐션 50%) 블랙홀이 상대를 빨아들이며 때리고, 마지막에 폭발

const PURPLE := Color("a05cff")

## 중력장이 끌어당기는 힘 (프레임당 픽셀)과 범위
const GRAVITY_PULL := 6.0
const GRAVITY_RANGE := 480.0

## 투사체가 맞았을 때의 효과 (기술 목록과 별개)
var _hole_hit := AttackData.new("blackhole", 0, 0, 0, 6, Rect2(), AttackData.Level.MID, 22, 10)
var _burst_hit := AttackData.new("collapse", 0, 0, 0, 45, Rect2(), AttackData.Level.MID, 30, 16)

var _hole: Projectile


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
	a = _add(AttackData.new("2D", 8, 6, 22, 30, Rect2(-80, -210, 250, 210), M, 18, 16))
	a.pushback = 18.0
	a = _add(AttackData.new("4D", 4, 12, 8, 0, Rect2(), M, 0, 0))
	a.move_speed = 14.0
	a = _add(AttackData.new("OD", 8, 0, 44, 0, Rect2(), M, 0, 0))
	a.title = "BLACK HOLE"
	a.cost = Fighter.RC_COST
	a.invuln_frames = 10
	a.event_frame = 8


## 타입을 안 붙인 이유: 이미 지워진(freed) 투사체가 들어오면 타입 검사에서 오류가 나기 때문
func _alive(p) -> bool:
	return is_instance_valid(p) and not p.dead


func _on_attack_event(attack: AttackData) -> void:
	if attack.name == "OD":
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


func tick() -> void:
	super()
	# 중력장: 지속 시간 동안 상대를 내 쪽으로
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
	# 중력장: 바깥에서 안으로 줄어드는 고리
	if _in_attack("5D") and state_frame > current_attack.startup:
		var center := Vector2(90 * facing, -90)
		for i in 3:
			var t := fmod(state_frame * 0.05 + i / 3.0, 1.0)
			draw_arc(center, GRAVITY_RANGE * 0.5 * (1.0 - t), 0, TAU, 40, Color(PURPLE, 0.5 * t), 4.0)
	# 등속 운동: 뒤로 남는 잔상 줄
	if _in_attack("4D"):
		for i in 3:
			var x := -facing * (30 + i * 26)
			draw_line(Vector2(x, -150), Vector2(x, -10), Color(PURPLE, 0.5 - i * 0.15), 6.0)
	super()
