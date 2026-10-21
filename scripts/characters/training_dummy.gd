extends Fighter
## 트레이닝 전용 연습용 인형: 기술 없이 서서 맞기만 하는 나무 인형 (더미 동작 설정은 그대로 따름)
## 그림 없이 코드로 그린다: 받침대 + 기둥 + 천 감은 몸통 + 과녁 + 머리

const WOOD := Color(0.62, 0.5, 0.36)
const WOOD_DARK := Color(0.4, 0.3, 0.2)
const CLOTH := Color(0.85, 0.8, 0.68)
const TARGET := Color(0.85, 0.15, 0.15)


func _build_specials() -> void:
	pass  # 필살기 없음


func _draw_body(rect: Rect2, _body_color: Color, size: Vector2) -> void:
	var h := size.y
	var low := h < BODY_SIZE.y
	# 맞으면 뒤로 기울고, 막으면 조금만 기움 (발밑 기준)
	var tilt := 0.0
	if state == State.HITSTUN or state == State.KO:
		tilt = -0.25 * facing
	elif state == State.BLOCKSTUN:
		tilt = -0.1 * facing
	draw_set_transform(Vector2(rect.get_center().x, 0), tilt, Vector2.ONE)
	# 받침대 + 기둥
	draw_rect(Rect2(-40, -14, 80, 14), WOOD_DARK)
	draw_rect(Rect2(-40, -14, 80, 14), Color.BLACK, false, 2.0)
	draw_rect(Rect2(-6, -h * 0.4, 12, h * 0.4 - 14), WOOD)
	# 몸통 (천을 감은 자루) + 묶은 끈 + 과녁
	var body := Rect2(-30, -h * 0.72, 60, h * 0.36)
	draw_rect(body, CLOTH)
	for i in 3:
		var y := body.position.y + body.size.y * (0.2 + i * 0.3)
		draw_line(Vector2(-30, y), Vector2(30, y), WOOD_DARK, 3.0)
	draw_rect(body, Color.BLACK, false, 3.0)
	var c := body.get_center()
	draw_circle(c, 15, TARGET)
	draw_circle(c, 9, CLOTH)
	draw_circle(c, 4, TARGET)
	# 팔 (가로 막대). 앉으면 접힘
	if not low:
		draw_rect(Rect2(-50, -h * 0.66, 100, 9), WOOD)
		draw_rect(Rect2(-50, -h * 0.66, 100, 9), Color.BLACK, false, 2.0)
	# 머리
	var head := Vector2(0, -h * 0.72 - 20)
	draw_circle(head, 20, CLOTH)
	draw_arc(head, 20, 0, TAU, 24, Color.BLACK, 3.0)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	if state == State.GUARD or state == State.BLOCKSTUN:
		var start := -PI * 0.4 if facing > 0 else PI * 0.6
		draw_arc(Vector2(facing * 40, -h * 0.55), 50, start, start + PI * 0.8, 16, Color(0.55, 0.8, 1.0, 0.8), 5.0)
