extends RefCounted
## R17PHASE1 rounds on lines: when each line lives (early, middle, late, or all), and the last round
## splits IF AHEAD / IF BEHIND with its own pace and arrows. Pure static; preloads StrikeMap, Exchanges, PaceAim.
##   split(rounds) -> {early, middle, late}   phase_of(round, rounds) -> String
##   pips(arrow, rounds) -> Array[bool]   late_state(won, lost) -> String
##   late_state_of(rounds_exs) -> String   live(arrows, late, round, rounds, state) -> Array
##   pace(late, round, rounds, state) -> String   validate(arrows, late, rounds, brought) -> Array
##   body_pays(arrow, rounds) -> int   words(arrow, rounds) -> String

const SM := preload("res://scripts/rules/StrikeMap.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")

const PHASES := ["early", "middle", "late"]
const ROUND_WORDS := ["all", "early", "middle", "late"]
const MIN_ROUNDS := 2
const MAX_ROUNDS := 12


## The three phases for a bout of `rounds` rounds (2-12, clamped). Early and late are each floor(rounds/3)
## rounds (at least 1), middle the rest. Returns {early: [round numbers], middle: [...], late: [...]}.
static func split(rounds: int) -> Dictionary:
	var r := clampi(rounds, MIN_ROUNDS, MAX_ROUNDS)
	var edge := maxi(1, r / 3)
	var early: Array = []
	var middle: Array = []
	var late: Array = []
	for i in range(1, r + 1):
		if i <= edge:
			early.append(i)
		elif i > r - edge:
			late.append(i)
		else:
			middle.append(i)
	return {"early": early, "middle": middle, "late": late}


## The phase ("early", "middle", "late") this round lives in, or "" if out of range.
static func phase_of(round: int, rounds: int) -> String:
	var phases := split(rounds)
	if round in phases["early"]:
		return "early"
	if round in phases["middle"]:
		return "middle"
	if round in phases["late"]:
		return "late"
	return ""


## One bool per round: true where this arrow's line lives. An arrow with no `rounds` key or "all" lives in every round.
static func pips(arrow: Dictionary, rounds: int) -> Array:
	var r := clampi(rounds, MIN_ROUNDS, MAX_ROUNDS)
	var rw := str(arrow.get("rounds", "all"))
	var out: Array = []
	for i in range(1, r + 1):
		if rw == "all":
			out.append(true)
		elif rw == "early":
			out.append(i in split(r)["early"])
		elif rw == "middle":
			out.append(i in split(r)["middle"])
		elif rw == "late":
			out.append(i in split(r)["late"])
		else:
			out.append(false)
	return out


## "ahead" when won > lost, else "behind" (level counts as behind, ESTIMATE).
static func late_state(won: int, lost: int) -> String:
	return "ahead" if won > lost else "behind"


## The same from each round's exchange records through Exchanges.round_of (reads "won" from each).
static func late_state_of(rounds_exs: Array) -> String:
	var won := 0
	var lost := 0
	for exs in rounds_exs:
		var rd := Exchanges.round_of(exs)
		if bool(rd["won"]):
			won += 1
		else:
			lost += 1
	return late_state(won, lost)


## The arrows whose phase holds this round. In the late phase, adds late[state]["arrows"] (state "ahead"/"behind").
## A late-only arrow ("late") lives in both states.
static func live(arrows: Array, late: Dictionary, round: int, rounds: int, state: String) -> Array:
	var out: Array = []
	var phase := phase_of(round, rounds)
	for a in arrows:
		var rw := str(a.get("rounds", "all"))
		if rw == "all" or rw == phase:
			out.append(a)
	if phase == "late" and late.has(state):
		var state_data: Dictionary = late[state]
		for a in state_data.get("arrows", []):
			out.append(a)
	return out


## The late state's pace in a late round; "" otherwise (the caller keeps today's round pace).
static func pace(late: Dictionary, round: int, rounds: int, state: String) -> String:
	if phase_of(round, rounds) != "late":
		return ""
	if late.has(state):
		return str(late[state].get("pace", ""))
	return ""


## Plain-word problems (empty = fine): more lines than `brought` in a round; more than 2 arrows in a late state;
## a pace not in PaceAim.PACES; an unknown rounds word; a late arrow whose move is not in StrikeMap.MOVES.
static func validate(arrows: Array, late: Dictionary, rounds: int, brought: int) -> Array:
	var problems: Array = []
	var r := clampi(rounds, MIN_ROUNDS, MAX_ROUNDS)
	var phases := split(r)
	# Count lines per round from arrows
	for i in range(1, r + 1):
		var count := 0
		for a in arrows:
			var pips_arr := pips(a, r)
			if i - 1 < pips_arr.size() and bool(pips_arr[i - 1]):
				count += 1
		if count > brought:
			problems.append("Round %d holds %d lines; the boxer brings %d" % [i, count, brought])
	# Late states
	for state in ["ahead", "behind"]:
		if late.has(state):
			var state_data: Dictionary = late[state]
			var late_arrows: Array = state_data.get("arrows", [])
			if late_arrows.size() > 2:
				problems.append("If %s: %d lines, at most 2" % [state, late_arrows.size()])
			var p := str(state_data.get("pace", ""))
			if p != "" and p not in PaceAim.PACES:
				problems.append("If %s: '%s' is not a pace" % [state, p])
			for a in late_arrows:
				var move_id := str(a.get("move", ""))
				if SM.move(move_id).is_empty():
					problems.append("If %s: '%s' is not a move" % [state, move_id])
	# Check rounds words and count late round lines
	for a in arrows:
		var rw := str(a.get("rounds", "all"))
		if rw not in ROUND_WORDS:
			problems.append("'%s' is not early, middle, late or all" % rw)
	# Late round line counts per state
	for state in ["ahead", "behind"]:
		if not late.has(state):
			continue
		var late_arrows: Array = late[state].get("arrows", [])
		for i in phases["late"]:
			var count := 0
			for a in arrows:
				var pips_arr := pips(a, r)
				if i - 1 < pips_arr.size() and bool(pips_arr[i - 1]):
					count += 1
			count += late_arrows.size()
			if count > brought:
				problems.append("Round %d, if %s, holds %d lines; the boxer brings %d" % [i, state, count, brought])
	return problems


## For a body line (its StrikeMap combo holds a body punch, "3b" or "b") that lives in the early phase,
## the last round number (pays in R3: Exchanges.BODY_COST makes every body shot cost for the rest of the bout);
## 0 otherwise.
static func body_pays(arrow: Dictionary, rounds: int) -> int:
	var move_id := str(arrow.get("move", ""))
	var row := SM.move(move_id)
	var combo := str(row.get("combo", ""))
	if not combo.contains("b"):
		return 0
	var rw := str(arrow.get("rounds", "all"))
	if rw != "early":
		return 0
	var r := clampi(rounds, MIN_ROUNDS, MAX_ROUNDS)
	return r


## "R1", "R2-3", "R3, if behind" style labels for a line's rounds; "All rounds" for "all".
static func words(arrow: Dictionary, rounds: int, state: String = "") -> String:
	var tail := ", if %s" % state if state != "" else ""
	var rw := str(arrow.get("rounds", "all"))
	if rw == "all":
		return "All rounds"
	var r := clampi(rounds, MIN_ROUNDS, MAX_ROUNDS)
	var phases := split(r)
	var nums: Array = phases.get(rw, [])
	if nums.is_empty():
		return ""
	if nums.size() == 1:
		return "R%d%s" % [nums[0], tail]
	return "R%d-%d%s" % [nums[0], nums[-1], tail]
