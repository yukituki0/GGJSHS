class_name Projectile
extends Node2D
## 투사체/설치물 공통 (패킷, 버그 함정, 방화벽, 나중에 케미 플라스크 등)
## 캐릭터가 만들어서 projectile_spawned 신호로 넘기면, Match가 매 프레임 움직이고 판정한다

var shooter: Fighter            # 쏜 캐릭터
var attack: AttackData          # 맞았을 때 효과. null이면 때리지 않음 (방화벽)
var velocity := Vector2.ZERO
var gravity := 0.0              # 포물선으로 날아가는 투사체용
var size := Vector2(40, 30)     # 판정 크기 (position이 가운데)
var lifetime := 600             # 이 프레임이 지나면 사라짐
var arm_frames := 0             # 이 프레임이 지나야 작동 (함정 설치 직후엔 안 터지게)
var blocks_projectiles := false # 상대 투사체를 막는가 (방화벽)
var hits_airborne := true       # 공중에 뜬 상대도 맞히나 (바닥 함정은 false)
var kind := ""                  # 그리기용 종류 이름
var color := Color.WHITE

var age := 0
var dead := false


func tick() -> void:
	age += 1
	velocity.y += gravity
	position += velocity
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
		_:
			draw_rect(r, color)
