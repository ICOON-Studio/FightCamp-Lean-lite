extends SceneTree
## MODETELLS1 the opponent's mode as a tell: share bands, tape order, free mode. Pure rule module + its test.

const MT := preload("res://scripts/rules/ModeTells.gd")

var _fails := 0


func _initialize() -> void:
	# band: edges and the three labels.
	_check(MT.band(0, 0) == "", "band(0,0) = empty (no films)")
	_check(MT.band(4, 0) == "", "band(4,0) = empty (never shown)")
	_check(MT.band(-1, 2) == "", "band(-1,2) = empty (negative films)")
	_check(MT.band(4, -1) == "", "band(4,-1) = empty (negative shown)")
	_check(MT.band(4, 3) == "often", "band(4,3) = often (3/4 = 0.75)")
	_check(MT.band(4, 4) == "often", "band(4,4) = often (4/4 = 1.0)")
	_check(MT.band(3, 3) == "often", "band(3,3) = often (3/3 = 1.0, exactly 3 films)")
	_check(MT.band(3, 2) == "some", "band(3,2) = some (2/3 = 0.67 < 0.75)")
	_check(MT.band(2, 2) == "some", "band(2,2) = some (capped: under 3 films the most is some)")
	_check(MT.band(1, 1) == "some", "band(1,1) = some (one film, one show)")
	_check(MT.band(6, 1) == "rare", "band(6,1) = rare (1/6 = 0.17 < 1/3)")
	_check(MT.band(3, 1) == "some", "band(3,1) = some (exactly 1/3)")
	_check(MT.band(5, 1) == "rare", "band(5,1) = rare (1/5 = 0.2 < 1/3)")
	_check(MT.band(2, 5) == MT.band(2, 2), "band(2,5) clamps to band(2,2) (shown > films)")

	# free_mode: every style the table knows, plus one it does not.
	_check(MT.free_mode("Pressure fighter") == "press", "free_mode(Pressure fighter) = press")
	_check(MT.free_mode("Out-boxer") == "range", "free_mode(Out-boxer) = range")
	_check(MT.free_mode("Counter-puncher") == "counter", "free_mode(Counter-puncher) = counter")
	_check(MT.free_mode("Volume puncher") == "press", "free_mode(Volume puncher) = press")
	_check(MT.free_mode("Boxer-puncher") == "", "free_mode(Boxer-puncher) = empty (no free mode)")
	_check(MT.free_mode("Swarmer") == "", "free_mode(unknown style) = empty")

	# tape_order: Pressure fighter with shown counter > range, one habit.
	var order1 := MT.tape_order("Pressure fighter", {"counter": 2, "range": 1}, 4, ["drops_right_after_jab"])
	var want1 := ["weapon", "mode:counter", "habit:drops_right_after_jab", "mode:range", "weakness"]
	_check(order1 == want1, "tape_order Pressure fighter {counter:2, range:1} habits=[drops_right_after_jab] = %s" % str(want1))

	# "press" never appears for a Pressure fighter (it is the free mode).
	var has_press := false
	for id in order1:
		if str(id) == "mode:press":
			has_press = true
	_check(not has_press, "press never appears for a Pressure fighter (free mode excluded)")

	# tape_order: Boxer-puncher with {} (all ties), no habits.
	var order2 := MT.tape_order("Boxer-puncher", {}, 0, [])
	var want2 := ["weapon", "mode:press", "mode:range", "weakness"]
	_check(order2 == want2, "tape_order Boxer-puncher {} habits=[] = %s (ties broken by MODES order)" % str(want2))

	# tape_order: habits go between the two mode ids.
	var order3 := MT.tape_order("Out-boxer", {"press": 3, "counter": 1}, 5, ["fades_late", "lunges_with_jab"])
	_check(str(order3[0]) == "weapon", "tape_order starts with weapon")
	_check(str(order3[1]) == "mode:press", "tape_order second = top unfree mode (press for Out-boxer)")
	_check(str(order3[2]) == "habit:fades_late" and str(order3[3]) == "habit:lunges_with_jab", "habits in given order between the two modes")
	_check(str(order3[4]) == "mode:counter", "tape_order fifth = second unfree mode (counter)")
	_check(str(order3[5]) == "weakness", "tape_order ends with weakness")
	_check(order3.size() == 6, "tape_order has exactly 6 entries when 2 habits (got %d)" % order3.size())

	# Constants.
	_check(MT.OFTEN_FILMS == 3, "OFTEN_FILMS = 3")
	_check(is_equal_approx(MT.OFTEN_SHARE, 0.75), "OFTEN_SHARE = 0.75")
	_check(is_equal_approx(MT.SOME_SHARE, 1.0 / 3.0), "SOME_SHARE = 1/3")
	_check(MT.MODES == ["press", "range", "counter", "loadup", "tiring", "hurt"], "MODES = the six ids")

	_end()


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print(("ok   " if ok else "FAIL ") + what)


func _end() -> void:
	print("MODE_TELLS %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)
