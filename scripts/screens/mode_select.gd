extends Screen
## 모드 선택: 대전 / CPU 대전 / 트레이닝 / 조작법 / 조작 장치 전환 / 언어

## 항목 순서 (글자는 _items()에서)
enum Item { VERSUS, CPU, TRAINING, CONTROLS, INPUT, LANGUAGE }

var cursor := 0


func _items() -> Array:
	var input_name := Game.t("keyboard" if InputManager.mode == InputManager.Mode.KEYBOARD else "joystick")
	return [
		Game.t("versus"),
		"%s: < %s >" % [Game.t("vs_cpu"), Game.t(Game.CPU_LEVEL_KEYS[Game.cpu_level])],
		Game.t("training"),
		Game.t("controls"),
		"%s: %s" % [Game.t("input"), input_name],
		"%s: %s" % [Game.t("language"), Game.t("language_name")],
	]


func _process(delta: float) -> void:
	super(delta)
	cursor = move_cursor(cursor, _items().size())
	# CPU 대전 항목에서 좌우 = 난이도
	if cursor == Item.CPU:
		var levels := Game.CPU_LEVEL_KEYS.size()
		if Game.menu_pressed("left"):
			Game.cpu_level = (Game.cpu_level - 1 + levels) % levels
			Sfx.play("menu_move")
		elif Game.menu_pressed("right"):
			Game.cpu_level = (Game.cpu_level + 1) % levels
			Sfx.play("menu_move")
	if Game.menu_back():
		Game.goto("title")
	elif Game.menu_confirm():
		match cursor:
			Item.VERSUS:
				Game.mode = Game.Mode.VERSUS
				Game.goto("char_select")
			Item.CPU:
				Game.mode = Game.Mode.CPU
				Game.goto("char_select")
			Item.TRAINING:
				Game.mode = Game.Mode.TRAINING
				Game.goto("char_select")
			Item.CONTROLS:
				Game.goto("controls")
			Item.INPUT:
				InputManager.toggle_mode()
			Item.LANGUAGE:
				Game.toggle_language()


func _draw() -> void:
	background()
	header(Game.t("select_mode"))
	menu_list(_items(), cursor, 200, 60, 28)
	var help := [
		Game.t("help_versus") % Game.ROUNDS_TO_WIN,
		Game.t("help_cpu"),
		Game.t("help_training"),
		Game.t("help_controls"),
		Game.t("help_input"),
		Game.t("help_language"),
	]
	Style.fill(self, Style.slant(W / 2 - 400, 566, 800, 46, 14), Color(Style.BLACK, 0.8))
	text(help[cursor], 598, 22, Style.GOLD, W / 2, 0)
	text(Game.t("menu_hint"), 690, 18, Style.GRAY, W / 2, 0)
