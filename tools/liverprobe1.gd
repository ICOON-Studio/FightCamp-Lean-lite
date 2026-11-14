extends SceneTree
## LIVERPROBE1: tune the liver fold to the design's bar on 400 played bouts.
## Grid: shot_points {5.5, 6.0, 6.5, 7.0} x fold_scale {0.5, 0.75, 1.0}, plus a control arm (fold_scale 0).
## Design bar: body knockdowns 10-20 % of ALL knockdowns (target 15 %). Pick the cell nearest 15 % share
## with the fewest extra stoppages vs the control arm.

const Dump := preload("res://tools/result_dump.gd")
const LiverFold := preload("res://scripts/state/LiverFold.gd")

const SHOT_POINTS := [5.5, 6.0, 6.5, 7.0]
const FOLD_SCALES := [0.5, 0.75, 1.0]
const SEED_LO := 100
const SEED_HI := 499
const TARGET_SHARE := 0.15


func _initialize() -> void:
	var control := {}   # shot_points -> {stops, counts}
	for pts in SHOT_POINTS:
		control[pts] = _run_cell(pts, 0.0)
		print("CONTROL pts=%.1f fold_scale=0.00 counts=%d liver_folds=0 stoppages=%d" % [
			pts, control[pts]["counts"], control[pts]["stops"]])
	var results := []
	var det_ok := true
	for pts in SHOT_POINTS:
		for sc in FOLD_SCALES:
			var r := _run_cell(pts, sc)
			var share := float(r["folds"]) / float(maxi(r["counts"], 1))
			var extra := int(r["stops"]) - int(control[pts]["stops"])
			print("CELL pts=%.1f scale=%.2f counts=%d liver_folds=%d share=%.3f stoppages=%d extra_stops=%d" % [
				pts, sc, r["counts"], r["folds"], share, r["stops"], extra])
			r["pts"] = pts
			r["sc"] = sc
			r["share"] = share
			r["extra"] = extra
			results.append(r)
		var det_r1 := _run_cell(pts, 1.0)
		var det_r2 := _run_cell(pts, 1.0)
		if det_r1["counts"] != det_r2["counts"] or det_r1["folds"] != det_r2["folds"] or det_r1["stops"] != det_r2["stops"]:
			det_ok = false
	print("determinism %s" % ("yes" if det_ok else "no"))
	var best := _pick_best(results)
	print("LIVERPROBE1 best=%.1f/%.2f share=%.3f folds=%d counts=%d" % [
		best["pts"], best["sc"], best["share"], best["folds"], best["counts"]])
	_write_result(results, control, best, det_ok)
	quit(0)


func _run_cell(pts: float, sc: float) -> Dictionary:
	LiverFold.shot_points = pts
	LiverFold.fold_scale = sc
	var total_counts := 0
	var total_folds := 0
	var total_stops := 0
	for sd in range(SEED_LO, SEED_HI + 1):
		var cf := Dump._setup(sd)
		var f: Dictionary = cf[1]
		var m := Dump._fight(cf[0], f, Dump.PLAN, true)
		var rounds: Array = m["rounds"]
		for r in rounds:
			var rd: Dictionary = r
			total_counts += int(rd.get("counts", 0))
			total_folds += int(bool(rd.get("liver_fold", false)))
		var stop := str(m.get("stopped", ""))
		if stop == "RSC" or stop == "KO":
			total_stops += 1
	return {"counts": total_counts, "folds": total_folds, "stops": total_stops}


func _pick_best(results: Array) -> Dictionary:
	var best: Dictionary = results[0]
	var best_dist := absf(float(best["share"]) - TARGET_SHARE)
	for r in results:
		var dist := absf(float(r["share"]) - TARGET_SHARE)
		if dist < best_dist or (dist == best_dist and int(r["extra"]) < int(best["extra"])):
			best = r
			best_dist = dist
	return best


func _write_result(results: Array, control: Dictionary, best: Dictionary, det_ok: bool) -> void:
	var lines: Array = []
	lines.append("# LIVERPROBE1 RESULT")
	lines.append("")
	lines.append("400 bouts (seeds %d-%d), grid shot_points x fold_scale." % [SEED_LO, SEED_HI])
	lines.append("Design bar: body knockdowns 10-20% of all knockdowns (target 15%).")
	lines.append("")
	lines.append("## Control arm (fold_scale=0, no folds)")
	lines.append("")
	lines.append("| shot_points | counts | stoppages |")
	lines.append("|---|---|---|")
	for pts in SHOT_POINTS:
		var c: Dictionary = control[pts]
		lines.append("| %.1f | %d | %d |" % [pts, c["counts"], c["stops"]])
	lines.append("")
	lines.append("## Grid")
	lines.append("")
	lines.append("| shot_points | fold_scale | counts | liver_folds | share | stoppages | extra_stops |")
	lines.append("|---|---|---|---|---|---|---|")
	for r in results:
		lines.append("| %.1f | %.2f | %d | %d | %.3f | %d | %d |" % [
			float(r["pts"]), float(r["sc"]), int(r["counts"]), int(r["folds"]),
			float(r["share"]), int(r["stops"]), int(r["extra"])])
	lines.append("")
	lines.append("## Best cell")
	lines.append("")
	lines.append("shot_points=%.1f fold_scale=%.2f share=%.3f folds=%d counts=%d extra_stops=%d" % [
		float(best["pts"]), float(best["sc"]), float(best["share"]),
		int(best["folds"]), int(best["counts"]), int(best["extra"])])
	lines.append("")
	lines.append("Determinism: %s" % ("yes" if det_ok else "no"))
	var text := "\n".join(lines) + "\n"
	var fa := FileAccess.open("res://docs/LIVERPROBE1_RESULT.md", FileAccess.WRITE)
	fa.store_string(text)
	fa.close()
