class_name Screen
extends Node2D
## 메뉴 화면 공통: 매 프레임 다시 그리기 + 글자/배경 그리기 도우미
## 그래픽은 아직 전부 코드로 그린다 (나중에 이미지로 교체 예정)

const W := 1280.0
const H := 720.0
const BG := Color(0.07, 0.07, 0.11)
const ACCENT := Color(1.0, 0.25, 0.35)

var frame := 0  # 화면이 열린 뒤 지난 프레임 (깜빡임, 등장 연출용)


func _process(_delta: float) -> void:
	frame += 1
	queue_redraw()


## 가운데 정렬 글자. x를 안 주면 화면 한가운데
func text(s: String, y: float, size: int, color := Color.WHITE, x := W / 2) -> void:
	draw_string(ThemeDB.fallback_font, Vector2(x - W, y), s,
			HORIZONTAL_ALIGNMENT_CENTER, W * 2, size, color)


## 배경: 어두운 바탕 + 비스듬한 줄무늬 (길티기어 메뉴 느낌)
func background() -> void:
	draw_rect(Rect2(0, 0, W, H), BG)
	var offset := fmod(frame * 0.6, 80.0)
	for i in range(-12, 24):
		var x := i * 80.0 + offset
		draw_line(Vector2(x, 0), Vector2(x - 300, H), Color(1, 1, 1, 0.03), 18.0)


## 세로 메뉴. 고른 항목은 강조색 + 화살표
func menu_list(items: Array, cursor: int, top: float, gap := 56.0, size := 34) -> void:
	for i in items.size():
		var y := top + i * gap
		if i == cursor:
			draw_rect(Rect2(W / 2 - 230, y - size - 2, 460, size + 18), Color(ACCENT, 0.25))
			text("> " + items[i] + " <", y, size, ACCENT)
		else:
			text(items[i], y, size, Color(0.8, 0.8, 0.85))


## 위/아래로 커서 이동 (끝에서 반대쪽으로 넘어감)
func move_cursor(cursor: int, count: int, player := 0) -> int:
	if Game.menu_pressed("up", player):
		return (cursor - 1 + count) % count
	if Game.menu_pressed("down", player):
		return (cursor + 1) % count
	return cursor
