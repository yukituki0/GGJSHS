# 완성 프롬프트 모음 (복사해서 바로 붙여넣기)

> 이 파일은 `python tools/make_prompts.py`로 자동 생성됨. 문장을 고치려면 그 스크립트를 고친다.
> **모든 프롬프트에 그 캐릭터의 이펙트 없는 전신 그림을 첨부**한다. 받은 그림은 파일 이름을 알려주며 보내면 된다.
> ✅ = 이미 게임에 들어간 그림, ⬜ = 아직 없음 (그림을 넣고 스크립트를 다시 돌리면 갱신됨)

## 현황

| 캐릭터 | 기본 전신·자세 6·상반신·얼굴·컷인 | 걷기 시트 | 뒤로 걷기 | 달리기 / 대시 | 백대시 | 쓰러짐 (KO) | 잡기 | 앉아서 가드 | 점프 공격 | 공중 대시 | 필살기·승리 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 🧪 CHEMIKID | ✅ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ✅ | ✅ | 0/7 |
| 💻 COMMON | ✅ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | 0/7 |
| 🌀 CHAOS | ✅ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ✅ | ✅ | ✅ | ✅ | 0/7 |
| 🌍 GLOBE | ✅ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | 0/7 |
| 📐 ROOT2 | ✅ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | 2/7 |
| 🌱 SEED | ✅ | ✅ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | 0/7 |

이펙트: 0/24

## 0-1. 무기 공격 S / HS (한 장씩)

> 길티기어처럼 S·HS는 무기 공격. 없으면 HS → S → 펀치 그림을 대신 쓴다

✅ **S 컴퍼스 찌르기** → `root2_slash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: thrusting the giant compass forward with both hands at chest height, front foot forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **HS 컴퍼스 크게 휘두르기** → `root2_heavy`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: big horizontal sweeping slash toward the opponent: gripping the end of the giant compass handle with both hands, arms fully extended forward, the compass swung horizontally at chest height with its points reaching far ahead, the compass held level (not pointing down at the ground), deep wide lunge with the front knee bent, upper body leaning forward, head and eyes facing forward toward the right, scarf and coat flaring behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **S 플라스크 휘두르기** → `chemikid_slash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: quick horizontal swipe with the flask hand at chest height, flask swung forward, other hand on the belt, front foot forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **HS 플라스크 내려치기** → `chemikid_heavy`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: heavy overhead smash, the flask arm swung down in a big arc and fully extended forward and down, deep lunge, lab coat flaring behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **S 키보드 휘두르기** → `common_slash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: quick horizontal swing of the mechanical keyboard held in both hands like a bat at chest height, front foot forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **HS 키보드 내려찍기** → `common_heavy`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: heavy slam, the mechanical keyboard brought down hard in front of the body with both hands at waist height, deep lunge, body leaning forward, jacket flaring. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

## 1. 걷기 시트 (4프레임, 한 장)

### ✅ 🧪 CHEMIKID → `chemikid_walk` ~ `chemikid_walk4`
```
Character pose sheet for a 2D fighting game walk cycle, 4 frames in one horizontal row, left to right. Same character as the attached image: same face, hair, outfit, colors and body proportions, holding his glowing green flask. The character keeps the same guarded fighting stance in every frame (upper body almost still, knees slightly bent) and only the legs change, taking short shuffling steps forward: 1) front foot lifted slightly and moving forward, 2) front foot planted, feet wide apart, 3) back foot lifted slightly and sliding forward, 4) back foot planted, feet close together. All frames facing right, same scale, feet on the same ground line, wide space between frames, no overlap. Transparent background (real alpha channel, not a checkerboard pattern), no effects, no motion lines, no text, no numbers. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### ✅ 💻 COMMON → `common_walk` ~ `common_walk4`
```
Character pose sheet for a 2D fighting game walk cycle, 4 frames in one horizontal row, left to right. Same character as the attached image: same face, hair, outfit, colors and body proportions, holding his mechanical keyboard. The character keeps the same guarded fighting stance in every frame (upper body almost still, knees slightly bent) and only the legs change, taking short shuffling steps forward: 1) front foot lifted slightly and moving forward, 2) front foot planted, feet wide apart, 3) back foot lifted slightly and sliding forward, 4) back foot planted, feet close together. All frames facing right, same scale, feet on the same ground line, wide space between frames, no overlap. Transparent background (real alpha channel, not a checkerboard pattern), no effects, no motion lines, no text, no numbers. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### ✅ 🌀 CHAOS → `chaos_walk` ~ `chaos_walk4`
```
Character pose sheet for a 2D fighting game walk cycle, 4 frames in one horizontal row, left to right. Same character as the attached image: same face, hair, outfit, colors and body proportions, empty-handed. The character keeps the same guarded fighting stance in every frame (upper body almost still, knees slightly bent) and only the legs change, taking short shuffling steps forward: 1) front foot lifted slightly and moving forward, 2) front foot planted, feet wide apart, 3) back foot lifted slightly and sliding forward, 4) back foot planted, feet close together. All frames facing right, same scale, feet on the same ground line, wide space between frames, no overlap. Transparent background (real alpha channel, not a checkerboard pattern), no effects, no motion lines, no text, no numbers. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### ✅ 🌍 GLOBE → `globe_walk` ~ `globe_walk4`
```
Character pose sheet for a 2D fighting game walk cycle, 4 frames in one horizontal row, left to right. Same character as the attached image: same face, hair, outfit, colors and body proportions, empty-handed, geologist hammer on the belt. The character keeps the same guarded fighting stance in every frame (upper body almost still, knees slightly bent) and only the legs change, taking short shuffling steps forward: 1) front foot lifted slightly and moving forward, 2) front foot planted, feet wide apart, 3) back foot lifted slightly and sliding forward, 4) back foot planted, feet close together. All frames facing right, same scale, feet on the same ground line, wide space between frames, no overlap. Transparent background (real alpha channel, not a checkerboard pattern), no effects, no motion lines, no text, no numbers. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### ✅ 📐 ROOT2 → `root2_walk` ~ `root2_walk4`
```
Character pose sheet for a 2D fighting game walk cycle, 4 frames in one horizontal row, left to right. Same character as the attached image: same face, hair, outfit, colors and body proportions, holding his giant drafting compass. The character keeps the same guarded fighting stance in every frame (upper body almost still, knees slightly bent) and only the legs change, taking short shuffling steps forward: 1) front foot lifted slightly and moving forward, 2) front foot planted, feet wide apart, 3) back foot lifted slightly and sliding forward, 4) back foot planted, feet close together. All frames facing right, same scale, feet on the same ground line, wide space between frames, no overlap. Transparent background (real alpha channel, not a checkerboard pattern), no effects, no motion lines, no text, no numbers. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### ✅ 🌱 SEED → `seed_walk` ~ `seed_walk4`
```
Character pose sheet for a 2D fighting game walk cycle, 4 frames in one horizontal row, left to right. Same character as the attached image: same face, hair, outfit, colors and body proportions, empty-handed, magnifying glass pendant. The character keeps the same guarded fighting stance in every frame (upper body almost still, knees slightly bent) and only the legs change, taking short shuffling steps forward: 1) front foot lifted slightly and moving forward, 2) front foot planted, feet wide apart, 3) back foot lifted slightly and sliding forward, 4) back foot planted, feet close together. All frames facing right, same scale, feet on the same ground line, wide space between frames, no overlap. Transparent background (real alpha channel, not a checkerboard pattern), no effects, no motion lines, no text, no numbers. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

## 2. 연결 자세 (한 장씩)

### 🧪 CHEMIKID

⬜ **뒤로 걷기** → `chemikid_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **달리기 / 대시** → `chemikid_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **백대시** → `chemikid_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **쓰러짐 (KO)** → `chemikid_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **잡기** → `chemikid_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: grabbing the opponent's collar with both hands and throwing forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아서 가드** → `chemikid_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **점프 공격** → `chemikid_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 대시** → `chemikid_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 💻 COMMON

⬜ **뒤로 걷기** → `common_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **달리기 / 대시** → `common_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **백대시** → `common_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **쓰러짐 (KO)** → `common_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **잡기** → `common_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: grabbing the opponent's collar with both hands and throwing forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **앉아서 가드** → `common_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **점프 공격** → `common_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중 대시** → `common_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌀 CHAOS

⬜ **뒤로 걷기** → `chaos_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **달리기 / 대시** → `chaos_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **백대시** → `chaos_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **쓰러짐 (KO)** → `chaos_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **잡기** → `chaos_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: grabbing the opponent's collar with both hands and throwing forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아서 가드** → `chaos_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **점프 공격** → `chaos_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 대시** → `chaos_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌍 GLOBE

⬜ **뒤로 걷기** → `globe_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **달리기 / 대시** → `globe_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **백대시** → `globe_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **쓰러짐 (KO)** → `globe_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **잡기** → `globe_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: grabbing the opponent's collar with both hands and throwing forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **앉아서 가드** → `globe_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **점프 공격** → `globe_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중 대시** → `globe_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 📐 ROOT2

⬜ **뒤로 걷기** → `root2_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **달리기 / 대시** → `root2_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **백대시** → `root2_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **쓰러짐 (KO)** → `root2_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **잡기** → `root2_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: grabbing the opponent's collar with both hands and throwing forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **앉아서 가드** → `root2_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **점프 공격** → `root2_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중 대시** → `root2_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌱 SEED

⬜ **뒤로 걷기** → `seed_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **달리기 / 대시** → `seed_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **백대시** → `seed_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **쓰러짐 (KO)** → `seed_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **잡기** → `seed_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: grabbing the opponent's collar with both hands and throwing forward. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **앉아서 가드** → `seed_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: crouching low with arms crossed in front of the face, blocking. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **점프 공격** → `seed_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중 대시** → `seed_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

## 3. 필살기 / 승리 자세 (한 장씩)

### 🧪 CHEMIKID

⬜ **D 플라스크 투척** → `chemikid_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: throwing the flask upward and forward with one arm, other hand on the belt. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **→D 촉매 돌진** → `chemikid_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: charging forward low like a sprinter, flask held back, coat flying. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **↓D 발열 반응** → `chemikid_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: leaping straight up with one fist raised high, flask held down by the side. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **←D 중화 반응** → `chemikid_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: counter stance, gloved palm held forward to block, flask hidden behind the back. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중D 앙금 생성** → `chemikid_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: in mid-air, throwing the flask straight down with both hands. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **D+HS 테르밋 반응** → `chemikid_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: holding two flasks raised high above the head, wild grin. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **승리** → `chemikid_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: victory pose, goggles pushed up, holding the flask up beside the face with a confident grin. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 💻 COMMON

⬜ **D 패킷 전송** → `common_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: aiming the keyboard forward like a gun and slamming the enter key. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **→D 버그 설치** → `common_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: crouching and placing something small on the ground with one hand. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **↓D 방화벽** → `common_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: holding the keyboard upright in front of the body like a shield. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **←D Ctrl+Z** → `common_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: leaning backward with two fingers pressing an invisible key, smirking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중D 이진 탐색** → `common_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: in mid-air, diving down with the keyboard raised over the head. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **D+HS 블루스크린** → `common_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: raising the keyboard high above the head with both hands, about to smash it down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **승리** → `common_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: victory pose, headphones on, keyboard resting on the shoulder, cool expression. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌀 CHAOS

⬜ **D 만유인력** → `chaos_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: one arm stretched forward with fingers curled, pulling something toward her. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **→D 운동량 던지기** → `chaos_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: lunging forward and grabbing the opponent's collar with both hands. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **↓D 전자기 펄스** → `chaos_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: arms spread wide, hair floating up, body crackling (no actual effect drawn). Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **←D 양자 터널링** → `chaos_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: gliding forward low, body bent, coat trailing behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중D 열팽창 폭발** → `chaos_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: in mid-air, thrusting one palm diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **D+HS 블랙홀** → `chaos_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: both hands cupped together in front of the chest, compressing something, intense stare. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **승리** → `chaos_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: victory pose, arms crossed, looking down coldly with a slight smile. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌍 GLOBE

⬜ **D 유성우** → `globe_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: one arm raised to the sky, calling something down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **→D 지각 돌진** → `globe_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: charging forward shoulder-first like a rugby tackle. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **↓D 지진해일** → `globe_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: punching the ground hard with one fist, one knee down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **←D 별자리 잇기** → `globe_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: pointing at the air with one finger, drawing dots. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중D 낙뢰** → `globe_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: in mid-air, swinging one fist straight down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **D+HS 태풍** → `globe_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: spinning with both arms spread wide, ponytail whipping around. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **승리** → `globe_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: victory pose, raising one fist high, big laughing grin. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 📐 ROOT2

⬜ **D √2 부메랑** → `root2_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: throwing something sideways like a boomerang, compass held in the other hand. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **→D 컴퍼스 찌르기** → `root2_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: lunging far forward and thrusting the giant compass like a spear. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **↓D 적분 기둥** → `root2_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: stabbing the giant compass point into the ground in front of him. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **←D 확률 주사위** → `root2_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: tossing a small die forward with a flick of the wrist. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중D 피보나치 낙하** → `root2_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: in mid-air, swinging the compass straight down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **D+HS Q.E.D.** → `root2_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: swinging the giant compass in a wide circle around himself. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **승리** → `root2_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: victory pose, pushing up his glasses with one finger, compass planted beside him. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌱 SEED

⬜ **D 씨앗 심기** → `seed_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: kneeling and pressing a seed into the ground with one hand. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **→D 덩굴 채찍** → `seed_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: swinging one arm wide like cracking a whip. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **↓D 세포분열** → `seed_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: one hand held out forward, summoning, calm expression. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **←D 광합성** → `seed_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: eyes closed, both hands together at the chest, face turned up to the sunlight. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **공중D DNA 이중나선** → `seed_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: in mid-air, spinning downward with arms tucked. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **D+HS 진화** → `seed_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: arms spread wide, looking upward, braid and cardigan blowing. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

⬜ **승리** → `seed_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: victory pose, holding a small flower and smiling gently. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

## 4. 기술 이펙트 (첨부 없이, 1:1 정사각형)

⬜ **플라스크 (투사체)** → `chemikid_flask`
```
A single 2D fighting game special effect sprite: a glass Erlenmeyer flask filled with glowing toxic-green liquid, tilted as if thrown. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **산성 웅덩이** → `chemikid_puddle`
```
A single 2D fighting game special effect sprite: a flat bubbling puddle of glowing green acid seen from the side, very wide and thin. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **발열 폭발** → `chemikid_explosion`
```
A single 2D fighting game special effect sprite: a tall chemical explosion bursting upward, orange fire mixed with green smoke. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **앙금 벽** → `chemikid_wall`
```
A single 2D fighting game special effect sprite: a short wall of white crystal precipitate rising from the ground, side view. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **패킷 (투사체)** → `common_packet`
```
A single 2D fighting game special effect sprite: a glowing cyan data packet, a rounded rectangle with binary 0101 patterns inside. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **버그 함정** → `common_bug`
```
A single 2D fighting game special effect sprite: a small mechanical bug robot sitting flat on the ground, cyan glowing eyes. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **방화벽** → `common_firewall`
```
A single 2D fighting game special effect sprite: a tall vertical cyan hexagon-grid energy shield, side view, thin and tall. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **블루스크린** → `common_bluescreen`
```
A single 2D fighting game special effect sprite: broken fragments of a blue error window flying apart, no letters. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **유성** → `globe_meteor`
```
A single 2D fighting game special effect sprite: a blazing orange meteor with a long fiery tail, flying diagonally downward. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **지진해일** → `globe_wave`
```
A single 2D fighting game special effect sprite: a big blue ocean wave rolling forward along the ground, side view. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **별자리 별** → `globe_star`
```
A single 2D fighting game special effect sprite: a single bright glowing star with sparkles. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **낙뢰** → `globe_lightning`
```
A single 2D fighting game special effect sprite: a jagged white-yellow lightning bolt striking straight down, tall and thin. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **태풍** → `globe_typhoon`
```
A single 2D fighting game special effect sprite: a swirling grey-blue tornado vortex with debris. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **블랙홀** → `chaos_blackhole`
```
A single 2D fighting game special effect sprite: a small black hole with a glowing violet accretion ring, slightly tilted. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **전자기 방전** → `chaos_spark`
```
A single 2D fighting game special effect sprite: a ball of crackling yellow electric sparks. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **증기 폭발** → `chaos_steam`
```
A single 2D fighting game special effect sprite: a burst of white hot steam spreading outward. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **√2 부메랑** → `root2_boomerang`
```
A single 2D fighting game special effect sprite: a golden square-root symbol shaped like a spinning boomerang. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **적분 기둥** → `root2_pillar`
```
A single 2D fighting game special effect sprite: a tall golden pillar of light rising from the ground with integral symbol patterns. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **주사위** → `root2_dice`
```
A single 2D fighting game special effect sprite: a single golden six-sided die with black dots. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **숫자 블록** → `root2_number`
```
A single 2D fighting game special effect sprite: a heavy golden block engraved with a big number, falling. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **덩굴** → `seed_vine`
```
A single 2D fighting game special effect sprite: a thick green thorny vine bursting up from the ground. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **덩굴 채찍** → `seed_whip`
```
A single 2D fighting game special effect sprite: a long green thorny vine whip swinging horizontally. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **DNA 나선** → `seed_dna`
```
A single 2D fighting game special effect sprite: a glowing lime-green and pink DNA double helix, diagonal. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **꽃잎** → `seed_leaf`
```
A single 2D fighting game special effect sprite: a cluster of pink petals and green leaves scattering. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```
