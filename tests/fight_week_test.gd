extends SceneTree
## S474 FWTANK1: the amateur fight week - the TANK, the load stop and the sparring nights (scripts/rules/FightWeek.gd,
## map DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI 4.2, 4.3, 4.4). Pure rule, no game state and no screen: an amateur bout
## has no camp, the player picks ONE load stop for the fight week and places 0-2 sparring nights, and both cost the tank
## (the energy ceiling at the first bell).
##   1. the tiredness layer (1 off for each point over 50, capped at 25) and the map's four worked examples at start 75:
##      Rest up 0 off, Tick over 31, Train through 37, Train through with two late nights 47,
##   2. the choice layer is never capped, and the tank bar's parts keep their order and leave every zero part out,
##   3. round 1: Rest up's three bands (under 40 / 40-64 / 65+), Tick over's boost, Train through,
##   4. the pad units banked per stop, the tiredness after the bell, the line printed on each stop, the next-stop hover,
##   5. sparring: the three night kinds (week before / fight week / late), the lines a night readies, the unsparred fire
##      shift in rounds 1 and 2,
##   6. your assistant's default night.
## Population: none. Every number is the map's ESTIMATE until FIGHTWEEKPROBE4 runs, so the constants are pinned here too.
##   godot --headless --audio-driver Dummy --path . --script res://tests/fight_week_test.gd

const FightWeek := preload("res://scripts/rules/FightWeek.gd")

## A plan in plan order: the hook is sparred already, the other three lines are UNSPARRED.
const LINES := [
	{"id": "jab", "unsparred": true},
	{"id": "hook", "unsparred": false},
	{"id": "uppercut", "unsparred": true},
	{"id": "body", "unsparred": true},
]
## The same plan with every line sparred, and a plan with nothing in it.
const SPARRED := [
	{"id": "jab", "unsparred": false},
	{"id": "hook", "unsparred": false},
]
const EMPTY: Array = []

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_constants()
	_test_tired_layer()
	_test_tank()
	_test_parts()
	_test_round_one()
	_test_banked()
	_test_stop_lines()
	_test_spar_night()
	_test_ready_lines()
	_test_fire_shift()
	_test_assistant_spar()
	print("FIGHT_WEEK checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


## The map's numbers, pinned: they are ESTIMATES, but a silent edit of one must not pass.
func _test_constants() -> void:
	_check(FightWeek.STOPS == ["rest_up", "tick_over", "train_through"] and FightWeek.DEFAULT_STOP == "tick_over",
		"three load stops, Tick over the default")
	_check(FightWeek.TIRED_FREE == 50 and FightWeek.TIRED_LAYER_CAP == 25, "the tiredness layer: free under 50, capped at 25")
	_check(int(FightWeek.STOP_TANK["rest_up"]) == 0 and int(FightWeek.STOP_TANK["tick_over"]) == 6
		and int(FightWeek.STOP_TANK["train_through"]) == 12, "the stops cost 0 / 6 / 12 off the tank")
	_check(FightWeek.REST_UP_TIRED_TO == 30, "Rest up brings the tiredness to 30 before the bell")
	_check(FightWeek.SPAR_EARLY_TANK == 3 and FightWeek.SPAR_LATE_TANK == 5 and FightWeek.EAT_LESS_TANK == 4,
		"a night costs 3, a late night 5, Eat less 4")
	_check(is_equal_approx(FightWeek.SPAR_LATE_INJURY_X, 2.5) and is_equal_approx(FightWeek.SPAR_LATE_CUT_STOP, 0.03),
		"a late night: injury x2.5 and a cut that ends the bout 3 in 100")
	_check(FightWeek.BANK_SHARE == {"rest_up": 0.2, "tick_over": 0.5, "train_through": 1.0},
		"a fifth / half / the full week's pad units are banked")
	_check(FightWeek.TRAIN_THROUGH_TIRED_AFTER == 6, "Train through adds 6 tiredness after the bell")
	_check(FightWeek.REST_UP_EDGE == [[40, -2.0], [65, -1.0]], "Rest up's round-1 bands: under 40 -2.0, under 65 -1.0")


func _test_tired_layer() -> void:
	_check(FightWeek.tired_layer(40) == 0, "start tiredness 40: the layer is free (0)")
	_check(FightWeek.tired_layer(50) == 0, "start tiredness 50: still free (0)")
	_check(FightWeek.tired_layer(51) == 1, "the first point over 50 costs 1")
	_check(FightWeek.tired_layer(60) == 10, "start tiredness 60: 10 off")
	_check(FightWeek.tired_layer(75) == 25, "start tiredness 75: 25 off (the map's worked week)")
	_check(FightWeek.tired_layer(90) == 25, "start tiredness 90: capped at 25")
	_check(FightWeek.tired_layer(200) == 25, "the cap holds however tired the boxer is")


## The map's four worked examples at start tiredness 75 (25 over 50), then the uncapped choice layer.
func _test_tank() -> void:
	var rest := FightWeek.tank(75, "rest_up", EMPTY, false)
	_check(_off(rest) == 0 and _layer(rest) == 0 and _choices(rest) == 0,
		"75, Rest up, no night, no cut: 0 off (rested to 30 before the bell)")
	var tick := FightWeek.tank(75, "tick_over", EMPTY, false)
	_check(_off(tick) == 31 and _layer(tick) == 25 and _choices(tick) == 6, "75, Tick over: 25 + 6 = 31 off")
	var train := FightWeek.tank(75, "train_through", EMPTY, false)
	_check(_off(train) == 37 and _layer(train) == 25 and _choices(train) == 12, "75, Train through: 25 + 12 = 37 off")
	var late_two := FightWeek.tank(75, "train_through", [5, 4], false)
	_check(_off(late_two) == 47 and _layer(late_two) == 25 and _choices(late_two) == 22,
		"75, Train through + two late nights: 25 + 12 + 10 = 47 off")
	var fresh := FightWeek.tank(30, "tick_over", EMPTY, false)
	_check(_off(fresh) == 6 and _layer(fresh) == 0, "30, Tick over: only the stop's 6 off (the tiredness layer is free)")
	var mid := FightWeek.tank(60, "train_through", EMPTY, false)
	_check(_layer(mid) == 10 and _choices(mid) == 12 and _off(mid) == 22, "60, Train through: 10 + 12 = 22 off")
	var heavy := FightWeek.tank(90, "train_through", [5, 5], true)
	_check(_layer(heavy) == 25 and _choices(heavy) == 26 and _off(heavy) == 51,
		"the choice layer is never capped: 90 + Train through + two late nights + Eat less = 25 + 26 = 51 off")
	var rest_cut := FightWeek.tank(75, "rest_up", [7], true)
	_check(_layer(rest_cut) == 0 and _choices(rest_cut) == 7 and _off(rest_cut) == 7,
		"Rest up with a 7-day night and Eat less: 3 + 4 = 7 off, no tiredness layer")
	_check(_choices(FightWeek.tank(75, "rest_up", EMPTY, true)) == 4, "Eat less costs exactly 4 off the tank")
	_check(_choices(FightWeek.tank(75, "tick_over", [7, 4], false)) == 14, "an early night 3 and a late night 5 stack on the stop's 6")
	_check(_choices(FightWeek.tank(75, "rest_up", [6], false)) == 3 and _choices(FightWeek.tank(75, "rest_up", [5], false)) == 5,
		"the night's price turns at 5 days out: 6 days = 3, 5 days = 5")
	_check(FightWeek.night_tank(9) == 3 and FightWeek.night_tank(8) == 3 and FightWeek.night_tank(7) == 3
		and FightWeek.night_tank(6) == 3 and FightWeek.night_tank(5) == 5 and FightWeek.night_tank(1) == 5,
		"a night's tank price by days out (a week-before night costs pad mastery, never the tank)")
	var unknown := FightWeek.tank(75, "", EMPTY, false)
	_check(_off(unknown) == 31 and _off(FightWeek.tank(75, "no_such_stop", EMPTY, false)) == 31,
		"an unknown stop runs the default (Tick over, 31 off at 75)")


## The tank bar's rows: tiredness, the stop, each night, Eat less - in that order, and no row for a zero part.
func _test_parts() -> void:
	var full := FightWeek.tank(75, "train_through", [5, 4], true)
	_check(_parts(full) == [["Tiredness", 25], ["Train through", 12], ["Sparring, 5 days out", 5],
		["Sparring, 4 days out", 5], ["Eat less", 4]], "the parts in order: %s" % str(_parts(full)))
	_check(_parts(FightWeek.tank(75, "rest_up", EMPTY, false)) == [], "Rest up at 75 with no choices: no parts at all")
	_check(_parts(FightWeek.tank(30, "tick_over", EMPTY, false)) == [["Tick over", 6]],
		"a fresh boxer's bar shows the stop only: no tiredness row for a zero layer")
	_check(_parts(FightWeek.tank(75, "rest_up", EMPTY, true)) == [["Eat less", 4]],
		"Rest up leaves its own zero row out and shows the cut")
	_check(_parts(FightWeek.tank(75, "rest_up", [7], false)) == [["Sparring, 7 days out", 3]],
		"the night's row names the days out: %s" % str(_parts(FightWeek.tank(75, "rest_up", [7], false))))
	_check(_parts_sum(_parts(full)) == _off(full), "the parts add up to the tank (%d)" % _off(full))
	var tick := FightWeek.tank(60, "tick_over", [6], false)
	_check(_parts(tick) == [["Tiredness", 10], ["Tick over", 6], ["Sparring, 6 days out", 3]]
		and _parts_sum(_parts(tick)) == _off(tick), "a Tick over week with one early night: %s" % str(_parts(tick)))


## Round 1 at the bell: FLAT or SHARP, its edge, and Tick over's one-level boost.
func _test_round_one() -> void:
	var fresh := FightWeek.round_one(39, "rest_up")
	_check(str(fresh["state"]) == FightWeek.STATE_FLAT and is_equal_approx(float(fresh["edge"]), -2.0) and not bool(fresh["boost"]),
		"Rest up at 39 start tiredness: FLAT, -2.0 edge, no boost")
	var band := FightWeek.round_one(40, "rest_up")
	_check(str(band["state"]) == FightWeek.STATE_FLAT and is_equal_approx(float(band["edge"]), -1.0),
		"Rest up at 40: the second band, FLAT -1.0")
	_check(is_equal_approx(float(FightWeek.round_one(64, "rest_up")["edge"]), -1.0)
		and str(FightWeek.round_one(64, "rest_up")["state"]) == FightWeek.STATE_FLAT, "Rest up at 64: still FLAT -1.0")
	var old := FightWeek.round_one(65, "rest_up")
	_check(str(old["state"]) == FightWeek.STATE_SHARP and is_zero_approx(float(old["edge"])) and not bool(old["boost"]),
		"Rest up at 65+: Sharp, no boost (the rest pays for itself)")
	_check(str(FightWeek.round_one(90, "rest_up")["state"]) == FightWeek.STATE_SHARP, "Rest up at 90: Sharp too")
	var tick := FightWeek.round_one(20, "tick_over")
	_check(str(tick["state"]) == FightWeek.STATE_SHARP and is_zero_approx(float(tick["edge"])) and bool(tick["boost"]),
		"Tick over: Sharp, and one chosen plan line fires a level up (boost)")
	_check(bool(FightWeek.round_one(80, "tick_over")["boost"]), "Tick over's boost does not depend on the tiredness")
	_check(str(FightWeek.round_one(20, "train_through")["state"]) == FightWeek.STATE_SHARP
		and not bool(FightWeek.round_one(20, "train_through")["boost"])
		and is_zero_approx(float(FightWeek.round_one(20, "train_through")["edge"])), "Train through: Sharp, no boost")
	_check(not bool(FightWeek.round_one(90, "train_through")["boost"]) and not bool(FightWeek.round_one(90, "rest_up")["boost"]),
		"only Tick over boosts")
	_check(bool(FightWeek.round_one(50, "")["boost"]), "an unknown stop reads the default (Tick over, boost)")


## The week's pad units the stop banks on the plan's moves, for mastery.
func _test_banked() -> void:
	_check(FightWeek.banked("rest_up", 720) == 144, "Rest up banks a fifth of 720 units: 144")
	_check(FightWeek.banked("tick_over", 720) == 360, "Tick over banks half of 720: 360")
	_check(FightWeek.banked("train_through", 720) == 720, "Train through banks the full 720 (3 pad nights, GAME units)")
	_check(FightWeek.banked("rest_up", 250) == 50 and FightWeek.banked("tick_over", 240) == 120,
		"the shares hold on a smaller week: 250 -> 50, 240 -> 120")
	_check(FightWeek.banked("train_through", 0) == 0, "no pad units, nothing banked")
	_check(FightWeek.banked("", 720) == 360, "an unknown stop banks the default's half")


## The lines the screen prints for each stop: the tiredness after the bell, when it is best, and the next stop.
func _test_stop_lines() -> void:
	_check(FightWeek.tired_after("train_through") == 6, "Train through: +6 tiredness after the bell")
	_check(FightWeek.tired_after("tick_over") == 0 and FightWeek.tired_after("rest_up") == 0,
		"Tick over and Rest up add nothing after the bell")
	_check(FightWeek.best_when("rest_up") == "start tiredness 65+, or a heavy cut",
		"Rest up's printed line: '%s'" % FightWeek.best_when("rest_up"))
	_check(FightWeek.best_when("tick_over") == "most weeks under 65",
		"Tick over's printed line: '%s'" % FightWeek.best_when("tick_over"))
	_check(FightWeek.best_when("train_through") == "a plan move is within a week of Usable, or the opponent is 5+ below",
		"Train through's printed line: '%s'" % FightWeek.best_when("train_through"))
	_check(FightWeek.best_when("no_such_stop") == FightWeek.best_when(FightWeek.DEFAULT_STOP),
		"an unknown stop prints the default's line")
	_check(FightWeek.next_stop("rest_up") == "tick_over" and FightWeek.next_stop("tick_over") == "train_through",
		"the next-stop hover walks the list")
	_check(FightWeek.next_stop("train_through") == "", "the last stop has no next stop")
	_check(FightWeek.next_stop("") == "" and FightWeek.next_stop("no_such_stop") == "", "a stop off the list has no next stop")


## The three night kinds, priced (4.4).
func _test_spar_night() -> void:
	var before := FightWeek.spar_night(9)
	_check(before == {"when": FightWeek.WHEN_WEEK_BEFORE, "tank": 0, "costs_pad_night": true, "readies": 2,
		"injury_x": 1.0, "cut_stop": 0.0}, "9 days out is a week-before night: no tank, one pad night's mastery: %s" % str(before))
	_check(str(FightWeek.spar_night(8)["when"]) == FightWeek.WHEN_WEEK_BEFORE and int(FightWeek.spar_night(8)["tank"]) == 0,
		"8 days out is still the week before")
	var week := FightWeek.spar_night(7)
	_check(week == {"when": FightWeek.WHEN_FIGHT_WEEK, "tank": 3, "costs_pad_night": false, "readies": 2,
		"injury_x": 1.0, "cut_stop": 0.0}, "7 days out is a fight-week night: 3 off the tank, two lines: %s" % str(week))
	_check(int(FightWeek.spar_night(6)["tank"]) == 3 and str(FightWeek.spar_night(6)["when"]) == FightWeek.WHEN_FIGHT_WEEK,
		"6 days out costs the same 3")
	var late := FightWeek.spar_night(5)
	_check(late == {"when": FightWeek.WHEN_LATE, "tank": 5, "costs_pad_night": false, "readies": FightWeek.SPAR_READY_EVERY,
		"injury_x": 2.5, "cut_stop": 0.03}, "5 days out is LATE: 5 off, every line (-1), x2.5 injury, cut 3 in 100: %s" % str(late))
	_check(str(FightWeek.spar_night(1)["when"]) == FightWeek.WHEN_LATE and int(FightWeek.spar_night(1)["tank"]) == 5,
		"1 day out is late too")
	_check(int(late["readies"]) == -1 and int(week["readies"]) == 2, "a late night readies every line, an early night two")
	_check(not bool(late["costs_pad_night"]) and not bool(week["costs_pad_night"]) and bool(before["costs_pad_night"]),
		"only the week-before night costs a pad night")


## Which lines a night readies (4.4): the player picks two, the default is the first two UNSPARRED in plan order, and a
## late night readies every unsparred line.
func _test_ready_lines() -> void:
	_check(FightWeek.ready_lines(LINES, ["uppercut", "jab"], 7) == ["uppercut", "jab"],
		"a 7-day night readies the two picked lines, in the order picked")
	_check(FightWeek.ready_lines(LINES, EMPTY, 7) == ["jab", "uppercut"],
		"no pick: the first two unsparred lines in plan order (the sparred hook is skipped)")
	_check(FightWeek.ready_lines(LINES, EMPTY, 6) == ["jab", "uppercut"], "a 6-day night readies two as well")
	_check(FightWeek.ready_lines(LINES, ["jab"], 4) == ["jab", "uppercut", "body"],
		"a late night readies EVERY unsparred line and ignores the picks")
	_check(FightWeek.ready_lines(SPARRED, ["jab"], 3) == [], "a late night on a fully sparred plan readies nothing")
	_check(FightWeek.ready_lines(LINES, ["hook", "body"], 7) == ["body"],
		"an already-sparred pick is skipped: only the unsparred one is readied")
	_check(FightWeek.ready_lines(LINES, ["hook"], 7) == ["jab", "uppercut"],
		"no pick left standing: the night falls back to the default two")
	_check(FightWeek.ready_lines(LINES, ["jab", "uppercut", "body"], 7) == ["jab", "uppercut"],
		"more than two picks: an early night still readies only two")
	_check(FightWeek.ready_lines(SPARRED, EMPTY, 7) == [], "a fully sparred plan has nothing to ready")
	_check(FightWeek.ready_lines(EMPTY, ["jab"], 7) == [] and FightWeek.ready_lines(EMPTY, EMPTY, 2) == [],
		"no plan, nothing readied")


## An UNSPARRED line fires one level down in rounds 1 and 2 only (Usable drops to Raw, which does not fire).
func _test_fire_shift() -> void:
	_check(FightWeek.fire_shift(true, 1) == -1, "round 1: an unsparred line fires a level down")
	_check(FightWeek.fire_shift(true, 2) == -1, "round 2: still a level down")
	_check(FightWeek.fire_shift(true, 3) == 0, "round 3: the shift is over")
	_check(FightWeek.fire_shift(true, 4) == 0 and FightWeek.fire_shift(true, 8) == 0, "later rounds are plain")
	_check(FightWeek.fire_shift(false, 1) == 0 and FightWeek.fire_shift(false, 2) == 0
		and FightWeek.fire_shift(false, 3) == 0, "a sparred line never shifts")


## Your assistant's default night (4.4), in days out; 0 places none.
func _test_assistant_spar() -> void:
	_check(FightWeek.assistant_spar(true, 0) == 8, "a week-before night exists: the assistant takes it (8 days out)")
	_check(FightWeek.assistant_spar(true, 12) == 8 and FightWeek.assistant_spar(true, 20) == 8,
		"the week-before night wins however heavy the choice layer already is")
	_check(FightWeek.assistant_spar(false, 0) == 7 and FightWeek.assistant_spar(false, 6) == 7,
		"no week before: a 7-day night while the choices stay under 12 (6 + 3 < 12)")
	_check(FightWeek.assistant_spar(false, 8) == 7, "8 + 3 is still under 12: the 7-day night")
	_check(FightWeek.assistant_spar(false, 9) == 0, "9 + 3 is not under 12: the assistant places no night")
	_check(FightWeek.assistant_spar(false, 12) == 0 and FightWeek.assistant_spar(false, 20) == 0,
		"a choice layer at or over Train through's 12 gets no night")


## A tank read's numbers (a Dictionary value is a Variant, so each is typed).
func _layer(read: Dictionary) -> int:
	return int(read["tired_layer"])


func _choices(read: Dictionary) -> int:
	return int(read["choices"])


func _off(read: Dictionary) -> int:
	return int(read["off"])


func _parts(read: Dictionary) -> Array:
	var out: Array = read["parts"]
	return out


func _parts_sum(parts: Array) -> int:
	var total := 0
	for p in parts:
		var row: Array = p
		total += int(row[1])
	return total
