class_name Fighter
extends Node2D
## 캐릭터 공통 몸통: 이동, 점프(2단), 대시/백스텝, 공중 대시, 공격, 가드, 피격
##
## 격투겜은 "프레임" 단위로 생각하는 게 편해서, 모든 시간 값은 프레임(1/60초) 단위다.
## 물리 엔진은 쓰지 않고 위치를 직접 계산한다 (격투겜은 정확한 제어가 더 중요해서).
## 캐릭터별 기술은 나중에 이 클래스를 상속해서 _build_attacks()를 바꾸면 된다.

signal projectile_spawned(projectile: Projectile)  # Match가 받아서 관리
signal super_flash(fighter: Fighter, attack: AttackData)  # 오버드라이브 컷인 (Match가 화면을 잠깐 멈춤)
@warning_ignore("unused_signal")  # 캐릭터 스크립트(커몬 등)에서 emit 한다
signal screen_tint(color: Color, frames: int)  # 화면 전체 색 효과 (블루스크린 등)

enum State {
	STAND, CROUCH, RUN, BACKDASH, PREJUMP, AIR, AIRDASH,
	GUARD, ATTACK, HITSTUN, BLOCKSTUN, KO,
}

# ── 튜닝 값 (단위: 픽셀 / 프레임) ─────────────────────────
@export var max_hp := 420
@export var walk_forward_speed := 4.0
@export var walk_back_speed := 3.2
@export var run_speed := 9.0
@export var jump_velocity := -17.0     # 위쪽이 음수
@export var double_jump_velocity := -14.0
@export var jump_forward_speed := 4.5   # 대각선 점프 가로 속도
@export var gravity := 0.9
@export var prejump_frames := 4         # 점프 직전 웅크리는 시간
@export var backdash_frames := 18
@export var backdash_speed := -8.0
@export var airdash_frames := 14
@export var airdash_speed := 11.0
@export var air_actions := 1            # 공중에서 2단 점프/공중 대시를 몇 번 쓸 수 있나 (둘이 공유)
@export var ground_friction := 0.85     # 밀려날 때 속도가 줄어드는 비율
@export var input_buffer_frames := 8    # 버튼을 몇 프레임 전에 눌러도 기억해 둘지

# ── 텐션 게이지 ───────────────────────────────────────────
const MAX_TENSION := 100.0
const RC_COST := 50.0                   # 로만 캔슬 비용 (게이지 절반)
@export var tension_walk_gain := 0.06   # 앞으로 걸을 때 프레임당
@export var tension_run_gain := 0.10    # 달릴 때 프레임당
@export var tension_hit_gain := 4.0     # 공격이 맞았을 때
@export var tension_block_gain := 2.0   # 공격이 막혔을 때 (공격한 쪽)
@export var tension_guard_gain := 1.0   # 공격을 막았을 때 (막은 쪽)

# ── 몸 크기 (임시 네모 그래픽 + 밀어내기/피격 판정) ─────────
const BODY_SIZE := Vector2(70, 160)
const CROUCH_SIZE := Vector2(80, 100)

## 버튼 우선순위: 동시에 눌렀으면 강한 버튼이 이긴다
const ATTACK_BUTTONS: Array[String] = ["hs", "s", "k", "p"]
## 입력 버퍼에 기억해 둘 버튼 (누르는 "순간"이 중요한 것들). "dash"는 버튼이 아니라 같은 방향 두 번 (66 / 44)
const BUFFERED_ACTIONS: Array[String] = ["hs", "s", "k", "p", "d", "dash", "up", "rc"]
const DASH_TAP_WINDOW := 14     # 첫 번째를 누르고 이 프레임 안에 같은 방향을 또 누르면 대시
const HISTORY_FRAMES := 60      # 위치 기록 길이 (커몬 Ctrl+Z 등에서 사용)

var player := 1                 # 1P / 2P
var char_id := ""               # Game.CHARACTERS의 id (그림/뼈대를 찾을 때)
var art_modulate := Color.WHITE # 그림 색 (같은 캐릭터끼리 붙을 때 2P를 어둡게)
var puppet: Puppet              # 전신 그림 + 뼈대가 있으면 네모 대신 그림으로 그린다
var _anim_t := 0                # 그림 움직임용 시계 (히트스톱 중엔 멈춤)
var color := Color.RED
var display_name := ""
var input_enabled := true       # 라운드 시작 전/끝난 뒤에는 Match가 입력을 막는다

## 트레이닝 더미: HUMAN이면 사람이 조작, 아니면 정해진 동작만 한다 (Game.DUMMY_KEYS와 순서 같음)
enum Dummy { HUMAN, STAND, CROUCH, JUMP, GUARD, GUARD_LOW, GUARD_AUTO }
var dummy: Dummy = Dummy.HUMAN
var brain: CpuBrain             # 있으면 CPU가 조작 (사람 입력 대신 brain의 버튼을 읽는다)
var can_die := true             # 트레이닝 모드에서는 false (체력이 1 밑으로 안 내려감)
var opponent: Fighter
var ground_y := 600.0           # 바닥 높이 (Match가 정해줌)

var hp := 0
var state: State = State.STAND
var velocity := Vector2.ZERO
var facing := 1                 # 1 = 오른쪽을 봄, -1 = 왼쪽을 봄
var state_frame := 0            # 현재 상태에 들어온 뒤 지난 프레임 수
var air_actions_left := 0
var _jump_dir := 0              # 점프 직전에 정한 방향 (-1 뒤, 0 제자리, 1 앞)
var _jump_from_run := false     # 달리다가 뛰었나 (더 멀리 뛴다)
var _tap_dir := 0               # 마지막으로 새로 누른 좌우 방향 (1 앞, -1 뒤, 0 없음)
var _tap_age := 99              # 그 뒤로 지난 프레임
var _dash_tapped := false       # 이번 프레임에 66 / 44가 완성됐나
var _dash_dir := 1              # 버퍼에 있는 대시 방향 (1 = 앞 대시, -1 = 백스텝)

var attacks := {}               # "5P" -> AttackData
var current_attack: AttackData
var attack_connected := false   # 이번 공격이 이미 맞았거나 막혔나 (한 번만 판정 + 개틀링 조건)
var stun_frames := 0            # 히트스턴/가드스턴 남은 프레임
var _buffer := {}               # 액션 -> 남은 기억 프레임 (0이면 없음)
var tension := 0.0
var hit_shake := 0              # 히트스톱 동안 맞은 쪽이 부르르 떠는 남은 프레임
var rc_flash := 0               # 로만 캔슬 이펙트 남은 프레임
var history: Array[Vector2] = []  # 최근 위치 기록 (맨 앞이 가장 오래된 것)
var _armor_used := 0            # 이번 공격에서 아머로 버틴 횟수
var armor_flash := 0            # 아머로 버텼을 때 번쩍임 남은 프레임
var shock_frames := 0           # 감전 표시 남은 프레임 (몸 주위에 노란 번개)
var damage_mult := 1.0          # 내 공격의 데미지 배율 (강화 상태 등)

# ── 가드 게이지 (길티기어 R.I.S.C. 게이지를 단순화) ─────────
## 막을 때마다 차고, 꽉 찬 상태에서 또 막으면 가드 크러시(가드가 깨져 잠깐 무방비).
## 공격을 맞으면 0으로, 한동안 안 막으면 천천히 줄어든다
const GUARD_MAX := 100.0
const GUARD_PER_BLOCK := 2.0       # 막을 때 = 가드 경직 x 이 값
const GUARD_DECAY := 0.25          # 안 막는 동안 프레임당 감소 (1초 뒤부터)
const GUARD_CRUSH_STUN := 45       # 가드 크러시 무방비 시간
var guard_gauge := 0.0
var _since_block := 999
var crush_text := 0                # "GUARD CRUSH!" 글자 남은 프레임

# ── 카운터 히트 ───────────────────────────────────────────
## 상대가 공격을 내는 중(발생~지속)에 때리면 카운터: 데미지와 경직이 늘고 멈춤도 길어진다
## (길티기어처럼 "COUNTER" 글자. 늘어난 경직 덕분에 평소엔 안 이어지는 콤보가 들어간다)
const COUNTER_DAMAGE := 1.1        # 데미지 +10%
const COUNTER_HITSTUN := 8         # 경직 +8프레임
const COUNTER_HITSTOP := 6         # 히트스톱 +6프레임 (Match가 더한다)
var counter_text := 0              # "COUNTER" 글자 남은 프레임
var last_hit_counter := false      # 방금 맞은 게 카운터였나 (Match가 읽는다)

# ── 일반 잡기 ─────────────────────────────────────────────
## 상대에게 붙어서 → 또는 ← + HS. 가드 불가. 상대가 땅에 있고 경직 중이 아닐 때만
const THROW_RANGE := 40.0          # 몸끼리 이 거리 안이면 잡을 수 있다


func _ready() -> void:
	hp = max_hp
	_build_attacks()
	_build_specials()
	var art := Game.load_texture("res://assets/characters/%s.png" % char_id)
	var rig := Rigs.get_rig(char_id)
	if art != null and not rig.is_empty():
		puppet = Puppet.new(art, rig)
		_fit_hitboxes_to_art()


## 1프레임 진행. Match가 매 프레임 1P → 2P 순서로 직접 호출한다 (처리 순서를 고정하려고)
func tick() -> void:
	state_frame += 1
	_anim_t += 1
	if brain != null and input_enabled:
		brain.think(self)
	_update_buffer()
	_update_state()
	if state == State.ATTACK and current_attack != null and current_attack.move_speed != 0.0 \
			and state_frame <= current_attack.startup + current_attack.active:
		velocity.x = current_attack.move_speed * facing  # 돌진기
	position += velocity
	# 바닥 밑으로 내려가지 않게. 공중 기술이 이번 프레임에 아래로 큰 속도를 주면
	# (_attack()의 착지 검사가 끝난 뒤라) 바닥을 뚫고 계속 떨어지던 버그 방지
	if position.y > ground_y:
		position.y = ground_y
		if state == State.AIR or state == State.AIRDASH or state == State.ATTACK:
			_land()
		else:
			velocity.y = 0.0
	history.append(position)
	if history.size() > HISTORY_FRAMES:
		history.pop_front()
	if rc_flash > 0:
		rc_flash -= 1
	if armor_flash > 0:
		armor_flash -= 1
	if shock_frames > 0:
		shock_frames -= 1
	if crush_text > 0:
		crush_text -= 1
	if counter_text > 0:
		counter_text -= 1
	_since_block += 1
	if _since_block > 60:
		guard_gauge = maxf(0.0, guard_gauge - GUARD_DECAY)
	queue_redraw()


## 히트스톱 중에 Match가 tick() 대신 호출한다.
## 캐릭터는 멈춰 있지만, 이때 누른 버튼은 버퍼에 기억해 둔다 (히트스톱 중 개틀링 입력 가능)
func tick_frozen() -> void:
	if brain == null:
		_update_dash_taps()
	for action in BUFFERED_ACTIONS:
		if brain == null and _just_pressed(action):
			_buffer[action] = input_buffer_frames
	if hit_shake > 0:
		hit_shake -= 1
	queue_redraw()


## 새 라운드: 위치와 체력, 상태를 처음으로 (텐션은 유지)
func reset_for_round(x: float) -> void:
	position = Vector2(x, ground_y)
	hp = max_hp
	velocity = Vector2.ZERO
	current_attack = null
	stun_frames = 0
	hit_shake = 0
	rc_flash = 0
	guard_gauge = 0.0
	crush_text = 0
	counter_text = 0
	history.clear()
	_buffer.clear()
	_change_state(State.STAND)
	_face_opponent()


func add_tension(amount: float) -> void:
	tension = clampf(tension + amount, 0.0, MAX_TENSION)


# ── 기술 목록 (캐릭터마다 덮어쓸 부분) ─────────────────────
## Rect2(x, y, 너비, 높이): 오른쪽을 볼 때 기준, 발 위치가 (0, 0), 위쪽이 음수
func _build_attacks() -> void:
	_add_throws()
	var M := AttackData.Level.MID
	var L := AttackData.Level.LOW
	var O := AttackData.Level.OVERHEAD
	#                         이름   발생 지속 후딜 데미지  판정 범위                       단계 히트 가드  개틀링
	_add(AttackData.new("5P",  4, 3,  8, 22, Rect2(25, -115, 70, 25), M, 12, 9,  ["5P", "5K", "2K", "5S", "2S"]))
	_add(AttackData.new("5K",  6, 3, 12, 30, Rect2(25, -80, 85, 25),  M, 15, 11, ["5S", "2S", "5H"]))
	_add(AttackData.new("5S",  8, 4, 16, 40, Rect2(25, -120, 120, 35), M, 17, 13, ["5H", "2S"]))
	_add(AttackData.new("5H", 12, 5, 22, 55, Rect2(20, -150, 140, 60), M, 20, 15))
	_add(AttackData.new("2P",  4, 3,  8, 18, Rect2(25, -70, 65, 22),  M, 11, 8,  ["2P", "5P", "2K", "5S", "2S"]))
	_add(AttackData.new("2K",  5, 3, 10, 20, Rect2(25, -25, 90, 25),  L, 13, 10, ["5S", "2S", "5H"]))
	_add(AttackData.new("2S",  8, 4, 16, 35, Rect2(25, -45, 120, 30), L, 16, 12, ["5H"]))
	_add(AttackData.new("2H", 11, 5, 22, 50, Rect2(10, -190, 90, 110), M, 20, 15))
	_add(AttackData.new("jP",  4, 4,  6, 20, Rect2(20, -110, 70, 30), O, 12, 9,  ["jK", "jS"]))
	_add(AttackData.new("jK",  6, 5,  8, 28, Rect2(20, -60, 80, 35),  O, 14, 10, ["jS", "jH"]))
	_add(AttackData.new("jS",  8, 5, 10, 38, Rect2(15, -100, 110, 60), O, 16, 12, ["jH"]))
	_add(AttackData.new("jH", 11, 6, 12, 50, Rect2(0, -60, 130, 70),  O, 18, 14))


## 일반 잡기 (모든 캐릭터 공통): 앞 던지기 / 뒤 던지기
func _add_throws() -> void:
	for dir in [1, -1]:
		var t := _add(AttackData.new("throw_f" if dir > 0 else "throw_b", 2, 3, 22, 40,
				Rect2(10, -150, 80, 140), AttackData.Level.MID, 30, 0))
		t.is_throw = true
		t.launch = Vector2(8.0 * dir, -10.0)  # 앞(1) 또는 뒤(-1)로 던진다
		t.hitstop = 12


## 지금 상대를 잡을 수 있는 거리/상태인가
func _in_throw_range() -> bool:
	if opponent == null or not opponent.is_on_ground() or not is_on_ground():
		return false
	if opponent.state in [State.HITSTUN, State.BLOCKSTUN, State.KO]:
		return false
	var gap := absf(opponent.position.x - position.x) - (body_size().x + opponent.body_size().x) / 2
	return gap <= THROW_RANGE


func _add(attack: AttackData) -> AttackData:
	attacks[attack.name] = attack
	return attack


# ── 캐릭터별로 덮어쓰는 부분 ──────────────────────────────
## 필살기 목록. 캐릭터 스크립트에서 _build_specials()를 덮어써서 "5D", "6D", "4D", "2D", "OD"를 추가
func _build_specials() -> void:
	pass


## 공격의 event_frame에 불린다 (투사체 만들기, 순간이동 등)
func _on_attack_event(_attack_data: AttackData) -> void:
	pass


## 내 공격이 맞았거나 막혔을 때 (블루스크린 효과 등)
func _on_attack_result(_attack_data: AttackData, _blocked: bool) -> void:
	pass


## 공격을 받기 직전에 불린다. true를 돌려주면 그 공격을 무효로 한다 (반격기)
func _try_counter(_attack_data: AttackData) -> bool:
	return false


## 이 필살기를 지금 쓸 수 있나 (투사체는 화면에 하나만 등)
func _can_use_special(_attack_name: String) -> bool:
	return true


## 상대를 target_x 쪽으로 끌어당긴다 (max_dist 안에 있을 때만)
func pull_opponent(target_x: float, strength: float, max_dist: float) -> void:
	if opponent == null or opponent.state == State.KO:
		return
	var dx := target_x - opponent.position.x
	if absf(dx) < max_dist and absf(dx) > 8:
		opponent.position.x += signf(dx) * minf(strength, absf(dx))


func spawn(projectile: Projectile) -> void:
	projectile.shooter = self
	projectile_spawned.emit(projectile)


# ── 입력 헬퍼 ─────────────────────────────────────────────
func _held(action: String) -> bool:
	if not input_enabled:
		return false
	if brain != null:
		return brain.held(action)
	if dummy != Dummy.HUMAN:
		return _dummy_held(action)
	if not action in InputManager.ACTIONS:
		return false  # "guard"는 더미/CPU 전용 (사람은 ← 누르기로 가드)
	return Input.is_action_pressed(InputManager.action_name(player, action))


## 더미가 "누르고 있는" 버튼
func _dummy_held(action: String) -> bool:
	match dummy:
		Dummy.CROUCH:
			return action == "down"
		Dummy.JUMP:
			return action == "up"
		Dummy.GUARD:
			return action == "guard"
		Dummy.GUARD_LOW:
			return action == "guard" or action == "down"
		Dummy.GUARD_AUTO:
			# 상대가 하단 공격 중이면 앉아서, 아니면 서서 가드
			if action == "guard":
				return true
			if action == "down":
				return opponent != null and opponent.current_attack != null \
						and opponent.current_attack.level == AttackData.Level.LOW
	return false


## 가드 입력: 뒤(상대 반대쪽)를 누르고 있거나 가드 버튼 (길티기어처럼 뒤 = 가드)
func _guard_held() -> bool:
	return _held("guard") or _input_forward() < 0


## 근접 가드 (Proximity Guard): 상대 공격이 발생~지속 중이고 "그 기술이 닿을 만한 거리"에 있거나,
## 상대 투사체가 가까이 오면 true. 이때 뒤를 누르면 뒤로 걷지 않고 그 자리에서 가드 자세를 잡는다.
## 멀리서 헛친 기술에는 반응하지 않고, 잡기는 반응하지 않는다 (CPU도 이걸 보고 가드)
const PROXIMITY_MARGIN := 60.0  # 판정 끝보다 이만큼 더 멀어도 가드 자세 (스파·길티처럼 판정보다 조금 넓게)


func is_threatened() -> bool:
	if opponent == null:
		return false
	var a := opponent.current_attack
	if opponent.state == State.ATTACK and a != null and not a.is_throw \
			and opponent.state_frame <= a.startup + a.active:
		var left := maxi(0, a.startup + a.active - opponent.state_frame)
		var reach := a.hitbox.end.x if a.hitbox.has_area() else 0.0
		reach += absf(a.move_speed) * left  # 돌진기는 앞으로 나가는 거리까지
		var gap := absf(opponent.position.x - position.x) - body_size().x / 2
		if a.hitbox.has_area() and gap <= reach + PROXIMITY_MARGIN:
			return true
	var match_node := get_parent()
	if match_node is Match:
		for proj in match_node.projectiles:
			if proj.shooter == opponent and proj.attack != null and not proj.dead \
					and proj.position.distance_to(position + Vector2(0, -80)) < 230:
				return true
	return false


## "최근 몇 프레임 안에 눌렀나" (입력 버퍼). 실제로 행동에 썼으면 _consume()으로 지운다
func _pressed(action: String) -> bool:
	return _buffer.get(action, 0) > 0


func _consume(action: String) -> void:
	_buffer[action] = 0


## 입력 버퍼: 누른 순간부터 input_buffer_frames 동안 "눌렀음"을 기억한다.
## 후딜 중에 조금 일찍 눌러도, 움직일 수 있게 되는 순간 바로 나간다.
func _update_buffer() -> void:
	_update_dash_taps()
	for action in BUFFERED_ACTIONS:
		if _just_pressed(action):
			_buffer[action] = input_buffer_frames
		elif _buffer.get(action, 0) > 0:
			_buffer[action] -= 1


## 대시 입력 (길티기어처럼 같은 방향 두 번): → → = 앞 대시(달리기), ← ← = 백스텝. 공중에서도 같다
func _update_dash_taps() -> void:
	_dash_tapped = false
	_tap_age += 1
	var dir := 0
	if _just_pressed("right"):
		dir = facing
	elif _just_pressed("left"):
		dir = -facing
	if dir == 0:
		return
	if dir == _tap_dir and _tap_age <= DASH_TAP_WINDOW:
		_dash_tapped = true
		_dash_dir = dir
		_tap_dir = 0  # 세 번째 누름이 또 대시가 되지 않게
	else:
		_tap_dir = dir
	_tap_age = 0


## 이번 프레임에 새로 눌렀나 (사람 / CPU / 더미에 따라)
func _just_pressed(action: String) -> bool:
	if action == "dash":
		return _dash_tapped
	if not input_enabled:
		return false
	if brain != null:
		return brain.just_pressed(action)
	if dummy != Dummy.HUMAN:
		return false
	return Input.is_action_just_pressed(InputManager.action_name(player, action))


## 좌우 입력을 "상대 기준"으로 바꿔준다: 1 = 앞(상대 쪽), -1 = 뒤, 0 = 없음
func _input_forward() -> int:
	var x := int(_held("right")) - int(_held("left"))
	return x * facing


## 이번 프레임에 누른 공격 버튼으로 기술 이름을 만든다. 없으면 ""
## prefix: "5"(서서), "2"(앉아서), "j"(공중)
func _pressed_attack(prefix: String) -> String:
	for button in ATTACK_BUTTONS:
		if _pressed(button):
			var suffix := "H" if button == "hs" else button.to_upper()
			return prefix + suffix
	return ""


## 이번 프레임의 필살기 입력 → 기술 이름. 없거나 못 쓰면 ""
## D + HS 동시 = 오버드라이브(텐션 50%), D + 방향 = 6D(앞) 4D(뒤) 2D(아래), D만 = 5D
func _pressed_special() -> String:
	if not _pressed("d"):
		return ""
	var move := ""
	if _pressed("hs") and attacks.has("OD") and tension >= attacks["OD"].cost:
		move = "OD"
	elif _held("down"):
		move = "2D"
	elif _input_forward() > 0:
		move = "6D"
	elif _input_forward() < 0:
		move = "4D"
	else:
		move = "5D"
	if not attacks.has(move) or not _can_use_special(move):
		return ""
	return move


func is_on_ground() -> bool:
	return position.y >= ground_y


# ── 상태 머신 ─────────────────────────────────────────────
func _change_state(new_state: State) -> void:
	state = new_state
	state_frame = 0


func _update_state() -> void:
	match state:
		State.STAND, State.CROUCH:
			_ground_neutral()
		State.RUN:
			_run()
		State.BACKDASH:
			_backdash()
		State.PREJUMP:
			_prejump()
		State.AIR:
			_air()
		State.AIRDASH:
			_airdash()
		State.GUARD:
			_guard()
		State.ATTACK:
			_attack()
		State.HITSTUN, State.BLOCKSTUN:
			_stunned()
		State.KO:
			_ko()


## 서 있거나 앉아 있을 때: 공격, 가드, 점프, 대시, 앉기, 걷기
func _ground_neutral() -> void:
	_face_opponent()
	var fwd := _input_forward()

	var special := _pressed_special()
	if special != "":
		_start_attack(special)
		return
	# 일반 잡기: 붙어서 → / ← + HS (아니면 그냥 5H가 나간다)
	if _pressed("hs") and fwd != 0 and not _held("down") and _in_throw_range():
		_start_attack("throw_f" if fwd > 0 else "throw_b")
		return
	var attack := _pressed_attack("2" if _held("down") else "5")
	if attack != "":
		_start_attack(attack)
		return
	if _held("up"):
		_start_prejump(fwd)
		return
	if _pressed("dash"):
		_consume("dash")
		if _dash_dir < 0:
			_change_state(State.BACKDASH)
			Sfx.play("dash", -4.0, 0.05)
		else:
			_change_state(State.RUN)
			Sfx.play("dash", -4.0, 0.05)
		return
	# 가드 버튼, 또는 상대가 공격해 올 때 뒤(↙ 포함)를 누르고 있으면 제자리 가드
	if _held("guard") or (fwd < 0 and is_threatened()):
		velocity.x = 0
		_change_state(State.GUARD)
		return

	if _held("down"):
		if state != State.CROUCH:
			_change_state(State.CROUCH)
		velocity.x = 0
		return

	if state != State.STAND:
		_change_state(State.STAND)
	if fwd > 0:
		velocity.x = walk_forward_speed * facing
		add_tension(tension_walk_gain)
	elif fwd < 0:
		velocity.x = -walk_back_speed * facing
	else:
		velocity.x = 0


## 달리기: →→ 뒤에 앞 방향을 누르고 있는 동안 계속 달린다
func _run() -> void:
	var attack := _pressed_attack("5")
	if attack != "":
		var run_velocity := velocity.x
		_start_attack(attack)
		velocity.x = run_velocity * 0.5  # 달리던 관성을 살짝 남긴 채 공격
		return
	if _held("up"):
		_start_prejump(1)
		return
	var fwd := _input_forward()
	if fwd > 0:
		velocity.x = run_speed * facing
		add_tension(tension_run_gain)
	else:
		velocity.x = 0
		_change_state(State.STAND)


## 백스텝: 정해진 프레임 동안 뒤로 빠진다 (도중에 다른 행동 불가)
func _backdash() -> void:
	velocity.x = backdash_speed * facing
	if state_frame >= backdash_frames:
		velocity.x = 0
		_change_state(State.STAND)


func _start_prejump(dir: int) -> void:
	_consume("up")  # 안 지우면 점프하자마자 버퍼에 남은 ↑ 때문에 2단 점프가 나가버린다
	_jump_dir = dir
	_jump_from_run = state == State.RUN
	velocity.x = 0
	_change_state(State.PREJUMP)


## 점프 직전 웅크림. 끝나면 실제로 뛰어오른다
func _prejump() -> void:
	if state_frame >= prejump_frames:
		# 웅크리는 동안 방향을 바꿨으면 그걸 따른다
		var fwd := _input_forward()
		if fwd != 0:
			_jump_dir = fwd
		var speed := run_speed if _jump_dir > 0 and _jump_from_run else jump_forward_speed
		velocity = Vector2(_jump_dir * speed * facing, jump_velocity)
		Sfx.play("jump", -6.0, 0.05)
		air_actions_left = air_actions
		_change_state(State.AIR)


## 공중: 중력, 공중 공격, 2단 점프, 공중 대시, 착지
func _air() -> void:
	velocity.y += gravity

	# 공중 필살기 (D)
	if _pressed("d") and attacks.has("jD") and _can_use_special("jD"):
		_start_attack("jD")
		return
	var attack := _pressed_attack("j")
	if attack != "":
		_start_attack(attack)
		return

	if air_actions_left > 0:
		if _pressed("up"):
			_consume("up")
			air_actions_left -= 1
			velocity = Vector2(_input_forward() * jump_forward_speed * facing, double_jump_velocity)
			Sfx.play("jump", -6.0, 0.1)
		elif _pressed("dash"):
			_consume("dash")
			air_actions_left -= 1
			velocity = Vector2(_dash_dir * airdash_speed * facing, 0)
			_change_state(State.AIRDASH)
			Sfx.play("dash", -4.0, 0.05)
			return

	_check_landing()


## 공중 대시: 정해진 프레임 동안 중력 없이 수평으로 날아간다
func _airdash() -> void:
	velocity.y = 0
	if state_frame >= airdash_frames:
		velocity.x *= 0.4  # 대시가 끝나면 속도를 줄이고 다시 떨어진다
		_change_state(State.AIR)


## 가드 중 (↓를 같이 누르면 앉아서 가드). 위협이 끝나거나 뒤를 놓으면 서기로 (그다음엔 다시 뒤로 걷기)
func _guard() -> void:
	_face_opponent()
	velocity.x = 0
	if not (_held("guard") or (_input_forward() < 0 and is_threatened())):
		_change_state(State.STAND)


## 공격 중: 발생 → 지속 → 후딜이 끝나면 원래 상태로. 맞히거나 막히면 개틀링 가능
func _attack() -> void:
	var airborne := not is_on_ground() or velocity.y < 0
	if airborne:
		velocity.y += gravity
		if position.y + velocity.y >= ground_y:
			_land()  # 공중 공격은 착지하면 끝
			return
	else:
		velocity.x *= ground_friction

	# 로만 캔슬: 게이지 절반을 써서 공격을 즉시 취소하고 다시 움직일 수 있게 된다
	if _pressed("rc") and tension >= RC_COST:
		_consume("rc")
		_roman_cancel(airborne)
		return

	if state_frame == current_attack.event_frame:
		_on_attack_event(current_attack)

	if attack_connected:
		# 일반기가 맞거나 막히면 필살기로 캔슬 가능 (필살기끼리는 안 됨)
		if not airborne and not current_attack.name.ends_with("D") and current_attack.name != "OD":
			var special := _pressed_special()
			if special != "":
				_start_attack(special)
				return
		var prefix := "j" if airborne else ("2" if _held("down") else "5")
		var next := _pressed_attack(prefix)
		if next != "" and next in current_attack.gatling:
			_start_attack(next)
			return

	if state_frame >= current_attack.total_frames():
		current_attack = null
		_change_state(State.AIR if airborne else State.STAND)
		if not airborne:
			_ground_neutral()  # 버퍼에 남은 입력이 있으면 같은 프레임에 바로 나가도록


func _roman_cancel(airborne: bool) -> void:
	Sfx.play("rc")
	add_tension(-RC_COST)
	rc_flash = 20
	current_attack = null
	if airborne:
		velocity = Vector2(velocity.x * 0.3, 0)  # 공중에서 쓰면 그 자리에 살짝 멈춘다
		air_actions_left = maxi(air_actions_left, 1)
		_change_state(State.AIR)
	else:
		velocity.x = 0
		_change_state(State.STAND)


func _start_attack(attack_name: String) -> void:
	for button in ATTACK_BUTTONS:  # 같이 눌린 다른 공격 버튼도 같이 소모
		_consume(button)
	_consume("d")
	current_attack = attacks[attack_name]
	attack_connected = false
	_armor_used = 0
	if is_on_ground():
		velocity.x = 0
	_change_state(State.ATTACK)
	if current_attack.cost > 0:
		add_tension(-current_attack.cost)
	if attack_name == "OD":
		super_flash.emit(self, current_attack)
		Sfx.play("overdrive")
	elif attack_name.ends_with("D"):
		Sfx.play("special", -3.0, 0.08)
	else:
		Sfx.play("whoosh", -8.0, 0.15)


## 히트스턴/가드스턴: 시간이 다 지나면 다시 움직일 수 있다
func _stunned() -> void:
	if is_on_ground() and velocity.y >= 0:
		velocity.x *= ground_friction
		stun_frames -= 1
		if stun_frames <= 0:
			_change_state(State.GUARD if state == State.BLOCKSTUN and _guard_held() else State.STAND)
	else:
		# 공중에서 맞으면 땅에 떨어질 때까지 못 움직인다
		velocity.y += gravity
		if position.y + velocity.y >= ground_y:
			_land()


func _ko() -> void:
	velocity.y += gravity
	if position.y + velocity.y >= ground_y:
		position.y = ground_y
		velocity = Vector2.ZERO
	else:
		velocity.x *= 0.98


func _check_landing() -> void:
	if position.y + velocity.y >= ground_y:
		_land()


func _land() -> void:
	position.y = ground_y
	velocity = Vector2.ZERO
	current_attack = null
	_change_state(State.STAND)


## 땅에 있을 때만 상대 쪽을 바라본다 (공중에서는 방향 고정)
func _face_opponent() -> void:
	if opponent == null:
		return
	if opponent.position.x > position.x + 1:
		facing = 1
	elif opponent.position.x < position.x - 1:
		facing = -1


# ── 판정 ─────────────────────────────────────────────────
func body_size() -> Vector2:
	var low := state == State.CROUCH or state == State.PREJUMP \
			or (state == State.GUARD and _held("down")) \
			or (state == State.ATTACK and current_attack != null and current_attack.name.begins_with("2"))
	if not low:
		return BODY_SIZE
	if puppet != null and _crouch_h < 0.0:
		# 앉은 몸 높이를 앉은 그림 키에 맞춤 (머리 꼭대기까지의 80% = 머리카락 끝은 빼고)
		_crouch_h = CROUCH_SIZE.y
		var tex := Game.load_texture("res://assets/characters/%s_crouch.png" % char_id)
		if tex != null:
			_crouch_h = clampf(Puppet.height_of(tex) * _pose_scale() * _pose_size(tex) * 0.8, 80.0, 130.0)
	return Vector2(CROUCH_SIZE.x, _crouch_h if _crouch_h > 0.0 else CROUCH_SIZE.y)


var _crouch_h := -1.0   # 앉은 몸 높이 (그림에서 한 번 계산)


## 몸통 사각형 (밀어내기 = 서로 겹치지 않게. 그림이 없으면 맞는 판정도 이것)
func body_rect() -> Rect2:
	var size := body_size()
	return Rect2(position.x - size.x / 2, position.y - size.y, size.x, size.y)


## 맞는 판정(허트박스): 그림이 있으면 지금 그려지는 그림 모양을 따라 여러 개 (월드 좌표)
## 뻗은 팔·다리도 맞는다 (길티기어처럼 공격하는 손발을 노려서 끊을 수 있음)
func hurt_rects() -> Array[Rect2]:
	if puppet == null:
		return [body_rect()]
	var tex := _pose_texture()
	var anchor := puppet.anchor
	var s := puppet.scale
	if tex != null:
		anchor = _anchor_for(tex)
		s = _pose_scale() * _pose_size(tex)
	else:
		tex = puppet.texture
	var out: Array[Rect2] = []
	for b: Rect2 in ArtBoxes.hurt_boxes(tex, anchor):
		var r := Rect2(b.position * s, b.size * s)
		if facing < 0:
			r.position.x = -r.position.x - r.size.x
		r.position += position
		out.append(r)
	return out


## 공격 판정(히트박스)을 그림에 맞추기: 서서/앉아서 쓰는 기본기만.
## 기준 기술(5P / 5K / 2P)의 판정 끝이 그 자세 그림의 주먹·발 끝에 오게(높이도) 옮기고,
## 같은 자세를 쓰는 다른 기술도 같은 만큼 옮긴다 (5S·5H가 5P보다 긴 건 그대로 = 밸런스 유지)
const REACH_LIMIT := 50.0   # 그림 때문에 사거리가 너무 크게 바뀌지 않게
const HEIGHT_LIMIT := 40.0  # 판정 높이도 너무 크게 바뀌지 않게 (앉은 상대에게 맞고 안 맞고가 바뀜)


func _fit_hitboxes_to_art() -> void:
	if puppet == null:
		return
	# [자세 그림, 기준 기술, 같이 옮길 기술, 손발 끝을 찾을 높이(키 비율)]
	var groups := [["kick", "5K", ["5K"], 0.2, 0.9], ["crouch", "2P", ["2P", "2S", "2H"], 0.3, 1.0]]
	# 5P / 5S / 5H는 쓰는 그림별로 묶는다 (S 그림이 있으면 5S는 그 그림의 무기 끝에 맞춤)
	for move in ["5P", "5S", "5H"]:
		var pose := _stand_pose(move)
		var same := groups.filter(func(g: Array) -> bool: return g[0] == pose)
		if same.is_empty():
			groups.append([pose, move, [move], 0.45, 1.0])
		else:
			same[0][2].append(move)
	for group in groups:
		var tex := Game.load_texture("res://assets/characters/%s_%s.png" % [char_id, group[0]])
		if tex == null or not attacks.has(group[1]):
			continue
		var s := _pose_scale() * _pose_size(tex)
		var tip := ArtBoxes.front_tip(tex, _anchor_for(tex), group[3], group[4])
		if tip == Vector2.INF:
			continue
		tip *= s
		var ref: AttackData = attacks[group[1]]
		# 캐릭터마다 일부러 그림 끝까지 늘리고 싶은 기술은 rigs의 reach_limit으로 한도를 바꾼다
		var limit: float = Rigs.get_rig(char_id).get("reach_limit", {}).get(group[1], REACH_LIMIT)
		var dx := clampf(tip.x - ref.hitbox.end.x, -REACH_LIMIT, limit)
		var dy := clampf(tip.y - ref.hitbox.get_center().y, -HEIGHT_LIMIT, HEIGHT_LIMIT)
		for move_name: String in group[2]:
			if attacks.has(move_name):
				var a: AttackData = attacks[move_name]
				# 기본 한도(50)까지는 판정을 통째로 옮기고, 그 이상 늘린 만큼은 앞으로 길게 늘린다 (가까운 상대도 맞게)
				var stretch := maxf(0.0, dx - REACH_LIMIT)
				a.hitbox.position.x = maxf(5.0, a.hitbox.position.x + dx - stretch)
				a.hitbox.size.x += stretch
				a.hitbox.position.y = minf(a.hitbox.position.y + dy, -a.hitbox.size.y)  # 땅 밑으로 안 내려가게


## 지금 살아있는 공격 판정(히트박스). 없으면 크기 0
func hitbox_rect() -> Rect2:
	if state != State.ATTACK or attack_connected or not current_attack.is_active(state_frame):
		return Rect2()
	var box := current_attack.hitbox
	if facing < 0:  # 왼쪽을 보면 좌우 반전
		box.position.x = -box.position.x - box.size.x
	box.position += position
	return box


## 이 공격을 막을 수 있는 상태인가
func can_block(level: AttackData.Level) -> bool:
	var guarding := state == State.GUARD or state == State.BLOCKSTUN \
			or (_guard_held() and state in [State.STAND, State.CROUCH, State.AIR])
	if not guarding:
		return false
	if not is_on_ground():
		return true  # 공중 가드는 모든 공격을 막는다
	var crouching := _held("down")
	match level:
		AttackData.Level.LOW:
			return crouching
		AttackData.Level.OVERHEAD:
			return not crouching
	return true


## Match가 호출: 공격이 맞았거나 막혔다고 알려준다
func on_attack_connected(attack: AttackData, blocked: bool) -> void:
	if attack == current_attack:
		attack_connected = true  # 투사체가 맞은 경우엔 지금 하는 공격과 상관없음
	add_tension(tension_block_gain if blocked else tension_hit_gain)
	_on_attack_result(attack, blocked)


## 지금 맞으면 카운터가 되는 상태인가 (공격 발생~지속 중). 판정 보기에서 맞는 판정이 하늘색이 된다
func in_counter_state() -> bool:
	return state == State.ATTACK and current_attack != null \
			and state_frame <= current_attack.startup + current_attack.active


## 공격 시작부터 invuln_frames 동안은 무적
func is_invulnerable() -> bool:
	return state == State.ATTACK and current_attack != null and state_frame <= current_attack.invuln_frames


## Match가 호출: 공격을 받았다. 막았으면 true를 돌려준다
func receive_attack(attack: AttackData, from_dir: int, damage_scale := 1.0) -> bool:
	var damage := int(round(attack.damage * damage_scale))
	var counter := in_counter_state() and not attack.is_throw  # 상태가 바뀌기 전에 미리 확인
	last_hit_counter = false
	if _try_counter(attack):
		return true  # 반격 성공: 막은 것처럼 처리 (데미지 없음)
	# 아머: 돌진기 등의 발생~지속 동안은 맞아도 멈추지 않는다 (데미지는 받음)
	if state == State.ATTACK and current_attack != null and _armor_used < current_attack.armor_hits \
			and state_frame <= current_attack.startup + current_attack.active:
		_armor_used += 1
		armor_flash = 12
		hp = maxi(hp - damage, 0 if can_die else 1)
		hit_shake = attack.hitstop
		if hp == 0:
			current_attack = null
			velocity = Vector2(6.0 * from_dir, -10.0)
			_change_state(State.KO)
		return false
	if not attack.unblockable and not attack.is_throw and can_block(attack.level):
		add_tension(tension_guard_gain)
		_since_block = 0
		if guard_gauge >= GUARD_MAX:
			# 가드 크러시: 가드가 깨지고 잠깐 무방비 (데미지는 없음)
			guard_gauge = 0.0
			crush_text = 50
			stun_frames = GUARD_CRUSH_STUN
			velocity.x = attack.pushback * 0.5 * from_dir
			_change_state(State.HITSTUN)
			Sfx.play("hit_heavy")
			return false
		guard_gauge = minf(GUARD_MAX, guard_gauge + attack.blockstun * GUARD_PER_BLOCK)
		stun_frames = attack.blockstun
		velocity.x = attack.pushback * from_dir
		_change_state(State.BLOCKSTUN)
		return true

	guard_gauge = 0.0  # 맞으면 가드 게이지 초기화
	if counter:
		damage = int(round(damage * COUNTER_DAMAGE))
		last_hit_counter = true
		counter_text = 50

	hp = maxi(hp - damage, 0 if can_die else 1)
	hit_shake = attack.hitstop
	current_attack = null
	if hp == 0:
		velocity = Vector2(6.0 * from_dir, -10.0)
		_change_state(State.KO)
		return false
	stun_frames = attack.hitstun + (COUNTER_HITSTUN if counter else 0)
	if attack.launch != Vector2.ZERO:
		velocity = Vector2(attack.launch.x * from_dir, attack.launch.y)  # 던지기 등: 크게 날아감
		position.y -= 1  # 땅에서 떨어뜨려야 공중 경직으로 처리된다
	elif is_on_ground():
		velocity.x = attack.pushback * from_dir
	else:
		velocity = Vector2(3.0 * from_dir, -6.0)  # 공중에서 맞으면 살짝 띄워진다
	_change_state(State.HITSTUN)
	return false


# ── 임시 그래픽 ───────────────────────────────────────────
var debug_draw_boxes := false   # F2로 판정 박스 보기


func _draw() -> void:
	var size := body_size()
	var shake_x := (4.0 if hit_shake % 2 == 0 else -4.0) if hit_shake > 0 else 0.0
	var rect := Rect2(-size.x / 2 + shake_x, -size.y, size.x, size.y)
	var body_color := color
	match state:
		State.HITSTUN, State.KO:
			body_color = color.lightened(0.5)
		State.GUARD, State.BLOCKSTUN:
			body_color = color.darkened(0.4)
	if armor_flash > 0:
		body_color = body_color.lerp(Color(1, 0.85, 0.4), armor_flash / 12.0)  # 아머로 버팀: 금색 번쩍
	if puppet != null:
		_draw_puppet(shake_x)
	else:
		_draw_body(rect, body_color, size)
	if shock_frames > 0:
		# 감전: 몸 둘레에 지직거리는 노란 번개
		for i in 4:
			var y0 := -size.y * (0.2 + i * 0.2)
			var jitter := 10.0 if (shock_frames + i) % 4 < 2 else -10.0
			draw_polyline(PackedVector2Array([Vector2(-size.x / 2 - 14, y0), Vector2(-size.x / 4, y0 + jitter),
					Vector2(size.x / 4, y0 - jitter), Vector2(size.x / 2 + 14, y0)]), Color(1, 0.95, 0.3), 3.0)
	# 로만 캔슬: 퍼져 나가는 원
	if rc_flash > 0:
		var t := 1.0 - rc_flash / 20.0
		draw_arc(Vector2(0, -size.y / 2), 40 + t * 160, 0, TAU, 48,
				Color(1, 0.2, 0.3, 1.0 - t), 6.0)
	# 머리 위 1P / 2P 표시
	var tag_color := Color(1, 0.35, 0.35) if player == 1 else Color(0.35, 0.6, 1)
	var tag_pos := Vector2(0, -size.y - 12)
	if puppet != null:  # 지금 그림의 머리 위를 따라다님 (앉으면 내려가고, 점프 그림이면 그 머리 위)
		var head := _head_top()
		tag_pos = Vector2(head.x * facing, head.y - 10)
	draw_string(Game.FONT, tag_pos + Vector2(-40, 0), "%dP" % player,
			HORIZONTAL_ALIGNMENT_CENTER, 80, 22, tag_color)
	if crush_text > 0:
		Style.text(self, "GUARD CRUSH!", Vector2(-150, -size.y - 50), 30, Color(1, 0.4, 0.3, minf(1.0, crush_text / 15.0)),
				HORIZONTAL_ALIGNMENT_CENTER, 300, 6)
	if counter_text > 0:
		Style.text(self, "COUNTER", Vector2(-150, -size.y - 50), 32, Color(1, 0.55, 0.15, minf(1.0, counter_text / 15.0)),
				HORIZONTAL_ALIGNMENT_CENTER, 300, 6)
	if debug_draw_boxes:
		# 디버그: 현재 상태 이름
		var label: String = State.keys()[state]
		if current_attack != null:
			label += " " + current_attack.name
		draw_string(Game.FONT, Vector2(-size.x / 2, -size.y - 38),
				label, HORIZONTAL_ALIGNMENT_LEFT, -1, 16)
		# 색은 길티기어 판정 보기 모드와 같게: 밀어내기 노랑, 맞는 판정 초록(카운터 상태면 하늘색), 공격 빨강, 잡기 보라
		draw_rect(rect, Color(1.0, 0.9, 0.2, 0.8), false, 1.0)
		var hurt_color := Color.CYAN if in_counter_state() else Color.GREEN
		for r: Rect2 in hurt_rects():
			r.position -= position
			draw_rect(r, hurt_color, false, 2.0)
		if is_on_ground():  # 잡기 범위: 내 몸 앞쪽 THROW_RANGE (상대 몸이 여기 닿으면 잡힘)
			var tx := size.x / 2 if facing > 0 else -size.x / 2 - THROW_RANGE
			draw_rect(Rect2(tx, -size.y * 0.8, THROW_RANGE, size.y * 0.6), Color(0.75, 0.35, 1.0, 0.9), false, 2.0)
		var hit := hitbox_rect()
		if hit.has_area():
			hit.position -= position
			draw_rect(hit, Color.RED, false, 2.0)


## 그림이 없을 때 몸 그리기 (연습용 인형처럼 직접 그리는 캐릭터는 이걸 바꾼다)
func _draw_body(rect: Rect2, body_color: Color, size: Vector2) -> void:
	_draw_box(rect, body_color, size)


## 그림이 없을 때: 색 네모 + 눈 + 공격 판정 위치에 흰 네모
func _draw_box(rect: Rect2, body_color: Color, size: Vector2) -> void:
	draw_rect(rect, body_color)
	draw_rect(rect, Color.WHITE, false, 3.0)
	draw_circle(Vector2(facing * size.x * 0.25, -size.y + 25), 7, Color.WHITE)
	if state == State.ATTACK and current_attack != null:
		var box := current_attack.hitbox
		if facing < 0:
			box.position.x = -box.position.x - box.size.x
		var alpha := 1.0 if current_attack.is_active(state_frame) else 0.3
		draw_rect(box, Color(1, 1, 1, alpha))


# ── 그림 인형 (Puppet) 자세 ───────────────────────────────
## 그림 한 장을 크게 구부리면 옷과 이펙트가 늘어나서 깨진다. 그래서 움직임은 "작게":
##   숨쉬기(몸통만 살짝), 몸 전체 기울이기/밀기/찌그러뜨리기 + 잔상·번쩍임 이펙트
## 자세별 그림(assets/characters/<id>_<자세>.png)이 있으면 그 상태에서는 그 그림으로 바꿔 끼운다
##   자세: punch(P/S/HS/D 공격) kick(K 공격) guard hit crouch jump
const POSES: Array[String] = ["punch", "kick", "guard", "hit", "crouch", "jump"]


func _draw_puppet(shake_x: float) -> void:
	var tint := art_modulate
	match state:
		State.HITSTUN, State.KO:
			tint = tint * Color(1.0, 0.8, 0.8)
		State.GUARD, State.BLOCKSTUN:
			tint = tint * Color(0.85, 0.88, 1.0)
	if armor_flash > 0:
		tint = tint.lerp(Color(1, 0.85, 0.4), armor_flash / 24.0)
	var body := _body_motion()
	var pose_tex := _pose_texture()
	_draw_tex(pose_tex, shake_x, tint, body)
	if state == State.GUARD or state == State.BLOCKSTUN:
		_draw_guard_shield()
	# 휘두르기 잔상(_draw_swing)은 자세 그림이 생긴 뒤로 오히려 어색해서 끔. 판정은 트레이닝의 "판정 보기"로


var _anchor_cache := {}


## 자세 그림을 세울 기준점. 앉기/가드 그림은 발을 넓게 벌려서 발 가운데를 기준으로 하면 몸이 앞으로 쏠려 보인다.
## 그래서 머리가 서 있을 때(기본 그림)와 같은 x에 오도록 맞춘다 = 제자리에서 앉거나 막는 것처럼
const HEAD_ALIGNED_POSES: Array[String] = ["_crouch"]  # _crouch_guard도 포함됨
## 서서 가드(<id>_guard)는 팔/무기를 머리 위로 드는 그림이 있어서 머리 대신 허리(그림 높이 45~65%)를 맞춘다
const HIP_BAND := Vector2(0.45, 0.65)


func _anchor_for(tex: Texture2D) -> Vector2:
	if _anchor_cache.has(tex):
		return _anchor_cache[tex]
	var a := Puppet.find_anchor(tex)
	var file := tex.resource_path.get_file()
	if file.begins_with(char_id + "_guard"):
		var stand_hip := (Puppet.band_x(puppet.texture, HIP_BAND.x, HIP_BAND.y) - puppet.anchor.x) * puppet.scale
		var s := _pose_scale() * _pose_size(tex)
		a.x = Puppet.band_x(tex, HIP_BAND.x, HIP_BAND.y) - stand_hip / s
	elif HEAD_ALIGNED_POSES.any(func(p: String) -> bool: return file.contains(p)):
		var stand_head := (Puppet.head_x(puppet.texture) - puppet.anchor.x) * puppet.scale  # 게임 좌표
		var s := _pose_scale() * _pose_size(tex)
		a.x = Puppet.head_x(tex) - stand_head / s
	_anchor_cache[tex] = a
	return a


## 지금 그려지는 그림의 머리 꼭대기 (캐릭터 발 기준 게임 좌표, 오른쪽을 볼 때)
func _head_top() -> Vector2:
	var tex := _pose_texture()
	var a := puppet.anchor
	var s := puppet.scale
	if tex != null:
		a = _anchor_for(tex)
		s = _pose_scale() * _pose_size(tex)
	else:
		tex = puppet.texture
	return Vector2((Puppet.head_x(tex) - a.x) * s, (Puppet.top_row(tex) - a.y) * s)


## 자세 그림 하나 그리기 (null이면 숨쉬는 기본 그림)
func _draw_tex(tex: Texture2D, shake_x: float, tint: Color, body: Transform2D) -> void:
	if tex != null:
		Puppet.draw_image(self, tex, _pose_scale() * _pose_size(tex), facing, Vector2(shake_x, 0), tint, body, _anchor_for(tex))
	else:
		_breathe()
		puppet.draw(self, facing, Vector2(shake_x, 0), tint, body)


## 자세 그림 크기: 포즈 시트는 기본 그림보다 작게 그려져 있어서, punch/guard/hit 자세 키의 중간값을
## 기본 그림의 키와 같다고 보고 비율을 맞춘다 (날아간 소품 등 한 자세만 튀어도 괜찮게).
## rigs.gd에 "pose_ratio"를 적으면 그 값을 쓴다
var _pose_scale_cache := 0.0

## 자세별 크기 보정: AI가 포즈 시트에서 웅크린 자세를 다른 자세보다 작게 그리는 경향이 있어서
## (같은 시트 안에서도 얼굴이 약 80% 크기) 웅크린 그림만 키운다. rigs.gd의 "pose_size"로 캐릭터마다 바꿀 수 있음
const POSE_SIZE := {"crouch": 1.2}


func _pose_size(tex: Texture2D) -> float:
	var pose := tex.resource_path.get_file().get_basename().trim_prefix(char_id + "_")
	var sizes: Dictionary = Rigs.get_rig(char_id).get("pose_size", POSE_SIZE)
	return sizes.get(pose, 1.0)


func _pose_scale() -> float:
	if _pose_scale_cache == 0.0:
		var ratio: float = Rigs.get_rig(char_id).get("pose_ratio", 0.0)
		if ratio == 0.0:
			var heights: Array[float] = []
			for pose in ["punch", "guard", "hit"]:
				var tex := Game.load_texture("res://assets/characters/%s_%s.png" % [char_id, pose])
				if tex != null:
					heights.append(Puppet.height_of(tex))
			if not heights.is_empty():
				heights.sort()
				ratio = heights[heights.size() / 2] / puppet.art_height
		_pose_scale_cache = puppet.scale / ratio if ratio > 0.0 else puppet.scale
	return _pose_scale_cache


## 서서 쓰는 손 기본기 그림. 길티기어처럼 S·HS는 무기 공격이라 "slash"(S), "heavy"(HS) 그림을 따로 쓸 수 있다.
## 그림이 없으면 한 단계 가벼운 그림으로 (HS → S → 펀치)
const STAND_POSES := {"5S": ["slash", "punch"], "5H": ["heavy", "slash", "punch"]}


func _stand_pose(move: String) -> String:
	for n: String in STAND_POSES.get(move, ["punch"]):
		if Game.load_texture("res://assets/characters/%s_%s.png" % [char_id, n]) != null:
			return n
	return "punch"


## 지금 상태에 맞는 자세 그림 (없으면 null → 기본 그림)
func _pose_texture() -> Texture2D:
	# 앞에 있는 이름부터 찾아서 그림이 있는 걸 쓴다 (없으면 다음 이름, 다 없으면 기본 그림)
	var names: Array[String] = []
	match state:
		State.ATTACK:
			if current_attack != null:
				var a := current_attack
				var special := a.name.ends_with("D") or a.is_throw
				if special:  # 필살기/잡기 전용 그림은 시작부터 끝까지
					names.append("throw" if a.is_throw else a.name.to_lower())  # 예: chemikid_6d.png
				if special or a.startup < state_frame:
					if a.name.begins_with("2"):
						names.append("crouch")  # 앉아서 쓰는 기술은 앉은 그림으로
					elif a.name.begins_with("j") and not _is_kick(a):
						names.append_array(["jump_attack", "punch"])
					else:
						names.append("kick" if _is_kick(a) else _stand_pose(a.name))
		State.STAND:
			if velocity.x != 0.0:
				if velocity.x * facing < 0.0:
					names.append("walk_back")
				names.append_array([_walk_frame(), "walk"])
			elif opponent != null and opponent.state == State.KO and is_on_ground():
				names.append("win")
		State.RUN:
			names.append_array(["dash", "walk"])
		State.BACKDASH:
			names.append_array(["backdash", "walk_back"])
		State.GUARD, State.BLOCKSTUN:
			if _held("down") and is_on_ground():
				names.append("crouch_guard")
			names.append("guard")
		State.HITSTUN:
			names.append("hit")
		State.KO:
			if is_on_ground() and state_frame > 6:
				names.append("down")  # 쓰러져 누운 그림
			names.append("hit")
		State.CROUCH, State.PREJUMP:
			names.append("crouch")
		State.AIR:
			names.append("jump")
		State.AIRDASH:
			names.append_array(["air_dash", "dash", "jump"])
	for n in names:
		var tex := Game.load_texture("res://assets/characters/%s_%s.png" % [char_id, n])
		if tex != null:
			return tex
	return null


const WALK_FRAME_TIME := 8    # 걷기 그림(walk, walk2, walk3, walk4)을 바꾸는 간격 (프레임). 4장이면 한 걸음 바퀴 = 32프레임
var _walk_count := -1         # 이 캐릭터의 걷기 그림 장수 (처음 한 번 센다)


## 지금 보여줄 걷기 그림 이름. 있는 장수만큼 돌아간다 (1장이면 walk만, 2장이면 walk↔walk2 ...)
func _walk_frame() -> String:
	if _walk_count < 0:
		_walk_count = 0
		for n in ["walk", "walk2", "walk3", "walk4"]:
			if Game.load_texture("res://assets/characters/%s_%s.png" % [char_id, n]) == null:
				break
			_walk_count += 1
	if _walk_count <= 1:
		return "walk"
	var i := int(_anim_t / WALK_FRAME_TIME) % _walk_count
	return "walk" if i == 0 else "walk%d" % (i + 1)


func _is_kick(a: AttackData) -> bool:
	return "K" in a.name.substr(1) and not a.is_throw


## 숨쉬기: 발은 바닥에 두고 몸통과 머리만 아주 살짝
func _breathe() -> void:
	var p := puppet
	var b := sin(_anim_t * 0.05) if state == State.STAND and velocity.x == 0.0 else 0.0
	p.pose({"torso": b * 0.015, "head": -b * 0.015}, Vector2(0, 6 + b * 6), 0.0, {},
			{"leg_f1": p.joint("fl_ft"), "leg_b1": p.joint("bl_ft")})


## 몸 전체 움직임 (발 기준). 오른쪽을 볼 때 기준이고, 왼쪽을 보면 알아서 뒤집힌다
## tilt: + = 앞으로 숙임, squash: 세로 비율(1보다 작으면 납작), shift: 밀기(px)
func _body_motion() -> Transform2D:
	var tilt := 0.0
	var squash := 1.0
	var shift := Vector2.ZERO
	match state:
		State.STAND:
			if velocity.x != 0.0:
				# 걷기 그림이 있으면 그림이 발걸음을 보여주니까 몸은 그대로 (위아래로 흔들면 발이 바닥에서 뜸).
				# 없으면 (같은 그림으로 미끄러지면 어색해서) 걸음마다 무게를 싣는 느낌으로 살짝 기울였다 폄
				if _pose_texture() == null:
					var w := absf(sin(_anim_t * PI / WALK_FRAME_TIME))
					tilt = (0.02 + 0.03 * w) * (1.0 if velocity.x * facing > 0.0 else -1.0)
					squash = 1.0 - 0.02 * (1.0 - w)
		State.RUN:
			tilt = 0.12  # 앞으로 숙임 (발 기준으로 기울여서 발은 바닥에 그대로)
		State.BACKDASH:
			tilt = -0.1
		State.CROUCH:
			if _pose_texture() == null:
				squash = 0.72
				tilt = 0.08
		State.PREJUMP:
			squash = 0.88
		State.AIR:
			squash = 1.04 if velocity.y < 0.0 else 1.0
			tilt = 0.05 if velocity.y > 0.0 else 0.0
		State.AIRDASH:
			tilt = 0.2
		State.GUARD:
			tilt = -0.05
			squash = 0.97
		State.BLOCKSTUN:
			tilt = -0.07
			shift.x = -6.0 if state_frame < 6 else 0.0
		State.HITSTUN:
			var k := clampf(1.0 - (state_frame - 3) / 18.0, 0.3, 1.0)
			tilt = -0.18 * k
			shift.x = -10.0 * k
		State.KO:
			if is_on_ground():
				tilt = -1.45 * minf(state_frame / 12.0, 1.0)  # 뒤로 쓰러짐
			else:
				tilt = -0.5
		State.ATTACK:
			var reach := _attack_reach()
			var wind := 1.0 - reach if state_frame <= current_attack.startup else 0.0
			if _is_kick(current_attack):
				tilt = -0.06 * reach
			else:
				tilt = 0.08 * reach - 0.04 * wind
			shift.x = 12.0 * reach - 4.0 * wind
			squash = 1.0 - 0.03 * reach
			if current_attack.name.begins_with("2") and _pose_texture() == null:
				squash *= 0.75
	# 발을 기준으로 기울이고(tilt), 세로로 찌그러뜨리고(squash), 가로는 그만큼 살짝 넓힌다
	return Transform2D(0.0, shift) * Transform2D(tilt, Vector2.ZERO) \
			* Transform2D(0.0, Vector2(1.0 + (1.0 - squash) * 0.4, squash), 0.0, Vector2.ZERO)


## 공격 진행도: 발생 동안 0 → 1, 지속 동안 1, 후딜 동안 1 → 0
func _attack_reach() -> float:
	var a := current_attack
	var f := state_frame
	if f <= a.startup:
		return float(f) / maxf(1.0, a.startup)
	if f <= a.startup + a.active:
		return 1.0
	return clampf(1.0 - float(f - a.startup - a.active) / maxf(1.0, a.recovery), 0.0, 1.0)


## 가드: 몸 앞에 반투명 방패 (그림을 구부리는 대신)
func _draw_guard_shield() -> void:
	var low := _held("down")
	var center := Vector2(facing * 80, -60 if low else -95)
	var start := -PI * 0.4 if facing > 0 else PI * 0.6
	var flash := 1.0 if state == State.BLOCKSTUN and state_frame < 6 else 0.0
	var col := Color(0.55, 0.8, 1.0, 0.55 + 0.4 * flash)
	draw_arc(center, 70 if not low else 55, start, start + PI * 0.8, 20, col, 6.0 + 4.0 * flash)
	draw_arc(center, 58 if not low else 45, start + 0.15, start + PI * 0.8 - 0.15, 16, Color(col, col.a * 0.5), 3.0)


## 휘두르기 잔상: 공격 판정이 살아 있는 동안 판정을 쓸고 지나가는 초승달 모양
func _draw_swing() -> void:
	if state != State.ATTACK or current_attack == null or current_attack.is_throw:
		return
	var a := current_attack
	if not a.is_active(state_frame) or not a.hitbox.has_area():
		return
	var t := float(state_frame - a.startup) / maxf(1.0, a.active)  # 0 → 1
	var box := a.hitbox
	var pivot := Vector2(0, box.get_center().y + 10)
	var r_out := box.end.x - pivot.x
	var r_in := maxf(10.0, box.position.x - pivot.x)
	var a0 := (Vector2(box.end.x, box.position.y) - pivot).angle()
	var a1 := (Vector2(box.end.x, box.end.y) - pivot).angle()
	var pts := PackedVector2Array()
	var n := 10
	for i in n + 1:
		var ang := lerpf(a0, a1, float(i) / n)
		pts.append(pivot + Vector2(r_out, 0).rotated(ang))
	for i in range(n, -1, -1):
		var ang := lerpf(a0, a1, float(i) / n)
		var r := lerpf(r_in, r_out, 0.55 + 0.45 * absf(float(i) / n - 0.5) * 2.0)
		pts.append(pivot + Vector2(r, 0).rotated(ang))
	for i in pts.size():
		pts[i].x *= facing
	draw_colored_polygon(pts, Color(color.lightened(0.6), 0.55 * (1.0 - t * 0.6)))
	draw_polyline(pts.slice(0, n + 1), Color(1, 1, 1, 0.9 * (1.0 - t * 0.5)), 4.0)
