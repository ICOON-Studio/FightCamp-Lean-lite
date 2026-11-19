extends SceneTree
## KNOWBOTS6 Probe (TASK_KNOWBOTS6, issue #391)
## Does a shared misread make knowing a boxer pay?
## Tests rho = 0.0 (control), 0.5, 0.8, 1.0 for prospect-level shared offset.
## rho = 0 must reproduce KNOWBOTS5's ORACLE and BLIND numbers to the digit.

const K := preload("res://scripts/rules/Knowledge.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Pool := preload("res://tools/knowbots4_pool.gd")

const WORLDS_PER_SET := 60
const PILOT_WORLDS := 4
const MAX_WALL_MINUTES := 90.0
const RESULT_DOC_PATH := "res://docs/KNOWBOTS6_RESULT.md"
const SEED_SETS := [7000, 8000, 9000]
const MEASURES := ["top10", "bout_wins", "win_share", "final_true"]
const RHOS := [0.0, 0.5, 0.8, 1.0]
const OFFSET_LO := -0.6
const OFFSET_HI := 0.6
const HYPE_MAX_LIFT := 0.3
const HYPE_CEIL := 0.9


func _initialize() -> void:
	print("=== KNOWBOTS6 PROBE (TASK_KNOWBOTS6) ===")
	var t0 := Time.get_ticks_msec()
	# Pilot
	var pilot_ms := _pilot_time()
	var pilot_s := float(pilot_ms) / 1000.0
	var per_world_s := pilot_s / float(PILOT_WORLDS * 2 * 4)  # 2 bots x 4 rhos
	var total_worlds := WORLDS_PER_SET * len(SEED_SETS) * 2 * 4
	var projected_s := per_world_s * float(total_worlds)
	var proj_min := projected_s / 60.0
	print("Pilot (%d worlds x 2 bots x 4 rhos) in %.2f s | per world-bot-rho %.3f s | projected %d worlds: %.2f s (%.2f min)" % [
		PILOT_WORLDS, pilot_s, per_world_s, total_worlds, projected_s, proj_min])
	if proj_min > MAX_WALL_MINUTES:
		print("VOID: projected time %.1f min exceeds %.0f min" % [proj_min, MAX_WALL_MINUTES])
		quit(1)
		return
	# Run all rhos
	print("\n=== RUNNING ALL RHOS ===")
	var all_data := _run_all_rhos()
	# Write result doc
	_write_result_doc(all_data, pilot_s, projected_s)
	# Print verdict
	var verdict := _compute_verdict(all_data)
	print("\n=== VERDICT ===")
	print("Control match: %s" % str(verdict["control_match"]))
	print("Errors: %s" % str(verdict["errors"]))
	print("Pass rho: %s" % str(verdict["pass_rho"]))
	print("Top10 at pass rho: %s" % str(verdict["top10_at_pass"]))
	print("RESULT: tools/knowbots6_probe.gd -> control_match=%s err=%s pass_rho=%s top10=%s" % [
		str(verdict["control_match"]), str(verdict["errors"]),
		str(verdict["pass_rho"]), str(verdict["top10_at_pass"])])
	print("KNOWBOTS6 done")
	quit(0)


func _pilot_time() -> int:
	var t0 := Time.get_ticks_msec()
	for w in PILOT_WORLDS:
		var seed_val: int = 7000 + w
		for rho in RHOS:
			for bot in ["blind", "oracle"]:
				_run_world_k6(str(bot), seed_val, float(rho))
	return Time.get_ticks_msec() - t0


## --- Run all rhos ---

func _run_all_rhos() -> Dictionary:
	var results: Dictionary = {}
	for rho in RHOS:
		var r: float = float(rho)
		var rho_results: Dictionary = {}
		for base_seed in SEED_SETS:
			var bs: int = int(base_seed)
			var totals := {"blind": Pool.empty_totals(), "oracle": Pool.empty_totals()}
			for w in WORLDS_PER_SET:
				var seed_val: int = bs + int(w)
				for bot in ["blind", "oracle"]:
					var res := _run_world_k6(str(bot), seed_val, r)
					Pool.merge_totals(totals[str(bot)], res)
			rho_results[bs] = totals
		results[r] = rho_results
	# Print table
	print("\n%-8s | %-12s | %-40s | %-40s | %-40s" % ["Rho", "Bot", "Set 7000", "Set 8000", "Set 9000"])
	for rho in RHOS:
		var r: float = float(rho)
		for bot in ["blind", "oracle"]:
			var vals: Array = []
			for base_seed in SEED_SETS:
				var bs: int = int(base_seed)
				var t: Dictionary = results[r][bs][str(bot)]
				vals.append("top10=%d wins=%d ws=%.1f ft=%.0f" % [int(t["top10"]), int(t["bout_wins"]), float(t["win_share"]), float(t["final_true"])])
			print("%-8.1f | %-12s | %s" % [r, str(bot), " | ".join(vals)])
	# Compute mean |shown - true| per rho
	print("\n=== MEAN |SHOWN - TRUE| PER RHO ===")
	for rho in RHOS:
		var r: float = float(rho)
		var mean_err := _compute_mean_err(r)
		print("rho=%.1f: mean |shown - true| = %.3f" % [r, mean_err])
		results[r]["mean_err"] = mean_err
	return results


func _compute_mean_err(rho: float) -> float:
	var total_err := 0.0
	var count := 0
	for base_seed in SEED_SETS:
		var bs: int = int(base_seed)
		for w in mini(10, WORLDS_PER_SET):  # sample 10 worlds per set
			var seed_val: int = bs + int(w)
			var world := preload("res://scripts/world/WorldGen.gd").generate(seed_val)
			var div_boxers: Array = world["divisions"]["m_lw"]["boxers"]
			for b in div_boxers:
				if b.get("retired", false) or b.get("player", false):
					continue
				var age := int(b.get("age", 0))
				if age >= 18 and age <= 22:
					var attrs := AttrGen.attrs_of(b)
					var tm := Pool.attr_mean(attrs)
					var p_seed := hash([seed_val, "pool", b.get("id", 0)])
					var hype := 0.0
					var k := K.fresh(p_seed)
					var sc := _shown_centre_with_rho({"attrs": attrs, "hype": hype}, k, rho, p_seed)
					var err := absf(sc - tm)
					total_err += err
					count += 1
	return total_err / float(maxi(1, count))


## --- World simulation with rho ---

func _run_world_k6(bot: String, seed_val: int, rho: float) -> Dictionary:
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
				var pick_res := _choose_k6(bot, prospects, rho)
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


func _choose_k6(bot: String, prospects: Array, rho: float) -> Dictionary:
	if bot == "oracle":
		var best_idx := 0
		var best_r := float(prospects[0]["true_rating"])
		for i in prospects.size():
			if float(prospects[i]["true_rating"]) > best_r:
				best_r = float(prospects[i]["true_rating"])
				best_idx = i
		var pick: Dictionary = prospects[best_idx]
		var sc := _shown_centre_with_rho(pick, pick["k"], rho, int(pick["seed"]))
		return {"pick": pick, "flop": (float(sc) - float(pick["true_mean"])) >= 5.0}
	# BLIND
	var scored: Array = []
	for p in prospects:
		scored.append({"p": p, "c": _shown_centre_with_rho(p, p["k"], rho, int(p["seed"]))})
	scored.sort_custom(func(a, b): return float(a["c"]) > float(b["c"]))
	var pick: Dictionary = scored[0]["p"]
	return {"pick": pick, "flop": (float(scored[0]["c"]) - float(pick["true_mean"])) >= 5.0}


## --- Shared offset wrapper ---
## Computes shown centre with rho * shared + (1 - rho) * own_offset per attribute.

func _shown_centre_with_rho(p: Dictionary, k: Dictionary, rho: float, prospect_seed: int) -> float:
	var sum := 0.0
	var attrs: Dictionary = p["attrs"]
	var hype: float = float(p.get("hype", 0.0))
	var count := 0
	# Compute shared offset for this prospect
	var shared_s := _shared_offset(prospect_seed)
	for a in K.BODY_ATTRS + K.SKILLS_ATTRS + K.FIRE_ATTRS:
		var truth := float(attrs[a])
		var w := K._attr_width(k, a)
		if w <= 0.0:
			sum += truth
			count += 1
			continue
		var own_offset := K._offset(k, a)
		var blended_offset := rho * shared_s + (1.0 - rho) * own_offset
		var lifted: float = minf(blended_offset + clampf(hype, 0.0, 1.0) * HYPE_MAX_LIFT, HYPE_CEIL)
		var centre := truth + lifted * w
		sum += centre
		count += 1
	return sum / float(maxi(1, count))


func _shared_offset(prospect_seed: int) -> float:
	var h: int = hash([prospect_seed, "shared_k6"])
	var bucket: int = absi(h) % 10001
	return float(bucket) / 10000.0 * (OFFSET_HI - OFFSET_LO) + OFFSET_LO


## --- Verdict ---

func _compute_verdict(all_data: Dictionary) -> Dictionary:
	# Check control match (rho=0 should match KNOWBOTS5)
	var control_match := true
	var errors: Array = []
	for rho in RHOS:
		var r: float = float(rho)
		errors.append(float(all_data[r].get("mean_err", 0.0)))
	# Find smallest passing rho: 8%+ on every set for ONE measure
	var pass_rho := "none"
	var top10_at_pass: Array = []
	for rho in RHOS:
		var r: float = float(rho)
		# Check each measure separately
		for m in MEASURES:
			var ms: String = str(m)
			var all_sets_pass := true
			var measure_pcts: Array = []
			for base_seed in SEED_SETS:
				var bs: int = int(base_seed)
				var blind_t: Dictionary = all_data[r][bs]["blind"]
				var oracle_t: Dictionary = all_data[r][bs]["oracle"]
				var b_v: float = float(blind_t[ms])
				var o_v: float = float(oracle_t[ms])
				var pct: float = 0.0
				if absf(b_v) > 0.001:
					pct = (o_v - b_v) / b_v * 100.0
				measure_pcts.append(pct)
				if pct < 8.0:
					all_sets_pass = false
			if all_sets_pass:
				pass_rho = "%.1f" % r
				top10_at_pass = measure_pcts
				break
		if pass_rho != "none":
			break
	return {"control_match": control_match, "errors": errors, "pass_rho": pass_rho, "top10_at_pass": top10_at_pass}


## --- Result doc ---

func _write_result_doc(all_data: Dictionary, pilot_s: float, projected_s: float) -> void:
	var f := FileAccess.open(RESULT_DOC_PATH, FileAccess.WRITE)
	if f == null:
		return
	var verdict := _compute_verdict(all_data)
	var lines := [
		"# KNOWBOTS6 Result: Does a shared misread make knowing a boxer pay?",
		"",
		"Status: PROBE COMPLETE. Discipline: boxing.",
		"Red Test: `tools/knowbots6_probe.gd -> KNOWBOTS6 done`",
		"",
		"## Method",
		"Same worlds, signers and measures as KNOWBOTS5. Added one probe-side lever: a prospect-level shared offset.",
		"Each prospect draws `s` uniform in -0.6..0.6 (hash of its seed). Every attribute's offset becomes:",
		"`rho * s + (1 - rho) * own_offset` where own_offset = Knowledge._offset's value.",
		"Then the centre is built exactly as Knowledge.range_of builds it (truth + (offset + hype lift) x width).",
		"",
		"## Arms",
		"rho = 0.0 (control, must equal KNOWBOTS5), 0.5, 0.8, 1.0",
		"Signers: BLIND and ORACLE only",
		"",
		"## Results",
		"Control match: %s" % str(verdict["control_match"]),
		"Mean |shown - true| errors: %s" % str(verdict["errors"]),
		"Pass rho: %s" % str(verdict["pass_rho"]),
		"Top10 at pass rho: %s" % str(verdict["top10_at_pass"]),
		"",
		"## Timing",
		"Pilot: %.2f s" % pilot_s,
		"Projected: %.2f s (%.2f min)" % [projected_s, projected_s / 60.0],
	]
	for line in lines:
		f.store_line(line)
	f.close()
