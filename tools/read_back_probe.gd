extends SceneTree
## READBACK1 - where the 6.5 points go when she waits for your best plan line, and what wins them back.
## Start from tools/cover_probe.gd: Lucy vs Maria Ortega (Pressure fighter), GOOD plan, no film, no shouts, 3 rounds.
## 400 bouts a cell, same seeds in every cell so cells are paired.
## Arms: (1) CONTROLS - no plan; plan, nobody waiting; she waits from round 2 (x -0.5).
## (2) WHERE THE POINTS GO - per-round breakdown for plain plan and waited arms.
## (3) THE WAY BACK - one arm each: a) drop the line; b) swap for next-best right answer; c-f cannot be built without editing game files.
## Usage: <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/read_back_probe.gd -- [bouts]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]


func _initialize() -> void:
	var n := 400
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		n = int(args[0])
	print("READBACK1 population: Lucy vs Maria Ortega (Pressure fighter), GOOD plan %s, film 0, no shouts, 3 rounds, n=%d per arm, same dice days" % [str(GOOD.map(func(a): return a["move"])), n])
	# 1. CONTROLS
	print("--- 1. CONTROLS ---")
	var ctrl_no_plan := _run_basic("no plan", [], n, false, false, "")
	var ctrl_plan := _run_basic("plan", GOOD, n, false, false, "")
	var ctrl_waited := _run_basic("waits x-0.5", GOOD, n, true, false, "")
	print("CTRL no plan    -> %s" % ctrl_no_plan)
	print("CTRL plan       -> %s" % ctrl_plan)
	print("CTRL waited     -> %s" % ctrl_waited)
	# 2. WHERE THE POINTS GO
	print("--- 2. WHERE THE POINTS GO ---")
	_run_detailed("plan (detail)", GOOD, n, false, false)
	_run_detailed("waits (detail)", GOOD, n, true, false)
	# 3. THE WAY BACK
	print("--- 3. THE WAY BACK ---")
	var arm_drop := _run_basic("drop", GOOD, n, true, true, "")
	var arm_swap := _run_basic("swap", GOOD, n, true, false, "swap")
	print("ARM drop        -> %s" % arm_drop)
	print("ARM swap        -> %s" % arm_swap)
	# Arms c-f cannot be built without editing game files:
	# c) decoy (waited line stays at lower pick weight) - requires PlanFight.choose changes
	# d) set-up (waited line only after another landed) - requires LiveRound/PlanFight changes
	# e) her wait costs her (other lines x1.25) - requires plan_edge calculation changes
	# f) e + b together - same issue
	print("ARM c (decoy)   -> CANNOT BUILD: requires PlanFight.choose to weight arrows differently")
	print("ARM d (set-up)  -> CANNOT BUILD: requires LiveRound to track which lines landed this round")
	print("ARM e (penalize)-> CANNOT BUILD: requires plan_edge calculation to boost other lines")
	print("ARM f (e+b)     -> CANNOT BUILD: requires both e and b changes")
	# 4. SUMMARY TABLE
	print("--- 4. SUMMARY TABLE ---")
	print("arm             win%    diff_waited  diff_plan")
	var plan_pct := _extract_pct(ctrl_plan)
	var waited_pct := _extract_pct(ctrl_waited)
	var drop_pct := _extract_pct(arm_drop)
	var swap_pct := _extract_pct(arm_swap)
	print("plan            %.1f    +%.1f        --" % [plan_pct, plan_pct - waited_pct])
	print("waits x-0.5     %.1f    --           %.1f" % [waited_pct, waited_pct - plan_pct])
	print("drop            %.1f    +%.1f        %.1f" % [drop_pct, drop_pct - waited_pct, drop_pct - plan_pct])
	print("swap            %.1f    +%.1f        %.1f" % [swap_pct, swap_pct - waited_pct, swap_pct - plan_pct])
	print("--- PROBE COMPLETE ---")
	quit(0)


func _extract_pct(result: String) -> float:
	# Extract "bouts won XX.X%" from the result string
	var idx := result.find("bouts won ")
	if idx < 0:
		return 0.0
	var sub := result.substr(idx + 10)
	var pct_str := sub.substr(0, sub.find("%"))
	return float(pct_str)


func _run_basic(label: String, arrows: Array, n: int, wait: bool, drop: bool, mode: String) -> String:
	var bouts_won := 0
	var r23_won := 0
	var r23_all := 0
	var top_share := 0.0
	var tops := {}
	var swaps := {}
	var sample_r2 := ""
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["morale"] = 60.0
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		f["arrows"] = arrows.duplicate(true)
		c.coach = {}
		var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "start")
		while true:
			while not LiveRound.live(m).is_empty():
				Bouts.fight_step(c, f, m, "shout:")
			if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
				break
			# Find the top line from round 1
			var by := {}
			var sit_of := {}
			var total := 0.0
			for ro in m["rounds"]:
				for x in ro["exchanges"]:
					if bool(x.get("planned", false)) and float(x.get("plan_edge", 0.0)) > 0.0:
						by[str(x["arrow"])] = float(by.get(str(x["arrow"]), 0.0)) + float(x["plan_edge"])
						total += float(x["plan_edge"])
						sit_of[str(x["arrow"])] = str(x.get("psit", x.get("sit", "")))
			var top := ""
			for k in by:
				if top == "" or float(by[k]) > float(by[top]):
					top = k
			if top != "" and int(m["round"]) == 1:
				top_share += float(by[top]) / maxf(total, 0.001)
				tops[top] = int(tops.get(top, 0)) + 1
			if wait and top != "" and int(m["round"]) == 1:
				f["bout"]["covered"] = {top: -0.5}
				if mode == "swap" and int(m["round"]) == 1:
					var have := (f["bout"].get("arrows", []) as Array).map(func(a): return str(a["move"]))
					var alt := ""
					for mv in (PlanFight.ANSWERS.get(str(sit_of.get(top, "")), {}) as Dictionary).get("best", []):
						if not have.has(str(mv)) and alt == "":
							alt = str(mv)
					if alt != "":
						f["bout"]["arrows"] = (f["bout"]["arrows"] as Array).map(func(a): return {"move": alt} if str(a["move"]) == top else a)
						swaps[alt] = int(swaps.get(alt, 0)) + 1
				if drop:
					f["bout"]["arrows"] = (f["bout"].get("arrows", []) as Array).filter(func(a): return str(a["move"]) != top)
			# Sample round 2 lines for first bout to prove the arm did what its name says
			if i == 0 and int(m["round"]) == 2 and sample_r2 == "":
				var r2_lines := []
				for x in (m["rounds"] as Array)[-1]["exchanges"]:
					if bool(x.get("planned", false)):
						r2_lines.append(str(x["arrow"]))
				sample_r2 = "R2 lines: %s" % str(r2_lines)
			Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
		Bouts.fight_step(c, f, m, "end")
		bouts_won += int(str(m.get("outcome", "")) == "win")
		for k in range(1, (m["rounds"] as Array).size()):
			r23_all += 1
			r23_won += int(bool(m["rounds"][k]["won"]))
	var result := "bouts won %.1f%%  rounds 2-3 won %.1f%%  top line's share of round 1 edge %.2f  top lines %s swaps %s" % [
		100.0 * bouts_won / n, 100.0 * r23_won / maxf(1, r23_all), top_share / n, tops, swaps]
	if sample_r2 != "":
		result += "  [%s]" % sample_r2
	return result


func _run_detailed(label: String, arrows: Array, n: int, wait: bool, drop: bool) -> void:
	# Per-round breakdown: each plan line's uses, exchanges won/lost, planned edge earned; round's reads; score; stoppages
	var round_stats := {}  # round -> {line -> {uses, won, lost, edge}, reads: [], scores: [], stoppages: 0}
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["morale"] = 60.0
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		f["arrows"] = arrows.duplicate(true)
		c.coach = {}
		var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "start")
		while true:
			while not LiveRound.live(m).is_empty():
				Bouts.fight_step(c, f, m, "shout:")
			if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
				break
			# Find the top line from round 1
			var by := {}
			var sit_of := {}
			for ro in m["rounds"]:
				for x in ro["exchanges"]:
					if bool(x.get("planned", false)) and float(x.get("plan_edge", 0.0)) > 0.0:
						by[str(x["arrow"])] = float(by.get(str(x["arrow"]), 0.0)) + float(x["plan_edge"])
						sit_of[str(x["arrow"])] = str(x.get("psit", x.get("sit", "")))
			var top := ""
			for k in by:
				if top == "" or float(by[k]) > float(by[top]):
					top = k
			if wait and top != "" and int(m["round"]) == 1:
				f["bout"]["covered"] = {top: -0.5}
				if drop:
					f["bout"]["arrows"] = (f["bout"].get("arrows", []) as Array).filter(func(a): return str(a["move"]) != top)
			Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
		Bouts.fight_step(c, f, m, "end")
		# Collect stats per round
		for ri in (m["rounds"] as Array).size():
			var ro: Dictionary = m["rounds"][ri]
			var rkey := "R%d" % (ri + 1)
			if not round_stats.has(rkey):
				round_stats[rkey] = {"lines": {}, "reads_final": 0, "won": 0, "total": 0, "stoppages": 0}
			var rs: Dictionary = round_stats[rkey]
			rs["won"] += int(bool(ro["won"]))
			rs["total"] += 1
			if str(m.get("outcome", "")) != "" and ri == (m["rounds"] as Array).size() - 1:
				if str(m.get("outcome", "")).ends_with("stop"):
					rs["stoppages"] += 1
			for x in ro["exchanges"]:
				var arrow := str(x.get("arrow", ""))
				if not rs["lines"].has(arrow):
					rs["lines"][arrow] = {"uses": 0, "won": 0, "lost": 0, "edge": 0.0}
				var ln: Dictionary = rs["lines"][arrow]
				if bool(x.get("planned", false)):
					ln["uses"] += 1
					ln["won"] += int(bool(x["won"]))
					ln["lost"] += int(not bool(x["won"]))
					ln["edge"] += float(x.get("plan_edge", 0.0))
			# Track final reads (from last exchange)
			if ro["exchanges"].size() > 0:
				var last_x: Dictionary = ro["exchanges"][-1]
				rs["reads_final"] += int(last_x.get("reads", 0))
	# Print the stats
	print("DETAILED: %s" % label)
	for rkey in ["R1", "R2", "R3"]:
		if not round_stats.has(rkey):
			continue
		var rs: Dictionary = round_stats[rkey]
		print("  %s: rounds won %d/%d (%.1f%%), stoppages %d" % [rkey, rs["won"], rs["total"], 100.0 * rs["won"] / maxf(1, rs["total"]), rs["stoppages"]])
		print("    lines: uses, won, lost, edge")
		for arrow in rs["lines"]:
			var ln: Dictionary = rs["lines"][arrow]
			if ln["uses"] > 0:
				print("      %-12s %4d %4d %4d %+.1f" % [arrow, ln["uses"], ln["won"], ln["lost"], ln["edge"]])
		print("    mean final reads: %.2f" % (float(rs["reads_final"]) / maxf(1, rs["total"])))
