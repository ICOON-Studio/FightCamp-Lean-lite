extends RefCounted
## READBACK3: two rules, each read from a bout key and OFF when the key is absent.
## - set_up (bool): a waited line used AFTER another planned line won an exchange earlier in the SAME ROUND
##   is NOT waited for on that use (keeps full edge, not a wrong answer): thrown behind something.
##   The set-up is per-round (cleared at the bell), and only a DIFFERENT line's win counts (the waited
##   line's own win does not set it up: you cannot throw yourself behind yourself).
## - wait_cost (float, e.g. 1.25): while her corner waits for a line, Lucy's OTHER planned lines earn
##   their edge times this in that round: the corner looking for one thing sees the others late.
## Pure static, no preloads beyond what it needs.

## Returns {cov: float, mult: float, wrong: bool}.
## cov: the coverage factor (1.0 = none, 0..1 = partial, <0 = waited for).
## mult: the wait_cost multiplier (1.0 = none, >1 = other lines boosted).
## wrong: whether this counts as a wrong answer (cov < 0.0 after set_up).
## plan_won_arrow: the arrow that won earlier THIS ROUND ("" = none yet).
static func factor(bout: Dictionary, arrow: String, pick: Dictionary, plan_won_arrow: String) -> Dictionary:
	if not bool(pick.get("planned", false)):
		return {"cov": 1.0, "mult": 1.0, "wrong": false}
	var covered: Dictionary = bout.get("covered", {})
	var raw_cov: float = float(covered.get(arrow, 1.0))
	# set_up: waited line after a DIFFERENT planned line won this round = not waited for
	var cov := raw_cov
	var different_won := plan_won_arrow != "" and plan_won_arrow != arrow
	if bool(bout.get("set_up", false)) and raw_cov < 0.0 and different_won:
		cov = 1.0
	# wait_cost: other planned lines (not the waited one) earn edge x wait_cost
	var mult := 1.0
	if raw_cov >= 0.0 and bout.has("wait_cost") and _has_waited(covered):
		mult = float(bout["wait_cost"])
	return {"cov": cov, "mult": mult, "wrong": cov < 0.0}


static func _has_waited(covered: Dictionary) -> bool:
	for key in covered:
		if float(covered[key]) < 0.0:
			return true
	return false
