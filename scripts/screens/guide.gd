extends Screen
## 게임 설명서: 격투 게임을 처음 해 보는 사람용 (축제 체험). 모드 선택 → 게임 설명서
## 좌우로 페이지를 넘긴다. 글은 아래 PAGES를 고치면 된다: [제목, [[굵은 글자, 설명], ...]] (영어, 한국어 순)

func _init() -> void:
	bg_name = "controls"


const PAGES := [
	[["HOW TO WIN", "이기는 법"], [
		[["Bring the foe's HP to 0", "상대 체력을 0으로"], ["Win 2 rounds to win the match. A round is 60 seconds.", "2라운드를 먼저 이기면 승리. 한 라운드는 60초"]],
		[["Time up", "시간 종료"], ["Whoever has more HP left wins the round.", "체력이 더 많이 남은 쪽이 이긴다"]],
		[["First time?", "처음이라면?"], ["Try TRAINING or VS CPU (EASY) first.", "트레이닝이나 CPU 대전(쉬움)부터 해 보자"]],
	]],
	[["BUTTONS", "버튼"], [
		[["Lever", "레버"], ["Walk ← →, jump ↑, crouch ↓. Tap →→ to dash, ←← to back step.", "← → 걷기, ↑ 점프, ↓ 앉기. →→ 대시, ←← 백스텝"]],
		[["P  K  S  HS", "P  K  S  HS"], ["Punch, Kick, Slash, Heavy Slash. Left is fast and weak, right is slow and strong.", "펀치·킥·슬래시·헤비 슬래시. 왼쪽일수록 빠르고 약하고, 오른쪽일수록 느리고 세다"]],
		[["D", "D"], ["Special move. Changes with the lever: D / → + D / ↓ + D / ← + D / in the air D.", "필살기. 레버와 같이 누르면 다른 기술: D / → + D / ↓ + D / ← + D / 공중 D"]],
		[["Crouch + button", "앉아서 + 버튼"], ["↓ + P/K/S/HS gives a different, low move.", "↓를 누른 채 버튼을 누르면 앉은 기술 (↓K는 발을 노리는 하단)"]],
	]],
	[["BLOCKING", "막기 (가드)"], [
		[["Hold away (←)", "뒤로 (←)"], ["Hold away from the foe to block. Standing blocks HIGH and MID attacks.", "상대 반대쪽을 누르고 있으면 막는다. 서서 막으면 상단·중단을 막는다"]],
		[["Hold down-away (↙)", "아래 뒤로 (↙)"], ["Crouching blocks HIGH and LOW attacks (sweeps).", "앉아서 막으면 상단·하단(발 공격)을 막는다"]],
		[["Mix-ups", "섞기"], ["Jump attacks and → + K are MID: block standing. ↓K, ↓S are LOW: block crouching.", "점프 공격과 → + K는 중단 → 서서. ↓K, ↓S는 하단 → 앉아서"]],
		[["Throw", "잡기"], ["Close + →/← + HS grabs. Cannot be blocked! Press HS when grabbed to break.", "붙어서 →/← + HS = 잡기. 막을 수 없다! 잡히는 순간 HS로 풀기"]],
	]],
	[["COMBOS", "콤보"], [
		[["Chain", "이어 치기"], ["When an attack hits, press a stronger button right away: P > K > S > HS.", "공격이 맞는 순간 더 센 버튼을 누르면 이어진다: P > K > S > HS"]],
		[["Finish with D", "D로 마무리"], ["A normal attack that hits can be canceled into a special (D).", "기본기가 맞으면 바로 D(필살기)로 이을 수 있다"]],
		[["Launch", "띄우기"], ["↓HS launches. Press ↑ as it hits, then attack in the air.", "↓HS가 맞으면 상대가 뜬다 → 바로 ↑ 점프 → 공중에서 S > HS > D"]],
		[["Combo list", "콤보표"], ["Pause → COMBO LIST shows easy combos for your character.", "일시정지 → 콤보표에 캐릭터별 쉬운 콤보가 있다"]],
	]],
	[["GAUGES", "게이지"], [
		[["HP (top)", "체력 (위)"], ["0 means you lose the round.", "0이 되면 그 라운드는 진다"]],
		[["TENSION (bottom)", "텐션 (아래)"], ["Fills by moving forward and attacking. At 50%: D + HS = Overdrive, RC = Roman Cancel.", "앞으로 가고 공격하면 찬다. 50%에서 D + HS = 오버드라이브(궁극기), RC = 로만 캔슬"]],
		[["MANA", "마력"], ["Each D special uses one block. Refills over time.", "D 필살기를 쓸 때마다 한 칸. 시간이 지나면 다시 찬다"]],
		[["BURST (B)", "버스트 (B)"], ["While getting hit: D + any attack to escape the combo. Once per match until it refills.", "맞는 중에 D + 공격 버튼 → 콤보에서 빠져나온다. 쓰면 천천히 다시 찬다"]],
	]],
	[["TIPS", "꿀팁"], [
		[["Don't just mash", "막 누르지 말기"], ["Block first, then hit back when the foe misses.", "먼저 막고, 상대가 헛치면 그때 반격"]],
		[["Anti-air", "대공"], ["If the foe jumps at you, ↓HS knocks them out of the air.", "상대가 뛰어들면 ↓HS로 떨어뜨린다"]],
		[["Know your character", "캐릭터 알기"], ["CHARACTER BOOK shows every move. Press P there to see combos.", "캐릭터 설정집에서 기술을 보고, P를 누르면 콤보를 볼 수 있다"]],
		[["Have fun!", "즐기기!"], ["SELECT = taunt. Use it wisely.", "SELECT = 도발. 이긴 다음에 쓰자"]],
	]],
]

var page := 0


func _process(delta: float) -> void:
	super(delta)
	if Game.menu_pressed("left") and page > 0:
		page -= 1
		Sfx.play("menu_move")
	elif Game.menu_pressed("right") and page < PAGES.size() - 1:
		page += 1
		Sfx.play("menu_move")
	elif Game.menu_pressed("p"):
		if page < PAGES.size() - 1:
			page += 1
			Sfx.play("menu_move")
		else:
			Sfx.play("menu_ok")
			Game.goto("mode_select")
	if Game.menu_back():
		Game.goto("mode_select")


func _draw() -> void:
	background()
	var lang := int(Game.language)
	header(Game.t("guide"))
	var pg: Array = PAGES[page]
	# 페이지 제목
	Style.fill(self, Style.slant(120, 130, 1040, 64, 18), Color(Style.PANEL, 0.95))
	Style.title(self, "%d. %s" % [page + 1, pg[0][lang]], Vector2(150, 176), 36, Style.GOLD, HORIZONTAL_ALIGNMENT_LEFT, -1, 6)
	# 내용: 왼쪽 굵은 글자 칩 + 오른쪽 설명
	var rows: Array = pg[1]
	for i in rows.size():
		var y := 250.0 + i * 100.0
		Style.fill(self, Style.slant(120, y - 34, 1040, 86, 14), Color(Style.BLACK, 0.7))
		Style.fill(self, Style.slant(120, y - 34, 300, 86, 14), Style.RED.darkened(0.25))
		Style.text(self, rows[i][0][lang], Vector2(130, y + 18), 26, Style.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 290, 4)
		# 설명은 길면 두 줄로 (박스 세로 가운데)
		var desc: String = rows[i][1][lang]
		var lines := Game.FONT.get_multiline_string_size(desc, HORIZONTAL_ALIGNMENT_LEFT, 660, 22).y / Game.FONT.get_height(22)
		var dy := 16.0 if lines < 1.5 else 2.0
		draw_multiline_string_outline(Game.FONT, Vector2(450, y + dy), desc, HORIZONTAL_ALIGNMENT_LEFT, 660, 22, 2, 3, Style.BLACK)
		draw_multiline_string(Game.FONT, Vector2(450, y + dy), desc, HORIZONTAL_ALIGNMENT_LEFT, 660, 22, 2, Style.WHITE)
	# 페이지 점
	for i in PAGES.size():
		var c := Vector2(W / 2 - (PAGES.size() - 1) * 14 + i * 28, 664)
		draw_circle(c, 8 if i == page else 5, Style.GOLD if i == page else Style.GRAY)
	if page > 0:
		text("<", 420, 60, Style.WHITE, 60, 8)  # 박스(120~1160) 바깥
	if page < PAGES.size() - 1:
		text(">", 420, 60, Style.WHITE, W - 50, 8)
	text(Game.t("guide_hint"), 704, 18, Style.GRAY, W / 2, 0)
