extends Fighter
## ROOT2 (수학 동아리): 멀리서 견제하는 원거리형. 체력은 낮고 빠르다
##
##   5D  √2 부메랑     (대수) 앞으로 날아갔다가 되돌아오는 투사체. 갈 때/올 때 한 번씩 맞힐 수 있다 (1개까지)
##   6D  컴퍼스 찌르기  (기하) 리치가 아주 긴 찌르기
##   2D  적분 기둥     (미적분) 상대 발밑에 좌표를 찍으면 잠시 뒤 ∫ 기둥이 솟는다 (1개까지)
##   4D  확률 주사위   (확률) 주사위를 던진다. 데미지 = 나온 눈 x 9
##   jD  피보나치 낙하  (수열) 1, 1, 2, 3, 5가 앞쪽에 차례로 떨어진다
##   OD  랜덤 증명     (증명, D+HS, 텐션 50%) 아래 셋 중 하나가 무작위로 나가고, 충분히 맞히면(PROOF_NEED) Q.E.D. 도장
##       - 대수의 증명: 거대 √2 부메랑 (갈 때/올 때 맞힘)
##       - 미적분의 증명: 상대를 따라가며 적분 기둥 3개가 차례로
##       - 확률의 증명: 주사위 6개를 부채꼴로 (각 데미지 = 눈 x 3)

const GOLD_MATH := Color("ffe14a")
const EFFECT_ALPHA := 0.7        # 이펙트 그림이 크고 진해서 캐릭터를 가리니까 살짝 투명하게 (글자는 그대로)

const BOOMERANG_SPEED := 14.0
const BOOMERANG_ACCEL := 0.32    # 되돌아오게 만드는 가속도
const FIBONACCI := [1, 1, 2, 3, 5]
const FIB_JITTER_X := 14.0      # 피보나치 숫자가 떨어지는 자리 흔들림 (좌우)
const FIB_JITTER_Y := 60.0      # 시작 높이 흔들림 (높을수록 늦게 떨어짐)
# 랜덤 증명: [종류, 화면에 띄울 이름]. 기대 데미지는 셋 다 도장 포함 90 정도 (예전 Q.E.D.와 비슷)
const PROOFS := [["algebra", "ALGEBRA!"], ["calculus", "CALCULUS!"], ["probability", "PROBABILITY!"]]
const PROOF_DICE := 6
## 증명이 "완성"되려면 맞아야 하는 횟수 (막히면 안 셈). 채우는 순간 Q.E.D. 도장이 찍힌다
## 대수: 부메랑 갈 때+올 때 2번 중 2 / 미적분: 기둥 3개 중 2 / 확률: 주사위 6개 중 3
const PROOF_NEED := {"algebra": 2, "calculus": 2, "probability": 3}
const PROOF_TIME := 150         # 이 프레임 안에 채워야 한다 (부메랑이 돌아오는 시간 포함)
const PROOF_HITS := ["sqrt2_max", "integral_od", "integral_od_side", "dice_od"]
const PROOF_PILLAR_DELAY := [14, 28]  # 미적분: 추가 기둥 2개가 나오는 시점 (증명 시작 후 프레임)

var _boomerang_hit := AttackData.new("sqrt2", 0, 0, 0, 24, Rect2(), AttackData.Level.MID, 16, 12)
var _integral_hit := AttackData.new("integral", 0, 0, 0, 45, Rect2(), AttackData.Level.MID, 26, 14)
var _fib_hit := AttackData.new("fibonacci", 0, 0, 0, 8, Rect2(), AttackData.Level.OVERHEAD, 12, 8)
var _big_boomerang_hit := AttackData.new("sqrt2_max", 0, 0, 0, 30, Rect2(), AttackData.Level.MID, 22, 14)
var _proof_pillar_hit := AttackData.new("integral_od", 0, 0, 0, 45, Rect2(), AttackData.Level.MID, 26, 14)
var _side_pillar_hit := AttackData.new("integral_od_side", 0, 0, 0, 12, Rect2(), AttackData.Level.MID, 22, 12)
var _qed_hit := AttackData.new("qed", 0, 0, 0, 30, Rect2(), AttackData.Level.MID, 30, 14)

var _boomerang: Projectile
var _boomerang_dir := 1
var _integral: Projectile
var _proof_hits := 0            # 이번 증명에서 맞힌 횟수
var _proof_need := 0
var _proof_frames := 0          # 남은 시간 (0이면 증명 중 아님)
var _pillar_queue: Array = []   # 미적분 증명: 아직 안 나온 추가 기둥들의 시점
var _proof_age := 0


func _init() -> void:
	_big_boomerang_hit.guard_gain = OD_GUARD_GAIN  # 궁극기: 막으면 깎이기만 하고 가드 크러시는 안 나게
	_proof_pillar_hit.guard_gain = OD_GUARD_GAIN  # 궁극기: 막으면 깎이기만 하고 가드 크러시는 안 나게
	_side_pillar_hit.guard_gain = OD_GUARD_GAIN  # 궁극기: 막으면 깎이기만 하고 가드 크러시는 안 나게
	_qed_hit.guard_gain = OD_GUARD_GAIN  # 궁극기: 막으면 깎이기만 하고 가드 크러시는 안 나게
	# 체력이 가장 낮고 빠르다
	max_hp = 400
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


## 모든 투사체/이펙트는 여기를 지나간다: 글자가 아닌 그림만 투명도를 낮춘다
func spawn(projectile: Projectile) -> void:
	if projectile.kind != "text":
		projectile.self_modulate.a = EFFECT_ALPHA
	super(projectile)


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
				p.extra.merge({"bg": "root2_number", "bg_size": 62.0, "bg_offset": Vector2(0, -7)})  # 금색 블록 위에 숫자
				var jitter := Vector2(randf_range(-FIB_JITTER_X, FIB_JITTER_X), -randf_range(0.0, FIB_JITTER_Y))
				p.position = position + Vector2((60 + dist) * facing, -120 - i * 30) + jitter  # 손 높이부터 앞쪽에
				p.velocity = Vector2(0, 11)
				p.ground_y = ground_y - 10
				spawn(p)
		"OD":
			_random_proof()


## 랜덤 증명: 세 가지 중 하나를 고르고, 고른 이름을 상대 머리 위에 띄운다 (도장은 충분히 맞혔을 때만)
func _random_proof() -> void:
	var proof: Array = PROOFS.pick_random()
	var circle := Projectile.new()  # 증명 이름 뒤에 금색 수식 마법진 (판정 없음)
	circle.kind = "sprite"
	circle.extra = {"fx": "root2_qed_circle", "px": 300.0, "spin": 0.01}
	circle.position = Vector2(_target_x(), ground_y - 270)
	circle.lifetime = 40
	spawn(circle)
	var label := _text(proof[1], null, 40)
	label.position = Vector2(_target_x(), ground_y - 270)
	label.lifetime = 40
	spawn(label)
	_proof_hits = 0
	_proof_need = PROOF_NEED[proof[0]]
	_proof_frames = PROOF_TIME
	_proof_age = 0
	_pillar_queue = []
	match proof[0]:
		"algebra":
			_spawn_boomerang(_big_boomerang_hit, 2.4)
		"calculus":
			# 첫 기둥은 상대 발밑, 나머지 둘은 PROOF_PILLAR_DELAY마다 그때 상대가 있는 자리에 (따라가며 적분)
			_spawn_pillar(_target_x(), _proof_pillar_hit, 12)
			_pillar_queue = PROOF_PILLAR_DELAY.duplicate()
		"probability":
			for i in PROOF_DICE:
				_spawn_dice(3, Vector2(randf_range(5.0, 11.0), randf_range(-13.0, -6.0)), "dice_od")


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
func _spawn_dice(per_pip: int, vel: Vector2, hit_name := "dice") -> void:
	var roll := randi_range(1, 6)
	var hit := AttackData.new(hit_name, 0, 0, 0, roll * per_pip, Rect2(), AttackData.Level.MID, 12 + roll * 2, 12)
	if hit_name == "dice_od":
		hit.guard_gain = OD_GUARD_GAIN
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
	_proof_age += 1
	if _proof_frames > 0:
		_proof_frames -= 1
	if not _pillar_queue.is_empty() and _proof_age >= _pillar_queue[0]:
		_pillar_queue.pop_front()
		_spawn_pillar(_target_x(), _side_pillar_hit, 8)


## 증명 기술이 맞을 때마다 세고, 정해진 횟수를 채우는 순간 도장 (못 채우면 도장 없음)
func _on_attack_result(attack: AttackData, blocked: bool) -> void:
	if _proof_frames <= 0 or blocked or not attack.name in PROOF_HITS:
		return
	_proof_hits += 1
	if _proof_hits == _proof_need:
		_proof_frames = 0
		_stamp_qed()


## Q.E.D. 도장: 상대 위에 쾅
func _stamp_qed() -> void:
	var p := _text("Q.E.D.", _qed_hit, 60, Style.RED)
	p.extra.merge({"bg": "root2_qed_seal", "bg_size": 250.0, "text_color": Style.RED})  # 금색 도장 위에 글자
	p.size = Vector2(260, 120)
	p.position = (opponent.position if opponent != null else position) + Vector2(0, -110)
	p.lifetime = 24
	p.rehit_interval = 999  # 맞혀도 바로 사라지지 않고 도장이 보이게
	spawn(p)


func _draw() -> void:
	# 컴퍼스 찌르기: 몸에서 뻗어 나가는 컴퍼스 다리
	if state == State.ATTACK and current_attack != null and current_attack.name == "6D" \
			and current_attack.is_active(state_frame) \
			and not draw_fx_span("root2_thrust", Vector2(20 * facing, -115), Vector2(320 * facing, -115), 70.0):
		draw_line(Vector2(20 * facing, -115), Vector2(310 * facing, -115), Color(0.85, 0.85, 0.9), 6.0)
		draw_line(Vector2(20 * facing, -115), Vector2(275 * facing, -80), Color(0.85, 0.85, 0.9), 4.0)
	super()
