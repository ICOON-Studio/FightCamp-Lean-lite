extends SceneTree
## TrainingWeek (the training board's sessions): 8 tests.

const TW := preload("res://scripts/rules/TrainingWeek.gd")
const Data := preload("res://scripts/state/Data.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")

var failures := 0


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	_test5()
	_test6()
	_test7()
	_test8()
	print("TRAINING_WEEK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. Eight sessions; every stat has exactly one session, plus the pads.
func _test1() -> void:
	var ok := TW.SESSIONS.size() == 8
	for stat in Data.STATS:
		var n := 0
		for s in TW.SESSIONS:
			if s["stat"] == stat:
				n += 1
		ok = ok and n == 1
	_check(ok and TW.session_for("") == "pads", "test 1: 8 sessions, one per stat + the pads")


## 2. The eight lines end on eight different points (the S348 mockup sent two cards to nonsense places).
func _test2() -> void:
	var seen := {}
	for s in TW.SESSIONS:
		seen[TW.point(str(s["id"]), "Uppercut")] = true
	_check(seen.size() == 8, "test 2: eight different body points (%s)" % ", ".join(seen.keys()))


## 3. Hours sum to the load for every focus; the main session gets the most after none, the support second.
func _test3() -> void:
	var ok := true
	for focus in Data.STATS:
		var partner := str(TrainingPreview.PARTNER[focus])
		var h: Dictionary = TW.hours(10.0, focus, partner)
		var total := 0.0
		for k in h.keys():
			total += float(h[k])
		var main_h := float(h[TW.session_for(focus)])
		var sup_h := float(h[TW.session_for(partner)])
		ok = ok and absf(total - 10.0) < 0.001 and main_h > sup_h
		for k in h.keys():
			if k != TW.session_for(focus):
				ok = ok and main_h > float(h[k])
	_check(ok, "test 3: hours sum to the load; main > every other session")


## 4. Roles: main = focus, support = partner, pads = pads, the rest "".
func _test4() -> void:
	var ok := TW.role("heavy_bag", "power", "technique") == "main"
	ok = ok and TW.role("shadow", "power", "technique") == "support"
	ok = ok and TW.role("pads", "power", "technique") == "pads"
	ok = ok and TW.role("roadwork", "power", "technique") == ""
	_check(ok, "test 4: main / support / pads / other roles")


## 5. The pads point at the hand of the move she learns: rear for Cross / Uppercut, lead for the rest.
func _test5() -> void:
	var ok := TW.point("pads", "Uppercut") == "rear_fist" and TW.point("pads", "Cross") == "rear_fist"
	for m in ["Jab", "Lead hook", "Body hook", "Check hook"]:
		ok = ok and TW.point("pads", m) == "lead_fist"
	_check(ok, "test 5: pads line ends on the learning move's hand")


## 6. Lead / rear flip for a southpaw on the front picture (her left on the viewer's right).
func _test6() -> void:
	var ok := TW.body_side("lead_shoulder", false) == "left_shoulder" and TW.body_side("lead_shoulder", true) == "right_shoulder"
	ok = ok and TW.body_side("rear_fist", false) == "right_fist" and TW.body_side("head", true) == "head"
	_check(ok, "test 6: orthodox lead = left, southpaw lead = right; centre points unchanged")


## 7. Every week card belongs to one session, and drills() finds hers.
func _test7() -> void:
	var ok := true
	for c in Data.CARDS:
		ok = ok and TW.session(str(TW.CARD_SESSION.get(c, ""))).size() > 0
	var d := TW.drills("roadwork", ["Jab and move", "Hill sprints"])
	_check(ok and d == ["Hill sprints"], "test 7: each week card sits on a session; drills() picks hers")


## 8. hours_text: minutes under an hour, one decimal above.
func _test8() -> void:
	_check(TW.hours_text(0.64) == "38 min" and TW.hours_text(3.2) == "3.2 h", "test 8: hours text")
