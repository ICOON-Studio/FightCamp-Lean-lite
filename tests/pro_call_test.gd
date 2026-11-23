extends SceneTree
## ProCall: TURNPRO1A tests, cut to v17 by S543 TURNPROBUILD17 (map DESIGN_TURNPRO1_V17.md section 6: the two houses, who
## calls by the forecast, the 0.9x second terms, the debut purse by tickets, the money sheet, the pays-back line, the five
## asks, apply_ask and the 14-day window were deleted with their rules). Kept: morale by ambition, the ambition's kind,
## the age line and the age the first calls stop at, no pronouns in the lines left.
const PC := preload("res://scripts/rules/ProCall.gd")
var failures := 0

func _initialize() -> void:
	_test_morale()
	_test_ambition_kind()
	_test_age_line()
	_test_calls_open()
	_test_no_pronouns()
	print("PRO_CALL failures=%d" % failures)
	quit(1 if failures > 0 else 0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS %s" % label)
	else:
		failures += 1
		print("FAIL %s" % label)

func _test_morale() -> void:
	var ok := true
	ok = ok and PC.morale("I want to turn pro", false, false) == 5
	ok = ok and PC.morale("I want to turn pro", true, false) == -5
	ok = ok and PC.morale("A regional title within a year", false, true) == -5
	ok = ok and PC.morale("A regional title within a year", false, false) == 0
	ok = ok and PC.morale("A regional title within a year", true, false) == 0
	ok = ok and PC.morale("A winning record by the summer", false, false) == 0
	ok = ok and PC.morale("A winning record by the summer", true, false) == 0
	_check(ok, "morale all rows")

func _test_ambition_kind() -> void:
	var ok := PC.ambition_kind("A regional title within a year") == "title"
	ok = ok and PC.ambition_kind("I want to turn pro") == "pro"
	ok = ok and PC.ambition_kind("A winning record by the summer") == "other"
	ok = ok and PC.ambition_kind("A first win in front of a home crowd") == "other"
	_check(ok, "ambition_kind title/pro/other")

func _test_age_line() -> void:
	var ok := PC.age_line(28) == ""
	ok = ok and PC.age_line(29) == "Age 29: first calls stop at 32."
	ok = ok and PC.age_line(32) == "First calls have stopped at 32."
	_check(ok, "age_line 28/29/32")

func _test_calls_open() -> void:
	var ok := PC.calls_open(28) and PC.calls_open(31) and not PC.calls_open(32) and not PC.calls_open(35)
	_check(ok, "calls_open 28/31=true 32/35=false")

func _test_no_pronouns() -> void:
	var lines: Array = [PC.age_line(29), PC.age_line(32)]
	var ok := true
	for line in lines:
		var lower: String = " " + str(line).to_lower() + " "
		if lower.contains(" he ") or lower.contains(" she ") or lower.contains(" her ") or lower.contains(" him "):
			ok = false
			print("  PRONOUN in: %s" % lower)
	_check(ok, "no pronouns in any returned line")
