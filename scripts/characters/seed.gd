extends Fighter
## SEED (생명 동아리): 심고, 나누고, 진화하는 설치·변칙형
##
##   5D  씨앗 심기     (생태) 앞 바닥에 씨앗 → 잠시 뒤 덩굴이 솟아 상대를 띄운다 (1개까지)
##   6D  덩굴 채찍     (식물) 리치가 긴 채찍
##   2D  세포분열      (세포) 분신이 앞으로 걸어가며 부딪히면 공격 (1개까지)
##   4D  광합성        (식물) 1초 동안 가만히 서서 체력 회복 (맞으면 끊김)
##   jD  DNA 이중나선  (유전) 나선이 아래 대각선으로 내려가며 여러 번 때린다
##   OD  진화          (진화, D+HS, 텐션 50%) 6초 동안 공격력 x1.3, 이동 속도 x1.25

const LEAF := Color("ff7ab8")      # 캐릭터 색 (꽃분홍)
const VINE_GREEN := Color("5cc85a")
const DNA_PINK := Color("ff6fae")

const SEED_GROW_FRAMES := 40       # 씨앗이 덩굴이 되기까지
const SEED_DISTANCE := 230.0       # 5D 씨앗을 심는 거리 (자라난 덩굴이 몸과 안 겹치게)
const WHIP_LINGER := 8.0          # 판정이 끝난 뒤에도 채찍이 흐려지며 남는 프레임 (눈에 보이게)
const WHIP_START := 90.0           # 6D 덩굴 채찍이 시작하는 곳 (몸 가운데에서 앞으로, 손 근처)
const PHOTOSYNTHESIS_HEAL := 0.6   # 광합성 프레임당 회복량
const EVOLVE_FRAMES := 360         # 진화 지속 (6초)
const EVOLVE_DAMAGE := 1.3
const EVOLVE_SPEED := 1.25

var _vine_hit := AttackData.new("vine", 0, 0, 0, 40, Rect2(), AttackData.Level.MID, 24, 14)
var _clone_hit := AttackData.new("cell", 0, 0, 0, 30, Rect2(), AttackData.Level.MID, 20, 14)
var _helix_hit := AttackData.new("dna", 0, 0, 0, 12, Rect2(), AttackData.Level.OVERHEAD, 16, 10)

var _seed: Projectile
var _clone: Projectile
var _heal_acc := 0.0
var _evolve_frames := 0
var _base_speed := {}


func _init() -> void:
	max_hp = 420
	_vine_hit.launch = Vector2(1, -12)
	_helix_hit.hitstop = 3


func _build_specials() -> void:
	var M := AttackData.Level.MID
	#                                 이름  발생 지속 후딜 데미지 판정 범위                  단계 히트 가드
	var a := _add(AttackData.new("5D", 12, 0, 20, 0, Rect2(), M, 0, 0))
	a.event_frame = 12
	a = _add(AttackData.new("6D", 12, 8, 19, 38, Rect2(60, -115, 230, 40), M, 18, 14))  # 몸 앞에서부터 (6D 그림이 앞으로 뻗은 자세라 몸과 안 겹치게)
	a = _add(AttackData.new("2D", 10, 0, 22, 0, Rect2(), M, 0, 0))
	a.event_frame = 10
	a = _add(AttackData.new("4D", 4, 60, 10, 0, Rect2(), M, 0, 0))
	a = _add(AttackData.new("jD", 8, 0, 16, 0, Rect2(), M, 0, 0))
	a.event_frame = 8
	a = _add(AttackData.new("OD", 10, 0, 30, 0, Rect2(), M, 0, 0))
	a.title = "EVOLUTION"
	a.cost = Fighter.RC_COST
	a.invuln_frames = 10
	a.event_frame = 10


## 타입을 안 붙인 이유: 이미 지워진(freed) 투사체가 들어오면 타입 검사에서 오류가 나기 때문
func _alive(p) -> bool:
	return is_instance_valid(p) and not p.dead


func _can_use_special(attack_name: String) -> bool:
	match attack_name:
		"5D":
			return not _alive(_seed)
		"2D":
			return not _alive(_clone)
	return true


func _on_attack_event(attack: AttackData) -> void:
	match attack.name:
		"5D":
			var p := Projectile.new()
			p.kind = "seed"
			p.size = Vector2(20, 20)
			p.color = VINE_GREEN
			p.position = Vector2(position.x + SEED_DISTANCE * facing, ground_y - 8)
			p.lifetime = SEED_GROW_FRAMES
			_seed = p
			spawn(p)
		"2D":
			var p := Projectile.new()
			p.kind = "clone"
			p.attack = _clone_hit
			p.size = Vector2(60, 150)
			p.color = LEAF
			p.position = Vector2(position.x + 50 * facing, ground_y - 75)
			p.velocity = Vector2(5.0 * facing, 0)
			p.lifetime = 60
			_clone = p
			spawn(p)
		"jD":
			var p := Projectile.new()
			p.kind = "helix"
			p.attack = _helix_hit
			p.size = Vector2(60, 70)
			p.color = DNA_PINK
			p.position = position + Vector2(80 * facing, -110)  # 손 높이에서 앞으로 (발밑 말고)
			p.velocity = Vector2(9.0 * facing, 4.5)
			p.lifetime = 30
			p.rehit_interval = 8
			spawn(p)
		"OD":
			_start_evolution()
			var bloom := Projectile.new()  # 진화: 몸에서 꽃잎이 터져 나옴 (판정 없음)
			bloom.kind = "sprite"
			bloom.extra = {"fx": "seed_leaf", "px": 340.0, "spin": 0.02}
			bloom.position = position + Vector2(0, -body_size().y * 0.55)
			bloom.lifetime = 40
			spawn(bloom)


func _start_evolution() -> void:
	if _evolve_frames == 0:
		_base_speed = { "walk": walk_forward_speed, "back": walk_back_speed, "run": run_speed }
	_evolve_frames = EVOLVE_FRAMES
	damage_mult = EVOLVE_DAMAGE
	walk_forward_speed = _base_speed["walk"] * EVOLVE_SPEED
	walk_back_speed = _base_speed["back"] * EVOLVE_SPEED
	run_speed = _base_speed["run"] * EVOLVE_SPEED


func _end_evolution() -> void:
	damage_mult = 1.0
	walk_forward_speed = _base_speed["walk"]
	walk_back_speed = _base_speed["back"]
	run_speed = _base_speed["run"]


func reset_for_round(x: float) -> void:
	if _evolve_frames > 0:
		_evolve_frames = 0
		_end_evolution()
	super(x)


func tick() -> void:
	super()
	# 씨앗이 다 자라면 그 자리에서 덩굴이 솟는다
	if _alive(_seed) and _seed.age >= SEED_GROW_FRAMES - 1:
		var v := Projectile.new()
		v.kind = "vine"
		v.attack = _vine_hit
		v.size = Vector2(60, 220)
		v.color = VINE_GREEN
		v.position = Vector2(_seed.position.x, ground_y - 110)
		v.lifetime = 30
		v.rehit_interval = 999  # 맞혀도 바로 사라지지 않고 덩굴이 끝까지 보이게
		_seed.dead = true
		spawn(v)
	# 광합성: 지속 시간 동안 체력 회복 (소수점은 모아서)
	if state == State.ATTACK and current_attack != null and current_attack.name == "4D" \
			and current_attack.is_active(state_frame):
		_heal_acc += PHOTOSYNTHESIS_HEAL
		var whole := int(_heal_acc)
		if whole > 0:
			hp = mini(max_hp, hp + whole)
			_heal_acc -= whole
	# 진화 시간 끝
	if _evolve_frames > 0:
		_evolve_frames -= 1
		if _evolve_frames == 0:
			_end_evolution()


func _draw() -> void:
	var size := body_size()
	# 진화 중: 몸 주위로 올라가는 분홍빛
	if _evolve_frames > 0 and not draw_fx("seed_aura", Vector2(0, -size.y * 0.72), size.y * 1.75, 0.0,
			0.6 + 0.2 * sin(_evolve_frames * 0.15)):
		for i in 5:
			var t := fmod(_evolve_frames * 0.02 + i * 0.2, 1.0)
			draw_circle(Vector2(sin(i * 2.4) * size.x * 0.6, -size.y * t), 6, Color(LEAF, 1.0 - t))
		draw_rect(Rect2(-size.x / 2 - 6, -size.y - 6, size.x + 12, size.y + 12), Color(LEAF, 0.5), false, 3.0)
	# 광합성 중: 위에서 내려오는 햇빛
	if state == State.ATTACK and current_attack != null and current_attack.name == "4D":
		var sun := Game.load_texture("res://assets/effects/seed_sunlight.png")
		if sun != null:  # 머리 위에서 쏟아지는 햇빛 기둥 (몸이 그 안에 들어가게)
			var w := 240.0
			var h := w * sun.get_height() / sun.get_width()
			var a := minf(1.0, state_frame / 8.0) * (0.75 + 0.15 * sin(state_frame * 0.3))
			draw_texture_rect(sun, Rect2(-w / 2, 10 - h, w, h), false, Color(1, 1, 1, a))
	if state == State.ATTACK and current_attack != null and current_attack.name == "4D" \
			and Game.load_texture("res://assets/effects/seed_sunlight.png") == null:
		for i in 3:
			var x := (i - 1) * 24.0
			draw_line(Vector2(x - 20, -size.y - 120), Vector2(x, -size.y - 10), Color(1, 0.95, 0.5, 0.6), 4.0)
	# 덩굴 채찍
	if state == State.ATTACK and current_attack != null and current_attack.name == "6D" \
			and state_frame > current_attack.startup \
			and state_frame <= current_attack.startup + current_attack.active + WHIP_LINGER:
		var fade := clampf(1.0 - float(state_frame - current_attack.startup - current_attack.active) / WHIP_LINGER, 0.0, 1.0)
		var whip := Game.load_texture("res://assets/effects/seed_whip.png")
		if whip != null:
			# 채찍 그림을 판정 길이만큼 쭉 뻗게 (나오는 동안 앞으로 늘어남)
			var a: AttackData = current_attack
			var reach := minf(1.0, float(state_frame - a.startup + 1) / 3.0)
			var box := a.hitbox
			var whip_x := WHIP_START
			var whip_len := (box.end.x + 20.0 - whip_x) * reach
			var h := whip_len * whip.get_height() / whip.get_width() * 1.4
			var src := Rect2(0, 0, whip.get_width() * reach, whip.get_height()) if reach < 1.0 else Rect2()
			draw_set_transform(Vector2.ZERO, 0, Vector2(facing, 1))
			if src.has_area():
				draw_texture_rect_region(whip, Rect2(whip_x, box.get_center().y - h / 2, whip_len, h), src, Color(1, 1, 1, fade))
			else:
				draw_texture_rect(whip, Rect2(whip_x, box.get_center().y - h / 2, whip_len, h), false, Color(1, 1, 1, fade))
			draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
		var pts := PackedVector2Array()
		for i in (0 if whip != null else 7):
			pts.append(Vector2((20 + i * 36) * facing, -95 + sin(i * 1.1 + state_frame) * 10))
		if pts.size() > 1:
			draw_polyline(pts, VINE_GREEN.darkened(0.3), 10.0)
			draw_polyline(pts, VINE_GREEN, 5.0)
	super()
