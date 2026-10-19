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
	var title := Game.t("versus" if Game.mode == Game.Mode.VERSUS else "training")
	text(Game.t("char_select"), 70, 48)
	text(title, 108, 22, ACCENT)

	# 양쪽 큰 미리보기
	_draw_preview(1, Rect2(40, 140, 360, 520))
	_draw_preview(2, Rect2(W - 400, 140, 360, 520))

	# 가운데 캐릭터 카드
	for i in Game.CHARACTERS.size():
		var c: Dictionary = Game.CHARACTERS[i]
		var rect := _card_rect(i)
		draw_rect(rect, Color(0.15, 0.15, 0.2))
		draw_rect(Rect2(rect.position + Vector2(45, 40), Vector2(80, 120)), c["color"])
		text(c["name"], rect.end.y - 18, 22, Color.WHITE, rect.get_center().x)
		draw_rect(rect, Color(1, 1, 1, 0.3), false, 2.0)
	# 커서 (1P 빨강 / 2P 파랑, 같은 칸이면 겹쳐서 보이게 크기 다르게)
	for p in [1, 2]:
		var rect := _card_rect(cursor[p]).grow(6 if p == 1 else 12)
		var col := Color(1, 0.3, 0.3) if p == 1 else Color(0.3, 0.6, 1)
		draw_rect(rect, col, false, 4.0)
		var label_x := rect.position.x + 14 if p == 1 else rect.end.x - 14
		text("%dP" % p, rect.position.y - 8, 20, col, label_x)

	if locked[1] and locked[2]:
		text(Game.t("ready"), 690, 32, Color.YELLOW)
	else:
		text(Game.t("select_hint"), 690, 18, Color(1, 1, 1, 0.5))


func _draw_preview(p: int, rect: Rect2) -> void:
	var c: Dictionary = Game.CHARACTERS[cursor[p]]
	var col := Color(1, 0.3, 0.3) if p == 1 else Color(0.3, 0.6, 1)
	draw_rect(rect, Color(0.1, 0.1, 0.15))
	# 임시 캐릭터 그림 (나중에 이미지로 교체)
	var body := Rect2(rect.get_center() - Vector2(70, 150), Vector2(140, 260))
	draw_rect(body, c["color"])
	draw_rect(body, Color.WHITE, false, 3.0)
	text("%dP" % p, rect.position.y + 40, 30, col, rect.get_center().x)
	text(c["name"], rect.end.y - 60, 40, Color.WHITE, rect.get_center().x)
	text(Game.club_name(c), rect.end.y - 28, 18, Color(1, 1, 1, 0.7), rect.get_center().x)
	draw_rect(rect, col if locked[p] else Color(1, 1, 1, 0.2), false, 4.0 if locked[p] else 2.0)
	if locked[p]:
		text(Game.t("ok"), rect.position.y + 90, 36, Color.YELLOW, rect.get_center().x)
