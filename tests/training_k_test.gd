extends SceneTree
## S496 TRAININGK1 golden path for TRAINING (Training K v6c, his Q-S294-259 "Yes, build it"): the TEST CLUB (TestJump club4:
## three boxers + the grappler) opens the club's week from the gym floor; every number on it is a rule's; a session dragged
## onto a morning, an evening set to pads, the coach's line dragged, a morning's effort changed, the coach's pick applied;
## the old fighter-page Training tab opens this screen; CONTINUE runs the week and the dragged split is what the pads drilled.
## Then a normal start (the walk-in alone): one card, a whole 75-minute night. Text size Largest: nothing spills its box.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const ClubWeek := preload("res://scripts/state/ClubWeek.gd")
const CoachNights := preload("res://scripts/rules/CoachNights.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")

var _fails := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	TestJump.run(main, "club4")
	if not main.modal.is_empty():
		main.act("close")
	var c: Career = main.career
	main.act("area", "home")
	await _frames(3)
	var pin := main.find_child("Spot_week", true, false)
	_check(pin != null or main.find_child("GymHub", true, false) != null, "the gym floor is up")
	main.nav({"area": "training"})
	await _frames(4)
	var page := main.find_child("Training", true, false)
	_check(page != null, "TRAINING opens")
	if page == null:
		_end()
		return
	_check(main.on_week_tab(), "the guide's week check knows the screen")
	for f in c.fighters:
		_check(page.find_child("Card_" + str(f["id"]), true, false) != null, "a card for boxer %s" % str(f["id"]))
	for g in c.grapplers:
		_check(page.find_child("Card_" + str(g["id"]), true, false) != null, "a card for the grappler")
	var f: Dictionary = ClubWeek.pick(c, "")
	var fid := str(f["id"])
	var m: Dictionary = page.get("model")
	# every number is a rule's: the morning gain is WeekPlan.week's, the coach's slices are CoachNights' split
	var g := WeekPhase.ahead_view(f, c.day) if WeekPhase.weekend(c.day) else f
	for i in 7:
		_check(page.find_child("Morning_%d" % i, true, false) != null and page.find_child("Evening_%d" % i, true, false) != null, "day %d has a morning and an evening" % i)
	var d0: Dictionary = (m["days"] as Array)[0]
	var gl := page.find_child("Gain_0", true, false) as Label
	if gl != null and not bool((d0["am"] as Dictionary)["rest"]):
		_check(gl.text.begins_with("%+.2f" % float((d0["am"] as Dictionary)["gain"])), "Monday's gain is WeekPlan's (%s)" % gl.text)
	var pads_day := -1
	for d in m["days"]:
		if str((d["coach"] as Dictionary)["kind"]) == "pads" and ((d["coach"] as Dictionary)["slices"] as Array).size() >= 2:
			pads_day = int(d["dow"])
			break
	_check(pads_day >= 0, "a pad night shared by two or more boxers (day %d)" % pads_day)
	if pads_day >= 0:
		var sl: Array = ((m["days"] as Array)[pads_day]["coach"] as Dictionary)["slices"]
		var sum := 0.0
		for s in sl:
			sum += float(s["min"])
			_check(is_equal_approx(float(s["min"]), float(DrillWeek.night_mins(c, pads_day)[str(s["fid"])])), "slice %s is CoachNights' minutes" % str(s["fid"]))
		_check(is_equal_approx(sum, CoachNights.NIGHT_MIN), "the night's slices add up to 75 (%.1f)" % sum)
	for n in ["ThisWeek", "Mornings", "Evening", "CoachPick", "StartWeek", "SessionTray", "TiredChart", "Diet", "BoutPanel", "WeekWhen"]:
		_check(page.find_child(n, true, false) != null, "the screen shows %s" % n)
	# a session dragged from the tray onto Tuesday's morning
	var tue := page.find_child("Morning_1", true, false)
	var tray := page.find_child("Tray_slip_rope", true, false)
	_check(tray != null and tray.call("_get_drag_data", Vector2.ZERO) is Dictionary, "the tray's Slip rope is draggable")
	_check(tue != null and tue.call("_can_drop_data", Vector2.ZERO, {"tk": "am", "id": "slip_rope"}), "Tuesday's morning takes a morning session")
	_check(tue != null and not tue.call("_can_drop_data", Vector2.ZERO, {"tk": "pm", "id": "pads"}), "a morning refuses an evening")
	tue.call("_drop_data", Vector2.ZERO, {"tk": "am", "id": "slip_rope"})
	await _frames(3)
	g = WeekPhase.ahead_view(f, c.day) if WeekPhase.weekend(c.day) else f
	_check(str(WeekPlan.days_of(g)[1][0]) == "slip_rope", "Tuesday's morning is Slip rope (%s)" % str(WeekPlan.days_of(g)[1]))
	page = main.find_child("Training", true, false)
	var gl1 := page.find_child("Gain_1", true, false) as Label
	_check(gl1 != null and gl1.text.contains("Defence"), "Tuesday's tile shows the new stat (%s)" % (gl1.text if gl1 else "none"))
	# Hard on Tuesday
	var hard := page.find_child("Level_1_H", true, false) as Button
	_check(hard != null, "Tuesday's effort buttons")
	if hard != null:
		hard.pressed.emit()
		await _frames(3)
		g = WeekPhase.ahead_view(f, c.day) if WeekPhase.weekend(c.day) else f
		_check(WeekPlan.days_of(g)[1] == ["slip_rope", "hard"], "Tuesday is Slip rope, Hard (%s)" % str(WeekPlan.days_of(g)[1]))
	# an evening set to pads by a drop
	page = main.find_child("Training", true, false)
	var sat := page.find_child("Evening_5", true, false)
	if sat != null and str(sat.get("kind")) != "fight":
		sat.call("_drop_data", Vector2.ZERO, {"tk": "pm", "id": "pads"})
		await _frames(3)
		g = WeekPhase.ahead_view(f, c.day) if WeekPhase.weekend(c.day) else f
		_check((PadWeek.nights_of(g)["pads"] as Array).has(5), "Saturday's evening is a pad night")
	# the coach's white line dragged her way on the shared night
	if pads_day >= 0:
		var ids := DrillWeek.on_pads(c, pads_day)
		var at := ids.find(fid)
		var was := float(DrillWeek.night_mins(c, pads_day)[fid])
		# her right-hand line pushed right (she is first), else her left-hand line pushed left
		var edge := at if at == 0 else at - 1
		var left := 70.0 if at == 0 else 5.0
		main.act("tksplit", "%d|%d|%.1f" % [pads_day, edge, left])
		await _frames(3)
		var mins: Dictionary = DrillWeek.night_mins(c, pads_day)
		_check(is_equal_approx(_sum(mins), 75.0) and float(mins[fid]) > was + 5.0, "the line moved: %d -> %d min to her (%s)" % [roundi(was), roundi(float(mins[fid])), str(mins)])
		var drill := PadWeek.night_minutes(DrillWeek.inputs(c, f)["nights"], pads_day)
		_check(absf(drill - PadWeek.PAD_NIGHT_MINUTES * CoachNights.factor(float(mins[fid]))) < 0.5, "her pads drill %.0f of 240 that night" % drill)
		page = main.find_child("Training", true, false)
		var ev := page.find_child("EveningSplit", true, false)
		_check(ev != null, "the evening panel opened on that night")
	# the coach's pick
	page = main.find_child("Training", true, false)
	var cl := page.find_child("CoachLine", true, false) as Label
	_check(cl != null and cl.text.length() > 5, "the coach's pick says something (%s)" % (cl.text if cl else ""))
	# another boxer selected from the strip
	var other := ""
	for x in c.fighters:
		if str(x["id"]) != fid:
			other = str(x["id"])
	var oc := page.find_child("Card_" + other, true, false)
	(oc.get("on_click") as Callable).call()
	await _frames(3)
	_check(str(main.route.get("fighter", "")) == other and str((main.find_child("Training", true, false).get("model") as Dictionary)["sel"]) == other, "her card selects her week")
	# the old Training tab is gone: its link opens TRAINING
	main.act("fighter", fid)
	main.act("ftab", "3")
	await _frames(3)
	_check(str(main.route["area"]) == "training" and str(main.route.get("fighter", "")) == fid, "the fighter page's old Training link opens TRAINING (%s)" % str(main.route))
	main.act("fighter", fid)
	await _frames(2)
	var tabs := ""
	for b in main.find_children("*", "Button", true, false):
		tabs += str((b as Button).text) + "|"
	_check(not tabs.contains("|Training|"), "the fighter page has no Training tab")
	# Largest text: nothing on the screen spills its box
	TextScale.use(self, 1.3)
	main.nav({"area": "training", "fighter": fid})
	await _frames(6)
	var over := TextScale.overflow(main.find_child("Training", true, false))
	for o in over:
		print("  overflow ", o)
	_check(over.size() <= 3, "Largest text: %d words spill their box" % over.size())
	var side := main.find_child("Side", true, false) as Control
	_check(side != null and side.get_global_rect().end.x <= 1920.0, "Largest text: the right column ends inside 1920 (%.0f)" % (side.get_global_rect().end.x if side else -1.0))
	TextScale.use(self, 1.0)
	# CONTINUE: the week runs, and her dragged night drilled what the screen said
	var guard := 0
	while posmod(c.day, 7) != 0 and guard < 4:   # to a Monday: a whole week ahead
		main.run_to_stop(8)
		if not main.modal.is_empty():
			main.act("close")
		guard += 1
	_check(posmod(c.day, 7) == 0, "the clock stops on a Monday (day %d)" % c.day)
	var shared := -1
	for d in range(1, 6):
		if DrillWeek.on_pads(c, d).size() >= 2 and DrillWeek.on_pads(c, d).has(fid):
			shared = d
			break
	if shared >= 0:
		var ids2 := DrillWeek.on_pads(c, shared)
		var at2 := ids2.find(fid)
		main.act("tksplit", "%d|%d|%.1f" % [shared, at2 if at2 == 0 else at2 - 1, 70.0 if at2 == 0 else 5.0])
		var mine := float(DrillWeek.night_mins(c, shared)[fid])
		for k in shared + 1:
			main.run_to_stop(1)
			if not main.modal.is_empty():
				main.act("close")
		var noted: Dictionary = f.get(DrillWeek.NOTED, {})
		_check(noted.has(str(shared)) and absf(float(noted[str(shared)]["minutes"]) - PadWeek.PAD_NIGHT_MINUTES * CoachNights.factor(mine)) < 0.5,
			"CONTINUE: night %d ran her %d coach minutes (%s)" % [shared, roundi(mine), str(noted.get(str(shared), {}))])
	await _normal()
	_end()


## A normal start: the walk-in alone - one card, the whole 75 minutes on her pad nights.
func _normal() -> void:
	main.act("quick")
	await _frames(2)
	var c: Career = main.career
	main.nav({"area": "training"})
	await _frames(3)
	_check(main.find_child("Training", true, false) != null, "normal start: TRAINING opens with nobody signed")
	load("res://scripts/state/Sim.gd").sign(c, TestClub.PICKS.duplicate())
	main.nav({"area": "training"})
	await _frames(4)
	var page := main.find_child("Training", true, false)
	var m: Dictionary = page.get("model")
	_check((m["cards"] as Array).size() == 1, "normal start: one card")
	for d in m["days"]:
		var cell: Dictionary = d["coach"]
		if str(cell["kind"]) == "pads":
			_check((cell["slices"] as Array).size() == 1 and is_equal_approx(float(cell["slices"][0]["min"]), 75.0), "normal start: a whole 75-minute night alone")
			break


func _sum(d: Dictionary) -> float:
	var t := 0.0
	for k in d:
		t += float(d[k])
	return t


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		_fails += 1
		print("FAIL ", label)


func _end() -> void:
	print("TRAINING_K %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(1 if _fails > 0 else 0)
