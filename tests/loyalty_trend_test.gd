extends SceneTree
## S519 club week v11 3.6: loyalty's 4-week trend beside the band word (Loyalty.trend): the log's moves in the last 28
## days summed; +3 or more rising, -3 or less falling, else steady. Two different boxers (one short twice, one with a
## sponsorship and a kept promise). Prints LOYALTY_TREND failures=N.

const Loyalty := preload("res://scripts/rules/Loyalty.gd")

var _fails := 0


func _initialize() -> void:
	var a := {"id": "a", "loyalty": 55, "known": 4}
	_check(str(Loyalty.trend(a, 30)["word"]) == "steady", "no moves: steady")
	Loyalty.apply(a, "short", 10)
	Loyalty.apply(a, "short", 14)
	var t := Loyalty.trend(a, 20)
	_check(str(t["word"]) == "falling" and int(t["n"]) < 0 and str(t["arrow"]) != "", "two short weeks: falling %s" % t)
	_check(str(Loyalty.trend(a, 60)["word"]) == "steady", "five weeks later the shorts are out of the window")
	var b := {"id": "b", "loyalty": 48, "known": 4}
	b["loyalty_log"] = [{"d": 3, "n": 5, "why": "sponsor_given", "v": 53}, {"d": 9, "n": 2, "why": "full_week", "v": 55}]
	var tb := Loyalty.trend(b, 12)
	_check(str(tb["word"]) == "rising" and int(tb["n"]) == 7, "a sponsorship and a full week: rising +7 %s" % tb)
	_check(str(Loyalty.trend(b, 1)["word"]) == "steady", "before any move: steady")
	print("LOYALTY_TREND failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
