extends SceneTree
## 200 seeded world bouts and 20 seeded live bouts. The bar is a call count, not a clock: attribute generation and
## migration run at most once a fighter a bout, and a derived attribute is not rebuilt per punch. Prints one digest
## line per bout set (the seeded results) and FIGHTER_SPEED failures=<n>.

const WorldGen := preload("res://scripts/world/WorldGen.gd")
const WorldBout := preload("res://scripts/world/WorldBout.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")

## Moved with the generated shapes (FIGHTERMODEL4I): a style is now wide enough to scout, so these seeded
## world bouts are not the old ones. The call caps below are the bar; the digests only name the new results.
const FAST_DIGEST := -748117240233963606   # S434 PROTABLES1: eight world tables
const FIGHT_DIGEST := -2169524393975280768   # S434 PROTABLES1: eight world tables
const LIVE_DIGEST := -1989922531601276332
## Once a fighter a bout, plus the one setup pass (alias is written twice inside a single migration).
const WORLD_CAP := {"build": 2, "migrate": 1, "full": 2, "alias": 4, "moves": 2, "derived": 4, "scan": 0}
const LIVE_CAP := {"build": 2, "migrate": 1, "full": 4, "alias": 12, "moves": 4, "derived": 4, "scan": 0}

var failures := 0


func _zero() -> void:
	Attrs.n_of_full = 0
	Attrs.n_migrate = 0
	Attrs.n_alias = 0
	Attrs.n_moves = 0
	AttrGen.n_build = 0
	Duels.n_derived = 0
	Duels.n_punch_scan = 0


func _take() -> Dictionary:
	return {"build": AttrGen.n_build, "migrate": Attrs.n_migrate, "full": Attrs.n_of_full, "alias": Attrs.n_alias,
		"moves": Attrs.n_moves, "derived": Duels.n_derived, "scan": Duels.n_punch_scan}


func _worst(worst: Dictionary, row: Dictionary) -> void:
	for k in row:
		worst[k] = maxi(int(worst.get(k, 0)), int(row[k]))


func _cap(tag: String, worst: Dictionary, cap: Dictionary) -> void:
	for k in cap:
		if int(worst.get(k, 0)) > int(cap[k]):
			failures += 1
			print("FAIL %s %s %d over %d" % [tag, k, int(worst[k]), int(cap[k])])


func _init() -> void:
	var world := WorldGen.generate(7)
	var pool: Array = []
	for div_id in world["divisions"]:
		for b in world["divisions"][div_id]["boxers"]:
			if int(b.get("rank", 0)) > 0:
				pool.append(b)
	WorldBout._cache = {}
	var rng := RandomNumberGenerator.new()
	rng.seed = 99
	var acc := 0
	var edge_sum := 0.0
	var world_us := 0
	var world_worst := {}
	for i in 200:
		var x: Dictionary = pool[i % pool.size()]
		var y: Dictionary = pool[(i * 3 + 1) % pool.size()]
		if x == y:
			y = pool[(i + 5) % pool.size()]
		_zero()
		var t0 := Time.get_ticks_usec()
		var rows: Array = WorldBout.quick_rows(x, y, 6)
		for row in rows:
			for e in row:
				edge_sum += float(e)
		var r := WorldBout.fast(x, y, 6, rng)
		world_us += Time.get_ticks_usec() - t0
		_worst(world_worst, _take())
		acc = acc * 13 + (1 if str(r["winner"]) == "a" else (2 if str(r["winner"]) == "b" else 3))
		acc = acc * 13 + int(r["round"]) + int(r["stopped"]) * 5
	_cap("world", world_worst, WORLD_CAP)
	if acc != FAST_DIGEST:
		failures += 1
		print("FAIL fast digest %d" % acc)
	var fight_acc := 0
	var fr := RandomNumberGenerator.new()
	fr.seed = 99
	for i in 40:
		var x: Dictionary = pool[i % pool.size()]
		var y: Dictionary = pool[(i * 5 + 2) % pool.size()]
		if x == y:
			y = pool[(i + 4) % pool.size()]
		var r := WorldBout.fight(x, y, 4, fr)
		fight_acc = fight_acc * 13 + (1 if str(r["winner"]) == "a" else (2 if str(r["winner"]) == "b" else 3))
		fight_acc = fight_acc * 13 + int(r["round"])
		for p in r["places"]:
			fight_acc = fight_acc * 13 + int(p)
	if fight_acc != FIGHT_DIGEST:
		failures += 1
		print("FAIL fight digest %d" % fight_acc)
	var live := 0
	var live_us := 0
	var live_worst := {}
	for k in 20:
		var sc := Career.new()
		sc.day = 40000 + k * 11
		sc.seed = 387
		sc.coach = {"rating": 58.0}
		var sf: Dictionary = Data.fighter_state(Data.lucy(), 0)
		var opp: Dictionary = (Data.OPPONENTS[k % Data.OPPONENTS.size()] as Dictionary).duplicate(true)
		sf["bout"] = {"opp": opp, "day": sc.day, "weighed": true, "made": true, "done": false, "film": 1}
		sc.fighters = [sf]
		var m := BoutNight.fight_modal(sf)
		_zero()
		var t1 := Time.get_ticks_usec()
		BoutNight.play_out(sc, sf, m)
		live_us += Time.get_ticks_usec() - t1
		_worst(live_worst, _take())
		live = live * 13 + (1 if BoutNight.outcome_of(sf, m) == "win" else (2 if BoutNight.outcome_of(sf, m) == "loss" else 3))
		for rd in m["rounds"]:
			live = live * 13 + int(bool(rd["won"]))
	_cap("live", live_worst, LIVE_CAP)
	if live != LIVE_DIGEST:
		failures += 1
		print("FAIL live digest %d" % live)
	print("WORLD us/bout %d calls %s" % [world_us / 200, str(world_worst)])
	print("LIVE us/bout %d calls %s" % [live_us / 20, str(live_worst)])
	print("DIGEST fast %d edges %.8f" % [acc, edge_sum])
	print("DIGEST fight %d" % fight_acc)
	print("DIGEST live %d" % live)
	print("FIGHTER_SPEED failures=%d" % failures)
	quit(0 if failures == 0 else 1)
