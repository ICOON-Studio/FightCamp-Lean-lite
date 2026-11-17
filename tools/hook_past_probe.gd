extends SceneTree
## HOOK_PAST_PROBE: one line per worst fling, then the summary line.
## HOOKPAST2: then one line per held worst run (every stopped punch, reached or not) and the HOOK_HELD summary.
## Usage: <godot> --headless --audio-driver Dummy --path . --script res://tools/hook_past_probe.gd -- csv=<path>

const HP := preload("res://scripts/rules/HookPast.gd")


func _initialize() -> void:
	var csv_path := _arg("csv", "")
	if csv_path.is_empty():
		printerr("hook_past_probe: need -- csv=<path>")
		quit(1)
		return
	var rows := _load_csv(csv_path)
	if rows.is_empty():
		print("HOOK_PAST runs=0 past_p50=0.0 past_p90=0.0 up_p90=0.0 fling_p50=0.0 fling_p90=0.0 flings=0")
		print("HOOK_HELD runs=0 over6=0 over9=0 p50=0.0 p90=0.0")
		quit(0)
		return
	var res := HP.analyse(rows)
	for w in res["worst"]:
		print("  worst clip=%s who=%d start=%d fling=%.1fm/s past=%.1fcm up=%.1fcm" % [
			w["clip"], w["who"], w["start_frame"], w["fling_mps"], w["past_cm"], w["up_cm"]])
	print("HOOK_PAST runs=%d past_p50=%.1f past_p90=%.1f up_p90=%.1f fling_p50=%.1f fling_p90=%.1f flings=%d" % [
		res["runs"], res["past_p50"], res["past_p90"], res["up_p90"],
		res["fling_p50"], res["fling_p90"], res["flings"]])
	var hres := HP.held(rows)
	for w in hres["worst"]:
		print("  held clip=%s who=%d start=%d speed=%.1fm/s at=%d" % [
			w["clip"], w["who"], w["start_frame"], w["speed_mps"], w["speed_frame"]])
	print("HOOK_HELD runs=%d over6=%d over9=%d p50=%.1f p90=%.1f" % [
		hres["runs"], hres["over6"], hres["over9"], hres["p50"], hres["p90"]])
	quit(0)


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


func _load_csv(path: String) -> Array:
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		printerr("hook_past_probe: cannot open or empty %s" % path)
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
