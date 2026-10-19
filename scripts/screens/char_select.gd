extends Screen
## 캐릭터 선택: 1P / 2P가 동시에 좌우로 고르고 P로 결정, K로 취소
## 트레이닝은 혼자서도 할 수 있게 "내 캐릭터 → 더미 캐릭터" 순서로 한 사람이 고른다
## 둘 다 결정하면 잠깐 뒤 스테이지 선택으로

const CARD_SIZE := Vector2(110, 140)
const COLUMNS := 3         # 카드 격자 가로 칸 수 (6명 = 3 x 2)
const CARD_GAP := 14.0
const GRID_TOP := 290.0

var cursor := { 1: 0, 2: 1 }
var locked := { 1: false, 2: false }
var _done_frames := 0


func _ready() -> void:
	cursor = Game.selected.duplicate()


func _training() -> bool:
	return Game.mode == Game.Mode.TRAINING


func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("ui_cancel"):
		Game.goto("mode_select")
		return
	if _training():
		_update_training_select()
	else:
		for p in [1, 2]:
			if not _update_slot(p, p):
				return

	if locked[1] and locked[2]:
		_done_frames += 1
		if _done_frames >= 40:
			Game.selected = cursor.duplicate()
			Game.goto("stage_select")
	else:
		_done_frames = 0


## slot(1P/2P 자리)을 player의 입력으로 조작. 화면을 나가면 false
func _update_slot(slot: int, player: int) -> bool:
	var count := Game.CHARACTERS.size()
	if locked[slot]:
		if Game.menu_back(player):
			locked[slot] = false
		return true
	if Game.menu_pressed("left", player):
		cursor[slot] = (cursor[slot] - 1 + count) % count
	elif Game.menu_pressed("right", player):
		cursor[slot] = (cursor[slot] + 1) % count
	elif Game.menu_pressed("up", player) and count > COLUMNS:
		cursor[slot] = (cursor[slot] - COLUMNS + count) % count
	elif Game.menu_pressed("down", player) and count > COLUMNS:
		cursor[slot] = (cursor[slot] + COLUMNS) % count
	elif Game.menu_confirm(player):
		locked[slot] = true
	elif Game.menu_back(player):
		Game.goto("mode_select")
		return false
	return true


## 트레이닝: 아무나(0) 입력으로 1P 자리 → 다 고르면 2P(더미) 자리
func _update_training_select() -> void:
	if not locked[1]:
		_update_slot(1, 0)
	elif not locked[2]:
		if Game.menu_back():
			locked[1] = false  # 더미 고르다가 뒤로 → 내 캐릭터 다시
			return
		_update_slot(2, 0)
	elif Game.menu_back():
		locked[2] = false


## 가운데 카드 격자에서 index번 카드 위치
func _card_rect(index: int) -> Rect2:
	var total := COLUMNS * CARD_SIZE.x + (COLUMNS - 1) * CARD_GAP
	var col := index % COLUMNS
	var row := int(float(index) / COLUMNS)
	var x := W / 2 - total / 2 + col * (CARD_SIZE.x + CARD_GAP)
	return Rect2(Vector2(x, GRID_TOP + row * (CARD_SIZE.y + CARD_GAP)), CARD_SIZE)


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
			_draw_art(art, Rect2(rect.position + Vector2(8, 6), rect.size - Vector2(16, 38)), false)
		else:
			draw_rect(Rect2(rect.position + Vector2(35, 22), Vector2(40, 80)), c["color"])
		Style.fill(self, Style.slant(rect.position.x, rect.end.y - 30, rect.size.x, 30, 6), Style.BLACK)
		text(c["name"], rect.end.y - 9, 16, Style.WHITE, rect.get_center().x, 0)
	# 커서 (1P 빨강 / 2P 파랑, 같은 칸이면 겹쳐서 보이게 크기 다르게)
	for p in [1, 2]:
		var rect := _card_rect(cursor[p]).grow(4 if p == 1 else 9)
		var col := _player_color(p)
		Style.outline(self, Style.slant(rect.position.x, rect.position.y, rect.size.x, rect.size.y, 12), col, 4.0)
		var label_x := rect.position.x + 24 if p == 1 else rect.end.x - 10
		text("%dP" % p, rect.position.y - 8, 22, col, label_x, 4)

	if locked[1] and locked[2]:
		Style.banner(self, Game.t("ready"), Style.GOLD, _done_frames / 10.0)
	else:
		text(Game.t("training_select_hint" if _training() else "select_hint"), 700, 18, Style.GRAY, W / 2, 0)


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
