extends SceneTree
## WeekOpp (S360, Q-S294-90): the opponent's goal line opens amber on the coach's phase weeks, one or two edits turn it
## green, a camp week records its preparation, and the edge counts only in exchanges on the opponent's own game.
## Population: every opponent game the styles produce (one opponent per main game, Exchanges.STYLE_MODES; no style loads up first) x every phase x every focus
## the coach's week can be written for (WeekPhase.FOCUS).

const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const WeekCoach := preload("res://scripts/rules/WeekCoach.gd")

var _fails := 0


func _initialize() -> void:
	var opps := {}   # game -> an opponent of that style
	for style in Exchanges.STYLE_MODES:
		var o := {"first": "Maria", "name": "Maria Ortega", "style": str(style)}
		var g := OppFile.main_game(o)
		if WeekOpp.NEED.has(g) and not opps.has(g):
			opps[g] = o
	_check(opps.size() >= 3, "population: an opponent for each game the styles produce (%s)" % [opps.keys()])
	var amber := 0
	var fails_before := _fails
	var total := 0
	var green: Array = []
	for g in opps:
		for p in WeekPhase.WEEKS:
			for focus in WeekPhase.FOCUS:
				var days := WeekPhase.week(str(p), str(focus))
				var ln := WeekOpp.line(opps[g], days, str(p))
				total += 1
				if bool(ln["ok"]):
					green.append("%s/%s/%s" % [g, p, focus])
					continue
				amber += 1
				_check(int(ln["short"]) <= 2, "1-2 edits fix %s/%s/%s (%d short)" % [g, p, focus, ln["short"]], true)
				var fixed := days.duplicate(true)
				var need := int(ln["short"])
				for i in 7:
					if need > 0 and str(fixed[i][0]) != str(ln["session"]) and str(fixed[i][0]) != str(WeekPhase.FOCUS.get(focus, "")):
						fixed[i] = [str(ln["session"]), "normal"]
						need -= 1
				_check(bool(WeekOpp.line(opps[g], fixed, str(p))["ok"]), "the edits turn %s/%s/%s green" % [g, p, focus], true)
	print("  amber on the coach's week: %d of %d; green: %s" % [amber, total, green])
	# Green only where the coach's week already fits: the camp's focus is the session the opponent asks for, or fight week's
	# shadow morning against a counter-puncher.
	_check(float(amber) / float(total) >= 0.8, "test 1: the coach's week misses the opponent at least 8 times in 10 (%d of %d)" % [amber, total])
	_check(_fails == fails_before, "test 2: every amber line is fixed by 1-2 edits")
	_check(WeekOpp.line({}, WeekPhase.week("base", "power"), "base").is_empty(), "test 3: no opponent, no line")

	# Preparation: two camp weeks, one met; the edge only on her game.
	var o: Dictionary = opps["press"]
	var bout := {"opp": o}
	WeekOpp.record(bout, WeekPhase.week("build", "power"), "build")
	var prepared := WeekPhase.week("build", "power")
	prepared[3] = ["slip_rope", "light"]
	prepared[5] = ["slip_rope", "normal"]
	WeekOpp.record(bout, prepared, "build")
	_check(int(bout["prep"]["weeks"]) == 2 and int(bout["prep"]["met"]) == 1, "test 4: two camp weeks, one prepared (%s)" % [bout["prep"]])
	_check(is_equal_approx(WeekOpp.edge(bout, "press"), WeekOpp.EDGE * 0.5), "test 4: half a camp of preparation = half the edge on her game")
	_check(WeekOpp.edge(bout, "range") == 0.0 and WeekOpp.edge({"opp": o}, "press") == 0.0, "test 4: no edge off her game, none unprepared")

	# The coach hands the opponent to the player.
	var ln2 := WeekOpp.line(o, WeekPhase.week("build", "power"), "build")
	var said := WeekCoach.line(WeekPhase.week("build", "power"), {"days": []}, [ln2], "hold")
	_check(said.contains("your call") and not said.contains("training morning"), "test 5: the coach says the opponent is your call (%s)" % said)
	print("WEEK_OPP %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String, quiet := false) -> void:
	if not quiet or not ok:
		print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
