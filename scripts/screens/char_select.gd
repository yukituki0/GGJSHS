extends Screen
## 캐릭터 선택: 1P / 2P가 동시에 좌우로 고르고 P로 결정, K로 취소
## 트레이닝은 혼자서도 할 수 있게 "내 캐릭터 → 더미 캐릭터" 순서로 한 사람이 고른다
## 둘 다 결정하면 잠깐 뒤 스테이지 선택으로


func _init() -> void:
	bg_name = "char_select"  # assets/ui/bg_char_select.png


const CARD_SIZE := Vector2(110, 140)
const COLUMNS := 3         # 카드 격자 가로 칸 수 (6명 = 3 x 2)
const CARD_GAP := 14.0
const GRID_TOP := 290.0

var cursor := { 1: 0, 2: 1 }      # 캐릭터 번호. RANDOM 칸이면 random_slot()
var locked := { 1: false, 2: false }
var _done_frames := 0
var _roll := { 1: 0, 2: 0 }       # RANDOM으로 결정한 뒤 룰렛이 도는 남은 프레임


## 캐릭터 카드 다음 칸 = RANDOM (카드 아래 가로로 긴 칸)
func random_slot() -> int:
	return Game.CHARACTERS.size()


## 트레이닝일 때 2P만 고를 수 있는 연습용 인형 칸 (RANDOM 칸 오른쪽 절반)
func dummy_slot() -> int:
	return random_slot() + 1


func _has_dummy(slot: int) -> bool:
	return slot == 2 and Game.mode == Game.Mode.TRAINING


func _ready() -> void:
	cursor = Game.selected.duplicate()
	for p in [1, 2]:
		if cursor[p] == Game.TRAINING_DUMMY_INDEX and _has_dummy(p):
			cursor[p] = dummy_slot()
		else:
			cursor[p] = clampi(cursor[p], 0, random_slot() - 1)


## 트레이닝 / CPU 대전: 한 사람이 내 캐릭터 → 상대 캐릭터 순서로 고른다
func _solo() -> bool:
	return Game.is_solo()


func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("ui_cancel"):
		Game.goto("mode_select")
		return
	if _solo():
		_update_solo_select()
	else:
		for p in [1, 2]:
			if not _update_slot(p, p):
				return

	for p in [1, 2]:
		if _roll[p] > 0:
			_roll[p] -= 1
			if _roll[p] % 3 == 0 and _roll[p] > 0:
				Sfx.play("menu_move")
	if locked[1] and locked[2] and _roll[1] == 0 and _roll[2] == 0:
		_done_frames += 1
		if _done_frames >= 40:
			Game.selected = cursor.duplicate()
			for p in [1, 2]:
				if cursor[p] == dummy_slot():
					Game.selected[p] = Game.TRAINING_DUMMY_INDEX
			Game.goto("stage_select")
	else:
		_done_frames = 0


## slot(1P/2P 자리)을 player의 입력으로 조작. 화면을 나가면 false
func _update_slot(slot: int, player: int) -> bool:
	var count := random_slot() + (2 if _has_dummy(slot) else 1)  # 캐릭터 + RANDOM (+ 연습용 인형)
	if locked[slot]:
		if Game.menu_back(player) and _roll[slot] == 0:
			locked[slot] = false
		return true
	var before: int = cursor[slot]
	if Game.menu_pressed("left", player):
		cursor[slot] = (cursor[slot] - 1 + count) % count
	elif Game.menu_pressed("right", player):
		cursor[slot] = (cursor[slot] + 1) % count
	elif Game.menu_pressed("up", player):
		cursor[slot] = _move_vertical(cursor[slot], -1)
	elif Game.menu_pressed("down", player):
		cursor[slot] = _move_vertical(cursor[slot], 1)
	elif Game.menu_confirm(player):
		locked[slot] = true
		if cursor[slot] == random_slot():
			# 랜덤: 바로 정하고, 잠깐 룰렛처럼 돌다가 멈추는 연출
			cursor[slot] = randi() % random_slot()
			_roll[slot] = 30
	elif Game.menu_back(player):
		Game.goto("mode_select")
		return false
	if cursor[slot] != before:
		Sfx.play("menu_move")
	return true


## 혼자: 아무나(0) 입력으로 1P 자리 → 다 고르면 2P(더미/CPU) 자리
func _update_solo_select() -> void:
	if not locked[1]:
		_update_slot(1, 0)
	elif not locked[2]:
		if Game.menu_back():
			locked[1] = false  # 더미 고르다가 뒤로 → 내 캐릭터 다시
			return
		_update_slot(2, 0)
	elif Game.menu_back():
		locked[2] = false


## 위아래 이동: 카드 줄 → (맨 아래 다음은) RANDOM 칸 → (그 다음은) 맨 윗줄 가운데
func _move_vertical(cur: int, dir: int) -> int:
	var rows := ceili(float(random_slot()) / COLUMNS)
	var mid := mini(int(COLUMNS / 2.0), random_slot() - 1)
	if cur >= random_slot():  # 맨 아래 줄 (RANDOM / 인형)
		return mid if dir > 0 else (rows - 1) * COLUMNS + mid
	var next := cur + dir * COLUMNS
	if next < 0 or next >= random_slot():
		return random_slot()
	return next


## 화면에 보여줄 캐릭터 번호 (RANDOM 칸이면 계속 바뀌고, 룰렛 중이면 빠르게 돌다가 결정된 캐릭터)
func _shown(p: int) -> int:
	if cursor[p] == dummy_slot():
		return -1
	if _roll[p] > 0:
		return (cursor[p] + int(_roll[p] / 3.0)) % random_slot()
	if cursor[p] == random_slot():
		return int(frame / 8.0 + p * 3) % random_slot()
	return cursor[p]


## 가운데 카드 격자에서 index번 카드 위치 (마지막 = RANDOM: 카드 아래 가로로 긴 칸)
func _card_rect(index: int) -> Rect2:
	var total := COLUMNS * CARD_SIZE.x + (COLUMNS - 1) * CARD_GAP
	if index >= random_slot():
		var rows := ceili(float(random_slot()) / COLUMNS)
		var r := Rect2(Vector2(W / 2 - total / 2, GRID_TOP + rows * (CARD_SIZE.y + CARD_GAP)), Vector2(total, 44))
		if Game.mode == Game.Mode.TRAINING:  # 트레이닝: 왼쪽 반 RANDOM, 오른쪽 반 인형
			r.size.x = total / 2 - CARD_GAP / 2
			if index == dummy_slot():
				r.position.x += total / 2 + CARD_GAP / 2
		return r
	var col := index % COLUMNS
	var row := int(float(index) / COLUMNS)
	var x := W / 2 - total / 2 + col * (CARD_SIZE.x + CARD_GAP)
	return Rect2(Vector2(x, GRID_TOP + row * (CARD_SIZE.y + CARD_GAP)), CARD_SIZE)


func _draw() -> void:
	background()
	header(Game.t("char_select"))
	var title := Game.t(["versus", "training", "vs_cpu"][Game.mode])
	Style.text(self, title, Vector2(56, 118), 22, Style.GOLD, HORIZONTAL_ALIGNMENT_LEFT, -1, 4)

	# 양쪽 큰 미리보기
	_draw_preview(1, Rect2(40, 140, 380, 520))
	_draw_preview(2, Rect2(W - 420, 140, 380, 520))

	# 가운데 캐릭터 카드
	for i in Game.CHARACTERS.size():
		var c: Dictionary = Game.CHARACTERS[i]
		var rect := _card_rect(i)
		Style.fill(self, Style.slant(rect.position.x, rect.position.y, rect.size.x, rect.size.y, 12), Style.PANEL)
		var face := Game.character_image(c, "face")
		var art := Game.character_art(c)
		if face != null:  # 얼굴 아이콘이 있으면 카드에 얼굴을 크게
			var r := Rect2(rect.position + Vector2(6, 4), rect.size - Vector2(12, 34))
			var fi := Game.face_image(c, r.size.x / r.size.y)
			draw_texture_rect_region(fi[0], r, fi[1])
		elif art != null:
			_draw_art(art, Rect2(rect.position + Vector2(8, 6), rect.size - Vector2(16, 38)), false)
		else:
			draw_rect(Rect2(rect.position + Vector2(35, 22), Vector2(40, 80)), c["color"])
		Style.fill(self, Style.slant(rect.position.x, rect.end.y - 30, rect.size.x, 30, 6), Style.BLACK)
		text(c["name"], rect.end.y - 9, 16, Style.WHITE, rect.get_center().x, 0)
	# RANDOM 칸
	var rr := _card_rect(random_slot())
	Style.fill(self, Style.slant(rr.position.x, rr.position.y, rr.size.x, rr.size.y, 12), Style.PANEL)
	Style.title(self, "?  " + Game.t("random") + "  ?", Vector2(rr.position.x, rr.end.y - 9), 30, Style.GOLD,
			HORIZONTAL_ALIGNMENT_CENTER, rr.size.x, 5)
	if Game.mode == Game.Mode.TRAINING:
		var dr := _card_rect(dummy_slot())
		Style.fill(self, Style.slant(dr.position.x, dr.position.y, dr.size.x, dr.size.y, 12), Style.PANEL)
		Style.title(self, "DUMMY", Vector2(dr.position.x, dr.end.y - 9), 30, Color(0.85, 0.75, 0.55),
				HORIZONTAL_ALIGNMENT_CENTER, dr.size.x, 5)
	# 커서 (1P 빨강 / 2P 파랑, 같은 칸이면 겹쳐서 보이게 크기 다르게)
	for p in [1, 2]:
		var rect := _card_rect(cursor[p]).grow(4 if p == 1 else 9)
		var col := _player_color(p)
		Style.outline(self, Style.slant(rect.position.x, rect.position.y, rect.size.x, rect.size.y, 12), col, 4.0)
		if cursor[p] >= random_slot():
			continue  # RANDOM 칸은 가로로 길어서 1P/2P 글자 없이 테두리만
		var label_x := rect.position.x + 24 if p == 1 else rect.end.x - 10
		text("%dP" % p, rect.position.y - 8, 22, col, label_x, 4)

	if locked[1] and locked[2] and _roll[1] == 0 and _roll[2] == 0:
		Style.banner(self, Game.t("ready"), Style.GOLD, _done_frames / 10.0)
	else:
		var hint := "select_hint"
		if Game.mode == Game.Mode.TRAINING:
			hint = "training_select_hint"
		elif Game.mode == Game.Mode.CPU:
			hint = "cpu_select_hint"
		text(Game.t(hint), 700, 18, Style.GRAY, W / 2, 0)


func _player_color(p: int) -> Color:
	return Color(1, 0.35, 0.35) if p == 1 else Color(0.35, 0.65, 1)


## 그림을 rect 안에 비율 유지해서 맞춰 그린다 (flip이면 좌우 반전)
func _draw_art(art: Texture2D, rect: Rect2, flip: bool) -> void:
	Style.texture(self, art, _fit(art, rect), flip)


## 그림을 rect 안에 비율 유지해서 넣을 위치 (아래 가운데 맞춤)
func _fit(art: Texture2D, rect: Rect2) -> Rect2:
	var s := minf(rect.size.x / art.get_width(), rect.size.y / art.get_height())
	var size := Vector2(art.get_width(), art.get_height()) * s
	return Rect2(Vector2(rect.get_center().x - size.x / 2, rect.end.y - size.y), size)


func _draw_preview(p: int, rect: Rect2) -> void:
	var c: Dictionary = Game.TRAINING_DUMMY if _shown(p) < 0 else Game.CHARACTERS[_shown(p)]
	var col := _player_color(p)
	var is_random: bool = cursor[p] == random_slot() or _roll[p] > 0
	var slope := 20.0 if p == 1 else -20.0
	var panel := Style.slant(rect.position.x, rect.position.y, rect.size.x, rect.size.y, slope)
	Style.fill(self, panel, Color(c["color"].darkened(0.7), 0.9))
	var art := Game.character_image(c, "select")  # 선택창 상반신 → 없으면 전신
	if art == null:
		art = Game.character_art(c)
	if art != null:
		# 2P는 좌우 반전 (서로 마주 보게). 랜덤 고르는 중이면 어둡게 + 물음표
		Style.texture(self, art, _fit(art, rect.grow(-10)), p == 2)
		if is_random:
			draw_colored_polygon(panel, Color(0, 0, 0, 0.55))
			Style.title(self, "?", Vector2(rect.position.x, rect.get_center().y + 60), 200, Style.GOLD,
					HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 10)
	elif c["id"] == "dummy":  # 연습용 인형: 받침대 + 기둥 + 과녁 몸통 + 머리
		var base := Vector2(rect.get_center().x, rect.end.y - 110)
		draw_rect(Rect2(base + Vector2(-60, -20), Vector2(120, 20)), Color(0.4, 0.3, 0.2))
		draw_rect(Rect2(base + Vector2(-9, -130), Vector2(18, 110)), Color(0.62, 0.5, 0.36))
		var torso := Rect2(base + Vector2(-48, -250), Vector2(96, 130))
		draw_rect(torso, Color(0.85, 0.8, 0.68))
		draw_rect(torso, Color.BLACK, false, 3.0)
		draw_rect(Rect2(base + Vector2(-80, -235), Vector2(160, 14)), Color(0.62, 0.5, 0.36))
		draw_circle(torso.get_center(), 26, Color(0.85, 0.15, 0.15))
		draw_circle(torso.get_center(), 15, Color(0.85, 0.8, 0.68))
		draw_circle(torso.get_center(), 7, Color(0.85, 0.15, 0.15))
		draw_circle(base + Vector2(0, -284), 32, Color(0.85, 0.8, 0.68))
		draw_arc(base + Vector2(0, -284), 32, 0, TAU, 24, Color.BLACK, 3.0)
	else:
		var body := Rect2(rect.get_center() - Vector2(70, 150), Vector2(140, 260))
		draw_rect(body, c["color"])
		draw_rect(body, Style.WHITE, false, 3.0)
	text("%dP" % p, rect.position.y + 40, 30, col, rect.get_center().x, 6)
	Style.fill(self, Style.slant(rect.position.x, rect.end.y - 100, rect.size.x, 100, slope * 0.2), Color(Style.BLACK, 0.8))
	var shown_name: String = Game.t("random") if cursor[p] == random_slot() else c["name"]
	Style.title(self, shown_name, Vector2(rect.get_center().x - W, rect.end.y - 44), 50, Style.WHITE, HORIZONTAL_ALIGNMENT_CENTER, W * 2, 8)
	if not is_random:
		text(Game.club_name(c), rect.end.y - 16, 18, Style.GOLD, rect.get_center().x, 0)
	Style.outline(self, panel, col if locked[p] else Color(1, 1, 1, 0.2), 5.0 if locked[p] else 2.0)
	if locked[p] and _roll[p] == 0:
		Style.fill(self, Style.slant(rect.position.x + 60, rect.position.y + 64, rect.size.x - 120, 50, 10), Style.RED)
		text(Game.t("ok"), rect.position.y + 101, 34, Style.WHITE, rect.get_center().x + 5, 4)
