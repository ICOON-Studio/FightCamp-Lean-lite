extends RefCounted
## StrikeMap: 8 position cards, 30 moves. Every combo, step and defence is a move
## from one card to another. Pure static lookups over the two tables.

const Combos := preload("res://scripts/rules/Combos.gd")

const CARDS: Array = [
	{"id": "outside", "name": "Outside", "what": "Out of range, feinting, hands low enough to move", "range_m": [1.4, 3.0]},
	{"id": "long", "name": "Long range", "what": "Jab range", "range_m": [1.05, 1.4]},
	{"id": "mid", "name": "Mid range", "what": "Hook and uppercut range", "range_m": [0.7, 1.05]},
	{"id": "inside", "name": "Inside", "what": "Heads close, short punches", "range_m": [0.45, 0.7]},
	{"id": "clinch", "name": "Clinch", "what": "Tied up until the referee breaks it", "range_m": [0.0, 0.45]},
	{"id": "own_ropes", "name": "On the ropes", "what": "Back on the ropes or in a corner: trapped", "range_m": []},
	{"id": "opp_ropes", "name": "Opponent on the ropes", "what": "The opponent's back is on the ropes", "range_m": []},
	{"id": "corner", "name": "Corner trap", "what": "She has the opponent trapped in a corner", "range_m": []},
]

const MOVES: Array = [
	{"id": "step_in", "name": "Step in", "kind": "step", "combo": "", "from": "outside", "to": "long"},
	{"id": "1-1-2", "name": "Double jab, cross", "kind": "combo", "combo": "1-1-2", "from": "outside", "to": "long"},
	{"id": "feint", "name": "Feint and draw", "kind": "step", "combo": "", "from": "outside", "to": "outside"},
	{"id": "1-1", "name": "Double jab", "kind": "combo", "combo": "1-1", "from": "long", "to": "long"},
	{"id": "1-2", "name": "One-two", "kind": "combo", "combo": "1-2", "from": "long", "to": "long"},
	{"id": "2-3", "name": "Cross, hook", "kind": "combo", "combo": "2-3", "from": "long", "to": "mid"},
	{"id": "1-2-3", "name": "One-two-hook", "kind": "combo", "combo": "1-2-3", "from": "long", "to": "mid"},
	{"id": "1-2-3-2", "name": "One-two-hook-cross", "kind": "combo", "combo": "1-2-3-2", "from": "long", "to": "mid"},
	{"id": "1-2-3b", "name": "One-two, body hook", "kind": "combo", "combo": "1-2-3b", "from": "long", "to": "mid"},
	{"id": "step_out", "name": "Step out", "kind": "step", "combo": "", "from": "long", "to": "outside"},
	{"id": "cut_off", "name": "Cut off the ring", "kind": "step", "combo": "", "from": "long", "to": "opp_ropes"},
	{"id": "1-6-3", "name": "Jab, uppercut, hook", "kind": "combo", "combo": "1-6-3", "from": "mid", "to": "inside"},
	{"id": "3b-3", "name": "Body hook, head hook", "kind": "combo", "combo": "3b-3", "from": "mid", "to": "inside"},
	{"id": "slip 2-3", "name": "Slip, cross, check hook", "kind": "combo", "combo": "slip 2-3", "from": "mid", "to": "mid"},
	{"id": "step_back", "name": "Step back", "kind": "step", "combo": "", "from": "mid", "to": "long"},
	{"id": "backed_up", "name": "Backed onto the ropes", "kind": "forced", "combo": "", "from": "mid", "to": "own_ropes"},
	{"id": "tie_up", "name": "Tie up", "kind": "defence", "combo": "", "from": "inside", "to": "clinch"},
	{"id": "roll_out", "name": "Roll under and out", "kind": "defence", "combo": "", "from": "inside", "to": "mid"},
	{"id": "3b-3@inside", "name": "Body hook, head hook", "kind": "combo", "combo": "3b-3", "from": "inside", "to": "inside"},
	{"id": "break", "name": "Referee breaks", "kind": "forced", "combo": "", "from": "clinch", "to": "long"},
	{"id": "push_off", "name": "Push off", "kind": "step", "combo": "", "from": "clinch", "to": "mid"},
	{"id": "pivot_out", "name": "Pivot off the ropes", "kind": "step", "combo": "", "from": "own_ropes", "to": "mid"},
	{"id": "tie_up@own_ropes", "name": "Tie up", "kind": "defence", "combo": "", "from": "own_ropes", "to": "clinch"},
	{"id": "slip 2-3@own_ropes", "name": "Slip, cross, check hook", "kind": "combo", "combo": "slip 2-3", "from": "own_ropes", "to": "mid"},
	{"id": "1-2@opp_ropes", "name": "One-two", "kind": "combo", "combo": "1-2", "from": "opp_ropes", "to": "opp_ropes"},
	{"id": "3b-3@opp_ropes", "name": "Body hook, head hook", "kind": "combo", "combo": "3b-3", "from": "opp_ropes", "to": "inside"},
	{"id": "herd", "name": "Herd into the corner", "kind": "step", "combo": "", "from": "opp_ropes", "to": "corner"},
	{"id": "3b-3@corner", "name": "Body hook, head hook", "kind": "combo", "combo": "3b-3", "from": "corner", "to": "corner"},
	{"id": "1-6-3@corner", "name": "Jab, uppercut, hook", "kind": "combo", "combo": "1-6-3", "from": "corner", "to": "corner"},
	{"id": "spins_out", "name": "She spins out", "kind": "forced", "combo": "", "from": "corner", "to": "mid"},
]


static func card(id: String) -> Dictionary:
	for c in CARDS:
		if str(c["id"]) == id:
			return c
	return {}


static func move(id: String) -> Dictionary:
	for m in MOVES:
		if str(m["id"]) == id:
			return m
	return {}


static func outs(card_id: String) -> Array:
	var out: Array = []
	for m in MOVES:
		if str(m["from"]) == card_id and str(m["kind"]) != "forced":
			out.append(m)
	return out


static func ins(card_id: String) -> Array:
	var out: Array = []
	for m in MOVES:
		if str(m["to"]) == card_id:
			out.append(m)
	return out


static func grey_reason(row: Dictionary, mastery: Dictionary) -> String:
	var kind := str(row.get("kind", ""))
	if kind == "combo":
		var missing := Combos.missing(str(row.get("combo", "")), mastery)
		if not missing.is_empty():
			return "Learn the " + " and ".join(missing) + " first"
		return ""
	if kind == "forced":
		return "Done to your fighter"
	return ""


static func route(from_id: String, to_id: String) -> Array:
	if from_id == to_id:
		return []
	var parent: Dictionary = {}
	var queue: Array = [from_id]
	var visited: Dictionary = {from_id: true}
	while not queue.is_empty():
		var cur: String = str(queue.pop_front())
		var candidates: Array = []
		for m in outs(cur):
			candidates.append(m)
		for m in MOVES:
			if str(m["from"]) == cur and str(m["kind"]) == "forced":
				candidates.append(m)
		for m in candidates:
			var nxt := str(m["to"])
			if visited.has(nxt):
				continue
			visited[nxt] = true
			parent[nxt] = m
			if nxt == to_id:
				var path: Array = []
				var cur2 := to_id
				while cur2 != from_id:
					var mv: Dictionary = parent[cur2]
					path.push_front(str(mv["id"]))
					cur2 = str(mv["from"])
				return path
			queue.append(nxt)
	return []
