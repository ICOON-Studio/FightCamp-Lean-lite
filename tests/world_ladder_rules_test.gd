extends SceneTree
## WorldLadderRules: the ladder cut, the promoter's band, and the title route.
## An unranked fighter's route starts at entering. Prints WORLD_LADDER_RULES failures=<n>.

const Rules := preload("res://scripts/rules/WorldLadderRules.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")

var failures := 0


func _init() -> void:
	var me := {"rank": 12, "fans": 0, "ducks": 0, "rating": 60.0}
	var near := {"rank": 8, "rating": 70.0}
	var far := {"rank": 1, "rating": 90.0}
	_check(Rules.in_reach(me, near) and not Rules.in_reach(me, far), "reach is the promoter's band")
	var open: Dictionary = Rules.row_ask(me, near, false)
	_check(bool(open["show"]) and bool(open["on"]) and str(open["why"]) == "", "an open ask inside the band")
	var booked: Dictionary = Rules.row_ask(me, near, true)
	_check(bool(booked["show"]) and not bool(booked["on"]) and str(booked["why"]) == "Booked", "a booked ask stays, grey")
	var high: Dictionary = Rules.row_ask(me, far, false)
	_check(not bool(high["show"]) and str(high["why"]) != "", "out of reach draws no Ask")
	var route: Dictionary = Rules.title_route(0)
	var first: Dictionary = route["steps"][0]
	_check(str(first["id"]) == "entering" and bool(first["now"]) and not bool(first["done"]), "an unranked fighter's route starts at entering")
	_check(int(route["wins"]) == 1 + Rules.wins_to_title(MM.UNRANKED_REACH), "entering is the first of the wins to #1")
	var top: Dictionary = Rules.title_route(1)
	_check(bool((top["steps"][0] as Dictionary)["done"]) and int(top["wins"]) == 0, "number 1 has entered and has no wins left")
	var one: Dictionary = Rules.title_route(6)
	_check(str(one["line"]).contains("1 more win") and not str(one["line"]).contains("wins"), "one win left says win")
	var am: Dictionary = Rules.amateur_route(2, 4, 0)
	_check(str((am["steps"][0] as Dictionary)["id"]) == "entering" and bool((am["steps"][0] as Dictionary)["now"]), "an unranked amateur starts at entering")
	_check(str(am["line"]).contains("4") and str(am["line"]).contains("2"), "the amateur line uses the real wins")
	var rows: Array = []
	for i in 12:
		rows.append({"rank": i + 1, "ours": false, "id": str(i)})
	rows.append({"rank": 0, "ours": true, "id": "you"})
	var got: Array = Rules.pick(rows, 10)
	_check(got.size() == 11 and bool((got[10] as Dictionary)["ours"]), "ten plus the unranked fighter")
	_check(int((got[0] as Dictionary)["rank"]) == 1 and int((got[9] as Dictionary)["rank"]) == 10, "the ten stay in rank order")
	var inside: Array = []
	for i in 10:
		inside.append({"rank": i + 1, "ours": i == 2})
	var once: Array = Rules.pick(inside, 10)
	_check(once.size() == 10, "a fighter already in the ten is not added again")
	_check(Rules.chip_state({"injured": true, "booked": true}) == "injured", "injury is the state that shows")
	_check(Rules.chip_state({"booked": true}) == "booked" and Rules.chip_state({}) == "free", "booked, else free")
	_check(Rules.trend({}) == "", "no log is not a guessed arrow")
	_check(Rules.trend({"log": [{"rank_before": 8, "rank_after": 5}]}) == "up", "a logged climb is up")
	print("WORLD_LADDER_RULES failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL ", what)
