extends SceneTree
## S531 TOPDOWN1: RingMap puts the boxers where the round's own cards say - range from the card, the trapped boxer's
## back on the rope, both inside the ring, lines per landed punch, a miss for a side that lost and landed nothing.

const RingMap := preload("res://scripts/rules/RingMap.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _ex(i: int, at: String, won: bool, landed: Array, arrow := "", planned := false) -> Dictionary:
	return {"i": i, "at": at, "won": won, "landed": landed, "arrow": arrow, "planned": planned}


func _inside(p: Vector2) -> bool:
	return absf(p.x) <= RingMap.HALF and absf(p.y) <= RingMap.HALF


func _initialize() -> void:
	var exs := [_ex(0, "long", true, [2, 0]), _ex(1, "mid", false, [1, 3]), _ex(2, "inside", true, [3, 2]),
		_ex(3, "own_ropes", false, [0, 3]), _ex(4, "mid", true, [2, 1], "pivot_out", true), _ex(5, "opp_ropes", true, [3, 0], "cut_off", true),
		_ex(6, "corner", true, [4, 1], "herd", true), _ex(7, "clinch", false, [0, 0]), _ex(8, "outside", false, [0, 1])]
	# Range follows the card: inside closer than mid closer than long closer than outside.
	_check(RingMap.gap("inside") < RingMap.gap("mid") and RingMap.gap("mid") < RingMap.gap("long") and RingMap.gap("long") < RingMap.gap("outside"),
		"gap grows inside < mid < long < outside")
	var all_in := true
	var gaps_ok := true
	for i in exs.size():
		var f := RingMap.frame(exs, i)
		all_in = all_in and _inside(f["a"]) and _inside(f["b"])
		var d: float = (f["a"] as Vector2).distance_to(f["b"])
		gaps_ok = gaps_ok and absf(d - float(f["gap"])) < 0.25
	_check(all_in, "both boxers stay inside the ropes on every exchange")
	_check(gaps_ok, "the drawn distance matches the card's range (within 0.25 m)")
	var lim := RingMap.HALF - RingMap.ROPE_IN
	var own := RingMap.frame(exs, 3)
	var a3: Vector2 = own["a"]
	_check(maxf(absf(a3.x), absf(a3.y)) > lim - 0.01, "on the ropes: her back is on the rope line (%.2f)" % maxf(absf(a3.x), absf(a3.y)))
	var opp := RingMap.frame(exs, 5)
	var b5: Vector2 = opp["b"]
	_check(maxf(absf(b5.x), absf(b5.y)) > lim - 0.01, "opponent on the ropes: the opponent's back is on the rope")
	var cor := RingMap.frame(exs, 6)
	var b6: Vector2 = cor["b"]
	_check(absf(b6.x) > lim - 0.01 and absf(b6.y) > lim - 0.01, "corner trap: the opponent stands in a corner")
	# Lines: one per landed punch (at most 3 a side); a miss for a side that lost and landed none.
	var l0: Array = RingMap.frame(exs, 0)["lines"]
	_check(l0.filter(func(x): return int(x["who"]) == 0 and bool(x["landed"])).size() == 2, "2 landed -> 2 solid lines for her")
	_check(l0.filter(func(x): return int(x["who"]) == 1 and not bool(x["landed"])).size() == 1, "opponent lost and landed none -> one miss")
	var l6: Array = RingMap.frame(exs, 6)["lines"]
	_check(l6.filter(func(x): return int(x["who"]) == 0).size() == RingMap.LINES_MAX, "at most %d lines a side" % RingMap.LINES_MAX)
	# The trail shows her last steps, no more than TRAIL.
	_check((RingMap.frame(exs, 8)["trail"] as Array).size() == RingMap.TRAIL and (RingMap.frame(exs, 0)["trail"] as Array).is_empty(),
		"the trail holds her last %d places" % RingMap.TRAIL)
	# The same round draws the same picture (no randomness).
	_check(RingMap.frame(exs, 4)["a"] == RingMap.frame(exs.duplicate(true), 4)["a"], "same round, same picture")
	# Ticks: a planned step names the step, otherwise the card.
	var t := RingMap.ticks(exs)
	_check(t.size() == exs.size() and str(t[4]["word"]) == "Pivot off the ropes" and str(t[0]["word"]) == "Long range",
		"ticks name the planned step, else the card (%s / %s)" % [t[4]["word"], t[0]["word"]])
	_check(RingMap.frame([], 0).is_empty() and RingMap.frame(exs, 99).is_empty(), "no exchange -> no frame")
	print("RING_MAP failures=%d" % failures)
	quit(0 if failures == 0 else 1)
