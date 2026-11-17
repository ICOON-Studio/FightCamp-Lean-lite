extends SceneTree
## FREE_HAND_PROBE: one line per off run, then the summary line.
## Usage: <godot> --headless --audio-driver Dummy --path . --script res://tools/free_hand_probe.gd -- csv=<path>

const FH := preload("res://scripts/rules/FreeHand.gd")


func _initialize() -> void:
	var csv_path := _arg("csv", "")
	if csv_path.is_empty():
		printerr("free_hand_probe: need -- csv=<path>")
		quit(1)
		return
	var rows := _load_csv(csv_path)
	if rows.is_empty():
		print("FREE_HAND runs=0 runs_off=0 off_share=0.00 free_p50=0.0 free_p90=0.0 drop_p90=0.0 guard_free_p50=0.0")
		quit(0)
		return
	var res := FH.analyse(rows)
	for r in res["runs"]:
		if r["frames_off"] >= 2 and not r["is_body"]:
			print("  off clip=%s who=%d start=%d frames_off=%d max_free=%.1fcm max_drop=%.1fcm" % [
				r["clip"], r["who"], r["start_frame"], r["frames_off"],
				r["max_free_cm"], r["max_drop_cm"]])
	print("FREE_HAND runs=%d runs_off=%d off_share=%.2f free_p50=%.1f free_p90=%.1f drop_p90=%.1f guard_free_p50=%.1f" % [
		res["runs_count"], res["runs_off"], res["off_share"],
		res["free_cm_p50"], res["free_cm_p90"], res["drop_cm_p90"],
		res["guard_free_cm_p50"]])
	quit(0)


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


func _load_csv(path: String) -> Array:
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		printerr("free_hand_probe: cannot open or empty %s" % path)
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
