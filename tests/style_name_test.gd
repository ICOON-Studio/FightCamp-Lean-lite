extends SceneTree
## STYLENAME1 - the named style: which one, when it goes, what it changes, the extra plan line.
## Expected values from the brief (ops/research/TASK_STYLENAME1.md), not from the code.

const StyleName := preload("res://scripts/rules/StyleName.gd")

var failures := 0


func _initialize() -> void:
	_check_can_name()
	_check_named()
	_check_monday()
	_check_effect()
	_check_plan_cap()
	_check_two_held()
	_check_fail_proof()
	print("STYLE_NAME failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check_can_name() -> void:
	var f := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}}
	_check(StyleName.can_name(f, "Out-boxer"), "can_name Out-boxer held (Jab 62, step_out 61, step_back 60)")
	_check(not StyleName.can_name(f, "Slugger"), "can_name Slugger false when not held")


func _check_named() -> void:
	var f := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}, "style": "Out-boxer"}
	_check(StyleName.named(f) == "Out-boxer", "named returns Out-boxer while held")
	var f2 := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 59.9}, "style": "Out-boxer"}
	_check(StyleName.named(f2) == "", "named returns empty when step_back drops below 60")


func _check_monday() -> void:
	var f := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}, "style": "Out-boxer"}
	var m1: Dictionary = StyleName.monday(f)
	_check(m1["style"] == "Out-boxer" and m1["lost"] == "" and not m1["auto"], "monday named + held keeps style")

	var f2 := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 59.0}, "style": "Out-boxer"}
	var m2: Dictionary = StyleName.monday(f2)
	_check(m2["style"] == "" and m2["lost"] == "Out-boxer" and not m2["auto"], "monday named + lost drops style, lost names it")

	var f3 := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}}
	var m3: Dictionary = StyleName.monday(f3)
	_check(m3["style"] == "Out-boxer" and m3["lost"] == "" and m3["auto"], "monday no style, one held -> auto names it")

	var f4 := {"moves": {"Jab": 62.0, "Cross": 60.0}, "steps": {"step_out": 61.0, "step_back": 60.0, "pivot_out": 60.0}}
	var m4: Dictionary = StyleName.monday(f4)
	_check(m4["style"] == "" and m4["auto"] == false, "monday no style, two held -> style stays empty")

	var f5 := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}, "style": "Out-boxer"}
	var _before := f5.duplicate(true)
	var _m := StyleName.monday(f5)
	_check(f5 == _before, "monday does not mutate f")


func _check_effect() -> void:
	var f_slug := {"moves": {"Body hook": 60.0, "Lead hook": 60.0}, "steps": {"roll_out": 60.0}, "style": "Slugger"}
	_check(StyleName.effect(f_slug, "knockdown") == 1.1, "Slugger effect knockdown 1.1")
	_check(StyleName.effect(f_slug, "range_open") == 0.0, "Slugger effect range_open 0.0 (neutral add)")
	_check(StyleName.effect(f_slug, "combo_energy") == 1.0, "Slugger effect combo_energy 1.0 (neutral mult)")

	var f_none := {"moves": {}, "steps": {}}
	_check(StyleName.effect(f_none, "knockdown") == 1.0, "no style knockdown neutral 1.0 (mult kind)")

	var f_cp := {"moves": {"Lead hook": 60.0, "Check hook": 60.0}, "steps": {"step_out": 60.0}, "style": "Counter-puncher"}
	_check(StyleName.effect(f_cp, "counter_edge", "loadup") == 0.15, "Counter-puncher counter_edge loadup 0.15")
	_check(StyleName.effect(f_cp, "counter_edge", "press") == 0.15, "Counter-puncher counter_edge press 0.15")
	_check(StyleName.effect(f_cp, "counter_edge", "range") == 0.0, "Counter-puncher counter_edge range 0.0 (when blocks it)")
	_check(StyleName.effect(f_cp, "counter_edge", "") == 0.0, "Counter-puncher counter_edge empty mode 0.0")


func _check_plan_cap() -> void:
	var f := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}, "style": "Out-boxer"}
	_check(StyleName.plan_cap(f, 5) == 6, "plan_cap named, coach_cap 5 -> 6")
	_check(StyleName.plan_cap(f, 7) == 7, "plan_cap named, coach_cap 7 -> 7 (MAX_LINES)")

	var f2 := {"moves": {}, "steps": {}}
	_check(StyleName.plan_cap(f2, 5) == 5, "plan_cap not named, coach_cap 5 -> 5")
	_check(StyleName.plan_cap(f2, 9) == 7, "plan_cap not named, coach_cap 9 -> 7 (MAX_LINES)")


func _check_two_held() -> void:
	var f := {"moves": {"Jab": 62.0, "Cross": 60.0}, "steps": {"step_out": 61.0, "step_back": 60.0, "pivot_out": 60.0}}
	_check(StyleName.two_held(f), "two_held Out-boxer + Volume puncher -> true")
	var f2 := {"moves": {"Jab": 62.0}, "steps": {"step_out": 61.0, "step_back": 60.0}}
	_check(not StyleName.two_held(f2), "two_held only Out-boxer -> false")


func _check_fail_proof() -> void:
	_check(1 == 1, "fail-proof sentinel (always pass)")


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
