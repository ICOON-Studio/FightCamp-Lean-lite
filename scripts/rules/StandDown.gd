extends RefCounted
## STANDDOWN1 (TRAINING_MAP_S432 F6, T32): after a bout, no sparring for days set by the head place it left. Pure, static;
## a stoppage keeps its suspension (make() gives {}); the spar-anyway knock reads InjuryRoll's "head" row, never typed here.

const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")

const HEAD_PER_DAMAGE := 2.2  # the same as Injuries.DAMAGE_TO_WORST
const FINE_AT := 55.0
const HURT_AT := 35.0
const DAYS := {"fine": 5, "hurt": 10, "critical": 21}
const ANYWAY_CHANCE := {"fine": 0.02, "hurt": 0.06, "critical": 0.0}  # ESTIMATE


static func head_place(damage: float) -> float:
	return clampf(100.0 - damage * HEAD_PER_DAMAGE, 0.0, 100.0)


static func band(head: float) -> String:
	if head >= FINE_AT:
		return "fine"
	if head >= HURT_AT:
		return "hurt"
	return "critical"


## Days bout_day+1 .. bout_day+DAYS[band] are locked; open_day is the first night sparring runs again.
static func make(bout_day: int, damage: float, stopped: bool) -> Dictionary:
	if stopped:
		return {}
	var head: float = head_place(damage)
	var b: String = band(head)
	return {"band": b, "damage": roundi(damage), "head": head, "open_day": bout_day + int(DAYS[b]) + 1}


static func locked(sd: Dictionary, day: int) -> bool:
	if sd.is_empty():
		return false
	return day < int(sd["open_day"])


## open_words: the caller's date words for open_day (Clock.fmt, e.g. "Thu 5 Mar").
static func reason(sd: Dictionary, open_words: String) -> String:
	if sd.is_empty():
		return ""
	return "no sparring until %s: the head took %d damage" % [open_words, int(sd["damage"])]


static func can_spar_anyway(sd: Dictionary) -> bool:
	var b: String = str(sd.get("band", ""))
	return b == "fine" or b == "hurt"


## [min, max] days out of a head knock, read from InjuryRoll.BOUT_TYPES' "head" row.
static func head_days() -> Array:
	for row in InjuryRoll.BOUT_TYPES:
		if str(row[0]) == "head":
			return [int(row[2]), int(row[3])]
	return [0, 0]


static func spar_anyway_roll(seed: int, sd: Dictionary) -> Dictionary:
	if not can_spar_anyway(sd):
		return {"knocked": false, "type": "none", "days_out": 0}
	var b: String = str(sd["band"])
	var chance: float = float(ANYWAY_CHANCE[b])
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	if rng.randf() < chance:
		var hd: Array = head_days()
		return {"knocked": true, "type": "head", "days_out": rng.randi_range(int(hd[0]), int(hd[1]))}
	return {"knocked": false, "type": "none", "days_out": 0}


## Words for the SPAR ANYWAY button.
static func price_line(sd: Dictionary) -> String:
	if not can_spar_anyway(sd):
		return ""
	var b: String = str(sd["band"])
	var chance: float = float(ANYWAY_CHANCE[b])
	var hd: Array = head_days()
	return "Spar anyway: %d in 100 of a head knock, out %d to %d days, bouts closed" % [roundi(chance * 100.0), int(hd[0]), int(hd[1])]
