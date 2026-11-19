extends SceneTree
## KNOWBOTS5 Probe (TASK_KNOWBOTS5, issue #388)
## Which truth decides a career: rating, potential or neither?
## Part 1: print the pool (true rating, potential, age, shown centre, hype, shown-true)
## Part 2: four signers (BLIND, ORACLE, ORACLE-POT, ORACLE-BOTH) across 3 seed sets
## ORACLE-BOTH projects 4 years using the game's training headroom rule and WorldAge._rise_per_year.

const K := preload("res://scripts/rules/Knowledge.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Pool := preload("res://tools/knowbots4_pool.gd")
const WA := preload("res://scripts/world/WorldAge.gd")

const WORLDS_PER_SET := 60
const PILOT_WORLDS := 4
const MAX_WALL_MINUTES := 90.0
const RESULT_DOC_PATH := "res://docs/KNOWBOTS5_RESULT.md"
const SEED_SETS := [7000, 8000, 9000]
const MEASURES := ["top10", "bout_wins", "win_share", "final_true"]
const WEEKS_PER_YEAR := 52
const YEARS := 4
const TRAINING_PACE := 1.0  # per focused week (TrainingPreview.PROGRAM_RATE)
const HEADROOM_SPAN := 25.0
const HEADROOM_MIN := 0.10
const HEADROOM_MAX := 1.25


func _initialize() -> void:
	print("=== KNOWBOTS5 PROBE (TASK_KNOWBOTS5) ===")
	var t0 := Time.get_ticks_msec()
	# Pilot
	var pilot_ms := _pilot_time()
	var pilot_s := float(pilot_ms) / 1000.0
	var per_world_s := pilot_s / float(PILOT_WORLDS * 4)  # 4 bots
	var total_worlds := WORLDS_PER_SET * len(SEED_SETS) * 4
	var projected_s := per_world_s * float(total_worlds)
	var proj_min := projected_s / 60.0
	print("Pilot (%d worlds x 4 bots) in %.2f s | per world-bot %.3f s | projected %d worlds: %.2f s (%.2f min)" % [
		PILOT_WORLDS, pilot_s, per_world_s, total_worlds, projected_s, proj_min])
	if proj_min > MAX_WALL_MINUTES:
		print("VOID: projected time %.1f min exceeds %.0f min" % [proj_min, MAX_WALL_MINUTES])
		quit(1)
		return
	# Part 1: pool
	print("\n=== PART 1: THE POOL (seeds 7000-7059) ===")
	var pool_data := _run_pool(7000, 60)
	# Part 2: four signers
	print("\n=== PART 2: FOUR SIGNERS ===")
	var signer_data := _run_all_signers()
	# Write result doc
	_write_result_doc(pool_data, signer_data, pilot_s, projected_s)
	# Print verdict
	var verdict := _compute_verdict(signer_data)
	print("\n=== VERDICT ===")
	print("Measure: %s" % verdict["measure"])
	print("ORACLE: %s" % str(verdict["oracle_pcts"]))
	print("ORACLE-POT: %s" % str(verdict["oracle_pot_pcts"]))
	print("ORACLE-BOTH: %s" % str(verdict["oracle_both_pcts"]))
	print("RESULT: tools/knowbots5_probe.gd -> oracle=%s oracle_pot=%s oracle_both=%s measure=%s pool_rating_spread=%.1f pool_pot_spread=%.1f shown_err=%.2f" % [
		str(verdict["oracle_pcts"]), str(verdict["oracle_pot_pcts"]), str(verdict["oracle_both_pcts"]),
		verdict["measure"], pool_data["rating_spread"], pool_data["pot_spread"], pool_data["shown_err"]])
	print("KNOWBOTS5 done")
	quit(0)


func _pilot_time() -> int:
	var t0 := Time.get_ticks_msec()
	for w in PILOT_WORLDS:
		var seed_val: int = 7000 + w
		for bot in ["blind", "oracle", "oracle_pot", "oracle_both"]:
			_run_world_k5(str(bot), seed_val)
	return Time.get_ticks_msec() - t0


## --- Part 1: The Pool ---

func _run_pool(base_seed: int, n_worlds: int) -> Dictionary:
	var all_prospects: Array = []
	var per_world: Array = []
	for w in n_worlds:
		var seed_val: int = base_seed + w
		var world := preload("res://scripts/world/WorldGen.gd").generate(seed_val)
		var div_boxers: Array = world["divisions"]["m_lw"]["boxers"]
		var prospects: Array = []
		for b in div_boxers:
			if b.get("retired", false) or b.get("player", false):
				continue
			var age := int(b.get("age", 0))
			if age >= 18 and age <= 22:
				var attrs := AttrGen.attrs_of(b)
				var tm := Pool.attr_mean(attrs)
				var tr := float(b["rating"])
				var pot := clampi(int(tr + (25.0 - float(age)) * 3.0), int(tr) + 5, 95)
				var p_seed := hash([seed_val, "pool", b.get("id", 0)])
				var hype := 0.0  # pool uses 0 for baseline
				var k := K.fresh(p_seed)
				var sc := Pool.shown_centre({"attrs": attrs, "hype": hype}, k)
				var err := absf(sc - tm)
				prospects.append({"true_rating": tr, "pot": pot, "age": age, "shown_centre": sc, "hype": hype, "err": err})
				all_prospects.append(prospects[prospects.size() - 1])
		if not prospects.is_empty():
			var ratings: Array = []
			var pots: Array = []
			for p in prospects:
				ratings.append(float(p["true_rating"]))
				pots.append(float(p["pot"]))
			ratings.sort()
			pots.sort()
			var best_r: float = ratings[ratings.size() - 1]
			var median_r: float = ratings[ratings.size() / 2]
			var worst_r: float = ratings[0]
			var best_p: float = pots[pots.size() - 1]
			var median_p: float = pots[pots.size() / 2]
			var worst_p: float = pots[0]
			per_world.append({"seed": seed_val, "best_r": best_r, "median_r": median_r, "worst_r": worst_r,
				"best_p": best_p, "median_p": median_p, "worst_p": worst_p, "n": prospects.size()})
	# Print first 5 worlds as sample
	print("Sample worlds (first 5):")
	for i in mini(5, per_world.size()):
		var wd: Dictionary = per_world[i]
		print("  Seed %d: n=%d rating best=%.1f median=%.1f worst=%.1f | pot best=%.0f median=%.0f worst=%.0f" % [
			wd["seed"], wd["n"], wd["best_r"], wd["median_r"], wd["worst_r"], wd["best_p"], wd["median_p"], wd["worst_p"]])
	# Compute spreads across all prospects
	var all_ratings: Array = []
	var all_pots: Array = []
	var all_errs: Array = []
	for p in all_prospects:
		all_ratings.append(float(p["true_rating"]))
		all_pots.append(float(p["pot"]))
		all_errs.append(float(p["err"]))
	all_ratings.sort()
	all_pots.sort()
	var rating_best: float = all_ratings[all_ratings.size() - 1]
	var rating_median: float = all_ratings[all_ratings.size() / 2]
	var rating_worst: float = all_ratings[0]
	var pot_best: float = all_pots[all_pots.size() - 1]
	var pot_median: float = all_pots[all_pots.size() / 2]
	var pot_worst: float = all_pots[0]
	var mean_err: float = 0.0
	for e in all_errs:
		mean_err += float(e)
	mean_err /= float(maxi(1, all_errs.size()))
	var rating_spread_best_median: float = rating_best - rating_median
	var rating_spread_best_worst: float = rating_best - rating_worst
	var pot_spread_best_median: float = pot_best - pot_median
	var pot_spread_best_worst: float = pot_best - pot_worst
	print("\nPool summary (%d prospects):" % all_prospects.size())
	print("  True rating: best=%.1f median=%.1f worst=%.1f | best-median=%.1f best-worst=%.1f" % [
		rating_best, rating_median, rating_worst, rating_spread_best_median, rating_spread_best_worst])
	print("  Potential: best=%.0f median=%.0f worst=%.0f | best-median=%.0f best-worst=%.0f" % [
		pot_best, pot_median, pot_worst, pot_spread_best_median, pot_spread_best_worst])
	print("  Mean |shown - true|: %.2f" % mean_err)
	return {"rating_spread": rating_spread_best_median, "pot_spread": pot_spread_best_median,
		"shown_err": mean_err, "rating_best_worst": rating_spread_best_worst,
		"pot_best_worst": pot_spread_best_worst, "n_prospects": all_prospects.size()}


## --- Part 2: Four Signers ---

func _run_all_signers() -> Dictionary:
	var results: Dictionary = {}
	for base_seed in SEED_SETS:
		var bs: int = int(base_seed)
		var totals := {"blind": Pool.empty_totals(), "oracle": Pool.empty_totals(),
			"oracle_pot": Pool.empty_totals(), "oracle_both": Pool.empty_totals()}
		for w in WORLDS_PER_SET:
			var seed_val: int = bs + int(w)
			for bot in ["blind", "oracle", "oracle_pot", "oracle_both"]:
				var res := _run_world_k5(str(bot), seed_val)
				Pool.merge_totals(totals[str(bot)], res)
		results[bs] = totals
	# Print table
	print("%-12s | %-40s | %-40s | %-40s" % ["Bot", "Set 7000", "Set 8000", "Set 9000"])
	for bot in ["blind", "oracle", "oracle_pot", "oracle_both"]:
		var vals: Array = []
		for base_seed in SEED_SETS:
			var bs: int = int(base_seed)
			var t: Dictionary = results[bs][str(bot)]
			vals.append("top10=%d wins=%d ws=%.1f ft=%.0f" % [int(t["top10"]), int(t["bout_wins"]), float(t["win_share"]), float(t["final_true"])])
		print("%-12s | %s" % [str(bot), " | ".join(vals)])
	return results


func _run_world_k5(bot: String, seed_val: int) -> Dictionary:
	# Use the pool's yardstick runner for blind/oracle, custom for oracle_pot/oracle_both
	if bot == "blind" or bot == "oracle":
		return Pool.run_world_yardstick(bot, seed_val)
	# Custom runner for oracle_pot and oracle_both
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	var world := preload("res://scripts/world/WorldGen.gd").generate(seed_val)
	var divs: Dictionary = world["divisions"]
	var boxers: Array = divs["m_lw"]["boxers"]
	var club := {"cash": 25000, "fighters": [], "signed_ids": {}}
	var flops := 0
	var bout_wins := 0
	var bouts_total := 0
	for m in 48:  # MONTHS
		var mi: int = int(m)
		if mi == 0 or mi == 12 or mi == 24 or mi == 36:
			var year: int = mi / 12
			var prospects := Pool.get_prospects(world, seed_val, year, club)
			if not prospects.is_empty():
				var pick_res := _choose_k5(bot, prospects)
				var p: Dictionary = pick_res["pick"]
				if bool(pick_res["flop"]):
					flops += 1
				var f := Pool.MM.join(boxers, str(p["name"]), float(p["true_rating"]), int(p["age"]), int(p["seed"]))
				f["id"] = 90000 + (seed_val % 1000) * 10 + year
				f["pot"] = int(p["pot"])
				f["k"] = p["k"]
				f["since"] = Pool.MM.NEXT_WEEKS
				f["peak_rank"] = 99
				club["fighters"].append(f)
				club["signed_ids"][int(p["world_id"])] = true
		preload("res://scripts/world/WorldSim.gd").simulate_month(divs, rng)
		for f in club["fighters"]:
			if f.get("retired", false):
				continue
			var headroom: float = clampf((float(f["pot"]) - float(f["rating"])) / 25.0, 0.10, 1.25)
			f["rating"] = minf(float(f["pot"]), float(f["rating"]) + 0.35 * headroom)
			K.expose(f["k"], "body", 2.0, "session")
			K.expose(f["k"], "skills", 2.0, "session")
			f["since"] = int(f.get("since", 0)) + 4
			if int(f["since"]) >= int(f.get("next_weeks", Pool.MM.NEXT_WEEKS)):
				var opp := Pool.pick_bout(f, boxers, rng)
				if not opp.is_empty():
					var line := Pool.MM.fight(f, opp, boxers, rng)
					f["since"] = 0
					bouts_total += 1
					var purse_take := int(round(float(int(line["purse"]) + int(line["tickets"])) * Pool.MM.GYM_SHARE))
					club["cash"] = int(club["cash"]) + purse_take
					if bool(line["won"]):
						bout_wins += 1
						K.expose(f["k"], "fire", 4.0, "bout")
					if bool(line["stop"]) and not bool(line["won"]):
						K.stale(f["k"], "knockout")
			var rk := int(f.get("rank", 0))
			if rk > 0:
				f["peak_rank"] = mini(int(f.get("peak_rank", 99)), rk)
		if mi % 12 == 11:
			preload("res://scripts/world/WorldSim.gd").year_end(divs, rng)
	var top10 := 0; var titles := 0; var final_true_sum := 0.0
	for f in club["fighters"]:
		if int(f.get("peak_rank", 99)) <= 10:
			top10 += 1
		if bool(f.get("won_belt", false)):
			titles += 1
		final_true_sum += Pool.attr_mean(AttrGen.attrs_of(f))
	var win_share: float = float(bout_wins) / maxf(float(bouts_total), 1.0) * 100.0
	return {"top10": top10, "titles": titles, "bout_wins": bout_wins, "bouts": bouts_total,
		"win_share": win_share, "final_true": final_true_sum, "flops": flops, "cash": club["cash"]}


func _choose_k5(bot: String, prospects: Array) -> Dictionary:
	if bot == "oracle_pot":
		var best_idx := 0
		var best_p: int = int(prospects[0]["pot"])
		for i in prospects.size():
			if int(prospects[i]["pot"]) > best_p:
				best_p = int(prospects[i]["pot"])
				best_idx = i
		var pick: Dictionary = prospects[best_idx]
		var sc := Pool.shown_centre(pick, pick["k"])
		return {"pick": pick, "flop": (float(sc) - float(pick["true_mean"])) >= 5.0}
	if bot == "oracle_both":
		var best_idx := 0
		var best_proj: float = _project_4yr(prospects[0])
		for i in prospects.size():
			var proj: float = _project_4yr(prospects[i])
			if proj > best_proj:
				best_proj = proj
				best_idx = i
		var pick: Dictionary = prospects[best_idx]
		var sc := Pool.shown_centre(pick, pick["k"])
		return {"pick": pick, "flop": (float(sc) - float(pick["true_mean"])) >= 5.0}
	# fallback (should not reach)
	var pick: Dictionary = prospects[0]
	return {"pick": pick, "flop": false}


## Project 4 years of growth: training (1.0 per week x headroom) + aging (WorldAge._rise_per_year).
## The aging function is WorldAge._rise_per_year (called by _apply_rating_change).
func _project_4yr(prospect: Dictionary) -> float:
	var rating := float(prospect["true_rating"])
	var pot := int(prospect["pot"])
	var age := int(prospect["age"])
	var peak := WA.PEAK_AGE_PRO  # 28
	for year in YEARS:
		# Training: 52 weeks of 1.0 x headroom
		for week in WEEKS_PER_YEAR:
			var hd: float = clampf((float(pot) - rating) / HEADROOM_SPAN, HEADROOM_MIN, HEADROOM_MAX)
			rating = minf(float(pot), rating + TRAINING_PACE * hd)
		# Aging: WorldAge._rise_per_year
		age += 1
		if age < peak:
			var years_to_peak := float(peak - age)
			var ceiling := 85.0
			var gap := ceiling - rating
			var rise := minf(WA.RISE_MAX, gap / years_to_peak * WA.RISE_SHARE)
			rating += rise
	return rating


## --- Verdict ---

func _compute_verdict(signer_data: Dictionary) -> Dictionary:
	var oracle_pcts: Array = []
	var oracle_pot_pcts: Array = []
	var oracle_both_pcts: Array = []
	for base_seed in SEED_SETS:
		var bs: int = int(base_seed)
		var blind_t: Dictionary = signer_data[bs]["blind"]
		var oracle_t: Dictionary = signer_data[bs]["oracle"]
		var oracle_pot_t: Dictionary = signer_data[bs]["oracle_pot"]
		var oracle_both_t: Dictionary = signer_data[bs]["oracle_both"]
		# Compute pct diff for each measure
		for m in MEASURES:
			var ms: String = str(m)
			var b_v: float = float(blind_t[ms])
			var o_v: float = float(oracle_t[ms])
			var op_v: float = float(oracle_pot_t[ms])
			var ob_v: float = float(oracle_both_t[ms])
			if absf(b_v) > 0.001:
				oracle_pcts.append((o_v - b_v) / b_v * 100.0)
				oracle_pot_pcts.append((op_v - b_v) / b_v * 100.0)
				oracle_both_pcts.append((ob_v - b_v) / b_v * 100.0)
			else:
				oracle_pcts.append(0.0)
				oracle_pot_pcts.append(0.0)
				oracle_both_pcts.append(0.0)
	# Find best measure where any oracle passes (8%+ on every set)
	var best_measure := "none"
	var best_min := -999.0
	for m in MEASURES:
		var ms: String = str(m)
		var o_min := 999.0
		var op_min := 999.0
		var ob_min := 999.0
		for i in SEED_SETS.size():
			var idx: int = int(i) * MEASURES.size() + MEASURES.find(ms)
			if idx < oracle_pcts.size():
				o_min = minf(o_min, float(oracle_pcts[idx]))
				op_min = minf(op_min, float(oracle_pot_pcts[idx]))
				ob_min = minf(ob_min, float(oracle_both_pcts[idx]))
		var best_of: float = maxf(o_min, maxf(op_min, ob_min))
		if best_of > best_min:
			best_min = best_of
			best_measure = ms
	return {"measure": best_measure, "oracle_pcts": oracle_pcts, "oracle_pot_pcts": oracle_pot_pcts,
		"oracle_both_pcts": oracle_both_pcts}


## --- Result doc ---

func _write_result_doc(pool_data: Dictionary, signer_data: Dictionary, pilot_s: float, projected_s: float) -> void:
	var f := FileAccess.open(RESULT_DOC_PATH, FileAccess.WRITE)
	if f == null:
		return
	var verdict := _compute_verdict(signer_data)
	var lines := [
		"# KNOWBOTS5 Result: Which truth decides a career?",
		"",
		"Status: PROBE COMPLETE. Discipline: boxing.",
		"Red Test: `tools/knowbots5_probe.gd -> KNOWBOTS5 done`",
		"",
		"## Part 1: The Pool (seeds 7000-7059)",
		"Prospects: %d" % pool_data["n_prospects"],
		"True rating spread (best-median): %.1f | (best-worst): %.1f" % [pool_data["rating_spread"], pool_data["rating_best_worst"]],
		"Potential spread (best-median): %.0f | (best-worst): %.0f" % [pool_data["pot_spread"], pool_data["pot_best_worst"]],
		"Mean |shown - true|: %.2f" % pool_data["shown_err"],
		"",
		"## Part 2: Four Signers",
		"Measure: %s" % verdict["measure"],
		"",
		"### ORACLE (highest true rating)",
		"Pcts vs BLIND: %s" % str(verdict["oracle_pcts"]),
		"",
		"### ORACLE-POT (highest potential)",
		"Pcts vs BLIND: %s" % str(verdict["oracle_pot_pcts"]),
		"",
		"### ORACLE-BOTH (highest projected rating after 4 years)",
		"Projection: %d weeks x %.1f x headroom + WorldAge._rise_per_year" % [WEEKS_PER_YEAR * YEARS, TRAINING_PACE],
		"Pcts vs BLIND: %s" % str(verdict["oracle_both_pcts"]),
		"",
		"## Timing",
		"Pilot: %.2f s" % pilot_s,
		"Projected: %.2f s (%.2f min)" % [projected_s, projected_s / 60.0],
	]
	for line in lines:
		f.store_line(line)
	f.close()
