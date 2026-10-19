class_name Projectile
extends Node2D
## 투사체/설치물 공통 (패킷, 버그 함정, 방화벽, 나중에 케미 플라스크 등)
## 캐릭터가 만들어서 projectile_spawned 신호로 넘기면, Match가 매 프레임 움직이고 판정한다

signal landed(pos: Vector2)     # 바닥(ground_y)에 닿아서 사라질 때 (플라스크 → 웅덩이 등)

var shooter: Fighter            # 쏜 캐릭터
var attack: AttackData          # 맞았을 때 효과. null이면 때리지 않음 (방화벽)
var velocity := Vector2.ZERO
var gravity := 0.0              # 포물선으로 날아가는 투사체용
var accel := Vector2.ZERO       # 매 프레임 속도에 더해짐 (부메랑처럼 되돌아오는 투사체)
var size := Vector2(40, 30)     # 판정 크기 (position이 가운데)
var lifetime := 600             # 이 프레임이 지나면 사라짐
var arm_frames := 0             # 이 프레임이 지나야 작동 (함정 설치 직후엔 안 터지게)
var blocks_projectiles := false # 상대 투사체를 막는가 (방화벽)
var hits_airborne := true       # 공중에 뜬 상대도 맞히나 (바닥 함정은 false)
var rehit_interval := 0         # 0이면 한 번 맞히고 사라짐, 아니면 이 간격마다 다시 맞힘 (웅덩이)
var ground_y := INF             # 이 높이에 닿으면 landed 신호를 내고 사라짐
var kind := ""                  # 그리기용 종류 이름
var extra := {}                 # 종류별 추가 정보 (별자리 선의 양 끝점 등)
var color := Color.WHITE

var age := 0
var dead := false
var rehit_cd := 0               # 다시 맞힐 수 있을 때까지 남은 프레임


func tick() -> void:
	age += 1
	velocity.y += gravity
	velocity += accel
	position += velocity
	if rehit_cd > 0:
		rehit_cd -= 1
	if position.y >= ground_y and not dead:
		position.y = ground_y
		dead = true
		landed.emit(position)
	if age >= lifetime or position.x < -200 or position.x > 1480 or position.y > 800:
		dead = true
	queue_redraw()


func rect() -> Rect2:
	return Rect2(position - size / 2, size)


func is_armed() -> bool:
	return age >= arm_frames


## 방향: 날아가는 방향, 멈춰 있으면 쏜 캐릭터가 보던 방향
func hit_direction() -> int:
	if velocity.x != 0:
		return 1 if velocity.x > 0 else -1
	return shooter.facing


# ── 임시 그래픽 (나중에 그림으로 교체) ─────────────────────
func _draw() -> void:
	var r := Rect2(-size / 2, size)
	match kind:
		"packet":
			# 데이터 패킷: 빛나는 사각형 + 꼬리
			for i in 4:
				var tail := Rect2(r.position - Vector2(hit_direction() * (i + 1) * 14, 0), r.size)
				draw_rect(tail.grow(-i * 3), Color(color, 0.25 - i * 0.05))
			draw_rect(r, color)
			draw_rect(r, Color.WHITE, false, 2.0)
			draw_string(Game.FONT, Vector2(-size.x / 2, 7), "0101", HORIZONTAL_ALIGNMENT_CENTER, size.x, 14, Style.BLACK)
		"bug":
			# 버그 함정: 깜빡이는 벌레 (작동 전엔 흐리게)
			var a := 1.0 if is_armed() else 0.35
			var blink := 0.6 + 0.4 * sin(age * 0.3)
			draw_circle(Vector2.ZERO, size.x / 2, Color(color, a * blink))
			for i in 3:
				var y := -6.0 + i * 6
				draw_line(Vector2(-size.x / 2 - 8, y), Vector2(size.x / 2 + 8, y), Color(Style.BLACK, a), 2.0)
			draw_string(Game.FONT, Vector2(-30, -size.y / 2 - 6), "BUG", HORIZONTAL_ALIGNMENT_CENTER, 60, 14, Color(color, a))
		"wall":
			# 방화벽: 반투명 벽 + 가로줄
			var fade := minf(1.0, (lifetime - age) / 20.0)
			draw_rect(r, Color(color, 0.35 * fade))
			for i in int(size.y / 20):
				var y := r.position.y + i * 20 + fmod(age * 1.5, 20.0)
				draw_line(Vector2(r.position.x, y), Vector2(r.end.x, y), Color(color, 0.8 * fade), 2.0)
			draw_rect(r, Color(Color.WHITE, fade), false, 2.0)
		"flask":
			# 플라스크: 빙글빙글 도는 병 + 초록 액체
			draw_set_transform(Vector2.ZERO, age * 0.35)
			draw_circle(Vector2(0, 4), size.x / 2, Color(color, 0.85))
			draw_rect(Rect2(-5, -size.y / 2 - 4, 10, 12), Color(0.9, 0.95, 1.0, 0.9))
			draw_arc(Vector2(0, 4), size.x / 2, 0, TAU, 20, Color.WHITE, 2.0)
			draw_set_transform(Vector2.ZERO, 0)
		"acid":
			# 산성 웅덩이: 납작한 초록 + 올라오는 거품
			var fade := minf(1.0, (lifetime - age) / 30.0)
			draw_rect(Rect2(r.position.x, -4, r.size.x, 10), Color(color, 0.55 * fade))
			for i in 4:
				var bx := r.position.x + fmod(i * 37.0 + age * 0.7, r.size.x)
				var by := -fmod(age * 1.2 + i * 13.0, 30.0)
				draw_circle(Vector2(bx, by), 4, Color(color, 0.7 * fade))
		"explosion":
			# 폭발: 커지면서 사라지는 원
			var t := float(age) / lifetime
			draw_circle(Vector2.ZERO, size.x * 0.3 + size.x * 0.4 * t, Color(1.0, 0.6, 0.15, 0.8 * (1.0 - t)))
			draw_circle(Vector2.ZERO, size.x * 0.2 + size.x * 0.25 * t, Color(color, 0.9 * (1.0 - t)))
		"meteor":
			# 별똥별: 빛나는 머리 + 날아온 방향으로 긴 꼬리
			var back := -velocity.normalized() * 70
			draw_line(Vector2.ZERO, back, Color(color, 0.35), 14.0)
			draw_line(Vector2.ZERO, back * 0.6, Color(color, 0.7), 8.0)
			_draw_star(Vector2.ZERO, size.x * 0.6, Color.WHITE, age * 0.2)
		"wave":
			# 파도: 진행 방향으로 말려 올라가는 물결
			var dir := hit_direction()
			var fade := minf(1.0, (lifetime - age) / 12.0)
			for i in 3:
				var off := Vector2(-dir * i * 22, i * 6)
				draw_arc(off + Vector2(0, size.y * 0.25), size.y * (0.55 - i * 0.1), PI if dir > 0 else 0.0,
						PI * 1.5 if dir > 0 else -PI * 0.5, 12, Color(color.lightened(i * 0.2), 0.85 * fade), 10.0 - i * 2)
			draw_rect(Rect2(r.position.x, r.end.y - 10, r.size.x, 10), Color(color, 0.6 * fade))
		"star":
			# 별자리용 별: 반짝임
			var tw := 0.75 + 0.25 * sin(age * 0.25)
			draw_circle(Vector2.ZERO, size.x * 0.9, Color(color, 0.15))
			_draw_star(Vector2.ZERO, size.x * 0.55 * tw, Color(color, 0.95), 0.0)
		"beam":
			# 별자리 선: 두 별을 잇는 빛줄기 (extra.a, extra.b는 position 기준 상대 좌표)
			var t := float(age) / lifetime
			var a: Vector2 = extra.get("a", Vector2.ZERO)
			var b: Vector2 = extra.get("b", Vector2.ZERO)
			draw_line(a, b, Color(color, 0.4 * (1.0 - t)), 18.0)
			draw_line(a, b, Color(Color.WHITE, 1.0 - t), 5.0)
		"bolt":
			# 번개: 위에서 아래로 지그재그
			var flick := 1.0 if age % 4 < 2 else 0.6
			var pts := PackedVector2Array()
			var steps := 8
			for i in steps + 1:
				var y := r.position.y + r.size.y * i / steps
				var x := 0.0 if i == 0 or i == steps else (14.0 if (i + int(age / 3.0)) % 2 == 0 else -14.0)
				pts.append(Vector2(x, y))
			draw_polyline(pts, Color(color, 0.5 * flick), 14.0)
			draw_polyline(pts, Color(Color.WHITE, flick), 4.0)
		"typhoon":
			# 태풍: 빙글빙글 도는 나선
			var fade := minf(1.0, (lifetime - age) / 15.0)
			for i in 5:
				var rad := size.x * (0.15 + i * 0.09)
				var start := age * 0.25 + i * 1.3
				draw_arc(Vector2(0, -i * 8), rad, start, start + PI * 1.3, 16, Color(color, (0.8 - i * 0.12) * fade), 6.0)
		"precipitate":
			# 앙금 덩어리: 하얀 결정
			draw_rect(r, color)
			draw_line(r.position, r.end, Color(0.7, 0.8, 0.85), 2.0)
			draw_rect(r, Color(0.5, 0.6, 0.65), false, 2.0)
		"saltwall":
			# 굳은 앙금 벽: 하얀 결정 기둥 (사라질 때 흐려짐)
			var fade := minf(1.0, (lifetime - age) / 20.0)
			draw_rect(r, Color(color, 0.9 * fade))
			for i in 4:
				var y := r.position.y + 12 + i * 26
				draw_line(Vector2(r.position.x, y), Vector2(r.end.x, y + 12), Color(0.6, 0.7, 0.75, fade), 2.0)
			draw_rect(r, Color(0.5, 0.6, 0.65, fade), false, 3.0)
		"pillar":
			# 불꽃 기둥: 아래에서 위로 치솟는 초고온 불꽃
			var t := float(age) / lifetime
			var grow := minf(1.0, age / 5.0)
			var col_rect := Rect2(r.position.x, r.end.y - r.size.y * grow, r.size.x, r.size.y * grow)
			draw_rect(col_rect, Color(color, 0.75 * (1.0 - t)))
			draw_rect(col_rect.grow_individual(-r.size.x * 0.3, 0, -r.size.x * 0.3, 0), Color(1, 0.95, 0.7, 1.0 - t))
		"text":
			# 글자 투사체 (숫자, 수식): extra.text, extra.size
			var s: String = extra.get("text", "?")
			var fs: int = extra.get("size", 32)
			var fade := minf(1.0, (lifetime - age) / 10.0)
			Style.text(self, s, Vector2(-100, fs * 0.35), fs, Color(color, fade), HORIZONTAL_ALIGNMENT_CENTER, 200, 6)
		"boomerang":
			# √2 부메랑: 빙글빙글 도는 루트 기호
			draw_set_transform(Vector2.ZERO, age * 0.4)
			Style.text(self, "√2", Vector2(-50, 12), 36, color, HORIZONTAL_ALIGNMENT_CENTER, 100, 6)
			draw_set_transform(Vector2.ZERO, 0)
		"integral":
			# 적분 기둥: 작동 전엔 좌표축 표시, 작동하면 기둥이 솟음
			if not is_armed():
				var blink := 0.5 + 0.5 * sin(age * 0.6)
				draw_line(Vector2(-60, r.end.y - 4), Vector2(60, r.end.y - 4), Color(color, blink), 3.0)
				draw_line(Vector2(0, r.end.y - 70), Vector2(0, r.end.y), Color(color, blink), 3.0)
				Style.text(self, "∫", Vector2(-40, r.end.y - 20), 40, Color(color, blink), HORIZONTAL_ALIGNMENT_CENTER, 80, 4)
			else:
				var grow := minf(1.0, (age - arm_frames) / 5.0)
				var col_rect := Rect2(r.position.x, r.end.y - r.size.y * grow, r.size.x, r.size.y * grow)
				draw_rect(col_rect, Color(color, 0.55))
				Style.text(self, "∫", Vector2(-60, col_rect.position.y + 90), 110, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 120, 8)
		"dice":
			# 주사위: 하얀 정육면체 + 나온 눈 숫자
			draw_set_transform(Vector2.ZERO, age * 0.3)
			draw_rect(r, Color.WHITE)
			draw_rect(r, Style.BLACK, false, 3.0)
			draw_set_transform(Vector2.ZERO, 0)
			Style.text(self, str(extra.get("n", 1)), Vector2(-30, 10), 28, Style.RED, HORIZONTAL_ALIGNMENT_CENTER, 60, 4)
		"seed":
			# 씨앗: 땅에 박힌 작은 씨 + 자라나는 싹
			draw_circle(Vector2.ZERO, 7, Color("8a5a2a"))
			var sprout := minf(1.0, age / 30.0) * 18
			draw_line(Vector2.ZERO, Vector2(0, -sprout), color, 3.0)
		"vine":
			# 덩굴: 아래에서 위로 솟는 굵은 줄기 + 잎
			var grow := minf(1.0, age / 5.0)
			var top := r.end.y - r.size.y * grow
			var pts := PackedVector2Array()
			for i in 9:
				var y := lerpf(r.end.y, top, i / 8.0)
				pts.append(Vector2(sin(i * 1.2 + age * 0.3) * 14, y))
			draw_polyline(pts, color.darkened(0.3), 16.0)
			draw_polyline(pts, color, 8.0)
			for i in range(2, 9, 2):
				draw_circle(pts[i] + Vector2(12 if i % 4 == 0 else -12, 0), 9, color.lightened(0.2))
		"clone":
			# 분신: 반투명한 몸 + 세포막 테두리
			var fade := minf(1.0, (lifetime - age) / 10.0)
			draw_rect(r, Color(color, 0.35 * fade))
			draw_rect(r, Color(color.lightened(0.4), 0.8 * fade), false, 3.0)
			draw_circle(Vector2(0, -r.size.y * 0.15), 12, Color(color.darkened(0.3), 0.6 * fade))
		"helix":
			# DNA 이중나선: 꼬인 두 줄 + 사다리
			for i in 7:
				var y := -r.size.y / 2 + i * r.size.y / 6
				var x := sin(age * 0.5 + i * 0.9) * r.size.x * 0.4
				draw_line(Vector2(-x, y), Vector2(x, y), Color(Color.WHITE, 0.6), 2.0)
				draw_circle(Vector2(x, y), 5, color)
				draw_circle(Vector2(-x, y), 5, Style.CYAN)
		"blackhole":
			# 블랙홀: 검은 중심 + 빨려 들어가는 보라색 고리
			var grow := minf(1.0, age / 15.0)
			for i in 4:
				var rad := size.x * 0.5 * grow * (1.0 - fmod(age * 0.03 + i * 0.25, 1.0))
				draw_arc(Vector2.ZERO, rad, 0, TAU, 32, Color(color, 0.6), 4.0)
			draw_circle(Vector2.ZERO, size.x * 0.22 * grow, Color(0.02, 0.0, 0.05))
			draw_arc(Vector2.ZERO, size.x * 0.22 * grow, 0, TAU, 32, Color(color.lightened(0.4), 0.9), 3.0)
		_:
			draw_rect(r, color)


## 다섯 꼭짓점 별 모양
func _draw_star(center: Vector2, radius: float, col: Color, rot: float) -> void:
	var pts := PackedVector2Array()
	for i in 10:
		var rad := radius if i % 2 == 0 else radius * 0.45
		pts.append(center + Vector2(0, -rad).rotated(rot + i * TAU / 10))
	draw_colored_polygon(pts, col)
