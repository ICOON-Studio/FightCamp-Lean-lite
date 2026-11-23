extends SceneTree
## S539 PLANREADSHOW1: the "opponents adjust" rule (PlanRead.ADJUST) is shown. Plays real bouts (a walk-down template that
## leans on its one jab against a range boxer, the plan that triggers the rule: plan_templates_test) and checks that
## 1) a bite is recorded on its exchange, one feed line a round; 2) the result Plan tab says it; 3) the live caption carries
## it; 4) the plan chart warns on a plan that leans on one answer; 5) the DIGEST of the bouts is the same before and after
## (nothing the fight decides changed - compare with the digest printed on main). Population: Data.RIVALS out-boxer, 40 days.

const OppFile := preload("res://scripts/rules/OppFile.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")
const ResultTabs := preload("res://scripts/ui/ResultTabs.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const PlanReadShow := preload("res://scripts/rules/PlanReadShow.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const PlanChart := preload("res://scripts/ui/PlanChart.gd")

var failures := 0


func _initialize() -> void:
	PlanReadShow.ComboCounter.on = false   # S540: this test is ADJUST's; the combo counter's own lines are combo_counter_test's
	var ranger: Dictionary = Data.RIVALS.filter(func(r): return str(r["style"]) == "Out-boxer")[0]
	var plan := PlanTemplates.load(PlanTemplates.boxing("t_walk"), PlanBoard.TOP_COACH)
	var digest := 0
	var natural := 0
	var forced_bouts := 0
	var first: Dictionary = {}
	var first_c: Career = null
	var first_f: Dictionary = {}
	var lines_ok := true
	for i in 40:
		# A) the bout as the game plays it: the digest of what the fight decided (must equal main's) and how often the rule bites.
		var c := _career(i, plan, ranger)
		var f: Dictionary = c.fighter()
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		for r in m["rounds"]:
			for x in r["exchanges"]:
				digest = hash([digest, bool(x["won"]), x["margin"], x["landed"], snappedf(float(x.get("plan_edge", 0.0)), 0.0001)])
				natural += 0 if (x.get("read_adj", {}) as Dictionary).is_empty() else 1
		# B) a round where the answers are already spent (three right uses each: the fourth is read): ADJUST bites for sure.
		var c2 := _career(i, plan, ranger)
		var f2: Dictionary = c2.fighter()
		var m2 := {"fid": f2["id"], "step": "tape", "total": 3, "round": 1, "rounds": []}
		LiveRound.open(c2, f2, m2, 1, "", BoutNight._energy(f2, 1, ""))
		var spent := {}
		for a in f2["bout"]["arrows"]:
			spent[str(a["move"])] = 3
		LiveRound.live(m2)["answer_uses"] = spent
		var guard := 0
		while not LiveRound.live(m2).is_empty() and guard < 12:
			guard += 1
			var r := LiveRound.exchange(c2, f2, m2, "")
			if not r.is_empty():
				(m2["rounds"] as Array).append(r)
		var said := 0
		var seen := false
		for x in (m2["rounds"][0] as Dictionary)["exchanges"]:
			if not (x.get("read_adj", {}) as Dictionary).is_empty():
				seen = true
			said += 1 if str(x.get("read_line", "")) != "" else 0
		lines_ok = lines_ok and said == (1 if seen else 0)
		if seen:
			forced_bouts += 1
			if first.is_empty():
				first = m2
				first_c = c2
				first_f = f2
	print("DIGEST ", digest, " natural bites in 40 bouts: ", natural)
	_check(forced_bouts > 0, "ADJUST bites in a round with spent answers (%d of 40)" % forced_bouts)
	_check(lines_ok, "one feed line a round, on the first bite, none without a bite")
	if first.is_empty():
		print("PLAN_READ_SHOWN failures=%d" % (failures + 1))
		quit(1)
		return
	var bites := PlanReadShow.bites(first["rounds"])
	var b: Dictionary = bites.values()[0]
	_check(int(b["cut"]) == 30 and int(b["uses"]) >= PlanReadShow.PlanRead.FREE_USES, "the first bite took 30%% (%s)" % str(b))
	var x0: Dictionary = {}
	for r in first["rounds"]:
		for x in r["exchanges"]:
			if x0.is_empty() and not (x.get("read_adj", {}) as Dictionary).is_empty():
				x0 = x
	_check(PlanReadShow.feed_line("Jab").begins_with("They have your Jab") and not x0.is_empty() and str(x0["read_line"]).contains("pays less"), "the feed line says it pays less")
	# The result Plan tab.
	var tab := ResultTabs.plan(first, ["Lucy", "Rival"])
	root.add_child(tab)
	await process_frame
	var text := ""
	var tips := ""
	for l in tab.find_children("*", "Label", true, false):
		text += (l as Label).text + "\n"
		tips += (l as Label).tooltip_text
	_check(text.contains("read after") and text.contains("paid 30% less"), "the Plan tab says what the read cost: " + "")
	_check(tips.contains("second answer") and tips.contains("drill"), "its tooltip names the fix")
	# The live caption.
	var opp_d: Dictionary = first_f["bout"]["opp"]
	var prof := {"a": RoundStyle.of_fighter(first_f), "b": RoundStyle.from_opponent(opp_d)}
	var ctx := {"n": 1, "plan": "", "a_style": str(first_f.get("style", "")), "b_style": str(opp_d.get("style", "")), "seed": 7, "profiles": prof,
		"f": first_f, "opp": opp_d, "names": ["A", "B"], "day": first_c.day, "won_last": false}
	var xs: Array = (first["rounds"][0] as Dictionary)["exchanges"]
	var caption_ok := false
	for k in xs.size():
		if str(xs[k].get("read_line", "")) != "":
			caption_ok = (ExchangeBeats.build(xs[k], k, {}, ctx) as Array).any(func(bt): return str(bt.get("caption", "")) == str(xs[k]["read_line"]))
	_check(caption_ok, "the live fight's caption carries the line")
	# The plan chart's warning.
	_check(PlanReadShow.lean_move([{"move": "1"}, {"move": "1"}, {"move": "1"}, {"move": "2"}]) == "1", "three lines of four on one answer lean")
	_check(PlanReadShow.lean_move([{"move": "1"}, {"move": "2"}, {"move": "3"}]) == "", "a spread plan does not")
	await _chart_chip()
	print("PLAN_READ_SHOWN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The chart on a real career: a plan with one answer on three of its four lines shows the chip; a spread plan does not.
func _chart_chip() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var f: Dictionary = main.career.fighters[0]
	f["arrows"] = [{"move": "1-2", "when": ""}, {"move": "1-2", "when": "press"}, {"move": "1-2", "when": "counter"}, {"move": "slip"}]
	var gp := PlanChart.chart(main, f, func(_m): pass)
	main.add_child(gp)
	await process_frame
	var chip := gp.find_child("LeanChip", true, false)
	_check(chip != null and chip.tooltip_text != "" and chip.tooltip_text != PlanReadShow.LEAN_WORDS, "the chart warns on a plan that leans on one answer, tooltip explains")
	f["arrows"] = [{"move": "1-2", "when": ""}, {"move": "slip", "when": "press"}, {"move": "2-3", "when": "counter"}]
	var gp2 := PlanChart.chart(main, f, func(_m): pass)
	main.add_child(gp2)
	await process_frame
	_check(gp2.find_child("LeanChip", true, false) == null, "a spread plan shows no chip")


func _career(i: int, plan: Array, opp: Dictionary) -> Career:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 40 + i
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0, "1-1-2": 50.0, "2-3": 40.0}
	f["arrows"] = plan.duplicate(true)
	f["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
	OppFile.open_all(f["bout"]["opp"])
	return c


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
