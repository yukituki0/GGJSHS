extends Node2D
## 대전 화면 HUD + 연출 (캐릭터보다 위에 그려지도록 z_index가 높은 노드)
## 체력/텐션/타이머/라운드, ROUND·FIGHT·K.O. 띠, VS 화면, 일시정지·결과 메뉴, 타격 이펙트

const HP_W := 470.0
const HP_H := 30.0
const SKEW := 14.0

@onready var m: Match = owner  # HUD는 카메라 영향을 안 받게 CanvasLayer 안에 있다

var _trail := { 1: 0.0, 2: 0.0 }  # 빨간 "방금 깎인 체력" 표시 (천천히 따라 줄어든다)
var _tex := {}                     # HUD 그림 (assets/ui/hud_*.png). 하나라도 없으면 코드로 그린 HUD 사용
var _use_images := false
var _bg_vs: Texture2D               # assets/ui/bg_vs.png (없으면 검은 배경)
var _bg_result: Texture2D           # assets/ui/bg_result.png (없으면 경기 화면 위에 메뉴만)


func _ready() -> void:
	for n in ["hud_hp_frame", "hud_hp_fill", "hud_timer",
			"hud_tension_p1_empty", "hud_tension_p1_full", "hud_tension_p2_empty", "hud_tension_p2_full"]:
		_tex[n] = Game.load_texture("res://assets/ui/%s.png" % n)
	_use_images = not _tex.values().has(null)
	_bg_vs = Game.load_texture("res://assets/ui/bg_vs.png")
	_bg_result = Game.load_texture("res://assets/ui/bg_result.png")


func _process(_delta: float) -> void:
	for f in [m.p1, m.p2]:
		var hp := float(f.hp)
		if _trail[f.player] < hp:
			_trail[f.player] = hp  # 회복/새 라운드
		elif f.state != Fighter.State.HITSTUN:
			_trail[f.player] = maxf(hp, _trail[f.player] - 2.5)  # 콤보가 끝나면 줄어든다
	queue_redraw()


func _draw() -> void:
	if m.tint_frames > 0:  # 화면 전체 색 효과 (블루스크린 등)
		draw_rect(Rect2(-20, -20, 1320, 760), Color(m.tint_color, m.tint_color.a * minf(1.0, m.tint_frames / 15.0)))
	_draw_sparks()
	if m.superflash > 0:
		_draw_superflash()
	if m.phase != Match.Phase.VS_INTRO:
		_draw_hud()
	match m.phase:
		Match.Phase.VS_INTRO:
			_draw_vs()
		Match.Phase.ROUND_INTRO:
			if m.phase_frame < 60:
				var last: bool = m.wins[1] == Game.ROUNDS_TO_WIN - 1 and m.wins[2] == Game.ROUNDS_TO_WIN - 1
				Style.banner(self, "FINAL ROUND" if last else "ROUND %d" % m.round_number,
						Style.WHITE, m.phase_frame / 14.0)
			else:
				Style.banner(self, "FIGHT!", Style.GOLD, (m.phase_frame - 60) / 10.0)
		Match.Phase.ROUND_END:
			Style.banner(self, m.round_result, Style.GOLD, m.phase_frame / 12.0)
		Match.Phase.RESULT:
			_draw_result()
	if m.paused:
		if m.show_moves:
			_draw_move_lists()
		else:
			_draw_menu(Game.t("pause"), m.pause_items())


# ── 그림 HUD (assets/ui/hud_*.png) ─────────────────────────
## 위치/크기는 1P(왼쪽) 기준. 2P는 좌우 반전 (텐션바는 글자가 있어서 반전 안 함)
## *_SLOT, *_SRC는 그림 크기에 대한 비율 (x, y, 폭, 높이). 그림을 바꾸면 이 숫자를 다시 재야 한다
const IMG_HP_FRAME_W := 560.0
const IMG_TOP_OFFSET := 30.0       # 위쪽 HUD 전체를 아래로 내리는 양 (화면 위에서 잘리지 않게)
const IMG_HP_FRAME_Y := -40.0 + IMG_TOP_OFFSET
const IMG_HP_BAR_SLOT := Rect2(0.2645, 0.3859, 0.6682, 0.212)      # 틀 안의 빈 바 자리
const IMG_HP_PORTRAIT_SLOT := Rect2(0.0909, 0.2554, 0.16, 0.4402)   # 틀 안의 육각형 초상화 자리
const IMG_HP_FILL_SRC := Rect2(0.0809, 0.2343, 0.8664, 0.5486)      # 채움 그림에서 실제 색 부분
const IMG_TIMER_W := 150.0
const IMG_TIMER_CENTER := Vector2(640, 52 + IMG_TOP_OFFSET)
const IMG_TEN_FRAME_W := 360.0
const IMG_TEN_BOTTOM := 712.0
## 텐션바는 1P/2P 그림이 따로 있다 (빈 것 + 꽉 찬 것). 꽉 찬 그림의 채움 자리를 비율만큼 잘라 빈 그림 위에 덮는다
const IMG_TEN_SLOT := {
	1: Rect2(0.3237, 0.4408, 0.5779, 0.2796),
	2: Rect2(0.105, 0.3824, 0.629, 0.2821),
}
const TRAIL_TINT := Color(1.0, 0.2, 0.15)


func _draw_hud_images() -> void:
	var hp_frame: Texture2D = _tex["hud_hp_frame"]
	var frame_h := IMG_HP_FRAME_W * hp_frame.get_height() / hp_frame.get_width()
	var frame := Rect2(0, IMG_HP_FRAME_Y, IMG_HP_FRAME_W, frame_h)  # 1P 기준
	var slot := _sub(frame, IMG_HP_BAR_SLOT)
	for f: Fighter in [m.p1, m.p2]:
		# 2P는 화면 가운데(x=640)를 기준으로 거울처럼 뒤집어서 1P와 같은 좌표로 그린다
		if f.player == 2:
			draw_set_transform(Vector2(1280, 0), 0.0, Vector2(-1, 1))
		_draw_portrait_hex(f, _sub(frame, IMG_HP_PORTRAIT_SLOT))
		# 빨간 잔상 → 현재 체력 (초상화 쪽 기준으로 채움)
		var ratio := float(f.hp) / f.max_hp
		var tint := Color.WHITE
		if ratio <= 0.25 and Time.get_ticks_msec() % 400 < 200:
			tint = Color(1.4, 1.1, 1.1)  # 체력 적으면 깜빡임
		_fill_part(_tex["hud_hp_fill"], IMG_HP_FILL_SRC, slot, _trail[f.player] / f.max_hp, false, TRAIL_TINT)
		_fill_part(_tex["hud_hp_fill"], IMG_HP_FILL_SRC, slot, ratio, false, tint)
		draw_texture_rect(hp_frame, frame, false)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		# 여기부터 글자: 뒤집으면 안 되니까 변환 없이
		if Game.character_art(Game.character(f.player)) == null:
			var port := _sub(frame, IMG_HP_PORTRAIT_SLOT)
			var port_x := port.position.x if f.player == 1 else 1280.0 - port.end.x
			Style.text(self, f.display_name.substr(0, 1), Vector2(port_x, port.get_center().y + 20), 54,
					Style.WHITE, HORIZONTAL_ALIGNMENT_CENTER, port.size.x, 8)
		# 이름: 바 아래
		var name_x := slot.position.x if f.player == 1 else 1280.0 - slot.end.x - 10.0
		Style.text(self, f.display_name, Vector2(name_x, slot.end.y + 26), 24, Color("ff3b3b"),
				HORIZONTAL_ALIGNMENT_LEFT if f.player == 1 else HORIZONTAL_ALIGNMENT_RIGHT, slot.size.x + 10, 7)
		# 가드 게이지: 이름 아래 얇은 바 (꽉 차면 다음 가드가 깨짐)
		var gx := slot.position.x if f.player == 1 else 1280.0 - slot.position.x - GUARD_BAR_W
		_draw_guard_gauge(f, Rect2(gx, slot.end.y + 36, GUARD_BAR_W, 8), f.player == 2)

	# 타이머
	var timer: Texture2D = _tex["hud_timer"]
	var timer_size := Vector2(IMG_TIMER_W, IMG_TIMER_W * timer.get_height() / timer.get_width())
	draw_texture_rect(timer, Rect2(IMG_TIMER_CENTER - timer_size / 2, timer_size), false)
	var secs := ceili(maxi(m.timer_frames, 0) / 60.0)
	var time_text := "--" if m.is_training() else str(secs)
	var col := Style.RED if not m.is_training() and secs <= 10 else Style.WHITE
	Style.text(self, time_text, IMG_TIMER_CENTER + Vector2(-50, 17), 46, col, HORIZONTAL_ALIGNMENT_CENTER, 100, 7)

	# 텐션: 1P는 왼쪽(TENSION 글자 쪽)부터, 2P는 오른쪽(글자 쪽)부터 채움
	for f: Fighter in [m.p1, m.p2]:
		var right := f.player == 2
		var empty: Texture2D = _tex["hud_tension_p%d_empty" % f.player]
		var full: Texture2D = _tex["hud_tension_p%d_full" % f.player]
		var ten_h := IMG_TEN_FRAME_W * empty.get_height() / empty.get_width()
		var tframe := Rect2(10.0 if not right else 1270.0 - IMG_TEN_FRAME_W, IMG_TEN_BOTTOM - ten_h, IMG_TEN_FRAME_W, ten_h)
		draw_texture_rect(empty, tframe, false)
		var slot_n: Rect2 = IMG_TEN_SLOT[f.player]
		var tslot := _sub(tframe, slot_n)
		var rc_ready := f.tension >= Fighter.RC_COST
		var tint := Color(0.65, 0.65, 0.65)
		if rc_ready:
			tint = Color.WHITE.lerp(Color(1.5, 1.4, 1.2), 0.5 + 0.5 * sin(Time.get_ticks_msec() / 120.0))  # 50% 넘으면 반짝
		_fill_part(full, slot_n, tslot, f.tension / Fighter.MAX_TENSION, right, tint)
		var mid := tslot.get_center().x
		draw_line(Vector2(mid, tslot.position.y + 2), Vector2(mid, tslot.end.y - 2), Color(1, 1, 1, 0.6), 2.0)
		var num_x := tframe.end.x + 4 if not right else tframe.position.x - 84
		Style.text(self, "%d%%" % int(f.tension), Vector2(num_x, tframe.end.y - 14), 26,
				Style.GOLD if rc_ready else Style.GRAY, HORIZONTAL_ALIGNMENT_CENTER, 80, 5)


const GUARD_BAR_W := 220.0


func _draw_guard_gauge(f: Fighter, r: Rect2, from_right: bool) -> void:
	var ratio := f.guard_gauge / Fighter.GUARD_MAX
	Style.fill(self, Style.slant(r.position.x, r.position.y, r.size.x, r.size.y, 4), Color(0, 0, 0, 0.7))
	if ratio > 0.0:
		var w := r.size.x * ratio
		var x := r.end.x - w if from_right else r.position.x
		var col := Color("b45cff").lerp(Color("ff3030"), ratio)  # 찰수록 빨개짐
		if ratio >= 1.0 and Time.get_ticks_msec() % 300 < 150:
			col = Color.WHITE  # 꽉 차면 깜빡 (다음 가드에서 깨짐)
		Style.fill(self, Style.slant(x, r.position.y, w, r.size.y, 4), col)
	Style.outline(self, Style.slant(r.position.x, r.position.y, r.size.x, r.size.y, 4), Color(1, 1, 1, 0.6), 1.5)
	Style.text(self, "GUARD", Vector2(r.position.x if not from_right else r.end.x - 60, r.end.y + 14), 12,
			Style.GRAY, HORIZONTAL_ALIGNMENT_LEFT if not from_right else HORIZONTAL_ALIGNMENT_RIGHT, 60, 0)


## 비율 영역 n을 rect 안의 실제 영역으로
func _sub(r: Rect2, n: Rect2) -> Rect2:
	return Rect2(r.position + n.position * r.size, n.size * r.size)


## 채움 그림을 ratio만큼만 slot에 그린다 (from_right면 오른쪽부터 채움)
func _fill_part(t: Texture2D, src_n: Rect2, slot: Rect2, ratio: float, from_right: bool, tint := Color.WHITE) -> void:
	ratio = clampf(ratio, 0.0, 1.0)
	if ratio <= 0.0:
		return
	var ts := t.get_size()
	var full_w := src_n.size.x * ts.x
	var src_x := src_n.position.x * ts.x + (full_w * (1.0 - ratio) if from_right else 0.0)
	var src := Rect2(src_x, src_n.position.y * ts.y, full_w * ratio, src_n.size.y * ts.y)
	var w := slot.size.x * ratio
	var dest := Rect2(slot.position.x + (slot.size.x - w if from_right else 0.0), slot.position.y, w, slot.size.y)
	draw_texture_rect_region(t, dest, src, tint)


## 육각형 초상화 칸: 일러스트가 있으면 얼굴 부분, 없으면 캐릭터 색 + 이니셜
func _draw_portrait_hex(f: Fighter, r: Rect2) -> void:
	var c := r.get_center()
	var hex := PackedVector2Array([
		Vector2(r.position.x, c.y), Vector2(r.position.x + r.size.x * 0.27, r.position.y),
		Vector2(r.end.x - r.size.x * 0.27, r.position.y), Vector2(r.end.x, c.y),
		Vector2(r.end.x - r.size.x * 0.27, r.end.y), Vector2(r.position.x + r.size.x * 0.27, r.end.y),
	])
	var fi := Game.face_image(Game.character(f.player), r.size.x / r.size.y)
	if fi.is_empty():
		Style.fill(self, hex, f.color.darkened(0.3))  # 이니셜 글자는 뒤집히면 안 돼서 _draw_hud_images()에서 따로
		return
	# 얼굴 부분을 육각형 모양으로 (텍스처 좌표 uv로 잘라서 붙이기)
	var art: Texture2D = fi[0]
	var px: Rect2 = fi[1]
	var face := Rect2(px.position / Vector2(art.get_size()), px.size / Vector2(art.get_size()))  # uv는 0~1
	var uvs := PackedVector2Array()
	for p in hex:
		var t: Vector2 = (p - r.position) / r.size
		uvs.append(face.position + t * face.size)
	draw_polygon(hex, PackedColorArray([Color.WHITE]), uvs, art)


# ── 코드로 그린 HUD (그림이 없을 때) ───────────────────────
func _draw_hud() -> void:
	if _use_images:
		_draw_hud_images()
		_draw_round_info(128.0 + IMG_TOP_OFFSET)
		return
	# 위쪽 어두운 띠 (밝은 배경에서도 HUD가 잘 보이게)
	draw_polygon(PackedVector2Array([Vector2(0, 0), Vector2(1280, 0), Vector2(1280, 130), Vector2(0, 130)]),
			PackedColorArray([Color(0, 0, 0, 0.65), Color(0, 0, 0, 0.65), Color(0, 0, 0, 0), Color(0, 0, 0, 0)]))
	_draw_hp_bar(m.p1, 104.0, 1.0)
	_draw_hp_bar(m.p2, 1280.0 - 104.0 - HP_W, -1.0)
	_draw_portrait(m.p1, Game.character(1), Vector2(14, 10), false)
	_draw_portrait(m.p2, Game.character(2), Vector2(1280 - 14 - PORTRAIT, 10), true)
	_draw_name(m.p1, 104.0, false)
	_draw_name(m.p2, 1280.0 - 104.0 - HP_W, true)
	_draw_timer()
	_draw_round_info(98.0)
	_draw_tension_bar(m.p1, 40.0, false)
	_draw_tension_bar(m.p2, 1280.0 - 40.0 - TENSION_W, true)


const PORTRAIT := 82.0
const TENSION_W := 320.0
## 체력바 옆 초상화 (그림이 있으면 얼굴 부분, 없으면 캐릭터 색)
func _draw_portrait(f: Fighter, info: Dictionary, pos: Vector2, right: bool) -> void:
	var slope := -10.0 if right else 10.0
	var frame := Style.slant(pos.x - 4, pos.y - 4, PORTRAIT + 8, PORTRAIT + 8, slope)
	Style.fill(self, frame, Style.BLACK)
	var inner := Rect2(pos, Vector2(PORTRAIT, PORTRAIT))
	var fi := Game.face_image(info)
	if not fi.is_empty():
		Style.texture(self, fi[0], inner, right, fi[1])  # 2P는 좌우 반전
	else:
		Style.gradient(self, Style.slant(pos.x, pos.y, PORTRAIT, PORTRAIT, slope),
				[f.color.lightened(0.2), f.color.lightened(0.2), f.color.darkened(0.5), f.color.darkened(0.5)])
		Style.text(self, f.display_name.substr(0, 1), pos + Vector2(0, 62), 56, Style.WHITE,
				HORIZONTAL_ALIGNMENT_CENTER, PORTRAIT, 8)
	Style.outline(self, frame, Style.GOLD.darkened(0.2), 3.0)


## dir: 1 = 1P(왼쪽, 바깥쪽 기준으로 채움), -1 = 2P(오른쪽, 좌우 반전)
func _draw_hp_bar(f: Fighter, x: float, dir: float) -> void:
	var y := 22.0
	var slope := SKEW * dir
	# 금속 느낌 테두리 (위는 밝고 아래는 어두운 회색)
	Style.gradient(self, Style.slant(x - 7, y - 6, HP_W + 14, HP_H + 12, slope),
			[Color("9a9aa6"), Color("9a9aa6"), Color("2a2a32"), Color("2a2a32")])
	Style.fill(self, Style.slant(x, y, HP_W, HP_H, slope), Color("1a0508"))
	var ratio := float(f.hp) / f.max_hp
	var trail_ratio: float = _trail[f.player] / f.max_hp
	# 빨간 잔상 → 노랑~주황 그라데이션 현재 체력 (1P는 왼쪽 기준, 2P는 오른쪽 기준)
	_bar_part(x, y, trail_ratio, slope, dir, [Style.RED, Style.RED, Style.DARK_RED, Style.DARK_RED])
	var top := Color("ffe46b") if ratio > 0.25 else Color("ffb36b")
	var bottom := Color("f08a17") if ratio > 0.25 else Color("e0301e")
	if ratio <= 0.25 and Time.get_ticks_msec() % 400 < 200:
		top = top.lightened(0.4)  # 체력 적으면 깜빡임
	_bar_part(x, y, ratio, slope, dir, [top, top, bottom, bottom])
	_bar_part(x, y, ratio, slope, dir, [Color(1, 1, 1, 0.45), Color(1, 1, 1, 0.45), Color(1, 1, 1, 0), Color(1, 1, 1, 0)], 10.0)
	Style.outline(self, Style.slant(x, y, HP_W, HP_H, slope), Style.BLACK, 2.0)


func _bar_part(x: float, y: float, ratio: float, slope: float, dir: float, colors: Array, h := HP_H) -> void:
	if ratio <= 0.0:
		return
	var w := HP_W * ratio
	var start := x if dir > 0 else x + HP_W - w
	Style.gradient(self, Style.slant(start, y, w, h, slope * h / HP_H), colors)


## 체력바 아래 이름 (빨간 글자 + 검은 외곽선)
func _draw_name(f: Fighter, x: float, right: bool) -> void:
	Style.text(self, f.display_name, Vector2(x + (0.0 if right else 18.0), 82), 26, Color("ff3b3b"),
			HORIZONTAL_ALIGNMENT_RIGHT if right else HORIZONTAL_ALIGNMENT_LEFT, HP_W - 18, 7)


## 톱니바퀴 모양 타이머
func _draw_timer() -> void:
	var c := Vector2(640, 46)
	var gear := PackedVector2Array()
	var teeth := 12
	for i in teeth * 2:
		var r := 52.0 if i % 2 == 0 else 44.0
		var a0 := (i - 0.5) * TAU / (teeth * 2)
		var a1 := (i + 0.5) * TAU / (teeth * 2)
		gear.append(c + Vector2(r, 0).rotated(a0))
		gear.append(c + Vector2(r, 0).rotated(a1))
	Style.fill(self, gear, Color("3a3a44"))
	Style.outline(self, gear, Color("15151a"), 3.0)
	draw_circle(c, 38, Style.BLACK)
	draw_arc(c, 38, 0, TAU, 40, Style.RED, 3.0)
	var secs := ceili(maxi(m.timer_frames, 0) / 60.0)
	var time_text := "--" if m.is_training() else str(secs)
	var col := Style.RED if not m.is_training() and secs <= 10 else Style.WHITE
	Style.text(self, time_text, Vector2(590, 64), 48, col, HORIZONTAL_ALIGNMENT_CENTER, 100, 6)


## 라운드 승수(마름모) 또는 TRAINING 글자
func _draw_round_info(y: float) -> void:
	if m.is_training():
		Style.text(self, Game.t("training"), Vector2(0, y + 30), 18, Style.GOLD, HORIZONTAL_ALIGNMENT_CENTER, 1280, 6)
		return
	for i in Game.ROUNDS_TO_WIN:
		_draw_round_pip(Vector2(566 - i * 24, y), m.wins[1] > i)
		_draw_round_pip(Vector2(714 + i * 24, y), m.wins[2] > i)


func _draw_round_pip(pos: Vector2, won: bool) -> void:
	var d := PackedVector2Array([pos + Vector2(0, -9), pos + Vector2(9, 0), pos + Vector2(0, 9), pos + Vector2(-9, 0)])
	Style.fill(self, d, Style.GOLD if won else Style.PANEL)
	Style.outline(self, d, Style.WHITE, 2.0)


# ── 아래쪽: 텐션 게이지 ───────────────────────────────────
func _draw_tension_bar(f: Fighter, x: float, right: bool) -> void:
	var y := 680.0
	var w := TENSION_W
	var h := 18.0
	var slope := -10.0 if right else 10.0
	Style.gradient(self, Style.slant(x - 6, y - 5, w + 12, h + 10, slope),
			[Color("9a9aa6"), Color("9a9aa6"), Color("2a2a32"), Color("2a2a32")])
	Style.fill(self, Style.slant(x, y, w, h, slope), Color("12100c"))
	var ratio := f.tension / Fighter.MAX_TENSION
	var fw := w * ratio
	var start := x + w - fw if right else x
	var rc_ready := f.tension >= Fighter.RC_COST
	var top := Color("ffd35a") if rc_ready else Color("c98a2a")
	var bottom := Color("e0501e") if rc_ready else Color("7a3a12")
	if rc_ready:
		top = top.lightened(0.3 * (0.5 + 0.5 * sin(Time.get_ticks_msec() / 120.0)))  # 50% 넘으면 반짝
	if fw > 0:
		Style.gradient(self, Style.slant(start, y, fw, h, slope), [top, top, bottom, bottom])
	# 50% 눈금
	var mid := x + w / 2
	draw_line(Vector2(mid + slope, y), Vector2(mid, y + h), Style.WHITE, 2.0)
	Style.outline(self, Style.slant(x, y, w, h, slope), Style.BLACK, 2.0)
	# "TENSION" 글자 + 숫자
	var align := HORIZONTAL_ALIGNMENT_RIGHT if right else HORIZONTAL_ALIGNMENT_LEFT
	Style.text(self, "TENSION", Vector2(x + (0.0 if right else 14.0), y + 15), 15, Style.WHITE, align, w - 14, 4)
	var num_x := x - 90 if right else x + w + 16
	Style.text(self, "%d%%" % int(f.tension), Vector2(num_x, y + 18), 26,
			Style.GOLD if rc_ready else Style.GRAY, HORIZONTAL_ALIGNMENT_CENTER, 74, 5)


## 게임 세계 좌표 → 화면 좌표 (카메라가 따라가며 확대하므로)
func _to_screen(world_pos: Vector2) -> Vector2:
	return get_viewport().get_canvas_transform() * world_pos


# ── 타격 이펙트 ───────────────────────────────────────────
func _draw_sparks() -> void:
	# 맞으면 금색 별, 막히면 하늘색 원
	for spark in m.sparks:
		var pos := _to_screen(spark[0])
		var t: float = spark[1] / 10.0
		if spark[2]:
			draw_arc(pos, 30 * (1.5 - t), 0, TAU, 24, Color(Style.CYAN, t), 5.0)
		else:
			for i in 8:
				var dir := Vector2.RIGHT.rotated(i * TAU / 8 + 0.2)
				draw_line(pos + dir * 10, pos + dir * (24 + 46 * (1.0 - t)), Color(Style.GOLD, t), 6.0)
			draw_circle(pos, 16 * t, Color(1, 1, 1, t))


# ── 오버드라이브 컷인 ─────────────────────────────────────
var _accent_cache := {}


## 컷인 그림의 강조색 (배경 속도선 쪽에서 채도 높은 픽셀들의 평균). 컷인이 없으면 캐릭터 색
func _cutin_color(f: Fighter) -> Color:
	var info := Game.character(f.player)
	var id: String = info["id"]
	if _accent_cache.has(id):
		return _accent_cache[id]
	var col: Color = f.color
	var tex := Game.character_image(info, "cutin")
	if tex != null:
		var img := tex.get_image()
		var sum := Color(0, 0, 0)
		var weight := 0.0
		for y in range(0, img.get_height(), 12):
			for x in range(int(img.get_width() * 0.6), img.get_width(), 12):  # 오른쪽 = 배경 쪽
				var c := img.get_pixel(x, y)
				if c.s > 0.45 and c.v > 0.3:
					sum += c * c.s
					weight += c.s
		if weight > 0.0:
			col = Color(sum.r / weight, sum.g / weight, sum.b / weight)
			col.s = maxf(col.s, 0.7)
			col.v = maxf(col.v, 0.8)
	_accent_cache[id] = col
	return col


func _draw_superflash() -> void:
	var f := m.superflash_fighter
	var t := 1.0 - float(m.superflash) / Match.SUPERFLASH_FRAMES  # 0 → 1
	draw_rect(Rect2(-20, -20, 1320, 760), Color(0, 0, 0, 0.55))
	# 캐릭터 주변 빛
	var center := _to_screen(f.position + Vector2(0, -80))
	draw_circle(center, 60 + t * 500, Color(f.color, 0.25 * (1.0 - t)))
	# 화면을 가로지르는 띠 + 일러스트 + 기술 이름
	var from_left := f.player == 1
	var slide := minf(t * 4.0, 1.0)
	var band_y := 250.0
	var x_off := (1.0 - slide) * (-1400.0 if from_left else 1400.0)
	var accent := _cutin_color(f)
	Style.fill(self, Style.slant(-100 + x_off, band_y, 1480, 190, 40 if from_left else -40), Color(accent.darkened(0.65), 0.94))
	Style.fill(self, Style.slant(-100 + x_off, band_y + 184, 1480, 8, 40 if from_left else -40), accent)
	var fi := Game.face_image(Game.character(f.player), 420.0 / 190.0, "cutin", 1.3)
	if not fi.is_empty():
		var dest := Rect2(Vector2((60.0 if from_left else 800.0) + x_off, band_y), Vector2(420, 190))
		Style.texture(self, fi[0], dest, not from_left, fi[1])
	var title := m.superflash_attack.title
	Style.title(self, title, Vector2(x_off, band_y + 120), 72, Style.WHITE,
			HORIZONTAL_ALIGNMENT_RIGHT if from_left else HORIZONTAL_ALIGNMENT_LEFT, 1280, 12, Style.RED)
	Style.text(self, f.display_name, Vector2(x_off + (0.0 if from_left else 60.0), band_y + 168), 28, Style.GOLD,
			HORIZONTAL_ALIGNMENT_RIGHT if from_left else HORIZONTAL_ALIGNMENT_LEFT, 1220, 5)


# ── VS 화면 ───────────────────────────────────────────────
func _draw_vs() -> void:
	var t := minf(m.phase_frame / 18.0, 1.0)
	var slide := (1.0 - t) * 800
	if _bg_vs != null:
		draw_texture_rect(_bg_vs, Rect2(0, 0, 1280, 720), false)
	else:
		draw_rect(Rect2(0, 0, 1280, 720), Style.BLACK)
	_draw_vs_side(m.p1, Game.character(1), -slide, false)
	_draw_vs_side(m.p2, Game.character(2), slide, true)
	# 가운데 사선
	Style.fill(self, PackedVector2Array([Vector2(680, 0), Vector2(700, 0), Vector2(600, 720), Vector2(580, 720)]), Style.RED)
	if t >= 1.0:
		var pop := minf((m.phase_frame - 18) / 8.0, 1.0)
		Style.title(self, "VS", Vector2(0, 410), int(lerpf(220, 150, pop)), Style.WHITE,
				HORIZONTAL_ALIGNMENT_CENTER, 1280, 18, Style.RED)
		var stage_name: String = Game.stage_info()["name"][Game.language]
		Style.text(self, "STAGE : " + stage_name, Vector2(0, 690), 22, Style.GRAY, HORIZONTAL_ALIGNMENT_CENTER, 1280)


func _draw_vs_side(f: Fighter, info: Dictionary, offset: float, right: bool) -> void:
	var x0 := 640.0 if right else 0.0
	var poly := PackedVector2Array([Vector2(x0 + (40 if right else 0), 0), Vector2(x0 + 640 + (0 if right else 40), 0),
			Vector2(x0 + 640 - (0 if right else 60), 720), Vector2(x0 - (60 if right else 0), 720)])
	for i in poly.size():
		poly[i] = poly[i] + Vector2(offset, 0)
	# 배경 그림이 있으면 반투명 (빨강/파랑 배경이 비치게)
	Style.fill(self, poly, Color(f.color.darkened(0.55), 0.45 if _bg_vs != null else 1.0))
	var art := Game.character_image(info, "select")  # 선택창 상반신 → 없으면 전신
	var full := art == null
	if full:
		art = Game.character_art(info)
	if art != null:
		# 일러스트: 화면 높이에 맞춰서 (2P는 좌우 반전). 상반신 그림은 화면을 꽉 채우게
		var art_scale := (680.0 if full else 720.0) / art.get_height()
		var size := Vector2(art.get_width(), art.get_height()) * art_scale
		var pos := Vector2(x0 + 320 - size.x / 2 + offset, 720 - size.y)
		Style.texture(self, art, Rect2(pos, size), right)
	else:
		draw_rect(Rect2(x0 + 250 + offset, 220, 140, 300), f.color)
	Style.title(self, f.display_name, Vector2(x0 + offset, 640), 72, Style.WHITE,
			HORIZONTAL_ALIGNMENT_CENTER, 640, 12)
	Style.text(self, Game.club_name(info), Vector2(x0 + offset, 676), 22, Style.GOLD,
			HORIZONTAL_ALIGNMENT_CENTER, 640, 4)


# ── 결과 / 일시정지 메뉴 ──────────────────────────────────
func _draw_result() -> void:
	var title: String
	if m.wins[1] >= Game.ROUNDS_TO_WIN and m.wins[2] >= Game.ROUNDS_TO_WIN:
		title = Game.t("draw_game")
	elif m.wins[1] >= Game.ROUNDS_TO_WIN:
		title = Game.t("wins") % [1, m.p1.display_name]
	else:
		title = Game.t("wins") % [2, m.p2.display_name]
	if _bg_result != null:
		# 결과 배경이 천천히 나타나고, 이긴 캐릭터 그림을 왼쪽 빈 곳에
		var fade := minf(m.phase_frame / 20.0, 1.0)
		draw_texture_rect(_bg_result, Rect2(0, 0, 1280, 720), false, Color(1, 1, 1, fade))
		var winner: int = 1 if m.wins[1] >= Game.ROUNDS_TO_WIN else 2
		var art := Game.character_image(Game.character(winner), "select")
		if art == null:
			art = Game.character_art(Game.character(winner))
		if art != null and m.wins[3 - winner] < Game.ROUNDS_TO_WIN:
			var size := Vector2(art.get_width(), art.get_height()) * (660.0 / art.get_height())
			draw_texture_rect(art, Rect2(Vector2(220 - size.x / 2, 720 - size.y), size), false, Color(1, 1, 1, fade))
	_draw_menu(title, Match.RESULT_ITEMS if m.phase_frame >= 60 else [], 0.3 if _bg_result != null else 0.65)


## 기술표: 1P(왼쪽) / 2P(오른쪽) 캐릭터 기술 + 아래에 공통 조작
func _draw_move_lists() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 0.82))
	Style.fill(self, Style.slant(-20, 22, 560, 60, 20), Style.RED)
	Style.text(self, Game.t("command_list"), Vector2(40, 66), 38, Style.WHITE, HORIZONTAL_ALIGNMENT_LEFT, -1, 8)
	for f: Fighter in [m.p1, m.p2]:
		var x := 40.0 if f.player == 1 else 660.0
		var info := Game.character(f.player)
		Style.text(self, "%dP  %s" % [f.player, f.display_name], Vector2(x, 128), 28, f.color.lightened(0.3),
				HORIZONTAL_ALIGNMENT_LEFT, -1, 6)
		var moves: Array = Game.MOVE_LISTS.get(info["id"], [])
		for i in moves.size():
			_draw_move_row(moves[i], x, 172 + i * 62)
	Style.text(self, Game.t("common_moves"), Vector2(40, 562), 22, Style.GOLD, HORIZONTAL_ALIGNMENT_LEFT, -1, 4)
	for i in Game.COMMON_MOVES.size():
		var mv: Array = Game.COMMON_MOVES[i]
		var desc: String = (" - " + mv[3]) if Game.language == Game.Language.KO else ""
		Style.text(self, "%s   %s%s" % [mv[0], mv[1 + Game.language], desc], Vector2(40, 594 + i * 30), 18,
				Style.WHITE, HORIZONTAL_ALIGNMENT_LEFT, -1, 3)
	Style.text(self, Game.t("command_hint"), Vector2(0, 708), 16, Style.GRAY, HORIZONTAL_ALIGNMENT_RIGHT, 1250, 0)


func _draw_move_row(mv: Array, x: float, y: float) -> void:
	Style.fill(self, Style.slant(x, y - 30, 580, 56, 10), Color(Style.PANEL, 0.9))
	Style.fill(self, Style.slant(x, y - 30, 110, 56, 10), Style.RED.darkened(0.3))
	Style.text(self, mv[0], Vector2(x + 4, y + 6), 20, Style.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 110, 4)
	Style.text(self, mv[1 + Game.language], Vector2(x + 126, y - 4), 22, Style.GOLD, HORIZONTAL_ALIGNMENT_LEFT, -1, 4)
	if Game.language == Game.Language.KO:  # 설명은 한국어로만 적어 둠
		Style.text(self, mv[3], Vector2(x + 126, y + 20), 16, Style.WHITE, HORIZONTAL_ALIGNMENT_LEFT, -1, 0)


func _draw_menu(title: String, items: Array, dim := 0.65) -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, dim))
	Style.fill(self, Style.slant(-20, 190, 1320, 90, 20), Style.RED)
	Style.title(self, title, Vector2(0, 258), 64, Style.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 1280, 12)
	for i in items.size():
		var y := 330.0 + i * 70
		var selected := i == m.menu_cursor
		Style.fill(self, Style.slant(440, y, 400, 52, 14), Style.RED if selected else Style.PANEL)
		if selected:
			Style.outline(self, Style.slant(440, y, 400, 52, 14), Style.WHITE, 3.0)
		Style.text(self, m.menu_label(items[i]), Vector2(440, y + 37), 30,
				Style.WHITE if selected else Style.GRAY, HORIZONTAL_ALIGNMENT_CENTER, 414)
