class_name AttackData
extends RefCounted
## 기술 하나의 데이터 (프레임 데이터 + 판정 + 데미지)
##
## 이름은 격투겜 커뮤니티의 "숫자패드 표기법"을 쓴다.
##   5 = 중립(서서), 2 = 아래(앉아서), j = 점프 중
##   예: 5P = 서서 P, 2K = 앉아서 K, jS = 점프 S

enum Level { MID, LOW, OVERHEAD }  # 중단(아무 가드나 됨) / 하단(앉아서 가드) / 중단 위(서서 가드)

var name: String
var startup: int        # 발생: 버튼 누르고 판정이 나오기까지 프레임
var active: int         # 지속: 판정이 살아있는 프레임
var recovery: int       # 후딜: 판정이 사라진 뒤 움직일 수 없는 프레임
var damage: int
var hitbox: Rect2       # 오른쪽을 볼 때 기준, 발 위치(0,0)에서의 상대 좌표
var level: Level
var hitstun: int        # 맞은 쪽이 못 움직이는 프레임
var blockstun: int      # 막은 쪽이 못 움직이는 프레임
var pushback := 6.0     # 맞거나 막았을 때 밀려나는 속도
var gatling: Array = []  # 맞히거나 막혔을 때 이어서 쓸 수 있는 기술


func _init(p_name: String, p_startup: int, p_active: int, p_recovery: int,
		p_damage: int, p_hitbox: Rect2, p_level: Level,
		p_hitstun: int, p_blockstun: int, p_gatling: Array = []) -> void:
	name = p_name
	startup = p_startup
	active = p_active
	recovery = p_recovery
	damage = p_damage
	hitbox = p_hitbox
	level = p_level
	hitstun = p_hitstun
	blockstun = p_blockstun
	gatling = p_gatling


func total_frames() -> int:
	return startup + active + recovery


## frame: 공격 시작 후 지난 프레임 (1부터)
func is_active(frame: int) -> bool:
	return frame > startup and frame <= startup + active
