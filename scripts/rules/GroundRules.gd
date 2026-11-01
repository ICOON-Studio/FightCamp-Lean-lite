extends RefCounted
## GroundRules - the ground fight on paper: positions, moves, odds.
## Pure static functions, no preloads.
##
## Research anchors:
##   topics/ground.md: UFC LW ~17% ground control; 15-25% ground time;
##     2.5-3.0 TD att/15 min; sub att 0.5-1.0/fighter/fight.
##   G141: stuffed shots -> FHL 15-25%, turtle 10-15%.
##   G143: Stage A per-second rates for guard/half/side/mount.
##   G144: skill-gap shape d20 = (actor-opp)/20, mult = base^d20 capped.
##   G92: 1.65 sub att was per BOUT (0.83 per fighter).
##   G75: no published destination shares; tables are coach judgement.

const TICK_S := 10.0

const POSITIONS := [
	"standing", "clinch", "front_headlock", "turtle",
	"guard", "half_guard", "side_control", "mount", "back",
]

const MOVES := [
	{"id": "clinch_entry", "from": "standing", "to": "clinch", "by": "either",
		"kind": "advance", "attr": "wrestling", "base": 0.50},
	{"id": "double_leg", "from": "standing", "to": "guard", "by": "either",
		"kind": "takedown", "attr": "wrestling", "base": 0.34},
	{"id": "single_leg", "from": "standing", "to": "half_guard", "by": "either",
		"kind": "takedown", "attr": "wrestling", "base": 0.30},
	{"id": "shot_fhl", "from": "standing", "to": "front_headlock", "by": "either",
		"kind": "takedown", "attr": "wrestling", "base": 0.25},
	{"id": "body_lock_trip", "from": "clinch", "to": "side_control", "by": "either",
		"kind": "takedown", "attr": "wrestling", "base": 0.38},
	{"id": "snapdown", "from": "clinch", "to": "front_headlock", "by": "either",
		"kind": "advance", "attr": "wrestling", "base": 0.40},
	{"id": "dump_turtle", "from": "clinch", "to": "turtle", "by": "either",
		"kind": "takedown", "attr": "wrestling", "base": 0.30},
	{"id": "fhl_to_back", "from": "front_headlock", "to": "back", "by": "top",
		"kind": "advance", "attr": "wrestling", "base": 0.28},
	{"id": "stand_fhl", "from": "front_headlock", "to": "standing", "by": "bottom",
		"kind": "escape", "attr": "wrestling", "base": 0.38},
	{"id": "turtle_to_back", "from": "turtle", "to": "back", "by": "top",
		"kind": "advance", "attr": "wrestling", "base": 0.32},
	{"id": "stand_turtle", "from": "turtle", "to": "standing", "by": "bottom",
		"kind": "escape", "attr": "wrestling", "base": 0.45},
	{"id": "pass_half", "from": "guard", "to": "half_guard", "by": "top",
		"kind": "pass", "attr": "wrestling", "base": 0.35},
	{"id": "pass_to_side", "from": "guard", "to": "side_control", "by": "top",
		"kind": "pass", "attr": "wrestling", "base": 0.22},
	{"id": "sweep_guard", "from": "guard", "to": "guard", "by": "bottom",
		"kind": "sweep", "attr": "bjj", "base": 0.25},
	{"id": "armbar_guard", "from": "guard", "to": "guard", "by": "bottom",
		"kind": "sub", "attr": "bjj", "base": 0.22},
	{"id": "triangle_guard", "from": "guard", "to": "guard", "by": "bottom",
		"kind": "sub", "attr": "bjj", "base": 0.18},
	{"id": "get_up", "from": "guard", "to": "standing", "by": "bottom",
		"kind": "escape", "attr": "wrestling", "base": 0.42},
	{"id": "half_to_side", "from": "half_guard", "to": "side_control", "by": "top",
		"kind": "advance", "attr": "wrestling", "base": 0.30},
	{"id": "sweep_half", "from": "half_guard", "to": "half_guard", "by": "bottom",
		"kind": "sweep", "attr": "bjj", "base": 0.22},
	{"id": "get_up_half", "from": "half_guard", "to": "standing", "by": "bottom",
		"kind": "escape", "attr": "wrestling", "base": 0.35},
	{"id": "side_to_mount", "from": "side_control", "to": "mount", "by": "top",
		"kind": "advance", "attr": "wrestling", "base": 0.30},
	{"id": "kimura_side", "from": "side_control", "to": "side_control", "by": "top",
		"kind": "sub", "attr": "bjj", "base": 0.03},
	{"id": "shrimp_side", "from": "side_control", "to": "guard", "by": "bottom",
		"kind": "escape", "attr": "bjj", "base": 0.30},
	{"id": "mount_to_back", "from": "mount", "to": "back", "by": "top",
		"kind": "advance", "attr": "wrestling", "base": 0.28},
	{"id": "armbar_mount", "from": "mount", "to": "guard", "by": "top",
		"kind": "sub", "attr": "bjj", "base": 0.02},
	{"id": "escape_mount", "from": "mount", "to": "half_guard", "by": "bottom",
		"kind": "escape", "attr": "bjj", "base": 0.32},
	{"id": "rnc_back", "from": "back", "to": "back", "by": "top",
		"kind": "sub", "attr": "bjj", "base": 0.04},
	{"id": "guillotine_guard", "from": "guard", "to": "guard", "by": "bottom",
		"kind": "sub", "attr": "bjj", "base": 0.15},
	{"id": "kimura_half", "from": "half_guard", "to": "half_guard", "by": "top",
		"kind": "sub", "attr": "bjj", "base": 0.12},
	{"id": "esc_back", "from": "back", "to": "guard", "by": "bottom",
		"kind": "escape", "attr": "bjj", "base": 0.30},
]

## G144 skill-gap multipliers per +20 attribute gap: [mult, cap_lo, cap_hi].
## Takedowns not in G144: brief says use 1.50 cap 0.30-3.0.
const GAP_MULT := {
	"takedown": [1.50, 0.30, 3.0],
	"pass":     [1.55, 0.30, 3.2],
	"sweep":    [1.70, 0.22, 3.6],
	"escape":   [1.25, 0.45, 2.0],
	"advance":  [1.30, 0.40, 2.5],
	"sub":      [1.65, 0.25, 3.5],
}
## Per-move overrides where G144/G142 give a specific row.
const GAP_MULT_OVERRIDE := {
	"fhl_to_back":    [1.60, 0.28, 3.4],
	"turtle_to_back": [1.60, 0.28, 3.4],
	"mount_to_back":  [1.60, 0.28, 3.4],
	"side_to_mount":  [1.25, 0.50, 2.0],
	"rnc_back":       [1.55, 0.30, 3.2],
	# G144 escape / recover guard 1.30-1.50 (cap 0.30-3.0); the kind row above is the stand-up row.
	"shrimp_side":    [1.40, 0.30, 3.0],
	"escape_mount":   [1.40, 0.30, 3.0],
	"esc_back":       [1.40, 0.30, 3.0],
}

## Move selection weights per position.
## Bottom subs (guard) weighted higher than top subs (side/mount/back):
##   BJJ fighter spends most time on bottom, so high bottom-sub weight
##   gives them more attempts despite less control time.
const _MOVE_WEIGHTS := {
	"standing": [],
	"clinch": [["body_lock_trip", 0.30], ["snapdown", 0.35], ["dump_turtle", 0.25]],
	"front_headlock": [["fhl_to_back", 0.35], ["stand_fhl", 0.45]],
	"turtle": [["turtle_to_back", 0.45], ["stand_turtle", 0.50]],
	"guard": [["pass_half", 0.10], ["pass_to_side", 0.04], ["sweep_guard", 0.10],
		["get_up", 0.80]],
	"half_guard": [["half_to_side", 0.15], ["sweep_half", 0.07],
		["get_up_half", 0.55]],
	"side_control": [["side_to_mount", 0.28], ["shrimp_side", 0.50]],
	"mount": [["mount_to_back", 0.18], ["escape_mount", 0.60]],
	"back": [["esc_back", 0.60]],
}

## Submission finish rates (given the attempt succeeded = locked in).
## G144 section 3: RNC ~0.62, armbar ~0.42, triangle ~0.38, kimura ~0.32.
## We use ~40-65% of G144 bases (our sim has higher attempt density per ground tick).
const _SUB_FINISH := {
	"armbar_guard": 0.23, "triangle_guard": 0.20, "kimura_side": 0.18,
	"armbar_mount": 0.22, "rnc_back": 0.35, "guillotine_guard": 0.15,
	"kimura_half": 0.14,
}

## Failed submission destinations.
## Spec: "A failed sub can lose position (mount armbar fails -> guard)."
const _SUB_FAIL_DEST := {
	"armbar_mount": {"pos": "guard", "top": ""},
}


## G144 skill-gap shape: d20 = (att_attr - def_attr) / 20;
##   mult = clamp(kind_mult^d20, cap_lo, cap_hi); chance = base * mult.
static func chance(move: Dictionary, attacker: Dictionary, defender: Dictionary) -> float:
	var attr_name: String = str(move["attr"])
	var a_val: float = float(attacker.get(attr_name, 50))
	var d_val: float = float(defender.get(attr_name, 50))
	var d20: float = (a_val - d_val) / 20.0
	var id: String = str(move["id"])
	var kind: String = str(move["kind"])
	var entry: Array = GAP_MULT_OVERRIDE.get(id, GAP_MULT.get(kind, [1.40, 0.30, 3.0]))
	var mult: float = clampf(pow(float(entry[0]), d20), float(entry[1]), float(entry[2]))
	return clampf(float(move["base"]) * mult, 0.02, 0.95)


static func step(state: Dictionary, fa: Dictionary, fb: Dictionary,
		roll: float, roll2: float) -> Dictionary:
	var pos: String = str(state["pos"])
	var top: String = str(state["top"])
	if pos == "standing":
		return _step_standing(state, fa, fb, roll, roll2)
	return _step_ground(state, fa, fb, roll, roll2, pos, top)


static func _step_standing(state: Dictionary, fa: Dictionary, fb: Dictionary,
		roll: float, roll2: float) -> Dictionary:
	var who := "a" if roll < 0.5 else "b"
	var att := fa if who == "a" else fb
	var def := fb if who == "a" else fa
	var base_rate := 0.035
	var att_w := float(att["wrestling"])
	var def_w := float(def["wrestling"])
	var mod := clampf(att_w * att_w / 2000.0, 0.3, 6.0)
	var p_try := base_rate * mod
	if roll2 >= p_try:
		return {"state": state, "move": "", "who": who, "ok": false, "finish": false}
	var move := "double_leg" if roll < 0.25 else "single_leg"
	var md := _move_def(move)
	var p := chance(md, att, def)
	var ok := roll2 < p
	if ok:
		return {"state": {"pos": str(md["to"]), "top": who},
			"move": move, "who": who, "ok": true, "finish": false}
	var r2 := roll2 / p if p > 0.0 else 0.5
	if r2 < 0.20:
		return {"state": {"pos": "front_headlock", "top": ""},
			"move": move, "who": who, "ok": false, "finish": false}
	elif r2 < 0.32:
		return {"state": {"pos": "turtle", "top": ""},
			"move": move, "who": who, "ok": false, "finish": false}
	return {"state": state, "move": move, "who": who, "ok": false, "finish": false}


static func _step_ground(state: Dictionary, fa: Dictionary, fb: Dictionary,
		roll: float, roll2: float, pos: String, top: String) -> Dictionary:
	var sub := _try_sub_from_pos(pos, top, fa, fb, roll, roll2)
	if not sub.is_empty():
		return sub
	var weights: Array = _MOVE_WEIGHTS.get(pos, [])
	var total_w := 0.0
	for w in weights:
		total_w += float(w[1])
	if total_w > 0.0:
		var sel_roll: float = roll * total_w
		var cum := 0.0
		var sel_id := ""
		for w in weights:
			cum += float(w[1])
			if sel_roll < cum:
				sel_id = str(w[0])
				break
		if sel_id != "":
			var md := _move_def(sel_id)
			var by: String = str(md["by"])
			var who := ""
			if by == "top":
				who = top
			elif by == "bottom":
				who = "b" if top == "a" else ("a" if top == "b" else "b")
			else:
				who = "a" if roll < 0.5 else "b"
			if who != "":
				var att := fa if who == "a" else fb
				var def := fb if who == "a" else fa
				var p := chance(md, att, def)
				var ok := roll2 < p
				if not ok:
					return {"state": state, "move": sel_id, "who": who, "ok": false, "finish": false}
				var new_state := _apply_success(state, md, who, top)
				return {"state": new_state, "move": sel_id, "who": who, "ok": true, "finish": false}
	return {"state": state, "move": "", "who": "", "ok": false, "finish": false}


static func _try_sub_from_pos(pos: String, cur_top: String, fa: Dictionary,
		fb: Dictionary, roll: float, roll2: float) -> Dictionary:
	var who := ""
	var sub_id := ""
	if pos == "guard":
		# Every guard sub is the bottom man's: armbar, triangle, guillotine on a posting head.
		var sub_roll := fmod(roll * 3.17 + roll2 * 1.41, 1.0)
		who = "b" if cur_top == "a" else ("a" if cur_top == "b" else "")
		if sub_roll < 0.30:
			sub_id = "guillotine_guard"
		else:
			sub_id = "armbar_guard" if roll < 0.5 else "triangle_guard"
	elif pos == "half_guard":
		# Top man's kimura off the underhook: a rarer look than the pass, so only some ticks.
		if fmod(roll * 3.17 + roll2 * 1.41, 1.0) >= 0.35:
			return {}
		who = cur_top
		sub_id = "kimura_half"
	elif pos == "side_control":
		who = cur_top
		sub_id = "kimura_side"
	elif pos == "mount":
		who = cur_top
		sub_id = "armbar_mount"
	elif pos == "back":
		who = cur_top
		sub_id = "rnc_back"
	else:
		return {}
	if who == "":
		return {}
	var att := fa if who == "a" else fb
	var def := fb if who == "a" else fa
	var att_bjj := float(att.get("bjj", 50))
	var p_try := clampf(att_bjj * att_bjj / 32000.0 + 0.006, 0.008, 0.20)
	if roll2 >= p_try:
		return {}
	var md := _move_def(sub_id)
	var p := chance(md, att, def)
	var ok := roll2 < p
	if not ok:
		if _SUB_FAIL_DEST.has(sub_id):
			var fd: Dictionary = _SUB_FAIL_DEST[sub_id]
			return {"state": {"pos": str(fd["pos"]), "top": str(fd["top"])},
				"move": sub_id, "who": who, "ok": false, "finish": false}
		return {"state": {"pos": pos, "top": cur_top}, "move": sub_id,
			"who": who, "ok": false, "finish": false}
	var new_state := _apply_success({"pos": pos, "top": cur_top}, md, who, cur_top)
	var fin_p: float = _SUB_FINISH.get(sub_id, 0.15)
	var finish_roll := fmod(roll * 7.31 + roll2 * 3.17, 1.0)
	var is_finish := finish_roll < fin_p
	return {"state": new_state, "move": sub_id, "who": who, "ok": true, "finish": is_finish}


static func _apply_success(state: Dictionary, md: Dictionary,
		who: String, cur_top: String) -> Dictionary:
	var kind: String = str(md["kind"])
	var to_pos: String = str(md["to"])
	if kind == "sweep":
		var new_top := "b" if cur_top == "a" else "a"
		return {"pos": to_pos, "top": new_top}
	if kind == "escape" and to_pos == "standing":
		return {"pos": "standing", "top": ""}
	if kind == "takedown" or kind == "pass" or kind == "advance":
		return {"pos": to_pos, "top": who}
	if to_pos == "standing":
		return {"pos": "standing", "top": ""}
	return {"pos": to_pos, "top": cur_top}


static func simulate(fa: Dictionary, fb: Dictionary, seconds: float, seed: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var state := {"pos": "standing", "top": ""}
	var ground_s := 0.0
	var ctrl_a := 0.0
	var ctrl_b := 0.0
	var td_att_a := 0
	var td_att_b := 0
	var td_ok_a := 0
	var td_ok_b := 0
	var sub_att_a := 0
	var sub_att_b := 0
	var finish := ""
	var log: Array = []
	var ticks := int(floor(seconds / TICK_S))
	for _i in ticks:
		if finish != "":
			break
		var r1 := rng.randf()
		var r2 := rng.randf()
		var result := step(state, fa, fb, r1, r2)
		state = result["state"]
		var move_id: String = str(result["move"])
		var who: String = str(result["who"])
		var ok: bool = bool(result["ok"])
		var is_finish: bool = bool(result["finish"])
		if move_id != "":
			if _is_takedown(move_id):
				if who == "a":
					td_att_a += 1
					if ok:
						td_ok_a += 1
				else:
					td_att_b += 1
					if ok:
						td_ok_b += 1
			if _is_submission(move_id):
				if who == "a":
					sub_att_a += 1
				else:
					sub_att_b += 1
			log.append({"tick": _i, "who": who, "move": move_id, "ok": ok, "pos": state["pos"]})
		if is_finish:
			finish = who
		if str(state["pos"]) != "standing":
			ground_s += TICK_S
			if str(state["top"]) == "a":
				ctrl_a += TICK_S
			elif str(state["top"]) == "b":
				ctrl_b += TICK_S
	return {
		"ground_s": ground_s,
		"control_s": {"a": ctrl_a, "b": ctrl_b},
		"td_att": {"a": td_att_a, "b": td_att_b},
		"td_ok": {"a": td_ok_a, "b": td_ok_b},
		"sub_att": {"a": sub_att_a, "b": sub_att_b},
		"finish": finish,
		"log": log,
	}


static func _move_def(id: String) -> Dictionary:
	for m in MOVES:
		if str(m["id"]) == id:
			return m
	return {}


static func _is_takedown(id: String) -> bool:
	for m in MOVES:
		if str(m["id"]) == id:
			return str(m["kind"]) == "takedown"
	return false


static func _is_submission(id: String) -> bool:
	for m in MOVES:
		if str(m["id"]) == id:
			return str(m["kind"]) == "sub"
	return false
