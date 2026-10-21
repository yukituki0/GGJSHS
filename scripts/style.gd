class_name Style
extends RefCounted
## 길티기어 느낌의 공통 색과 그리기 도우미 (대전 HUD와 메뉴 화면이 같이 쓴다)
## 검정 + 진홍색 + 흰색 + 금색, 비스듬한(기울어진) 판, 굵은 외곽선 글자

const BLACK := Color("0b0b10")
const PANEL := Color("16151c")
const RED := Color("d7192d")
const DARK_RED := Color("4a0910")
const WHITE := Color("f4f1ea")
const GRAY := Color("8a8790")
const GOLD := Color("f4c430")
const CYAN := Color("37d6ff")


## 기울어진 사각형(평행사변형). skew가 양수면 윗변이 오른쪽으로 밀린다
static func slant(x: float, y: float, w: float, h: float, skew: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(x + skew, y), Vector2(x + w + skew, y),
		Vector2(x + w, y + h), Vector2(x, y + h),
	])


static func fill(c: CanvasItem, points: PackedVector2Array, color: Color) -> void:
	c.draw_colored_polygon(points, color)


## 그림 그리기 (flip이면 좌우 반전). src를 주면 그림의 그 부분만
## Godot은 폭이 음수인 사각형으로는 반전이 제대로 안 돼서, 그리는 좌표계를 뒤집어서 그린다
static func texture(c: CanvasItem, tex: Texture2D, dest: Rect2, flip := false, src := Rect2()) -> void:
	if flip:
		c.draw_set_transform(Vector2(dest.position.x * 2 + dest.size.x, 0), 0.0, Vector2(-1, 1))
	if src.has_area():
		c.draw_texture_rect_region(tex, dest, src)
	else:
		c.draw_texture_rect(tex, dest, false)
	if flip:
		c.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## 꼭짓점마다 색을 줘서 그라데이션으로 칠하기 (slant()와 같이 쓰면 [왼위, 오위, 오아래, 왼아래])
static func gradient(c: CanvasItem, points: PackedVector2Array, colors: Array) -> void:
	c.draw_polygon(points, PackedColorArray(colors))


static func outline(c: CanvasItem, points: PackedVector2Array, color: Color, width := 2.0) -> void:
	var closed := points.duplicate()
	closed.append(points[0])
	c.draw_polyline(closed, color, width)


## 외곽선 있는 글자. width를 주면 그 폭 안에서 정렬
static func text(c: CanvasItem, s: String, pos: Vector2, size: int, color := WHITE,
		align := HORIZONTAL_ALIGNMENT_LEFT, width := -1.0, outline_size := 0,
		outline_color := BLACK, font: Font = null) -> void:
	if font == null:
		font = Game.FONT
	if outline_size > 0:
		c.draw_string_outline(font, pos, s, align, width, size, outline_size, outline_color)
	c.draw_string(font, pos, s, align, width, size, color)


## 제목/연출용 굵은 글자 (Game.TITLE_FONT). 사용법은 text()와 같다
static func title(c: CanvasItem, s: String, pos: Vector2, size: int, color := WHITE,
		align := HORIZONTAL_ALIGNMENT_LEFT, width := -1.0, outline_size := 0,
		outline_color := BLACK) -> void:
	text(c, s, pos, size, color, align, width, outline_size, outline_color, Game.TITLE_FONT)


## 화면을 가로지르는 기울어진 띠 + 큰 글자 (ROUND 1, FIGHT!, K.O. 같은 연출)
## t: 0 → 1 등장 진행도 (글자가 크게 시작해서 제자리로 줄어든다)
static func banner(c: CanvasItem, s: String, color: Color, t := 1.0) -> void:
	var e := 1.0 - pow(1.0 - clampf(t, 0.0, 1.0), 3.0)  # 부드럽게 감속
	var band_w := 1280.0 * e
	fill(c, PackedVector2Array([
		Vector2(640 - band_w / 2, 300), Vector2(640 + band_w / 2, 276),
		Vector2(640 + band_w / 2, 420), Vector2(640 - band_w / 2, 444),
	]), Color(BLACK, 0.85) if s in DARK_BAND and has_text_image(s) else Color(RED, 0.88))
	c.draw_line(Vector2(640 - band_w / 2, 292), Vector2(640 + band_w / 2, 268), BLACK, 6.0)
	c.draw_line(Vector2(640 - band_w / 2, 452), Vector2(640 + band_w / 2, 428), BLACK, 6.0)
	var size := int(lerpf(180.0, 104.0, e))
	if text_image(c, s, Vector2(640, 360), lerpf(1.6, 1.0, e)):
		return
	title(c, s, Vector2(0, 360 + size * 0.36), size, color, HORIZONTAL_ALIGNMENT_CENTER, 1280, 16)


## 글자 그림 (assets/ui/text_<이름>.png). 글자 → 파일 이름. 그림이 없는 글자는 폰트로 쓴다
const TEXT_IMAGES := {
	"ROUND 1": "round1", "ROUND 2": "round2", "FINAL ROUND": "final_round", "FIGHT!": "fight",
	"K.O.": "ko", "DOUBLE K.O.": "double_ko", "TIME UP": "time_up", "DRAW GAME": "draw_game",
	"COUNTER": "counter", "GUARD CRUSH!": "guard_crush", "VS": "vs", "READY!": "ready",
	"ALGEBRA!": "root2_algebra", "CALCULUS!": "root2_calculus", "PROBABILITY!": "root2_probability",
}
const DARK_BAND := ["K.O.", "DOUBLE K.O."]  # 빨간 글자 그림이라 띠를 어둡게 (빨강 위 빨강은 안 보임)
const TEXT_IMAGE_MAX := Vector2(820, 240)  # 띠 글자 기본 크기 한도 (scale 1일 때)


static func has_text_image(s: String) -> bool:
	return TEXT_IMAGES.has(s) and Game.load_texture("res://assets/ui/text_%s.png" % TEXT_IMAGES[s]) != null


## 글자 그림을 center에 그린다. 없으면 false (폰트로 대신 쓰라는 뜻)
## scale: 기본 크기(TEXT_IMAGE_MAX 안에 맞춘 크기)의 배율, alpha: 투명도
static func text_image(c: CanvasItem, s: String, center: Vector2, scale := 1.0, alpha := 1.0,
		max_size := TEXT_IMAGE_MAX) -> bool:
	if not TEXT_IMAGES.has(s):
		return false
	var tex := Game.load_texture("res://assets/ui/text_%s.png" % TEXT_IMAGES[s])
	if tex == null:
		return false
	var k := minf(max_size.x / tex.get_width(), max_size.y / tex.get_height()) * scale
	var sz := Vector2(tex.get_width(), tex.get_height()) * k
	c.draw_texture_rect(tex, Rect2(center - sz / 2, sz), false, Color(1, 1, 1, alpha))
	return true
