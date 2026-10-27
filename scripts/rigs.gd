class_name Rigs
## 캐릭터 그림의 뼈대 (Puppet용). 좌표는 assets/characters/<id>.png 의 픽셀 위치
## (2026-10: 렉 때문에 그림을 모두 절반 크기로 줄이면서 좌표도 절반으로 바꿈)
## 그림을 바꾸면 이 좌표도 다시 맞춰야 한다 (그림 위에 점을 찍어 보며 확인)
##
## hip: 엉덩이(몸 전체가 돌고 움직이는 중심)   neck / head: 목, 머리 가운데
## ba_*: 뒤쪽 팔 (어깨 sh, 팔꿈치 el, 손 ha)    fa_*: 앞쪽 팔
## bl_*: 뒤쪽 다리 (엉덩이 hip, 무릎 kn, 발 ft)  fl_*: 앞쪽 다리
## anchor(선택): 두 발 사이 바닥. 안 적으면 그림에서 자동으로 찾는다
## pose_anchor(선택): 자세 그림의 발 위치(그림 픽셀). 무기 끝이 발보다 아래로 내려간 그림처럼 자동으로 못 찾을 때
## fit_band(선택): 판정을 맞출 때 손발 끝을 찾는 높이 비율 [아래, 위] (0=발, 1=머리)
## no_fit(선택): 그림에 판정을 맞추지 않을 기술 (일부러 정한 사거리)
## reach_limit(선택): 그림에 판정을 맞출 때 사거리를 늘려도 되는 최대치 (기본 50). 예: {"5H": 120}
## pose_size(선택): 자세 그림 크기 보정 (머리 크기가 서 있는 그림과 같아 보이게). 안 적은 자세는 1.0
##   AI가 앉은/점프 그림을 작게 또는 크게 그리는 경우가 있어서 캐릭터마다 눈으로 보고 맞춘 값

const RIGS := {
	"chemikid": {
		"pose_size": {"crouch": 1.15, "crouch_guard": 0.95, "jump": 1.12, "heavy": 0.72, "2d": 1.16, "2k": 0.72, "2p": 0.81, "2s": 0.72, "dash": 0.88, "guard": 0.86, "hit": 0.83, "jd": 0.88, "jh": 0.74, "jk": 0.9, "od": 1.14, "punch": 0.78, "slash": 0.83},
		"pose_anchor": {"heavy": Vector2(325, 640), "2h": Vector2(136.5, 671.5), "2p": Vector2(176, 525), "4d": Vector2(148, 639.5), "5d": Vector2(363.5, 639.5), "air_dash": Vector2(273.5, 480.5), "dash": Vector2(325, 608), "js": Vector2(161, 582), "6d": Vector2(107, 639)},  # 깊은 런지: 뒷발 쪽을 기준으로 해서 몸이 앞으로 확 튀지 않게
		"joints": {
			"hip": Vector2(280, 310), "neck": Vector2(285, 120), "head": Vector2(300, 75),
			"ba_sh": Vector2(215, 130), "ba_el": Vector2(150, 190), "ba_ha": Vector2(215, 225),
			"fa_sh": Vector2(340, 140), "fa_el": Vector2(420, 215), "fa_ha": Vector2(465, 180),
			"bl_hip": Vector2(250, 340), "bl_kn": Vector2(165, 500), "bl_ft": Vector2(110, 670),
			"fl_hip": Vector2(320, 340), "fl_kn": Vector2(400, 500), "fl_ft": Vector2(475, 665),
		},
	},
	"common": {
		"reach_limit": {"jS": 80},  # 그림 끝까지 닿게 (눈으로 닿았는데 안 맞는 일 없게)
		"pose_size": {"crouch": 0.9, "5d": 0.85, "2k": 0.91, "2p": 0.9, "2s": 0.91, "6d": 0.76, "backdash": 0.9, "dash": 0.78, "guard": 0.91, "heavy": 0.77, "hit": 1.12, "jk": 0.79, "jp": 0.83, "punch": 0.81, "slash": 0.86, "walk_back": 0.81, "jh": 0.78},
		"pose_anchor": {"2k": Vector2(280, 501.5), "5d": Vector2(280, 678.5), "od": Vector2(210, 529), "2s": Vector2(144, 543), "dash": Vector2(301.5, 644.5), "heavy": Vector2(179, 679), "jp": Vector2(167, 719.5), "slash": Vector2(122, 678)},
		"no_fit": ["2H"],
		"fit_band": {"jS": [0.45, 1.0]},  # 공중 S: 키보드 밑으로 늘어진 케이블 말고 키보드 끝에  # 대공 2H: 그림의 앞쪽 끝(옷자락)이 아니라 원래대로 머리 위를 친다  # 다리를 길게 뻗은 2K: 뒷발이 서 있을 때 뒷발 자리에 오게
		"joints": {
			"hip": Vector2(280, 320), "neck": Vector2(280, 125), "head": Vector2(295, 65),
			"ba_sh": Vector2(220, 150), "ba_el": Vector2(160, 190), "ba_ha": Vector2(165, 95),
			"fa_sh": Vector2(340, 160), "fa_el": Vector2(410, 240), "fa_ha": Vector2(450, 335),
			"bl_hip": Vector2(240, 350), "bl_kn": Vector2(175, 500), "bl_ft": Vector2(90, 665),
			"fl_hip": Vector2(325, 350), "fl_kn": Vector2(400, 500), "fl_ft": Vector2(475, 660),
		},
	},
	"chaos": {
		"reach_limit": {"jS": 80},  # 그림 끝까지 닿게 (눈으로 닿았는데 안 맞는 일 없게)
		"fit_band": {"5S": [0.7, 1.0]},  # S 손날: 앞으로 펄럭이는 가운 자락 말고 뻗은 손끝에
		"pose_size": {"crouch": 0.91, "crouch_guard": 0.85, "jump_attack": 1.1, "air_dash": 1.1, "guard": 0.91, "hit": 0.88, "jump": 0.85, "punch": 0.9, "2p": 0.85, "2k": 0.81, "2s": 0.87, "jp": 0.87, "jk": 0.78, "jh": 0.9, "js": 0.78, "walk_back": 0.9, "dash": 0.81, "backdash": 0.9, "5d": 0.78, "6d": 0.87, "4d": 0.85, "od": 1.13, "2h": 1.1, "slash": 0.84, "heavy": 0.84, "jd": 0.89},
		"pose_anchor": {"air_dash": Vector2(283, 491.5), "hit": Vector2(274.5, 690.5), "jump_attack": Vector2(238.5, 557), "punch": Vector2(146, 655.5), "2p": Vector2(160, 589.5), "jh": Vector2(225, 655), "od": Vector2(170, 622)},
		"no_fit": ["2D"],  # 2D 전자기 펄스: 몸 주위 전체를 치는 기술이라 그림 앞끝에 맞추면 뒤쪽 판정이 없어짐
		"joints": {
			"hip": Vector2(265, 310), "neck": Vector2(265, 125), "head": Vector2(280, 70),
			"ba_sh": Vector2(190, 150), "ba_el": Vector2(165, 225), "ba_ha": Vector2(130, 310),
			"fa_sh": Vector2(340, 150), "fa_el": Vector2(400, 210), "fa_ha": Vector2(400, 130),
			"bl_hip": Vector2(225, 350), "bl_kn": Vector2(160, 525), "bl_ft": Vector2(100, 685),
			"fl_hip": Vector2(320, 350), "fl_kn": Vector2(400, 525), "fl_ft": Vector2(475, 680),
		},
	},
	"globe": {
		"reach_limit": {"5H": 120},  # HS 망치 멀리 휘두르기: 판정을 망치 머리까지
		"pose_size": {"crouch": 1.15, "jump": 1.19, "2p": 0.75, "2k": 0.78, "2s": 0.91, "jp": 0.82, "js": 0.84, "walk_back": 0.9, "dash": 0.8, "5d": 0.91, "6d": 0.81, "od": 0.9, "slash": 0.88, "heavy": 0.89, "jk": 0.83},
		"pose_anchor": {"hit": Vector2(78.5, 715), "2k": Vector2(262, 537.5), "dash": Vector2(350, 609), "heavy": Vector2(417.5, 515.5), "jh": Vector2(280, 679.5)},
		"joints": {
			"hip": Vector2(260, 310), "neck": Vector2(270, 145), "head": Vector2(290, 85),
			"ba_sh": Vector2(190, 165), "ba_el": Vector2(125, 225), "ba_ha": Vector2(115, 290),
			"fa_sh": Vector2(325, 165), "fa_el": Vector2(360, 240), "fa_ha": Vector2(440, 205),
			"bl_hip": Vector2(210, 360), "bl_kn": Vector2(150, 525), "bl_ft": Vector2(90, 670),
			"fl_hip": Vector2(310, 360), "fl_kn": Vector2(400, 525), "fl_ft": Vector2(475, 670),
		},
	},
	"root2": {
		"pose_size": {"crouch": 0.88, "2p": 0.88, "2k": 0.88, "2h": 1.15, "heavy": 0.75, "air_dash": 0.77, "5d": 0.8, "2d": 0.89, "guard": 0.85, "jd": 1.18, "jh": 1.1},
		# jd: 컴퍼스 끝이 발보다 한참 아래라 부츠 바닥을 발 위치로 / win: 땅에 세운 컴퍼스 끝 말고 두 부츠 가운데
		"pose_anchor": {"win": Vector2(305, 711.5), "jp": Vector2(357, 461.5), "jk": Vector2(280, 425), "6d": Vector2(432.5, 716.5), "js": Vector2(227.5, 454), "od": Vector2(228.5, 712)},
		"reach_limit": {"5H": 120, "2S": 120, "jS": 120},  # 5H·2S·jS 판정을 컴퍼스 끝까지 (원거리형). 6D는 그보다 더 길게 root2.gd에서
		"no_fit": ["6D"],  # 6D는 5H보다 길게 일부러 정한 사거리
		"joints": {
			"hip": Vector2(280, 280), "neck": Vector2(280, 135), "head": Vector2(300, 75),
			"ba_sh": Vector2(210, 150), "ba_el": Vector2(150, 210), "ba_ha": Vector2(165, 215),
			"fa_sh": Vector2(340, 155), "fa_el": Vector2(425, 210), "fa_ha": Vector2(500, 240),
			"bl_hip": Vector2(240, 325), "bl_kn": Vector2(165, 500), "bl_ft": Vector2(100, 670),
			"fl_hip": Vector2(320, 325), "fl_kn": Vector2(425, 500), "fl_ft": Vector2(475, 670),
		},
	},
	"seed": {
		"pose_size": {"crouch": 1.02, "jump": 1.12, "2s": 1.0, "jp": 0.77, "jk": 0.78, "js": 0.77, "walk_back": 0.89, "dash": 0.8, "backdash": 0.92, "throw": 0.88, "jump_attack": 0.77, "5d": 0.9, "6d": 0.9, "jd": 0.81, "slash": 0.85, "heavy": 0.87, "2k": 0.82, "punch": 0.78, "2p": 0.86},
		"pose_anchor": {"2h": Vector2(162, 792), "jp": Vector2(261, 642), "dash": Vector2(360.5, 717), "od": Vector2(179.5, 754.5), "jh": Vector2(289, 543.5)},
		"joints": {
			"hip": Vector2(285, 300), "neck": Vector2(295, 130), "head": Vector2(310, 80),
			"ba_sh": Vector2(215, 160), "ba_el": Vector2(165, 240), "ba_ha": Vector2(145, 310),
			"fa_sh": Vector2(360, 155), "fa_el": Vector2(400, 235), "fa_ha": Vector2(460, 225),
			"bl_hip": Vector2(245, 425), "bl_kn": Vector2(165, 550), "bl_ft": Vector2(90, 680),
			"fl_hip": Vector2(340, 425), "fl_kn": Vector2(400, 550), "fl_ft": Vector2(465, 660),
		},
	},
}


static func get_rig(id: String) -> Dictionary:
	return RIGS.get(id, {})
