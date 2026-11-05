extends SceneTree
## S387 MENUREVIEW1 WeekRead, on a real career stepped by the real Sim:
##   1. the cause names the sessions that really trained the stat, on their days; an untrained stat has none,
##   2. an ETA matches the week the stat really crosses, within a week,
##   3. a goal on pace reads on pace and really lands; one behind reads behind and really falls short,
##   4. the rank move reads up, down, held, new, out and none,
##   5. the runway is right for a positive, a zero and a negative weekly balance, against the real close rule,
##      and a real gym goes below $0 and closes when it said it would,
##   6. the review draws it all: goal, rank and runway rows land, a report from before S387 still opens.

const Sim := preload("res://scripts/state/Sim.gd")
const WeekRead := preload("res://scripts/rules/WeekRead.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: ", what)
	else:
		failures += 1
		print("  FAIL: ", what)


## A quick start with the walk-in signed and a coach: the boxer on the coach's base week, no bouts taken, money no object.
func _career(seed_n: int) -> Career:
	var c := Career.quick_start()
	c.seed = seed_n
	c.cash = 1000000
	Sim.sign(c, ["signature"])
	Sim.hire(c, "reid")
	return c


func _week(c: Career) -> void:
	for i in 7:
		Sim.step_day(c)
	c.review_pending = false


func _row(c: Career, f: Dictionary, st: String) -> Dictionary:
	for fr in c.last_report["fighters"]:
		if str(fr["id"]) == str(f["id"]):
			for x in fr["rows"]:
				if str(x["st"]) == st:
					return x
	return {}


func _initialize() -> void:
	_causes()
	_etas()
	_goals()
	_ranks()
	_runway()
	_real_runway()
	await _screen()
	print("WEEK_READ failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _causes() -> void:
	var c := _career(7)
	var f: Dictionary = c.fighter()
	f["stats"]["conditioning"] = floorf(float(f["stats"]["conditioning"])) + 0.95   # the week's first session crosses a point
	f["week_start"] = (f["stats"] as Dictionary).duplicate()
	var sessions: Array = WeekPlan.days_of(f).duplicate(true)
	_week(c)
	var x := _row(c, f, "conditioning")
	var rd: Dictionary = x["read"]
	# What the plan ran: each session that builds conditioning, on its days.
	var by: Dictionary = {}
	for d in 7:
		var s := WeekPlan.session(str((sessions[d] as Array)[0]))
		if str(s["stat"]) == "conditioning":
			(by.get_or_add(str(s["name"]).to_lower(), []) as Array).append(Clock.DAYS[d])
	_check(by.size() == 2, "the coach's week trains conditioning with two sessions: %s" % str(by))
	_check(bool(rd["tick"]) and int(rd["gain"]) == 1, "a crossed point is +1, not a decimal: %s" % str(rd["text"]))
	_check(str(rd["text"]).begins_with("+1 Conditioning: "), "the line says it: %s" % str(rd["text"]))
	for who in by:
		_check(str(rd["why"]).contains("%s %s" % [who, " + ".join(by[who])]), "the cause names %s on its days: %s" % [who, str(rd["why"])])
	var chin := _row(c, f, "chin")
	_check(str(chin["read"]["why"]) == "" and str(chin["read"]["text"]) == "Not on the plan", "an untrained stat has no cause: %s" % str(chin["read"]["text"]))
	var iq := _row(c, f, "fight_iq")
	_check(str(iq["read"]["why"]).begins_with("sparring "), "sparring moved ring IQ, and the review says so: %s" % str(iq["read"]["why"]))
	_check(WeekRead.cause([["Pads and drills", 2, 0.4, [3, 1]]]) == "pads Tue + Thu", "days read in week order: '%s'" % WeekRead.cause([["Pads and drills", 2, 0.4, [3, 1]]]))
	# In a camp the pads drill the camp's stat: the cause must be the pads, on the nights they ran.
	var k := _career(9)
	var g: Dictionary = k.fighter()
	g["camp"] = {"focus": "technique", "protocol": 2, "start": 0}
	_week(k)
	_check(str(_row(k, g, "technique")["read"]["why"]).contains("pads "), "in a camp the pads train its stat: %s" % str(_row(k, g, "technique")["read"]["why"]))


## Every stat the review dates, on three careers: the week it really crosses against the ETA.
func _etas() -> void:
	var checked := 0
	var worst := 0
	for s in [3, 11, 29]:
		var c := _career(s)
		var f: Dictionary = c.fighter()
		_week(c)
		var due := {}
		for x in (c.last_report["fighters"][0]["rows"] as Array):
			var eta := int(x["read"]["eta"])
			if eta > 0 and eta <= 8:
				due[str(x["st"])] = [eta, int(x["read"]["next"]), 0]
		for w in range(1, 11):
			_week(c)
			for st in due:
				if int(due[st][2]) == 0 and float(f["stats"][st]) >= float(due[st][1]):
					due[st][2] = w
		for st in due:
			var off := absi(int(due[st][2]) - int(due[st][0]))
			checked += 1
			worst = maxi(worst, off)
			_check(int(due[st][2]) > 0 and off <= 1, "seed %d: %s said %d weeks, really %d" % [s, st, int(due[st][0]), int(due[st][2])])
	_check(checked >= 6, "%d ETAs checked, the worst off by %d" % [checked, worst])
	var ctx := {"stats": {"conditioning": 50.0, "power": 60.0}, "pot": 75, "coach": 60.0, "weight": 60.0, "fatigue": 20.0}
	var route := WeekRead.path(WeekPlan.COACH_WEEK, ctx, [], [])
	_check(route.size() == WeekRead.HORIZON and route[4] == WeekPlan.project(WeekPlan.COACH_WEEK, ctx, 5, [])["stats"], "the route is the planner's own projection")
	var x := {"st": "speed", "before": 60.2, "after": 60.5}
	_check(WeekRead.stat(x, [{"speed": 60.8}, {"speed": 61.1}], "Speed")["text"] == "Speed 61 in ~2 weeks", "the words: 'Speed 61 in ~2 weeks'")
	_check(WeekRead.stat(x, [{"speed": 61.1}], "Speed")["text"] == "Speed 61 next week", "one week reads next week")
	_check(int(WeekRead.stat(x, [{"speed": 60.8}, {"speed": 61.1}], "Speed", 3)["eta"]) == 5, "an injury's weeks out wait first")
	_check(str(WeekRead.stat(x, [{"speed": 60.6}, {"speed": 60.7}], "Speed")["text"]) == "Speed 61 in 2+ weeks", "past the horizon it says so")
	_check(str(WeekRead.stat({"st": "chin", "before": 99.0, "after": 99.0}, [{"chin": 99.0}], "Chin")["text"]) == "Chin at the top", "a stat at the cap has no next point")


## A goal `points` above her now, `days` away, as FighterGoal keeps it, then run to its deadline for real.
func _goal_case(points: float, days: int) -> Array:
	var c := _career(5)
	var f: Dictionary = c.fighter()
	_week(c)
	var now := float(f["stats"]["conditioning"])
	f["goal"] = {"id": "t", "title": "Test engine", "start_day": c.day, "deadline_day": c.day + days,
		"targets": {"conditioning": now + points}, "start_stats": (f["stats"] as Dictionary).duplicate()}
	var gr := Sim.goal_read(c, f)
	var rd := WeekRead.goal(gr, 0.0)
	for i in int(days / 7.0):
		_week(c)
	return [rd, gr, float(f["stats"]["conditioning"]) - (now + points)]


func _goals() -> void:
	var on := _goal_case(1.0, 28)
	var rd: Dictionary = on[0]
	_check(str(on[1]["status"]) == "ON TRACK" and str(rd["state"]) == "on_pace" and str(rd["word"]) == "ON PACE", "a goal in reach reads on pace: %s" % str(rd["text"]))
	_check(str(rd["text"]).contains(" early") and int(rd["days"]) > 0 and float(rd["short"]) == 0.0, "and by how much: %d days to spare" % int(rd["days"]))
	_check(float(on[2]) >= 0.0, "and it really lands: %.2f over at the deadline" % float(on[2]))
	var off := _goal_case(9.0, 28)
	rd = off[0]
	_check(str(rd["state"]) == "behind" and str(rd["word"]) == "BEHIND", "a goal out of reach reads behind: %s" % str(rd["text"]))
	_check(float(rd["short"]) > 0.0 and int(rd["days"]) < 0 and str(rd["text"]).contains("short at the deadline"), "and by how much: %.1f short" % float(rd["short"]))
	_check(float(off[2]) < 0.0 and absf(float(off[2]) + float(rd["short"])) < 1.0, "and it really falls short: %.2f, read as %.2f" % [float(off[2]), -float(rd["short"])])
	var row := {"key": "conditioning", "met": false, "projected": 60.1, "target": 60.0, "line": "Conditioning 58.0 / 60.0"}
	_check(str(WeekRead.goal({"code": "AT_RISK", "left": 14, "rate": {"conditioning": 0.1}, "targets": [row]})["state"]) == "tight", "lands inside the 2-day buffer: tight, not behind")
	var none := {"key": "conditioning", "met": false, "projected": 58.0, "target": 60.0, "line": "Conditioning 58.0 / 60.0"}
	_check(str(WeekRead.goal({"code": "OFF_TRACK", "left": 14, "rate": {}, "targets": [none]})["text"]).contains("not on the plan"), "a goal stat nothing trains says so")
	var fight := {"key": "booked_fight", "met": false, "projected": 0.0, "target": 1.0, "line": "Booked Fight 0 / 1"}
	_check(str(WeekRead.goal({"code": "ON_TRACK", "left": 14, "rate": {"conditioning": 0.2}, "targets": [fight, row]})["text"]).contains("No fight booked yet"), "a fight still to book is named")
	_check(str(WeekRead.goal({"code": "AT_RISK", "left": 0, "rate": {"conditioning": 0.1}, "targets": [row]})["text"]).ends_with("deadline today."), "no days left reads deadline today")
	_check(str(WeekRead.goal({"code": "MET", "left": 3, "targets": []})["word"]) == "MET", "a goal met reads met")
	_check(WeekRead.goal({}).is_empty(), "no goal, no row")


func _ranks() -> void:
	_check(WeekRead.rank(9, 7, "54 kg")["text"] == "Up 2 to 7 in the 54 kg rankings." and int(WeekRead.rank(9, 7, "54 kg")["move"]) == 2, "up")
	_check(WeekRead.rank(7, 9, "54 kg")["text"] == "Down 2 to 9 in the 54 kg rankings." and str(WeekRead.rank(7, 9, "54 kg")["kind"]) == "down", "down")
	_check(str(WeekRead.rank(7, 7, "54 kg")["kind"]) == "same" and str(WeekRead.rank(0, 0, "54 kg")["kind"]) == "none", "held, and unranked")
	_check(str(WeekRead.rank(0, 10, "54 kg")["kind"]) == "first" and str(WeekRead.rank(10, 0, "54 kg")["kind"]) == "out", "a first ranking, and out")


func _runway() -> void:
	var rule := GymBills.CLOSE_AFTER_WEEKS
	var up := WeekRead.runway(5000, 0, 1200, 1000, 28, 0)
	_check(int(up["net"]) == 200 and int(up["weeks"]) == -1 and int(up["close"]) == -1 and str(up["state"]) == "ok" and str(up["text"]).contains("+$200 a week"), "positive: safe: %s" % str(up["text"]))
	var flat := WeekRead.runway(5000, 0, 1000, 1000, 28, 0)
	_check(int(flat["net"]) == 0 and int(flat["weeks"]) == -1 and str(flat["state"]) == "ok" and str(flat["text"]).contains("holds at $5,000"), "zero: holds: %s" % str(flat["text"]))
	# -$200 a week from $2,000 on a bill day: income lands weekly, the costs on the 28-day bill, so each month-end leaves
	# $800 less: 1,200, then 400, then -400 at week 12.
	var down := WeekRead.runway(2000, 0, 800, 1000, 28, 0)
	_check(int(down["net"]) == -200 and int(down["weeks"]) == 12 and str(down["state"]) == "ok", "negative: %d weeks: %s" % [int(down["weeks"]), str(down["text"])])
	_check(str(down["text"]).contains("%d weeks in a row below $0 closes the gym" % rule), "measured against the real close rule (%d weeks)" % rule)
	var bill := WeekRead.runway(500, 3000, 1100, 1000, 21, 0)
	_check(int(bill["weeks"]) == 1 and str(bill["state"]) == "warn" and str(bill["text"]).contains("month-end bill"), "a positive week still hits the bill already run up: %s" % str(bill["text"]))
	var red := WeekRead.runway(-9000, 0, 800, 1000, 28, 3)
	_check(int(red["weeks"]) == 0 and str(red["state"]) == "red" and int(red["close"]) == rule - 3 and str(red["text"]).contains("%d more closes the gym" % (rule - 3)), "below $0 counts down the rule: %s" % str(red["text"]))
	# Costs wait for the bill, so a losing gym can blink above $0 between bills: the read says when it closes, not "back above".
	var blink := WeekRead.runway(-1500, 0, 800, 1000, 28, 3)
	_check(int(blink["back"]) == 2 and int(blink["close"]) > rule - 3 and str(blink["text"]).contains("closes in ~"), "a losing gym is never told it is back: %s" % str(blink["text"]))
	var back := WeekRead.runway(-300, 0, 1200, 1000, 28, 1)
	_check(int(back["back"]) >= 1 and str(back["text"]).contains("back above $0"), "a positive week climbs out: %s" % str(back["text"]))
	var even := WeekRead.runway(-1000, 0, 500, 500, 28, 2)
	_check(int(even["net"]) == 0 and str(even["state"]) == "red" and int(even["back"]) == 2 and str(even["text"]).contains("back above $0 in ~2 weeks"), "zero below $0: the income climbs out between bills: %s" % str(even["text"]))
	var flat_deep := WeekRead.runway(-90000, 0, 500, 500, 28, 2)
	_check(int(flat_deep["close"]) == rule - 2 and str(flat_deep["text"]).contains("closes in ~"), "zero too deep below $0: the clock runs out: %s" % str(flat_deep["text"]))
	_check(str(WeekRead.runway(-1000, 0, 500, 500, 28, rule)["state"]) == "closed", "the rule reached: closed")


## A real gym, its members settled so the balance holds: the runway against the week the cash really goes below $0 and the
## week it really closes.
func _real_runway() -> void:
	var c := _career(1)
	for i in 16:
		_week(c)
	c.deals = []   # no sponsor: a gym that loses money
	c.cash = 1500
	var rw: Dictionary = WeekRead.runway(c.cash, c.accrued, int(Sim.weekly_income(c)["total"]), int(Sim.weekly_costs(c)["total"]), c.day, c.weeks_below)
	_check(int(rw["net"]) < 0 and int(rw["weeks"]) > 0, "a small gym loses money: %s" % str(rw["text"]))
	var dry := 0
	var shut := 0
	for w in range(1, 40):
		_week(c)
		if dry == 0 and c.cash < 0:
			dry = w
		if c.closed:
			shut = w
			break
	_check(dry > 0 and absi(dry - int(rw["weeks"])) <= 1, "the cash goes below $0 when it said: read %d, really %d" % [int(rw["weeks"]), dry])
	# Within a bill cycle: one member more or less decides whether the cash blinks above $0 between two bills (the read says "~").
	_check(shut > 0 and absi(shut - int(rw["close"])) <= 4, "the gym closes within a month of the read: read %d, really %d" % [int(rw["close"]), shut])


func _screen() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("newcareer")
	main.act("quick")
	main.act("guideskip")
	main.close_modal()
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("hire", "reid")
	await process_frame
	main.run_to_stop()
	main.act("review")
	await process_frame
	var rv: Node = main.modal_node()
	var fid := str(main.career.fighter()["id"])
	_check(rv.find_child("Goal_" + fid, true, false) != null, "the review draws the goal row")
	_check(rv.find_child("Rank_" + fid, true, false) != null or str(rv.headlines[0]["kind"]) == "rank", "the review draws the rank row")
	var run: Control = rv.find_child("Runway", true, false)
	_check(run != null and run.modulate.a == 0.0, "the runway row waits its turn")
	_check(rv.find_child("Why_chin", true, false) != null, "every stat has a read")
	rv.finish()
	_check(rv.revealed and run.modulate.a == 1.0, "a click lands everything")
	var at_end := true
	for x in rv._grow:
		at_end = at_end and is_equal_approx(float(x[0].frac), clampf(float(x[1]), 0.0, 1.0))
	_check(at_end, "every bar at its end after a click")
	main.act("close")
	await process_frame
	# A climb that is the week's surprise waits for the sticky note; a drop is no surprise, and takes the row.
	var up: Dictionary = main.career.last_report.duplicate(true)
	var fr0: Dictionary = up["fighters"][0]
	fr0["injury"] = ""
	fr0["new_weapon"] = ""
	fr0["peak"] = ""
	fr0["rank_before"] = 5
	fr0["rank_after"] = 3
	fr0["rank"] = WeekRead.rank(5, 3, "54 kg")
	main.open_modal({"type": "review", "r": up})
	await process_frame
	_check(str(main.modal_node().headlines[0]["kind"]) == "rank" and main.modal_node().find_child("Rank_" + fid, true, false) == null, "a rank climb lands on the sticky note, not twice")
	main.act("close")
	await process_frame
	fr0["rank_before"] = 3
	fr0["rank_after"] = 5
	fr0["rank"] = WeekRead.rank(3, 5, "54 kg")
	main.open_modal({"type": "review", "r": up})
	await process_frame
	var fell: Node = main.modal_node().find_child("Rank__text".replace("__", "_" + fid + "_"), true, false)
	_check(fell != null and str(fell.text) == "Down 2 to 5 in the 54 kg rankings.", "a rank drop takes the row")
	main.act("close")
	await process_frame
	# A review saved before S387: no read, no goal, no rank, no runway.
	var old: Dictionary = main.career.last_report.duplicate(true)
	old["money"].erase("runway")
	for fr in old["fighters"]:
		fr.erase("goal")
		fr.erase("rank")
		for x in fr["rows"]:
			x.erase("read")
			x.erase("src")
	main.open_modal({"type": "review", "r": old})
	await process_frame
	_check(main.modal_node() != null and main.modal_node().find_child("Runway", true, false) == null, "an old report still opens")
	main.queue_free()
