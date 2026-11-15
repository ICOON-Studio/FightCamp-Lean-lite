extends SceneTree
## S490 STEPVALUE1 lines: the ropes count (StepWire, round "ropes") is named on the corner card's HURT row and in the Why's
## AGAINST YOU line - only when it happened. Roles, never names (S448).

const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")

var failures := 0


func _initialize() -> void:
	var s := CornerCard.summarize([])
	_check(not str(CornerCard.card(s, 80.0, [], 0)["hurt"]).contains("ropes"), "corner card: no ropes, no line")
	_check(str(CornerCard.card(s, 80.0, [], 1)["hurt"]).contains("Put on the ropes once"), "corner card: once")
	_check(str(CornerCard.card(s, 80.0, [], 2)["hurt"]).contains("Put on the ropes 2 times"), "corner card: 2 times")
	var plain := [{"exchanges": [{"won": false}], "won": false}, {"exchanges": [{"won": false}], "won": false}]
	_check(not str(FightWhy.read(plain, "Lucy", "Maria")["against"]).contains("ropes"), "Why: no ropes, no line")
	var roped := [{"exchanges": [{"won": false}], "won": false, "ropes": 1}, {"exchanges": [{"won": false}], "won": false, "ropes": 2}]
	var against := str(FightWhy.read(roped, "Lucy", "Maria")["against"])
	_check(against.contains("On the ropes 3 times with no way off."), "Why: rounds summed (%s)" % against)
	_check(not against.contains("Lucy ") or not against.contains("ropes"), "Why: the ropes line names nobody")
	var once := [{"exchanges": [{"won": false}], "won": false, "ropes": 1}]
	_check(str(FightWhy.read(once, "Lucy", "Maria")["against"]).contains("On the ropes once with no way off."), "Why: once")
	print("ROPES_LINES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
