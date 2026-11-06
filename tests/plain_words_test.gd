extends SceneTree
## TASK MENUTEXT1 (S392): no debug text or mixed words on the screens.
## Scans scripts/ui/ string literals for patterns the blind critic flagged:
## - "x1." (multiplier debug like "Luke x1.23", "tier 2 x1.0")
## - "/week" (fade rate debug like "fades 0.75/week")
## - "(M" followed by a digit (move reference like "(M34)")
## - "Not now" as button text (offer refusal should be one word: "Pass"; "Later" only closes a window)
## Comments and doc strings are skipped. A pass = no matches.

var failures := 0
## Patterns that signal debug text on screen.
const DEBUG_PATTERNS := ["x1.", "/week"]
## Move reference pattern: "(M" followed by digits, like "(M34)".
var MOVE_REF := RegEx.create_from_string("\\(M\\d")
## Offer refusal words that should be consolidated to "Pass".
const OFFER_WORDS := ["Not now"]   # S392: "Later" stays on buttons that only close a window; Pass refuses


func _initialize() -> void:
	var files := _gd_files("res://scripts/ui")
	_check(files.size() > 50, "found %d scripts in scripts/ui/" % files.size())
	var hits: Array = []
	for p in files:
		var text := FileAccess.get_file_as_string(p)
		hits.append_array(_check_file(text, p))
	for h in hits:
		print("  ", h)
	_check(hits.is_empty(), "no debug text or mixed offer words in scripts/ui/: %d found" % hits.size())
	print("PLAIN_WORDS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## "<file>:<line>: <pattern> in '<literal>'" for each match.
func _check_file(text: String, path: String) -> Array:
	var out: Array = []
	for lit in _literals(text):
		var s: String = lit["s"]
		# Skip comments (before is the text up to the quote; if line starts with # it is a comment).
		var before: String = str(lit["before"])
		if before.strip_edges().begins_with("#"):
			continue
		# Check debug patterns.
		for pat in DEBUG_PATTERNS:
			if s.find(pat) >= 0:
				out.append("%s:%d: '%s' in '%s'" % [path, int(lit["line"]), pat, s.replace("\n", "\\n")])
		# Check move reference pattern.
		if MOVE_REF.search(s) != null:
			out.append("%s:%d: '(M<n>' in '%s'" % [path, int(lit["line"]), s.replace("\n", "\\n")])
		# Check offer refusal words (only if it looks like button text - short string).
		if s.length() < 20:
			for word in OFFER_WORDS:
				if s == word:
					out.append("%s:%d: offer word '%s'" % [path, int(lit["line"]), word])
	return out


## Every string literal outside comments: [{s, line, before}].
func _literals(text: String) -> Array:
	var out: Array = []
	var n := text.length()
	var i := 0
	var line := 1
	var counted := 0
	var marks := [-2, -2, -2]
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
