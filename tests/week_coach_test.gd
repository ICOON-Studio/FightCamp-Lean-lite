extends SceneTree
## S356 the coach's one line on the whiteboard (WeekCoach): a red day first, then the weight, then the camp's stat, else
## "leave it" - each from WeekPlan's own numbers for a real week.
## Population: a 61.0 kg amateur lightweight (limit 61.2 / 60.0), conditioning 58, potential 80, coach 60.

const WP := preload("res://scripts/rules/WeekPlan.gd")
const WC := preload("res://scripts/rules/WeekCoach.gd")

var _fails := 0


func _ctx(diet: String, fatigue: float = 20.0) -> Dictionary:
	return {"stats": {"power": 55.0, "speed": 57.0, "technique": 60.0, "defense": 52.0, "conditioning": 58.0, "fight_iq": 50.0,
		"chin": 62.0}, "pot": 80, "coach": 60.0, "weight": 61.0, "diet": diet, "fatigue": fatigue}


func _say(days: Array, diet: String, goal: Dictionary, fatigue := 20.0) -> String:
	var ctx := _ctx(diet, fatigue)
	var evs := WP.evenings_for(1)
	var s := WC.line(days, WP.week(days, ctx, evs), WP.goal_lines(goal, days, ctx, 3, evs), diet)
	print("  coach: " + s)
	return s


func _initialize() -> void:
	var easy := WP.COACH_WEEK
	var goal := {"limit": 61.2, "stat": "conditioning", "target": 58.5}
	_check(_say(easy, "hold", goal) == "The week lands on every line. Leave it.", "the coach's week on an easy goal: leave it")
	_check(_say(easy, "hold", {"limit": 60.0, "stat": "conditioning", "target": 58.5}).begins_with("Over by"), "over the limit on a hold diet: switch to Cut")
	var short := _say(easy, "hold", {"limit": 61.2, "stat": "conditioning", "target": 61.0})
	_check(short.begins_with("Conditioning lands") and short.contains("roadwork morning Hard"), "the stat short: name its session")
	var hard: Array = []
	for d in easy:
		hard.append([str(d[0]), "hard" if str(d[0]) != "rest" else "normal"])
	var red := _say(hard, "hold", goal, 60.0)
	_check(red.contains("'s in the red") and red.contains("down to Light"), "Hard every day: the first day in the red, and the fix")
	_check(not red.begins_with("Sunday"), "the red day is a training day, not the rest day")
	print("WEEK_COACH %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
