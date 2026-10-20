# 새 자세 그림 넣기 (걷기, 대시, 필살기 자세 등). 다른 자세 그림들과 같은 크기로 맞춰서 저장한다
#
# 사용법:
#   python tools/add_pose.py <캐릭터 id> <자세>=<그림>[@키비율] ...
#   예) python tools/add_pose.py chemikid walk=a.webp walk2=b.webp 6d=c.webp@0.8
#   → assets/characters/chemikid_walk.png ...
#
# 한 장씩 받은 그림은 AI가 매번 꽉 차게 그려서 크기가 제각각이다.
# 그래서 "서 있을 때 키(punch/guard/hit 키의 중간값)"에 대한 비율로 크기를 다시 맞춘다.
# 키비율: 그 자세에서 캐릭터(+손에 든 물건) 맨 위~맨 아래가 서 있을 때 키의 몇 배인지.
#   안 적으면 아래 DEFAULT_RATIO, 그것도 없으면 1.0. 넣은 뒤 머리 크기가 다르면 비율만 고쳐서 다시 넣으면 된다.
import sys
import numpy as np
from PIL import Image

DEFAULT_RATIO = {
    'walk': 1.0, 'walk2': 1.0, 'walk3': 1.0, 'walk4': 1.0, 'walk_back': 1.0,
    'dash': 0.85, 'air_dash': 0.75, 'backdash': 0.95,
    'down': 0.35,             # 쓰러져 누운 자세 (키가 아주 낮음)
    'win': 1.05, 'throw': 0.95, 'crouch_guard': 0.7, 'jump_attack': 0.85,
}

char_id = sys.argv[1]


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


stand = sorted(height(Image.open(path(p))) for p in ('punch', 'guard', 'hit'))[1]
for arg in sys.argv[2:]:
    pose, src = arg.split('=', 1)
    ratio = DEFAULT_RATIO.get(pose, 1.0)
    if '@' in src:
        src, r = src.rsplit('@', 1)
        ratio = float(r)
    im = trim(Image.open(src))
    k = stand * ratio / height(im)
    im = im.resize((round(im.width * k), round(im.height * k)), Image.LANCZOS)
    im.save(path(pose.lower()), optimize=True)
    print(path(pose.lower()), 'x%.2f' % k, im.size)
