extends SceneTree
## S387 FirstWeek: a new career opens on the gym (S388) with no grappler signed; CONTINUE walks sign -> coach -> week 1 and only then runs
## time; the first review names someone who trained; Ana joins at the end of week 1; Skip ends the guide; an unguided week with
## nobody training fires no review. The Playbook is the fighter page's tab: the rail shortcut lands there and keeps its sub-tab.

const MAIN := preload("res://scenes/Main.tscn")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const FighterPage := preload("res://scripts/ui/areas/FighterPage.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	_guided()
	_skipped()
	_playbook()
	print("FIRST_WEEK failures=%d" % failures)
	print("PASS first_week_test" if failures == 0 else "FAIL first_week_test")
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)


func _strip() -> Node:
	return main.find_child("FirstWeekStrip", true, false)


## The guide's two lines on screen hold these words.
func _says(what: String, why: String) -> bool:
	var a := main.find_child("GuideWhat", true, false) as Label
	var b := main.find_child("GuideWhy", true, false) as Label
	return a != null and b != null and a.text.contains(what) and b.text.contains(why)


func _guided() -> void:
	main.act("quick")
	var c: Career = main.career
	_check(c.guide == "sign", "a new career starts the guide")
	_check(main.modal.is_empty(), "the career opens on the gym, nothing opens by itself (S275)")
	_check(_strip() != null and main.find_child("GuideStep", true, false) != null, "the guide shows its step button")
	_check(_says("Sign your first boxer", "No boxer, no fights"), "the guide says what to do and why: sign")
	main.on_go()
	_check(str(main.modal.get("type", "")) == "interview", "the guide's button opens the boxer's interview")
	_check(c.grapplers.is_empty(), "no grappler is signed at the start")
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	main.close_modal()
	_check(_strip() != null, "the strip shows")
	_check(_says("Hire a coach", "60%"), "the guide says what to do and why: coach")
	_check(str(Needs.go_state(c, false)["t"]).begins_with("NEEDS YOU"), "signed, no coach: CONTINUE is blocked")
	main.on_go()
	_check(main.route["area"] == "gym" and int(main.route["tab"]) == 1, "CONTINUE goes to GYM > Staff")
	var day := c.day
	main.act("hire", "reid")
	_check(c.guide == "week" and Needs.blockers(c).size() == 1, "coach hired: the week step blocks")
	main.on_go()
	_check(main.on_week_tab(), "CONTINUE opens the Training tab")
	main.on_go()
	_check(c.guide == "go", "the second press locks week 1")
	_check(Needs.blockers(c).is_empty(), "nothing blocks time now")
	_check(c.day == day, "no day passed during the guide")
	var stopped := false
	for i in 8:
		stopped = c.review_pending
		if stopped:
			break
		Clock.step(c)
	_check(stopped, "week 1 ends in a review")
	_check((c.last_report["fighters"] as Array).size() == 1, "the review has the boxer who trained")
	_check((c.last_report["grapplers"] as Array).is_empty(), "the first review stamps no grappler")
	_check(c.guide == "", "the guide is over")
	_check(c.grapplers.size() == 1, "Ana joined at the end of week 1")
	main.render()
	_check(_strip() == null, "the strip is gone")


func _skipped() -> void:
	main.act("quick")
	var c: Career = main.career
	main.close_modal()
	main.act("guideskip")
	_check(c.guide == "" and _strip() == null, "Skip ends the guide")
	c.applicant = {}
	for i in 8:
		Clock.step(c)
	_check(not c.review_pending, "a week with nobody training fires no review")
	_check(c.grapplers.size() == 1, "a skipped guide still gets Ana after week 1")


func _playbook() -> void:
	main.act("quick")
	var c: Career = main.career
	main.close_modal()
	main.act("guideskip")
	main.act("area", "playbook")
	_check(main.route["area"] == "home", "no fighter: the shortcut stays put")
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	main.act("area", "playbook")
	_check(main.route["area"] == "fighters" and int(main.route["ftab"]) == FighterPage.PLAYBOOK_TAB, "the rail shortcut opens the fighter's Playbook tab")
	_check(str(main.route["fighter"]) == str(c.fighter()["id"]), "on the current fighter")
	main.act("go", "playbook:2")
	_check(int(main.route["ptab"]) == 2, "a playbook link keeps its sub-tab")
	main.act("ptab", "3")
	_check(int(main.route["ptab"]) == 3 and int(main.route["ftab"]) == FighterPage.PLAYBOOK_TAB, "the sub-tab row works")
