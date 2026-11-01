extends SceneTree
## StrikeMap test: cards, moves, reachability, grey_reason, route.

const SM := preload("res://scripts/rules/StrikeMap.gd")
const C := preload("res://scripts/rules/Combos.gd")

var failures := 0
var _route_print: Array = []


func _initialize() -> void:
	_test_1_counts()
	_test_2_refs()
	_test_3_book_coverage()
	_test_4_connected()
	_test_5_reachability()
	_test_6_range_sense()
	_test_7_grey_reason()
	_test_8_route()
	if failures == 0:
		print("PASS strike_map_test")
	else:
		print("FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok   ", label)
	else:
		failures += 1
		print("  FAIL ", label)


func _test_1_counts() -> void:
	_check(SM.CARDS.size() == 8, "8 cards")
	var ids: Array = []
	for c in SM.CARDS:
		ids.append(str(c["id"]))
	var expected := ["outside", "long", "mid", "inside", "clinch", "own_ropes", "opp_ropes", "corner"]
	_check(ids == expected, "card ids in order")
	var seen := {}
	var unique := true
	for id in ids:
		if seen.has(id):
			unique = false
		seen[id] = true
	_check(unique, "card ids unique")
	_check(SM.MOVES.size() == 30, "30 moves")
	var mids: Array = []
	for m in SM.MOVES:
		mids.append(str(m["id"]))
	var mseen := {}
	var munique := true
	for id in mids:
		if mseen.has(id):
			munique = false
		mseen[id] = true
	_check(munique, "move ids unique")


func _test_2_refs() -> void:
	var card_ids := {}
	for c in SM.CARDS:
		card_ids[str(c["id"])] = true
	var book_ids := {}
	for b in C.BOOK:
		book_ids[str(b["id"])] = true
	var ok_from_to := true
	var ok_combo := true
	for m in SM.MOVES:
		if not card_ids.has(str(m["from"])):
			ok_from_to = false
		if not card_ids.has(str(m["to"])):
			ok_from_to = false
		if str(m["kind"]) == "combo":
			if not book_ids.has(str(m["combo"])):
				ok_combo = false
	_check(ok_from_to, "every move from/to is a card id")
	_check(ok_combo, "every combo row's combo is a BOOK id")


func _test_3_book_coverage() -> void:
	var on_map := {}
	for m in SM.MOVES:
		if str(m["kind"]) == "combo":
			on_map[str(m["combo"])] = true
	var all := true
	for b in C.BOOK:
		if not on_map.has(str(b["id"])):
			all = false
	_check(all, "every BOOK id appears in at least one row")


func _test_4_connected() -> void:
	var ok_out := true
	var ok_in := true
	for c in SM.CARDS:
		var cid := str(c["id"])
		if SM.outs(cid).is_empty():
			ok_out = false
		if SM.ins(cid).is_empty():
			ok_in = false
	_check(ok_out, "every card has at least one way out")
	_check(ok_in, "every card has at least one way in")


func _test_5_reachability() -> void:
	var ok_from_outside := true
	var ok_to_long := true
	for c in SM.CARDS:
		var cid := str(c["id"])
		if cid == "outside":
			continue
		var r := SM.route("outside", cid)
		if r.is_empty():
			ok_from_outside = false
	for c in SM.CARDS:
		var cid := str(c["id"])
		if cid == "long":
			continue
		var r := SM.route(cid, "long")
		if r.is_empty():
			ok_to_long = false
	_check(ok_from_outside, "from outside every card is reachable")
	_check(ok_to_long, "every card reaches long")


func _test_6_range_sense() -> void:
	var bad := ["lead_hook", "body_hook", "rear_uppercut"]
	var ok := true
	for m in SM.MOVES:
		if str(m["kind"]) != "combo":
			continue
		if str(m["from"]) != "outside":
			continue
		var r := C.row(str(m["combo"]))
		if r.is_empty():
			continue
		for beat in r["beats"]:
			if bad.has(str(beat)):
				ok = false
	_check(ok, "no hook/uppercut combo starts at outside")


func _test_7_grey_reason() -> void:
	var gr1 := SM.grey_reason(SM.move("1-2-3"), {})
	_check(gr1.contains("Lead hook"), "grey_reason('1-2-3', {}) names 'Lead hook'")
	var full := {"Jab": 50, "Cross": 50, "Lead hook": 50, "Body hook": 50, "Uppercut": 50, "Check hook": 50}
	var ok_all := true
	for m in SM.MOVES:
		if str(m["kind"]) == "combo":
			if SM.grey_reason(m, full) != "":
				ok_all = false
	_check(ok_all, "grey_reason: full mastery -> '' for every combo row")
	_check(SM.grey_reason(SM.move("break"), full) == "It happens to her", "grey_reason('break') = 'It happens to her'")
	_check(SM.grey_reason(SM.move("step_in"), full) == "", "grey_reason('step_in') = ''")


func _test_8_route() -> void:
	var r := SM.route("outside", "clinch")
	_check(not r.is_empty(), "route(outside, clinch) is non-empty")
	if r.is_empty():
		return
	var ok_chain := true
	var first_from := ""
	var last_to := ""
	for i in r.size():
		var mv := SM.move(str(r[i]))
		if i == 0:
			first_from = str(mv["from"])
		if i == r.size() - 1:
			last_to = str(mv["to"])
		if i < r.size() - 1:
			var nxt := SM.move(str(r[i + 1]))
			if str(mv["to"]) != str(nxt["from"]):
				ok_chain = false
	_check(ok_chain, "route: each row's to is the next row's from")
	_check(first_from == "outside", "route: first from is outside")
	_check(last_to == "clinch", "route: last to is clinch")
	_route_print = r
	print("  route: ", r)
