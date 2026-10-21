extends Fighter
## GLOBE (지구과학 동아리): 땅·바다·하늘·우주를 다루는 헤비급. 체력 최고, 느림, 한 방이 크다
##
##   5D  유성우       (천문) 하늘에서 별똥별 3개가 비스듬히 떨어진다
##   6D  지각 돌진    (지질) 한 대를 버티면서(아머) 돌진하는 어깨치기
##   2D  지진해일     (지질+해양) 바닥을 따라 파도가 밀려간다. 하단 + 공중은 안 맞음 → 점프로 피해야 함
##   4D  별자리 잇기  (천문) 별 3개 설치 → 다시 4D를 누르면 선으로 이어지며 공격
##   jD  낙뢰         (기상) 공중에서, 앞쪽에 번개가 내리꽂힌다
##   OD  태풍         (기상, D+HS, 텐션 50%) 상대를 끌어당기며 여러 번 때리는 소용돌이

const EARTH := Color("e08a3c")
const STAR_GOLD := Color("ffe48a")
const OCEAN := Color("3aa0ff")
const STORM := Color("b8c8ff")

## 별자리 별 위치 (캐릭터 발 기준, 오른쪽을 볼 때)
const STAR_OFFSETS := [Vector2(140, -230), Vector2(240, -300), Vector2(340, -210)]
## 유성우: [떨어질 거리(앞쪽), 떨어지기 시작하는 높이]
const METEORS := [[180.0, 520.0], [290.0, 640.0], [400.0, 760.0]]
const METEOR_VELOCITY := Vector2(6.0, 10.0)

## 투사체가 맞았을 때의 효과 (기술 목록과 별개)
var _meteor_hit := AttackData.new("meteor", 0, 0, 0, 22, Rect2(), AttackData.Level.MID, 18, 12)
var _wave_hit := AttackData.new("wave", 0, 0, 0, 40, Rect2(), AttackData.Level.LOW, 22, 14)
var _beam_hit := AttackData.new("constellation", 0, 0, 0, 24, Rect2(), AttackData.Level.MID, 22, 14)
var _bolt_hit := AttackData.new("bolt", 0, 0, 0, 35, Rect2(), AttackData.Level.MID, 20, 14)
var _typhoon_hit := AttackData.new("typhoon", 0, 0, 0, 9, Rect2(), AttackData.Level.MID, 22, 10)

var _meteors: Array = []
var _stars: Array = []
var _typhoon: Projectile


func _init() -> void:
	# 체력이 가장 많고 가장 느리다
	max_hp = 500
	walk_forward_speed = 3.2
	walk_back_speed = 2.6
	run_speed = 7.5
	double_jump_velocity = -12.0
	_typhoon_hit.hitstop = 2  # 여러 번 맞는 기술이라 멈춤을 짧게


func _build_specials() -> void:
	var M := AttackData.Level.MID
	#                                 이름  발생 지속 후딜 데미지 판정 범위                  단계 히트 가드
	var a := _add(AttackData.new("5D", 16, 0, 26, 0, Rect2(), M, 0, 0))
	a.event_frame = 16
	a = _add(AttackData.new("6D", 14, 14, 24, 60, Rect2(10, -150, 90, 120), M, 24, 18))
	a.move_speed = 9.0
	a.armor_hits = 1
	a.pushback = 12.0
	a = _add(AttackData.new("2D", 12, 0, 26, 0, Rect2(), M, 0, 0))
	a.event_frame = 12
	a = _add(AttackData.new("4D", 10, 0, 20, 0, Rect2(), M, 0, 0))
	a.event_frame = 10
	a = _add(AttackData.new("jD", 10, 0, 20, 0, Rect2(), M, 0, 0))
	a.event_frame = 10
	a = _add(AttackData.new("OD", 8, 0, 40, 0, Rect2(), M, 0, 0))
	a.title = "TYPHOON"
	a.cost = Fighter.RC_COST
	a.invuln_frames = 10
	a.event_frame = 8


## 타입을 안 붙인 이유: 이미 지워진(freed) 투사체가 들어오면 타입 검사에서 오류가 나기 때문
func _alive(p) -> bool:
	return is_instance_valid(p) and not p.dead


func _any_alive(list: Array) -> bool:
	return list.any(func(p): return _alive(p))


func _can_use_special(attack_name: String) -> bool:
	if attack_name == "5D":
		return not _any_alive(_meteors)  # 유성우는 다 떨어진 뒤에 다시
	return true


func _on_attack_event(attack: AttackData) -> void:
	match attack.name:
		"5D":
			_meteors.clear()
			for m in METEORS:
				var land_x: float = position.x + facing * m[0]
				var fall_frames: float = m[1] / METEOR_VELOCITY.y
				var p := _make("meteor", _meteor_hit, Vector2(28, 28), STAR_GOLD)
				p.position = Vector2(land_x - facing * METEOR_VELOCITY.x * fall_frames, ground_y - m[1])
				p.velocity = Vector2(METEOR_VELOCITY.x * facing, METEOR_VELOCITY.y)
				p.ground_y = ground_y - 10
				_meteors.append(p)
				spawn(p)
		"2D":
			var p := _make("wave", _wave_hit, Vector2(80, 70), OCEAN)
			p.position = Vector2(position.x + 70 * facing, ground_y - 35)
			p.velocity = Vector2(7.5 * facing, 0)
			p.lifetime = 75
			p.hits_airborne = false
			spawn(p)
		"4D":
			if _any_alive(_stars):
				_connect_stars()
			else:
				_place_stars()
		"jD":
			var p := _make("bolt", _bolt_hit, Vector2(44, ground_y), STORM)
			p.position = Vector2(position.x + 170 * facing, ground_y / 2)
			p.lifetime = 14
			spawn(p)
		"OD":
			var p := _make("typhoon", _typhoon_hit, Vector2(200, 300), STORM)
			p.position = Vector2(position.x + 180 * facing, ground_y - 150)
			p.velocity = Vector2(2.5 * facing, 0)
			p.lifetime = 100
			p.rehit_interval = 8
			_typhoon = p
			spawn(p)


func _make(kind: String, hit: AttackData, size: Vector2, color: Color) -> Projectile:
	var p := Projectile.new()
	p.kind = kind
	p.attack = hit
	p.size = size
	p.color = color
	return p


## 별자리 1단계: 별 3개를 띄워 둔다 (아직 공격은 안 함)
func _place_stars() -> void:
	_stars.clear()
	for off in STAR_OFFSETS:
		var p := _make("star", null, Vector2(30, 30), STAR_GOLD)
		p.position = position + Vector2(off.x * facing, off.y)
		p.lifetime = 480  # 8초 안에 이어야 한다
		_stars.append(p)
		spawn(p)


## 별자리 2단계: 별끼리 빛줄기로 잇는다 (이어진 선이 공격)
func _connect_stars() -> void:
	var alive := _stars.filter(func(p): return _alive(p))
	for i in alive.size() - 1:
		var a: Vector2 = alive[i].position
		var b: Vector2 = alive[i + 1].position
		var mid := (a + b) / 2
		var beam := _make("beam", _beam_hit, Vector2(absf(b.x - a.x) + 30, absf(b.y - a.y) + 40), STAR_GOLD)
		beam.position = mid
		beam.extra = { "a": a - mid, "b": b - mid }
		beam.lifetime = 16
		spawn(beam)
	for p in alive:
		p.dead = true
	_stars.clear()


func tick() -> void:
	super()
	# 태풍: 근처의 상대를 소용돌이 쪽으로 끌어당긴다
	if _alive(_typhoon):
		pull_opponent(_typhoon.position.x, 3.0, 450.0)
