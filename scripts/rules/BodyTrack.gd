extends RefCounted
## The body view's colours and words: Burn read like tyre temperatures.
## Pure static module — ZERO preloads.

const PARTS := ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core", "legs"]
const COLOURS := {"fresh": Color("#3fa7ff"), "warm": Color("#5ccf6a"), "hot": Color("#f2c230"), "burning": Color("#f2473a")}
const NAMES := {
	"lead_shoulder": "Jab shoulder", "rear_shoulder": "Power shoulder",
	"lead_arm": "Jab arm", "rear_arm": "Power arm",
	"core": "Body", "legs": "Legs",
}


static func band(burn: float) -> String:
	if burn < 25.0:
		return "fresh"
	if burn < 50.0:
		return "warm"
	if burn < 75.0:
		return "hot"
	return "burning"


static func colour(burn: float) -> Color:
	var fresh_c: Color = COLOURS["fresh"]
	var warm_c: Color = COLOURS["warm"]
	var hot_c: Color = COLOURS["hot"]
	var burning_c: Color = COLOURS["burning"]
	if burn <= 12.5:
		return fresh_c
	if burn >= 87.5:
		return burning_c
	if burn < 37.5:
		var t: float = (burn - 12.5) / 25.0
		return fresh_c.lerp(warm_c, t)
	if burn < 62.5:
		var t: float = (burn - 37.5) / 25.0
		return warm_c.lerp(hot_c, t)
	var t: float = (burn - 62.5) / 25.0
	return hot_c.lerp(burning_c, t)


static func body_place(part: String, southpaw: bool) -> String:
	match part:
		"lead_shoulder":
			return "right_shoulder" if southpaw else "left_shoulder"
		"rear_shoulder":
			return "left_shoulder" if southpaw else "right_shoulder"
		"lead_arm":
			return "right_arm" if southpaw else "left_arm"
		"rear_arm":
			return "left_arm" if southpaw else "right_arm"
		"core":
			return "core"
		"legs":
			return "legs"
	return part


static func pulse(prev: float, now: float) -> bool:
	if prev < 25.0 and now >= 25.0:
		return true
	if prev < 50.0 and now >= 50.0:
		return true
	if prev < 75.0 and now >= 75.0:
		return true
	return false


static func label(part: String, burn: float) -> String:
	return "%s: %s" % [NAMES[part], band(burn)]


static func worst_line(burns: Dictionary) -> String:
	var best: String = ""
	var best_v: float = -1.0
	for p in PARTS:
		var v: float = float(burns.get(p, 0.0))
		if v > best_v:
			best = p
			best_v = v
	if best_v < 50.0:
		return ""
	return "%s %s" % [NAMES[best], band(best_v)]
