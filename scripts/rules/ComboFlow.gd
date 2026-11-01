extends RefCounted
## ComboFlow: coach rules for how well a player-built punch chain flows (Playbook Combos tab).

const MOVES := {
	"jab": {"hand": "lead", "level": "head", "kind": "punch", "loads": "rear"},
	"cross": {"hand": "rear", "level": "head", "kind": "punch", "loads": "lead"},
	"lead_hook": {"hand": "lead", "level": "head", "kind": "punch", "loads": "rear"},
	"body_hook": {"hand": "lead", "level": "body", "kind": "punch", "loads": "rear"},
	"rear_uppercut": {"hand": "rear", "level": "head", "kind": "punch", "loads": "lead"},
	"lead_uppercut": {"hand": "lead", "level": "head", "kind": "punch", "loads": "rear"},
	"rear_hook": {"hand": "rear", "level": "head", "kind": "punch", "loads": "lead"},
	"slip": {"hand": "", "level": "", "kind": "defence", "loads": "rear"},
	"roll": {"hand": "", "level": "", "kind": "defence", "loads": "lead"},
	"pivot": {"hand": "", "level": "", "kind": "step", "loads": ""},
	"step_in": {"hand": "", "level": "", "kind": "step", "loads": ""},
	"step_back": {"hand": "", "level": "", "kind": "step", "loads": ""},
}

## Same numbers as Combos.gd (no preload); tank units for a chain.
const PUNCH_COST := 0.22
const FAST_PUNCH := 1.39
const POWER_MIX := 1.05

const SCORE_START := 50
## Rule 1: the loaded hand fires on time.
const BONUS_OFF_LOAD := 12
const PENALTY_SAME_POWER := 16
const PENALTY_REAR_AFTER_CROSS := 18
## Rule 2: weight on the wrong side for the next punch.
const PENALTY_WRONG_LOAD := 14
## Rule 1 exception: the jab resets fast.
const BONUS_DOUBLE_JAB := 12
## Rule 3: downstairs then back up (once a chain).
const BONUS_LEVEL_CHANGE := 10
## Rule 4: slip or roll into the shot that is loaded.
const BONUS_DEFENCE_COUNTER := 14
const BONUS_STEP_IN_FIRST := 6
## Rule 5: past four punches she is open and inaccurate.
const PENALTY_PUNCH_OVER_FOUR := 25
## Rule 5: two to four punches is a real combination.
const BONUS_COMBO_LENGTH := 8
## Rule 6: open on the rear power hand alone.
const PENALTY_REAR_POWER_OPENER := 22
const NOTE_CROSS_OPENER := 0
const FLOWS_AT := 70
const WORKABLE_AT := 45


static func rate(chain: Array) -> Dictionary:
	var notes: Array = []
	var score := float(SCORE_START)
	if chain.is_empty():
		notes.append("Empty chain — nothing to throw.")
		return _pack(0, notes)
	var punch_count := 0
	var saw_head := false
	var saw_body := false
	var level_bonus := false
	var prev_id := ""
	var prev_kind := ""
	var prev_load := ""
	var after_defence := false
	var punch_seen := 0
	for i in chain.size():
		var id := str(chain[i])
		var m: Dictionary = MOVES.get(id, {})
		if m.is_empty():
			notes.append("Unknown move \"%s\" — cannot judge the chain." % id)
			score -= 20.0
			continue
		var kind := str(m["kind"])
		if kind == "punch":
			punch_count += 1
			punch_seen += 1
			if not level_bonus:
				var lvl := str(m.get("level", ""))
				if lvl == "head":
					saw_head = true
				elif lvl == "body":
					saw_body = true
				if saw_head and saw_body:
					score += float(BONUS_LEVEL_CHANGE)
					level_bonus = true
					notes.append("Switches level — body and head in one chain.")
		if i == 0:
			score += _score_opener(m, id, notes)
			if kind == "step" and id == "step_in":
				score += float(BONUS_STEP_IN_FIRST)
				notes.append("Steps in first — closes range before the combination.")
		else:
			var prev: Dictionary = MOVES.get(prev_id, {})
			score += _score_link(prev, prev_id, prev_kind, prev_load, m, id, kind, after_defence, punch_seen,
				notes)
		if kind == "defence":
			after_defence = true
		elif kind == "punch":
			after_defence = false
		prev_id = id
		prev_kind = kind
		prev_load = str(m.get("loads", ""))
	if punch_count >= 2 and punch_count <= 4:
		score += float(BONUS_COMBO_LENGTH)
		notes.append("Combination length sits in the sweet spot (2–4 punches).")
	if punch_count > 4:
		notes.append("Too many punches in one go — accuracy drops and she leaves holes.")
	if notes.is_empty():
		notes.append("Straight work — nothing major to flag.")
	return _pack(score, notes)


static func energy(chain: Array) -> float:
	var punches := 0
	var non_punches := 0
	for raw in chain:
		var m: Dictionary = MOVES.get(str(raw), {})
		if m.is_empty():
			continue
		match str(m["kind"]):
			"punch":
				punches += 1
			"defence", "step":
				non_punches += 1
	var total := 0.0
	if punches > 0:
		total += PUNCH_COST * (1.0 + FAST_PUNCH * float(maxi(0, punches - 1))) * POWER_MIX
	total += float(non_punches) * PUNCH_COST * 0.5 * POWER_MIX
	return total


static func _pack(score: float, notes: Array) -> Dictionary:
	var s := clampi(roundi(score), 0, 100)
	var word := "clumsy"
	if s >= FLOWS_AT:
		word = "flows"
	elif s >= WORKABLE_AT:
		word = "workable"
	return {"score": s, "word": word, "notes": notes}


static func _score_opener(m: Dictionary, id: String, notes: Array) -> float:
	var kind := str(m["kind"])
	if kind == "defence" or kind == "step":
		return 0.0
	if kind != "punch":
		return 0.0
	if str(m["hand"]) == "lead":
		return 0.0
	if id == "cross":
		notes.append("Opens on the cross — usually a answer off his jab.")
		return -float(NOTE_CROSS_OPENER)
	notes.append("Opens on the rear power hand — slow and telegraphed.")
	return -float(PENALTY_REAR_POWER_OPENER)


static func _score_link(prev: Dictionary, prev_id: String, prev_kind: String, prev_load: String, m: Dictionary,
		id: String, kind: String, after_defence: bool, punch_index: int, notes: Array) -> float:
	var delta := 0.0
	if kind != "punch":
		return delta
	if punch_index > 4:
		delta -= float(PENALTY_PUNCH_OVER_FOUR)
		notes.append("Punch %d in the chain — past the four she can keep sharp." % punch_index)
	var hand := str(m["hand"])
	if prev_kind == "punch":
		var prev_hand := str(prev["hand"])
		if hand == prev_hand:
			if prev_id == "jab" and id == "jab":
				delta += float(BONUS_DOUBLE_JAB)
				notes.append("Double jab — fast reset, stays on the jab hand.")
			elif prev_id == "body_hook" and id == "lead_hook":
				delta += float(BONUS_OFF_LOAD)
				notes.append("Body hook up to the head hook — classic inside change.")
			else:
				delta -= float(PENALTY_SAME_POWER)
				notes.append("Same power hand twice — she has to reload.")
		if prev_id == "cross" and (id == "rear_hook" or id == "rear_uppercut"):
			delta -= float(PENALTY_REAR_AFTER_CROSS)
			notes.append("Rear shot right after the cross — the weight is not loaded for it.")
	var load_side := prev_load
	if prev_kind == "defence":
		load_side = str(prev.get("loads", ""))
	if load_side != "":
		var off_load := (hand == "lead" and load_side == "lead") or (hand == "rear" and load_side == "rear")
		if prev_id == "jab" and id == "jab":
			off_load = true
		if prev_id == "body_hook" and id == "lead_hook":
			off_load = true
		if off_load:
			if punch_index <= 4:
				delta += float(BONUS_OFF_LOAD)
				notes.append("Throws off the loaded hand — good weight transfer.")
		else:
			if not (prev_id == "jab" and id == "jab"):
				delta -= float(PENALTY_WRONG_LOAD)
				notes.append("Punch from the wrong side — weight has to catch up.")
	if after_defence and prev_kind == "defence":
		if load_side != "":
			var counter_ok := (hand == "lead" and load_side == "lead") or (hand == "rear" and load_side == "rear")
			if counter_ok:
				delta += float(BONUS_DEFENCE_COUNTER)
				notes.append("Defence into the counter — catches him on the reload.")
	return delta
