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
var hitstop: int        # 맞은 순간 둘 다 멈추는 프레임 (센 기술일수록 길다 = 묵직한 손맛)
var gatling: Array = []  # 맞히거나 막혔을 때 이어서 쓸 수 있는 기술

# ── 필살기용 추가 정보 (생성 후 필요한 것만 설정) ─────────
var title := ""          # 화면에 띄울 기술 이름 (오버드라이브 컷인 등)
var cost := 0.0          # 텐션 소모량 (오버드라이브 50)
var mana := -1.0         # 마력 소모량. -1이면 기본값 (D 필살기 Fighter.SPECIAL_MANA, 나머지 0)
var event_frame := -1    # 이 프레임에 캐릭터의 _on_attack_event()가 불린다 (투사체 생성 등)
var invuln_frames := 0   # 시작부터 이 프레임까지 무적 (공격을 안 맞음)
var move_speed := 0.0    # 공격 중 앞으로 움직이는 속도 (돌진기)
var armor_hits := 0      # 발생~지속 동안 이 횟수만큼 맞아도 안 멈춤 (데미지는 받음)
var unblockable := false # 가드 불가
var is_throw := false    # 잡기: 가드 불가 + 땅에 있고 경직 중이 아닌 상대만 잡힌다
var rise := Vector2.ZERO    # 발생이 끝나는 순간 내 몸이 이 속도로 뛰어오름 (승룡권 같은 대공기, x는 앞 기준)
var landing_recovery := 0   # 뛰어오른 기술이 착지한 뒤 못 움직이는 프레임 (빗나가면 빈틈)
var launch := Vector2.ZERO  # 맞으면 이 속도로 날아감 (x는 공격 방향 기준). 0이면 보통 넉백


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
	hitstop = 4 + int(p_damage / 6.0)  # 5P≈7F, 5H≈13F. 기술마다 따로 정하고 싶으면 생성 후 덮어쓰기
	gatling = p_gatling


func total_frames() -> int:
	return startup + active + recovery


## frame: 공격 시작 후 지난 프레임 (1부터)
func is_active(frame: int) -> bool:
	return frame > startup and frame <= startup + active
