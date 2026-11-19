extends SceneTree
## HOTBLIND1: contract-only checks for HotStreak and RivalOffer. The expectations
## come from the task brief, their ## comments, and their published constants;
## implementation bodies and tests/hot_streak_test.gd were not used.

const HotStreak := preload("res://scripts/state/HotStreak.gd")
const RivalOffer := preload("res://scripts/rules/RivalOffer.gd")

var failures: int = 0


func _initialize() -> void:
	_test_hot_and_words()
	_test_isolation()
	_test_would_duck()
	_test_duck_records()
	_test_owed_answer()
	if failures == 0:
		print("HOT_CONTRACT PASS fails=0")
	else:
		print("HOT_CONTRACT FAIL fails=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, what: String) -> void:
	if condition:
		print("ok " + what)
	else:
		failures += 1
		print("FAIL " + what)


func _result(fid: String, win: bool, day: int, pts: int, pro: bool = false) -> Dictionary:
	return {"fid": fid, "win": win, "d": day, "pts": pts, "pro": pro}


func _test_hot_and_words() -> void:
	var c := Career.new()
	var f := {"id": "a", "rep": 20}
	c.day = 100
	c.results = []
	_check(not HotStreak.hot(c, f), "empty results are not hot")
	_check(HotStreak.words(c, f) == "", "not hot has no words")

	c.results = [_result("a", true, 100, 4), _result("a", true, 90, 4)]
	_check(not HotStreak.hot(c, f), "two wins with enough points are not hot")
	c.results = [_result("a", true, 100, 3), _result("a", true, 90, 3), _result("a", true, 80, 1)]
	_check(not HotStreak.hot(c, f), "three wins and seven points are not hot")
	c.results = [_result("a", true, 100, 3), _result("a", true, 90, 3), _result("a", true, 80, 2)]
	_check(HotStreak.hot(c, f), "three wins and exactly eight points are hot")
	_check(HotStreak.words(c, f) == "On a run: 3 wins, +8 points in 8 weeks.", "words at the exact threshold")

	c.results = [_result("a", true, 100, 3), _result("a", true, 90, 3), _result("a", false, 80, 2), _result("a", true, 70, 10)]
	_check(not HotStreak.hot(c, f), "a non-win breaks the run despite older wins and points")
	_check(HotStreak.words(c, f) == "", "broken run has no words")
	c.results = [_result("a", true, 100, 2), _result("a", true, 90, 2), _result("a", true, 80, 2), _result("a", true, 70, 2), _result("a", false, 60, 3), _result("a", true, 50, 1)]
	_check(HotStreak.hot(c, f), "older non-win does not break newest three wins")
	_check(HotStreak.words(c, f) == "On a run: 4 wins, +12 points in 8 weeks.", "words count the full run and all recent points")

	c.results = [_result("a", true, 100, 3), _result("a", true, 90, 3), _result("a", true, 44, 2)]
	_check(HotStreak.hot(c, f), "points exactly 56 days old count")
	c.results = [_result("a", true, 100, 3), _result("a", true, 90, 3), _result("a", true, 43, 2)]
	_check(not HotStreak.hot(c, f), "points 57 days old do not count")
	c.results = [_result("a", true, 100, 4), _result("a", true, 90, 4), _result("a", true, 43, 100)]
	_check(HotStreak.hot(c, f), "an old win still counts toward the run")
	_check(HotStreak.words(c, f) == "On a run: 3 wins, +8 points in 8 weeks.", "old win adds no recent points")


func _test_isolation() -> void:
	var c := Career.new()
	var f := {"id": "a", "rep": 20}
	c.day = 100
	c.results = [_result("b", true, 100, 100), _result("a", true, 99, 3), _result("a", true, 98, 2), _result("a", true, 97, 2)]
	_check(not HotStreak.hot(c, f), "another boxer's points cannot make her hot")
	c.results = [_result("b", true, 100, 100), _result("a", true, 99, 4), _result("a", true, 98, 4)]
	_check(not HotStreak.hot(c, f), "another boxer's win cannot complete her run")
	c.results = [_result("a", false, 100, 100, true), _result("b", false, 99, 100), _result("a", true, 98, 3), _result("a", true, 97, 3), _result("a", true, 96, 2)]
	_check(HotStreak.hot(c, f), "other boxer and pro non-wins do not break her run")
	_check(HotStreak.words(c, f) == "On a run: 3 wins, +8 points in 8 weeks.", "words exclude other boxer and pro results")
	c.results = [_result("a", true, 100, 100, true), _result("a", true, 99, 3), _result("a", true, 98, 2), _result("a", true, 97, 2)]
	_check(not HotStreak.hot(c, f), "her pro points cannot make her hot")
	c.results = [_result("a", true, 100, 100, true), _result("a", true, 99, 4), _result("a", true, 98, 4)]
	_check(not HotStreak.hot(c, f), "her pro win cannot complete her amateur run")


func _test_would_duck() -> void:
	var c := Career.new()
	var f := {"id": "a", "rep": 20}
	c.day = 100
	c.results = [_result("a", true, 100, 3), _result("a", true, 90, 3), _result("a", true, 80, 2)]
	_check(HotStreak.would_duck(c, f, {"name": "Equal", "rep": 20}, true), "equal rank and No is a duck")
	_check(HotStreak.would_duck(c, f, {"name": "Upper", "rep": 28}, true), "eight points above and No is a duck")
	_check(not HotStreak.would_duck(c, f, {"name": "Below", "rep": 19}, true), "one point below is not a duck")
	_check(not HotStreak.would_duck(c, f, {"name": "Far", "rep": 29}, true), "nine points above is not a duck")
	_check(not HotStreak.would_duck(c, f, {"name": "Equal", "rep": 20}, false), "Yes is not a duck even when hot")
	c.results = []
	_check(not HotStreak.would_duck(c, f, {"name": "Equal", "rep": 20}, true), "No is not a duck when not hot")


func _test_duck_records() -> void:
	var c := Career.new()
	var f := {"id": "a", "rep": 20}
	c.day = 70
	_check(HotStreak.ducks_of(c, f, "Red") == [], "missing ducks read as empty")
	_check(not HotStreak.is_owed(c, f, "Red"), "missing ducks are not owed")
	HotStreak.duck(c, f, "Red")
	_check(f.has("ducks") and f["ducks"].get("Red", []) == [10], "first duck creates storage for the current week")
	_check(not HotStreak.is_owed(c, f, "Red"), "one duck is not owed")
	c.day = 76
	HotStreak.duck(c, f, "Red")
	_check(HotStreak.ducks_of(c, f, "Red") == [10], "same-week asks record one duck")
	_check(not HotStreak.is_owed(c, f, "Red"), "two asks in one week are not owed")
	c.day = 77
	HotStreak.duck(c, f, "Red")
	_check(HotStreak.ducks_of(c, f, "Red") == [10, 11], "next week's duck is recorded separately")
	_check(HotStreak.is_owed(c, f, "Red"), "two distinct weeks inside window are owed")
	HotStreak.duck(c, f, "Blue")
	HotStreak.clear(f, "Red")
	_check(HotStreak.ducks_of(c, f, "Red") == [] and not HotStreak.is_owed(c, f, "Red"), "clear removes the booked rival's ducks")
	_check(HotStreak.ducks_of(c, f, "Blue") == [11], "clear preserves another rival's ducks")

	c.day = 119
	var window_f := {"id": "a", "rep": 20, "ducks": {"Red": [9, 10, 16, 17, 18]}}
	_check(HotStreak.ducks_of(c, window_f, "Red") == [10, 16, 17], "window includes ages zero and seven, excludes eight and future")
	_check(HotStreak.is_owed(c, window_f, "Red"), "two or more ducks in window are owed")
	var spaced := {"id": "a", "rep": 20}
	c.day = 70
	HotStreak.duck(c, spaced, "Red")
	c.day = 126
	HotStreak.duck(c, spaced, "Red")
	_check(not HotStreak.is_owed(c, spaced, "Red"), "ducks eight weeks apart are not owed")
	_check(HotStreak.ducks_of(c, spaced, "Red") == [18], "only the new duck is inside the window")
	_check(spaced["ducks"]["Red"] == [18], "recording a duck drops expired weeks from storage")
	c.day = 133
	_check(HotStreak.ducks_of(c, spaced, "Red") == [18], "a seven-week-old duck remains visible")
	c.day = 182
	_check(HotStreak.ducks_of(c, spaced, "Red") == [], "old ducks expire even without a new record")
	_check(not HotStreak.is_owed(c, spaced, "Red"), "expired ducks cannot make owed")


func _test_owed_answer() -> void:
	var answer: Dictionary = RivalOffer.owed_answer(true, 12)
	_check(answer.get("score") == 95 and answer.get("no_pays") == 3, "owed answer forces 95 and pays 3")
	answer = RivalOffer.owed_answer(true, 100)
	_check(answer.get("score") == 95 and answer.get("no_pays") == 3, "owed answer overrides even a higher score")
	answer = RivalOffer.owed_answer(false, 37)
	_check(answer.get("score") == 37 and answer.get("no_pays") == 0, "not owed preserves score and pays zero")
	answer = RivalOffer.owed_answer(false, 0)
	_check(answer.get("score") == 0 and answer.get("no_pays") == 0, "not owed preserves a zero score")
