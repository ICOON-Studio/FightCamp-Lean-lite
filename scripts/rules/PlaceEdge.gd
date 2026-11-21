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
