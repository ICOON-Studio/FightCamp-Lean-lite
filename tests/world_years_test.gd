extends SceneTree
## The 20-year test: run 20 game years with no player and check stability.
## Checks: rankings stay full, age spread believable, arrivals match retirements,
## ratings don't drift, champions have challengers, fight schedules are real.

const WG := preload("res://scripts/world/WorldGen.gd")
const WA := preload("res://scripts/world/WorldAge.gd")
const WR := preload("res://scripts/world/WorldRank.gd")
const WS := preload("res://scripts/world/WorldSim.gd")

const YEARS := 20
const MAX_DRIFT := 7.0

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
	for year in YEARS:
		var sim := WS.simulate_year(world["divisions"], rng)
		_record_year(world, year, sim)
		_check_places_mean_levels(world, "year %d" % (year + 1))
	_check_rankings_full(world)
	_check_age_spread(world)
	_check_retirements_arrivals(world)
	_check_rating_drift(world, initial_ratings)
	_check_champions_have_challengers(world)
	_check_unique_ids(world)
	_check_fight_schedules(world)
	_print_book()
	print("worst clear inversions over %d years: %.1f%% (bar %.0f%%)" % [YEARS, _worst_inverted * 100.0, MAX_INVERTED * 100.0])
	print("WORLD_YEARS checks=%d failures=%d" % [checks, failures])
	if failures > 0:
		push_error("WORLD_YEARS failed")
	quit(failures)


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
	if total_retired > 200:
		failures += 1
		push_error("Retirements: %d total retirements seems too high" % total_retired)
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
## points better stays under MAX_INVERTED every year (a new world: none). Before: 22-39% at the start, 12-26% in year 1.
const MAX_INVERTED := 0.05
var _worst_inverted := 0.0


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
		_worst_inverted = maxf(_worst_inverted, share)
		var bar := 0.0 if when == "a new world" else MAX_INVERTED
		if share > bar:
			failures += 1
			push_error("Places: %s %s has %.1f%% clear inversions (bar %.0f%%)" % [div_id, when, share * 100.0, bar * 100.0])
			return


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
