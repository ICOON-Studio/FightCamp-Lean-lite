extends SceneTree
## S388 does a plan win fights? (critic: "the plan influences, it does not decide"; docs/PLAYER_PATH.md section 8). Same boxer, same
## opponent, the same days as dice, three plans: none, one that answers a presser, one that walks into her. Prints exchanges won, bouts won
## and the mean edge. Usage: godot --headless --script res://tools/plan_effect_probe.gd -- [bouts]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const BAD := [{"move": "cut_off"}, {"move": "3b-3"}, {"move": "herd"}, {"move": "3b-3@inside"}]


func _initialize() -> void:
	var n := 400
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		n = int(args[0])
	for arm in [["no plan", []], ["good plan", GOOD], ["bad plan", BAD]]:
		print(_run(str(arm[0]), arm[1], n))
	quit(0)


func _run(label: String, arrows: Array, n: int) -> String:
	var won := 0
	var all := 0
	var edge := 0.0
	var bouts_won := 0
	var rounds_won := 0
	var rounds_all := 0
	var grades := {}
	var fits := {}   # S396: how often each kind of planned answer fires
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		f["arrows"] = arrows.duplicate(true)
		f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false,
			"film": 0, "rounds": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		var rw := 0
		for r in m["rounds"]:
			rounds_all += 1
			rw += int(bool(r["won"]))
			for x in r["exchanges"]:
				all += 1
				won += int(bool(x["won"]))
				edge += float(x.get("plan_edge", 0.0))
				var fk := (str(x.get("arrow_fit", "")) if bool(x.get("planned", false)) else "improvised") + ("" if bool(x.get("planned", false)) else "")
				fits[fk] = int(fits.get(fk, 0)) + 1
		rounds_won += rw
		var w := FightWhy.read(m["rounds"], "Lucy", "Maria")
		grades[w["grade"]] = int(grades.get(w["grade"], 0)) + 1
		if i < 6:
			print("WHY %s | %s | %s | %s | %s | %s" % [label, m.get("outcome", ""), FightWhy.GRADES[w["grade"]], w["plan"], w["against"], w["next"]])
		bouts_won += int(str(m.get("outcome", "")) == "win" or (not m.has("outcome") and rw * 2 > (m["rounds"] as Array).size()))
	return "%-10s exchanges won %.1f%%  rounds won %.1f%%  bouts won %.1f%%  mean edge %+.2f  (%d bouts) grades %s" % [label, 100.0 * won / maxf(1, all),
		100.0 * rounds_won / maxf(1, rounds_all), 100.0 * bouts_won / n, edge / maxf(1, all), n, grades] + "  fits %s" % fits
