extends SceneTree
## THE COACH'S READ (S531; S533 P4PBUILD1 stage 3): a booking block first, the strongest checked gain and cost, how much is
## known (1 to 3), the read's record, and Accept / Pass / Later each with its price. Never "camp hard" into a short rest or
## a missed weight; never a ladder place the table's forecast does not give; never an invented weakness.

const CoachRead := preload("res://scripts/rules/CoachRead.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _price(r: Dictionary, id: String) -> String:
	for ch in r["choices"]:
		if str(ch["id"]) == id:
			return str(ch["price"])
	return ""


func _initialize() -> void:
	var base := {"gap": 1, "rest": 40, "coach": true, "days_out": 12, "booked_morale": 5, "pass_price": -3, "idle_weeks": 2, "idle_at": 4, "idle_price": -3,
		"later_days": 26, "later_rest": 14, "lo": 0.45, "hi": 0.62, "game_known": true, "game_place": "mid range", "answer": "step back", "answer_ready": true}
	var even := CoachRead.read(base)
	_check(even["verdict"] == "Take it" and even["tone"] == "go" and even["pick"] == "accept" and str(even["gain"]).contains("step back ready"),
		"an even, rested bout with a ready answer: take it (%s)" % str(even["gain"]))
	_check(even["cost"] == CoachRead.NO_COST, "nothing against it: 'No confirmed cost', no filler")
	var unsafe := CoachRead.read(base.merged({"unsafe": true}, true))
	_check(unsafe["verdict"] == "Pass this one" and unsafe["tone"] == "stop" and unsafe["pick"] == "pass" and str(unsafe["cost"]).contains("not safe")
		and _price(unsafe, "accept").contains("not allowed") and CoachRead.read(base.merged({"unsafe": true, "rank_now": 6, "rank_win": 4}, true))["gain"] == CoachRead.NO_GAIN, "unsafe: the block comes first, Accept is not offered as a pick")
	var weaker := CoachRead.read(base.merged({"gap": -9}, true))
	_check(weaker["verdict"] == "Too soon" and weaker["pick"] == "pass" and str(weaker["cost"]).contains("weaker"), "a big gap against: too soon")
	var quick := CoachRead.read(base.merged({"gap": 0, "rest": 10}, true))
	_check(quick["verdict"] == "Look for a later date" and quick["pick"] == "later" and str(quick["cost"]).contains("10 days") and not str(quick["verdict"]).contains("camp"),
		"ten days' rest: look for a later date, never 'camp hard' (%s)" % quick["cost"])
	var quick_stuck := CoachRead.read(base.merged({"gap": 0, "rest": 10, "later_days": -1}, true))
	_check(quick_stuck["verdict"] == "Take it with care" and quick_stuck["pick"] == "accept" and _price(quick_stuck, "later").contains("no later show"),
		"short rest and no later show to ask for: take it with care, and Later says there is none")
	var cut := CoachRead.read(base.merged({"over": 2.6}, true))
	_check(cut["pick"] == "later" and cut["tone"] == "care" and str(cut["cost"]).contains("2.6 kg"), "2.6 kg over: a later date, the kilos named")
	var cut_stuck := CoachRead.read(base.merged({"over": 2.6, "later_days": -1}, true))
	_check(cut_stuck["pick"] == "pass", "a missed weight is never recommended: with no later date the pick is Pass")
	var easy := CoachRead.read(base.merged({"gap": 9}, true))
	_check(easy["verdict"] == "An easy night" and str(easy["cost"]).contains("learn"), "a mismatch your way: an easy night, little to learn")
	var step := CoachRead.read(base.merged({"gap": -5}, true))
	_check(step["tone"] == "care" and step["pick"] == "accept" and str(step["cost"]).contains("risk"), "a legal step up: taken knowing the risk")
	var rank := CoachRead.read(base.merged({"rank_now": 6, "rank_win": 4}, true))
	_check(str(rank["gain"]).contains("place 4") and str(rank["gain"]).contains("from 6"), "the table's own forecast gives a place: that is the gain (%s)" % rank["gain"])
	var no_rank := CoachRead.read(base.merged({"rank_now": 6, "rank_win": 6, "answer": "", "answer_ready": false}, true))
	_check(not str(no_rank["gain"]).contains("place") and str(no_rank["cost"]).contains("no line"), "a higher name with no place gained promises none; a known game with no plan line is the cost")
	var blunt := CoachRead.read(base.merged({"answer_ready": false}, true))
	_check(str(blunt["cost"]).contains("not sharp enough"), "a plan line that cannot come off yet is a cost, not a gain")
	var goal := CoachRead.read(base.merged({"goal_needs_bout": true, "goal_days": 9, "answer": "", "game_known": false}, true))
	_check(str(goal["gain"]).contains("9 days left") and _price(goal, "accept").contains("goal's bout is booked") and _price(goal, "pass").contains("9 days left"),
		"the goal's real deadline is the gain, and both answers carry it")
	var blind := CoachRead.read(base.merged({"game_known": false}, true))
	_check(int(blind["sure"]) == 1 and str(blind["sure_words"]).contains("not known") and not str(blind["gain"]).contains("plan"), "an unknown game: 1 of 3, and no plan claim is made")
	_check(int(CoachRead.read(base.merged({"lo": 0.2, "hi": 0.6}, true))["sure"]) == 1 and int(even["sure"]) == 3
		and int(CoachRead.read(base.merged({"lo": 0.4, "hi": 0.65}, true))["sure"]) == 2, "the marks follow what is known: wide range 1, some range 2, narrow 3")
	_check(_price(even, "accept").contains("12 days") and _price(even, "accept").contains("morale +5") and _price(even, "accept").contains("no-bout count restarts"),
		"Accept is priced: %s" % _price(even, "accept"))
	_check(_price(even, "pass").contains("loyalty -3") and _price(even, "pass").contains("week 3 of 4"), "Pass is priced: %s" % _price(even, "pass"))
	_check(_price(CoachRead.read(base.merged({"duck": true}, true)), "pass").contains("duck"), "a pass that counts as a duck says so")
	_check(_price(even, "later").contains("26 days") and _price(even, "later").contains("14 more days of rest") and _price(even, "later").contains("may say no"),
		"Later is priced: %s" % _price(even, "later"))
	var picks := 0
	for ch in quick["choices"]:
		picks += int(bool(ch["pick"]))
	_check(picks == 1 and (quick["choices"] as Array).size() == 3, "three answers, one pick")
	_check(even["record"] == "" and CoachRead.read(base.merged({"reads_right": 7, "reads_of": 10}, true))["record"] == "Read right 7 of the last 10"
		and CoachRead.read(base.merged({"reads_right": 2, "reads_of": 2}, true))["record"] == "", "the record shows from 3 resolved reads, with its denominator")
	var guess := CoachRead.read(base.merged({"coach": false}, true))
	_check(bool(guess["guess"]) and CoachRead.line(guess).begins_with("Your estimate: ") and guess["gain"] == even["gain"], "no coach: the same evidence, called your estimate")
	var ln := CoachRead.line(quick, "Reid")
	_check(ln.begins_with("Coach: \"Look for a later date.\"") and ln.contains("Gain: ") and ln.contains("Cost: "), "the line: coach, verdict, gain, cost (%s)" % ln)
	for r in [quick, guess, weaker, easy, rank, unsafe, cut]:
		var t := CoachRead.line(r, "Reid") + " " + str(r["sure_words"]) + " " + _price(r, "accept") + " " + _price(r, "pass") + " " + _price(r, "later")
		_check(not t.contains("Reid") and not (" " + t.to_lower() + " ").contains(" her ") and not (" " + t.to_lower()).contains(" she "), "no name or she/her in the read (%s)" % t.left(60))
	var pro := CoachRead.pro_read({"mid": 0.5, "lo": 0.3, "hi": 0.7, "scouted": false, "stop": 0.12, "takes": "Takes #4, +1 fan"})
	_check(pro["verdict"] == "A close one" and str(pro["gain"]).contains("takes #4") and str(pro["cost"]).contains("12%") and int(pro["sure"]) == 1,
		"a pro row: its own stakes, and 1 of 3 until scouted")
	_check(int(CoachRead.pro_read({"mid": 0.7, "lo": 0.62, "hi": 0.78, "scouted": true})["sure"]) == 3 and CoachRead.pro_read({"mid": 0.2})["tone"] == "stop" and str(CoachRead.pro_read({"mid": 0.36})["cost"]).contains("36%"), "scouted and narrow: 3 of 3; a hard ask is red")
	print("COACH_READ failures=%d" % failures)
	quit(0 if failures == 0 else 1)
