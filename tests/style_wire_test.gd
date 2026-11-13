extends SceneTree
## S459 INTEGRATE1: the named style reaches the game (StyleName wired). Each check compares a named fighter against the
## same fighter with no name, so a lever that is not wired reads 1.0 / 0 and fails.
##   1. Out-boxer: Duels.control steering it open is 10% higher; closing and holding are untouched.
##   2. Boxer-puncher: a planned line's multiplier on the mid card 1.1, at long 1.0; Counter-puncher 1.15 only vs loadup/press.
##   3. Slugger: Knockdowns' chance x1.1 through the power points BoutNight adds.
##   4. The plan limit: a named style lifts a coach's 5 to 6, never cuts a top coach's 9.
##   5. The week turns: three Sharp moves of a set name the style and say so in the news; a lost hold clears it.

const StyleName := preload("res://scripts/rules/StyleName.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")

var failures := 0
const OUT := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}, "named_style": "Out-boxer"}


func _initialize() -> void:
	_open()
	_plan()
	_knock()
	_limit()
	_week()
	print("STYLE_WIRE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _attrs(extra: Dictionary) -> Dictionary:
	var a := {"footwork": 60.0, "foot_speed": 58.0, "jab": 62.0, "timing": 55.0, "head_movement": 50.0, "strength": 52.0,
		"forward": 50.0, "composure": 55.0}
	a.merge(extra, true)
	return a


func _open() -> void:
	var plain := Duels.control(_attrs({}), -1, Duels.LONG, false)
	var named := _attrs({"open_add": StyleName.effect(OUT, "range_open")})
	_check(is_equal_approx(Duels.control(named, -1, Duels.LONG, false), plain * 1.1), "Out-boxer steers it open x1.1 (%.2f vs %.2f)" % [Duels.control(named, -1, Duels.LONG, false), plain])
	_check(is_equal_approx(Duels.control(named, 1, Duels.LONG, false), Duels.control(_attrs({}), 1, Duels.LONG, false)), "closing is untouched")


func _plan() -> void:
	var bp := {"moves": {"Cross": 61.0, "Uppercut": 60.0}, "steps": {"step_in": 60.0}, "named_style": "Boxer-puncher"}
	_check(is_equal_approx(StyleName.plan_mult(bp, "mid", "range"), 1.1), "Boxer-puncher x1.1 on the mid card")
	_check(is_equal_approx(StyleName.plan_mult(bp, "long", "range"), 1.0), "Boxer-puncher x1.0 at long")
	var cp := {"moves": {"Lead hook": 60.0, "Check hook": 60.0}, "steps": {"step_out": 60.0}, "named_style": "Counter-puncher"}
	_check(is_equal_approx(StyleName.plan_mult(cp, "long", "press"), 1.15), "Counter-puncher x1.15 vs a presser")
	_check(is_equal_approx(StyleName.plan_mult(cp, "long", "range"), 1.0), "Counter-puncher x1.0 vs a range game")
	_check(is_equal_approx(StyleName.plan_mult({}, "mid", "press"), 1.0), "no style: x1.0")


func _knock() -> void:
	var sl := {"moves": {"Body hook": 60.0, "Lead hook": 60.0}, "steps": {"roll_out": 60.0}, "named_style": "Slugger"}
	var add := StyleName.knock_power(sl, Knockdowns.POWER_CHIN_SCALE)
	_check(is_equal_approx(exp(add / Knockdowns.POWER_CHIN_SCALE), 1.1), "Slugger: the added power multiplies the count chance by 1.1 (+%.2f)" % add)
	_check(is_zero_approx(StyleName.knock_power({}, Knockdowns.POWER_CHIN_SCALE)), "no style: no power added")


func _limit() -> void:
	_check(StyleName.limit(OUT, 5) == 6, "a named style lifts a coach's 5 lines to 6 (%d)" % StyleName.limit(OUT, 5))
	_check(StyleName.limit(OUT, 9) == 9, "a top coach's 9 stays 9 (%d)" % StyleName.limit(OUT, 9))
	_check(StyleName.limit({}, 5) == 5, "no style: the coach's 5")


class FakeCareer extends Career:
	var said: Array = []
	func add_news(t: String, _mail: bool = true, _own: bool = false) -> void:
		said.append(t)


func _week() -> void:
	var c := FakeCareer.new()
	var f := {"first": "Ana", "moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}}
	var s: Dictionary = DrillWeek._style_week(c, f)
	_check(str(f.get("named_style", "")) == "Out-boxer" and str(s["style"]) == "Out-boxer", "three Sharp moves of the set name the style (%s)" % str(f.get("named_style", "")))
	_check(c.said.size() == 1 and str(c.said[0]).contains("out-boxer"), "the news says it (%s)" % str(c.said))
	f["steps"]["step_back"] = 58.0
	DrillWeek._style_week(c, f)
	_check(str(f.get("named_style", "x")) == "", "a lost hold clears the style")
	_check(c.said.size() == 2 and str(c.said[1]).contains("no longer"), "the news says it went (%s)" % str(c.said))


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
