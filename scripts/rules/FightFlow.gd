extends RefCounted
## S340 fight flows (operator Q-S294-64 "Yes, boxing and wrestling now"; FLOWS_S339.md steps 1 and 3): the coach's plan
## drawn as a flowchart on the gym whiteboard - the places top to bottom in the order she reaches them, each with the key
## ideas the coach writes on it, and an arrow for every planned move, labelled with WHEN ("if she presses: Step back") - and
## after a fight the same flow lit up with which arrows fired and which worked. One flow for both sports: boxing's places
## are StrikeMap's ring cards (an arrow may carry `when`, the opponent's game), wrestling's are the tie-ups (its map rows
## carry the opponent's `reaction`).
##   build(plan, map, start) -> {start, nodes: [{id, depth, col}], edges: [{move, from, to, when}]}
##   lit(edges, moves) -> edges + {used, worked, state}   bout_moves(rounds) -> {id: [worked, used]}
## Pure static; preloads only the plan board (sport-free).

const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")

## What the coach writes on each place (real coaching cues; 1-2 lines a card).
const IDEAS := {
	"outside": ["Feint to find the timing", "Step in behind the jab"],
	"long": ["Jab to the chest and the head", "Throw, then step out at an angle"],
	"mid": ["Chin down, elbows in", "Hook off the jab, never alone"],
	"inside": ["Head on the shoulder, short shots", "Body first, the head follows"],
	"clinch": ["Tie both arms, lean in", "Breathe, wait for 'Break'"],
	"own_ropes": ["Don't stay: pivot or tie up", "Gloves high, elbows on the ribs"],
	"opp_ropes": ["Cut off the exits, feet square", "Body, head - keep the pressure"],
	"corner": ["Short shots up the middle", "Watch for the spin out"],
	"collar_tie": ["Elbow on the collarbone, own the head", "Snap down on the lean"],
	"underhook": ["Hips in, head tight to hers", "Lift the elbow, go behind"],
	"wrist_control": ["Two hands on one wrist", "Pull it across, take the angle"],
	"two_on_one": ["Both hands on one arm, hips close", "Drag the arm past you"],
	"russian_tie": ["The arm to your chest", "Feet outside"],
	"front_headlock": ["Chest on the head, hips down", "Spin behind as the hips flatten"],
	"finish": ["Hips and hands: get behind, score"],
}
## Boxing's `when`: the opponent's game (Exchanges' situations) in the coach's words.
const WHEN_WORDS := {"press": "she presses", "range": "she boxes at range", "counter": "she waits to counter",
	"loadup": "she loads up", "tiring": "she tires", "hurt": "she is hurt", "she_tired": "you are tired",
	"she_hurt": "you are hurt"}
## An arrow worked when at least this share of its tries won the exchange.
const WORKED_SHARE := 0.5


static func build(plan: Array, map: Array, start: String) -> Dictionary:
	var edges: Array = []
	for a in plan:
		var row := PlanBoard.row(map, str(a["move"]))
		if row.is_empty():
			continue
		edges.append({"move": str(a["move"]), "from": str(row["from"]), "to": str(row["to"]),
			"when": str(a.get("when", row.get("reaction", "")))})
	var depth := {start: 0}
	var order: Array = [start]
	_walk(start, edges, depth, order)
	# S341: the places the plan walks to from the start (the main route); an arrow out of a place she only lands in (her back
	# on the ropes) never pushes the main route down - Mid range stays under Long range, the ropes below them.
	var walked := depth.duplicate()
	# A place the plan never walks to from the start (an arrow from a card it cannot reach): a new row below, walked from there.
	for e in edges:
		var from := str(e["from"])
		if depth.has(from):
			continue
		var deepest := 0
		for k in depth:
			deepest = maxi(deepest, int(depth[k]))
		depth[from] = deepest + 1
		order.append(from)
		_walk(from, edges, depth, order)
	# A place sits below every place that leads to it (collar tie -> front headlock -> finish, not finish beside the
	# headlock) unless that arrow closes a loop (step back from mid range to long range stays an arrow up).
	for _i in order.size():
		var changed := false
		for e in edges:
			var u := str(e["from"])
			var v := str(e["to"])
			if u == v or v == start or int(depth[v]) > int(depth[u]) or _reaches(v, u, edges) or (walked.has(v) and not walked.has(u)):
				continue
			depth[v] = int(depth[u]) + 1
			changed = true
		if not changed:
			break
	order.sort_custom(func(x, y): return int(depth[x]) < int(depth[y]) or (int(depth[x]) == int(depth[y]) and order.find(x) < order.find(y)))
	var cols := {}
	var nodes: Array = []
	for id in order:
		var d := int(depth[id])
		nodes.append({"id": id, "depth": d, "col": int(cols.get(d, 0))})
		cols[d] = int(cols.get(d, 0)) + 1
	return {"start": start, "nodes": nodes, "edges": edges}


## Breadth first from root: each new place one row below the place its arrow leaves.
static func _walk(root: String, edges: Array, depth: Dictionary, order: Array) -> void:
	var queue: Array = [root]
	while not queue.is_empty():
		var n: String = queue.pop_front()
		for e in edges:
			if str(e["from"]) == n and not depth.has(str(e["to"])):
				depth[str(e["to"])] = int(depth[n]) + 1
				order.append(str(e["to"]))
				queue.append(str(e["to"]))


static func _reaches(a: String, b: String, edges: Array) -> bool:
	var seen := {a: true}
	var queue: Array = [a]
	while not queue.is_empty():
		var n: String = queue.pop_front()
		if n == b:
			return true
		for e in edges:
			if str(e["from"]) == n and not seen.has(str(e["to"])):
				seen[str(e["to"])] = true
				queue.append(str(e["to"]))
	return false


## The words on an arrow: "if she presses: Step back" (a branch) or just the move's name.
static func label(edge: Dictionary, move_name: String) -> String:
	var w := str(edge.get("when", ""))
	if w == "":
		return move_name
	return "if %s: %s" % [str(WHEN_WORDS.get(w, "she " + w)), move_name]


## The bout's arrows summed over its rounds (each round's PlanFight.tally "moves").
static func bout_moves(rounds: Array) -> Dictionary:
	var out := {}
	for r in rounds:
		var mv: Dictionary = ((r as Dictionary).get("arrows", {}) as Dictionary).get("moves", {})
		for id in mv:
			var acc: Array = out.get(id, [0, 0])
			out[id] = [int(acc[0]) + int(mv[id][0]), int(acc[1]) + int(mv[id][1])]
	return out


## Each edge with how it went: state "worked" (won at least WORKED_SHARE of its tries), "failed", or "unused".
static func lit(edges: Array, moves: Dictionary) -> Array:
	var out: Array = []
	for e in edges:
		var x: Dictionary = (e as Dictionary).duplicate()
		var t: Array = moves.get(str(e["move"]), [0, 0])
		x["worked"] = int(t[0])
		x["used"] = int(t[1])
		x["state"] = "unused" if int(t[1]) == 0 else ("worked" if float(t[0]) >= WORKED_SHARE * float(t[1]) else "failed")
		out.append(x)
	return out
