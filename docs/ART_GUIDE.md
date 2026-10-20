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
| 캐릭터 전신 (투명 배경) | `assets/characters/<id>.png` | 6 (남3 여3) | ✅ 6/6 |
| 캐릭터 자세 그림 | `assets/characters/<id>_<자세>.png` | 6 x 6 | ⬜ 아래 "캐릭터별 자세 프롬프트" |
| 타이틀 로고 | `assets/ui/logo.png` | 1 | ✅ 완료 |
| 메뉴 배경 일러스트 | `assets/ui/key_art.png` | 1 | ✅ v2 완료 |
| 메뉴/씬 배경 | `assets/ui/bg_*.png` | 7 | 🔄 6/7 (대기 화면 남음) |
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

**메뉴/타이틀 배경 일러스트 v2** → `assets/ui/key_art.png` (1920×1080)

v1은 두 사람이 가운데에서 부딪혀서 풍경이 거의 안 보였다. v2는 **두 사람을 양쪽 끝으로** 밀고 가운데를 풍경으로 비운다.
(게임은 이 그림을 1.01~1.05배로 천천히 확대/축소하므로 **가장자리 5%에는 중요한 것을 두지 않는다**)
```
Wide key art for a 2D anime fighting game, 16:9 landscape.
Composition: two rival students stand at the FAR LEFT and FAR RIGHT edges of the image,
each taking up only about 20% of the width, cropped from the knees up, facing toward the center.
Left: a chemistry-club student (white lab coat, glowing green flask).
Right: a computer-club student (black hoodie with cyan circuit lines, mechanical keyboard).
The wide CENTER 60% is open scenery: the rooftop of a Korean science high school overlooking
the Jeju island sea at sunset, Hallasan mountain silhouette on the horizon, basalt stone walls,
warm orange sky with drifting clouds. A thin line of green and cyan energy streams from each
character toward the center and meets far away above the sea.
Keep the upper center sky empty and simple for a title logo, and keep the lower center calm
for menu text. Keep important details away from the outer 5% border.
No text, no logo, no watermark.
[공통 스타일 문장] [부드럽게 문장]
```

### "너무 날카로워 보일 때" 부드럽게 문장 (캐릭터가 나오는 모든 프롬프트에 선택으로 붙이기)
학생 축제용이라 길티기어 느낌(굵은 선, 셀 음영, 빨강/검정)은 유지하되, **얼굴과 실루엣만 둥글게** 만드는 문장이다.
둥근 모양은 친근하게, 뾰족한 모양은 공격적으로 보인다는 형태 언어 원리를 이용한다.
```
Friendly, confident teenage students, not villains. Softer facial features: rounded cheeks,
gentle jawline, bright eyes, an excited grin or a determined smile instead of a glare.
Hair with soft volume and rounded clumps, not spiky blades. Clean smooth line art,
fewer sharp spikes and jagged edges on clothes and effects. Keep thick outlines and cel shading.
Avoid: menacing glare, sharp angular face, spiky hair tips, harsh jagged lines.
```

---

## 메뉴 / 씬 배경 (전부 1920×1080 PNG)

`assets/ui/bg_<이름>.png`로 넣으면 그 화면 배경이 자동으로 그림으로 바뀐다.
게임이 위에 **35% 검은 막 + 빨간 사선 무늬 + 메뉴 글자**를 얹으므로, 배경은 **복잡하지 않고 조금 어두워도 된다**.
모든 씬 배경 공통 문장 (각 프롬프트 끝에 붙이기):
```
Background only, no characters in the foreground unless described. 16:9, 1920x1080.
Slightly dark and low-detail so white menu text stays readable. No text, no logo, no UI, no watermark.
[공통 스타일 문장]
```

| 화면 | 파일 | 위에 올라가는 것 | 코드 연결 |
|---|---|---|---|
| 모드 선택 | `bg_mode_select.png` | 가운데 메뉴 목록, 아래 설명 띠 | ✅ |
| 캐릭터 선택 | `bg_char_select.png` | 왼쪽·오른쪽 큰 캐릭터 칸, 가운데 카드 6장 | ✅ |
| 스테이지 선택 | `bg_stage_select.png` | 가운데 스테이지 미리보기 | ✅ |
| 조작법 | `bg_controls.png` | 표가 화면 대부분 | ✅ |
| VS 화면 | `bg_vs.png` | 양쪽 캐릭터 + 가운데 VS | ✅ |
| 승리/결과 | `bg_result.png` | 이긴 캐릭터 + 글자 | ✅ |
| 대기 화면 (아무도 안 할 때) | `bg_standby.png` | INSERT COIN 같은 글자 | ⬜ 그림 오면 연결 |

**모드 선택** → `bg_mode_select.png`
```
A dim science high school corridor at night lit by red emergency light, lockers and
club posters on the walls blurred out of focus, strong perspective lines toward the center,
subtle red diagonal light streaks. Center area plain and dark for a vertical menu list.
```

**캐릭터 선택** → `bg_char_select.png`
```
An empty arena-like school gymnasium at night, two spotlights: a crimson spotlight on the
left third and a blue spotlight on the right third, both on empty floor, a dark center area
with faint hexagonal science-lab tile pattern. Symmetrical composition.
```
(왼쪽=1P 빨강, 오른쪽=2P 파랑 칸과 색을 맞춘 것)

**스테이지 선택** → `bg_stage_select.png`
```
A top-down stylized map of a science high school campus on Jeju island at dusk, buildings,
playground, rooftop, and the sea drawn in flat dark navy and crimson tones like a tactical map,
thin glowing red route lines, very low detail in the center.
```

**조작법** → `bg_controls.png`
```
A dark blueprint-style background: faint white technical drawings of an arcade joystick and
buttons, grid lines, chemistry and circuit diagrams in the margins, mostly dark navy and black,
very low contrast so a table of text can sit on top.
```

**VS 화면** → `bg_vs.png`
```
A dramatic split background for a fighting game versus screen: left half crimson red, right half
deep blue, divided by a jagged diagonal lightning crack through the center, sparks, smoke and
speed lines. No characters.
```

**승리/결과** → `bg_result.png`
```
A school rooftop at sunset after a battle, confetti and floating sparks, scattered science
papers drifting in the wind, warm golden light from the right, dark empty left half for a
winner character pose.
```

**대기 화면 (데모 / 아무도 안 할 때)** → `bg_standby.png`
축제 부스에서 지나가는 사람 시선을 끄는 그림. 캐릭터 6명이 다 나온다 (부드럽게 문장 추천).
```
A group key art of six science-club students as an anime fighting game cast, standing in a wide
line across the image, all full-body and the same height scale: chemistry (white lab coat,
green flask), computer (black hoodie, cyan circuits), math (geometric compass, golden ratio
spiral), physics (magnetic field lines, pendulum), biology (plants and vines, DNA motif),
earth science (stars, ocean waves and weather icons). Behind them a huge Jeju sea sunset.
Lower 25% darker for blinking text.
[부드럽게 문장]
```
(캐릭터 6명 그림이 확정된 다음 그 그림들을 **첨부해서** 만들면 얼굴이 맞는다)

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

**머리색으로 구분하기** (작은 초상화에서도 누군지 바로 보이게)
| 캐릭터 | 머리색 | 상태 |
|---|---|---|
| CHEMIKID | 검정 (부스스) | ✅ 완료 |
| COMMON | 검정 (후드) | ✅ 완료 |
| CHAOS | 검보라 긴 머리 | ✅ 완료 |
| ROOT2 | **금발** | ✅ 완료 |
| SEED | **연두** | ✅ 완료 |
| GLOBE | **주황** | ✅ 완료 |

- 완성된 그림을 첨부해서 화풍을 맞추면 **머리색까지 따라 검정으로 나오기 쉽다** → 프롬프트에 `(NOT black hair)`를 넣었다. 그래도 검정이면 "Change only the hair color to ..."로 다시 요청.
- 흰 실험 가운은 이미 2명(CHEMIKID, CHAOS)이 입고 있으니 남은 3명에게는 **가운을 입히지 않는다**.

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
> A girl from the earth science club, strong and grounded heavyweight vibe. Bright orange hair
> in a high ponytail (NOT black hair). Sturdy field-researcher
> jacket with many pockets over a school uniform, long pants, hiking boots, a geologist's hammer on
> her belt, a small glowing globe floating above one hand, tiny star sparkles and a swirl of wind
> around her. Color palette: earthy orange, ocean blue, night-sky navy, crimson accent.

**🌀 CHAOS (물리, 여)** → `chaos.png`
> A girl from the physics club, calm but dangerous grappler vibe. Fitted lab jacket with rolled
> sleeves over a school uniform, long pants, sneakers, fingerless gloves crackling with small
> purple electric arcs, a tiny black-hole orb orbiting her, faint gravity distortion rings.
> Color palette: violet, electric yellow, black, crimson accent.

**📐 ROOT2 (수학, 남)** → `root2.png`
> A boy from the math club, sharp and precise long-range fighter vibe. Neat short blond hair
> (NOT black hair). Neat school blazer with a
> long scarf, round glasses, holding a large drafting compass like a spear, a giant golden √2 symbol
> spinning like a boomerang near him, floating golden formulas (∫, π, Σ) around him.
> Color palette: gold, white, navy, crimson accent.

**🌱 SEED (생명, 여)** → `seed.png`
> A girl from the biology club, gentle but tricky summoner vibe. Soft lime-green hair in a
> side braid (NOT black hair). Long cardigan over a school uniform
> with a knee-length skirt and leggings, a flower hairpin, a magnifying glass on a cord,
> green vines wrapping softly around her arms, a glowing pink DNA double helix floating beside her.
> Color palette: blossom pink, leaf green, white, crimson accent.

### 자세별 그림 (있으면 게임이 그 상태에서 바꿔 끼운다)
그림 1장을 크게 구부리면 옷과 이펙트가 늘어나서 깨진다. 그래서 대전 중 움직임은 "작게"(숨쉬기, 기울이기)만 하고,
아래 자세 그림이 있으면 그 상태에서 그림을 통째로 바꾼다. **없는 자세는 기본 그림으로 나오니까 하나씩 늘려가면 된다.**

| 파일 | 언제 | 자세 설명 (프롬프트에 넣을 것) |
|---|---|---|
| `<id>_punch.png` | P/S/HS/필살기 공격 | `throwing a strong straight punch / striking forward with the front arm fully extended` |
| `<id>_kick.png` | K 공격 | `high kick with the front leg extended forward at waist height` |
| `<id>_guard.png` | 가드 | `defensive guard stance, both forearms raised in front of the face, knees bent` |
| `<id>_hit.png` | 맞았을 때, KO | `getting hit, recoiling backward, head and upper body thrown back, pained expression` |
| `<id>_crouch.png` | 앉기 | `low crouching stance, one knee bent deeply, ready to spring` |
| `<id>_jump.png` | 점프 | `mid-air jump, knees tucked up, arms out for balance` |

(`<id>` = chemikid, common, chaos, root2, seed, globe)

**자세 그림 프롬프트** (기본 전신 그림을 꼭 **첨부**)
```
Same character, same outfit, same art style and same proportions as the attached image.
Full body, facing right (three-quarter side view), whole body visible from head to feet,
plain transparent background, no effects, no glowing particles, no holograms, no energy orbs,
no motion lines, no text.
Pose: [위 표의 자세 설명]
[안전 조건]
```
- **이펙트(블랙홀, 홀로그램, 연기 등)는 빼고** 받는다. 이펙트는 게임 코드가 그린다. (그림에 이펙트가 박혀 있으면 움직일 때 같이 늘어나서 깨짐)
- 손에 드는 물건(플라스크, 키보드 등)은 있어도 된다.
- 크기: 기본 그림과 비슷한 크기(세로로 긴 그림, 캐릭터가 화면을 꽉 채우게)로 받으면 게임에서 같은 크기로 나온다.
- 추천 순서: punch → guard → hit (제일 자주 보이는 것부터)

### 포즈 시트: 자세 여러 개를 한 장으로 (추천)
게임 회사에서 캐릭터를 여러 사람이 그릴 때 쓰는 **모델 시트(포즈 시트)** 방식이다. 한 장에 같이 그리면 얼굴/옷/크기가 서로 맞게 나온다.
6자세를 한 장에 넣으면 자세 하나가 너무 작아져서(흐려짐) **3자세씩 2장**으로 나눈다. 받아서 넣어 주면 자세별로 잘라서 넣는 건 내가 한다.

| 시트 | 자세 (왼쪽부터) | 저장 이름 (아무거나 OK) |
|---|---|---|
| 공격 시트 | punch, kick, jump | `<id>_sheet_attack.png` |
| 방어 시트 | guard, hit, crouch | `<id>_sheet_defense.png` |

**공격 시트 프롬프트** (기본 전신 그림 **첨부**, 가로 3:2 비율로)
```
Character pose sheet (model sheet) for a 2D fighting game.
Same character as the attached image: same face, hair, outfit, colors and body proportions.
Three full-body poses in one horizontal row, left to right:
1) [이 캐릭터의 punch 문장]
2) [이 캐릭터의 kick 문장]
3) [이 캐릭터의 jump 문장]
All three poses facing right (three-quarter side view), drawn at exactly the same scale,
feet of poses 1 and 2 on the same invisible ground line, whole body visible from head to feet,
wide empty space between poses so they never touch or overlap.
Plain solid pure white background, no effects, no glowing particles, no energy, no motion lines,
no ground shadow, no text, no labels, no numbers, no borders, no panels.
[안전 조건]
[공통 스타일 문장]
```
**방어 시트 프롬프트**: 위와 같고 1) 2) 3)만 `guard` / `hit` / `crouch` 문장으로 바꾼다.

- `[이 캐릭터의 ... 문장]`은 아래 "캐릭터별 자세 프롬프트"에서 `Pose:` 뒤의 문장을 그대로 넣는다.
- 자세끼리 붙어 나오거나 글자/번호가 들어가면 버리고 다시 뽑는다 (자동으로 자를 때 문제가 됨).
- 이펙트 없는 기본 그림부터 먼저 만들고, 그 그림을 첨부해서 시트를 뽑는다:
  `Same image, but remove all effects (glow, particles, holograms, energy, floating objects). Keep the character exactly the same, transparent background.`

### 캐릭터별 자세 프롬프트 (그대로 복사해서 쓰기)
위 "자세 그림 프롬프트"의 `Pose:` 자리에 아래 문장을 넣는다. **그 캐릭터의 기본 전신 그림을 꼭 첨부.**
한 대화창에서 한 캐릭터씩 punch → guard → hit → kick → crouch → jump 순서로 뽑으면 얼굴이 잘 유지된다.

**🧪 CHEMIKID** (손에 플라스크는 들고 있어도 됨, 연기/빛은 없이)
- punch: `Pose: lunging forward and splashing the flask forward with the front arm fully extended, coat flaring behind.`
- kick: `Pose: front snap kick at waist height, front leg extended forward, holding the flask back for balance.`
- guard: `Pose: defensive stance, both gloved forearms crossed in front of the face, knees bent, flask tucked to the chest.`
- hit: `Pose: knocked back by a hit, upper body and head thrown backward, goggles askew, pained expression, arms flung out.`
- crouch: `Pose: low crouch with one knee deeply bent, the other leg stretched back, flask held low, ready to spring.`
- jump: `Pose: mid-air jump, knees tucked up, coat billowing, flask raised overhead.`

**💻 COMMON** (키보드는 들고 있어도 됨, 홀로그램/코드 빛은 없이)
- punch: `Pose: swinging the mechanical keyboard forward horizontally with both hands like a guitar smash, full extension.`
- kick: `Pose: sneaker kick at waist height, front leg extended forward, keyboard held over the shoulder.`
- guard: `Pose: holding the mechanical keyboard vertically in front of the body as a shield, knees bent.`
- hit: `Pose: knocked back by a hit, headphones flying off the neck, hood flapping, upper body thrown backward.`
- crouch: `Pose: low crouch with the keyboard held flat across the knees, hood up, ready to spring.`
- jump: `Pose: mid-air jump, knees tucked up, keyboard raised overhead with both hands.`

**🌀 CHAOS** (블랙홀/번개 없이, 빈손)
- punch: `Pose: palm strike thrust forward with the front arm fully extended, long hair streaming back, coat flaring.`
- kick: `Pose: spinning back kick at waist height, front leg extended, long hair whipping around.`
- guard: `Pose: defensive stance, one open palm raised forward and the other arm across the chest, knees bent.`
- hit: `Pose: knocked back by a hit, long hair flying forward, upper body thrown backward, eyes squeezed shut.`
- crouch: `Pose: low crouch with one hand touching the ground, coat spread on the floor, looking forward.`
- jump: `Pose: mid-air jump, knees tucked up, coat and long hair floating upward.`

**🌍 GLOBE** (지구본/돌/바람 없이, 빈손. 지질 망치는 허리에 그대로)
- punch: `Pose: heavy hook punch with the front fist fully extended, whole body leaning into the blow, ponytail swinging.`
- kick: `Pose: powerful stomp kick at waist height with a hiking boot, front leg extended forward.`
- guard: `Pose: sturdy defensive stance, both fists raised in front of the face like a boxer, wide stance, knees bent.`
- hit: `Pose: knocked back by a hit, ponytail flying, upper body thrown backward, gritting teeth.`
- crouch: `Pose: low wide crouch with one fist planted on the ground like a sprinter, ready to charge.`
- jump: `Pose: mid-air jump, knees tucked up, both fists raised overhead ready to smash down.`

**📐 ROOT2** (큰 컴퍼스는 들고 있어도 됨, 금색 수식/√2 빛은 없이)
- punch: `Pose: thrusting the giant drafting compass forward like a spear, front arm fully extended, scarf streaming back.`
- kick: `Pose: precise side kick at waist height, front leg extended, compass held behind.`
- guard: `Pose: holding the giant compass diagonally in front of the body with both hands to block, knees bent.`
- hit: `Pose: knocked back by a hit, glasses slipping, scarf flying, upper body thrown backward.`
- crouch: `Pose: low crouch with the compass planted on the ground like a staff, one knee down.`
- jump: `Pose: mid-air jump, knees tucked up, compass raised overhead with both hands.`

**🌱 SEED** (DNA/덩굴/꽃잎 빛은 없이, 빈손. 돋보기 목걸이는 그대로)
- punch: `Pose: open palm push thrust forward with the front arm fully extended, braid swinging, cardigan flaring.`
- kick: `Pose: light front kick at waist height with a loafer, front leg extended, skirt kept modest.`
- guard: `Pose: defensive stance, both forearms raised in front of the face, knees bent, braid over the shoulder.`
- hit: `Pose: knocked back by a hit, braid flying, upper body thrown backward, eyes squeezed shut.`
- crouch: `Pose: low crouch with knees together and one hand touching the ground, skirt kept modest.`
- jump: `Pose: mid-air jump, knees tucked up, cardigan sleeves floating, skirt kept modest.`

- 여자 캐릭터 킥/점프/앉기는 위 문장에 `skirt kept modest`/안전 조건이 들어가 있다. 이상한 각도로 나오면 버리고 다시 뽑기.
- 처음 3명(CHEMIKID, COMMON, CHAOS)도 나중에 **이펙트 없는 기본 그림**으로 다시 뽑으면 좋다: 기본 그림을 첨부하고 `Same image, but remove all effects (glow, particles, holograms, energy). Keep the character exactly the same.`

### 같은 캐릭터를 계속 똑같이 나오게 하는 팁
1. 전신 일러스트를 **먼저 1장** 마음에 들 때까지 뽑는다.
2. 다른 그림(컷인용 얼굴 등)은 그 그림을 **첨부**하고 `Same character as the attached image, ...`로 시작한다.
3. 6명을 **같은 대화(채팅방)** 안에서 만들면 스타일이 더 비슷하게 나온다.

## 사용 전 확인할 것
- 쓰는 툴(ChatGPT / Gemini)의 **이용약관**에서 생성 이미지 사용 조건을 직접 확인하기.
- 넣은 그림은 Godot 에디터를 열면 자동으로 import 된다. 그림을 넣은 뒤 커밋해서 올리면 된다.
