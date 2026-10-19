extends Node
## 게임 전체 상태 (Autoload 싱글톤, 이름: Game)
## 화면이 바뀌어도 유지돼야 하는 것들: 모드, 고른 캐릭터, 언어, 화면 이동

enum Mode { VERSUS, TRAINING }
enum Language { EN, KO }

const GAME_TITLE := "Guilty JSHS"

const ROUNDS_TO_WIN := 2       # 2선승제
const ROUND_SECONDS := 60

## 영어/한국어 둘 다 되는 폰트 (Pretendard, SIL OFL 1.1 - assets/fonts/Pretendard-LICENSE.txt)
const FONT: Font = preload("res://assets/fonts/Pretendard-Bold.otf")

const SETTINGS_PATH := "user://settings.cfg"

## 캐릭터 목록. 새 캐릭터는 여기에 한 줄 추가 + scripts/characters/에 파일 추가
## club: [영어, 한국어]
const CHARACTERS: Array[Dictionary] = [
	{
		"name": "CHEMIKID", "club": ["CHEMISTRY CLUB  Chemikid", "화학 동아리  Chemikid"],
		"color": Color(0.30, 0.85, 0.45), "script": "res://scripts/characters/chemikid.gd",
	},
	{
		"name": "COMMON", "club": ["COMPUTER CLUB  COMMON", "정보 동아리  COMMON"],
		"color": Color(0.30, 0.65, 1.00), "script": "res://scripts/characters/common.gd",
	},
]

## 화면 글자: 키 -> [영어, 한국어]
## 라운드 연출(ROUND 1, FIGHT!, K.O.)은 격투겜 관례라 영어 그대로 둔다
const STRINGS := {
	"subtitle": ["- JEJU SCIENCE HIGH SCHOOL CLUB FIGHTING FESTIVAL -", "- 제주과학고등학교 동아리 파이팅 페스티벌 -"],
	"press_start": ["PRESS START", "START 버튼을 누르세요"],
	"f1_hint": ["F1: KEYBOARD / JOYSTICK", "F1: 키보드 / 조이스틱 전환"],

	"select_mode": ["SELECT MODE", "모드 선택"],
	"versus": ["VERSUS", "대전"],
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
	"dust": ["D  (Dust)", "D  (더스트)"],
	"rc": ["RC (Roman Cancel)", "RC (로만 캔슬)"],
	"dash": ["DASH", "대시"],
	"guard": ["GUARD", "가드"],
	"start_pause": ["START / PAUSE", "시작 / 일시정지"],
	"combo_hint": ["COMBO: hit or block, then press a stronger button (P > K > S > HS)",
			"콤보: 맞히거나 막히면 더 강한 버튼으로 이어서 (P > K > S > HS)"],

	"char_select": ["CHARACTER SELECT", "캐릭터 선택"],
	"select_hint": ["LEFT/RIGHT: SELECT    P: OK    K: CANCEL", "좌우: 선택    P: 결정    K: 취소"],
	"ok": ["OK!", "결정!"],
	"ready": ["READY!", "준비 완료!"],

	"pause": ["PAUSE", "일시정지"],
	"resume": ["RESUME", "계속하기"],
	"rematch": ["REMATCH", "재경기"],
	"to_char_select": ["CHARACTER SELECT", "캐릭터 선택"],
	"to_title": ["TITLE", "타이틀로"],
	"wins": ["%dP %s WINS!", "%dP %s 승리!"],
	"draw_game": ["DRAW GAME", "무승부"],
}

const SCENES := {
	"title": "res://scenes/title.tscn",
	"mode_select": "res://scenes/mode_select.tscn",
	"controls": "res://scenes/controls.tscn",
	"char_select": "res://scenes/char_select.tscn",
	"battle": "res://scenes/battle.tscn",
}

var mode: Mode = Mode.VERSUS
var language: Language = Language.EN
var selected := { 1: 0, 2: 1 }  # 플레이어 -> CHARACTERS 인덱스


func _ready() -> void:
	_load_settings()
	InputManager.mode_changed.connect(func(_m): save_settings())


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


# ── 메뉴 입력 ─────────────────────────────────────────────
## player가 0이면 1P/2P 아무나
func menu_pressed(action: String, player := 0) -> bool:
	for p in ([1, 2] if player == 0 else [player]):
		if Input.is_action_just_pressed(InputManager.action_name(p, action)):
			return true
	return false


## 메뉴의 "결정" (P 또는 START)
func menu_confirm(player := 0) -> bool:
	return menu_pressed("p", player) or menu_pressed("start", player)


## 메뉴의 "뒤로" (K)
func menu_back(player := 0) -> bool:
	return menu_pressed("k", player)
