extends RefCounted
## S533 STEPPAY2 phase 2 (ops/research/STEPS_PAYOFF_SCOPE_S533.md, owner Q-S294-285 "Yes, build it"): THE PLACE PAYS.
## STEPPAY1 measured that no place in the ring was an edge (every card within -3.0..+3.2 of the game's own mix, the noise):
## having the opponent on the ropes scored the same as being there yourself. Real boxing: a boxer with her back on the
## ropes has no step back and no range game, and the one in front of her throws with her feet set.
## The rule, read in ONE place of the exchange odds (RingDuel.step adds it to the duel edge; RingDuel.settle keeps it apart
## from the duel's own edge on the record):
##   edge(at)              - points on the exchange for your boxer: + with the opponent on the ropes / in the corner,
##                           the same size against her on her own ropes (the mirror).
##   pins_opp / pins_her   - who is trapped on this card.
##   bias(b, at)           - the trapped opponent's RANGE game gets weight 0 in Exchanges.next_mode.
##   mode_at(at, mode)     - a trapped opponent whose game was "range" covers up and counters instead.
##   call_place / mode_place - nobody asks for long range (Duels' ladder place 0) with her back on the ropes.
## SIZE (measured, docs/STEPPAY2_PHASE2.md): ROPES is the size of an OK corner call (Exchanges.EDGE ok = 5.0); the corner a
## bit more. Pure static, zero preloads. `on` false = the control arm (the game before this rule).

const ROPES := 5.0
const CORNER := 6.5
const LONG := 0   ## Duels.LONG, the ladder's long range
static var on: bool = true
## MEASUREMENT ONLY (tools/place_value_probe.gd / treevalue_probe.gd `edge=`): another ROPES size, CORNER in proportion.
static var probe_size: float = -1.0
## The win read (BoutRead walks the duel in expectation and has no card): what the ropes cost on an average exchange after a
## round's first = -ROPES x her pressing + loading share x the share of exchanges your boxer loses x READ_KEEP.
## Measured, tools/place_read_probe.gd (150 bouts x 6 styles, STEPPAY2 phase 4): the played mean was 0.49-0.74 of that
## forecast with no pivot-out line in the plan (mean 0.60) and 0.36-0.58 with one (mean 0.45: she turns off the ropes).
const READ_KEEP := 0.60
const READ_KEEP_PIVOT := 0.45
const SPREAD := 66.0   ## Exchanges.EX_SPREAD: each side rolls +/- half of it


static func edge(at: String) -> float:
	if not on:
		return 0.0
	var r := probe_size if probe_size >= 0.0 else ROPES
	match at:
		"opp_ropes":
			return r
		"corner":
			return r * CORNER / ROPES
		"own_ropes":
			return -r
	return 0.0


## The share of exchanges lost at an edge of d points (two rolls of +/- SPREAD / 2).
static func lose_share(d: float) -> float:
	var t := 1.0 - minf(absf(d), SPREAD) / SPREAD
	return t * t / 2.0 if d >= 0.0 else 1.0 - t * t / 2.0


static func read(trap_share: float, lose: float, pivot_planned: bool) -> float:
	if not on:
		return 0.0
	return -ROPES * trap_share * lose * (READ_KEEP_PIVOT if pivot_planned else READ_KEEP)


static func pins_opp(at: String) -> bool:
	return on and (at == "opp_ropes" or at == "corner")


static func pins_her(at: String) -> bool:
	return on and at == "own_ropes"


static func bias(b: Dictionary, at: String) -> Dictionary:
	if not pins_opp(at):
		return b
	var out := b.duplicate()
	out["range"] = 0.0
	return out


static func mode_at(at: String, mode: String) -> String:
	return "counter" if pins_opp(at) and mode == "range" else mode


static func call_place(at: String, want: int) -> int:
	return -1 if pins_her(at) and want == LONG else want


static func mode_place(at: String, want: int) -> int:
	return -1 if pins_opp(at) and want == LONG else want
