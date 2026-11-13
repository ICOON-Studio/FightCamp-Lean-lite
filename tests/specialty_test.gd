extends SceneTree
## SPECIALTY1 - the weekly hold: line_for, units, frozen, week, coach_holds, dropped, needs_flag.
## Expected values from the brief (ops/research/TASK_SPECIALTY1.md), not from the code.

const Specialty := preload("res://scripts/rules/Specialty.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")

var failures := 0


func _initialize() -> void:
	_check_line_for()
	_check_units()
	_check_frozen()
	_check_week_sharp()
	_check_week_under_60()
	_check_week_signature()
	_check_week_frozen()
	_check_week_steps()
	_check_week_no_mutate()
	_check_floors()
	_check_coach_holds()
	_check_dropped()
	_check_needs_flag()
	_check_apply()
	_check_run_week()
	print("SPECIALTY failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, msg: String) -> void:
	if ok:
		print("PASS %s" % msg)
	else:
		print("FAIL %s" % msg)
		failures += 1


func _check_line_for() -> void:
	_check(Specialty.line_for(59.9) == 0.0, "line_for(59.9) == 0")
	_check(Specialty.line_for(60.0) == 20.0, "line_for(60) == 20")
	_check(Specialty.line_for(84.9) == 20.0, "line_for(84.9) == 20")
	_check(Specialty.line_for(85.0) == 40.0, "line_for(85) == 40")
	_check(Specialty.line_for(0.0) == 0.0, "line_for(0) == 0")


func _check_units() -> void:
	# pads combo:1-2 60 -> Jab 30, Cross 30
	var u1: Dictionary = Specialty.units({"combo:1-2": 60.0}, {}, [])
	_check(u1.get("Jab", 0.0) == 30.0, "units: pads combo:1-2 60 -> Jab 30")
	_check(u1.get("Cross", 0.0) == 30.0, "units: pads combo:1-2 60 -> Cross 30")

	# spar 3 distinct moves -> 60 each
	var u2: Dictionary = Specialty.units({}, {}, ["move:Jab", "combo:1-2", "move:Lead hook"])
	_check(u2.get("Jab", 0.0) == 60.0, "units: spar 3 distinct -> Jab 60")
	_check(u2.get("Cross", 0.0) == 60.0, "units: spar 3 distinct -> Cross 60")
	_check(u2.get("Lead hook", 0.0) == 60.0, "units: spar 3 distinct -> Lead hook 60")

	# spar 4 distinct moves -> 45 each
	var u3: Dictionary = Specialty.units({}, {}, ["move:Jab", "combo:1-2", "move:Lead hook", "move:Body hook"])
	_check(u3.get("Jab", 0.0) == 45.0, "units: spar 4 distinct -> Jab 45")
	_check(u3.get("Cross", 0.0) == 45.0, "units: spar 4 distinct -> Cross 45")
	_check(u3.get("Lead hook", 0.0) == 45.0, "units: spar 4 distinct -> Lead hook 45")
	_check(u3.get("Body hook", 0.0) == 45.0, "units: spar 4 distinct -> Body hook 45")

	# unknown combo key skipped
	var u4: Dictionary = Specialty.units({"combo:unknown": 60.0}, {}, [])
	_check(u4.size() == 0, "units: unknown combo skipped")

	# pads + bag stack
	var u5: Dictionary = Specialty.units({"move:Jab": 30.0}, {"move:Jab": 20.0}, [])
	_check(u5.get("Jab", 0.0) == 50.0, "units: pads 30 + bag 20 -> Jab 50")


func _check_frozen() -> void:
	_check(Specialty.frozen("taper", false, false) == true, "frozen: taper -> true")
	_check(Specialty.frozen("peak", false, false) == false, "frozen: peak -> false")
	_check(Specialty.frozen("build", false, true) == true, "frozen: build + injured -> true")
	_check(Specialty.frozen("build", true, false) == true, "frozen: fight_week -> true")
	_check(Specialty.frozen("build", false, false) == false, "frozen: none -> false")


func _check_week_sharp() -> void:
	# Sharp Jab 62 with 10 units -> 60.5 and in faded
	var f: Dictionary = {"moves": {"Jab": 62.0}}
	var r: Dictionary = Specialty.week(f, {"Jab": 10.0}, false)
	_check(abs(r["moves"]["Jab"] - 60.5) < 0.001, "week: Sharp Jab 62, 10u -> 60.5")
	_check(r["faded"].has("Jab"), "week: Sharp Jab 62, 10u -> faded")
	_check(not r["held"].has("Jab"), "week: Sharp Jab 62, 10u -> not held")

	# Sharp Jab 62 with 20 units -> 62 and in held
	var r2: Dictionary = Specialty.week(f, {"Jab": 20.0}, false)
	_check(r2["moves"]["Jab"] == 62.0, "week: Sharp Jab 62, 20u -> 62")
	_check(r2["held"].has("Jab"), "week: Sharp Jab 62, 20u -> held")

	# Sharp 60.0 with 0 units -> 58.5
	var f2: Dictionary = {"moves": {"Jab": 60.0}}
	var r3: Dictionary = Specialty.week(f2, {}, false)
	_check(abs(r3["moves"]["Jab"] - 58.5) < 0.001, "week: Sharp Jab 60, 0u -> 58.5")


func _check_week_under_60() -> void:
	# Move at 50.8 (under 60) unchanged and in neither list
	var f: Dictionary = {"moves": {"Jab": 50.8}}
	var r: Dictionary = Specialty.week(f, {}, false)
	_check(r["moves"]["Jab"] == 50.8, "week: Jab 50.8 unchanged")
	_check(not r["held"].has("Jab"), "week: Jab 50.8 not in held")
	_check(not r["faded"].has("Jab"), "week: Jab 50.8 not in faded")


func _check_week_signature() -> void:
	# Signature 86 with 30 units -> 84.5
	var f: Dictionary = {"moves": {"Jab": 86.0}}
	var r: Dictionary = Specialty.week(f, {"Jab": 30.0}, false)
	_check(abs(r["moves"]["Jab"] - 84.5) < 0.001, "week: Signature Jab 86, 30u -> 84.5")


func _check_week_frozen() -> void:
	# Frozen week -> all unchanged and all 60+ in held
	var f: Dictionary = {"moves": {"Jab": 62.0, "Cross": 88.0}, "steps": {"step_in": 65.0}}
	var r: Dictionary = Specialty.week(f, {}, true)
	_check(r["moves"]["Jab"] == 62.0, "frozen week: Jab 62 unchanged")
	_check(r["moves"]["Cross"] == 88.0, "frozen week: Cross 88 unchanged")
	_check(r["steps"]["step_in"] == 65.0, "frozen week: step_in 65 unchanged")
	_check(r["held"].has("Jab"), "frozen week: Jab in held")
	_check(r["held"].has("Cross"), "frozen week: Cross in held")
	_check(r["held"].has("step_in"), "frozen week: step_in in held")
	_check(r["faded"].size() == 0, "frozen week: nothing faded")


func _check_week_steps() -> void:
	# step_in 65 with 0 units -> 63.5 in returned steps
	var f: Dictionary = {"steps": {"step_in": 65.0}}
	var r: Dictionary = Specialty.week(f, {}, false)
	_check(abs(r["steps"]["step_in"] - 63.5) < 0.001, "week: step_in 65, 0u -> 63.5")
	_check(r["faded"].has("step_in"), "week: step_in 65 in faded")


func _check_week_no_mutate() -> void:
	# f itself unchanged after the call
	var f: Dictionary = {"moves": {"Jab": 62.0}, "steps": {"step_in": 65.0}}
	var _r: Dictionary = Specialty.week(f, {}, false)
	_check(f["moves"]["Jab"] == 62.0, "no mutate: f.moves.Jab unchanged")
	_check(f["steps"]["step_in"] == 65.0, "no mutate: f.steps.step_in unchanged")


func _check_floors() -> void:
	# Signature at 85.0 with 0 units -> 83.5 (85 - 1.5, above 70)
	var f: Dictionary = {"moves": {"Jab": 85.0}}
	var r: Dictionary = Specialty.week(f, {}, false)
	_check(abs(r["moves"]["Jab"] - 83.5) < 0.001, "floor: Signature 85, 0u -> 83.5")


func _check_coach_holds() -> void:
	# plan ["Jab", "step_in"], Jab 62, step_in 65, Cross 88, Lead hook 61
	# coach_holds: Jab (plan, 62>=60), Cross (88>=85 Signature), step_in (plan, 65>=60)
	# MoveTree order: PUNCH_IDS then STEP_IDS -> Jab, Cross, step_in
	var f: Dictionary = {"moves": {"Jab": 62.0, "Cross": 88.0, "Lead hook": 61.0}, "steps": {"step_in": 65.0}}
	var ch: Array = Specialty.coach_holds(f, ["Jab", "step_in"])
	_check(ch.size() == 3, "coach_holds: 3 moves")
	_check(ch[0] == "Jab", "coach_holds: [0] Jab")
	_check(ch[1] == "Cross", "coach_holds: [1] Cross")
	_check(ch[2] == "step_in", "coach_holds: [2] step_in")


func _check_dropped() -> void:
	# 60+ moves: Jab 62, Cross 88, Lead hook 61, step_in 65
	# coach_holds: Jab, Cross, step_in -> dropped: Lead hook
	var f: Dictionary = {"moves": {"Jab": 62.0, "Cross": 88.0, "Lead hook": 61.0}, "steps": {"step_in": 65.0}}
	var dr: Array = Specialty.dropped(f, ["Jab", "step_in"])
	_check(dr.size() == 1, "dropped: 1 move")
	_check(dr[0] == "Lead hook", "dropped: Lead hook")


func _check_needs_flag() -> void:
	# Cross 88 with 10 units, holds without Cross -> ["Cross"]
	var f: Dictionary = {"moves": {"Cross": 88.0}}
	var nf: Array = Specialty.needs_flag(f, {"Cross": 10.0}, [], false)
	_check(nf.size() == 1, "needs_flag: 1 flag")
	_check(nf[0] == "Cross", "needs_flag: Cross")

	# frozen -> empty
	var nf2: Array = Specialty.needs_flag(f, {"Cross": 10.0}, [], true)
	_check(nf2.size() == 0, "needs_flag: frozen -> empty")

	# Cross in holds -> not flagged
	var nf3: Array = Specialty.needs_flag(f, {"Cross": 10.0}, ["Cross"], false)
	_check(nf3.size() == 0, "needs_flag: Cross in holds -> empty")


## S457 wiring (Claude): apply() on a real week's inputs, and PadWeek.run_week handing 60+ moves to the hold.
func _check_apply() -> void:
	var f := {"moves": {"Jab": 62.0, "Cross": 88.0}}
	var r: Dictionary = Specialty.apply(f, {}, [], [], 0)
	_check(is_equal_approx(float(f["moves"]["Jab"]), 60.5), "apply: Sharp Jab 62 with no drill -> 60.5")
	_check(is_equal_approx(float(f["moves"]["Cross"]), 86.5), "apply: Signature Cross 88 with no drill -> 86.5")
	_check((r["faded"] as Array).size() == 2, "apply: both in faded")
	f = {"moves": {"Jab": 62.0}}
	Specialty.apply(f, {}, ["Jab"], [], 0)
	_check(is_equal_approx(float(f["moves"]["Jab"]), 62.0), "apply: a carded move (120 bag units) holds")
	f = {"moves": {"Jab": 62.0}, "injury": {"type": "hand", "days_out": 20}}
	Specialty.apply(f, {}, [], [], 0)
	_check(is_equal_approx(float(f["moves"]["Jab"]), 62.0), "apply: injured -> frozen")
	f = {"moves": {"Jab": 62.0}, "phase": "taper"}
	Specialty.apply(f, {}, [], [], 0)
	_check(is_equal_approx(float(f["moves"]["Jab"]), 62.0), "apply: taper -> frozen")
	f = {"moves": {"Jab": 62.0}, "injury": {}}
	Specialty.apply(f, {}, [], ["move:Jab"], 1)
	_check(is_equal_approx(float(f["moves"]["Jab"]), 62.0), "apply: one sparring night on 1 move (180 units) holds")


func _check_run_week() -> void:
	var f := {"moves": {"Jab": 62.0, "Cross": 40.0}}
	var r: Dictionary = PadWeek.run_week(f, {"pads": [], "spar": []}, {}, 50.0, PadWeek.STATION_TIER)
	_check(is_equal_approx(float(f["moves"]["Jab"]), 60.5), "run_week: an undrilled Sharp move fades by the hold (60.5), not decay_week (61.25)")
	_check(is_equal_approx(float(f["moves"]["Cross"]), 39.25), "run_week: under 60 keeps decay_week (40 -> 39.25)")
	_check((r.get("faded", []) as Array).has("Jab"), "run_week: returns faded")
	f = {"moves": {"Jab": 62.0}, "phase": "taper"}
	PadWeek.run_week(f, {"pads": [], "spar": []}, {}, 50.0, PadWeek.STATION_TIER)
	_check(is_equal_approx(float(f["moves"]["Jab"]), 62.0), "run_week: taper week freezes the 60+ move")
