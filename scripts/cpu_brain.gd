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

enum Level { EASY, NORMAL, HARD }

const PARAMS := {
	Level.EASY: { "react": 22, "guard": 0.25, "low_guard": 0.2, "combo": 0.3, "anti_air": 0.1,
			"throw": 0.15, "special": 0.2, "think": [24, 50] },
	Level.NORMAL: { "react": 13, "guard": 0.55, "low_guard": 0.55, "combo": 0.65, "anti_air": 0.4,
			"throw": 0.35, "special": 0.3, "think": [14, 36] },
	Level.HARD: { "react": 7, "guard": 0.85, "low_guard": 0.85, "combo": 0.9, "anti_air": 0.75,
			"throw": 0.55, "special": 0.35, "think": [8, 24] },
}

var p: Dictionary
var _held := {}            # 지금 누르고 있는 버튼
var _pressed := {}         # 이번 프레임에 새로 누른 버튼
var _plan := "wait"        # 지금 하고 있는 행동
var _plan_frames := 0      # 그 행동을 더 할 프레임
var _plan_age := 0
var _threat_frames := 0    # 위협(상대 공격/투사체)을 본 뒤 지난 프레임
var _guarding := false
var _guard_low := false
var _combo_decided := false
var _aa_decided := false


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
	var dx := opp.position.x - me.position.x
	var dist := absf(dx)
	var fwd := "right" if dx > 0 else "left"
	var back := "left" if dx > 0 else "right"

	# 1) 막기: 위협을 보고 react 프레임 뒤에, guard 확률로 가드할지 정한다
	if _is_threatened(me):
		_threat_frames += 1
		if _threat_frames == p["react"]:
			_guarding = randf() < p["guard"]
			var low := opp.current_attack != null and opp.current_attack.level == AttackData.Level.LOW
			_guard_low = low and randf() < p["low_guard"]
	else:
		_threat_frames = 0
		_guarding = false
	var can_act := me.state in [Fighter.State.STAND, Fighter.State.CROUCH, Fighter.State.RUN,
			Fighter.State.GUARD, Fighter.State.BLOCKSTUN]
	if _guarding and can_act:
		_held[back] = true  # 사람처럼 뒤를 누르고 있기로 가드
		_held["down"] = _guard_low
		return

	# 2) 콤보: 내 공격이 맞거나 막히면 combo 확률로 다음 기술을 이어서 누른다
	if me.state == Fighter.State.ATTACK and me.current_attack != null:
		if me.attack_connected and not _combo_decided:
			_combo_decided = true
			if randf() < p["combo"]:
				_continue_combo(me, opp, fwd)
		return
	_combo_decided = false

	# 3) 대공: 점프해서 다가오는 상대를 anti_air 확률로 2H로 떨어뜨린다
	if not opp.is_on_ground() and dist < 230 and me.is_on_ground():
		if not _aa_decided:
			_aa_decided = true
			if randf() < p["anti_air"]:
				_held["down"] = true
				_press("hs")
				return
	elif opp.is_on_ground():
		_aa_decided = false

	# 4) 평소: 거리에 따라 행동(plan)을 골라 정해진 시간 동안 한다
	_plan_frames -= 1
	_plan_age += 1
	if _plan_frames <= 0:
		_choose_plan(me, opp, dist)
	_do_plan(me, opp, dist, fwd, back)


## 상대 공격(지속 판정 직전~중) 또는 다가오는 상대 투사체가 있으면 위협
func _is_threatened(me: Fighter) -> bool:
	return me.is_threatened()


## 맞혔을 때: 개틀링 목록에서 하나, 또는 필살기로 캔슬
func _continue_combo(me: Fighter, _opp: Fighter, fwd: String) -> void:
	var options: Array = me.current_attack.gatling.duplicate()
	var specials := ["5D", "6D", "2D"].filter(func(s): return me.attacks.has(s))
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
	if not me.attacks.has("5D"):
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
			_held[fwd] = true
			if first:
				_press("dash")
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
				var moves := ["5D", "6D", "2D", "4D"].filter(func(m): return me.attacks.has(m))
				if not moves.is_empty():
					var m: String = moves.pick_random()
					_press_move(m, fwd)
		"overdrive":
			if first:
				_press("d")
				_press("hs")
