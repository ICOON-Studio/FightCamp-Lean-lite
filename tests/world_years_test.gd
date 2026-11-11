extends SceneTree
## The 20-year test: run 20 game years with no player and check stability.
## Checks: rankings stay full, age spread believable, arrivals match retirements,
## ratings don't drift, champions have challengers, fight schedules are real.

const WG := preload("res://scripts/world/WorldGen.gd")
const WA := preload("res://scripts/world/WorldAge.gd")
const WR := preload("res://scripts/world/WorldRank.gd")
const WS := preload("res://scripts/world/WorldSim.gd")

const YEARS := 20
## S398 fighter model: world bouts on the real duels give real upsets, so the #1 seat changes hands more (measured 7.5 in one
## division-year); places still mean levels (the inversion checks below: a table's mean, its worst year, the rare years; S434).
const MAX_DRIFT := 8.5

var failures := 0
var checks := 0
var book: Array = []


func _init() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 12345
	var world := WG.generate(12345)
	var initial_ratings := _capture_top_ratings(world)
	var initial_champs := _capture_champions(world)
	book.append("=== WORLD YEARS BOOK ===")
	book.append("Seed: 12345, Years: %d" % YEARS)
	book.append("")
	_check_places_mean_levels(world, "a new world")
	_check_streak_seat()
	for year in YEARS:
		var sim := WS.simulate_year(world["divisions"], rng)
		_record_year(world, year, sim)
		_check_places_mean_levels(world, "year %d" % (year + 1))
	_check_inversion_spread()
	_check_rankings_full(world)
	_check_age_spread(world)
	_check_retirements_arrivals(world)
	_check_rating_drift(world, initial_ratings)
	_check_champions_have_challengers(world)
	_check_unique_ids(world)
	_check_fight_schedules(world)
	_print_book()
	print("worst clear inversions over %d years: %.1f%% (bars: a year %.0f%%, a table's mean %.1f%%)" % [YEARS, _worst_inverted * 100.0, MAX_INVERTED * 100.0, MEAN_INVERTED * 100.0])
	print("WORLD_YEARS checks=%d failures=%d" % [checks, failures])
	if failures > 0:
		push_error("WORLD_YEARS failed")
	quit(failures)


## A 66-rated 6-0-1 stays off a rating-seeded table. The monthly review gives that record the last seat (week 4).
func _check_streak_seat() -> void:
	checks += 1
	var boxers: Array = []
	for i in 20:
		boxers.append({"id": i + 1, "name": "R%d" % i, "rating": 80.0 - float(i) * 0.4, "rank": i + 1, "w": 20, "l": 4, "retired": false, "player": false})
	var prospect := {"id": 99, "name": "Prospect", "rating": 66.0, "rank": 0, "w": 6, "l": 0, "d": 1, "retired": false, "player": true}
	boxers.append(prospect)
	var n := WS.seat_streaks(boxers)
	if n < 1 or int(prospect["rank"]) <= 0:
		failures += 1
		push_error("6-0-1 at 66 stayed unranked (seated %d)" % n)
	else:
		print("6-0-1 pro ranked by week 4 (monthly review), place #%d" % int(prospect["rank"]))


func _capture_top_ratings(world: Dictionary) -> Dictionary:
	var tops := {}
	for div_id in world["divisions"]:
		var boxers: Array = world["divisions"][div_id]["boxers"]
		var active: Array = []
		for b in boxers:
			if not b.get("retired", false) and int(b.get("rank", 0)) > 0:
				active.append(b)
		active.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
		if active.size() > 0:
			tops[div_id] = float(active[0]["rating"])
	return tops


func _capture_champions(world: Dictionary) -> Dictionary:
	var champs := {}
	for div_id in world["divisions"]:
		var boxers: Array = world["divisions"][div_id]["boxers"]
		var champ := WR.champion_of(boxers, "area")
		if not champ.is_empty():
			champs[div_id] = champ["name"]
	return champs


func _record_year(world: Dictionary, year: int, sim: Dictionary) -> void:
	book.append("--- Year %d ---" % (year + 1))
	for div_id in world["divisions"]:
		var boxers: Array = world["divisions"][div_id]["boxers"]
		var snapshot := WR.ranking_snapshot(boxers)
		if snapshot.size() > 0:
			book.append("  %s #1: %s (%.1f)" % [div_id, snapshot[0]["name"], snapshot[0]["rating"]])
	var retired_count := 0
	if sim.get("age", {}).has("retired"):
		retired_count = sim["age"]["retired"].size()
	book.append("  Retired: %d, Results: %d" % [retired_count, sim["results"].size()])
	book.append("")


func _check_rankings_full(world: Dictionary) -> void:
	checks += 1
	for div_id in world["divisions"]:
		var boxers: Array = world["divisions"][div_id]["boxers"]
		var snapshot := WR.ranking_snapshot(boxers)
		if snapshot.size() < 15:
			failures += 1
			push_error("Rankings: %s has only %d ranked boxers after 20 years" % [div_id, snapshot.size()])
			return


func _check_age_spread(world: Dictionary) -> void:
	checks += 1
	for div_id in world["divisions"]:
		var boxers: Array = world["divisions"][div_id]["boxers"]
		var spread := WA.age_spread(boxers)
		if int(spread["max"]) > 42:
			failures += 1
			push_error("Age: %s max age %d > 42" % [div_id, int(spread["max"])])
			return
		if int(spread["min"]) < 17 and int(spread["min"]) > 0:
			failures += 1
			push_error("Age: %s min age %d < 17" % [div_id, int(spread["min"])])
			return


func _check_retirements_arrivals(world: Dictionary) -> void:
	checks += 1
	var total_retired := 0
	for div_id in world["divisions"]:
		var boxers: Array = world["divisions"][div_id]["boxers"]
		for b in boxers:
			if b.get("retired", false):
				total_retired += 1
	# S434: a rate a table (50 in 20 years each; it was 200 for the four tables), so eight tables are read on the same scale.
	var cap := 50 * (world["divisions"] as Dictionary).size()
	if total_retired > cap:
		failures += 1
		push_error("Retirements: %d total retirements seems too high (bar %d, 50 a table)" % [total_retired, cap])
		return


func _check_rating_drift(world: Dictionary, initial: Dictionary) -> void:
	checks += 1
	for div_id in initial:
		var boxers: Array = world["divisions"][div_id]["boxers"]
		var active: Array = []
		for b in boxers:
			if not b.get("retired", false) and int(b.get("rank", 0)) > 0:
				active.append(b)
		active.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
		if active.size() > 0:
			var current_top := float(active[0]["rating"])
			var drift := absf(current_top - initial[div_id])
			if drift > MAX_DRIFT:
				failures += 1
				push_error("Drift: %s top rating drifted %.1f (from %.1f to %.1f)" % [div_id, drift, initial[div_id], current_top])
				return


func _check_champions_have_challengers(world: Dictionary) -> void:
	checks += 1
	for div_id in world["divisions"]:
		var boxers: Array = world["divisions"][div_id]["boxers"]
		for level in WR.BELT_LEVELS:
			var champ := WR.champion_of(boxers, level)
			if champ.is_empty():
				failures += 1
				push_error("Champions: %s has no %s champion after %d years" % [div_id, level, YEARS])
				return
			if WR.mandatory_challenger(boxers, champ).is_empty():
				failures += 1
				push_error("Champions: %s %s champion has no mandatory challenger" % [div_id, level])
				return


## S397 (operator "Yes, fix ranks"): a place means a level - the share of ranked pairs where the boxer below is 5 or more
## points better (a new world: none). Before S397: 22-39% at the start, 12-26% in year 1.
## S434 (PROTABLES1, 8 tables): read as the design means it, not as one table-year's luck. A probe over 8 seeds x 20 years
## (ops/research/PROTABLES1_INVERSIONS_S434.md) put every table, old and new, at a 0.8-1.2% average with its worst year
## 5-7%; the old four ALONE on main reached 7.4% on seeds 1, 2 and 3, so "no table-year above 5%" passed on seed 12345 by
## luck and twice the tables doubled the draws (pooled table means 0.8-1.2%). The bars: each table's mean under MEAN_INVERTED, no year above
## MAX_INVERTED, and at most RARE_SHARE of table-years above RARE_INVERTED.
const MEAN_INVERTED := 0.03   # one seed's table mean reached 1.58% (w_fw, seed 12345); the broken world read 12-26%
const MAX_INVERTED := 0.10
const RARE_INVERTED := 0.05
const RARE_SHARE := 0.05
var _worst_inverted := 0.0
var _inv := {}   # div -> [sum, years, over RARE_INVERTED]


func _check_places_mean_levels(world: Dictionary, when: String) -> void:
	checks += 1
	for div_id in world["divisions"]:
		var r: Array = world["divisions"][div_id]["boxers"].filter(func(b): return int(b.get("rank", 0)) > 0 and not b.get("retired", false))
		var n := 0
		var bad := 0
		for a in r:
			for b in r:
				if int(a["rank"]) < int(b["rank"]):
					n += 1
					bad += int(float(b["rating"]) - float(a["rating"]) >= 5.0)
		var share := float(bad) / maxf(1.0, float(n))
		if when == "a new world":
			if share > 0.0:
				failures += 1
				push_error("Places: %s in a new world has %.1f%% clear inversions (bar 0%%)" % [div_id, share * 100.0])
				return
			continue
		_worst_inverted = maxf(_worst_inverted, share)
		var st: Array = _inv.get(div_id, [0.0, 0, 0])
		st[0] += share
		st[1] += 1
		st[2] += int(share > RARE_INVERTED)
		_inv[div_id] = st
		if share > MAX_INVERTED:
			failures += 1
			push_error("Places: %s %s has %.1f%% clear inversions (bar %.0f%%)" % [div_id, when, share * 100.0, MAX_INVERTED * 100.0])
			return


## After the years: each table's mean, and how many of all the table-years went over RARE_INVERTED.
func _check_inversion_spread() -> void:
	checks += 1
	var years := 0
	var over := 0
	for div_id in _inv:
		var st: Array = _inv[div_id]
		years += int(st[1])
		over += int(st[2])
		var mean := float(st[0]) / maxf(1.0, float(st[1]))
		print("  inversions %s mean=%.2f%% years_over_%.0f%%=%d" % [div_id, mean * 100.0, RARE_INVERTED * 100.0, int(st[2])])
		if mean > MEAN_INVERTED:
			failures += 1
			push_error("Places: %s averages %.2f%% clear inversions (bar %.1f%%)" % [div_id, mean * 100.0, MEAN_INVERTED * 100.0])
	if float(over) > RARE_SHARE * float(years):
		failures += 1
		push_error("Places: %d of %d table-years over %.0f%% (bar %.0f%%)" % [over, years, RARE_INVERTED * 100.0, RARE_SHARE * 100.0])


func _check_unique_ids(world: Dictionary) -> void:
	checks += 1
	var seen := {}
	for div_id in world["divisions"]:
		for b in world["divisions"][div_id]["boxers"]:
			var id := int(b.get("id", 0))
			if id <= 0 or seen.has(id):
				failures += 1
				push_error("Ids: %s has id %d (zero or used twice)" % [b["name"], id])
				return
			seen[id] = true


func _check_fight_schedules(world: Dictionary) -> void:
	checks += 1
	for div_id in world["divisions"]:
		var boxers: Array = world["divisions"][div_id]["boxers"]
		for b in boxers:
			var total_fights := int(b.get("w", 0)) + int(b.get("l", 0)) + int(b.get("d", 0))
			var years_active := maxi(1, int(b["age"]) - 16)
			var fights_per_year := float(total_fights) / float(years_active)
			if fights_per_year > 20.0:
				failures += 1
				push_error("Schedule: %s has %.1f fights/year (%d total in %d years)" % [b["name"], fights_per_year, total_fights, years_active])
				return


func _print_book() -> void:
	var save_path := "user://world_years_book.txt"
	var f := FileAccess.open(save_path, FileAccess.WRITE)
	if f != null:
		for line in book:
			f.store_line(line)
		f.close()
	for i in mini(40, book.size()):
		print(book[i])
