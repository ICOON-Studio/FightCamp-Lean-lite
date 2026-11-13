extends SceneTree
## S462 INTEGRATE1 #9: TellWorth (what the next tape session buys) reaches the camp's Film option as its hover.
##   1. An opponent with tape and hidden tells: the hover names what the next session looks for and its worth (a range while
##      hidden), the same numbers TellWorth.next_film gives.
##   2. Control: the whole file opened - "Nothing left on the tape to find."; no tape (no bouts on record) - no hover.
##   3. Shown: the built Film card carries that hover.
## Population: Lucy Jackson (Data.lucy) against Maria Ortega (Data.OPPONENTS[0]) and an unrecorded opponent.

const Data := preload("res://scripts/state/Data.gd")
const Camp := preload("res://scripts/ui/modals/Camp.gd")
const TellWorth := preload("res://scripts/rules/TellWorth.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

var failures := 0


class Stub extends Node:
	func act(_a: String, _b: String = "") -> void:
		pass


func _initialize() -> void:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 100)
	f["combos"] = {"1-2": 55.0, "2-3": 40.0}
	var maria: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	f["bout"] = {"opp": maria, "day": 130, "rounds": 3}
	_check(OppFile.has_tape(maria) and not OppFile.hidden(maria).is_empty(), "fixture: the opponent has tape and hidden tells")
	var nf := TellWorth.next_film(maria, f.get("moves", {}), f["combos"], 3)
	var tip := Camp.worth_tip(f, maria)
	print("  hover: " + tip.replace("\n", " | "))
	_check(tip.contains(str(nf["what"])) and tip.contains("worth"), "the hover names what the next session looks for and its worth")
	_check(tip.contains("to %d plan points" % roundi(float(nf["hi"]))), "the hover's top is TellWorth's own (%d)" % roundi(float(nf["hi"])))
	_check(not tip.contains(str(f["first"])) and not tip.contains(str(maria["name"])), "no names in the hover")

	var opened := maria.duplicate(true)
	OppFile.open_all(opened)
	_check(Camp.worth_tip(f, opened) == "Nothing left on the tape to find.", "control: the whole file open - nothing left to find")
	var fresh := maria.duplicate(true)
	fresh["w"] = 0
	fresh["l"] = 0
	_check(Camp.worth_tip(f, fresh) == "", "control: no tape - no hover")

	var camp: Node = Camp.new()
	var stub := Stub.new()
	var card: Button = camp._film_card(stub, f, maria, true)
	_check(card.tooltip_text == tip, "shown: the camp's Film card carries the hover")
	card.free()
	camp.free()
	stub.free()

	print("TELL_WIRE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		print("FAIL " + label)
		failures += 1
