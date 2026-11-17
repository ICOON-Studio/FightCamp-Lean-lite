extends SceneTree
## PUNCH_END_PROBE: reads a shown.csv, runs PunchEnd.analyse, prints each punch and the summary.
## Usage: <godot> --headless --audio-driver Dummy --path . --script res://tools/punch_end_probe.gd -- csv=<path>

const PE := preload("res://scripts/rules/PunchEnd.gd")


func _initialize() -> void:
	var csv_path := _arg("csv", "")
	if csv_path.is_empty():
		printerr("punch_end_probe: need -- csv=<path>")
		quit(1)
		return
	var rows := _load_csv(csv_path)
	if rows.is_empty():
		print("PUNCH_END punches=0 head=0 above10=0 above_p50=0.0 home_p50=0.0 home_p90=0.0 landed=0 contact_home_p50=0.0 contact_home_le4=0")
		quit(0)
		return
	var result := PE.analyse(rows)
	var punches: Array = result["punches"]
	for p in punches:
		print("  punch clip=%s who=%d start=%d far=%d out=%d above=%.1fcm miss=%.1fcm home=%d from=%s contact_home=%d body=%s" % [
			p["clip"], p["who"], p["start_frame"], p["far_frame"], p["out_frames"],
			p["above_cm"], p["miss_cm"], p["home_frames"], p["home_from"], p["contact_home_frames"], str(p["is_body"])])
	print("PUNCH_END punches=%d head=%d above10=%d above_p50=%.1f home_p50=%.1f home_p90=%.1f landed=%d contact_home_p50=%.1f contact_home_le4=%d" % [
		punches.size(), result["head_n"], result["above_10_n"],
		result["above_p50"], result["home_p50"], result["home_p90"],
		result["landed_n"], result["contact_home_p50"], result["contact_home_le4"]])
	quit(0)


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


func _load_csv(path: String) -> Array:
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		printerr("punch_end_probe: cannot open or empty %s" % path)
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
