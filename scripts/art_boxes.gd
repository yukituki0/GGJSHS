class_name ArtBoxes
## 그림에서 판정 박스 뽑기 (길티기어처럼 판정이 그림을 따라가게)
##
## 그림을 위에서부터 띠(BANDS)로 나누고, 띠마다 "그림이 꽉 찬 세로줄"만 모아 사각형 하나를 만든다.
## 얇게 삐져나온 머리카락/가운 자락은 빠지고, 뻗은 팔·다리는 들어간다.
## 결과는 그림 픽셀 좌표(발 위치 기준, 오른쪽을 볼 때)라서 그릴 때와 같은 배율을 곱해서 쓴다.

const BANDS := 4            # 머리 / 몸통 / 허리 / 다리
const FILL := 0.25          # 세로줄에서 이만큼 이상 그림이 차 있어야 몸으로 친다
const STEP := 4             # 픽셀 건너뛰며 검사 (빠르게)

static var _cache := {}


## tex의 판정 박스들 (발 기준 그림 픽셀). anchor = 두 발 사이 바닥
static func hurt_boxes(tex: Texture2D, anchor: Vector2) -> Array[Rect2]:
	var key := tex.resource_path
	if _cache.has(key):
		return _cache[key]
	var img := tex.get_image()
	var w := img.get_width()
	var top := 0
	while top < img.get_height() - 1 and not _row_has(img, top):
		top += 1
	var bottom := mini(int(anchor.y), img.get_height())  # 발 위치가 그림 아래 바깥이어도 그림 안에서만 검사
	var band_h := float(bottom - top) / BANDS
	var boxes: Array[Rect2] = []
	for b in BANDS:
		var y0 := int(top + b * band_h)
		var y1 := int(top + (b + 1) * band_h)
		var lo := w
		var hi := -1
		for x in range(0, w, STEP):
			var filled := 0
			var total := 0
			for y in range(y0, y1, STEP):
				total += 1
				if img.get_pixel(x, y).a > 0.5:
					filled += 1
			if total > 0 and float(filled) / total >= FILL:
				lo = mini(lo, x)
				hi = maxi(hi, x)
		if hi >= lo:
			boxes.append(Rect2(lo - anchor.x, y0 - anchor.y, hi - lo + STEP, y1 - y0))
	_cache[key] = boxes
	return boxes


## 그림에서 앞쪽(오른쪽) 끝 위치 (발 기준 그림 픽셀). 키의 from~to 비율 높이 안에서만 찾는다
## (예: 0.4~1.0 = 허리 위 → 뻗은 주먹 끝). 못 찾으면 Vector2.INF
static func front_tip(tex: Texture2D, anchor: Vector2, from: float, to: float) -> Vector2:
	var img := tex.get_image()
	var top := 0
	while top < img.get_height() - 1 and not _row_has(img, top):
		top += 1
	var h := anchor.y - top
	var ya := clampi(int(anchor.y - h * to), 0, img.get_height() - 1)
	var yb := clampi(int(anchor.y - h * from), 0, img.get_height() - 1)
	for x in range(img.get_width() - 1, -1, -STEP):
		var hits: Array[int] = []
		for y in range(ya, yb + 1, STEP):
			if img.get_pixel(x, y).a > 0.5:
				hits.append(y)
		if hits.size() >= 2:  # 한두 픽셀 잡티 말고 실제 손/발
			return Vector2(x - anchor.x, (hits[0] + hits[-1]) / 2.0 - anchor.y)
	return Vector2.INF


static func _row_has(img: Image, y: int) -> bool:
	for x in range(0, img.get_width(), 2):
		if img.get_pixel(x, y).a > 0.3:
			return true
	return false
