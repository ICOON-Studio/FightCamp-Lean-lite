extends SceneTree
## S516 LADDERWIRE stage 2: the rankings sort by ladder points first, a projected bout moves both sides' points, and
## the Ask card carries points, price, reach and Leans Yes / Leans No (never random), and an out-of-reach or No ask books
## nothing. Population: a quick-start club with Lucy against the region's own named rivals (different records, ratings).
## Prints LADDER_TABLE failures=N.

const RankLine := preload("res://scripts/rules/RankLine.gd")
const LadderRep := preload("res://scripts/rules/LadderRep.gd")
const LadderPoints := preload("res://scripts/state/LadderPoints.gd")
const AskLadder := preload("res://scripts/state/AskLadder.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Region := preload("res://scripts/state/Region.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")
const WorldLadder := preload("res://scripts/ui/WorldLadder.gd")

var _fails := 0


func _initialize() -> void:
	# Order: points first; without points the seed keeps the old net-wins order.
	var x := {"name": "X", "w": 6, "l": 0, "rating": 50.0, "rep": 20}
	var y := {"name": "Y", "w": 4, "l": 3, "rating": 40.0, "rep": 35}
	_check(RankLine._before(y, x) and not RankLine._before(x, y), "35 points rank above 20 points, whatever the record")
	var p := {"name": "P", "w": 6, "l": 1, "rating": 0.0}
	var q := {"name": "Q", "w": 5, "l": 2, "rating": 0.0}
	_check(RankLine._before(p, q), "no points: the seed keeps net wins first (6-1 above 5-2)")
	_check(RankLine.rep(p) == LadderPoints.seed_of(6, 1), "a row without points reads at its seed")
	_check(Region.before(y, x) == RankLine._before(y, x), "Region.before is RankLine's one rule")
	# A projected win moves points: beat the boxer just above and pass her.
	var rows := [{"name": "A", "w": 6, "l": 1, "rating": 0.0, "rep": 30}, {"name": "B", "w": 5, "l": 1, "rating": 0.0, "rep": 27},
		{"name": "Me", "w": 5, "l": 1, "rating": 0.0, "rep": 26}]
	var m := BoutRead.rank_move(rows, {"name": "Me", "w": 5, "l": 1, "rep": 26}, "A", Region.before, 4)
	_check(int(m["now"]) == 3 and int(m["win"]) == 1, "3rd now, 1st after beating the leader (26+8 > 30-8): got %s" % str(m))
	_check(int(m["loss"]) == 3, "a loss keeps her 3rd: got %d" % int(m["loss"]))
	# The career table carries points and is sorted by them.
	var c := Career.quick_start()
	c.seed = 11
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	var table := Region.rankings(c, str(f["div"]))
	var sorted := table.size() >= 2
	for i in range(1, table.size()):
		if int(table[i - 1]["rep"]) < int(table[i]["rep"]):
			sorted = false
	_check(sorted, "Region.rankings is best-points first (%d rows)" % table.size())
	# World > Rankings (amateur): every row carries its points, best first (the Points column reads them).
	var wrows: Array = WorldLadder._amateur_rows(c, f)
	var wok := not wrows.is_empty()
	for r in wrows:
		if not (r as Dictionary).has("rep"):
			wok = false
	_check(wok, "the World table's amateur rows carry ladder points (%d rows)" % wrows.size())
	# The Ask card's ladder lines.
	var opp: Dictionary = c.rivals.filter(func(r): return str(r["div"]) == str(f["div"]))[0]
	var lad := AskLadder.lines(c, f, opp)
	_check(str(lad["points"]).begins_with("Ladder points: yours") and str(lad["price"]).begins_with("Win +"), "points + price lines: %s %s" % [lad["points"], lad["price"]])
	_check(str(lad["lean"]).begins_with("Leans Yes - ") or str(lad["lean"]).begins_with("Leans No - "), "a lean with a reason: %s" % lad["lean"])
	_check(str(AskLadder.lines(c, f, opp)) == str(lad), "the lean is never random (same facts, same answer)")
	# Out of reach: 8 points against 60 is greyed with the points it needs.
	var far := opp.duplicate(true)
	far["rep"] = 60
	var me := f.duplicate(true)
	me["rep"] = 8
	var g := AskLadder.lines(c, me, far)
	_check(not bool(g["askable"]) and int(g["needs"]) == 60 - 8 - LadderRep.reach_up(8) and str(g["reach"]).contains("OUT OF REACH"),
		"8 v 60 is out of reach, needs %d: %s" % [int(g["needs"]), g["reach"]])
	# Reasons the game holds: last meeting and idle weeks.
	var met := {"bouts": [{"d": c.day - 70, "vs": "Me", "win": true}]}
	_check(AskLadder.last_meeting(met, "Me") == "they_won" and AskLadder.idle_weeks(met, c.day) == 10, "last meeting + 10 idle weeks")
	_check(AskLadder.temper("Some Club", 1) in AskLadder.TEMPERS, "a temperament word")
	# An out-of-reach ask books nothing and says why.
	var target := str(opp["name"])
	c.rival(target)["rep"] = 95
	f["rep"] = 0
	f["w"] = 3   # asking opens after the first bout (AskBout.open)
	f["l"] = 1
	var booked := AskFlow.book(c, f, "name", target, c.day + 14)
	_check(not booked and str((f.get("ask_no", {}) as Dictionary).get("words", "")).contains("OUT OF REACH"),
		"an out-of-reach ask is refused with the reason: %s" % str(f.get("ask_no", {})))
	# A No: a 60-point boxer asking a 10-point one - they expect to lose, they say No, nothing is booked.
	c.rival(target)["rep"] = 10
	f["rep"] = 60
	var low := AskLadder.lines(c, f, c.rival(target))
	var asked := AskFlow.book(c, f, "name", target, c.day + 14)
	_check(not bool(low["yes"]) and not asked and str((f.get("ask_no", {}) as Dictionary).get("words", "")).contains("said No - they rate your boxer too highly"),
		"a No is refused with its biggest reason: %s" % str(f.get("ask_no", {})))
	print("LADDER_TABLE failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
	else:
		print("ok ", what)
