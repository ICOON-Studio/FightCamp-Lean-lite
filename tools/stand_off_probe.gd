extends SceneTree
## STAND_OFF_PROBE: reads a shown.csv, runs StandOff.analyse, prints each stand-off and the summary.
## Usage: <godot> --headless --audio-driver Dummy --path . --script res://tools/stand_off_probe.gd -- csv=<path>


func _initialize() -> void:
	var csv_path := _arg("csv", "")
	if csv_path.is_empty():
		printerr("stand_off_probe: need -- csv=<path>")
		quit(1)
		return
	var rows := _load_csv(csv_path)
	if rows.is_empty():
		print("STAND_OFF count=0 total_s=0.0 longest_frames=0 near_frames=0 pressing_share=0.000")
		quit(0)
		return
	var SO := load("res://scripts/rules/StandOff.gd")
	var result: Dictionary = SO.analyse(rows)
	var standoffs: Array = result["standoffs"]
	for s in standoffs:
		print("  standoff start=%d end=%d frames=%d start_s=%.3f hips_m=%.2f glove_m=%.2f clips=%s" % [
			s["start_frame"], s["end_frame"], s["frames"], s["start_s"],
			s["hips_m"], s["glove_m"], str(s["clips"])])
	print("STAND_OFF count=%d total_s=%.1f longest_frames=%d near_frames=%d pressing_share=%.3f" % [
		result["count"], result["total_s"], result["longest_frames"],
		result["near_frames"], result["pressing_share"]])
	quit(0)


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


func _load_csv(path: String) -> Array:
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		printerr("stand_off_probe: cannot open or empty %s" % path)
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
