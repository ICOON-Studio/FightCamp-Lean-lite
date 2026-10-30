extends SceneTree
## CallEvidence: 6 tests.
## 1. Structure: 9 keys, <= 70 chars, digit, no she/her in 8 call lines.
## 2. Numbers: long "3 of 7", body "48 (hurt)" + "4 to the body", calm "38".
## 3. finish picks b's lowest (nose 30 -> "nose: 30 (critical)"); hands picks a's lowest face.
## 4. Band edges: 56 fine, 55 hurt, 35 critical, 15 doctor.
## 5. open_line: 2 fires -> "2 times"; 1 fire -> "once"; ties -> lowest t; no b fire -> "".
## 6. Zero thrown -> "Lucy threw no jabs"; empty map -> no crash.

const CE := preload("res://scripts/rules/CallEvidence.gd")

var failures := 0


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	_test5()
	_test6()
	print("CALL_EVIDENCE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures += 1
		print("  FAIL: " + msg)


func _has_digit(s: String) -> bool:
	for c in s:
		if c >= "0" and c <= "9":
			return true
	return false


func _has_she_her(s: String) -> bool:
	var re := RegEx.new()
	re.compile("(?i)\\b(she|her)\\b")
	return re.search(s) != null


func _names() -> Array:
	return ["Lucy", "Maria"]


func _map1() -> Dictionary:
	return {
		"a": {"places": {"head": 100.0, "left_eye": 100.0, "right_eye": 100.0,
			"nose": 100.0, "left_ribs": 100.0, "right_ribs": 100.0}},
		"b": {"places": {"head": 100.0, "left_eye": 100.0, "right_eye": 100.0,
			"nose": 100.0, "left_ribs": 61.0, "right_ribs": 48.0}},
	}


func _tally1() -> Dictionary:
	return {
		"a": {"thrown": {"jab": 7, "straight": 5, "hook": 3, "uppercut": 2,
			"body": 4, "total": 21},
			"landed": {"jab": 3, "straight": 2, "hook": 1, "uppercut": 1,
			"body": 4, "total": 11}, "pct": {}},
		"b": {"thrown": {"jab": 5, "straight": 3, "hook": 2, "uppercut": 1,
			"body": 0, "total": 11},
			"landed": {"jab": 2, "straight": 1, "hook": 1, "uppercut": 0,
			"body": 0, "total": 4}, "pct": {}},
	}


func _fires1() -> Array:
	return [
		{"who": "b", "habit": "drops_right_after_jab", "t": 5.0},
		{"who": "b", "habit": "drops_right_after_jab", "t": 20.0},
	]


func _energy1() -> Dictionary:
	return {"a": 37.6, "b": 80.0}


func _hw1() -> Dictionary:
	return {"drops_right_after_jab": "drops her right after the jab"}


func _test1() -> void:
	var r := CE.lines(_map1(), _tally1(), _fires1(), _energy1(), _names(), _hw1())
	_check(r.size() == 9, "t1: expected 9 keys, got %d" % r.size())
	var all_keys := ["long", "body", "lead", "hands", "let_go", "calm", "tie", "finish", "open"]
	for k in all_keys:
		_check(r.has(k), "t1: missing key '%s'" % k)
	var eight := ["long", "body", "lead", "hands", "let_go", "calm", "tie", "finish"]
	for k in eight:
		var line: String = r[k]
		_check(line.length() <= 70, "t1: '%s' too long (%d chars)" % [k, line.length()])
		_check(_has_digit(line), "t1: '%s' no digit: '%s'" % [k, line])
		_check(not _has_she_her(line), "t1: '%s' has she/her: '%s'" % [k, line])


func _test2() -> void:
	var r := CE.lines(_map1(), _tally1(), _fires1(), _energy1(), _names(), _hw1())
	_check(r["long"].find("3 of 7") >= 0, "t2: long missing '3 of 7': '%s'" % r["long"])
	_check(r["body"].find("48 (hurt)") >= 0, "t2: body missing '48 (hurt)': '%s'" % r["body"])
	_check(r["body"].find("4 to the body") >= 0, "t2: body missing '4 to the body': '%s'" % r["body"])
	_check(r["calm"].find("38") >= 0, "t2: calm missing '38': '%s'" % r["calm"])


func _test3() -> void:
	var m := {
		"a": {"places": {"head": 100.0, "left_eye": 70.0, "right_eye": 100.0,
			"nose": 100.0, "left_ribs": 100.0, "right_ribs": 100.0}},
		"b": {"places": {"head": 100.0, "left_eye": 100.0, "right_eye": 100.0,
			"nose": 30.0, "left_ribs": 100.0, "right_ribs": 100.0}},
	}
	var r := CE.lines(m, _tally1(), [], _energy1(), _names(), {})
	_check(r["finish"].find("nose: 30 (critical)") >= 0,
		"t3: finish expected 'nose: 30 (critical)': '%s'" % r["finish"])
	_check(r["hands"].find("left eye 70") >= 0,
		"t3: hands expected 'left eye 70': '%s'" % r["hands"])


func _test4() -> void:
	var edges := [[56.0, "fine"], [55.0, "hurt"], [35.0, "critical"], [15.0, "doctor"]]
	for e in edges:
		var v: float = e[0]
		var band: String = e[1]
		var m := {
			"a": {"places": {"head": 100.0, "left_eye": 100.0, "right_eye": 100.0,
				"nose": 100.0, "left_ribs": 100.0, "right_ribs": 100.0}},
			"b": {"places": {"head": 100.0, "left_eye": 100.0, "right_eye": 100.0,
				"nose": v, "left_ribs": 100.0, "right_ribs": 100.0}},
		}
		var r := CE.lines(m, _tally1(), [], _energy1(), _names(), {})
		var expected := "nose: %d (%s)" % [int(v), band]
		_check(r["finish"].find(expected) >= 0,
			"t4: band %.0f -> '%s', got '%s'" % [v, expected, r["finish"]])


func _test5() -> void:
	var hw := {"drops_right_after_jab": "drops her right after the jab",
		"low_lead_hand": "keeps her lead hand low"}

	var fires1 := [
		{"who": "b", "habit": "drops_right_after_jab", "t": 5.0},
		{"who": "b", "habit": "drops_right_after_jab", "t": 20.0},
		{"who": "b", "habit": "low_lead_hand", "t": 2.0},
		{"who": "a", "habit": "slow_starter", "t": 1.0},
	]
	var o1 := CE.open_line(fires1, _names(), hw)
	_check(o1 == "Maria drops her right after the jab: 2 times",
		"t5: two fires, got '%s'" % o1)

	var fires2 := [{"who": "b", "habit": "low_lead_hand", "t": 2.0}]
	var o2 := CE.open_line(fires2, _names(), hw)
	_check(o2 == "Maria keeps her lead hand low: once",
		"t5: one fire -> once, got '%s'" % o2)

	var fires3 := [
		{"who": "b", "habit": "x", "t": 10.0},
		{"who": "b", "habit": "y", "t": 3.0},
	]
	var hw3 := {"x": "does x", "y": "does y"}
	var o3 := CE.open_line(fires3, _names(), hw3)
	_check(o3 == "Maria does y: once",
		"t5: ties -> lowest t, got '%s'" % o3)

	var fires4 := [{"who": "a", "habit": "slow_starter", "t": 1.0}]
	var o4 := CE.open_line(fires4, _names(), {})
	_check(o4 == "", "t5: no b fire -> empty, got '%s'" % o4)


func _test6() -> void:
	var t := {
		"a": {"thrown": {"jab": 0, "straight": 0, "hook": 0, "uppercut": 0,
			"body": 0, "total": 0},
			"landed": {"jab": 0, "straight": 0, "hook": 0, "uppercut": 0,
			"body": 0, "total": 0}, "pct": {}},
		"b": {"thrown": {"jab": 0, "straight": 0, "hook": 0, "uppercut": 0,
			"body": 0, "total": 0},
			"landed": {"jab": 0, "straight": 0, "hook": 0, "uppercut": 0,
			"body": 0, "total": 0}, "pct": {}},
	}
	var m := {
		"a": {"places": {"head": 100.0, "left_eye": 100.0, "right_eye": 100.0,
			"nose": 100.0, "left_ribs": 100.0, "right_ribs": 100.0}},
		"b": {"places": {"head": 100.0, "left_eye": 100.0, "right_eye": 100.0,
			"nose": 100.0, "left_ribs": 100.0, "right_ribs": 100.0}},
	}
	var r := CE.lines(m, t, [], {"a": 100.0, "b": 100.0}, _names(), {})
	_check(r["long"] == "Lucy threw no jabs",
		"t6: zero jabs, got '%s'" % r["long"])

	var r2 := CE.lines({}, {}, [], {}, _names(), {})
	_check(r2.has("long"), "t6: empty map missing 'long'")
	_check(r2.has("finish"), "t6: empty map missing 'finish'")
	_check(r2.has("open"), "t6: empty map missing 'open'")
