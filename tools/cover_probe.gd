extends SceneTree
## S423 R25 groundwork, part 2. tools/adapt_probe.gd showed an opponent who switches GAMES between rounds moves nothing (the
## corner's shouts answer each game). The plan is the lever: worth ~16 points (PlanRead header). Here, between rounds, the
## opponent's corner COVERS the plan line that earned the most edge so far: next round that line keeps `cover` of its edge
## (the bout's `covered` hook, LiveRound). Arms: no plan; plan, no cover; covered x0.5 / x0.0; covered x0.5 and the player
## drops that line (the plan falls back to its other lines); she WAITS for it (x-0.5: the edge turns, it counts as a wrong
## answer for the round's reads), and waits + the player drops it. Lucy (Data.lucy, 1-1 and 1-2 at 50) vs Maria Ortega
## (Data.OPPONENTS[0], Pressure fighter), the GOOD plan from tools/plan_effect_probe.gd, no film, no shouts, 3 rounds.
##   <godot.exe> --headless --path . --audio-driver Dummy --script res://tools/cover_probe.gd -- [bouts]

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
	print("COVER population: Lucy vs Maria Ortega (Pressure fighter), GOOD plan %s, film 0, no shouts, 3 rounds, n=%d per arm, same dice days" % [str(GOOD.map(func(a): return a["move"])), n])
	for arm in [["no plan", [], -9.0, false], ["plan", GOOD, -9.0, false], ["covered x0.5", GOOD, 0.5, false],
			["covered x0", GOOD, 0.0, false], ["x0.5 + drop", GOOD, 0.5, true],
			["waits x-0.5", GOOD, -0.5, false], ["waits + drop", GOOD, -0.5, true], ["waits + swap", GOOD, -0.5, false, true],
			["drilled, plan", GOOD, -9.0, false], ["drilled, waits", GOOD, -0.5, false], ["drilled, waits + swap", GOOD, -0.5, false, true]]:
		print(_run(str(arm[0]), arm[1], float(arm[2]), bool(arm[3]), n, arm.size() > 4))
	quit(0)


func _run(label: String, arrows: Array, cover: float, drop: bool, n: int, swap := false) -> String:
	var bouts_won := 0
	var r23_won := 0
	var r23_all := 0
	var top_share := 0.0
	var tops := {}
	var swaps := {}
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["morale"] = 60.0
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		if label.begins_with("drilled"):   # a second answer to her pressing drilled in camp
			f["combos"]["slip 2-3"] = 50.0
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
			if cover > -9.0 and top != "":
				f["bout"]["covered"] = {top: cover}
				if swap and int(m["round"]) == 1:
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
			Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
		Bouts.fight_step(c, f, m, "end")
		bouts_won += int(str(m.get("outcome", "")) == "win")
		for k in range(1, (m["rounds"] as Array).size()):
			r23_all += 1
			r23_won += int(bool(m["rounds"][k]["won"]))
	return "COVER %-13s bouts won %.1f%%  rounds 2-3 won %.1f%%  top line's share of round 1 edge %.2f  top lines %s swaps %s" % [label,
		100.0 * bouts_won / n, 100.0 * r23_won / maxf(1, r23_all), top_share / n, tops, swaps]
