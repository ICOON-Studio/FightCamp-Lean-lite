extends RefCounted
## FILMTRUTH1 - film nights: how sure a seen tell is, look again or next group,
## cleared as false, debutant lock. Pure static; no class_name, no preload, no game state.
## Dice come in as floats in [0, 1).
##
## A tell is a Dictionary:
##   {"id": String, "group": int, "mode": String, "state": "hidden"|"seen"|"confirmed"|"false",
##    "sure": float, "fade": bool}
##
## locked(opp_bouts)  open_group(tells, group)  next_group(tells)  look_again(tells, group)
## second_night_options(tells)  truth(tell, roll)  check_minute(tell, true_tell, mode_came_up, round_no)
## apply(tell, result)  best_second_night(tells, lines_on)

const SEEN_TRUE := 0.70
const LOOKED_TRUE := 0.90
const NIGHT_COST_PADS := 1


## "no tape on a debutant" when opp_bouts == 0, else "" (the film magnet greys).
static func locked(opp_bouts: int) -> String:
	if opp_bouts == 0:
		return "no tape on a debutant"
	return ""


## Every hidden tell of that group becomes "seen" with sure 0.70; returns how many it opened.
static func open_group(tells: Array, group: int) -> int:
	var n := 0
	for t in tells:
		if t["group"] == group and t["state"] == "hidden":
			t["state"] = "seen"
			t["sure"] = SEEN_TRUE
			n += 1
	return n


## The lowest group number that still has a hidden tell, -1 when none.
static func next_group(tells: Array) -> int:
	var best := -1
	for t in tells:
		if t["state"] == "hidden":
			var g: int = t["group"]
			if best == -1 or g < best:
				best = g
	return best


## Every "seen" tell of that group goes to sure 0.90; returns how many.
static func look_again(tells: Array, group: int) -> int:
	var n := 0
	for t in tells:
		if t["group"] == group and t["state"] == "seen":
			t["sure"] = LOOKED_TRUE
			n += 1
	return n


## The two second-night options: look_again (the group with the most seen tells at 0.70)
## and next_group (the lowest hidden group).
static func second_night_options(tells: Array) -> Array:
	# look_again: group with the most seen tells at 0.70
	var best_g := -1
	var best_count := 0
	var group_seen := {}
	for t in tells:
		if t["state"] == "seen" and t["sure"] == SEEN_TRUE:
			var g: int = t["group"]
			if not group_seen.has(g):
				group_seen[g] = 0
			group_seen[g] = (group_seen[g] as int) + 1
	for g in group_seen:
		var c: int = group_seen[g]
		if c > best_count:
			best_count = c
			best_g = g
	var look_ok := best_count > 0
	var look_why := ""
	if not look_ok:
		look_why = "nothing seen to look at again"

	# next_group
	var ng := next_group(tells)
	var next_ok := ng >= 0
	var next_why := ""
	if not next_ok:
		next_why = "every group is open"

	return [
		{"id": "look_again", "group": best_g, "ok": look_ok, "why": look_why},
		{"id": "next_group", "group": ng, "ok": next_ok, "why": next_why},
	]


## Whether a seen tell is really true: roll < sure.
static func truth(tell: Dictionary, roll: float) -> bool:
	return roll < tell["sure"]


## What the corner minute shows for one seen tell.
## A fade or slow start is checked only at round 2; others at the first minute where
## mode came up. Round 3+ returns "" (amateur bouts: minutes only after rounds 1 and 2).
static func check_minute(tell: Dictionary, true_tell: bool, mode_came_up: bool, round_no: int) -> String:
	if round_no >= 3:
		return ""
	var is_fade: bool = tell["fade"]
	if is_fade:
		if round_no != 2:
			return ""
		if not mode_came_up:
			return ""
		if true_tell:
			return "confirmed"
		return "false"
	# non-fade: checked at the first minute where mode came up
	if not mode_came_up:
		return ""
	if true_tell:
		return "confirmed"
	return "false"


## Sets tell.state to the result ("confirmed" sure 1.0, "false" sure 0.0); "" changes nothing.
static func apply(tell: Dictionary, result: String) -> void:
	if result == "":
		return
	tell["state"] = result
	if result == "confirmed":
		tell["sure"] = 1.0
	elif result == "false":
		tell["sure"] = 0.0


## "look_again" when some seen tell has 2+ lines relying on it, else "next_group" when
## a group is still hidden, else "look_again".
static func best_second_night(tells: Array, lines_on: Dictionary) -> String:
	for t in tells:
		if t["state"] == "seen":
			var tid: String = t["id"]
			if lines_on.has(tid) and (lines_on[tid] as int) >= 2:
				return "look_again"
	var ng := next_group(tells)
	if ng >= 0:
		return "next_group"
	return "look_again"
