extends Screen
## 캐릭터 설정집: 캐릭터마다 일러스트 + 동아리 + 한 줄 설정 + 체력 + 기술 목록 (+ 있으면 긴 설정 글)
## 좌우로 캐릭터를 넘긴다. 설정 글은 Game.CHARACTERS의 concept / profile을 고치면 된다

const HP_MAX := 480.0   # 체력 막대 기준 (가장 체력이 많은 캐릭터보다 조금 크게)

var cursor := 0
var _hp := {}           # 캐릭터 id → 최대 체력 (캐릭터 스크립트에서 한 번 읽어 둔다)
var _turn := 0.0        # 넘길 때 그림이 옆에서 미끄러져 들어오는 연출 (-1 ~ 1)


func _init() -> void:
	bg_name = "char_select"  # 캐릭터 선택 배경을 같이 쓴다


func _ready() -> void:
	for info: Dictionary in Game.CHARACTERS:
		var f: Fighter = load(info["script"]).new()
		_hp[info["id"]] = f.max_hp
		f.free()


func _process(delta: float) -> void:
	super(delta)
	var n := Game.CHARACTERS.size()
	if Game.menu_pressed("left"):
		cursor = (cursor - 1 + n) % n
		_turn = -1.0
		Sfx.play("menu_move")
	elif Game.menu_pressed("right"):
		cursor = (cursor + 1) % n
		_turn = 1.0
		Sfx.play("menu_move")
	_turn = move_toward(_turn, 0.0, delta * 6.0)
	if Game.menu_back():
		Game.goto("mode_select")


func _draw() -> void:
	background()
	draw_rect(Rect2(0, 0, W, H), Color(0, 0, 0, 0.45))
	header(Game.t("char_book"))
	var info: Dictionary = Game.CHARACTERS[cursor]
	var lang := Game.language
	# 왼쪽: 큰 일러스트 (넘길 때 옆에서 들어옴)
	var art := Game.character_image(info, "select")
	if art == null:
		art = Game.character_art(info)
	if art != null:
		var s := 600.0 / art.get_height()
		var sz := Vector2(art.get_width(), art.get_height()) * s
		var x := 300.0 - sz.x / 2 + _turn * 120.0
		draw_texture_rect(art, Rect2(Vector2(x, H - sz.y), sz), false, Color(1, 1, 1, 1.0 - absf(_turn)))
	# 오른쪽 판
	var px := 600.0
	Style.fill(self, Style.slant(px - 20, 120, 680, 560, 24), Color(Style.PANEL, 0.88))
	Style.fill(self, Style.slant(px - 20, 120, 680, 8, 2), info["color"])
	Style.title(self, info["name"], Vector2(px + 20, 196), 64, Style.WHITE, HORIZONTAL_ALIGNMENT_LEFT, -1, 8)
	Style.text(self, info["club"][lang], Vector2(px + 22, 232), 22, info["color"].lightened(0.3), HORIZONTAL_ALIGNMENT_LEFT, -1, 4)
	Style.text(self, info.get("concept", ["", ""])[lang], Vector2(px + 22, 272), 20, Style.WHITE, HORIZONTAL_ALIGNMENT_LEFT, 620, 3)
	# 체력 막대
	var hp: int = _hp.get(info["id"], 400)
	Style.text(self, Game.t("hp"), Vector2(px + 22, 312), 18, Style.GOLD, HORIZONTAL_ALIGNMENT_LEFT, -1, 3)
	draw_rect(Rect2(px + 80, 298, 400, 16), Color(0, 0, 0, 0.6))
	draw_rect(Rect2(px + 80, 298, 400 * hp / HP_MAX, 16), info["color"])
	Style.text(self, str(hp), Vector2(px + 492, 312), 18, Style.WHITE, HORIZONTAL_ALIGNMENT_LEFT, -1, 3)
	# 기술 목록
	var moves: Array = Game.MOVE_LISTS.get(info["id"], [])
	for i in moves.size():
		var mv: Array = moves[i]
		var y := 356.0 + i * 44.0
		Style.fill(self, Style.slant(px + 10, y - 26, 110, 36, 8), Style.RED.darkened(0.3))
		Style.text(self, Game.command_text(mv[0]), Vector2(px + 10, y), 18, Style.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 116, 3)
		Style.text(self, mv[1 + lang], Vector2(px + 136, y), 20, Style.GOLD, HORIZONTAL_ALIGNMENT_LEFT, -1, 3)
		if lang == Game.Language.KO:
			Style.text(self, mv[3], Vector2(px + 330, y), 16, Style.WHITE, HORIZONTAL_ALIGNMENT_LEFT, 330, 0)
	# 긴 설정 글 (적어 둔 캐릭터만)
	var profile: Array = info.get("profile", [])
	if not profile.is_empty():
		Style.text(self, Game.t("profile"), Vector2(px + 22, 636), 16, Style.GOLD, HORIZONTAL_ALIGNMENT_LEFT, -1, 2)
		Style.text(self, profile[lang], Vector2(px + 90, 636), 16, Style.WHITE, HORIZONTAL_ALIGNMENT_LEFT, 560, 2)
	# 넘김 표시 + 몇 번째
	text("<", 420, 60, Style.WHITE, 40, 8)
	text(">", 420, 60, Style.WHITE, W - 40, 8)
	text("%d / %d" % [cursor + 1, Game.CHARACTERS.size()], 110, 20, Style.GRAY, 1180, 3)
	Style.fill(self, Style.slant(W / 2 - 260, 688, 520, 28, 10), Color(Style.BLACK, 0.8))
	text(Game.t("book_hint"), 708, 18, Style.GRAY, W / 2, 0)
