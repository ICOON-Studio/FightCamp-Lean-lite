extends SceneTree
## S531 THE COACH'S READ: the verdict follows her own state; one reason for, one against; no coach = a shorter guess.

const CoachRead := preload("res://scripts/rules/CoachRead.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	var even := CoachRead.read({"gap": 1, "rest": 40, "coach": true})
	_check(even["verdict"] == "Take it" and str(even["for"]).contains("even") and even["tone"] == "go", "an even, rested bout: take it, it teaches (%s)" % str(even))
	var unsafe := CoachRead.read({"gap": 2, "unsafe": true, "coach": true})
	_check(unsafe["verdict"] == "Too soon" and unsafe["tone"] == "stop" and str(unsafe["against"]).contains("not safe"), "unsafe: too soon")
	var weaker := CoachRead.read({"gap": -9, "coach": true})
	_check(weaker["verdict"] == "Too soon" and str(weaker["against"]).contains("weaker"), "a big gap against her: too soon")
	var quick := CoachRead.read({"gap": 0, "rest": 10, "coach": true})
	_check(quick["verdict"] == "Take it, but camp hard" and str(quick["against"]).contains("10 days"), "ten days' rest: camp hard (%s)" % quick["against"])
	var cut := CoachRead.read({"gap": 0, "rest": 40, "over": 2.6, "coach": true})
	_check(cut["tone"] == "care" and str(cut["against"]).contains("2.6 kg"), "a 2.6 kg cut: camp hard, the kilos named")
	var easy := CoachRead.read({"gap": 9, "rest": 40, "coach": true})
	_check(easy["verdict"] == "Free points" and str(easy["against"]).contains("learn"), "a mismatch her way: free points, little to learn")
	var rank := CoachRead.read({"gap": -2, "rest": 40, "her_rank": 6, "opp_rank": 3, "coach": true})
	_check(str(rank["for"]).contains("#3"), "a higher-ranked opponent: the ladder is the reason for (%s)" % rank["for"])
	var hot := CoachRead.read({"gap": 0, "hot": true, "streak_words": "On a run: 4 wins", "coach": true})
	_check(str(hot["for"]).begins_with("on a run"), "on a run: ride it")
	var guess := CoachRead.read({"gap": 0, "rest": 10, "coach": false})
	_check(bool(guess["guess"]) and str(guess["for"]) == "" and str(guess["against"]) != "", "no coach: the owner's guess keeps one reason")
	var ln := CoachRead.line(quick, "Reid")
	_check(ln.begins_with("Coach: \"Take it, but camp hard.\"") and ln.contains("For: ") and ln.contains("Against: "), "the line: coach, verdict, for, against (%s)" % ln)
	# S532 (owner S448: names only in headers): no coach's name and no she/her in the read's text.
	for r in [quick, guess, weaker, easy, rank]:
		var t := CoachRead.line(r, "Reid")
		_check(not t.contains("Reid") and not (" " + t.to_lower() + " ").contains(" her ") and not t.to_lower().contains("she"), "no name or she/her in the read (%s)" % t)
	_check(CoachRead.line(guess, "").begins_with("Your guess: "), "no coach: 'Your guess'")
	print("COACH_READ failures=%d" % failures)
	quit(0 if failures == 0 else 1)
