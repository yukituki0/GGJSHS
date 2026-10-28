# Guilty JSHS

**제주과학고등학교 동아리 최강자 결정전** — 길티기어 스타일의 2D 대전 격투 게임.
동아리를 대표하는 6명의 캐릭터가 1:1로 싸운다. 2026 학교 축제(10/31) 전시용으로 만들었다.

- 엔진: **Godot 4.7.2** (GDScript)
- 그림: 캐릭터·이펙트·배경은 AI(ChatGPT / Gemini)로 그린 뒤 `tools/`의 스크립트로 정리
- 2인 대전 / CPU 대전 / 트레이닝 / 캐릭터 설정집

---

## 실행하기

1. [Godot 4.7.2](https://godotengine.org/download)를 받는다 (표준 버전, .NET 아님).
2. Godot에서 **Import** → 이 폴더의 `project.godot`를 연다.
3. **F5** (또는 오른쪽 위 ▶)로 실행. 시작 화면은 `scenes/title.tscn`.

> 💡 `git pull` 하기 전에는 **Godot을 꺼 둔다.** 켜 둔 채로 받으면 Godot이 바뀐 파일을 예전 내용으로 다시 저장할 수 있다.

### 실행 파일(.exe)로 만들기
1. Godot에서 **Editor → Manage Export Templates** → 4.7.2 템플릿 다운로드 (한 번만).
2. **Project → Export → Add… → Windows Desktop** → 경로 예: `build/GuiltyJSHS.exe`.
3. **Export Project** → `GuiltyJSHS.exe` + `GuiltyJSHS.pck`가 생긴다. 두 파일을 같은 폴더에 두고 실행하면 Godot 없이 돌아간다.
   - "Embed PCK"(한 파일로 합치기)는 백신이 오진할 수 있어서 축제 PC에서는 두 파일로 두는 걸 추천.
4. 나눠 줄 때는 zip으로 묶어 GitHub **Releases**에 올린다 (저장소에는 실행 파일을 올리지 않는다).

---

## 조작

버튼은 길티기어처럼 **P · K · S · HS · D · RC** 6개. 대시·가드는 레버(키보드는 방향키)로 한다.

| | 1P 키보드 | 2P 키보드 |
|---|---|---|
| 이동 | W A S D | ← ↑ → ↓ |
| P / K / S | Y / U / I | 숫자패드 4 / 5 / 6 |
| D / RC / HS | H / J / K | 숫자패드 1 / 2 / 3 |
| START (일시정지) / SELECT (도발) | 1 / 2 | 0 / 9 |

| 입력 | 동작 |
|---|---|
| ← 누르고 있기 / ↙ | 서서 가드(상단·중단) / 앉아 가드(상단·하단) |
| →→ / ←← | 대시 / 백스텝 (공중에서는 공중 대시) |
| P → K → S → HS | 개틀링 콤보 (맞히거나 막히면 더 강한 버튼으로) |
| D, →D, ←D, ↓D, 공중D | 필살기 (마력 1칸 소모) |
| D + HS | 오버드라이브 (텐션 50%) |
| RC | 로만 캔슬 (텐션 50%) |
| →/← + HS (붙어서) | 잡기 |
| 맞는 중 D + 공격 버튼 | 버스트 (게이지 가득일 때) |
| SELECT / → + SELECT | 도발 (상대 텐션 +10%) / 리스펙트 |

- 키보드와 스틱은 **항상 같이 입력된다** (모드 전환 필요 없음). 안내 글자는 마지막에 누른 장치의 버튼 이름으로 저절로 바뀐다
- **F1**: 안내 글자 키보드 ↔ 스틱 이름 직접 전환 · **F4**: 성능 표시(FPS, 멈칫 횟수) · **F11**: 전체 화면 · **ESC**: 종료 확인
- **키 설정**: 모드 선택 → 조작법 → P. 1P/2P 버튼을 바꿀 수 있고 저장된다 (아케이드 스틱 버튼 번호도 여기서 맞춘다).
- 트레이닝: **F2** 판정 보기, ⚙ 설정에서 더미 동작 / 판정 보기 / 입력 기록. 1P·2P 어느 쪽 키로도 내 캐릭터를 움직일 수 있다.
- 안내 글자는 키보드 모드면 실제 키 이름(Y, U …)으로 바뀐다.

### 아케이드 스틱 (Zero Delay 인코더, 예: CY-822A)
1. 레버 5핀 케이블 → 보드 JOYSTICK 칸. 트레이닝 입력 기록으로 방향이 맞는지 확인 (반대면 커넥터를 뒤집거나 레버 기판을 돌린다).
2. 버튼 2핀 선 → 보드 버튼 칸, 반대쪽 단자 두 개 → 버튼의 **COM / NO** (NC 아님).
3. 1P 보드를 먼저, 2P 보드를 나중에 USB에 꽂는다 (먼저 꽂힌 쪽 = 1P).
4. 게임에서 조작법 → 키 설정 → 칸을 고르고 스틱 버튼을 눌러 하나씩 맞춘다.

추천 버튼 배치: 위 줄 `P K S`, 아래 줄 `D RC HS`.

---

## 시스템

| 시스템 | 내용 |
|---|---|
| 라운드 | 60초, 2선승제. 시간이 끝나면 체력이 많은 쪽 승리 |
| 텐션 | 앞으로 걷기·공격으로 차고, 오버드라이브와 로만 캔슬에 쓴다. 오버드라이브로 맞히면 조금만 찬다 |
| 마력 | D 필살기 한 번에 1칸(25). 약 11초면 다 찬다. 모자라면 필살기가 안 나간다 |
| 버스트 | 경기 시작 때 가득, 라운드가 바뀌어도 유지. 맞는 중에 써서 콤보에서 빠져나온다 |
| 가드 게이지 | 계속 막으면 차오르다가 가드 크러시 |
| 콤보 보정 | 3번째 기술부터 한 기술마다 데미지 ×0.9 (최소 ×0.5) |
| 카운터 | 상대가 기술을 내는 중에 때리면 데미지 +10%, 경직·멈춤 증가 |
| 2H | 대공. 맞으면 상대가 떠오르고, ↑로 점프 캔슬해서 공중 콤보 |
| 콤보 제한 | 공중에서 8대 넘게 맞으면 떨어질 때까지 무적, 6히트부터 경직이 점점 짧아짐 (무한 콤보 방지) |
| 데모 | 타이틀에서 20초 입력이 없으면 CPU끼리 대전 (축제용) |

---

## 캐릭터

| 캐릭터 | 동아리 | 체력 | 스타일 | 오버드라이브 |
|---|---|---|---|---|
| 🧪 CHEMIKID | 화학 | 440 | 플라스크·불꽃 반응·대공, 느리지만 한 방 | 테르밋 반응 |
| 💻 COMMON | 정보 | 410 | 패킷·버그 함정·Ctrl+Z, 빠른 트릭 | 블루스크린 |
| 🌍 GLOBE | 지구과학 | 470 | 유성·지진해일·아머 돌진, 헤비급 | 태풍 |
| 🌀 CHAOS | 물리 | 460 | 만유인력으로 끌어와 커맨드 잡기 | 블랙홀 |
| 📐 ROOT2 | 수학 | 400 | 컴퍼스 원거리 견제·부메랑·주사위 | 랜덤 증명 (Q.E.D.) |
| 🌱 SEED | 생명 | 420 | 씨앗·덩굴 채찍·분신·회복 | 진화 (6초 강화) |

기술 전체 목록은 [`docs/MOVES.md`](docs/MOVES.md), 콤보는 [`docs/COMBOS.md`](docs/COMBOS.md), 게임 안에서는 **일시정지 → 기술표** 또는 **캐릭터 설정집**.

---

## 폴더 구조

```
assets/
  characters/   캐릭터 그림 (<id>.png 기본, <id>_<자세>.png 자세별: punch, 2k, jh, 6d, taunt …)
  effects/      필살기 이펙트 그림 (<id>_<이름>.png)
  stages/       스테이지 배경
  ui/           HUD, 로고, 메뉴 배경, 글자 그림
  sound/        효과음·배경음
  fonts/        글꼴
scenes/         화면 (title, mode_select, char_select, stage_select, battle, controls, key_config, char_book)
scripts/
  fighter.gd        캐릭터 공통: 상태 머신, 입력, 가드, 콤보 보정, 판정, 자세 그림
  characters/*.gd   캐릭터별 필살기 (fighter.gd를 상속)
  attack_data.gd    기술 하나의 프레임/판정/데미지
  projectile.gd     투사체·설치물·이펙트
  match.gd          라운드 진행, 충돌 판정, 일시정지
  battle_hud.gd     체력·텐션·마력·버스트·콤보 카운터·컷인
  cpu_brain.gd      CPU (쉬움/보통/어려움/달인)
  input_manager.gd  키보드/조이스틱 배치, 키 설정
  rigs.gd           캐릭터별 그림 보정 (자세 크기, 발 위치, 판정 맞춤 예외)
  game.gd           전역 설정, 글자(한국어/영어), 캐릭터·기술 목록
  screens/          메뉴 화면들
tools/          그림 정리 스크립트 (Python + Pillow)
docs/           기술표, 그림 가이드, 프롬프트 모음, 베타 테스트 체크리스트
```

---

## 그림 넣기

1. [`docs/PROMPTS.md`](docs/PROMPTS.md)에서 프롬프트를 복사해 AI로 그린다 (✅ = 이미 들어간 그림, ⬜ = 아직 없음). 규칙은 [`docs/ART_GUIDE.md`](docs/ART_GUIDE.md).
2. 투명 배경 PNG/WebP로 받는다.
3. 자세 그림은 크기를 맞춰서 넣는다:
   ```bash
   python tools/add_pose.py <캐릭터id> <자세>=<그림파일>[@키비율] ...
   # 예) python tools/add_pose.py seed taunt=a.webp respect=b.webp
   ```
4. 게임에서 머리 크기가 다르게 보이면 `scripts/rigs.gd`의 `pose_size`, 발 위치가 어긋나면 `pose_anchor`를 고친다.
5. 공격 판정은 그림의 손발 끝에 자동으로 맞춰진다 (트레이닝 F2로 확인). 프레임도 리치에 따라 조금씩 자동 조정된다.
6. 그림을 넣은 뒤 `python tools/make_prompts.py`를 돌리면 PROMPTS.md의 ✅/⬜가 갱신된다.

---

## 음악 출처

메뉴는 `bgm_menu`, 대전은 `bgm_battle1~3` 중 하나를 경기마다 무작위로 튼다 (`assets/sound/`, 음량은 -16 LUFS로 맞춤).

| 파일 | 곡 | 만든 사람 | 라이선스 |
|---|---|---|---|
| `bgm_menu.ogg` | neorock83 | [魔王魂 (maou.audio)](https://maou.audio/) | 魔王魂 이용 규약 (출처 "魔王魂" 표기) |
| `bgm_battle1.ogg` | [Fight Theme (Metal)](https://opengameart.org/content/fight-theme-metal) | Fato_Shadow | CC-BY 3.0 |
| `bgm_battle2.ogg` | [JRPG Epic Rock Battle Theme #1](https://opengameart.org/content/jrpg-epic-rock-battle-theme-1) (loop) | HydroGene | CC0 |
| `bgm_battle3.ogg` | [Red Engines Blue Wings & boss_battle_06_alternate](https://opengameart.org/node/167341) | Alexandr Zhelanov, nene | CC-BY 4.0 |

효과음은 `tools/make_sfx.py`로 직접 합성했다.

---

## 문서

| 문서 | 내용 |
|---|---|
| [`docs/MOVES.md`](docs/MOVES.md) | 캐릭터별 기술표 |
| [`docs/COMBOS.md`](docs/COMBOS.md) | 캐릭터별 콤보 (테스트로 확인한 것만) |
| [`docs/PROMPTS.md`](docs/PROMPTS.md) | 그림 프롬프트 모음 (자동 생성) |
| [`docs/ART_GUIDE.md`](docs/ART_GUIDE.md) | 그림 파일 이름·크기 규칙 |
| [`docs/BETA_TEST.md`](docs/BETA_TEST.md) | 축제 전 베타 테스트 체크리스트 |
