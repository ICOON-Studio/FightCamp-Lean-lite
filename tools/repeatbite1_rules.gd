extends RefCounted
## S539 REPEATBITE1 greybox rule (probe copy; the game is untouched). Owner Q-S294-306 "Yes, make it bite"; Q-301 "a bigger
## chance to be read by the opponent for a counter punch". Pure static, zero game preloads.
##   A THE COUNTER: a move thrown READ_AT times in a ROUND (every throw counted, plan line or instinct) is read; each further
##     throw of it is countered with chance CHANCE (counter-puncher x COUNTER_STYLE): the exchange is lost and its margin
##     drops to -COUNTER_MARGIN or lower. A ring-smart opponent (rating >= IQ_AT) reads one throw sooner.
##   B THE MEMORY: A, but the count carries across rounds: at each bell every count fades by FADE (the corner's change call
##     would clear it; the sim has no such call, so in the probe it never clears).
##   C THE FILM: B, and an opponent whose camp filmed her starts with her last bout's most-thrown move half-read
##     (count = READ_AT / 2, rounded down).
## Numbers fixed BEFORE the run (S539): CHANCE 0.35 (about one in three throws into a read gets timed), counter-puncher x1.75
## (task), IQ_AT 65 (the volume puncher 65.5 and the boxer-puncher 72 of the six), COUNTER_MARGIN 10 (a best answer is +9).

const CHANCE := 0.35
const COUNTER_STYLE := 1.75
const IQ_AT := 65.0
const COUNTER_MARGIN := 10.0
const FADE := 1


static func read_at(n: int, opp_rating: float) -> int:
	return maxi(1, n - (1 if opp_rating >= IQ_AT else 0))


static func chance(opp_style: String) -> float:
	return minf(0.95, CHANCE * (COUNTER_STYLE if opp_style == "Counter-puncher" else 1.0))


## True when this throw of a move already thrown `count` times meets a read.
static func is_read(count: int, n_at: int) -> bool:
	return count >= n_at


## The bell: counts fade (B, C) or reset (A).
static func bell(counts: Dictionary, carry: bool) -> Dictionary:
	if not carry:
		return {}
	var out := {}
	for k in counts:
		var v := int(counts[k]) - FADE
		if v > 0:
			out[k] = v
	return out


## The film: the last bout's most-thrown move, half-read.
static func film_start(last_top: String, n_at: int) -> Dictionary:
	return {} if last_top == "" else {last_top: n_at / 2}


## A countered exchange: lost, margin at most -COUNTER_MARGIN.
static func countered(x: Dictionary) -> Dictionary:
	var e := x.duplicate()
	e["margin"] = minf(float(x["margin"]), -COUNTER_MARGIN)
	e["won"] = false
	return e
