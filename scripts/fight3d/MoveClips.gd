extends RefCounted
## MoveClips: every StrikeMap move id -> the clips that show it, in play order.
## Pure data - no preloads, no scene access. The fight scene reads this to plan which animations to play.

const SM := preload("res://scripts/rules/StrikeMap.gd")

## The map. Clip names are what the AnimationPlayer holds: native punches (jab, cross, lead_hook),
## BAKED values (advance, retreat, strafe_left, strafe_right, slip, pull, body_hook, rear_uppercut, ...),
## PAIR clips (clinch_att), and pro_<name> for Punch PRO files (pro_left_jab, pro_right_cross, ...).
const MAP := {
	## --- Steps ---
	"step_in": ["advance"],
	"feint": ["pull"],  ## why: a feint draws a reaction then pulls back
	"step_out": ["retreat"],
	"cut_off": ["strafe_left", "advance"],  ## why: strafe to cut the ring + advance to close
	"step_back": ["retreat"],
	"push_off": ["retreat"],  ## why: push off from the clinch
	"pivot_out": ["strafe_right", "advance"],  ## why: pivot off the ropes then advance
	"herd": ["advance", "strafe_left"],  ## why: walk forward while angling toward the corner

	## --- Combos (punches in order, preferring Punch PRO clips) ---
	"1-1": ["pro_left_jab", "pro_left_jab"],
	"1-2": ["pro_left_jab", "pro_right_cross"],
	"2-3": ["pro_right_cross", "pro_left_hook"],
	"1-1-2": ["pro_left_jab", "pro_left_jab", "pro_right_cross"],
	"1-2-3": ["pro_left_jab", "pro_right_cross", "pro_left_hook"],
	"1-2-3-2": ["pro_left_jab", "pro_right_cross", "pro_left_hook", "pro_right_cross"],
	"1-2-3b": ["pro_left_jab", "pro_right_cross", "body_hook"],
	"1-6-3": ["pro_left_jab", "pro_right_uppercut", "pro_left_hook"],
	"3b-3": ["body_hook", "pro_left_hook"],
	"slip 2-3": ["slip", "pro_right_cross", "pro_left_hook"],  ## why: slip first, then the counter punches

	## --- Combos at specific cards (same punches, different position) ---
	"3b-3@inside": ["body_hook", "pro_left_hook"],
	"slip 2-3@own_ropes": ["slip", "pro_right_cross", "pro_left_hook"],
	"1-2@opp_ropes": ["pro_left_jab", "pro_right_cross"],
	"3b-3@opp_ropes": ["body_hook", "pro_left_hook"],
	"3b-3@corner": ["body_hook", "pro_left_hook"],
	"1-6-3@corner": ["pro_left_jab", "pro_right_uppercut", "pro_left_hook"],

	## --- Defences ---
	"tie_up": ["clinch_att"],  ## why: going into the clinch
	"roll_out": ["pro_left_weave", "retreat"],  ## why: weave under then retreat
	"tie_up@own_ropes": ["clinch_att"],

	## --- Forced ---
	"backed_up": ["retreat", "retreat"],  ## why: forced back onto the ropes, two retreating steps
	"break": ["retreat"],  ## why: referee breaks the clinch, step back
	"spins_out": ["strafe_right"],  ## why: spinning out of corner pressure
}


## Returns the clip list for a move id, or an empty array for an unknown id.
static func clips(move_id: String) -> Array:
	if MAP.has(move_id):
		return MAP[move_id]
	return []


## Returns the clip names in MAP that are not in `have`.
static func missing(have: Array) -> Array:
	var have_set := {}
	for h in have:
		have_set[str(h)] = true
	var out: Array = []
	var seen := {}
	for mid in MAP:
		for c in MAP[mid]:
			var cn := str(c)
			if not have_set.has(cn) and not seen.has(cn):
				seen[cn] = true
				out.append(cn)
	return out
