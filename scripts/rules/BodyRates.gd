extends RefCounted
## Per-body-part burn rates: a boxer's stats and style set how fast each part burns.
## Pure static module - no preloads, no state.

const PARTS := ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core", "legs"]
const RATE_MIN := 0.7
const RATE_MAX := 1.3

## Conditioning: every part, -0.25 at 100 / +0.25 at 0 around 50 (linear).
const COND_ALL := 0.25
## Technique (relaxed, efficient): shoulders and arms, +-0.10 around 50.
const TECH_UPPER := 0.10
## Speed (light feet): legs, +-0.08 around 50.
const SPEED_LEGS := 0.08
## Power punchers: arms +0.06 at 100 (none below 50).
const POWER_ARMS := 0.06

const STYLE := {
	"Pressure fighter": {"lead_arm": 1.08, "rear_arm": 1.08, "lead_shoulder": 1.05, "rear_shoulder": 1.05, "legs": 1.05},
	"Out-boxer": {"legs": 1.12, "lead_shoulder": 1.06},
	"Slugger": {"rear_arm": 1.10, "rear_shoulder": 1.08, "core": 1.05},
	"Counter-puncher": {"core": 1.05},
	"Boxer-puncher": {},
}


static func of(stats: Dictionary, style: String) -> Dictionary:
	var cond: float = float(stats.get("conditioning", 50.0))
	var tech: float = float(stats.get("technique", 50.0))
	var spd: float = float(stats.get("speed", 50.0))
	var pwr: float = float(stats.get("power", 50.0))

	var cond_t: float = (50.0 - cond) / 50.0 * COND_ALL
	var tech_t: float = (50.0 - tech) / 50.0 * TECH_UPPER
	var speed_t: float = (50.0 - spd) / 50.0 * SPEED_LEGS
	var power_t: float = maxf(0.0, (pwr - 50.0) / 50.0 * POWER_ARMS)

	var result: Dictionary = {}
	for p in PARTS:
		result[p] = 1.0 + cond_t

	for p in ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm"]:
		result[p] = float(result[p]) + tech_t

	result["legs"] = float(result["legs"]) + speed_t

	if pwr > 50.0:
		result["lead_arm"] = float(result["lead_arm"]) + power_t
		result["rear_arm"] = float(result["rear_arm"]) + power_t

	var row: Dictionary = STYLE.get(style, {})
	for p in PARTS:
		var mult: float = float(row.get(p, 1.0))
		result[p] = clampf(float(result[p]) * mult, RATE_MIN, RATE_MAX)

	return result


static func word(rate: float) -> String:
	if rate <= 0.85:
		return "trained"
	if rate >= 1.15:
		return "burns fast"
	return "average"
