# 자세를 한 장씩 받은 고화질 그림으로 바꾸기 (포즈 시트로 넣은 자세 크기 비율을 그대로 유지)
#
# 사용법:
#   python tools/replace_poses.py <캐릭터 id> <자세>=<그림> [<자세>=<그림> ...]
#   예) python tools/replace_poses.py chemikid punch=a.webp kick=b.webp hit=c.webp
#
# 한 장씩 받은 그림은 AI가 매번 꽉 차게 그려서 웅크린 자세도 서 있는 것만큼 크다.
# 그래서 지금 들어 있는 자세 그림(포즈 시트에서 자른 것)의 키 비율대로 크기를 다시 맞춘다.
# 받은 그림에 없는 자세도 같은 배율로 키워서 크기를 맞춘다. 처음엔 hit 그림이 기준이라 꼭 넣을 것.
# (이미 고화질로 바꾼 캐릭터는 hit 없이 남은 자세만 넣어도 됨 → 지금 크기를 그대로 기준으로 씀)
import sys
import numpy as np
from PIL import Image

POSES = ['punch', 'kick', 'guard', 'hit', 'crouch', 'jump']
char_id = sys.argv[1]
new = dict(arg.split('=', 1) for arg in sys.argv[2:])


def path(pose):
    return 'assets/characters/%s_%s.png' % (char_id, pose)


def trim(im):
    """반투명 잡티를 지우고 진한 부분에 딱 맞게 자르기"""
    im = im.convert('RGBA')
    a = np.asarray(im.getchannel('A')).copy()
    a[a < 40] = 0
    im.putalpha(Image.fromarray(a))
    s = a > 128
    ys, xs = np.nonzero(s.any(1))[0], np.nonzero(s.any(0))[0]
    return im.crop((max(0, xs[0] - 4), max(0, ys[0] - 4), xs[-1] + 5, ys[-1] + 5))


def height(im):
    a = np.asarray(im.getchannel('A')) > 128
    ys = np.nonzero(a.any(1))[0]
    return ys[-1] - ys[0] + 1


old = {p: height(Image.open(path(p))) for p in POSES}  # 지금 자세들의 키 (시트 비율)
pieces = {p: trim(Image.open(f)) for p, f in new.items()}
if 'hit' in new:
    scale = height(pieces['hit']) / old['hit']  # 시트 1픽셀 → 새 그림 몇 픽셀
elif Image.open(path('hit')).height > 900:
    scale = 1.0  # 이미 고화질로 바뀐 캐릭터: 지금 크기 그대로
else:
    sys.exit('처음 바꿀 때는 hit 그림이 있어야 크기 기준을 잡을 수 있음')
for p in POSES:
    if p not in pieces and scale == 1.0:
        continue  # 크기가 이미 맞는 그림은 다시 저장하지 않음 (다시 늘이면 흐려짐)
    im = pieces.get(p) or trim(Image.open(path(p)))
    k = old[p] * scale / height(im)
    im = im.resize((round(im.width * k), round(im.height * k)), Image.LANCZOS)
    im.save(path(p), optimize=True)
    print(path(p), '새 그림' if p in pieces else '크기만 맞춤', im.size)
