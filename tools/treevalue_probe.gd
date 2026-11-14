extends SceneTree
## TREEVALUE1: is every move-tree node worth drilling against at least one style?
## For each of 16 nodes: 60 generated fighters x 4 style opponents, at 0/45/70.
## VALUE = win% at 70 minus win% at 0. Pass: VALUE >= 1.5 against at least one style.
## Usage: python ops/Tools/godot_slot.py run --who treevalue1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/treevalue_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const PunchStart := preload("res://scripts/rules/PunchStart.gd")
const StepMastery := preload("res://scripts/rules/StepMastery.gd")

## Four opponents of different styles.
const OPPS := [
	{"name": "Maria Ortega", "style": "Pressure fighter"},
	{"name": "Priya Nair", "style": "Counter-puncher"},
	{"name": "Erin Doyle", "style": "Volume puncher"},
	{"name": "Dana Whitfield", "style": "Boxer-puncher"},
]
## Plan: arrows covering every punch via combos, plus every step/defence in the situation table.
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
var mutant_ok := false
## S464 Claude: each style's rating is CALIBRATED so the BASE plan wins about half its bouts (the shipped opponents beat
## these fighters 83-100% of the time - a floor no drill can show a value against). Style, threat and plan stay the opponent's.
var opp_rating := {}
## S464 Claude: the plan a cell fights on. In a node's sweep every OTHER arrow on that node's situation ("when") is left out,
## so the node is the line the bout reads there (first run: step_in at "range" sat behind 2-3 and 1-2-3b and was never read).
var cur_plan: Array = PLAN.duplicate(true)


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
	return {}


## Generate a varied fighter from a seed. Returns a fighter_state dict.
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
	f["arrows"] = cur_plan.duplicate(true)
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
	return {"outcome": str(m.get("outcome", ""))}


func _run_cell(opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, n: int) -> Dictionary:
	var wins := 0
	for i in n * N_FIGHTERS:
		var r := _run_bout(i, opp_name, moves, steps, combos)
		wins += int(str(r["outcome"]) == "win")
	return {"wins": wins}


func _base_dict() -> Dictionary:
	var moves := {}; var steps := {}; var combos := {}
	for k in Data.MOVES:
		moves[k] = BASE_VAL
	for k in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS:
		steps[k] = BASE_VAL
	for k in MoveTree.COMBO_PUNCHES:
		combos[k] = BASE_VAL
	return {"moves": moves, "steps": steps, "combos": combos}


func _initialize() -> void:
	print("=== TREEVALUE1: is every node worth drilling against at least one style? ===")
	print("fire_level key absent: GAME_SHARES")
	print("Nodes: %d, Fighters: %d, Opponents: %d" % [MoveTree.NODES.size(), N_FIGHTERS, OPPS.size()])
	print("Plan: %s" % str(PLAN.map(func(a): return str(a["move"]) + (":" + str(a["when"]) if a.has("when") else ""))))
	# Print 5 sample fighters
	print("--- Sample fighters (5 of %d) ---" % N_FIGHTERS)
	for si in 5:
		var f := _make_fighter(SEED_START + si * 10)
		var st: Dictionary = f["stats"]
		print("  %s: technique=%.1f fight_iq=%.1f footwork=%.1f rating=%.1f" % [
			f["name"], float(st["technique"]), float(st["fight_iq"]), float(f.get("footwork", 50.0)), float(f.get("pot", 60.0))])
	# PILOT: 10 bouts a cell, project time
	var pilot_n := 10
	var t0 := Time.get_ticks_msec()
	var base := _base_dict()
	for pi in pilot_n:
		_run_bout(pi, str(OPPS[0]["name"]), base["moves"], base["steps"], base["combos"])
	var pilot_ms := Time.get_ticks_msec() - t0
	var n_cells := 1 + 2 + MoveTree.NODES.size() * 2
	var total_cells := n_cells * OPPS.size()
	var proj_min := float(pilot_ms) / float(pilot_n) * float((total_cells + 80) * N_FIGHTERS) / 60000.0
	print("Pilot: %d ms for %d bouts -> projected %.1f min for full run" % [pilot_ms, pilot_n, proj_min])
	var n := 2  # bouts per fighter per cell: a cell = every one of the 60 fighters twice (120 bouts, 0.83 in 100 a bout)
	print("--- CALIBRATE: each style's rating so BASE wins about 50 in 100 (bisect, 7 steps, 60 bouts each) ---")
	for opp in OPPS:
		var on: String = str(opp["name"])
		var lo := 30.0
		var hi := float(_find_opp(on)["rating"])
		for _k in 7:
			opp_rating[on] = (lo + hi) / 2.0
			var w := int(_run_cell(on, base["moves"], base["steps"], base["combos"], 1)["wins"])
			if w > N_FIGHTERS / 2:
				lo = float(opp_rating[on])
			else:
				hi = float(opp_rating[on])
		print("  %s (%s): shipped rating %.1f -> calibrated %.2f" % [on, str(opp["style"]), float(_find_opp(on)["rating"]), float(opp_rating[on])])
	print("Using %d bouts a cell, %d cells, %d opponents -> %d total bouts" % [n, n_cells, OPPS.size(), n * total_cells])
	# CONTROL 1: BASE run twice must give identical win count (determinism)
	print("--- CONTROL 1: determinism ---")
	var ctrl_a := _run_cell(str(OPPS[0]["name"]), base["moves"], base["steps"], base["combos"], n)
	var ctrl_b := _run_cell(str(OPPS[0]["name"]), base["moves"], base["steps"], base["combos"], n)
	if ctrl_a["wins"] != ctrl_b["wins"]:
		print("DETERMINISM FAILED: ctrl_a wins=%d ctrl_b wins=%d" % [int(ctrl_a["wins"]), int(ctrl_b["wins"])])
		_write_result_doc({}, [], [], [], 0, 0, 0, 0, true)
		quit(1)
		return
	print("CONTROL OK: %d wins both runs" % int(ctrl_a["wins"]))
	# CONTROL 2: mutant arm - simplified check
	print("--- CONTROL 2: mutant arm (FireLevel.probe_off = true, every line fires) ---")
	FireLevel.probe_off = true
	var mut_max := 0.0
	for sid in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS:
		var mw := {}
		for val in [0, 70]:
			var s_m: Dictionary = (base["steps"] as Dictionary).duplicate()
			s_m[sid] = float(val)
			mw[val] = int(_run_cell(str(OPPS[0]["name"]), base["moves"], s_m, base["combos"], n)["wins"])
		var mv := float(int(mw[70]) - int(mw[0])) * 100.0 / float(n * N_FIGHTERS)
		mut_max = maxf(mut_max, absf(mv))
		print("  mutant %s: %d -> %d (VALUE %+.1f)" % [sid, int(mw[0]), int(mw[70]), mv])
	FireLevel.probe_off = false
	mutant_ok = mut_max <= 0.5
	print("Mutant arm every step/defence VALUE within +-0.5: %s (max |VALUE| %.1f)" % ["yes" if mutant_ok else "NO", mut_max])
	# BASE: all 16 nodes at 45, per opponent
	print("--- BASE: all nodes at 45 ---")
	var base_results := {}
	for opp in OPPS:
		var opp_name: String = str(opp["name"])
		var moves_d: Dictionary = (base["moves"] as Dictionary).duplicate()
		var steps_d: Dictionary = (base["steps"] as Dictionary).duplicate()
		var combos_d: Dictionary = (base["combos"] as Dictionary).duplicate()
		var res := _run_cell(opp_name, moves_d, steps_d, combos_d, n)
		base_results[opp_name] = res
		print("  %s (%s): %d wins (%.1f%%)" % [opp_name, str(opp["style"]), int(res["wins"]), 100.0 * int(res["wins"]) / float(n * N_FIGHTERS)])
	# SWEEP: for each node, at 0, 45, 70
	print("--- SWEEP: each node at 0, 45, 70 ---")
	var node_results := {}
	for node in MoveTree.NODES:
		var nid: String = str(node["id"])
		var branch: String = str(node["branch"])
		var combo_note := ""
		if MoveTree.PUNCH_IDS.has(nid):
			combo_note = "combos containing %s also set" % nid
		print("  %s (%s): %s" % [nid, branch, combo_note if combo_note != "" else "step/defence"])
		var wins_at := {0: [], 70: []}
		cur_plan = _plan_for(nid)
		print("    plan: %s" % str(cur_plan.map(func(x): return str(x["move"]) + (":" + str(x["when"]) if x.has("when") else ""))))
		for val in [0, 70]:
			for opp in OPPS:
				var m0: Dictionary = (base["moves"] as Dictionary).duplicate()
				var s0: Dictionary = (base["steps"] as Dictionary).duplicate()
				var c0: Dictionary = (base["combos"] as Dictionary).duplicate()
				if MoveTree.PUNCH_IDS.has(nid):
					m0[nid] = float(val)
					for cid in MoveTree.COMBO_PUNCHES:
						if (MoveTree.COMBO_PUNCHES[cid] as Array).has(nid):
							c0[cid] = float(val)
				else:
					s0[nid] = float(val)
				var res := _run_cell(str(opp["name"]), m0, s0, c0, n)
				(wins_at[val] as Array).append(int(res["wins"]))
		node_results[nid] = {"branch": branch, "wins_at": wins_at}
	cur_plan = PLAN.duplicate(true)
	# Calculate VALUE per node per style
	print("")
	print("=== RESULTS ===")
	var header := "%-12s %-8s" % ["node", "branch"]
	for opp in OPPS:
		header += " %14s" % (str(opp["name"]).left(14))
	header += " %8s" % "VALUE"
	print(header)
	var pass_nodes: Array = []
	var fail_nodes: Array = []
	var best_by_style := {}
	for node in MoveTree.NODES:
		var nid: String = str(node["id"])
		var nr: Dictionary = node_results[nid]
		var line := "%-12s %-8s" % [nid, str(nr["branch"])]
		var max_value := -999.0
		var max_style := ""
		for oi in OPPS.size():
			var opp: Dictionary = OPPS[oi] as Dictionary
			var w0: int = int((nr["wins_at"] as Dictionary)[0][oi])
			var w70: int = int((nr["wins_at"] as Dictionary)[70][oi])
			var total := n * N_FIGHTERS
			var value := float(w70 - w0) * 100.0 / float(total)
			line += " %5d->%5d" % [w0, w70]
			if value > max_value:
				max_value = value
				max_style = str(opp["style"])
		line += " %+.1f" % max_value
		if max_value >= 1.5:
			pass_nodes.append(nid)
			if max_style != "":
				if not best_by_style.has(max_style):
					best_by_style[max_style] = nid
				elif best_by_style[max_style] != nid:
					best_by_style[max_style] = "MULTI"
		else:
			fail_nodes.append(nid)
		print(line)
	# Check if any node is best against all four styles
	var best_everywhere := "none"
	for opp in OPPS:
		var opp_style: String = str(opp["style"])
		var best_node := ""
		var best_val := -999.0
		for node in MoveTree.NODES:
			var nid: String = str(node["id"])
			var nr: Dictionary = node_results[nid]
			var oi: int = OPPS.find(opp)
			var w0: int = int((nr["wins_at"] as Dictionary)[0][oi])
			var w70: int = int((nr["wins_at"] as Dictionary)[70][oi])
			var total := n * N_FIGHTERS
			var value := float(w70 - w0) * 100.0 / float(total)
			if value > best_val:
				best_val = value
				best_node = nid
		if best_everywhere == "none":
			best_everywhere = best_node
		elif best_everywhere != best_node:
			best_everywhere = "none"
			break
	# ANSWERS curve: fighters with 6 and 9 Usable answer nodes
	print("")
	print("--- ANSWERS curve: 6 vs 9 Usable answer nodes ---")
	var answer_nodes_6 := _pick_answer_nodes(6)
	var answer_nodes_9 := _pick_answer_nodes(9)
	print("6 Usable: %s" % ", ".join(answer_nodes_6))
	print("9 Usable: %s" % ", ".join(answer_nodes_9))
	var answers_6_wins := 0
	var answers_9_wins := 0
	for opp in OPPS:
		var m6: Dictionary = (base["moves"] as Dictionary).duplicate()
		var s6: Dictionary = (base["steps"] as Dictionary).duplicate()
		var c6: Dictionary = (base["combos"] as Dictionary).duplicate()
		var m9: Dictionary = (base["moves"] as Dictionary).duplicate()
		var s9: Dictionary = (base["steps"] as Dictionary).duplicate()
		var c9: Dictionary = (base["combos"] as Dictionary).duplicate()
		for nid in MoveTree.NODES:   # S464: punches stay at BASE; only the answer steps/defences vary (6 vs 9 Usable)
			var id_str: String = str(nid["id"])
			if MoveTree.PUNCH_IDS.has(id_str):
				continue
			if not answer_nodes_6.has(id_str):
				s6[id_str] = 0.0
			if not answer_nodes_9.has(id_str):
				s9[id_str] = 0.0
		var r6 := _run_cell(str(opp["name"]), m6, s6, c6, n)
		var r9 := _run_cell(str(opp["name"]), m9, s9, c9, n)
		answers_6_wins += int(r6["wins"])
		answers_9_wins += int(r9["wins"])
		print("  %s: 6 Usable=%d wins, 9 Usable=%d wins" % [str(opp["name"]), int(r6["wins"]), int(r9["wins"])])
	var answers_rise := answers_9_wins > answers_6_wins
	print("Answers rise from 6 to 9: %s" % ("yes" if answers_rise else "NO"))
	# Final summary
	print("")
	print("every node VALUE >= 1.5 vs one style: %s" % ("yes" if fail_nodes.is_empty() else "NO"))
	print("no node best against all four styles: %s" % ("yes" if best_everywhere == "none" else "NO"))
	print("wins rise from 6 to 9 Usable answers: %s" % ("yes" if answers_rise else "NO"))
	print("TREEVALUE pass=%d fail=%s best_everywhere=%s answers6=%d answers9=%d mutant_ok=%s" % [
		pass_nodes.size(), ",".join(fail_nodes) if not fail_nodes.is_empty() else "none",
		best_everywhere, answers_6_wins, answers_9_wins, "yes" if mutant_ok else "NO"])
	_write_result_doc(node_results, pass_nodes, fail_nodes, OPPS, answers_6_wins, answers_9_wins, n, N_FIGHTERS, false)
	quit(0 if fail_nodes.is_empty() and best_everywhere == "none" and answers_rise else 1)


func _pick_answer_nodes(target_count: int) -> Array:
	var answer_ids: Array = []
	for sit in PlanFight.ANSWERS:
		var row: Dictionary = PlanFight.ANSWERS[sit]
		for cat in ["best", "ok"]:
			for move_id in row.get(cat, []):
				var node_ok := MoveTree.NODES.any(func(nd): return str(nd["id"]) == str(move_id))
				if node_ok and not answer_ids.has(move_id):   # S464: nodes only (combo ids are not nodes)
					answer_ids.append(move_id)
	if answer_ids.size() <= target_count:
		return answer_ids
	var out: Array = []
	for i in target_count:
		out.append(answer_ids[i])
	return out


func _write_result_doc(node_results: Dictionary, pass_nodes: Array, fail_nodes: Array, opps: Array,
		answers_6: int, answers_9: int, n: int, n_fighters: int, control_failed: bool) -> void:
	var f := FileAccess.open("res://docs/TREEVALUE1_RESULT.md", FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write result doc")
		return
	var dt := Time.get_datetime_string_from_system()
	f.store_line("# TREEVALUE1 Result")
	f.store_line("")
	f.store_line("Probe run: %s. n=%d bout(s) per fighter per cell, %d fighters, %d opponents." % [dt, n, n_fighters, opps.size()])
	f.store_line("")
	f.store_line("## Question")
	f.store_line("")
	f.store_line("Is every move-tree node worth drilling against at least one style?")
	f.store_line("VALUE = win% at 70 (Sharp) minus win% at 0. Pass: VALUE >= 1.5 against at least one style.")
	f.store_line("")
	f.store_line("## Method")
	f.store_line("")
	f.store_line("60 generated fighters (seeds 7100-7159), 4 style opponents.")
	f.store_line("BASE: all 16 nodes at 45 (Usable). For each node: same seeds at 0 and 70 (45 = BASE).")
	f.store_line("For punches, combos containing that punch are also set.")
	f.store_line("fire_level key ABSENT (game shares: Usable 0.5, Sharp 0.75, Signature 1.0).")
	f.store_line("Opponent ratings CALIBRATED so BASE wins about 50 in 100: %s." % str(opp_rating))
	f.store_line("")
	f.store_line("## Result")
	f.store_line("")
	if control_failed:
		f.store_line("**CONTROL FAILED: determinism broken**")
	else:
		f.store_line("**TREEVALUE pass=%d fail=%s**" % [pass_nodes.size(), ",".join(fail_nodes) if not fail_nodes.is_empty() else "none"])
	f.store_line("")
	f.store_line("| Node | Branch | VALUE per style | Max VALUE |")
	f.store_line("|------|--------|-----------------|-----------|")
	for node in MoveTree.NODES:
		var nid: String = str(node["id"])
		if not node_results.has(nid):
			continue
		var nr: Dictionary = node_results[nid]
		var values_str := ""
		var max_val := -999.0
		for oi in opps.size():
			var w0: int = nr["wins_at"][0][oi]
			var w70: int = nr["wins_at"][70][oi]
			var total := n * n_fighters
			var value := float(w70 - w0) * 100.0 / float(total)
			values_str += "%s:%.1f " % [opps[oi]["style"].left(10), value]
			if value > max_val:
				max_val = value
		f.store_line("| %s | %s | %s | %.1f |" % [nid, str(nr["branch"]), values_str.strip_edges(), max_val])
	f.store_line("")
	f.store_line("## Answers curve")
	f.store_line("")
	f.store_line("6 Usable answer nodes: %d wins" % answers_6)
	f.store_line("9 Usable answer nodes: %d wins" % answers_9)
	f.store_line("Rises: %s" % ("yes" if answers_9 > answers_6 else "NO"))
	f.close()
	print("Result doc written to docs/TREEVALUE1_RESULT.md")
