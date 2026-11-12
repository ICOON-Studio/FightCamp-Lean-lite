extends RefCounted
## ASKPROBE1: what a fight teaches. Pure static module copying Matchmaking.apply_result's growth arithmetic
## (the pro model) for amateurs. Reads its constants, never retypes a number: a re-tune there moves this too.
## gap = opponent rating minus ours. won = whether we won. stopped = whether the fight ended in a stoppage.

const Matchmaking := preload("res://scripts/rules/Matchmaking.gd")

## Cut points for the teaching word (ASKPROBE1 sets them).
## S445: cut from the probe's measured 0.47-1.05 spread (0.4 / 0.7 put every card in "some" or "a lot", Kalli + John S444).
const WORD_LITTLE := 0.6
const WORD_LOT := 0.85
## Cut points for the stoppage risk word (ASKPROBE1 sets them).
const STOP_POSSIBLE := 0.15
const STOP_RISK := 0.30


## The rating growth a fight earns, exactly Matchmaking.apply_result's arithmetic.
static func teach(gap: float, won: bool, stopped: bool) -> float:
	var grow: float
	if gap > -Matchmaking.SOFT_GAP:
		grow = Matchmaking.GROW_BASE + Matchmaking.GROW_PER_POINT * clampf(gap, 0.0, Matchmaking.LEARN_GAP)
	else:
		grow = Matchmaking.GROW_SOFT
	if not won:
		if gap <= Matchmaking.LEARN_GAP and not stopped:
			grow += Matchmaking.GROW_LOSS
		if stopped:
			grow -= Matchmaking.STOP_COST
	return grow


## The teaching word for the card: "teaches little" / "teaches some" / "teaches a lot".
static func word(expected: float) -> String:
	if expected < WORD_LITTLE:
		return "teaches little"
	if expected < WORD_LOT:
		return "teaches some"
	return "teaches a lot"


## The stoppage risk word for the card: "unlikely" / "possible" / "a real risk".
static func stop_word(chance: float) -> String:
	if chance < STOP_POSSIBLE:
		return "unlikely"
	if chance < STOP_RISK:
		return "possible"
	return "a real risk"
