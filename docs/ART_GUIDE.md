# Guilty JSHS 그림 가이드 (ChatGPT / Gemini용)

그림 파일을 아래 경로에 **이 이름 그대로** 넣으면 게임이 자동으로 사용한다.
(없으면 지금처럼 코드로 그린 임시 그래픽이 나온다)

| 그림 | 파일 경로 | 크기 / 형식 |
|---|---|---|
| 화학 실험실 배경 | `assets/stages/lab.png` | 1920×1080 (16:9), PNG |
| 컴퓨터실 배경 | `assets/stages/computer.png` | 1920×1080 (16:9), PNG |
| 옥상(제주 바다) 배경 | `assets/stages/rooftop.png` | 1920×1080 (16:9), PNG |
| CHEMIKID 전신 일러스트 | `assets/characters/chemikid.png` | 세로로 긴 그림, **투명 배경** PNG |
| COMMON 전신 일러스트 | `assets/characters/common.png` | 세로로 긴 그림, **투명 배경** PNG |
| 타이틀 로고 | `assets/ui/logo.png` | 가로로 긴 그림, **투명 배경** PNG |
| 타이틀/메뉴 배경 | `assets/ui/key_art.png` | 1920×1080 (16:9), PNG |
| HUD/메뉴 부품 | `assets/ui/` | 목업에서 잘라낸 PNG (이름은 넣을 때 같이 정하기) |

## 공통 스타일 문장 (모든 프롬프트 끝에 붙이기)

> Japanese anime fighting game art style, cel-shaded with hard-edged shadows,
> thick black ink outlines, high contrast, saturated colors, dramatic rim lighting,
> gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.

- 게임 이름을 넣어서 "~ 스타일"이라고 쓰는 대신 **특징을 풀어서** 쓰는 게 결과가 안정적이고, 저작권 문제도 피할 수 있다.
- 그림 안에 **글자/로고가 들어가지 않게** `no text, no logo, no watermark`를 붙인다.

---

## 0단계: 화풍 확정용 "게임 화면 목업" (제일 먼저!)

배경/캐릭터/HUD가 다 들어간 **가짜 게임 스크린샷**을 먼저 한 장 만들어서 화풍을 정한다.
마음에 드는 목업이 나오면 → 체력바, 타이머 같은 부품을 Photopea로 잘라서 쓰고,
나머지 그림을 만들 때도 이 목업을 **첨부해서 "같은 화풍으로"** 요청한다.

```
A screenshot mockup of a 2D anime fighting game, 16:9, 1920x1080.
Two fighters face each other on a stage: on the left, a chemistry-club student in a white lab coat
with a glowing green flask; on the right, a computer-club hacker in a black hoodie with cyan
circuit patterns carrying a mechanical keyboard like a guitar.
Stage: a Korean high school chemistry lab at night.
HUD: at the top, two long slanted health bars with ornate metallic frames and yellow-to-orange
gradient fill, a small character portrait at each outer end, a gear-shaped round timer in the
center showing "60"; at the bottom, two slanted metallic "tension" gauges with orange fill.
[공통 스타일 문장]
```
(HUD 글자는 AI가 틀리게 쓰기 쉬우니, 글자는 나중에 게임이 직접 그린다. 모양만 참고)

## 타이틀 로고 + 메뉴 배경

**타이틀 로고** → `assets/ui/logo.png` (투명 배경, 가로로 긴 그림)
```
A game title logo that reads exactly "Guilty JSHS", aggressive heavy-metal style lettering,
sharp edges, metallic silver letters with crimson red outlines and sparks, slightly slanted,
transparent background, centered, no other text.
```
(글자가 틀리게 나오면 여러 번 다시 뽑거나, 글자 없는 장식만 만들고 글자는 게임이 쓴다)

**메뉴/타이틀 배경 일러스트** → `assets/ui/key_art.png` (1920×1080)
```
Key art for a 2D anime fighting game, 16:9. A chemistry-club student (white lab coat, glowing
green flask) and a computer-club hacker (black hoodie with cyan circuits, mechanical keyboard
like a guitar) clash in the center, green chemical energy colliding with cyan digital code,
sparks and smoke, Jeju island sea at sunset in the background. Leave the upper center area
fairly simple for a title logo. No text, no logo, no watermark.
[공통 스타일 문장]
```

---

## 배경 3장

배경 공통 조건: 캐릭터가 서 있을 **아래쪽 1/3은 평평한 바닥**으로 비워 두고, 가운데에 시선을 뺏는 큰 물체를 두지 않는다.

```
A side-view 2D fighting game stage background, 16:9, wide horizontal composition,
flat empty floor across the bottom third where two fighters will stand, no characters,
no text, no logo, no watermark.
[장소 설명]
[공통 스타일 문장]
```

**1) 화학 실험실 (lab.png)**
> A Korean science high school chemistry lab at night. Long black lab benches, glassware and flasks
> glowing toxic green, fume hoods, test tube racks, a large periodic-table-like poster on the wall
> (with no readable text), green chemical smoke drifting near the floor.

**2) 컴퓨터실 (computer.png)**
> A high school computer lab late at night. Rows of glowing monitors, server racks with blinking
> blue LEDs, tangled cables, cyan holographic code floating in the air, dark room lit mostly by screens.

**3) 옥상 - 제주 바다 (rooftop.png)**
> The rooftop of a high school on Jeju Island at sunset. Orange and purple sky, the ocean on the horizon,
> Hallasan mountain silhouette in the far distance, black volcanic basalt stone walls, a chain-link fence,
> strong wind blowing.

---

## 캐릭터 2명

캐릭터 공통 조건 (나중에 팔다리를 잘라서 움직이게 만들 것이라 중요):
- **전신**, **오른쪽을 보는** 격투 자세 (3/4 측면)
- **팔과 다리가 몸통에 겹치지 않게** 약간 벌린 자세
- **투명 배경** (안 되면 완전히 흰 배경 또는 초록 배경 `#00FF00`)

```
Full-body character design for a 2D fighting game, standing in a fighting stance facing right
(three-quarter side view), arms and legs slightly apart and not overlapping the torso,
whole body visible from head to feet, transparent background, no text, no logo, no watermark.
[캐릭터 설명]
[공통 스타일 문장]
```

**CHEMIKID (화학 동아리)**
> A mad-scientist high school student from the chemistry club. A white lab coat worn open over a
> black school uniform, safety goggles pushed up on the forehead, thick rubber gloves, a belt with
> glowing test tubes. Holding a glowing green flask in one hand. Confident grin. Color palette:
> toxic green, black, white, with a crimson red accent.

**COMMON (정보 동아리)**
> A hacker high school student from the computer club. An oversized black hoodie with glowing cyan
> circuit-board patterns, large headphones around the neck, fingerless gloves. Carries a mechanical
> keyboard slung over the shoulder like an electric guitar. Cyan holographic code swirling around the hands.
> Cool, sharp expression. Color palette: cyan, deep blue, black, with a crimson red accent.

### 같은 캐릭터를 계속 똑같이 나오게 하는 팁
1. 전신 일러스트를 **먼저 1장** 마음에 들 때까지 뽑는다.
2. 이후 다른 그림(컷인용 얼굴 클로즈업 등)은 그 그림을 **첨부**하고
   `Same character as the attached image, ...`로 시작해서 요청한다.
3. 두 캐릭터를 **같은 대화(채팅방)** 안에서 만들면 스타일이 더 비슷하게 나온다.

## 사용 전 확인할 것
- 쓰는 툴(ChatGPT / Gemini)의 **이용약관**에서 생성 이미지 사용 조건을 직접 확인하기.
- 넣은 그림은 Godot 에디터를 열면 자동으로 import 된다. 그림을 넣은 뒤 커밋해서 올리면 된다.
