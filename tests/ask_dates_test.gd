extends SceneTree
## ASKDATES1: AskDates tests. Two shows side by side, what each date leaves time for, why a card is missing.
## Pure rule module: no game state, no screen. Every number read from the game's constants.
##   godot --headless --audio-driver Dummy --path . --script res://tests/ask_dates_test.gd

const AskDates := preload("res://scripts/rules/AskDates.gd")
const AskBout := preload("res://scripts/rules/AskBout.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const Region := preload("res://scripts/state/Region.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const SRC := "res://scripts/rules/AskDates.gd"

var failures := 0
var MIN_WINS: int = Region.RANK_MIN_WINS
var FMT := Callable(Clock, "fmt")


func _initialize() -> void:
	_check_shows_skip_short_lead()
	_check_shows_held_night()
	_check_shows_count()
	_check_prep_6()
	_check_prep_7()
	_check_prep_8()
	_check_prep_14()
	_check_prep_21()
	_check_prep_1()
	_check_absent_unranked()
	_check_absent_ranked_nobody_above()
	_check_absent_below_min_wins()
	_check_trade_win()
	_check_trade_loss()
	_check_trade_stopped()
	_check_wait_words()
	# Mutants: [what, old line, new line, the check function that must go red].
	var mutants := [
		["prep week_before threshold broken",
			"var week_before := away >= FightWeek.SPAR_WEEK_BEFORE_DAYS",
			"var week_before := away >= 999",
			"_check_prep_8"],
		["holder dropped",
			"return str((t as Dictionary).get(\"name\", \"\"))",
			"return \"\"",
			"_check_shows_held_night"],
	]
	for mu in mutants:
		var s := _mutant(str(mu[1]), str(mu[2]))
		if s == null:
			_fail("mutant '%s': the line to change is not in AskDates.gd (the test is stale)" % mu[0])
			continue
		var bad := _run_check(str(mu[3]), s)
		if bad:
			print("  mutant red: %s (%s)" % [mu[0], mu[3]])
		else:
			_fail("mutant '%s' stayed GREEN under %s" % [mu[0], mu[3]])
	print("ASK_DATES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _fail(what: String) -> void:
	failures += 1
	print("  FAIL: " + what)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fail(what)


func _mutant(old: String, new: String) -> GDScript:
	var src := FileAccess.get_file_as_string(SRC)
	if not src.contains(old):
		return null
	var g := GDScript.new()
	g.source_code = src.replace(old, new)
	if g.reload() != OK:
		return null
	return g


## Run a named check function on a mutant script; returns true if the check found failures.
func _run_check(check_name: String, s: GDScript) -> bool:
	var bad: Array = []
	match check_name:
		"_check_prep_8":
			bad = _mut_check_prep_8(s)
		"_check_shows_held_night":
			bad = _mut_check_shows_held_night(s)
	return not bad.is_empty()


## Mutant version of prep(8) check: week_before must be true at 8 days.
func _mut_check_prep_8(s: GDScript) -> Array:
	var p: Dictionary = s.call("prep", 8)
	if not bool(p["week_before"]):
		return ["mutant prep(8).week_before is false, want true"]
	return []


## Mutant version of held night check: holder must be "Lucy".
func _mut_check_shows_held_night(s: GDScript) -> Array:
	var shows: Array = s.call("shows", 0, [17, 31], [{"name": "Lucy", "day": 17}], FMT, 2)
	if shows.is_empty():
		return ["mutant shows() returned empty"]
	if str(shows[0]["holder"]) != "Lucy":
		return ["mutant holder '%s', want 'Lucy'" % shows[0]["holder"]]
	return []


## Shows at day 0 with shows every 14 days from day 3: the first show is day 17 (day 3 is under CAMP_MIN_DAYS).
func _check_shows_skip_short_lead() -> void:
	var show_days := [3, 17, 31, 45]
	var shows: Array = AskDates.shows(0, show_days, [], FMT, 2)
	_check(shows.size() == 2, "shows() returned %d, want 2" % shows.size())
	if shows.size() >= 1:
		_check(int(shows[0]["day"]) == 17, "first show day %d, want 17 (day 3 is under CAMP_MIN_DAYS %d)" % [
			int(shows[0]["day"]), BoutRules.CAMP_MIN_DAYS])
		_check(int(shows[0]["days_away"]) == 17, "first show days_away %d, want 17" % int(shows[0]["days_away"]))
		_check(str(shows[0]["date_words"]) == Clock.fmt(17), "first show date_words '%s', want '%s'" % [
			shows[0]["date_words"], Clock.fmt(17)])
		_check(str(shows[0]["holder"]) == "", "first show holder '%s', want '' (free night)" % shows[0]["holder"])
	if shows.size() >= 2:
		_check(int(shows[1]["day"]) == 31, "second show day %d, want 31" % int(shows[1]["day"]))


## A held night lists its holder.
func _check_shows_held_night() -> void:
	var shows: Array = AskDates.shows(0, [17, 31], [{"name": "Lucy", "day": 17}], FMT, 2)
	_check(shows.size() == 2, "shows() with holder returned %d, want 2" % shows.size())
	if shows.size() >= 1:
		_check(str(shows[0]["holder"]) == "Lucy", "held night holder '%s', want 'Lucy'" % shows[0]["holder"])
	if shows.size() >= 2:
		_check(str(shows[1]["holder"]) == "", "free night holder '%s', want ''" % shows[1]["holder"])


## Shows count: ask for 3, get 3 (when available).
func _check_shows_count() -> void:
	var show_days := [17, 31, 45, 59]
	var shows: Array = AskDates.shows(0, show_days, [], FMT, 3)
	_check(shows.size() == 3, "shows(count=3) returned %d, want 3" % shows.size())


## prep(6): no fight week (6 < 7), no week before, 2 spar nights, no film evening.
func _check_prep_6() -> void:
	var p: Dictionary = AskDates.prep(6)
	_check(not bool(p["fight_week"]), "prep(6).fight_week is true, want false (6 < CAMP_MIN_DAYS %d)" % BoutRules.CAMP_MIN_DAYS)
	_check(not bool(p["week_before"]), "prep(6).week_before is true, want false")
	_check(int(p["spar_nights"]) == 2, "prep(6).spar_nights %d, want 2" % int(p["spar_nights"]))
	_check(not bool(p["film_evening"]), "prep(6).film_evening is true, want false")
	_check(str(p["camp_words"]) == AskBout.camp_words(6), "prep(6).camp_words '%s' != AskBout.camp_words(6) '%s'" % [
		p["camp_words"], AskBout.camp_words(6)])
	_check_prep_checks(p, [false, false, true, false])


## prep(7): fight week yes, no week before, 2 spar nights, film evening yes.
func _check_prep_7() -> void:
	var p: Dictionary = AskDates.prep(7)
	_check(bool(p["fight_week"]), "prep(7).fight_week is false, want true")
	_check(not bool(p["week_before"]), "prep(7).week_before is true, want false (7 < SPAR_WEEK_BEFORE_DAYS %d)" % FightWeek.SPAR_WEEK_BEFORE_DAYS)
	_check(int(p["spar_nights"]) == 2, "prep(7).spar_nights %d, want 2" % int(p["spar_nights"]))
	_check(bool(p["film_evening"]), "prep(7).film_evening is false, want true")
	_check_prep_checks(p, [true, false, true, true])


## prep(8): fight week yes, week before yes, 3 spar nights, film evening yes.
func _check_prep_8() -> void:
	var p: Dictionary = AskDates.prep(8)
	_check(bool(p["fight_week"]), "prep(8).fight_week is false, want true")
	_check(bool(p["week_before"]), "prep(8).week_before is false, want true (8 >= SPAR_WEEK_BEFORE_DAYS %d)" % FightWeek.SPAR_WEEK_BEFORE_DAYS)
	_check(int(p["spar_nights"]) == 3, "prep(8).spar_nights %d, want 3" % int(p["spar_nights"]))
	_check(bool(p["film_evening"]), "prep(8).film_evening is false, want true")
	_check_prep_checks(p, [true, true, true, true])


## prep(14): fight week yes, week before yes, 3 spar nights, film evening yes.
func _check_prep_14() -> void:
	var p: Dictionary = AskDates.prep(14)
	_check(bool(p["fight_week"]), "prep(14).fight_week is false, want true")
	_check(bool(p["week_before"]), "prep(14).week_before is false, want true")
	_check(int(p["spar_nights"]) == 3, "prep(14).spar_nights %d, want 3" % int(p["spar_nights"]))
	_check(bool(p["film_evening"]), "prep(14).film_evening is false, want true")
	_check_prep_checks(p, [true, true, true, true])


## prep(21): fight week yes, week before yes, 3 spar nights, film evening yes, camp can be set.
func _check_prep_21() -> void:
	var p: Dictionary = AskDates.prep(21)
	_check(bool(p["fight_week"]), "prep(21).fight_week is false, want true")
	_check(bool(p["week_before"]), "prep(21).week_before is false, want true")
	_check(int(p["spar_nights"]) == 3, "prep(21).spar_nights %d, want 3" % int(p["spar_nights"]))
	_check(bool(p["film_evening"]), "prep(21).film_evening is false, want true")
	_check(str(p["camp_words"]).begins_with("Camp can be set"), "prep(21).camp_words '%s' should start with 'Camp can be set'" % p["camp_words"])
	_check_prep_checks(p, [true, true, true, true])


## prep(1): no fight week, no week before, 0 spar nights, no film evening.
func _check_prep_1() -> void:
	var p: Dictionary = AskDates.prep(1)
	_check(not bool(p["fight_week"]), "prep(1).fight_week is true, want false")
	_check(not bool(p["week_before"]), "prep(1).week_before is true, want false")
	_check(int(p["spar_nights"]) == 0, "prep(1).spar_nights %d, want 0" % int(p["spar_nights"]))
	_check(not bool(p["film_evening"]), "prep(1).film_evening is true, want false")
	_check_prep_checks(p, [false, false, false, false])


## Check the checks array has the right on values.
func _check_prep_checks(p: Dictionary, want: Array) -> void:
	var checks: Array = p["checks"]
	_check(checks.size() == 4, "prep checks size %d, want 4" % checks.size())
	if checks.size() == 4:
		for i in 4:
			_check(bool(checks[i]["on"]) == bool(want[i]),
				"prep checks[%d].on is %s, want %s" % [i, checks[i]["on"], want[i]])


## Absent for an unranked 1-0 fighter: no sheet (next_in_turn is ""), no name (not on ladder).
func _check_absent_unranked() -> void:
	var f := {"name": "Novice", "w": 1, "l": 0}
	var rows := [
		{"name": "Other", "club": "X", "w": 5, "l": 3, "rating": 55.0, "style": "", "ours": false},
	]
	var abs: Array = AskDates.absent(f, rows, "", MIN_WINS)
	var kinds := _abs_kinds(abs)
	_check(kinds.has("sheet"), "absent unranked: no sheet kind")
	_check(kinds.has("name"), "absent unranked: no name kind")
	_check(not kinds.has("step_up"), "absent unranked: step_up should be present (Other is a valid step up)")
	var sheet_why := _abs_why(abs, "sheet")
	_check(sheet_why == "No name on the sheet is legal for this fighter now.",
		"absent unranked sheet why '%s'" % sheet_why)
	var name_why := _abs_why(abs, "name")
	_check(name_why == "Names open at %d wins (now 1)." % MIN_WINS,
		"absent unranked name why '%s'" % name_why)


## Absent for a ranked fighter with nobody above free: no sheet, no step_up, no name.
func _check_absent_ranked_nobody_above() -> void:
	var f := {"name": "Top", "w": 10, "l": 0}
	var rows := [
		{"name": "Top", "club": "Our Gym", "w": 10, "l": 0, "rating": 80.0, "style": "", "ours": true},
	]
	var abs: Array = AskDates.absent(f, rows, "", MIN_WINS)
	var kinds := _abs_kinds(abs)
	_check(kinds.has("sheet"), "absent ranked: no sheet kind")
	_check(kinds.has("step_up"), "absent ranked: no step_up kind")
	_check(kinds.has("name"), "absent ranked: no name kind")
	var step_why := _abs_why(abs, "step_up")
	_check(step_why == "Nobody above on the ladder is free.",
		"absent ranked step_up why '%s'" % step_why)
	var name_why := _abs_why(abs, "name")
	_check(name_why == "No other legal name up to %d places above or level." % AskBout.PICK_REACH,
		"absent ranked name why '%s'" % name_why)


## Absent for a fighter at min_wins-1: not on the ladder yet.
func _check_absent_below_min_wins() -> void:
	var f := {"name": "Almost", "w": MIN_WINS - 1, "l": 0}
	var rows: Array = []
	var abs: Array = AskDates.absent(f, rows, "", MIN_WINS)
	var kinds := _abs_kinds(abs)
	_check(kinds.has("sheet"), "absent below min: no sheet kind")
	_check(kinds.has("step_up"), "absent below min: no step_up kind")
	_check(kinds.has("name"), "absent below min: no name kind")
	var step_why := _abs_why(abs, "step_up")
	_check(step_why == "Nobody with a better record inside the novice rule.",
		"absent below min step_up why '%s'" % step_why)
	var name_why := _abs_why(abs, "name")
	_check(name_why == "Names open at %d wins (now %d)." % [MIN_WINS, MIN_WINS - 1],
		"absent below min name why '%s'" % name_why)


## Trade win: numbers equal the constants.
func _check_trade_win() -> void:
	var t: Array = AskDates.trade("win")
	_check(t.size() == 2, "trade(win) size %d, want 2" % t.size())
	if t.size() >= 2:
		_check(str(t[0]) == "+%d members" % BoutRules.WIN_MEMBERS,
			"trade(win)[0] '%s', want '+%d members'" % [t[0], BoutRules.WIN_MEMBERS])
		_check(str(t[1]) == "+%d reputation" % BoutRules.WIN_REPUTATION,
			"trade(win)[1] '%s', want '+%d reputation'" % [t[1], BoutRules.WIN_REPUTATION])


## Trade loss: numbers equal the constants.
func _check_trade_loss() -> void:
	var t: Array = AskDates.trade("loss")
	_check(t.size() == 2, "trade(loss) size %d, want 2" % t.size())
	if t.size() >= 2:
		var want_mem := "-%d member%s" % [BoutRules.LOSS_MEMBERS, "" if BoutRules.LOSS_MEMBERS == 1 else "s"]
		_check(str(t[0]) == want_mem, "trade(loss)[0] '%s', want '%s'" % [t[0], want_mem])
		_check(str(t[1]) == "-%d reputation" % BoutRules.LOSS_REPUTATION,
			"trade(loss)[1] '%s', want '-%d reputation'" % [t[1], BoutRules.LOSS_REPUTATION])


## Trade stopped: numbers equal the constants.
func _check_trade_stopped() -> void:
	var t: Array = AskDates.trade("stopped")
	_check(t.size() == 3, "trade(stopped) size %d, want 3" % t.size())
	if t.size() >= 3:
		var want_mem := "-%d member%s" % [BoutRules.STOPPED_LOSS_MEMBERS, "" if BoutRules.STOPPED_LOSS_MEMBERS == 1 else "s"]
		_check(str(t[0]) == want_mem, "trade(stopped)[0] '%s', want '%s'" % [t[0], want_mem])
		_check(str(t[1]) == "-%d reputation" % BoutRules.STOPPED_LOSS_REPUTATION,
			"trade(stopped)[1] '%s', want '-%d reputation'" % [t[1], BoutRules.STOPPED_LOSS_REPUTATION])
		var ko_days: int = int(load("res://scripts/rules/InjuryRoll.gd").KO_DAYS)
		_check(str(t[2]) == "%d days out" % ko_days,
			"trade(stopped)[2] '%s', want '%d days out'" % [t[2], ko_days])


## Wait words: reads every number from the game's constants.
func _check_wait_words() -> void:
	var w := AskDates.wait_words()
	var want := "Wait for the sheet: likely in %d to %d weeks, date unknown. A month without a fight costs %d morale." % [
		AmateurBooking.LEAD_WEEKS_MIN, AmateurBooking.LEAD_WEEKS_MAX,
		absi(int(FighterProfile.MORALE_EVENTS.get("month_no_fight", 0)))]
	_check(w == want, "wait_words() '%s', want '%s'" % [w, want])


## Helper: extract kinds from absent array.
func _abs_kinds(abs: Array) -> Array:
	var out: Array = []
	for a in abs:
		out.append(str((a as Dictionary).get("kind", "")))
	return out


## Helper: extract why for a kind from absent array.
func _abs_why(abs: Array, kind: String) -> String:
	for a in abs:
		if str((a as Dictionary).get("kind", "")) == kind:
			return str((a as Dictionary).get("why", ""))
	return ""
