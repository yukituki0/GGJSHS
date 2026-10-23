extends Node
## 입력 관리자 (Autoload 싱글톤, 이름: InputManager)
##
## 게임 코드는 항상 "p1_left", "p2_hs" 같은 액션 이름만 쓴다.
## 키보드 모드 / 조이스틱 모드를 바꾸면 각 액션에 연결된 실제 입력만 갈아끼운다.
## 그래서 캐릭터 코드는 지금 어떤 모드인지 몰라도 된다.

enum Mode { KEYBOARD, JOYSTICK }

signal mode_changed(new_mode: Mode)

## 플레이어마다 공통으로 쓰는 액션 이름 (앞에 "p1_" / "p2_"가 붙는다)
## 길티기어처럼 버튼은 6개(P K S HS D RC). 대시(→→ / ←←)와 가드(← 누르기)는 스틱으로 한다
const ACTIONS: Array[String] = [
	"up", "down", "left", "right",
	"p", "k", "s", "hs", "d",
	"rc", "start", "select",
]

## 키보드 배치 (physical_keycode 기준 = 키보드 언어 설정과 상관없이 "자리"로 인식)
const KEYBOARD_MAP := {
	1: {
		"up": KEY_W, "down": KEY_S, "left": KEY_A, "right": KEY_D,
		"p": KEY_Y, "k": KEY_U, "s": KEY_I, "hs": KEY_K,
		"d": KEY_H, "rc": KEY_J,
		"start": KEY_1, "select": KEY_2,
	},
	2: {
		"up": KEY_UP, "down": KEY_DOWN, "left": KEY_LEFT, "right": KEY_RIGHT,
		"p": KEY_KP_4, "k": KEY_KP_5, "s": KEY_KP_6, "hs": KEY_KP_3,
		"d": KEY_KP_1, "rc": KEY_KP_2,
		"start": KEY_0, "select": KEY_9,
	},
}

## 조이스틱 버튼 번호 (임시값!)
## 실물 키트가 오면 Gamepad Tester로 버튼 번호를 확인해서 여기만 고치면 된다.
const JOY_BUTTON_MAP := {
	"p": 0, "k": 1, "s": 2, "hs": 3,
	"d": 4, "rc": 5,
	"start": 9, "select": 8,
}

## 조이스틱은 축(axis)으로 들어올 수도, 방향 버튼(D-pad)으로 들어올 수도 있어서 둘 다 등록한다.
const JOY_DIRECTION_MAP := {
	"up":    { "axis": JOY_AXIS_LEFT_Y, "value": -1.0, "button": JOY_BUTTON_DPAD_UP },
	"down":  { "axis": JOY_AXIS_LEFT_Y, "value":  1.0, "button": JOY_BUTTON_DPAD_DOWN },
	"left":  { "axis": JOY_AXIS_LEFT_X, "value": -1.0, "button": JOY_BUTTON_DPAD_LEFT },
	"right": { "axis": JOY_AXIS_LEFT_X, "value":  1.0, "button": JOY_BUTTON_DPAD_RIGHT },
}

## 아케이드 스틱은 디지털이라 축 값이 0 아니면 ±1로 튄다. 0.5면 충분히 안전하다.
const DEADZONE := 0.5

var mode: Mode = Mode.KEYBOARD

## 키 설정 화면에서 바꾼 배치 (기본값과 다른 것만). 플레이어 → { 액션: 키 코드 / 버튼 번호 }
var custom_keys := {1: {}, 2: {}}
var custom_joy := {1: {}, 2: {}}


func _ready() -> void:
	set_mode(Mode.KEYBOARD)


func _unhandled_input(event: InputEvent) -> void:
	# F1: 조작 모드 토글 (축제 현장에서 급하게 바꿀 때)
	if event is InputEventKey and event.pressed and not event.echo \
			and event.physical_keycode == KEY_F1:
		toggle_mode()


func toggle_mode() -> void:
	set_mode(Mode.JOYSTICK if mode == Mode.KEYBOARD else Mode.KEYBOARD)


func set_mode(new_mode: Mode) -> void:
	mode = new_mode
	for player in [1, 2]:
		for action in ACTIONS:
			var id := action_name(player, action)
			if not InputMap.has_action(id):
				InputMap.add_action(id, DEADZONE)
			InputMap.action_erase_events(id)
			for event in _events_for(player, action):
				InputMap.action_add_event(id, event)
	mode_changed.emit(mode)


## 예: action_name(1, "hs") -> "p1_hs"
func action_name(player: int, action: String) -> String:
	return "p%d_%s" % [player, action]


## 지금 쓰는 키보드 키 / 조이스틱 버튼 (키 설정에서 바꿨으면 그 값)
func key_for(player: int, action: String) -> int:
	return custom_keys[player].get(action, KEYBOARD_MAP[player][action])


func joy_button_for(player: int, action: String) -> int:
	return custom_joy[player].get(action, JOY_BUTTON_MAP.get(action, -1))


## 키 설정: player의 action을 code(키보드 키 또는 조이스틱 버튼)로. 같은 키를 쓰던 다른 액션과는 서로 바꾼다
func bind(player: int, action: String, code: int) -> void:
	var keyboard := mode == Mode.KEYBOARD
	var table: Dictionary = custom_keys[player] if keyboard else custom_joy[player]
	var old := key_for(player, action) if keyboard else joy_button_for(player, action)
	for other: String in ACTIONS:
		if other == action:
			continue
		var cur := key_for(player, other) if keyboard else joy_button_for(player, other)
		if cur == code:
			table[other] = old  # 겹치면 맞바꿈
	table[action] = code
	set_mode(mode)


func reset_bindings() -> void:
	custom_keys = {1: {}, 2: {}}
	custom_joy = {1: {}, 2: {}}
	set_mode(mode)


func _events_for(player: int, action: String) -> Array[InputEvent]:
	var events: Array[InputEvent] = []
	if mode == Mode.KEYBOARD:
		var key := InputEventKey.new()
		key.physical_keycode = key_for(player, action) as Key
		events.append(key)
	else:
		var device := player - 1  # 먼저 꽂힌 인코더 = 1P(device 0), 다음 = 2P(device 1)
		if action in JOY_DIRECTION_MAP:
			var dir: Dictionary = JOY_DIRECTION_MAP[action]
			var motion := InputEventJoypadMotion.new()
			motion.device = device
			motion.axis = dir["axis"]
			motion.axis_value = dir["value"]
			events.append(motion)
			var dpad := InputEventJoypadButton.new()
			dpad.device = device
			dpad.button_index = dir["button"]
			events.append(dpad)
		elif action in JOY_BUTTON_MAP:
			var button := InputEventJoypadButton.new()
			button.device = device
			button.button_index = joy_button_for(player, action) as JoyButton
			events.append(button)
	return events
