extends Node2D
## 퍼펫(그림 변형) 시험 화면: 같은 캐릭터를 여러 자세로 나란히 보여준다
## Godot에서 scenes/puppet_test.tscn 을 열고 F6으로 실행

const ID := "chemikid"
const LABELS := ["IDLE", "WALK", "PUNCH", "KICK", "CROUCH", "HIT"]

var _puppets: Array[Puppet] = []
var t := 0


func _ready() -> void:
	var tex := Game.character_art(Game.CHARACTERS[0])
	for i in LABELS.size():
		_puppets.append(Puppet.new(tex, Rigs.get_rig(ID)))
	# 확인: 쉬는 자세에서 발 IK를 걸어도 그림이 그대로여야 한다
	var p := _puppets[0]
	p.pose({}, Vector2.ZERO, 0.0, {}, {"leg_f1": p.joint("fl_ft"), "leg_b1": p.joint("bl_ft")})


func _process(_delta: float) -> void:
	t += 1
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.12, 0.13, 0.17))
	draw_line(Vector2(0, 560), Vector2(1280, 560), Color(1, 1, 1, 0.3), 2.0)
	for i in LABELS.size():
		var p := _puppets[i]
		_pose(i, p)
		var x := 110.0 + i * 212.0
		p.draw(self, 1, Vector2(x, 560))
		Style.text(self, LABELS[i], Vector2(x - 100, 620), 24, Style.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 200, 4)


func _pose(i: int, p: Puppet) -> void:
	var s := sin(t * 0.08)
	var feet := {"leg_f1": p.joint("fl_ft"), "leg_b1": p.joint("bl_ft")}
	match LABELS[i]:
		"IDLE":  # 숨쉬기: 엉덩이가 살짝 오르내리고 발은 고정
			p.pose({"torso": s * 0.03, "head": -s * 0.03, "arm_f1": s * 0.08, "arm_b1": -s * 0.06},
					Vector2(0, 14 + s * 14), 0.0, {}, feet)
		"WALK":
			var w := sin(t * 0.18)
			var lift := maxf(0.0, w) * 90.0
			var lift2 := maxf(0.0, -w) * 90.0
			p.pose({"torso": 0.05, "arm_f1": -w * 0.25, "arm_b1": w * 0.25},
					Vector2(w * 20, 20 - absf(w) * 16), 0.0, {},
					{"leg_f1": p.joint("fl_ft") + Vector2(w * 140, -lift), "leg_b1": p.joint("bl_ft") + Vector2(-w * 140, -lift2)})
		"PUNCH":  # 0~10 준비(팔 뒤로) → 10~20 쭉 뻗기 → 20~40 돌아오기
			var f := t % 40
			var reach := 0.0
			var wind := 0.0
			if f < 10:
				wind = f / 10.0
			elif f < 20:
				reach = 1.0
			else:
				reach = 1.0 - (f - 20) / 20.0
			var target := p.joint("fa_sh") + Vector2(520, -40)
			p.pose({"torso": 0.12 * reach - 0.08 * wind, "arm_f1": -0.9 * wind, "arm_f2": -0.8 * wind},
					Vector2(60 * reach, 20), 0.0, {"arm_f1": [target, reach]}, feet)
		"KICK":
			var f := t % 40
			var reach := 1.0 if (f >= 10 and f < 20) else (f / 10.0 if f < 10 else 1.0 - (f - 20) / 20.0)
			var foot := p.joint("fl_ft").lerp(p.joint("fl_hip") + Vector2(650, -60), reach)
			p.pose({"torso": -0.25 * reach}, Vector2(-40 * reach, 0), 0.0, {},
					{"leg_f1": foot, "leg_b1": p.joint("bl_ft")})
		"CROUCH":
			p.pose({"torso": 0.25, "head": -0.15, "arm_f1": -0.3, "arm_b1": 0.2},
					Vector2(30, 330), 0.0, {}, feet)
		"HIT":
			var k := absf(sin(t * 0.05))
			p.pose({"torso": -0.35 * k, "head": -0.3 * k, "arm_f1": -0.6 * k, "arm_b1": 0.5 * k},
					Vector2(-80 * k, 30 * k), 0.0, {}, feet)
