extends SceneTree
## RANKSHOW1 - RankLine: the rank a fight earned, as a plain line.
## Rows are arrays of {name, w, l, rating} for ALL fighters in the division.
## RankLine determines who's ranked (w >= min_wins) and sorts by net wins, wins, rating.

const RankLine := preload("res://scripts/rules/RankLine.gd")
const MIN_WINS := 4

var _fails := 0


func _initialize() -> void:
	_enter_at_min_wins()
	_climb_names_passed()
	_fall_when_passed()
	_unranked_need()
	_rival_below_does_not_move()
	_equal_net_equal_wins_split_rating()
	_words_no_extra_digits()
	_determinism()
	_still_ranked_same()
	_enter_from_unranked()
	_leave_ranked()
	_before_words()
	print("RANK_LINE failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1


## Find a fighter's record in the rows.
func _find(rows: Array, name: String) -> Dictionary:
	for r in rows:
		if str(r["name"]) == name:
			return r as Dictionary
	return {}


## She enters the rankings at exactly min_wins (4 wins).
func _enter_at_min_wins() -> void:
	var before: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Beth", "w": 6, "l": 2, "rating": 65.0},
		{"name": "Cora", "w": 5, "l": 3, "rating": 60.0},
		{"name": "Lucy", "w": 3, "l": 1, "rating": 50.0}]
	# Lucy wins: now 4-1, enters rankings
	var after: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Beth", "w": 6, "l": 2, "rating": 65.0},
		{"name": "Lucy", "w": 4, "l": 1, "rating": 55.0},
		{"name": "Cora", "w": 5, "l": 3, "rating": 60.0}]
	var r: Dictionary = RankLine.after(before, after, "Lucy", MIN_WINS)
	_check(int(r["was"]) == 0, "was unranked before (3 wins)")
	_check(int(r["now"]) == 3, "now ranked at 3 (net 3, between Beth net 4 and Cora net 2)")
	_check(bool(r["entered"]), "entered the rankings")
	_check(int(r["need"]) == 0, "need is 0 once ranked")
	_check(str(r["words"]).find("nter") >= 0, "words say enters: '%s'" % str(r["words"]))


## She climbs and names the passed fighters in order.
func _climb_names_passed() -> void:
	var before: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Beth", "w": 6, "l": 2, "rating": 65.0},
		{"name": "Lucy", "w": 5, "l": 2, "rating": 60.0},
		{"name": "Cora", "w": 5, "l": 3, "rating": 55.0}]
	# Lucy wins: 6-2 net 4, rating 66 > Beth's 65, passes Beth
	var after: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 6, "l": 2, "rating": 66.0},
		{"name": "Beth", "w": 6, "l": 2, "rating": 65.0},
		{"name": "Cora", "w": 5, "l": 3, "rating": 55.0}]
	var r: Dictionary = RankLine.after(before, after, "Lucy", MIN_WINS)
	_check(int(r["was"]) == 3, "was 3rd")
	_check(int(r["now"]) == 2, "now 2nd")
	_check(int(r["moved"]) == 1, "moved up 1")
	var passed: Array = r["passed"]
	_check(passed.size() == 1 and str(passed[0]) == "Beth", "passed Beth: %s" % str(passed))
	_check(str(r["words"]).find("Beth") >= 0, "words name Beth: '%s'" % str(r["words"]))


## She falls when she loses and another passes her.
func _fall_when_passed() -> void:
	var before: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 5, "l": 2, "rating": 55.0},
		{"name": "Beth", "w": 4, "l": 3, "rating": 60.0}]
	# Lucy loses: 5-3 net 2; Beth wins: 5-3 net 2, same wins, Beth rating 60 > Lucy 55
	var after: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Beth", "w": 5, "l": 3, "rating": 60.0},
		{"name": "Lucy", "w": 5, "l": 3, "rating": 55.0}]
	var r: Dictionary = RankLine.after(before, after, "Lucy", MIN_WINS)
	_check(int(r["was"]) == 2, "was 2nd before the loss")
	_check(int(r["now"]) == 3, "now 3rd after the loss")
	_check(int(r["moved"]) == -1, "moved down 1 (was - now = 2 - 3 = -1)")
	_check(str(r["words"]).find("own") >= 0, "words say down: '%s'" % str(r["words"]))


## Unranked with 0, 1, 3 wins gives the right need.
func _unranked_need() -> void:
	# 0 wins: need 4
	var rows0: Array = [{"name": "Lucy", "w": 0, "l": 0, "rating": 0.0}]
	var r0: Dictionary = RankLine.after(rows0, rows0, "Lucy", MIN_WINS)
	_check(int(r0["need"]) == 4, "0 wins: need 4 (got %d)" % int(r0["need"]))
	# 1 win: need 3
	var rows1: Array = [{"name": "Lucy", "w": 1, "l": 0, "rating": 0.0}]
	var r1: Dictionary = RankLine.after(rows1, rows1, "Lucy", MIN_WINS)
	_check(int(r1["need"]) == 3, "1 win: need 3 (got %d)" % int(r1["need"]))
	# 3 wins: need 1
	var rows3: Array = [{"name": "Lucy", "w": 3, "l": 1, "rating": 0.0}]
	var r3: Dictionary = RankLine.after(rows3, rows3, "Lucy", MIN_WINS)
	_check(int(r3["need"]) == 1, "3 wins: need 1 (got %d)" % int(r3["need"]))


## A rival below her who wins does not move her.
func _rival_below_does_not_move() -> void:
	var before: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 5, "l": 2, "rating": 60.0},
		{"name": "Beth", "w": 4, "l": 3, "rating": 55.0}]
	# Beth wins but still below Lucy (Beth 5-3 net 2, Lucy 5-2 net 3)
	var after: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 5, "l": 2, "rating": 60.0},
		{"name": "Beth", "w": 5, "l": 3, "rating": 55.0}]
	var r: Dictionary = RankLine.after(before, after, "Lucy", MIN_WINS)
	_check(int(r["was"]) == 2 and int(r["now"]) == 2, "Lucy stays 2nd when rival below wins")
	_check(int(r["moved"]) == 0, "moved is 0")


## Two rows equal on net wins and wins split on rating.
func _equal_net_equal_wins_split_rating() -> void:
	var rows: Array = [
		{"name": "Lucy", "w": 5, "l": 2, "rating": 55.0},
		{"name": "Beth", "w": 5, "l": 2, "rating": 60.0}]
	# Same net (3), same wins (5), rating decides: Beth 60 > Lucy 55, so Beth is 1st.
	var r: Dictionary = RankLine.after(rows, rows, "Lucy", MIN_WINS)
	_check(int(r["now"]) == 2, "Lucy is 2nd (lower rating)")
	var r2: Dictionary = RankLine.after(rows, rows, "Beth", MIN_WINS)
	_check(int(r2["now"]) == 1, "Beth is 1st (higher rating)")


## The words contain no digits other than the ranks and counts.
func _words_no_extra_digits() -> void:
	var before: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 5, "l": 2, "rating": 60.0}]
	var after: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 6, "l": 2, "rating": 65.0}]
	var r: Dictionary = RankLine.after(before, after, "Lucy", MIN_WINS)
	var words: String = str(r["words"])
	# Extract all digits from words
	var digits_only: String = ""
	for i in words.length():
		var ch: String = words.substr(i, 1)
		if ch >= "0" and ch <= "9":
			digits_only += ch
	# The only numbers should be ranks (1, 2) and maybe counts. No ratings, no other numbers.
	_check(digits_only.length() <= 6, "words have few digits: '%s' -> '%s'" % [words, digits_only])


## Determinism: same input, same output.
func _determinism() -> void:
	var before: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 5, "l": 2, "rating": 60.0},
		{"name": "Beth", "w": 4, "l": 3, "rating": 55.0}]
	var after: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 6, "l": 2, "rating": 65.0},
		{"name": "Beth", "w": 4, "l": 3, "rating": 55.0}]
	var r1: Dictionary = RankLine.after(before, after, "Lucy", MIN_WINS)
	var r2: Dictionary = RankLine.after(before, after, "Lucy", MIN_WINS)
	_check(r1 == r2, "same input gives same output")


## Still ranked, same position.
func _still_ranked_same() -> void:
	var rows: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 5, "l": 2, "rating": 60.0},
		{"name": "Beth", "w": 4, "l": 3, "rating": 55.0}]
	var r: Dictionary = RankLine.after(rows, rows, "Lucy", MIN_WINS)
	_check(int(r["was"]) == 2 and int(r["now"]) == 2, "still 2nd")
	_check(int(r["moved"]) == 0, "moved is 0")
	_check(str(r["words"]).find("till") >= 0, "words say still: '%s'" % str(r["words"]))


## Enter from unranked: she wasn't ranked before (3 wins), she's ranked after (4 wins).
func _enter_from_unranked() -> void:
	var before: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Beth", "w": 6, "l": 2, "rating": 65.0},
		{"name": "Lucy", "w": 3, "l": 1, "rating": 50.0}]
	var after: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Beth", "w": 6, "l": 2, "rating": 65.0},
		{"name": "Lucy", "w": 4, "l": 1, "rating": 55.0}]
	var r: Dictionary = RankLine.after(before, after, "Lucy", MIN_WINS)
	_check(int(r["was"]) == 0, "was unranked")
	_check(int(r["now"]) == 3, "now 3rd")
	_check(bool(r["entered"]), "entered")


## Leave ranked: she was ranked before, not ranked after (fell below min_wins or went pro).
func _leave_ranked() -> void:
	var before: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 4, "l": 3, "rating": 50.0},
		{"name": "Beth", "w": 4, "l": 4, "rating": 45.0}]
	# Lucy is no longer in the after table (went pro or dropped out)
	var after: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Beth", "w": 4, "l": 4, "rating": 45.0}]
	var r: Dictionary = RankLine.after(before, after, "Lucy", MIN_WINS)
	_check(int(r["was"]) == 2, "was 2nd")
	_check(int(r["now"]) == 0, "now unranked")
	_check(bool(r["left"]), "left the rankings")


## before() words: simple position or unranked message.
func _before_words() -> void:
	var rows: Array = [
		{"name": "Alice", "w": 7, "l": 1, "rating": 70.0},
		{"name": "Lucy", "w": 5, "l": 2, "rating": 60.0},
		{"name": "Beth", "w": 4, "l": 3, "rating": 55.0}]
	var b: Dictionary = RankLine.before(rows, "Lucy", MIN_WINS)
	_check(int(b["now"]) == 2, "before: Lucy is 2nd")
	_check(str(b["words"]).find("2") >= 0, "before words mention rank: '%s'" % str(b["words"]))
	var b2: Dictionary = RankLine.before(rows, "Nobody", MIN_WINS)
	_check(int(b2["now"]) == 0, "before: Nobody is unranked")
	_check(int(b2["need"]) > 0 or str(b2["words"]).find("nranked") >= 0,
		"before: unranked message or need: '%s'" % str(b2["words"]))
