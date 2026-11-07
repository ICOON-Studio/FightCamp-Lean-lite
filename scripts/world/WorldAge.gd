extends RefCounted
## Yearly tick: ages boxers, applies the career curve (rise, peak, decline), tracks damage, forecasts retirement.
## Numbers grounded in real boxing data (see assets/data/world/SOURCES.md).

const PEAK_AGE_AMATEUR := 24
const PEAK_AGE_PRO := 28
const DECLINE_START := 31
const RETIREMENT_AGE_SOFT := 38
const RETIREMENT_AGE_HARD := 42
const HARD_FIGHT_THRESHOLD := 2.0
const DAMAGE_PER_HARD_FIGHT := 0.3
const DAMAGE_PER_STOPPAGE_LOSS := 0.5
const MAX_FIGHTS_AMATEUR := 18
const MAX_FIGHTS_PRO_EARLY := 6
const MAX_FIGHTS_PRO_ESTABLISHED := 4
const MAX_FIGHTS_CHAMPION := 2


static func tick_year(boxers: Array, rng: RandomNumberGenerator) -> Dictionary:
	var retired: Array = []
	var arrived: Array = []
	for b in boxers:
		if b.get("retired", false):
			continue
		b["age"] = int(b["age"]) + 1
		_apply_rating_change(b)
		if _should_retire(b, rng):
			b["retired"] = true
			retired.append(b)
	return {"retired": retired, "arrived": arrived}


static func _apply_rating_change(b: Dictionary) -> void:
	var age := int(b["age"])
	var peak := int(b.get("peak_age", PEAK_AGE_PRO))
	var current := float(b["rating"])
	var delta := 0.0
	if age < peak:
		delta = _rise_per_year(age, peak, current)
	elif age <= DECLINE_START:
		delta = 0.0
	else:
		delta = _decline_per_year(age, b.get("damage_ledger", {}))
	b["rating"] = snappedf(maxf(40.0, current + delta), 0.5)


static func _rise_per_year(age: int, peak: int, current: float) -> float:
	var years_to_peak := float(peak - age)
	if years_to_peak <= 0.0:
		return 0.0
	var ceiling := 85.0
	var gap := ceiling - current
	return minf(1.0, gap / years_to_peak * 0.4)


static func _decline_per_year(age: int, ledger: Dictionary) -> float:
	var base_decline := -0.2
	if age > RETIREMENT_AGE_SOFT:
		base_decline = -0.5
	var damage_years := float(ledger.get("hard_fights", 0)) * DAMAGE_PER_HARD_FIGHT
	damage_years += float(ledger.get("stoppage_losses", 0)) * DAMAGE_PER_STOPPAGE_LOSS
	return base_decline - damage_years * 0.08


static func _should_retire(b: Dictionary, rng: RandomNumberGenerator) -> bool:
	var age := int(b["age"])
	if age >= RETIREMENT_AGE_HARD:
		return true
	if age >= RETIREMENT_AGE_SOFT:
		var chance := float(age - RETIREMENT_AGE_SOFT) * 0.15 + _damage_retirement_chance(b)
		return rng.randf() < chance
	if float(b.get("rating", 50.0)) < 48.0:
		return true
	return false


static func _damage_retirement_chance(b: Dictionary) -> float:
	var ledger: Dictionary = b.get("damage_ledger", {})
	var hard := float(ledger.get("hard_fights", 0))
	var stop := float(ledger.get("stoppage_losses", 0))
	return hard * 0.01 + stop * 0.02


static func fights_left_forecast(b: Dictionary) -> int:
	var age := int(b["age"])
	var peak := int(b.get("peak_age", PEAK_AGE_PRO))
	var ledger: Dictionary = b.get("damage_ledger", {})
	var remaining_years := maxf(0.0, float(RETIREMENT_AGE_SOFT - age))
	var damage_reduction := float(ledger.get("hard_fights", 0)) * DAMAGE_PER_HARD_FIGHT
	damage_reduction += float(ledger.get("stoppage_losses", 0)) * DAMAGE_PER_STOPPAGE_LOSS
	remaining_years = maxf(0.0, remaining_years - damage_reduction)
	var fights_per_year := _max_fights_per_year(b)
	return int(remaining_years * float(fights_per_year))


static func _max_fights_per_year(b: Dictionary) -> int:
	if b.get("belt", "") != "":
		return MAX_FIGHTS_CHAMPION
	var wins := int(b.get("w", 0))
	if wins < 10:
		return MAX_FIGHTS_PRO_EARLY
	return MAX_FIGHTS_PRO_ESTABLISHED


## Every bout counts once in total_fights; a close one (rating gap under HARD_FIGHT_THRESHOLD) also counts as hard.
static func record_bout(b: Dictionary, rating_gap: float) -> void:
	var ledger: Dictionary = b.get("damage_ledger", {})
	ledger["total_fights"] = int(ledger.get("total_fights", 0)) + 1
	if rating_gap < HARD_FIGHT_THRESHOLD:
		ledger["hard_fights"] = int(ledger.get("hard_fights", 0)) + 1
	b["damage_ledger"] = ledger


## A stoppage loss adds to the damage only: the bout itself was already counted by record_bout.
static func record_stoppage_loss(b: Dictionary) -> void:
	var ledger: Dictionary = b.get("damage_ledger", {})
	ledger["stoppage_losses"] = int(ledger.get("stoppage_losses", 0)) + 1
	b["damage_ledger"] = ledger


static func age_spread(boxers: Array) -> Dictionary:
	var ages: Array = []
	for b in boxers:
		if not b.get("retired", false):
			ages.append(int(b["age"]))
	if ages.is_empty():
		return {"min": 0, "max": 0, "avg": 0.0}
	ages.sort()
	var total := 0
	for a in ages:
		total += int(a)
	return {"min": ages[0], "max": ages[ages.size() - 1], "avg": float(total) / float(ages.size())}
