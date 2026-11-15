extends SceneTree
## APPROACH1 (R58): Eastside ABC approach trigger, offered cause, optional talk,
## five answers at day + 84, and button card lines.
## Run: godot --headless --audio-driver Dummy --fixed-fps 60
##      --path . --script res://tests/approach_test.gd

const Approach := preload("res://scripts/rules/Approach.gd")

var _fails: int = 0


func _initialize() -> void:
	_due()
	_offer()
	_talk()
	_answers()
	_card_line()
	var tag: String = "APPROACH PASS" if _fails == 0 else "APPROACH FAIL"
	print("%s fails=%d" % [tag, _fails])
	quit(0 if _fails == 0 else 1)


func _due() -> void:
	var base: Dictionary = {
		"loyalty": 33,
		"potential": 85,
		"rank": 0,
		"is_pro": false,
		"last_approach_day": -1,
		"day": 91,
	}
	_check(Approach.due(base), "Danny at 33 loyalty, 85 potential, never approached: due true")

	var at_limit: Dictionary = base.duplicate()
	at_limit["loyalty"] = 35
	_check(not Approach.due(at_limit), "loyalty 35 (not under 35): due false")

	var under_edge: Dictionary = base.duplicate()
	under_edge["loyalty"] = 34
	_check(Approach.due(under_edge), "loyalty 34: due true")

	var low_pot: Dictionary = base.duplicate()
	low_pot["potential"] = 79
	_check(not Approach.due(low_pot), "potential 79, rank 0, not pro: due false")

	var pot_edge: Dictionary = base.duplicate()
	pot_edge["potential"] = 80
	_check(Approach.due(pot_edge), "potential 80: due true")

	var ranked: Dictionary = base.duplicate()
	ranked["potential"] = 70
	ranked["rank"] = 4
	_check(Approach.due(ranked), "rank 4, potential 70: due true")

	var rank_six: Dictionary = base.duplicate()
	rank_six["potential"] = 70
	rank_six["rank"] = 6
	_check(not Approach.due(rank_six), "rank 6, potential 70: due false")

	var pro: Dictionary = base.duplicate()
	pro["potential"] = 60
	pro["is_pro"] = true
	_check(Approach.due(pro), "is_pro true: due true")

	var too_soon: Dictionary = base.duplicate()
	too_soon["last_approach_day"] = 20
	too_soon["day"] = 91
	_check(not Approach.due(too_soon), "71 days since last approach: due false")

	var day_103: Dictionary = base.duplicate()
	day_103["last_approach_day"] = 20
	day_103["day"] = 103
	_check(not Approach.due(day_103), "83 days since last approach: due false")

	var day_104: Dictionary = base.duplicate()
	day_104["last_approach_day"] = 20
	day_104["day"] = 104
	_check(Approach.due(day_104), "84 days since last approach: due true")


func _offer() -> void:
	var keep_log: Array = [
		{"d": 28, "n": -3, "why": "day_job"},
		{"d": 37, "n": -3, "why": "offer_passed"},
		{"d": 56, "n": -3, "why": "day_job"},
		{"d": 84, "n": -3, "why": "day_job"},
		{"d": 86, "n": -3, "why": "offer_passed"},
		{"d": 26, "n": 2, "why": "win"},
	]
	var keep_res: Dictionary = Approach.offer(keep_log, 91)
	_check(
		str(keep_res["group"]) == "keep"
		and int(keep_res["loss"]) == -9
		and str(keep_res["line"]) == "Full time: Eastside's backers pay the keep",
		"day 91 keep -9 (d 28 inside 84d) beats bout -6"
	)

	var full_log: Array = [
		{"d": 28, "n": -3, "why": "day_job"},
		{"d": 37, "n": -3, "why": "offer_passed"},
		{"d": 56, "n": -3, "why": "day_job"},
		{"d": 75, "n": -4, "why": "target_missed"},
		{"d": 84, "n": -3, "why": "day_job"},
		{"d": 86, "n": -3, "why": "offer_passed"},
		{"d": 26, "n": 2, "why": "win"},
	]
	var r91: Dictionary = Approach.offer(full_log, 91)
	_check(
		str(r91["group"]) == "bout"
		and int(r91["loss"]) == -10
		and str(r91["line"]) == "A bout on Eastside's show",
		"day 91 with target_missed (-4): bout -10 beats keep -9"
	)

	var r120: Dictionary = Approach.offer(full_log, 120)
	_check(
		str(r120["group"]) == "bout" and int(r120["loss"]) == -10,
		"day 120 drops d 28 (92d) while d 37 (83d) stays inside: keep -6, bout -10"
	)

	var r121: Dictionary = Approach.offer(full_log, 121)
	_check(
		str(r121["group"]) == "bout" and int(r121["loss"]) == -7,
		"day 121 drops d 28 and d 37 (>= 84d): keep -6, bout -7 -> bout"
	)

	var debut_res: Dictionary = Approach.offer([{"d": 80, "n": -8, "why": "decline_pro"}], 91)
	_check(
		str(debut_res["group"]) == "debut"
		and int(debut_res["loss"]) == -8
		and str(debut_res["line"]) == "Eastside's promoter signs the debut",
		"decline_pro maps to debut"
	)

	var mgr_res: Dictionary = Approach.offer([{"d": 80, "n": -5, "why": "pro_unhappy"}], 91)
	_check(
		str(mgr_res["group"]) == "manager"
		and int(mgr_res["loss"]) == -5
		and str(mgr_res["line"]) == "A manager at 15%",
		"pro_unhappy maps to manager"
	)

	var tie_res: Dictionary = Approach.offer([
		{"d": 80, "n": -4, "why": "pro_unhappy"},
		{"d": 81, "n": -4, "why": "decline_pro"},
		{"d": 82, "n": -4, "why": "no_bout"},
		{"d": 83, "n": -4, "why": "wants_sponsor"},
	], 91)
	_check(
		str(tie_res["group"]) == "keep" and int(tie_res["loss"]) == -4,
		"tie breaks by keep, bout, debut, manager"
	)

	var empty_res: Dictionary = Approach.offer([
		{"d": 80, "n": 5, "why": "win"},
		{"d": 81, "n": -3, "why": "other"},
	], 91)
	_check(
		str(empty_res["group"]) == "keep"
		and int(empty_res["loss"]) == 0
		and str(empty_res["line"]) == "Full time: Eastside's backers pay the keep",
		"no negative row in any group -> keep with loss 0"
	)


func _talk() -> void:
	var chance: float = Approach.talk_chance(34)
	_check(absf(chance - 0.504) < 0.001, "talk_chance(34) == 0.504 (got %.4f)" % chance)
	_check(
		absf(Approach.talk_chance(-10) - 0.30) < 0.0001,
		"talk_chance clamps negative coachability to 0 -> 0.30"
	)
	_check(
		absf(Approach.talk_chance(120) - 0.90) < 0.0001,
		"talk_chance clamps coachability above 100 -> 0.90"
	)

	var hit: Dictionary = Approach.talk(34, 0.50)
	_check(
		bool(hit["landed"]) and int(hit["delta"]) == 0,
		"talk(34, 0.50) landed true, delta 0"
	)

	var miss: Dictionary = Approach.talk(34, 0.51)
	_check(
		not bool(miss["landed"]) and int(miss["delta"]) == -4,
		"talk(34, 0.51) landed false, delta -4"
	)

	var edge: Dictionary = Approach.talk(34, 0.504)
	_check(
		not bool(edge["landed"]) and int(edge["delta"]) == -4,
		"talk(34, 0.504) strict < so not landed"
	)


func _answers() -> void:
	var base: Dictionary = {
		"loyalty": 33,
		"talk": "",
		"group": "keep",
		"holder": {"loyalty": 64},
		"can_book": true,
		"ticks": 3,
		"ticks_after_show": 2,
		"holder_ticks": 3,
		"day": 91,
	}
	var cols: Array = Approach.answers(base)
	_check(cols.size() == 5, "answers returns 5 columns")
	var ids: Array = []
	for item in cols:
		var col: Dictionary = item
		ids.append(str(col["id"]))
	_check(
		ids == ["match", "half", "move", "promise", "let_go"],
		"column order is match, half, move, promise, let_go"
	)

	var c_match: Dictionary = cols[0]
	var c_half: Dictionary = cols[1]
	var c_move: Dictionary = cols[2]
	var c_promise: Dictionary = cols[3]
	var c_let_go: Dictionary = cols[4]

	_check(
		bool(c_match["available"])
		and int(c_match["loyalty_end"]) == 45
		and int(c_match["cash"]) == -3000
		and int(c_match["locked_to"]) == 175
		and int(c_match["holder_end"]) == 64
		and is_equal_approx(float(c_match["train"]), 1.0)
		and is_equal_approx(float(c_match["holder_train"]), 1.0),
		"match: loyalty 45, cash -3000, locked_to 175, Lucy 64"
	)
	_check(
		bool(c_half["available"])
		and int(c_half["loyalty_end"]) == 39
		and int(c_half["holder_end"]) == 60
		and int(c_half["cash"]) == 0
		and int(c_half["locked_to"]) == 175
		and is_equal_approx(float(c_half["train"]), 0.925)
		and is_equal_approx(float(c_half["holder_train"]), 0.925),
		"half: loyalty 39 (33+6), Lucy 60, both train 0.925"
	)
	_check(
		bool(c_move["available"])
		and int(c_move["loyalty_end"]) == 45
		and int(c_move["holder_end"]) == 43
		and int(c_move["cash"]) == 0
		and is_equal_approx(float(c_move["train"]), 1.0)
		and is_equal_approx(float(c_move["holder_train"]), 0.85),
		"move: loyalty 45, Lucy 43 (64-12-9), holder_train 0.85"
	)
	_check(
		bool(c_promise["available"])
		and int(c_promise["loyalty_end"]) == 41
		and int(c_promise["cash"]) == -3500
		and int(c_promise["holder_end"]) == 64
		and int(c_promise["locked_to"]) == -1,
		"promise: loyalty 41 (33+4+10-6), cash -3500, locked_to -1"
	)
	_check(
		bool(c_let_go["available"])
		and int(c_let_go["loyalty_end"]) == -1
		and int(c_let_go["cash"]) == 0
		and int(c_let_go["holder_end"]) == 64
		and int(c_let_go["locked_to"]) == -1,
		"let_go: available, cash 0, loyalty_end -1, Lucy 64"
	)

	var landed_view: Dictionary = base.duplicate()
	landed_view["talk"] = "landed"
	var landed_cols: Array = Approach.answers(landed_view)
	var landed_half: Dictionary = landed_cols[1]
	_check(
		bool(landed_half["available"]) and int(landed_half["loyalty_end"]) == 43,
		"talk landed: half loyalty_end 43 (33+10)"
	)

	var failed_view: Dictionary = base.duplicate()
	failed_view["loyalty"] = 29
	failed_view["talk"] = "failed"
	var failed_cols: Array = Approach.answers(failed_view)
	var failed_match: Dictionary = failed_cols[0]
	var failed_half: Dictionary = failed_cols[1]
	var failed_promise: Dictionary = failed_cols[3]
	_check(
		not bool(failed_half["available"]) and str(failed_half["why_not"]) == "the talk failed",
		"talk failed: half unavailable with why_not 'the talk failed'"
	)
	_check(int(failed_promise["loyalty_end"]) == 37, "talk failed: promise 37 (29+4+10-6)")
	_check(int(failed_match["loyalty_end"]) == 41, "talk failed: match 41 (29+12)")

	var no_holder_view: Dictionary = base.duplicate()
	no_holder_view["holder"] = {}
	var nh_cols: Array = Approach.answers(no_holder_view)
	var nh_match: Dictionary = nh_cols[0]
	var nh_half: Dictionary = nh_cols[1]
	var nh_move: Dictionary = nh_cols[2]
	_check(
		not bool(nh_half["available"])
		and str(nh_half["why_not"]) == "nobody holds the stipend"
		and int(nh_half["holder_end"]) == -1
		and is_equal_approx(float(nh_half["holder_train"]), 1.0),
		"empty holder: half unavailable ('nobody holds the stipend'), holder_end -1, holder_train 1.0"
	)
	_check(
		not bool(nh_move["available"])
		and str(nh_move["why_not"]) == "nobody holds the stipend"
		and int(nh_move["holder_end"]) == -1
		and is_equal_approx(float(nh_move["holder_train"]), 1.0),
		"empty holder: move unavailable ('nobody holds the stipend'), holder_end -1, holder_train 1.0"
	)
	_check(int(nh_match["holder_end"]) == -1, "empty holder: match holder_end -1")

	var no_show_view: Dictionary = base.duplicate()
	no_show_view["can_book"] = false
	var ns_cols: Array = Approach.answers(no_show_view)
	var ns_promise: Dictionary = ns_cols[3]
	_check(
		not bool(ns_promise["available"]) and str(ns_promise["why_not"]) == "no show can be booked now",
		"can_book false: promise unavailable ('no show can be booked now')"
	)

	var bout_view: Dictionary = base.duplicate()
	bout_view["group"] = "bout"
	var bout_cols: Array = Approach.answers(bout_view)
	var bout_match: Dictionary = bout_cols[0]
	var bout_half: Dictionary = bout_cols[1]
	_check(
		bool(bout_match["available"])
		and int(bout_match["cash"]) == 0
		and int(bout_match["loyalty_end"]) == 45,
		"group bout: match available with cash 0 and loyalty_end 45"
	)
	_check(not bool(bout_half["available"]), "group bout: half unavailable")


func _card_line() -> void:
	var cols: Array = Approach.answers({
		"loyalty": 33,
		"talk": "",
		"group": "keep",
		"holder": {"loyalty": 64},
		"can_book": true,
		"ticks": 3,
		"ticks_after_show": 2,
		"holder_ticks": 3,
		"day": 91,
	})
	var want_words: Array = [
		"MATCH IT",
		"HALF EACH",
		"MOVE THE STIPEND",
		"PROMISE: OUR SHOW",
		"LET THEM GO",
	]
	for i in range(want_words.size()):
		var col: Dictionary = cols[i]
		var got: String = Approach.card_line(col)
		var want: String = str(want_words[i])
		_check(got == want, "card_line available %s == '%s'" % [str(col["id"]), want])

	var failed_cols: Array = Approach.answers({
		"loyalty": 29,
		"talk": "failed",
		"group": "keep",
		"holder": {"loyalty": 64},
		"can_book": false,
		"ticks": 3,
		"ticks_after_show": 2,
		"holder_ticks": 3,
		"day": 91,
	})
	var bad_half: Dictionary = failed_cols[1]
	var bad_promise: Dictionary = failed_cols[3]
	_check(
		Approach.card_line(bad_half) == "HALF EACH - the talk failed",
		"card_line unavailable half == 'HALF EACH - the talk failed'"
	)
	_check(
		Approach.card_line(bad_promise) == "PROMISE: OUR SHOW - no show can be booked now",
		"card_line unavailable promise == 'PROMISE: OUR SHOW - no show can be booked now'"
	)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
