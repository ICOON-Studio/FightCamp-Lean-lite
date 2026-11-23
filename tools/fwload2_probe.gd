extends SceneTree
## FWLOAD2 (S543, ops/research/TASK_FWLOAD2.md, page ops/research/DESIGN_FWLOAD2.md): the fight week's load (Rest up / Tick over
## / Train through) on the GAME's tank and week, with the code-checked critic's two changes as flagged LOCAL rules (nothing
## under scripts/ or tests/ changes). MEASUREMENT ONLY.
##   Path: Bouts.accept -> FightWeekPlan.mark/draft/read/lock -> Sim.step_day each day (WeekPhase.LOAD_WEEKS, so tiredness
##   carries as the game carries it) -> Bouts.fight_step (BoutNight._peak calls BoutRules.tank_parts_for: stale NOT pre-set).
##   Rule arms: TODAY (control) and CHANGED:
##     bank_first  the week's pad work with the stop's bank (DrillWeek.run on a copy, fw_bank as locked) lands on the plan's
##                 combinations BEFORE the bell; a line crossing FireLevel.USABLE_AT fires at its new level in this bout.
##                 (Restored after the bout: the game's own Sunday drilling still adds it, so nothing is counted twice.)
##     r1_read     Rest up's flat round costs fast_edge (-3) against a fast starter and 0 against a slow one (replaces
##                 FightWeek.REST_UP_EDGE's tiredness bands).
##   Cells: start tiredness 35/50/58/66 x a plan line near Usable yes/no x the opponent a fast/slow starter (16) + a bout
##   six days before at 58 (17, 18). Every cell plays all three loads on the same boxer, opponent and bout dice (paired),
##   and each load's week is fought twice from one snapshot (TODAY, CHANGED). Policies (pick as built, pick with the
##   facts, the reader) choose one of the three, read from state at the booking.
##   mode=cells n=100 | mode=career n=12 (8 weekly bouts per career and arm; bar 5) | mode=trial (one run a cell, printed)
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/fwload2_probe.gd -- mode=cells n=100
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const FightWeekPick := preload("res://scripts/rules/FightWeekPick.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Report := preload("res://tools/fwload2_report.gd")
const STATS := ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]
const LOADS := ["rest_up", "tick_over", "train_through"]
const RULES := ["today", "changed"]
const POLS := ["rest", "tick", "through", "pick", "pickf", "reader"]
## The plan: three combination lines. 1-2 Sharp, 3b-3 Usable, 1-1-2 the line near (or far from) Usable.
const ARROWS := ["1-2", "3b-3", "1-1-2"]
const MAST := [70.0, 45.0]
var near_m := 26.0      # 1-1-2 "near": the trial measured a full week +4.9 by the bell, half +2.5: 26 crosses only on a full bank
const FAR_M := 10.0     # 1-1-2 "far": no week takes it to Usable
const NEAR_GAP := 5.0   # the reader's and the pick's "a week from Usable": 30 - mastery <= this (one full week, trial)
const BOUT_DOW := 5     # club shows are Saturdays (Data.SHOW_FIRST_DAY 12, day 0 a Monday)
const OFFS := [-3.0, -1.5, 0.0, 1.5, 3.0, -2.0, 2.0]   # the opponent's rating against our fight power (+ cal)
const OPP_NAMES := ["Chloe Bennett", "Sophie Turner", "Megan Hughes", "Holly Price", "Ellie Ward", "Aisha Rahman"]
const CELLS := [[35, true, "fast", false], [35, true, "slow", false], [35, false, "fast", false], [35, false, "slow", false],
	[50, true, "fast", false], [50, true, "slow", false], [50, false, "fast", false], [50, false, "slow", false],
	[58, true, "fast", false], [58, true, "slow", false], [58, false, "fast", false], [58, false, "slow", false],
	[66, true, "fast", false], [66, true, "slow", false], [66, false, "fast", false], [66, false, "slow", false],
	[58, true, "fast", true], [58, false, "slow", true]]

var mode := "cells"
var n := 100
var cal := 0.0
var fast_edge := -3.0
var only := -1
var c: Career
var rivals0: Array = []
var cash0 := 0
var pop: Array = []
var rows: Array = []      # one row per (cell, i): {cell, i, picks {pol: load}, out {rule|load: {...}}}
var mism := 0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() != 2:
			continue
		match kv[0]:
			"mode": mode = kv[1]
			"n": n = int(kv[1])
			"cal": cal = float(kv[1])
			"fast_edge": fast_edge = float(kv[1])
			"near": near_m = float(kv[1])
			"only": only = int(kv[1])
	c = Career.quick_start()
	c.seed = 4421
	rivals0 = c.rivals.duplicate(true)
	cash0 = c.cash
	_population()
	var t0 := Time.get_ticks_msec()
	print("FWLOAD2 mode=%s n=%d cal=%.1f fast_edge=%.1f near=%.0f far=%.0f near_gap=%.0f" % [mode, n, cal, fast_edge, near_m, FAR_M, NEAR_GAP])
	if mode == "career":
		_careers()
	else:
		var reps := 1 if mode == "trial" else n
		for ci in CELLS.size():
			if only >= 0 and ci != only:
				continue
			for i in reps:
				rows.append(_cell_run(ci, i))
		print("FWLOAD2 WALL %.0f s, %d cell-runs, mismatch skips %d" % [(Time.get_ticks_msec() - t0) / 1000.0, rows.size(), mism])
		Report.cells(rows, CELLS, POLS, LOADS, mode == "trial")
	print("FWLOAD2 DONE %.0f s" % ((Time.get_ticks_msec() - t0) / 1000.0))
	quit(0)


## 24 boxers: Data.lucy re-rated to fight power 54-66, every stat +-3, chin 58-72, w 2-6 (never two identical).
func _population() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 4421
	for k in 24:
		var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
		var p0 := BoutRules.fight_power(f["stats"], {}, 0, "")
		var target := 54.0 + rng.randf() * 12.0
		for s in STATS:
			f["stats"][s] = float(f["stats"][s]) + target - p0 + rng.randf_range(-3.0, 3.0)
		f["stats"]["chin"] = 58.0 + rng.randf() * 14.0
		f["id"] = "fw%02d" % k
		f["w"] = 2 + k % 5
		f["l"] = k % 3
		f["weight"] = float(f["limit"])
		f["morale"] = 55.0 + rng.randf() * 10.0
		pop.append(f)


func _fresh(k: int, day: int) -> Dictionary:
	var f: Dictionary = (pop[k % pop.size()] as Dictionary).duplicate(true)
	for key in ["sparred", "arrows", "last_bout_day", "stand_down", "week_nights", "phase", "week_edits", "fw_bank", "pad_week"]:
		f.erase(key)
	f["bout"] = {}; f["camp"] = {}; f["injury"] = {}; f["ko_history"] = []; f["offers"] = []
	f["arrows"] = []
	f["combos"] = (f.get("combos", {}) as Dictionary).duplicate()
	return f


func _set_plan(f: Dictionary, near: bool) -> void:
	var m := MAST + [near_m if near else FAR_M]
	for k in ARROWS.size():
		var cid := str(StrikeMap.move(ARROWS[k]).get("combo", ""))
		if cid != "":
			f["combos"][cid] = float(m[k])
		(f["arrows"] as Array).append({"move": ARROWS[k]})


## The opponent: a named rival of the women's lightweight sheet, re-rated, filed as a fast or a slow starter.
func _opp(f: Dictionary, i: int, start: String) -> Dictionary:
	var o: Dictionary = c.rival(str(OPP_NAMES[i % OPP_NAMES.size()])).duplicate(true)
	o["rating"] = BoutRules.fight_power(f["stats"], {}, 0, "") + cal + float(OFFS[i % OFFS.size()])
	o["w"] = int(f["w"]); o["l"] = int(f["l"])
	o["weight"] = float(f["limit"])
	if start == "slow":
		o["style"] = "Counter-puncher"; o["weak"] = "Slow to start"; o["habits"] = ["slow_starter"]
	else:
		o["style"] = "Pressure fighter"; o["weak"] = "Leaves the chin open"; o["habits"] = ["chases_stoppage"]
		o["threat"] = "Fast starter, throws from the first bell"
	o["round1"] = start   # the probe's file field: what OppFile would read as the opponent's start
	return o


## Books f for a bout 7 days out (a Saturday) against opp. False when the booking is refused.
func _book(f: Dictionary, opp: Dictionary) -> bool:
	var on := c.day + 7
	var oid := "%s:o%d" % [str(f["id"]), c.day]
	f["offers"] = [Bouts._offer(oid, opp, on, c.day + Bouts.OFFER_ANSWER_DAYS, int(f["w"]) + int(f["l"]))]
	return Bouts.accept(c, oid)


func _near(f: Dictionary) -> bool:
	for a in f.get("arrows", []):
		var m := FireLevel.mastery_of(f, str(a["move"]))
		if m < FireLevel.USABLE_AT and FireLevel.USABLE_AT - m <= NEAR_GAP:
			return true
	return false


## What each policy picks from the state at the booking (the screen's facts).
func _picks(f: Dictionary) -> Dictionary:
	var t := FightWeekPlan.tired(f)
	var near := _near(f)
	var start := str((f["bout"]["opp"] as Dictionary).get("round1", ""))
	var built := str(FightWeekPlan.draft(c, f)["stop"])
	var facts := {"start_tired": t, "tank_weight": 0, "opp_round1": start, "near_usable": near,
		"rating_gap": float(f["bout"]["opp"].get("rating", 0.0)) - FightWeekPlan.rating_of(f)}
	var full := str(FightWeekPick.best_stop(facts)["stop"])
	return {"rest": "rest_up", "tick": "tick_over", "through": "train_through", "pick": built, "pickf": full,
		"reader": _reader(t, near, start)}


## THE READER (DESIGN_FWLOAD2 s5, written before any run): "Train through when a plan line is a week from Usable and she
## is under 58 tired; Rest up when the opponent starts slow or she is 58 or more tired; otherwise Tick over."
func _reader(t: int, near: bool, start: String) -> String:
	if near and t < 58:
		return "train_through"
	if start == "slow" or t >= 58:
		return "rest_up"
	return "tick_over"


func _reset(day: int) -> void:
	c.rivals = rivals0.duplicate(true)
	c.news.clear(); c.results.clear(); c.favours = {}; c.cash = cash0
	c.day = day


## One cell, one boxer: the three loads, each week run once and fought under both rule arms on the same dice.
func _cell_run(ci: int, i: int) -> Dictionary:
	var cl: Array = CELLS[ci]
	var d0 := 7 * (3 + i % 20) + BOUT_DOW   # a Saturday, booking 7 days before the bout
	var row := {"cell": ci, "i": i, "picks": {}, "out": {}}
	for load in LOADS:
		_reset(d0)
		var f := _fresh(i, d0)
		f["id"] = "fw_c%d_i%d" % [ci, i]
		_set_plan(f, bool(cl[1]))
		f["week_fatigue"] = float(cl[0])
		if bool(cl[3]):
			f["last_bout_day"] = d0 + 7 - 6
		c.fighters = [f]
		if not _book(f, _opp(f, i, str(cl[2]))):
			mism += 1
			return row
		if (row["picks"] as Dictionary).is_empty():
			row["picks"] = _picks(f)
		var wk := _week(f, str(load))
		for rule in RULES:
			var fx: Dictionary = (wk["f"] as Dictionary).duplicate(true)
			var o := _fight(fx, str(rule), 1000000 + ci * 10000 + i, int(wk["day"]))
			o.merge(wk["info"])
			row["out"]["%s|%s" % [rule, load]] = o
	return row


## Locks the load (no sparring night) and runs the 7 days through the game's own day loop.
func _week(f: Dictionary, load: String) -> Dictionary:
	var plan := FightWeekPlan.draft(c, f)
	plan["stop"] = load
	plan["nights"] = {}
	plan["eat_less"] = false
	plan["film"] = false
	var r := FightWeekPlan.read(c, f, plan)
	var why := FightWeekPlan.lock(c, f, plan)
	var info := {"lock": why, "tank_lock": float((r["tank"] as Dictionary)["off"]), "t0": FightWeekPlan.tired(f), "pulled": false}
	var on := int(f["bout"]["day"])
	while c.day < on:
		Sim.step_day(c)
		if (f.get("bout", {}) as Dictionary).is_empty() or not (f.get("injury", {}) as Dictionary).is_empty():
			info["pulled"] = true
			break
	if not bool(info["pulled"]):
		f["bout"]["weighed"] = true
		f["bout"]["made"] = true
	info["t_bell"] = float(f.get("week_fatigue", 20.0))
	info["tank_read"] = float((FightWeekPlan.read(c, f, plan)["tank"] as Dictionary)["off"]) if not bool(info["pulled"]) else -1.0
	info["tank_game"] = float(BoutRules.tank_parts_for(c.results, f, float(info["t_bell"]), on)["off"]) if not bool(info["pulled"]) else -1.0
	return {"f": f, "day": c.day, "info": info}


## The game's bout. CHANGED lays the two local rules on the bout before the bell; TODAY leaves it as locked.
func _fight(f: Dictionary, rule: String, dice: int, real_day: int) -> Dictionary:
	var out := {"fought": false, "won": false, "stale": -1.0, "m112": 0.0, "fired_lvl": "", "tank_end": 0.0, "toll": 0.0}
	if (f.get("bout", {}) as Dictionary).is_empty() or not (f.get("injury", {}) as Dictionary).is_empty():
		return out
	c.day = real_day
	c.fighters = [f]
	c.results.clear()
	var b: Dictionary = f["bout"]
	var keep := (f["combos"] as Dictionary).duplicate()
	if rule == "changed":
		var cp: Dictionary = f.duplicate(true)
		DrillWeek.run(c, cp)   # the week's pads with this stop's bank (fw_bank, as locked)
		for a in ARROWS:
			var cid := str(StrikeMap.move(a).get("combo", ""))
			if cid != "":
				f["combos"][cid] = maxf(float(f["combos"].get(cid, 0.0)), float((cp["combos"] as Dictionary).get(cid, 0.0)))
		if str(b.get("load", "")) == "rest_up":
			b["r1_edge"] = fast_edge if str((b["opp"] as Dictionary).get("round1", "")) == "fast" else 0.0
	out["m112"] = FireLevel.mastery_of(f, "1-1-2")
	out["r1_edge"] = float(b.get("r1_edge", 0.0))
	c.day = dice
	var m := {"fid": str(f["id"]), "step": "tape", "total": Bouts.rounds_of(f)}
	Bouts.fight_step(c, f, m, "start")
	out["stale"] = float(b.get("stale", -1.0))
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")
	out["fought"] = true
	out["won"] = str(m.get("outcome", "")) == "win"
	var used := 0
	for r in m.get("rounds", []):
		for x in (r as Dictionary).get("exchanges", []):
			if str((x as Dictionary).get("arrow", "")) == "1-1-2" and bool(x.get("planned", false)):
				used += 1
	out["used112"] = used
	out["toll"] = float(f.get("week_fatigue", 0.0))
	c.day = real_day
	c.results.clear()
	for k in keep:
		f["combos"][k] = keep[k] if rule == "changed" else f["combos"][k]
	return out


## Bar 5: 8 weekly bouts per career, every policy and rule arm; tiredness and the tank at each bell.
func _careers() -> void:
	var table := {}
	for rule in RULES:
		for pol in POLS:
			var tb: Array = []
			for w in 8:
				tb.append([])
			for k in n:
				_reset(7 * 3 + BOUT_DOW)
				var f := _fresh(k, c.day)
				f["id"] = "fw_k%d" % k
				_set_plan(f, k % 2 == 0)
				f["week_fatigue"] = 35.0 + float(k % 4) * 10.0
				c.fighters = [f]
				for w in 8:
					var start := "fast" if (k + w) % 2 == 0 else "slow"
					if not _book(f, _opp(f, k * 8 + w, start)):
						mism += 1
						break
					var pk: String = str(_picks(f)[pol])
					var wk := _week(f, pk)
					var o := _fight(f, str(rule), 3000000 + k * 100 + w, int(wk["day"]))
					(tb[w] as Array).append({"t_bell": float(wk["info"]["t_bell"]), "stale": float(o["stale"]), "won": bool(o["won"]),
						"fought": bool(o["fought"]), "load": pk})
					f["offers"] = []
			table["%s|%s" % [rule, pol]] = tb
	Report.careers(table, RULES, POLS)
