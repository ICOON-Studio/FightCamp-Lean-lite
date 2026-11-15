extends SceneTree
## PALETTEGUARD1 - blocks loose colours in screen scripts. One palette, no raw hex.
## Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/palette_guard_test.gd
## Add -- write to create/refresh the baseline.

const ROOTS: Array[String] = ["res://scripts/ui", "res://scripts/fight3d"]
const EXEMPT_FILES: Array[String] = ["res://scripts/ui/Palette.gd", "res://scripts/ui/IsoGym.gd"]
const EXEMPT_TEXT: Array[String] = ["StandardMaterial3D", "ShaderMaterial", "ORMMaterial3D"]
const BASELINE_PATH := "res://tests/palette_baseline.json"

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _self_check() -> void:
	var cases: Array = [
		["var a := Color(\"#ff0000\")", 1],
		["x.color = Color(0.2, 0.3, 0.4)", 1],
		["const C := \"#1a1512\"", 1],
		["Color(PAGE, 0.6)", 0],
		["# Color(\"#fff\") in a comment", 0],
		["var b = Color.WHITE  # Color(1,1,1)", 1],
		["m.modulate = Color.TRANSPARENT", 0],
		["Color8(10, 20, 30)", 1],
	]
	for c in cases:
		var got: int = _count_line(str(c[0]))
		_check(got == int(c[1]), "self-check '%s' expected %d got %d" % [c[0], c[1], got])


func _strip_trailing_comment(line: String) -> String:
	var in_str := false
	for i in line.length():
		var ch := line[i]
		if ch == "\"":
			in_str = not in_str
		elif ch == "#" and not in_str:
			return line.substr(0, i)
	return line


func _count_line(line: String) -> int:
	var stripped := line.strip_edges()
	if stripped.begins_with("#"):
		return 0
	var code := _strip_trailing_comment(line)
	var count := 0
	var re_color_str := RegEx.new()
	re_color_str.compile("Color\\(\\s*\"")
	var re_color_num := RegEx.new()
	re_color_num.compile("Color\\(\\s*[-0-9.]")
	var re_html := RegEx.new()
	re_html.compile("Color\\.html\\(")
	var re_color8 := RegEx.new()
	re_color8.compile("Color8\\(")
	var re_named := RegEx.new()
	re_named.compile("Color\\.(WHITE|BLACK|RED|GREEN|BLUE|YELLOW|GRAY|GREY|ORANGE|PURPLE)\\b")
	var re_hex := RegEx.new()
	re_hex.compile("\"#[0-9a-fA-F]{3,8}\"")
	var str_matches := re_color_str.search_all(code)
	for _m in str_matches:
		count += 1
	for m in re_color_num.search_all(code):
		var pos: int = m.get_start()
		var inside := false
		for sm in str_matches:
			if pos > sm.get_start() and pos < sm.get_end() + 40:
				inside = true
				break
		if not inside:
			count += 1
	for _m in re_html.search_all(code):
		count += 1
	for _m in re_color8.search_all(code):
		count += 1
	for _m in re_named.search_all(code):
		count += 1
	var hex_matches := re_hex.search_all(code)
	for hm in hex_matches:
		var hpos: int = hm.get_start()
		var already := false
		for sm in str_matches:
			if hpos >= sm.get_start() and hpos <= sm.get_end():
				already = true
				break
		if not already:
			count += 1
	return count


func _count_file(path: String) -> int:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return 0
	var total := 0
	while not f.eof_reached():
		total += _count_line(f.get_line())
	f.close()
	return total


func _collect_files() -> Array[String]:
	var result: Array[String] = []
	for root in ROOTS:
		_walk(root, result)
	result.sort()
	return result


func _walk(path: String, out: Array[String]) -> void:
	var da := DirAccess.open(path)
	if da == null:
		return
	da.list_dir_begin()
	var name := da.get_next()
	while name != "":
		var full := path.path_join(name)
		if da.current_is_dir():
			_walk(full, out)
		elif name.ends_with(".gd") and not name.ends_with(".uid"):
			out.push_back(full)
		name = da.get_next()
	da.list_dir_end()


func _is_exempt(path: String) -> bool:
	if path in EXEMPT_FILES:
		return true
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return false
	var text := f.get_as_text()
	f.close()
	for marker in EXEMPT_TEXT:
		if marker in text:
			return true
	return false


func _read_baseline() -> Dictionary:
	if not FileAccess.file_exists(BASELINE_PATH):
		return {}
	var f := FileAccess.open(BASELINE_PATH, FileAccess.READ)
	if f == null:
		return {}
	var text := f.get_as_text()
	f.close()
	var parsed = JSON.parse_string(text)
	if parsed is Dictionary:
		return parsed
	return {}


func _write_baseline(counts: Dictionary) -> void:
	var keys: Array[String] = []
	for k in counts:
		if int(counts[k]) > 0:
			keys.push_back(str(k))
	keys.sort()
	var lines: Array[String] = ["{"]
	for i in keys.size():
		var comma := "," if i < keys.size() - 1 else ""
		lines.push_back("\t\"%s\": %d%s" % [keys[i], int(counts[keys[i]]), comma])
	lines.push_back("}")
	var f := FileAccess.open(BASELINE_PATH, FileAccess.WRITE)
	if f:
		f.store_string("\n".join(lines) + "\n")
		f.close()


func _initialize() -> void:
	_self_check()
	if failures > 0:
		print("PALETTE_GUARD self-check FAILED")
		quit(1)
		return

	var args := OS.get_cmdline_user_args()
	var write_mode := "write" in args

	var files := _collect_files()
	var counts := {}
	var exempt_count := 0
	var total_raw := 0

	for path in files:
		if _is_exempt(path):
			exempt_count += 1
			continue
		var c := _count_file(path)
		counts[path] = c
		total_raw += c

	if write_mode:
		_write_baseline(counts)
		var n := 0
		for k in counts:
			if int(counts[k]) > 0:
				n += 1
		print("PALETTE_GUARD wrote %d files" % n)
		quit(0)
		return

	var baseline := _read_baseline()
	var over := 0
	var new_files := 0
	var shrunk := 0

	for path in counts:
		var c: int = int(counts[path])
		if path in baseline:
			var b: int = int(baseline[path])
			if c > b:
				over += 1
				print("FAIL %s raw colours %d > baseline %d" % [path, c, b])
			elif c < b:
				shrunk += 1
				print("SHRUNK %s %d -> %d" % [path, b, c])
		else:
			if c > 0:
				new_files += 1
				print("FAIL %s new file with %d raw colours - use Palette.gd" % [path, c])

	print("PALETTE_GUARD files=%d exempt=%d raw=%d over=%d new=%d shrunk=%d" % [
		files.size() - exempt_count, exempt_count, total_raw, over, new_files, shrunk])
	quit(1 if over + new_files > 0 else 0)
