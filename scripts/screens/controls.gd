extends Screen
## 조작법 화면: 지금 조작 모드의 버튼 배치를 보여준다


func _init() -> void:
	bg_name = "controls"  # assets/ui/bg_controls.png


## [글자 키, 액션들]
const ROWS := [
	["move", ["up", "down", "left", "right"]],
	["punch", ["p"]],
	["kick", ["k"]],
	["slash", ["s"]],
	["heavy", ["hs"]],
	["dust", ["d"]],
	["overdrive", ["d", "hs"]],
	["rc", ["rc"]],
	["burst", ["d", "p"]],
	["throw_tech", ["right", "hs"]],
	["overhead_kick", ["right", "k"]],
	["taunt", ["select"]],
	["dash", ["right", "right"]],  # 1P(오른쪽을 볼 때) 기준으로 표시
	["guard", ["left"]],
	["start_pause", ["start"]],
	["select_back", ["select"]],
]


func _process(delta: float) -> void:
	super(delta)
	if Game.menu_back() or Game.menu_pressed("start"):
		Game.goto("mode_select")
	elif Game.menu_pressed("p"):  # 키 설정 화면으로
		Sfx.play("menu_ok")
		Game.goto("key_config")


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
	var mode_name := Game.t("keyboard" if InputManager.mode == InputManager.Mode.KEYBOARD else "joystick")
	header("%s  -  %s" % [Game.t("controls"), mode_name])
	text("1P", 150, 30, Color(1, 0.45, 0.45), 700)
	text("2P", 150, 30, Color(0.45, 0.7, 1), 980)
	for i in ROWS.size():
		var y := 178 + i * 29
		var label := Game.t(ROWS[i][0])
		var actions: Array = ROWS[i][1]
		Style.fill(self, Style.slant(180, y - 23, 920, 27, 10), Color(Style.PANEL, 0.85 if i % 2 == 0 else 0.5))
		Style.text(self, label, Vector2(200, y), 21, Style.WHITE)
		for p in [1, 2]:
			var names: Array[String] = []
			for a in actions:
				names.append(_input_name(p, a))
			text(" ".join(names), y, 24, Style.GOLD, 700 if p == 1 else 980, 0)
	text(Game.t("combo_hint"), 670, 20, Style.WHITE, W / 2, 4)
	text(Game.t("controls_hint"), 700, 18, Style.GRAY, W / 2, 0)
