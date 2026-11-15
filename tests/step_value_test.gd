extends SceneTree
## STEPVALUE2: the step worth table, the mastery tiers, the grade, the stack cap and the learn lines.
## Expected values come from the brief (ops/research/TASK_STEPVALUE2.md) and the map, not from the code.

const SV := preload("res://scripts/rules/StepValue.gd")

const EPS: float = 0.001
const USABLE_WORTH: float = 2.0 / 3.0
const SIGNATURE_WORTH: float = 4.0 / 3.0
const GOOD_MULT: float = 1.2 / 0.85
const POOR_MULT: float = 0.35 / 0.85

var failures: int = 0


func _initialize() -> void:
	_check_styles_and_steps()
	_check_target_table()
	_check_tier()
	_check_worth()
	_check_negatives_ignore_grade()
	_check_stack()
	_check_best_and_wrong()
	_check_learn_line()
	_check_pick_for()
	_report()


func _report() -> void:
	if failures == 0:
		print("STEP_VALUE PASS fails=0")
		quit(0)
	else:
		print("STEP_VALUE FAIL fails=%d" % failures)
		quit(1)


func _check(condition: bool, what: String) -> void:
	if condition:
		print("ok   " + what)
	else:
		failures += 1
		print("FAIL " + what)


func _near(a: float, b: float) -> bool:
	return absf(a - b) < EPS


## The six style words and the ten step ids, in the order the game uses.
func _check_styles_and_steps() -> void:
	var styles: Array = ["Pressure fighter", "Slugger", "Out-boxer", "Counter-puncher", "Volume puncher", "Boxer-puncher"]
	var steps: Array = ["step_in", "step_out", "step_back", "pivot_out", "cut_off", "herd", "feint", "tie_up", "roll_out", "push_off"]
	_check(SV.STYLES.size() == 6 and SV.STYLES == styles, "six style words")
	_check(SV.STEPS.size() == 10 and SV.STEPS == steps, "ten step ids in mastery order")


## Ten steps x six styles = 60 numbers, every style filled for every step, and the table's own size.
func _check_target_table() -> void:
	_check(SV.TARGET.size() == 10, "TARGET has 10 steps (got %d)" % SV.TARGET.size())
	var filled: int = 0
	var complete: bool = true
	for key in SV.TARGET:
		var step: String = str(key)
		var row: Dictionary = SV.TARGET[step]
		_check(row.size() == 6, "%s has 6 styles (got %d)" % [step, row.size()])
		if row.size() != 6:
			complete = false
		for style_key in SV.STYLES:
			var style: String = str(style_key)
			if not row.has(style):
				complete = false
			else:
				filled += 1
	_check(complete, "every step has every one of the six styles")
	_check(filled == 60, "TARGET holds 60 numbers (got %d)" % filled)
	_check(SV.STACK_CAP == 5.0, "STACK_CAP is 5.0 (got %.4f)" % SV.STACK_CAP)
	_check(_near(float(SV.GRADE_MULT["good"]), GOOD_MULT), "GRADE_MULT good is 1.2/0.85")
	_check(_near(float(SV.GRADE_MULT["ok"]), 1.0), "GRADE_MULT ok is 1.0")
	_check(_near(float(SV.GRADE_MULT["poor"]), POOR_MULT), "GRADE_MULT poor is 0.35/0.85")
	_check(_near(float(SV.TIER_WORTH["new"]), 0.0), "TIER_WORTH new is 0")
	_check(_near(float(SV.TIER_WORTH["usable"]), USABLE_WORTH), "TIER_WORTH usable is 2/3")
	_check(_near(float(SV.TIER_WORTH["sharp"]), 1.0), "TIER_WORTH sharp is 1")
	_check(_near(float(SV.TIER_WORTH["signature"]), SIGNATURE_WORTH), "TIER_WORTH signature is 4/3")


## The mastery bar -> tier boundaries: 30 usable, 60 sharp, 85 signature.
func _check_tier() -> void:
	_check(SV.tier(0.0) == "new", "tier 0 is new")
	_check(SV.tier(29.9) == "new", "tier 29.9 is new (got '%s')" % SV.tier(29.9))
	_check(SV.tier(30.0) == "usable", "tier 30 is usable (got '%s')" % SV.tier(30.0))
	_check(SV.tier(59.9) == "usable", "tier 59.9 is usable (got '%s')" % SV.tier(59.9))
	_check(SV.tier(60.0) == "sharp", "tier 60 is sharp (got '%s')" % SV.tier(60.0))
	_check(SV.tier(84.9) == "sharp", "tier 84.9 is sharp (got '%s')" % SV.tier(84.9))
	_check(SV.tier(85.0) == "signature", "tier 85 is signature (got '%s')" % SV.tier(85.0))
	_check(SV.tier(100.0) == "signature", "tier 100 is signature")


## The map's targets are at Sharp, OK grade; tier scales the worth, grade scales the positive worth.
func _check_worth() -> void:
	_check(_near(SV.worth("step_back", "Pressure fighter", 60.0, "ok"), 3.5), "step back vs pressure at sharp is 3.5 (got %.4f)" % SV.worth("step_back", "Pressure fighter", 60.0, "ok"))
	_check(_near(SV.worth("step_back", "Pressure fighter", 85.0, "ok"), 3.5 * SIGNATURE_WORTH), "step back vs pressure at signature is 3.5 x 4/3 (got %.4f)" % SV.worth("step_back", "Pressure fighter", 85.0, "ok"))
	_check(_near(SV.worth("step_back", "Pressure fighter", 40.0, "ok"), 3.5 * USABLE_WORTH), "step back vs pressure at usable is 3.5 x 2/3 (got %.4f)" % SV.worth("step_back", "Pressure fighter", 40.0, "ok"))
	_check(_near(SV.worth("step_back", "Pressure fighter", 10.0, "ok"), 0.0), "step back vs pressure under 30 is 0 (got %.4f)" % SV.worth("step_back", "Pressure fighter", 10.0, "ok"))
	_check(_near(SV.worth("step_back", "Pressure fighter", 60.0, "good"), 3.5 * GOOD_MULT), "step back vs pressure good is 3.5 x 1.2/0.85 (got %.4f)" % SV.worth("step_back", "Pressure fighter", 60.0, "good"))
	_check(_near(SV.worth("step_back", "Pressure fighter", 60.0, "poor"), 3.5 * POOR_MULT), "step back vs pressure poor is 3.5 x 0.35/0.85 (got %.4f)" % SV.worth("step_back", "Pressure fighter", 60.0, "poor"))
	_check(_near(SV.worth("step_back", "Pressure fighter", 60.0, "nonsense"), 3.5), "unknown grade reads as ok (got %.4f)" % SV.worth("step_back", "Pressure fighter", 60.0, "nonsense"))
	_check(_near(SV.worth("nope", "Slugger", 60.0, "ok"), 0.0), "unknown step is 0 (got %.4f)" % SV.worth("nope", "Slugger", 60.0, "ok"))
	_check(_near(SV.worth("step_back", "Brawler", 60.0, "ok"), 0.0), "unknown style is 0 (got %.4f)" % SV.worth("step_back", "Brawler", 60.0, "ok"))
	_check(_near(SV.worth("feint", "Counter-puncher", 60.0, "ok"), 4.0), "feint vs counter at sharp is 4.0 (got %.4f)" % SV.worth("feint", "Counter-puncher", 60.0, "ok"))
	_check(_near(SV.worth("push_off", "Pressure fighter", 60.0, "ok"), 1.5), "push off vs pressure at sharp is 1.5 (got %.4f)" % SV.worth("push_off", "Pressure fighter", 60.0, "ok"))
	_check(_near(SV.worth("tie_up", "Boxer-puncher", 60.0, "ok"), 0.0), "tie up vs boxer-puncher is 0 (got %.4f)" % SV.worth("tie_up", "Boxer-puncher", 60.0, "ok"))


## Walking into a step hurts the same however well it is done: the grade never scales a negative.
func _check_negatives_ignore_grade() -> void:
	_check(_near(SV.worth("step_back", "Out-boxer", 60.0, "good"), -1.5), "step back vs out-boxer good is -1.5 (got %.4f)" % SV.worth("step_back", "Out-boxer", 60.0, "good"))
	_check(_near(SV.worth("step_back", "Out-boxer", 60.0, "poor"), -1.5), "step back vs out-boxer poor is still -1.5 (got %.4f)" % SV.worth("step_back", "Out-boxer", 60.0, "poor"))
	_check(_near(SV.worth("step_in", "Counter-puncher", 85.0, "good"), -2.5 * SIGNATURE_WORTH), "step in vs counter at signature is -2.5 x 4/3 (got %.4f)" % SV.worth("step_in", "Counter-puncher", 85.0, "good"))
	_check(_near(SV.worth("step_in", "Counter-puncher", 29.0, "ok"), 0.0), "step in vs counter under 30 is 0 (got %.4f)" % SV.worth("step_in", "Counter-puncher", 29.0, "ok"))


## The positive part is capped at 5.0; the negatives are added after the cap.
func _check_stack() -> void:
	var capped: float = SV.stack({"step_out": 60.0, "roll_out": 60.0, "tie_up": 60.0}, "Slugger", {})
	_check(_near(capped, 5.0), "stack 2.5+3.0+3.0 vs slugger caps at 5.0 (got %.4f)" % capped)
	var cap_then_negative: float = SV.stack({"step_back": 60.0, "pivot_out": 60.0, "push_off": 60.0, "step_in": 60.0}, "Out-boxer", {})
	_check(_near(cap_then_negative, 0.5), "stack -1.5-0.5-0.5+3.0 vs out-boxer is 0.5 (got %.4f)" % cap_then_negative)
	# The brief's own table row for step_out puts Counter-puncher at -1.0 (step_out's wrong style),
	# so this stack is -1.0+1.0+0.0-2.5 = -2.5. The brief's expected -0.5 reads step_out as +1.0,
	# which its table contradicts; the table is the 60 numbers, so the table wins.
	_check(_near(SV.worth("step_out", "Counter-puncher", 60.0, "ok"), -1.0), "step out vs counter is -1.0 (its wrong style, got %.4f)" % SV.worth("step_out", "Counter-puncher", 60.0, "ok"))
	var no_cap: float = SV.stack({"step_out": 60.0, "roll_out": 60.0, "tie_up": 60.0, "step_in": 60.0}, "Counter-puncher", {})
	_check(_near(no_cap, -2.5), "stack -1.0+1.0+0.0-2.5 vs counter is -2.5, no cap hit (got %.4f)" % no_cap)
	var single: float = SV.stack({"step_back": 60.0}, "Pressure fighter", {})
	_check(_near(single, 3.5), "stack of one step with no grades reads ok (got %.4f)" % single)
	var graded: float = SV.stack({"step_back": 60.0}, "Pressure fighter", {"step_back": "good"})
	_check(_near(graded, 3.5 * GOOD_MULT), "stack reads the grade (got %.4f)" % graded)
	var graded_negative: float = SV.stack({"step_back": 60.0}, "Out-boxer", {"step_back": "good"})
	_check(_near(graded_negative, -1.5), "stack grade never scales a negative (got %.4f)" % graded_negative)
	var empty: float = SV.stack({}, "Slugger", {})
	_check(_near(empty, 0.0), "stack of no steps is 0 (got %.4f)" % empty)
	var unknown: float = SV.stack({"nope": 60.0}, "Slugger", {})
	_check(_near(unknown, 0.0), "stack of an unknown step is 0 (got %.4f)" % unknown)
	var under: float = SV.stack({"step_back": 10.0}, "Pressure fighter", {})
	_check(_near(under, 0.0), "stack of a new step is 0 (got %.4f)" % under)
	# the cap holds whatever the grades do: both good, this would be 8.5 uncapped
	var goods: float = SV.stack({"tie_up": 60.0, "roll_out": 60.0}, "Slugger", {"tie_up": "good", "roll_out": "good"})
	_check(_near(goods, 5.0), "stack of two good steps vs slugger still caps at 5.0 (got %.4f)" % goods)


## Each step's target style and the style it walks into, from the map's table.
func _check_best_and_wrong() -> void:
	_check(SV.best_style("feint") == "Counter-puncher", "feint's best style is counter-puncher (got '%s')" % SV.best_style("feint"))
	_check(SV.wrong_style("step_in") == "Counter-puncher", "step in's wrong style is counter-puncher (got '%s')" % SV.wrong_style("step_in"))
	var bests: Dictionary = {
		"step_back": "Pressure fighter",
		"step_out": "Slugger",
		"pivot_out": "Pressure fighter",
		"step_in": "Out-boxer",
		"cut_off": "Out-boxer",
		"herd": "Volume puncher",
		"feint": "Counter-puncher",
		"tie_up": "Slugger",
		"roll_out": "Slugger",
		"push_off": "Pressure fighter",
	}
	var wrongs: Dictionary = {
		"step_back": "Out-boxer",
		"step_out": "Counter-puncher",
		"pivot_out": "Out-boxer",
		"step_in": "Counter-puncher",
		"cut_off": "Pressure fighter",
		"herd": "Pressure fighter",
		"feint": "Pressure fighter",
		"tie_up": "Out-boxer",
		"roll_out": "Volume puncher",
		"push_off": "Out-boxer",
	}
	for key in SV.STEPS:
		var step: String = str(key)
		_check(SV.best_style(step) == str(bests[step]), "%s's best style is %s (got '%s')" % [step, str(bests[step]), SV.best_style(step)])
		_check(SV.wrong_style(step) == str(wrongs[step]), "%s's wrong style is %s (got '%s')" % [step, str(wrongs[step]), SV.wrong_style(step)])
	_check(SV.best_style("nope") == "", "unknown step has no best style (got '%s')" % SV.best_style("nope"))
	_check(SV.wrong_style("nope") == "", "unknown step has no wrong style (got '%s')" % SV.wrong_style("nope"))


## The learn card's line: game words, no jargon, no names, and the "once usable" promise under 30.
func _check_learn_line() -> void:
	var gain: String = SV.learn_line("step_back", "Pressure fighter", 60.0, "ok")
	_check(_same(gain, "Worth about +3.5 in 100 against a pressure fighter"), "learn line for a gain (got '%s')" % gain)
	var wrong: String = SV.learn_line("step_in", "Counter-puncher", 60.0, "ok")
	_check(_same(wrong, "Walks into it against a counter-puncher: about -2.5 in 100"), "learn line for walking into it (got '%s')" % wrong)
	var little: String = SV.learn_line("pivot_out", "Slugger", 60.0, "ok")
	_check(_same(little, "Little use against a slugger"), "learn line for little use (got '%s')" % little)
	var once: String = SV.learn_line("step_back", "Pressure fighter", 10.0, "ok")
	_check(_same(once, "Worth about +2.3 in 100 against a pressure fighter (once usable)"), "learn line under 30 says once usable (got '%s')" % once)
	var once_negative: String = SV.learn_line("step_in", "Counter-puncher", 10.0, "ok")
	_check(_same(once_negative, "Walks into it against a counter-puncher: about -1.7 in 100 (once usable)"), "learn line under 30 on a wrong style uses the usable worth (got '%s')" % once_negative)
	var once_little: String = SV.learn_line("pivot_out", "Slugger", 0.0, "ok")
	_check(_same(once_little, "Little use against a slugger (once usable)"), "learn line under 30 with no use says once usable (got '%s')" % once_little)
	var signature: String = SV.learn_line("step_back", "Pressure fighter", 90.0, "ok")
	_check(_same(signature, "Worth about +4.7 in 100 against a pressure fighter"), "learn line at signature reads 4/3 (got '%s')" % signature)
	var good: String = SV.learn_line("step_back", "Pressure fighter", 60.0, "good")
	_check(_same(good, "Worth about +4.9 in 100 against a pressure fighter"), "learn line at good grade (got '%s')" % good)
	var names_free: String = SV.learn_line("feint", "Counter-puncher", 60.0, "ok")
	_check(_same(names_free, "Worth about +4.0 in 100 against a counter-puncher"), "learn line names no one (got '%s')" % names_free)
	_check(SV.learn_line("nope", "Slugger", 60.0, "ok") == "", "unknown step has no learn line")
	_check(SV.learn_line("feint", "Brawler", 60.0, "ok") == "", "unknown style has no learn line")


## Who to learn next: the weighted sum over the styles the region brings, highest first, ties in STEPS order.
func _check_pick_for() -> void:
	var pressure: Array = SV.pick_for({"Pressure fighter": 3}, {})
	_check(pressure.size() == 10, "pick_for returns all ten steps (got %d)" % pressure.size())
	_check(str(pressure[0]) == "step_back", "three pressure fighters -> step back first (got '%s')" % str(pressure[0]))
	var counter: Array = SV.pick_for({"Counter-puncher": 2}, {})
	_check(str(counter[0]) == "feint", "two counter-punchers -> feint first (got '%s')" % str(counter[0]))
	var tie: Array = SV.pick_for({}, {})
	var tie_ok: bool = tie == SV.STEPS
	_check(tie_ok, "no styles seen -> every step ties in STEPS order (got %s)" % str(tie))
	var unknown: Array = SV.pick_for({"Brawler": 4}, {})
	_check(unknown == SV.STEPS, "an unknown style scores nothing and ties in STEPS order")
	var outboxer: Array = SV.pick_for({"Out-boxer": 5}, {})
	_check(str(outboxer[0]) == "cut_off", "five out-boxers -> cut off first (got '%s')" % str(outboxer[0]))
	var slugger: Array = SV.pick_for({"Slugger": 2}, {})
	_check(str(slugger[0]) == "tie_up", "two sluggers -> tie up first, STEPS order breaks the tie (got '%s')" % str(slugger[0]))
	var mixed: Array = SV.pick_for({"Pressure fighter": 3, "Counter-puncher": 1}, {})
	_check(str(mixed[0]) == "step_back", "pressure plus a counter -> step back still first (got '%s')" % str(mixed[0]))
	var ordered: bool = true
	var i: int = 1
	while i < mixed.size():
		var prev: float = _score(str(mixed[i - 1]), {"Pressure fighter": 3, "Counter-puncher": 1}, {})
		var here: float = _score(str(mixed[i]), {"Pressure fighter": 3, "Counter-puncher": 1}, {})
		if here > prev + EPS:
			ordered = false
		i += 1
	_check(ordered, "pick_for is sorted highest first")


## The score a step gets for a set of styles seen, rebuilt here so the sort can be checked independently.
func _score(step: String, styles_seen: Dictionary, my_grades: Dictionary) -> float:
	var grade: String = str(my_grades.get(step, "ok"))
	var total: float = 0.0
	for key in styles_seen:
		var style: String = str(key)
		var count: float = float(styles_seen[style])
		total += SV.worth(step, style, 60.0, grade) * count
	return total


## The learn line is a display string: compare it exactly, but never die on a last-digit float difference.
func _same(got: String, expected: String) -> bool:
	if got == expected:
		return true
	var a: PackedStringArray = got.split(" ")
	var b: PackedStringArray = expected.split(" ")
	if a.size() != b.size():
		return false
	for i in a.size():
		if a[i] == b[i]:
			continue
		if not a[i].is_valid_float() or not b[i].is_valid_float():
			return false
		if absf(a[i].to_float() - b[i].to_float()) > 0.006:
			return false
	return true
