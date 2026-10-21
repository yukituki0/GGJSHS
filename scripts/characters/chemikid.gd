extends Fighter
## CHEMIKID (화학 동아리): 플라스크를 던지는 매드 사이언티스트. 느리지만 한 방이 세다
##
##   5D  플라스크 투척  (산·염기) 포물선 투사체. 바닥에 깨지면 산성 웅덩이(밟으면 계속 조금씩 데미지, 하단)
##   6D  촉매 돌진      (반응 속도) 앞으로 빠르게 돌진하며 타격
##   2D  발열 반응      (열화학) 승룡권처럼 위로 솟구치는 대공기 (시작할 때 무적, 착지 빈틈 18F)
##   4D  중화 반응      (산·염기) 반격 자세. 이때 공격을 받으면 무효로 하고 받아친다
##   jD  앙금 생성      (침전 반응) 공중에서 앙금을 떨어뜨림 → 바닥에 굳어 상대 투사체를 막는 벽 (1개까지)
##   OD  테르밋 반응    (산화환원, D+HS, 텐션 50%) 앞쪽 연쇄 폭발 → 마지막에 초고온 불꽃 기둥

const ACID_GREEN := Color("7dff6a")
const THERMITE := Color("ff8a1e")
const SALT_WHITE := Color("eef4f6")
const NEUTRAL_FLASH := Color(0.7, 1.0, 0.7, 0.25)

## 반격 자세에서 공격을 받아낼 수 있는 구간 (4D 시작 후 프레임)
const COUNTER_START := 4
const COUNTER_END := 26

## 테르밋 폭발: [공격 시작 후 프레임, 캐릭터 앞 거리]. 마지막은 불꽃 기둥
const CHAIN_BLASTS := [[8, 110], [14, 190], [20, 270], [26, 350]]
const PILLAR := [38, 300]

## 투사체/폭발이 맞았을 때의 효과 (기술 목록과 별개)
var _flask_hit := AttackData.new("flask", 0, 0, 0, 32, Rect2(), AttackData.Level.MID, 18, 12)
var _acid_hit := AttackData.new("acid", 0, 0, 0, 7, Rect2(), AttackData.Level.LOW, 10, 6)
var _blast_hit := AttackData.new("blast", 0, 0, 0, 16, Rect2(), AttackData.Level.MID, 26, 14)
var _pillar_hit := AttackData.new("thermite", 0, 0, 0, 40, Rect2(), AttackData.Level.MID, 30, 16)
var _salt_hit := AttackData.new("precipitate", 0, 0, 0, 20, Rect2(), AttackData.Level.MID, 16, 12)

var _flask: Projectile
var _puddle: Projectile
var _salt_wall: Projectile
var _counter_text := 0  # "NEUTRALIZE!" 글자 남은 프레임


func _init() -> void:
	# 체력이 많고 느리다
	max_hp = 440
	walk_forward_speed = 3.6
	walk_back_speed = 2.9
	run_speed = 8.5
	_pillar_hit.launch = Vector2(4, -15)


func _build_specials() -> void:
	var M := AttackData.Level.MID
	#                                 이름  발생 지속 후딜 데미지 판정 범위                    단계 히트 가드
	var a := _add(AttackData.new("5D", 14, 0, 24, 0, Rect2(), M, 0, 0))
	a.event_frame = 14
	a = _add(AttackData.new("6D", 10, 12, 20, 45, Rect2(10, -140, 90, 90), M, 22, 16))
	a.move_speed = 12.0
	a.pushback = 10.0
	a = _add(AttackData.new("2D", 7, 6, 28, 50, Rect2(-10, -280, 120, 220), M, 24, 16))
	a.invuln_frames = 7
	a.rise = Vector2(2.5, -15.0)  # 승룡권처럼 솟구치는 대공 (약 125px, 공중 30프레임)
	a.landing_recovery = 18       # 착지 빈틈
	a = _add(AttackData.new("4D", 4, 0, 30, 0, Rect2(), M, 0, 0))
	# 반격이 성공했을 때 바로 이어지는 공격 (빠르고 넓다)
	a = _add(AttackData.new("4D_counter", 3, 6, 18, 55, Rect2(0, -170, 150, 150), M, 28, 16))
	a.invuln_frames = 9
	a = _add(AttackData.new("jD", 10, 0, 18, 0, Rect2(), M, 0, 0))
	a.event_frame = 10
	a = _add(AttackData.new("OD", 6, 0, 44, 0, Rect2(), M, 0, 0))
	a.title = "THERMITE"
	a.cost = Fighter.RC_COST
	a.invuln_frames = 10


## 타입을 안 붙인 이유: 이미 지워진(freed) 투사체가 들어오면 타입 검사에서 오류가 나기 때문
func _alive(p) -> bool:
	return is_instance_valid(p) and not p.dead


func _can_use_special(attack_name: String) -> bool:
	if attack_name == "5D":
		return not _alive(_flask)  # 플라스크는 화면에 하나만
	return true


func _on_attack_event(attack: AttackData) -> void:
	if attack.name == "jD":
		var s := Projectile.new()
		s.kind = "precipitate"
		s.attack = _salt_hit
		s.size = Vector2(34, 30)
		s.color = SALT_WHITE
		s.position = position + Vector2(70 * facing, -120)  # 손 높이에서 앞으로
		s.velocity = Vector2(5.0 * facing, 2.0)
		s.gravity = 0.7
		s.ground_y = ground_y - 10
		s.landed.connect(_on_salt_landed)
		spawn(s)
	if attack.name == "5D":
		var p := Projectile.new()
		p.kind = "flask"
		p.attack = _flask_hit
		p.size = Vector2(30, 34)
		p.color = ACID_GREEN
		p.position = position + Vector2(40 * facing, -150)
		p.velocity = Vector2(7.5 * facing, -11.0)
		p.gravity = 0.6
		p.ground_y = ground_y - 10
		p.landed.connect(_on_flask_landed)
		_flask = p
		spawn(p)


## 플라스크가 바닥에 깨지면 그 자리에 산성 웅덩이
func _on_flask_landed(pos: Vector2) -> void:
	if _alive(_puddle):
		_puddle.dead = true
	var p := Projectile.new()
	p.kind = "acid"
	p.attack = _acid_hit
	p.size = Vector2(170, 24)
	p.color = ACID_GREEN
	p.position = Vector2(pos.x, ground_y - 10)
	p.lifetime = 240
	p.hits_airborne = false
	p.rehit_interval = 30  # 0.5초마다 데미지
	_puddle = p
	spawn(p)


## 앙금이 바닥에 닿으면 그 자리에 굳은 벽 (상대 투사체를 막는다)
func _on_salt_landed(pos: Vector2) -> void:
	if _alive(_salt_wall):
		_salt_wall.dead = true
	var p := Projectile.new()
	p.kind = "saltwall"
	p.blocks_projectiles = true
	p.size = Vector2(60, 110)
	p.color = SALT_WHITE
	p.position = Vector2(pos.x, ground_y - 55)
	p.lifetime = 150
	_salt_wall = p
	spawn(p)


## 중화 반응: 반격 자세 중에 공격을 받으면 무효로 하고 받아친다
func _try_counter(_attack_data: AttackData) -> bool:
	if state != State.ATTACK or current_attack == null or current_attack.name != "4D":
		return false
	if state_frame < COUNTER_START or state_frame > COUNTER_END:
		return false
	_counter_text = 40
	rc_flash = 20
	screen_tint.emit(NEUTRAL_FLASH, 12)
	_start_attack("4D_counter")
	return true


func tick() -> void:
	super()
	if _counter_text > 0:
		_counter_text -= 1
	# 연쇄 반응: 정해진 프레임마다 앞쪽에 폭발
	if state == State.ATTACK and current_attack != null and current_attack.name == "OD":
		for blast in CHAIN_BLASTS:
			if state_frame == blast[0]:
				var p := Projectile.new()
				p.kind = "explosion"
				p.attack = _blast_hit
				p.size = Vector2(130, 170)
				p.color = THERMITE
				p.position = Vector2(position.x + blast[1] * facing, ground_y - 85)
				p.lifetime = 12
				p.rehit_interval = 999  # 맞혀도 바로 사라지지 않고 폭발이 끝까지 보이게
				spawn(p)
		if state_frame == PILLAR[0]:
			var pillar := Projectile.new()
			pillar.kind = "pillar"
			pillar.attack = _pillar_hit
			pillar.size = Vector2(150, 460)
			pillar.color = THERMITE
			pillar.position = Vector2(position.x + PILLAR[1] * facing, ground_y - 230)
			pillar.lifetime = 22
			pillar.rehit_interval = 999
			spawn(pillar)


func _draw() -> void:
	super()
	# 반격 자세 중: 몸 앞에 초록 방패 표시
	if state == State.ATTACK and current_attack != null and current_attack.name == "4D" \
			and state_frame >= COUNTER_START and state_frame <= COUNTER_END:
		var start := -PI / 2 if facing > 0 else PI / 2  # 바라보는 쪽 반원
		draw_arc(Vector2(facing * 30, -90), 70, start, start + PI, 16, Color(ACID_GREEN, 0.8), 5.0)
	if _counter_text > 0:
		draw_string(Game.FONT, Vector2(-120, -230), "NEUTRALIZE!", HORIZONTAL_ALIGNMENT_CENTER, 240, 30,
				Color(ACID_GREEN, _counter_text / 40.0))
