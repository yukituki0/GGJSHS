extends Node
## 게임 전체 상태 (Autoload 싱글톤, 이름: Game)
## 화면이 바뀌어도 유지돼야 하는 것들: 모드, 고른 캐릭터, 화면 이동

enum Mode { VERSUS, TRAINING }

const GAME_TITLE := "GGJSHS"   # 게임 제목 (정해지면 여기만 바꾸면 된다)

const ROUNDS_TO_WIN := 2       # 2선승제
const ROUND_SECONDS := 60

## 캐릭터 목록. 새 캐릭터는 여기에 한 줄 추가 + scripts/characters/에 파일 추가
const CHARACTERS: Array[Dictionary] = [
	{
		"name": "CHEMIKID", "club": "CHEMISTRY CLUB  Chemikid",
		"color": Color(0.30, 0.85, 0.45), "script": "res://scripts/characters/chemikid.gd",
	},
	{
		"name": "COMMON", "club": "COMPUTER CLUB  COMMON",
		"color": Color(0.30, 0.65, 1.00), "script": "res://scripts/characters/common.gd",
	},
]

const SCENES := {
	"title": "res://scenes/title.tscn",
	"mode_select": "res://scenes/mode_select.tscn",
	"controls": "res://scenes/controls.tscn",
	"char_select": "res://scenes/char_select.tscn",
	"battle": "res://scenes/battle.tscn",
}

var mode: Mode = Mode.VERSUS
var selected := { 1: 0, 2: 1 }  # 플레이어 -> CHARACTERS 인덱스


func goto(scene: String) -> void:
	get_tree().change_scene_to_file.call_deferred(SCENES[scene])


func character(player: int) -> Dictionary:
	return CHARACTERS[selected[player]]


## 메뉴 입력: player가 0이면 1P/2P 아무나
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
