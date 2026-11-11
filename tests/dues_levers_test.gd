extends SceneTree
## DUES_LEVERS test (DUESSUMS3): search a REGION of balanced numbers.
## 8748 sets (3x4x3x3x3x3x3x3), nine clubs each. GOOD / NEAR / ROBUST counts.
## PICK = most robust set (or best GOOD if none).

const DuesLevers := preload("res://scripts/rules/DuesLevers.gd")
const DuesLeversPrint = preload("res://tests/dues_levers_print.gd")

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
const STRENGTH_CANDIDATES := [0.0, 0.25, 0.50]
const UPLIFT_CANDIDATES := [0.0, 0.10, 0.20]

const LEVER_SIZES := [3, 4, 3, 3, 3, 3, 3, 3]


func _initialize() -> void:
	_test_control()
	_test_waitlist_control()
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


func _make_levers(gi: int, vi: int, si: int, di: int, sti: int, csi: int, wi: int, ui: int) -> Dictionary:
	return {
		"grant_chance": GRANT_CHANCES[gi],
		"youth_open": true,
		"volunteer_share": VOLUNTEER_SHARES[vi],
		"show_per_boxer": SHOW_PER_BOXERS[si],
		"low_rep_draw": LOW_REP_DRAWS[di],
		"steady": STEADY_CANDIDATES[sti],
		"cheap_share": CHEAP_SHARE_CANDIDATES[csi],
		"strength": STRENGTH_CANDIDATES[wi],
		"uplift": UPLIFT_CANDIDATES[ui],
	}


func _indices_key(indices: Array) -> String:
	return "%d,%d,%d,%d,%d,%d,%d,%d" % [indices[0], indices[1], indices[2], indices[3], indices[4], indices[5], indices[6], indices[7]]


func _get_neighbors(indices: Array) -> Array:
	var neighbors := []
	var lever_vals := [GRANT_CHANCES, VOLUNTEER_SHARES, SHOW_PER_BOXERS, LOW_REP_DRAWS, STEADY_CANDIDATES, CHEAP_SHARE_CANDIDATES, STRENGTH_CANDIDATES, UPLIFT_CANDIDATES]
	for li in range(8):
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
		"strength": 0.0,
		"uplift": 0.0,
	}
	var results := _run_nine(levers)
	DuesLeversPrint.print_table(results, "CONTROL (all levers neutral)")
	var wins := _count_wins(results)
	print("  CONTROL wins: cheap=%d standard=%d premium=%d" % [wins["cheap"], wins["standard"], wins["premium"]])
	_check(wins["premium"] == 9, "CONTROL: premium wins 9 of 9")


func _test_waitlist_control() -> void:
	var wl := {"grant_chance": 0.0, "youth_open": true, "volunteer_share": 0.0, "show_per_boxer": 0, "low_rep_draw": 0.85, "steady": 1.0, "cheap_share": 1.0, "strength": 0.50, "uplift": 0.20}
	var wl_results := _run_nine(wl)
	DuesLeversPrint.print_table(wl_results, "CONTROL waitlist (strength=0.50 uplift=0.20)")
	for r in wl_results:
		if r["cap"] == 40:
			print("  cap40 rep%d: cheap=%d std=%d prem=%d winner=%s" % [r["rep"], int(float(r["cheap"]["total"])), int(float(r["standard"]["total"])), int(float(r["premium"]["total"])), r["winner"]])
	var wl_control_levers := {"grant_chance": 0.0, "youth_open": true, "volunteer_share": 0.0, "show_per_boxer": 0, "low_rep_draw": 0.65, "steady": 1.0, "cheap_share": 1.0, "strength": 0.50, "uplift": 0.20}
	var wl_control_any_kept := false
	for rep in [10, 40, 80]:
		var r: Dictionary = DuesLevers.five_year_total(rep, 40, "premium", wl_control_levers)
		var wk_val: int = int(float(r["waitlist_kept"]))
		var wf_val: int = int(float(r["waitlist_fee_extra"]))
		if wk_val > 0:
			wl_control_any_kept = true
		print("  WAITLIST rep%d cap40 low_draw=0.65: premium total=%d waitlist_kept=%d waitlist_fee_extra=%d" % [rep, int(float(r["total"])), wk_val, wf_val])
	if not wl_control_any_kept:
		print("  WAITLIST: keep never acts - Membership.settle_week walks the count toward a target with no random churn, so a full club loses nobody")


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
							for wi in range(STRENGTH_CANDIDATES.size()):
								for ui in range(UPLIFT_CANDIDATES.size()):
									var levers := _make_levers(gi, vi, si, di, sti, csi, wi, ui)
									var results := _run_nine(levers)
									var wins := _count_wins(results)
									var indices := [gi, vi, si, di, sti, csi, wi, ui]
									var key := _indices_key(indices)
									var entry := {"levers": levers, "results": results, "wins": wins, "indices": indices}
									all_results[key] = entry
									if _is_good(results, wins):
										good_keys.append(key)
									if _is_near(results, wins):
										near_keys.append(key)

	print("  GOOD sets: %d of 8748" % good_keys.size())
	print("  NEAR sets: %d of 8748" % near_keys.size())

	if good_keys.size() == 0:
		print("  No GOOD sets found - reporting bar failures")

	## Bar failure analysis.
	DuesLeversPrint.report_bar_failures(all_results)

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

	## Inert lever detection: a lever is inert when no pair of sets differing only
	## in that lever by one step has any of the 27 totals move more than 0.5.
	var lever_names := ["grant_chance", "volunteer_share", "show_per_boxer", "low_rep_draw", "steady", "cheap_share", "strength", "uplift"]
	var inert_levers := []
	for li in range(8):
		var pairs_count: int = 0
		var differing_count: int = 0
		for k in all_results:
			var entry: Dictionary = all_results[k]
			var indices: Array = entry["indices"]
			if indices[li] < LEVER_SIZES[li] - 1:
				var next_indices: Array = indices.duplicate()
				next_indices[li] = indices[li] + 1
				var nk: String = _indices_key(next_indices)
				if all_results.has(nk):
					pairs_count += 1
					var next_entry: Dictionary = all_results[nk]
					var any_diff: bool = false
					for ri in range(REPS.size()):
						for ci in range(CAPS.size()):
							for band in DuesLevers.BANDS:
								var t1: float = float(entry["results"][ri * CAPS.size() + ci][band]["total"])
								var t2: float = float(next_entry["results"][ri * CAPS.size() + ci][band]["total"])
								if absf(t1 - t2) > 0.5:
									any_diff = true
					if any_diff:
						differing_count += 1
		print("  INERT check %s: pairs=%d differing=%d" % [lever_names[li], pairs_count, differing_count])
		if differing_count == 0:
			inert_levers.append(li)
	var inert_names_str := ""
	for idx in range(inert_levers.size()):
		if idx > 0:
			inert_names_str += ", "
		inert_names_str += lever_names[inert_levers[idx]]
	if inert_names_str == "":
		inert_names_str = "none"
	print("  INERT axes: %s" % inert_names_str)

	## ROBUST (inert axes excluded): neighbors that change only non-inert levers.
	var inert_set := {}
	for li in inert_levers:
		inert_set[li] = true
	var robust_ex_keys := []
	var gn_ex_counts := {}
	var nb_ex_counts := {}
	for k in good_keys:
		var entry: Dictionary = all_results[k]
		var indices: Array = entry["indices"]
		var gn_ex: int = 0
		var nb_ex: int = 0
		for li in range(8):
			if inert_set.has(li):
				continue
			if indices[li] > 0:
				var n: Array = indices.duplicate()
				n[li] = indices[li] - 1
				nb_ex += 1
				if good_set.has(_indices_key(n)):
					gn_ex += 1
			if indices[li] < LEVER_SIZES[li] - 1:
				var n: Array = indices.duplicate()
				n[li] = indices[li] + 1
				nb_ex += 1
				if good_set.has(_indices_key(n)):
					gn_ex += 1
		gn_ex_counts[k] = gn_ex
		nb_ex_counts[k] = nb_ex
		if nb_ex > 0 and gn_ex * 2 >= nb_ex:
			robust_ex_keys.append(k)

	print("  ROBUST (inert axes excluded): %d" % robust_ex_keys.size())

	## Per-lever GOOD counts.
	DuesLeversPrint.print_per_lever_counts(good_keys, [GRANT_CHANCES, VOLUNTEER_SHARES, SHOW_PER_BOXERS, LOW_REP_DRAWS, STEADY_CANDIDATES, CHEAP_SHARE_CANDIDATES, STRENGTH_CANDIDATES, UPLIFT_CANDIDATES])

	## Win split table.
	DuesLeversPrint.print_split_table(all_results)

	## Top 5 ROBUST (inert-excluded, or best GOOD by that count).
	var show_keys := robust_ex_keys.duplicate()
	var is_robust := true
	if show_keys.size() == 0:
		show_keys = good_keys.duplicate()
		is_robust = false
	show_keys.sort_custom(func(a, b):
		var ga: int = gn_ex_counts.get(a, 0)
		var gb: int = gn_ex_counts.get(b, 0)
		if ga != gb:
			return ga > gb
		return a < b
	)
	var show_n := mini(5, show_keys.size())
	for idx in range(show_n):
		var k: String = show_keys[idx]
		var entry: Dictionary = all_results[k]
		var lev: Dictionary = entry["levers"]
		var w: Dictionary = entry["wins"]
		var gn_ex: int = gn_ex_counts.get(k, 0)
		var nb_ex: int = nb_ex_counts.get(k, 0)
		var label := "ROBUST" if is_robust else "GOOD"
		print("  %s #%d good_neighbors=%d of %d wl_str=%.2f uplift=%.2f chance=%.2f vol=%.2f per_boxer=%d low_draw=%.2f steady=%.2f cheap_share=%.2f wins: c=%d s=%d p=%d" % [
			label, idx + 1, gn_ex, nb_ex,
			float(lev["strength"]), float(lev["uplift"]),
			float(lev["grant_chance"]), float(lev["volunteer_share"]),
			int(lev["show_per_boxer"]), float(lev["low_rep_draw"]),
			float(lev["steady"]), float(lev["cheap_share"]),
			w["cheap"], w["standard"], w["premium"],
		])
		DuesLeversPrint.print_table(entry["results"], "%s #%d" % [label, idx + 1])

	## PICK.
	var pick_key := ""
	if robust_ex_keys.size() > 0:
		robust_ex_keys.sort_custom(func(a, b):
			var ga: int = gn_ex_counts.get(a, 0)
			var gb: int = gn_ex_counts.get(b, 0)
			if ga != gb:
				return ga > gb
			return a < b
		)
		pick_key = robust_ex_keys[0]
	elif good_keys.size() > 0:
		good_keys.sort_custom(func(a, b):
			var ga: int = gn_ex_counts.get(a, 0)
			var gb: int = gn_ex_counts.get(b, 0)
			if ga != gb:
				return ga > gb
			return a < b
		)
		pick_key = good_keys[0]
		print("  No ROBUST set - PICK is best GOOD by inert-excluded neighbor count")

	if pick_key != "":
		var pick_entry: Dictionary = all_results[pick_key]
		var pick_lev: Dictionary = pick_entry["levers"]
		var pick_w: Dictionary = pick_entry["wins"]
		var pick_gn_ex: int = gn_ex_counts.get(pick_key, 0)
		var pick_nb_ex: int = nb_ex_counts.get(pick_key, 0)
		print("  PICK: good_neighbors=%d of %d wl_str=%.2f uplift=%.2f chance=%.2f vol=%.2f per_boxer=%d low_draw=%.2f steady=%.2f cheap_share=%.2f wins: c=%d s=%d p=%d" % [
			pick_gn_ex, pick_nb_ex,
			float(pick_lev["strength"]), float(pick_lev["uplift"]),
			float(pick_lev["grant_chance"]), float(pick_lev["volunteer_share"]),
			int(pick_lev["show_per_boxer"]), float(pick_lev["low_rep_draw"]),
			float(pick_lev["steady"]), float(pick_lev["cheap_share"]),
			pick_w["cheap"], pick_w["standard"], pick_w["premium"],
		])
		DuesLeversPrint.print_full_table(pick_entry["results"], "PICK breakdown")

	if robust_ex_keys.size() == 0:
		print("  No ROBUST set found - bar analysis above shows which bar decides it")
	## S432 collect: the brief's own check (step 3e) - no ROBUST set is a RESULT, and the test says so by failing here.
	_check(robust_ex_keys.size() > 0, "at least one ROBUST set exists, inert axes excluded (%d)" % robust_ex_keys.size())


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

	## waitlist_keep: 1.0 when not full or rep < 40; cheap always 1.0.
	_check(absf(DuesLevers.waitlist_keep("premium", 10, false, 0.5) - 1.0) < 0.001, "waitlist_keep not full = 1.0")
	_check(absf(DuesLevers.waitlist_keep("premium", 30, true, 0.5) - 1.0) < 0.001, "waitlist_keep rep<40 = 1.0")
	_check(absf(DuesLevers.waitlist_keep("cheap", 80, true, 0.5) - 1.0) < 0.001, "waitlist_keep cheap = 1.0")
	_check(absf(DuesLevers.waitlist_keep("premium", 100, true, 0.5) - 0.5) < 0.001, "waitlist_keep premium rep100 str0.5 = 0.5")
	_check(absf(DuesLevers.waitlist_keep("standard", 100, true, 0.5) - 0.75) < 0.001, "waitlist_keep standard rep100 str0.5 = 0.75")
	## waitlist_fee: 1.0 unless full, rep>=60, premium.
	_check(absf(DuesLevers.waitlist_fee("premium", 50, true, 0.2) - 1.0) < 0.001, "waitlist_fee rep<60 = 1.0")
	_check(absf(DuesLevers.waitlist_fee("standard", 80, true, 0.2) - 1.0) < 0.001, "waitlist_fee standard = 1.0")
	_check(absf(DuesLevers.waitlist_fee("premium", 80, true, 0.2) - 1.2) < 0.001, "waitlist_fee premium rep80 uplift0.2 = 1.2")
	_check(absf(DuesLevers.waitlist_fee("premium", 80, false, 0.2) - 1.0) < 0.001, "waitlist_fee not full = 1.0")


func _test_totals_are_sums() -> void:
	var levers := {
		"grant_chance": 0.33,
		"youth_open": true,
		"volunteer_share": 0.10,
		"show_per_boxer": 2000,
		"low_rep_draw": 0.75,
		"steady": 1.05,
		"cheap_share": 0.75,
		"strength": 0.25,
		"uplift": 0.10,
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
