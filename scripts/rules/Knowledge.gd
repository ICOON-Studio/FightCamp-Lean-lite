extends RefCounted
## KNOW1 - What the player can see of a boxer, and the range never lies (S411, Q-S294-139).
## Pure static; preloads only Attrs.gd for the attribute keys. No he or she anywhere.

const Attrs := preload("res://scripts/rules/Attrs.gd")

# Starting half-ranges (G).
const BODY_START := 8.0   # G
const SKILLS_START := 12.0  # G
const FIRE_START := 25.0  # G
const FLOOR := 0.5  # G
const HALF := 12.0  # G
const FIRE_SPAR_CAP := 12.5  # G - exposure at which fire width = half of FIRE_START

# Group membership.
const BODY_ATTRS: Array[String] = ["strength", "explosiveness", "speed", "stamina", "recovery", "flexibility"]
const SKILLS_ATTRS: Array[String] = ["accuracy", "timing", "defence", "footwork", "inside", "fight_iq"]
const FIRE_ATTRS: Array[String] = ["durability", "composure", "heart"]
const GROUPS: Dictionary = {
	"body": BODY_ATTRS,
	"skills": SKILLS_ATTRS,
	"fire": FIRE_ATTRS,
}

# Offset bounds.
const OFFSET_LO := -0.6
const OFFSET_HI := 0.6
const HYPE_MAX_LIFT := 0.3
const HYPE_CEIL := 0.9


## Nothing seen yet.
static func fresh(seed: int) -> Dictionary:
	return {"seed": seed, "seen_all": false, "body": 0.0, "skills": 0.0, "fire_spar": 0.0, "fire_bout": 0.0}


## Seen all - for old saves and boxers already at the club.
static func all_seen() -> Dictionary:
	return {"seed": 0, "seen_all": true, "body": 0.0, "skills": 0.0, "fire_spar": 0.0, "fire_bout": 0.0}


## Which group an attribute belongs to. "" for anything not in GROUPS.
static func group_of(attr: String) -> String:
	for g in GROUPS:
		if (GROUPS[g] as Array).has(attr):
			return g
	return ""


## Half the range in attribute points for a group given the knowledge dict.
static func width(k: Dictionary, group: String) -> float:
	if k.get("seen_all", false):
		return 0.0
	var start: float = _start_of(group)
	if start <= 0.0:
		return 0.0
	var exposure: float = _effective_exposure(k, group)
	return FLOOR + (start - FLOOR) / (1.0 + exposure / HALF)


## Add exposure to a group. Kind is "session", "test", "spar" or "bout".
## Group fire takes only "spar" (to fire_spar) and "bout" (to fire_bout).
## Negative amounts do nothing.
static func expose(k: Dictionary, group: String, amount: float, kind: String) -> void:
	if amount < 0.0:
		return
	if group == "fire":
		if kind == "spar":
			k["fire_spar"] = float(k.get("fire_spar", 0.0)) + amount
		elif kind == "bout":
			k["fire_bout"] = float(k.get("fire_bout", 0.0)) + amount
	elif group == "body":
		if kind == "session" or kind == "test":
			k["body"] = float(k.get("body", 0.0)) + amount
	elif group == "skills":
		if kind == "session" or kind == "test" or kind == "spar":
			k["skills"] = float(k.get("skills", 0.0)) + amount


## The range {lo, hi, centre, width} for an attribute given the truth.
## An attribute outside GROUPS has width 0 (always exact).
static func range_of(k: Dictionary, attr: String, truth: float, hype: float = 0.0) -> Dictionary:
	var w: float = _attr_width(k, attr)
	if w <= 0.0:
		return {"lo": truth, "hi": truth, "centre": truth, "width": 0.0}
	var offset: float = _offset(k, attr)
	# Hype lifts the offset, capped at HYPE_CEIL.
	var lifted: float = minf(offset + clampf(hype, 0.0, 1.0) * HYPE_MAX_LIFT, HYPE_CEIL)
	var centre: float = truth + lifted * w
	var lo: float = clampf(truth + (lifted - 1.0) * w, 0.0, 100.0)
	var hi: float = clampf(truth + (lifted + 1.0) * w, 0.0, 100.0)
	return {"lo": lo, "hi": hi, "centre": centre, "width": w}


## Stale: knockout, layoff, step_up cut fire to 60%; ageing to 85%.
## Body and skills do not go stale. A seen_all boxer is unchanged.
static func stale(k: Dictionary, why: String) -> void:
	if k.get("seen_all", false):
		return
	var factor: float = 0.0
	if why == "knockout" or why == "layoff" or why == "step_up":
		factor = 0.6
	elif why == "ageing":
		factor = 0.85
	else:
		return
	k["fire_spar"] = float(k.get("fire_spar", 0.0)) * factor
	k["fire_bout"] = float(k.get("fire_bout", 0.0)) * factor


# --- internal ---

static func _start_of(group: String) -> float:
	if group == "body":
		return BODY_START
	elif group == "skills":
		return SKILLS_START
	elif group == "fire":
		return FIRE_START
	return 0.0


static func _effective_exposure(k: Dictionary, group: String) -> float:
	if group == "fire":
		var spar: float = float(k.get("fire_spar", 0.0))
		var bout: float = float(k.get("fire_bout", 0.0))
		return bout + minf(spar, FIRE_SPAR_CAP)
	elif group == "body":
		return float(k.get("body", 0.0))
	elif group == "skills":
		return float(k.get("skills", 0.0))
	return 0.0


static func _attr_width(k: Dictionary, attr: String) -> float:
	var g: String = group_of(attr)
	if g == "":
		return 0.0
	return width(k, g)


## Fixed offset per boxer and attribute, in -0.6..0.6.
## Uses absi(h) % 10001 for stability across engine versions.
static func _offset(k: Dictionary, attr: String) -> float:
	var seed: int = int(k.get("seed", 0))
	var h: int = hash([seed, attr])
	var bucket: int = absi(h) % 10001
	# Scale bucket (0..10000) to -0.6..0.6
	return float(bucket) / 10000.0 * (OFFSET_HI - OFFSET_LO) + OFFSET_LO
