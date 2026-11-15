extends RefCounted
## Coached mornings and the weak spot: pure club-week rules (MORNINGS1).
## Owner Q-S294-241: "Yes, build it after the fight week".
## Map: DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md sections 3.5 and 3.3 (WEAK SPOT).
## Multipliers and morning pads rate are ESTIMATE design values for the probe to check.
## owned(coach_kind): count the week's player-owned and coach-owned mornings.
## mult(use, on_weak): multiply a normal stat morning's gain.
## pads_rate(): rate of a morning pad turn, separate from stat gain.
## weak_spot(stats): lowest fight ability at least three below the six-ability mean.
## weak_line(stats): describe that hole and the opponents who find it.
## deal(asks, coach_kind): allocate mornings in priority order, pairing shared drills.
## added(dealt): total extra stat gain in morning-equivalents.

const SOLO := 1.25
const SOLO_WEAK := 1.4
const SHARED := 1.15
const MORNING_PADS := 0.8
const NOT_COACHED := 1.0
const YOU_OWNED := 4
const COACH_OWNED := {"sessional": 2, "full_time": 3, "none": 0}
const FIGHT_ABILITIES := ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]
const WEAK_GAP := 3.0
const FINDS := {
	"defense": "pressure fighters", "conditioning": "volume punchers",
	"fight_iq": "counter-punchers", "speed": "out-boxers",
	"power": "sluggers", "technique": "counter-punchers",
}
const WORDS := {
	"power": "Power", "speed": "Speed", "technique": "Technique",
	"defense": "Defence", "conditioning": "Cardio", "fight_iq": "Ring IQ",
}


static func owned(coach_kind: String) -> int:
	return YOU_OWNED + int(COACH_OWNED.get(coach_kind, 0))


static func mult(use: String, on_weak: bool) -> float:
	match use:
		"solo":
			return SOLO_WEAK if on_weak else SOLO
		"shared":
			return SHARED
	return NOT_COACHED


static func pads_rate() -> float:
	return MORNING_PADS


static func weak_spot(stats: Dictionary) -> String:
	var total := 0.0
	var lowest := INF
	var lowest_id := ""
	for ability in FIGHT_ABILITIES:
		var value := float(stats.get(ability, 0.0))
		total += value
		if value < lowest:
			lowest = value
			lowest_id = ability
	return lowest_id if total / FIGHT_ABILITIES.size() - lowest >= WEAK_GAP else ""


static func weak_line(stats: Dictionary) -> String:
	var ability := weak_spot(stats)
	if ability == "":
		return ""
	return "Low %s: %s find it" % [WORDS[ability], FINDS[ability]]


static func deal(asks: Array, coach_kind: String) -> Array:
	var left := owned(coach_kind)
	var paired := {}
	var dealt: Array = []
	for i in range(asks.size()):
		var ask: Dictionary = asks[i]
		var ability := str(ask.get("ability", ""))
		var use := "none"
		# A reserved partner is already paid for, even if the budget is now empty.
		if paired.has(i):
			use = "shared"
		elif left > 0:
			var requested := str(ask.get("use", "none"))
			if requested == "shared":
				use = "solo"
				for j in range(i + 1, asks.size()):
					var candidate: Dictionary = asks[j]
					if not paired.has(j) and str(candidate.get("use", "")) == "shared" and str(candidate.get("ability", "")) == ability:
						paired[j] = true
						use = "shared"
						break
			elif requested == "solo" or requested == "pads":
				use = requested
			if use != "none":
				left -= 1
		var gain := pads_rate() if use == "pads" else mult(use, bool(ask.get("weak", false)))
		dealt.append({"id": str(ask.get("id", "")), "ability": ability, "use": use, "mult": gain})
	return dealt


static func added(dealt: Array) -> float:
	var extra := 0.0
	for row in dealt:
		if row.get("use", "none") in ["solo", "shared"]:
			extra += float(row.get("mult", NOT_COACHED)) - 1.0
	return extra
