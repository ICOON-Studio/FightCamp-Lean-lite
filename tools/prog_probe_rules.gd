extends RefCounted
## PROGPROBE1R2 - modelled rules for ARM B (the map). NOT built in scripts/ yet;
## modelled here so their numbers can be set before build. Every function marked
## with which PROGRESSION_MAP section it models. Pure static; no class_name.

const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const LearnSlots := preload("res://scripts/rules/LearnSlots.gd")

# MODELLED (PROGRESSION_MAP M2): One learning slot (two when pads rating 65+).
const SLOT_PADS_THRESHOLD := 65.0
const SHADOW_MORNING_RATE := 0.85
const SHADOW_MORNING_MINS := 60.0

# MODELLED (PROGRESSION_MAP M3): Hold rule defaults.
const SHARP_HOLD_DEFAULT := 20.0
const SIGNATURE_HOLD_DEFAULT := 40.0
const FADE_TOWARD_SHARP := 50.0
const FADE_TOWARD_SIGNATURE := 70.0
const FADE_RATE := 1.5
const HOLD_POLICIES := ["COACH", "WIDEST", "DEEPEST", "PLAN_ONLY"]


## MODELLED (M2): Number of learning slots based on pads rating.
static func slot_count(pad_rating: float) -> int:
	return 2 if pad_rating >= SLOT_PADS_THRESHOLD else 1


## MODELLED (M2): The coach's three cards via LearnSlots.cards.
static func coach_cards(f: Dictionary, opp_style: String, gains: Dictionary) -> Array:
	return LearnSlots.cards(f, opp_style, gains)


## MODELLED (M2): The slot's PUNCH moves for this week's pad cards.
# Only includes moves UNDER 30 that need slot training. Moves at 30+ are on pad cards via slot_moves_at30.
static func slot_moves(f: Dictionary, pad_rating: float) -> Array:
	var out: Array = []
	var ls: Array = f.get("learning_slots", [])
	for mv in ls:
		if MoveTree.PUNCH_IDS.has(str(mv)) and MoveTree.mastery(f, str(mv)) < 30.0:
			if not out.has(str(mv)):
				out.append(str(mv))
	return out


## MODELLED (M2): All punches for the pad cards (both under 30 learning and at 30+ sharpening).
static func all_punches_for_cards(f: Dictionary) -> Array:
	var out: Array = []
	for m in ["Jab", "Cross", "Lead hook", "Body hook", "Uppercut", "Check hook"]:
		if float(f.get("moves", {}).get(m, 0.0)) >= 0.0:
			out.append(m)
	return out


## MODELLED (M3): Apply weekly hold. Reads units move by move INCLUDING steps/defences.
static func apply_hold(f: Dictionary, drilled_units: Dictionary, sharp_hold: float, sig_hold: float, frozen: bool) -> void:
	if frozen:
		return
	var moves: Dictionary = f.get("moves", {})
	for mv in moves.keys():
		_apply_one_hold(moves, mv, drilled_units, sharp_hold, sig_hold)
	var steps: Dictionary = f.get("steps", {})
	for sid in steps.keys():
		_apply_one_hold(steps, sid, drilled_units, sharp_hold, sig_hold)


static func _apply_one_hold(store: Dictionary, mv: String, drilled_units: Dictionary, sharp_hold: float, sig_hold: float) -> void:
	var m: float = float(store[mv])
	if m < 60.0:
		return
	var units: float = float(drilled_units.get(mv, 0.0))
	var hold_needed: float = sig_hold if m >= 85.0 else sharp_hold
	if units < hold_needed:
		var target: float = FADE_TOWARD_SIGNATURE if m >= 85.0 else FADE_TOWARD_SHARP
		var new_m: float = maxf(m - FADE_RATE, target)
		store[mv] = new_m


## MODELLED (M3): Frozen = no fade (fight week, TAPER, injured).
static func is_frozen(f: Dictionary) -> bool:
	var bout: Dictionary = f.get("bout", {})
	if not bout.is_empty():
		var bd: int = int(bout.get("day", 0))
		var pd: int = int(f.get("phase_day", 0))
		if (pd - posmod(pd, 7)) == (bd - posmod(bd, 7)):
			return true
	if str(f.get("phase", "base")) == "taper":
		return true
	if bool(f.get("injured", false)):
		return true
	return false


## MODELLED (M5): Drill a step or defence via MoveMastery.gain (shadowbox station).
static func drill_step_def(f: Dictionary, id: String, minutes: float, coach: float, tier: float) -> float:
	var steps: Dictionary = f.get("steps", {})
	var m: float = float(steps.get(id, 0.0))
	var st: Dictionary = f.get("stats", {})
	var cap_val: float = MoveMastery.cap(float(st.get("technique", 55.0)), float(st.get("fight_iq", 55.0)))
	var new_m := MoveMastery.gain(m, "shadowbox", minutes, coach, tier, 1.0, cap_val)
	steps[id] = new_m
	return new_m


## MODELLED (M5): Shadow mornings - 0.85/hour on one step/defence + slot punch.
# Prioritizes open steps/defences (prerequisites for row 2/3), then the most-advanced unmaxed.
static func shadow_mornings(f: Dictionary, coach: float, tier: float) -> Dictionary:
	var step_targets: Array = []
	var steps: Dictionary = f.get("steps", {})
	# First: open steps/defences (needed for row progression)
	for sid in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS:
		if MoveTree.state(f, str(sid)) == "open" and float(steps.get(sid, 0.0)) < 30.0:
			step_targets.append([sid, float(steps.get(sid, 0.0))])
	# Then: steps/defences at 30+ that haven't reached cap
	if step_targets.is_empty():
		for sid in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS:
			var m := float(steps.get(sid, 0.0))
			if m >= 30.0 and m < 85.0:
				step_targets.append([sid, m])
	# Then: any unmaxed step/defence
	if step_targets.is_empty():
		for sid in MoveTree.STEP_IDS + MoveTree.DEFENCE_IDS:
			var m := float(steps.get(sid, 0.0))
			if m < 85.0:
				step_targets.append([sid, m])
	step_targets.sort_custom(func(a, b): return float(a[1]) > float(b[1]))
	var targets: Array = []
	if not step_targets.is_empty():
		targets.append(str(step_targets[0][0]))
	var ls: Array = f.get("learning_slots", [])
	for mv in ls:
		if MoveTree.PUNCH_IDS.has(str(mv)) and not targets.has(str(mv)):
			targets.append(str(mv))
			break
	if targets.is_empty():
		return {}
	var mins := SHADOW_MORNING_MINS / float(targets.size())
	var st: Dictionary = f.get("stats", {})
	var cap_val := MoveMastery.cap(float(st.get("technique", 55.0)), float(st.get("fight_iq", 55.0)))
	var drilled := {}
	for tid in targets:
		var m0: float = MoveTree.mastery(f, str(tid))
		var new_m := MoveMastery.gain(m0, "shadowbox", mins, coach, tier, 1.0, cap_val)
		if MoveTree.PUNCH_IDS.has(str(tid)):
			f["moves"][str(tid)] = new_m
		else:
			f["steps"][str(tid)] = new_m
		drilled[str(tid)] = mins
	return drilled


## MODELLED (M2): Set the learning slot.
static func set_learning_slot(f: Dictionary, move_id: String) -> void:
	if not f.has("learning_slots"):
		f["learning_slots"] = []
	var ls: Array = f["learning_slots"]
	if not ls.has(move_id):
		ls.append(move_id)


## MODELLED (M3): Determine which moves to hold based on policy.
static func hold_targets(f: Dictionary, plan_moves: Array, policy: String) -> Array:
	var moves: Dictionary = f.get("moves", {})
	var steps: Dictionary = f.get("steps", {})
	var at_60: Array = []
	for mv in moves.keys():
		if float(moves[mv]) >= 60.0:
			at_60.append([mv, float(moves[mv])])
	for sid in steps.keys():
		if float(steps[sid]) >= 60.0:
			at_60.append([sid, float(steps[sid])])
	at_60.sort_custom(func(a, b): return float(a[1]) > float(b[1]))
	match policy:
		"COACH":
			var out: Array = []
			for pm in plan_moves:
				if not out.has(pm):
					out.append(str(pm))
			for pair in at_60:
				if float(pair[1]) >= 85.0 and not out.has(str(pair[0])):
					out.append(str(pair[0]))
			return out
		"WIDEST":
			var out: Array = []
			for pair in at_60:
				out.append(str(pair[0]))
			return out
		"DEEPEST":
			var out: Array = []
			for i in mini(2, at_60.size()):
				out.append(str(at_60[i][0]))
			return out
		"PLAN_ONLY":
			return plan_moves.duplicate()
	return []
