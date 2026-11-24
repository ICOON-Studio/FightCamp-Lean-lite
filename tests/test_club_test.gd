extends SceneTree
## S489 FOURSTART1 (his Q-246): the TEST CLUB - three boxers in three weight classes and one grappler, the coach hired,
## past the guide; the normal start still has 0 fighters; a second make adds no one; four weeks play through with all
## four (every week's review covers the three boxers). Run:
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/test_club_test.gd

const Sim := preload("res://scripts/state/Sim.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")

var fails := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		fails += 1
		print("FAIL ", what)


func _initialize() -> void:
	var normal := Career.quick_start()
	FirstWeek.begin(normal)
	_check(normal.fighters.is_empty() and not normal.test_club, "the normal start has 0 fighters (Q-246)")
	var c := Career.quick_start()
	c.seed = 7
	FirstWeek.begin(c)
	var boxers := TestClub.make(c)
	_check(boxers.size() == 3, "three boxers (%d)" % boxers.size())
	var divs := {}
	for f in boxers:
		divs[str(f["div"])] = true
	_check(divs.size() == 3, "three weight classes: %s" % str(divs.keys()))
	_check(c.grapplers.size() == 1, "one grappler on the mat")
	_check(not c.coach.is_empty(), "the coach hired")
	_check(c.applicant.is_empty(), "no walk-in left at reception")
	_check(TestClub.on(c) and c.guide == "", "flagged as the test club, past the guide")
	TestClub.make(c)
	_check(c.fighters.size() == 3 and c.grapplers.size() == 1, "a second make adds no one")
	var reviews := 0
	var covered := 0
	for i in 28:
		Sim.step_day(c)
		if c.review_pending:
			reviews += 1
			covered = maxi(covered, (c.last_report.get("fighters", []) as Array).size())
			c.review_pending = false
	_check(reviews >= 3, "four weeks give the weekly reviews (%d)" % reviews)
	_check(covered == 3, "a week's review covers all three boxers (%d)" % covered)
	_check(c.fighters.size() == 3, "all three still at the gym after four weeks")
	print("test_club_test %s" % ("PASS" if fails == 0 else "FAIL (%d)" % fails))
	quit(0 if fails == 0 else 1)
