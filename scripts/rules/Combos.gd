extends RefCounted
## Combos: the book, unlock, training, fight edge, energy.
## Pure static rules over Data.MOVES names. One preload: MoveMastery.

const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

const LEARN_AT := 30.0

const BOOK := [
	{"id": "1-1", "moves": ["Jab", "Jab"], "beats": ["jab", "jab"], "counter": false},
	{"id": "1-2", "moves": ["Jab", "Cross"], "beats": ["jab", "cross"], "counter": false},
	{"id": "1-1-2", "moves": ["Jab", "Jab", "Cross"], "beats": ["jab", "jab", "cross"], "counter": false},
	{"id": "2-3", "moves": ["Cross", "Lead hook"], "beats": ["cross", "lead_hook"], "counter": false},
	{"id": "1-2-3", "moves": ["Jab", "Cross", "Lead hook"], "beats": ["jab", "cross", "lead_hook"], "counter": false},
	{"id": "1-2-3-2", "moves": ["Jab", "Cross", "Lead hook", "Cross"], "beats": ["jab", "cross", "lead_hook", "cross"], "counter": false},
	{"id": "3b-3", "moves": ["Body hook", "Lead hook"], "beats": ["body_hook", "lead_hook"], "counter": false},
	{"id": "1-2-3b", "moves": ["Jab", "Cross", "Body hook"], "beats": ["jab", "cross", "body_hook"], "counter": false},
	{"id": "1-6-3", "moves": ["Jab", "Uppercut", "Lead hook"], "beats": ["jab", "rear_uppercut", "lead_hook"], "counter": false},
	{"id": "slip 2-3", "moves": ["Cross", "Check hook"], "beats": ["cross", "lead_hook"], "counter": true},
]

## S303 energy, calibrated on John J-COMBOENERGY1 (Godot/research/J_COMBOENERGY1_JOHN.md; sources opened S303).
## Targets at finals pace (ESTIMATE): ends rounds ~68 / 46 / 29, starts rounds 2-3 at ~78 / 61.
const TANK := 100.0
## Moving and guarding: 0.10 a second x a 3-minute round (ESTIMATE).
const ROUND_COST := 18.0
## One punch (ESTIMATE). A combination of n costs PUNCH_COST x (1 + FAST_PUNCH x (n - 1)): a punch thrown at combination
## cadence costs 1.39x (DERIVED, Arseneau 2011 bag VO2 24.7 / 30.4 / 38.3 at 60 / 120 / 180 a minute).
const PUNCH_COST := 0.22
const FAST_PUNCH := 1.39
## Rear-hand punches and hooks cost 1.1x; about half her punches are those (ESTIMATE) -> 1.05 on the mix.
const POWER_MIX := 1.05
## Punches a round: women's 2023 world finals winners 19.3 / 16.8 / 18.1 a minute (MEASURED, Martusciello 2025a) x 3 min.
const PUNCHES := 54.0
## Of what she spends, 60% comes back fast and 40% not inside the fight; the minute's rest refills 52% of the fast part
## (DERIVED, Bogdanis 1995 phosphocreatine half-time 56.6 s), x her fitness 0.8 .. 1.2 (ESTIMATE).
const QUICK_SHARE := 0.6
const QUICK_REFILL := 0.52
## Force, speed, accuracy and combination timing hold down to 20 (MEASURED: Smith 2006, Hukkanen 2017, Martusciello 2025a);
## under it crosses and hooks lose force and combinations stretch 10% (ESTIMATE). From 70 to 30 she throws fewer punches
## and her combinations get ~30% shorter (ESTIMATE); WEARY_AT is where it shows (a tired beat, a combination left unfinished).
const TIRED_AT := 20.0
const WEARY_AT := 40.0
const FRESH_AT := 70.0


static func row(id: String) -> Dictionary:
	for b in BOOK:
		if str(b["id"]) == id:
			return b
	return {}


static func unlocked(moves: Dictionary) -> Array:
	var out: Array = []
	for b in BOOK:
		var ok := true
		for m in b["moves"]:
			if float(moves.get(str(m), 0.0)) < LEARN_AT:
				ok = false
				break
		if ok:
			out.append(str(b["id"]))
	return out


static func missing(id: String, moves: Dictionary) -> Array:
	var r := row(id)
	if r.is_empty():
		return []
	var out: Array = []
	for m in r["moves"]:
		if float(moves.get(str(m), 0.0)) < LEARN_AT:
			out.append(str(m))
	return out


## The combo's ceiling: her technique / ring IQ cap (MoveMastery.cap), and never sharper than its weakest punch.
static func cap(id: String, moves: Dictionary, technique: float, ring_iq: float) -> float:
	var r := row(id)
	if r.is_empty():
		return 0.0
	var lowest := 100.0
	for m in r["moves"]:
		lowest = minf(lowest, float(moves.get(str(m), 0.0)))
	return minf(MoveMastery.cap(technique, ring_iq), lowest)


static func drill(m: float, id: String, minutes: float, coach_skill: float, station_tier: int, cap_value: float) -> float:
	var r := row(id)
	if r.is_empty():
		return m
	var n := float(r["moves"].size())
	return MoveMastery.gain(m, "pads", minutes * 2.0 / n, coach_skill, station_tier, 1.0, cap_value)


static func fade(m: float, drilled: bool) -> float:
	return MoveMastery.decay_week(m, drilled)


static func next_to_learn(moves: Dictionary, combos: Dictionary) -> String:
	var best_id := ""
	var best_m := LEARN_AT
	var best_len := 999
	for i in BOOK.size():
		var b: Dictionary = BOOK[i]
		var bid := str(b["id"])
		var ok := true
		for m in b["moves"]:
			if float(moves.get(str(m), 0.0)) < LEARN_AT:
				ok = false
				break
		if not ok:
			continue
		var cm := float(combos.get(bid, 0.0))
		if cm >= LEARN_AT:
			continue
		var cl := int(b["moves"].size())
		if cm < best_m or (cm == best_m and cl < best_len):
			best_id = bid
			best_m = cm
			best_len = cl
	return best_id


static func edge(combos: Dictionary, energy: float) -> float:
	var total := 0.0
	for id in combos.keys():
		var m := float(combos[id])
		if m >= 85.0:
			total += 0.30
		elif m >= 60.0:
			total += 0.20
		elif m >= 30.0:
			total += 0.12
	total = minf(total, 0.6)
	return total * energy_scale(energy)


static func pick(combos: Dictionary, max_len: int, roll: float) -> Dictionary:
	var eligible: Array = []
	var weights: Array = []
	var total := 0.0
	for b in BOOK:
		var bid := str(b["id"])
		var m := float(combos.get(bid, 0.0))
		if m < LEARN_AT:
			continue
		if int(b["moves"].size()) > max_len:
			continue
		eligible.append(b)
		weights.append(m)
		total += m
	if total <= 0.0:
		return {}
	var threshold := roll * total
	var accum := 0.0
	for i in eligible.size():
		accum += float(weights[i])
		if accum > threshold:
			return eligible[i]
	return eligible[eligible.size() - 1]


static func interval(m: float, same_hand: bool, energy: float) -> float:
	var t := lerpf(0.45, 0.30, clampf(m / 100.0, 0.0, 1.0))
	if same_hand:
		t += 0.10
	if energy < TIRED_AT:
		t *= 1.10
	return t


static func opponent_combos(opp: Dictionary) -> Dictionary:
	var style := str(opp.get("style", ""))
	var base := {"1-2": 45}
	match style:
		"Out-boxer":
			base = {"1-1": 55, "1-2": 50}
		"Pressure fighter":
			base = {"1-2-3": 50, "3b-3": 45}
		"Counter-puncher":
			base = {"slip 2-3": 55, "1-2": 45}
		"Slugger":
			base = {"2-3": 55, "1-2-3b": 40}
	var words := (str(opp.get("threat", "")) + " " + str(opp.get("weak", ""))).to_lower()
	if words.contains("double") or words.contains("doubles the jab"):
		base["1-1"] = 60
	if words.contains("body"):
		base["3b-3"] = 50
	if words.contains("left hook") or words.contains("hook"):
		base["2-3"] = 50
	return base


static func describe(id: String, m: float) -> String:
	var word := MoveMastery.tier(m)
	word = word.substr(0, 1) + word.substr(1).to_lower()
	return "%s %s (M%d)" % [word, id, roundi(m)]


static func combo_cost(length: int) -> float:
	return PUNCH_COST * (1.0 + FAST_PUNCH * float(maxi(0, length - 1)))


static func uses(combos: Dictionary, corner: String) -> int:
	var count := 0
	for id in combos.keys():
		if float(combos[id]) >= LEARN_AT:
			count += 1
	var u := 2.0 + 1.5 * float(count)
	if corner == "calm":
		u *= 0.7
	elif corner == "body":
		u *= 1.2
	return int(minf(u, 8.0))


static func round_spend(combos: Dictionary, corner: String, conditioning: float) -> float:
	var u := uses(combos, corner)
	var total_len := 0
	var usable_count := 0
	for b in BOOK:
		var bid := str(b["id"])
		if float(combos.get(bid, 0.0)) >= LEARN_AT:
			total_len += int(b["moves"].size())
			usable_count += 1
	var avg_len := 2
	if usable_count > 0:
		avg_len = roundi(float(total_len) / float(usable_count))
	# The corner's call sets the work rate: "calm" throws less, "body" digs more (ESTIMATE).
	var punches := PUNCHES * (0.8 if corner == "calm" else (1.15 if corner == "body" else 1.0))
	var in_combos := minf(punches, float(u * avg_len))
	var punch_part := (float(u) * combo_cost(avg_len) + (punches - in_combos) * PUNCH_COST) * POWER_MIX
	return (ROUND_COST + punch_part) * spend_factor(conditioning)


## Fitter boxers work at a lower share of their peak (Arseneau 2011: sparring 70% VO2peak): conditioning 50 = 1.0,
## 100 = 0.8, 0 = 1.2 (ESTIMATE).
static func spend_factor(conditioning: float) -> float:
	return 1.2 - 0.4 * clampf(conditioning, 0.0, 100.0) / 100.0


## The minute's rest refills QUICK_REFILL of her fast debt x fitness 0.8 .. 1.2; the slow part stays spent.
static func refill(quick_debt: float, conditioning: float) -> float:
	return quick_debt * QUICK_REFILL * (0.8 + 0.4 * clampf(conditioning, 0.0, 100.0) / 100.0)


## One round and the rest after it: {energy at the bell, energy after the rest, fast debt carried}.
static func after_round(energy: float, quick_debt: float, spend: float, conditioning: float) -> Dictionary:
	var at_bell := maxf(0.0, energy - spend)
	var debt := quick_debt + QUICK_SHARE * (energy - at_bell)
	var back := refill(debt, conditioning)
	return {"bell": at_bell, "next": minf(TANK, at_bell + back), "debt": debt - back}


## Her combination edge shrinks ~30% from FRESH_AT to WEARY_AT - 10 (shorter combinations; accuracy holds).
static func energy_scale(energy: float) -> float:
	return 1.0 - 0.3 * clampf((FRESH_AT - energy) / (FRESH_AT - 30.0), 0.0, 1.0)


## Under TIRED_AT crosses and hooks lose force (power points off the round, ESTIMATE).
static func tired_penalty(energy: float) -> float:
	if energy >= TIRED_AT:
		return 0.0
	return minf((TIRED_AT - energy) * 0.05, 1.0)


## Her longest run: the speed cap, ~30% shorter by energy 30.
static func max_len(energy: float, speed_cap: int) -> int:
	return maxi(1, mini(speed_cap, roundi(float(speed_cap) * energy_scale(energy))))


## Chance she leaves a started combination unfinished: none above WEARY_AT, up to half when empty (ESTIMATE; Kalli's
## "runs out of gas" lines caption it).
static func cut_chance(energy: float) -> float:
	return clampf((WEARY_AT - energy) / WEARY_AT, 0.0, 0.5)
