extends Fighter
## CHAOS (물리 동아리): 끌어당기고 잡아 던지는 잡기형. 가까이 붙어야 강하다
##
##   5D  만유인력      (역학) 잠깐 동안 상대를 내 쪽으로 끌어당긴다 (데미지 없음)
##   6D  운동량 던지기  (역학) 커맨드 잡기: 일반 잡기보다 사거리·데미지 2배. 5D로 끌어온 뒤 잡는 게 핵심. 빗나가면 빈틈 큼
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
	# 커맨드 잡기: 일반 잡기(사거리 90, 40 데미지, 후딜 22)보다 사거리 2배, 데미지 2배. 대신 빗나가면 빈틈이 크다
	a = _add(AttackData.new("6D", 6, 3, 40, 80, Rect2(10, -150, 170, 140), M, 30, 0))
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
			p.position = position + Vector2(100 * facing, -90)  # 손 높이에서 앞으로
			p.velocity = Vector2(7.0 * facing, 4.0)
			p.lifetime = 18
			p.extra = {"fx": "chaos_steam"}  # 증기 폭발 그림 (없으면 원래 원 모양)
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
			boom.extra = {"fx": "chaos_spark"}  # 블랙홀 붕괴: 번쩍이는 방전
			spawn(boom)


func _in_attack(attack_name: String) -> bool:
	return state == State.ATTACK and current_attack != null and current_attack.name == attack_name


## 운동량 던지기(→D): 뻗은 손에서 잡기 범위 끝까지 전기 줄기가 뻗어 상대를 붙잡는다
## (손보다 잡기 범위가 훨씬 길어서, 전기로 끌어당기는 것처럼 보이게)
const GRAB_BOLT_EXTRA := 60.0


func _draw_grab_bolt() -> void:
	if not _in_attack("6D") or state_frame < 2 or state_frame > current_attack.startup + current_attack.active + 10:
		return
	var a: AttackData = current_attack
	var hand := art_tip("6d", 0.55, 1.0)
	if hand == Vector2.INF:
		hand = Vector2(110, -130)
	hand.x = (hand.x - 40.0) * facing  # 손바닥 안쪽에서 시작 (손끝에서 시작하면 짧아 보임)
	var reach := minf(1.0, float(state_frame) / a.startup)
	var end_x := (a.hitbox.end.x + GRAB_BOLT_EXTRA) * facing  # 잡기 범위 끝보다 조금 더 (번개가 상대 쪽으로 쭉 뻗게)
	var end := Vector2(lerpf(hand.x, end_x, reach), hand.y + 10)
	if opponent != null and opponent.state == State.HITSTUN and attack_connected:
		end = opponent.position - position + Vector2(0, -opponent.body_size().y * 0.6)  # 잡혔으면 상대 몸에
	var fade := clampf(1.0 - float(state_frame - a.startup - a.active) / 10.0, 0.0, 1.0)
	for layer in 2:  # 바깥 보라 + 안쪽 흰 번개
		var pts := PackedVector2Array([hand])
		var steps := 7
		for i in range(1, steps):
			var p := hand.lerp(end, float(i) / steps)
			p.y += sin(state_frame * 2.3 + i * 1.9 + layer) * 14.0
			pts.append(p)
		pts.append(end)
		var col := Color(PURPLE.lightened(0.2), 0.8 * fade) if layer == 0 else Color(1, 1, 1, 0.9 * fade)
		draw_polyline(pts, col, 7.0 if layer == 0 else 2.5)
	draw_circle(end, 14.0 + 4.0 * sin(state_frame * 1.5), Color(PURPLE.lightened(0.4), 0.6 * fade))


func _draw() -> void:
	_draw_grab_bolt()
	# 만유인력: 바깥에서 안으로 줄어드는 고리
	if _in_attack("5D"):
		var center := Vector2(90 * facing, -110)  # 앞으로 뻗은 손
		var grav := Game.load_texture("res://assets/effects/chaos_gravity.png")
		if grav != null:  # 손에 감기는 중력 소용돌이: 모였다가 끌어당기는 동안 빙글빙글
			var grow := minf(1.0, state_frame / float(current_attack.startup))
			var px := 150.0 * grow * (1.0 + 0.08 * sin(state_frame * 0.6))
			var sz := Vector2(grav.get_width(), grav.get_height()) * (px / maxf(grav.get_width(), grav.get_height()))
			draw_set_transform(center, -state_frame * 0.25 * facing, Vector2.ONE)
			draw_texture_rect(grav, Rect2(-sz / 2, sz), false)
			draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
	if _in_attack("5D") and state_frame > current_attack.startup:
		var center := Vector2(90 * facing, -110)
		for i in 3:
			var t := fmod(state_frame * 0.05 + i / 3.0, 1.0)
			draw_arc(center, GRAVITY_RANGE * 0.5 * (1.0 - t), 0, TAU, 40, Color(PURPLE, 0.5 * t), 4.0)
	# 전자기 펄스: 주변에 퍼지는 번개 고리
	if _in_attack("2D") and current_attack.is_active(state_frame):
		var spark := Game.load_texture("res://assets/effects/chaos_spark.png")
		if spark != null:
			# 몸 주위 방전 구체: 지직거리게 돌리고 크기를 흔든다
			var px := 320.0 * (0.9 + 0.1 * sin(state_frame * 1.7))
			var sz := Vector2(spark.get_width(), spark.get_height()) * (px / spark.get_width())
			draw_set_transform(Vector2(0, -100), state_frame * 0.5, Vector2.ONE)
			draw_texture_rect(spark, Rect2(-sz / 2, sz), false, Color(1, 1, 1, 0.85))
			draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
		for i in 8:
			var ang := i * TAU / 8 + state_frame * 0.4
			var from := Vector2(0, -100) + Vector2(40, 0).rotated(ang)
			var to := Vector2(0, -100) + Vector2(150, 0).rotated(ang + 0.2)
			draw_line(from, to, Color(1, 0.95, 0.3, 0.9), 3.0)
	# 양자 터널링: 사라진 자리에 흐릿한 잔상 + 확률 구름
	if _ghost_frames > 0:
		var a := _ghost_frames / 20.0
		var size := body_size()
		if not draw_ghost(_ghost_pos, Color(0.75, 0.45, 1.0, 0.45 * a)):  # 사라진 자리에 보랏빛 내 모습
			draw_rect(Rect2(_ghost_pos - position + Vector2(-size.x / 2, -size.y), size), Color(PURPLE, 0.35 * a))
		for i in 6:
			draw_circle(_ghost_pos - position + Vector2(sin(i * 2.1) * 40, -size.y * 0.5 + cos(i * 1.7) * 60),
					10, Color(PURPLE, 0.3 * a))
	super()
