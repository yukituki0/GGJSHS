"""관람객 안내자료 (인쇄용 A4 2장) - 게임과 같은 길티기어 스타일, 주아체, 게임 그림 사용

    python3 docs/handout/make_handout.py   →  docs/handout/guilty_jshs_handout.pdf

글자를 바꾸려면 아래 page1() / page2() 안의 문장만 고치면 된다.
주아체(Jua)에 없는 화살표·가운뎃점은 자동으로 DejaVu 글꼴로 그린다.
"""
import io
import os

from PIL import Image
from fontTools.ttLib import TTFont as FTFont
from reportlab.lib.colors import Color, HexColor, black, white
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))
OUT = os.path.join(HERE, 'guilty_jshs_handout.pdf')
W, H = A4

RED = HexColor('#d8263a')
RED_DARK = HexColor('#8e1222')
GOLD = HexColor('#f5c542')
INK = HexColor('#0c0c11')
PANEL = HexColor('#17171f')
PANEL2 = HexColor('#22222c')
GRAY = HexColor('#a9adba')
CYAN = HexColor('#57c8ff')

# ── 글꼴 ──────────────────────────────────────────────
FONTS = {
    'jua': os.path.join(HERE, 'fonts', 'Jua-Regular.ttf'),
    'dejavu': os.path.join(HERE, 'fonts', 'DejaVuSans-Bold.ttf'),
    'anton': os.path.join(ROOT, 'assets', 'fonts', 'Anton-Regular.ttf'),
}
for name, path in FONTS.items():
    pdfmetrics.registerFont(TTFont(name, path))
_CMAP = {name: set(FTFont(path).getBestCmap()) for name, path in FONTS.items()}


def runs(text, font):
    """글꼴에 없는 글자(화살표 등)는 DejaVu로 나눠 그리기"""
    out = []
    for ch in text:
        if ch in '←→↑↓↙▶':
            f = 'dejavu'  # 화살표는 굵은 DejaVu로 통일 (Anton 화살표는 너무 가늘다)
        elif ord(ch) in _CMAP[font] or ch == ' ':
            f = font
        elif ord(ch) in _CMAP['jua']:
            f = 'jua'  # Anton에 없는 한글
        else:
            f = 'dejavu'
        if out and out[-1][0] == f:
            out[-1][1] += ch
        else:
            out.append([f, ch])
    return out


def width(text, size, font='jua'):
    return sum(pdfmetrics.stringWidth(t, f, size * (1.0 if f == 'dejavu' else 1)) for f, t in runs(text, font))


def text(c, x, y, s, size, color=white, font='jua', align='left', outline=None):
    """한 줄 글자. align = left / center / right. outline = (색, 두께) 이면 테두리"""
    w = width(s, size, font)
    if align == 'center':
        x -= w / 2
    elif align == 'right':
        x -= w
    c.saveState()  # 테두리 글자 모드(Tr)가 다음 글자로 새지 않게
    for f, t in runs(s, font):
        sz = size * (1.0 if f == 'dejavu' else 1)
        to = c.beginText()
        to.setTextOrigin(x, y)
        to.setFont(f, sz)
        if outline:
            c.setStrokeColor(outline[0])
            c.setLineWidth(outline[1])
            c.setLineJoin(1)
            to.setTextRenderMode(2)
        else:
            to.setTextRenderMode(0)
        c.setFillColor(color)
        to.textOut(t)
        c.drawText(to)
        x += pdfmetrics.stringWidth(t, f, sz)
    c.restoreState()
    return w


def wrap(s, size, maxw, font='jua'):
    """띄어쓰기 단위로 줄 바꾸기 (한국어 단어는 안 쪼갬)"""
    lines, cur = [], ''
    for word in s.split(' '):
        trial = (cur + ' ' + word).strip()
        if cur and width(trial, size, font) > maxw:
            lines.append(cur)
            cur = word
        else:
            cur = trial
    if cur:
        lines.append(cur)
    return lines


def para(c, x, y, s, size, maxw, color=white, lead=1.32):
    """여러 줄. 마지막 줄 아래 y를 돌려준다"""
    for line in wrap(s, size, maxw):
        text(c, x, y, line, size, color)
        y -= size * lead
    return y


# ── 도형 ──────────────────────────────────────────────
def slant(c, x, y, w, h, fill, skew=10, stroke=None, lw=1.5):
    """길티기어 HUD 같은 기울어진 사각형 (평행사변형)"""
    p = c.beginPath()
    p.moveTo(x + skew, y + h)
    p.lineTo(x + w, y + h)
    p.lineTo(x + w - skew, y)
    p.lineTo(x, y)
    p.close()
    if fill is not None:
        c.setFillColor(fill)
    if stroke is not None:
        c.setStrokeColor(stroke)
        c.setLineWidth(lw)
    c.drawPath(p, fill=fill is not None, stroke=stroke is not None)


def alpha_rect(c, x, y, w, h, color, a):
    c.saveState()
    c.setFillColor(color)
    c.setFillAlpha(a)
    c.rect(x, y, w, h, fill=1, stroke=0)
    c.restoreState()


def fade(c, x, y, w, h, color, top_a, bottom_a, steps=24):
    """세로 그라데이션 (위 → 아래 투명도)"""
    for i in range(steps):
        a = top_a + (bottom_a - top_a) * i / (steps - 1)
        alpha_rect(c, x, y + h - (i + 1) * h / steps, w, h / steps + 0.5, color, a)


def speed_lines(c, x, y, w, h, color, n=14, a=0.10):
    """뒤에 깔리는 비스듬한 속도선"""
    c.saveState()
    c.setStrokeColor(color)
    c.setStrokeAlpha(a)
    for i in range(n):
        c.setLineWidth(1 + (i % 3) * 1.5)
        x0 = x + i * w / n
        c.line(x0, y, x0 + h * 0.45, y + h)
    c.restoreState()


_cache = {}


def image(c, rel, x, y, w, h, mode='cover', anchor=(0.5, 0.5), dpi=200, alpha=1.0):
    """게임 그림 넣기. cover = 꽉 채우고 잘라냄, contain = 다 보이게. anchor = 자를 때 기준 (0~1)"""
    path = os.path.join(ROOT, rel)
    im = Image.open(path).convert('RGBA')
    tw, th = int(w / 72 * dpi), int(h / 72 * dpi)
    if mode == 'cover':
        s = max(tw / im.width, th / im.height)
        im = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), Image.LANCZOS)
        left = int((im.width - tw) * anchor[0])
        top = int((im.height - th) * anchor[1])
        im = im.crop((left, top, left + tw, top + th))
        dx = dy = 0
        dw, dh = w, h
    else:
        s = min(tw / im.width, th / im.height)
        im = im.resize((max(1, round(im.width * s)), max(1, round(im.height * s))), Image.LANCZOS)
        dw, dh = im.width * 72 / dpi, im.height * 72 / dpi
        dx = (w - dw) * anchor[0]
        dy = (h - dh) * (1 - anchor[1])
    if alpha < 1.0:
        a = im.getchannel('A').point(lambda v: int(v * alpha))
        im.putalpha(a)
    buf = io.BytesIO()
    if im.getchannel('A').getextrema()[0] == 255:  # 투명한 곳이 없으면 JPEG (PDF 용량 줄이기)
        im.convert('RGB').save(buf, 'JPEG', quality=88)
    else:
        im.save(buf, 'PNG', optimize=True)
    buf.seek(0)
    c.drawImage(ImageReader(buf), x + dx, y + dy, dw, dh, mask='auto')


# ── 공통 부품 ──────────────────────────────────────────
def panel(c, x, y, w, h, title, sub):
    """어두운 판 + 위에 빨간 기울어진 제목 띠"""
    slant(c, x, y, w, h, PANEL, skew=8, stroke=HexColor('#33333f'), lw=1)
    c.setFillColor(RED)
    c.rect(x + 2, y + 6, 3, h - 30, fill=1, stroke=0)
    slant(c, x - 4, y + h - 22, min(w * 0.72, width(title, 15) + 90), 26, RED, skew=10)
    text(c, x + 12, y + h - 15, title, 15)
    text(c, x + 18 + width(title, 15), y + h - 14, sub, 9, HexColor('#ffd7dc'), font='anton')


def chip(c, x, y, label, fill=INK, color=white, w=None, size=10.5):
    w = w or width(label, size) + 16
    slant(c, x, y, w, 17, fill, skew=5, stroke=RED, lw=1)
    text(c, x + w / 2, y + 4.5, label, size, color, align='center')
    return w


def header_corner(c, y_top):
    """오른쪽 위: 학교 엠블럼 + 동아리"""
    image(c, 'docs/handout/img/emblem.png', W - 74, y_top - 60, 50, 50, mode='contain')
    text(c, W - 14, y_top - 71, '제주과학고 정보동아리 COMMON', 7.5, white, align='right')


def footer(c, page):
    slant(c, -10, 0, W + 20, 26, RED_DARK, skew=0)
    slant(c, -10, 0, 250, 26, RED, skew=14)
    text(c, 18, 9, 'GUILTY JSHS', 12, white, font='anton')
    text(c, 104, 9, '관람객 안내자료', 11)
    text(c, W - 20, 9, '제주과학고등학교 정보동아리 COMMON   %d / 2' % page, 9.5, white, align='right')


def number(c, x, y, n, size=22):
    text(c, x, y, '%02d' % n, size, RED, font='anton')


# ── 1쪽: 격투 게임 설명서 ────────────────────────────────
def page1(c):
    c.setFillColor(INK)
    c.rect(0, 0, W, H, fill=1, stroke=0)
    speed_lines(c, 0, 0, W, H, white, n=18, a=0.035)

    # 위: 대표 그림 + 로고
    top_h = 232
    image(c, 'assets/ui/key_art.png', 0, H - top_h, W, top_h, anchor=(0.5, 0.35))
    fade(c, 0, H - top_h, W, top_h * 0.75, INK, 0.0, 1.0)
    alpha_rect(c, 0, H - top_h, W, top_h, INK, 0.12)
    image(c, 'assets/ui/logo.png', 14, H - top_h + 22, 300, 143, mode='contain', anchor=(0, 1))
    slant(c, 300, H - top_h + 58, W - 290, 46, RED, skew=18)
    text(c, 322, H - top_h + 74, '격투 게임 설명서', 27)
    slant(c, 330, H - top_h + 36, W - 320, 20, INK, skew=10, stroke=RED, lw=1)
    text(c, 346, H - top_h + 41.5, 'HOW TO PLAY  ·  처음 하는 사람을 위한 안내', 10, GOLD, font='anton')
    header_corner(c, H - 10)

    # 01 이렇게 이겨요
    y = H - top_h - 78
    panel(c, 20, y, W - 40, 70, '이렇게 이겨요', 'HOW TO WIN')
    steps = ['캐릭터 고르기', '공격하고 막기', '체력 0 만들기', '2라운드 먼저 승리']
    sw = (W - 80) / 4
    for i, s in enumerate(steps):
        sx = 34 + i * sw
        slant(c, sx, y + 12, sw - 14, 26, PANEL2, skew=8, stroke=RED, lw=1)
        number(c, sx + 10, y + 18, i + 1, 15)
        text(c, sx + 32, y + 19, s, 11.5)
        if i < 3:
            text(c, sx + sw - 13, y + 18, '▶', 10, RED, font='dejavu')
    text(c, W - 30, y + 46, '한 라운드 60초 · 시간이 끝나면 체력이 많은 쪽이 승리', 9.5, GRAY, align='right')

    # 02 버튼 / 03 막기
    y2 = y - 224
    colw = (W - 52) / 2
    panel(c, 20, y2, colw, 214, '버튼', 'BUTTONS')
    bx = 40
    colors = [('P', '#3c7be0'), ('K', '#2fae6b'), ('S', '#e3a21a'), ('HS', '#d8344a'), ('D', '#8b4fd6'), ('RC', '#4b5468')]
    for i, (lb, col) in enumerate(colors):
        cx, cy = bx + 18 + i * 38, y2 + 166
        c.setFillColor(HexColor('#000000'))
        c.circle(cx, cy - 2, 15, fill=1, stroke=0)
        c.setFillColor(HexColor(col))
        c.setStrokeColor(white)
        c.setLineWidth(1.2)
        c.circle(cx, cy, 15, fill=1, stroke=1)
        text(c, cx, cy - 4.5, lb, 12 if len(lb) < 2 else 10.5, white, font='anton', align='center')
    rows = [('레버', '← → 걷기 · ↑ 점프 · ↓ 앉기 · →→ 대시'),
            ('P K S HS', '기본 공격 · 왼쪽은 빠르게, 오른쪽은 세게'),
            ('D', '필살기 · 레버와 같이 D / →D / ↓D / ←D'),
            ('D + HS', '궁극기 (텐션 50%)'),
            ('RC', '로만 캔슬 · 공격 취소 (텐션 50%)')]
    ry = y2 + 124
    for k, v in rows:
        chip(c, 32, ry - 4, k, w=62, size=10)
        para(c, 102, ry, v, 10.2, colw - 92)
        ry -= 25

    gx = 32 + colw
    panel(c, gx, y2, colw, 214, '막기', 'GUARD')
    half = (colw - 36) / 2
    for i, (pose, title, desc) in enumerate([('globe_guard', '← 서서 막기', '상단 · 중단을 막아요'),
                                             ('globe_crouch_guard', '↙ 앉아서 막기', '상단 · 하단을 막아요')]):
        px = gx + 14 + i * (half + 8)
        slant(c, px, y2 + 64, half, 120, PANEL2, skew=6)
        image(c, 'assets/effects/fx_guard_shield.png', px + half - 40, y2 + 96, 34, 80, mode='contain', alpha=0.85)
        image(c, 'assets/characters/%s.png' % pose, px + 4, y2 + 96, half - 40, 84, mode='contain', anchor=(0.5, 1))
        text(c, px + half / 2, y2 + 82, title, 12.5, white, align='center')
        text(c, px + half / 2, y2 + 70, desc, 9, GRAY, align='center')
    gy = y2 + 46
    for k, fill, v in [('중단', HexColor('#1f6f9e'), '점프 공격 · →K  →  서서 막기'),
                       ('하단', HexColor('#1f6f9e'), '↓K · ↓S  →  앉아서 막기'),
                       ('잡기', RED, '붙어서 →/← + HS  →  못 막아요! 잡히면 HS')]:
        chip(c, gx + 14, gy - 4, k, fill=fill, w=40, size=10)
        text(c, gx + 62, gy, v, 9.8)
        gy -= 18.5

    # 04 콤보 / 05 게이지
    y3 = y2 - 172
    panel(c, 20, y3, colw, 162, '콤보', 'COMBO')
    slant(c, 32, y3 + 84, colw - 24, 44, PANEL2, skew=10, stroke=RED, lw=1)
    text(c, 20 + colw / 2, y3 + 97, 'P > K > S > HS', 26, white, font='anton', align='center', outline=(RED, 1.2))
    text(c, 20 + colw / 2, y3 + 70, '공격이 맞는 순간 더 센 버튼을 누르면 이어져요', 10, GRAY, align='center')
    slant(c, 32, y3 + 26, colw - 24, 34, PANEL2, skew=10, stroke=RED, lw=1)
    text(c, 20 + colw / 2, y3 + 36, 'S > HS > D', 21, white, font='anton', align='center', outline=(RED, 1))
    text(c, 20 + colw / 2, y3 + 10, '마지막은 필살기(D)로 마무리!', 10, GOLD, align='center')

    panel(c, gx, y3, colw, 162, '게이지', 'GAUGES')
    image(c, 'assets/ui/hud_hp_fill.png', gx + 16, y3 + 110, 70, 16, mode='contain')
    image(c, 'assets/ui/hud_tension_p1_full.png', gx + 16, y3 + 78, 70, 18, mode='contain')
    for i in range(4):
        slant(c, gx + 18 + i * 17, y3 + 52, 15, 6, CYAN, skew=3)
    c.setFillColor(GOLD)
    c.circle(gx + 50, y3 + 20, 10, fill=1, stroke=0)
    text(c, gx + 50, y3 + 16, 'B', 11, INK, font='anton', align='center')
    for i, (k, v) in enumerate([('체력 (위)', '0이 되면 그 라운드는 져요'),
                                ('텐션 (아래)', '앞으로 가고 공격하면 차요 · 50%면 궁극기'),
                                ('마력', '필살기 한 번에 한 칸 · 시간이 지나면 다시 차요'),
                                ('버스트', '맞는 중에 D + 공격 버튼 → 콤보 탈출')]):
        ty = y3 + 120 - i * 31
        text(c, gx + 96, ty, k, 11.5, GOLD)
        para(c, gx + 96, ty - 13, v, 9.2, colw - 104, GRAY)

    # 처음이라면
    y4 = 36
    h4 = y3 - y4 - 10
    slant(c, 20, y4, W - 40, h4, HexColor('#2a0d12'), skew=10, stroke=RED, lw=1.5)
    image(c, 'assets/ui/text_fight.png', W - 170, y4 + 6, 140, h4 - 12, mode='contain', alpha=0.9)
    text(c, 40, y4 + h4 - 22, '처음이라면', 15, GOLD)
    tips = ['모드 선택 → 게임 설명서 · 트레이닝부터 해 보세요',
            '막 누르기보다 먼저 막고, 상대가 헛치면 반격!',
            '일시정지(START) → 콤보표에 캐릭터별 쉬운 콤보가 있어요']
    for i, t in enumerate(tips):
        text(c, 44, y4 + h4 - 42 - i * 16, '▶', 7.5, RED, font='dejavu')
        text(c, 56, y4 + h4 - 42 - i * 16, t, 10.5)
    footer(c, 1)


# ── 2쪽: 캐릭터 & 콤보 ──────────────────────────────────
CHARS = [
    ('chemikid', 'CHEMIKID', '화학 동아리', '플라스크·불꽃 반응, 느리지만 한방', 'S > HS > ↓D', '#62e07a'),
    ('common', 'COMMON', '정보 동아리', '패킷·버그 함정, 빠른 트릭', '↓K > S > HS > D', '#4fb4ff'),
    ('globe', 'GLOBE', '지구과학 동아리', '유성·돌진, 체력 최고 헤비급', 'S > HS > →D', '#ff8a3c'),
    ('chaos', 'CHAOS', '물리 동아리', '중력으로 끌어와 잡기', 'S > HS > ↓D', '#b07cff'),
    ('root2', 'ROOT2', '수학 동아리', '컴퍼스·부메랑 원거리 견제', 'S > HS > D', '#ffd34a'),
    ('seed', 'SEED', '생명 동아리', '덩굴·분신·회복, 진화로 강화', 'S > HS > →D', '#ff7ab8'),
]


def page2(c):
    c.setFillColor(INK)
    c.rect(0, 0, W, H, fill=1, stroke=0)
    speed_lines(c, 0, 0, W, H, white, n=18, a=0.035)

    top_h = 196
    image(c, 'assets/ui/bg_vs.png', 0, H - top_h, W, top_h, anchor=(0.5, 0.5))
    fade(c, 0, H - top_h, W, top_h * 0.6, INK, 0.0, 1.0)
    image(c, 'assets/ui/text_vs.png', W / 2 - 70, H - top_h + 70, 140, 110, mode='contain', alpha=0.9)
    image(c, 'assets/ui/logo.png', 14, H - 86, 150, 72, mode='contain', anchor=(0, 0.5))
    slant(c, 20, H - top_h + 18, 330, 44, RED, skew=16)
    text(c, 40, H - top_h + 33, '캐릭터 & 콤보 모음', 25)
    slant(c, 30, H - top_h - 2, 300, 18, INK, skew=8, stroke=RED, lw=1)
    text(c, 46, H - top_h + 3, 'CHARACTERS & COMBOS  ·  6명의 동아리 대표', 9.5, GOLD, font='anton')
    header_corner(c, H - 10)

    # 캐릭터 카드 2 x 3
    cw = (W - 52) / 2
    ch = 142
    y0 = H - top_h - 26 - ch
    for i, (cid, name, club, style, combo, col) in enumerate(CHARS):
        x = 20 + (i % 2) * (cw + 12)
        y = y0 - (i // 2) * (ch + 10)
        slant(c, x, y, cw, ch, PANEL, skew=10, stroke=HexColor(col), lw=1.6)
        # 상반신 (선택창 그림)
        c.saveState()
        p = c.beginPath()
        p.moveTo(x + 12, y + ch)
        p.lineTo(x + 122, y + ch)
        p.lineTo(x + 110, y)
        p.lineTo(x, y)
        p.close()
        c.clipPath(p, stroke=0, fill=0)
        c.setFillColor(HexColor(col))
        c.setFillAlpha(0.25)
        c.rect(x, y, 124, ch, fill=1, stroke=0)
        c.setFillAlpha(1)
        image(c, 'assets/characters/%s_select.png' % cid, x, y, 124, ch, anchor=(0.5, 0.0))
        c.restoreState()
        tx = x + 130
        text(c, tx, y + ch - 30, name, 22, white, font='anton')
        text(c, tx, y + ch - 46, club, 10.5, HexColor(col))
        para(c, tx, y + ch - 66, style, 10.5, cw - 140, white)
        text(c, tx, y + 34, '입문 콤보', 9, GRAY)
        slant(c, tx - 2, y + 10, cw - 136, 20, INK, skew=6, stroke=RED, lw=1)
        text(c, tx + 8, y + 15.5, combo, 12.5, white, font='anton')

    # 아래: 콤보 읽는 법 / 모두 쓸 수 있는 콤보
    yb = 40
    hb = y0 - 2 * (ch + 10) - yb - 12
    panel(c, 20, yb, cw, hb, '콤보 읽는 법', 'NOTATION')
    for i, (k, v) in enumerate([('↓K', '앉아서 K'), ('→D', '앞 + D'),
                                ('>', '앞 기술이 맞는 순간 다음 버튼'), ('↑', '↓HS가 맞는 순간 점프 (공중 콤보)')]):
        ry = yb + hb - 46 - i * 21
        chip(c, 32, ry - 4, k, w=38, size=11)
        text(c, 80, ry, v, 10.5)
    gx = 32 + cw
    panel(c, gx, yb, cw, hb, '모두 쓸 수 있는 콤보', 'FOR EVERYONE')
    for i, (k, v) in enumerate([('입문', 'P > K > S > HS'), ('띄우기', '↓HS > ↑ > S > HS > D'),
                                ('궁극기 마무리', '콤보 끝에 D + HS (텐션 50%)')]):
        ry = yb + hb - 48 - i * 26
        number(c, gx + 14, ry - 2, i + 1, 17)
        text(c, gx + 40, ry + 4, k, 10.5, GOLD)
        text(c, gx + 40, ry - 9, v, 11.5, white, font='anton' if i < 2 else 'jua')
    footer(c, 2)


def main():
    c = canvas.Canvas(OUT, pagesize=A4)
    c.setTitle('Guilty JSHS 관람객 안내자료')
    c.setAuthor('제주과학고등학교 정보동아리 COMMON')
    page1(c)
    c.showPage()
    page2(c)
    c.showPage()
    c.save()
    print(os.path.relpath(OUT, ROOT))


if __name__ == '__main__':
    main()
