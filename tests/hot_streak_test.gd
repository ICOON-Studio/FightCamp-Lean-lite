extends SceneTree
## S518 LADDERWIRE R6 (map DESIGN_LADDER1_V6_DOLA.md R6): the hot streak (3 wins in a row + 8 ladder points in 8 weeks since S519 STREAKPROBE1; was 15),
## its -20 on a rival corner 0-8 points above (Leans No - your boxer is on a run), DUCKED on such a No (once a week at
## most), OWED after two ducks in 8 weeks (the next ask to that rival is a Yes, and booking it clears the slate).
## Population: a quick-start club with Lucy against the region's own named rivals (different records, ratings, clubs).
## Prints HOT_STREAK failures=N.

const Data := preload("res://scripts/state/Data.gd")
const HotStreak := preload("res://scripts/state/HotStreak.gd")
const AskLadder := preload("res://scripts/state/AskLadder.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")

var _fails := 0


func _club() -> Career:
	var c := Career.quick_start()
	c.seed = 11
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 70
	var f: Dictionary = c.fighters[0]
	f["w"] = 4
	f["l"] = 1
	f["rep"] = 40
	f["offers"] = []
	return c


func _win(c: Career, days_ago: int, pts: int, win := true) -> void:
	c.results.push_front({"d": c.day - days_ago, "fid": "lucy", "who": "Lucy", "opp": "X", "win": win, "pts": pts})


func _initialize() -> void:
	var c := _club()
	var f: Dictionary = c.fighters[0]
	_check(not HotStreak.hot(c, f), "no results: not on a run")
	_win(c, 40, 6)
	_win(c, 25, 5)
	_win(c, 10, 6)
	_check(HotStreak.hot(c, f) and HotStreak.words(c, f).begins_with("On a run: 3 wins, +17 points"), "3 wins, +17 in 8 weeks: %s" % HotStreak.words(c, f))
	var cold := _club()
	_win(cold, 40, 2)
	_win(cold, 25, 2)
	_win(cold, 10, 2)
	_check(not HotStreak.hot(cold, cold.fighters[0]), "3 wins but +6 points: not on a run (S519: the bar is 8)")
	var broke := _club()
	_win(broke, 40, 9)
	_win(broke, 25, 9, false)
	_win(broke, 10, 9)
	_check(not HotStreak.hot(broke, broke.fighters[0]), "a loss in the last 3: not on a run")
	var old := _club()
	_win(old, 90, 9)
	_win(old, 70, 9)
	_win(old, 10, 6)
	_check(not HotStreak.hot(old, old.fighters[0]), "3 wins but only +6 inside 8 weeks: not on a run")
	# A rival 5 points above who says yes to a cold boxer and No to a boxer on a run.
	var pick := {}
	for r in c.rivals.filter(func(x): return str(x["div"]) == str(f["div"])):
		r["rep"] = 45
		var hot_l := AskLadder.lines(c, f, r)
		var cold_l := AskLadder.lines(cold, cold.fighters[0], r)
		if bool(hot_l["askable"]) and not bool(hot_l["yes"]) and bool(cold_l["yes"]):
			pick = r
			break
	_check(not pick.is_empty(), "a rival 5 above flips to No for a boxer on a run")
	if pick.is_empty():
		_done()
		return
	var name := str(pick["name"])
	_check(str(AskLadder.lines(c, f, pick)["lean"]) == "Leans No - your boxer is on a run.", "the reason: %s" % AskLadder.lines(c, f, pick)["lean"])
	# First No: DUCKED once.
	_check(not AskFlow.book(c, f, "name", name, c.day + 14), "the ask is refused")
	_check(HotStreak.ducks_of(c, f, name).size() == 1 and str(f["ask_no"]["words"]).contains("DUCKED: one more No"), "DUCKED once: %s" % f["ask_no"]["words"])
	_check(str(AskLadder.lines(c, f, pick)["chip"]).begins_with("DUCKED once"), "the card's chip: %s" % AskLadder.lines(c, f, pick)["chip"])
	AskFlow.book(c, f, "name", name, c.day + 14)
	_check(HotStreak.ducks_of(c, f, name).size() == 1 and not HotStreak.is_owed(c, f, name), "asking again the same week is still one duck")
	# A week on, still hot: second No = DUCKED twice -> OWED.
	c.day += 7
	_check(HotStreak.hot(c, f), "still on a run a week later")
	_check(not AskFlow.book(c, f, "name", name, c.day + 14), "the second ask is refused")
	_check(HotStreak.is_owed(c, f, name) and str(f["ask_no"]["words"]).contains("DUCKED twice"), "DUCKED twice: %s" % f["ask_no"]["words"])
	var owed := AskLadder.lines(c, f, pick)
	_check(bool(owed["owed"]) and bool(owed["yes"]) and str(owed["lean"]) == "Leans Yes - they owe you this bout." and str(owed["chip"]).begins_with("OWED"),
		"OWED: they must say yes: %s / %s" % [owed["lean"], owed["chip"]])
	# The owed ask books, and the slate is clean.
	_check(AskFlow.book(c, f, "name", name, c.day + 14), "the owed ask books the bout")
	_check(HotStreak.ducks_of(c, f, name).is_empty() and not HotStreak.is_owed(c, f, name), "booked: no ducks left")
	# A duck ages out after 8 weeks.
	var d := _club()
	var df: Dictionary = d.fighters[0]
	HotStreak.duck(d, df, name)
	d.day += 7 * 8
	_check(HotStreak.ducks_of(d, df, name).is_empty(), "a duck 8 weeks old no longer counts")
	# A No from a rival far above (out of the 0-8 window) is no duck.
	pick["rep"] = 60
	_check(not HotStreak.would_duck(c, f, pick, true), "a rival 20 above saying No is not a duck")
	_done()


func _done() -> void:
	print("HOT_STREAK failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
