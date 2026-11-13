extends SceneTree
## S461 INTEGRATE1 #2: LineGrade reaches the Plan screen. Each plan line carries its grade word (Good / OK / Poor) for this
## boxer, the two attributes on the hover; a forced or unknown move shows none. The fight and forecast side is GRADE1's
## (line_grade_test, bout_read_test, fight_why_test).
##   1. A move LineGrade grades gets a label whose word is LineGrade.grade's word; the hover names both attributes.
##   2. Control: an ungraded move gets no label.
##   3. The word follows the boxer: the same move on attributes far under OK_AT reads Poor.

const GamePlanRows := preload("res://scripts/ui/GamePlanRows.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 1)
	var attrs := Attrs.of(f)
	var row := HBoxContainer.new()
	GamePlanRows.grade_tag(row, "step_back", attrs, 0)
	var l := row.find_child("Grade_0", true, false) as Label
	var want := str(LineGrade.grade("step_back", attrs).get("word", ""))
	_check(l != null and want != "" and l.text == want, "1 step_back reads %s (%s)" % [want, l.text if l else "none"])
	_check(l != null and l.tooltip_text.contains(str(Attrs.LABEL[str(LineGrade.DONE_WITH["step_back"][0])])), "1 the hover names the attributes")
	GamePlanRows.grade_tag(row, "no_such_move", attrs, 1)
	_check(row.find_child("Grade_1", true, false) == null, "2 an ungraded move shows no grade")
	var low := {}
	for k in attrs.keys():
		low[k] = 20.0
	GamePlanRows.grade_tag(row, "step_back", low, 2)
	var p := row.find_child("Grade_2", true, false) as Label
	_check(p != null and p.text == "Poor", "3 low attributes read Poor (%s)" % (p.text if p else "none"))
	row.free()
	print("GRADE_WIRE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
