extends SceneTree
## SLOTS1 - the learning slots test: slots, speed, cards, swap_price, pick/drop.

const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Data := preload("res://scripts/state/Data.gd")
const LS := preload("res://scripts/rules/LearnSlots.gd")

var failures := 0


func _initialize() -> void:
	_check_slots()
	_check_speed()
	_check_cards()
	_check_builds_style()
	_check_weeks_to_usable()
	_check_swap_price()
	_check_pick_drop()
	_check_two_fighters()
	print("LEARN_SLOTS failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _base_fighter() -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
	f["steps"] = MoveTree.day0_steps(55.0)
	return f


func _check_slots() -> void:
	_check(LS.slots(-1.0) == 1, "slots(-1) -> 1")
	_check(LS.slots(64.9) == 1, "slots(64.9) -> 1")
	_check(LS.slots(65.0) == 2, "slots(65) -> 2")


func _check_speed() -> void:
	var f: Dictionary = _base_fighter()
	f["personality"] = {"coachability": 100.0}
	f["age"] = 25
	var s1: float = LS.speed(f)
	_check(absf(s1 - 1.2) < 0.001, "speed coach100 age25 -> 1.2 (got %.4f)" % s1)
	f["personality"] = {"coachability": 0.0}
	f["age"] = 20
	var s2: float = LS.speed(f)
	_check(absf(s2 - 0.88) < 0.001, "speed coach0 age20 -> 0.88 (got %.4f)" % s2)
	f["personality"] = {"coachability": 55.0}
	f["age"] = 33
	var s3: float = LS.speed(f)
	var expected: float = (0.8 + 0.22) * 0.9
	_check(absf(s3 - expected) < 0.001, "speed coach55 age33 -> %.4f (got %.4f)" % [expected, s3])


func _check_cards() -> void:
	var f: Dictionary = _base_fighter()
	var cs: Array = LS.cards(f, "Pressure fighter", {})
	_check(cs.size() <= 3, "at most 3 cards (got %d)" % cs.size())
	# every id is open in MoveTree
	for c in cs:
		var id: String = str(c["id"])
		_check(MoveTree.state(f, id) == "open", "%s is open" % id)
	# first card answers Pressure fighter if any open node does
	var pf_answers: Array = ["step_back", "pivot_out", "tie_up", "Check hook"]
	var any_answers: bool = false
	for c in cs:
		if pf_answers.has(str(c["id"])):
			any_answers = true
			break
	if any_answers:
		var first_id: String = str(cs[0]["id"])
		_check(pf_answers.has(first_id), "first card answers Pressure fighter (got %s)" % first_id)
	# no card already in learning_slots, no duplicates
	f["learning_slots"] = ["step_back"]
	var cs2: Array = LS.cards(f, "Pressure fighter", {})
	for c in cs2:
		_check(str(c["id"]) != "step_back", "card %s not in learning_slots" % str(c["id"]))
	var seen: Array = []
	for c in cs2:
		_check(not seen.has(str(c["id"])), "no duplicate card %s" % str(c["id"]))
		seen.append(str(c["id"]))


func _check_builds_style() -> void:
	var f: Dictionary = _base_fighter()
	# Out-boxer = Jab, step_out, step_back. Give Jab 61, step_out 60 -> step_back is the third.
	f["moves"]["Jab"] = 61.0
	f["steps"]["step_out"] = 60.0
	# step_back needs step_out 30, which is met. Make sure row 2 is open (need 5 usable).
	# With day0_steps(55): step_in=30.25, step_out=60. Punches from tech 60.1: Jab=51.085, Cross=45.075, Lead hook=37.262, Body hook=30.05.
	# Usable (>=30): Jab, Cross, Lead hook, Body hook, step_in, step_out = 6. Row 2 is open.
	var cs: Array = LS.cards(f, "Slugger", {})
	var found_third: bool = false
	var third_idx: int = -1
	for i in cs.size():
		var c: Dictionary = cs[i]
		if str(c["id"]) == "step_back" and str(c["builds_style"]) == "Out-boxer":
			found_third = true
			third_idx = i
			break
	_check(found_third, "step_back card says Third move of Out-boxer")
	if found_third:
		# check it has the reason string
		var reasons: Array = cs[third_idx]["reasons"]
		var has_reason: bool = false
		for r in reasons:
			if str(r).find("Third move of Out-boxer") >= 0:
				has_reason = true
				break
		_check(has_reason, "step_back reasons contains Third move of Out-boxer")
		# check it ranks above a card with no reason but weeks to Usable
		if cs.size() > 1:
			var last: Dictionary = cs[cs.size() - 1]
			var last_reasons: Array = last["reasons"]
			var last_has_style: bool = false
			for r in last_reasons:
				if str(r).begins_with("Third move of"):
					last_has_style = true
				if str(r).begins_with("Answers a"):
					last_has_style = true
			_check(third_idx < cs.size() - 1 or not last_has_style,
				"Third move of Out-boxer ranks above a plain weeks-to-Usable card")


func _check_weeks_to_usable() -> void:
	# A node at mastery 12 with gain 6 and speed 1.0 -> ceil((30-12)/(6*1.0)) = ceil(3.0) = 3.
	var f: Dictionary = _base_fighter()
	f["personality"] = {"coachability": 50.0}
	f["age"] = 25
	# speed = (0.8 + 0.4*0.5) * 1.0 = 1.0
	var gains: Dictionary = {"Jab": 6.0}
	f["moves"]["Jab"] = 12.0
	var cs: Array = LS.cards(f, "Out-boxer", gains)
	for c in cs:
		if str(c["id"]) == "Jab":
			_check(int(c["weeks_to_usable"]) == 3, "Jab at 12 gain 6 speed 1 -> 3 weeks (got %d)" % int(c["weeks_to_usable"]))
			break


func _check_swap_price() -> void:
	var sp: float = LS.swap_price(20.0)
	_check(absf(sp - 0.75) < 0.001, "swap_price(20) -> 0.75 (got %.4f)" % sp)


func _check_pick_drop() -> void:
	var f: Dictionary = _base_fighter()
	# Pick an open node with slot_count 1
	var open: Array = MoveTree.open_nodes(f)
	_check(open.size() > 0, "fighter has open nodes")
	var first_open: String = str(open[0])
	var ok1: bool = LS.pick(f, first_open, 1)
	_check(ok1, "pick fills one slot")
	# Refuse a second with slot_count 1
	var second: String = ""
	for id in open:
		if str(id) != first_open:
			second = str(id)
			break
	if second != "":
		var ok2: bool = LS.pick(f, second, 1)
		_check(not ok2, "pick refuses second with slot_count 1")
	# Takes a second with slot_count 2
	if second != "":
		var ok3: bool = LS.pick(f, second, 2)
		_check(ok3, "pick takes second with slot_count 2")
	# Refuses a locked node
	var locked_ok: bool = LS.pick(f, "feint", 5)
	# feint needs Jab 60, which day0 fighter doesn't have
	_check(not locked_ok, "pick refuses a locked node (feint)")
	# Drop works
	LS.drop(f, first_open)
	var ls: Array = f.get("learning_slots", [])
	_check(not ls.has(first_open), "drop removes the node")


func _check_two_fighters() -> void:
	# Lucy and Data.PROSPECTS[3] (Danny) give different card lists or different weeks for the same opponent style.
	# Set explicit personalities and make their states clearly different.
	var f1: Dictionary = _base_fighter()
	f1["personality"] = {"coachability": 80.0}
	f1["age"] = 22
	# Give Lucy a different move mastery to change her weeks_to_usable
	f1["moves"]["Jab"] = 20.0
	var f2: Dictionary = Data.fighter_state(Data.PROSPECTS[3], 0)
	f2["steps"] = MoveTree.day0_steps(55.0)
	# Danny has coachability 34, age 20 - clearly different from Lucy's 80/22.
	var cs1: Array = LS.cards(f1, "Pressure fighter", {})
	var cs2: Array = LS.cards(f2, "Pressure fighter", {})
	# Different ids or different weeks
	var ids1: Array = []
	var ids2: Array = []
	for c in cs1:
		ids1.append(str(c["id"]))
	for c in cs2:
		ids2.append(str(c["id"]))
	var different: bool = ids1 != ids2
	if not different:
		# same ids -> check weeks
		for i in cs1.size():
			if int(cs1[i]["weeks_to_usable"]) != int(cs2[i]["weeks_to_usable"]):
				different = true
				break
	_check(different, "two fighters give different cards or weeks (Lucy vs Danny)")


func _check(cond: bool, label: String) -> void:
	if cond:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)
