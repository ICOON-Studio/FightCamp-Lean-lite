extends SceneTree
## OFFICEV2 (S538, owner Q-S294-302 / Q-304 "Yes, build them"; C475 "tooltip on goals give some tips"): the office
## dashboard's GOALS panel on the TEST CLUB. Left: the club's pending items, soonest first, each with its days left. Right:
## one row a fighter - the want, how far, by when, what a miss costs - and a TIP that says what to do this week, read from
## the career (never the label again, and inside the tooltip standard). Reading it changes nothing. Then the real screen:
## the panel is on the desktop with a row a fighter and the fighter chips under it.
## Prints OFFICE_GOALS failures=<n>.
##   godot --headless --audio-driver Dummy --path . --script res://tests/office_goals_test.gd

const GOALS_PATH := "res://scripts/ui/OfficeGoals.gd"
const Sim := preload("res://scripts/state/Sim.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Tip := preload("res://scripts/ui/Tip.gd")

var failures := 0


func _initialize() -> void:
	if not ResourceLoader.exists(GOALS_PATH):
		_check(false, "OfficeGoals.gd exists")
		_done()
		return
	var goals: Script = load(GOALS_PATH)
	var c := Career.quick_start()
	c.seed = 7
	FirstWeek.begin(c)
	TestClub.make(c)
	for i in 10:
		Sim.step_day(c)
	var before := var_to_str([c.cash, c.day, c.fighters, c.grapplers, c.promises, c.news.size()])
	var pend: Array = goals.pending(c)
	_check(not pend.is_empty(), "the club has pending items (%d)" % pend.size())
	_check(pend.size() <= int(goals.MAX_PENDING), "at most %d pending rows" % int(goals.MAX_PENDING))
	var last := -1
	for p in pend:
		_check(int(p["day"]) >= c.day and int(p["days"]) == int(p["day"]) - c.day, "pending '%s' counts its days (%d)" % [p["t"], int(p["days"])])
		_check(int(p["day"]) >= last, "pending rows come soonest first (%s)" % p["t"])
		last = int(p["day"])
		_check(str(p["t"]) != "" and str(p["sub"]) != "", "pending '%s' has its line" % p["t"])
	_check(pend.any(func(p): return str(p["kind"]) == "bills"), "the month bill is pending")
	var names: Array = []
	for f in c.fighters + c.grapplers:
		names.append(str(f["name"]))
		names.append(str(f["first"]) if f.has("first") else str(f["name"]).get_slice(" ", 0))
	var wants: Array = goals.wants(c)
	_check(wants.size() == c.fighters.size() + c.grapplers.size(), "one row a fighter (%d)" % wants.size())
	for w in wants:
		var who := str(w["name"])
		for k in ["want", "status", "by", "miss"]:
			_check(str(w.get(k, "")) != "", "%s: '%s' is filled (%s)" % [who, k, str(w.get(k, ""))])
		var tip: Dictionary = w.get("tip", {})
		var todo := str(tip.get("do", ""))
		_check(todo != "", "%s: the tip says what to do" % who)
		_check(todo != str(w["want"]) and not todo.to_lower().begins_with(str(w["want"]).to_lower()), "%s: the tip is not the label (%s)" % [who, todo])
		var faults: Array = Tip.faults(Tip.spec(tip), str(w["want"]), names)
		_check(faults.is_empty(), "%s: the tip keeps the tooltip standard %s: %s" % [who, str(faults), str(tip)])
	# A boxer with a goal: the tip follows the state - no bout booked and none offered -> ask for one.
	var f0: Dictionary = c.fighters[0]
	var g0: Dictionary = Sim.goal_read(c, f0)
	if not g0.is_empty():
		var row: Dictionary = wants[0]
		_check(str(row["want"]) == str(g0["title"]), "the want is the goal's title (%s)" % row["want"])
		_check(int(row["by_day"]) == c.day + int(g0["days_left"]), "the by-day is the goal's deadline")
		_check(str(row["miss"]).contains("mood"), "a missed goal costs mood (%s)" % row["miss"])
		var saved: Dictionary = (f0["goal"] as Dictionary).duplicate(true)
		f0["goal"] = {}
		f0["goal_talk"] = true
		var talk: Dictionary = goals.wants(c)[0]
		_check(str(talk["status"]) == "GOAL TALK" and str(talk["act"]) == "goaltalk", "no goal and a talk waiting: the row says GOAL TALK (%s)" % talk["status"])
		_check(str(talk["tip"]["do"]) != str(row["tip"]["do"]), "the tip changes with the state")
		f0["goal"] = saved
		f0["goal_talk"] = false
	_check(var_to_str([c.cash, c.day, c.fighters, c.grapplers, c.promises, c.news.size()]) == before, "reading the goals changes nothing")
	await _screen()
	_done()


func _screen() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.create = {"test_club": "1"}
	main._start_career("Anvil Street Gym", "London")
	for i in 3:
		await process_frame
	main.nav({"area": "office", "tab": 0})
	for i in 3:
		await process_frame
	var c: Career = main.career
	var panel := main.find_child("GoalsPanel", true, false) as Control
	_check(panel != null, "the GOALS panel is on the desktop")
	if panel != null:
		for f in c.fighters + c.grapplers:
			var row := panel.find_child("Want_" + str(f["id"]), true, false) as Control
			_check(row != null, "the panel has %s's row" % f["name"])
			if row != null:
				_check(not Tip.of(row).is_empty() and str(Tip.of(row).get("do", "")) != "", "%s's row carries its tip" % f["name"])
		_check(panel.find_child("Pending_0", true, false) != null, "the panel has the pending list")
	var strip := main.find_child("FightersPanel", true, false) as Control
	_check(strip != null and strip.find_child("Card_" + str(c.fighters[0]["id"]), true, false) != null, "the fighters are a strip of chips")
	_check(strip != null and panel != null and strip.size.y < 200.0, "the fighter chips are a short strip (%d px)" % (int(strip.size.y) if strip != null else -1))
	main.queue_free()


func _done() -> void:
	print("OFFICE_GOALS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok: " if ok else "  FAIL: ") + what)
	if not ok:
		failures += 1
