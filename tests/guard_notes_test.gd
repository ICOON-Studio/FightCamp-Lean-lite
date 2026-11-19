extends SceneTree
## S526 guard v4 step 6: GuardNotes - the camp's guard lines say only what GuardWear / PlanFight do.

const GuardNotes := preload("res://scripts/rules/GuardNotes.gd")
const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

var _fails := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print(("PASS " if ok else "FAIL ") + what)


func _initialize() -> void:
	var press := GuardNotes.style_warning("press")
	_check(press.contains("%d%%" % roundi(GuardWear.WEAR_ROPES * 100.0)), "press warning quotes WEAR_ROPES: " + press)
	_check(GuardNotes.style_warning("loadup") != "", "a loader also puts you on the ropes (LOST_CARD)")
	_check(GuardNotes.style_warning("range") == "" and GuardNotes.style_warning("counter") == "",
		"range / counter games: no rope warning (LOST_CARD has no own_ropes for them)")
	for g in PlanFight.LOST_CARD:
		_check((GuardNotes.style_warning(str(g)) != "") == (str(PlanFight.LOST_CARD[g]) == "own_ropes"), "warning follows LOST_CARD for " + str(g))
	var am := GuardNotes.amateur_note(true)
	_check(am.contains("%d%%" % roundi(GuardWear.WEAR_AMATEUR * 100.0)) and am.contains("back %d" % roundi(GuardWear.RECOVER_QUIET_AMATEUR)),
		"amateur note quotes WEAR_AMATEUR and RECOVER_QUIET_AMATEUR: " + am)
	_check(GuardNotes.amateur_note(false) == "", "pro: no amateur note")
	_check(GuardNotes.lines("press", true).size() == 2 and GuardNotes.lines("range", false).is_empty(), "lines() joins both, skips empties")
	print("guard_notes_test: %s" % ("ALL PASS" if _fails == 0 else "%d FAIL" % _fails))
	quit(0 if _fails == 0 else 1)
