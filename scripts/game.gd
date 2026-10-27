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
## 타이머 숫자: Chakra Petch Bold Italic (기울어진 각진 숫자, SIL OFL 1.1 - assets/fonts/ChakraPetch-OFL.txt)
const TIMER_FONT: Font = preload("res://assets/fonts/ChakraPetch-BoldItalic.ttf")


static func _make_title_font() -> FontFile:
	var f: FontFile = load("res://assets/fonts/Anton-Regular.ttf").duplicate()
	f.fallbacks = [load("res://assets/fonts/BlackHanSans-Regular.ttf"), FONT]
	return f

const SETTINGS_PATH := "user://settings.cfg"

## 캐릭터 목록. 새 캐릭터는 여기에 한 줄 추가 + scripts/characters/에 파일 추가
## club: [영어, 한국어]   concept: 한 줄 설정 [영어, 한국어] (캐릭터 설정집에 나옴)
## profile(선택): 긴 설정 글 [영어, 한국어]. 적으면 설정집 아래쪽에 나온다
## 일러스트: assets/characters/<id>.png 가 있으면 캐릭터 선택/VS 화면에 쓴다 (없으면 색 네모)
## face: 일러스트에서 얼굴 위치 (얼굴 중심 x, 얼굴 중심 y, 얼굴 크기) — 셋 다 "그림 폭"에 대한 비율
##       체력바 초상화와 필살기 컷인이 이 부분을 잘라 쓴다. 그림이 없으면 무시
const CHARACTERS: Array[Dictionary] = [
	{
		"id": "chemikid", "name": "CHEMIKID", "club": ["CHEMISTRY CLUB  Chemikid", "화학 동아리  Chemikid"],
		"concept": ["A mad scientist who hurls flasks. Slow, but hits hard.", "플라스크를 던지는 매드 사이언티스트. 느리지만 한 방이 세다"],
		"color": Color(0.30, 0.85, 0.45), "script": "res://scripts/characters/chemikid.gd", "face": Vector3(0.61, 0.145, 0.22),
	},
	{
		"id": "common", "name": "COMMON", "club": ["COMPUTER CLUB  COMMON", "정보 동아리  COMMON"],
		"concept": ["A hacker who confuses opponents with traps and teleports.", "함정과 순간이동으로 상대를 헷갈리게 하는 해커"],
		"color": Color(0.30, 0.65, 1.00), "script": "res://scripts/characters/common.gd", "face": Vector3(0.595, 0.14, 0.22),
	},
	{
		"id": "globe", "name": "GLOBE", "club": ["EARTH SCIENCE CLUB  Globe", "지구과학 동아리  Globe"],
		"concept": ["A heavyweight of land, sea, sky and space. Highest HP, slow, big hits.", "땅·바다·하늘·우주를 다루는 헤비급. 체력 최고, 느림, 한 방이 크다"],
		"color": Color("e08a3c"), "script": "res://scripts/characters/globe.gd", "face": Vector3(0.58, 0.18, 0.22),
	},
	{
		"id": "chaos", "name": "CHAOS", "club": ["PHYSICS CLUB  Chaos", "물리 동아리  Chaos"],
		"concept": ["A grappler who pulls foes in and throws them. Strongest up close.", "끌어당기고 잡아 던지는 잡기형. 가까이 붙어야 강하다"],
		"color": Color("a05cff"), "script": "res://scripts/characters/chaos.gd", "face": Vector3(0.57, 0.14, 0.22),
	},
	{
		"id": "root2", "name": "ROOT2", "club": ["MATH CLUB  Root2", "수학 동아리  Root2"],
		"concept": ["A zoner who controls from range. Low HP, fast.", "멀리서 견제하는 원거리형. 체력은 낮고 빠르다"],
		"color": Color("e8d84a"), "script": "res://scripts/characters/root2.gd", "face": Vector3(0.59, 0.165, 0.22),
	},
	{
		"id": "seed", "name": "SEED", "club": ["BIOLOGY CLUB  Seed", "생명 동아리  Seed"],
		"concept": ["A trickster who plants, divides and evolves.", "심고, 나누고, 진화하는 설치·변칙형"],
		"color": Color("ff7ab8"), "script": "res://scripts/characters/seed.gd", "face": Vector3(0.62, 0.15, 0.22),
	},
]

## 스테이지 목록. 배경 그림: assets/stages/<id>.png (1920x1080 권장, 없으면 코드로 그린 임시 배경)
## sky: 임시 배경의 [위, 아래] 색
## wall_base: 배경 그림에서 벽(길)과 바닥이 만나는 높이 비율. 있으면 그 아래 바닥을 눌러서 캐릭터가 벽 가까이 서 보이게
const STAGES: Array[Dictionary] = [
	{
		"id": "school_front", "name": ["MAIN GATE - SUNSET", "제주과학고 정문 - 석양"],
		"sky": [Color("f0a0b8"), Color("8a7aa8")], "floor": Color("5a5a62"),
	},
	{
		"id": "lobby", "name": ["LOBBY", "중앙 로비"],
		"sky": [Color("e8ecea"), Color("c8d0cc")], "floor": Color("2f6a72"), "wall_base": 0.64,
	},
	{
		"id": "cherry_road", "name": ["CHERRY TREE ROAD", "벚나무 길"],
		"sky": [Color("9fb3c8"), Color("d8dde2")], "floor": Color("4a4a4e"), "wall_base": 0.62,
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
	"press_start": ["PRESS {START}", "{START} 버튼을 누르세요"],
	"press_start_kb": ["PRESS {P}", "{P} 키를 누르세요"],  # 키보드 모드일 때 (뒤에 _kb가 붙은 글자가 있으면 그걸 쓴다)
	"f1_hint": ["F1: KEY NAMES (KEYBOARD / STICK)", "F1: 버튼 이름 표시 (키보드 / 스틱)"],

	"select_mode": ["SELECT MODE", "모드 선택"],
	"versus": ["VERSUS", "대전"],
	"vs_cpu": ["VS CPU", "CPU 대전"],
	"cpu_easy": ["EASY", "쉬움"],
	"cpu_normal": ["NORMAL", "보통"],
	"cpu_hard": ["HARD", "어려움"],
	"cpu_master": ["MASTER", "달인"],
	"help_cpu": ["1P vs computer.  {LR}: difficulty", "컴퓨터와 대전.  {LR}: 난이도 바꾸기"],
	"cpu_select_hint": ["Pick your character, then the CPU's    {P}: OK    {K}: BACK",
			"내 캐릭터 → CPU 캐릭터 순서로 고르기    {P}: 결정    {K}: 뒤로"],
	"training": ["TRAINING", "트레이닝"],
	"controls": ["CONTROLS", "조작법"],
	"input": ["INPUT", "조작 장치"],
	"keyboard": ["KEYBOARD", "키보드"],
	"joystick": ["JOYSTICK", "조이스틱"],
	"language": ["LANGUAGE", "언어"],
	"language_name": ["ENGLISH", "한국어"],
	"help_versus": ["1P vs 2P. First to %d rounds wins.", "1P 대 2P. %d라운드를 먼저 이기면 승리!"],
	"help_training": ["Practice freely. HP refills, tension and mana are always full.", "자유롭게 연습. 체력은 회복되고 텐션과 마력은 항상 가득."],
	"help_controls": ["Check the button layout and change keys.", "버튼 배치를 확인하고 키를 바꿀 수 있어요."],
	"help_input": ["Keyboard and stick always work. This only changes the button names shown (auto, or F1).",
			"키보드와 스틱은 항상 같이 됩니다. 안내에 보일 버튼 이름만 바꿔요 (자동, F1로도 가능)"],
	"help_language": ["Change the language.", "언어를 바꿉니다."],
	"menu_hint": ["{P} / {START}: OK      {K}: BACK", "{P} / {START}: 결정      {K}: 뒤로"],
	"back_hint": ["{K} / {START}: BACK", "{K} / {START}: 뒤로"],
	"controls_hint": ["{P}: KEY CONFIG      {K} / {START}: BACK", "{P}: 키 설정      {K} / {START}: 뒤로"],
	"key_config": ["KEY CONFIG", "키 설정"],
	"key_config_hint": ["ARROWS: MOVE (top row: tab)    {P}: CHANGE    ESC: BACK", "방향키: 이동 (맨 위 줄: 탭 바꾸기)    {P}: 바꾸기    ESC: 뒤로"],
	"tab_keyboard": ["KEYBOARD", "키보드"],
	"tab_stick": ["ARCADE STICK", "아케이드 스틱"],
	"press_new_key": ["Press a new key for %s  (ESC: cancel)", "%s에 쓸 새 키를 누르세요  (ESC: 취소)"],
	"press_new_button": ["Press a new button for %s  (ESC: cancel)", "%s에 쓸 새 버튼을 누르세요  (ESC: 취소)"],
	"reset_keys": ["RESET TO DEFAULT", "기본값으로 되돌리기"],
	"key_up": ["UP (JUMP)", "위 (점프)"],
	"key_down": ["DOWN (CROUCH)", "아래 (앉기)"],
	"key_left": ["LEFT", "왼쪽"],
	"key_right": ["RIGHT", "오른쪽"],
	"key_d": ["D  (Special)", "D  (필살기)"],
	"key_start": ["START", "START (시작/일시정지)"],
	"key_select": ["SELECT", "SELECT (뒤로)"],

	"move": ["MOVE", "이동"],
	"punch": ["P  (Punch)", "P  (펀치)"],
	"kick": ["K  (Kick)", "K  (킥)"],
	"slash": ["S  (Slash)", "S  (슬래시)"],
	"heavy": ["HS (Heavy Slash)", "HS (헤비 슬래시)"],
	"dust": ["D  (Special: D / 6D / 4D / 2D)", "D  (필살기: D / 앞D / 뒤D / 아래D)"],
	"overdrive": ["OVERDRIVE ({D} + {HS}, 50%)", "오버드라이브 ({D} + {HS}, 50%)"],
	"rc": ["RC (Roman Cancel)", "RC (로만 캔슬)"],
	"burst": ["BURST (while hit: {D} + any attack)", "버스트 (맞는 중: {D} + 공격 버튼)"],
	"throw_tech": ["THROW / BREAK  (→/← + {HS} / {HS} when grabbed)", "잡기 / 잡기 풀기  (→/← + {HS} / 잡힐 때 {HS})"],
	"overhead_kick": ["OVERHEAD  (→ + {K})", "중단 발차기  (→ + {K})"],
	"taunt": ["TAUNT ({P} + {K}, gives foe 10%) / → + {P} + {K}: RESPECT", "도발 ({P} + {K}, 상대 텐션 +10%) / 앞 + {P} + {K}: 리스펙트"],
	"demo_play": ["DEMO PLAY  -  PRESS ANY BUTTON", "데모 플레이  -  아무 버튼이나 누르세요"],
	"dash": ["DASH  (→→ / ←← backdash)", "대시  (→→ / ←← 백스텝)"],
	"guard": ["GUARD  (hold ← = high/overhead, ↙ = high/low)", "가드  (← 서서: 상단·중단 / ↙ 앉아: 상단·하단)"],
	"start_pause": ["START / PAUSE", "시작 / 일시정지"],
	"select_back": ["SELECT (BACK / PAUSE)", "SELECT (뒤로 / 일시정지)"],
	"combo_hint": ["COMBO: hit or block, then press a stronger button ({P} > {K} > {S} > {HS})",
			"콤보: 맞히거나 막히면 더 강한 버튼으로 이어서 ({P} > {K} > {S} > {HS})"],

	"char_select": ["CHARACTER SELECT", "캐릭터 선택"],
	"select_hint": ["{LR}: SELECT    {P}: OK    {K}: CANCEL", "{LR}: 선택    {P}: 결정    {K}: 취소"],
	"ok": ["OK!", "결정!"],
	"ready": ["READY!", "준비 완료!"],

	"stage_select": ["STAGE SELECT", "스테이지 선택"],
	"random": ["RANDOM", "랜덤"],
	"stage_hint": ["{LR}: SELECT    {P}: OK    {K}: BACK", "{LR}: 선택    {P}: 결정    {K}: 뒤로"],
	"training_select_hint": ["Pick your character, then the dummy's    {P}: OK    {K}: BACK",
			"내 캐릭터 → 더미 캐릭터 순서로 고르기    {P}: 결정    {K}: 뒤로"],
	"dummy": ["DUMMY", "더미"],
	"hitbox": ["HITBOX", "판정 보기"],
	"on": ["ON", "켜짐"],
	"off": ["OFF", "꺼짐"],
	"dummy_human": ["2P CONTROL", "2P가 조작"],  # 이때는 1P 키로만 내 캐릭터, 2P 키로 더미
	"dummy_stand": ["STAND", "서 있기"],
	"dummy_crouch": ["CROUCH", "앉기"],
	"dummy_jump": ["JUMP", "점프"],
	"dummy_guard": ["STAND GUARD", "서서 가드"],
	"dummy_guard_low": ["CROUCH GUARD", "앉아서 가드"],
	"dummy_guard_auto": ["AUTO GUARD", "자동 가드"],
	"quit_confirm": ["Quit the game?", "게임을 종료할까요?"],
	"quit_hint": ["{P}: YES    {K} / ESC: NO", "{P}: 예    {K} / ESC: 아니오"],
	"esc_hint": ["ESC: QUIT", "ESC: 종료"],

	"pause": ["PAUSE", "일시정지"],
	"resume": ["RESUME", "계속하기"],
	"rematch": ["REMATCH", "재경기"],
	"to_char_select": ["CHARACTER SELECT", "캐릭터 선택"],
	"to_title": ["TITLE", "타이틀로"],
	"to_mode_select": ["MODE SELECT", "모드 선택으로"],
	"input_log": ["INPUT LOG", "입력 기록"],
	"training_settings": ["TRAINING SETTINGS", "트레이닝 설정"],
	"back": ["BACK", "뒤로"],
	"char_book": ["CHARACTER BOOK", "캐릭터 설정집"],
	"help_char_book": ["Profiles, stats and moves of every character.", "캐릭터마다 설정, 능력치, 기술을 볼 수 있어요."],
	"book_hint": ["{LR}: CHARACTER    {K}: BACK", "{LR}: 캐릭터    {K}: 뒤로"],
	"hp": ["HP", "체력"],
	"profile": ["PROFILE", "설정"],
	"command_list": ["COMMAND LIST", "기술표"],
	"command_hint": ["{K} / {START}: CLOSE", "{K} / {START}: 닫기"],
	"common_moves": ["COMMON", "공통"],
	"wins": ["%dP %s WINS!", "%dP %s 승리!"],
	"draw_game": ["DRAW GAME", "무승부"],
}

## 기술표: 캐릭터 id -> [입력, 영어 이름, 한국어 이름, 한국어 설명]  (→ = 상대 쪽, ← = 반대쪽)
## 기술을 바꾸면 여기와 docs/MOVES.md도 같이 고친다
## 도발(P+K) / 리스펙트(→+P+K) 대사: 캐릭터 id → {"taunt": [[영어, 한국어], ...], "respect": [...]}
## 여러 개면 그때그때 하나를 고른다. 자유롭게 고쳐도 됨
const TAUNT_LINES := {
	"chemikid": {
		"taunt": [["Is that all the reaction you've got?", "반응이 그게 다야?"], ["You're just a catalyst for my win.", "넌 내 승리의 촉매일 뿐"]],
		"respect": [["Nice chemistry.", "케미 좋은데?"]],
	},
	"common": {
		"taunt": [["404: skill not found.", "404: 실력을 찾을 수 없음"], ["Ctrl+Z won't save you.", "Ctrl+Z로도 못 돌려"]],
		"respect": [["GG. Well played.", "GG. 잘했어"]],
	},
	"globe": {
		"taunt": [["Feeling the pressure? That's tectonics.", "압력 느껴져? 그게 지각변동이야"], ["You're on shaky ground!", "발밑 조심해!"]],
		"respect": [["Solid as bedrock. Respect.", "기반암처럼 단단하네. 인정"]],
	},
	"chaos": {
		"taunt": [["Your entropy is showing.", "엔트로피 새고 있어"], ["Zero momentum. Boring.", "운동량 0. 지루해"]],
		"respect": [["Impressive force.", "힘 좀 쓰는데?"]],
	},
	"root2": {
		"taunt": [["Your odds are irrational.", "네 승률은 무리수야"], ["Q.E.D. already.", "이미 증명 끝"]],
		"respect": [["A beautiful proof.", "아름다운 증명이었어"]],
	},
	"seed": {
		"taunt": [["Still a sprout, huh?", "아직 새싹이네?"], ["Natural selection says no.", "자연선택이 널 거부했어"]],
		"respect": [["You've grown a lot!", "많이 자랐구나!"]],
	},
}

const MOVE_LISTS := {
	"chemikid": [
		["D", "Flask Toss", "플라스크 투척", "포물선, 깨지면 산성 웅덩이"],
		["→ + D", "Flame Test", "불꽃 반응", "빨강·노랑·초록 불꽃 3연타"],
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
		["→ + D", "Momentum Throw", "운동량 던지기", "먼 거리 잡기 (데미지 2배)"],
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
		["D + HS", "Random Proof", "랜덤 증명", "랜덤 증명, 충분히 맞히면 도장 (50%)"],
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
	["← / ↙", "Guard", "가드", "← 서서: 상단·중단 / ↙ 앉아: 상단·하단"],
	["→/← + HS", "Throw", "잡기", "붙어서. 가드 불가. 잡히는 순간 HS로 풀기"],
	["→ + K", "Overhead", "중단 발차기", "느리지만 앉아 가드를 깸"],
	["P → K → S → HS", "Gatling", "개틀링", "맞히거나 막히면 더 강한 버튼으로"],
	["RC", "Roman Cancel", "로만 캔슬", "공격 취소 (텐션 50%)"],
	["→→ / ←←", "Dash / Backdash", "대시 / 백스텝", "→ 계속 누르면 달리기. 공중에서도 가능"],
]

const SCENES := {
	"title": "res://scenes/title.tscn",
	"mode_select": "res://scenes/mode_select.tscn",
	"controls": "res://scenes/controls.tscn",
	"key_config": "res://scenes/key_config.tscn",
	"char_select": "res://scenes/char_select.tscn",
	"stage_select": "res://scenes/stage_select.tscn",
	"battle": "res://scenes/battle.tscn",
	"char_book": "res://scenes/char_book.tscn",
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
var cpu_level := 1              # CpuBrain.Level (0 쉬움, 1 보통, 2 어려움, 3 달인)
const CPU_LEVEL_KEYS := ["cpu_easy", "cpu_normal", "cpu_hard", "cpu_master"]


## 데모 (축제용): 타이틀에서 한동안 아무도 안 누르면 CPU끼리 대전을 보여 준다. 아무 버튼이나 누르면 타이틀로
const DEMO_WAIT := 60 * 20       # 타이틀에서 이만큼(20초) 입력이 없으면 데모 시작
var demo := false
var _before_demo := {}           # 데모 전 설정 (끝나면 되돌린다)


func start_demo() -> void:
	_before_demo = {"mode": mode, "selected": selected.duplicate(), "stage": stage}
	demo = true
	mode = Mode.CPU
	var a := randi() % CHARACTERS.size()
	var b := (a + 1 + randi() % (CHARACTERS.size() - 1)) % CHARACTERS.size()  # 서로 다른 캐릭터
	selected = {1: a, 2: b}
	stage = randi() % STAGES.size()
	goto("battle")


func end_demo() -> void:
	if not demo:
		return
	demo = false
	mode = _before_demo["mode"]
	selected = _before_demo["selected"]
	stage = _before_demo["stage"]
	goto("title")


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
	if InputManager.mode == InputManager.Mode.KEYBOARD and STRINGS.has(key + "_kb"):
		key += "_kb"
	return keys_in(STRINGS[key][language])


## 버튼 이름: 키보드 모드면 1P 키보드 키 ("Y", "U" ...), 스틱 모드면 버튼 이름 ("P", "K" ...)
const BUTTON_NAMES := {"p": "P", "k": "K", "s": "S", "hs": "HS", "d": "D", "rc": "RC", "start": "START", "select": "SELECT"}


func button_name(action: String) -> String:
	if InputManager.mode == InputManager.Mode.KEYBOARD:
		return OS.get_keycode_string(InputManager.key_for(1, action))
	return BUTTON_NAMES[action]


## 글자 속 {P} {K} {S} {HS} {D} {RC} {START} {SELECT} {LR}를 지금 조작 장치의 버튼 이름으로
func keys_in(s: String) -> String:
	if not "{" in s:
		return s
	for action: String in BUTTON_NAMES:
		s = s.replace("{%s}" % BUTTON_NAMES[action], button_name(action))
	var lr: String
	if InputManager.mode == InputManager.Mode.KEYBOARD:
		lr = "%s/%s" % [button_name_dir("left"), button_name_dir("right")]
	else:
		lr = "LEFT/RIGHT" if language == Language.EN else "좌우"
	return s.replace("{LR}", lr)


func button_name_dir(action: String) -> String:
	return OS.get_keycode_string(InputManager.key_for(1, action))


## 기술표 커맨드 ("D + HS", "→ + D" 등) 속 버튼 글자를 키보드 모드면 키 이름으로 바꾼다
func command_text(cmd: String) -> String:
	if InputManager.mode != InputManager.Mode.KEYBOARD:
		return cmd
	var re := RegEx.create_from_string("\\b(HS|RC|P|K|S|D)\\b")
	var out := ""
	var last := 0
	for m in re.search_all(cmd):
		out += cmd.substr(last, m.get_start() - last) + button_name(m.get_string().to_lower())
		last = m.get_end()
	return out + cmd.substr(last)


func toggle_language() -> void:
	language = Language.KO if language == Language.EN else Language.EN
	save_settings()


# ── 설정 저장 (언어, 조작 모드) ───────────────────────────
## user:// 는 Windows에서 %APPDATA%\Godot\app_userdata\GGJSHS 폴더
func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("game", "language", language)
	cfg.set_value("game", "input_mode", InputManager.mode)
	cfg.set_value("keys", "keyboard", InputManager.custom_keys)
	cfg.set_value("keys", "joystick", InputManager.custom_joy)
	cfg.save(SETTINGS_PATH)


func _load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return
	language = cfg.get_value("game", "language", Language.EN)
	InputManager.custom_keys = cfg.get_value("keys", "keyboard", {1: {}, 2: {}})
	InputManager.custom_joy = cfg.get_value("keys", "joystick", {1: {}, 2: {}})
	InputManager.rebuild()
	InputManager.set_mode(cfg.get_value("game", "input_mode", InputManager.Mode.KEYBOARD))


# ── 화면 이동 / 캐릭터 ────────────────────────────────────
func goto(scene: String) -> void:
	get_tree().change_scene_to_file.call_deferred(SCENES[scene])


func character(player: int) -> Dictionary:
	if selected[player] == TRAINING_DUMMY_INDEX:
		return TRAINING_DUMMY
	return CHARACTERS[selected[player]]


## 트레이닝 전용 연습용 인형 (캐릭터 선택에서 트레이닝일 때 2P 자리에만 나옴)
const TRAINING_DUMMY_INDEX := 100
const TRAINING_DUMMY := {
	"id": "dummy", "name": "DUMMY", "club": ["TRAINING DUMMY", "연습용 인형"],
	"color": Color(0.62, 0.55, 0.45), "script": "res://scripts/characters/training_dummy.gd",
}


func club_name(info: Dictionary) -> String:
	return info["club"][language]


func stage_info() -> Dictionary:
	return STAGES[stage]


## 그림 파일이 있으면 불러오고, 없으면 null (그림이 아직 없어도 게임이 돌아가게)
## 그림 불러오기 (없으면 null). 한 번 불러온 그림은 계속 들고 있는다
## (안 들고 있으면 매 프레임 그릴 때마다 새로 불러오게 되고, 막 불러온 그림은 하얀 네모로 그려진다)
var _textures := {}

func load_texture(path: String) -> Texture2D:
	if _pending.has(path):  # 미리 불러오기 중이던 그림: 끝날 때까지 기다렸다가 받기
		_pending.erase(path)
		_textures[path] = ResourceLoader.load_threaded_get(path)
	if not _textures.has(path):
		_textures[path] = load(path) if ResourceLoader.exists(path) else null
	return _textures[path]


## 캐릭터 그림 미리 불러오기 (백그라운드). 그림이 장당 1~3MB라 기술을 처음 쓸 때 불러오면 화면이 멈칫한다
var _pending := {}


## 그 캐릭터의 그림 파일들 (assets/characters/<id>.png, <id>_*.png)
func character_paths(id: String) -> Array[String]:
	var out: Array[String] = []
	for f in ResourceLoader.list_directory("res://assets/characters/"):
		if f.ends_with(".png") and (f == id + ".png" or f.begins_with(id + "_")):
			out.append("res://assets/characters/" + f)
	return out


## 이펙트·글자 그림 (assets/effects, assets/ui/text_*) 경로
func effect_paths() -> Array[String]:
	var out: Array[String] = []
	for f in ResourceLoader.list_directory("res://assets/effects/"):
		if f.ends_with(".png"):
			out.append("res://assets/effects/" + f)
	for f in ResourceLoader.list_directory("res://assets/ui/"):
		if f.begins_with("text_") and f.ends_with(".png"):
			out.append("res://assets/ui/" + f)
	return out


func preload_paths(paths: Array[String]) -> void:
	for path in paths:
		if not _textures.has(path) and not _pending.has(path):
			if ResourceLoader.load_threaded_request(path) == OK:
				_pending[path] = true


func preload_characters(indices: Array) -> void:
	preload_paths(effect_paths())
	for i in indices:
		if i < 0 or i >= CHARACTERS.size():
			continue  # 트레이닝 더미 등
		preload_paths(character_paths(CHARACTERS[i]["id"]))


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
