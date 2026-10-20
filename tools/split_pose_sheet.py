# 포즈 시트(자세 여러 개가 한 장에 있는 그림)를 자세별 투명 PNG로 자르기
#
# 사용법:
#   python tools/split_pose_sheet.py <시트 그림> <캐릭터 id> <자세 이름들...>
#   예) python tools/split_pose_sheet.py sheet.webp chemikid punch kick guard hit crouch jump
#   → assets/characters/chemikid_punch.png ... (왼쪽에 있는 자세부터 순서대로)
#
# 배경: 흰색(또는 투명) 배경이면 된다. 테두리와 이어진 흰색을 지운다.
# 자세끼리 떨어져 있어야 한다. 떨어진 작은 조각(플라스크 등)은 가장 가까운 자세에 붙인다.
import sys
import numpy as np
from PIL import Image, ImageDraw, ImageFilter

src, char_id, poses = sys.argv[1], sys.argv[2], sys.argv[3:]
im = Image.open(src).convert('RGBA')
a = np.asarray(im).astype(int)
h, w = a.shape[:2]

# 1) 배경 지우기: 테두리와 이어진 밝은 무채색 영역
mn, mx = a[..., :3].min(2), a[..., :3].max(2)
bg_like = ((mn > 225) & (mx - mn < 18)) | (a[..., 3] < 10)
m = Image.fromarray(np.where(bg_like, 255, 0).astype(np.uint8)).copy()
for x in range(0, w, 3):
    for y in (0, h - 1):
        if m.getpixel((x, y)) == 255:
            ImageDraw.floodfill(m, (x, y), 128)
for y in range(0, h, 3):
    for x in (0, w - 1):
        if m.getpixel((x, y)) == 255:
            ImageDraw.floodfill(m, (x, y), 128)
# 선(케이블 고리 등)에 둘러싸여 테두리와 안 이어진 배경 구멍: 거의 순백이고 균일한 덩어리만 지운다
# (흰 셔츠/신발 밑창은 음영이 있어서 평균 밝기가 낮아 남는다)
arr = np.asarray(m).copy()
holes = Image.fromarray(np.where(arr == 255, 255, 0).astype(np.uint8)).copy()
for y in range(0, h, 3):
    for x in range(0, w, 3):
        if holes.getpixel((x, y)) != 255:
            continue
        ImageDraw.floodfill(holes, (x, y), 100)
        harr = np.asarray(holes)
        comp = harr == 100
        n = comp.sum()
        if n > 150 and a[..., :3][comp].mean() > 249:
            arr[comp] = 128
        holes = Image.fromarray(np.where(comp, 50, harr).astype(np.uint8)).copy()
alpha = np.where(arr == 128, 0, 255).astype(np.uint8)
alpha_img = Image.fromarray(alpha).filter(ImageFilter.MinFilter(3)).filter(ImageFilter.GaussianBlur(0.6))

# 2) 덩어리 나누기 (살짝 부풀려서 가까운 조각끼리는 한 덩어리로). 픽셀마다 덩어리 번호를 기억한다
fat = Image.fromarray(alpha).filter(ImageFilter.MaxFilter(7))
lab = Image.fromarray(np.where(np.asarray(fat) > 0, 255, 0).astype(np.uint8)).copy()
labels = np.zeros((h, w), np.int32)
blobs = []  # [면적, bbox, 번호]
step = 4
for y in range(0, h, step):
    for x in range(0, w, step):
        if lab.getpixel((x, y)) != 255:
            continue
        ImageDraw.floodfill(lab, (x, y), 100)
        arr = np.asarray(lab)
        comp = arr == 100
        ys, xs = np.nonzero(comp)
        labels[comp] = len(blobs) + 1
        blobs.append([comp.sum(), (xs.min(), ys.min(), xs.max() + 1, ys.max() + 1), len(blobs) + 1])
        lab = Image.fromarray(np.where(comp, 50, arr).astype(np.uint8)).copy()

blobs.sort(key=lambda b: -b[0])
if len(blobs) < len(poses) or blobs[len(poses) - 1][0] < blobs[0][0] * 0.15:
    sys.exit('자세 %d개를 못 찾음 (찾은 큰 덩어리: %s). 자세끼리 붙어 있는지 확인' % (len(poses), [b[0] for b in blobs[:8]]))
big = [{"box": list(b[1]), "ids": [b[2]]} for b in blobs[:len(poses)]]
# 작은 조각(손에 든 물건, 머리카락 끝 등)은 가장 가까운 큰 덩어리에 합친다
for area, (x0, y0, x1, y1), k in blobs[len(poses):]:
    cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
    def dist(g):
        b = g["box"]
        dx = max(b[0] - cx, 0, cx - b[2])
        dy = max(b[1] - cy, 0, cy - b[3])
        return dx * dx + dy * dy
    g = min(big, key=dist)
    if dist(g) > 60 * 60:
        continue  # 너무 멀면 버린다 (잡티)
    g["ids"].append(k)
    b = g["box"]
    b[0], b[1], b[2], b[3] = min(b[0], x0), min(b[1], y0), max(b[2], x1), max(b[3], y1)

# 3) 왼쪽부터 순서대로, 자기 덩어리 픽셀만 남겨서 저장 (옆 자세가 같이 잘리지 않게)
big.sort(key=lambda g: (g["box"][0] + g["box"][2]) / 2)
soft = np.asarray(alpha_img)
for name, g in zip(poses, big):
    x0, y0, x1, y1 = g["box"]
    mine = np.isin(labels, g["ids"])
    piece = im.copy()
    piece.putalpha(Image.fromarray(np.where(mine, soft, 0).astype(np.uint8)))
    piece = piece.crop((x0, y0, x1, y1))
    path = 'assets/characters/%s_%s.png' % (char_id, name)
    piece.save(path, optimize=True)
    print(path, piece.size)
