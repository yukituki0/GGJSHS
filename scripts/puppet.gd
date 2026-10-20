class_name Puppet
extends RefCounted
## 전신 그림 1장을 뼈대로 구부려서 움직이는 인형 (컷아웃 대신 "메시 변형")
##
## 그림을 팔다리로 잘라내면 팔이 몸통 위에 겹친 자리에 구멍이 생긴다.
## 그래서 그림 위에 촘촘한 삼각형 그물을 깔고, 그물의 각 점이 가까운 뼈를 따라 움직이게 한다.
## 뼈 위치(관절 좌표)는 캐릭터마다 scripts/rigs.gd 에 적는다 (그림 픽셀 좌표).

## 뼈: [이름, 부모, 시작 관절, 끝 관절]. 부모가 ""이면 엉덩이(root)에 붙는다
const BONES := [
	["torso", "", "hip", "neck"],
	["head", "torso", "neck", "head"],
	["arm_b1", "torso", "ba_sh", "ba_el"],
	["arm_b2", "arm_b1", "ba_el", "ba_ha"],
	["arm_f1", "torso", "fa_sh", "fa_el"],
	["arm_f2", "arm_f1", "fa_el", "fa_ha"],
	["leg_b1", "", "bl_hip", "bl_kn"],
	["leg_b2", "leg_b1", "bl_kn", "bl_ft"],
	["leg_f1", "", "fl_hip", "fl_kn"],
	["leg_f2", "leg_f1", "fl_kn", "fl_ft"],
]
const GRID := 28.0        # 그물 칸 크기 (그림 픽셀)
const WEIGHTS := 3        # 점 하나가 따라가는 뼈 개수

var texture: Texture2D
var rig: Dictionary
var scale := 0.16         # 그림 픽셀 → 게임 화면 크기 (피격 판정보다 조금 크게: 머리가 판정 위로 나옴)

var _points := PackedVector2Array()   # 그물 점 (그림 픽셀 좌표, 쉬는 자세)
var _uvs := PackedVector2Array()
var _indices := PackedInt32Array()
var _w_bone := PackedInt32Array()     # 점마다 영향을 주는 뼈 WEIGHTS개와 비율
var _w_amount := PackedFloat32Array()
var _rest: Array[Transform2D] = []    # 뼈의 쉬는 자세 (월드)
var _local: Array[Transform2D] = []   # 부모 기준 쉬는 자세
var _parent: Array[int] = []
var _length: Array[float] = []        # 뼈 길이
var _bend_sign: Array[float] = []     # 위쪽 뼈: 관절(무릎/팔꿈치)이 꺾이는 방향 (+1 / -1)
var _skin: Array[Transform2D] = []    # 이번 프레임: 쉬는 자세 → 지금 자세


func _init(tex: Texture2D, rig_data: Dictionary) -> void:
	texture = tex
	rig = rig_data
	scale = rig.get("scale", scale)
	_build_bones()
	_build_mesh(tex.get_image())


func _joint(name: String) -> Vector2:
	return rig["joints"][name]


func _bone_index(name: String) -> int:
	for i in BONES.size():
		if BONES[i][0] == name:
			return i
	return -1


func _build_bones() -> void:
	var root := Transform2D(0.0, _joint("hip"))
	for b in BONES:
		var start := _joint(b[2])
		var dir := _joint(b[3]) - start
		var rest := Transform2D(dir.angle(), start)
		var p := _bone_index(b[1])
		_parent.append(p)
		_rest.append(rest)
		_local.append((root if p < 0 else _rest[p]).affine_inverse() * rest)
		_skin.append(Transform2D.IDENTITY)
		_length.append(dir.length())
	# 위쪽 뼈(팔/다리)가 쉬는 자세에서 관절이 어느 쪽으로 꺾여 있는지 → IK에서 같은 쪽으로 꺾는다
	for i in BONES.size():
		var s := 1.0
		var child := i + 1
		if child < BONES.size() and _parent[child] == i:
			var a := _joint(BONES[i][2])
			var mid := _joint(BONES[i][3])
			var end := _joint(BONES[child][3])
			s = 1.0 if (end - a).cross(mid - a) < 0.0 else -1.0
		_bend_sign.append(s)


## 그림에서 투명하지 않은 칸만 그물로 만들고, 점마다 가까운 뼈 2개를 고른다
func _build_mesh(img: Image) -> void:
	var w := img.get_width()
	var h := img.get_height()
	var cols := int(ceil(w / GRID))
	var rows := int(ceil(h / GRID))
	var index_of := {}  # 격자 좌표 → 점 번호
	for r in rows:
		for c in cols:
			if not _cell_visible(img, c, r):
				continue
			var corners := [Vector2i(c, r), Vector2i(c + 1, r), Vector2i(c + 1, r + 1), Vector2i(c, r + 1)]
			var ids: Array[int] = []
			for g: Vector2i in corners:
				if not index_of.has(g):
					var p := Vector2(minf(g.x * GRID, w), minf(g.y * GRID, h))
					index_of[g] = _points.size()
					_points.append(p)
					_uvs.append(p / Vector2(w, h))
					_add_weights(p)
				ids.append(index_of[g])
			_indices.append_array([ids[0], ids[1], ids[2], ids[0], ids[2], ids[3]])


func _cell_visible(img: Image, c: int, r: int) -> bool:
	var step := 4
	for y in range(int(r * GRID), mini(int((r + 1) * GRID), img.get_height()), step):
		for x in range(int(c * GRID), mini(int((c + 1) * GRID), img.get_width()), step):
			if img.get_pixel(x, y).a > 0.05:
				return true
	return false


func _add_weights(p: Vector2) -> void:
	# 가까운 뼈 3개를 거리에 따라 섞는다 (섞는 폭이 넓을수록 부드럽게 휘고, 좁을수록 관절이 또렷하다)
	var ws: Array = []
	for i in BONES.size():
		var a := _joint(BONES[i][2])
		var b := _joint(BONES[i][3])
		var d := p.distance_to(Geometry2D.get_closest_point_to_segment(p, a, b))
		ws.append([1.0 / pow(d + 40.0, 3.0), i])
	ws.sort_custom(func(x: Array, y: Array) -> bool: return x[0] > y[0])
	var total: float = ws[0][0] + ws[1][0] + ws[2][0]
	for k in WEIGHTS:
		_w_bone.append(ws[k][1])
		_w_amount.append(ws[k][0] / total)


## 자세 정하기
## bend: 뼈 이름 → 쉬는 자세에서 더 돌릴 각도 (라디안, + = 그림에서 시계 방향)
## root: 엉덩이를 옮길 거리 (그림 픽셀), root_angle: 몸 전체 기울기
## aim: 뼈 이름(팔/다리 위쪽) → [목표 위치(그림 픽셀), 섞는 정도 0~1]. 팔다리를 쭉 펴서 목표를 가리킨다
## ik: 뼈 이름(팔/다리 위쪽) → 손/발이 닿을 위치 (그림 픽셀). 관절을 알맞게 굽혀서 닿게 한다 (발 고정 등)
func pose(bend: Dictionary, root := Vector2.ZERO, root_angle := 0.0, aim := {}, ik := {}) -> void:
	var root_t := Transform2D(root_angle, _joint("hip") + root)
	var world: Array[Transform2D] = []
	world.resize(BONES.size())
	var aim_angle := {}
	for i in BONES.size():
		var name: String = BONES[i][0]
		var parent_t: Transform2D = root_t if _parent[i] < 0 else world[_parent[i]]
		var base := parent_t * _local[i]
		var delta: float = bend.get(name, 0.0)
		if ik.has(name):  # 위쪽 뼈: 끝(손/발)이 목표에 닿도록 두 관절 IK
			var to: Vector2 = ik[name] - base.origin
			var l1 := _length[i]
			var l2 := _length[i + 1]
			var d := clampf(to.length(), absf(l1 - l2) + 0.01, l1 + l2 - 0.01)
			var a := acos(clampf((l1 * l1 + d * d - l2 * l2) / (2.0 * l1 * d), -1.0, 1.0))
			delta = to.angle() - a * _bend_sign[i] - base.get_rotation()
		elif _parent[i] >= 0 and ik.has(BONES[_parent[i]][0]):  # 아래쪽 뼈: 목표를 향해
			var knee: Vector2 = world[_parent[i]] * Vector2(_length[_parent[i]], 0)
			delta = (ik[BONES[_parent[i]][0]] - knee).angle() - base.get_rotation()
		elif aim.has(name):  # 위쪽 뼈: 목표를 바라보게
			var target: Vector2 = aim[name][0]
			var want := (target - base.origin).angle()
			delta = lerp_angle(delta, want - base.get_rotation(), aim[name][1])
			aim_angle[i] = true
		elif _parent[i] >= 0 and aim_angle.has(_parent[i]):  # 아래쪽 뼈: 위쪽과 일직선으로
			var blend: float = aim[BONES[_parent[i]][0]][1]
			delta = lerp_angle(delta, world[_parent[i]].get_rotation() - base.get_rotation(), blend)
		world[i] = base * Transform2D(delta, Vector2.ZERO)
		_skin[i] = world[i] * _rest[i].affine_inverse()


## 게임 좌표(발 기준, 오른쪽을 볼 때) → 그림 픽셀 좌표
func to_art(game_pos: Vector2) -> Vector2:
	return rig["anchor"] + game_pos / scale


## 쉬는 자세의 관절 위치 (aim 목표를 정할 때 기준으로)
func joint(name: String) -> Vector2:
	return _joint(name)


## canvas에 그리기. 발 사이(anchor)가 (0,0)에 오고, facing이 -1이면 좌우 반전
## body: 몸 전체 변형 (발 기준, 오른쪽을 볼 때 기준. 기울이기/찌그러뜨리기/밀기)
func draw(canvas: CanvasItem, facing: int, offset := Vector2.ZERO, modulate := Color.WHITE,
		body := Transform2D.IDENTITY) -> void:
	var anchor: Vector2 = rig["anchor"]
	var pts := PackedVector2Array()
	pts.resize(_points.size())
	for i in _points.size():
		var p := _points[i]
		var q := Vector2.ZERO
		for k in WEIGHTS:
			q += (_skin[_w_bone[i * WEIGHTS + k]] * p) * _w_amount[i * WEIGHTS + k]
		q = body * ((q - anchor) * scale)
		pts[i] = Vector2(q.x * facing, q.y) + offset
	var colors := PackedColorArray()
	colors.resize(_points.size())
	colors.fill(modulate)
	RenderingServer.canvas_item_add_triangle_array(canvas.get_canvas_item(), _indices, pts, colors, _uvs,
			PackedInt32Array(), PackedFloat32Array(), texture.get_rid())


# ── 자세별 그림 (assets/characters/<id>_<자세>.png) ─────────
## 그물 없이 그림 한 장을 통째로 그린다 (몸 전체 변형만). 발 위치는 그림에서 자동으로 찾는다
static var _anchors := {}


static func find_anchor(tex: Texture2D) -> Vector2:
	var key := tex.resource_path
	if _anchors.has(key):
		return _anchors[key]
	var img := tex.get_image()
	var w := img.get_width()
	var bottom := img.get_height() - 1
	while bottom > 0 and not _row_has_pixels(img, bottom):
		bottom -= 1
	# 맨 아래 60픽셀 안에 있는 발들의 가운데
	var lo := w
	var hi := 0
	for y in range(maxi(0, bottom - 60), bottom + 1, 2):
		for x in range(0, w, 2):
			if img.get_pixel(x, y).a > 0.3:
				lo = mini(lo, x)
				hi = maxi(hi, x)
	var anchor := Vector2((lo + hi) / 2.0, bottom)
	_anchors[key] = anchor
	return anchor


static func _row_has_pixels(img: Image, y: int) -> bool:
	for x in range(0, img.get_width(), 2):
		if img.get_pixel(x, y).a > 0.3:
			return true
	return false


static func draw_image(canvas: CanvasItem, tex: Texture2D, art_scale: float, facing: int, offset: Vector2,
		modulate: Color, body: Transform2D) -> void:
	var anchor := find_anchor(tex)
	var xf := Transform2D(0.0, offset) * Transform2D(0.0, Vector2(facing, 1), 0.0, Vector2.ZERO) * body \
			* Transform2D(0.0, Vector2(art_scale, art_scale), 0.0, -anchor * art_scale)
	canvas.draw_set_transform_matrix(xf)
	canvas.draw_texture(tex, Vector2.ZERO, modulate)
	canvas.draw_set_transform_matrix(Transform2D.IDENTITY)
