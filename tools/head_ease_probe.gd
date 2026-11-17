extends SceneTree
## HEAD_EASE_PROBE: reads a shown.csv, runs HeadEase.analyse, prints each hit run and the summary.
## Usage: <godot> --headless --audio-driver Dummy --path . --script res://tools/head_ease_probe.gd -- csv=<path>

const HE := preload("res://scripts/rules/HeadEase.gd")


func _initialize() -> void:
	var csv_path := _arg("csv", "")
	if csv_path.is_empty():
		printerr("head_ease_probe: need -- csv=<path>")
		quit(1)
		return
	var rows := _load_csv(csv_path)
	var result := HE.analyse(rows)
	var runs: Array = result["runs"]
	for p in runs:
		print("  run who=%d clip=%s start=%d peak_frame=%d peak=%.1fcm back_frames=%d max_back=%.1fcm" % [
			p["who"], p["clip"], p["start_frame"], p["peak_frame"],
			p["peak_cm"], p["back_frames"], p["max_back_cm"]])
	print("HEAD_EASE runs=%d peak_f_p50=%.1f peak_p50=%.1f back_f_p50=%.1f max_back_p50=%.1f max_back_p90=%.1f late=%.2f snap=%.2f" % [
		runs.size(), result["peak_frame_p50"], result["peak_cm_p50"], result["back_frames_p50"],
		result["max_back_cm_p50"], result["max_back_cm_p90"], result["late_share"], result["snap_share"]])
	quit(0)


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


func _load_csv(path: String) -> Array:
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		printerr("head_ease_probe: cannot open or empty %s" % path)
		return []
	var lines := text.split("\n")
	if lines.is_empty():
		return []
	var headers := lines[0].strip_edges().split(",")
	var rows: Array = []
	for i in range(1, lines.size()):
		var line := lines[i].strip_edges()
		if line.is_empty():
			continue
		var vals := line.split(",")
		var row := {}
		for j in range(mini(headers.size(), vals.size())):
			row[headers[j]] = vals[j]
		rows.append(row)
	return rows
