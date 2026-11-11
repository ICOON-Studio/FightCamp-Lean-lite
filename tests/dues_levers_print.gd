extends RefCounted
## DuesLevers print helpers - static functions for test output.
## Extracted to keep the test file under 500 lines.

const DuesLevers := preload("res://scripts/rules/DuesLevers.gd")


static func print_table(results: Array, label: String) -> void:
	print("  --- %s ---" % label)
	print("  %-12s %-8s %-10s %-10s %-10s" % ["case", "cheap", "standard", "premium", "winner"])
	for r in results:
		var case_str: String = "rep%d/cap%d" % [r["rep"], r["cap"]]
		var c_str: String = "%d" % int(float(r["cheap"]["total"]))
		var s_str: String = "%d" % int(float(r["standard"]["total"]))
		var p_str: String = "%d" % int(float(r["premium"]["total"]))
		print("  %-12s %-8s %-10s %-10s %-10s" % [case_str, c_str, s_str, p_str, r["winner"]])


static func print_full_table(results: Array, label: String) -> void:
	print("  --- %s ---" % label)
	for r in results:
		print("  rep%d/cap%d winner=%s" % [r["rep"], r["cap"], r["winner"]])
		for band in DuesLevers.BANDS:
			var d: Dictionary = r[band]
			print("    %-4s dues=%d grant=%d vol=%d show=%d bxr=%d cls=%d wk=%d wf=%d tot=%d" % [
				band.substr(0, 4), int(float(d["dues"])), int(float(d["grant"])),
				int(float(d["volunteer"])), int(float(d["show"])), int(float(d["boxers"])),
				int(float(d["classes"])), int(float(d.get("waitlist_kept", 0.0))),
				int(float(d.get("waitlist_fee_extra", 0.0))), int(float(d["total"]))])


static func print_split_table(all_results: Dictionary) -> void:
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


static func print_per_lever_counts(good_keys: Array, lever_vals: Array) -> void:
	var lever_names := ["grant_chance", "volunteer_share", "show_per_boxer", "low_rep_draw", "steady", "cheap_share", "strength", "uplift"]
	for li in range(8):
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


static func report_bar_failures(all_results: Dictionary) -> void:
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
