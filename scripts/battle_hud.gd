extends Node2D
## 대전 화면 HUD + 연출 (캐릭터보다 위에 그려지도록 z_index가 높은 노드)
## 체력/텐션/타이머/라운드, ROUND·FIGHT·K.O. 띠, VS 화면, 일시정지·결과 메뉴, 타격 이펙트

const HP_W := 470.0
const HP_H := 30.0
const SKEW := 14.0

@onready var m: Match = get_parent()

var _trail := { 1: 0.0, 2: 0.0 }  # 빨간 "방금 깎인 체력" 표시 (천천히 따라 줄어든다)


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
		_draw_menu(Game.t("pause"), Match.PAUSE_ITEMS)


# ── 위쪽: 초상화, 체력, 이름, 타이머, 라운드 ──────────────
func _draw_hud() -> void:
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
	if m.is_training():
		Style.text(self, Game.t("training"), Vector2(0, 128), 18, Style.GOLD, HORIZONTAL_ALIGNMENT_CENTER, 1280, 6)
	else:
		for i in Game.ROUNDS_TO_WIN:
			_draw_round_pip(Vector2(566 - i * 24, 98), m.wins[1] > i)
			_draw_round_pip(Vector2(714 + i * 24, 98), m.wins[2] > i)
	_draw_tension_bar(m.p1, 40.0, false)
	_draw_tension_bar(m.p2, 1280.0 - 40.0 - TENSION_W, true)


const PORTRAIT := 82.0
const TENSION_W := 320.0
## 전신 일러스트에서 얼굴 부분을 잘라 쓸 영역 (그림 크기에 대한 비율: x, y, 폭)
## 그림이 들어온 뒤 얼굴이 잘 안 맞으면 이 숫자만 조정하면 된다
const FACE_CROP := Vector3(0.3, 0.03, 0.4)


## 체력바 옆 초상화 (그림이 있으면 얼굴 부분, 없으면 캐릭터 색)
func _draw_portrait(f: Fighter, info: Dictionary, pos: Vector2, right: bool) -> void:
	var skew := -10.0 if right else 10.0
	var frame := Style.slant(pos.x - 4, pos.y - 4, PORTRAIT + 8, PORTRAIT + 8, skew)
	Style.fill(self, frame, Style.BLACK)
	var inner := Rect2(pos, Vector2(PORTRAIT, PORTRAIT))
	var art := Game.character_art(info)
	if art != null:
		var w := art.get_width() * FACE_CROP.z
		var src := Rect2(art.get_width() * FACE_CROP.x, art.get_height() * FACE_CROP.y, w, w)
		if right:  # 2P는 좌우 반전
			draw_texture_rect_region(art, Rect2(inner.position + Vector2(inner.size.x, 0), Vector2(-inner.size.x, inner.size.y)), src)
		else:
			draw_texture_rect_region(art, inner, src)
	else:
		Style.gradient(self, Style.slant(pos.x, pos.y, PORTRAIT, PORTRAIT, skew),
				[f.color.lightened(0.2), f.color.lightened(0.2), f.color.darkened(0.5), f.color.darkened(0.5)])
		Style.text(self, f.display_name.substr(0, 1), pos + Vector2(0, 62), 56, Style.WHITE,
				HORIZONTAL_ALIGNMENT_CENTER, PORTRAIT, 8)
	Style.outline(self, frame, Style.GOLD.darkened(0.2), 3.0)


## dir: 1 = 1P(왼쪽, 바깥쪽 기준으로 채움), -1 = 2P(오른쪽, 좌우 반전)
func _draw_hp_bar(f: Fighter, x: float, dir: float) -> void:
	var y := 22.0
	var skew := SKEW * dir
	# 금속 느낌 테두리 (위는 밝고 아래는 어두운 회색)
	Style.gradient(self, Style.slant(x - 7, y - 6, HP_W + 14, HP_H + 12, skew),
			[Color("9a9aa6"), Color("9a9aa6"), Color("2a2a32"), Color("2a2a32")])
	Style.fill(self, Style.slant(x, y, HP_W, HP_H, skew), Color("1a0508"))
	var ratio := float(f.hp) / f.max_hp
	var trail_ratio: float = _trail[f.player] / f.max_hp
	# 빨간 잔상 → 노랑~주황 그라데이션 현재 체력 (1P는 왼쪽 기준, 2P는 오른쪽 기준)
	_bar_part(x, y, trail_ratio, skew, dir, [Style.RED, Style.RED, Style.DARK_RED, Style.DARK_RED])
	var top := Color("ffe46b") if ratio > 0.25 else Color("ffb36b")
	var bottom := Color("f08a17") if ratio > 0.25 else Color("e0301e")
	if ratio <= 0.25 and Time.get_ticks_msec() % 400 < 200:
		top = top.lightened(0.4)  # 체력 적으면 깜빡임
	_bar_part(x, y, ratio, skew, dir, [top, top, bottom, bottom])
	_bar_part(x, y, ratio, skew, dir, [Color(1, 1, 1, 0.45), Color(1, 1, 1, 0.45), Color(1, 1, 1, 0), Color(1, 1, 1, 0)], 10.0)
	Style.outline(self, Style.slant(x, y, HP_W, HP_H, skew), Style.BLACK, 2.0)


func _bar_part(x: float, y: float, ratio: float, skew: float, dir: float, colors: Array, h := HP_H) -> void:
	if ratio <= 0.0:
		return
	var w := HP_W * ratio
	var start := x if dir > 0 else x + HP_W - w
	Style.gradient(self, Style.slant(start, y, w, h, skew * h / HP_H), colors)


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


func _draw_round_pip(pos: Vector2, won: bool) -> void:
	var d := PackedVector2Array([pos + Vector2(0, -9), pos + Vector2(9, 0), pos + Vector2(0, 9), pos + Vector2(-9, 0)])
	Style.fill(self, d, Style.GOLD if won else Style.PANEL)
	Style.outline(self, d, Style.WHITE, 2.0)


# ── 아래쪽: 텐션 게이지 ───────────────────────────────────
func _draw_tension_bar(f: Fighter, x: float, right: bool) -> void:
	var y := 680.0
	var w := TENSION_W
	var h := 18.0
	var skew := -10.0 if right else 10.0
	Style.gradient(self, Style.slant(x - 6, y - 5, w + 12, h + 10, skew),
			[Color("9a9aa6"), Color("9a9aa6"), Color("2a2a32"), Color("2a2a32")])
	Style.fill(self, Style.slant(x, y, w, h, skew), Color("12100c"))
	var ratio := f.tension / Fighter.MAX_TENSION
	var fw := w * ratio
	var start := x + w - fw if right else x
	var rc_ready := f.tension >= Fighter.RC_COST
	var top := Color("ffd35a") if rc_ready else Color("c98a2a")
	var bottom := Color("e0501e") if rc_ready else Color("7a3a12")
	if rc_ready:
		top = top.lightened(0.3 * (0.5 + 0.5 * sin(Time.get_ticks_msec() / 120.0)))  # 50% 넘으면 반짝
	if fw > 0:
		Style.gradient(self, Style.slant(start, y, fw, h, skew), [top, top, bottom, bottom])
	# 50% 눈금
	var mid := x + w / 2
	draw_line(Vector2(mid + skew, y), Vector2(mid, y + h), Style.WHITE, 2.0)
	Style.outline(self, Style.slant(x, y, w, h, skew), Style.BLACK, 2.0)
	# "TENSION" 글자 + 숫자
	var align := HORIZONTAL_ALIGNMENT_RIGHT if right else HORIZONTAL_ALIGNMENT_LEFT
	Style.text(self, "TENSION", Vector2(x + (0.0 if right else 14.0), y + 15), 15, Style.WHITE, align, w - 14, 4)
	var num_x := x - 90 if right else x + w + 16
	Style.text(self, "%d%%" % int(f.tension), Vector2(num_x, y + 18), 26,
			Style.GOLD if rc_ready else Style.GRAY, HORIZONTAL_ALIGNMENT_CENTER, 74, 5)


# ── 타격 이펙트 ───────────────────────────────────────────
func _draw_sparks() -> void:
	# 맞으면 금색 별, 막히면 하늘색 원
	for spark in m.sparks:
		var pos: Vector2 = spark[0]
		var t: float = spark[1] / 10.0
		if spark[2]:
			draw_arc(pos, 30 * (1.5 - t), 0, TAU, 24, Color(Style.CYAN, t), 5.0)
		else:
			for i in 8:
				var dir := Vector2.RIGHT.rotated(i * TAU / 8 + 0.2)
				draw_line(pos + dir * 10, pos + dir * (24 + 46 * (1.0 - t)), Color(Style.GOLD, t), 6.0)
			draw_circle(pos, 16 * t, Color(1, 1, 1, t))


# ── 오버드라이브 컷인 ─────────────────────────────────────
func _draw_superflash() -> void:
	var f := m.superflash_fighter
	var t := 1.0 - float(m.superflash) / Match.SUPERFLASH_FRAMES  # 0 → 1
	draw_rect(Rect2(-20, -20, 1320, 760), Color(0, 0, 0, 0.55))
	# 캐릭터 주변 빛
	var center := f.position + Vector2(0, -80)
	draw_circle(center, 60 + t * 500, Color(f.color, 0.25 * (1.0 - t)))
	# 화면을 가로지르는 띠 + 일러스트 + 기술 이름
	var from_left := f.player == 1
	var slide := minf(t * 4.0, 1.0)
	var band_y := 250.0
	var x_off := (1.0 - slide) * (-1400.0 if from_left else 1400.0)
	Style.fill(self, Style.slant(-100 + x_off, band_y, 1480, 190, 40 if from_left else -40), Color(f.color.darkened(0.6), 0.92))
	Style.fill(self, Style.slant(-100 + x_off, band_y + 184, 1480, 8, 40 if from_left else -40), Style.RED)
	var art := Game.character_art(Game.character(f.player))
	if art != null:
		var face_w := art.get_width() * 0.6
		var src := Rect2(art.get_width() * 0.2, art.get_height() * 0.02, face_w, face_w * 190.0 / 420.0)
		var dest := Rect2(Vector2((60.0 if from_left else 800.0) + x_off, band_y), Vector2(420, 190))
		if not from_left:
			dest = Rect2(dest.position + Vector2(dest.size.x, 0), Vector2(-dest.size.x, dest.size.y))
		draw_texture_rect_region(art, dest, src)
	var title := m.superflash_attack.title
	Style.text(self, title, Vector2(x_off, band_y + 120), 72, Style.WHITE,
			HORIZONTAL_ALIGNMENT_RIGHT if from_left else HORIZONTAL_ALIGNMENT_LEFT, 1280, 12, Style.RED)
	Style.text(self, f.display_name, Vector2(x_off + (0.0 if from_left else 60.0), band_y + 168), 28, Style.GOLD,
			HORIZONTAL_ALIGNMENT_RIGHT if from_left else HORIZONTAL_ALIGNMENT_LEFT, 1220, 5)


# ── VS 화면 ───────────────────────────────────────────────
func _draw_vs() -> void:
	var t := minf(m.phase_frame / 18.0, 1.0)
	var slide := (1.0 - t) * 800
	draw_rect(Rect2(0, 0, 1280, 720), Style.BLACK)
	_draw_vs_side(m.p1, Game.character(1), -slide, false)
	_draw_vs_side(m.p2, Game.character(2), slide, true)
	# 가운데 사선
	Style.fill(self, PackedVector2Array([Vector2(680, 0), Vector2(700, 0), Vector2(600, 720), Vector2(580, 720)]), Style.RED)
	if t >= 1.0:
		var pop := minf((m.phase_frame - 18) / 8.0, 1.0)
		Style.text(self, "VS", Vector2(0, 410), int(lerpf(220, 150, pop)), Style.WHITE,
				HORIZONTAL_ALIGNMENT_CENTER, 1280, 18, Style.RED)
		var stage_name: String = Game.stage_info()["name"][Game.language]
		Style.text(self, "STAGE : " + stage_name, Vector2(0, 690), 22, Style.GRAY, HORIZONTAL_ALIGNMENT_CENTER, 1280)


func _draw_vs_side(f: Fighter, info: Dictionary, offset: float, right: bool) -> void:
	var x0 := 640.0 if right else 0.0
	var poly := PackedVector2Array([Vector2(x0 + (40 if right else 0), 0), Vector2(x0 + 640 + (0 if right else 40), 0),
			Vector2(x0 + 640 - (0 if right else 60), 720), Vector2(x0 - (60 if right else 0), 720)])
	for i in poly.size():
		poly[i] = poly[i] + Vector2(offset, 0)
	Style.fill(self, poly, f.color.darkened(0.55))
	var art := Game.character_art(info)
	if art != null:
		# 일러스트: 화면 높이에 맞춰서 (2P는 좌우 반전)
		var art_scale := 680.0 / art.get_height()
		var size := Vector2(art.get_width(), art.get_height()) * art_scale
		var pos := Vector2(x0 + 320 - size.x / 2 + offset, 720 - size.y)
		draw_texture_rect(art, Rect2(pos + (Vector2(size.x, 0) if right else Vector2.ZERO),
				Vector2(-size.x if right else size.x, size.y)), false)
	else:
		draw_rect(Rect2(x0 + 250 + offset, 220, 140, 300), f.color)
	Style.text(self, f.display_name, Vector2(x0 + offset, 640), 72, Style.WHITE,
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
	_draw_menu(title, Match.RESULT_ITEMS if m.phase_frame >= 60 else [])


func _draw_menu(title: String, items: Array) -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 0.65))
	Style.fill(self, Style.slant(-20, 190, 1320, 90, 20), Style.RED)
	Style.text(self, title, Vector2(0, 258), 64, Style.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 1280, 12)
	for i in items.size():
		var y := 330.0 + i * 70
		var selected := i == m.menu_cursor
		Style.fill(self, Style.slant(440, y, 400, 52, 14), Style.RED if selected else Style.PANEL)
		if selected:
			Style.outline(self, Style.slant(440, y, 400, 52, 14), Style.WHITE, 3.0)
		Style.text(self, Game.t(items[i]), Vector2(440, y + 37), 30,
				Style.WHITE if selected else Style.GRAY, HORIZONTAL_ALIGNMENT_CENTER, 414)
