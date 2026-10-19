extends Screen
## 캐릭터 선택: 1P / 2P가 동시에 좌우로 고르고 P로 결정, K로 취소
## 둘 다 결정하면 잠깐 뒤 대전 화면으로

const CARD_SIZE := Vector2(170, 210)

var cursor := { 1: 0, 2: 1 }
var locked := { 1: false, 2: false }
var _done_frames := 0


func _ready() -> void:
	cursor = Game.selected.duplicate()


func _process(delta: float) -> void:
	super(delta)
	var count := Game.CHARACTERS.size()
	for p in [1, 2]:
		if locked[p]:
			if Game.menu_back(p):
				locked[p] = false
			continue
		if Game.menu_pressed("left", p):
			cursor[p] = (cursor[p] - 1 + count) % count
		elif Game.menu_pressed("right", p):
			cursor[p] = (cursor[p] + 1) % count
		elif Game.menu_confirm(p):
			locked[p] = true
		elif Game.menu_back(p):
			Game.goto("mode_select")
			return

	if locked[1] and locked[2]:
		_done_frames += 1
		if _done_frames >= 40:
			Game.selected = cursor.duplicate()
			Game.goto("battle")
	else:
		_done_frames = 0


func _card_rect(index: int) -> Rect2:
	var count := Game.CHARACTERS.size()
	var gap := 30.0
	var total := count * CARD_SIZE.x + (count - 1) * gap
	var x := W / 2 - total / 2 + index * (CARD_SIZE.x + gap)
	return Rect2(Vector2(x, 400), CARD_SIZE)


func _draw() -> void:
	background()
	header(Game.t("char_select"))
	var title := Game.t("versus" if Game.mode == Game.Mode.VERSUS else "training")
	Style.text(self, title, Vector2(56, 118), 22, Style.GOLD, HORIZONTAL_ALIGNMENT_LEFT, -1, 4)

	# 양쪽 큰 미리보기
	_draw_preview(1, Rect2(40, 140, 380, 520))
	_draw_preview(2, Rect2(W - 420, 140, 380, 520))

	# 가운데 캐릭터 카드
	for i in Game.CHARACTERS.size():
		var c: Dictionary = Game.CHARACTERS[i]
		var rect := _card_rect(i)
		Style.fill(self, Style.slant(rect.position.x, rect.position.y, rect.size.x, rect.size.y, 12), Style.PANEL)
		var art := Game.character_art(c)
		if art != null:
			_draw_art(art, Rect2(rect.position + Vector2(10, 8), rect.size - Vector2(20, 50)), false)
		else:
			draw_rect(Rect2(rect.position + Vector2(45, 40), Vector2(80, 120)), c["color"])
		Style.fill(self, Style.slant(rect.position.x, rect.end.y - 42, rect.size.x, 42, 6), Style.BLACK)
		text(c["name"], rect.end.y - 13, 22, Style.WHITE, rect.get_center().x, 0)
	# 커서 (1P 빨강 / 2P 파랑, 같은 칸이면 겹쳐서 보이게 크기 다르게)
	for p in [1, 2]:
		var rect := _card_rect(cursor[p]).grow(6 if p == 1 else 12)
		var col := _player_color(p)
		Style.outline(self, Style.slant(rect.position.x, rect.position.y, rect.size.x, rect.size.y, 12), col, 4.0)
		var label_x := rect.position.x + 24 if p == 1 else rect.end.x - 10
		text("%dP" % p, rect.position.y - 8, 22, col, label_x, 4)

	if locked[1] and locked[2]:
		Style.banner(self, Game.t("ready"), Style.GOLD, _done_frames / 10.0)
	else:
		text(Game.t("select_hint"), 700, 18, Style.GRAY, W / 2, 0)


func _player_color(p: int) -> Color:
	return Color(1, 0.35, 0.35) if p == 1 else Color(0.35, 0.65, 1)


## 그림을 rect 안에 비율 유지해서 맞춰 그린다 (flip이면 좌우 반전)
func _draw_art(art: Texture2D, rect: Rect2, flip: bool) -> void:
	var s := minf(rect.size.x / art.get_width(), rect.size.y / art.get_height())
	var size := Vector2(art.get_width(), art.get_height()) * s
	var pos := Vector2(rect.get_center().x - size.x / 2, rect.end.y - size.y)
	if flip:
		draw_texture_rect(art, Rect2(pos + Vector2(size.x, 0), Vector2(-size.x, size.y)), false)
	else:
		draw_texture_rect(art, Rect2(pos, size), false)


func _draw_preview(p: int, rect: Rect2) -> void:
	var c: Dictionary = Game.CHARACTERS[cursor[p]]
	var col := _player_color(p)
	var slope := 20.0 if p == 1 else -20.0
	var panel := Style.slant(rect.position.x, rect.position.y, rect.size.x, rect.size.y, slope)
	Style.fill(self, panel, Color(c["color"].darkened(0.7), 0.9))
	var art := Game.character_art(c)
	if art != null:
		_draw_art(art, rect.grow(-10), p == 2)  # 2P는 좌우 반전 (서로 마주 보게)
	else:
		var body := Rect2(rect.get_center() - Vector2(70, 150), Vector2(140, 260))
		draw_rect(body, c["color"])
		draw_rect(body, Style.WHITE, false, 3.0)
	text("%dP" % p, rect.position.y + 40, 30, col, rect.get_center().x, 6)
	Style.fill(self, Style.slant(rect.position.x, rect.end.y - 100, rect.size.x, 100, slope * 0.2), Color(Style.BLACK, 0.8))
	text(c["name"], rect.end.y - 46, 44, Style.WHITE, rect.get_center().x, 8)
	text(Game.club_name(c), rect.end.y - 16, 18, Style.GOLD, rect.get_center().x, 0)
	Style.outline(self, panel, col if locked[p] else Color(1, 1, 1, 0.2), 5.0 if locked[p] else 2.0)
	if locked[p]:
		Style.fill(self, Style.slant(rect.position.x + 60, rect.position.y + 64, rect.size.x - 120, 50, 10), Style.RED)
		text(Game.t("ok"), rect.position.y + 101, 34, Style.WHITE, rect.get_center().x + 5, 4)
