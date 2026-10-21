class_name Rigs
## 캐릭터 그림의 뼈대 (Puppet용). 좌표는 assets/characters/<id>.png 의 픽셀 위치
## 그림을 바꾸면 이 좌표도 다시 맞춰야 한다 (그림 위에 점을 찍어 보며 확인)
##
## hip: 엉덩이(몸 전체가 돌고 움직이는 중심)   neck / head: 목, 머리 가운데
## ba_*: 뒤쪽 팔 (어깨 sh, 팔꿈치 el, 손 ha)    fa_*: 앞쪽 팔
## bl_*: 뒤쪽 다리 (엉덩이 hip, 무릎 kn, 발 ft)  fl_*: 앞쪽 다리
## anchor(선택): 두 발 사이 바닥. 안 적으면 그림에서 자동으로 찾는다
## pose_anchor(선택): 자세 그림의 발 위치(그림 픽셀). 무기 끝이 발보다 아래로 내려간 그림처럼 자동으로 못 찾을 때
## reach_limit(선택): 그림에 판정을 맞출 때 사거리를 늘려도 되는 최대치 (기본 50). 예: {"5H": 120}
## pose_size(선택): 자세 그림 크기 보정 (머리 크기가 서 있는 그림과 같아 보이게). 안 적은 자세는 1.0
##   AI가 앉은/점프 그림을 작게 또는 크게 그리는 경우가 있어서 캐릭터마다 눈으로 보고 맞춘 값

const RIGS := {
	"chemikid": {
		"pose_size": {"crouch": 1.15, "crouch_guard": 0.95, "jump": 1.12},
		"joints": {
			"hip": Vector2(560, 620), "neck": Vector2(570, 240), "head": Vector2(600, 150),
			"ba_sh": Vector2(430, 260), "ba_el": Vector2(300, 380), "ba_ha": Vector2(430, 450),
			"fa_sh": Vector2(680, 280), "fa_el": Vector2(840, 430), "fa_ha": Vector2(930, 360),
			"bl_hip": Vector2(500, 680), "bl_kn": Vector2(330, 1000), "bl_ft": Vector2(220, 1340),
			"fl_hip": Vector2(640, 680), "fl_kn": Vector2(800, 1000), "fl_ft": Vector2(950, 1330),
		},
	},
	"common": {
		"pose_size": {"crouch": 0.9},
		"joints": {
			"hip": Vector2(560, 640), "neck": Vector2(560, 250), "head": Vector2(590, 130),
			"ba_sh": Vector2(440, 300), "ba_el": Vector2(320, 380), "ba_ha": Vector2(330, 190),
			"fa_sh": Vector2(680, 320), "fa_el": Vector2(820, 480), "fa_ha": Vector2(900, 670),
			"bl_hip": Vector2(480, 700), "bl_kn": Vector2(350, 1000), "bl_ft": Vector2(180, 1330),
			"fl_hip": Vector2(650, 700), "fl_kn": Vector2(800, 1000), "fl_ft": Vector2(950, 1320),
		},
	},
	"chaos": {
		"pose_size": {"crouch": 1.05, "crouch_guard": 0.95, "jump_attack": 1.1, "air_dash": 1.1},
		"joints": {
			"hip": Vector2(530, 620), "neck": Vector2(530, 250), "head": Vector2(560, 140),
			"ba_sh": Vector2(380, 300), "ba_el": Vector2(330, 450), "ba_ha": Vector2(260, 620),
			"fa_sh": Vector2(680, 300), "fa_el": Vector2(800, 420), "fa_ha": Vector2(800, 260),
			"bl_hip": Vector2(450, 700), "bl_kn": Vector2(320, 1050), "bl_ft": Vector2(200, 1370),
			"fl_hip": Vector2(640, 700), "fl_kn": Vector2(800, 1050), "fl_ft": Vector2(950, 1360),
		},
	},
	"globe": {
		"pose_size": {"crouch": 1.15},
		"joints": {
			"hip": Vector2(520, 620), "neck": Vector2(540, 290), "head": Vector2(580, 170),
			"ba_sh": Vector2(380, 330), "ba_el": Vector2(250, 450), "ba_ha": Vector2(230, 580),
			"fa_sh": Vector2(650, 330), "fa_el": Vector2(720, 480), "fa_ha": Vector2(880, 410),
			"bl_hip": Vector2(420, 720), "bl_kn": Vector2(300, 1050), "bl_ft": Vector2(180, 1340),
			"fl_hip": Vector2(620, 720), "fl_kn": Vector2(800, 1050), "fl_ft": Vector2(950, 1340),
		},
	},
	"root2": {
		"pose_size": {"crouch": 0.88, "heavy": 0.75, "air_dash": 0.77, "5d": 0.8},
		"pose_anchor": {"jd": Vector2(440, 1169)},  # 컴퍼스 끝이 발보다 한참 아래라 부츠 바닥을 발 위치로
		"reach_limit": {"5H": 120},  # 5H 판정을 컴퍼스 끝까지 (원거리형). 6D는 그보다 더 길게 root2.gd에서
		"joints": {
			"hip": Vector2(560, 560), "neck": Vector2(560, 270), "head": Vector2(600, 150),
			"ba_sh": Vector2(420, 300), "ba_el": Vector2(300, 420), "ba_ha": Vector2(330, 430),
			"fa_sh": Vector2(680, 310), "fa_el": Vector2(850, 420), "fa_ha": Vector2(1000, 480),
			"bl_hip": Vector2(480, 650), "bl_kn": Vector2(330, 1000), "bl_ft": Vector2(200, 1340),
			"fl_hip": Vector2(640, 650), "fl_kn": Vector2(850, 1000), "fl_ft": Vector2(950, 1340),
		},
	},
	"seed": {
		"pose_size": {"crouch": 1.02, "jump": 1.12},
		"joints": {
			"hip": Vector2(570, 600), "neck": Vector2(590, 260), "head": Vector2(620, 160),
			"ba_sh": Vector2(430, 320), "ba_el": Vector2(330, 480), "ba_ha": Vector2(290, 620),
			"fa_sh": Vector2(720, 310), "fa_el": Vector2(800, 470), "fa_ha": Vector2(920, 450),
			"bl_hip": Vector2(490, 850), "bl_kn": Vector2(330, 1100), "bl_ft": Vector2(180, 1360),
			"fl_hip": Vector2(680, 850), "fl_kn": Vector2(800, 1100), "fl_ft": Vector2(930, 1320),
		},
	},
}


static func get_rig(id: String) -> Dictionary:
	return RIGS.get(id, {})
