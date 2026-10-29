extends Screen
## 모드 선택: 게임 설명서 / 대전 / CPU 대전 / 트레이닝 / 설정집 / 조작법(키 설정) / 언어
## (키보드와 스틱은 항상 같이 입력돼서 조작 장치 전환 항목은 없다)


func _init() -> void:
	bg_name = "mode_select"  # assets/ui/bg_mode_select.png


## 항목 순서 (글자는 _items()에서)
enum Item { GUIDE, VERSUS, CPU, TRAINING, CHAR_BOOK, CONTROLS, LANGUAGE }

var cursor := 1  # 처음엔 대전에 커서 (설명서는 맨 위에 보이게)


func _items() -> Array:
	return [
		Game.t("guide"),
		Game.t("versus"),
		"%s: < %s >" % [Game.t("vs_cpu"), Game.t(Game.CPU_LEVEL_KEYS[Game.cpu_level])],
		Game.t("training"),
		Game.t("char_book"),
		Game.t("controls"),
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
			Item.GUIDE:
				Game.goto("guide")
			Item.VERSUS:
				Game.mode = Game.Mode.VERSUS
				Game.goto("char_select")
			Item.CPU:
				Game.mode = Game.Mode.CPU
				Game.goto("char_select")
			Item.TRAINING:
				Game.mode = Game.Mode.TRAINING
				Game.goto("char_select")
			Item.CHAR_BOOK:
				Game.goto("char_book")
			Item.CONTROLS:
				Game.goto("controls")
			Item.LANGUAGE:
				Game.toggle_language()


func _draw() -> void:
	background()
	header(Game.t("select_mode"))
	menu_list(_items(), cursor, 180, 50, 26)
	var help := [
		Game.t("help_guide"),
		Game.t("help_versus") % Game.ROUNDS_TO_WIN,
		Game.t("help_cpu"),
		Game.t("help_training"),
		Game.t("help_char_book"),
		Game.t("help_controls"),
		Game.t("help_language"),
	]
	Style.fill(self, Style.slant(W / 2 - 400, 566, 800, 46, 14), Color(Style.BLACK, 0.8))
	text(help[cursor], 598, 22, Style.GOLD, W / 2, 0)
	text(Game.t("menu_hint"), 690, 18, Style.GRAY, W / 2, 0)
