extends Screen
## 모드 선택: VERSUS / TRAINING / CONTROLS / 조작 모드 전환

var cursor := 0


func _items() -> Array:
	var input_name := "KEYBOARD" if InputManager.mode == InputManager.Mode.KEYBOARD else "JOYSTICK"
	return ["VERSUS", "TRAINING", "CONTROLS", "INPUT: " + input_name]


func _process(delta: float) -> void:
	super(delta)
	cursor = move_cursor(cursor, _items().size())
	if Game.menu_back():
		Game.goto("title")
	elif Game.menu_confirm():
		match cursor:
			0:
				Game.mode = Game.Mode.VERSUS
				Game.goto("char_select")
			1:
				Game.mode = Game.Mode.TRAINING
				Game.goto("char_select")
			2:
				Game.goto("controls")
			3:
				InputManager.toggle_mode()


func _draw() -> void:
	background()
	text("SELECT MODE", 130, 56)
	draw_rect(Rect2(W / 2 - 200, 150, 400, 4), ACCENT)
	menu_list(_items(), cursor, 280)
	var help := [
		"1P vs 2P. First to %d rounds wins." % Game.ROUNDS_TO_WIN,
		"Practice freely. HP refills, tension is always full.",
		"Check the button layout.",
		"Switch between keyboard and arcade stick (or press F1).",
	]
	text(help[cursor], 560, 22, Color(1, 1, 1, 0.7))
	text("P / START: OK      K: BACK", 680, 18, Color(1, 1, 1, 0.4))
