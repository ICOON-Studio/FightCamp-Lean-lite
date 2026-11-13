extends RefCounted
## COACHMARKET1 - the assistant coach market: four coaches, growth, the second slot,
## the Signature rate, letting go. Pure static; preloads Data, LearnSlots and MoveTree only.

const Data := preload("res://scripts/state/Data.gd")
const LearnSlots := preload("res://scripts/rules/LearnSlots.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")

const MAX_HIRED := 2

const NEW_COACHES: Array[Dictionary] = [
	{"id": "price", "name": "Jamie Price", "kind": "Sessional assistant coach", "salary": 380, "rating": 53, "spec": "Pad work",
		"note": "young, three evenings a week",
		"areas": {"pads": 60, "bag": 56, "sparring": 55, "conditioning": 50, "strength": 44}},
	{"id": "mendez", "name": "Rosa Mendez", "kind": "Sessional assistant coach", "salary": 520, "rating": 60, "spec": "Footwork",
		"note": "three evenings a week",
		"areas": {"pads": 62, "bag": 58, "sparring": 72, "conditioning": 60, "strength": 48}},
]

const GROWTH: Dictionary = {
	"reid": {"pads": [10, 82]},
	"hale": {"pads": [10, 70]},
	"price": {"pads": [8, 72]},
	"mendez": {"pads": [10, 68]},
}

const FOOTWORK_MULT := 1.2
const SIGNATURE_DRILL_SESSIONS := 40
const SIGNATURE_DRILL_MULT := 1.2

static func market() -> Array:
	var out: Array = []
	for c in Data.COACHES:
		out.append(c.duplicate(true))
	for c in NEW_COACHES:
		out.append(c.duplicate(true))
	return out

static func coach(id: String) -> Dictionary:
	for c in market():
		if c["id"] == id:
			return c
	return {}

static func can_hire(hired: Array, id: String) -> bool:
	if coach(id).is_empty():
		return false
	if hired.has(id):
		return false
	if hired.size() >= MAX_HIRED:
		return false
	return true

static func area_now(id: String, area: String, sessions: int) -> float:
	var c: Dictionary = coach(id)
	if c.is_empty():
		return 0.0
	var areas: Dictionary = c["areas"]
	var start: float = float(areas.get(area, 0))
	var g: Dictionary = GROWTH.get(id, {})
	if not g.has(area):
		return start
	var params: Array = g.get(area)
	var per: int = int(params[0])
	var ceiling: float = float(params[1])
	return minf(start + floori(float(sessions) / float(per)), ceiling)

static func sessions_to(id: String, area: String, target: float, sessions: int) -> int:
	var c: Dictionary = coach(id)
	if c.is_empty():
		return -1
	var g: Dictionary = GROWTH.get(id, {})
	if not g.has(area):
		return -1
	var params: Array = g.get(area)
	var per: int = int(params[0])
	var ceiling: float = float(params[1])
	if target > ceiling:
		return -1
	var areas: Dictionary = c["areas"]
	var start: float = float(areas.get(area, 0))
	var cur: float = area_now(id, area, sessions)
	if cur >= target:
		return 0
	var diff: int = int(target) - int(start)
	var total: int = diff * per
	return total - sessions

static func second_slot(id: String, sessions: int) -> bool:
	return LearnSlots.slots(area_now(id, "pads", sessions)) == 2

static func signature_rate(pads: float) -> float:
	return clampf((pads - 55.0) / 20.0, 0.25, 1.0)

static func node_mult(id: String, node_id: String, move_sessions: int) -> float:
	var m: float = 1.0
	if id == "mendez" and MoveTree.STEP_IDS.has(node_id):
		m *= FOOTWORK_MULT
	if move_sessions >= SIGNATURE_DRILL_SESSIONS:
		m *= SIGNATURE_DRILL_MULT
	return m

static func let_go(id: String) -> Dictionary:
	var c: Dictionary = coach(id)
	return {"cost": int(c.get("salary", 0)), "keeps_growth": true}

static func milestone(id: String, sessions: int) -> String:
	const roles: Dictionary = {
		"price": "The young coach",
		"mendez": "The footwork coach",
		"reid": "The pads coach",
		"hale": "The conditioning coach",
	}
	var role: String = roles.get(id, "")
	var pads: float = area_now(id, "pads", sessions)
	var g: Dictionary = GROWTH.get(id, {})
	var ceiling: int = 0
	if g.has("pads"):
		var params: Array = g.get("pads")
		ceiling = int(params[1])
	if pads >= float(ceiling):
		return ""
	if pads < 65.0:
		var need: int = sessions_to(id, "pads", 65.0, sessions)
		return role + ": " + str(need) + " pad sessions to 65: second slots"
	var need: int = sessions_to(id, "pads", float(ceiling), sessions)
	return role + ": " + str(need) + " pad sessions to " + str(ceiling) + ": top pads"
