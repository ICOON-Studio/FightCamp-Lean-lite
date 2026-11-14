extends SceneTree
## NODEREAD1: which of the 16 MoveTree.NODES does the bout actually read?
## For each node: BASE (all 65) vs node-at-0 and node-at-95, 300 paired bouts per cell.
## READ = yes when any opponent's win% moves >= 1.0 between 0 and 95.
## Usage: python ops/Tools/godot_slot.py run --who noderead1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/noderead_probe.gd

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")

const OPPS := [
	{"name": "Maria Ortega", "style": "Pressure fighter"},
	{"name": "Priya Nair", "style": "Counter-puncher"},
	{"name": "Erin Doyle", "style": "Volume puncher"},
	{"name": "Dana Whitfield", "style": "Boxer-puncher"},
]
## Plan: arrows from PlanFight.ANSWERS best/ok lists covering every PUNCH_ID via combos,
## plus every step/defence id that appears in the situation table.
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
]


func _find_opp(name: String) -> Dictionary:
	for opp in Data.OPPONENTS:
		if str(opp["name"]) == name:
			return (opp as Dictionary).duplicate(true)
	if Data.MISMATCH["name"] == name:
		return (Data.MISMATCH as Dictionary).duplicate(true)
	return {}


func _run_bout(seed_offset: int, opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
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
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3, "fire_level": {}}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")
	var total_landed := 0
	for r in m.get("rounds", []):
		var ln: Array = (r as Dictionary).get("landed", [0, 0])
		total_landed += int(ln[0])
	return {"outcome": str(m.get("outcome", "")), "landed": total_landed}


func _run_cell(opp_name: String, moves: Dictionary, steps: Dictionary, combos: Dictionary, n: int) -> Dictionary:
	var wins := 0
	var outcomes: Array = []
	for i in n:
		var r := _run_bout(i, opp_name, moves, steps, combos)
		wins += int(str(r["outcome"]) == "win")
		outcomes.append(r)
	return {"wins": wins, "outcomes": outcomes}


func _initialize() -> void:
	print("=== NODEREAD1: which move-tree nodes does the bout read? ===")
	print("Nodes: %d, Opponents: %d" % [MoveTree.NODES.size(), OPPS.size()])
	print("Plan: %s" % str(PLAN.map(func(a): return str(a["move"]) + (":" + str(a["when"]) if a.has("when") else ""))))
	var plan_nodes := {}
	for arrow in PLAN:
		var mid: String = str(arrow["move"])
		if MoveTree.COMBO_PUNCHES.has(mid):
			for p in MoveTree.COMBO_PUNCHES[mid]:
				plan_nodes[p] = true
		else:
			plan_nodes[mid] = true
	print("Plan covers %d of 16 nodes: %s" % [plan_nodes.size(), ", ".join(plan_nodes.keys())])
	var uncovered: Array = []
	for node in MoveTree.NODES:
		if not plan_nodes.has(str(node["id"])):
			uncovered.append(str(node["id"]))
	if not uncovered.is_empty():
		print("Not in plan (still tested): %s" % ", ".join(uncovered))
	# PILOT: 20 bouts a cell, project time
	var pilot_n := 20
	var t0 := Time.get_ticks_msec()
	var dummy_moves := {}; for k in Data.MOVES: dummy_moves[k] = 65.0
	var dummy_steps := {}; for k in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS: dummy_steps[k] = 65.0
	var dummy_combos := {}; for k in MoveTree.COMBO_PUNCHES: dummy_combos[k] = 65.0
	_run_cell(OPPS[0]["name"], dummy_moves, dummy_steps, dummy_combos, pilot_n)
	_run_cell(OPPS[0]["name"], dummy_moves, dummy_steps, dummy_combos, pilot_n)
	var pilot_ms := Time.get_ticks_msec() - t0
	var n_cells := 1 + 1 + MoveTree.NODES.size() * 2
	var total_cells := n_cells * OPPS.size()
	var proj_min := float(pilot_ms) / float(pilot_n * 2) * float(total_cells * 300) / 60000.0
	print("Pilot: %d ms for %d bouts -> projected %.1f min for full run" % [pilot_ms, pilot_n * 2, proj_min])
	var n := 300
	if proj_min > 60.0:
		n = 150
		print("Over 60 min, dropping to %d bouts a cell" % n)
	print("Using %d bouts a cell, %d cells, %d opponents -> %d total bouts" % [n, n_cells, OPPS.size(), n * total_cells])
	# CONTROL: BASE run twice must give identical win count (determinism)
	print("--- CONTROL: determinism ---")
	var ctrl_a := _run_cell(OPPS[0]["name"], dummy_moves, dummy_steps, dummy_combos, n)
	var ctrl_b := _run_cell(OPPS[0]["name"], dummy_moves, dummy_steps, dummy_combos, n)
	if ctrl_a["wins"] != ctrl_b["wins"]:
		print("DETERMINISM FAILED: ctrl_a wins=%d ctrl_b wins=%d" % [ctrl_a["wins"], ctrl_b["wins"]])
		print("NODEREAD read=0 unread=ALL (determinism broken)")
		quit(1)
		return
	var ctrl_same := true
	for i in n:
		var a: Dictionary = ctrl_a["outcomes"][i]
		var b: Dictionary = ctrl_b["outcomes"][i]
		if str(a["outcome"]) != str(b["outcome"]) or int(a["landed"]) != int(b["landed"]):
			ctrl_same = false
			break
	if not ctrl_same:
		print("DETERMINISM FAILED: outcome/landed differs between two BASE runs")
		print("NODEREAD read=0 unread=ALL (determinism broken)")
		quit(1)
		return
	print("CONTROL OK: %d wins both runs, all %d bouts identical" % [ctrl_a["wins"], n])
	# BASE: all 16 nodes at 65, per opponent
	print("--- BASE: all nodes at 65 ---")
	var base_results := {}
	for opp in OPPS:
		var res := _run_cell(opp["name"], dummy_moves, dummy_steps, dummy_combos, n)
		base_results[opp["name"]] = res
		print("  %s (%s): %d wins (%.1f%%)" % [opp["name"], opp["style"], res["wins"], 100.0 * res["wins"] / n])
	# SWEEP: for each node, set to 0 then 95
	print("--- SWEEP: each node at 0 and 95 ---")
	var rows: Array = []
	for node in MoveTree.NODES:
		var nid: String = str(node["id"])
		var branch: String = str(node["branch"])
		var field := "moves" if MoveTree.PUNCH_IDS.has(nid) else ("steps" if MoveTree.STEP_IDS.has(nid) else "steps")
		var combo_note := ""
		for vi in 2:
			var val := 0.0 if vi == 0 else 95.0
			var m0 := dummy_moves.duplicate(); var s0 := dummy_steps.duplicate(); var c0 := dummy_combos.duplicate()
			if MoveTree.PUNCH_IDS.has(nid):
				m0[nid] = val
				for cid in MoveTree.COMBO_PUNCHES:
					if (MoveTree.COMBO_PUNCHES[cid] as Array).has(nid):
						c0[cid] = val
				combo_note = "combos containing %s also set to %.0f" % [nid, val]
			else:
				s0[nid] = val
			var verify := MoveTree.mastery({"moves": m0, "steps": s0}, nid)
			if vi == 0:
				print("  %s (%s): field=%s, set to 0, verify=%.0f%s" % [nid, branch, field, verify, (" (" + combo_note + ")" if combo_note != "" else "")])
			else:
				print("  %s (%s): field=%s, set to 95, verify=%.0f%s" % [nid, branch, field, verify, (" (" + combo_note + ")" if combo_note != "" else "")])
			var wins_arr: Array = []
			var diffs := 0
			for opp in OPPS:
				var res := _run_cell(opp["name"], m0, s0, c0, n)
				wins_arr.append(res["wins"])
				var base_outcomes: Array = base_results[opp["name"]]["outcomes"]
				for j in n:
					var br: Dictionary = base_outcomes[j]
					var vr: Dictionary = res["outcomes"][j]
					if str(br["outcome"]) != str(vr["outcome"]) or int(br["landed"]) != int(vr["landed"]):
						diffs += 1
			rows.append({"node": nid, "branch": branch, "vi": vi, "wins": wins_arr, "diffs": diffs})
	# RESULTS TABLE
	print("")
	print("=== RESULTS ===")
	var header := "%-12s %-8s" % ["node", "branch"]
	for opp in OPPS:
		header += " %14s" % (str(opp["name"]).left(14))
	header += " %6s" % "diffs"
	print(header)
	var node_results := {}
	for row in rows:
		var vi: int = row["vi"]
		var nid: String = str(row["node"])
		var line := "%-12s %-8s" % [nid, str(row["branch"])]
		for wi in row["wins"]:
			line += " %5d/%4.1f%%" % [wi, 100.0 * wi / n]
		line += " %6d" % row["diffs"]
		if vi == 1:
			var r0: Dictionary = node_results[nid]
			var spread := ""
			var any_read := false
			for oi in OPPS.size():
				var w0: int = r0["wins"][oi]
				var w95: int = row["wins"][oi]
				var d := float(w95 - w0) * 100.0 / n
				spread += " %+.1f" % d
				if absf(d) >= 1.0:
					any_read = true
			line += " | 0:%.1f 95:%.1f -> READ=%s" % [100.0 * r0["wins"][0] / n, 100.0 * row["wins"][0] / n, "yes" if any_read else "NO"]
			node_results[nid]["read"] = any_read
			node_results[nid]["diffs"] = row["diffs"]
		else:
			node_results[nid] = {"wins": row["wins"], "read": false, "diffs": row["diffs"]}
		print(line)
	# SUMMARY
	var read_nodes: Array = []
	var unread_nodes: Array = []
	for node in MoveTree.NODES:
		var nid: String = str(node["id"])
		if node_results[nid]["read"]:
			read_nodes.append(nid)
		else:
			unread_nodes.append(nid)
	print("")
	print("NODEREAD read=%d unread=%s" % [read_nodes.size(), ",".join(unread_nodes) if not unread_nodes.is_empty() else "none"])
	# RESULT DOC
	_write_result_doc(read_nodes, unread_nodes, node_results, n)
	quit(0)


func _write_result_doc(read_nodes: Array, unread_nodes: Array, node_results: Dictionary, n: int) -> void:
	var f := FileAccess.open("res://docs/NODEREAD1_RESULT.md", FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write result doc")
		return
	var dt := Time.get_datetime_string_from_system()
	f.store_line("# NODEREAD1 Result")
	f.store_line("")
	f.store_line("Probe run: %s. n=%d bouts/cell, %d opponents." % [dt, n, OPPS.size()])
	f.store_line("")
	f.store_line("## Question")
	f.store_line("")
	f.store_line("Which of the 16 MoveTree.NODES does the bout actually read? A node the bout does not read")
	f.store_line("makes TREEVALUE1 void (S450: a probe reading the same in both arms is void).")
	f.store_line("")
	f.store_line("## Plan")
	f.store_line("")
	f.store_line("Arrows from PlanFight.ANSWERS best/ok lists:")
	f.store_line("")
	for arrow in PLAN:
		var w := " (when: %s)" % str(arrow["when"]) if arrow.has("when") else ""
		f.store_line("- %s%s" % [str(arrow["move"]), w])
	f.store_line("")
	f.store_line("## Method")
	f.store_line("")
	f.store_line("BASE: all 16 nodes at 65. For each node: same seeds with ONLY that node at 0, then at 95.")
	f.store_line("For punches, combos containing that punch are also set to the same value.")
	f.store_line("READ = yes when any opponent's win% moves >= 1.0 between 0 and 95.")
	f.store_line("")
	f.store_line("## Result")
	f.store_line("")
	f.store_line("**NODEREAD read=%d unread=%s**" % [read_nodes.size(), ",".join(unread_nodes) if not unread_nodes.is_empty() else "none"])
	f.store_line("")
	f.store_line("| Node | Branch | Read | Diffs |")
	f.store_line("|------|--------|------|-------|")
	for node in MoveTree.NODES:
		var nid: String = str(node["id"])
		var nr: Dictionary = node_results[nid]
		f.store_line("| %s | %s | %s | %d |" % [nid, str(node["branch"]), "yes" if nr["read"] else "NO", nr["diffs"]])
	f.store_line("")
	f.store_line("## What the bout reads (evidence)")
	f.store_line("")
	f.store_line("f[\"moves\"] (punch mastery): weapons_edge (BoutRules), PlanFight.can_do/choose, card_mean.")
	f.store_line("f[\"combos\"] (combo mastery): FireLevel.mastery_of/fires, setup, card_mean, LineGrade.")
	f.store_line("f[\"steps\"] (step/defence mastery): NOT read in LiveRound.gd.")
	f.close()
	print("Result doc written to docs/NODEREAD1_RESULT.md")
