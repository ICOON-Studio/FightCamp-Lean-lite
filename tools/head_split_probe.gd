extends SceneTree
## HEAD_SPLIT_PROBE: what moved each head jump, and two films compared only over their shared part.
## One csv: one line per worst jump, then the HEAD_SPLIT summary line.
## Two csvs: HEAD_SPLIT_SHARED until=<frame>, the shared part of each film (A / B), then the whole films
## (A_ALL / B_ALL) - S507: a whole-film comparison counts a different bout, not a different layer.
## Usage: <godot> --headless --audio-driver Dummy --path . --script res://tools/head_split_probe.gd -- csv=<a> [csv2=<b>]

const HS := preload("res://scripts/rules/HeadSplit.gd")


func _initialize() -> void:
	var csv_path := _arg("csv", "")
	var csv2 := _arg("csv2", "")
	if csv_path.is_empty():
		printerr("head_split_probe: need -- csv=<path> [csv2=<path>]")
		quit(1)
		return
	if not FileAccess.file_exists(csv_path) or (not csv2.is_empty() and not FileAccess.file_exists(csv2)):
		printerr("head_split_probe: cannot open %s %s" % [csv_path, csv2])
		quit(1)
		return
	var rows_a := _load_csv(csv_path)
	if csv2.is_empty():
		var res := HS.analyse(rows_a)
		for w in res["worst"]:
			print("  worst film_s=%.3f who=%d clip=%s head=%.1fcm root=%.1f hips=%.1f trunk=%.1f neck=%.1f" % [
				w["film_s"], w["who"], w["clip"], w["head_cm"],
				w["root_cm"], w["hips_cm"], w["trunk_cm"], w["neck_cm"]])
		print(_line(res))
		quit(0)
		return
	var rows_b := _load_csv(csv2)
	var until := HS.shared_until(rows_a, rows_b)
	print("HEAD_SPLIT_SHARED until=%d" % until)
	print("A " + _line(HS.analyse(rows_a, until)))
	print("B " + _line(HS.analyse(rows_b, until)))
	print("A_ALL " + _line(HS.analyse(rows_a)))
	print("B_ALL " + _line(HS.analyse(rows_b)))
	quit(0)


func _line(res: Dictionary) -> String:
	return "HEAD_SPLIT jumps=%d punch=%d react=%d other=%d per_punch=%.3f per_react=%.3f root=%.1f hips=%.1f trunk=%.1f neck=%.1f" % [
		res["jumps"], res["by_kind"].get("punch", 0), res["by_kind"].get("react", 0), res["by_kind"].get("other", 0),
		res["per_punch"], res["per_react"],
		res["root_p50"], res["hips_p50"], res["trunk_p50"], res["neck_p50"]]


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(k + "="):
			return a.substr(k.length() + 1)
	return dflt


func _load_csv(path: String) -> Array:
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		printerr("head_split_probe: cannot open or empty %s" % path)
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
