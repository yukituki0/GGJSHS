class_name Screen
extends Node2D
## 메뉴 화면 공통: 매 프레임 다시 그리기 + 글자/배경/메뉴 그리기 도우미
## 색과 모양은 Style(길티기어 느낌)을 따른다

const W := 1280.0
const H := 720.0
const ACCENT := Style.RED

var frame := 0  # 화면이 열린 뒤 지난 프레임 (깜빡임, 등장 연출용)
var bg_name := ""  # 이 화면의 배경 그림 이름 → assets/ui/bg_<이름>.png (없으면 코드 배경)
var _bg_tex: Texture2D
var _bg_loaded := false


func _enter_tree() -> void:
	Sfx.play_bgm.call_deferred("bgm_menu")  # 시작 직후엔 Sfx가 아직 준비 전일 수 있어서 한 프레임 뒤에


func _process(_delta: float) -> void:
	frame += 1
	queue_redraw()


## 가운데 정렬 글자 (검은 외곽선). x를 안 주면 화면 한가운데
func text(s: String, y: float, size: int, color := Style.WHITE, x := W / 2, outline := 6) -> void:
	Style.text(self, s, Vector2(x - W, y), size, color, HORIZONTAL_ALIGNMENT_CENTER, W * 2, outline)


## 배경: 그림(bg_name)이 있으면 그림 + 어둡게, 없으면 검은 바탕. 그 위에 흘러가는 붉은 사선 + 아래쪽 붉은 빛
func background() -> void:
	if not _bg_loaded:
		_bg_loaded = true
		if bg_name != "":
			_bg_tex = Game.load_texture("res://assets/ui/bg_%s.png" % bg_name)
	if _bg_tex != null:
		draw_texture_rect(_bg_tex, Rect2(0, 0, W, H), false)
		draw_rect(Rect2(0, 0, W, H), Color(0, 0, 0, 0.35))  # 메뉴 글자가 잘 보이게 살짝 어둡게
	else:
		draw_rect(Rect2(0, 0, W, H), Style.BLACK)
	var offset := fmod(frame * 0.8, 120.0)
	for i in range(-10, 16):
		var x := i * 120.0 + offset
		Style.fill(self, Style.slant(x, 0, 26, H, -260), Color(Style.RED, 0.06))
	draw_polygon(PackedVector2Array([Vector2(0, H * 0.55), Vector2(W, H * 0.55), Vector2(W, H), Vector2(0, H)]),
			PackedColorArray([Color(Style.RED, 0), Color(Style.RED, 0), Color(Style.RED, 0.22), Color(Style.RED, 0.22)]))


## 화면 제목: 비스듬한 빨간 띠 위에 큰 글자
func header(s: String, y := 70.0) -> void:
	Style.fill(self, Style.slant(-20, y - 52, 620, 70, 24), Style.RED)
	Style.fill(self, Style.slant(-20, y + 22, 600, 6, 24), Style.WHITE)
	Style.text(self, s, Vector2(50, y), 46, Style.WHITE, HORIZONTAL_ALIGNMENT_LEFT, -1, 8)


## 세로 메뉴: 비스듬한 판. 고른 항목은 빨간 판 + 흰 테두리 + 살짝 오른쪽으로
func menu_list(items: Array, cursor: int, top: float, gap := 64.0, size := 30) -> void:
	for i in items.size():
		var y := top + i * gap
		var selected := i == cursor
		var x := W / 2 - 240 + (16.0 if selected else 0.0)
		Style.fill(self, Style.slant(x, y - size - 6, 480, size + 22, 16), Style.RED if selected else Style.PANEL)
		if selected:
			Style.outline(self, Style.slant(x, y - size - 6, 480, size + 22, 16), Style.WHITE, 3.0)
		Style.text(self, items[i], Vector2(x, y), size, Style.WHITE if selected else Style.GRAY,
				HORIZONTAL_ALIGNMENT_CENTER, 496, 4)


## 위/아래로 커서 이동 (끝에서 반대쪽으로 넘어감)
func move_cursor(cursor: int, count: int, player := 0) -> int:
	if Game.menu_pressed("up", player):
		Sfx.play("menu_move")
		return (cursor - 1 + count) % count
	if Game.menu_pressed("down", player):
		Sfx.play("menu_move")
		return (cursor + 1) % count
	return cursor
