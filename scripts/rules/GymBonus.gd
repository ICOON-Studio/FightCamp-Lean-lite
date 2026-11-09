extends RefCounted
## S409 each building gives the club one small edge, chosen once at career start (operator S408: "each gym slight bonus
## different from each other"). The numbers live in assets/data/gym_plans.json. Every factor here is read by a rule, so a card
## only promises what the game runs. An empty or unknown id is the first plan.
##   plan(id) -> the plan   members(id), show(id), training(id, stat) -> multipliers on the gain   days_out(id) -> on days lost

const GymPlan := preload("res://scripts/rules/GymPlan.gd")

const TRAINED := ["power", "technique"]   # what the bag wall's "training" bonus covers

static var _plans: Array = []


static func plan(id: String) -> Dictionary:
	if _plans.is_empty():
		_plans = GymPlan.load_all()
	for p in _plans:
		if str(p["id"]) == id:
			return p
	return _plans[0]


static func members(id: String) -> float:
	return 1.0 + _pct(id, "members") / 100.0


static func show(id: String) -> float:
	return 1.0 + _pct(id, "show") / 100.0


static func training(id: String, stat: String) -> float:
	return 1.0 + _pct(id, "training") / 100.0 if stat in TRAINED else 1.0


static func days_out(id: String) -> float:
	return 1.0 - _pct(id, "recovery") / 100.0


static func _pct(id: String, kind: String) -> float:
	var b: Dictionary = plan(id)["bonus"]
	return float(b["pct"]) if str(b["kind"]) == kind else 0.0
