"""임시 효과음 합성기 (나중에 진짜 효과음으로 바꿀 때까지 쓰는 소리)

    python3 tools/make_sfx.py

assets/sound/ 에 같은 이름의 .wav 파일을 만든다. 더 좋은 효과음(.wav / .ogg)이 생기면
같은 이름으로 덮어쓰기만 하면 된다 (Sfx.gd가 이름으로 찾는다).
"""
import os
import wave

import numpy as np

RATE = 44100
OUT = os.path.join(os.path.dirname(__file__), '..', 'assets', 'sound')
rng = np.random.default_rng(7)


def t(sec):
    return np.linspace(0, sec, int(RATE * sec), endpoint=False)


def env(n, attack=0.002, decay=6.0):
    """빠르게 올라갔다가 지수적으로 줄어드는 볼륨"""
    x = np.arange(n) / RATE
    a = np.clip(x / attack, 0, 1)
    return a * np.exp(-x * decay)


def noise(sec):
    return rng.uniform(-1, 1, int(RATE * sec))


def lowpass(x, k):
    """간단한 이동 평균 저역 통과 (k가 클수록 묵직하게)"""
    return np.convolve(x, np.ones(k) / k, mode='same')


def sweep(sec, f0, f1):
    """주파수가 f0 → f1로 변하는 사인파"""
    f = np.linspace(f0, f1, int(RATE * sec))
    return np.sin(2 * np.pi * np.cumsum(f) / RATE)


def save(name, x, gain=0.8):
    x = x / (np.max(np.abs(x)) + 1e-9) * gain
    data = (x * 32767).astype(np.int16)
    with wave.open(os.path.join(OUT, name + '.wav'), 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(data.tobytes())


def hit(sec, low, thump_hz, decay):
    n = int(RATE * sec)
    body = lowpass(noise(sec), low) * env(n, decay=decay)
    thump = sweep(sec, thump_hz, thump_hz * 0.4) * env(n, decay=decay * 0.8)
    return body + thump * 0.9


os.makedirs(OUT, exist_ok=True)
# 타격음: 약 / 중 / 강
save('hit_light', hit(0.12, 3, 220, 28))
save('hit_medium', hit(0.18, 6, 160, 18))
save('hit_heavy', hit(0.32, 12, 110, 10), gain=0.95)
# 가드: 짧고 높은 금속성 "탁"
n = int(RATE * 0.12)
save('guard', (np.sin(2 * np.pi * 1300 * t(0.12)) * 0.5 + lowpass(noise(0.12), 2) * 0.5) * env(n, decay=35), 0.6)
# 헛스윙: 바람 소리
n = int(RATE * 0.16)
save('whoosh', lowpass(noise(0.16), 8) * np.sin(np.linspace(0, np.pi, n)) ** 2, 0.4)
# 점프 / 대시
save('jump', sweep(0.12, 300, 700) * env(int(RATE * 0.12), decay=20), 0.35)
save('dash', lowpass(noise(0.2), 4) * env(int(RATE * 0.2), attack=0.03, decay=12), 0.45)
# 필살기 발동 / 투사체
save('special', (sweep(0.25, 500, 1500) + sweep(0.25, 750, 2200) * 0.5) * env(int(RATE * 0.25), decay=9), 0.5)
# 로만 캔슬: 위로 솟는 "쉬잉"
save('rc', (sweep(0.35, 400, 2400) + lowpass(noise(0.35), 3) * 0.3) * env(int(RATE * 0.35), attack=0.01, decay=7), 0.55)
# 오버드라이브 컷인: 낮은 쾅 + 금속 울림
sec = 0.9
n = int(RATE * sec)
save('overdrive', (sweep(sec, 90, 40) * env(n, decay=3) + np.sin(2 * np.pi * 660 * t(sec)) * env(n, decay=5) * 0.3
                   + lowpass(noise(sec), 20) * env(n, decay=4) * 0.6), 0.9)
# K.O.: 길고 무거운 쾅
sec = 1.2
n = int(RATE * sec)
save('ko', hit(sec, 25, 80, 3) + sweep(sec, 200, 50) * env(n, decay=2.5) * 0.5, 0.95)
# 메뉴: 이동 / 결정 / 취소
# 메뉴 소리: 부드러운 사인파 대신 배음이 많은 사각파 + 짧은 금속성 클릭으로 날카롭게
mrng = np.random.default_rng(11)  # 다른 효과음의 노이즈가 바뀌지 않게 따로


def square(sec, f, duty=0.5):
    """사각파 (배음이 많아서 날카로운 소리)"""
    return np.where((t(sec) * f) % 1.0 < duty, 1.0, -1.0)


def click(sec, k=3):
    """아주 짧은 고음 잡음 (금속을 튕기는 듯한 시작음)"""
    x = mrng.uniform(-1, 1, int(RATE * sec))
    return (x - lowpass(x, k)) * env(len(x), attack=0.0005, decay=400)


sec = 0.045
save('menu_move', (square(sec, 1760, 0.25) * 0.5 + np.sin(2 * np.pi * 3520 * t(sec)) * 0.3)
     * env(int(RATE * sec), attack=0.0008, decay=90) + click(sec) * 0.6, 0.3)
sec = 0.16
f = np.concatenate([np.full(int(RATE * 0.05), 1320.0), np.full(int(RATE * sec) - int(RATE * 0.05), 1980.0)])
ok = np.where((np.cumsum(f) / RATE) % 1.0 < 0.3, 1.0, -1.0)
save('menu_ok', (ok * 0.55 + np.sin(2 * np.pi * np.cumsum(f * 2) / RATE) * 0.25)
     * env(int(RATE * sec), attack=0.0008, decay=22) + click(sec, 2) * 0.7, 0.4)
sec = 0.1
fb = np.linspace(1100, 520, int(RATE * sec))
back = np.where((np.cumsum(fb) / RATE) % 1.0 < 0.4, 1.0, -1.0)
save('menu_back', back * env(int(RATE * sec), attack=0.0008, decay=35) * 0.6 + click(sec) * 0.4, 0.33)
# 라운드 시작 "FIGHT!" 강조음
sec = 0.5
n = int(RATE * sec)
save('fight', (hit(sec, 8, 140, 6) + sweep(sec, 300, 900) * env(n, decay=6) * 0.5), 0.9)
print('saved to', os.path.abspath(OUT))
