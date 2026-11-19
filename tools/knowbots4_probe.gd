extends SceneTree
## KNOWBOTS4 Probe (TASK_KNOWBOTS4, issue #379)
## Knowledge v3 probes K1/K3/K4, yardstick first.
## Part 1: yardstick - pick the measure where ORACLE - BLIND is largest and stable.
## Part 2: K1 (READER vs BLIND), K3 (read mix), K4 (leak bot).
## Three seed sets: 7000-7059, 8000-8059, 9000-9059. 4 years each.
## Result doc written BY THE PROBE from its own numbers.

const K := preload("res://scripts/rules/Knowledge.gd")
const KR := preload("res://scripts/rules/KnowReads.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Pool := preload("res://tools/knowbots4_pool.gd")

const WORLDS_PER_SET := 60
const PILOT_WORLDS := 4
const MAX_WALL_MINUTES := 90.0
const RESULT_DOC_PATH := "res://docs/KNOWBOTS4_RESULT.md"
const SEED_SETS := [7000, 8000, 9000]
const MEASURES := ["top10", "titles", "bout_wins", "win_share", "final_true"]


func _initialize() -> void:
	print("=== KNOWBOTS4 PROBE (TASK_KNOWBOTS4) ===")
	var t0 := Time.get_ticks_msec()
	# Pilot
	var pilot_data := _run_set_yardstick(PILOT_WORLDS, 7000)
	var pilot_ms := Time.get_ticks_msec() - t0
	var pilot_s := float(pilot_ms) / 1000.0
	var per_world_s := pilot_s / float(PILOT_WORLDS)
	var total_worlds := WORLDS_PER_SET * len(SEED_SETS) * 2
	var projected_s := per_world_s * float(total_worlds)
	var proj_min := projected_s / 60.0
	print("Pilot (%d worlds) in %.2f s | per world %.2f s | projected %d worlds: %.2f s (%.2f min)" % [
		PILOT_WORLDS, pilot_s, per_world_s, total_worlds, projected_s, proj_min])
	if proj_min > MAX_WALL_MINUTES:
		print("VOID: projected time %.1f min exceeds %.0f min" % [proj_min, MAX_WALL_MINUTES])
		quit(1)
		return
	# Part 1: yardstick on three seed sets
	print("\n=== PART 1: YARDSTICK ===")
	var yardstick := _run_yardstick()
	# Hype-truth correlation sample
	var corr := _hype_truth_corr()
	print("Hype-truth correlation: %.4f (must be within +-0.1)" % corr)
	if yardstick["measure"] == "VOID":
		_write_void_result(yardstick, corr)
		print("RESULT: tools/knowbots4_probe.gd -> yardstick=VOID")
		print("KNOWBOTS4 done")
		quit(0)
		return
	# Part 2: K1, K3, K4
	print("\n=== PART 2: K1/K3/K4 ===")
	var k_results := _run_k1_k3_k4(yardstick)
	# 5 sample prospects for the trap check
	_sample_prospects()
	_write_result_doc(yardstick, k_results, corr, pilot_s, projected_s)
	var k1_str := "pass" if k_results["k1_pass"] else "fail"
	var k3_str := "pass" if k_results["k3_pass"] else "fail"
	var k4_str := "pass" if k_results["k4_pass"] else "fail"
	print("RESULT: tools/knowbots4_probe.gd -> yardstick=%s oracle_minus_blind=%s reader_minus_blind=%s k1=%s k3=%s k4=%s" % [
		yardstick["measure"], str(yardstick["oracle_minus_blind"]), str(yardstick["reader_minus_blind"]),
		k1_str, k3_str, k4_str])
	print("KNOWBOTS4 done")
	quit(0)


## --- Part 1: Yardstick ---

func _run_yardstick() -> Dictionary:
	var set_results: Array = []
	for base_seed in SEED_SETS:
		var data := _run_set_yardstick(WORLDS_PER_SET, base_seed)
		set_results.append(data)
	# Print side by side
	print("%-12s | %-24s | %-24s | %-24s" % ["Measure", "Set 7000", "Set 8000", "Set 9000"])
	for m in MEASURES:
		var vals: Array = []
		for sd in set_results:
			var ora_v: float = float(sd["oracle"][m])
			var bli_v: float = float(sd["blind"][m])
			vals.append("O=%.1f B=%.1f" % [ora_v, bli_v])
		print("%-12s | %s" % [m, " | ".join(vals)])
	# Find best stable measure
	var best_measure := "VOID"
	var best_min_pct := -1.0
	var omb_per_set: Array = []
	for m in MEASURES:
		var pcts: Array = []
		var omb_set: Array = []
		for sd in set_results:
			var ora_v: float = float(sd["oracle"][m])
			var bli_v: float = float(sd["blind"][m])
			var diff: float = ora_v - bli_v
			omb_set.append(diff)
			if absf(bli_v) > 0.001:
				pcts.append(diff / bli_v * 100.0)
			else:
				pcts.append(0.0)
		var min_pct: float = pcts[0]
		for p in pcts:
			if p < min_pct:
				min_pct = p
		if min_pct >= 8.0 and min_pct > best_min_pct:
			best_min_pct = min_pct
			best_measure = m
			omb_per_set = omb_set
	print("\nYardstick: best measure = %s (min ORACLE-BLIND pct of BLIND = %.1f%%)" % [best_measure, best_min_pct])
	if best_measure == "VOID":
		return {"measure": "VOID", "sets": set_results, "oracle_minus_blind": [], "reader_minus_blind": []}
	return {"measure": best_measure, "sets": set_results,
		"oracle_minus_blind": omb_per_set, "reader_minus_blind": []}


func _run_set_yardstick(n_worlds: int, base_seed: int) -> Dictionary:
	var totals := {"blind": Pool.empty_totals(), "oracle": Pool.empty_totals()}
	for w in n_worlds:
		var seed_val := base_seed + w
		for bot in ["blind", "oracle"]:
			var res := Pool.run_world_yardstick(bot, seed_val)
			Pool.merge_totals(totals[bot], res)
	return totals


## --- Part 2: K1, K3, K4 ---

func _run_k1_k3_k4(yardstick: Dictionary) -> Dictionary:
	var measure: String = yardstick["measure"]
	var k1_pass := true
	var total_read_spend := {"look_closer": 0, "trial": 0, "test_day": 0, "recheck": 0}
	var all_rmb: Array = []
	var all_omb: Array = []
	var total_k4_rows := 0
	var total_k4_cannot := 0
	for base_seed in SEED_SETS:
		var data := _run_set_k1(base_seed, total_read_spend)
		var ora_v: float = float(data["oracle"][measure])
		var bli_v: float = float(data["blind"][measure])
		var rea_v: float = float(data["reader"][measure])
		var bad_v: float = float(data["bad"][measure])
		var omb: float = ora_v - bli_v
		var rmb: float = rea_v - bli_v
		all_omb.append(omb)
		all_rmb.append(rmb)
		print("Set %d: O=%.0f B=%.0f R=%.0f BAD=%.0f | O-B=%.0f R-B=%.0f" % [
			base_seed, ora_v, bli_v, rea_v, bad_v, omb, rmb])
		if rmb < 5.0:
			k1_pass = false
		if bad_v >= bli_v:
			k1_pass = false
		var k4_res := _run_k4(base_seed)
		total_k4_rows += k4_res["rows"]
		total_k4_cannot += k4_res["cannot_place"]
	# K3: read mix
	var total_spend: float = 0.0
	for kind in total_read_spend:
		total_spend += float(total_read_spend[kind])
	var k3_shares: Dictionary = {}
	var k3_ok := true
	for kind in total_read_spend:
		var share: float = float(total_read_spend[kind]) / maxf(total_spend, 1.0) * 100.0
		k3_shares[kind] = share
		if share > 50.0:
			k3_ok = false
		if share < 5.0 and total_spend > 0.0:
			k3_ok = false
	var k4_pct: float = float(total_k4_cannot) / maxf(float(total_k4_rows), 1.0) * 100.0
	var k3_pass := k3_ok
	var k4_pass := k4_pct >= 95.0
	print("\nK3 read shares: %s (pass=%s)" % [str(k3_shares), str(k3_pass)])
	print("K4: %d/%d cannot place (%.1f%%, need 95%%+) pass=%s" % [total_k4_cannot, total_k4_rows, k4_pct, str(k4_pass)])
	return {"k1_pass": k1_pass, "k3_pass": k3_pass, "k4_pass": k4_pass,
		"oracle_minus_blind": all_omb, "reader_minus_blind": all_rmb,
		"k3_shares": k3_shares, "k4_pct": k4_pct, "k4_rows": total_k4_rows, "k4_cannot": total_k4_cannot}


func _run_set_k1(base_seed: int, read_spend: Dictionary) -> Dictionary:
	var totals := {"blind": Pool.empty_totals(), "reader": Pool.empty_totals(),
		"bad": Pool.empty_totals(), "oracle": Pool.empty_totals()}
	for w in WORLDS_PER_SET:
		var seed_val := base_seed + w
		for bot in ["blind", "reader", "bad", "oracle"]:
			var res := Pool.run_world_k1(bot, seed_val, read_spend)
			Pool.merge_totals(totals[bot], res)
	return totals


## --- K4: Leak bot ---

func _run_k4(base_seed: int) -> Dictionary:
	var total_rows := 0
	var cannot_place := 0
	for w in WORLDS_PER_SET:
		var seed_val := base_seed + w
		var world := preload("res://scripts/world/WorldGen.gd").generate(seed_val)
		var div_boxers: Array = world["divisions"]["m_lw"]["boxers"]
		var pool_rng := RandomNumberGenerator.new()
		pool_rng.seed = hash([seed_val, "k4pool"])
		var candidates: Array = []
		for b in div_boxers:
			if b.get("retired", false) or b.get("player", false):
				continue
			var age := int(b.get("age", 0))
			if age >= 18 and age <= 22:
				candidates.append(b)
		for i in range(candidates.size() - 1, 0, -1):
			var j := pool_rng.randi_range(0, i)
			var tmp = candidates[i]; candidates[i] = candidates[j]; candidates[j] = tmp
		var n := mini(10, candidates.size())
		for idx in n:
			var b: Dictionary = candidates[idx]
			var attrs := AttrGen.attrs_of(b)
			var p_seed := hash([seed_val, "k4", idx])
			var hype := pool_rng.randf()
			var k := K.fresh(p_seed)
			for attr in K.BODY_ATTRS + K.SKILLS_ATTRS + K.FIRE_ATTRS:
				var truth := float(attrs[attr])
				var s := K.shown(k, attr, truth, hype)
				total_rows += 1
				var w_word: String = K.word(float(s["width"]))
				if w_word == "Exact":
					continue
				var centre := float(s["centre"])
				if absf(centre - truth) > 2.0:
					cannot_place += 1
	return {"rows": total_rows, "cannot_place": cannot_place}


## --- Hype-truth correlation ---

func _hype_truth_corr() -> float:
	var hypes: Array = []
	var truths: Array = []
	var rng := RandomNumberGenerator.new()
	rng.seed = 7777
	for i in 200:
		var seed_val := 7000 + i
		var world := preload("res://scripts/world/WorldGen.gd").generate(seed_val)
		var div_boxers: Array = world["divisions"]["m_lw"]["boxers"]
		for b in div_boxers:
			if b.get("retired", false) or b.get("player", false):
				continue
			var age := int(b.get("age", 0))
			if age >= 18 and age <= 22:
				var attrs := AttrGen.attrs_of(b)
				var tm := Pool.attr_mean(attrs)
				var hype := rng.randf()
				hypes.append(hype)
				truths.append(tm)
				if hypes.size() >= 200:
					break
			if hypes.size() >= 200:
				break
	return _pearson(hypes, truths)


func _pearson(xs: Array, ys: Array) -> float:
	var n := xs.size()
	if n < 2:
		return 0.0
	var mx := 0.0; var my := 0.0
	for i in n:
		mx += float(xs[i]); my += float(ys[i])
	mx /= float(n); my /= float(n)
	var num := 0.0; var dx2 := 0.0; var dy2 := 0.0
	for i in n:
		var dx := float(xs[i]) - mx; var dy := float(ys[i]) - my
		num += dx * dy; dx2 += dx * dx; dy2 += dy * dy
	var denom := sqrt(dx2 * dy2)
	if denom < 0.0001:
		return 0.0
	return num / denom


## --- 5 sample prospects (the trap check) ---

func _sample_prospects() -> void:
	print("\n=== 5 SAMPLE PROSPECTS (trap check) ===")
	var world := preload("res://scripts/world/WorldGen.gd").generate(7000)
	var div_boxers: Array = world["divisions"]["m_lw"]["boxers"]
	var count := 0
	for b in div_boxers:
		if count >= 5:
			break
		if b.get("retired", false) or b.get("player", false):
			continue
		var age := int(b.get("age", 0))
		if age >= 18 and age <= 22:
			var attrs := AttrGen.attrs_of(b)
			var tm := Pool.attr_mean(attrs)
			var k := K.fresh(hash(["sample", count]))
			var sc := 0.0
			var attr_count := 0
			for a in K.BODY_ATTRS + K.SKILLS_ATTRS + K.FIRE_ATTRS:
				var truth := float(attrs[a])
				var r := K.range_of(k, a, truth, 0.0)
				sc += float(r["centre"])
				attr_count += 1
			sc /= float(maxi(1, attr_count))
			print("Prospect %d: rating=%.1f attr_mean=%.1f shown_centre=%.1f hype=0.0 top10_measure=N/A" % [
				count, float(b["rating"]), tm, sc])
			count += 1


## --- Result doc writing ---

func _write_void_result(yardstick: Dictionary, corr: float) -> void:
	var f := FileAccess.open(RESULT_DOC_PATH, FileAccess.WRITE)
	if f == null:
		return
	var lines := [
		"# KNOWBOTS4 Result: Knowledge v3 probes K1/K3/K4",
		"",
		"Status: PROBE COMPLETE. Yardstick: VOID.",
		"Red Test: `tools/knowbots4_probe.gd -> KNOWBOTS4 done`",
		"",
		"## Part 1: Yardstick",
		"No measure gives ORACLE - BLIND >= 8% of BLIND's value on every seed set.",
		"",
		"| Measure | Set 7000 (O/B) | Set 8000 (O/B) | Set 9000 (O/B) |",
		"|---|---|---|---|",
	]
	# Add the table rows from yardstick data
	var sets: Array = yardstick.get("sets", [])
	if sets.size() == 3:
		for m in MEASURES:
			var row := "| %s |" % m
			for sd in sets:
				var ora_v: float = float(sd["oracle"][m])
				var bli_v: float = float(sd["blind"][m])
				row += " %.1f / %.1f |" % [ora_v, bli_v]
			lines.append(row)
	lines.append("")
	lines.append("Hype-truth correlation: %.4f (must be within +-0.1)" % corr)
	for line in lines:
		f.store_line(line)
	f.close()


func _write_result_doc(yardstick: Dictionary, k_results: Dictionary, corr: float, pilot_s: float, projected_s: float) -> void:
	var f := FileAccess.open(RESULT_DOC_PATH, FileAccess.WRITE)
	if f == null:
		return
	var omb: Array = k_results["oracle_minus_blind"]
	var rmb: Array = k_results["reader_minus_blind"]
	var omb_strs: Array = []; var rmb_strs: Array = []
	for v in omb: omb_strs.append(str(int(v)))
	for v in rmb: rmb_strs.append(str(int(v)))
	var lines := [
		"# KNOWBOTS4 Result: Knowledge v3 probes K1/K3/K4",
		"",
		"Status: PROBE COMPLETE. Discipline: boxing.",
		"Red Test: `tools/knowbots4_probe.gd -> KNOWBOTS4 done`",
		"",
		"## Part 1: Yardstick",
		"Measure chosen: %s" % yardstick["measure"],
		"ORACLE - BLIND per set: [%s]" % ", ".join(omb_strs),
		"Hype-truth correlation: %.4f" % corr,
		"",
		"## Part 2: K1",
		"READER - BLIND per set: [%s]" % ", ".join(rmb_strs),
		"K1 pass: %s" % str(k_results["k1_pass"]),
		"",
		"## Part 2: K3 (read mix)",
		"Shares: %s" % str(k_results["k3_shares"]),
		"K3 pass: %s" % str(k_results["k3_pass"]),
		"",
		"## Part 2: K4 (leak bot)",
		"Cannot place: %d / %d rows (%.1f%%)" % [k_results["k4_cannot"], k_results["k4_rows"], k_results["k4_pct"]],
		"K4 pass: %s" % str(k_results["k4_pass"]),
		"",
		"## Timing",
		"Pilot: %.2f s" % pilot_s,
		"Projected: %.2f s (%.2f min)" % [projected_s, projected_s / 60.0],
	]
	for line in lines:
		f.store_line(line)
	f.close()
