extends Node2D
## 대전 화면 HUD + 연출 (캐릭터보다 위에 그려지도록 z_index가 높은 노드)
## 체력/텐션/타이머/라운드, ROUND·FIGHT·K.O. 띠, VS 화면, 일시정지·결과 메뉴, 타격 이펙트

const HP_W := 500.0
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
	_draw_sparks()
	if m.phase != Match.Phase.VS_INTRO:
		_draw_hud()
	match m.phase:
		Match.Phase.VS_INTRO:
			_draw_vs()
		Match.Phase.ROUND_INTRO:
			if m.phase_frame < 60:
				var last := m.wins[1] == Game.ROUNDS_TO_WIN - 1 and m.wins[2] == Game.ROUNDS_TO_WIN - 1
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


# ── 위쪽: 체력, 이름, 타이머, 라운드 ───────────────────────
func _draw_hud() -> void:
	# 위쪽 어두운 띠 (밝은 배경에서도 HUD가 잘 보이게)
	draw_polygon(PackedVector2Array([Vector2(0, 0), Vector2(1280, 0), Vector2(1280, 120), Vector2(0, 120)]),
			PackedColorArray([Color(0, 0, 0, 0.7), Color(0, 0, 0, 0.7), Color(0, 0, 0, 0), Color(0, 0, 0, 0)]))
	_draw_hp_bar(m.p1, 46.0, 1.0)
	_draw_hp_bar(m.p2, 1280.0 - 46.0 - HP_W, -1.0)
	_draw_name_plate(m.p1, 40.0, false)
	_draw_name_plate(m.p2, 1280.0 - 40.0 - 230.0, true)
	_draw_timer()
	if m.is_training():
		Style.text(self, Game.t("training"), Vector2(0, 132), 18, Style.GOLD, HORIZONTAL_ALIGNMENT_CENTER, 1280, 6)
	else:
		for i in Game.ROUNDS_TO_WIN:
			_draw_round_pip(Vector2(560 - i * 24, 104), m.wins[1] > i)
			_draw_round_pip(Vector2(720 + i * 24, 104), m.wins[2] > i)
	_draw_tension_bar(m.p1, 40.0, false)
	_draw_tension_bar(m.p2, 1280.0 - 40.0 - 300.0, true)


## dir: 1 = 1P(왼쪽, 바깥쪽 기준으로 채움), -1 = 2P(오른쪽, 좌우 반전)
func _draw_hp_bar(f: Fighter, x: float, dir: float) -> void:
	var y := 26.0
	var skew := SKEW * dir
	# 바깥 검은 테두리
	Style.fill(self, Style.slant(x - 6, y - 5, HP_W + 12, HP_H + 10, skew), Style.BLACK)
	Style.fill(self, Style.slant(x, y, HP_W, HP_H, skew), Style.DARK_RED.darkened(0.5))
	var ratio := float(f.hp) / f.max_hp
	var trail_ratio: float = _trail[f.player] / f.max_hp
	# 빨간 잔상 → 금색 현재 체력 (1P는 왼쪽 기준, 2P는 오른쪽 기준으로 채움)
	_bar_part(x, y, trail_ratio, skew, dir, Style.RED)
	var col := Style.GOLD if ratio > 0.25 else Color("ff6a2a")
	if ratio <= 0.25 and Time.get_ticks_msec() % 400 < 200:
		col = col.lightened(0.3)  # 체력 적으면 깜빡임
	_bar_part(x, y, ratio, skew, dir, col)
	# 위쪽 하이라이트 줄
	_bar_part(x, y, ratio, skew, dir, Color(1, 1, 1, 0.25), 6.0)
	Style.outline(self, Style.slant(x, y, HP_W, HP_H, skew), Style.WHITE, 2.0)


func _bar_part(x: float, y: float, ratio: float, skew: float, dir: float, color: Color, h := HP_H) -> void:
	if ratio <= 0.0:
		return
	var w := HP_W * ratio
	var start := x if dir > 0 else x + HP_W - w
	Style.fill(self, Style.slant(start, y, w, h, skew * h / HP_H), color)


func _draw_name_plate(f: Fighter, x: float, right: bool) -> void:
	var skew := -10.0 if right else 10.0
	Style.fill(self, Style.slant(x, 66, 230, 26, skew), Style.BLACK)
	Style.fill(self, Style.slant(x + (226.0 if right else 0.0), 66, 4, 26, skew), Style.RED)
	var tag := "%dP  %s" % [f.player, f.display_name]
	Style.text(self, tag, Vector2(x + 12, 87), 20, Style.WHITE,
			HORIZONTAL_ALIGNMENT_RIGHT if right else HORIZONTAL_ALIGNMENT_LEFT, 206)


func _draw_timer() -> void:
	var c := Vector2(640, 54)
	var hex := PackedVector2Array()
	for i in 6:
		hex.append(c + Vector2(50, 0).rotated(i * TAU / 6) * Vector2(1.0, 0.85))
	Style.fill(self, hex, Style.BLACK)
	Style.outline(self, hex, Style.RED, 3.0)
	var secs := ceili(maxi(m.timer_frames, 0) / 60.0)
	var time_text := "--" if m.is_training() else str(secs)
	var col := Style.RED if not m.is_training() and secs <= 10 else Style.WHITE
	Style.text(self, time_text, Vector2(590, 74), 52, col, HORIZONTAL_ALIGNMENT_CENTER, 100, 6)


func _draw_round_pip(pos: Vector2, won: bool) -> void:
	var d := PackedVector2Array([pos + Vector2(0, -9), pos + Vector2(9, 0), pos + Vector2(0, 9), pos + Vector2(-9, 0)])
	Style.fill(self, d, Style.GOLD if won else Style.PANEL)
	Style.outline(self, d, Style.WHITE, 2.0)


# ── 아래쪽: 텐션 게이지 ───────────────────────────────────
func _draw_tension_bar(f: Fighter, x: float, right: bool) -> void:
	var y := 676.0
	var w := 300.0
	var h := 16.0
	var skew := -8.0 if right else 8.0
	Style.fill(self, Style.slant(x - 4, y - 4, w + 8, h + 8, skew), Style.BLACK)
	var ratio := f.tension / Fighter.MAX_TENSION
	var fw := w * ratio
	var start := x + w - fw if right else x
	var rc_ready := f.tension >= Fighter.RC_COST
	var col := Style.CYAN if rc_ready else Style.CYAN.darkened(0.55)
	if rc_ready:
		col = col.lightened(0.25 * (0.5 + 0.5 * sin(Time.get_ticks_msec() / 120.0)))  # 50% 넘으면 반짝
	if fw > 0:
		Style.fill(self, Style.slant(start, y, fw, h, skew), col)
	# 50% 눈금
	var mid := x + w / 2
	draw_line(Vector2(mid + skew, y), Vector2(mid, y + h), Style.WHITE, 2.0)
	Style.outline(self, Style.slant(x, y, w, h, skew), Style.WHITE, 2.0)
	# "TENSION 50%"
	var label_x := x if not right else x + w - 200
	var align := HORIZONTAL_ALIGNMENT_RIGHT if right else HORIZONTAL_ALIGNMENT_LEFT
	Style.text(self, "TENSION  %d%%" % int(f.tension), Vector2(label_x, y - 8), 18,
			Style.CYAN if rc_ready else Style.GRAY, align, 200, 4)


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
