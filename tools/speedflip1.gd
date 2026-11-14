extends SceneTree
## SPEEDFLIP1: reads the four punch_speed_test outputs saved in docs/speedflip1/ and reports the noise
## (rows that differ between two runs of the same arm) and the real differences (rows that are stable in
## both arms but fail in one and pass in the other). The noise comes from FighterLife._process_modification()
## using get_process_delta_time() which varies between runs (see docs/SPEEDFLIP1_RESULT.md).
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tools/speedflip1.gd

const DIR := "docs/speedflip1/"
const FILES := ["new1.txt", "new2.txt", "old1.txt", "old2.txt"]

func _parse(path: String) -> Dictionary:
	var rows := {}
	var checks := {}
	var content := FileAccess.get_file_as_string(path)
	if content.is_empty():
		return {}
	var lines := content.split("\n")
	for line_raw in lines:
		var line: String = line_raw.strip_edges()
		if line.begins_with("ROW "):
			var parts := line.split(" ")
			if parts.size() >= 3:
				var clip := parts[1]
				var top := 0.0
				var first := 0.0
				var pop := 0.0
				var body := 0.0
				for i in parts.size():
					if parts[i] == "top" and i + 1 < parts.size():
						top = float(parts[i + 1])
					elif parts[i] == "at" and i > 0 and parts[i - 1] == "moves" and i + 1 < parts.size():
						first = float(parts[i + 1])
					elif parts[i] == "step" and i + 1 < parts.size():
						var val: String = parts[i + 1]
						pop = float(val.replace("x", ""))
					elif parts[i] == "arm" and i + 2 < parts.size() and parts[i + 1] == "the":
						var val: String = parts[i + 2]
						body = float(val.replace("x", ""))
				rows[clip] = {"top": top, "first": first, "pop": pop, "body": body}
		elif line.begins_with("PASS ") or line.begins_with("FAIL "):
			var status := "PASS" if line.begins_with("PASS ") else "FAIL"
			var rest := line.substr(5)
			var space := rest.find(" ")
			if space > 0:
				var check_type := rest.substr(0, space)
				var clip := rest.substr(space + 1)
				var colon := clip.find(":")
				if colon > 0:
					clip = clip.substr(0, colon)
				if not checks.has(clip):
					checks[clip] = {}
				checks[clip][check_type] = status
	return {"rows": rows, "checks": checks}

func _same_arr(a: Array, b: Array, eps: float = 0.001) -> bool:
	if a.size() != b.size():
		return false
	for i in a.size():
		if absf(float(a[i]) - float(b[i])) > eps:
			return false
	return true

func _noise(runs: Array) -> Dictionary:
	var noise := {}
	var all_clips := {}
	for run in runs:
		for clip in run["rows"]:
			all_clips[clip] = true
	for clip in all_clips:
		var values := []
		for run in runs:
			if run["rows"].has(clip):
				var r: Dictionary = run["rows"][clip]
				values.append([r["top"], r["first"], r["pop"], r["body"]])
		var all_same := true
		for i in range(1, values.size()):
			if not _same_arr(values[0], values[i]):
				all_same = false
				break
		if not all_same:
			noise[clip] = true
	return noise

func _initialize() -> void:
	var runs := []
	for fname in FILES:
		var path: String = ProjectSettings.globalize_path("res://") + DIR + fname
		if not FileAccess.file_exists(path):
			print("SPEEDFLIP1 missing: %s" % path)
			quit(1)
			return
		runs.append(_parse(path))
	if runs.size() != 4:
		print("SPEEDFLIP1 expected 4 runs, got %d" % runs.size())
		quit(1)
		return
	var new_runs := [runs[0], runs[1]]
	var old_runs := [runs[2], runs[3]]
	var new_noise := _noise(new_runs)
	var old_noise := _noise(old_runs)
	var new_checks: Dictionary = runs[0]["checks"]
	var old_checks: Dictionary = runs[2]["checks"]
	var all_clips := {}
	for clip in runs[0]["rows"]:
		all_clips[clip] = true
	var stable := {}
	for clip in all_clips:
		if not new_noise.has(clip) and not old_noise.has(clip):
			stable[clip] = true
	var real_new_only := 0
	var real_old_only := 0
	for clip in stable:
		if not new_checks.has(clip) or not old_checks.has(clip):
			continue
		for check_type in ["SPEED", "FIRST", "POP", "SYNC"]:
			var new_status: String = new_checks[clip].get(check_type, "PASS")
			var old_status: String = old_checks[clip].get(check_type, "PASS")
			if new_status == "FAIL" and old_status == "PASS":
				real_new_only += 1
			elif new_status == "PASS" and old_status == "FAIL":
				real_old_only += 1
	var total_noise := new_noise.size() + old_noise.size()
	print("SPEEDFLIP1 noise_rows=%d real_new_only=%d real_old_only=%d" % [total_noise, real_new_only, real_old_only])
	quit(0)
