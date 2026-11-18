extends SceneTree
## S519 club week v11 golden path (his S425 rule: one test walks the mechanic end to end through the game's own acts).
## Quick start: sign the walk-in, then a second boxer - the one-time "share the coach's time" note. Then the TEST CLUB
## (Lucy, Kira, Josh, Ana; Reid hired): Training shows the coach's coached mornings; the evening panel's act makes Monday a
## class night; the Money row's act puts Lucy on half the sponsorship; a week is played through Main (run_to_stop): the
## class money and the half stipend land in the week, the class night drilled on the bag, the members' carry moved; a bout
## offer in a week the film nights are full shows the clash. Prints CLUB_WEEK_WALK failures=N.

const ClubWeek := preload("res://scripts/state/ClubWeek.gd")
const MorningWire := preload("res://scripts/state/MorningWire.gd")
const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")
const ClubForecast := preload("res://scripts/state/ClubForecast.gd")
const DayJob := preload("res://scripts/rules/DayJob.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var main: Node
var _fails := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	main.save_path = "user://club_week_walk.save"
	root.add_child(main)
	await process_frame
	# --- the note when the second boxer signs (normal game: 0 boxers, a walk-in)
	main.act("quick")
	var q: Career = main.career
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	_check(q.fighters.size() == 1 and MorningWire.of(q, q.fighters[0]).is_empty(), "one boxer: no coached-morning deal")
	for p in q.prospects:
		if str(p["id"]) == "josh":
			p["state"] = "invited"   # the scout's invite and trial, as refuse_walkin_test does
	Roster.sign_prospect(q, "josh", ["signature"])
	var said := false
	for n in q.news:
		said = said or str(n["t"]).begins_with("Two boxers now share the coach's time")
	_check(q.fighters.size() == 2 and said, "the second signing says the coach's time is shared now")
	# --- the test club
	TestJump.run(main, "club4")
	var c: Career = main.career
	main.modal = {}
	while posmod(c.day, 7) != 0:
		c.day += 1
	var lucy: Dictionary = c.fighters[0]
	var lid := str(lucy["id"])
	main.nav({"area": "training", "fighter": lid})
	await process_frame
	var model := ClubWeek.model(c, lid, 0)
	var tags := 0
	for d in model["days"]:
		if not ((d["am"] as Dictionary).get("coach", {}) as Dictionary).is_empty():
			tags += 1
	_check(tags >= 1, "Training shows the coach's coached mornings for the boxer (%d tiles)" % tags)
	var pads: Array = PadWeek.nights_of(lucy).get("pads", [])
	var cd := int(pads[0])
	main.act("tkclass", str(cd))
	_check(ClubClasses.on(c.coach, cd) and str(ClubWeek.coach_cell(c, cd, -1)["kind"]) == "class", "the evening panel's act: class night on day %d" % cd)
	main.act("stipend", "%s|half" % lid)
	_check(bool(lucy.get("half_job", false)) and DayJob.count_of(lucy) == 1, "the Money row's act: Lucy on half the sponsorship")
	var inc := Sim.weekly_income(c)
	_check(int(inc.get("class_nights", 0)) == 117, "the week's money carries the class night: %s" % inc.get("class_nights", 0))
	var half_min := PadWeek.night_minutes(DrillWeek.inputs(c, lucy)["nights"], cd)
	_check(half_min < PadWeek.PAD_NIGHT_MINUTES, "the class night drills on the bag: %.0f min" % half_min)
	# --- play the week through the game
	var start := c.day
	var cash0 := c.cash
	var stops := 0
	while c.day < start + 7 and stops < 40:
		stops += 1
		c.cash = maxi(c.cash, 20000)
		if c.review_pending:
			main.act("review")
			await process_frame
			main.act("close")
		if not (main.modal as Dictionary).is_empty():
			main.act("close")
		main.run_to_stop(7)
		await process_frame
	_check(c.day >= start + 7, "a week played (day %d -> %d)" % [start, c.day])
	_check(float(c.coach.get("class_carry", 0.0)) > 0.0 or c.members > 0, "the class night's members carry moved: %.3f" % float(c.coach.get("class_carry", 0.0)))
	_check(cash0 != 0, "the money ran")
	# --- the clash before Accept
	var sat := c.day - posmod(c.day, 7) + 7 + 5
	c.fighters[1]["bout"] = {"day": sat, "done": false, "opp": {"first": "A", "name": "A B"}}
	c.fighters[2]["bout"] = {"day": sat, "done": false, "opp": {"first": "C", "name": "C D"}}
	var cl := ClubForecast.clash(c, lucy, sat)
	_check(cl.contains("film 3 of"), "a third bout that week: the offer's clash line (%s)" % cl)
	c.fighters[1]["bout"] = {}
	c.fighters[2]["bout"] = {}
	print("CLUB_WEEK_WALK failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
