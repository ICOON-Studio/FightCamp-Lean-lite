extends SceneTree
## S356 CORE3 step 4, the fight plan's Test it (PlanTest):
##   1. nothing booked = no test; a test books nothing (record, cash, results, her saved plan unchanged),
##   2. the range holds the true count, wide on a stranger (tape found nothing) and narrow with her file open,
##   3. the same plan on the same camp rolls the same dice (a change in the range is the plan's); S382 G3: the tests are
##      the camp's sparring nights (3 weeks out on a Wednesday: Thu, Thu, Peak Tue + Thu = 4), the fifth is refused,
##   4. control arm: a plan that answers a presser wins more of the 20 than one that walks into her,
##   5. it says where the plan breaks.
## Population: Lucy Jackson (Data.lucy, out-boxer) vs Maria Ortega (Data.OPPONENTS[0], pressure fighter, southpaw).

const Data := preload("res://scripts/state/Data.gd")
const PlanTest := preload("res://scripts/state/PlanTest.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const BAD := [{"move": "cut_off"}, {"move": "3b-3"}, {"move": "herd"}, {"move": "3b-3@inside"}]

var _fails := 0


func _initialize() -> void:
	var c := _career()
	var f: Dictionary = c.fighter()
	_check(not bool(PlanTest.run(c, f, GOOD)["ok"]), "no bout booked: no test")
	_book(c, f)
	var cash := c.cash
	var w := int(f.get("w", 0))
	var l := int(f.get("l", 0))
	var results := c.results.size()
	var a := PlanTest.run(c, f, GOOD)
	print("GOOD on a stranger: %d of %d, shown %d-%d; %s" % [a["wins"], a["sims"], a["lo"], a["hi"], " | ".join(a["breaks"])])
	_check(bool(a["ok"]) and c.cash == cash and int(f.get("w", 0)) == w and int(f.get("l", 0)) == l and c.results.size() == results
		and (f.get("arrows", []) as Array).is_empty() and not bool(f["bout"].get("done", false)), "a test books nothing")
	_check(int(a["lo"]) <= int(a["wins"]) and int(a["wins"]) <= int(a["hi"]), "the range holds the true count")
	_check(int(a["hi"]) - int(a["lo"]) == 2 * PlanTest.SPREAD_UNSEEN, "a stranger: the range is %d wide" % (int(a["hi"]) - int(a["lo"])))
	_check(not (a["breaks"] as Array).is_empty(), "it says where the plan breaks")
	var b := PlanTest.run(c, f, BAD)
	print("BAD on a stranger: %d of %d, shown %d-%d; %s" % [b["wins"], b["sims"], b["lo"], b["hi"], " | ".join(b["breaks"])])
	# The plan is one edge among the corner's: over 20 bouts it shows in the rounds more than in the bouts.
	var ra: Array = a["rounds"]
	var rb: Array = b["rounds"]
	var gap := float(ra[0]) / float(ra[1]) - float(rb[0]) / float(rb[1])
	_check(gap > 0.03 and gap < 0.4 and int(a["wins"]) >= int(b["wins"]), "control: the plan that answers a presser wins more rounds (%d/%d vs %d/%d) and no fewer bouts (%d vs %d)" % [ra[0], ra[1], rb[0], rb[1], a["wins"], b["wins"]])
	OppFile.open_all(f["bout"]["opp"])
	var g := PlanTest.run(c, f, GOOD)
	_check(int(g["wins"]) >= 0 and int(g["hi"]) - int(g["lo"]) == 2 * PlanTest.SPREAD_SEEN and int(g["lo"]) <= int(g["wins"])
		and int(g["wins"]) <= int(g["hi"]), "her file open: the range narrows to %d-%d" % [g["lo"], g["hi"]])
	_check(int(g["left"]) == 1 and int(g["night"]) == 43, "the third test took the Peak Tuesday; one spar night left")
	var last := PlanTest.run(c, f, GOOD)
	_check(int(last["left"]) == 0 and not bool(PlanTest.run(c, f, GOOD)["ok"]) and PlanTest.left(f, c.day) == 0
		and PlanTest.button(f, c.day) == "Test it - no spar night left", "four spar nights, four tests; the fifth is refused")
	# The same dice: a fresh camp tests the same plan to the same count.
	var c2 := _career()
	var f2: Dictionary = c2.fighter()
	_book(c2, f2)
	OppFile.open_all(f2["bout"]["opp"])
	_check(int(PlanTest.run(c2, f2, GOOD)["wins"]) == int(g["wins"]), "the same plan, the same dice, the same count")
	print("PLAN_TEST_IT %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _career() -> Career:
	var c := Career.quick_start()
	c.seed = 356
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 30
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0}
	return c


func _book(c: Career, f: Dictionary) -> void:
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day + 21, "weighed": true, "made": true,
		"done": false, "film": 1}


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
