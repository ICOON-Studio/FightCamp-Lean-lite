extends SceneTree
## KNOWBOTS3 Probe (TASK_KNOWBOTS3, S463)
## TRUTH = AttrGen.attrs_of(b) (level + shape + age wear). ORACLE bot signs highest true rating.
## FLOP: signed boxer's TRUE attr mean is 5+ under shown centre (same scale now).

const WG := preload("res://scripts/world/WorldGen.gd")
const WS := preload("res://scripts/world/WorldSim.gd")
const WR := preload("res://scripts/world/WorldRank.gd")
const WA := preload("res://scripts/world/WorldAge.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const K := preload("res://scripts/rules/Knowledge.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

const TOTAL_WORLDS := 60
const PILOT_WORLDS := 4
const YEARS := 4
const MONTHS := 48
const DIV := "m_lw"
const PROSPECTS_PER_SIGNING := 6
const SCOUT_COST := 250
const TRIAL_COST := 1000
const TEST_FEE := 100
const PASS_MARGIN := 5
const FLOP_THRESHOLD := 5.0
const MAX_WALL_MINUTES := 90.0
const RESULT_DOC_PATH := "res://docs/KNOWBOTS3_RESULT.md"


func _initialize() -> void:
	print("=== KNOWBOTS3 PROBE (TASK_KNOWBOTS3) ===")
	var t0 := Time.get_ticks_msec()
	_run_worlds_full(PILOT_WORLDS, 7000, {}, [], [], [])
	var pilot_ms := Time.get_ticks_msec() - t0
	var pilot_s := float(pilot_ms) / 1000.0
	var projected_s := (pilot_s / float(PILOT_WORLDS)) * float(TOTAL_WORLDS) * 2.0
	var proj_min := projected_s / 60.0
	print("Pilot (%d worlds) completed in %.2f s | Projected %d worlds x2: %.2f s (%.2f min)" % [
		PILOT_WORLDS, pilot_s, TOTAL_WORLDS, projected_s, proj_min])
	if proj_min > MAX_WALL_MINUTES:
		push_error("Projected time %.1f min exceeds %.0f min cutoff" % [proj_min, MAX_WALL_MINUTES])
		quit(1)
		return
	var all_hype: Array = []
	var all_truth: Array = []
	var all_rating: Array = []
	var data := _run_worlds_full(TOTAL_WORLDS, 7000, {}, all_hype, all_truth, all_rating)
	var corr := _pearson(all_hype, all_truth)
	var truth_rating_corr := _pearson(all_truth, all_rating)
	print("Hype-truth correlation: %.4f (must be within +-0.1)" % corr)
	print("Truth-rating correlation: %.4f (must be > 0.5)" % truth_rating_corr)
	if truth_rating_corr < 0.5:
		print("VOID: truth-rating correlation %.4f < 0.5" % truth_rating_corr)
		quit(1)
		return
	var sens_ov := {"body": K.BODY_START * 2.0, "skills": K.SKILLS_START * 2.0, "fire": K.FIRE_START * 2.0}
	var sens_hype: Array = []
	var sens_truth: Array = []
	var sens_rating: Array = []
	var sens_data := _run_worlds_full(TOTAL_WORLDS, 7000, sens_ov, sens_hype, sens_truth, sens_rating)
	var sens_corr := _pearson(sens_hype, sens_truth)
	print("Sensitivity hype-truth correlation: %.4f" % sens_corr)
	_report_and_record(data, sens_data, corr, sens_corr, truth_rating_corr, pilot_s, projected_s)


func _run_worlds_full(n_worlds: int, base_seed: int, ov: Dictionary, hype_arr: Array, truth_arr: Array, rating_arr: Array) -> Dictionary:
	var totals := {
		"blind": {"top10": 0, "titles": 0, "reads": 0, "cash": 0, "flops": 0},
		"reader": {"top10": 0, "titles": 0, "reads": 0, "cash": 0, "flops": 0},
		"bad": {"top10": 0, "titles": 0, "reads": 0, "cash": 0, "flops": 0},
		"oracle": {"top10": 0, "titles": 0, "reads": 0, "cash": 0, "flops": 0},
	}
	for w in n_worlds:
		var seed_val := base_seed + w
		for bot in ["blind", "reader", "bad", "oracle"]:
			var res := _run_single_world(bot, seed_val, ov, hype_arr, truth_arr, rating_arr)
			var t: Dictionary = totals[bot]
			t["top10"] += int(res["top10"])
			t["titles"] += int(res["titles"])
			t["reads"] += int(res["reads"])
			t["cash"] += int(res["cash"])
			t["flops"] += int(res["flops"])
	return totals


func _run_single_world(bot: String, seed_val: int, ov: Dictionary, hype_arr: Array, truth_arr: Array, rating_arr: Array) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	var world := WG.generate(seed_val)
	var divs: Dictionary = world["divisions"]
	var boxers: Array = divs[DIV]["boxers"]
	var club := {"cash": 25000, "reads": 0, "fighters": [], "signed_ids": {}}
	var flops := 0
	for m in MONTHS:
		if m == 0 or m == 12 or m == 24 or m == 36:
			var year := m / 12
			var prospects := _get_prospects(world, seed_val, year, club, hype_arr, truth_arr, rating_arr)
			if not prospects.is_empty():
				var pick_res := _choose_signing(bot, prospects, club, ov)
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
				var opp := _pick_bout(f, boxers, rng)
				if not opp.is_empty():
					var line := MM.fight(f, opp, boxers, rng)
					f["since"] = 0
					var purse_take := int(round(float(int(line["purse"]) + int(line["tickets"])) * MM.GYM_SHARE))
					club["cash"] = int(club["cash"]) + purse_take
					if bool(line["won"]):
						K.expose(f["k"], "fire", 4.0, "bout")
					if bool(line["stop"]) and not bool(line["won"]):
						K.stale(f["k"], "knockout")
			var rk := int(f.get("rank", 0))
			if rk > 0:
				f["peak_rank"] = mini(int(f.get("peak_rank", 99)), rk)
				if rk <= 10:
					f["hit_top10"] = true
			if str(f.get("belt", "")) != "":
				f["won_belt"] = true
		if m % 12 == 11:
			WS.year_end(divs, rng)
	var top10 := 0
	var titles := 0
	for f in club["fighters"]:
		if bool(f.get("hit_top10", false)) or int(f.get("peak_rank", 99)) <= 10:
			top10 += 1
		if bool(f.get("won_belt", false)):
			titles += 1
	return {"top10": top10, "titles": titles, "reads": club["reads"], "cash": club["cash"], "flops": flops}


func _get_prospects(world: Dictionary, seed_val: int, year: int, club: Dictionary, hype_arr: Array, truth_arr: Array, rating_arr: Array) -> Array:
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
		var tmp = candidates[i]
		candidates[i] = candidates[j]
		candidates[j] = tmp
	var n := mini(PROSPECTS_PER_SIGNING, candidates.size())
	var list: Array = []
	for idx in n:
		var b: Dictionary = candidates[idx]
		var p_seed := hash([seed_val, year, "p", idx])
		var hype := pool_rng.randf()
		var attrs := AttrGen.attrs_of(b)
		var truth_mean := _attr_mean(attrs)
		var truth_rating := float(b["rating"])
		var pot := clampi(int(truth_rating + (25.0 - float(b["age"])) * 3.0), int(truth_rating) + 5, 95)
		var k := K.fresh(p_seed)
		hype_arr.append(hype)
		truth_arr.append(truth_mean)
		rating_arr.append(truth_rating)
		list.append({
			"name": b.get("name", "Prospect %d" % idx),
			"seed": p_seed,
			"age": int(b["age"]),
			"true_rating": truth_rating,
			"true_mean": truth_mean,
			"pot": pot,
			"hype": hype,
			"attrs": attrs,
			"k": k,
			"world_id": int(b.get("id", 0)),
		})
	return list


func _attr_mean(attrs: Dictionary) -> float:
	var sum := 0.0
	var count := 0
	for a in K.BODY_ATTRS + K.SKILLS_ATTRS + K.FIRE_ATTRS:
		if attrs.has(a):
			sum += float(attrs[a])
			count += 1
	return sum / float(maxi(1, count))


func _shown_centre(p: Dictionary, k: Dictionary, ov: Dictionary) -> float:
	var sum := 0.0
	var attrs: Dictionary = p["attrs"]
	var count := 0
	for a in K.BODY_ATTRS + K.SKILLS_ATTRS + K.FIRE_ATTRS:
		var truth := float(attrs[a])
		var r := _range_of_ov(k, a, truth, float(p["hype"]), ov)
		sum += float(r["centre"])
		count += 1
	return sum / float(maxi(1, count))


func _choose_signing(bot: String, prospects: Array, club: Dictionary, ov: Dictionary) -> Dictionary:
	if bot == "oracle":
		var best_idx := 0
		var best_rating := float(prospects[0]["true_rating"])
		for i in prospects.size():
			if float(prospects[i]["true_rating"]) > best_rating:
				best_rating = float(prospects[i]["true_rating"])
				best_idx = i
		var pick: Dictionary = prospects[best_idx]
		var shown := _shown_centre(pick, pick["k"], {})
		var flop := (float(shown) - float(pick["true_mean"])) >= FLOP_THRESHOLD
		return {"pick": pick, "flop": flop}
	var scored: Array = []
	for p in prospects:
		var c := _shown_centre(p, p["k"], ov)
		scored.append({"p": p, "c": c})
	if bot == "bad":
		scored.sort_custom(func(a, b): return float(a["c"]) < float(b["c"]))
		var pick: Dictionary = scored[0]["p"]
		var shown := float(scored[0]["c"])
		var flop := (shown - float(pick["true_mean"])) >= FLOP_THRESHOLD
		return {"pick": pick, "flop": flop}
	if bot == "blind":
		scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
		var pick: Dictionary = scored[0]["p"]
		var shown := float(scored[0]["c"])
		var flop := (shown - float(pick["true_mean"])) >= FLOP_THRESHOLD
		return {"pick": pick, "flop": flop}
	scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
	var top_c := float(scored[0]["c"])
	for entry in scored:
		var p: Dictionary = entry["p"]
		if float(entry["c"]) >= top_c - 5.0 and int(club["cash"]) >= SCOUT_COST:
			club["cash"] = int(club["cash"]) - SCOUT_COST
			club["reads"] = int(club["reads"]) + SCOUT_COST
			K.expose(p["k"], "skills", 12.0, "session")
			entry["c"] = _shown_centre(p, p["k"], ov)
	scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
	for i in mini(2, scored.size()):
		var p: Dictionary = scored[i]["p"]
		if int(club["cash"]) >= TRIAL_COST:
			club["cash"] = int(club["cash"]) - TRIAL_COST
			club["reads"] = int(club["reads"]) + TRIAL_COST
			K.expose(p["k"], "body", 24.0, "session")
			K.expose(p["k"], "skills", 24.0, "session")
			K.expose(p["k"], "fire", 12.0, "spar")
			scored[i]["c"] = _shown_centre(p, p["k"], ov)
	scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
	var pick: Dictionary = scored[0]["p"]
	if int(club["cash"]) >= TEST_FEE:
		club["cash"] = int(club["cash"]) - TEST_FEE
		club["reads"] = int(club["reads"]) + TEST_FEE
		K.expose(pick["k"], "body", 20.0, "test")
	var shown := float(scored[0]["c"])
	var flop := (shown - float(pick["true_mean"])) >= FLOP_THRESHOLD
	return {"pick": pick, "flop": flop}


## --- Override helpers: Knowledge.range_of with start overrides for sensitivity ---

func _range_of_ov(k: Dictionary, attr: String, truth: float, hype: float, ov: Dictionary) -> Dictionary:
	var w := _attr_width_ov(k, attr, ov)
	if w <= 0.0:
		return {"lo": truth, "hi": truth, "centre": truth, "width": 0.0}
	var offset := _offset_ov(k, attr)
	var lifted := minf(offset + clampf(hype, 0.0, 1.0) * K.HYPE_MAX_LIFT, K.HYPE_CEIL)
	var centre := truth + lifted * w
	var lo := clampf(truth + (lifted - 1.0) * w, 0.0, 100.0)
	var hi := clampf(truth + (lifted + 1.0) * w, 0.0, 100.0)
	return {"lo": lo, "hi": hi, "centre": centre, "width": w}

func _attr_width_ov(k: Dictionary, attr: String, ov: Dictionary) -> float:
	var g := K.group_of(attr)
	if g == "":
		return 0.0
	return _width_ov(k, g, ov)

func _width_ov(k: Dictionary, group: String, ov: Dictionary) -> float:
	if k.get("seen_all", false):
		return 0.0
	var start := _start_of_ov(group, ov)
	if start <= 0.0:
		return 0.0
	var exposure := _eff_exp_ov(k, group)
	return K.FLOOR + (start - K.FLOOR) / (1.0 + exposure / K.HALF)

func _start_of_ov(group: String, ov: Dictionary) -> float:
	if ov.has(group):
		return float(ov[group])
	if group == "body":
		return K.BODY_START
	if group == "skills":
		return K.SKILLS_START
	if group == "fire":
		return K.FIRE_START
	return 0.0

func _eff_exp_ov(k: Dictionary, group: String) -> float:
	if group == "fire":
		return float(k.get("fire_bout", 0.0)) + minf(float(k.get("fire_spar", 0.0)), K.FIRE_SPAR_CAP)
	if group == "body":
		return float(k.get("body", 0.0))
	if group == "skills":
		return float(k.get("skills", 0.0))
	return 0.0

func _offset_ov(k: Dictionary, attr: String) -> float:
	var seed_val := int(k.get("seed", 0))
	var h := hash([seed_val, attr])
	var bucket := absi(h) % 10001
	return float(bucket) / 10000.0 * (K.OFFSET_HI - K.OFFSET_LO) + K.OFFSET_LO


## --- Bout picking ---

func _pick_bout(p: Dictionary, boxers: Array, rng: RandomNumberGenerator) -> Dictionary:
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

func _place_of(b: Dictionary) -> int:
	return int(b["rank"]) if int(b.get("rank", 0)) > 0 else 99


## --- Pearson correlation ---

func _pearson(xs: Array, ys: Array) -> float:
	var n := xs.size()
	if n < 2:
		return 0.0
	var mx := 0.0
	var my := 0.0
	for i in n:
		mx += float(xs[i])
		my += float(ys[i])
	mx /= float(n)
	my /= float(n)
	var num := 0.0
	var dx2 := 0.0
	var dy2 := 0.0
	for i in n:
		var dx := float(xs[i]) - mx
		var dy := float(ys[i]) - my
		num += dx * dy
		dx2 += dx * dx
		dy2 += dy * dy
	var denom := sqrt(dx2 * dy2)
	if denom < 0.0001:
		return 0.0
	return num / denom


## --- Reporting ---

func _report_and_record(data: Dictionary, sens_data: Dictionary, corr: float, sens_corr: float, truth_rating_corr: float, pilot_s: float, projected_s: float) -> void:
	var r: Dictionary = data["reader"]; var b: Dictionary = data["blind"]
	var bad: Dictionary = data["bad"]; var ora: Dictionary = data["oracle"]
	var diff := int(r["top10"]) - int(b["top10"])
	var oracle_minus_blind := int(ora["top10"]) - int(b["top10"])
	var instrument_ok := oracle_minus_blind >= 8 and int(bad["top10"]) < int(b["top10"])
	var pass_ok := instrument_ok and diff >= PASS_MARGIN
	var sr: Dictionary = sens_data["reader"]; var sb: Dictionary = sens_data["blind"]
	var sens_diff := int(sr["top10"]) - int(sb["top10"])
	print("\n=== RESULTS (60 WORLDS, 4 YEARS EACH) ===")
	for bot in ["oracle", "reader", "blind", "bad"]:
		var d: Dictionary = data[bot]
		print("%-6s | top10: %3d | titles: %2d | reads: $%6d | avg_cash: $%6d | flops: %2d" % [bot.to_upper(), int(d["top10"]), int(d["titles"]), int(d["reads"]), int(d["cash"]) / TOTAL_WORLDS, int(d["flops"])])
	print("\n=== SENSITIVITY (DOUBLED STARTS) ===")
	for bot in ["reader", "blind", "bad"]:
		var d: Dictionary = sens_data[bot]
		print("%-6s | top10: %3d | titles: %2d | reads: $%6d | avg_cash: $%6d | flops: %2d" % [bot.to_upper(), int(d["top10"]), int(d["titles"]), int(d["reads"]), int(d["cash"]) / TOTAL_WORLDS, int(d["flops"])])
	print("\n--- PASS LINE ---")
	print("ORACLE (%d) - BLIND (%d) = %+d (need >= +8) %s" % [int(ora["top10"]), int(b["top10"]), oracle_minus_blind, "PASS" if oracle_minus_blind >= 8 else "FAIL"])
	print("Control: BAD (%d) < BLIND (%d): %s" % [int(bad["top10"]), int(b["top10"]), "PASS" if int(bad["top10"]) < int(b["top10"]) else "FAIL"])
	print("INSTRUMENT: %s" % ("ok" if instrument_ok else "VOID"))
	if instrument_ok:
		print("READER (%d) - BLIND (%d) = %+d (need >= +%d) %s" % [int(r["top10"]), int(b["top10"]), diff, PASS_MARGIN, "PASS" if diff >= PASS_MARGIN else "FAIL"])
		var oracle_gap := int(ora["top10"]) - int(b["top10"])
		print("READER share of ORACLE gap: %.1f%%" % (float(diff) / float(maxi(1, oracle_gap)) * 100.0))
	print("Sensitivity: READER (%d) - BLIND (%d) = %+d" % [int(sr["top10"]), int(sb["top10"]), sens_diff])
	print("Hype-truth corr: %.4f (normal), %.4f (sensitivity)" % [corr, sens_corr])
	print("Truth-rating corr: %.4f (must be > 0.5)" % truth_rating_corr)
	var verdict := "VOID" if not instrument_ok else ("ok" if pass_ok else "fail")
	print(verdict)
	print("KNOWBOTS3 done")
	if not instrument_ok:
		print("RESULT: tools/knowbots_probe.gd -> instrument=VOID oracle_minus_blind=%d pass=no sensitivity=%d" % [oracle_minus_blind, sens_diff])
	else:
		print("RESULT: tools/knowbots_probe.gd -> instrument=ok oracle_minus_blind=%d reader_minus_blind=%d pass=%s sensitivity=%d" % [oracle_minus_blind, diff, "yes" if pass_ok else "no", sens_diff])
	_write_result_doc(data, sens_data, diff, sens_diff, corr, sens_corr, truth_rating_corr, oracle_minus_blind, instrument_ok, pass_ok, pilot_s, projected_s)
	quit(0 if pass_ok else 1)


func _write_result_doc(data: Dictionary, sens_data: Dictionary, diff: int, sens_diff: int, corr: float, sens_corr: float, truth_rating_corr: float, oracle_minus_blind: int, instrument_ok: bool, pass_ok: bool, pilot_s: float, projected_s: float) -> void:
	var r: Dictionary = data["reader"]; var b: Dictionary = data["blind"]
	var bad: Dictionary = data["bad"]; var ora: Dictionary = data["oracle"]
	var sr: Dictionary = sens_data["reader"]; var sb: Dictionary = sens_data["blind"]
	var sbad: Dictionary = sens_data["bad"]
	var f := FileAccess.open(RESULT_DOC_PATH, FileAccess.WRITE)
	if f == null:
		return
	var oracle_gap := int(ora["top10"]) - int(b["top10"])
	var reader_share := float(diff) / float(maxi(1, oracle_gap)) if oracle_gap > 0 else 0.0
	var lines := [
		"# KNOWBOTS3 Result: Knowledge with True Attribute Levels as Truth",
		"",
		"Status: PROBE COMPLETE. Discipline: boxing.",
		"Red Test: `tools/knowbots_probe.gd -> KNOWBOTS3 done`",
		"",
		"## 1. What Changed from KNOWBOTS2",
		"KNOWBOTS2 was VOID: the truth was `b[\"shape\"]` (centred around 0), not attribute levels. Results came from",
		"`b[\"rating\"]` which WorldGen rolls independently of shape. Flops compared shown centre (~0-10) with true_rating (~45-70).",
		"",
		"KNOWBOTS3 fixes:",
		"1. TRUTH = `AttrGen.attrs_of(b)` - the boxer's real attribute LEVELS (level + shape + age wear).",
		"2. Print correlation of truth's attribute mean with b[\"rating\"]: must be > 0.5.",
		"3. ORACLE bot: signs the prospect with highest TRUE rating, pays nothing. Instrument ceiling.",
		"4. FLOP: signed boxer's TRUE attribute mean is 5+ under shown centre (same scale now).",
		"",
		"## 2. Results (60 Worlds, 4 Years Each)",
		"| Bot | Top-10 | Titles | Reads Paid | Avg Cash | Flops |",
		"| :--- | :---: | :---: | :---: | :---: | :---: |",
		"| **ORACLE** | **%d** | %d | $0 | $%d | %d |" % [int(ora["top10"]), int(ora["titles"]), int(ora["cash"]) / TOTAL_WORLDS, int(ora["flops"])],
		"| **READER** | **%d** | %d | $%d | $%d | **%d** |" % [int(r["top10"]), int(r["titles"]), int(r["reads"]), int(r["cash"]) / TOTAL_WORLDS, int(r["flops"])],
		"| BLIND | %d | %d | $0 | $%d | %d |" % [int(b["top10"]), int(b["titles"]), int(b["cash"]) / TOTAL_WORLDS, int(b["flops"])],
		"| BAD SIGNER | %d | %d | $0 | $%d | %d |" % [int(bad["top10"]), int(bad["titles"]), int(bad["cash"]) / TOTAL_WORLDS, int(bad["flops"])],
		"",
		"## 3. Sensitivity (Doubled Start Half-Ranges)",
		"| Bot | Top-10 | Titles | Reads Paid | Avg Cash | Flops |",
		"| :--- | :---: | :---: | :---: | :---: | :---: |",
		"| **READER** | **%d** | %d | $%d | $%d | **%d** |" % [int(sr["top10"]), int(sr["titles"]), int(sr["reads"]), int(sr["cash"]) / TOTAL_WORLDS, int(sr["flops"])],
		"| BLIND | %d | %d | $0 | $%d | %d |" % [int(sb["top10"]), int(sb["titles"]), int(sb["cash"]) / TOTAL_WORLDS, int(sb["flops"])],
		"| BAD SIGNER | %d | %d | $0 | $%d | %d |" % [int(sbad["top10"]), int(sbad["titles"]), int(sbad["cash"]) / TOTAL_WORLDS, int(sbad["flops"])],
		"",
		"## 4. Correlations",
		"- Hype-truth correlation: %.4f (must be within +-0.1)" % corr,
		"- Sensitivity correlation: %.4f" % sens_corr,
		"- Truth-rating correlation: %.4f (must be > 0.5)" % truth_rating_corr,
		"",
		"## 5. Pass Line",
		"- ORACLE - BLIND = %+d (need >= +8): %s" % [oracle_minus_blind, "PASS" if oracle_minus_blind >= 8 else "FAIL"],
		"- Control: BAD SIGNER (%d) < BLIND (%d): %s" % [int(bad["top10"]), int(b["top10"]), "PASS" if int(bad["top10"]) < int(b["top10"]) else "FAIL"],
		"- INSTRUMENT: %s" % ("ok" if instrument_ok else "VOID"),
	]
	if instrument_ok:
		lines.append("- READER - BLIND = %+d (need >= +%d): %s" % [diff, PASS_MARGIN, "PASS" if diff >= PASS_MARGIN else "FAIL"])
		lines.append("- READER share of ORACLE gap: %.1f%%" % (reader_share * 100.0))
	lines.append("- Sensitivity: READER - BLIND = %+d" % sens_diff)
	lines.append("")
	lines.append("## 6. Timing")
	lines.append("- Pilot (%d worlds): %.2f s" % [PILOT_WORLDS, pilot_s])
	lines.append("- Projected %d worlds x2: %.2f s (%.2f min)" % [TOTAL_WORLDS, projected_s, projected_s / 60.0])
	lines.append("")
	lines.append("## 7. PR Result Line")
	if instrument_ok:
		lines.append("`RESULT: tools/knowbots_probe.gd -> instrument=ok oracle_minus_blind=%d reader_minus_blind=%d pass=%s sensitivity=%d`" % [
			oracle_minus_blind, diff, "yes" if pass_ok else "no", sens_diff])
	else:
		lines.append("`RESULT: tools/knowbots_probe.gd -> instrument=VOID oracle_minus_blind=%d pass=no sensitivity=%d`" % [oracle_minus_blind, sens_diff])
	for line in lines:
		f.store_line(line)
	f.close()
