extends RefCounted
## SLOTS1 - the learning slots: how many moves a fighter can study at once, how fast they learn,
## and the coach's three cards for what to study next. Pure static; preloads MoveTree and MoveMastery only.

const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

## A move not in the caller's gains dict uses this mastery per week on pad nights.
const DEFAULT_GAIN := 6.0

## The moves that ANSWER each opponent style: the coach's first pick when one of these is open.
const ANSWERS := {
	"Out-boxer": ["cut_off", "step_in", "feint"],
	"Pressure fighter": ["step_back", "pivot_out", "tie_up", "Check hook"],
	"Counter-puncher": ["feint", "Body hook", "step_in"],
	"Slugger": ["roll_out", "step_out", "Check hook"],
	"Volume puncher": ["tie_up", "pivot_out", "roll_out"],
	"Boxer-puncher": ["step_back", "Check hook", "feint"],
}


## How many learning slots the fighter has: 1; 2 when an assistant with pads rating >= 65 runs their pad nights.
## Pass -1.0 for no assistant.
static func slots(assistant_pads: float) -> int:
	if assistant_pads >= 65.0:
		return 2
	return 1


## How fast the fighter learns (a multiplier on weekly mastery gain):
## base = 0.8 + 0.4 x coachability / 100; x1.1 when under 23; x0.9 when 31 or over.
static func speed(f: Dictionary) -> float:
	var personality: Dictionary = f.get("personality", {}) as Dictionary
	var coach: float = float(personality.get("coachability", 55.0))
	var base: float = 0.8 + 0.4 * coach / 100.0
	var age: int = int(f.get("age", 22))
	if age < 23:
		base *= 1.1
	elif age >= 31:
		base *= 0.9
	return base


## The coach's three cards: up to three open nodes the fighter is not already studying,
## scored and sorted by what they answer, what they complete, and what they open.
static func cards(f: Dictionary, opp_style: String, gains: Dictionary) -> Array:
	var open: Array = MoveTree.open_nodes(f)
	var learning: Array = f.get("learning_slots", [])
	var candidates: Array = []
	for id in open:
		if (learning as Array).has(id):
			continue
		candidates.append(id)
	var spd: float = speed(f)
	var scored: Array = []
	for id in candidates:
		var sc: int = 0
		var reasons: Array[String] = []
		var builds: String = ""
		var answers: bool = false
		# (a) answers the opponent style
		var ans_list: Array = ANSWERS.get(opp_style, [])
		if (ans_list as Array).has(id):
			sc += 3
			reasons.append("Answers a " + opp_style)
			answers = true
		# (b) completes a style set
		for sname in MoveTree.STYLES:
			var moves: Array = MoveTree.STYLES[sname]
			if not (moves as Array).has(id):
				continue
			var count: int = 0
			for mv in moves:
				if str(mv) == id:
					continue
				if MoveTree.mastery(f, str(mv)) >= 60.0:
					count += 1
			if count == 2:
				sc += 2
				builds = sname
				reasons.append("Third move of " + sname)
				break
		# (c) opens other nodes
		var opens_arr: Array = MoveTree.opens(id)
		var opens_count: int = mini(opens_arr.size(), 2)
		sc += opens_count
		if opens_arr.size() > 0:
			reasons.append("Opens " + str(opens_arr[0]))
		# weeks to Usable
		var m: float = MoveTree.mastery(f, id)
		var gain: float = float(gains.get(id, DEFAULT_GAIN))
		var wtu: int = maxi(1, ceili((30.0 - m) / (gain * spd)))
		reasons.append(str(wtu) + " weeks to Usable")
		scored.append({"id": id, "score": sc, "reasons": reasons, "weeks_to_usable": wtu,
			"opens": opens_arr, "answers": answers, "builds_style": builds})
	# sort by score desc, then by NODES order
	scored.sort_custom(func(a, b):
		if int(a["score"]) != int(b["score"]):
			return int(a["score"]) > int(b["score"])
		return _node_index(str(a["id"])) < _node_index(str(b["id"]))
	)
	var out: Array = []
	for i in mini(scored.size(), 3):
		var c: Dictionary = scored[i]
		out.append({"id": str(c["id"]), "reasons": c["reasons"], "weeks_to_usable": int(c["weeks_to_usable"]),
			"opens": c["opens"], "answers": bool(c["answers"]), "builds_style": str(c["builds_style"])})
	return out


## Index of a node id in MoveTree.NODES (for tie-breaking).
static func _node_index(id: String) -> int:
	for i in MoveTree.NODES.size():
		if str(MoveTree.NODES[i]["id"]) == id:
			return i
	return 999


## The mastery a half-learned move loses a week while out of the slot.
static func swap_price(m: float) -> float:
	return m - MoveMastery.decay_week(m, false)


## Put id in the fighter's learning_slots when it is open and a slot is free; returns false otherwise.
static func pick(f: Dictionary, id: String, slot_count: int) -> bool:
	if MoveTree.state(f, id) != "open":
		return false
	if not f.has("learning_slots"):
		f["learning_slots"] = []
	var ls: Array = f["learning_slots"]
	if ls.size() >= slot_count:
		return false
	if ls.has(id):
		return false
	ls.append(id)
	return true


## Take id out of the fighter's learning_slots.
static func drop(f: Dictionary, id: String) -> void:
	if not f.has("learning_slots"):
		return
	var ls: Array = f["learning_slots"]
	ls.erase(id)
