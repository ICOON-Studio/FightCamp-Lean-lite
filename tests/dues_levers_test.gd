extends SceneTree
## DUES_LEVERS test (DUESSUMS2): search a REGION of balanced numbers.
## 972 sets (3x4x3x3x3x3), nine clubs each. GOOD / NEAR / ROBUST counts.
## PICK = most robust set (or best GOOD if none).

const DuesLevers := preload("res://scripts/rules/DuesLevers.gd")

var checks := 0
var failures := 0

const REPS := [10, 40, 80]
const CAPS := [40, 60, 120]

const GRANT_CHANCES := [0.20, 0.33, 0.50]
const VOLUNTEER_SHARES := [0.0, 0.05, 0.10, 0.15]
const SHOW_PER_BOXERS := [1000, 2000, 3000]
const LOW_REP_DRAWS := [0.85, 0.75, 0.65]
const STEADY_CANDIDATES := [1.0, 1.05, 1.10]
const CHEAP_SHARE_CANDIDATES := [1.0, 0.75, 0.5]

const LEVER_SIZES := [3, 4, 3, 3, 3, 3]


func _initialize() -> void:
	_test_control()
	_test_search()
	_test_lever_rules()
	_test_totals_are_sums()
	print("DUES_LEVERS checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	checks += 1
	if not cond:
		failures += 1
		print("  FAIL: %s" % label)


func _run_nine(levers: Dictionary) -> Array:
	var results := []
	for ri in range(REPS.size()):
		for ci in range(CAPS.size()):
			var rep: int = REPS[ri]
			var cap: int = CAPS[ci]
			var cheap_r: Dictionary = DuesLevers.five_year_total(rep, cap, "cheap", levers)
			var std_r: Dictionary = DuesLevers.five_year_total(rep, cap, "standard", levers)
			var prem_r: Dictionary = DuesLevers.five_year_total(rep, cap, "premium", levers)
			var totals := {"cheap": cheap_r["total"], "standard": std_r["total"], "premium": prem_r["total"]}
			var winner: String = _pick_winner(totals)
			results.append({
				"rep": rep, "cap": cap,
				"cheap": cheap_r, "standard": std_r, "premium": prem_r,
				"winner": winner,
			})
	return results


func _pick_winner(totals: Dictionary) -> String:
	var best_band: String = "premium"
	var best_val: float = float(totals["premium"])
	for band in ["standard", "cheap"]:
		var v: float = float(totals[band])
		if v > best_val:
			best_val = v
			best_band = band
	return best_band


func _count_wins(results: Array) -> Dictionary:
	var wins := {"cheap": 0, "standard": 0, "premium": 0}
	for r in results:
		wins[r["winner"]] += 1
	return wins


func _is_good(results: Array, wins: Dictionary) -> bool:
	for band in DuesLevers.BANDS:
		var w: int = wins[band]
		if w < 2 or w > 5:
			return false
	var cheap_nc := false
	var prem_f := false
	for r in results:
		if r["rep"] == 10 and r["cap"] == 120 and r["winner"] == "cheap":
			cheap_nc = true
		if r["rep"] == 80 and r["cap"] == 40 and r["winner"] == "premium":
			prem_f = true
	if not cheap_nc or not prem_f:
		return false
	for r in results:
		var c_tot: float = float(r["cheap"]["total"])
		var s_tot: float = float(r["standard"]["total"])
		var p_tot: float = float(r["premium"]["total"])
		var best: float = maxf(c_tot, maxf(s_tot, p_tot))
		var worst: float = minf(c_tot, minf(s_tot, p_tot))
		if worst > 0.0 and best > worst * 1.25:
			return false
		if worst <= 0.0 and best > 0.0:
			return false
	return true


func _is_near(results: Array, wins: Dictionary) -> bool:
	for band in DuesLevers.BANDS:
		var w: int = wins[band]
		if w < 2 or w > 5:
			return false
	var cheap_nc := false
	var prem_f := false
	for r in results:
		if r["rep"] == 10 and r["cap"] == 120 and r["winner"] == "cheap":
			cheap_nc = true
		if r["rep"] == 80 and r["cap"] == 40 and r["winner"] == "premium":
			prem_f = true
	if not cheap_nc or not prem_f:
		return false
	for r in results:
		var c_tot: float = float(r["cheap"]["total"])
		var s_tot: float = float(r["standard"]["total"])
		var p_tot: float = float(r["premium"]["total"])
		var best: float = maxf(c_tot, maxf(s_tot, p_tot))
		var worst: float = minf(c_tot, minf(s_tot, p_tot))
		if worst > 0.0 and best > worst * 1.35:
			return false
		if worst <= 0.0 and best > 0.0:
			return false
	return true


func _make_levers(gi: int, vi: int, si: int, di: int, sti: int, csi: int) -> Dictionary:
	return {
		"grant_chance": GRANT_CHANCES[gi],
		"youth_open": true,
		"volunteer_share": VOLUNTEER_SHARES[vi],
		"show_per_boxer": SHOW_PER_BOXERS[si],
		"low_rep_draw": LOW_REP_DRAWS[di],
		"steady": STEADY_CANDIDATES[sti],
		"cheap_share": CHEAP_SHARE_CANDIDATES[csi],
	}


func _indices_key(indices: Array) -> String:
	return "%d,%d,%d,%d,%d,%d" % [indices[0], indices[1], indices[2], indices[3], indices[4], indices[5]]


func _get_neighbors(indices: Array) -> Array:
	var neighbors := []
	var lever_vals := [GRANT_CHANCES, VOLUNTEER_SHARES, SHOW_PER_BOXERS, LOW_REP_DRAWS, STEADY_CANDIDATES, CHEAP_SHARE_CANDIDATES]
	for li in range(6):
		if indices[li] > 0:
			var n := indices.duplicate()
			n[li] = indices[li] - 1
			neighbors.append(n)
		if indices[li] < LEVER_SIZES[li] - 1:
			var n := indices.duplicate()
			n[li] = indices[li] + 1
			neighbors.append(n)
	return neighbors


func _test_control() -> void:
	var levers := {
		"grant_chance": 0.0,
		"youth_open": true,
		"volunteer_share": 0.0,
		"show_per_boxer": 0,
		"low_rep_draw": 0.85,
		"steady": 1.0,
		"cheap_share": 1.0,
	}
	var results := _run_nine(levers)
	_print_table(results, "CONTROL (all levers neutral)")
	var wins := _count_wins(results)
	print("  CONTROL wins: cheap=%d standard=%d premium=%d" % [wins["cheap"], wins["standard"], wins["premium"]])
	_check(wins["premium"] == 9, "CONTROL: premium wins 9 of 9")


func _test_search() -> void:
	var all_results := {}
	var good_keys := []
	var near_keys := []

	for gi in range(GRANT_CHANCES.size()):
		for vi in range(VOLUNTEER_SHARES.size()):
			for si in range(SHOW_PER_BOXERS.size()):
				for di in range(LOW_REP_DRAWS.size()):
					for sti in range(STEADY_CANDIDATES.size()):
						for csi in range(CHEAP_SHARE_CANDIDATES.size()):
							var levers := _make_levers(gi, vi, si, di, sti, csi)
							var results := _run_nine(levers)
							var wins := _count_wins(results)
							var indices := [gi, vi, si, di, sti, csi]
							var key := _indices_key(indices)
							var entry := {"levers": levers, "results": results, "wins": wins, "indices": indices}
							all_results[key] = entry
							if _is_good(results, wins):
								good_keys.append(key)
							if _is_near(results, wins):
								near_keys.append(key)

	print("  GOOD sets: %d of 972" % good_keys.size())
	print("  NEAR sets: %d of 972" % near_keys.size())

	if good_keys.size() == 0:
		print("  No GOOD sets found - reporting bar failures")

	## Bar failure analysis.
	_report_bar_failures(all_results)

	## ROBUST: GOOD set where >= half of one-step neighbors are GOOD too.
	var good_set := {}
	for k in good_keys:
		good_set[k] = true
	var robust_keys := []
	var good_neighbor_counts := {}
	for k in good_keys:
		var entry: Dictionary = all_results[k]
		var neighbors := _get_neighbors(entry["indices"])
		var gn := 0
		for n in neighbors:
			var nk := _indices_key(n)
			if good_set.has(nk):
				gn += 1
		good_neighbor_counts[k] = gn
		if gn * 2 >= neighbors.size():
			robust_keys.append(k)

	print("  ROBUST sets: %d" % robust_keys.size())

	## Per-lever GOOD counts.
	_print_per_lever_counts(good_keys)

	## Win split table.
	_print_split_table(all_results)

	## Top 5 ROBUST (or best GOOD).
	var show_keys := robust_keys.duplicate()
	var is_robust := true
	if show_keys.size() == 0:
		show_keys = good_keys.duplicate()
		is_robust = false
	show_keys.sort_custom(func(a, b): return good_neighbor_counts.get(a, 0) > good_neighbor_counts.get(b, 0))
	var show_n := mini(5, show_keys.size())
	for idx in range(show_n):
		var k: String = show_keys[idx]
		var entry: Dictionary = all_results[k]
		var lev: Dictionary = entry["levers"]
		var w: Dictionary = entry["wins"]
		var gn: int = good_neighbor_counts.get(k, 0)
		var label := "ROBUST" if is_robust else "GOOD"
		print("  %s #%d good_neighbors=%d chance=%.2f vol=%.2f per_boxer=%d low_draw=%.2f steady=%.2f cheap_share=%.2f wins: c=%d s=%d p=%d" % [
			label, idx + 1, gn,
			float(lev["grant_chance"]), float(lev["volunteer_share"]),
			int(lev["show_per_boxer"]), float(lev["low_rep_draw"]),
			float(lev["steady"]), float(lev["cheap_share"]),
			w["cheap"], w["standard"], w["premium"],
		])
		_print_table(entry["results"], "%s #%d" % [label, idx + 1])

	## PICK.
	var pick_key := ""
	if robust_keys.size() > 0:
		robust_keys.sort_custom(func(a, b): return good_neighbor_counts.get(a, 0) > good_neighbor_counts.get(b, 0))
		pick_key = robust_keys[0]
	elif good_keys.size() > 0:
		good_keys.sort_custom(func(a, b): return good_neighbor_counts.get(a, 0) > good_neighbor_counts.get(b, 0))
		pick_key = good_keys[0]
		print("  No ROBUST set - PICK is best GOOD by neighbor count")

	if pick_key != "":
		var pick_entry: Dictionary = all_results[pick_key]
		var pick_lev: Dictionary = pick_entry["levers"]
		var pick_w: Dictionary = pick_entry["wins"]
		var pick_gn: int = good_neighbor_counts.get(pick_key, 0)
		print("  PICK: good_neighbors=%d chance=%.2f vol=%.2f per_boxer=%d low_draw=%.2f steady=%.2f cheap_share=%.2f wins: c=%d s=%d p=%d" % [
			pick_gn,
			float(pick_lev["grant_chance"]), float(pick_lev["volunteer_share"]),
			int(pick_lev["show_per_boxer"]), float(pick_lev["low_rep_draw"]),
			float(pick_lev["steady"]), float(pick_lev["cheap_share"]),
			pick_w["cheap"], pick_w["standard"], pick_w["premium"],
		])
		_print_full_table(pick_entry["results"], "PICK breakdown")

	if robust_keys.size() == 0:
		print("  No ROBUST set found - bar analysis above shows which bar decides it")
	## S432 collect: the brief's own check (step 3e) - no ROBUST set is a RESULT, and the test says so by failing here.
	_check(robust_keys.size() > 0, "at least one ROBUST set exists (%d)" % robust_keys.size())


func _report_bar_failures(all_results: Dictionary) -> void:
	var b1_fails := 0
	var b2a_fails := 0
	var b2b_fails := 0
	var b3_fails := 0
	var passes_1 := 0
	var passes_2a := 0
	var passes_2b := 0
	var passes_3 := 0
	for k in all_results:
		var entry: Dictionary = all_results[k]
		var results: Array = entry["results"]
		var wins: Dictionary = entry["wins"]
		var b1 := true
		for band in DuesLevers.BANDS:
			if wins[band] < 2 or wins[band] > 5:
				b1 = false
				break
		if b1:
			passes_1 += 1
		else:
			b1_fails += 1
			continue
		var cheap_nc := false
		var prem_f := false
		for r in results:
			if r["rep"] == 10 and r["cap"] == 120 and r["winner"] == "cheap":
				cheap_nc = true
			if r["rep"] == 80 and r["cap"] == 40 and r["winner"] == "premium":
				prem_f = true
		if cheap_nc:
			passes_2a += 1
		else:
			b2a_fails += 1
			continue
		if prem_f:
			passes_2b += 1
		else:
			b2b_fails += 1
			continue
		var b3 := true
		for r in results:
			var c_tot: float = float(r["cheap"]["total"])
			var s_tot: float = float(r["standard"]["total"])
			var p_tot: float = float(r["premium"]["total"])
			var best: float = maxf(c_tot, maxf(s_tot, p_tot))
			var worst: float = minf(c_tot, minf(s_tot, p_tot))
			if worst > 0.0 and best > worst * 1.25:
				b3 = false
				break
			if worst <= 0.0 and best > 0.0:
				b3 = false
				break
		if b3:
			passes_3 += 1
		else:
			b3_fails += 1
	print("  Bar analysis: pass_wins_range=%d fail=%d | pass_cheap_rep10cap120=%d fail=%d | pass_prem_rep80cap40=%d fail=%d | pass_spread=%d fail=%d" % [
		passes_1, b1_fails, passes_2a, b2a_fails, passes_2b, b2b_fails, passes_3, b3_fails])


func _print_per_lever_counts(good_keys: Array) -> void:
	var lever_names := ["grant_chance", "volunteer_share", "show_per_boxer", "low_rep_draw", "steady", "cheap_share"]
	var lever_vals := [GRANT_CHANCES, VOLUNTEER_SHARES, SHOW_PER_BOXERS, LOW_REP_DRAWS, STEADY_CANDIDATES, CHEAP_SHARE_CANDIDATES]
	for li in range(6):
		var counts := {}
		for v in lever_vals[li]:
			counts[v] = 0
		for k in good_keys:
			var parts: PackedStringArray = k.split(",")
			var idx: int = int(parts[li])
			var v = lever_vals[li][idx]
			counts[v] += 1
		var parts_str := ""
		for v in lever_vals[li]:
			parts_str += " %s=%d" % [str(v), counts[v]]
		print("  GOOD by %s:%s" % [lever_names[li], parts_str])


func _print_split_table(all_results: Dictionary) -> void:
	var split_counts := {}
	for k in all_results:
		var entry: Dictionary = all_results[k]
		var w: Dictionary = entry["wins"]
		var split := "%d/%d/%d" % [w["cheap"], w["standard"], w["premium"]]
		if split_counts.has(split):
			split_counts[split] += 1
		else:
			split_counts[split] = 1
	var splits := []
	for s in split_counts:
		splits.append({"split": s, "count": split_counts[s]})
	splits.sort_custom(func(a, b): return a["count"] > b["count"])
	print("  Win splits (cheap/standard/premium -> count):")
	for s in splits:
		print("    %s -> %d" % [s["split"], s["count"]])


func _print_table(results: Array, label: String) -> void:
	print("  --- %s ---" % label)
	print("  %-12s %-8s %-10s %-10s %-10s" % ["case", "cheap", "standard", "premium", "winner"])
	for r in results:
		var case_str: String = "rep%d/cap%d" % [r["rep"], r["cap"]]
		var c_str: String = "%d" % int(float(r["cheap"]["total"]))
		var s_str: String = "%d" % int(float(r["standard"]["total"]))
		var p_str: String = "%d" % int(float(r["premium"]["total"]))
		print("  %-12s %-8s %-10s %-10s %-10s" % [case_str, c_str, s_str, p_str, r["winner"]])


func _print_full_table(results: Array, label: String) -> void:
	print("  --- %s ---" % label)
	for r in results:
		var case_str: String = "rep%d/cap%d" % [r["rep"], r["cap"]]
		print("  %s winner=%s" % [case_str, r["winner"]])
		var cd: int = int(float(r["cheap"]["dues"]))
		var cg: int = int(float(r["cheap"]["grant"]))
		var cv: int = int(float(r["cheap"]["volunteer"]))
		var cs: int = int(float(r["cheap"]["show"]))
		var cb: int = int(float(r["cheap"]["boxers"]))
		var cc: int = int(float(r["cheap"]["classes"]))
		var ct: int = int(float(r["cheap"]["total"]))
		print("    cheap:   dues=%d grant=%d vol=%d show=%d bxr=%d cls=%d tot=%d" % [cd, cg, cv, cs, cb, cc, ct])
		var sd: int = int(float(r["standard"]["dues"]))
		var sg: int = int(float(r["standard"]["grant"]))
		var sv: int = int(float(r["standard"]["volunteer"]))
		var ss: int = int(float(r["standard"]["show"]))
		var sb: int = int(float(r["standard"]["boxers"]))
		var sc: int = int(float(r["standard"]["classes"]))
		var st: int = int(float(r["standard"]["total"]))
		print("    std:     dues=%d grant=%d vol=%d show=%d bxr=%d cls=%d tot=%d" % [sd, sg, sv, ss, sb, sc, st])
		var pd: int = int(float(r["premium"]["dues"]))
		var pg: int = int(float(r["premium"]["grant"]))
		var pv: int = int(float(r["premium"]["volunteer"]))
		var ps: int = int(float(r["premium"]["show"]))
		var pb: int = int(float(r["premium"]["boxers"]))
		var pc: int = int(float(r["premium"]["classes"]))
		var pt: int = int(float(r["premium"]["total"]))
		print("    premium: dues=%d grant=%d vol=%d show=%d bxr=%d cls=%d tot=%d" % [pd, pg, pv, ps, pb, pc, pt])


func _test_lever_rules() -> void:
	## Neutral values: steady_draw returns 1.0 for cheap/premium, steady for standard.
	_check(absf(DuesLevers.steady_draw("cheap", 1.10) - 1.0) < 0.001, "steady_draw cheap = 1.0 always")
	_check(absf(DuesLevers.steady_draw("premium", 1.10) - 1.0) < 0.001, "steady_draw premium = 1.0 always")
	_check(absf(DuesLevers.steady_draw("standard", 1.0) - 1.0) < 0.001, "steady_draw standard neutral = 1.0")
	_check(absf(DuesLevers.steady_draw("standard", 1.10) - 1.10) < 0.001, "steady_draw standard 1.10 = 1.10")

	## class_year: standard and premium get full 350x52; cheap gets cheap_share x 350 x 52.
	var full_class: float = 350.0 * 52.0
	_check(absf(DuesLevers.class_year("standard", 1.0) - full_class) < 1.0, "class_year standard = 350x52")
	_check(absf(DuesLevers.class_year("premium", 0.5) - full_class) < 1.0, "class_year premium = 350x52 (cheap_share ignored)")
	_check(absf(DuesLevers.class_year("cheap", 1.0) - full_class) < 1.0, "class_year cheap at share 1.0 = 350x52")
	_check(absf(DuesLevers.class_year("cheap", 0.5) - 0.5 * full_class) < 1.0, "class_year cheap at share 0.5 = half")

	## Grant: 0 for premium.
	_check(DuesLevers.grant_year("premium", 0.50, true) == 0.0, "grant_year returns 0 for premium")

	## Volunteer: 0 for premium.
	_check(DuesLevers.volunteer_saving_year("premium", 0.15) == 0.0, "volunteer_saving_year returns 0 for premium")

	## Grant: cheap full, standard half.
	var gc: float = DuesLevers.grant_year("cheap", 0.33, true)
	var gs: float = DuesLevers.grant_year("standard", 0.33, true)
	_check(absf(gc - 0.33 * 12345.0) < 1.0, "grant_year cheap = chance x 12345")
	_check(absf(gs - 0.5 * 0.33 * 12345.0) < 1.0, "grant_year standard = half chance x 12345")

	## Premium draw: linear.
	_check(absf(DuesLevers.premium_draw(0, 0.75) - 0.75) < 0.001, "premium_draw at rep 0 = low_rep_draw")
	_check(absf(DuesLevers.premium_draw(100, 0.75) - 1.0) < 0.001, "premium_draw at rep 100 = 1.0")

	## youth_open false -> grant 0.
	_check(DuesLevers.grant_year("cheap", 0.50, false) == 0.0, "grant_year 0 when youth_open false")


func _test_totals_are_sums() -> void:
	var levers := {
		"grant_chance": 0.33,
		"youth_open": true,
		"volunteer_share": 0.10,
		"show_per_boxer": 2000,
		"low_rep_draw": 0.75,
		"steady": 1.05,
		"cheap_share": 0.75,
	}
	for ri in range(REPS.size()):
		for ci in range(CAPS.size()):
			var rep: int = REPS[ri]
			var cap: int = CAPS[ci]
			for band in DuesLevers.BANDS:
				var r: Dictionary = DuesLevers.five_year_total(rep, cap, band, levers)
				var parts: float = float(r["dues"]) + float(r["grant"]) + float(r["volunteer"]) + float(r["show"]) + float(r["boxers"]) + float(r["classes"])
				var total: float = float(r["total"])
				_check(absf(total - parts) < 1.0, "total = sum of parts for %s at rep%d/cap%d" % [band, rep, cap])
