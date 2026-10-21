extends Node
## 게임 전체 상태 (Autoload 싱글톤, 이름: Game)
## 화면이 바뀌어도 유지돼야 하는 것들: 모드, 고른 캐릭터, 언어, 화면 이동

enum Mode { VERSUS, TRAINING, CPU }
enum Language { EN, KO }

const GAME_TITLE := "Guilty JSHS"

const ROUNDS_TO_WIN := 2       # 2선승제
const ROUND_SECONDS := 60

## 영어/한국어 둘 다 되는 폰트 (Pretendard, SIL OFL 1.1 - assets/fonts/Pretendard-LICENSE.txt)
const FONT: Font = preload("res://assets/fonts/Pretendard-Bold.otf")
## 제목/연출용 굵은 폰트: 영문 Anton(세로로 긴 광고체) + 한글 Black Han Sans (둘 다 SIL OFL 1.1, assets/fonts/*-OFL.txt)
## Anton에 없는 글자(한글, √ 등)는 다음 폰트에서 찾아 쓴다
var TITLE_FONT: FontFile = _make_title_font()


static func _make_title_font() -> FontFile:
	var f: FontFile = load("res://assets/fonts/Anton-Regular.ttf").duplicate()
	f.fallbacks = [load("res://assets/fonts/BlackHanSans-Regular.ttf"), FONT]
	return f

const SETTINGS_PATH := "user://settings.cfg"

## 캐릭터 목록. 새 캐릭터는 여기에 한 줄 추가 + scripts/characters/에 파일 추가
## club: [영어, 한국어]
## 일러스트: assets/characters/<id>.png 가 있으면 캐릭터 선택/VS 화면에 쓴다 (없으면 색 네모)
## face: 일러스트에서 얼굴 위치 (얼굴 중심 x, 얼굴 중심 y, 얼굴 크기) — 셋 다 "그림 폭"에 대한 비율
##       체력바 초상화와 필살기 컷인이 이 부분을 잘라 쓴다. 그림이 없으면 무시
const CHARACTERS: Array[Dictionary] = [
	{
		"id": "chemikid", "name": "CHEMIKID", "club": ["CHEMISTRY CLUB  Chemikid", "화학 동아리  Chemikid"],
		"color": Color(0.30, 0.85, 0.45), "script": "res://scripts/characters/chemikid.gd", "face": Vector3(0.61, 0.145, 0.22),
	},
	{
		"id": "common", "name": "COMMON", "club": ["COMPUTER CLUB  COMMON", "정보 동아리  COMMON"],
		"color": Color(0.30, 0.65, 1.00), "script": "res://scripts/characters/common.gd", "face": Vector3(0.595, 0.14, 0.22),
	},
	{
		"id": "globe", "name": "GLOBE", "club": ["EARTH SCIENCE CLUB  Globe", "지구과학 동아리  Globe"],
		"color": Color("e08a3c"), "script": "res://scripts/characters/globe.gd", "face": Vector3(0.58, 0.18, 0.22),
	},
	{
		"id": "chaos", "name": "CHAOS", "club": ["PHYSICS CLUB  Chaos", "물리 동아리  Chaos"],
		"color": Color("a05cff"), "script": "res://scripts/characters/chaos.gd", "face": Vector3(0.57, 0.14, 0.22),
	},
	{
		"id": "root2", "name": "ROOT2", "club": ["MATH CLUB  Root2", "수학 동아리  Root2"],
		"color": Color("e8d84a"), "script": "res://scripts/characters/root2.gd", "face": Vector3(0.59, 0.165, 0.22),
	},
	{
		"id": "seed", "name": "SEED", "club": ["BIOLOGY CLUB  Seed", "생명 동아리  Seed"],
		"color": Color("ff7ab8"), "script": "res://scripts/characters/seed.gd", "face": Vector3(0.62, 0.15, 0.22),
	},
]

## 스테이지 목록. 배경 그림: assets/stages/<id>.png (1920x1080 권장, 없으면 코드로 그린 임시 배경)
## sky: 임시 배경의 [위, 아래] 색
const STAGES: Array[Dictionary] = [
	{
		"id": "lab", "name": ["CHEMISTRY LAB", "화학 실험실"],
		"sky": [Color("1d2b2a"), Color("0d1414")], "floor": Color("2b2f2e"),
	},
	{
		"id": "computer", "name": ["COMPUTER ROOM", "컴퓨터실"],
		"sky": [Color("101a33"), Color("070b16")], "floor": Color("1e2433"),
	},
	{
		"id": "rooftop", "name": ["ROOFTOP - JEJU SEA", "옥상 - 제주 바다"],
		"sky": [Color("f08a4b"), Color("6a2c5a")], "floor": Color("3a3440"),
	},
	{
		"id": "playground", "name": ["PLAYGROUND", "운동장"],
		"sky": [Color("5aa0d8"), Color("b8d8ea")], "floor": Color("8a6a48"),
	},
	{
		"id": "hallway", "name": ["HALLWAY", "복도"],
		"sky": [Color("3a3a42"), Color("1c1c22")], "floor": Color("5a5550"),
	},
]

## 화면 글자: 키 -> [영어, 한국어]
## 라운드 연출(ROUND 1, FIGHT!, K.O.)은 격투겜 관례라 영어 그대로 둔다
const STRINGS := {
	"subtitle": ["- JEJU SCIENCE HIGH SCHOOL CLUB SHOWDOWN -", "- 제주과학고등학교 동아리 최강자 결정전 -"],
	"press_start": ["PRESS START", "START 버튼을 누르세요"],
	"f1_hint": ["F1: KEYBOARD / JOYSTICK", "F1: 키보드 / 조이스틱 전환"],

	"select_mode": ["SELECT MODE", "모드 선택"],
	"versus": ["VERSUS", "대전"],
	"vs_cpu": ["VS CPU", "CPU 대전"],
	"cpu_easy": ["EASY", "쉬움"],
	"cpu_normal": ["NORMAL", "보통"],
	"cpu_hard": ["HARD", "어려움"],
	"help_cpu": ["1P vs computer.  LEFT/RIGHT: difficulty", "컴퓨터와 대전.  좌우: 난이도 바꾸기"],
	"cpu_select_hint": ["Pick your character, then the CPU's    P: OK    K: BACK",
			"내 캐릭터 → CPU 캐릭터 순서로 고르기    P: 결정    K: 뒤로"],
	"training": ["TRAINING", "트레이닝"],
	"controls": ["CONTROLS", "조작법"],
	"input": ["INPUT", "조작 장치"],
	"keyboard": ["KEYBOARD", "키보드"],
	"joystick": ["JOYSTICK", "조이스틱"],
	"language": ["LANGUAGE", "언어"],
	"language_name": ["ENGLISH", "한국어"],
	"help_versus": ["1P vs 2P. First to %d rounds wins.", "1P 대 2P. %d라운드를 먼저 이기면 승리!"],
	"help_training": ["Practice freely. HP refills, tension is always full.", "자유롭게 연습. 체력은 회복되고 텐션은 항상 가득."],
	"help_controls": ["Check the button layout.", "버튼 배치를 확인합니다."],
	"help_input": ["Switch between keyboard and arcade stick (or press F1).", "키보드 / 아케이드 스틱 전환 (F1로도 가능)"],
	"help_language": ["Change the language.", "언어를 바꿉니다."],
	"menu_hint": ["P / START: OK      K: BACK", "P / START: 결정      K: 뒤로"],
	"back_hint": ["K / START: BACK", "K / START: 뒤로"],

	"move": ["MOVE", "이동"],
	"punch": ["P  (Punch)", "P  (펀치)"],
	"kick": ["K  (Kick)", "K  (킥)"],
	"slash": ["S  (Slash)", "S  (슬래시)"],
	"heavy": ["HS (Heavy Slash)", "HS (헤비 슬래시)"],
	"dust": ["D  (Special: D / 6D / 4D / 2D)", "D  (필살기: D / 앞D / 뒤D / 아래D)"],
	"overdrive": ["OVERDRIVE (D + HS, 50%)", "오버드라이브 (D + HS, 50%)"],
	"rc": ["RC (Roman Cancel)", "RC (로만 캔슬)"],
	"dash": ["DASH", "대시"],
	"guard": ["GUARD", "가드"],
	"start_pause": ["START / PAUSE", "시작 / 일시정지"],
	"select_back": ["SELECT (BACK / PAUSE)", "SELECT (뒤로 / 일시정지)"],
	"combo_hint": ["COMBO: hit or block, then press a stronger button (P > K > S > HS)",
			"콤보: 맞히거나 막히면 더 강한 버튼으로 이어서 (P > K > S > HS)"],

	"char_select": ["CHARACTER SELECT", "캐릭터 선택"],
	"select_hint": ["LEFT/RIGHT: SELECT    P: OK    K: CANCEL", "좌우: 선택    P: 결정    K: 취소"],
	"ok": ["OK!", "결정!"],
	"ready": ["READY!", "준비 완료!"],

	"stage_select": ["STAGE SELECT", "스테이지 선택"],
	"random": ["RANDOM", "랜덤"],
	"stage_hint": ["LEFT/RIGHT: SELECT    P: OK    K: BACK", "좌우: 선택    P: 결정    K: 뒤로"],
	"training_select_hint": ["Pick your character, then the dummy's    P: OK    K: BACK",
			"내 캐릭터 → 더미 캐릭터 순서로 고르기    P: 결정    K: 뒤로"],
	"dummy": ["DUMMY", "더미"],
	"hitbox": ["HITBOX", "판정 보기"],
	"on": ["ON", "켜짐"],
	"off": ["OFF", "꺼짐"],
	"dummy_human": ["2P CONTROL", "2P가 조작"],
	"dummy_stand": ["STAND", "서 있기"],
	"dummy_crouch": ["CROUCH", "앉기"],
	"dummy_jump": ["JUMP", "점프"],
	"dummy_guard": ["STAND GUARD", "서서 가드"],
	"dummy_guard_low": ["CROUCH GUARD", "앉아서 가드"],
	"dummy_guard_auto": ["AUTO GUARD", "자동 가드"],
	"quit_confirm": ["Quit the game?", "게임을 종료할까요?"],
	"quit_hint": ["P: YES    K / ESC: NO", "P: 예    K / ESC: 아니오"],
	"esc_hint": ["ESC: QUIT", "ESC: 종료"],

	"pause": ["PAUSE", "일시정지"],
	"resume": ["RESUME", "계속하기"],
	"rematch": ["REMATCH", "재경기"],
	"to_char_select": ["CHARACTER SELECT", "캐릭터 선택"],
	"to_title": ["TITLE", "타이틀로"],
	"command_list": ["COMMAND LIST", "기술표"],
	"command_hint": ["K / START: CLOSE", "K / START: 닫기"],
	"common_moves": ["COMMON", "공통"],
	"wins": ["%dP %s WINS!", "%dP %s 승리!"],
	"draw_game": ["DRAW GAME", "무승부"],
}

## 기술표: 캐릭터 id -> [입력, 영어 이름, 한국어 이름, 한국어 설명]  (→ = 상대 쪽, ← = 반대쪽)
## 기술을 바꾸면 여기와 docs/MOVES.md도 같이 고친다
const MOVE_LISTS := {
	"chemikid": [
		["D", "Flask Toss", "플라스크 투척", "포물선, 깨지면 산성 웅덩이"],
		["→ + D", "Catalyst Rush", "촉매 돌진", "빠른 돌진 공격"],
		["↓ + D", "Exotherm", "발열 반응", "위로 폭발하는 대공기 (무적)"],
		["← + D", "Neutralize", "중화 반응", "반격 자세"],
		["AIR D", "Precipitate", "앙금 생성", "바닥에 굳어 투사체를 막는 벽"],
		["D + HS", "THERMITE", "테르밋 반응", "연쇄 폭발 + 불꽃 기둥 (50%)"],
	],
	"common": [
		["D", "Packet Send", "패킷 전송", "빠른 직선 투사체"],
		["→ + D", "Bug Trap", "버그 설치", "바닥 함정 (하단)"],
		["↓ + D", "Firewall", "방화벽", "투사체를 막는 벽"],
		["← + D", "Ctrl+Z", "Ctrl+Z", "1초 전 위치로 되감기"],
		["AIR D", "Binary Search", "이진 탐색", "상대를 따라 내려꽂기"],
		["D + HS", "BLUE SCREEN", "블루스크린", "넓은 공격 + 긴 경직 (50%)"],
	],
	"globe": [
		["D", "Meteor Shower", "유성우", "별똥별 3개"],
		["→ + D", "Tectonic Rush", "지각 돌진", "한 대 버티는 돌진 (아머)"],
		["↓ + D", "Tsunami", "지진해일", "바닥 파도 (하단, 점프로 회피)"],
		["← + D", "Constellation", "별자리 잇기", "별 설치 → 한 번 더 누르면 연결"],
		["AIR D", "Lightning", "낙뢰", "앞쪽에 번개"],
		["D + HS", "TYPHOON", "태풍", "끌어당기며 여러 번 타격 (50%)"],
	],
	"chaos": [
		["D", "Gravitation", "만유인력", "상대를 끌어당김"],
		["→ + D", "Momentum Throw", "운동량 던지기", "가드 불가 잡기"],
		["↓ + D", "EM Pulse", "전자기 펄스", "주변 방전, 감전"],
		["← + D", "Quantum Tunnel", "양자 터널링", "상대 뒤로 순간이동"],
		["AIR D", "Thermal Burst", "열팽창 폭발", "아래 대각선 증기 폭발"],
		["D + HS", "BLACK HOLE", "블랙홀", "빨아들이고 폭발 (50%)"],
	],
	"root2": [
		["D", "√2 Boomerang", "√2 부메랑", "갔다가 돌아오는 투사체"],
		["→ + D", "Compass Thrust", "컴퍼스 찌르기", "아주 긴 리치"],
		["↓ + D", "Integral Pillar", "적분 기둥", "상대 발밑에 기둥"],
		["← + D", "Probability Dice", "확률 주사위", "데미지 = 눈 x 9"],
		["AIR D", "Fibonacci Drop", "피보나치 낙하", "1, 1, 2, 3, 5 낙하"],
		["D + HS", "Q.E.D.", "Q.E.D.", "수식 낙하 + 도장 (50%)"],
	],
	"seed": [
		["D", "Plant Seed", "씨앗 심기", "잠시 뒤 덩굴이 솟음"],
		["→ + D", "Vine Whip", "덩굴 채찍", "긴 리치 채찍"],
		["↓ + D", "Mitosis", "세포분열", "걸어가는 분신"],
		["← + D", "Photosynthesis", "광합성", "체력 회복"],
		["AIR D", "Double Helix", "DNA 이중나선", "여러 번 타격"],
		["D + HS", "EVOLUTION", "진화", "6초 강화 (50%)"],
	],
}

## 모든 캐릭터 공통 조작 (기술표 아래쪽에 표시)
const COMMON_MOVES := [
	["→/← + HS", "Throw", "잡기", "붙어서. 가드 불가 (경직·공중 상대는 X)"],
	["P → K → S → HS", "Gatling", "개틀링", "맞히거나 막히면 더 강한 버튼으로"],
	["RC", "Roman Cancel", "로만 캔슬", "공격 취소 (텐션 50%)"],
	["DASH", "Dash / Air Dash", "대시 / 공중 대시", "← + DASH = 백스텝"],
]

const SCENES := {
	"title": "res://scenes/title.tscn",
	"mode_select": "res://scenes/mode_select.tscn",
	"controls": "res://scenes/controls.tscn",
	"char_select": "res://scenes/char_select.tscn",
	"stage_select": "res://scenes/stage_select.tscn",
	"battle": "res://scenes/battle.tscn",
}

var mode: Mode = Mode.VERSUS
var language: Language = Language.EN
var selected := { 1: 0, 2: 1 }  # 플레이어 -> CHARACTERS 인덱스
var stage := 0                  # STAGES 인덱스
var stage_random := true        # 스테이지 선택에서 RANDOM을 골랐으면 매 경기 랜덤

## 트레이닝 더미 (2P 자리) 동작. Fighter.Dummy와 순서가 같다
const DUMMY_KEYS := ["dummy_human", "dummy_stand", "dummy_crouch", "dummy_jump",
		"dummy_guard", "dummy_guard_low", "dummy_guard_auto"]
var dummy_mode := 1             # 기본: 서 있기 (혼자서도 연습할 수 있게)
var cpu_level := 1              # CpuBrain.Level (0 쉬움, 1 보통, 2 어려움)
const CPU_LEVEL_KEYS := ["cpu_easy", "cpu_normal", "cpu_hard"]


## 혼자 하는 모드 (캐릭터를 한 사람이 둘 다 고른다)
func is_solo() -> bool:
	return mode == Mode.TRAINING or mode == Mode.CPU


func _ready() -> void:
	_load_settings()
	InputManager.mode_changed.connect(func(_m): save_settings())


func _unhandled_input(event: InputEvent) -> void:
	# F11: 전체 화면 켜기/끄기 (축제 때는 전체 화면으로)
	if event is InputEventKey and event.pressed and not event.echo \
			and event.physical_keycode == KEY_F11:
		var full := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
				DisplayServer.WINDOW_MODE_WINDOWED if full else DisplayServer.WINDOW_MODE_FULLSCREEN)


## 번역된 글자. 예: Game.t("press_start")
func t(key: String) -> String:
	return STRINGS[key][language]


func toggle_language() -> void:
	language = Language.KO if language == Language.EN else Language.EN
	save_settings()


# ── 설정 저장 (언어, 조작 모드) ───────────────────────────
## user:// 는 Windows에서 %APPDATA%\Godot\app_userdata\GGJSHS 폴더
func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("game", "language", language)
	cfg.set_value("game", "input_mode", InputManager.mode)
	cfg.save(SETTINGS_PATH)


func _load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return
	language = cfg.get_value("game", "language", Language.EN)
	InputManager.set_mode(cfg.get_value("game", "input_mode", InputManager.Mode.KEYBOARD))


# ── 화면 이동 / 캐릭터 ────────────────────────────────────
func goto(scene: String) -> void:
	get_tree().change_scene_to_file.call_deferred(SCENES[scene])


func character(player: int) -> Dictionary:
	return CHARACTERS[selected[player]]


func club_name(info: Dictionary) -> String:
	return info["club"][language]


func stage_info() -> Dictionary:
	return STAGES[stage]


## 그림 파일이 있으면 불러오고, 없으면 null (그림이 아직 없어도 게임이 돌아가게)
## 그림 불러오기 (없으면 null). 한 번 불러온 그림은 계속 들고 있는다
## (안 들고 있으면 매 프레임 그릴 때마다 새로 불러오게 되고, 막 불러온 그림은 하얀 네모로 그려진다)
var _textures := {}

func load_texture(path: String) -> Texture2D:
	if not _textures.has(path):
		_textures[path] = load(path) if ResourceLoader.exists(path) else null
	return _textures[path]


func character_art(info: Dictionary) -> Texture2D:
	return load_texture("res://assets/characters/%s.png" % info["id"])


## 화면 전용 그림: kind = "select"(선택창 상반신) / "face"(얼굴 아이콘) / "cutin"(필살기 컷인). 없으면 null
func character_image(info: Dictionary, kind: String) -> Texture2D:
	return load_texture("res://assets/characters/%s_%s.png" % [info["id"], kind])


## 얼굴 그림과 잘라 쓸 영역: 전용 그림(face/cutin)이 있으면 그 가운데를, 없으면 전신 그림의 얼굴 부분을
## aspect = 가로/세로 비율. 그림이 하나도 없으면 빈 배열
func face_image(info: Dictionary, aspect := 1.0, kind := "face", zoom := 1.0) -> Array:
	var tex := character_image(info, kind)
	if tex != null:
		var size := Vector2(tex.get_width(), tex.get_height())
		var crop := Vector2(minf(size.x, size.y * aspect), minf(size.y, size.x / aspect))
		return [tex, Rect2((size - crop) / 2, crop)]
	var art := character_art(info)
	if art == null:
		return []
	return [art, face_rect(info, art, aspect, zoom)]


## 일러스트에서 얼굴 부분 (픽셀 단위). aspect = 가로/세로 비율, zoom > 1이면 얼굴 주변까지 넓게
func face_rect(info: Dictionary, art: Texture2D, aspect := 1.0, zoom := 1.0) -> Rect2:
	var f: Vector3 = info.get("face", Vector3(0.5, 0.15, 0.3))
	var w := float(art.get_width())
	var h := f.z * w * zoom
	var size := Vector2(h * aspect, h)
	var rect := Rect2(Vector2(f.x, f.y) * w - size / 2, size)
	rect.position.y = maxf(rect.position.y, 0.0)  # 그림 위로 벗어나지 않게
	return rect


# ── 메뉴 입력 ─────────────────────────────────────────────
## player가 0이면 1P/2P 아무나
func menu_pressed(action: String, player := 0) -> bool:
	for p in ([1, 2] if player == 0 else [player]):
		if Input.is_action_just_pressed(InputManager.action_name(p, action)):
			return true
	return false


## 메뉴의 "결정" (P 또는 START). 눌렸으면 결정음
func menu_confirm(player := 0) -> bool:
	var pressed := menu_pressed("p", player) or menu_pressed("start", player)
	if pressed:
		Sfx.play("menu_ok")
	return pressed


## 메뉴의 "뒤로" (K, SELECT, 키보드 ESC)
func menu_back(player := 0) -> bool:
	var pressed := menu_pressed("k", player) or menu_pressed("select", player) \
			or (player == 0 and Input.is_action_just_pressed("ui_cancel"))
	if pressed:
		Sfx.play("menu_back")
	return pressed


## 일시정지 (START, SELECT, 키보드 ESC)
func pause_pressed() -> bool:
	return menu_pressed("start") or menu_pressed("select") or Input.is_action_just_pressed("ui_cancel")
