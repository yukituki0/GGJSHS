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
| HUD 부품 | `assets/ui/hud_*.png` | 아래 "1단계: HUD 부품" 참고 |

## 📋 게임 전체 그림 목록 (진행 상황)

| 구분 | 파일 | 개수 | 상태 |
|---|---|---|---|
| HUD | `assets/ui/hud_*.png` | 체력 틀/채움, 타이머, 텐션 1P/2P | ✅ 완료 |
| 스테이지 (**실제 학교 사진**) | `assets/stages/` `lab` `computer` `rooftop` `playground` `hallway` `.png` | 5 | ⬜ 사진 찍기 |
| 캐릭터 전신 (투명 배경) | `assets/characters/<id>.png` | 6 (남3 여3) | ⬜ 아래 "캐릭터 6명" |
| 타이틀 로고 | `assets/ui/logo.png` | 1 | ✅ 완료 |
| 메뉴 배경 일러스트 | `assets/ui/key_art.png` | 1 | ⬜ |
| 기술 이펙트 / 투사체 | 캐릭터 기술이 정해지면 목록 추가 | - | ⬜ 나중에 |

캐릭터 id: `chemikid`(화학) `common`(정보) `root2`(수학) `chaos`(물리) `seed`(생명) `globe`(지구과학)

### 학교 사진 찍을 때
- 가로로, 가능하면 16:9 / 아래쪽 1/3은 바닥이 보이게 / 정면·수평으로 / **사람이 안 나오게** / 조명 켜고
- 보내주면 1920×1080으로 자르고, HUD와 어울리게 색 보정(어둡게, 대비 강하게)까지 해서 넣는다

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

### ✅ 확정된 목업: `docs/reference/mockup.webp`
이후 그림은 전부 이 목업을 **첨부**하고 `Same art style as the attached image.`로 시작한다.

---

## 1단계: HUD 부품 (목업 첨부해서 하나씩)

목업에서 직접 잘라내면 뒤의 배경이 같이 잘려서, **부품만 따로** 다시 그려 달라고 하는 게 깔끔하다.
투명 배경이 안 되면 **완전한 초록색(#00FF00) 배경**으로 받아오기 → 초록색은 지워서 넣을 수 있다.

공통 앞부분:
```
Same art style as the attached image. Draw ONLY the following UI element, isolated,
centered, on a transparent background (or a flat pure green #00FF00 background),
no characters, no scenery, no text unless stated, no watermark.
```

| 파일 이름 | 요청 내용 |
|---|---|
| `hud_hp_frame.png` | The LEFT player's health bar frame from the image: the long slanted ornate metallic frame with the small portrait window at the left end. The bar and the portrait window must be EMPTY (hollow / transparent inside). |
| `hud_hp_fill.png` | Only the yellow-to-orange gritty health bar fill: a long slanted strip, no frame. |
| `hud_timer.png` | Only the gear-shaped round timer emblem with the red spikes, with an EMPTY center (no numbers). |
| `hud_tension_frame.png` | The LEFT player's "TENSION" gauge frame from the bottom of the image, with the word "TENSION", the bar inside EMPTY. |
| `hud_tension_fill.png` | Only the orange gauge fill strip, no frame. |

- 2P 쪽은 게임이 **좌우 반전**해서 쓰니까 1P(왼쪽)용만 있으면 된다.
- 체력바/텐션바 채움은 "바가 꽉 찬 상태" 그림 하나면 된다. 줄어드는 건 게임이 잘라서 보여준다.

## 2단계: 배경과 캐릭터 (목업 첨부)

- 실험실 배경: `Same scene as the attached image but with NO characters and NO HUD, empty lab, 16:9.`
- 캐릭터: `The left character (chemistry club) from the attached image, full body, ...` + 아래 "캐릭터 2명" 조건

---

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

## 캐릭터 6명 (목업 첨부)

### 성비와 선정성 기준
- **남 3 : 여 3**으로 고정한다 (선택형으로 하면 그림이 12장 + 컷아웃 작업도 2배라 축제 전에 어려움)
  - 남: CHEMIKID, COMMON, ROOT2 / 여: GLOBE, CHAOS, SEED
- 학교 축제용이니까 **모든 캐릭터에 아래 "안전 조건"을 꼭 붙인다.** 그래도 노출이 있거나 몸매를 강조한 그림이 나오면 버리고 다시 뽑는다.

**안전 조건 (모든 캐릭터 프롬프트에 붙이기)**
```
Age-appropriate high school student, fully clothed in a modest school uniform or club outfit,
long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands,
non-sexualized, natural body proportions, confident heroic pose, wholesome.
```

### 공통 조건 (나중에 팔다리를 잘라서 움직이게 만들 것이라 중요)
- **전신**, **오른쪽을 보는** 격투 자세 (3/4 측면)
- **팔과 다리가 몸통에 겹치지 않게** 약간 벌린 자세
- **투명 배경** (안 되면 완전한 초록 배경 `#00FF00` → 내가 지워서 넣는다)

```
Same art style as the attached image. Full-body character design for a 2D fighting game,
standing in a fighting stance facing right (three-quarter side view), arms and legs slightly apart
and not overlapping the torso, whole body visible from head to feet, transparent background,
no text, no logo, no watermark.
[캐릭터 설명]
[안전 조건]
[공통 스타일 문장]
```

### 캐릭터 설명 (기술 컨셉에 맞춤)

**🧪 CHEMIKID (화학, 남)** → `chemikid.png` · 목업 왼쪽 캐릭터를 첨부해서 같은 얼굴로
> A boy from the chemistry club, mad-scientist vibe. White lab coat worn over a black school uniform
> with a tie, safety goggles pushed up on his messy dark hair, thick rubber gloves, a belt with glowing
> test tubes. Holding a glowing green flask. Color palette: toxic green, white, black, crimson accent.

**💻 COMMON (정보, 남)** → `common.png` · 목업 오른쪽 캐릭터를 첨부해서 같은 얼굴로
> A boy from the computer club, cool hacker vibe. Oversized black hoodie with glowing cyan
> circuit-board lines, headphones around the neck, fingerless gloves, a mechanical keyboard slung
> over the shoulder like an electric guitar, cyan holographic code around his hands.
> Color palette: cyan, deep blue, black, crimson accent.

**🌍 GLOBE (지구과학, 여)** → `globe.png`
> A girl from the earth science club, strong and grounded heavyweight vibe. Sturdy field-researcher
> jacket with many pockets over a school uniform, long pants, hiking boots, a geologist's hammer on
> her belt, a small glowing globe floating above one hand, tiny star sparkles and a swirl of wind
> around her. Color palette: earthy orange, ocean blue, night-sky navy, crimson accent.

**🌀 CHAOS (물리, 여)** → `chaos.png`
> A girl from the physics club, calm but dangerous grappler vibe. Fitted lab jacket with rolled
> sleeves over a school uniform, long pants, sneakers, fingerless gloves crackling with small
> purple electric arcs, a tiny black-hole orb orbiting her, faint gravity distortion rings.
> Color palette: violet, electric yellow, black, crimson accent.

**📐 ROOT2 (수학, 남)** → `root2.png`
> A boy from the math club, sharp and precise long-range fighter vibe. Neat school blazer with a
> long scarf, round glasses, holding a large drafting compass like a spear, a giant golden √2 symbol
> spinning like a boomerang near him, floating golden formulas (∫, π, Σ) around him.
> Color palette: gold, white, navy, crimson accent.

**🌱 SEED (생명, 여)** → `seed.png`
> A girl from the biology club, gentle but tricky summoner vibe. Long cardigan over a school uniform
> with a knee-length skirt and leggings, a flower hairpin, a magnifying glass on a cord,
> green vines wrapping softly around her arms, a glowing pink DNA double helix floating beside her.
> Color palette: blossom pink, leaf green, white, crimson accent.

### 같은 캐릭터를 계속 똑같이 나오게 하는 팁
1. 전신 일러스트를 **먼저 1장** 마음에 들 때까지 뽑는다.
2. 다른 그림(컷인용 얼굴 등)은 그 그림을 **첨부**하고 `Same character as the attached image, ...`로 시작한다.
3. 6명을 **같은 대화(채팅방)** 안에서 만들면 스타일이 더 비슷하게 나온다.

## 사용 전 확인할 것
- 쓰는 툴(ChatGPT / Gemini)의 **이용약관**에서 생성 이미지 사용 조건을 직접 확인하기.
- 넣은 그림은 Godot 에디터를 열면 자동으로 import 된다. 그림을 넣은 뒤 커밋해서 올리면 된다.
