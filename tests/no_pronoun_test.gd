extends SceneTree
## S371 NO HIS/HER (operator S354: "use names or do not use it if it is not necessary"; male boxers join, TASK_MALE1):
## no game text says she / her / hers / herself. Scans every string literal in res://scripts/**/*.gd (comments skipped)
## and every string in res://assets/data/*.json, {placeholders} stripped first ({her} is filled with the NAME).
## Kept, by an explicit list: the "her" actor slot / words key, the " her " -> " the " display map and the S354 wrestling
## reaction ids that saved plans store ("tie:reaction"; WrestleChains.say shows "the" on screen). A bare "her" as the
## fallback of a .get() is a name stand-in on screen, so it fails.
##   1. the scanner: a planted "she" line is caught, a comment and a placeholder are not, a fallback "her" is caught.
##   2. scripts: no she/her literal outside the list.   3. data: no she/her string, no key but "her".

const PRONOUN := "(?i)\\b(she|her|hers|herself)\\b"
const PLACEHOLDER := "\\{[A-Za-z_]+\\}"
const GET_FALLBACK := "\\.get\\(\\s*\"[^\"]*\"\\s*,\\s*$"
## The S354 saved move ids (WrestleChains.CHAINS "reaction"; plans store "<tie>:<reaction>").
const REACTIONS := ["carries her head high", "squares her hips", "drops her head", "pulls her wrist back",
	"straightens her arm", "pulls her arm free", "lifts her elbow", "keeps her head on my side",
	"keeps her head on the far side", "pulls her arm away", "lifts her head"]
## Code, not text: the actor slot / words key ("her" vs "opp" / "their") and the reaction display map's argument.
const CODE := ["her", " her "]
const DATA_KEYS := ["her"]

var failures := 0
var _pron := RegEx.create_from_string(PRONOUN)
var _ph := RegEx.create_from_string(PLACEHOLDER)
var _fallback := RegEx.create_from_string(GET_FALLBACK)
var _tie_id := RegEx.create_from_string("^[a-z_]+:")


func _initialize() -> void:
	# 1. The scanner on a planted file.
	var planted := "var a := \"she runs\"  # her comment\n## her doc\nvar b := \"{her} jabs\"\nvar c := f.get(\"first\", \"her\")\n" \
		+ "var d := ctx_actor(\"her\")\nvar e := \"\"\"two\nlines, hers\"\"\"\nvar g := 'Her road'\n"
	var bad := _bad_literals(planted, "planted")
	_check(bad.size() == 4, "the scanner catches the planted she, the fallback her, a triple-quoted hers and a single-quoted Her (%s)" % str(bad))
	_check(bad.size() > 0 and str(bad[0]).begins_with("planted:1:"), "and names the line (%s)" % str(bad))
	# 2. Every script's string literals.
	var files := _gd_files("res://scripts")
	var hits: Array = []
	var seen := 0
	for p in files:
		var text := FileAccess.get_file_as_string(p)
		seen += _literals(text).size()
		hits.append_array(_bad_literals(text, p))
	_check(files.size() > 100 and seen > 5000, "scanned %d scripts, %d string literals" % [files.size(), seen])
	for h in hits:
		print("  ", h)
	_check(hits.is_empty(), "no she/her in a script's text: %d found" % hits.size())
	# 3. The text data.
	var data_hits: Array = []
	var n_json := 0
	for fn in DirAccess.get_files_at("res://assets/data"):
		if not fn.ends_with(".json"):
			continue
		var raw := FileAccess.get_file_as_string("res://assets/data/" + fn)
		if raw.strip_edges() == "":
			continue
		n_json += 1
		var parsed: Variant = JSON.parse_string(raw)
		_check(parsed != null, "%s parses" % fn)
		_walk(parsed, fn, data_hits)
	_check(n_json >= 5, "scanned %d data files" % n_json)
	for h in data_hits:
		print("  ", h)
	_check(data_hits.is_empty(), "no she/her in the text data: %d found" % data_hits.size())
	print("NO_PRONOUN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## "<where>:<line>: <literal>" for each literal that says she/her and is not on the kept list.
func _bad_literals(text: String, where: String) -> Array:
	var out: Array = []
	for l in _literals(text):
		var s: String = l["s"]
		if _pron.search(_ph.sub(s, "", true)) == null:
			continue
		if CODE.has(s) and not (s == "her" and _fallback.search(str(l["before"])) != null):
			continue
		if REACTIONS.has(s) or (_tie_id.search(s) != null and REACTIONS.has(s.substr(s.find(":") + 1))):
			continue
		out.append("%s:%d: %s" % [where, int(l["line"]), s.replace("\n", "\\n")])
	return out


## Every string literal outside comments: [{s, line, before (the line's text up to the opening quote)}].
func _literals(text: String) -> Array:
	var out: Array = []
	var n := text.length()
	var i := 0
	var line := 1
	var counted := 0
	var marks := [-2, -2, -2]   # the next '#', '"', "'" (cached: each find runs once per mark passed)
	while i < n:
		var at := _next_of(text, i, marks)
		if at < 0:
			break
		line += text.count("\n", counted, at) if at > counted else 0
		counted = at
		var ch := text[at]
		if ch == "#":
			var eol := text.find("\n", at)
			i = n if eol < 0 else eol
			continue
		var triple := text.substr(at, 3) == ch.repeat(3)
		var j := at + (3 if triple else 1)
		var end := -1
		if triple:
			end = text.find(ch.repeat(3), j)
		else:
			var k := j
			while k < n:
				var c := text[k]
				if c == "\\":
					k += 2
					continue
				if c == ch or c == "\n":
					break
				k += 1
			end = k
		if end < 0:
			end = n
		var sol := text.rfind("\n", at) + 1
		out.append({"s": text.substr(j, end - j), "line": line, "before": text.substr(sol, at - sol)})
		i = end + (3 if triple else 1)
	return out


## The first '#', '"' or "'" at or after `from`, or -1. `marks` caches each one's last find.
func _next_of(text: String, from: int, marks: Array) -> int:
	var best := -1
	var chars := ["#", "\"", "'"]
	for m in 3:
		if int(marks[m]) != -1 and int(marks[m]) < from:
			marks[m] = text.find(chars[m], from)
		var k := int(marks[m])
		if k >= 0 and (best < 0 or k < best):
			best = k
	return best


func _walk(v: Variant, path: String, out: Array) -> void:
	if v is Dictionary:
		for k in v:
			if _pron.search(_ph.sub(str(k), "", true)) != null and not DATA_KEYS.has(str(k)):
				out.append("%s: key %s" % [path, str(k)])
			_walk(v[k], "%s/%s" % [path, str(k)], out)
	elif v is Array:
		for i in (v as Array).size():
			_walk(v[i], "%s[%d]" % [path, i], out)
	elif v is String:
		if _pron.search(_ph.sub(v, "", true)) != null:
			out.append("%s: %s" % [path, v])


func _gd_files(dir: String) -> Array:
	var out: Array = []
	for fn in DirAccess.get_files_at(dir):
		if fn.ends_with(".gd"):
			out.append(dir.path_join(fn))
	for sub in DirAccess.get_directories_at(dir):
		out.append_array(_gd_files(dir.path_join(sub)))
	return out


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
