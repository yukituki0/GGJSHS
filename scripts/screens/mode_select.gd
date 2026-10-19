extends Screen
## 모드 선택: 대전 / 트레이닝 / 조작법 / 조작 장치 전환 / 언어

var cursor := 0


func _items() -> Array:
	var input_name := Game.t("keyboard" if InputManager.mode == InputManager.Mode.KEYBOARD else "joystick")
	return [
		Game.t("versus"),
		Game.t("training"),
		Game.t("controls"),
		"%s: %s" % [Game.t("input"), input_name],
		"%s: %s" % [Game.t("language"), Game.t("language_name")],
	]


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
			4:
				Game.toggle_language()


func _draw() -> void:
	background()
	header(Game.t("select_mode"))
	menu_list(_items(), cursor, 220)
	var help := [
		Game.t("help_versus") % Game.ROUNDS_TO_WIN,
		Game.t("help_training"),
		Game.t("help_controls"),
		Game.t("help_input"),
		Game.t("help_language"),
	]
	Style.fill(self, Style.slant(W / 2 - 400, 556, 800, 46, 14), Color(Style.BLACK, 0.8))
	text(help[cursor], 588, 22, Style.GOLD, W / 2, 0)
	text(Game.t("menu_hint"), 690, 18, Style.GRAY, W / 2, 0)
