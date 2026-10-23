# 완성 프롬프트 모음 (복사해서 바로 붙여넣기)

> 이 파일은 `python tools/make_prompts.py`로 자동 생성됨. 문장을 고치려면 그 스크립트를 고친다.
> **모든 프롬프트에 그 캐릭터의 이펙트 없는 전신 그림을 첨부**한다. 받은 그림은 파일 이름을 알려주며 보내면 된다.
> ✅ = 이미 게임에 들어간 그림, ⬜ = 아직 없음 (그림을 넣고 스크립트를 다시 돌리면 갱신됨)

## 현황

| 캐릭터 | 기본 전신·자세 6·상반신·얼굴·컷인 | 걷기 시트 | 뒤로 걷기 | 달리기 / 대시 | 백대시 | 쓰러짐 (KO) | 잡기 | 앉아서 가드 | 점프 공격 | 공중 대시 | 도발 (P+K) | 리스펙트 (→+P+K) | 필살기·승리 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 🧪 CHEMIKID | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 7/7 |
| 💻 COMMON | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 7/7 |
| 🌀 CHAOS | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 7/7 |
| 🌍 GLOBE | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 7/7 |
| 📐 ROOT2 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 7/7 |
| 🌱 SEED | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 7/7 |

이펙트: 31/32

## 0-0. 글자 그림 (한 장씩, 첨부 없이)

> AI가 글자를 틀리게 쓰는 일이 많으니 받으면 철자를 꼭 확인. 틀리면 다시 뽑기

✅ **라운드 1** "ROUND 1" → `text_round1`
```
Fighting game announcer text logo that reads exactly "ROUND 1" (spelled R-O-U-N-D-1), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic white silver chrome gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **라운드 2** "ROUND 2" → `text_round2`
```
Fighting game announcer text logo that reads exactly "ROUND 2" (spelled R-O-U-N-D-2), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic white silver chrome gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **마지막 라운드** "FINAL ROUND" → `text_final_round`
```
Fighting game announcer text logo that reads exactly "FINAL ROUND" (spelled F-I-N-A-L-R-O-U-N-D), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic blood red and silver chrome gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **싸움 시작** "FIGHT!" → `text_fight`
```
Fighting game announcer text logo that reads exactly "FIGHT!" (spelled F-I-G-H-T-!), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic blazing gold and orange fire gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **K.O.** "K.O." → `text_ko`
```
Fighting game announcer text logo that reads exactly "K.O." (spelled K-.-O-.), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic deep crimson red with black cracks gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **동시 K.O.** "DOUBLE K.O." → `text_double_ko`
```
Fighting game announcer text logo that reads exactly "DOUBLE K.O." (spelled D-O-U-B-L-E-K-.-O-.), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic deep crimson red with black cracks gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **시간 종료** "TIME UP" → `text_time_up`
```
Fighting game announcer text logo that reads exactly "TIME UP" (spelled T-I-M-E-U-P), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic white silver chrome with a red edge gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **무승부** "DRAW GAME" → `text_draw_game`
```
Fighting game announcer text logo that reads exactly "DRAW GAME" (spelled D-R-A-W-G-A-M-E), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic white silver chrome gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **카운터 히트** "COUNTER" → `text_counter`
```
Fighting game announcer text logo that reads exactly "COUNTER" (spelled C-O-U-N-T-E-R), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic hot orange red gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **가드 크러시** "GUARD CRUSH!" → `text_guard_crush`
```
Fighting game announcer text logo that reads exactly "GUARD CRUSH!" (spelled G-U-A-R-D-C-R-U-S-H-!), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic electric blue with white cracks gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **VS 화면** "VS" → `text_vs`
```
Fighting game announcer text logo that reads exactly "VS" (spelled V-S), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic blazing gold and red fire gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **승리 (이름 옆)** "WINS!" → `text_win`
```
Fighting game announcer text logo that reads exactly "WINS!" (spelled W-I-N-S-!), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic blazing gold gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **캐릭터 결정** "READY!" → `text_ready`
```
Fighting game announcer text logo that reads exactly "READY!" (spelled R-E-A-D-Y-!), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic gold gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **Root2 궁 결과** "ALGEBRA!" → `text_root2_algebra`
```
Fighting game announcer text logo that reads exactly "ALGEBRA!" (spelled A-L-G-E-B-R-A-!), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic shining gold gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **Root2 궁 결과** "CALCULUS!" → `text_root2_calculus`
```
Fighting game announcer text logo that reads exactly "CALCULUS!" (spelled C-A-L-C-U-L-U-S-!), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic shining gold gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **Root2 궁 결과** "PROBABILITY!" → `text_root2_probability`
```
Fighting game announcer text logo that reads exactly "PROBABILITY!" (spelled P-R-O-B-A-B-I-L-I-T-Y-!), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic shining gold gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

✅ **Root2 도장 글자** "Q.E.D." → `text_root2_qed`
```
Fighting game announcer text logo that reads exactly "Q.E.D." (spelled Q-.-E-.-D-.), only these characters, no other text or letters. Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, thick black outline plus a thin white outer stroke, metallic deep stamp-ink red, slightly rough like a rubber stamp gradient with bright highlights, subtle glow and a few sparks around the edges. Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.
```

## 0-1. 무기 공격 S / HS (한 장씩)

> 길티기어처럼 S·HS는 무기 공격. 없으면 HS → S → 펀치 그림을 대신 쓴다

✅ **S 컴퍼스 찌르기** → `root2_slash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: thrusting the giant compass forward with both hands at chest height, front foot forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **HS 컴퍼스 크게 휘두르기** → `root2_heavy`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: big horizontal sweeping slash toward the opponent: gripping the end of the giant compass handle with both hands, arms fully extended forward, the compass swung horizontally at chest height with its points reaching far ahead, the compass held level (not pointing down at the ground), deep wide lunge with the front knee bent, upper body leaning forward, head and eyes facing forward toward the right, scarf and coat flaring behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **S 플라스크 휘두르기** → `chemikid_slash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: quick horizontal swipe with the flask hand at chest height, flask swung forward, other hand on the belt, front foot forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **HS 플라스크 내려치기** → `chemikid_heavy`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: heavy overhead smash, the flask arm swung down in a big arc and fully extended forward and down, deep lunge, lab coat flaring behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **S 키보드 휘두르기** → `common_slash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: quick horizontal swing of the mechanical keyboard held in both hands like a bat at chest height, front foot forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **S 지질 망치 휘두르기** → `globe_slash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: quick horizontal swing of the small geologist rock hammer (taken from the belt) held in one hand at chest height, arm fully extended forward toward the right, front foot forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **HS 지질 망치 크게 휘두르기 (멀리 닿게)** → `globe_heavy`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: big long-reach hammer swing: gripping the very END of the geologist rock hammer handle with both hands, both arms fully stretched FAR forward toward the right at chest height so the hammer head is the farthest point of the whole image, the hammer head reaching well past the front foot, very deep wide lunge with the front knee bent and the back leg straight, upper body leaning far forward, head facing right, jacket and ponytail flaring behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **S 손날 베기** → `chaos_slash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: sharp knife-hand chop: one arm swung horizontally forward at chest height, fingers straight like a blade, arm fully extended toward the right, lab coat flaring, front foot forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **HS 양손 장타** → `chaos_heavy`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: powerful two-handed palm strike: both palms thrust straight forward at chest height, arms fully extended toward the right, deep lunge, long hair and lab coat blown back. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **S 손날 휘두르기** → `seed_slash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: sweeping backhand chop: one arm swung horizontally forward at chest height, arm fully extended toward the right, long braid swinging, front foot forward. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **HS 손바닥 강타** → `seed_heavy`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: powerful forward palm strike with one hand at chest height, arm fully extended toward the right, other hand pulled back, deep lunge, cardigan and braid flaring behind. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **HS 키보드 내려찍기** → `common_heavy`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: heavy slam, the mechanical keyboard brought down hard in front of the body with both hands at waist height, deep lunge, body leaning forward, jacket flaring. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

## 0-2. 앉은 / 공중 기본기 (한 장씩)

> 없으면 앉은 기술은 앉은 그림, 공중 기술은 점프 공격 그림을 같이 쓴다. 자주 쓰는 2K(하단)·2H(대공)·jK·jH부터 추천

### 🧪 CHEMIKID

✅ **앉아 P** → `chemikid_2p`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: crouching low, quick short jab forward with one fist at waist height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 K** → `chemikid_2k`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: crouching low, poking forward along the ground with the front foot, leg extended low, foot near the floor. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 S** → `chemikid_2s`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: crouching low with both knees bent, a sweeping strike with the flask far forward at knee height: the striking arm fully extended straight toward the right, reaching well past the front foot (a real attack, not a guard stance). Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 HS (대공)** → `chemikid_2h`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: anti-air: rising up from a crouch and swinging the flask straight upward above the head, looking up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 P** → `chemikid_jp`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: in mid-air, knees tucked, quick jab forward with one fist. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 K** → `chemikid_jk`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: in mid-air, kicking forward with one leg fully extended. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 S** → `chemikid_js`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: in mid-air, swinging the flask horizontally forward at chest height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 HS** → `chemikid_jh`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: in mid-air, big downward swing of the flask in front of the body, body arched forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 💻 COMMON

✅ **앉아 P** → `common_2p`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: crouching low, quick short jab forward with one fist at waist height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 K** → `common_2k`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: crouching low, poking forward along the ground with the front foot, leg extended low, foot near the floor. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 S** → `common_2s`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: crouching low with both knees bent, a sweeping strike with the mechanical keyboard far forward at knee height: the striking arm fully extended straight toward the right, reaching well past the front foot (a real attack, not a guard stance). Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 HS (대공)** → `common_2h`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: anti-air: rising up from a crouch and swinging the mechanical keyboard straight upward above the head, looking up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 P** → `common_jp`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: in mid-air, knees tucked, quick jab forward with one fist. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 K** → `common_jk`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: in mid-air, kicking forward with one leg fully extended. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 S** → `common_js`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: in mid-air, swinging the mechanical keyboard horizontally forward at chest height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 HS** → `common_jh`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: in mid-air, big downward swing of the mechanical keyboard in front of the body, body arched forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌀 CHAOS

✅ **앉아 P** → `chaos_2p`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: crouching low, quick short jab forward with one fist at waist height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 K** → `chaos_2k`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: crouching low, poking forward along the ground with the front foot, leg extended low, foot near the floor. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 S** → `chaos_2s`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: crouching low with both knees bent, a sweeping strike with one hand in a karate chop far forward at knee height: the striking arm fully extended straight toward the right, reaching well past the front foot (a real attack, not a guard stance). Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 HS (대공)** → `chaos_2h`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: anti-air: rising up from a crouch and swinging one hand in a karate chop straight upward above the head, looking up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 P** → `chaos_jp`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: in mid-air, knees tucked, quick jab forward with one fist. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 K** → `chaos_jk`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: in mid-air, kicking forward with one leg fully extended. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 S** → `chaos_js`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: in mid-air, swinging one hand in a karate chop horizontally forward at chest height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 HS** → `chaos_jh`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: in mid-air, big downward swing of one hand in a karate chop in front of the body, body arched forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌍 GLOBE

✅ **앉아 P** → `globe_2p`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: crouching low, quick short jab forward with one fist at waist height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 K** → `globe_2k`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: crouching low, poking forward along the ground with the front foot, leg extended low, foot near the floor. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 S** → `globe_2s`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: crouching low with both knees bent, a sweeping strike with one hand in a karate chop far forward at knee height: the striking arm fully extended straight toward the right, reaching well past the front foot (a real attack, not a guard stance). Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 HS (대공)** → `globe_2h`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: anti-air: rising up from a crouch and swinging one hand in a karate chop straight upward above the head, looking up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 P** → `globe_jp`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: in mid-air, knees tucked, quick jab forward with one fist. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 K** → `globe_jk`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: in mid-air, kicking forward with one leg fully extended. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 S** → `globe_js`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: in mid-air, swinging one hand in a karate chop horizontally forward at chest height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 HS** → `globe_jh`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: in mid-air, big downward swing of one hand in a karate chop in front of the body, body arched forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 📐 ROOT2

✅ **앉아 P** → `root2_2p`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: crouching low, quick short jab forward with one fist at waist height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 K** → `root2_2k`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: crouching low, poking forward along the ground with the front foot, leg extended low, foot near the floor. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 S** → `root2_2s`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: crouching low with both knees bent, a sweeping strike with the giant compass far forward at knee height: the striking arm fully extended straight toward the right, reaching well past the front foot (a real attack, not a guard stance). Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 HS (대공)** → `root2_2h`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: anti-air: rising up from a crouch and swinging the giant compass straight upward above the head, looking up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 P** → `root2_jp`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: in mid-air, knees tucked, quick jab forward with one fist. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 K** → `root2_jk`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: in mid-air, kicking forward with one leg fully extended. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 S** → `root2_js`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: in mid-air, swinging the giant compass horizontally forward at chest height. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 HS** → `root2_jh`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: in mid-air, big downward swing of the giant compass in front of the body, body arched forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌱 SEED

✅ **앉아 P** → `seed_2p`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: crouching low, quick short jab forward with one fist at waist height. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 K** → `seed_2k`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: crouching low, poking forward along the ground with the front foot, leg extended low, foot near the floor. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 S** → `seed_2s`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: crouching low with both knees bent, a sweeping strike with one hand in a karate chop far forward at knee height: the striking arm fully extended straight toward the right, reaching well past the front foot (a real attack, not a guard stance). Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아 HS (대공)** → `seed_2h`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: anti-air: rising up from a crouch and swinging one hand in a karate chop straight upward above the head, looking up. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 P** → `seed_jp`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: in mid-air, knees tucked, quick jab forward with one fist. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 K** → `seed_jk`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: in mid-air, kicking forward with one leg fully extended. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 S** → `seed_js`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: in mid-air, swinging one hand in a karate chop horizontally forward at chest height. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 HS** → `seed_jh`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: in mid-air, big downward swing of one hand in a karate chop in front of the body, body arched forward. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
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

✅ **뒤로 걷기** → `chemikid_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **달리기 / 대시** → `chemikid_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **백대시** → `chemikid_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **쓰러짐 (KO)** → `chemikid_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **잡기** → `chemikid_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: throw motion: both hands reaching forward and gripping EMPTY AIR at chest height as if grabbing an invisible collar, then pulling to throw, the opponent is NOT drawn, hands hold nothing. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아서 가드** → `chemikid_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **점프 공격** → `chemikid_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 대시** → `chemikid_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **도발 (P+K)** → `chemikid_taunt`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: cocky taunt toward the opponent on the right: smug grin, beckoning with one hand "come at me", other hand on the hip, relaxed confident stance, showing off the character's personality. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **리스펙트 (→+P+K)** → `chemikid_respect`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: showing respect to the opponent on the right: a small polite bow or a thumbs-up with a friendly smile, relaxed standing pose, sportsmanlike. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 💻 COMMON

✅ **뒤로 걷기** → `common_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **달리기 / 대시** → `common_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **백대시** → `common_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **쓰러짐 (KO)** → `common_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **잡기** → `common_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: throw motion: both hands reaching forward and gripping EMPTY AIR at chest height as if grabbing an invisible collar, then pulling to throw, the opponent is NOT drawn, hands hold nothing. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아서 가드** → `common_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **점프 공격** → `common_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 대시** → `common_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **도발 (P+K)** → `common_taunt`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: cocky taunt toward the opponent on the right: smug grin, beckoning with one hand "come at me", other hand on the hip, relaxed confident stance, showing off the character's personality. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **리스펙트 (→+P+K)** → `common_respect`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: showing respect to the opponent on the right: a small polite bow or a thumbs-up with a friendly smile, relaxed standing pose, sportsmanlike. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌀 CHAOS

✅ **뒤로 걷기** → `chaos_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **달리기 / 대시** → `chaos_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **백대시** → `chaos_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **쓰러짐 (KO)** → `chaos_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **잡기** → `chaos_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: throw motion: both hands reaching forward and gripping EMPTY AIR at chest height as if grabbing an invisible collar, then pulling to throw, the opponent is NOT drawn, hands hold nothing. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아서 가드** → `chaos_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **점프 공격** → `chaos_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 대시** → `chaos_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **도발 (P+K)** → `chaos_taunt`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: cocky taunt toward the opponent on the right: smug grin, beckoning with one hand "come at me", other hand on the hip, relaxed confident stance, showing off the character's personality. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **리스펙트 (→+P+K)** → `chaos_respect`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: showing respect to the opponent on the right: a small polite bow or a thumbs-up with a friendly smile, relaxed standing pose, sportsmanlike. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌍 GLOBE

✅ **뒤로 걷기** → `globe_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **달리기 / 대시** → `globe_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **백대시** → `globe_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **쓰러짐 (KO)** → `globe_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **잡기** → `globe_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: throw motion: both hands reaching forward and gripping EMPTY AIR at chest height as if grabbing an invisible collar, then pulling to throw, the opponent is NOT drawn, hands hold nothing. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아서 가드** → `globe_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **점프 공격** → `globe_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 대시** → `globe_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **도발 (P+K)** → `globe_taunt`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: cocky taunt toward the opponent on the right: smug grin, beckoning with one hand "come at me", other hand on the hip, relaxed confident stance, showing off the character's personality. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **리스펙트 (→+P+K)** → `globe_respect`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: showing respect to the opponent on the right: a small polite bow or a thumbs-up with a friendly smile, relaxed standing pose, sportsmanlike. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 📐 ROOT2

✅ **뒤로 걷기** → `root2_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **달리기 / 대시** → `root2_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **백대시** → `root2_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **쓰러짐 (KO)** → `root2_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **잡기** → `root2_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: throw motion: both hands reaching forward and gripping EMPTY AIR at chest height as if grabbing an invisible collar, then pulling to throw, the opponent is NOT drawn, hands hold nothing. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아서 가드** → `root2_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: crouching low with arms crossed in front of the face, blocking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **점프 공격** → `root2_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 대시** → `root2_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **도발 (P+K)** → `root2_taunt`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: cocky taunt toward the opponent on the right: smug grin, beckoning with one hand "come at me", other hand on the hip, relaxed confident stance, showing off the character's personality. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **리스펙트 (→+P+K)** → `root2_respect`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: showing respect to the opponent on the right: a small polite bow or a thumbs-up with a friendly smile, relaxed standing pose, sportsmanlike. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌱 SEED

✅ **뒤로 걷기** → `seed_walk_back`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **달리기 / 대시** → `seed_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: sprinting forward low, body leaning far forward, clothes and hair streaming behind. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **백대시** → `seed_backdash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: hopping backward, both feet off the ground, arms pulled in, guard up. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **쓰러짐 (KO)** → `seed_down`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **잡기** → `seed_throw`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: throw motion: both hands reaching forward and gripping EMPTY AIR at chest height as if grabbing an invisible collar, then pulling to throw, the opponent is NOT drawn, hands hold nothing. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **앉아서 가드** → `seed_crouch_guard`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: crouching low with arms crossed in front of the face, blocking. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **점프 공격** → `seed_jump_attack`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: mid-air downward strike, knees tucked, attacking diagonally downward. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중 대시** → `seed_air_dash`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: dashing horizontally through the air, body almost horizontal, one arm forward. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **도발 (P+K)** → `seed_taunt`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: cocky taunt toward the opponent on the right: smug grin, beckoning with one hand "come at me", other hand on the hip, relaxed confident stance, showing off the character's personality. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **리스펙트 (→+P+K)** → `seed_respect`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: showing respect to the opponent on the right: a small polite bow or a thumbs-up with a friendly smile, relaxed standing pose, sportsmanlike. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

## 3. 필살기 / 승리 자세 (한 장씩)

### 🧪 CHEMIKID

✅ **D 플라스크 투척** → `chemikid_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: throwing the flask upward and forward with one arm, other hand on the belt. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **→D 불꽃 반응** → `chemikid_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: flame test: one arm thrust straight forward at chest height with the palm open toward the right as if releasing fire from the hand, the other hand holding the flask up near the shoulder, firm wide stance, lab coat flaring, NO fire drawn (the game adds the flames). Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **↓D 발열 반응** → `chemikid_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: leaping straight up with one fist raised high, flask held down by the side. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **←D 중화 반응** → `chemikid_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: counter stance, gloved palm held forward to block, flask hidden behind the back. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중D 앙금 생성** → `chemikid_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: in mid-air, throwing the flask straight down with both hands. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **D+HS 테르밋 반응** → `chemikid_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: holding two flasks raised high above the head, wild grin. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **승리** → `chemikid_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his glowing green flask. Pose: victory pose, goggles pushed up, holding the flask up beside the face with a confident grin. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 💻 COMMON

✅ **D 패킷 전송** → `common_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: aiming the keyboard forward like a gun and slamming the enter key. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **→D 버그 설치** → `common_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: crouching and placing something small on the ground with one hand. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **↓D 방화벽** → `common_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: holding the keyboard upright in front of the body like a shield. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **←D Ctrl+Z** → `common_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: leaning backward with two fingers pressing an invisible key, smirking. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중D 이진 탐색** → `common_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: in mid-air, diving down with the keyboard raised over the head. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **D+HS 블루스크린** → `common_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: raising the keyboard high above the head with both hands, about to smash it down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **승리** → `common_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his mechanical keyboard. Pose: victory pose, headphones on, keyboard resting on the shoulder, cool expression. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌀 CHAOS

✅ **D 만유인력** → `chaos_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: one arm stretched forward with fingers curled, pulling something toward her. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **→D 운동량 던지기** → `chaos_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: lunging forward with both hands gripping EMPTY AIR at chest height as if grabbing an invisible collar, the opponent is NOT drawn. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **↓D 전자기 펄스** → `chaos_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: arms spread wide, hair floating up, body crackling (no actual effect drawn). Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **←D 양자 터널링** → `chaos_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: gliding forward low, body bent, coat trailing behind. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중D 열팽창 폭발** → `chaos_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: in mid-air, thrusting one open palm diagonally DOWN and forward toward the lower right with the arm fully extended, the other arm pulled back, lab coat and long hair blown upward, NO steam drawn (the game adds it). Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **D+HS 블랙홀** → `chaos_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: both hands cupped together in front of the chest, compressing something, intense stare. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **승리** → `chaos_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed. Pose: victory pose, arms crossed, looking down coldly with a slight smile. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌍 GLOBE

✅ **D 유성우** → `globe_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: one arm raised to the sky, calling something down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **→D 지각 돌진** → `globe_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: charging forward shoulder-first like a rugby tackle. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **↓D 지진해일** → `globe_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: punching the ground hard with one fist, one knee down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **←D 별자리 잇기** → `globe_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: pointing at the air with one finger, drawing dots. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중D 낙뢰** → `globe_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: in mid-air, swinging one fist straight down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **D+HS 태풍** → `globe_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: spinning with both arms spread wide, ponytail whipping around. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **승리** → `globe_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, geologist hammer on the belt. Pose: victory pose, raising one fist high, big laughing grin. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 📐 ROOT2

✅ **D √2 부메랑** → `root2_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: throwing something sideways like a boomerang, compass held in the other hand. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **→D 컴퍼스 찌르기** → `root2_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: lunging far forward and thrusting the giant compass like a spear. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **↓D 적분 기둥** → `root2_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: stabbing the giant compass point into the ground in front of him. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **←D 확률 주사위** → `root2_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: tossing a small die forward with a flick of the wrist. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중D 피보나치 낙하** → `root2_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: in mid-air, swinging the compass straight down. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **D+HS Q.E.D.** → `root2_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: swinging the giant compass in a wide circle around himself. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **승리** → `root2_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Holding his giant drafting compass. Pose: victory pose, pushing up his glasses with one finger, compass planted beside him. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

### 🌱 SEED

✅ **D 씨앗 심기** → `seed_5d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: kneeling and pressing a seed into the ground with one hand. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **→D 덩굴 채찍** → `seed_6d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: swinging one arm wide like cracking a whip. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **↓D 세포분열** → `seed_2d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: one hand held out forward, summoning, calm expression. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **←D 광합성** → `seed_4d`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: eyes closed, both hands together at the chest, face turned up to the sunlight. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **공중D DNA 이중나선** → `seed_jd`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: in mid-air, spinning downward with arms tucked. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **D+HS 진화** → `seed_od`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: arms spread wide, looking upward, braid and cardigan blowing. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

✅ **승리** → `seed_win`
```
Same character as the attached image: same face, hair, outfit, colors and body proportions. ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. Full body, facing right (three-quarter side view), whole body visible from head to feet, transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, no ground shadow, no text. Empty-handed, magnifying glass pendant. Pose: victory pose, holding a small flower and smiling gently. Skirt kept modest, opaque tights. Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, non-sexualized, natural body proportions, wholesome. Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, color accents of crimson red, black and white.
```

## 4. 기술 이펙트 (첨부 없이, 1:1 정사각형)

✅ **플라스크 (투사체)** → `chemikid_flask`
```
A single 2D fighting game special effect sprite: a glass Erlenmeyer flask filled with glowing toxic-green liquid, tilted as if thrown. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **산성 웅덩이** → `chemikid_puddle`
```
A single 2D fighting game special effect sprite: a flat bubbling puddle of glowing green acid seen from the side, very wide and thin. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **발열 폭발** → `chemikid_explosion`
```
A single 2D fighting game special effect sprite: a tall chemical explosion bursting upward, orange fire mixed with green smoke. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **앙금 벽** → `chemikid_wall`
```
A single 2D fighting game special effect sprite: a short wall of white crystal precipitate rising from the ground, side view. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **패킷 (투사체)** → `common_packet`
```
A single 2D fighting game special effect sprite: a glowing cyan data packet, a rounded rectangle with binary 0101 patterns inside. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **버그 함정** → `common_bug`
```
A single 2D fighting game special effect sprite: a small mechanical bug robot sitting flat on the ground, cyan glowing eyes. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **방화벽** → `common_firewall`
```
A single 2D fighting game special effect sprite: a tall vertical cyan hexagon-grid energy shield, side view, thin and tall. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **블루스크린** → `common_bluescreen`
```
A single 2D fighting game special effect sprite: broken fragments of a blue error window flying apart, no letters. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **유성** → `globe_meteor`
```
A single 2D fighting game special effect sprite: a blazing orange meteor with a long fiery tail, flying diagonally downward. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **지진해일** → `globe_wave`
```
A single 2D fighting game special effect sprite: a big blue ocean wave rolling forward along the ground, side view. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **별자리 별** → `globe_star`
```
A single 2D fighting game special effect sprite: a single bright glowing star with sparkles. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **낙뢰** → `globe_lightning`
```
A single 2D fighting game special effect sprite: a jagged white-yellow lightning bolt striking straight down, tall and thin. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **태풍** → `globe_typhoon`
```
A single 2D fighting game special effect sprite: a swirling grey-blue tornado vortex with debris. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **만유인력 (D, 손에 감기는 중력)** → `chaos_gravity`
```
A single 2D fighting game special effect sprite: a swirling violet-and-black gravity vortex wrapped around an invisible hand: spiraling rings of distorted space, tiny pebbles and dust orbiting inward, a dark core in the center, round overall shape, NO hand drawn, nothing else. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **불꽃 반응 (→D, 게임이 빨강·노랑·초록으로 색을 바꿈)** → `chemikid_flame`
```
A single 2D fighting game special effect sprite: a single burst of fire flaring out horizontally toward the right like a burner flame, WHITE-hot and very light grey colors only (the game tints it red, yellow and green), wider than tall, soft flickering edges, nothing else. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **중화 반응 방패 (←D)** → `chemikid_neutralize`
```
A single 2D fighting game special effect sprite: a round chemistry barrier seen from the side: a swirling disc where acid-red and base-blue liquid mix together into clear white light in the center, bubbles and tiny hexagon molecule shapes around the rim, glowing, NO letters. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **지각 돌진 흙먼지 (→D, 몸 뒤로 튀는 바위·먼지)** → `globe_rush`
```
A single 2D fighting game special effect sprite: a burst of broken rock chunks and brown dust kicked up from the ground and flying backward to the LEFT, as if something just dashed forward to the right, wider than tall, sitting on a flat ground line at the bottom, flat 2-tone cel shading in brown and orange, clean black outlines, NO realistic texture, nothing else. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **광합성 햇빛 (←D, 위에서 쏟아지는 빛 기둥)** → `seed_sunlight`
```
A single 2D fighting game special effect sprite: a soft vertical column of warm sunlight pouring straight DOWN from the top edge to the bottom, about 2 times taller than wide, pale yellow and white, a few small floating leaves and sparkles inside, edges fading out softly, flat stylized anime look, NO sun disc, NO character, nothing else. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **블랙홀** → `chaos_blackhole`
```
A single 2D fighting game special effect sprite: a small black hole with a glowing violet accretion ring, slightly tilted. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **전자기 방전** → `chaos_spark`
```
A single 2D fighting game special effect sprite: a ball of crackling yellow electric sparks. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **증기 폭발** → `chaos_steam`
```
A single 2D fighting game special effect sprite: a burst of white hot steam spreading outward. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

⬜ **열팽창 증기 분사 (공중D, 손에서 뿜어 나오는 원뿔)** → `chaos_steam_jet`
```
A single 2D fighting game special effect sprite: a jet of scalding white-and-orange steam blasting out horizontally from LEFT to RIGHT like a cone: a narrow hot point at the very left edge (where a palm would be) widening into a big billowing cloud at the right edge, about 2.5 times wider than tall, heat shimmer streaks inside, flat 2-tone cel shading, clean black outlines, NO hand drawn, nothing else. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **√2 부메랑** → `root2_boomerang`
```
A single 2D fighting game special effect sprite: a golden square-root symbol shaped like a spinning boomerang. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **적분 기둥 (↓D, 바닥에서 솟는 가늘고 긴 그림)** → `root2_pillar`
```
A single 2D fighting game special effect sprite: ONE thin sharp beam of light shooting straight UP from the ground, shaped like a tall elongated integral sign, very narrow (about 5 times taller than wide), flat 2-tone cel shading in gold and white only, crisp clean edges, a small flat burst of light at the base, a few thin golden line sparks, minimal detail, NO glow haze, NO realistic texture, NO particles cloud, nothing else. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **주사위** → `root2_dice`
```
A single 2D fighting game special effect sprite: a single golden six-sided die with black dots. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **숫자 블록 (숫자 없이 — 게임이 1·1·2·3·5를 위에 씀)** → `root2_number`
```
A single 2D fighting game special effect sprite: a heavy golden stone block falling, seen from the front, a large smooth empty flat face in the center with a raised beveled border, completely blank face with NO number, NO letters, NO symbols, short golden speed lines above it. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **궁극기 Q.E.D. 도장 (글자 없이 — 게임이 Q.E.D.를 위에 씀)** → `root2_qed_seal`
```
A single 2D fighting game special effect sprite: a huge round golden official seal stamp impression, ornate double ring border with tiny geometric compass and ruler motifs, empty smooth center with NO letters and NO text, slightly tilted, glowing edges, a burst of golden light behind it. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **궁극기 수식 마법진 (상대 머리 위 배경)** → `root2_qed_circle`
```
A single 2D fighting game special effect sprite: a large flat glowing golden magic circle made of geometry: concentric circles, a triangle and square inscribed, compass arcs and ruler tick marks, seen from the front, abstract math symbol shapes but NO readable letters or numbers. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **덩굴 (D 씨앗에서 솟음, 가늘고 긴 그림)** → `seed_vine`
```
A single 2D fighting game special effect sprite: ONE slender green plant sprout whipping straight UP out of the ground, thin stem (about 6 times taller than wide), gently curling at the top with two or three small leaves and one small pink bud, a tiny tuft of dirt at its base, flat 2-tone cel shading in only green and light green, bold clean black outline, simple and stylized like a fighting game sprite, NO thick trunk, NO thorns, NO rocks, NO realistic texture, NO glow, nothing else. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **덩굴 채찍 (→D, 가로로 쭉 뻗은 그림)** → `seed_whip`
```
A single 2D fighting game special effect sprite: ONE single long green thorny vine whip stretched out STRAIGHT horizontally from the left edge to the right edge like a cracking whip, very wide and thin (about 5 times wider than tall), slight S-wave, the right tip curled with a motion blur crack, NOT a circle, NOT a ring, NOT a loop, a few leaves flying. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **DNA 나선 (공중D, 대각선)** → `seed_dna`
```
A single 2D fighting game special effect sprite: ONE single glowing DNA double helix, one lime-green strand and one hot-pink strand twisted together with rungs between them, going diagonally from top-left down to bottom-right, a few pink petals around, nothing else. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```

✅ **꽃잎 바람 (D+HS 진화 연출)** → `seed_leaf`
```
A single 2D fighting game special effect sprite: a swirling burst of pink cherry-blossom petals and green leaves spreading outward in a circle from the center, empty center, nothing else. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.
```
