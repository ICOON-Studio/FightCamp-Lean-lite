extends SceneTree
## TASK GUIDEFLAG1: the guide strip ends with the first week; the offer flag says what is needed.
## The guide runs through week 1 (sign/coach/week/go), then career.guide is empty for good.
## The offer flag's title is short enough not to be cut: "Answer <first name>'s bout offer".
## The opponent's name moves to the flag's second line, before "expires <date>".

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	_guide_during_week_1()
	_guide_ends_after_week_1()
	_stale_guide_clears_on_sync()
	_offer_flag_format()
	print("GUIDE_ENDS failures=%d" % failures)
	print("PASS guide_ends_test" if failures == 0 else "FAIL guide_ends_test")
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)


func _strip() -> Node:
	return main.find_child("FirstWeekStrip", true, false)


## A new career has a guide during week 1.
func _guide_during_week_1() -> void:
	main.act("quick")
	var c: Career = main.career
	_check(c.guide == "sign", "a new career starts with guide='sign'")
	_check(_strip() != null, "the strip shows during week 1")
	main.close_modal()
	main.act("guideskip")
	_check(c.guide == "", "skip ends the guide")


## A career at week 20 has guide=="" and no FirstWeekStrip.
## A career inside the first fight keeps the guide.
func _guide_ends_after_week_1() -> void:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	# Play through week 1: sign, coach, week 1, go
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	Sim.hire(c, "reid")
	FirstWeek.sync(c)
	FirstWeek.set_week(c)
	_check(c.guide == "go", "week 1 set: guide='go'")
	# End week 1
	while not c.review_pending:
		Clock.step(c)
	main.act("review")
	main.act("close")
	# After week 1, the guide should be at "offer" (not empty)
	_check(c.guide == "offer", "after week 1: guide is 'offer' (was '%s')" % c.guide)
	main.render()
	_check(_strip() != null, "after week 1: FirstWeekStrip still shows")
	# Jump to week 20 - the guide should be empty
	c.day = 140
	FirstWeek.sync(c)
	_check(c.guide == "", "at week 20: guide is empty (was '%s')" % c.guide)
	main.render()
	_check(_strip() == null, "at week 20: no FirstWeekStrip shows")


## A saved career with a stale guide at week 20 clears on sync.
func _stale_guide_clears_on_sync() -> void:
	var c := Career.quick_start()
	c.seed = 1
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	Sim.hire(c, "reid")
	# Simulate a stale save: week 20 with guide still set
	c.day = 140
	c.guide = "offer"
	FirstWeek.sync(c)
	_check(c.guide == "", "stale guide at week 20 clears on sync")
	# Another stale state
	c.guide = "club"
	c.first_hour = {"tasks_done": ["second", "book", "goal"]}
	FirstWeek.sync(c)
	_check(c.guide == "", "stale 'club' guide with all tasks done clears")


## The offer flag's title is under 34 characters and holds the first name.
## Its second line holds the opponent's name. Its act is still openBout.
func _offer_flag_format() -> void:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	Sim.hire(c, "reid")
	FirstWeek.sync(c)
	FirstWeek.set_week(c)
	# Run to week 2 when offers arrive
	while c.day < 7:
		Clock.step(c)
	if c.review_pending:
		main.act("review")
		main.act("close")
	# Wait for offers
	while c.fighter().get("offers", []).is_empty():
		Clock.step(c)
	var f := c.fighter()
	var offers: Array = f.get("offers", [])
	_check(not offers.is_empty(), "offers arrived")
	if offers.is_empty():
		return
	# Find the needs for the offer
	var needs := Needs.needs(c)
	var offer_need: Dictionary = {}
	for n in needs:
		if str(n["act"]) == "openBout":
			offer_need = n
			break
	_check(not offer_need.is_empty(), "found openBout need")
	if offer_need.is_empty():
		return
	# Check title format: "Answer <first name>'s bout offer"
	var title: String = str(offer_need["t"])
	_check(title.length() < 34, "offer title under 34 chars: '%s' (%d)" % [title, title.length()])
	_check(title.contains(f["first"]), "offer title contains fighter's first name '%s'" % f["first"])
	_check(title.begins_with("Answer "), "offer title starts with 'Answer'")
	# Check second line has opponent name
	var subtitle: String = str(offer_need["s"])
	var opp_name: String = str(offers[0]["opp"]["name"])
	_check(subtitle.contains(opp_name), "offer subtitle contains opponent name '%s'" % opp_name)
	_check(subtitle.contains("expires"), "offer subtitle contains 'expires'")
	# Check act is still openBout
	_check(str(offer_need["act"]) == "openBout", "offer act is 'openBout'")
