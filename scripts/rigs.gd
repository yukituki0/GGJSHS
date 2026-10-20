class_name Rigs
## 캐릭터 그림의 뼈대 (Puppet용). 좌표는 assets/characters/<id>.png 의 픽셀 위치
## 그림을 바꾸면 이 좌표도 다시 맞춰야 한다 (그림 위에 점을 찍어 보며 확인)
##
## hip: 엉덩이(몸 전체가 돌고 움직이는 중심)   neck / head: 목, 머리 가운데
## ba_*: 뒤쪽 팔 (어깨 sh, 팔꿈치 el, 손 ha)    fa_*: 앞쪽 팔
## bl_*: 뒤쪽 다리 (엉덩이 hip, 무릎 kn, 발 ft)  fl_*: 앞쪽 다리
## anchor: 두 발 사이 바닥 (게임에서 캐릭터 위치)

const RIGS := {
	"chemikid": {
		"anchor": Vector2(540, 1495),
		"joints": {
			"hip": Vector2(620, 640), "neck": Vector2(570, 290), "head": Vector2(580, 150),
			"ba_sh": Vector2(450, 290), "ba_el": Vector2(262, 450), "ba_ha": Vector2(405, 495),
			"fa_sh": Vector2(705, 322), "fa_el": Vector2(800, 495), "fa_ha": Vector2(878, 345),
			"bl_hip": Vector2(560, 710), "bl_kn": Vector2(375, 1125), "bl_ft": Vector2(195, 1410),
			"fl_hip": Vector2(690, 700), "fl_kn": Vector2(795, 1050), "fl_ft": Vector2(885, 1410),
		},
	},
	"common": {
		"anchor": Vector2(530, 1495),
		"joints": {
			"hip": Vector2(560, 760), "neck": Vector2(560, 270), "head": Vector2(595, 150),
			"ba_sh": Vector2(360, 330), "ba_el": Vector2(190, 420), "ba_ha": Vector2(270, 260),
			"fa_sh": Vector2(670, 330), "fa_el": Vector2(745, 575), "fa_ha": Vector2(870, 440),
			"bl_hip": Vector2(480, 770), "bl_kn": Vector2(380, 1060), "bl_ft": Vector2(180, 1430),
			"fl_hip": Vector2(640, 770), "fl_kn": Vector2(720, 1050), "fl_ft": Vector2(880, 1430),
		},
	},
	"chaos": {
		"anchor": Vector2(515, 1490),
		"joints": {
			"hip": Vector2(510, 700), "neck": Vector2(500, 260), "head": Vector2(530, 150),
			"ba_sh": Vector2(340, 290), "ba_el": Vector2(260, 470), "ba_ha": Vector2(210, 640),
			"fa_sh": Vector2(620, 320), "fa_el": Vector2(720, 480), "fa_ha": Vector2(830, 450),
			"bl_hip": Vector2(440, 720), "bl_kn": Vector2(330, 1050), "bl_ft": Vector2(160, 1420),
			"fl_hip": Vector2(600, 720), "fl_kn": Vector2(720, 1050), "fl_ft": Vector2(870, 1410),
		},
	},
	"globe": {
		"anchor": Vector2(520, 1500),
		"joints": {
			"hip": Vector2(500, 640), "neck": Vector2(530, 300), "head": Vector2(560, 170),
			"ba_sh": Vector2(380, 320), "ba_el": Vector2(260, 480), "ba_ha": Vector2(220, 640),
			"fa_sh": Vector2(650, 330), "fa_el": Vector2(760, 480), "fa_ha": Vector2(870, 410),
			"bl_hip": Vector2(430, 700), "bl_kn": Vector2(330, 1050), "bl_ft": Vector2(150, 1430),
			"fl_hip": Vector2(580, 700), "fl_kn": Vector2(700, 1050), "fl_ft": Vector2(870, 1430),
		},
	},
	"root2": {
		"anchor": Vector2(570, 1420),
		"joints": {
			"hip": Vector2(560, 690), "neck": Vector2(560, 330), "head": Vector2(580, 250),
			"ba_sh": Vector2(450, 380), "ba_el": Vector2(380, 500), "ba_ha": Vector2(300, 520),
			"fa_sh": Vector2(680, 380), "fa_el": Vector2(800, 460), "fa_ha": Vector2(930, 500),
			"bl_hip": Vector2(500, 740), "bl_kn": Vector2(380, 1000), "bl_ft": Vector2(230, 1350),
			"fl_hip": Vector2(640, 740), "fl_kn": Vector2(790, 1000), "fl_ft": Vector2(900, 1360),
		},
	},
	"seed": {
		"anchor": Vector2(530, 1500),
		"joints": {
			"hip": Vector2(540, 700), "neck": Vector2(540, 300), "head": Vector2(560, 180),
			"ba_sh": Vector2(380, 340), "ba_el": Vector2(250, 540), "ba_ha": Vector2(120, 650),
			"fa_sh": Vector2(690, 330), "fa_el": Vector2(790, 450), "fa_ha": Vector2(850, 410),
			"bl_hip": Vector2(480, 760), "bl_kn": Vector2(330, 1100), "bl_ft": Vector2(180, 1430),
			"fl_hip": Vector2(620, 760), "fl_kn": Vector2(730, 1100), "fl_ft": Vector2(880, 1430),
		},
	},
}


static func get_rig(id: String) -> Dictionary:
	return RIGS.get(id, {})
