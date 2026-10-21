extends Fighter
## ROOT2 (수학 동아리): 멀리서 견제하는 원거리형. 체력은 낮고 빠르다
##
##   5D  √2 부메랑     (대수) 앞으로 날아갔다가 되돌아오는 투사체. 갈 때/올 때 한 번씩 맞힐 수 있다 (1개까지)
##   6D  컴퍼스 찌르기  (기하) 리치가 아주 긴 찌르기
##   2D  적분 기둥     (미적분) 상대 발밑에 좌표를 찍으면 잠시 뒤 ∫ 기둥이 솟는다 (1개까지)
##   4D  확률 주사위   (확률) 주사위를 던진다. 데미지 = 나온 눈 x 9
##   jD  피보나치 낙하  (수열) 1, 1, 2, 3, 5가 앞쪽에 차례로 떨어진다
##   OD  랜덤 증명     (증명, D+HS, 텐션 50%) 아래 셋 중 하나가 무작위로 나가고, 마지막에 Q.E.D. 도장
##       - 대수의 증명: 거대 √2 부메랑 (갈 때/올 때 맞힘)
##       - 미적분의 증명: 상대 자리 + 양옆에 적분 기둥 3개
##       - 확률의 증명: 주사위 6개를 부채꼴로 (각 데미지 = 눈 x 3)

const GOLD_MATH := Color("ffe14a")

const BOOMERANG_SPEED := 14.0
const BOOMERANG_ACCEL := 0.32    # 되돌아오게 만드는 가속도
const FIBONACCI := [1, 1, 2, 3, 5]
const FIB_JITTER_X := 14.0      # 피보나치 숫자가 떨어지는 자리 흔들림 (좌우)
const FIB_JITTER_Y := 60.0      # 시작 높이 흔들림 (높을수록 늦게 떨어짐)
# 랜덤 증명: [종류, 화면에 띄울 이름]. 기대 데미지는 셋 다 도장 포함 90 정도 (예전 Q.E.D.와 비슷)
const PROOFS := [["algebra", "ALGEBRA!"], ["calculus", "CALCULUS!"], ["probability", "PROBABILITY!"]]
const PROOF_DICE := 6
const PROOF_PILLAR_GAP := 130.0  # 양옆 적분 기둥 간격

var _boomerang_hit := AttackData.new("sqrt2", 0, 0, 0, 24, Rect2(), AttackData.Level.MID, 16, 12)
var _integral_hit := AttackData.new("integral", 0, 0, 0, 45, Rect2(), AttackData.Level.MID, 26, 14)
var _fib_hit := AttackData.new("fibonacci", 0, 0, 0, 8, Rect2(), AttackData.Level.OVERHEAD, 12, 8)
var _big_boomerang_hit := AttackData.new("sqrt2_max", 0, 0, 0, 30, Rect2(), AttackData.Level.MID, 22, 14)
var _proof_pillar_hit := AttackData.new("integral_od", 0, 0, 0, 45, Rect2(), AttackData.Level.MID, 26, 14)
var _side_pillar_hit := AttackData.new("integral_od_side", 0, 0, 0, 25, Rect2(), AttackData.Level.MID, 22, 12)
var _qed_hit := AttackData.new("qed", 0, 0, 0, 30, Rect2(), AttackData.Level.MID, 30, 14)

var _boomerang: Projectile
var _boomerang_dir := 1
var _integral: Projectile


func _init() -> void:
	# 체력이 가장 낮고 빠르다
	max_hp = 360
	walk_forward_speed = 4.4
	walk_back_speed = 3.6
	run_speed = 10.0
	_fib_hit.hitstop = 3
	_integral_hit.launch = Vector2(2, -12)
	_proof_pillar_hit.launch = Vector2(2, -12)
	_side_pillar_hit.launch = Vector2(2, -10)
	_qed_hit.launch = Vector2(8, -10)


func _build_specials() -> void:
	var M := AttackData.Level.MID
	#                                 이름  발생 지속 후딜 데미지 판정 범위                  단계 히트 가드
	var a := _add(AttackData.new("5D", 12, 0, 22, 0, Rect2(), M, 0, 0))
	a.event_frame = 12
	a = _add(AttackData.new("6D", 11, 4, 20, 40, Rect2(20, -130, 290, 30), M, 18, 14))  # 5H(컴퍼스 끝)보다 길게
	a = _add(AttackData.new("2D", 14, 0, 22, 0, Rect2(), M, 0, 0))
	a.event_frame = 14
	a = _add(AttackData.new("4D", 12, 0, 22, 0, Rect2(), M, 0, 0))
	a.event_frame = 12
	a = _add(AttackData.new("jD", 8, 0, 16, 0, Rect2(), M, 0, 0))
	a.event_frame = 8
	a = _add(AttackData.new("OD", 8, 0, 46, 0, Rect2(), M, 0, 0))
	a.title = "Q.E.D."
	a.cost = Fighter.RC_COST
	a.invuln_frames = 10
	a.event_frame = 8


## 타입을 안 붙인 이유: 이미 지워진(freed) 투사체가 들어오면 타입 검사에서 오류가 나기 때문
func _alive(p) -> bool:
	return is_instance_valid(p) and not p.dead


func _can_use_special(attack_name: String) -> bool:
	match attack_name:
		"5D":
			return not _alive(_boomerang)
		"2D":
			return not _alive(_integral)
	return true


func _text(text: String, hit: AttackData, size: int, color := GOLD_MATH) -> Projectile:
	var p := Projectile.new()
	p.kind = "text"
	p.attack = hit
	p.extra = { "text": text, "size": size }
	p.size = Vector2(size * 0.8, size * 0.9)
	p.color = color
	return p


func _on_attack_event(attack: AttackData) -> void:
	match attack.name:
		"5D":
			_spawn_boomerang(_boomerang_hit, 1.0)
		"2D":
			# 상대 발밑에 좌표 지정 → arm_frames 뒤에 기둥이 솟는다
			_integral = _spawn_pillar(_target_x(), _integral_hit, 30)
		"4D":
			# 주사위: 던질 때마다 눈이 정해지고, 데미지 = 눈 x 9
			_spawn_dice(9, Vector2(8.0, -9.0))
		"jD":
			# 피보나치: 떨어지는 자리는 점점 멀리 (1, 1, 2, 3, 5 간격) 그대로, 어느 자리에 어떤 숫자가 올지는 섞고
			# 위치·높이를 조금씩 흔들어서 쓸 때마다 모양이 달라진다 (높이가 다르면 떨어지는 순서도 바뀜)
			var numbers := FIBONACCI.duplicate()
			numbers.shuffle()
			var dist := 0.0
			for i in FIBONACCI.size():
				dist += FIBONACCI[i] * 26.0
				var p := _text(str(numbers[i]), _fib_hit, 34)
				var jitter := Vector2(randf_range(-FIB_JITTER_X, FIB_JITTER_X), -randf_range(0.0, FIB_JITTER_Y))
				p.position = position + Vector2((30 + dist) * facing, -20 - i * 30) + jitter
				p.velocity = Vector2(0, 11)
				p.ground_y = ground_y - 10
				spawn(p)
		"OD":
			_random_proof()


## 랜덤 증명: 세 가지 중 하나를 고르고, 고른 이름을 상대 머리 위에 띄운다 (도장은 tick()에서)
func _random_proof() -> void:
	var proof: Array = PROOFS.pick_random()
	var label := _text(proof[1], null, 40)
	label.position = Vector2(_target_x(), ground_y - 270)
	label.lifetime = 40
	spawn(label)
	match proof[0]:
		"algebra":
			_spawn_boomerang(_big_boomerang_hit, 2.4)
		"calculus":
			var cx := _target_x()
			_spawn_pillar(cx, _proof_pillar_hit, 12)
			for side in [-1, 1]:
				_spawn_pillar(cx + side * PROOF_PILLAR_GAP, _side_pillar_hit, 20)
		"probability":
			for i in PROOF_DICE:
				_spawn_dice(3, Vector2(randf_range(5.0, 11.0), randf_range(-13.0, -6.0)))


## 상대 발밑 x (상대가 없으면 앞쪽)
func _target_x() -> float:
	return opponent.position.x if opponent != null else position.x + 250 * facing


## 부메랑 (scale: 크기 배율). 돌아오면 내 몸에 닿아 사라진다
func _spawn_boomerang(hit: AttackData, scale_k: float) -> void:
	var p := Projectile.new()
	p.kind = "boomerang"
	p.attack = hit
	p.size = Vector2(50, 40) * scale_k
	p.color = GOLD_MATH
	p.position = position + Vector2(50 * facing, -110)
	p.velocity = Vector2(BOOMERANG_SPEED * facing, 0)
	p.accel = Vector2(-BOOMERANG_ACCEL * facing, 0)
	p.lifetime = 120
	p.rehit_interval = 40  # 갈 때 한 번, 돌아올 때 한 번
	_boomerang = p
	_boomerang_dir = facing
	spawn(p)


## 적분 기둥: x 자리에 좌표를 찍고 arm 프레임 뒤에 솟는다
func _spawn_pillar(x: float, hit: AttackData, arm: int) -> Projectile:
	var p := Projectile.new()
	p.kind = "integral"
	p.attack = hit
	p.size = Vector2(70, 260)
	p.color = GOLD_MATH
	p.position = Vector2(x, ground_y - 130)
	p.arm_frames = arm
	p.lifetime = arm + 22
	p.rehit_interval = 999  # 맞혀도 바로 사라지지 않고 끝까지 솟아 있게 (다시 맞히지는 않음)
	spawn(p)
	return p


## 주사위: 던질 때마다 눈이 정해지고, 데미지 = 눈 x per_pip. vel은 앞쪽 기준
func _spawn_dice(per_pip: int, vel: Vector2) -> void:
	var roll := randi_range(1, 6)
	var hit := AttackData.new("dice", 0, 0, 0, roll * per_pip, Rect2(), AttackData.Level.MID, 12 + roll * 2, 12)
	var p := Projectile.new()
	p.kind = "dice"
	p.attack = hit
	p.extra = { "n": roll }
	p.size = Vector2(36, 36)
	p.position = position + Vector2(40 * facing, -120)
	p.velocity = Vector2(vel.x * facing, vel.y)
	p.gravity = 0.55
	p.ground_y = ground_y - 18
	spawn(p)


func tick() -> void:
	super()
	# 부메랑이 돌아와서 내 몸에 닿으면 사라진다
	if _alive(_boomerang) and signf(_boomerang.velocity.x) != _boomerang_dir \
			and absf(_boomerang.position.x - position.x) < 40:
		_boomerang.dead = true
	# Q.E.D. 마지막 도장
	if state == State.ATTACK and current_attack != null and current_attack.name == "OD" and state_frame == 44:
		var p := _text("Q.E.D.", _qed_hit, 90, Style.RED)
		p.size = Vector2(260, 120)
		p.position = (opponent.position if opponent != null else position) + Vector2(0, -110)
		p.lifetime = 24
		p.rehit_interval = 999  # 맞혀도 바로 사라지지 않고 도장이 보이게
		spawn(p)


func _draw() -> void:
	# 컴퍼스 찌르기: 몸에서 뻗어 나가는 컴퍼스 다리
	if state == State.ATTACK and current_attack != null and current_attack.name == "6D" \
			and current_attack.is_active(state_frame):
		draw_line(Vector2(20 * facing, -115), Vector2(310 * facing, -115), Color(0.85, 0.85, 0.9), 6.0)
		draw_line(Vector2(20 * facing, -115), Vector2(275 * facing, -80), Color(0.85, 0.85, 0.9), 4.0)
	super()
