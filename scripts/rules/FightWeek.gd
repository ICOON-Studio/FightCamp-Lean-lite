extends RefCounted
## S474 FWTANK1 (operator S473 "Yes, build it"; map DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI 4.2, 4.3, 4.4): the amateur
## FIGHT WEEK. An amateur bout has no camp: the player picks ONE LOAD STOP for the fight week and places 0-2 SPARRING
## nights, and both cost THE TANK - the energy ceiling at the first bell.
## THE TANK has two layers (4.2, answers John's J1 "the tank cap still makes tired boxers pay nothing"): the TIREDNESS
## layer is 1 off for each point of start tiredness over 50, capped at 25; the CHOICES layer (the load stop, each
## fight-week sparring night, Eat less) is subtracted AFTER it and is never capped. A tired boxer pays every point of
## every choice. Worked at start tiredness 75: Rest up 0 off, Tick over 31, Train through 37, Train through with two late
## nights 47. Rest up rests the boxer down to 30 tiredness BEFORE the bell, so its tiredness layer is 0.
##   tired_layer(start_tired) -> points   night_tank(days_out) -> points   stop_of(stop) -> a stop id
##   tank(start_tired, stop, spar_nights, eat_less) -> {tired_layer, choices, off, parts [[label, points], ...]}
##   round_one(start_tired, stop) -> {state "sharp"|"flat", edge, boost}   banked(stop, week_units) -> pad units kept
##   tired_after(stop) -> tiredness added after the bell   best_when(stop) -> the line printed on the stop
##   spar_night(days_out) -> {when, tank, costs_pad_night, readies, injury_x, cut_stop}
##   ready_lines(lines, picked, days_out) -> the ids the night readies   fire_shift(unsparred, round_no) -> level shift
##   assistant_spar(has_week_before, choices_now) -> the assistant's default night, days out (0 = none)   next_stop(stop)
## Every number here is an ESTIMATE until FIGHTWEEKPROBE4 runs, so each stays named at the top. Week-before nights (8+ days
## out) cost one pad night's mastery, never the tank, and are NOT passed to tank(). Pure static: no class_name, no preload.

## The tiredness layer of the tank: free under 50, then 1 off a point, capped (4.2).
const TIRED_FREE := 50
const TIRED_LAYER_CAP := 25
## The three load stops of the fight week (4.3); Tick over is the one the screen opens on.
const STOPS := ["rest_up", "tick_over", "train_through"]
const DEFAULT_STOP := "tick_over"
const STOP_NAMES := {"rest_up": "Rest up", "tick_over": "Tick over", "train_through": "Train through"}
## What each stop costs off the tank (the choice layer, uncapped).
const STOP_TANK := {"rest_up": 0, "tick_over": 6, "train_through": 12}
## Rest up brings the tiredness down to this BEFORE the bell, so its tiredness layer is 0.
const REST_UP_TIRED_TO := 30
## Sparring nights: 3 off the tank at 7 or 6 days out, 5 off at 5 or fewer (4.4). Eat less (Cut 500 kcal) costs 4 (4.5).
const SPAR_EARLY_TANK := 3
const SPAR_LATE_TANK := 5
const EAT_LESS_TANK := 4
const SPAR_LATE_MAX_DAYS := 5
const SPAR_WEEK_BEFORE_DAYS := 8
## A late night is priced on purpose over the pack's no-sparring TAPER (WeekPhase): x2.5 training injury and a cut that
## ends the bout 3 in 100 (ESTIMATE, NEW; [R] Buglioni, Boxing News 2016).
const SPAR_LATE_INJURY_X := 2.5
const SPAR_LATE_CUT_STOP := 0.03
## A night with no risk of its own: the week before, or 7-6 days out.
const INJURY_X_PLAIN := 1.0
const CUT_STOP_NONE := 0.0
## What a night readies: two lines the player picks, or -1 = every unsparred line on a late night (4.4).
const SPAR_READY_MAX := 2
const SPAR_READY_EVERY := -1
## The week's pad units the stop banks for mastery (4.3: a fifth / half / the full week; 720 for 3 pad nights, GAME).
const BANK_SHARE := {"rest_up": 0.2, "tick_over": 0.5, "train_through": 1.0}
## Train through costs tiredness after the bell, and the week enters TrainingLoad's ratio (1.5x spike: injury x2-4).
const TRAIN_THROUGH_TIRED_AFTER := 6
## Rest up's round 1, as [start tiredness under, edge] bands read in order; past the last band the boxer is Sharp and
## gets no boost (ESTIMATE).
const REST_UP_EDGE := [[40, -2.0], [65, -1.0]]
## Round 1 reads: FLAT costs edge; Tick over's ONE chosen plan line fires one level up in rounds 1 and 2 (4.3).
const STATE_FLAT := "flat"
const STATE_SHARP := "sharp"
const FIRST_ROUND := 1
const BOOST_LAST_ROUND := 2
## The night kinds spar_night() returns, and the assistant's default (4.4: a week-before night when one exists, else a
## 7-day night if the choice layer stays under Train through's 12, else none).
const WHEN_WEEK_BEFORE := "week_before"
const WHEN_FIGHT_WEEK := "fight_week"
const WHEN_LATE := "late"
const ASSISTANT_NIGHT := 7
const NO_NIGHT := 0
## The line printed on each stop: the state it is best in (4.3).
const BEST_WHEN := {
	"rest_up": "start tiredness 65+, or a heavy cut",
	"tick_over": "most weeks under 65",
	"train_through": "a plan move is within a week of Usable, or the opponent is 5+ below",
}
## The tank bar's printed part labels: the tiredness layer in grey, then each choice stacked in colour after it (4.2).
const LABEL_TIRED := "Tiredness"
const LABEL_EAT_LESS := "Eat less"
const LABEL_SPAR := "Sparring, %d days out"


## The tiredness layer of the tank: 1 off for each point of start tiredness over 50, capped at 25 (4.2).
static func tired_layer(start_tired: int) -> int:
	return clampi(start_tired - TIRED_FREE, 0, TIRED_LAYER_CAP)


## The stop the week runs on; an unknown or empty stop falls back to the default (Tick over).
static func stop_of(stop: String) -> String:
	return stop if STOPS.has(stop) else DEFAULT_STOP


## What one sparring night costs off the tank: 5 at 5 or fewer days out, else 3. (A week-before night costs no tank; it
## costs one pad night's mastery instead, so week-before nights are never passed to tank().)
static func night_tank(days_out: int) -> int:
	return SPAR_LATE_TANK if days_out <= SPAR_LATE_MAX_DAYS else SPAR_EARLY_TANK


## THE TANK at the first bell (4.2): {"tired_layer": int, "choices": int, "off": int, "parts": [[label, points], ...]}.
## `spar_nights` holds the days-out of each FIGHT-WEEK sparring night placed on the board. Rest up rests the boxer down to
## 30 before the bell, so its tiredness layer is 0; the choices are added after that layer and are never capped. `parts`
## carries the bar's rows in order - tiredness, the stop, each night, Eat less - and leaves every zero part out.
static func tank(start_tired: int, stop: String, spar_nights: Array, eat_less: bool) -> Dictionary:
	var s := stop_of(stop)
	var at_bell: int = REST_UP_TIRED_TO if s == "rest_up" else start_tired
	var layer := tired_layer(at_bell)
	var stop_points: int = STOP_TANK[s]
	var choices := stop_points
	var parts: Array = []
	if layer > 0:
		parts.append([LABEL_TIRED, layer])
	if stop_points > 0:
		parts.append([str(STOP_NAMES[s]), stop_points])
	for n in spar_nights:
		var days := int(n)
		var points := night_tank(days)
		choices += points
		if points > 0:
			parts.append([LABEL_SPAR % days, points])
	if eat_less:
		choices += EAT_LESS_TANK
		parts.append([LABEL_EAT_LESS, EAT_LESS_TANK])
	return {"tired_layer": layer, "choices": choices, "off": layer + choices, "parts": parts}


## Round 1 at the bell (4.3): {"state": "sharp" or "flat", "edge": float, "boost": bool}.
## Rest up: start tiredness under 40 reads FLAT at -2.0 edge, 40 to 64 FLAT at -1.0, and 65+ Sharp with no boost.
## Tick over: Sharp, and ONE chosen plan line fires one level up in rounds 1 and 2. Train through: Sharp, no boost.
static func round_one(start_tired: int, stop: String) -> Dictionary:
	var s := stop_of(stop)
	if s == "rest_up":
		for band in REST_UP_EDGE:
			var edge: Array = band
			if start_tired < int(edge[0]):
				return {"state": STATE_FLAT, "edge": float(edge[1]), "boost": false}
		return {"state": STATE_SHARP, "edge": 0.0, "boost": false}
	if s == "tick_over":
		return {"state": STATE_SHARP, "edge": 0.0, "boost": true}
	return {"state": STATE_SHARP, "edge": 0.0, "boost": false}


## The pad units of the week that the stop banks on the plan's moves, for mastery (4.3).
static func banked(stop: String, week_units: int) -> int:
	var share: float = BANK_SHARE[stop_of(stop)]
	return roundi(week_units * share)


## The tiredness the stop adds after the bell (4.3: Train through +6; the other two add nothing).
static func tired_after(stop: String) -> int:
	return TRAIN_THROUGH_TIRED_AFTER if stop_of(stop) == "train_through" else 0


## The line printed on the stop: the state it is best in (4.3).
static func best_when(stop: String) -> String:
	return str(BEST_WHEN[stop_of(stop)])


## One sparring night, priced (4.4): {"when", "tank", "costs_pad_night", "readies", "injury_x", "cut_stop"}.
## 8+ days out is the WEEK BEFORE: no tank, one pad night's mastery instead, two lines readied. 7 or 6 days out is a
## FIGHT-WEEK night: 3 off the tank, two lines. 5 or fewer is LATE: 5 off the tank, EVERY unsparred line readied (-1),
## x2.5 training injury and a cut that ends the bout 3 in 100.
static func spar_night(days_out: int) -> Dictionary:
	if days_out >= SPAR_WEEK_BEFORE_DAYS:
		return {"when": WHEN_WEEK_BEFORE, "tank": 0, "costs_pad_night": true, "readies": SPAR_READY_MAX,
			"injury_x": INJURY_X_PLAIN, "cut_stop": CUT_STOP_NONE}
	if days_out > SPAR_LATE_MAX_DAYS:
		return {"when": WHEN_FIGHT_WEEK, "tank": SPAR_EARLY_TANK, "costs_pad_night": false, "readies": SPAR_READY_MAX,
			"injury_x": INJURY_X_PLAIN, "cut_stop": CUT_STOP_NONE}
	return {"when": WHEN_LATE, "tank": SPAR_LATE_TANK, "costs_pad_night": false, "readies": SPAR_READY_EVERY,
		"injury_x": SPAR_LATE_INJURY_X, "cut_stop": SPAR_LATE_CUT_STOP}


## The plan lines a night readies (4.4). `lines` is [{"id": String, "unsparred": bool}, ...] in plan order, `picked` the
## ids the player chose on the picker. A line written or changed since the boxer last sparred is UNSPARRED. A LATE night
## readies every unsparred line; otherwise the picked ones (at most two, and only unsparred ones), or - with no pick left
## standing - the first two unsparred lines in plan order, which is the default.
static func ready_lines(lines: Array, picked: Array, days_out: int) -> Array:
	var free: Array = []
	for row in lines:
		var line: Dictionary = row
		if bool(line.get("unsparred", false)):
			free.append(str(line.get("id", "")))
	if days_out <= SPAR_LATE_MAX_DAYS:
		return free
	var out: Array = []
	for p in picked:
		var pick := str(p)
		if free.has(pick) and not out.has(pick) and out.size() < SPAR_READY_MAX:
			out.append(pick)
	if out.is_empty():
		for id in free:
			out.append(id)
			if out.size() >= SPAR_READY_MAX:
				break
	return out


## An UNSPARRED line fires one level down in rounds 1 and 2 (Usable drops to Raw, which does not fire); 0 elsewhere (4.4).
static func fire_shift(unsparred: bool, round_no: int) -> int:
	if unsparred and round_no >= FIRST_ROUND and round_no <= BOOST_LAST_ROUND:
		return -1
	return 0


## Your assistant's default night (4.4), in days out; NO_NIGHT (0) when it places none: a week-before night when one
## exists, else a 7-day night while the choice layer stays under Train through's 12, else none.
static func assistant_spar(has_week_before: bool, choices_now: int) -> int:
	if has_week_before:
		return SPAR_WEEK_BEFORE_DAYS
	var heaviest: int = STOP_TANK["train_through"]
	if choices_now + SPAR_EARLY_TANK < heaviest:
		return ASSISTANT_NIGHT
	return NO_NIGHT


## The stop after this one, for the next-stop hover (4.3 D5: hovering a stop shows the next stop's tank, round-1 and
## banked lines side by side); "" after the last stop, and for a stop that is not on the list.
static func next_stop(stop: String) -> String:
	var i := STOPS.find(stop)
	if i < 0 or i + 1 >= STOPS.size():
		return ""
	return str(STOPS[i + 1])
