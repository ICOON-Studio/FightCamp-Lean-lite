extends RefCounted
## TREEVALUE2 cells (S522, map ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md section 9 gate 2):
## one bout, one cell, the gate's three legs, the FAIL line and the result doc. tools/treevalue_probe.gd drives them.
## A cell = the plan WITH the step's line against the SAME plan without that line, same seeds, same fighter.
## The step fights at Sharp (StepMastery 60) and OK grade: LineGrade's DONE_WITH pair mean set to OK_PAIR
## (Exchanges.OK_AT 50 <= 56 < GOOD_AT 62). LineGrade's rule is the one the live round reads (map 4.2 CHECK: the code wins).
## No fire_level key on the bout: FireLevel.GAME_SHARES (a Sharp line fires 3 in 4).
## fires = exchanges where the step's arrow was PLANNED (the FireLevel roll came off); uses = thrown either way.

const Bouts := preload("res://scripts/state/Bouts.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StepValue := preload("res://scripts/rules/StepValue.gd")
const StepEffect := preload("res://scripts/rules/StepEffect.gd")

## Both attributes of the graded pair at this value: mean 56 = OK.
const OK_PAIR := 56.0


## One amateur 3x3 bout. make_fighter = the probe's TREEVALUE1 factory (seed -> fighter_state).
## Returns {outcome, fires, uses} for the graded step.
static func run_bout(make_fighter: Callable, seed_start: int, n_fighters: int, seed_offset: int,
		opp: Dictionary, plan: Array, moves: Dictionary, steps: Dictionary, combos: Dictionary,
		grade_step: String) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(make_fighter.call(seed_start + (seed_offset % n_fighters)))
	c.day = 40 + seed_offset
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["morale"] = 60.0
	f["moves"] = moves.duplicate()
	f["steps"] = steps.duplicate()
	f["combos"] = combos.duplicate()
	f["arrows"] = plan.duplicate(true)
	c.coach = {}
	if grade_step != "" and LineGrade.DONE_WITH.has(grade_step):
		var a := Attrs.of(f)
		var pair: Array = LineGrade.DONE_WITH[grade_step]
		a[str(pair[0])] = OK_PAIR
		a[str(pair[1])] = OK_PAIR
		Attrs.sync(f)
	f["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	Bouts.fight_step(c, f, m, "sim")
	var fires := 0
	var uses := 0
	var wrong := 0   # S531 phase 5b: planned fires whose step fit vs her game this exchange was "wrong"
	for r in m["rounds"]:
		for x in (r as Dictionary)["exchanges"]:
			if PlanFight.base_id(str((x as Dictionary).get("arrow", ""))) == grade_step:
				uses += 1
				fires += 1 if bool((x as Dictionary).get("planned", false)) else 0
				wrong += 1 if bool((x as Dictionary).get("planned", false)) and str((x as Dictionary).get("step_fit", "")) == "wrong" else 0
	return {"outcome": str(m.get("outcome", "")), "fires": fires, "uses": uses, "wrong": wrong}


## n bouts from seed_base (the seed set's offset + the bout index). Same seeds in both arms of a cell.
static func run_cell(make_fighter: Callable, seed_start: int, n_fighters: int, seed_base: int, n: int,
		opp: Dictionary, plan: Array, moves: Dictionary, steps: Dictionary, combos: Dictionary,
		grade_step: String) -> Dictionary:
	var wins := 0
	var fires := 0
	var uses := 0
	var wrong := 0
	for i in n:
		var r := run_bout(make_fighter, seed_start, n_fighters, seed_base + i, opp, plan, moves, steps, combos, grade_step)
		wins += 1 if str(r["outcome"]) == "win" else 0
		fires += int(r["fires"])
		uses += int(r["uses"])
		wrong += int(r.get("wrong", 0))
	return {"wins": wins, "fires": fires, "uses": uses, "n": n, "wrong": wrong}


## The gate's three legs for one step from its six measured cells: best style in 1.5-5, wrong style negative,
## every other style 0 to +1. cells = {style: {"delta": wins in 100}}.
static func legs(step: String, cells: Dictionary) -> Dictionary:
	var best: String = StepValue.best_style(step)
	var wrong: String = StepValue.wrong_style(step)
	var bv: float = float(cells[best]["delta"])
	# S531 (STEPTUNE3 s2): since phase 3 four steps have no wrong style (feint, tie_up, roll_out, push_off); their wrong
	# leg does not exist - it passes, and the two legs that exist decide (it used to read cells[""] and abort the summary).
	var wv: float = float(cells[wrong]["delta"]) if wrong != "" and cells.has(wrong) else -1.0
	var best_ok: bool = bv >= 1.5 and bv <= 5.0
	var wrong_ok: bool = wv < 0.0
	var others_ok: bool = true
	var worst_other := ""
	for style in StepValue.STYLES:
		var s: String = str(style)
		if s == best or s == wrong:
			continue
		var v: float = float(cells[s]["delta"])
		if v < 0.0 or v > 1.0:
			others_ok = false
			if worst_other == "":
				worst_other = s
	return {"best": best, "wrong": wrong, "best_ok": best_ok, "wrong_ok": wrong_ok, "others_ok": others_ok,
		"worst_other": worst_other, "pass": best_ok and wrong_ok and others_ok}


## One line per FAIL naming the StepEffect row that would move the step (read at runtime, never changed).
static func fail_line(step: String, cells: Dictionary, lg: Dictionary) -> String:
	var row: Dictionary = StepEffect.effect(step)
	var parts: Array = []
	for k in ["deny", "open", "drain", "opp_steps_less", "opp_counter_edge", "self_tank", "tank", "wrong_extra_damage"]:
		if float(row.get(k, 0.0)) != 0.0:
			parts.append("%s %.2f" % [k, float(row[k])])
	for k in ["ropes", "opp_ropes"]:
		if int(row.get(k, 0)) != 0:
			parts.append("%s %+d" % [k, int(row[k])])
	for k in ["clears_ropes", "ends_early"]:
		if bool(row.get(k, false)):
			parts.append(k)
	for k in ["distance", "break_to", "deny_on", "open_on"]:
		if str(row.get(k, "")) != "":
			parts.append("%s %s" % [k, str(row[k])])
	var why: Array = []
	if not bool(lg["best_ok"]):
		why.append("best cell %s %+.1f outside 1.5-5" % [str(lg["best"]), float(cells[str(lg["best"])]["delta"])])
	if not bool(lg["wrong_ok"]):
		why.append("wrong cell %s %+.1f not negative" % [str(lg["wrong"]), float(cells[str(lg["wrong"])]["delta"])])
	if not bool(lg["others_ok"]):
		why.append("other styles outside 0 to +1 (first: %s)" % str(lg["worst_other"]))
	return "FAIL %s: StepEffect.TABLE.%s (%s) is the row that would move it - %s. Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet." % [
		step, step, ", ".join(parts), "; ".join(why)]


## docs/TREEVALUE2_RESULT.md: the 10x6 table (measured beside TARGET, fires beside both), the legs, the count, the FAIL lines.
static func write_doc(report: Dictionary) -> void:
	var f := FileAccess.open("res://docs/TREEVALUE2_RESULT.md", FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write result doc")
		return
	var results: Dictionary = report["results"]
	var n_bouts: int = int(report["n_bouts"])
	var seed_sets: Array = report["seed_sets"]
	f.store_line("# TREEVALUE2 Result")
	f.store_line("")
	f.store_line("Probe run: %s. %d bouts a cell per arm per seed set, %d seed sets (S427), amateur 3x3, %d fighters, 6 style opponents." % [
		str(report["dt"]), n_bouts, seed_sets.size(), int(report["n_fighters"])])
	f.store_line("")
	f.store_line("## Question")
	f.store_line("")
	f.store_line("Is each footwork / defence step worth 1.5-5 in 100 against its own style? (map section 9 gate 2)")
	f.store_line("Each step at Sharp mastery (StepMastery 60) and OK grade: the plan WITH its line minus the SAME plan without it,")
	f.store_line("win difference in 100. Gate: its best style's cell in 1.5-5 (the section 5 targets within +-1); its wrong style negative; the others 0 to +1.")
	f.store_line("")
	f.store_line("## Method")
	f.store_line("")
	f.store_line("- Fighters: TREEVALUE1's factory, seeds %d-%d (the same 60 in every seed set; the sets shift the fight-night dice)." % [
		int(report["seed_start"]), int(report["seed_start"]) + int(report["n_fighters"]) - 1])
	f.store_line("- Seed sets (day offsets): %s. A cell's value is the mean of its %d seed-set deltas; each arm fights the same seeds." % [str(seed_sets), seed_sets.size()])
	f.store_line("- Plan: TREEVALUE1's PLAN with its S464 surgery per step (_plan_for): the swept step planned ANY TIME on its card,")
	f.store_line("  the other arrows sharing its `when` left out; the without-arm is that same plan minus the step's line. Nothing else differs.")
	f.store_line("- Mastery: the swept step at 60 (Sharp, fires 3 in 4), every other line at 45 (Usable, 1 in 2). fire_level key ABSENT = GAME_SHARES.")
	f.store_line("- Grade: OK forced on the swept step by setting both LineGrade.DONE_WITH attributes to %.0f (mean %.0f: OK_AT 50 <= %.0f < GOOD_AT 62)." % [OK_PAIR, OK_PAIR, OK_PAIR])
	f.store_line("  LineGrade's rule is the one the live round reads; StepEffect.grade_for (the map 4.2 ability pairs) is not wired into the bout.")
	f.store_line("- Opponents: shipped roster, one per style (OPPS + MISMATCH + RIVALS' Holly Price and Jade Cooper). Ratings CALIBRATED so the full")
	f.store_line("  BASE plan wins about half: %s." % str(report["opp_rating"]))
	f.store_line("- fires/bout = exchanges where the step's arrow was PLANNED (the FireLevel roll came off), with-arm, over all %d bouts of the cell." % (n_bouts * seed_sets.size()))
	f.store_line("  A 0.0 delta with fires 0 means the line never came off; with fires > 0 it fired and did nothing.")
	f.store_line("- What the bout reads of StepEffect today: only the ropes count (StepWire). The deny/open/drain sizes are NOT in the exchange;")
	f.store_line("  a step's fight edge comes from PlanFight.ANSWERS fit through LineGrade, plus the ropes place it opens.")
	f.store_line("")
	f.store_line("## Controls")
	f.store_line("")
	f.store_line("- Determinism: the same cell twice -> %d and %d wins (fires %d / %d). %s" % [
		int(report["det"]["a"]), int(report["det"]["b"]), int(report["det"]["fa"]), int(report["det"]["fb"]),
		"OK" if int(report["det"]["a"]) == int(report["det"]["b"]) else "FAILED"])
	f.store_line("- OK grade on every swept step: %s." % ("yes" if bool(report["grade_ok"]) else "NO"))
	f.store_line("- Without-arm planned fires of the swept step (must be 0, the line is out): %d." % int(report["without_fires"]))
	f.store_line("- Calibration control win shares (full BASE plan, 120 bouts): %s." % str(report["calib_wins"]))
	f.store_line("")
	f.store_line("## Result: measured win difference in 100 (TARGET beside it, fires/bout beside both)")
	f.store_line("")
	var header := "| Step |"
	for style in StepValue.STYLES:
		header += " %s |" % str(style)
	f.store_line(header)
	var sep := "|------|"
	for _s in StepValue.STYLES:
		sep += "------|"
	f.store_line(sep)
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var cells: Dictionary = results[sid]["cells"]
		var line := "| %s |" % sid
		for style in StepValue.STYLES:
			var s: String = str(style)
			var cell: Dictionary = cells[s]
			var target: float = float(StepValue.TARGET[sid][s])
			line += " %+.1f (t%+.1f) f%.2f |" % [float(cell["delta"]), target, float(cell["fires"]) / float(cell["n"])]
		f.store_line(line)
	f.store_line("")
	f.store_line("## Per step: the gate's three legs")
	f.store_line("")
	var pass_count := 0
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var cells: Dictionary = results[sid]["cells"]
		var lg: Dictionary = legs(sid, cells)
		if bool(lg["pass"]):
			pass_count += 1
		f.store_line("- %s: best %s %+.1f in 1.5-5: %s; wrong %s %+.1f negative: %s; others 0 to +1: %s -> **%s**" % [
			sid, str(lg["best"]), float(cells[str(lg["best"])]["delta"]), "yes" if bool(lg["best_ok"]) else "NO",
			str(lg["wrong"]), float(cells[str(lg["wrong"])]["delta"]), "yes" if bool(lg["wrong_ok"]) else "NO",
			"yes" if bool(lg["others_ok"]) else "NO", "PASS" if bool(lg["pass"]) else "FAIL"])
	f.store_line("")
	f.store_line("**TREEVALUE2 pass=%d/10**" % pass_count)
	f.store_line("")
	f.store_line("## One line per FAIL: the StepEffect row that would move it (never changed here)")
	f.store_line("")
	var any_fail := false
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var lg: Dictionary = legs(sid, results[sid]["cells"])
		if not bool(lg["pass"]):
			any_fail = true
			f.store_line("- %s" % fail_line(sid, results[sid]["cells"], lg))
	if not any_fail:
		f.store_line("- none")
	f.store_line("")
	f.store_line("## Seed spread (the best style's cell, delta per seed set)")
	f.store_line("")
	f.store_line("| Step | Best style | %s | mean |" % " | ".join(seed_sets.map(func(x): return "set %d" % int(x))))
	f.store_line("|------|-----------|------|------|------|------|")
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var lg: Dictionary = legs(sid, results[sid]["cells"])
		var cell: Dictionary = results[sid]["cells"][str(lg["best"])]
		var line := "| %s | %s |" % [sid, str(lg["best"])]
		for d in cell["seeds"]:
			line += " %+.1f |" % float(d)
		line += " %+.1f |" % float(cell["delta"])
		f.store_line(line)
	f.store_line("")
	f.store_line("## Without-arm win share (saturation check: a cell near 0 or 100 cannot show a step's worth)")
	f.store_line("")
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var line := "- %s:" % sid
		for style in StepValue.STYLES:
			var cell: Dictionary = results[sid]["cells"][str(style)]
			line += " %s %.2f" % [str(style).left(8), float(cell["without"]) / float(cell["n"])]
		f.store_line(line)
	f.store_line("")
	f.store_line("Elapsed: %.0f s. Reproduce: `python ops/Tools/godot_slot.py run --who treevalue2 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd`" % float(report["elapsed_s"]))
	f.close()
	print("Result doc written to docs/TREEVALUE2_RESULT.md")
