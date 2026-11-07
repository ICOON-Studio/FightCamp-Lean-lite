extends SceneTree
## World rules test: seeded generation repeats, ranking movement, belt vacates on retirement, forecast falls with damage.

const WG := preload("res://scripts/world/WorldGen.gd")
const WA := preload("res://scripts/world/WorldAge.gd")
const WR := preload("res://scripts/world/WorldRank.gd")

var failures := 0
var checks := 0


func _init() -> void:
	_check_seeded_generation()
	_check_ranking_takes_place()
	_check_belt_vacates_on_retirement()
	_check_forecast_falls_with_damage()
	_check_unranked_beat_ranked_no_swap()
	_check_age_spread_believable()
	print("WORLD_RULES checks=%d failures=%d" % [checks, failures])
	if failures > 0:
		push_error("WORLD_RULES failed")
	quit(failures)


func _check_seeded_generation() -> void:
	checks += 1
	var w1 := WG.generate(42)
	var w2 := WG.generate(42)
	if w1["boxers"].size() != w2["boxers"].size():
		failures += 1
		push_error("Seeded generation: different boxer count")
		return
	for i in w1["boxers"].size():
		if w1["boxers"][i]["name"] != w2["boxers"][i]["name"]:
			failures += 1
			push_error("Seeded generation: different names at %d" % i)
			return
		if w1["boxers"][i]["rating"] != w2["boxers"][i]["rating"]:
			failures += 1
			push_error("Seeded generation: different ratings at %d" % i)
			return


func _check_ranking_takes_place() -> void:
	checks += 1
	var a := {"name": "A", "rank": 5, "rating": 70.0, "retired": false, "w": 10, "l": 2, "belt": "",
		"damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 0}, "age": 26, "peak_age": 28}
	var b := {"name": "B", "rank": 3, "rating": 73.0, "retired": false, "w": 12, "l": 1, "belt": "",
		"damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 0}, "age": 27, "peak_age": 28}
	var c := {"name": "C", "rank": 4, "rating": 71.0, "retired": false, "w": 11, "l": 2, "belt": "",
		"damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 0}, "age": 25, "peak_age": 28}
	var division := [a, b, c]
	var result := WR.apply_result_in(a, b, division)
	if not result.get("moved", false):
		failures += 1
		push_error("Ranking: A beat higher-ranked B, should take place")
		return
	if int(a["rank"]) != 3:
		failures += 1
		push_error("Ranking: A should be rank 3, got %d" % int(a["rank"]))
		return
	if int(b["rank"]) != 4:
		failures += 1
		push_error("Ranking: B should drop to 4, got %d" % int(b["rank"]))
		return


func _check_belt_vacates_on_retirement() -> void:
	checks += 1
	var champ := {"name": "Champ", "rank": 1, "rating": 80.0, "retired": false, "belt": "GBA_world",
		"w": 25, "l": 1, "age": 34, "peak_age": 28,
		"damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 0}}
	var contender := {"name": "Challenger", "rank": 2, "rating": 76.0, "retired": false, "belt": "",
		"w": 18, "l": 3, "age": 27, "peak_age": 28,
		"damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 0}}
	var division := [champ, contender]
	var vacate := WR.vacate_belt(champ, division)
	if not vacate.get("vacated", false):
		failures += 1
		push_error("Belt: should vacate on retirement")
		return
	if champ.get("belt", "") != "":
		failures += 1
		push_error("Belt: champion should have empty belt after vacate")
		return
	if vacate.get("mandatory", {}).get("name", "") != "Challenger":
		failures += 1
		push_error("Belt: mandatory challenger should be rank 2")
		return


func _check_forecast_falls_with_damage() -> void:
	checks += 1
	var clean := {"age": 30, "peak_age": 28, "rating": 75.0, "belt": "", "w": 15,
		"damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 15}}
	var damaged := {"age": 30, "peak_age": 28, "rating": 75.0, "belt": "", "w": 15,
		"damage_ledger": {"hard_fights": 8, "stoppage_losses": 3, "total_fights": 20}}
	var clean_forecast := WA.fights_left_forecast(clean)
	var damaged_forecast := WA.fights_left_forecast(damaged)
	if damaged_forecast >= clean_forecast:
		failures += 1
		push_error("Forecast: damaged (%d) should have fewer fights left than clean (%d)" % [damaged_forecast, clean_forecast])
		return


func _check_unranked_beat_ranked_no_swap() -> void:
	checks += 1
	var unranked := {"name": "New", "rank": 0, "rating": 65.0, "retired": false, "w": 3, "l": 1, "belt": "",
		"damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 0}, "age": 20, "peak_age": 28}
	var ranked := {"name": "Ranked", "rank": 10, "rating": 70.0, "retired": false, "w": 10, "l": 3, "belt": "",
		"damage_ledger": {"hard_fights": 0, "stoppage_losses": 0, "total_fights": 0}, "age": 25, "peak_age": 28}
	var division := [unranked, ranked]
	var result := WR.apply_result_in(unranked, ranked, division)
	if result.get("moved", false):
		failures += 1
		push_error("Ranking: unranked beating ranked should not swap")
		return


func _check_age_spread_believable() -> void:
	checks += 1
	var boxers: Array = []
	for i in 20:
		boxers.append({"age": 20 + i, "retired": false})
	var spread := WA.age_spread(boxers)
	if int(spread["min"]) < 18 or int(spread["max"]) > 42:
		failures += 1
		push_error("Age spread: min=%d max=%d outside believable range" % [int(spread["min"]), int(spread["max"])])
		return
