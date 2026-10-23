extends Screen
## 키 설정: 1P / 2P의 버튼 배치를 바꾼다 (조작법 화면에서 P)
## 칸을 고르고 P → 새 키(키보드 모드) / 새 버튼(조이스틱 모드)을 누르면 바뀐다. 이미 쓰던 키면 서로 맞바꾼다
## 키보드 키를 누르면 키보드 배치가, 스틱 버튼을 누르면 스틱 배치가 바뀐다 (화면 표시는 마지막에 누른 장치 기준)
## 스틱 방향(레버)은 바꾸지 않고 버튼만. ESC는 언제나 뒤로/취소 (키를 잘못 바꿔도 빠져나올 수 있게)


func _init() -> void:
	bg_name = "controls"


## [액션, 이름 글자 키]
const ROWS := [
	["up", "key_up"], ["down", "key_down"], ["left", "key_left"], ["right", "key_right"],
	["p", "punch"], ["k", "kick"], ["s", "slash"], ["hs", "heavy"], ["d", "key_d"], ["rc", "rc"],
	["start", "key_start"], ["select", "key_select"],
]
const DIRECTIONS := ["up", "down", "left", "right"]

var row := 0
var col := 0              # 0 = 1P, 1 = 2P
var waiting := false      # 새 키를 기다리는 중
var _cooldown := 0        # 방금 바꾼 키가 바로 메뉴 입력으로 먹히지 않게 잠깐 무시


## 지금 모드에서 바꿀 수 있는 줄 + 맨 아래 "기본값으로"
func _rows() -> Array:
	if InputManager.mode == InputManager.Mode.KEYBOARD:
		return ROWS
	return ROWS.filter(func(r: Array) -> bool: return not r[0] in DIRECTIONS)


func _process(delta: float) -> void:
	super(delta)
	if waiting:
		return
	if _cooldown > 0:
		_cooldown -= 1
		return
	if Input.is_action_just_pressed("ui_cancel") or Game.menu_back():
		Game.goto("controls")
		return
	var count := _rows().size() + 1  # + 기본값으로
	row = move_cursor(row, count)
	if Game.menu_pressed("left") or Game.menu_pressed("right"):
		col = 1 - col
		Sfx.play("menu_move")
	if Game.menu_pressed("p"):
		Sfx.play("menu_ok")
		if row == count - 1:
			InputManager.reset_bindings()
			Game.save_settings()
		else:
			waiting = true


func _input(event: InputEvent) -> void:
	if not waiting or not event.is_pressed() or event.is_echo():
		return
	var action: String = _rows()[row][0]
	var player := col + 1
	if event is InputEventKey and event.physical_keycode == KEY_ESCAPE:
		waiting = false
	elif event is InputEventKey:
		if event.physical_keycode in [KEY_F1, KEY_F2, KEY_F3, KEY_F11]:
			return  # 기능 키는 못 쓰게
		InputManager.bind(player, action, event.physical_keycode, true)
		waiting = false
	elif event is InputEventJoypadButton and event.device == player - 1 and not action in DIRECTIONS:
		InputManager.bind(player, action, event.button_index, false)  # 스틱은 버튼만 (방향은 레버)
		waiting = false
	if not waiting:
		Game.save_settings()
		Sfx.play("menu_ok")
		_cooldown = 10
		get_viewport().set_input_as_handled()


func _key_label(player: int, action: String) -> String:
	if InputManager.mode == InputManager.Mode.KEYBOARD:
		return OS.get_keycode_string(InputManager.key_for(player, action))
	return "Btn %d" % InputManager.joy_button_for(player, action)


func _draw() -> void:
	background()
	var mode_name := Game.t("keyboard" if InputManager.mode == InputManager.Mode.KEYBOARD else "joystick")
	header("%s  -  %s" % [Game.t("key_config"), mode_name])
	var cols := [760.0, 1000.0]
	text("1P", 142, 28, Color(1, 0.45, 0.45), cols[0])
	text("2P", 142, 28, Color(0.45, 0.7, 1), cols[1])
	var rows := _rows()
	var gap := 37.0 if rows.size() > 8 else 44.0
	for i in rows.size() + 1:
		var y := 186 + i * gap
		var sel := i == row
		Style.fill(self, Style.slant(180, y - 27, 940, 34, 10), Color(Style.PANEL, 0.9 if i % 2 == 0 else 0.6))
		if i == rows.size():  # 기본값으로
			Style.text(self, Game.t("reset_keys"), Vector2(200, y), 21, Style.GOLD if sel else Style.GRAY)
			if sel:
				Style.outline(self, Style.slant(180, y - 27, 940, 34, 10), Style.WHITE, 3.0)
			continue
		Style.text(self, Game.t(rows[i][1]), Vector2(200, y), 21, Style.WHITE)
		for c in 2:
			var cell := Style.slant(cols[c] - 95, y - 25, 190, 30, 8)
			var picked := sel and c == col
			if picked:
				Style.fill(self, cell, Style.RED if not waiting else Style.GOLD.darkened(0.2))
				Style.outline(self, cell, Style.WHITE, 2.5)
			var label := "..." if picked and waiting else _key_label(c + 1, rows[i][0])
			text(label, y, 22, Style.GOLD if not picked else Style.WHITE, cols[c], 4)
	var hint := Game.t("key_config_hint")
	if waiting:
		var name := Game.t(rows[row][1])
		hint = Game.t("press_new_key" if InputManager.mode == InputManager.Mode.KEYBOARD else "press_new_button") % name
	Style.fill(self, Style.slant(W / 2 - 360, 680, 720, 30, 10), Color(Style.BLACK, 0.8))
	text(hint, 701, 18, Style.WHITE if waiting else Style.GRAY, W / 2, 0)
