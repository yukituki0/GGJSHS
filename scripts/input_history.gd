extends Node2D
## 트레이닝 입력 기록 (스파·길티 트레이닝처럼): 화면 왼쪽(1P) / 오른쪽(2P)에 최근 입력을 위에서부터 쌓는다.
## 한 줄 = 방향(상대 쪽 기준 화살표, 숫자패드 표기) + 이번에 누른 버튼 + 그 입력을 유지한 프레임 수
## Match가 트레이닝 모드일 때 HudLayer에 붙인다

const ROWS := 16
const ROW_H := 28.0
const TOP := 200.0
const BUTTONS := ["p", "k", "s", "hs", "d", "rc"]
const BUTTON_COLORS := {
	"p": Color("ff7ab8"), "k": Color("4aa8ff"), "s": Color("5cd65c"),
	"hs": Color("ff4a4a"), "d": Color("ffa53a"), "rc": Color("e8e8e8"),
}

var match_node: Node
var _logs := {1: [], 2: []}      # 플레이어 → [{dir, buttons, frames}] (앞이 최신)
var _prev_held := {1: {}, 2: {}}


func _physics_process(_delta: float) -> void:
	if match_node == null or match_node.paused:
		queue_redraw()  # 일시정지 중엔 안 그리도록 다시 그리기
		return
	for f: Fighter in [match_node.p1, match_node.p2]:
		if f == null or not _shown(f):
			continue
		_record(f)
	queue_redraw()


## 사람이 조작하는 쪽만 보여준다 (더미 / CPU는 X)
func _shown(f: Fighter) -> bool:
	return f.brain == null and f.dummy == Fighter.Dummy.HUMAN


func _record(f: Fighter) -> void:
	var dir := _numpad(f)
	var pressed: Array = []
	var held: Dictionary = _prev_held[f.player]
	for b in BUTTONS:
		var now := f._held(b)
		if now and not held.get(b, false):
			pressed.append(b)
		held[b] = now
	var log: Array = _logs[f.player]
	if log.is_empty() or log[0]["dir"] != dir or not pressed.is_empty():
		log.push_front({"dir": dir, "buttons": pressed, "frames": 1})
		if log.size() > ROWS:
			log.pop_back()
	else:
		log[0]["frames"] = mini(log[0]["frames"] + 1, 99)


## 숫자패드 방향 (상대 쪽 = 6). 5 = 중립
func _numpad(f: Fighter) -> int:
	var x := f._input_forward()
	var y := (1 if f._held("up") else 0) - (1 if f._held("down") else 0)
	return 5 + x + y * 3


func _draw() -> void:
	if match_node == null or match_node.paused:  # 일시정지 메뉴(트레이닝 설정 등) 위로 겹쳐 보이지 않게
		return
	for f: Fighter in [match_node.p1, match_node.p2]:
		if f == null or not _shown(f):
			continue
		var left := f.player == 1
		var x := 16.0 if left else 1280.0 - 16.0 - 200.0
		var log: Array = _logs[f.player]
		draw_rect(Rect2(x - 6, TOP - 6, 212, ROWS * ROW_H + 8), Color(0, 0, 0, 0.35))
		for i in log.size():
			var e: Dictionary = log[i]
			var y := TOP + i * ROW_H
			var a := 1.0 - i * 0.04
			Style.text(self, str(e["frames"]), Vector2(x, y + 20), 16, Color(0.75, 0.75, 0.75, a),
					HORIZONTAL_ALIGNMENT_RIGHT, 30, 0)
			_draw_arrow(Vector2(x + 52, y + 13), e["dir"], a)
			var bx := x + 76.0
			for b: String in e["buttons"]:
				_draw_button(Vector2(bx, y + 2), b, a)
				bx += 32.0 if b != "hs" else 40.0


## 숫자패드 방향 화살표 (5는 작은 점)
func _draw_arrow(c: Vector2, dir: int, a: float) -> void:
	var col := Color(1, 1, 1, a)
	if dir == 5:
		draw_circle(c, 4, Color(1, 1, 1, 0.5 * a))
		return
	# 숫자패드: 1~3 = 아래 줄(화면 아래), 7~9 = 위 줄
	var v := Vector2((dir - 1) % 3 - 1, 1 - (dir - 1) / 3).normalized()
	var tip := c + v * 11
	var tail := c - v * 11
	draw_line(tail, tip, col, 4.0)
	var side := v.orthogonal() * 6
	draw_colored_polygon(PackedVector2Array([tip + v * 3, tip - v * 6 + side, tip - v * 6 - side]), col)


func _draw_button(pos: Vector2, b: String, a: float) -> void:
	var w := 28.0 if b != "hs" else 36.0
	var col: Color = BUTTON_COLORS[b]
	draw_rect(Rect2(pos, Vector2(w, 22)), Color(col, 0.9 * a))
	draw_rect(Rect2(pos, Vector2(w, 22)), Color(0, 0, 0, a), false, 2.0)
	Style.text(self, b.to_upper(), pos + Vector2(0, 17), 15, Color(0.05, 0.05, 0.08, a), HORIZONTAL_ALIGNMENT_CENTER, w, 0)
