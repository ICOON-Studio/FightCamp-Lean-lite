extends RefCounted
## MOVETREE1 - the boxing move tree as rules and data. 16 nodes in a coach's teaching order:
## 6 punches (Data.MOVES), 7 footwork (StrikeMap step ids), 3 defences. Three rows: row 1 open
## at signing, row 2 at 5 usable, row 3 at 9. A row's lock only stops learning; a node at 30+
## in a locked row is known and usable. Pure static; preloads StrikeMap and PunchStart only.

const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PunchStart := preload("res://scripts/rules/PunchStart.gd")
const StepMastery := preload("res://scripts/rules/StepMastery.gd")

## The 16 nodes. Each: {id, branch, row, needs: {node_id: mastery_required}}.
const NODES := [
	# Row 1 - open at signing
	{"id": "Jab", "branch": "lead", "row": 1, "needs": {}},
	{"id": "Lead hook", "branch": "lead", "row": 1, "needs": {}},
	{"id": "Cross", "branch": "rear", "row": 1, "needs": {}},
	{"id": "Body hook", "branch": "rear", "row": 1, "needs": {}},
	{"id": "step_in", "branch": "footwork", "row": 1, "needs": {}},
	{"id": "step_out", "branch": "footwork", "row": 1, "needs": {}},
	# Row 2 - open when 5 nodes at 30+
	{"id": "Check hook", "branch": "lead", "row": 2, "needs": {"Lead hook": 60}},
	{"id": "Uppercut", "branch": "rear", "row": 2, "needs": {"Cross": 30, "step_in": 30}},
	{"id": "step_back", "branch": "footwork", "row": 2, "needs": {"step_out": 30}},
	{"id": "pivot_out", "branch": "footwork", "row": 2, "needs": {"step_back": 30}},
	{"id": "tie_up", "branch": "defence", "row": 2, "needs": {"step_in": 30}},
	{"id": "roll_out", "branch": "defence", "row": 2, "needs": {"Lead hook": 30}},
	# Row 3 - open when 9 nodes at 30+
	{"id": "feint", "branch": "footwork", "row": 3, "needs": {"Jab": 60}},
	{"id": "cut_off", "branch": "footwork", "row": 3, "needs": {"step_in": 60}},
	{"id": "herd", "branch": "footwork", "row": 3, "needs": {"cut_off": 30}},
	{"id": "push_off", "branch": "defence", "row": 3, "needs": {"tie_up": 30}},
]

## Style sets (M4): three moves each, all at 60+ to hold the style.
const STYLES := {
	"Out-boxer": ["Jab", "step_out", "step_back"],
	"Volume puncher": ["Jab", "Cross", "pivot_out"],
	"Boxer-puncher": ["Cross", "step_in", "Uppercut"],
	"Pressure fighter": ["step_in", "Body hook", "tie_up"],
	"Slugger": ["Body hook", "Lead hook", "roll_out"],
	"Counter-puncher": ["Lead hook", "step_out", "Check hook"],
}

const PUNCH_IDS := ["Jab", "Lead hook", "Cross", "Body hook", "Uppercut", "Check hook"]
const STEP_IDS := ["step_in", "step_out", "step_back", "pivot_out", "cut_off", "herd", "feint"]
const DEFENCE_IDS := ["tie_up", "roll_out", "push_off"]

## Combo-to-punches mapping (mirrors Combos.BOOK unique punches, avoids a third preload).
const COMBO_PUNCHES := {
	"1-1": ["Jab"],
	"1-2": ["Jab", "Cross"],
	"1-1-2": ["Jab", "Cross"],
	"2-3": ["Cross", "Lead hook"],
	"1-2-3": ["Jab", "Cross", "Lead hook"],
	"1-2-3-2": ["Jab", "Cross", "Lead hook"],
	"1-2-3b": ["Jab", "Cross", "Body hook"],
	"1-6-3": ["Jab", "Uppercut", "Lead hook"],
	"3b-3": ["Body hook", "Lead hook"],
	"slip 2-3": ["Cross", "Check hook"],
}


## Node lookup by id.
static func _node(id: String) -> Dictionary:
	for n in NODES:
		if str(n["id"]) == id:
			return n
	return {}


## Mastery of a node for a fighter dict. Punches from f["moves"], steps/defences from f["steps"]
## (absent -> 0.0).
static func mastery(f: Dictionary, id: String) -> float:
	if PUNCH_IDS.has(id):
		return float((f.get("moves", {}) as Dictionary).get(id, 0.0))
	var steps: Dictionary = f.get("steps", {}) as Dictionary
	return float(steps.get(id, 0.0))


## Count of nodes at 30+ (usable).
static func usable_count(f: Dictionary) -> int:
	var n: int = 0
	for node in NODES:
		if mastery(f, str(node["id"])) >= 30.0:
			n += 1
	return n


## Is a row open? Row 1 always; row 2 when 5 nodes at 30+; row 3 when 9 at 30+.
static func row_open(f: Dictionary, row: int) -> bool:
	if row <= 1:
		return true
	var uc: int = usable_count(f)
	if row == 2:
		return uc >= 5
	return uc >= 9


## State of a node: "known" (30+), "open" (row open and needs met, under 30), "locked" (else).
## A row's lock only stops learning: a node at 30+ in a locked row is still "known".
static func state(f: Dictionary, id: String) -> String:
	var m: float = mastery(f, id)
	if m >= 30.0:
		return "known"
	var nd: Dictionary = _node(id)
	if nd.is_empty():
		return "locked"
	var r: int = int(nd["row"])
	if not row_open(f, r):
		return "locked"
	var needs: Dictionary = nd["needs"] as Dictionary
	for req_id in needs:
		if mastery(f, str(req_id)) < float(needs[req_id]):
			return "locked"
	return "open"


## Array of node ids whose state is "open".
static func open_nodes(f: Dictionary) -> Array:
	var out: Array = []
	for node in NODES:
		if state(f, str(node["id"])) == "open":
			out.append(str(node["id"]))
	return out


## Nodes whose needs name `id` (i.e. nodes that `id` helps unlock).
static func opens(id: String) -> Array:
	var out: Array = []
	for node in NODES:
		var needs: Dictionary = node["needs"] as Dictionary
		if needs.has(id):
			out.append(str(node["id"]))
	return out


## Day 0 steps and old-save steps: one rule, StepMastery's (S452 STEPMASTERY1; it also strips a place suffix "tie_up@own_ropes").
static func day0_steps(footwork: float) -> Dictionary:
	return StepMastery.start_values(footwork)


static func old_save_steps(plan_arrows: Array) -> Dictionary:
	return StepMastery.from_old_save(plan_arrows)


## Style names whose three moves are all at 60+.
static func styles_held(f: Dictionary) -> Array:
	var out: Array = []
	for style_name in STYLES:
		var moves: Array = STYLES[style_name]
		var held := true
		for mv in moves:
			if mastery(f, str(mv)) < 60.0:
				held = false
				break
		if held:
			out.append(style_name)
	return out


## Places: for a step/defence, the [from, to] ring places of every StrikeMap row with that id
## (or id@place); for a punch, the places of the StrikeMap combinations that use it.
## Reads from StrikeMap.MOVES only.
static func places(id: String) -> Array:
	if PUNCH_IDS.has(id):
		return _punch_places(id)
	return _step_def_places(id)


static func _step_def_places(id: String) -> Array:
	var out: Array = []
	for m in StrikeMap.MOVES:
		var mid: String = str(m["id"])
		if mid == id or mid.begins_with(id + "@"):
			out.append([str(m["from"]), str(m["to"])])
	return out


static func _punch_places(punch: String) -> Array:
	var combo_ids: Array = []
	for cid in COMBO_PUNCHES:
		if (COMBO_PUNCHES[cid] as Array).has(punch):
			combo_ids.append(cid)
	var out: Array = []
	for m in StrikeMap.MOVES:
		if str(m["kind"]) == "combo" and combo_ids.has(str(m["combo"])):
			out.append([str(m["from"]), str(m["to"])])
	return out
