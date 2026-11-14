extends SceneTree
## BoutSheet: slots, swap, pass, refusals, rematch, rest window.

const BoutSheet := preload("res://scripts/rules/BoutSheet.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_lead_weeks()
	_test_rest_ready_day()
	_test_eligible()
	_test_holder()
	_test_swap()
	_test_sheet()
	_test_refuse()
	_test_refused_line()
	_test_rematch()
	_test_rusty()
	print("BOUT_SHEET checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


func _four_boxers() -> Array:
	return [
		{"id": "A", "sex": "f", "div": "65kg", "last_bout_day": 10, "ready_day": 25},
		{"id": "B", "sex": "f", "div": "65kg", "last_bout_day": 20, "ready_day": 35},
		{"id": "C", "sex": "m", "div": "60kg", "last_bout_day": 5, "ready_day": 25},
		{"id": "D", "sex": "f", "div": "57kg", "last_bout_day": 50, "ready_day": 100},
	]


func _slot_65(day: int = 35) -> Dictionary:
	return {"show": "CLUB1", "day": day, "sex": "f", "div": "65kg", "named": false, "opp": ""}


func _test_lead_weeks() -> void:
	var seen := {}
	for i in 60:
		var w := BoutSheet.lead_weeks("k%d" % i)
		_check(w >= BoutSheet.LEAD_WEEKS_MIN and w <= BoutSheet.LEAD_WEEKS_MAX, "lead_weeks k%d is %d (1-3)" % [i, w])
		seen[w] = true
	_check(seen.size() == 3, "over 60 keys every lead of 1, 2 and 3 appears (%d kinds)" % seen.size())
	_check(BoutSheet.lead_weeks("k8") == BoutSheet.lead_weeks("k8"), "the same key always gets the same lead")


func _test_rest_ready_day() -> void:
	_check(BoutSheet.rest_ready_day(10, 3, 0, 0) == 31, "last_bout 10 + 3 weeks = day 31")
	_check(BoutSheet.rest_ready_day(10, 5, 50, 0) == 50, "suspension_end 50 > 45: picks 50")
	_check(BoutSheet.rest_ready_day(10, 3, 0, 60) == 60, "stop_rest_end 60 > 31: picks 60")
	_check(BoutSheet.rest_ready_day(10, 4, 0, 0) == 31, "bad window 4 -> REST_DEFAULT 3 weeks: 10+21=31")
	_check(BoutSheet.rest_ready_day(10, 8, 0, 0) == 66, "window 8 is valid: 10+56=66")


func _test_eligible() -> void:
	var boxers := _four_boxers()
	var slot := _slot_65(35)
	var el := BoutSheet.eligible(boxers, slot)
	_check(el.size() == 2, "eligible: two women at 65kg ready by day 35")
	_check(el[0].id == "A", "eligible: A (last_bout 10) before B (last_bout 20)")
	_check(el[1].id == "B", "eligible: B is second")
	var slot2 := _slot_65(100)
	var el2 := BoutSheet.eligible(boxers, slot2)
	_check(el2.size() == 2, "eligible at day 100: still only 65kg women (D is 57kg)")


func _test_holder() -> void:
	var boxers := _four_boxers()
	var slot := _slot_65(35)
	_check(BoutSheet.holder(boxers, slot, {}) == "A", "holder default: first eligible is A")
	var swapped := {BoutSheet.slot_key(slot): "B"}
	_check(BoutSheet.holder(boxers, slot, swapped) == "B", "holder with swap: B takes it")
	var slot_empty := {"show": "X", "day": 1, "sex": "f", "div": "99kg", "named": false, "opp": ""}
	_check(BoutSheet.holder(boxers, slot_empty, {}) == "", "holder with no eligible: empty string")


func _test_swap() -> void:
	var boxers := _four_boxers()
	var slot := _slot_65(35)
	var swapped := {}
	var first := BoutSheet.holder(boxers, slot, swapped)
	_check(first == "A", "swap setup: holder is A")
	var nxt := BoutSheet.swap(boxers, slot, swapped)
	_check(nxt == "B", "swap: next after A is B")
	_check(BoutSheet.holder(boxers, slot, swapped) == "B", "after swap: holder is B")
	var nxt2 := BoutSheet.swap(boxers, slot, swapped)
	_check(nxt2 == "A", "swap again wraps: back to A")
	var one_slot := {"show": "X", "day": 1, "sex": "m", "div": "60kg", "named": false, "opp": ""}
	var sw2 := {}
	var r := BoutSheet.swap(boxers, one_slot, sw2)
	_check(r == "", "swap with one eligible: no-op, returns empty")
	_check(BoutSheet.swap_note("65kg") == "this slot went to your other 65kg boxer", "swap_note text")


func _test_sheet() -> void:
	var boxers := _four_boxers()
	var a: Dictionary = boxers[0]
	var slots := [
		{"show": "S1", "day": 35, "sex": "f", "div": "65kg", "named": false, "opp": ""},
		{"show": "S2", "day": 40, "sex": "f", "div": "65kg", "named": false, "opp": ""},
		{"show": "S3", "day": 45, "sex": "f", "div": "65kg", "named": false, "opp": ""},
		{"show": "S4", "day": 50, "sex": "f", "div": "65kg", "named": false, "opp": ""},
	]
	var sh := BoutSheet.sheet(a, slots, boxers, {}, {}, 50)
	_check(sh.size() == BoutSheet.MAX_CARDS, "sheet trims to MAX_CARDS=3 (had 4)")
	_check(sh[0].day == 35 and sh[1].day == 40 and sh[2].day == 45, "sheet: soonest first")
	var locked := {"S2": 999}
	var sh2 := BoutSheet.sheet(a, slots, boxers, {}, locked, 50)
	_check(sh2.size() == 3, "sheet with locked S2: still 3 (skips S2, picks up S4)")
	var found_s2 := false
	for s in sh2:
		if s.show == "S2":
			found_s2 = true
	_check(not found_s2, "sheet: locked show S2 not in output")


func _test_refuse() -> void:
	var refusals := {}
	var r1 := BoutSheet.refuse(refusals, "SHOW1", 10)
	_check(r1.count == 1 and r1.locked_until == -1, "refuse once: count 1, not locked")
	var r2 := BoutSheet.refuse(refusals, "SHOW1", 20)
	_check(r2.count == 2 and r2.locked_until == 20 + 56, "refuse twice: count 2, locked_until=76")
	var old := {}
	var r3 := BoutSheet.refuse(old, "SHOW2", 10)
	_check(r3.count == 1, "refuse at day 10: count 1")
	var r4 := BoutSheet.refuse(old, "SHOW2", 10 + 56 + 1)
	_check(r4.count == 1, "refuse at day 67: the day-10 refusal dropped out, count 1")


func _test_refused_line() -> void:
	var refusals := {"SHOW1": [10, 20]}
	_check(BoutSheet.refused_line(refusals, "SHOW1", 20) == "refused 2 of 2", "refused_line: 2 of 2")
	_check(BoutSheet.refused_line(refusals, "SHOW1", 20 + 56 + 1) == "refused 0 of 2", "refused_line: old ones dropped")
	_check(BoutSheet.refused_line(refusals, "NOBODY", 50) == "refused 0 of 2", "refused_line: unknown show is 0 of 2")


func _test_rematch() -> void:
	_check(BoutSheet.rematch(["Alice", "Bob"], "Bob"), "rematch: Bob is in history")
	_check(not BoutSheet.rematch(["Alice", "Bob"], "Carol"), "rematch: Carol not in history")


func _test_rusty() -> void:
	_check(not BoutSheet.rusty(0, 41, 0), "rusty at 41 days: not yet (need 42)")
	_check(BoutSheet.rusty(0, 42, 0), "rusty at 42 days: yes (RUST_WEEKS*7=42)")
	_check(BoutSheet.rusty(10, 52, 5), "rusty: base is max(10,5)=10, 52-10=42: yes")
