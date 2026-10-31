extends RefCounted
## Real-world numbers (research S323): competition injury 6.8 per 1000 bout-minutes -> ~6 % a 3x3 bout, 72 % head/neck,
## cuts 20 % (Alevras 2022 meta-analysis); training 1.3 per 1000 h -> ~1.3 % a 10 h week; ~33 days lost per injury
## (Loosemore 2015); load this week vs 4-week average >= 1.5 = 2-4x risk (Gabbett 2016); England Boxing KO rule 4.1.2.

const BOUT_BASE := 0.06
const TRAIN_BASE_10H := 0.013
const SAFE_RATIO := 1.3
const SPIKE_RATIO := 1.5
const SPIKE_MULT := 3.0
const KO_DAYS := 30
const KO_SECOND_WINDOW := 90
const KO_SECOND_DAYS := 90
const KO_THIRD_WINDOW := 365
const KO_THIRD_DAYS := 365
const FACE_CUT_LINE := 35.0
const BOUT_TYPES := [["cut", 20, 14, 21], ["nose", 15, 21, 35], ["head", 37, 21, 35], ["hand", 18, 35, 56], ["ribs", 10, 21, 35]]
const TRAIN_TYPES := [["hand", 40, 14, 28], ["ribs", 30, 14, 21], ["strain", 30, 7, 14]]
const NAMES := {"cut": "Cut", "nose": "Broken nose", "head": "Head knock", "hand": "Hand injury", "ribs": "Rib injury", "strain": "Strain"}


static func bout_chance(damage: Dictionary) -> float:
	var places: Dictionary = damage.get("places", {})
	var worst: float = 100.0
	for key in places:
		var v: float = float(places[key])
		if v < worst:
			worst = v
	var rounds: int = int(damage.get("rounds", 3))
	var s: float = (100.0 - worst) / 100.0
	var chance: float = BOUT_BASE * (float(rounds) / 3.0) * (0.4 + 1.2 * s)
	return clampf(chance, 0.0, 0.4)


static func ko_days(history: Array, day: int) -> int:
	var third: int = 0
	var second: int = 0
	for h in history:
		var hd: int = int(h)
		var diff: int = day - hd
		if diff >= 0 and diff <= KO_THIRD_WINDOW:
			third += 1
			if diff <= KO_SECOND_WINDOW:
				second += 1
	if third >= 2:
		return KO_THIRD_DAYS
	if second >= 1:
		return KO_SECOND_DAYS
	return KO_DAYS


static func bout_roll(seed: int, damage: Dictionary) -> Dictionary:
	if damage.get("head_stoppage", false):
		var hist: Array = damage.get("ko_history", [])
		var day: int = int(damage.get("day", 0))
		return {"injured": true, "type": "ko", "days_out": ko_days(hist, day)}
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var chance: float = bout_chance(damage)
	if rng.randf() >= chance:
		return {"injured": false, "type": "none", "days_out": 0}
	var places: Dictionary = damage.get("places", {})
	var face_cut: bool = false
	for fp in ["left_eye", "right_eye", "nose"]:
		if places.has(fp) and float(places[fp]) <= FACE_CUT_LINE:
			face_cut = true
	var total: int = 0
	for t in BOUT_TYPES:
		var w: int = int(t[1])
		if t[0] == "cut" and face_cut:
			w *= 2
		total += w
	var roll: float = rng.randf() * float(total)
	var accum: int = 0
	var chosen: Array = BOUT_TYPES[0]
	for t in BOUT_TYPES:
		var w: int = int(t[1])
		if t[0] == "cut" and face_cut:
			w *= 2
		accum += w
		if roll < float(accum):
			chosen = t
			break
	var days: int = rng.randi_range(int(chosen[2]), int(chosen[3]))
	return {"injured": true, "type": str(chosen[0]), "days_out": days}


static func load_ratio(this_week: float, last4: Array) -> float:
	if last4.is_empty():
		return 1.0
	var total: float = 0.0
	for w in last4:
		total += float(w)
	var avg: float = total / float(last4.size())
	if avg <= 0.0:
		return 1.0
	return this_week / avg


static func load_mult(ratio: float) -> float:
	if ratio <= SAFE_RATIO:
		return 1.0
	if ratio >= SPIKE_RATIO:
		return SPIKE_MULT
	return 1.0 + (ratio - SAFE_RATIO) / (SPIKE_RATIO - SAFE_RATIO) * (SPIKE_MULT - 1.0)


static func training_chance(hours: float, ratio: float) -> float:
	var chance: float = TRAIN_BASE_10H * hours / 10.0 * load_mult(ratio)
	return clampf(chance, 0.0, 0.3)


static func training_roll(seed: int, hours: float, ratio: float) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var chance: float = training_chance(hours, ratio)
	if rng.randf() >= chance:
		return {"injured": false, "type": "none", "days_out": 0}
	var total: int = 0
	for t in TRAIN_TYPES:
		total += int(t[1])
	var roll: float = rng.randf() * float(total)
	var accum: int = 0
	var chosen: Array = TRAIN_TYPES[0]
	for t in TRAIN_TYPES:
		accum += int(t[1])
		if roll < float(accum):
			chosen = t
			break
	var days: int = rng.randi_range(int(chosen[2]), int(chosen[3]))
	return {"injured": true, "type": str(chosen[0]), "days_out": days}


static func weeks_out(days: int) -> int:
	if days <= 0:
		return 0
	return int(ceil(float(days) / 7.0))


static func line(inj: Dictionary) -> String:
	var t: String = str(inj.get("type", "none"))
	if t == "ko":
		return "Suspended %d days (stopped to the head)" % int(inj["days_out"])
	if t == "none":
		return "No injuries"
	var w: int = weeks_out(int(inj["days_out"]))
	var ws: String = "1 week" if w == 1 else "%d weeks" % w
	return "%s - out %s" % [str(NAMES[t]), ws]
