extends RefCounted
## S540 COMBOCOUNTER1 (owner Q-S294-307 "Yes, build it"): THE COMBO COUNTER. A boxer who throws the same line every time
## gets timed. Probed first on a greybox: docs/REPEATBITE1_RESULT.md variant P2 (and REPEATBITE2's P2 control, the same
## numbers): SPAM read in 34 bouts of 100 and -6.1 wins v the counter-puncher, -2.2 overall; a spread plan read in 17 and
## -0.3. Numbers as measured there (tools/repeatbite1_rules.gd), not retuned:
##   COUNT  only the PLAN's own lines (a planned throw that fired; her instinct on a range is never counted - the player
##          cannot vary what he never chose). One count per line (move), carried round to round: each bell fades every
##          count by FADE (the corner minute buys a little back, it does not wipe the slate).
##   READ   a line thrown READ_AT times is read; a ring-smart opponent (rating IQ_AT+) reads it one throw sooner.
##   COUNTER each further throw of a read line is countered with chance CHANCE (a Counter-puncher x COUNTER_STYLE): the
##          exchange is LOST and its margin drops to -COUNTER_MARGIN or lower.
##   FILM   her last bout is on film: the next opponent starts with that bout's most-thrown plan line half-read
##          (count READ_AT / 2, rounded down - so against a ring-smart reader, who needs one throw, the film adds nothing).
##          (The greybox took the most-thrown move of any kind; the game takes the plan's own, the only lines it counts.)
## HOW IT STACKS WITH PlanRead.ADJUST (decided S540, no double charge in one coin): ADJUST trims the EDGE of a right answer
## after FREE_USES right uses in a round (the line still wins more often than not, it just pays less); the counter decides
## the EXCHANGE - on a counter the edge is moot, the exchange is the opponent's. They read different things (ADJUST: right
## answers per round; the counter: every plan line, across rounds and from film), so both stay - the greybox measured the
## counter laid over the game WITH ADJUST in it, so the P2 numbers already are the stacked numbers.
## Pure static, zero preloads; state lives on the dicts handed in: bout["cc"] (the counts), bout["cc_thrown"] (this bout's
## plan lines, for the next film), fighter["cc_film"] (the line her next opponent has on film).
## `on` false = the control arm (the game before). The live round's wire: state/LiveRound.gd (open, exchange).

const READ_AT := 2
const IQ_AT := 65.0
const CHANCE := 0.35
const COUNTER_STYLE := 1.75
const COUNTER_MARGIN := 10.0
const FADE := 1
static var on: bool = true


## Throws of one line before the opponent has it.
static func read_at(opp_rating: float) -> int:
	return maxi(1, READ_AT - (1 if opp_rating >= IQ_AT else 0))


## The chance a throw into a read is countered.
static func chance(opp_style: String) -> float:
	return minf(0.95, CHANCE * (COUNTER_STYLE if opp_style == "Counter-puncher" else 1.0))


static func is_read(count: int, n_at: int) -> bool:
	return count >= n_at


## The bell: every count fades by FADE.
static func bell(counts: Dictionary) -> Dictionary:
	var out := {}
	for k in counts:
		var v := int(counts[k]) - FADE
		if v > 0:
			out[k] = v
	return out


## The film: last bout's most-thrown plan line, half-read.
static func film_start(last_top: String, n_at: int) -> Dictionary:
	return {} if last_top == "" or n_at / 2 <= 0 else {last_top: n_at / 2}


## The most-thrown line of a tally {move: throws} ("" when empty; ties go to the first counted).
static func top(thrown: Dictionary) -> String:
	var best := ""
	for k in thrown:
		if str(k) != "" and (best == "" or int(thrown[k]) > int(thrown[best])):
			best = str(k)
	return best


## A countered exchange (Exchanges.settle's dict, changed in place and returned): lost, margin -COUNTER_MARGIN or lower.
static func countered(s: Dictionary) -> Dictionary:
	s["margin"] = minf(float(s["margin"]), -COUNTER_MARGIN)
	s["won"] = false
	return s


## The bell of round n on the bout: round 1 opens on the film, later rounds on the faded counts.
static func open_round(f: Dictionary, n: int) -> void:
	var bout: Dictionary = f["bout"]
	if n == 1 or not bout.has("cc"):
		var opp: Dictionary = bout.get("opp", {})
		bout["cc"] = film_start(str(f.get("cc_film", "")), read_at(float(opp.get("rating", 60.0)))) if on else {}
		bout["cc_film_from"] = str(f.get("cc_film", ""))
		bout["cc_thrown"] = {}
	else:
		bout["cc"] = bell(bout["cc"])


## One exchange: `move` is the plan line she threw ("" = instinct or no plan: never counted), `roll` its own dice, `s`
## the settled exchange (countered in place when the counter lands; {} = only count).
## {fired: thrown into a read, countered: the exchange is the opponent's, count: throws of the line before this one}.
static func throw(f: Dictionary, move: String, roll: float, s: Dictionary = {}) -> Dictionary:
	var out := {"fired": false, "countered": false, "count": 0}
	var bout: Dictionary = f["bout"]
	if not on or move == "" or not bout.has("cc"):
		return out
	var opp: Dictionary = bout.get("opp", {})
	var counts: Dictionary = bout["cc"]
	var k := int(counts.get(move, 0))
	out["count"] = k
	if is_read(k, read_at(float(opp.get("rating", 60.0)))):
		out["fired"] = true
		out["countered"] = roll < chance(str(opp.get("style", "")))
		if bool(out["countered"]) and not s.is_empty():
			countered(s)
	counts[move] = k + 1
	var thrown: Dictionary = bout.get_or_add("cc_thrown", {})
	thrown[move] = int(thrown.get(move, 0)) + 1
	f["cc_film"] = top(thrown)   # what the next opponent's camp will have on film (this bout's line so far)
	return out


## The counters of a bout, per line: {move: {n: counters, fired: throws into the read, round: first counter's round}}.
static func counters(rounds: Array) -> Dictionary:
	var out := {}
	for r in rounds:
		for x in (r as Dictionary).get("exchanges", []):
			var cc: Dictionary = (x as Dictionary).get("cc", {})
			if cc.is_empty() or not bool(cc.get("fired", false)):
				continue
			var mv := str(x.get("arrow", ""))
			var row: Dictionary = out.get_or_add(mv, {"n": 0, "fired": 0, "round": 0})
			row["fired"] = int(row["fired"]) + 1
			if bool(cc.get("countered", false)):
				row["n"] = int(row["n"]) + 1
				if int(row["round"]) == 0:
					row["round"] = int((r as Dictionary).get("n", 0))
	return out
