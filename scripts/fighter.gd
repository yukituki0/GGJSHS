class_name Fighter
extends Node2D
## 캐릭터 공통 몸통: 이동, 앉기, 점프(2단), 대시/백스텝, 공중 대시
##
## 격투겜은 "프레임" 단위로 생각하는 게 편해서, 모든 시간 값은 프레임(1/60초) 단위다.
## 물리 엔진은 쓰지 않고 위치를 직접 계산한다 (격투겜은 정확한 제어가 더 중요해서).
## 캐릭터별 기술은 나중에 이 클래스를 상속해서 추가한다.

enum State { STAND, CROUCH, RUN, BACKDASH, PREJUMP, AIR, AIRDASH }

# ── 튜닝 값 (단위: 픽셀 / 프레임) ─────────────────────────
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

# ── 몸 크기 (임시 네모 그래픽 + 밀어내기 판정) ─────────────
const BODY_SIZE := Vector2(70, 160)
const CROUCH_SIZE := Vector2(80, 100)

var player := 1                 # 1P / 2P
var color := Color.RED
var opponent: Fighter
var ground_y := 600.0           # 바닥 높이 (Match가 정해줌)

var state: State = State.STAND
var velocity := Vector2.ZERO
var facing := 1                 # 1 = 오른쪽을 봄, -1 = 왼쪽을 봄
var state_frame := 0            # 현재 상태에 들어온 뒤 지난 프레임 수
var air_actions_left := 0
var _jump_dir := 0              # 점프 직전에 정한 방향 (-1 뒤, 0 제자리, 1 앞)


## 1프레임 진행. Match가 매 프레임 1P → 2P 순서로 직접 호출한다 (처리 순서를 고정하려고)
func tick() -> void:
	state_frame += 1
	_update_state()
	position += velocity
	queue_redraw()


# ── 입력 헬퍼 ─────────────────────────────────────────────
func _held(action: String) -> bool:
	return Input.is_action_pressed(InputManager.action_name(player, action))


func _pressed(action: String) -> bool:
	return Input.is_action_just_pressed(InputManager.action_name(player, action))


## 좌우 입력을 "상대 기준"으로 바꿔준다: 1 = 앞(상대 쪽), -1 = 뒤, 0 = 없음
func _input_forward() -> int:
	var x := int(_held("right")) - int(_held("left"))
	return x * facing


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


## 서 있거나 앉아 있을 때: 걷기, 앉기, 점프, 대시 시작
func _ground_neutral() -> void:
	_face_opponent()
	var fwd := _input_forward()

	if _held("up"):
		_start_prejump(fwd)
		return
	if _pressed("dash"):
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
	elif fwd < 0:
		velocity.x = -walk_back_speed * facing
	else:
		velocity.x = 0


## 달리기: 대시 버튼이나 앞 방향을 누르고 있는 동안 계속 달린다
func _run() -> void:
	if _held("up"):
		_start_prejump(1)
		return
	var fwd := _input_forward()
	if fwd >= 0 and (_held("dash") or fwd > 0):
		velocity.x = run_speed * facing
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


## 공중: 중력, 2단 점프, 공중 대시, 착지
func _air() -> void:
	velocity.y += gravity

	if air_actions_left > 0:
		if _pressed("up"):
			air_actions_left -= 1
			velocity = Vector2(_input_forward() * jump_forward_speed * facing, double_jump_velocity)
		elif _pressed("dash"):
			air_actions_left -= 1
			var dir := -1 if _input_forward() < 0 else 1
			velocity = Vector2(dir * airdash_speed * facing, 0)
			_change_state(State.AIRDASH)
			return

	if position.y + velocity.y >= ground_y:
		_land()


## 공중 대시: 정해진 프레임 동안 중력 없이 수평으로 날아간다
func _airdash() -> void:
	velocity.y = 0
	if state_frame >= airdash_frames:
		velocity.x *= 0.4  # 대시가 끝나면 속도를 줄이고 다시 떨어진다
		_change_state(State.AIR)


func _land() -> void:
	position.y = ground_y
	velocity = Vector2.ZERO
	_change_state(State.STAND)


## 땅에 있을 때만 상대 쪽을 바라본다 (공중에서는 방향 고정)
func _face_opponent() -> void:
	if opponent == null:
		return
	if opponent.position.x > position.x + 1:
		facing = 1
	elif opponent.position.x < position.x - 1:
		facing = -1


# ── 판정용 몸통 (밀어내기에 사용) ─────────────────────────
func body_size() -> Vector2:
	return CROUCH_SIZE if state == State.CROUCH or state == State.PREJUMP else BODY_SIZE


## 발 위치(position)를 기준으로 한 몸통 사각형
func body_rect() -> Rect2:
	var size := body_size()
	return Rect2(position.x - size.x / 2, position.y - size.y, size.x, size.y)


# ── 임시 그래픽 ───────────────────────────────────────────
func _draw() -> void:
	var size := body_size()
	var rect := Rect2(-size.x / 2, -size.y, size.x, size.y)
	draw_rect(rect, color)
	draw_rect(rect, Color.WHITE, false, 3.0)
	# 바라보는 방향 표시 (눈)
	draw_circle(Vector2(facing * size.x * 0.25, -size.y + 25), 7, Color.WHITE)
	# 디버그: 현재 상태 이름
	draw_string(ThemeDB.fallback_font, Vector2(-size.x / 2, -size.y - 10),
			State.keys()[state], HORIZONTAL_ALIGNMENT_LEFT, -1, 18)
