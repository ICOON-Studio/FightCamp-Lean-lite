extends SceneTree
## CARDVISIT1: which cards does a played bout ever reach, and which plan lines can ever fire there?
## 60 generated fighters x 4 opponents, 2 bouts each, all bars 45, BASE plan = treevalue's PLAN.
## Records (at, sit) per exchange; prints card x situation table and REACH per ANSWERS (move, sit) pair.
## Mutant arm forces at="outside" to prove the instrument reads a reach.
## Usage: python ops/Tools/godot_slot.py run --who cardvisit1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/cardvisit_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
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
	{"move": "step_in", "when": "range"},
	{"move": "feint", "when": "counter"},
	{"move": "cut_off", "when": "tiring"},
	{"move": "herd", "when": "hurt"},
	{"move": "step_out", "when": "she_tired"},
]
const BASE_VAL := 45.0
const N_FIGHTERS := 60
const SEED_START := 7100
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
		"id": "cv_%d" % seed_val,
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


func _run_bout(seed_offset: int, opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(_make_fighter(SEED_START + (seed_offset % N_FIGHTERS)))
	c.day = 40 + seed_offset
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["morale"] = 60.0
	f["moves"] = moves.duplicate()
	f["steps"] = steps.duplicate()
	f["combos"] = combos.duplicate()
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
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")
	var exs: Array = []
	for r in m["rounds"]:
		for x in (r as Dictionary).get("exchanges", []):
			var xd: Dictionary = x as Dictionary
			exs.append({"at": str(xd.get("at", "")), "sit": str(xd.get("sit", "")), "psit": str(xd.get("psit", "")),
				"arrow": str(xd.get("arrow", "")), "won": bool(xd.get("won", false))})
	return {"outcome": str(m.get("outcome", "")), "exchanges": exs}


func _base_dict() -> Dictionary:
	var moves := {}; var steps := {}; var combos := {}
	for k in Data.MOVES:
		moves[k] = BASE_VAL
	for k in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS:
		steps[k] = BASE_VAL
	for k in MoveTree.COMBO_PUNCHES:
		combos[k] = BASE_VAL
	return {"moves": moves, "steps": steps, "combos": combos}


func _collect(opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, n: int) -> Array:
	var all_ex: Array = []
	for i in n * N_FIGHTERS:
		var r := _run_bout(i, opp_name, moves, steps, combos)
		for x in r["exchanges"]:
			all_ex.append(x)
	return all_ex


func _run_cell_wins(opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, n: int) -> int:
	var wins := 0
	for i in n * N_FIGHTERS:
		var r := _run_bout(i, opp_name, moves, steps, combos)
		wins += int(str(r["outcome"]) == "win")
	return wins


## Collect all (at, psit) pairs from the exchange records, with an optional mutant override for at.
func _card_sit_counts(exs: Array, force_at: String) -> Dictionary:
	var counts: Dictionary = {}
	for x in exs:
		var at: String = force_at if force_at != "" else str(x["at"])
		var sit: String = str(x["psit"])
		var key := at + "|" + sit
		counts[key] = int(counts.get(key, 0)) + 1
	return counts


func _reach(exs: Array, move_id: String, sit: String, force_at: String) -> float:
	var row := StrikeMap.move(move_id)
	if row.is_empty():
		return 0.0
	var from_card: String = str(row["from"])
	var total := exs.size()
	if total == 0:
		return 0.0
	var hit := 0
	for x in exs:
		var at: String = force_at if force_at != "" else str(x["at"])
		if at == from_card and str(x["psit"]) == sit:
			hit += 1
	return float(hit) * 100.0 / float(total)


func _initialize() -> void:
	print("=== CARDVISIT1: which cards does a bout reach, which plan lines can fire? ===")
	print("Fighters: %d, Opponents: %d, Plan: %d arrows" % [N_FIGHTERS, OPPS.size(), PLAN.size()])
	var base := _base_dict()
	# PILOT
	var t0 := Time.get_ticks_msec()
	for pi in 5:
		_run_bout(pi, str(OPPS[0]["name"]), base["moves"], base["steps"], base["combos"])
	var pilot_ms := Time.get_ticks_msec() - t0
	print("Pilot: %d ms for 5 bouts" % pilot_ms)
	# CALIBRATE
	print("--- CALIBRATE ---")
	var n := 2
	for opp in OPPS:
		var on: String = str(opp["name"])
		var lo := 30.0
		var hi := float(_find_opp(on)["rating"])
		for _k in 7:
			opp_rating[on] = (lo + hi) / 2.0
			var w := _run_cell_wins(on, base["moves"], base["steps"], base["combos"], 1)
			if w > N_FIGHTERS / 2:
				lo = float(opp_rating[on])
			else:
				hi = float(opp_rating[on])
		print("  %s (%s): calibrated %.2f" % [on, str(opp["style"]), float(opp_rating[on])])
	# CONTROL 1: determinism
	print("--- CONTROL 1: determinism ---")
	var ctrl_a_ex: Array = _collect(str(OPPS[0]["name"]), base["moves"], base["steps"], base["combos"], n)
	var ctrl_b_ex: Array = _collect(str(OPPS[0]["name"]), base["moves"], base["steps"], base["combos"], n)
	var ctrl_a_sig := _sig(ctrl_a_ex)
	var ctrl_b_sig := _sig(ctrl_b_ex)
	var det_ok := ctrl_a_sig == ctrl_b_sig
	print("Determinism: %s (exchanges: %d vs %d, sig match: %s)" % ["yes" if det_ok else "NO", ctrl_a_ex.size(), ctrl_b_ex.size(), "yes" if ctrl_a_sig == ctrl_b_sig else "NO"])
	if not det_ok:
		print("DETERMINISM FAILED")
		_write_result_doc({}, {}, {}, {}, [], true, false)
		quit(1)
		return
	# Collect exchanges per opponent
	print("--- COLLECT: exchanges per opponent ---")
	var per_opp: Dictionary = {}
	var all_ex: Array = []
	for opp in OPPS:
		var on: String = str(opp["name"])
		var exs: Array = _collect(on, base["moves"], base["steps"], base["combos"], n)
		per_opp[on] = exs
		for x in exs:
			all_ex.append(x)
		print("  %s: %d exchanges" % [on, exs.size()])
	print("Total exchanges: %d" % all_ex.size())
	# Card x situation table (all opponents combined)
	var cards := ["outside", "long", "mid", "inside", "clinch", "own_ropes", "opp_ropes", "corner"]
	var sits := ["press", "range", "counter", "counter_late", "loadup", "tiring", "hurt", "hurt_danger", "she_tired", "she_hurt"]
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
	print("=== CARD x SITUATION (share of %d exchanges) ===" % all_ex.size())
	var hdr := "%-12s" % "card"
	for s in sits:
		hdr += " %8s" % s.left(8)
	hdr += " %8s" % "TOTAL"
	print(hdr)
	for card in cards:
		var card_str: String = str(card)
		var line := "%-12s" % card_str
		var row_total := 0
		for s in sits:
			var s_str: String = str(s)
			var key: String = card_str + "|" + s_str
			var c := int(card_sit.get(key, 0))
			row_total += c
			var share := float(c) * 100.0 / float(all_ex.size()) if all_ex.size() > 0 else 0.0
			line += " %7.1f%%" % share if c > 0 else " %8s" % "."
		line += " %7.1f%%" % (float(row_total) * 100.0 / float(all_ex.size()))
		print(line)
	# Card totals
	var total_line := "%-12s" % "TOTAL"
	for s in sits:
		var sc := int(sit_counts.get(s, 0))
		total_line += " %7.1f%%" % (float(sc) * 100.0 / float(all_ex.size())) if sc > 0 else " %8s" % "."
	total_line += " %7.1f%%" % 100.0
	print(total_line)
	# Per-opponent card table
	print("")
	print("=== PER-OPPONENT CARD SHARES ===")
	for opp in OPPS:
		var on: String = str(opp["name"])
		var exs: Array = per_opp[on]
		var oc: Dictionary = {}
		for x in exs:
			var at: String = str(x["at"])
			oc[at] = int(oc.get(at, 0)) + 1
		var parts: Array = []
		for card in cards:
			var c := int(oc.get(card, 0))
			if c > 0:
				parts.append("%s:%.1f%%" % [card, float(c) * 100.0 / float(exs.size())])
		print("  %s: %s" % [on, ", ".join(parts)])
	# REACH: for every (move, sit) in ANSWERS best/ok
	print("")
	print("=== REACH: share of exchanges where card == move.from AND psit == sit ===")
	var reach_data: Dictionary = {}
	var never_pairs: Array = []
	var never_best: Array = []
	for sit in sits:
		if not PlanFight.ANSWERS.has(sit):
			continue
		var row: Dictionary = PlanFight.ANSWERS[sit]
		for cat in ["best", "ok"]:
			for move_id in row.get(cat, []):
				var r := _reach(all_ex, str(move_id), str(sit), "")
				var key: String = str(move_id) + "|" + str(sit)
				reach_data[key] = {"share": r, "cat": str(cat)}
				if r <= 0.0:
					never_pairs.append("%s@%s" % [str(move_id), str(sit)])
					if str(cat) == "best":
						never_best.append("%s@%s" % [str(move_id), str(sit)])
	var reach_lines: Array = []
	for key in reach_data.keys():
		var key_str: String = str(key)
		var parts: PackedStringArray = key_str.split("|")
		var rd: Dictionary = reach_data[key_str]
		var tag := "NEVER" if float(rd["share"]) <= 0.0 else "%.2f%%" % float(rd["share"])
		var line := "REACH %s %s %s [%s]" % [str(parts[0]), str(parts[1]), tag, str(rd["cat"])]
		reach_lines.append(line)
	reach_lines.sort()
	for line in reach_lines:
		print("  " + line)
	# CONTROL 2: mutant arm - force at="outside"
	print("")
	print("--- CONTROL 2: mutant arm (force at=outside) ---")
	var mut_reach := _reach(all_ex, "step_in", "range", "outside")
	print("Mutant REACH step_in range (at forced outside): %.2f%%" % mut_reach)
	var mutant_ok := mut_reach > 0.0
	print("Mutant arm shows step_in REACH > 0: %s" % ("yes" if mutant_ok else "NO"))
	# Pass lines
	var never_cards: Array = []
	for card in cards:
		if int(card_counts.get(card, 0)) == 0:
			never_cards.append(card)
	var all_cards_reached := never_cards.is_empty()
	print("")
	print("every card reached >= 1: %s (never: %s)" % ["yes" if all_cards_reached else "NO", ",".join(never_cards) if not never_cards.is_empty() else "none"])
	print("every ANSWERS best pair REACH >= 1: %s (never_best: %s)" % ["yes" if never_best.is_empty() else "NO", ",".join(never_best) if not never_best.is_empty() else "none"])
	print("CARDVISIT never_cards=%s never_best=%d pairs=%s" % [
		",".join(never_cards) if not never_cards.is_empty() else "none",
		never_best.size(),
		",".join(never_pairs) if not never_pairs.is_empty() else "none"])
	_write_result_doc(card_counts, sit_counts, card_sit, reach_data, never_pairs, false, mutant_ok)
	quit(0 if all_cards_reached and never_best.is_empty() and mutant_ok else 1)


func _sig(exs: Array) -> String:
	var h := 0
	for x in exs:
		h = (h * 31 + str(x["at"]).hash() + str(x["psit"]).hash() + int(x["won"])) & 0x7FFFFFFF
	return str(h) + ":" + str(exs.size())


func _write_result_doc(card_counts: Dictionary, sit_counts: Dictionary, card_sit: Dictionary,
		reach_data: Dictionary, never_pairs: Array, control_failed: bool, mutant_ok: bool) -> void:
	var f := FileAccess.open("res://docs/CARDVISIT1_RESULT.md", FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write result doc")
		return
	var dt := Time.get_datetime_string_from_system()
	var cards := ["outside", "long", "mid", "inside", "clinch", "own_ropes", "opp_ropes", "corner"]
	var sits := ["press", "range", "counter", "counter_late", "loadup", "tiring", "hurt", "hurt_danger", "she_tired", "she_hurt"]
	f.store_line("# CARDVISIT1 Result")
	f.store_line("")
	f.store_line("Probe run: %s. %d fighters, %d opponents, 2 bouts each." % [dt, N_FIGHTERS, OPPS.size()])
	f.store_line("")
	f.store_line("## Question")
	f.store_line("")
	f.store_line("Which cards does a played bout ever reach, and which plan lines can ever fire there?")
	f.store_line("")
	f.store_line("## Method")
	f.store_line("")
	f.store_line("60 generated fighters (seeds 7100-7159), 4 style opponents, 2 bouts per fighter per opponent.")
	f.store_line("All step/defence bars at 45 (Usable). BASE plan = treevalue's PLAN (16 arrows).")
	f.store_line("Opponent ratings CALIBRATED so BASE wins about 50 in 100: %s." % str(opp_rating))
	f.store_line("")
	if control_failed:
		f.store_line("**CONTROL FAILED: determinism broken**")
		f.close()
		return
	f.store_line("## Card x Situation Table")
	f.store_line("")
	var total_ex := 0
	for card in cards:
		total_ex += int(card_counts.get(card, 0))
	f.store_line("Share of %d total exchanges." % total_ex)
	f.store_line("")
	var hdr := "| Card |"
	var sep := "|------|"
	for s in sits:
		hdr += " %s |" % s.left(8)
		sep += "---------|"
	hdr += " TOTAL |"
	sep += "---------|"
	f.store_line(hdr)
	f.store_line(sep)
	for card in cards:
		var card_str: String = str(card)
		var line := "| %s |" % card_str
		var row_total := 0
		for s in sits:
			var s_str: String = str(s)
			var key: String = card_str + "|" + s_str
			var c := int(card_sit.get(key, 0))
			row_total += c
			line += " %.1f%% |" % (float(c) * 100.0 / float(total_ex)) if c > 0 else " . |"
		line += " %.1f%% |" % (float(row_total) * 100.0 / float(total_ex))
		f.store_line(line)
	f.store_line("")
	f.store_line("## REACH")
	f.store_line("")
	f.store_line("Share of exchanges where card == move.from AND psit == sit.")
	f.store_line("")
	f.store_line("| Move | Situation | Category | REACH |")
	f.store_line("|------|-----------|----------|-------|")
	var keys: Array = reach_data.keys()
	keys.sort()
	for k in keys:
		var key: String = str(k)
		var parts: PackedStringArray = key.split("|")
		var rd: Dictionary = reach_data[key]
		var tag := "NEVER" if float(rd["share"]) <= 0.0 else "%.2f%%" % float(rd["share"])
		f.store_line("| %s | %s | %s | %s |" % [str(parts[0]), str(parts[1]), str(rd["cat"]), tag])
	f.store_line("")
	f.store_line("## Controls")
	f.store_line("")
	f.store_line("Determinism: same seeds twice give identical exchange tables.")
	f.store_line("Mutant arm (force at=outside): step_in REACH > 0 = %s." % ("yes" if mutant_ok else "NO"))
	f.store_line("")
	var never_cards: Array = []
	for card in cards:
		if int(card_counts.get(card, 0)) == 0:
			never_cards.append(card)
	f.store_line("## Summary")
	f.store_line("")
	f.store_line("Never-reached cards: %s." % (",".join(never_cards) if not never_cards.is_empty() else "none"))
	f.store_line("Never-reached best pairs: %s." % (",".join(never_pairs) if not never_pairs.is_empty() else "none"))
	f.store_line("")
	f.store_line("`CARDVISIT never_cards=%s never_best=%d pairs=%s`" % [
		",".join(never_cards) if not never_cards.is_empty() else "none",
		never_pairs.size(),
		",".join(never_pairs) if not never_pairs.is_empty() else "none"])
	f.close()
	print("Result doc written to docs/CARDVISIT1_RESULT.md")
