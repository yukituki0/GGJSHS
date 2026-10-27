# docs/PROMPTS.md 만들기: 바로 복사해서 붙여넣는 완성 프롬프트 모음
# 문장을 고치려면 이 파일을 고치고 다시 실행: python tools/make_prompts.py
STYLE = ("Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, "
         "high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, "
         "color accents of crimson red, black and white.")
SAFE = ("Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, "
        "long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, "
        "non-sexualized, natural body proportions, wholesome.")
SINGLE = ("Same character as the attached image: same face, hair, outfit, colors and body proportions. "
          "ONLY ONE PERSON in the image: no opponent, no second character, no other people, no enemy silhouette. "
          "Full body, facing right (three-quarter side view), whole body visible from head to feet, "
          "transparent background (real alpha channel, not a checkerboard pattern), no effects, no glowing particles, no energy, no motion lines, "
          "no ground shadow, no text.")

CHARS = [
    ('chemikid', '🧪 CHEMIKID', 'holding his glowing green flask'),
    ('common', '💻 COMMON', 'holding his mechanical keyboard'),
    ('chaos', '🌀 CHAOS', 'empty-handed'),
    ('globe', '🌍 GLOBE', 'empty-handed, geologist hammer on the belt'),
    ('root2', '📐 ROOT2', 'holding his giant drafting compass'),
    ('seed', '🌱 SEED', 'empty-handed, magnifying glass pendant'),
]
SKIRT = {'seed'}  # 치마 캐릭터: 다리 드는 자세에 조건 추가

# 공통 자세: 파일 이름, 설명(한글), Pose 문장
COMMON_POSES = [
    ('walk_back', '뒤로 걷기', 'stepping backward cautiously in a guarded fighting stance, weight on the back foot, guard up'),
    ('dash', '달리기 / 대시', 'sprinting forward low, body leaning far forward, clothes and hair streaming behind'),
    ('backdash', '백대시', 'hopping backward, both feet off the ground, arms pulled in, guard up'),
    ('down', '쓰러짐 (KO)', 'knocked down, lying flat on the back on the ground, eyes closed, side view, whole body horizontal'),
    ('throw', '잡기', 'throw motion: both hands reaching forward and gripping EMPTY AIR at chest height as if grabbing an invisible collar, then pulling to throw, the opponent is NOT drawn, hands hold nothing'),
    ('crouch_guard', '앉아서 가드', 'crouching low with arms crossed in front of the face, blocking'),
    ('jump_attack', '점프 공격', 'mid-air downward strike, knees tucked, attacking diagonally downward'),
    ('air_dash', '공중 대시', 'dashing horizontally through the air, body almost horizontal, one arm forward'),
    ('taunt', '도발 (P+K)', 'cocky taunt toward the opponent on the right: smug grin, beckoning with one hand "come at me", '
     'other hand on the hip, relaxed confident stance, showing off the character\'s personality'),
    ('respect', '리스펙트 (→+P+K)', 'showing respect to the opponent on the right: a small polite bow or a thumbs-up with a friendly smile, '
     'relaxed standing pose, sportsmanlike'),
]

# 캐릭터별 필살기/승리 자세: (파일, 기술 이름, Pose 문장)
SPECIALS = {
    'chemikid': [
        ('5d', 'D 플라스크 투척', 'throwing the flask upward and forward with one arm, other hand on the belt'),
        ('6d', '→D 불꽃 반응', 'flame test: one arm thrust straight forward at chest height with the palm open toward the right as if '
                              'releasing fire from the hand, the other hand holding the flask up near the shoulder, firm wide stance, '
                              'lab coat flaring, NO fire drawn (the game adds the flames)'),
        ('2d', '↓D 발열 반응', 'leaping straight up with one fist raised high, flask held down by the side'),
        ('4d', '←D 중화 반응', 'counter stance, gloved palm held forward to block, flask hidden behind the back'),
        ('jd', '공중D 앙금 생성', 'in mid-air, throwing the flask straight down with both hands'),
        ('od', 'D+HS 테르밋 반응', 'holding two flasks raised high above the head, wild grin'),
        ('win', '승리', 'victory pose, goggles pushed up, holding the flask up beside the face with a confident grin'),
    ],
    'common': [
        ('5d', 'D 패킷 전송', 'aiming the keyboard forward like a gun and slamming the enter key'),
        ('6d', '→D 버그 설치', 'crouching and placing something small on the ground with one hand'),
        ('2d', '↓D 방화벽', 'holding the keyboard upright in front of the body like a shield'),
        ('4d', '←D Ctrl+Z', 'leaning backward with two fingers pressing an invisible key, smirking'),
        ('jd', '공중D 이진 탐색', 'in mid-air, diving down with the keyboard raised over the head'),
        ('od', 'D+HS 블루스크린', 'raising the keyboard high above the head with both hands, about to smash it down'),
        ('win', '승리', 'victory pose, headphones on, keyboard resting on the shoulder, cool expression'),
    ],
    'chaos': [
        ('5d', 'D 만유인력', 'one arm stretched forward with fingers curled, pulling something toward her'),
        ('6d', '→D 운동량 던지기', "lunging forward with both hands gripping EMPTY AIR at chest height as if grabbing an invisible collar, the opponent is NOT drawn"),
        ('2d', '↓D 전자기 펄스', 'arms spread wide, hair floating up, body crackling (no actual effect drawn)'),
        ('4d', '←D 양자 터널링', 'gliding forward low, body bent, coat trailing behind'),
        ('jd', '공중D 열팽창 폭발', 'in mid-air, thrusting one open palm diagonally DOWN and forward toward the lower right with the arm fully '
                                  'extended, the other arm pulled back, lab coat and long hair blown upward, NO steam drawn (the game adds it)'),
        ('od', 'D+HS 블랙홀', 'both hands cupped together in front of the chest, compressing something, intense stare'),
        ('win', '승리', 'victory pose, arms crossed, looking down coldly with a slight smile'),
    ],
    'globe': [
        ('5d', 'D 유성우', 'one arm raised to the sky, calling something down'),
        ('6d', '→D 지각 돌진', 'charging forward shoulder-first like a rugby tackle'),
        ('2d', '↓D 지진해일', 'punching the ground hard with one fist, one knee down'),
        ('4d', '←D 별자리 잇기', 'pointing at the air with one finger, drawing dots'),
        ('jd', '공중D 낙뢰', 'in mid-air, swinging one fist straight down'),
        ('od', 'D+HS 태풍', 'spinning with both arms spread wide, ponytail whipping around'),
        ('win', '승리', 'victory pose, raising one fist high, big laughing grin'),
    ],
    'root2': [
        ('5d', 'D √2 부메랑', 'throwing something sideways like a boomerang, compass held in the other hand'),
        ('6d', '→D 컴퍼스 찌르기', 'lunging far forward and thrusting the giant compass like a spear'),
        ('2d', '↓D 적분 기둥', 'stabbing the giant compass point into the ground in front of him'),
        ('4d', '←D 확률 주사위', 'tossing a small die forward with a flick of the wrist'),
        ('jd', '공중D 피보나치 낙하', 'in mid-air, swinging the compass straight down'),
        ('od', 'D+HS Q.E.D.', 'swinging the giant compass in a wide circle around himself'),
        ('win', '승리', 'victory pose, pushing up his glasses with one finger, compass planted beside him'),
    ],
    'seed': [
        ('5d', 'D 씨앗 심기', 'kneeling and pressing a seed into the ground with one hand'),
        ('6d', '→D 덩굴 채찍', 'swinging one arm wide like cracking a whip'),
        ('2d', '↓D 세포분열', 'one hand held out forward, summoning, calm expression'),
        ('4d', '←D 광합성', 'eyes closed, both hands together at the chest, face turned up to the sunlight'),
        ('jd', '공중D DNA 이중나선', 'in mid-air, spinning downward with arms tucked'),
        ('od', 'D+HS 진화', 'arms spread wide, looking upward, braid and cardigan blowing'),
        ('win', '승리', 'victory pose, holding a small flower and smiling gently'),
    ],
}

# 다시 뽑을 그림: (파일, 설명, Pose 문장). 새 그림을 넣으면 여기서 지운다
REDO = [
    # 판정보다 그림이 짧아서 판정이 허공에 떠 있는 것 (실측: 그림 끝 / 판정 끝)
]

# 스테이지 배경 (학교 사진을 첨부해서 애니풍으로 바꾸기). assets/stages/<id>.png, 1920x1080
STAGE_PHOTOS = [
    ('playground', '운동장', '농구장 사진 (372)',
     'the outdoor school basketball court in front of the pink and beige three-story school buildings, pine trees on the right, big white clouds in a blue sky'),
    ('hallway', '복도', '2층 난간 창문 사진 (369)',
     'the second-floor school hallway with a glass and steel railing in front of a wall of big black-framed windows looking out on the campus buildings and green hills'),
    ('cherry_road', '벚나무 길', '벚나무 길 사진 (371)',
     'the long campus road lined with cherry trees and round trimmed bushes, the pink school building on the left, autumn leaves, cloudy sky'),
    ('lobby', '중앙 로비', '로비 사진 (370)',
     'the school lobby with a teal rubber floor, a big black TV and two windows on the white wall, two small potted plants, framed calligraphy above'),
]

# 무기 공격 (길티기어처럼 S = 가벼운 무기 공격, HS = 크고 느린 무기 공격). 5S → <id>_slash, 5H → <id>_heavy
WEAPON_POSES = [
    ('root2_slash', 'S 컴퍼스 찌르기', 'thrusting the giant compass forward with both hands at chest height, front foot forward'),
    ('root2_heavy', 'HS 컴퍼스 크게 휘두르기',
     'big horizontal sweeping slash toward the opponent: gripping the end of the giant compass handle with both hands, '
     'arms fully extended forward, the compass swung horizontally at chest height with its points reaching far ahead, '
     'the compass held level (not pointing down at the ground), deep wide lunge with the front knee bent, '
     'upper body leaning forward, head and eyes facing forward toward the right, scarf and coat flaring behind'),
    ('chemikid_slash', 'S 플라스크 휘두르기',
     'quick horizontal swipe with the flask hand at chest height, flask swung forward, other hand on the belt, front foot forward'),
    ('chemikid_heavy', 'HS 플라스크 내려치기',
     'heavy overhead smash, the flask arm swung down in a big arc and fully extended forward and down, '
     'deep lunge, lab coat flaring behind'),
    ('common_slash', 'S 키보드 휘두르기',
     'quick horizontal swing of the mechanical keyboard held in both hands like a bat at chest height, front foot forward'),
    ('globe_slash', 'S 지질 망치 휘두르기',
     'quick horizontal swing of the small geologist rock hammer (taken from the belt) held in one hand at chest height, '
     'arm fully extended forward toward the right, front foot forward'),
    ('globe_heavy', 'HS 지질 망치 크게 휘두르기 (멀리 닿게)',
     'big long-reach hammer swing: gripping the very END of the geologist rock hammer handle with both hands, '
     'both arms fully stretched FAR forward toward the right at chest height so the hammer head is the farthest point of the whole image, '
     'the hammer head reaching well past the front foot, very deep wide lunge with the front knee bent and the back leg straight, '
     'upper body leaning far forward, head facing right, jacket and ponytail flaring behind'),
    ('chaos_slash', 'S 손날 베기',
     'sharp knife-hand chop: one arm swung horizontally forward at chest height, fingers straight like a blade, '
     'arm fully extended toward the right, lab coat flaring, front foot forward'),
    ('chaos_heavy', 'HS 양손 장타',
     'powerful two-handed palm strike: both palms thrust straight forward at chest height, arms fully extended toward the right, '
     'deep lunge, long hair and lab coat blown back'),
    ('seed_slash', 'S 손날 휘두르기',
     'sweeping backhand chop: one arm swung horizontally forward at chest height, arm fully extended toward the right, '
     'long braid swinging, front foot forward'),
    ('seed_heavy', 'HS 손바닥 강타',
     'powerful forward palm strike with one hand at chest height, arm fully extended toward the right, other hand pulled back, '
     'deep lunge, cardigan and braid flaring behind'),
    ('common_heavy', 'HS 키보드 내려찍기',
     'heavy slam, the mechanical keyboard brought down hard in front of the body with both hands at waist height, '
     'deep lunge, body leaning forward, jacket flaring'),
]

# 앉은 / 공중 기본기 (파일 이름 = 기술 이름: <id>_2k.png, <id>_jh.png). 없으면 앉은 그림 / 점프 공격 그림을 같이 쓴다
# {W}: S·HS 때 휘두르는 것 (무기 캐릭터는 무기, 맨손 캐릭터는 손날)
WEAPON = {
    'chemikid': 'the flask', 'common': 'the mechanical keyboard', 'root2': 'the giant compass',
    'chaos': 'one hand in a karate chop', 'globe': 'one hand in a karate chop', 'seed': 'one hand in a karate chop',
}
NORMALS = [
    ('2p', '앉아 P', 'crouching low, quick jab with one fist at waist height, the punching arm FULLY extended straight toward the right, '
                    'fist reaching well past the front knee'),
    ('2k', '앉아 K', 'crouching low, sweeping kick: the front leg FULLY extended straight forward along the floor toward the right, '
                    'foot at ankle height reaching far ahead of the body, the other knee bent'),
    ('2s', '앉아 S', 'crouching low with both knees bent, a sweeping strike with {W} far forward at knee height: '
           'the striking arm fully extended straight toward the right, reaching well past the front foot (a real attack, not a guard stance)'),
    ('2h', '앉아 HS (대공)', 'anti-air: rising up from a crouch and swinging {W} straight upward above the head, looking up'),
    ('6k', '앞 K (땅 중단 발차기)', 'overhead heel-drop kick: one leg raised high and swinging DOWN onto the opponent in front, the heel at head height '
                    'reaching forward toward the right, standing on the other leg, body leaning slightly back, a big committed slow attack'),
    ('jp', '공중 P', 'in mid-air, knees tucked, quick jab forward with one fist'),
    ('jk', '공중 K', 'in mid-air, flying side kick: one leg FULLY extended straight forward toward the right at hip height, '
                    'the foot is the farthest point of the image, the other knee tucked'),
    ('js', '공중 S', 'in mid-air, swinging {W} horizontally forward at chest height'),
    ('jh', '공중 HS', 'in mid-air, big diagonal downward swing of {W} reaching FAR forward and down toward the lower right, '
                    'the striking arm fully extended well in front of the body (not close to the chest), body leaning forward'),
]

# 글자 그림 (assets/ui/text_<이름>.png): 지금 폰트로 쓰는 큰 글자를 그림으로. (이름, 설명, 정확한 글자, 색)
TEXTS = [
    ('round1', '라운드 1', 'ROUND 1', 'white silver chrome'),
    ('throw_break', '잡기 풀기', 'THROW BREAK', 'cool sky-blue and white chrome'),
    ('round2', '라운드 2', 'ROUND 2', 'white silver chrome'),
    ('final_round', '마지막 라운드', 'FINAL ROUND', 'blood red and silver chrome'),
    ('fight', '싸움 시작', 'FIGHT!', 'blazing gold and orange fire'),
    ('ko', 'K.O.', 'K.O.', 'deep crimson red with black cracks'),
    ('double_ko', '동시 K.O.', 'DOUBLE K.O.', 'deep crimson red with black cracks'),
    ('time_up', '시간 종료', 'TIME UP', 'white silver chrome with a red edge'),
    ('draw_game', '무승부', 'DRAW GAME', 'white silver chrome'),
    ('counter', '카운터 히트', 'COUNTER', 'hot orange red'),
    ('guard_crush', '가드 크러시', 'GUARD CRUSH!', 'electric blue with white cracks'),
    ('vs', 'VS 화면', 'VS', 'blazing gold and red fire'),
    ('win', '승리 (이름 옆)', 'WINS!', 'blazing gold'),
    ('ready', '캐릭터 결정', 'READY!', 'gold'),
    ('root2_algebra', 'Root2 궁 결과', 'ALGEBRA!', 'shining gold'),
    ('root2_calculus', 'Root2 궁 결과', 'CALCULUS!', 'shining gold'),
    ('root2_probability', 'Root2 궁 결과', 'PROBABILITY!', 'shining gold'),
    ('root2_qed', 'Root2 도장 글자', 'Q.E.D.', 'deep stamp-ink red, slightly rough like a rubber stamp'),
]

EFFECTS = [
    # 공통 (모든 캐릭터): 지금은 코드로 그린 임시 연출
    ('fx_hit', '맞힘 불꽃 (공통)', 'a sharp hit spark burst: bright white center with jagged golden-orange star rays shooting outward, comic-style impact, round overall'),
    ('fx_guard', '막힘 불꽃 (공통)', 'a defensive block spark: a small cyan-white hexagon flash with short straight light rays, crisp and clean, round overall'),
    ('fx_guard_shield', '가드 방패 (공통, 몸 앞)', 'a curved translucent cyan energy barrier seen from the side, a tall crescent shape bulging toward the right, hexagon pattern faintly inside, glowing edge'),
    ('fx_burst', '버스트 충격파 (공통)', 'a powerful circular shockwave ring exploding outward: gold and sky-blue double ring, white flash in the center, a few speed lines, round'),
    ('fx_rc', '로만 캔슬 (공통)', 'a crimson red circular ring wave expanding outward with thin red speed lines and a few small red sparks, round, mostly empty center'),
    ('fx_shock', '감전 (Chaos ↓D에 맞은 상대 몸 주위)', 'crackling yellow electric arcs forming a rough upright oval cage, as if wrapped around an invisible standing person, empty center, taller than wide'),
    ('chemikid_flask', '플라스크 (투사체)', 'a glass Erlenmeyer flask filled with glowing toxic-green liquid, tilted as if thrown'),
    ('chemikid_puddle', '산성 웅덩이', 'a flat bubbling puddle of glowing green acid seen from the side, very wide and thin'),
    ('chemikid_explosion', '발열 폭발', 'a tall chemical explosion bursting upward, orange fire mixed with green smoke'),
    ('chemikid_wall', '앙금 벽', 'a short wall of white crystal precipitate rising from the ground, side view'),
    ('common_packet', '패킷 (투사체)', 'a glowing cyan data packet, a rounded rectangle with binary 0101 patterns inside'),
    ('common_bug', '버그 함정', 'a small mechanical bug robot sitting flat on the ground, cyan glowing eyes'),
    ('common_firewall', '방화벽', 'a tall vertical cyan hexagon-grid energy shield, side view, thin and tall'),
    ('common_bluescreen', '블루스크린', 'broken fragments of a blue error window flying apart, no letters'),
    ('globe_meteor', '유성', 'a blazing orange meteor with a long fiery tail, flying diagonally downward'),
    ('globe_wave', '지진해일', 'a big blue ocean wave rolling forward along the ground, side view'),
    ('globe_star', '별자리 별', 'a single bright glowing star with sparkles'),
    ('globe_lightning', '낙뢰', 'a jagged white-yellow lightning bolt striking straight down, tall and thin'),
    ('globe_typhoon', '태풍', 'a swirling grey-blue tornado vortex with debris'),
    ('chaos_gravity', '만유인력 (D, 손에 감기는 중력)',
     'a swirling violet-and-black gravity vortex wrapped around an invisible hand: spiraling rings of distorted space, '
     'tiny pebbles and dust orbiting inward, a dark core in the center, round overall shape, NO hand drawn, nothing else'),
    ('chemikid_flame', '불꽃 반응 (→D, 게임이 빨강·노랑·초록으로 색을 바꿈)',
     'a single burst of fire flaring out horizontally toward the right like a burner flame, WHITE-hot and very light grey colors only '
     '(the game tints it red, yellow and green), wider than tall, soft flickering edges, nothing else'),
    ('chemikid_neutralize', '중화 반응 방패 (←D)',
     'a round chemistry barrier seen from the side: a swirling disc where acid-red and base-blue liquid mix together into '
     'clear white light in the center, bubbles and tiny hexagon molecule shapes around the rim, glowing, NO letters'),
    ('globe_rush', '지각 돌진 흙먼지 (→D, 몸 뒤로 튀는 바위·먼지)',
     'a burst of broken rock chunks and brown dust kicked up from the ground and flying backward to the LEFT, '
     'as if something just dashed forward to the right, wider than tall, sitting on a flat ground line at the bottom, '
     'flat 2-tone cel shading in brown and orange, clean black outlines, NO realistic texture, nothing else'),
    ('seed_sunlight', '광합성 햇빛 (←D, 위에서 쏟아지는 빛 기둥)',
     'a soft vertical column of warm sunlight pouring straight DOWN from the top edge to the bottom, '
     'about 2 times taller than wide, pale yellow and white, a few small floating leaves and sparkles inside, '
     'edges fading out softly, flat stylized anime look, NO sun disc, NO character, nothing else'),
    ('chaos_grab_bolt', '운동량 던지기 전기 줄기 (→D, 가로로 긴 그림)', 'ONE horizontal bolt of violet-and-white lightning stretching straight from the left edge to the right edge, jagged zigzag, a bright grabbing spark at the right end, very wide and thin (about 6 times wider than tall)'),
    ('chaos_blackhole', '블랙홀', 'a small black hole with a glowing violet accretion ring, slightly tilted'),
    ('chaos_spark', '전자기 방전', 'a ball of crackling yellow electric sparks'),
    ('chaos_steam', '증기 폭발', 'a burst of white hot steam spreading outward'),
    ('chaos_steam_jet', '열팽창 증기 분사 (공중D, 손에서 뿜어 나오는 원뿔)',
     'a jet of scalding white-and-orange steam blasting out horizontally from LEFT to RIGHT like a cone: a narrow hot point at the very '
     'left edge (where a palm would be) widening into a big billowing cloud at the right edge, about 2.5 times wider than tall, '
     'heat shimmer streaks inside, flat 2-tone cel shading, clean black outlines, NO hand drawn, nothing else'),
    ('root2_boomerang', '√2 부메랑', 'a golden square-root symbol shaped like a spinning boomerang'),
    ('root2_thrust', '컴퍼스 찌르기 궤적 (→D, 가로로 긴 그림)', 'ONE long straight golden thrust streak flying from left to right like a spear trail, a sharp bright point at the right end, thin geometric ruler tick marks along it, very wide and thin (about 6 times wider than tall)'),
    ('root2_pillar', '적분 기둥 (↓D, 바닥에서 솟는 가늘고 긴 그림)',
     'ONE thin sharp beam of light shooting straight UP from the ground, shaped like a tall elongated integral sign, '
     'very narrow (about 5 times taller than wide), flat 2-tone cel shading in gold and white only, crisp clean edges, '
     'a small flat burst of light at the base, a few thin golden line sparks, minimal detail, '
     'NO glow haze, NO realistic texture, NO particles cloud, nothing else'),
    ('root2_dice', '주사위', 'a single golden six-sided die with black dots'),
    ('root2_number', '숫자 블록 (숫자 없이 — 게임이 1·1·2·3·5를 위에 씀)',
     'a heavy golden stone block falling, seen from the front, a large smooth empty flat face in the center with a raised beveled border, '
     'completely blank face with NO number, NO letters, NO symbols, short golden speed lines above it'),
    ('root2_qed_seal', '궁극기 Q.E.D. 도장 (글자 없이 — 게임이 Q.E.D.를 위에 씀)',
     'a huge round golden official seal stamp impression, ornate double ring border with tiny geometric compass and ruler motifs, '
     'empty smooth center with NO letters and NO text, slightly tilted, glowing edges, a burst of golden light behind it'),
    ('root2_qed_circle', '궁극기 수식 마법진 (상대 머리 위 배경)',
     'a large flat glowing golden magic circle made of geometry: concentric circles, a triangle and square inscribed, '
     'compass arcs and ruler tick marks, seen from the front, abstract math symbol shapes but NO readable letters or numbers'),
    ('seed_seed', '씨앗 (D, 땅에 심긴 씨)', 'a small brown seed half-buried in a tiny mound of dirt with one tiny green sprout and two little leaves popping out, cute, simple, side view'),
    ('seed_aura', '진화 오라 (D+HS 6초 강화 중 몸 주위)', 'a soft pink-and-green glowing aura shaped like a tall upright oval flame with cherry-blossom petals and small leaves rising upward, empty center, taller than wide'),
    ('seed_vine', '덩굴 (D 씨앗에서 솟음, 가늘고 긴 그림)',
     'ONE slender green plant sprout whipping straight UP out of the ground, thin stem (about 6 times taller than wide), '
     'gently curling at the top with two or three small leaves and one small pink bud, a tiny tuft of dirt at its base, '
     'flat 2-tone cel shading in only green and light green, bold clean black outline, simple and stylized like a fighting game sprite, '
     'NO thick trunk, NO thorns, NO rocks, NO realistic texture, NO glow, nothing else'),
    ('seed_whip', '덩굴 채찍 (→D, 가로로 쭉 뻗은 그림)',
     'ONE single long green thorny vine whip stretched out STRAIGHT horizontally from the left edge to the right edge like a cracking whip, '
     'very wide and thin (about 5 times wider than tall), slight S-wave, the right tip curled with a motion blur crack, '
     'NOT a circle, NOT a ring, NOT a loop, a few leaves flying'),
    ('seed_dna', 'DNA 나선 (공중D, 대각선)',
     'ONE single glowing DNA double helix, one lime-green strand and one hot-pink strand twisted together with rungs between them, '
     'going diagonally from top-left down to bottom-right, a few pink petals around, nothing else'),
    ('seed_leaf', '꽃잎 바람 (D+HS 진화 연출)',
     'a swirling burst of pink cherry-blossom petals and green leaves spreading outward in a circle from the center, '
     'empty center, nothing else'),
]


import os


def has(name):
    """그림이 이미 게임 폴더에 있으면 True (캐릭터 그림 또는 이펙트 그림)"""
    return os.path.exists('assets/characters/%s.png' % name) or os.path.exists('assets/effects/%s.png' % name)


def mark(*names):
    return '✅' if all(has(n) for n in names) else '⬜'


# 판정에 맞춘 리치: 게임의 공격 판정 끝 = 그림의 손발(무기) 끝 + 18px 이 되게.
# 6명 같은 기술 판정 길이의 중간값에서 18을 뺀 값을 서 있는 키(235)로 나눈 비율. (자세 파일 끝 이름 → (비율, 높이 설명))
REACH = {
    'punch': (0.47, 'at chest height'), 'kick': (0.52, 'at head height'), '6k': (0.50, 'the heel at head height, coming down'),
    'slash': (0.54, 'at chest height'), 'heavy': (0.69, 'at chest-to-waist height'),
    '2p': (0.47, 'at waist height while crouching'), '2k': (0.36, 'at ankle height along the floor'),
    '2s': (0.52, 'at knee height'), 'jp': (0.55, 'at chest height in mid-air'), 'jk': (0.59, 'at hip height in mid-air'),
    'js': (0.67, 'at chest height in mid-air'), 'jh': (0.50, 'diagonally down-forward in mid-air'),
}
REACH_OVERRIDE = {'root2_heavy': 1.1, 'root2_2s': 1.1, 'root2_js': 1.0, 'globe_heavy': 0.85}  # 일부러 긴 무기 기술


def reach_text(file):
    key = file.split('_', 1)[1]
    if key not in REACH:
        return ''
    ratio, where = REACH[key]
    ratio = REACH_OVERRIDE.get(file, ratio)
    return (f" REACH (must match the game's hit area): the very tip of the attacking hand, foot or weapon ends about "
            f"{int(ratio * 100)}% of the character's full standing height in front of the body's center line, {where}. "
            "The attacking limb is fully extended and clearly separated from the body. Leave empty space around it, nothing cropped.")


def pose_prompt(char, name, pose, file=''):
    extra = ' Skirt kept modest, opaque tights.' if char in SKIRT else ''
    return f"{SINGLE} {name}. Pose: {pose}.{extra}{reach_text(file) if file else ''} {SAFE} {STYLE}"


out = ['# 완성 프롬프트 모음 (복사해서 바로 붙여넣기)', '',
       '> 이 파일은 `python tools/make_prompts.py`로 자동 생성됨. 문장을 고치려면 그 스크립트를 고친다.',
       '> **모든 프롬프트에 그 캐릭터의 이펙트 없는 전신 그림을 첨부**한다. 받은 그림은 파일 이름을 알려주며 보내면 된다.',
       '> ✅ = 이미 게임에 들어간 그림, ⬜ = 아직 없음 (그림을 넣고 스크립트를 다시 돌리면 갱신됨)', '']

# 현황표
DONE_BASIC = ['', '_punch', '_kick', '_guard', '_hit', '_crouch', '_jump', '_select', '_face', '_cutin']
cols = ['기본 전신·자세 6·상반신·얼굴·컷인', '걷기 시트'] + [ko for _, ko, _ in COMMON_POSES] + ['필살기·승리']
out += ['## 현황', '', '| 캐릭터 | ' + ' | '.join(cols) + ' |', '|' + '---|' * (len(cols) + 1)]
for cid, title, _ in CHARS:
    row = [mark(*[cid + x for x in DONE_BASIC]), mark(*[f'{cid}_walk', f'{cid}_walk2', f'{cid}_walk3', f'{cid}_walk4'])]
    row += [mark(f'{cid}_{f}') for f, _, _ in COMMON_POSES]
    sp = SPECIALS[cid]
    row += ['%d/%d' % (sum(has(f'{cid}_{f}') for f, _, _ in sp), len(sp))]
    out.append(f'| {title} | ' + ' | '.join(row) + ' |')
out += ['', '이펙트: %d/%d' % (sum(has(f) for f, _, _ in EFFECTS), len(EFFECTS)), '']

if REDO:
    out += ['## 0. 다시 뽑을 그림 (판정에 맞게 우선!)', '', '> 괄호 = 지금 그림 끝 / 판정 끝 (발 기준 px). REACH 문장이 판정 길이에 맞춰 들어가 있다', '']
    for f, ko, pose in REDO:
        cid = f.split('_')[0]
        item = next(i for c, _, i in CHARS if c == cid)
        out += [f'⬜ **{ko}** → `{f}`', '```', pose_prompt(cid, item[0].upper() + item[1:], pose, f), '```', '']

out += ['## 0-0. 글자 그림 (한 장씩, 첨부 없이)', '',
        '> AI가 글자를 틀리게 쓰는 일이 많으니 받으면 철자를 꼭 확인. 틀리면 다시 뽑기', '']
for f, ko, txt, col in TEXTS:
    spelled = '-'.join(c for c in txt if c != ' ')
    out += [f'{"✅" if os.path.exists(f"assets/ui/text_{f}.png") else "⬜"} **{ko}** "{txt}" → `text_{f}`', '```',
            f'Fighting game announcer text logo that reads exactly "{txt}" (spelled {spelled}), only these characters, no other text or letters. '
            f'Bold aggressive heavy metal lettering like a 2D anime fighting game, slightly slanted, sharp angular edges, '
            f'thick black outline plus a thin white outer stroke, metallic {col} gradient with bright highlights, subtle glow and a few sparks around the edges. '
            'Horizontal, centered, wide margins, transparent background (real alpha channel, not a checkerboard pattern), no character, no background scene.',
            '```', '']

out += ['## 0-1. 무기 공격 S / HS (한 장씩)', '',
        '> 길티기어처럼 S·HS는 무기 공격. 없으면 HS → S → 펀치 그림을 대신 쓴다', '']
for f, ko, pose in WEAPON_POSES:
    cid = f.split('_')[0]
    item = next(i for c, _, i in CHARS if c == cid)
    out += [f'{mark(f)} **{ko}** → `{f}`', '```', pose_prompt(cid, item[0].upper() + item[1:], pose, f), '```', '']

out += ['## 0-2. 앉은 / 공중 기본기 (한 장씩)', '',
        '> 없으면 앉은 기술은 앉은 그림, 공중 기술은 점프 공격 그림을 같이 쓴다. 자주 쓰는 2K(하단)·2H(대공)·jK·jH부터 추천', '']
for cid, title, item in CHARS:
    out += [f'### {title}', '']
    for f, ko, pose in NORMALS:
        out += [f'{mark(cid + "_" + f)} **{ko}** → `{cid}_{f}`', '```',
                pose_prompt(cid, item[0].upper() + item[1:], pose.replace('{W}', WEAPON[cid]), f'{cid}_{f}'), '```', '']

out += ['## 1. 걷기 시트 (4프레임, 한 장)', '']
for cid, title, item in CHARS:
    extra = ' Skirt kept modest, opaque tights.' if cid in SKIRT else ''
    out += [f'### {mark(f"{cid}_walk", f"{cid}_walk2", f"{cid}_walk3", f"{cid}_walk4")} {title} → `{cid}_walk` ~ `{cid}_walk4`', '```',
            "Character pose sheet for a 2D fighting game walk cycle, 4 frames in one horizontal row, left to right. "
            "Same character as the attached image: same face, hair, outfit, colors and body proportions, " + item + ". "
            "The character keeps the same guarded fighting stance in every frame (upper body almost still, knees slightly bent) "
            "and only the legs change, taking short shuffling steps forward: "
            "1) front foot lifted slightly and moving forward, 2) front foot planted, feet wide apart, "
            "3) back foot lifted slightly and sliding forward, 4) back foot planted, feet close together. "
            "All frames facing right, same scale, feet on the same ground line, wide space between frames, no overlap. "
            "Transparent background (real alpha channel, not a checkerboard pattern), no effects, no motion lines, no text, no numbers." + extra + " " + SAFE + " " + STYLE,
            '```', '']

out += ['## 2. 연결 자세 (한 장씩)', '']
for cid, title, item in CHARS:
    out += [f'### {title}', '']
    for f, ko, pose in COMMON_POSES:
        out += [f'{mark(cid + "_" + f)} **{ko}** → `{cid}_{f}`', '```', pose_prompt(cid, item[0].upper() + item[1:], pose), '```', '']

out += ['## 3. 필살기 / 승리 자세 (한 장씩)', '']
for cid, title, item in CHARS:
    out += [f'### {title}', '']
    for f, ko, pose in SPECIALS[cid]:
        out += [f'{mark(cid + "_" + f)} **{ko}** → `{cid}_{f}`', '```', pose_prompt(cid, item[0].upper() + item[1:], pose), '```', '']

out += ['## 4. 기술 이펙트 (첨부 없이, 1:1 정사각형)', '']
for f, ko, desc in EFFECTS:
    out += [f'{mark(f)} **{ko}** → `{f}`', '```',
            f"A single 2D fighting game special effect sprite: {desc}. No character, centered, transparent background (real alpha channel, not a checkerboard pattern), "
            "bold cel-shaded anime effect style with thick black outlines, high contrast, saturated colors, no text, no letters.",
            '```', '']

out += ['## 5. 스테이지 배경 (학교 사진 첨부, 16:9 가로)', '',
        '> 사진을 첨부해서 한 장씩. 바닥(캐릭터가 서는 곳)이 그림 아래쪽 약 85% 높이에 오게. 받은 그림은 `assets/stages/<id>.png`', '']
for sid, ko, photo, desc in STAGE_PHOTOS:
    done = '✅' if os.path.exists(f'assets/stages/{sid}.png') else '⬜'
    out += [f'{done} **{ko}** ({photo}) → `stages/{sid}`', '```',
            f"Redraw the attached photo as a 2D anime fighting game stage background: {desc}. Keep the same place, layout and buildings as the photo. "
            "Wide 16:9 landscape, 1920x1080. Straight-on side view at standing eye level, like a Guilty Gear / Street Fighter stage: "
            "a flat open floor runs across the whole bottom of the image, and the line where the characters stand is at about 85% of the image height, "
            "with nothing blocking the floor in the middle. No people, no characters, no text, no letters, no UI. "
            "Painterly anime background art, cel-shaded with clean outlines, slightly muted colors and soft depth so fighters in front stand out, "
            "dramatic lighting, " + "a little darker and calmer than the characters.",
            '```', '']

open('docs/PROMPTS.md', 'w', encoding='utf-8').write('\n'.join(out))
print('docs/PROMPTS.md', len(out), 'lines')
