extends Screen
## 타이틀 화면: 아무나 START(또는 P)를 누르면 모드 선택으로


func _process(delta: float) -> void:
	super(delta)
	if frame > 20 and Game.menu_confirm():
		Game.goto("mode_select")


func _draw() -> void:
	background()
	# 제목: 위에서 떨어지며 등장
	var drop := maxf(0.0, 1.0 - frame / 25.0)
	var y := 300 - drop * 200
	text(Game.GAME_TITLE, y + 6, 120, Color(0, 0, 0, 0.5), W / 2 + 6)  # 그림자
	text(Game.GAME_TITLE, y, 120, Color.WHITE)
	draw_rect(Rect2(W / 2 - 380, y + 30, 760, 8), ACCENT)
	text(Game.t("subtitle"), y + 80, 26, Color(0.85, 0.85, 0.9))
	# 깜빡이는 PRESS START
	if frame > 25 and frame % 60 < 30:
		text(Game.t("press_start"), 560, 40, Color.YELLOW)
	text(Game.t("f1_hint"), 690, 16, Color(1, 1, 1, 0.4))
