class_name CpuBrain
extends RefCounted
## 컴퓨터 상대 (2P 자리). 매 프레임 상황을 보고 "누르고 있는 버튼"과 "이번에 누른 버튼"을 정한다.
## Fighter는 사람 입력 대신 이걸 읽으니까, 기술/콤보/잡기를 사람과 똑같은 규칙으로 쓴다.
##
## 난이도마다 달라지는 것:
##   react     상대 공격을 보고 가드하기까지 걸리는 프레임 (작을수록 빠름)
##   guard     가드할 확률          low_guard  하단을 앉아서 막을 확률
##   combo     맞혔을 때 콤보를 이어갈 확률
##   anti_air  점프해 오는 상대를 대공으로 떨어뜨릴 확률
##   think     다음 행동을 고르기까지 걸리는 프레임 (작을수록 빠르게 판단)
##   punish    상대가 기술을 헛치거나 막혀서 빈틈이 있을 때 바로 때릴 확률
##   burst     콤보를 burst_hits대 이상 맞으면 버스트로 빠져나올 확률
##   tech      일반 잡기를 당하는 순간 잡기 풀기(HS)를 누를 확률
##   overhead  상대가 앉아서 막고 있으면 땅 중단(6K)을 섞을 확률
##   master    달인 전용 기술: 정해진 최대 데미지 콤보 길(2H 띄우기 → 점프 캔슬 → 공중 콤보 → 공중D),
##             필살기 → 오버드라이브 연결, 막힌 위험한 기술은 로만 캔슬로 안전하게, 점프 대공은 띄워서 공중 콤보,
##             먼 거리 빈틈은 긴 기술로 때리기

enum Level { EASY, NORMAL, HARD, MASTER }

const PARAMS := {
	Level.EASY: { "react": 20, "guard": 0.3, "low_guard": 0.25, "combo": 0.4, "anti_air": 0.15,
			"throw": 0.15, "special": 0.2, "think": [22, 46], "punish": 0.1, "burst": 0.2, "burst_hits": 6,
			"tech": 0.05, "overhead": 0.05 },
	Level.NORMAL: { "react": 11, "guard": 0.65, "low_guard": 0.6, "combo": 0.75, "anti_air": 0.5,
			"throw": 0.35, "special": 0.3, "think": [12, 30], "punish": 0.45, "burst": 0.5, "burst_hits": 4,
			"tech": 0.3, "overhead": 0.2 },
	Level.HARD: { "react": 5, "guard": 0.9, "low_guard": 0.9, "combo": 0.95, "anti_air": 0.85,
			"throw": 0.5, "special": 0.35, "think": [6, 18], "punish": 0.85, "burst": 0.85, "burst_hits": 3,
			"tech": 0.6, "overhead": 0.35 },
	Level.MASTER: { "react": 3, "guard": 0.97, "low_guard": 0.97, "combo": 1.0, "anti_air": 0.95,
			"throw": 0.55, "special": 0.35, "think": [4, 12], "punish": 0.97, "burst": 0.95, "burst_hits": 3,
			"tech": 0.8, "overhead": 0.45, "master": true },
}

## 달인 콤보 길: 이어갈 수 있는 기술 중 앞에 있는 것부터 고른다 (띄우는 2H로 모아서 공중 콤보)
const MASTER_ROUTE := ["2H", "5H", "5S", "2S", "5K", "2K", "5P", "2P"]
const AIR_ROUTE := ["s", "hs"]       # 점프 캔슬 뒤 공중에서 누를 순서 (jS → jH → 공중D)

var p: Dictionary
var _held := {}            # 지금 누르고 있는 버튼
var _pressed := {}         # 이번 프레임에 새로 누른 버튼
var _plan := "wait"        # 지금 하고 있는 행동
var _plan_frames := 0      # 그 행동을 더 할 프레임
var _plan_age := 0
var _threat_frames := 0    # 위협(상대 공격/투사체)을 본 뒤 지난 프레임
var _guarding := false
var _guard_low := false
var _level_decided_for: Variant = null  # 상·하단 가드를 마지막으로 정한 상대 기술 (바뀌면 다시 정함)
var _combo_for: AttackData        # 이어갈지 이미 정한 기술 (기술마다 한 번씩 정한다)
var _aa_decided := false
var _burst_decided := -1           # 버스트를 쓸지 정한 콤보 히트 수 (같은 히트에서 두 번 안 정하게)
var _punish_decided := false
var _air_step := 0                 # 달인 공중 콤보 진행 (0 = jS, 1 = jH, 2 = 공중D)
var _rc_decided: AttackData        # 막힌 기술을 로만 캔슬할지 이미 정한 기술
var _tech_for: AttackData          # 잡기 풀기를 시도할지 이미 정한 잡기


func _init(level: int) -> void:
	p = PARAMS[level]


func held(action: String) -> bool:
	return _held.get(action, false)


func just_pressed(action: String) -> bool:
	return _pressed.get(action, false)


func _press(action: String) -> void:
	_pressed[action] = true
	_held[action] = true


## Fighter.tick() 맨 앞에서 매 프레임 불린다
func think(me: Fighter) -> void:
	_pressed.clear()
	_held.clear()
	var opp := me.opponent
	if opp == null or me.state == Fighter.State.KO:
		return

	# 0) 버스트: 콤보를 여러 대 맞고 있으면 burst 확률로 빠져나온다
	if me.can_burst() and me.combo_hits >= p["burst_hits"] and _burst_decided != me.combo_hits:
		_burst_decided = me.combo_hits
		if randf() < p["burst"]:
			_press("d")
			_press("p")
			return
	if me.state in [Fighter.State.HITSTUN, Fighter.State.DOWN]:
		return
	# 0.5) 잡기 풀기: 상대가 일반 잡기를 시작하면 tech 확률로 HS
	if opp.state == Fighter.State.ATTACK and opp.current_attack != null \
			and opp.current_attack.name in ["throw_f", "throw_b"] and _tech_for != opp.current_attack:
		_tech_for = opp.current_attack
		if randf() < p["tech"]:
			_press("hs")
			return
	elif opp.state != Fighter.State.ATTACK:
		_tech_for = null
	var dx := opp.position.x - me.position.x
	var dist := absf(dx)
	var fwd := "right" if dx > 0 else "left"
	var back := "left" if dx > 0 else "right"

	# 1) 막기: 위협을 보고 react 프레임 뒤에, guard 확률로 가드할지 정한다
	if _is_threatened(me):
		_threat_frames += 1
		if _threat_frames == p["react"]:
			_guarding = randf() < p["guard"]
		# 상·하단은 상대 기술이 바뀔 때마다 다시 판단한다 (예전엔 처음 한 번만 정해서
		# 5S → 2K처럼 이어지는 하단을 서서 맞았다). 바닥 함정·하단 투사체도 본다
		var level := _incoming_level(me, opp)
		var key: Variant = opp.current_attack if opp.state == Fighter.State.ATTACK else level
		if _threat_frames >= p["react"] and key != _level_decided_for:
			_level_decided_for = key
			match level:
				AttackData.Level.LOW:
					_guard_low = randf() < p["low_guard"]
				AttackData.Level.OVERHEAD:
					_guard_low = randf() > p["low_guard"]  # 중단은 서서 막아야 한다
				_:
					# 상단은 서든 앉든 막힌다. 잘하는 CPU일수록 하단에 대비해 앉아서 막는다
					_guard_low = randf() < p["low_guard"] * 0.8
	else:
		_threat_frames = 0
		_guarding = false
		_level_decided_for = null
	var can_act := me.state in [Fighter.State.STAND, Fighter.State.CROUCH, Fighter.State.RUN,
			Fighter.State.GUARD, Fighter.State.BLOCKSTUN]
	if _guarding and can_act:
		_held[back] = true  # 사람처럼 뒤를 누르고 있기로 가드
		_held["down"] = _guard_low
		return

	# 1.5) 달인: 공중 콤보 (2H 점프 캔슬로 뛰어오른 뒤 떠 있는 상대에게 jS → jH → 공중D)
	if p.has("master") and not me.is_on_ground() and opp.state == Fighter.State.HITSTUN \
			and not opp.is_on_ground() and me.state == Fighter.State.AIR and dist < 200 and _air_step < AIR_ROUTE.size():
		_press(AIR_ROUTE[_air_step])
		_air_step += 1
		return
	if me.is_on_ground() and me.state != Fighter.State.ATTACK:
		_air_step = 0

	# 2) 콤보: 내 공격이 맞거나 막히면 combo 확률로 다음 기술을 이어서 누른다 (기술마다 다시 정함)
	if me.state == Fighter.State.ATTACK and me.current_attack != null:
		if p.has("master"):
			_master_attack(me, opp, fwd)
			return
		if me.attack_connected and _combo_for != me.current_attack:
			_combo_for = me.current_attack
			if randf() < p["combo"]:
				_continue_combo(me, opp, fwd)
		return
	_combo_for = null

	# 2.5) 빈틈 때리기: 상대가 기술 후딜(헛침/막힘) 중이고 가까우면 빠른 기술로 콤보 시작
	if _opp_recovering(opp) and dist < 200 and can_act:
		if not _punish_decided:
			_punish_decided = true
			if randf() < p["punish"]:
				if p.has("master"):  # 달인: 거리에 맞는 가장 센 시작기 (먼 빈틈은 5H)
					_press_move("2K" if dist < 120 else ("5S" if dist < 170 else "5H"), fwd)
				else:
					_press_move(["5K", "2K", "5P"].pick_random() if dist < 130 else "5S", fwd)
				return
	else:
		_punish_decided = false

	# 3) 대공: 점프해서 다가오는 상대를 anti_air 확률로 2H로 떨어뜨린다
	if not opp.is_on_ground() and dist < 230 and me.is_on_ground():
		if not _aa_decided:
			_aa_decided = true
			if randf() < p["anti_air"]:
				# 달인 Chemikid: 무적 대공(↓D)이 있으면 그걸로
				if p.has("master") and me.char_id == "chemikid" and not _usable_specials(me, ["2D"]).is_empty():
					_held["down"] = true
					_press("d")
					return
				_held["down"] = true
				_press("hs")
				return
	elif opp.is_on_ground():
		_aa_decided = false

	# 3.5) 기상 공방: 상대가 쓰러져 있으면 붙어서 일어나는 순간 하단(2K)/중단(6K)/잡기로 흔든다
	if opp.state == Fighter.State.DOWN and me.is_on_ground() and can_act:
		if dist > 110:
			_held[fwd] = true
		elif opp.state_frame >= Fighter.DOWN_FRAMES - 4:
			var r := randf()
			if r < p["overhead"]:
				_held[fwd] = true
				_press("k")
			elif r < 0.75:
				_press_move("2K", fwd)
		return

	# 4) 평소: 거리에 따라 행동(plan)을 골라 정해진 시간 동안 한다
	_plan_frames -= 1
	_plan_age += 1
	if _plan_frames <= 0:
		_choose_plan(me, opp, dist)
	_do_plan(me, opp, dist, fwd, back)


## 달인: 공격 중 판단. 맞으면 콤보 길대로 이어가고, 막혔는데 위험한 기술이면 로만 캔슬
func _master_attack(me: Fighter, opp: Fighter, fwd: String) -> void:
	var a := me.current_attack
	if not me.attack_connected:
		return
	var blocked := opp.state == Fighter.State.BLOCKSTUN
	if _combo_for == a:
		# 2H 점프 캔슬: 맞힌 2H에서는 위를 계속 누르고 있어야 점프가 나간다
		if a.name in Fighter.JUMP_CANCEL and not blocked and me.is_on_ground():
			_held["up"] = true
			_held[fwd] = true
		return
	_combo_for = a
	var is_special := a.name.ends_with("D") or a.name == "OD"
	if blocked:
		# 막힌 큰 기술(필살기·5H)은 텐션이 있으면 로만 캔슬로 빈틈 없애기
		if (is_special or a.name == "5H") and a.name != "OD" and me.tension >= Fighter.RC_COST and _rc_decided != a:
			_rc_decided = a
			_press("rc")
		elif not is_special and a.gatling.size() > 0:
			_press_move(a.gatling[0], fwd)  # 막혀도 개틀링으로 압박 계속
		return
	# 맞음: 필살기 → 오버드라이브
	if is_special:
		if a.name != "OD" and me.tension >= Fighter.RC_COST and me.attacks.has("OD"):
			_press("d")
			_press("hs")
		return
	# 공중 기본기 → 다음 공중기 → 공중D
	if a.name.begins_with("j"):
		if a.gatling.size() > 0:
			var nxt: String = a.gatling[-1]
			_press(nxt.substr(1).to_lower().replace("h", "hs"))
		elif not _usable_specials(me, ["jD"]).is_empty():
			_press("d")
		return
	# 2H: 점프 캔슬로 공중 콤보
	if a.name in Fighter.JUMP_CANCEL and me.is_on_ground():
		_held["up"] = true
		_held[fwd] = true
		_air_step = 0
		return
	# 땅 기본기: 콤보 길에서 가장 센 다음 기술, 더 없으면 필살기
	for mv: String in MASTER_ROUTE:
		if mv in a.gatling:
			_press_move(mv, fwd)
			return
	var specials := _usable_specials(me, ["6D", "2D", "5D"])
	if not specials.is_empty():
		_press_move(specials[0], fwd)
	elif me.tension >= Fighter.RC_COST and me.attacks.has("OD"):
		_press("d")
		_press("hs")


## 상대가 공격 후딜 중인가 (판정이 사라진 뒤 아직 못 움직이는 때)
func _opp_recovering(opp: Fighter) -> bool:
	if opp.state != Fighter.State.ATTACK or opp.current_attack == null:
		return false
	var a := opp.current_attack
	return opp.state_frame > a.startup + a.active and a.total_frames() - opp.state_frame > 6


## 마력이 충분한 필살기만 (모자라면 눌러 봐야 안 나가니까)
func _usable_specials(me: Fighter, names: Array) -> Array:
	return names.filter(func(s): return me.attacks.has(s) and me.mana >= me.mana_cost(s))


## 상대 공격(지속 판정 직전~중) 또는 다가오는 상대 투사체가 있으면 위협
func _is_threatened(me: Fighter) -> bool:
	return me.is_threatened()


## 지금 막아야 할 공격의 단계: 상대가 기술 중이면 그 기술, 아니면 가까이 오는 투사체 중 하단이 있으면 하단
func _incoming_level(me: Fighter, opp: Fighter) -> AttackData.Level:
	if opp.state == Fighter.State.ATTACK and opp.current_attack != null:
		return opp.current_attack.level
	var match_node := me.get_parent()
	if match_node is Match:
		for proj in match_node.projectiles:
			if proj.shooter == opp and proj.attack != null and not proj.dead \
					and absf(proj.position.x - me.position.x) < 200.0 and proj.attack.level == AttackData.Level.LOW:
				return AttackData.Level.LOW
	return AttackData.Level.MID


## 맞혔을 때: 개틀링 목록에서 하나, 또는 필살기로 캔슬
func _continue_combo(me: Fighter, _opp: Fighter, fwd: String) -> void:
	var options: Array = me.current_attack.gatling.duplicate()
	var specials := _usable_specials(me, ["5D", "6D", "2D"])
	if not me.current_attack.name.ends_with("D") and randf() < 0.35 and not specials.is_empty():
		options = specials
	# 텐션이 있으면 가끔 오버드라이브로 마무리
	if me.tension >= Fighter.RC_COST and me.attacks.has("OD") and randf() < 0.25:
		_press("d")
		_press("hs")
		return
	if options.is_empty():
		return
	_press_move(options.pick_random(), fwd)


## "2S", "6D" 같은 기술 이름대로 버튼을 누른다
func _press_move(move: String, fwd: String) -> void:
	if move.begins_with("2"):
		_held["down"] = true
	elif move.begins_with("6"):
		_held[fwd] = true
	elif move.begins_with("4"):
		_held["left" if fwd == "right" else "right"] = true
	var button := move.substr(1).to_lower()
	_press("hs" if button == "h" else button)


func _choose_plan(me: Fighter, _opp: Fighter, dist: float) -> void:
	var think: Array = p["think"]
	_plan_frames = randi_range(think[0], think[1])
	_plan_age = 0
	var options: Array = []
	if dist > 400:
		options = ["approach", "approach", "dash", "special", "wait", "jump"]
	elif dist > 170:
		options = ["approach", "dash", "jump", "poke", "special", "retreat", "crouch"]
	else:
		options = ["attack", "attack", "poke", "retreat", "crouch", "special"]
		if randf() < p["throw"]:
			options.append("throw")
			options.append("throw")
	# 텐션이 있고 가까우면 오버드라이브도 후보
	if me.tension >= Fighter.RC_COST and dist < 320 and randf() < p["special"]:
		options.append("overdrive")
	if _usable_specials(me, ["5D", "6D", "2D", "4D"]).is_empty():
		options.erase("special")
	_plan = options.pick_random()


func _do_plan(me: Fighter, _opp: Fighter, dist: float, fwd: String, back: String) -> void:
	var first := _plan_age == 0
	match _plan:
		"approach":
			_held[fwd] = true
		"retreat":
			_held[back] = true
		"crouch":
			_held["down"] = true
		"dash":
			# 사람처럼 66: 앞을 톡 → 한 프레임 뗐다가 → 다시 눌러서 그대로 달린다
			if _plan_age == 0 or _plan_age == 2:
				_press(fwd)
			elif _plan_age > 2:
				_held[fwd] = true
		"jump":
			if first:
				_held["up"] = true
				_held[fwd] = true
			elif not me.is_on_ground() and dist < 190:
				_press(["k", "s", "hs"].pick_random())  # 점프 공격
				_plan_frames = 0
		"poke":
			if first:
				_press_move(["5S", "5K", "2K", "2S"].pick_random(), fwd)
		"attack":
			if first:
				# 상대가 앉아서 막고 있으면 중단(6K)을 섞는다
				if _opp.state in [Fighter.State.GUARD, Fighter.State.BLOCKSTUN, Fighter.State.CROUCH] \
						and _opp._held("down") and randf() < p["overhead"]:
					_held[fwd] = true
					_press("k")
				else:
					_press_move(["5P", "5K", "2K", "2P"].pick_random(), fwd)
		"throw":
			if me._in_throw_range():
				_held[fwd] = true
				_press("hs")
				_plan_frames = 0
			else:
				_held[fwd] = true
		"special":
			if first:
				var moves := _usable_specials(me, ["5D", "6D", "2D", "4D"])
				if not moves.is_empty():
					var m: String = moves.pick_random()
					_press_move(m, fwd)
		"overdrive":
			if first:
				_press("d")
				_press("hs")
