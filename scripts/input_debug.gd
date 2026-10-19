extends Node2D
## 입력 테스트 화면 (임시)
## 지금 눌린 액션을 1P / 2P별로 보여준다. F1로 조작 모드 전환.
## 캐릭터가 생기면 이 화면은 지울 예정.

var _label: Label


func _ready() -> void:
	_label = Label.new()
	_label.position = Vector2(40, 40)
	_label.add_theme_font_size_override("font_size", 28)
	add_child(_label)


func _process(_delta: float) -> void:
	var mode_text := "KEYBOARD" if InputManager.mode == InputManager.Mode.KEYBOARD else "JOYSTICK"
	var lines: Array[String] = ["MODE: %s   (F1 = toggle)" % mode_text, ""]
	for player in [1, 2]:
		var pressed: Array[String] = []
		for action in InputManager.ACTIONS:
			if Input.is_action_pressed(InputManager.action_name(player, action)):
				pressed.append(action.to_upper())
		lines.append("%dP: %s" % [player, " ".join(pressed)])
	lines.append("")
	lines.append("JOYPADS: %s" % _joypad_names())
	_label.text = "\n".join(lines)


func _joypad_names() -> String:
	var names: Array[String] = []
	for device in Input.get_connected_joypads():
		names.append("#%d %s" % [device, Input.get_joy_name(device)])
	return "none" if names.is_empty() else ", ".join(names)
