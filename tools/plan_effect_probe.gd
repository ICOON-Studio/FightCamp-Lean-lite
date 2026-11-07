extends SceneTree
## S388 does a plan win fights? (critic: "the plan influences, it does not decide"; docs/PLAYER_PATH.md section 8). Same boxer, same
## opponent, the same days as dice, three plans: none, one that answers a presser, one that walks into her. Prints exchanges won, bouts won
## and the mean edge. Usage: godot --headless --script res://tools/plan_effect_probe.gd -- [bouts] [arm prefix]

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const PlanPressure := preload("res://scripts/rules/PlanPressure.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
## S396: half right answers (3b-3 is ok on a presser) - the old "bad" arm, kept as "mixed".
const MIXED := [{"move": "cut_off"}, {"move": "3b-3"}, {"move": "herd"}, {"move": "3b-3@inside"}]
## S397: a truly wrong plan for a presser (PlanFight.ANSWERS): every arrow is "wrong" or "none" for her main games on its
## card - mid 1-6-3 (wrong on her load-up, nothing on her press), long 1-2-3-2 (wrong on a counter), step_out when she
## boxes at range (wrong), inside 3b-3 (wrong on a load-up).
const WRONG := [{"move": "1-6-3"}, {"move": "1-2-3-2"}, {"move": "step_out", "when": "range"}, {"move": "3b-3@inside"}]


func _initialize() -> void:
	var n := 400
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		n = int(args[0])
	var only := str(args[1]) if args.size() > 1 else ""
	# S397 the stronger-fighter arms: a plan must not beat a clearly better fighter (opponent rating +/- STRONG).
	for arm in [["no plan", [], 0.0], ["good plan", GOOD, 0.0], ["mixed plan", MIXED, 0.0], ["wrong plan", WRONG, 0.0],
			["good vs +%d" % STRONG, GOOD, STRONG], ["wrong vs -%d" % STRONG, WRONG, -STRONG], ["none vs +%d" % STRONG, [], STRONG],
			# S397 rule 1: the coach's plan when the player writes none (CoachPlan), by coach rating.
			["coach 58", [], 0.0, 58.0], ["coach 74", [], 0.0, 74.0], ["coach 90", [], 0.0, 90.0]]:
		if only == "" or str(arm[0]).begins_with(only):
			print(_run(str(arm[0]), arm[1], n, float(arm[2]), float(arm[3]) if arm.size() > 3 else -1.0))
	quit(0)


const STRONG := 10


func _run(label: String, arrows: Array, n: int, opp_up := 0.0, coach := -1.0) -> String:
	var won := 0
	var all := 0
	var edge := 0.0
	var bouts_won := 0
	var rounds_won := 0
	var rounds_all := 0
	var grades := {}
	var cut := 0
	var tank := 0.0
	var fits := {}   # S396: how often each kind of planned answer fires
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		f["arrows"] = arrows.duplicate(true)
		# S397 rule 1: no coach unless the arm names one (the bout's first bell lets him write the plan she has not).
		c.coach = {"rating": coach} if coach >= 0.0 else {}
		var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
		opp["rating"] = float(opp["rating"]) + opp_up
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false,
			"film": 0, "rounds": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		if coach >= 0.0 and i == 0:
			print("coach %d plan %s" % [int(coach), f["bout"]["arrows"]])
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
		var pt := PlanPressure.tally(m["rounds"])
		cut += int(pt["cut"])
		tank += float(pt["tank"])
		var w := FightWhy.read(m["rounds"], "Lucy", "Maria")
		grades[w["grade"]] = int(grades.get(w["grade"], 0)) + 1
		if i < 6:
			print("WHY %s | %s | %s | %s | %s | %s" % [label, m.get("outcome", ""), FightWhy.GRADES[w["grade"]], w["plan"], w["against"], w["next"]])
		bouts_won += int(str(m.get("outcome", "")) == "win" or (not m.has("outcome") and rw * 2 > (m["rounds"] as Array).size()))
	return "%-12s exchanges won %.1f%%  rounds won %.1f%%  bouts won %.1f%%  mean edge %+.2f  (%d bouts) grades %s" % [label, 100.0 * won / maxf(1, all),
		100.0 * rounds_won / maxf(1, rounds_all), 100.0 * bouts_won / n, edge / maxf(1, all), n, grades] + "  pressure cut %.1f punches, tank lost %.1f a bout  fits %s" % [float(cut) / n, tank / n, fits]
