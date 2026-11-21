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
	# S533 the corner's eye: the plan's line and what became of it, from the record; who is pinned; no invented walk-down.
	var m4 := RingMap.plan_mark(exs[4])
	_check(str(m4.get("dir")) == "side" and str(m4.get("state")) == "worked", "an old exchange: a thrown pivot that won reads side / worked (%s)" % str(m4))
	_check(RingMap.plan_mark(_ex(9, "mid", false, [0, 1], "step_back", false)).is_empty(), "an old exchange with an instinct move claims no missed plan")
	var held := _ex(9, "mid", false, [0, 1], "1-2", false).merged({"want": "step_back", "line": "held", "held": true})
	_check(str(RingMap.plan_mark(held).get("state")) == "held" and str(RingMap.plan_mark(held).get("name")) == str(RingMap.plan_mark(_ex(0, "mid", true, [1, 0], "step_back", true)).get("name")),
		"a held step reads held, and names the line the plan wanted, not the punch thrown instead")
	var unready := _ex(9, "own_ropes", false, [0, 2], "tie_up", false).merged({"want": "pivot_out", "line": "not_ready"})
	_check(str(RingMap.plan_mark(unready).get("state")) == "not_ready" and not RingMap.fired(unready), "a line that did not get off reads not ready")
	_check(str(RingMap.plan_mark(_ex(9, "mid", false, [0, 1], "step_back", true).merged({"want": "step_back", "line": "lost"})).get("state")) == "lost", "thrown and lost reads lost, not held")
	var punch := RingMap.plan_mark(_ex(9, "long", true, [2, 0], "1-2", true).merged({"want": "1-2", "line": "worked"}))
	_check(str(punch.get("dir", "x")) == "" and str(punch.get("state")) == "worked", "a punch line is said, with no arrow")
	_check(RingMap.plan_mark(_ex(9, "long", true, [2, 0], "1-2", false).merged({"want": "", "line": "none"})).is_empty(), "no line in the plan here: no mark")
	_check(str(RingMap.next_mark({"at": "own_ropes", "want": "pivot_out"}).get("state")) == "faint" and RingMap.next_mark({"at": "mid", "want": ""}).is_empty(),
		"the next opening's line is faint; none when the plan has nothing there")
	# Only a step that was taken turns the map.
	var base := [_ex(0, "mid", true, [1, 0]), _ex(1, "mid", true, [1, 0], "pivot_out", false).merged({"want": "pivot_out", "line": "not_ready"})]
	var took := [_ex(0, "mid", true, [1, 0]), _ex(1, "mid", true, [1, 0], "pivot_out", true).merged({"want": "pivot_out", "line": "worked"})]
	var plain := [_ex(0, "mid", true, [1, 0]), _ex(1, "mid", true, [1, 0])]
	_check(is_equal_approx(RingMap.angle_at(base, 1), RingMap.angle_at(plain, 1)) and not is_equal_approx(RingMap.angle_at(took, 1), RingMap.angle_at(plain, 1)),
		"an unfired pivot does not turn the map; a taken one does")
	# The open ring claims no walk-down: winning in the open does not move the pair toward a rope.
	var wins: Array = []
	for k in 9:
		wins.append(_ex(k, "mid", true, [2, 0]))
	var w8 := RingMap.frame(wins, 8)
	_check((((w8["a"] as Vector2) + (w8["b"] as Vector2)) * 0.5).length() < 0.01, "nine won exchanges in the open: the pair is still round the middle")
	_check(RingMap.pinned(exs.slice(0, 4)) == 0 and RingMap.pinned(exs.slice(0, 6)) == 1 and RingMap.pinned(exs.slice(0, 7)) == 1 and RingMap.pinned(exs.slice(0, 3)) == -1
		and RingMap.pinned([]) == -1, "pinned: your boxer on the own ropes, the opponent on the ropes or in a corner, nobody in the open")
	_check(RingMap.pinned([_ex(0, "mid", true, [1, 0]).merged({"pinned": true})]) == 0, "the duel's pin counts as pinned")
	# Ghosts: the last two settled rounds' attempted lines, by round; old rounds give none.
	var r1 := {"n": 1, "exchanges": [took[1], took[1].duplicate(), unready, _ex(3, "mid", false, [0, 1], "step_back", true).merged({"want": "step_back", "line": "lost"})]}
	var r2 := {"n": 2, "exchanges": [held]}
	var r3 := {"n": 3, "exchanges": [took[1]]}
	var gh := RingMap.ghosts([r1, r2, r3])
	_check(gh.size() == 1 and int(gh[0]["n"]) == 3, "ghosts keep the last two rounds, and a round with nothing attempted gives no row (%s)" % str(gh))
	var gh2 := RingMap.ghosts([r1])
	_check(int(gh2[0]["rows"][0]["worked"]) == 2 and int(gh2[0]["rows"][1]["lost"]) == 1 and gh2[0]["rows"].size() == 2, "a ghost row counts each attempted line: worked 2, lost 1; held and not ready are not attempts")
	_check(RingMap.ghosts([{"n": 1, "exchanges": exs}]).is_empty(), "an old round with no recorded lines has no ghost")
	_check(RingMap.LEGEND.size() == 5, "the legend names the five states")
	print("RING_MAP failures=%d" % failures)
	quit(0 if failures == 0 else 1)
