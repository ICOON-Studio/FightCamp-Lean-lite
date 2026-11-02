extends SceneTree
## NextStep: 9 tests.

const NS := preload("res://scripts/rules/NextStep.gd")
const Roster := preload("res://scripts/state/Roster.gd")

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
	_test9()
	print("NEXT_STEP failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. New signing {} -> lit 0, need "Book her first amateur bout", 5 steps, only step 0 lit.
func _test1() -> void:
	var r: Dictionary = NS.road({}, 20)
	var ok := true
	if r["lit"] != 0:
		ok = false
	if r["need"] != "Book the first amateur bout":
		ok = false
	if r["steps"].size() != 5:
		ok = false
	var lit_count := 0
	for i in range(r["steps"].size()):
		var s: Dictionary = r["steps"][i]
		if s["lit"]:
			lit_count += 1
			if i != 0:
				ok = false
		if i == 0 and s["done"]:
			ok = false
	if lit_count != 1:
		ok = false
	_check(ok, "test 1: new signing lit=0 need='Book the first amateur bout' (got lit=%d need='%s' steps=%d)" % [r["lit"], r["need"], r["steps"].size()])


## 2. {bouts 3, reg_days 35, age 22} -> lit 1, need contains "Needs 5 bouts (has 3)" and "entries close in 50 days".
func _test2() -> void:
	var f := {"bouts": 3, "reg_days": 35, "age": 22}
	var r: Dictionary = NS.road(f, 20)
	var ok := true
	if r["lit"] != 1:
		ok = false
	if not r["need"].contains("Needs 5 bouts (has 3)"):
		ok = false
	if not r["need"].contains("entries close in 50 days"):
		ok = false
	_check(ok, "test 2: lit=1 need contains 'Needs 5 bouts (has 3)' and 'entries close in 50 days' (got lit=%d need='%s')" % [r["lit"], r["need"]])


## 3. {bouts 6, reg_days 100, age 22} -> lit 2, need contains "Enter her"; with nationals "entered" -> "She is in the draw".
func _test3() -> void:
	var f1 := {"bouts": 6, "reg_days": 100, "age": 22}
	var r1: Dictionary = NS.road(f1, 20)
	var ok := true
	if r1["lit"] != 2:
		ok = false
	if not r1["need"].begins_with("Enter"):
		ok = false
	var f2 := {"bouts": 6, "reg_days": 100, "age": 22, "nationals": "entered"}
	var r2: Dictionary = NS.road(f2, 20)
	if r2["need"] != "She is in the draw":
		ok = false
	_check(ok, "test 3: lit=2 need='Enter her...' and nationals='entered' -> 'She is in the draw' (got lit=%d need='%s', r2 need='%s')" % [r1["lit"], r1["need"], r2["need"]])


## 4. {bouts 8, w 6, rank 2, reg_days 120, age 22, nationals "Lost in the regional final"} -> lit 3, need "1 more win".
func _test4() -> void:
	var f := {"bouts": 8, "w": 6, "rank": 2, "reg_days": 120, "age": 22, "nationals": "Lost in the regional final"}
	var r: Dictionary = NS.road(f, 20)
	var ok := true
	if r["lit"] != 3:
		ok = false
	if r["need"] != "1 more win":
		ok = false
	_check(ok, "test 4: lit=3 need='1 more win' (got lit=%d need='%s')" % [r["lit"], r["need"]])


## 5. Same with rank 0 -> need exactly "1 more wins and a top-3 ranking, or 3 more wins".
func _test5() -> void:
	var f := {"bouts": 8, "w": 6, "rank": 0, "reg_days": 120, "age": 22, "nationals": "Lost in the regional final"}
	var r: Dictionary = NS.road(f, 20)
	var ok := true
	if r["lit"] != 3:
		ok = false
	if r["need"] != "1 more wins and a top-3 ranking, or 3 more wins":
		ok = false
	_check(ok, "test 5: lit=3 rank=0 need='1 more wins and a top-3 ranking, or 3 more wins' (got lit=%d need='%s')" % [r["lit"], r["need"]])


## 6. pro_declines 2 -> "Only a No. 1 ranking brings another offer"; 3 -> "No more offers - she stays amateur".
func _test6() -> void:
	var f1 := {"bouts": 8, "w": 6, "rank": 2, "reg_days": 120, "age": 22, "nationals": "Lost in the regional final", "pro_declines": 2}
	var r1: Dictionary = NS.road(f1, 20)
	var f2 := {"bouts": 8, "w": 6, "rank": 2, "reg_days": 120, "age": 22, "nationals": "Lost in the regional final", "pro_declines": 3}
	var r2: Dictionary = NS.road(f2, 20)
	var ok := true
	if r1["need"] != "Only a No. 1 ranking brings another offer":
		ok = false
	if r2["need"] != "No more offers - she stays amateur":
		ok = false
	_check(ok, "test 6: pro_declines 2 -> 'Only a No. 1 ranking...' 3 -> 'No more offers...' (got r1='%s', r2='%s')" % [r1["need"], r2["need"]])


## 7. Consistency with the game's own rule: for every w in 0..12, rank in 0..5, pro_declines in 0..3, nat_final in [false, true]
## (bouts 15, reg_days 200, age 24, nationals "Won it"): step 3 done == Roster.pro_ready(f). Print the number of cases.
func _test7() -> void:
	var cases := 0
	var ok := true
	for w in range(13):
		for rank in range(6):
			for pro_declines in range(4):
				for nat_final in [false, true]:
					var f := {"bouts": 15, "w": w, "rank": rank, "reg_days": 200, "age": 24, "nationals": "Won it", "pro_declines": pro_declines, "nat_final": nat_final}
					var r: Dictionary = NS.road(f, 20)
					var step3_done: bool = r["steps"][3]["done"]
					var expected: bool = Roster.pro_ready(f)
					if step3_done != expected:
						ok = false
					cases += 1
	print("Consistency cases: %d" % cases)
	_check(ok, "test 7: step 3 done == Roster.pro_ready(f) for %d cases" % cases)


## 8. {pro true, pro_bouts 0, ...} -> lit 4; {pro true, pro_bouts 1} -> lit -1, need "".
func _test8() -> void:
	var f1 := {"bouts": 8, "w": 8, "rank": 1, "reg_days": 200, "age": 24, "nationals": "Won it", "pro": true, "pro_bouts": 0}
	var r1: Dictionary = NS.road(f1, 20)
	var f2 := {"bouts": 8, "w": 8, "rank": 1, "reg_days": 200, "age": 24, "nationals": "Won it", "pro": true, "pro_bouts": 1}
	var r2: Dictionary = NS.road(f2, 20)
	var ok := true
	if r1["lit"] != 4:
		ok = false
	if r2["lit"] != -1:
		ok = false
	if r2["need"] != "":
		ok = false
	_check(ok, "test 8: pro=true pro_bouts=0 -> lit=4; pro_bouts=1 -> lit=-1 need='' (got r1.lit=%d, r2.lit=%d r2.need='%s')" % [r1["lit"], r2["lit"], r2["need"]])


## 9. Steps 0..lit-1 are done in every case above that has no skipped step; never more than one step lit.
func _test9() -> void:
	var cases: Array = [
		{},
		{"bouts": 3, "reg_days": 35, "age": 22},
		{"bouts": 6, "reg_days": 100, "age": 22},
		{"bouts": 6, "reg_days": 100, "age": 22, "nationals": "entered"},
		{"bouts": 8, "w": 6, "rank": 2, "reg_days": 120, "age": 22, "nationals": "Lost in the regional final"},
		{"bouts": 8, "w": 6, "rank": 0, "reg_days": 120, "age": 22, "nationals": "Lost in the regional final"},
		{"bouts": 8, "w": 6, "rank": 2, "reg_days": 120, "age": 22, "nationals": "Lost in the regional final", "pro_declines": 2},
		{"bouts": 8, "w": 6, "rank": 2, "reg_days": 120, "age": 22, "nationals": "Lost in the regional final", "pro_declines": 3},
		{"bouts": 8, "w": 8, "rank": 1, "reg_days": 200, "age": 24, "nationals": "Won it", "pro": true, "pro_bouts": 0},
		{"bouts": 8, "w": 8, "rank": 1, "reg_days": 200, "age": 24, "nationals": "Won it", "pro": true, "pro_bouts": 1},
	]
	var ok := true
	for f in cases:
		var r: Dictionary = NS.road(f, 20)
		var lit: int = r["lit"]
		var lit_count := 0
		for i in range(r["steps"].size()):
			var s: Dictionary = r["steps"][i]
			if s["lit"]:
				lit_count += 1
			if lit >= 0 and i < lit:
				if not s["done"]:
					ok = false
		if lit_count > 1:
			ok = false
	_check(ok, "test 9: steps 0..lit-1 done, never more than one step lit")
