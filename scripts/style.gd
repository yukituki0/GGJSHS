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


static func outline(c: CanvasItem, points: PackedVector2Array, color: Color, width := 2.0) -> void:
	var closed := points.duplicate()
	closed.append(points[0])
	c.draw_polyline(closed, color, width)


## 외곽선 있는 글자. width를 주면 그 폭 안에서 정렬
static func text(c: CanvasItem, s: String, pos: Vector2, size: int, color := WHITE,
		align := HORIZONTAL_ALIGNMENT_LEFT, width := -1.0, outline_size := 0,
		outline_color := BLACK) -> void:
	if outline_size > 0:
		c.draw_string_outline(Game.FONT, pos, s, align, width, size, outline_size, outline_color)
	c.draw_string(Game.FONT, pos, s, align, width, size, color)


## 화면을 가로지르는 기울어진 띠 + 큰 글자 (ROUND 1, FIGHT!, K.O. 같은 연출)
## t: 0 → 1 등장 진행도 (글자가 크게 시작해서 제자리로 줄어든다)
static func banner(c: CanvasItem, s: String, color: Color, t := 1.0) -> void:
	var e := 1.0 - pow(1.0 - clampf(t, 0.0, 1.0), 3.0)  # 부드럽게 감속
	var band_w := 1280.0 * e
	fill(c, PackedVector2Array([
		Vector2(640 - band_w / 2, 300), Vector2(640 + band_w / 2, 276),
		Vector2(640 + band_w / 2, 420), Vector2(640 - band_w / 2, 444),
	]), Color(RED, 0.88))
	c.draw_line(Vector2(640 - band_w / 2, 292), Vector2(640 + band_w / 2, 268), BLACK, 6.0)
	c.draw_line(Vector2(640 - band_w / 2, 452), Vector2(640 + band_w / 2, 428), BLACK, 6.0)
	var size := int(lerpf(180.0, 104.0, e))
	text(c, s, Vector2(0, 360 + size * 0.36), size, color, HORIZONTAL_ALIGNMENT_CENTER, 1280, 16)
