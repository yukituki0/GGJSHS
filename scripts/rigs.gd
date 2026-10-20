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
}


static func get_rig(id: String) -> Dictionary:
	return RIGS.get(id, {})
