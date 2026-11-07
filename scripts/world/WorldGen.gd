extends RefCounted
## Generates a living world of boxers: names, clubs, ages, records, ratings. Seeded so the same seed gives the same world.
## Reads data from assets/data/world/ JSON files. Each boxer is a Dictionary matching the opponent shape the fight reads.

const WR := preload("res://scripts/world/WorldRank.gd")

const STANCES := ["orthodox", "southpaw"]
const STYLES := [
	{"style": "Pressure fighter", "threat": "Body hooks in close", "weak": "Walks in straight"},
	{"style": "Counter-puncher", "threat": "Right hand counter over the jab", "weak": "Slow to start"},
	{"style": "Volume puncher", "threat": "Never stops throwing", "weak": "Leaves the chin open"},
	{"style": "Boxer-puncher", "threat": "Straight right", "weak": "Stands still after combinations"},
	{"style": "Out-boxer", "threat": "A long jab to live behind", "weak": "Struggles when backed up"},
	{"style": "Swarmer", "threat": "Left hook to the body", "weak": "Fades after round 2"},
]
const RANKED_PER_DIVISION := 20
const UNRANKED_PER_DIVISION := 15

var _data_cache: Dictionary = {}
var _next_id := 1


static func generate(seed_value: int) -> Dictionary:
	var gen := preload("res://scripts/world/WorldGen.gd").new()
	return gen._build_world(seed_value)


static func load_json(path: String) -> Variant:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return null
	var text := f.get_as_text()
	return JSON.parse_string(text)


func _build_world(seed_value: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	_load_data()
	var world := {"divisions": {}, "boxers": [], "next_id": 1}
	for div in _data_cache["divisions"]:
		var div_id: String = div["id"]
		var div_boxers: Array = _generate_division(rng, div, seed_value)
		var orgs := _pick_belt_orgs(rng)
		_crown_champions(div_boxers, orgs)
		world["divisions"][div_id] = {"info": div, "boxers": div_boxers, "belt_orgs": orgs}
		world["boxers"].append_array(div_boxers)
	world["next_id"] = _next_id
	return world


## One sanctioning body per belt level in each division, so a belt string reads "<abbr>_<level>".
func _pick_belt_orgs(rng: RandomNumberGenerator) -> Dictionary:
	var orgs := {}
	for lv in _data_cache["belt_levels"]:
		var pool: Array = lv["organisations"]
		orgs[str(lv["level"])] = str(pool[rng.randi_range(0, pool.size() - 1)]["abbr"])
	return orgs


## A new world starts with every belt held: the world title by the number one, then continental, national, area down the table.
func _crown_champions(div_boxers: Array, orgs: Dictionary) -> void:
	var levels: Array = WR.BELT_LEVELS.duplicate()
	levels.reverse()
	for i in levels.size():
		for b in div_boxers:
			if int(b["rank"]) == i + 1:
				WR.award_belt(b, levels[i], str(orgs[levels[i]]))


func _load_data() -> void:
	if not _data_cache.is_empty():
		return
	_data_cache["first_names"] = load_json("res://assets/data/world/first_names.json")
	_data_cache["surnames"] = load_json("res://assets/data/world/surnames.json")
	_data_cache["clubs"] = load_json("res://assets/data/world/clubs.json")
	_data_cache["divisions"] = load_json("res://assets/data/world/divisions.json")["divisions"]
	_data_cache["belt_levels"] = load_json("res://assets/data/world/organizations.json")["belt_levels"]


func _generate_division(rng: RandomNumberGenerator, div: Dictionary, base_seed: int) -> Array:
	var sex: String = div["sex"]
	var total := RANKED_PER_DIVISION + UNRANKED_PER_DIVISION
	var firsts: Array = _pick_names(rng, sex, total)
	var lasts: Array = _pick_surnames(rng, total)
	var clubs: Array = _pick_clubs(rng, total)
	var boxers: Array = []
	for i in total:
		var is_ranked := i < RANKED_PER_DIVISION
		var b := _make_boxer(rng, firsts[i], lasts[i], clubs[i], sex, div["id"], is_ranked, base_seed + i)
		b["rank"] = i + 1 if is_ranked else 0
		boxers.append(b)
	return boxers


func _pick_names(rng: RandomNumberGenerator, sex: String, count: int) -> Array:
	var pool: Array = _data_cache["first_names"][sex] if sex in _data_cache["first_names"] else _data_cache["first_names"]["men"]
	var result: Array = []
	var available: Array = pool.duplicate()
	for i in count:
		if available.is_empty():
			available = pool.duplicate()
		var idx := rng.randi_range(0, available.size() - 1)
		result.append(available[idx])
		available.remove_at(idx)
	return result


func _pick_surnames(rng: RandomNumberGenerator, count: int) -> Array:
	var pool: Array = _data_cache["surnames"]
	var result: Array = []
	var available: Array = pool.duplicate()
	for i in count:
		if available.is_empty():
			available = pool.duplicate()
		var idx := rng.randi_range(0, available.size() - 1)
		result.append(available[idx])
		available.remove_at(idx)
	return result


func _pick_clubs(rng: RandomNumberGenerator, count: int) -> Array:
	var pool: Array = _data_cache["clubs"]
	var result: Array = []
	for i in count:
		result.append(pool[rng.randi_range(0, pool.size() - 1)])
	return result


func _make_boxer(rng: RandomNumberGenerator, first: String, last: String, club: Dictionary, sex: String,
		div_id: String, is_ranked: bool, boxer_seed: int) -> Dictionary:
	var age := _roll_age(rng, is_ranked)
	var stance: String = STANCES[rng.randi_range(0, 1)] if rng.randf() < 0.25 else STANCES[0]
	var st: Dictionary = STYLES[rng.randi_range(0, STYLES.size() - 1)]
	var rating := _roll_rating(rng, age, is_ranked)
	var record := _roll_record(rng, age, is_ranked, rating)
	var height := rng.randi_range(165, 180) if sex == "men" else rng.randi_range(158, 174)
	var id := _next_id
	_next_id += 1
	return {
		"id": id,
		"name": "%s %s" % [first, last],
		"first": first,
		"last": last,
		"sex": sex,
		"club": club["club"],
		"region": club["region"],
		"age": age,
		"stance": stance,
		"style": st["style"],
		"threat": st["threat"],
		"weak": st["weak"],
		"div": div_id,
		"rating": rating,
		"w": record["w"],
		"l": record["l"],
		"d": record["d"],
		"ko": record["ko"],
		"height": height,
		"reach": height + rng.randi_range(-2, 5),
		"damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 0},
		"peak_age": _peak_age_for(sex, div_id),
		"retired": false,
		"rank": 0,
		"belt": "",
	}


func _roll_age(rng: RandomNumberGenerator, is_ranked: bool) -> int:
	if is_ranked:
		return rng.randi_range(22, 34)
	return rng.randi_range(18, 28)


func _roll_rating(rng: RandomNumberGenerator, age: int, is_ranked: bool) -> float:
	var base: float
	if is_ranked:
		base = rng.randf_range(64.0, 80.0)
	else:
		base = rng.randf_range(55.0, 68.0)
	var age_factor := _age_factor(age)
	return snappedf(base * age_factor, 0.5)


func _roll_record(rng: RandomNumberGenerator, age: int, is_ranked: bool, rating: float = 65.0) -> Dictionary:
	var fights_per_year := 12 if age < 22 else 6
	var years_active := maxi(1, age - 16)
	var total_fights := mini(years_active * fights_per_year, rng.randi_range(5, 40) if is_ranked else rng.randi_range(0, 12))
	# the better boxer has the better record: 55 rates about 45% wins, 80 about 88% (plus or minus 8 points of luck)
	var win_pct := clampf(0.45 + (rating - 55.0) / 25.0 * 0.43 + rng.randf_range(-0.08, 0.08), 0.30, 0.95)
	var wins := int(float(total_fights) * win_pct)
	var losses := total_fights - wins - (1 if rng.randf() < 0.15 else 0)
	losses = maxi(0, losses)
	var ko := rng.randi_range(0, wins / 3) if wins > 0 else 0
	return {"w": wins, "l": losses, "d": total_fights - wins - losses, "ko": ko}


func _age_factor(age: int) -> float:
	if age < 22:
		return 0.90 + float(age - 18) * 0.025
	if age <= 28:
		return 1.0
	if age <= 33:
		return 1.0 - float(age - 28) * 0.01
	return 1.0 - 0.05 - float(age - 33) * 0.02


func _peak_age_for(sex: String, div_id: String) -> int:
	var is_amateur := div_id.begins_with("a_")
	if is_amateur:
		return 24
	return 28
