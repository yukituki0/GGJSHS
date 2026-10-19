extends Screen
## 타이틀 화면: 아무나 START(또는 P)를 누르면 모드 선택으로


func _process(delta: float) -> void:
	super(delta)
	if frame > 20 and Game.menu_confirm():
		Game.goto("mode_select")


func _draw() -> void:
	background()
	# 제목: 크게 시작해서 쾅 하고 자리 잡음
	var e := 1.0 - pow(1.0 - minf(frame / 22.0, 1.0), 3.0)
	var size := int(lerpf(260, 130, e))
	var y := 300.0
	Style.fill(self, Style.slant(W / 2 - 520 * e, y + 22, 1040 * e, 14, -30), Style.RED)
	text(Game.GAME_TITLE, y, size, Style.WHITE, W / 2, 16)
	if frame > 22:
		text(Game.t("subtitle"), y + 82, 24, Style.GOLD, W / 2, 4)
		# 깜빡이는 PRESS START
		if frame % 60 < 36:
			Style.fill(self, Style.slant(W / 2 - 220, 520, 440, 56, 18), Color(Style.BLACK, 0.8))
			text(Game.t("press_start"), 560, 36, Style.WHITE)
	text(Game.t("f1_hint") + "    F11: FULLSCREEN", 700, 16, Style.GRAY, W / 2, 0)
