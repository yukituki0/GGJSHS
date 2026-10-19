extends Screen
## 스테이지 선택: 맨 앞은 RANDOM, 나머지는 Game.STAGES 순서. 아무나 좌우로 고르고 P로 결정
## 카드에는 스테이지 사진(assets/stages/<id>.png)이 있으면 사진, 없으면 임시 색


func _init() -> void:
	bg_name = "stage_select"  # assets/ui/bg_stage_select.png


const CARD := Vector2(300, 170)
const GAP := 30.0

var cursor := 0          # 0 = RANDOM, 1부터 = STAGES[cursor - 1]
var _textures := []      # 스테이지별 사진 (없으면 null)


func _ready() -> void:
	for info in Game.STAGES:
		_textures.append(Game.load_texture("res://assets/stages/%s.png" % info["id"]))
	cursor = 0 if Game.stage_random else Game.stage + 1


func _count() -> int:
	return Game.STAGES.size() + 1


func _process(delta: float) -> void:
	super(delta)
	if Game.menu_pressed("left"):
		cursor = (cursor - 1 + _count()) % _count()
		Sfx.play("menu_move")
	elif Game.menu_pressed("right"):
		cursor = (cursor + 1) % _count()
		Sfx.play("menu_move")
	elif Game.menu_confirm():
		Game.stage_random = cursor == 0
		if cursor > 0:
			Game.stage = cursor - 1
		Game.goto("battle")
	elif Game.menu_back():
		Game.goto("char_select")


func _name(index: int) -> String:
	if index == 0:
		return Game.t("random")
	return Game.STAGES[index - 1]["name"][Game.language]


func _draw() -> void:
	background()
	header(Game.t("stage_select"))

	# 크게 보기 (지금 고른 스테이지)
	var big := Rect2(W / 2 - 400, 130, 800, 400)
	_draw_stage(cursor, big)
	Style.outline(self, PackedVector2Array([big.position, Vector2(big.end.x, big.position.y), big.end,
			Vector2(big.position.x, big.end.y)]), Style.WHITE, 3.0)
	Style.fill(self, Style.slant(big.position.x - 20, big.end.y - 64, 520, 64, 16), Color(Style.RED, 0.95))
	Style.text(self, _name(cursor), Vector2(big.position.x + 10, big.end.y - 18), 38, Style.WHITE,
			HORIZONTAL_ALIGNMENT_LEFT, -1, 8)

	# 아래 작은 카드 줄 (고른 카드가 가운데 오도록 밀기)
	var y := 560.0
	var small := Vector2(CARD.x * 0.5, CARD.y * 0.5)
	for i in _count():
		var x := W / 2 - small.x / 2 + (i - cursor) * (small.x + GAP * 0.6)
		if x < -small.x or x > W:
			continue
		var r := Rect2(x, y, small.x, small.y)
		_draw_stage(i, r)
		if i == cursor:
			draw_rect(r.grow(5), Style.GOLD, false, 4.0)
		else:
			draw_rect(r, Color(0, 0, 0, 0.45))

	# 좌우 화살표
	text("<", 340, 60, Style.WHITE, big.position.x - 50, 8)
	text(">", 340, 60, Style.WHITE, big.end.x + 50, 8)
	text(Game.t("stage_hint"), 700, 18, Style.GRAY, W / 2, 0)


## 스테이지 그림 (사진이 없으면 임시 그라데이션, RANDOM이면 물음표)
func _draw_stage(index: int, r: Rect2) -> void:
	if index == 0:
		draw_rect(r, Style.PANEL)
		text("?", r.get_center().y + r.size.y * 0.2, int(r.size.y * 0.55), Style.GOLD, r.get_center().x, 8)
		return
	var tex: Texture2D = _textures[index - 1]
	if tex != null:
		draw_texture_rect(tex, r, false)
		return
	var info: Dictionary = Game.STAGES[index - 1]
	var top: Color = info["sky"][0]
	var bottom: Color = info["sky"][1]
	var ground := r.position.y + r.size.y * 0.8
	draw_polygon(PackedVector2Array([r.position, Vector2(r.end.x, r.position.y), Vector2(r.end.x, ground),
			Vector2(r.position.x, ground)]), PackedColorArray([top, top, bottom, bottom]))
	draw_rect(Rect2(r.position.x, ground, r.size.x, r.end.y - ground), info["floor"])
