extends SceneTree
## RivalPast: 8 tests.

const RP := preload("res://scripts/rules/RivalPast.gd")

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
	print("RIVAL_PAST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. seed returns w + l bouts with correct win/loss counts.
func _test1() -> void:
	var r: Dictionary = {"name": "Amy Cole", "w": 3, "l": 2}
	var others: Array = [["Bea Lyn", "Z ABC"]]
	var bouts: Array = RP.seed(r, others, 7, 200)
	var ok: bool = bouts.size() == 5
	var wins: int = 0
	var losses: int = 0
	for b in bouts:
		if (b as Dictionary)["win"]:
			wins += 1
		else:
			losses += 1
	if wins != 3:
		ok = false
	if losses != 2:
		ok = false
	_check(ok, "test 1: seed returns 5 bouts (3 wins, 2 losses)")


## 2. Days strictly fall (newest first), all below day0, gaps 21..56.
func _test2() -> void:
	var r: Dictionary = {"name": "Amy Cole", "w": 3, "l": 2}
	var others: Array = [["Bea Lyn", "Z ABC"]]
	var bouts: Array = RP.seed(r, others, 7, 200)
	var ok: bool = true
	var prev_d: int = 200
	for i in range(bouts.size()):
		var b: Dictionary = bouts[i] as Dictionary
		var d: int = b["d"]
		if d >= 200:
			ok = false
		if d >= prev_d:
			ok = false
		var gap: int = prev_d - d
		if i > 0:
			if gap < RP.GAP.x or gap > RP.GAP.y:
				ok = false
		prev_d = d
	_check(ok, "test 2: days strictly fall, all < day0, gaps 21..56")


## 3. Same rival + same seed = identical; different seed = different.
func _test3() -> void:
	var r: Dictionary = {"name": "Amy Cole", "w": 3, "l": 2}
	var others: Array = [["Bea Lyn", "Z ABC"]]
	var a: Array = RP.seed(r, others, 7, 200)
	var b: Array = RP.seed(r, others, 7, 200)
	var same: bool = true
	if a.size() != b.size():
		same = false
	else:
		for i in range(a.size()):
			var ai: Dictionary = a[i] as Dictionary
			var bi: Dictionary = b[i] as Dictionary
			if ai["d"] != bi["d"] or ai["vs"] != bi["vs"] or ai["how"] != bi["how"]:
				same = false
				break
	var c: Array = RP.seed(r, others, 99, 200)
	var diff: bool = false
	if a.size() != c.size():
		diff = true
	else:
		for i in range(a.size()):
			var ai: Dictionary = a[i] as Dictionary
			var ci: Dictionary = c[i] as Dictionary
			if ai["d"] != ci["d"] or ai["vs"] != ci["vs"] or ai["how"] != ci["how"]:
				diff = true
				break
	_check(same and diff, "test 3: deterministic; different seed -> different past")


## 4. No bout vs her own name, even when others contains her.
func _test4() -> void:
	var r: Dictionary = {"name": "Amy Cole", "w": 3, "l": 2}
	var others: Array = [["Amy Cole", "X ABC"], ["Bea Lyn", "Y ABC"]]
	var bouts: Array = RP.seed(r, others, 7, 200)
	var ok: bool = true
	for b in bouts:
		if (b as Dictionary)["vs"] == "Amy Cole":
			ok = false
			break
	_check(ok, "test 4: no bout vs her own name")


## 5. Every bout has required keys; ours == false; how is valid.
func _test5() -> void:
	var r: Dictionary = {"name": "Amy Cole", "w": 3, "l": 2}
	var others: Array = [["Bea Lyn", "Z ABC"]]
	var bouts: Array = RP.seed(r, others, 7, 200)
	var ok: bool = true
	var required: Array = ["d", "vs", "vs_club", "win", "how", "ours"]
	for b in bouts:
		var bd: Dictionary = b as Dictionary
		for key in required:
			if not bd.has(key):
				ok = false
		if bd.get("ours") != false:
			ok = false
		var how: String = str(bd.get("how", ""))
		var valid_how: bool = how in RP.DECISIONS
		if not valid_how:
			if how.begins_with("stopped in round "):
				var suffix: String = how.substr("stopped in round ".length())
				if suffix in ["1", "2", "3"]:
					valid_how = true
		if not valid_how:
			ok = false
	_check(ok, "test 5: all keys present, ours==false, how valid")


## 6. A 0-0 rival gets an empty past.
func _test6() -> void:
	var r: Dictionary = {"name": "Amy Cole", "w": 0, "l": 0}
	var others: Array = [["Bea Lyn", "Z ABC"]]
	var bouts: Array = RP.seed(r, others, 7, 200)
	_check(bouts.is_empty(), "test 6: 0-0 rival gets empty past")


## 7. add puts bout first; second add goes in front; add on empty dict leaves it empty.
func _test7() -> void:
	var r: Dictionary = {"name": "Amy Cole"}
	RP.add(r, 210, "Cara Dee", "Z ABC", true, "on points, 3-0", true)
	var ok: bool = true
	if not r.has("bouts"):
		ok = false
	else:
		var bouts: Array = r["bouts"] as Array
		if bouts.size() != 1:
			ok = false
		else:
			var first: Dictionary = bouts[0] as Dictionary
			if first["d"] != 210:
				ok = false
			if first["vs"] != "Cara Dee":
				ok = false
			if first["ours"] != true:
				ok = false
	RP.add(r, 220, "Dia Fox", "A ABC", false, "on points, 2-1", true)
	if r.has("bouts"):
		var bouts: Array = r["bouts"] as Array
		if bouts.size() != 2:
			ok = false
		else:
			var first: Dictionary = bouts[0] as Dictionary
			if first["d"] != 220:
				ok = false
			if first["vs"] != "Dia Fox":
				ok = false
	var e: Dictionary = {}
	RP.add(e, 210, "Cara Dee", "Z ABC", true, "on points, 3-0", true)
	if not e.is_empty():
		ok = false
	_check(ok, "test 7: add newest-first; add on empty dict is no-op")


## 8. shown(r, 1) returns newest only; shown({}, 3) returns [].
func _test8() -> void:
	var r: Dictionary = {"name": "Amy Cole"}
	RP.add(r, 210, "Cara Dee", "Z ABC", true, "on points, 3-0", true)
	RP.add(r, 220, "Dia Fox", "A ABC", false, "on points, 2-1", true)
	var s1: Array = RP.shown(r, 1)
	var ok: bool = s1.size() == 1
	if s1.size() == 1:
		var b: Dictionary = s1[0] as Dictionary
		if b["vs"] != "Dia Fox":
			ok = false
	var s2: Array = RP.shown({}, 3)
	if not s2.is_empty():
		ok = false
	_check(ok, "test 8: shown returns newest n; shown on empty -> []")
