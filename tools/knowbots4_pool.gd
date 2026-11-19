extends RefCounted
## KNOWBOTS4 pool helper - world simulation for the probe.
## Extracted to keep knowbots4_probe.gd under 500 lines.

const WG := preload("res://scripts/world/WorldGen.gd")
const WS := preload("res://scripts/world/WorldSim.gd")
const WR := preload("res://scripts/world/WorldRank.gd")
const WA := preload("res://scripts/world/WorldAge.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const K := preload("res://scripts/rules/Knowledge.gd")
const KR := preload("res://scripts/rules/KnowReads.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")

const MONTHS := 48
const DIV := "m_lw"
const PROSPECTS_PER_SIGNING := 6
const FLOP_THRESHOLD := 5.0


static func attr_mean(attrs: Dictionary) -> float:
	var sum := 0.0
	var count := 0
	for a in K.BODY_ATTRS + K.SKILLS_ATTRS + K.FIRE_ATTRS:
		if attrs.has(a):
			sum += float(attrs[a])
			count += 1
	return sum / float(maxi(1, count))


static func shown_centre(p: Dictionary, k: Dictionary) -> float:
	var sum := 0.0
	var attrs: Dictionary = p["attrs"]
	var count := 0
	for a in K.BODY_ATTRS + K.SKILLS_ATTRS + K.FIRE_ATTRS:
		var truth := float(attrs[a])
		var r := K.range_of(k, a, truth, float(p["hype"]))
		sum += float(r["centre"])
		count += 1
	return sum / float(maxi(1, count))


static func empty_totals() -> Dictionary:
	return {"top10": 0, "titles": 0, "bout_wins": 0, "bouts": 0, "win_share": 0.0,
		"final_true": 0.0, "flops": 0, "cash": 0, "reads": 0}


static func merge_totals(dst: Dictionary, src: Dictionary) -> void:
	for key in ["top10", "titles", "bout_wins", "bouts", "flops", "cash", "reads"]:
		dst[key] = int(dst.get(key, 0)) + int(src.get(key, 0))
	dst["win_share"] = float(dst.get("win_share", 0.0)) + float(src.get("win_share", 0.0))
	dst["final_true"] = float(dst.get("final_true", 0.0)) + float(src.get("final_true", 0.0))


static func get_prospects(world: Dictionary, seed_val: int, year: int, club: Dictionary) -> Array:
	var div_boxers: Array = world["divisions"][DIV]["boxers"]
	var signed_ids: Dictionary = club.get("signed_ids", {})
	var candidates: Array = []
	for b in div_boxers:
		if b.get("retired", false) or b.get("player", false):
			continue
		var age := int(b.get("age", 0))
		var rank := int(b.get("rank", 0))
		if age >= 18 and age <= 22 and (rank == 0 or rank > 30):
			if not signed_ids.has(int(b.get("id", 0))):
				candidates.append(b)
	var pool_rng := RandomNumberGenerator.new()
	pool_rng.seed = hash([seed_val, "pool", year])
	for i in range(candidates.size() - 1, 0, -1):
		var j := pool_rng.randi_range(0, i)
		var tmp = candidates[i]; candidates[i] = candidates[j]; candidates[j] = tmp
	var n := mini(PROSPECTS_PER_SIGNING, candidates.size())
	var list: Array = []
	for idx in n:
		var b: Dictionary = candidates[idx]
		var p_seed := hash([seed_val, year, "p", idx])
		var hype := pool_rng.randf()
		var attrs := AttrGen.attrs_of(b)
		var tm := attr_mean(attrs)
		var tr := float(b["rating"])
		var pot := clampi(int(tr + (25.0 - float(b["age"])) * 3.0), int(tr) + 5, 95)
		var k := K.fresh(p_seed)
		list.append({"name": b.get("name", "Prospect"), "seed": p_seed, "age": int(b["age"]),
			"true_rating": tr, "true_mean": tm, "pot": pot, "hype": hype,
			"attrs": attrs, "k": k, "world_id": int(b.get("id", 0))})
	return list


static func pick_bout(p: Dictionary, boxers: Array, rng: RandomNumberGenerator) -> Dictionary:
	var offered := MM.offers(p, boxers, rng)
	if offered.is_empty():
		return {}
	var options: Array = offered.duplicate()
	var ranked := boxers.filter(func(b): return int(b.get("rank", 0)) > 0 and not b.get("player", false) and not b.get("retired", false))
	ranked.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
	for b in ranked:
		if (int(p["rank"]) == 0 or int(b["rank"]) < int(p["rank"])) and MM.ask(p, b)["ok"]:
			var g := MM.guess(b, rng)
			g["kind"] = "ask"
			options.append(g)
	options.sort_custom(func(a, b): return _place_of(a["opp"]) < _place_of(b["opp"]))
	for g in options:
		var ch := MM.shown_chance(p, g, 2.5)
		if float(ch["mid"]) >= 0.55:
			MM.note_choice(p, g["opp"], offered)
			return g["opp"]
	var level := options.filter(func(g): return str(g["kind"]) == "level")
	var pick: Dictionary = (level[0] if not level.is_empty() else options[0])["opp"]
	MM.note_choice(p, pick, offered)
	return pick


static func _place_of(b: Dictionary) -> int:
	return int(b["rank"]) if int(b.get("rank", 0)) > 0 else 99


## --- World simulation for yardstick (ORACLE + BLIND) ---

static func run_world_yardstick(bot: String, seed_val: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	var world := WG.generate(seed_val)
	var divs: Dictionary = world["divisions"]
	var boxers: Array = divs[DIV]["boxers"]
	var club := {"cash": 25000, "fighters": [], "signed_ids": {}}
	var flops := 0
	var bout_wins := 0
	var bouts_total := 0
	for m in MONTHS:
		if m == 0 or m == 12 or m == 24 or m == 36:
			var year := m / 12
			var prospects := get_prospects(world, seed_val, year, club)
			if not prospects.is_empty():
				var pick_res := _choose_yardstick(bot, prospects)
				var p: Dictionary = pick_res["pick"]
				if bool(pick_res["flop"]):
					flops += 1
				var f := MM.join(boxers, str(p["name"]), float(p["true_rating"]), int(p["age"]), int(p["seed"]))
				f["id"] = 90000 + (seed_val % 1000) * 10 + year
				f["pot"] = int(p["pot"])
				f["k"] = p["k"]
				f["since"] = MM.NEXT_WEEKS
				f["peak_rank"] = 99
				club["fighters"].append(f)
				club["signed_ids"][int(p["world_id"])] = true
		WS.simulate_month(divs, rng)
		for f in club["fighters"]:
			if f.get("retired", false):
				continue
			var headroom: float = clampf((float(f["pot"]) - float(f["rating"])) / 25.0, 0.10, 1.25)
			f["rating"] = minf(float(f["pot"]), float(f["rating"]) + 0.35 * headroom)
			K.expose(f["k"], "body", 2.0, "session")
			K.expose(f["k"], "skills", 2.0, "session")
			f["since"] = int(f.get("since", 0)) + 4
			if int(f["since"]) >= int(f.get("next_weeks", MM.NEXT_WEEKS)):
				var opp := pick_bout(f, boxers, rng)
				if not opp.is_empty():
					var line := MM.fight(f, opp, boxers, rng)
					f["since"] = 0
					bouts_total += 1
					var purse_take := int(round(float(int(line["purse"]) + int(line["tickets"])) * MM.GYM_SHARE))
					club["cash"] = int(club["cash"]) + purse_take
					if bool(line["won"]):
						bout_wins += 1
						K.expose(f["k"], "fire", 4.0, "bout")
					if bool(line["stop"]) and not bool(line["won"]):
						K.stale(f["k"], "knockout")
			var rk := int(f.get("rank", 0))
			if rk > 0:
				f["peak_rank"] = mini(int(f.get("peak_rank", 99)), rk)
		if m % 12 == 11:
			WS.year_end(divs, rng)
	var top10 := 0; var titles := 0; var final_true_sum := 0.0
	for f in club["fighters"]:
		if int(f.get("peak_rank", 99)) <= 10:
			top10 += 1
		if bool(f.get("won_belt", false)):
			titles += 1
		final_true_sum += attr_mean(AttrGen.attrs_of(f))
	var win_share: float = float(bout_wins) / maxf(float(bouts_total), 1.0) * 100.0
	return {"top10": top10, "titles": titles, "bout_wins": bout_wins, "bouts": bouts_total,
		"win_share": win_share, "final_true": final_true_sum, "flops": flops, "cash": club["cash"]}


static func _choose_yardstick(bot: String, prospects: Array) -> Dictionary:
	if bot == "oracle":
		var best_idx := 0
		var best_r := float(prospects[0]["true_rating"])
		for i in prospects.size():
			if float(prospects[i]["true_rating"]) > best_r:
				best_r = float(prospects[i]["true_rating"])
				best_idx = i
		var pick: Dictionary = prospects[best_idx]
		var sc := shown_centre(pick, pick["k"])
		return {"pick": pick, "flop": (float(sc) - float(pick["true_mean"])) >= FLOP_THRESHOLD}
	var scored: Array = []
	for p in prospects:
		scored.append({"p": p, "c": shown_centre(p, p["k"])})
	scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
	var pick: Dictionary = scored[0]["p"]
	return {"pick": pick, "flop": (float(scored[0]["c"]) - float(pick["true_mean"])) >= FLOP_THRESHOLD}


## --- World simulation for K1 (all four bots) ---

static func run_world_k1(bot: String, seed_val: int, read_spend: Dictionary) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	var world := WG.generate(seed_val)
	var divs: Dictionary = world["divisions"]
	var boxers: Array = divs[DIV]["boxers"]
	var club := {"cash": 25000, "fighters": [], "signed_ids": {}, "reads": 0}
	var flops := 0; var bout_wins := 0; var bouts_total := 0
	for m in MONTHS:
		if m == 0 or m == 12 or m == 24 or m == 36:
			var year := m / 12
			var prospects := get_prospects(world, seed_val, year, club)
			if not prospects.is_empty():
				var pick_res := _choose_k1(bot, prospects, club, read_spend)
				var p: Dictionary = pick_res["pick"]
				if bool(pick_res["flop"]):
					flops += 1
				var f := MM.join(boxers, str(p["name"]), float(p["true_rating"]), int(p["age"]), int(p["seed"]))
				f["id"] = 90000 + (seed_val % 1000) * 10 + year
				f["pot"] = int(p["pot"])
				f["k"] = p["k"]
				f["since"] = MM.NEXT_WEEKS
				f["peak_rank"] = 99
				club["fighters"].append(f)
				club["signed_ids"][int(p["world_id"])] = true
		WS.simulate_month(divs, rng)
		for f in club["fighters"]:
			if f.get("retired", false):
				continue
			var headroom: float = clampf((float(f["pot"]) - float(f["rating"])) / 25.0, 0.10, 1.25)
			f["rating"] = minf(float(f["pot"]), float(f["rating"]) + 0.35 * headroom)
			K.expose(f["k"], "body", 2.0, "session")
			K.expose(f["k"], "skills", 2.0, "session")
			if m % 12 == 0 and m > 0 and bot == "reader":
				if K.recheck_ready(f["k"], m * 30):
					var cost: int = KR.price("recheck")
					if int(club["cash"]) >= cost:
						club["cash"] -= cost; club["reads"] += cost
						read_spend["recheck"] = int(read_spend.get("recheck", 0)) + cost
						KR.apply(f["k"], "recheck"); K.recheck_done(f["k"], m * 30)
			f["since"] = int(f.get("since", 0)) + 4
			if int(f["since"]) >= int(f.get("next_weeks", MM.NEXT_WEEKS)):
				var opp := pick_bout(f, boxers, rng)
				if not opp.is_empty():
					var line := MM.fight(f, opp, boxers, rng)
					f["since"] = 0; bouts_total += 1
					var purse_take := int(round(float(int(line["purse"]) + int(line["tickets"])) * MM.GYM_SHARE))
					club["cash"] = int(club["cash"]) + purse_take
					if bool(line["won"]):
						bout_wins += 1; K.expose(f["k"], "fire", 4.0, "bout"); K.bout(f["k"])
					if bool(line["stop"]) and not bool(line["won"]):
						K.stale(f["k"], "knockout")
			var rk := int(f.get("rank", 0))
			if rk > 0:
				f["peak_rank"] = mini(int(f.get("peak_rank", 99)), rk)
		if m % 12 == 11:
			WS.year_end(divs, rng)
	var top10 := 0; var titles := 0; var final_true_sum := 0.0
	for f in club["fighters"]:
		if int(f.get("peak_rank", 99)) <= 10:
			top10 += 1
		if bool(f.get("won_belt", false)):
			titles += 1
		final_true_sum += attr_mean(AttrGen.attrs_of(f))
	var win_share: float = float(bout_wins) / maxf(float(bouts_total), 1.0) * 100.0
	return {"top10": top10, "titles": titles, "bout_wins": bout_wins, "bouts": bouts_total,
		"win_share": win_share, "final_true": final_true_sum, "flops": flops,
		"cash": club["cash"], "reads": club["reads"]}


static func _choose_k1(bot: String, prospects: Array, club: Dictionary, read_spend: Dictionary) -> Dictionary:
	if bot == "oracle":
		var best_idx := 0; var best_r := float(prospects[0]["true_rating"])
		for i in prospects.size():
			if float(prospects[i]["true_rating"]) > best_r:
				best_r = float(prospects[i]["true_rating"]); best_idx = i
		var pick: Dictionary = prospects[best_idx]
		var sc := shown_centre(pick, pick["k"])
		return {"pick": pick, "flop": (float(sc) - float(pick["true_mean"])) >= FLOP_THRESHOLD}
	if bot == "bad":
		var scored: Array = []
		for p in prospects:
			scored.append({"p": p, "c": shown_centre(p, p["k"])})
		scored.sort_custom(func(a, b): return float(a["c"]) < float(b["c"]))
		var pick: Dictionary = scored[0]["p"]
		return {"pick": pick, "flop": (float(scored[0]["c"]) - float(pick["true_mean"])) >= FLOP_THRESHOLD}
	if bot == "blind":
		var scored: Array = []
		for p in prospects:
			scored.append({"p": p, "c": shown_centre(p, p["k"])})
		scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
		var pick: Dictionary = scored[0]["p"]
		return {"pick": pick, "flop": (float(scored[0]["c"]) - float(pick["true_mean"])) >= FLOP_THRESHOLD}
	# READER: v3 reads
	var scored: Array = []
	for p in prospects:
		scored.append({"p": p, "c": shown_centre(p, p["k"])})
	scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
	# Look closer on top 2
	for i in mini(2, scored.size()):
		var cost: int = KR.price("look_closer")
		if int(club["cash"]) >= cost:
			club["cash"] -= cost; club["reads"] += cost
			read_spend["look_closer"] = int(read_spend.get("look_closer", 0)) + cost
			KR.apply(scored[i]["p"]["k"], "look_closer")
			scored[i]["c"] = shown_centre(scored[i]["p"], scored[i]["p"]["k"])
	scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
	# Trial on Hyped
	for i in scored.size():
		var p: Dictionary = scored[i]["p"]
		if K.is_hyped(p["k"]):
			var cost: int = KR.price("trial")
			if int(club["cash"]) >= cost:
				club["cash"] -= cost; club["reads"] += cost
				read_spend["trial"] = int(read_spend.get("trial", 0)) + cost
				KR.apply(p["k"], "trial")
				scored[i]["c"] = shown_centre(p, p["k"])
	scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
	# Test day on top pick
	var pick: Dictionary = scored[0]["p"]
	var td_cost: int = KR.price("test_day")
	if int(club["cash"]) >= td_cost:
		club["cash"] -= td_cost; club["reads"] += td_cost
		read_spend["test_day"] = int(read_spend.get("test_day", 0)) + td_cost
		KR.apply(pick["k"], "test_day")
	var sc := float(scored[0]["c"])
	return {"pick": pick, "flop": (sc - float(pick["true_mean"])) >= FLOP_THRESHOLD}
