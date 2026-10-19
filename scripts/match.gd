extends Node2D
## 대전 화면: 캐릭터 2명 배치, 바닥, 화면 벽, 서로 밀어내기
##
## 지금은 카메라가 고정이라 "스테이지 = 화면"이고, 양쪽 벽이 최대 거리 제한 역할을 한다.

const GROUND_Y := 620.0
const WALL_LEFT := 40.0
const WALL_RIGHT := 1240.0

var p1: Fighter
var p2: Fighter


func _ready() -> void:
	p1 = _spawn(1, Color(0.85, 0.2, 0.2), 440)
	p2 = _spawn(2, Color(0.2, 0.4, 0.9), 840)
	p1.opponent = p2
	p2.opponent = p1


func _spawn(player: int, color: Color, x: float) -> Fighter:
	var f := Fighter.new()
	f.player = player
	f.color = color
	f.ground_y = GROUND_Y
	f.position = Vector2(x, GROUND_Y)
	add_child(f)
	return f


## 매 프레임: 1P 이동 → 2P 이동 → 밀어내기 (항상 이 순서)
func _physics_process(_delta: float) -> void:
	p1.tick()
	p2.tick()
	_resolve_push()


## 두 몸통이 겹치면 반씩 밀어내고, 벽 밖으로 못 나가게 막는다
func _resolve_push() -> void:
	if p1.body_rect().intersects(p2.body_rect()):
		var p1_is_left := p1.position.x < p2.position.x \
				or (p1.position.x == p2.position.x and p1.facing == 1)
		var left := p1 if p1_is_left else p2
		var right := p2 if p1_is_left else p1
		var overlap := left.body_rect().end.x - right.body_rect().position.x
		left.position.x -= overlap / 2
		right.position.x += overlap / 2
		_clamp_to_walls(left)
		_clamp_to_walls(right)
		# 한쪽이 벽에 막혀서 덜 밀렸으면, 나머지를 반대쪽 캐릭터가 마저 밀린다
		overlap = left.body_rect().end.x - right.body_rect().position.x
		if overlap > 0:
			if left.body_rect().position.x <= WALL_LEFT:
				right.position.x += overlap
			else:
				left.position.x -= overlap
	_clamp_to_walls(p1)
	_clamp_to_walls(p2)


func _clamp_to_walls(f: Fighter) -> void:
	var half := f.body_size().x / 2
	f.position.x = clampf(f.position.x, WALL_LEFT + half, WALL_RIGHT - half)


func _draw() -> void:
	# 배경과 바닥
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.12, 0.12, 0.16))
	draw_rect(Rect2(0, GROUND_Y, 1280, 720 - GROUND_Y), Color(0.25, 0.25, 0.3))
	draw_line(Vector2(0, GROUND_Y), Vector2(1280, GROUND_Y), Color.WHITE, 2.0)
