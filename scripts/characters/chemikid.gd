extends Fighter
## CHEMIKID (화학 동아리): 플라스크를 던지는 매드 사이언티스트. 느리지만 한 방이 세다
##
##   5D  플라스크 투척  포물선 투사체. 바닥에 깨지면 산성 웅덩이(밟으면 계속 조금씩 데미지, 하단)
##   6D  촉매 돌진      앞으로 빠르게 돌진하며 타격
##   2D  발열 반응      발밑에서 위로 폭발 (대공기, 시작할 때 무적)
##   4D  중화 반응      반격 자세. 이때 공격을 받으면 무효로 하고 받아친다
##   OD  연쇄 반응      (D+HS, 텐션 50%) 앞쪽으로 폭발이 연달아 터진다

const ACID_GREEN := Color("7dff6a")
const NEUTRAL_FLASH := Color(0.7, 1.0, 0.7, 0.25)

## 반격 자세에서 공격을 받아낼 수 있는 구간 (4D 시작 후 프레임)
const COUNTER_START := 4
const COUNTER_END := 26

## 연쇄 반응 폭발: [공격 시작 후 프레임, 캐릭터 앞 거리]
const CHAIN_BLASTS := [[8, 110], [14, 190], [20, 270], [26, 350], [32, 430]]

## 투사체/폭발이 맞았을 때의 효과 (기술 목록과 별개)
var _flask_hit := AttackData.new("flask", 0, 0, 0, 32, Rect2(), AttackData.Level.MID, 18, 12)
var _acid_hit := AttackData.new("acid", 0, 0, 0, 7, Rect2(), AttackData.Level.LOW, 10, 6)
var _blast_hit := AttackData.new("blast", 0, 0, 0, 18, Rect2(), AttackData.Level.MID, 26, 14)

var _flask: Projectile
var _puddle: Projectile
var _counter_text := 0  # "NEUTRALIZE!" 글자 남은 프레임


func _init() -> void:
	# 체력이 많고 느리다
	max_hp = 440
	walk_forward_speed = 3.6
	walk_back_speed = 2.9
	run_speed = 8.5


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
	a = _add(AttackData.new("4D", 4, 0, 30, 0, Rect2(), M, 0, 0))
	# 반격이 성공했을 때 바로 이어지는 공격 (빠르고 넓다)
	a = _add(AttackData.new("4D_counter", 3, 6, 18, 55, Rect2(0, -170, 150, 150), M, 28, 16))
	a.invuln_frames = 9
	a = _add(AttackData.new("OD", 6, 0, 44, 0, Rect2(), M, 0, 0))
	a.title = "CHAIN REACTION"
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
				p.color = ACID_GREEN
				p.position = Vector2(position.x + blast[1] * facing, ground_y - 85)
				p.lifetime = 12
				spawn(p)


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
