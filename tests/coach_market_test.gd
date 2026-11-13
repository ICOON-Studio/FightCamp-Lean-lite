extends SceneTree

var failures := 0

func _initialize() -> void:
	var cm := preload("res://scripts/rules/CoachMarket.gd")

	# market(): 4 coaches, correct ids, correct keys, correct ratings
	var m: Array = cm.market()
	if m.size() != 4:
		failures += 1
		print("FAIL: market size ", m.size())
	var ids: Array = []
	for c in m:
		ids.append(c["id"])
	for eid in ["reid", "hale", "price", "mendez"]:
		if not ids.has(eid):
			failures += 1
			print("FAIL: missing id ", eid)
	var req_keys: Array = ["id", "name", "kind", "salary", "rating", "spec", "note", "areas"]
	for c in m:
		for k in req_keys:
			if not c.has(k):
				failures += 1
				print("FAIL: ", c.get("id", "?"), " missing key ", k)
		var areas: Dictionary = c["areas"]
		var total: int = 0
		for a in areas:
			total += int(areas[a])
		var exp: int = roundi(float(total) / float(areas.size()))
		if int(c["rating"]) != exp:
			failures += 1
			print("FAIL: ", c["id"], " rating ", c["rating"], " != ", exp)

	# Deep copy: changing a returned dict does not change the next market()
	var m1: Array = cm.market()
	var first: Dictionary = m1[0]
	var orig_name: String = first["name"]
	first["name"] = "CHANGED"
	var m2: Array = cm.market()
	if m2[0]["name"] == "CHANGED":
		failures += 1
		print("FAIL: market not deep copied")
	first["name"] = orig_name

	# can_hire
	if not cm.can_hire([], "price"):
		failures += 1
		print("FAIL: can_hire [] price")
	if cm.can_hire(["reid", "hale"], "price"):
		failures += 1
		print("FAIL: can_hire 2+ price")
	if cm.can_hire(["reid"], "reid"):
		failures += 1
		print("FAIL: can_hire reid again")
	if cm.can_hire([], "nobody"):
		failures += 1
		print("FAIL: can_hire nobody")

	# area_now
	if cm.area_now("price", "pads", 0) != 60.0:
		failures += 1
		print("FAIL: price pads 0 = ", cm.area_now("price", "pads", 0))
	if cm.area_now("price", "pads", 8) != 61.0:
		failures += 1
		print("FAIL: price pads 8 = ", cm.area_now("price", "pads", 8))
	if cm.area_now("price", "pads", 96) != 72.0:
		failures += 1
		print("FAIL: price pads 96 = ", cm.area_now("price", "pads", 96))
	if cm.area_now("price", "pads", 500) != 72.0:
		failures += 1
		print("FAIL: price pads 500 = ", cm.area_now("price", "pads", 500))
	if cm.area_now("reid", "pads", 25) != 76.0:
		failures += 1
		print("FAIL: reid pads 25 = ", cm.area_now("reid", "pads", 25))
	if cm.area_now("hale", "bag", 100) != 72.0:
		failures += 1
		print("FAIL: hale bag 100 = ", cm.area_now("hale", "bag", 100))

	# sessions_to
	if cm.sessions_to("price", "pads", 65.0, 0) != 40:
		failures += 1
		print("FAIL: sessions_to price 65 from 0 = ", cm.sessions_to("price", "pads", 65.0, 0))
	if cm.sessions_to("reid", "pads", 65.0, 0) != 0:
		failures += 1
		print("FAIL: sessions_to reid 65 from 0 = ", cm.sessions_to("reid", "pads", 65.0, 0))
	if cm.sessions_to("mendez", "pads", 70.0, 0) != -1:
		failures += 1
		print("FAIL: sessions_to mendez 70 = ", cm.sessions_to("mendez", "pads", 70.0, 0))

	# second_slot
	if cm.second_slot("price", 0):
		failures += 1
		print("FAIL: second_slot price 0")
	if not cm.second_slot("price", 40):
		failures += 1
		print("FAIL: second_slot price 40")
	if not cm.second_slot("reid", 0):
		failures += 1
		print("FAIL: second_slot reid 0")
	if cm.second_slot("hale", 0):
		failures += 1
		print("FAIL: second_slot hale 0")
	if cm.second_slot("mendez", 0):
		failures += 1
		print("FAIL: second_slot mendez 0")
	if not cm.second_slot("mendez", 30):
		failures += 1
		print("FAIL: second_slot mendez 30")

	# signature_rate
	if cm.signature_rate(74.0) != 0.95:
		failures += 1
		print("FAIL: sig 74 = ", cm.signature_rate(74.0))
	if cm.signature_rate(58.0) != 0.25:
		failures += 1
		print("FAIL: sig 58 = ", cm.signature_rate(58.0))
	if cm.signature_rate(72.0) != 0.85:
		failures += 1
		print("FAIL: sig 72 = ", cm.signature_rate(72.0))
	if cm.signature_rate(40.0) != 0.25:
		failures += 1
		print("FAIL: sig 40 = ", cm.signature_rate(40.0))
	if cm.signature_rate(90.0) != 1.0:
		failures += 1
		print("FAIL: sig 90 = ", cm.signature_rate(90.0))

	# node_mult
	if cm.node_mult("mendez", "step_in", 0) != 1.2:
		failures += 1
		print("FAIL: node_mult mendez step 0 = ", cm.node_mult("mendez", "step_in", 0))
	if cm.node_mult("mendez", "Jab", 0) != 1.0:
		failures += 1
		print("FAIL: node_mult mendez Jab = ", cm.node_mult("mendez", "Jab", 0))
	if cm.node_mult("reid", "Jab", 40) != 1.2:
		failures += 1
		print("FAIL: node_mult reid Jab 40 = ", cm.node_mult("reid", "Jab", 40))
	if cm.node_mult("reid", "Jab", 39) != 1.0:
		failures += 1
		print("FAIL: node_mult reid Jab 39 = ", cm.node_mult("reid", "Jab", 39))
	if cm.node_mult("mendez", "step_in", 40) != 1.44:
		failures += 1
		print("FAIL: node_mult mendez step 40 = ", cm.node_mult("mendez", "step_in", 40))

	# let_go
	var lg: Dictionary = cm.let_go("hale")
	if int(lg["cost"]) != 1090:
		failures += 1
		print("FAIL: let_go hale cost = ", lg["cost"])
	if lg["keeps_growth"] != true:
		failures += 1
		print("FAIL: let_go keeps_growth")

	# milestone
	var ms0: String = cm.milestone("price", 0)
	if ms0 != "The young coach: 40 pad sessions to 65: second slots":
		failures += 1
		print("FAIL: milestone price 0 = '", ms0, "'")
	var ms40: String = cm.milestone("price", 40)
	if ms40 != "The young coach: 56 pad sessions to 72: top pads":
		failures += 1
		print("FAIL: milestone price 40 = '", ms40, "'")
	var ms96: String = cm.milestone("price", 96)
	if ms96 != "":
		failures += 1
		print("FAIL: milestone price 96 = '", ms96, "'")

	# No milestone string contains a name, " he ", " she ", " his ", " her "
	var all_ms: Array = []
	for sid in ["reid", "hale", "price", "mendez"]:
		for sess in [0, 10, 40, 80, 200]:
			all_ms.append(cm.milestone(sid, sess))
	for ms in all_ms:
		var low: String = ms.to_lower()
		for banned in [" he ", " she ", " his ", " her "]:
			if low.contains(banned):
				failures += 1
				print("FAIL: milestone has '", banned, "': ", ms)
		for name in ["luke", "reid", "marcus", "hale", "jamie", "price", "rosa", "mendez"]:
			if low.contains(name):
				failures += 1
				print("FAIL: milestone has name '", name, "': ", ms)

	# Two different coaches give different area_now / milestone for the same sessions
	if cm.area_now("price", "pads", 10) == cm.area_now("reid", "pads", 10):
		failures += 1
		print("FAIL: same area_now for price and reid")
	if cm.milestone("price", 10) == cm.milestone("reid", 10):
		failures += 1
		print("FAIL: same milestone for price and reid")

	print("COACH_MARKET failures=", failures)
	quit(failures)
