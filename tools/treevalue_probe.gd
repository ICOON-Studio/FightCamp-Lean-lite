extends SceneTree
## TREEVALUE2 (S522): is each footwork / defence step worth 1.5-5 in 100 against its own style?
## Map ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md section 9 gate 2. For each of StepValue.STEPS x StepValue.STYLES:
## 400 bouts a cell x 3 seed sets (the S427 convention), amateur 3x3, the step at Sharp mastery (StepMastery 60) and OK grade,
## the plan WITH its line against the SAME plan without that line. Win difference in 100 per cell; fires/bout beside it.
## Keeps TREEVALUE1's tables (OPPS, PLAN, the fighter factory, _plan_for's S464 plan surgery); cells live in treevalue_cells.gd.
## No fire_level key on the bout (absent = FireLevel.GAME_SHARES). Gate FAILs are findings, not a failed run: the probe
## quits 0 when it measured and its controls hold, 1 only when a control breaks.
## Usage: python ops/Tools/godot_slot.py run --who treevalue2 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const StepMastery := preload("res://scripts/rules/StepMastery.gd")
const StepValue := preload("res://scripts/rules/StepValue.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const Cells := preload("res://tools/treevalue_cells.gd")

## TREEVALUE1's four opponents (kept); TREEVALUE2 adds the two RIVALS below for the six styles of StepValue.STYLES.
const OPPS := [
	{"name": "Maria Ortega", "style": "Pressure fighter"},
	{"name": "Priya Nair", "style": "Counter-puncher"},
	{"name": "Erin Doyle", "style": "Volume puncher"},
	{"name": "Dana Whitfield", "style": "Boxer-puncher"},
]
## One shipped opponent per style: OPPS + MISMATCH + RIVALS (Holly Price, Jade Cooper).
const STYLE_OPP := {
	"Pressure fighter": "Maria Ortega",
	"Slugger": "Jade Cooper",
	"Out-boxer": "Holly Price",
	"Counter-puncher": "Priya Nair",
	"Volume puncher": "Erin Doyle",
	"Boxer-puncher": "Dana Whitfield",
}
## TREEVALUE1's plan: arrows covering every punch via combos, plus every step/defence in the situation table.
const PLAN := [
	{"move": "step_back"},
	{"move": "pivot_out"},
	{"move": "tie_up"},
	{"move": "roll_out", "when": "loadup"},
	{"move": "push_off", "when": "press"},
	{"move": "1-1-2", "when": "press"},
	{"move": "2-3", "when": "range"},
	{"move": "1-2-3b", "when": "range"},
	{"move": "1-6-3", "when": "counter"},
	{"move": "slip 2-3", "when": "loadup"},
	{"move": "3b-3", "when": "tiring"},
	# S464 Claude: the five nodes the first run never planned, each where PlanFight.ANSWERS calls it best (step_out: she_tired)
	{"move": "step_in", "when": "range"},
	{"move": "feint", "when": "counter"},
	{"move": "cut_off", "when": "tiring"},
	{"move": "herd", "when": "hurt"},
	{"move": "step_out", "when": "she_tired"},
]
const BASE_VAL := 45.0
const N_FIGHTERS := 60
const SEED_START := 7100
## TREEVALUE2: 400 bouts a cell per arm, three seed sets (day offsets; 10000 % 60 shifts the fighter phase too).
const N_BOUTS := 400
const SEED_SETS := [0, 10000, 20000]
const SHARP := 60.0
## Each style's rating is CALIBRATED so the full BASE plan wins about half its bouts (TREEVALUE1's S464 rule: a floor
## no step can show a value against). Style, threat and plan stay the opponent's.
var opp_rating := {}


func _plan_for(nid: String) -> Array:
	var mine := ""
	for a in PLAN:
		if str(a["move"]) == nid:
			mine = str(a.get("when", ""))
	if mine == "":
		return PLAN.duplicate(true)
	# S464 second fix: an arrow fires only on its OWN card (StrikeMap "from") at its when (PlanBoard.pick); "range" is fought on
	# the long card while step_in starts from outside, so a planned "step_in:range" can never fire. The swept node is planned
	# ANY TIME here (its when dropped), like step_back / pivot_out / tie_up, so it fires whenever the bout reaches its card.
	var out: Array = PLAN.filter(func(a): return str(a["move"]) == nid or str(a.get("when", "")) != mine).duplicate(true)
	for a in out:
		if str(a["move"]) == nid:
			a.erase("when")
	return out


func _find_opp(name: String) -> Dictionary:
	for opp in Data.OPPONENTS:
		if str(opp["name"]) == name:
			return (opp as Dictionary).duplicate(true)
	if Data.MISMATCH["name"] == name:
		return (Data.MISMATCH as Dictionary).duplicate(true)
	for opp in Data.RIVALS:
		if str(opp["name"]) == name:
			return (opp as Dictionary).duplicate(true)
	return {}


## Generate a varied fighter from a seed (TREEVALUE1's factory, kept). Returns a fighter_state dict.
func _make_fighter(seed_val: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	var prof := AttrGen.generate(rng)
	var style_name: String = AttrGen.style_word(prof)
	var first_names := ["Alex", "Sam", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Quinn", "Avery", "Skyler",
		"Jamie", "Drew", "Blake", "Cameron", "Dakota", "Emerson", "Finley", "Harper", "Hayden", "Jesse",
		"Kai", "Lane", "Logan", "Parker", "Reese", "Rowan", "Sage", "Spencer", "Tatum", "Winter"]
	var last_names := ["Smith", "Jones", "Brown", "Wilson", "Taylor", "Davies", "Evans", "Thomas", "Roberts", "Johnson",
		"Walker", "Wright", "Robinson", "White", "Thompson", "Moore", "Clark", "Lewis", "Hall", "Young",
		"King", "Baker", "Lee", "Green", "Adams", "Nelson", "Mitchell", "Harris", "Turner", "Fox"]
	var first: String = str(first_names[rng.randi_range(0, first_names.size() - 1)])
	var last: String = str(last_names[rng.randi_range(0, last_names.size() - 1)])
	var technique := clampf(50.0 + prof["shape"].get("accuracy", 0.0) * 0.5 + rng.randf_range(-5.0, 5.0), 30.0, 80.0)
	var fight_iq := clampf(50.0 + prof["shape"].get("fight_iq", 0.0) * 0.5 + rng.randf_range(-5.0, 5.0), 30.0, 80.0)
	var footwork := clampf(50.0 + prof["shape"].get("footwork", 0.0) * 0.5 + rng.randf_range(-5.0, 5.0), 30.0, 80.0)
	var f := {
		"id": "tv_%d" % seed_val,
		"name": "%s %s" % [first, last],
		"first": first,
		"sex": "f",
		"age": 22 + rng.randi_range(-3, 5),
		"wc": "Lightweight",
		"limit": 60.0,
		"weight": 60.0 + rng.randf_range(-1.0, 1.0),
		"stance": "orthodox" if rng.randf() < 0.7 else "southpaw",
		"style": style_name,
		"w": 3 + rng.randi_range(0, 5),
		"l": 1 + rng.randi_range(0, 3),
		"pot": 70 + rng.randi_range(-10, 15),
		"cards": [],
		"focus": "conditioning",
		"div": "wlw",
		"diet": "hold",
		"fatigue": 8,
		"weekly_salary": 250,
		"booked_fight": false,
		"history": [],
		"stats": {
			"power": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"speed": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"technique": technique,
			"defense": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"conditioning": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"fight_iq": fight_iq,
			"chin": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
		},
		"goal": {},
		"shape": prof["shape"],
		"pace": float(prof["pace"]),
		"forward": float(prof["forward"]),
		"heart": float(prof["heart"]),
		"footwork": footwork,
	}
	return Data.fighter_state(f, 40 + (seed_val - SEED_START))


func _base_dict() -> Dictionary:
	var moves := {}; var steps := {}; var combos := {}
	for k in Data.MOVES:
		moves[k] = BASE_VAL
	for k in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS:
		steps[k] = BASE_VAL
	for k in MoveTree.COMBO_PUNCHES:
		combos[k] = BASE_VAL
	return {"moves": moves, "steps": steps, "combos": combos}


## The cell's opponent with its calibrated rating.
func _opp_for(style: String) -> Dictionary:
	var opp := _find_opp(str(STYLE_OPP[style]))
	if opp_rating.has(str(opp["name"])):
		opp["rating"] = float(opp_rating[str(opp["name"])])
	return opp


func _cell(plan: Array, opp: Dictionary, base: Dictionary, step: String, seed_base: int, n: int) -> Dictionary:
	var steps: Dictionary = (base["steps"] as Dictionary).duplicate()
	if step != "":
		steps[step] = SHARP
	return Cells.run_cell(Callable(self, "_make_fighter"), SEED_START, N_FIGHTERS, seed_base, n, opp, plan,
		base["moves"], steps, base["combos"], step)


func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	print("TREEVALUE2: is each footwork / defence step worth 1.5-5 in 100 against its own style?")
	print("fire_level key absent: GAME_SHARES")
	print("Steps: %d, Styles: %d, bouts a cell per arm: %d, seed sets: %s, amateur 3x3, Sharp %.0f, OK grade" % [
		StepValue.STEPS.size(), StepValue.STYLES.size(), N_BOUTS, str(SEED_SETS), SHARP])
	var base := _base_dict()
	var factory := Callable(self, "_make_fighter")
	# CONTROL: the forced grade really is OK on every step (LineGrade's rule, the one the live round reads).
	print("--- CONTROL: OK grade on every swept step (DONE_WITH pair mean %.0f) ---" % Cells.OK_PAIR)
	var grade_ok := true
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var gf := _make_fighter(SEED_START)
		gf["moves"] = base["moves"]
		var ga := Attrs.of(gf)
		var pair: Array = LineGrade.DONE_WITH[sid]
		ga[str(pair[0])] = Cells.OK_PAIR
		ga[str(pair[1])] = Cells.OK_PAIR
		Attrs.sync(gf)
		var gw := LineGrade.grade(sid, Attrs.of(gf))
		print("  %s: %s (%s)" % [sid, str(gw["word"]), str(pair)])
		if str(gw["word"]) != "OK":
			grade_ok = false
	if not grade_ok:
		print("CONTROL FAILED: a swept step does not grade OK")
		quit(1)
		return
	# PILOT: 10 bouts, project the full run.
	var pilot_n := 10
	var tp := Time.get_ticks_msec()
	for pi in pilot_n:
		Cells.run_bout(factory, SEED_START, N_FIGHTERS, pi, _opp_for("Pressure fighter"), PLAN, base["moves"], base["steps"], base["combos"], "")
	var pilot_ms := Time.get_ticks_msec() - tp
	var total_bouts := StepValue.STEPS.size() * StepValue.STYLES.size() * SEED_SETS.size() * 2 * N_BOUTS \
		+ StepValue.STYLES.size() * 8 * 2 * N_FIGHTERS + 2 * N_BOUTS
	print("Pilot: %d ms for %d bouts -> projected %.1f min for %d bouts" % [pilot_ms, pilot_n, float(pilot_ms) / float(pilot_n) * float(total_bouts) / 60000.0, total_bouts])
	# CALIBRATE: each style's opponent so the full BASE plan wins about half (bisect, 7 steps, 120 bouts each).
	print("--- CALIBRATE: each style's rating so BASE wins about 50 in 100 ---")
	var calib_wins := {}
	for style in StepValue.STYLES:
		var s: String = str(style)
		var on: String = str(STYLE_OPP[s])
		var shipped := float(_find_opp(on)["rating"])
		var lo := 30.0
		var hi := shipped
		for _k in 7:
			opp_rating[on] = (lo + hi) / 2.0
			var w := int(_cell(PLAN, _opp_for(s), base, "", 0, 2 * N_FIGHTERS)["wins"])
			if w > N_FIGHTERS:
				lo = float(opp_rating[on])
			else:
				hi = float(opp_rating[on])
		var cw := int(_cell(PLAN, _opp_for(s), base, "", 0, 2 * N_FIGHTERS)["wins"])
		calib_wins[on] = "%d/%d" % [cw, 2 * N_FIGHTERS]
		print("  %s (%s): shipped %.1f -> calibrated %.2f, BASE wins %s" % [on, s, shipped, float(opp_rating[on]), str(calib_wins[on])])
	# CONTROL: determinism - the same cell twice, same wins and fires.
	print("--- CONTROL: determinism (step_back vs Pressure fighter, with-arm, %d bouts twice) ---" % N_BOUTS)
	var det_plan := _plan_for("step_back")
	var det_a := _cell(det_plan, _opp_for("Pressure fighter"), base, "step_back", int(SEED_SETS[0]), N_BOUTS)
	var det_b := _cell(det_plan, _opp_for("Pressure fighter"), base, "step_back", int(SEED_SETS[0]), N_BOUTS)
	if int(det_a["wins"]) != int(det_b["wins"]) or int(det_a["fires"]) != int(det_b["fires"]):
		print("DETERMINISM FAILED: a=%d/%d b=%d/%d" % [int(det_a["wins"]), int(det_a["fires"]), int(det_b["wins"]), int(det_b["fires"])])
		quit(1)
		return
	print("CONTROL OK: %d wins, %d fires both runs" % [int(det_a["wins"]), int(det_a["fires"])])
	# SWEEP: each step x each style, with-arm vs the same plan without the line, 3 seed sets.
	print("--- SWEEP: each step at Sharp and OK grade, plan with its line vs the same plan without it ---")
	var results := {}
	var without_fires := 0
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var with_plan := _plan_for(sid)
		var without_plan: Array = with_plan.filter(func(a): return str(a["move"]) != sid)
		print("  %s plan: %s" % [sid, str(with_plan.map(func(x): return str(x["move"]) + (":" + str(x["when"]) if x.has("when") else "")))])
		var cells := {}
		for style in StepValue.STYLES:
			var s: String = str(style)
			var opp := _opp_for(s)
			var deltas: Array = []
			var wins_with := 0
			var wins_without := 0
			var fires := 0
			var uses := 0
			var n_total := 0
			for sb in SEED_SETS:
				var w := _cell(with_plan, opp, base, sid, int(sb), N_BOUTS)
				var wo := _cell(without_plan, opp, base, sid, int(sb), N_BOUTS)
				deltas.append(float(int(w["wins"]) - int(wo["wins"])) * 100.0 / float(N_BOUTS))
				wins_with += int(w["wins"])
				wins_without += int(wo["wins"])
				fires += int(w["fires"])
				uses += int(w["uses"])
				without_fires += int(wo["fires"])
				n_total += N_BOUTS
			var mean := 0.0
			for d in deltas:
				mean += float(d)
			mean /= float(deltas.size())
			cells[s] = {"delta": mean, "seeds": deltas, "fires": fires, "uses": uses, "with": wins_with, "without": wins_without, "n": n_total}
			print("CELL step=%s style=%s with=%d without=%d delta=%+.2f fires/bout=%.2f uses/bout=%.2f seeds=%s" % [
				sid, s, wins_with, wins_without, mean, float(fires) / float(n_total), float(uses) / float(n_total), str(deltas)])
		results[sid] = {"cells": cells}
	if without_fires != 0:
		print("CONTROL FAILED: the swept step fired %d times as planned in the without-arm (its line is out)" % without_fires)
		quit(1)
		return
	# SUMMARY: the gate's three legs per step, the count, one line per FAIL.
	print("")
	print("=== RESULTS: measured win difference in 100 (TARGET beside it) ===")
	var header := "%-10s" % "step"
	for style in StepValue.STYLES:
		header += " %18s" % str(style).left(16)
	header += " %6s" % "gate"
	print(header)
	var pass_count := 0
	var fail_lines: Array = []
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var cells: Dictionary = results[sid]["cells"]
		var lg := Cells.legs(sid, cells)
		var line := "%-10s" % sid
		for style in StepValue.STYLES:
			var s: String = str(style)
			line += " %+6.1f (t%+5.1f)" % [float(cells[s]["delta"]), float(StepValue.TARGET[sid][s])]
		line += " %6s" % ("PASS" if bool(lg["pass"]) else "FAIL")
		print(line)
		print("  %s: best %s %+.1f in 1.5-5: %s; wrong %s %+.1f negative: %s; others 0 to +1: %s" % [
			sid, str(lg["best"]), float(cells[str(lg["best"])]["delta"]), "yes" if bool(lg["best_ok"]) else "NO",
			str(lg["wrong"]), float(cells[str(lg["wrong"])]["delta"]), "yes" if bool(lg["wrong_ok"]) else "NO",
			"yes" if bool(lg["others_ok"]) else "NO"])
		if bool(lg["pass"]):
			pass_count += 1
		else:
			var fl := Cells.fail_line(sid, cells, lg)
			fail_lines.append(fl)
			print(fl)
	print("")
	for fl in fail_lines:
		print(fl)
	print("Without-arm planned fires of the swept steps: %d (must be 0)" % without_fires)
	var elapsed := float(Time.get_ticks_msec() - t0) / 1000.0
	Cells.write_doc({"dt": Time.get_datetime_string_from_system(), "results": results, "n_bouts": N_BOUTS,
		"seed_sets": SEED_SETS, "n_fighters": N_FIGHTERS, "seed_start": SEED_START, "opp_rating": opp_rating,
		"calib_wins": calib_wins, "det": {"a": int(det_a["wins"]), "b": int(det_b["wins"]), "fa": int(det_a["fires"]), "fb": int(det_b["fires"])},
		"grade_ok": grade_ok, "without_fires": without_fires, "elapsed_s": elapsed})
	print("TREEVALUE2 done pass=%d/10" % pass_count)
	quit(0)
