class_name Fighter
extends Node2D
## 캐릭터 공통 몸통: 이동, 점프(2단), 대시/백스텝, 공중 대시, 공격, 가드, 피격
##
## 격투겜은 "프레임" 단위로 생각하는 게 편해서, 모든 시간 값은 프레임(1/60초) 단위다.
## 물리 엔진은 쓰지 않고 위치를 직접 계산한다 (격투겜은 정확한 제어가 더 중요해서).
## 캐릭터별 기술은 나중에 이 클래스를 상속해서 _build_attacks()를 바꾸면 된다.

signal projectile_spawned(projectile: Projectile)  # Match가 받아서 관리
signal super_flash(fighter: Fighter, attack: AttackData)  # 오버드라이브 컷인 (Match가 화면을 잠깐 멈춤)
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
## 입력 버퍼에 기억해 둘 버튼 (누르는 "순간"이 중요한 것들)
const BUFFERED_ACTIONS: Array[String] = ["hs", "s", "k", "p", "d", "dash", "up", "rc"]
const HISTORY_FRAMES := 60      # 위치 기록 길이 (커몬 Ctrl+Z 등에서 사용)

var player := 1                 # 1P / 2P
var color := Color.RED
var display_name := ""
var input_enabled := true       # 라운드 시작 전/끝난 뒤에는 Match가 입력을 막는다
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

var attacks := {}               # "5P" -> AttackData
var current_attack: AttackData
var attack_connected := false   # 이번 공격이 이미 맞았거나 막혔나 (한 번만 판정 + 개틀링 조건)
var stun_frames := 0            # 히트스턴/가드스턴 남은 프레임
var _buffer := {}               # 액션 -> 남은 기억 프레임 (0이면 없음)
var tension := 0.0
var hit_shake := 0              # 히트스톱 동안 맞은 쪽이 부르르 떠는 남은 프레임
var rc_flash := 0               # 로만 캔슬 이펙트 남은 프레임
var history: Array[Vector2] = []  # 최근 위치 기록 (맨 앞이 가장 오래된 것)


func _ready() -> void:
	hp = max_hp
	_build_attacks()
	_build_specials()


## 1프레임 진행. Match가 매 프레임 1P → 2P 순서로 직접 호출한다 (처리 순서를 고정하려고)
func tick() -> void:
	state_frame += 1
	_update_buffer()
	_update_state()
	if state == State.ATTACK and current_attack != null and current_attack.move_speed != 0.0 \
			and state_frame <= current_attack.startup + current_attack.active:
		velocity.x = current_attack.move_speed * facing  # 돌진기
	position += velocity
	history.append(position)
	if history.size() > HISTORY_FRAMES:
		history.pop_front()
	if rc_flash > 0:
		rc_flash -= 1
	queue_redraw()


## 히트스톱 중에 Match가 tick() 대신 호출한다.
## 캐릭터는 멈춰 있지만, 이때 누른 버튼은 버퍼에 기억해 둔다 (히트스톱 중 개틀링 입력 가능)
func tick_frozen() -> void:
	for action in BUFFERED_ACTIONS:
		if input_enabled and Input.is_action_just_pressed(InputManager.action_name(player, action)):
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
	history.clear()
	_buffer.clear()
	_change_state(State.STAND)
	_face_opponent()


func add_tension(amount: float) -> void:
	tension = clampf(tension + amount, 0.0, MAX_TENSION)


# ── 기술 목록 (캐릭터마다 덮어쓸 부분) ─────────────────────
## Rect2(x, y, 너비, 높이): 오른쪽을 볼 때 기준, 발 위치가 (0, 0), 위쪽이 음수
func _build_attacks() -> void:
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


func _add(attack: AttackData) -> AttackData:
	attacks[attack.name] = attack
	return attack


# ── 캐릭터별로 덮어쓰는 부분 ──────────────────────────────
## 필살기 목록. 캐릭터 스크립트에서 _build_specials()를 덮어써서 "5D", "6D", "4D", "2D", "OD"를 추가
func _build_specials() -> void:
	pass


## 공격의 event_frame에 불린다 (투사체 만들기, 순간이동 등)
func _on_attack_event(_attack: AttackData) -> void:
	pass


## 내 공격이 맞았거나 막혔을 때 (블루스크린 효과 등)
func _on_attack_result(_attack: AttackData, _blocked: bool) -> void:
	pass


## 이 필살기를 지금 쓸 수 있나 (투사체는 화면에 하나만 등)
func _can_use_special(_attack_name: String) -> bool:
	return true


func spawn(projectile: Projectile) -> void:
	projectile.shooter = self
	projectile_spawned.emit(projectile)


# ── 입력 헬퍼 ─────────────────────────────────────────────
func _held(action: String) -> bool:
	return input_enabled and Input.is_action_pressed(InputManager.action_name(player, action))


## "최근 몇 프레임 안에 눌렀나" (입력 버퍼). 실제로 행동에 썼으면 _consume()으로 지운다
func _pressed(action: String) -> bool:
	return _buffer.get(action, 0) > 0


func _consume(action: String) -> void:
	_buffer[action] = 0


## 입력 버퍼: 누른 순간부터 input_buffer_frames 동안 "눌렀음"을 기억한다.
## 후딜 중에 조금 일찍 눌러도, 움직일 수 있게 되는 순간 바로 나간다.
func _update_buffer() -> void:
	for action in BUFFERED_ACTIONS:
		if input_enabled and Input.is_action_just_pressed(InputManager.action_name(player, action)):
			_buffer[action] = input_buffer_frames
		elif _buffer.get(action, 0) > 0:
			_buffer[action] -= 1


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
	var attack := _pressed_attack("2" if _held("down") else "5")
	if attack != "":
		_start_attack(attack)
		return
	if _held("guard"):
		velocity.x = 0
		_change_state(State.GUARD)
		return
	if _held("up"):
		_start_prejump(fwd)
		return
	if _pressed("dash"):
		_consume("dash")
		if fwd < 0:
			_change_state(State.BACKDASH)
		else:
			_change_state(State.RUN)
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


## 달리기: 대시 버튼이나 앞 방향을 누르고 있는 동안 계속 달린다
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
	if fwd >= 0 and (_held("dash") or fwd > 0):
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
	velocity.x = 0
	_change_state(State.PREJUMP)


## 점프 직전 웅크림. 끝나면 실제로 뛰어오른다
func _prejump() -> void:
	if state_frame >= prejump_frames:
		# 웅크리는 동안 방향을 바꿨으면 그걸 따른다
		var fwd := _input_forward()
		if fwd != 0:
			_jump_dir = fwd
		var speed := run_speed if _jump_dir > 0 and _held("dash") else jump_forward_speed
		velocity = Vector2(_jump_dir * speed * facing, jump_velocity)
		air_actions_left = air_actions
		_change_state(State.AIR)


## 공중: 중력, 공중 공격, 2단 점프, 공중 대시, 착지
func _air() -> void:
	velocity.y += gravity

	var attack := _pressed_attack("j")
	if attack != "":
		_start_attack(attack)
		return

	if air_actions_left > 0:
		if _pressed("up"):
			_consume("up")
			air_actions_left -= 1
			velocity = Vector2(_input_forward() * jump_forward_speed * facing, double_jump_velocity)
		elif _pressed("dash"):
			_consume("dash")
			air_actions_left -= 1
			var dir := -1 if _input_forward() < 0 else 1
			velocity = Vector2(dir * airdash_speed * facing, 0)
			_change_state(State.AIRDASH)
			return

	_check_landing()


## 공중 대시: 정해진 프레임 동안 중력 없이 수평으로 날아간다
func _airdash() -> void:
	velocity.y = 0
	if state_frame >= airdash_frames:
		velocity.x *= 0.4  # 대시가 끝나면 속도를 줄이고 다시 떨어진다
		_change_state(State.AIR)


## 가드 버튼을 누르고 있는 동안 (↓를 같이 누르면 앉아서 가드)
func _guard() -> void:
	_face_opponent()
	velocity.x = 0
	if not _held("guard"):
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
	if is_on_ground():
		velocity.x = 0
	_change_state(State.ATTACK)
	if current_attack.cost > 0:
		add_tension(-current_attack.cost)
	if attack_name == "OD":
		super_flash.emit(self, current_attack)


## 히트스턴/가드스턴: 시간이 다 지나면 다시 움직일 수 있다
func _stunned() -> void:
	if is_on_ground() and velocity.y >= 0:
		velocity.x *= ground_friction
		stun_frames -= 1
		if stun_frames <= 0:
			_change_state(State.GUARD if state == State.BLOCKSTUN and _held("guard") else State.STAND)
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
	return CROUCH_SIZE if low else BODY_SIZE


## 몸통 사각형 (밀어내기 + 맞는 판정 = 허트박스)
func body_rect() -> Rect2:
	var size := body_size()
	return Rect2(position.x - size.x / 2, position.y - size.y, size.x, size.y)


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
			or (_held("guard") and state in [State.STAND, State.CROUCH, State.AIR])
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


## 공격 시작부터 invuln_frames 동안은 무적
func is_invulnerable() -> bool:
	return state == State.ATTACK and current_attack != null and state_frame <= current_attack.invuln_frames


## Match가 호출: 공격을 받았다. 막았으면 true를 돌려준다
func receive_attack(attack: AttackData, from_dir: int) -> bool:
	if can_block(attack.level):
		add_tension(tension_guard_gain)
		stun_frames = attack.blockstun
		velocity.x = attack.pushback * from_dir
		_change_state(State.BLOCKSTUN)
		return true

	hp = maxi(hp - attack.damage, 0 if can_die else 1)
	hit_shake = attack.hitstop
	current_attack = null
	if hp == 0:
		velocity = Vector2(6.0 * from_dir, -10.0)
		_change_state(State.KO)
		return false
	stun_frames = attack.hitstun
	if is_on_ground():
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
	draw_rect(rect, body_color)
	draw_rect(rect, Color.WHITE, false, 3.0)
	# 로만 캔슬: 퍼져 나가는 원
	if rc_flash > 0:
		var t := 1.0 - rc_flash / 20.0
		draw_arc(Vector2(0, -size.y / 2), 40 + t * 160, 0, TAU, 48,
				Color(1, 0.2, 0.3, 1.0 - t), 6.0)
	# 바라보는 방향 표시 (눈)
	draw_circle(Vector2(facing * size.x * 0.25, -size.y + 25), 7, Color.WHITE)
	# 공격 중이면 히트박스 위치에 팔 모양을 그린다 (발생 중엔 흐리게, 지속 중엔 진하게)
	if state == State.ATTACK and current_attack != null:
		var box := current_attack.hitbox
		if facing < 0:
			box.position.x = -box.position.x - box.size.x
		var alpha := 1.0 if current_attack.is_active(state_frame) else 0.3
		draw_rect(box, Color(1, 1, 1, alpha))
	# 머리 위 1P / 2P 표시
	var tag_color := Color(1, 0.35, 0.35) if player == 1 else Color(0.35, 0.6, 1)
	draw_string(Game.FONT, Vector2(-40, -size.y - 12), "%dP" % player,
			HORIZONTAL_ALIGNMENT_CENTER, 80, 22, tag_color)
	if debug_draw_boxes:
		# 디버그: 현재 상태 이름
		var label: String = State.keys()[state]
		if current_attack != null:
			label += " " + current_attack.name
		draw_string(Game.FONT, Vector2(-size.x / 2, -size.y - 38),
				label, HORIZONTAL_ALIGNMENT_LEFT, -1, 16)
		draw_rect(rect, Color.GREEN, false, 2.0)
		var hit := hitbox_rect()
		if hit.has_area():
			hit.position -= position
			draw_rect(hit, Color.RED, false, 2.0)
