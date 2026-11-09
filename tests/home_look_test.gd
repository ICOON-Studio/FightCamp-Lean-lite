extends SceneTree
## S394 HOME's words and order on a real career: needs by urgency, the form when the club has no results for a fighter, the next
## fight's line, the since-Monday lines, five rail buttons. The look itself is judged on stills, not here.

const Sim := preload("res://scripts/state/Sim.gd")
const HomeNeeds := preload("res://scripts/ui/HomeNeeds.gd")
const HomeRows := preload("res://scripts/ui/HomeRows.gd")
const HomeSide := preload("res://scripts/ui/HomeSide.gd")
const HomeMatch := preload("res://scripts/ui/HomeMatch.gd")
const Shell := preload("res://scripts/ui/Shell.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print(("  ok: " if ok else "  FAIL: ") + what)
	if not ok:
		failures += 1


func _initialize() -> void:
	_check(HomeRows.ordinal(1) == "1st" and HomeRows.ordinal(2) == "2nd" and HomeRows.ordinal(3) == "3rd", "ordinals 1-3")
	_check(HomeRows.ordinal(11) == "11th" and HomeRows.ordinal(12) == "12th" and HomeRows.ordinal(23) == "23rd", "ordinals past 10")
	_check(HomeNeeds.urgency({"red": true, "act": "go", "arg": "money:3"}) == 0, "a clock-stopper comes first")
	_check(HomeNeeds.urgency({"red": false, "act": "camp", "arg": "lucy"}) == 1, "a camp comes before a sponsor")
	_check(HomeNeeds.urgency({"red": false, "act": "go", "arg": "money:3"}) == 2, "a sponsor can wait")
	_check(HomeNeeds.urgency({"red": false, "act": "review", "arg": ""}) == 2, "the review can wait")
	_check(HomeRows.past_record({"w": 3, "l": 1}) == "3 and 1", "the record reads in words")
	_check(HomeRows.past_record({"w": 0, "l": 0}) == "No fights", "no bouts at all says so")
	_check(HomeRows.past_record({"pro": true, "pro_w": 0, "pro_l": 0, "w": 9, "l": 1}) == "9 and 1 amateur", "before the debut the amateur record stands")
	_check(Shell.RAIL.size() == 1, "one way back to the gym (S416: no double menus)")
	var c := Career.quick_start()
	if c != null:
		_check(HomeMatch.hero(c).is_empty() or HomeMatch.hero(c).has("id"), "the hero reads a new career")
		_check(HomeSide.since_lines(c).size() <= HomeSide.SINCE_SHOWN, "since lines stay to the cap")
	print("HOME_LOOK failures=%d" % failures)
	quit(1 if failures > 0 else 0)
