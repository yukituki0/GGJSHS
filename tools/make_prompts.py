# docs/PROMPTS.md 만들기: 바로 복사해서 붙여넣는 완성 프롬프트 모음
# 문장을 고치려면 이 파일을 고치고 다시 실행: python tools/make_prompts.py
STYLE = ("Japanese anime fighting game art style, cel-shaded with hard-edged shadows, thick black ink outlines, "
         "high contrast, saturated colors, dramatic rim lighting, gritty rock-and-roll / heavy metal aesthetic, "
         "color accents of crimson red, black and white.")
SAFE = ("Age-appropriate high school student, fully clothed in a modest school uniform or club outfit, "
        "long sleeves or jacket, knee-length or longer skirt/pants, no exposed skin other than face and hands, "
        "non-sexualized, natural body proportions, wholesome.")
SINGLE = ("Same character as the attached image: same face, hair, outfit, colors and body proportions. "
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
    ('throw', '잡기', "grabbing the opponent's collar with both hands and throwing forward"),
    ('crouch_guard', '앉아서 가드', 'crouching low with arms crossed in front of the face, blocking'),
    ('jump_attack', '점프 공격', 'mid-air downward strike, knees tucked, attacking diagonally downward'),
    ('air_dash', '공중 대시', 'dashing horizontally through the air, body almost horizontal, one arm forward'),
]

# 캐릭터별 필살기/승리 자세: (파일, 기술 이름, Pose 문장)
SPECIALS = {
    'chemikid': [
        ('5d', 'D 플라스크 투척', 'throwing the flask upward and forward with one arm, other hand on the belt'),
        ('6d', '→D 촉매 돌진', 'charging forward low like a sprinter, flask held back, coat flying'),
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
        ('6d', '→D 운동량 던지기', "lunging forward and grabbing the opponent's collar with both hands"),
        ('2d', '↓D 전자기 펄스', 'arms spread wide, hair floating up, body crackling (no actual effect drawn)'),
        ('4d', '←D 양자 터널링', 'gliding forward low, body bent, coat trailing behind'),
        ('jd', '공중D 열팽창 폭발', 'in mid-air, thrusting one palm diagonally downward'),
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
REDO = []

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
    ('2p', '앉아 P', 'crouching low, quick short jab forward with one fist at waist height'),
    ('2k', '앉아 K', 'crouching low, poking forward along the ground with the front foot, leg extended low, foot near the floor'),
    ('2s', '앉아 S', 'crouching low, swinging {W} forward at knee height'),
    ('2h', '앉아 HS (대공)', 'anti-air: rising up from a crouch and swinging {W} straight upward above the head, looking up'),
    ('jp', '공중 P', 'in mid-air, knees tucked, quick jab forward with one fist'),
    ('jk', '공중 K', 'in mid-air, kicking forward with one leg fully extended'),
    ('js', '공중 S', 'in mid-air, swinging {W} horizontally forward at chest height'),
    ('jh', '공중 HS', 'in mid-air, big downward swing of {W} in front of the body, body arched forward'),
]

# 글자 그림 (assets/ui/text_<이름>.png): 지금 폰트로 쓰는 큰 글자를 그림으로. (이름, 설명, 정확한 글자, 색)
TEXTS = [
    ('round1', '라운드 1', 'ROUND 1', 'white silver chrome'),
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
    ('chaos_blackhole', '블랙홀', 'a small black hole with a glowing violet accretion ring, slightly tilted'),
    ('chaos_spark', '전자기 방전', 'a ball of crackling yellow electric sparks'),
    ('chaos_steam', '증기 폭발', 'a burst of white hot steam spreading outward'),
    ('root2_boomerang', '√2 부메랑', 'a golden square-root symbol shaped like a spinning boomerang'),
    ('root2_pillar', '적분 기둥', 'a tall golden pillar of light rising from the ground with integral symbol patterns'),
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
    ('seed_vine', '덩굴', 'a thick green thorny vine bursting up from the ground'),
    ('seed_whip', '덩굴 채찍', 'a long green thorny vine whip swinging horizontally'),
    ('seed_dna', 'DNA 나선', 'a glowing lime-green and pink DNA double helix, diagonal'),
    ('seed_leaf', '꽃잎', 'a cluster of pink petals and green leaves scattering'),
]


import os


def has(name):
    """그림이 이미 게임 폴더에 있으면 True (캐릭터 그림 또는 이펙트 그림)"""
    return os.path.exists('assets/characters/%s.png' % name) or os.path.exists('assets/effects/%s.png' % name)


def mark(*names):
    return '✅' if all(has(n) for n in names) else '⬜'


def pose_prompt(char, name, pose):
    extra = ' Skirt kept modest, opaque tights.' if char in SKIRT else ''
    return f"{SINGLE} {name}. Pose: {pose}.{extra} {SAFE} {STYLE}"


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
    out += ['## 0. 다시 뽑을 그림', '']
    for f, ko, pose in REDO:
        cid = f.split('_')[0]
        item = next(i for c, _, i in CHARS if c == cid)
        out += [f'⬜ **{ko}** → `{f}`', '```', pose_prompt(cid, item[0].upper() + item[1:], pose), '```', '']

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
    out += [f'{mark(f)} **{ko}** → `{f}`', '```', pose_prompt(cid, item[0].upper() + item[1:], pose), '```', '']

out += ['## 0-2. 앉은 / 공중 기본기 (한 장씩)', '',
        '> 없으면 앉은 기술은 앉은 그림, 공중 기술은 점프 공격 그림을 같이 쓴다. 자주 쓰는 2K(하단)·2H(대공)·jK·jH부터 추천', '']
for cid, title, item in CHARS:
    out += [f'### {title}', '']
    for f, ko, pose in NORMALS:
        out += [f'{mark(cid + "_" + f)} **{ko}** → `{cid}_{f}`', '```',
                pose_prompt(cid, item[0].upper() + item[1:], pose.replace('{W}', WEAPON[cid])), '```', '']

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

open('docs/PROMPTS.md', 'w', encoding='utf-8').write('\n'.join(out))
print('docs/PROMPTS.md', len(out), 'lines')
