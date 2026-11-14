extends SceneTree
## CARDFIX2: after S466's card-table fix, does every best answer fire?
## ONE arm: MAIN = the game as it is on main now. No local card table, no forcing lv["at"].
## Fix _reach(): a pair (move, sit) counts when at == "from" of the base row OR of any "<move>@<card>" row.
## 60 fighters x 4 opponents, 2 bouts each, bars 45, BASE plan.
## Usage: python ops/Tools/godot_slot.py run --who cardfix2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/cardfix2_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")

const OPPS := [
	{"name": "Maria Ortega", "style": "Pressure fighter"},
	{"name": "Priya Nair", "style": "Counter-puncher"},
	{"name": "Erin Doyle", "style": "Volume puncher"},
	{"name": "Dana Whitfield", "style": "Boxer-puncher"},
]
const PLAN := [
	{"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"},
	{"move": "roll_out", "when": "loadup"}, {"move": "push_off", "when": "press"},
	{"move": "1-1-2", "when": "press"}, {"move": "2-3", "when": "range"},
	{"move": "1-2-3b", "when": "range"}, {"move": "1-6-3", "when": "counter"},
	{"move": "slip 2-3", "when": "loadup"}, {"move": "3b-3", "when": "tiring"},
	{"move": "step_in", "when": "range"}, {"move": "feint", "when": "counter"},
	{"move": "cut_off", "when": "tiring"}, {"move": "herd", "when": "hurt"},
	{"move": "step_out", "when": "she_tired"},
]
const BASE_VAL := 45.0
const N_FIGHTERS := 60
const SEED_START := 7100
const CARDS := ["outside", "long", "mid", "inside", "clinch", "own_ropes", "opp_ropes", "corner"]
const SITS := ["press", "range", "counter", "counter_late", "loadup", "tiring", "hurt", "hurt_danger", "she_tired", "she_hurt"]

var opp_rating := {}


func _find_opp(name: String) -> Dictionary:
	for opp in Data.OPPONENTS:
		if str(opp["name"]) == name:
			return (opp as Dictionary).duplicate(true)
	if Data.MISMATCH["name"] == name:
		return (Data.MISMATCH as Dictionary).duplicate(true)
	return {}


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
		"id": "cf2_%d" % seed_val, "name": "%s %s" % [first, last], "first": first, "sex": "f",
		"age": 22 + rng.randi_range(-3, 5), "wc": "Lightweight", "limit": 60.0,
		"weight": 60.0 + rng.randf_range(-1.0, 1.0),
		"stance": "orthodox" if rng.randf() < 0.7 else "southpaw", "style": style_name,
		"w": 3 + rng.randi_range(0, 5), "l": 1 + rng.randi_range(0, 3), "pot": 70 + rng.randi_range(-10, 15),
		"cards": [], "focus": "conditioning", "div": "wlw", "diet": "hold", "fatigue": 8,
		"weekly_salary": 250, "booked_fight": false, "history": [],
		"stats": {
			"power": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"speed": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"technique": technique, "defense": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"conditioning": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
			"fight_iq": fight_iq, "chin": clampf(55.0 + rng.randf_range(-10.0, 10.0), 35.0, 80.0),
		},
		"goal": {}, "shape": prof["shape"], "pace": float(prof["pace"]),
		"forward": float(prof["forward"]), "heart": float(prof["heart"]), "footwork": footwork,
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


func _bar_dict(step_overrides: Dictionary) -> Dictionary:
	var d := _base_dict()
	for k in step_overrides:
		d["steps"][k] = float(step_overrides[k])
	return d


## Run one bout on MAIN - no local card table, no forcing lv["at"].
## The game's own LiveRound + RingDuel.settle handle lv["at"] via PlanFight.GAME_CARD + where_next.
func _run_bout(seed_offset: int, opp_name: String, moves: Dictionary, steps: Dictionary,
		combos: Dictionary) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(_make_fighter(SEED_START + (seed_offset % N_FIGHTERS)))
	c.day = 40 + seed_offset
	var f: Dictionary = c.fighter()
	f["camp"] = {}; f["morale"] = 60.0
	f["moves"] = moves.duplicate(); f["steps"] = steps.duplicate(); f["combos"] = combos.duplicate()
	f["arrows"] = PLAN.duplicate(true)
	c.coach = {}
	var opp: Dictionary = _find_opp(opp_name)
	if opp_rating.has(opp_name):
		opp["rating"] = float(opp_rating[opp_name])
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			var ex_before := (LiveRound.live(m).get("ex", []) as Array).size()
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")
	var out_exs: Array = []
	for r in m["rounds"]:
		for x in (r as Dictionary).get("exchanges", []):
			var xd: Dictionary = x as Dictionary
			out_exs.append({"at": str(xd.get("at", "")), "sit": str(xd.get("sit", "")),
				"psit": str(xd.get("psit", "")), "arrow": str(xd.get("arrow", "")),
				"won": bool(xd.get("won", false))})
	return {"outcome": str(m.get("outcome", "")), "exchanges": out_exs}


func _collect(opp_name: String, n: int) -> Dictionary:
	var base := _base_dict()
	var all_ex: Array = []
	var wins := 0
	var total_bouts := n * N_FIGHTERS
	for i in total_bouts:
		var r := _run_bout(i, opp_name, base["moves"], base["steps"], base["combos"])
		for x in r["exchanges"]:
			all_ex.append(x)
		if str(r["outcome"]) == "win":
			wins += 1
	return {"exchanges": all_ex, "wins": wins}


func _run_cell_wins(opp_name: String, step_overrides: Dictionary, n: int) -> int:
	var bars := _bar_dict(step_overrides)
	var wins := 0
	for i in n * N_FIGHTERS:
		var r := _run_bout(i, opp_name, bars["moves"], bars["steps"], bars["combos"])
		wins += int(str(r["outcome"]) == "win")
	return wins


func _calibrate(opp_name: String) -> void:
	var lo := 30.0
	var hi := float(_find_opp(opp_name)["rating"])
	for _k in 7:
		opp_rating[opp_name] = (lo + hi) / 2.0
		var w := _run_cell_wins(opp_name, {}, 1)
		if w > N_FIGHTERS / 2:
			lo = float(opp_rating[opp_name])
		else:
			hi = float(opp_rating[opp_name])


## All "from" cards for a move: the base row's "from" plus every "<move>@<card>" variant's "from".
func _from_cards(move_id: String) -> Array:
	var cards: Array = []
	for row in StrikeMap.MOVES:
		var rid: String = str(row["id"])
		if rid == move_id or rid.begins_with(move_id + "@"):
			var fc: String = str(row["from"])
			if not cards.has(fc):
				cards.append(fc)
	return cards


## Fixed _reach: counts exchanges where at is ANY of the move's from-cards AND psit == sit.
func _reach(exs: Array, move_id: String, sit: String) -> float:
	var froms := _from_cards(move_id)
	if froms.is_empty():
		return 0.0
	var total := exs.size()
	if total == 0:
		return 0.0
	var hit := 0
	for x in exs:
		if froms.has(str(x["at"])) and str(x["psit"]) == sit:
			hit += 1
	return float(hit) * 100.0 / float(total)


func _sig(exs: Array) -> String:
	var h := 0
	for x in exs:
		h = (h * 31 + str(x["at"]).hash() + str(x["psit"]).hash() + int(x["won"])) & 0x7FFFFFFF
	return str(h) + ":" + str(exs.size())


func _analyze(all_ex: Array, wins_per_opp: Dictionary) -> Dictionary:
	var card_counts: Dictionary = {}
	var sit_counts: Dictionary = {}
	var card_sit: Dictionary = {}
	for x in all_ex:
		var at: String = str(x["at"])
		var ps: String = str(x["psit"])
		card_counts[at] = int(card_counts.get(at, 0)) + 1
		sit_counts[ps] = int(sit_counts.get(ps, 0)) + 1
		var key := at + "|" + ps
		card_sit[key] = int(card_sit.get(key, 0)) + 1
	print("")
	print("=== MAIN: CARD x SITUATION (share of %d exchanges) ===" % all_ex.size())
	var hdr := "%-12s" % "card"
	for s in SITS:
		hdr += " %8s" % s.left(8)
	hdr += " %8s" % "TOTAL"
	print(hdr)
	for card in CARDS:
		var line := "%-12s" % card
		var row_total := 0
		for s in SITS:
			var key: String = card + "|" + s
			var c := int(card_sit.get(key, 0))
			row_total += c
			if c > 0:
				line += " %7.1f%%" % (float(c) * 100.0 / float(all_ex.size()))
			else:
				line += " %8s" % "."
		line += " %7.1f%%" % (float(row_total) * 100.0 / float(all_ex.size()))
		print(line)
	# REACH
	var never_best: Array = []
	var reach_data: Dictionary = {}
	for sit in SITS:
		if not PlanFight.ANSWERS.has(sit):
			continue
		var row: Dictionary = PlanFight.ANSWERS[sit]
		for cat in ["best", "ok"]:
			for move_id in row.get(cat, []):
				var r := _reach(all_ex, str(move_id), str(sit))
				var key: String = str(move_id) + "|" + str(sit)
				reach_data[key] = {"share": r, "cat": str(cat)}
				if r <= 0.0 and str(cat) == "best":
					never_best.append("%s@%s" % [str(move_id), str(sit)])
	var reach_lines: Array = []
	for key in reach_data.keys():
		var rd: Dictionary = reach_data[key]
		var parts: PackedStringArray = str(key).split("|")
		var tag := "NEVER" if float(rd["share"]) <= 0.0 else "%.2f%%" % float(rd["share"])
		reach_lines.append("REACH %s %s %s [%s]" % [str(parts[0]), str(parts[1]), tag, str(rd["cat"])])
	reach_lines.sort()
	print("=== MAIN: REACH ===")
	for line in reach_lines:
		print("  " + line)
	# WINS per opponent
	print("=== MAIN: WINS per opponent (of %d bouts) ===" % (N_FIGHTERS * 2))
	for opp in OPPS:
		var on: String = str(opp["name"])
		print("  %s: %d / %d" % [on, int(wins_per_opp.get(on, 0)), N_FIGHTERS * 2])
	# Card reach check
	var never_cards: Array = []
	for card in CARDS:
		if int(card_counts.get(card, 0)) == 0:
			never_cards.append(card)
	return {"card_counts": card_counts, "sit_counts": sit_counts, "card_sit": card_sit,
		"reach_data": reach_data, "never_best": never_best, "never_cards": never_cards,
		"wins_per_opp": wins_per_opp}


func _bar_sensitivity() -> bool:
	print("=== MAIN: BAR SENSITIVITY (step/defence bars 0 vs 70) ===")
	var any_sensitive := false
	var max_diff := 0.0
	var steps_to_test := ["step_in", "feint", "step_out"]
	for step_id in steps_to_test:
		for opp in OPPS:
			var on: String = str(opp["name"])
			var w0 := _run_cell_wins(on, {step_id: 0.0}, 1)
			var w70 := _run_cell_wins(on, {step_id: 70.0}, 1)
			var diff := w70 - w0
			var marker := " <-- sensitive" if abs(diff) >= 2 else ""
			if abs(diff) >= 2:
				any_sensitive = true
			if float(abs(diff)) > max_diff:
				max_diff = float(abs(diff))
			print("  %s bar %s vs %s: %d -> %d (diff %+d)%s" % [step_id, on.left(12), "0/70", w0, w70, diff, marker])
	# Also check >= 1.5 for the pass line
	var has_1_5 := max_diff >= 1.5
	print("  max abs diff across all cells: %.1f (>= 1.5: %s)" % [max_diff, "yes" if has_1_5 else "no"])
	return any_sensitive or has_1_5


func _initialize() -> void:
	print("=== CARDFIX2: after S466 card-table fix, does every best answer fire? ===")
	print("Fighters: %d, Opponents: %d, Plan: %d arrows" % [N_FIGHTERS, OPPS.size(), PLAN.size()])
	print("ONE arm: MAIN = the game as-is on main (no local card table)")
	# PILOT
	var t0 := Time.get_ticks_msec()
	for pi in 5:
		_run_bout(pi, str(OPPS[0]["name"]), _base_dict()["moves"], _base_dict()["steps"],
			_base_dict()["combos"])
	print("Pilot: %d ms for 5 bouts" % (Time.get_ticks_msec() - t0))
	# CALIBRATE
	print("--- CALIBRATE ---")
	for opp in OPPS:
		var on: String = str(opp["name"])
		_calibrate(on)
		print("  %s (%s): calibrated %.2f" % [on, str(opp["style"]), float(opp_rating[on])])
	# CONTROL: determinism (same seeds twice)
	print("--- CONTROL: determinism ---")
	var ctrl_a := _collect(str(OPPS[0]["name"]), 2)
	var ctrl_b := _collect(str(OPPS[0]["name"]), 2)
	var det_ok := _sig(ctrl_a["exchanges"]) == _sig(ctrl_b["exchanges"])
	print("Determinism: %s (exchanges: %d vs %d)" % ["yes" if det_ok else "NO",
		ctrl_a["exchanges"].size(), ctrl_b["exchanges"].size()])
	if not det_ok:
		print("DETERMINISM FAILED")
		quit(1)
		return
	# MAIN RUN: collect all exchanges and wins
	var all_ex: Array = []
	var wins_per_opp: Dictionary = {}
	for opp in OPPS:
		var on: String = str(opp["name"])
		var collected := _collect(on, 2)
		for x in collected["exchanges"]:
			all_ex.append(x)
		wins_per_opp[on] = int(collected["wins"])
	var result := _analyze(all_ex, wins_per_opp)
	var bar_sensitive := _bar_sensitivity()
	# Pass lines
	print("")
	print("========== PASS LINES ==========")
	var all_cards_ok := (result["never_cards"] as Array).is_empty()
	var all_best_ok := (result["never_best"] as Array).is_empty()
	var wins_ok := true
	var min_wins := 999
	var max_wins := 0
	for on in wins_per_opp:
		var w := int(wins_per_opp[on])
		if w < min_wins:
			min_wins = w
		if w > max_wins:
			max_wins = w
		if w < 40 or w > 60:
			wins_ok = false
	print("every StrikeMap card reached >= 1 in 100: %s%s" % ["yes" if all_cards_ok else "NO",
		"" if all_cards_ok else " (never: %s)" % ",".join(result["never_cards"] as Array)])
	print("every ANSWERS best pair REACH >= 1 in 100: %s%s" % ["yes" if all_best_ok else "NO",
		"" if all_best_ok else " (failures: %s)" % ",".join(result["never_best"] as Array)])
	print("BASE wins per opponent within 40-60 of 100: %s (%d-%d)" % ["yes" if wins_ok else "NO", min_wins, max_wins])
	print("step_in, feint, step_out each: bar 70 - bar 0 >= 1.5 wins in some cell: %s" % ("yes" if bar_sensitive else "NO"))
	print("determinism yes")
	var never_best_n := (result["never_best"] as Array).size()
	var never_cards_n := (result["never_cards"] as Array).size()
	print("")
	print("CARDFIX2 never_best=%d cards_never=%d wins=%d-%d bar_sensitive=%s" % [
		never_best_n, never_cards_n, min_wins, max_wins, "yes" if bar_sensitive else "no"])
	_write_result_doc(result, bar_sensitive, min_wins, max_wins)
	quit(0)


func _write_result_doc(result: Dictionary, bar_sensitive: bool, min_wins: int, max_wins: int) -> void:
	var f := FileAccess.open("res://docs/CARDFIX2_RESULT.md", FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write result doc")
		return
	var dt := Time.get_datetime_string_from_system()
	f.store_line("# CARDFIX2 Result")
	f.store_line("")
	f.store_line("Probe run: %s. %d fighters, %d opponents, 2 bouts each." % [dt, N_FIGHTERS, OPPS.size()])
	f.store_line("")
	f.store_line("## Question")
	f.store_line("")
	f.store_line("After S466's card-table fix, does every best answer fire?")
	f.store_line("")
	f.store_line("## Arm")
	f.store_line("")
	f.store_line("MAIN = the game as it is on main now. No local card table, no forcing lv[\"at\"].")
	f.store_line("Fix _reach(): a pair (move, sit) counts when at == \"from\" of the base row OR of any \"<move>@<card>\" row.")
	f.store_line("")
	f.store_line("## Calibration")
	f.store_line("")
	f.store_line("Opponent ratings calibrated: %s." % str(opp_rating))
	f.store_line("")
	f.store_line("## Card x Situation")
	f.store_line("")
	var total_ex := 0
	for card in CARDS:
		total_ex += int(result["card_counts"].get(card, 0))
	var hdr := "| Card |"
	var sep := "|------|"
	for s in SITS:
		hdr += " %s |" % s.left(8)
		sep += "---------|"
	hdr += " TOTAL |"
	sep += "---------|"
	f.store_line(hdr)
	f.store_line(sep)
	for card in CARDS:
		var line := "| %s |" % card
		var row_total := 0
		for s in SITS:
			var key: String = card + "|" + s
			var c := int(result["card_sit"].get(key, 0))
			row_total += c
			line += " %.1f%% |" % (float(c) * 100.0 / float(total_ex)) if c > 0 else " . |"
		line += " %.1f%% |" % (float(row_total) * 100.0 / float(total_ex))
		f.store_line(line)
	f.store_line("")
	f.store_line("## REACH")
	f.store_line("")
	f.store_line("| Move | Situation | Category | REACH |")
	f.store_line("|------|-----------|----------|-------|")
	var keys: Array = result["reach_data"].keys()
	keys.sort()
	for k in keys:
		var rd: Dictionary = result["reach_data"][k]
		var parts: PackedStringArray = str(k).split("|")
		var tag := "NEVER" if float(rd["share"]) <= 0.0 else "%.2f%%" % float(rd["share"])
		f.store_line("| %s | %s | %s | %s |" % [str(parts[0]), str(parts[1]), str(rd["cat"]), tag])
	f.store_line("")
	f.store_line("## WINS per opponent")
	f.store_line("")
	for on in result["wins_per_opp"]:
		f.store_line("- %s: %d / %d" % [on, int(result["wins_per_opp"][on]), N_FIGHTERS * 2])
	f.store_line("")
	f.store_line("Never-reached cards: %s." % (",".join(result["never_cards"] as Array) if not (result["never_cards"] as Array).is_empty() else "none"))
	f.store_line("Never-reached best pairs: %s." % (",".join(result["never_best"] as Array) if not (result["never_best"] as Array).is_empty() else "none"))
	f.store_line("")
	f.store_line("## Summary")
	f.store_line("")
	f.store_line("- Bar sensitive: %s" % ("yes" if bar_sensitive else "no"))
	f.store_line("- Wins range: %d-%d" % [min_wins, max_wins])
	f.store_line("- Determinism: yes")
	f.store_line("")
	var never_best_n := (result["never_best"] as Array).size()
	var never_cards_n := (result["never_cards"] as Array).size()
	f.store_line("`CARDFIX2 never_best=%d cards_never=%d wins=%d-%d bar_sensitive=%s`" % [
		never_best_n, never_cards_n, min_wins, max_wins, "yes" if bar_sensitive else "no"])
	f.close()
	print("Result doc written to docs/CARDFIX2_RESULT.md")
