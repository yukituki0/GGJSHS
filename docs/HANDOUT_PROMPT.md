# 관람객 안내자료 (인쇄용 게임 설명서) 프롬프트

정보동아리 다른 부스 안내자료(로봇팔 블록 코딩 / 사람이·AI가 조종하는 로봇팔 PDF)와 **같은 디자인**으로 맞춘다.
A4 세로 2장: 1장 = 게임 방법, 2장 = 캐릭터 & 콤보.

**첨부할 것:** 참고 PDF 1장(디자인 따라 하기용, 예: 로봇팔 블록 코딩), 학교 엠블럼 그림, (2장) 캐릭터 6명 얼굴 그림(`assets/characters/<id>_face.png`)

> AI는 한글을 틀리게 쓰는 일이 많다. 받으면 **글자 하나하나 확인**하고, 틀린 곳이 많으면
> "같은 디자인, 글자 칸은 비워 둬"로 다시 뽑은 뒤 PPT·캔바에서 글자만 직접 넣는 게 빠르다.

---

## 1장: 게임 방법

```
Make a printable A4 portrait (210 x 297 mm) visitor handout in EXACTLY the same design as the attached PDF: same layout system, colors, fonts and decorations.

DESIGN (copy from the attached PDF):
- Top header area looks like a sheet of lined notebook paper with a spiral binding edge.
- Top-left: a simple flat line icon (instead of the robot arm, draw an arcade joystick with 6 round buttons, same flat dark-gray style).
- Top-center title in two lines, bold Korean font, black: "길티 JSHS" / "격투 게임 설명서".
- Top-right: the attached school emblem, and under it small text "제주과학고등학교 정보동아리 COMMON".
- Body background: dark navy blue (#1f2a7a style) with a few large faint translucent circles.
- Each section: a light-cyan rounded pill header with dark navy bold text, and white rounded cards below.
- Number badges are small cyan circles with white numbers. Arrows between steps are light cyan chevrons.
- Two-column cards are connected by black ring-binder rings in the middle, like the attached PDF.
- Footer in small white text: left "Guilty JSHS | 관람객 안내자료", right "1/2".
- Clean, flat, lots of white space, no photos, no characters, no gradients except the subtle circles.

CONTENT (Korean text, write every character exactly as given):

Section 1 (full width) pill: "이렇게 이겨요"
 4 steps in a row with chevrons, each a cyan rounded box:
 "1단계 캐릭터 고르기" > "2단계 공격하고 막기" > "3단계 체력 0 만들기" > "4단계 2라운드 먼저 승리"
 Under it a small pill: "한 라운드 60초 · 시간이 끝나면 체력이 많은 쪽이 승리"

Section 2 (left column) pill: "버튼 이름"
 A row of 6 round arcade buttons labeled P, K, S, HS, D, RC, and a lever icon.
 List:
 "레버  ← → 걷기 · ↑ 점프 · ↓ 앉기 · →→ 대시"
 "P K S HS  기본 공격 (왼쪽은 빠르고 약하게, 오른쪽은 느리고 세게)"
 "D  필살기 (레버와 같이: D / →D / ↓D / ←D)"
 "D + HS  궁극기 (텐션 50%)"
 "RC  로만 캔슬 (공격 취소, 텐션 50%)"

Section 3 (right column) pill: "막기 (가드)"
 Two small diagrams side by side: a standing figure with "← 서서 막기" and "상단·중단을 막아요",
 a crouching figure with "↙ 앉아서 막기" and "상단·하단을 막아요".
 Below: "점프 공격·→K는 중단 → 서서 막기"
        "↓K·↓S는 하단 → 앉아서 막기"
        "잡기(붙어서 →/← + HS)는 못 막아요! 잡히는 순간 HS로 풀기"

Section 4 (left column) pill: "콤보"
 Big example in a card: "P > K > S > HS"
 Caption: "공격이 맞는 순간 더 센 버튼을 누르면 이어져요"
 Second example: "S > HS > D" with caption "마지막은 필살기(D)로!"

Section 5 (right column) pill: "게이지"
 Numbered list with cyan badges:
 1 "체력 (위)" - "0이 되면 그 라운드는 져요"
 2 "텐션 (아래)" - "앞으로 가고 공격하면 차요. 50%면 궁극기"
 3 "마력" - "필살기 한 번에 한 칸, 시간이 지나면 다시 차요"
 4 "버스트 B" - "맞는 중에 D + 공격 버튼 → 콤보 탈출"

Bottom card with a red "!" circle icon, title "처음이라면" and bullets:
 "• 모드 선택 → 게임 설명서 / 트레이닝부터 해 보세요"
 "• 막 누르기보다 먼저 막고, 상대가 헛치면 반격!"
 "• 일시정지(START) → 콤보표에 캐릭터별 쉬운 콤보가 있어요"
```

---

## 2장: 캐릭터 & 콤보

```
Second page of the same handout. Same A4 portrait design as page 1 and the attached PDF (notebook-paper header, school emblem top-right with "제주과학고등학교 정보동아리 COMMON", dark navy body with faint circles, light-cyan pill headers, white rounded cards, cyan number badges, ring-binder rings between columns).

Header title (two lines): "캐릭터 &" / "콤보 모음". Top-left icon: a small flat crossed-swords or "VS" icon in the same style.
Footer: left "Guilty JSHS | 관람객 안내자료", right "2/2".

Section pill (full width): "6명의 동아리 대표"
 A 2 x 3 grid of white cards. Each card has a round portrait slot on the left (use the attached face image for that character), the name in bold, the club in small text, one line of style, and one easy combo in a light-cyan rounded box.
 Write exactly:
 1. "CHEMIKID" / "화학 동아리" / "플라스크·불꽃 반응, 느리지만 한 방" / 콤보 "S > HS > ↓D"
 2. "COMMON" / "정보 동아리" / "패킷·버그 함정, 빠른 트릭" / 콤보 "↓K > S > HS > D"
 3. "GLOBE" / "지구과학 동아리" / "유성·돌진, 체력 최고 헤비급" / 콤보 "S > HS > →D"
 4. "CHAOS" / "물리 동아리" / "중력으로 끌어와 잡기" / 콤보 "S > HS > ↓D"
 5. "ROOT2" / "수학 동아리" / "컴퍼스·부메랑 원거리 견제" / 콤보 "S > HS > D"
 6. "SEED" / "생명 동아리" / "덩굴·분신·회복, 진화로 강화" / 콤보 "S > HS > →D"

Section pill (left column): "콤보 읽는 법"
 Small table:
 "↓K" - "앉아서 K"
 "→D" - "앞 + D"
 ">" - "앞 기술이 맞는 순간 다음 버튼"
 "↑" - "↓HS가 맞는 순간 점프 (공중 콤보)"

Section pill (right column): "모두 쓸 수 있는 콤보"
 Numbered list:
 1 "입문" - "P > K > S > HS"
 2 "띄우기" - "↓HS > ↑ > S > HS > D"
 3 "궁극기 마무리" - "콤보 끝에 D + HS (텐션 50%)"

Bottom wide card, two halves:
 left: "도전 과제" / "CPU 달인을 이겨 보세요!"
 right: "핵심 질문" / "막을까, 때릴까? 상대의 다음 수를 읽어 보세요"
```

---

### 메모
- 콤보는 게임 안에서 자동 테스트로 이어지는 걸 확인한 것만 넣었다 (`docs/COMBOS.md`).
- 글자를 바꾸려면 위 따옴표 안만 고치면 된다. 버튼 이름은 게임 화면과 같게 P K S HS D RC로.
