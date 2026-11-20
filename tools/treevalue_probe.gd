extends SceneTree
## TREEVALUE2 (S522): is each footwork / defence step worth 1.5-5 in 100 against its own style?
## Map ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md section 9 gate 2. For each of StepValue.STEPS x StepValue.STYLES:
## 400 bouts a cell x 3 seed sets (the S427 convention), amateur 3x3, the step at Sharp mastery (StepMastery 60) and OK grade,
## the plan WITH its line against the SAME plan without that line. Win difference in 100 per cell; fires/bout beside it.
## Keeps TREEVALUE1's tables (OPPS, PLAN, the fighter factory, _plan_for's S464 plan surgery); cells live in treevalue_cells.gd.
## No fire_level key on the bout (absent = FireLevel.GAME_SHARES). Gate FAILs are findings, not a failed run: the probe
## quits 0 when it measured and its controls hold, 1 only when a control breaks.
## Usage: python ops/Tools/godot_slot.py run --who treevalue2 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd

const StepEffectOff := preload("res://scripts/rules/StepEffect.gd")   # S532 off= lever attribution
const Data := preload("res://scripts/state/Data.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const StepMastery := preload("res://scripts/rules/StepMastery.gd")
const StepValue := preload("res://scripts/rules/StepValue.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const Cells := preload("res://tools/treevalue_cells.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

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
## STEPTUNE2's per-fire invariant I(best,wrong) and gate-leg count (docs/STEPTUNE2_RESULT.md s4-s5), the baseline this run
## compares against: which three-leg windows opened once phase 1 wired the wrong cost and the opening rides on to a punch.
const ST2 := {
	"step_in": {"i": 0.415, "legs": 1}, "step_out": {"i": -0.598, "legs": 0}, "step_back": {"i": 5.960, "legs": 2},
	"pivot_out": {"i": 1.330, "legs": 0}, "cut_off": {"i": 2.073, "legs": 1}, "herd": {"i": 0.361, "legs": 1},
	"feint": {"i": -1.422, "legs": 1}, "tie_up": {"i": -0.038, "legs": 1}, "roll_out": {"i": 0.070, "legs": 1},
	"push_off": {"i": 0.128, "legs": 2},
}
## Each style's rating is CALIBRATED so the full BASE plan wins about half its bouts (TREEVALUE1's S464 rule: a floor
## no step can show a value against). Style, threat and plan stay the opponent's.
var opp_rating := {}


func _plan_for(nid: String) -> Array:
	var mine := ""
	for a in PLAN:
		if str(a["move"]) == nid:
			mine = str(a.get("when", ""))
	# S464 second fix: an arrow fires only on its OWN card (StrikeMap "from") at its when (PlanBoard.pick); "range" is fought on
	# the long card while step_in starts from outside, so a planned "step_in:range" can never fire. The swept node is planned
	# ANY TIME here (its when dropped), like step_back / pivot_out / tie_up, so it fires whenever the bout reaches its card.
	var out: Array = PLAN.duplicate(true)
	if mine != "":
		out = PLAN.filter(func(a): return str(a["move"]) == nid or str(a.get("when", "")) != mine).duplicate(true)
		for a in out:
			if str(a["move"]) == nid:
				a.erase("when")
	out = _swept_first(out, nid)
	_keep_dest_punch(out, nid)   # S528 TREEVALUE5: the destination card keeps a planned punch to spend the step's opening
	return out


## S528 TREEVALUE5 (STEPTUNE2 s3): the swept step's DESTINATION card must hold one planned PUNCH, or its opening is spent on
## another step / an unplanned pick for nothing. Keep the punch already there; else put back the base PLAN's punch on that card
## (the one the surgery removed), ANY TIME; else the map's own punch there (the @card variant). It answers the game most played
## on the card (PlanFight.GAME_CARD's situation that lands there). Returns the punch kept, "" when the card has no punch move
## (clinch: only break / push_off leave it, so tie_up's opening rides push_off on to mid - phase 1 passes it through a step).
func _keep_dest_punch(plan: Array, nid: String) -> String:
	var dest := str(StrikeMap.move(nid).get("to", ""))
	var have := _punch_on(plan, dest)
	if have != "":
		return have
	var sit := "press"
	for k in PlanFight.GAME_CARD:
		if str(PlanFight.GAME_CARD[k]) == dest:
			sit = str(k)
			break
	if dest == "corner":
		sit = "hurt"
	var rank := {"best": 3, "ok": 2, "none": 1, "wrong": 0}
	var pick_id := ""
	var pick_fit := -1
	for a in PLAN:
		var id := str(a["move"])
		var r := StrikeMap.move(id)
		if str(r.get("kind", "")) == "combo" and str(r.get("from", "")) == dest:
			var f := int(rank.get(PlanFight.fit(id, sit), 0))
			if f > pick_fit:
				pick_fit = f
				pick_id = id
	if pick_id == "":
		for m in StrikeMap.outs(dest):
			if str(m.get("kind", "")) == "combo":
				var f := int(rank.get(PlanFight.fit(str(m["id"]), sit), 0))
				if f > pick_fit:
					pick_fit = f
					pick_id = str(m["id"])
	if pick_id != "":
		plan.append({"move": pick_id})
	return pick_id


## The first planned PUNCH (combo) whose StrikeMap "from" is this card, "" if none.
func _punch_on(plan: Array, card: String) -> String:
	for a in plan:
		var r := StrikeMap.move(str(a["move"]))
		if str(r.get("kind", "")) == "combo" and str(r.get("from", "")) == card:
			return str(a["move"])
	return ""


## STEPTUNE2 s4's per-fire invariant: cell_a - (F_a / F_b) x cell_b, F = fires/bout. The per-fire lever package L cancels,
## so no StepEffect.TABLE number moves it; the gate needs I(best,wrong) > 1.5 for the best and wrong legs to coexist.
## NAN when the reference style never fires (F_b = 0): the invariant is undefined there, the cell is pure fit.
func _invariant(cells: Dictionary, a: String, b: String) -> float:
	if not cells.has(b) or not cells.has(a):
		return NAN   # S531: a step with no wrong style has no pair to read
	var fb := float(cells[b]["fires"]) / float(cells[b]["n"])
	if fb <= 0.0:
		return NAN
	return float(cells[a]["delta"]) - (float(cells[a]["fires"]) / float(cells[a]["n"])) / fb * float(cells[b]["delta"])


## S527: PlanBoard.pick takes the FIRST any-time arrow on a card, and tie_up (any time, inside) came before roll_out, so
## TREEVALUE3's roll_out never fired (0 uses in every style). The swept arrow goes first: the with-arm plays it where it
## starts, the without-arm falls back to whatever the plan had there (a player's real choice between the two).
## S527: `-- only=roll_out,push_off` sweeps just those steps (default: every step).
func _sweep_steps() -> Array:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("only="):
			return str(a).substr(5).split(",")
	return StepValue.STEPS


func _swept_first(plan: Array, nid: String) -> Array:
	var head: Array = plan.filter(func(a): return str(a["move"]) == nid)
	return head + plan.filter(func(a): return str(a["move"]) != nid)


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
	# S532 TREEVALUE10 lever attribution: `-- off=drain,wrong` reads those effects of every swept step as zero (with-arm only:
	# the without-arm has no such line). Names the arm in the output so a result never hides which arm it is.
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("off="):
			for st in _sweep_steps():
				StepEffectOff.probe_off[str(st)] = Array(str(a).substr(4).split(","))
			print("OFF (lever attribution, measurement only): %s" % str(StepEffectOff.probe_off))
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
	for step in _sweep_steps():
		var sid: String = str(step)
		var with_plan := _plan_for(sid)
		var without_plan: Array = with_plan.filter(func(a): return str(a["move"]) != sid)
		var plan_str := str(with_plan.map(func(x): return str(x["move"]) + (":" + str(x["when"]) if x.has("when") else "")))
		var dest := str(StrikeMap.move(sid).get("to", ""))
		var dest_punch := _punch_on(with_plan, dest)
		print("  %s plan: %s" % [sid, plan_str])
		print("    -> %s keeps punch: %s" % [dest, dest_punch if dest_punch != "" else "NONE (no punch move leaves that card)"])
		var cells := {}
		for style in StepValue.STYLES:
			var s: String = str(style)
			var opp := _opp_for(s)
			var deltas: Array = []
			var wins_with := 0
			var wins_without := 0
			var fires := 0
			var uses := 0
			var wrong := 0
			var n_total := 0
			for sb in SEED_SETS:
				var w := _cell(with_plan, opp, base, sid, int(sb), N_BOUTS)
				var wo := _cell(without_plan, opp, base, sid, int(sb), N_BOUTS)
				deltas.append(float(int(w["wins"]) - int(wo["wins"])) * 100.0 / float(N_BOUTS))
				wins_with += int(w["wins"])
				wins_without += int(wo["wins"])
				fires += int(w["fires"])
				wrong += int(w.get("wrong", 0))
				uses += int(w["uses"])
				without_fires += int(wo["fires"])
				n_total += N_BOUTS
			var mean := 0.0
			for d in deltas:
				mean += float(d)
			mean /= float(deltas.size())
			cells[s] = {"delta": mean, "seeds": deltas, "fires": fires, "uses": uses, "with": wins_with, "without": wins_without, "n": n_total, "wrong": wrong}
			print("CELL step=%s style=%s with=%d without=%d delta=%+.2f fires/bout=%.2f uses/bout=%.2f wrong=%.0f%% seeds=%s" % [
				sid, s, wins_with, wins_without, mean, float(fires) / float(n_total), float(uses) / float(n_total), 100.0 * float(wrong) / float(maxi(1, fires)), str(deltas)])
		results[sid] = {"cells": cells, "plan": plan_str, "dest": dest, "dest_punch": dest_punch}
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
	for step in _sweep_steps():
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
			"none" if str(lg["wrong"]) == "" else str(lg["wrong"]), float(cells.get(str(lg["wrong"]), {"delta": 0.0})["delta"]), "yes" if bool(lg["wrong_ok"]) else "NO",
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
	if _sweep_steps().size() == StepValue.STEPS.size():   # S527: a filtered run prints only, the full doc stays whole
		_write_doc({"dt": Time.get_datetime_string_from_system(), "results": results, "n_bouts": N_BOUTS,
			"seed_sets": SEED_SETS, "n_fighters": N_FIGHTERS, "seed_start": SEED_START, "opp_rating": opp_rating,
			"calib_wins": calib_wins, "det": {"a": int(det_a["wins"]), "b": int(det_b["wins"]), "fa": int(det_a["fires"]), "fb": int(det_b["fires"])},
			"grade_ok": grade_ok, "without_fires": without_fires, "elapsed_s": elapsed, "pass": pass_count})
	print("TREEVALUE2 done pass=%d/10" % pass_count)
	quit(0)


## docs/TREEVALUE5_RESULT.md: the cells (with / without wins, fires a bout), the per-fire invariant I(best,wrong) against
## STEPTUNE2, and which three-leg windows opened. Written here (not Cells.write_doc) so only this brief's OWNS files change.
func _write_doc(report: Dictionary) -> void:
	var f := FileAccess.open("res://docs/TREEVALUE5_RESULT.md", FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write docs/TREEVALUE5_RESULT.md")
		return
	var results: Dictionary = report["results"]
	var sets: Array = report["seed_sets"]
	f.store_line("# TREEVALUE5 Result\n")
	f.store_line("Probe run: %s. Phase 2 of STEPS_SCOPE_S528 on the phase-1 fight: StepWire.open_edge passes a step's opening on to the punch after it; a wrong-fit step lets WRONG_COST more of her punches land. %d bouts a cell per arm per seed set, %d sets, amateur 3x3, %d fighters, Sharp %.0f, OK grade.\n" % [str(report["dt"]), int(report["n_bouts"]), sets.size(), int(report["n_fighters"]), SHARP])
	f.store_line("## The probe fix (STEPTUNE2 s3)\n")
	f.store_line("_plan_for keeps one planned PUNCH on the swept step's destination card (StrikeMap.move(step).to): the punch already there, else the base PLAN punch the surgery removed (ANY TIME), else the map's own punch there, answering the game most played on the card. It is in BOTH arms, so the delta isolates the step. Per step:\n")
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var dp: String = str(results[sid]["dest_punch"])
		f.store_line("- %s -> %s: %s" % [sid, str(results[sid]["dest"]), dp if dp != "" else "NO punch move leaves this card (clinch); the opening rides push_off on to mid"])
	f.store_line("\n## Controls\n")
	f.store_line("- OK grade on every swept step: %s. Determinism: %d / %d wins (fires %d / %d). Without-arm planned fires: %d (must be 0)." % ["yes" if bool(report["grade_ok"]) else "NO", int(report["det"]["a"]), int(report["det"]["b"]), int(report["det"]["fa"]), int(report["det"]["fb"]), int(report["without_fires"])])
	f.store_line("- Calibration (full BASE plan, 120 bouts): %s. Ratings: %s.\n" % [str(report["calib_wins"]), str(report["opp_rating"])])
	f.store_line("## Cells: win difference in 100 [with / without wins] fires/bout (TARGET beside it)\n")
	var header := "| Step |"
	var sep := "|------|"
	for style in StepValue.STYLES:
		header += " %s |" % str(style)
		sep += "------|"
	f.store_line(header)
	f.store_line(sep)
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var line := "| %s |" % sid
		for style in StepValue.STYLES:
			var c: Dictionary = results[sid]["cells"][str(style)]
			line += " %+.1f (t%+.1f) [%d/%d] f%.2f w%d%% |" % [float(c["delta"]), float(StepValue.TARGET[sid][str(style)]), int(c["with"]), int(c["without"]), float(c["fires"]) / float(c["n"]), roundi(100.0 * float(c.get("wrong", 0)) / float(maxi(1, int(c["fires"]))))]
		f.store_line(line)
	f.store_line("\n## The gate's three legs and the per-fire invariant I(best,wrong) vs STEPTUNE2\n")
	f.store_line("I(best,wrong) = cell_best - (F_best/F_wrong) x cell_wrong (F = fires/bout): no TABLE number moves it; the gate needs I > 1.5 for the best (1.5..5) and wrong (<0) legs to coexist. 'Window' = the leg count that can pass.\n")
	f.store_line("| Step | best | wrong | I now | I ST2 | I>1.5 | legs now | legs ST2 | window |")
	f.store_line("|------|------|-------|-------|-------|-------|----------|----------|--------|")
	var pass_count := 0
	var opened: Array = []
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var cells: Dictionary = results[sid]["cells"]
		var lg: Dictionary = Cells.legs(sid, cells)
		var legs_now := int(lg["best_ok"]) + int(lg["wrong_ok"]) + int(lg["others_ok"])
		var iv := _invariant(cells, str(lg["best"]), str(lg["wrong"]))
		var st2: Dictionary = ST2[sid]
		if bool(lg["pass"]):
			pass_count += 1
		if legs_now > int(st2["legs"]) or bool(lg["pass"]):
			opened.append("%s (%d->%d legs)" % [sid, int(st2["legs"]), legs_now])
		f.store_line("| %s | %s | %s | %s | %+.3f | %s | %d | %d | %s |" % [sid, str(lg["best"]), str(lg["wrong"]), "n/a" if is_nan(iv) else "%+.3f" % iv, float(st2["i"]), "yes" if (not is_nan(iv) and iv > 1.5) else "no", legs_now, int(st2["legs"]), "PASS" if bool(lg["pass"]) else ("opened" if legs_now > int(st2["legs"]) else "still shut")])
	f.store_line("\n**TREEVALUE2 done pass=%d/10** (gate legs: best in 1.5..5, wrong < 0, others 0..1).\n" % pass_count)
	f.store_line("Windows that opened vs STEPTUNE2: %s.\n" % (", ".join(opened) if not opened.is_empty() else "none"))
	f.store_line("## One line per FAIL (the StepEffect row that would move it; TABLE is NOT changed here)\n")
	var any_fail := false
	for step in StepValue.STEPS:
		var sid: String = str(step)
		var lg: Dictionary = Cells.legs(sid, results[sid]["cells"])
		if not bool(lg["pass"]):
			any_fail = true
			f.store_line("- %s" % Cells.fail_line(sid, results[sid]["cells"], lg))
	if not any_fail:
		f.store_line("- none")
	f.store_line("\nElapsed: %.0f s. Reproduce: `python ops/Tools/godot_slot.py run --who treevalue5 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd`" % float(report["elapsed_s"]))
	f.close()
	print("Result doc written to docs/TREEVALUE5_RESULT.md")
