extends RefCounted
## S360 the Playbook's Moves tab as a move book (operator Q-S294-91): every move on StrikeMap in one line of the coach's words,
## grouped by where in the ring it is thrown (StrikeMap's cards, ring order). Pure data; preloads the move map only.
##   groups() -> [[title, line, [move ids]]] for MoveBook.make   WORDS = {move id: line}

const SM := preload("res://scripts/rules/StrikeMap.gd")

## The heading of each place's group: [title, what the place is like].
const PLACES := [
	["outside", "FROM OUTSIDE", "Out of reach: find the timing, then get in behind the jab."],
	["long", "AT LONG RANGE", "The end of the jab: straight punches, then in or out."],
	["mid", "AT MID RANGE", "Hook and uppercut range: hit and get out before the reply."],
	["inside", "INSIDE", "Heads close: short punches, or tie up and smother."],
	["clinch", "IN THE CLINCH", "Tied up: make the space, or wait for the break."],
	["own_ropes", "ON THE ROPES", "Back on the ropes: do not stay there."],
	["opp_ropes", "OPPONENT ON THE ROPES", "The opponent is trapped: cut off the exits and work."],
	["corner", "OPPONENT IN THE CORNER", "No way out but through: short shots up the middle."],
]

const WORDS := {
	"step_in": "Step in behind a feint to the end of the jab.",
	"1-1-2": "Two jabs to walk in, the cross behind them.",
	"feint": "Show a punch, read the reply, stay out of reach.",
	"1-1": "Two jabs: the range finder, a fence against a presser.",
	"1-2": "The jab, then the cross down the middle: the first combination.",
	"2-3": "The cross, then the lead hook as the opponent slips it.",
	"1-2-3": "Jab, cross, then the hook comes round the guard.",
	"1-2-3-2": "Four punches: hook, then the cross again through the gap.",
	"1-2-3b": "Up top twice, then the hook to the ribs under the elbows.",
	"step_out": "One step back out of jab range: rest, reset.",
	"cut_off": "Step across the opponent's path and walk the ring smaller.",
	"1-6-3": "Jab, the rear uppercut through the guard, the hook to finish.",
	"3b-3": "Hook to the body, then the same hand to the head as the guard drops.",
	"slip 2-3": "Slip the punch outside, cross and check hook as the opponent comes in.",
	"step_back": "One step back to long range: out of hook reach.",
	"backed_up": "Walked onto the ropes: what pressure does to a fighter who stays.",
	"tie_up": "Wrap the arms and smother the punches until the break.",
	"roll_out": "Roll under the hook and come up outside it, already moving away.",
	"3b-3@inside": "Short body hook, short head hook, heads together.",
	"break": "Both push off and step back to long range.",
	"push_off": "A step back out of the tie-up: make the space on your own terms.",
	"pivot_out": "Turn on the lead foot and step off the ropes to the side.",
	"tie_up@own_ropes": "Tie up on the ropes: no more punches until the break.",
	"slip 2-3@own_ropes": "Slip, cross and hook back out: the ropes push the counter in.",
	"1-2@opp_ropes": "Straight punches down the middle while the exits are shut.",
	"3b-3@opp_ropes": "Body, then head, stepping in as the opponent covers.",
	"herd": "Shut one exit, then the other: walk the opponent into the corner.",
	"3b-3@corner": "Body, head, body: nowhere to roll to in a corner.",
	"1-6-3@corner": "Jab, uppercut up the middle, the hook as the head comes up.",
	"spins_out": "The opponent spins off the corner; the fight goes back to mid range.",
}


## The book: one group a place, its moves in StrikeMap's order (the textbook move first), forced moves last.
static func groups() -> Array:
	var out: Array = []
	for p in PLACES:
		var ids: Array = []
		var forced: Array = []
		for m in SM.MOVES:
			if str(m["from"]) == str(p[0]):
				(forced if str(m["kind"]) == "forced" else ids).append(str(m["id"]))
		out.append([str(p[1]), str(p[2]), ids + forced])
	return out
