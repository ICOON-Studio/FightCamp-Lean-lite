extends SceneTree
## BeltRoad (S353, the BJJ road to black belt) against the IBJJF documents read S353, not against the code:
##   1. the floor: ages 16/16/18/19, black at 18 only for a world champion at brown; days at blue 730, purple 548, brown 365,
##      none at white; a world champion at her belt waits none.
##   2. readiness: the lower of mat time and owned syllabus moves (mastery >= 30), stripes one per quarter.
##   3. promote: refused under the floor (with the reason), allowed early with a mat debt, clean when ready; black is the end.
##   4. the match: 5/6/7/8/10 minutes; points 4/4/3/2/2/2.

const BR := preload("res://scripts/rules/BeltRoad.gd")

var failures := 0


func _initialize() -> void:
	_check_floor()
	_check_readiness()
	_check_promote()
	_check_match()
	print("BELT_ROAD failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _all_owned(belt: String) -> Dictionary:
	var m := {}
	for id in BR.moves_for(belt):
		m[id] = 30.0
	return m


func _check_floor() -> void:
	_check(BR.next_belt("white") == "blue" and BR.next_belt("brown") == "black" and BR.next_belt("black") == "", "belt order")
	_check(BR.age_ok({"belt": "white", "age": 16}) and not BR.age_ok({"belt": "white", "age": 15}), "blue at 16, not 15")
	_check(BR.age_ok({"belt": "purple", "age": 18}) and not BR.age_ok({"belt": "purple", "age": 17}), "brown at 18, not 17")
	_check(BR.age_ok({"belt": "brown", "age": 19}) and not BR.age_ok({"belt": "brown", "age": 18}), "black at 19, not 18")
	_check(BR.age_ok({"belt": "brown", "age": 18, "world_champ": true}), "black at 18 for a world champion at brown")
	_check(BR.days_left({"belt": "white", "belt_day": 100}, 100) == 0, "no minimum at white")
	_check(BR.days_left({"belt": "blue", "belt_day": 0}, 700) == 30, "blue: 2 years (730 days) - 700 served = 30")
	_check(BR.days_left({"belt": "purple", "belt_day": 0}, 0) == 548, "purple: 1.5 years")
	_check(BR.days_left({"belt": "brown", "belt_day": 10}, 375) == 0, "brown: 1 year served")
	_check(BR.days_left({"belt": "blue", "belt_day": 0, "world_champ": true}, 10) == 0, "world champion at blue waits none")


func _check_readiness() -> void:
	var f := {"belt": "white", "belt_day": 0, "age": 22, "mat_classes": 100}
	var half := {}
	var ids: Array = BR.moves_for("white")
	_check(ids.size() == 14, "white -> blue syllabus has 14 moves (got %d)" % ids.size())
	for i in 7:
		half[ids[i]] = 30.0
	half[ids[7]] = 29.9
	var r := BR.readiness(f, half, 50)
	_check(r["mat"] == [100, 200] and r["moves"] == [7, 14], "counts: 100 of 200 classes, 7 of 14 moves (29.9 is not owned)")
	_check(is_equal_approx(float(r["share"]), 0.5) and int(r["stripes"]) == 2, "share 0.5 -> 2 stripes")
	_check(r["floor_ok"] and not r["ready"], "floor met at white, not ready at half")
	f["mat_classes"] = 200
	r = BR.readiness(f, _all_owned("white"), 50)
	_check(r["ready"] and int(r["stripes"]) == 4, "all moves + 200 classes -> ready, 4 stripes")
	f["mat_classes"] = 40
	r = BR.readiness(f, _all_owned("white"), 50)
	_check(is_equal_approx(float(r["share"]), 0.2) and int(r["stripes"]) == 0, "every move but 40 classes -> share 0.2, 0 stripes")
	_check(not BR.readiness({"belt": "black"}, {}, 0)["ready"], "black: nothing further")


func _check_promote() -> void:
	var young := BR.promote({"belt": "white", "age": 15, "belt_day": 0, "mat_classes": 999}, _all_owned("white"), 900)
	_check(not young["ok"] and str(young["why"]).contains("16"), "15-year-old white: refused, says 16")
	var soon := BR.promote({"belt": "blue", "age": 25, "belt_day": 0, "mat_classes": 999}, _all_owned("blue"), 400)
	_check(not soon["ok"] and str(soon["why"]).contains("330"), "blue after 400 days: refused, 330 more days")
	var early := BR.promote({"belt": "white", "age": 20, "belt_day": 0, "mat_classes": 50}, {}, 30)
	_check(early["ok"] and early["early"], "white -> blue before ready: the coach may (early)")
	var ef: Dictionary = early.get("fighter", {})
	_check(ef.get("belt") == "blue" and int(ef.get("mat_debt", 0)) == int(roundf(0.25 * 450)) and int(ef.get("belt_day")) == 30,
		"early blue: new belt, day 30, owes a quarter of 450 classes")
	var ready := BR.promote({"belt": "white", "age": 20, "belt_day": 0, "mat_classes": 200}, _all_owned("white"), 30)
	_check(ready["ok"] and not ready["early"] and int(ready["fighter"]["mat_debt"]) == 0 and int(ready["fighter"]["mat_classes"]) == 0,
		"ready: clean promotion, counters reset")
	var debt := BR.readiness({"belt": "blue", "belt_day": 0, "age": 20, "mat_classes": 100, "mat_debt": 112}, {}, 10)
	_check(debt["mat"][0] == 0, "the debt is paid first: 100 classes - 112 owed = 0 counted")
	_check(not BR.promote({"belt": "black", "age": 40}, {}, 0)["ok"], "a black belt is the end of the road")


func _check_match() -> void:
	_check([BR.match_minutes("white"), BR.match_minutes("blue"), BR.match_minutes("purple"), BR.match_minutes("brown"),
		BR.match_minutes("black")] == [5, 6, 7, 8, 10], "match minutes 5/6/7/8/10")
	_check(BR.POINTS["mount"] == 4 and BR.POINTS["back"] == 4 and BR.POINTS["pass"] == 3 and BR.POINTS["takedown"] == 2
		and BR.POINTS["sweep"] == 2 and BR.POINTS["knee_on_belly"] == 2, "points 4/4/3/2/2/2")


func _check(ok: bool, what: String) -> void:
	if ok:
		print("PASS ", what)
	else:
		failures += 1
		print("FAIL ", what)
