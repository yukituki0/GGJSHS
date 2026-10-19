extends Screen
## 조작법 화면: 지금 조작 모드의 버튼 배치를 보여준다

const ROWS := [
	["MOVE", ["up", "down", "left", "right"]],
	["P  (Punch)", ["p"]],
	["K  (Kick)", ["k"]],
	["S  (Slash)", ["s"]],
	["HS (Heavy Slash)", ["hs"]],
	["D  (Dust)", ["d"]],
	["RC (Roman Cancel)", ["rc"]],
	["DASH", ["dash"]],
	["GUARD", ["guard"]],
	["START / PAUSE", ["start"]],
]


func _process(delta: float) -> void:
	super(delta)
	if Game.menu_back() or Game.menu_pressed("start"):
		Game.goto("mode_select")


## 액션에 연결된 입력 이름 (예: "W", "Num 4", "Joy 3")
func _input_name(player: int, action: String) -> String:
	var events := InputMap.action_get_events(InputManager.action_name(player, action))
	var names: Array[String] = []
	for e in events:
		if e is InputEventKey:
			names.append(OS.get_keycode_string(e.physical_keycode))
		elif e is InputEventJoypadButton:
			names.append("Btn %d" % e.button_index)
		elif e is InputEventJoypadMotion:
			names.append("Stick")
	return names[0] if not names.is_empty() else "-"


func _draw() -> void:
	background()
	var mode_name := "KEYBOARD" if InputManager.mode == InputManager.Mode.KEYBOARD else "JOYSTICK"
	text("CONTROLS  -  " + mode_name, 90, 44)
	text("1P", 150, 30, Color(1, 0.5, 0.5), 700)
	text("2P", 150, 30, Color(0.5, 0.7, 1), 980)
	for i in ROWS.size():
		var y := 205 + i * 44
		var label: String = ROWS[i][0]
		var actions: Array = ROWS[i][1]
		draw_string(ThemeDB.fallback_font, Vector2(200, y), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 24)
		for p in [1, 2]:
			var names: Array[String] = []
			for a in actions:
				names.append(_input_name(p, a))
			text(" ".join(names), y, 24, Color.YELLOW, 700 if p == 1 else 980)
	text("COMBO: hit or block, then press a stronger button (P > K > S > HS)", 650, 20, Color(1, 1, 1, 0.7))
	text("K / START: BACK", 690, 18, Color(1, 1, 1, 0.4))
