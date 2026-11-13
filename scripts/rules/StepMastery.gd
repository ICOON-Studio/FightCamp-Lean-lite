extends RefCounted
## StepMastery: pure rules for the 10 step/defence mastery bars (STEPMASTERY1A).
## Reads MoveMastery for the gain formula; nothing else. No state, no UI.

const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

const NODES: Array = [
	"step_in", "step_out", "step_back", "pivot_out", "cut_off", "herd", "feint",
	"tie_up", "roll_out", "push_off",
]

const NAMES := {
	"step_in": "Step in",
	"step_out": "Step out",
	"step_back": "Step back",
	"pivot_out": "Pivot off the ropes",
	"cut_off": "Cut off the ring",
	"herd": "Herd into the corner",
	"feint": "Feint and draw",
	"tie_up": "Tie up",
	"roll_out": "Roll under and out",
	"push_off": "Push off",
}


## A newly signed fighter: step_in and step_out = max(30, 0.55 x footwork);
## every other node 0. Every NODES id present.
static func start_values(footwork: float) -> Dictionary:
	var base: float = maxf(30.0, 0.55 * footwork)
	var out: Dictionary = {}
	for id in NODES:
		if id == "step_in" or id == "step_out":
			out[id] = base
		else:
			out[id] = 0.0
	return out


## Old save with no step bars: a node whose id is in plan_arrows starts at 60,
## any other at 30. Strip place suffix ("tie_up@own_ropes" -> "tie_up") first.
static func from_old_save(plan_arrows: Array) -> Dictionary:
	var lit: Dictionary = {}
	for raw in plan_arrows:
		var base_id: String = str(raw).split("@")[0]
		lit[base_id] = true
	var out: Dictionary = {}
	for id in NODES:
		if lit.has(id):
			out[id] = 60.0
		else:
			out[id] = 30.0
	return out


## Shadow morning, own chain or pad night may drill a node only if it is the
## slot's move or it is already at 30+.
static func drillable(id: String, m: float, slot_id: String) -> bool:
	return id == slot_id or m >= 30.0


## Shadow morning gain: MoveMastery.gain with station "shadowbox" (0.85/hr),
## station_tier 1.0, efficiency 1.0, minutes = hours * 60.
static func shadow_gain(m: float, hours: float, coach_skill: float, cap_value: float) -> float:
	return MoveMastery.gain(m, "shadowbox", hours * 60.0, coach_skill, 1.0, 1.0, cap_value)


## Nights until the node reaches 30 (usable). 0 at 30+, -1 when gain <= 0.
static func nights_to_usable(m: float, gain_per_night: float) -> int:
	if gain_per_night <= 0.0:
		return -1
	if m >= 30.0:
		return 0
	return ceili((30.0 - m) / gain_per_night)


## The grey line under 30: "<Name>: learning, <n> pad nights" (singular "1 pad night").
## "" at 30+. gain_per_night <= 0 -> "<Name>: learning, needs pad nights".
static func grey_reason(id: String, m: float, gain_per_night: float) -> String:
	if m >= 30.0:
		return ""
	var name: String = str(NAMES[id])
	if gain_per_night <= 0.0:
		return name + ": learning, needs pad nights"
	var n: int = nights_to_usable(m, gain_per_night)
	if n == 1:
		return name + ": learning, 1 pad night"
	return name + ": learning, " + str(n) + " pad nights"


## The mastery FireLevel reads for a step/defence arrow: strip "@...",
## return bars[id] if present, else 100.0 (no bars fires as today).
static func fire_mastery(bars: Dictionary, arrow: String) -> float:
	var base_id: String = arrow.split("@")[0]
	if bars.has(base_id):
		return float(bars[base_id])
	return 100.0
