extends Screen
## 타이틀 화면: 아무나 START(또는 P)를 누르면 모드 선택으로
## 키보드 ESC → "게임을 종료할까요?" (축제 운영용. 조이스틱만으로는 게임이 꺼지지 않게)
##
## 배경: assets/ui/key_art.png (메뉴 일러스트) → 없으면 title_bg.png (목업을 흐리게 만든 임시) → 없으면 코드 배경
## 로고: assets/ui/logo.png → 없으면 글자

const LOGO_W := 560.0            # 로고 폭 (화면 좌표 1280 기준)
const LOGO_CENTER := Vector2(640, 150)   # 메뉴 일러스트의 하늘 쪽 (캐릭터 얼굴을 가리지 않게)
const SUBTITLE_Y := 566.0          # PRESS START 바로 위 (가운데 해와 에너지가 만나는 곳을 가리지 않게)
const START_Y := 640.0

var _quit_confirm := false
var _idle := 0                   # 아무 입력이 없던 프레임 (Game.DEMO_WAIT가 되면 데모)
var _bg: Texture2D
var _logo: Texture2D


func _ready() -> void:
	_bg = Game.load_texture("res://assets/ui/key_art.png")
	if _bg == null:
		_bg = Game.load_texture("res://assets/ui/title_bg.png")
	_logo = Game.load_texture("res://assets/ui/logo.png")


func _process(delta: float) -> void:
	super(delta)
	if _quit_confirm:
		if Game.menu_pressed("p"):
			get_tree().quit()
		elif Game.menu_back():  # K, SELECT, ESC
			_quit_confirm = false
		return
	_idle = 0 if Input.is_anything_pressed() else _idle + 1
	if _idle >= Game.DEMO_WAIT:
		Game.start_demo()
		return
	if Input.is_action_just_pressed("ui_cancel"):
		_quit_confirm = true
	elif frame > 20 and Game.menu_confirm():
		Game.goto("mode_select")


func _draw() -> void:
	_draw_background()
	# 로고: 크게 시작해서 쾅 하고 자리 잡음 (+ 잠깐 하얗게 번쩍)
	var e := 1.0 - pow(1.0 - minf(frame / 22.0, 1.0), 3.0)
	var center := LOGO_CENTER
	if _logo != null:
		var w := LOGO_W * lerpf(1.8, 1.0, e)
		var size := Vector2(w, w * _logo.get_height() / _logo.get_width())
		draw_texture_rect(_logo, Rect2(center - size / 2, size), false, Color(1, 1, 1, minf(1.0, frame / 6.0)))
	else:
		text(Game.GAME_TITLE, center.y + 40, int(lerpf(260, 130, e)), Style.WHITE, W / 2, 16)
	if frame >= 22 and frame < 30:
		draw_rect(Rect2(0, 0, W, H), Color(1, 1, 1, (30 - frame) / 8.0 * 0.6))
	if frame > 22:
		Style.fill(self, Style.slant(W / 2 - 500, SUBTITLE_Y - 42, 1000, 58, -20), Color(Style.BLACK, 0.78))
		Style.title(self, Game.t("subtitle"), Vector2(0, SUBTITLE_Y + 2), 36, Style.GOLD, HORIZONTAL_ALIGNMENT_CENTER, W, 6)
		# 깜빡이는 PRESS START
		if frame % 60 < 36:
			Style.fill(self, Style.slant(W / 2 - 220, START_Y - 40, 440, 56, 18), Style.RED)
			Style.title(self, Game.t("press_start"), Vector2(0, START_Y + 2), 38, Style.WHITE, HORIZONTAL_ALIGNMENT_CENTER, W, 6)
	text("F11: FULLSCREEN    %s" % Game.t("esc_hint"), 700, 16, Style.GRAY, W / 2, 0)
	if _quit_confirm:
		draw_rect(Rect2(0, 0, W, H), Color(0, 0, 0, 0.7))
		Style.fill(self, Style.slant(-20, 280, W + 40, 150, 24), Style.RED)
		text(Game.t("quit_confirm"), 350, 52, Style.WHITE, W / 2, 10)
		text(Game.t("quit_hint"), 405, 26, Style.WHITE, W / 2, 4)


## 배경 그림 + 천천히 확대(살아 있는 느낌) + 아래쪽 붉은 빛 + 비스듬한 빛줄기
func _draw_background() -> void:
	if _bg == null:
		background()
		return
	var zoom := 1.03 + 0.02 * sin(frame * 0.006)  # 항상 1보다 크게 (작아지면 가장자리가 비어 보임)
	var size := Vector2(W, H) * zoom
	draw_texture_rect(_bg, Rect2((Vector2(W, H) - size) / 2, size), false)
	draw_polygon(PackedVector2Array([Vector2(0, H * 0.5), Vector2(W, H * 0.5), Vector2(W, H), Vector2(0, H)]),
			PackedColorArray([Color(Style.RED, 0), Color(Style.RED, 0), Color(Style.RED, 0.35), Color(Style.RED, 0.35)]))
	var sweep := fmod(frame * 4.0, W + 600) - 300
	Style.fill(self, Style.slant(sweep, 0, 90, H, -300), Color(1, 1, 1, 0.05))
