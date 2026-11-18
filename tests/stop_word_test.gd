extends SceneTree
## STOPWORD1 (S513, ops/research/TASK_STOPWORD1.md): StopWord.word against the measured table in docs/STOPWORD1_RESULT.md.
## The fixture is that table's 16 pooled rows - 960 real bouts of the TEST CLUB's three boxers against their own weight
## class's amateurs, 60 an asked gap, seeds off 4421, bucketed by the REAL gap. The band a gap belongs to is RECOMPUTED
## here from the counts (2.5-point bins, adjacent violators pooled into monotone blocks, then the brief's chance edges),
## never read from StopWord's rating constants: an edge re-tuned away from the measured bands goes red.
## The raw rows are not monotone (the three chins differ), so a row is checked against its BLOCK's band - the table the
## edges were read off. The 7 rows whose own chance disagrees are named in the result doc, not asserted away here.
## Each check runs on the real module and on runtime MUTANTS of its source (one line changed, compiled here): the real
## module must pass, every mutant must fail - an assert that cannot go red is not a test.
##   <godot.exe> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/stop_word_test.gd

const StopWord := preload("res://scripts/rules/StopWord.gd")
const SRC := "res://scripts/rules/StopWord.gd"
const BIN := 2.5
const WORDS := ["unlikely", "possible", "a real risk"]
## The brief's chance edges: the SPEC the module must carry, kept here so a re-tune of them is caught too.
const SPEC_POSSIBLE := 0.08
const SPEC_RISK := 0.20
## docs/STOPWORD1_RESULT.md, "The table: REAL gap -> the chance": [REAL gap, n, our stopped, their stopped, decisions].
const TABLE := [
	[-5.42, 60, 1, 3, 56], [-2.93, 60, 1, 1, 58], [-1.43, 60, 0, 4, 56], [-0.93, 60, 0, 1, 59],
	[-0.67, 60, 6, 4, 50], [-0.42, 60, 3, 2, 55], [-0.17, 60, 7, 0, 53], [0.57, 60, 1, 2, 57],
	[2.33, 60, 14, 0, 46], [2.58, 60, 5, 0, 55], [4.07, 60, 1, 1, 58], [4.33, 60, 8, 0, 52],
	[5.57, 60, 4, 3, 53], [10.58, 60, 23, 0, 37], [11.33, 60, 45, 0, 15], [12.07, 60, 7, 0, 53],
]

var failures := 0
var blocks: Array = []


func _initialize() -> void:
	blocks = _blocks()
	var real: GDScript = StopWord
	for what in _fixture():
		_fail("the measured fixture: " + what)
	var checks := ["_check_table", "_check_monotone", "_check_words", "_check_edges", "_check_spec"]
	for ck in checks:
		for b in call(ck, real):
			_fail("%s: %s" % [ck, b])
	# Mutants: [what, old line, new line, the check that must go red].
	var mutants := [
		["the lower edge left at the provisional +3.0", "const POSSIBLE_GAP := 0.0", "const POSSIBLE_GAP := 3.0", "_check_table"],
		["the upper edge pushed past the measured risk rows", "const RISK_GAP := 8.0", "const RISK_GAP := 12.0", "_check_table"],
		["the lower edge above the upper", "const POSSIBLE_GAP := 0.0", "const POSSIBLE_GAP := 9.0", "_check_edges"],
		["the upper edge below the lower", "const RISK_GAP := 8.0", "const RISK_GAP := -1.0", "_check_edges"],
		["a level opponent reads unlikely (the lower edge inclusive)", "if gap < POSSIBLE_GAP:", "if gap <= POSSIBLE_GAP:", "_check_edges"],
		["the risk comparison flipped", "if gap < RISK_GAP:", "if gap > RISK_GAP:", "_check_monotone"],
		["the first comparison flipped", "if gap < POSSIBLE_GAP:", "if gap > POSSIBLE_GAP:", "_check_monotone"],
		["the top band dropped to possible", "\treturn \"a real risk\"", "\treturn \"possible\"", "_check_table"],
		["a fourth word", "\treturn \"a real risk\"", "\treturn \"certain\"", "_check_words"],
		["the chance edge re-tuned away from the brief", "const CHANCE_POSSIBLE := 0.08", "const CHANCE_POSSIBLE := 0.15", "_check_spec"],
	]
	for mu in mutants:
		var s := _mutant(str(mu[1]), str(mu[2]))
		if s == null:
			_fail("mutant '%s': the line to change is not in StopWord.gd (the test is stale)" % mu[0])
			continue
		var bad: Array = call(str(mu[3]), s)
		if bad.is_empty():
			_fail("mutant '%s' stayed GREEN under %s" % [mu[0], mu[3]])
		else:
			print("  mutant red: %s (%s: %s)" % [mu[0], mu[3], str(bad[0])])
	if failures == 0:
		print("STOP_WORD PASS")
	else:
		print("STOP_WORD FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _fail(what: String) -> void:
	failures += 1
	print("  FAIL: " + what)


func _mutant(old: String, new: String) -> GDScript:
	var src := FileAccess.get_file_as_string(SRC)
	if not src.contains(old):
		return null
	var g := GDScript.new()
	g.source_code = src.replace(old, new)
	if g.reload() != OK:
		return null
	return g


## The fixture must be the published table: every row's three outcomes add to its n, the blocks rise, all three bands
## are reached, and the module is pure (the brief: no preloads).
func _fixture() -> Array:
	var bad: Array = []
	for r in TABLE:
		if int(r[2]) + int(r[3]) + int(r[4]) != int(r[1]):
			bad.append("row %+.2f: %d + %d + %d is not n=%d" % [float(r[0]), int(r[2]), int(r[3]), int(r[4]), int(r[1])])
	var prev := -1.0
	var bands := {}
	for b in blocks:
		var ch := _chance(b)
		if ch < prev:
			bad.append("the blocks are not monotone at %+.2f" % float(b["lo"]))
		prev = ch
		bands[_band(ch)] = true
	for w in WORDS:
		if not bands.has(w):
			bad.append("no measured block reaches the band '%s'" % w)
	if FileAccess.get_file_as_string(SRC).contains("preload("):
		bad.append("StopWord.gd preloads: the brief asks for a pure module")
	return bad


## The 2.5-point bins of the measured rows, adjacent violators pooled: a bin whose our-stopped chance is lower than the
## block before it joins that block. The same read the probe reports, recomputed here from the counts.
func _blocks() -> Array:
	var bins := {}
	for r in TABLE:
		var key := floorf(float(r[0]) / BIN) * BIN
		if not bins.has(key):
			bins[key] = {"lo": key, "hi": key + BIN, "n": 0, "our": 0, "gap": 0.0}
		var bin: Dictionary = bins[key]
		bin["n"] = int(bin["n"]) + int(r[1])
		bin["our"] = int(bin["our"]) + int(r[2])
		bin["gap"] = float(bin["gap"]) + float(r[0]) * int(r[1])
	var keys: Array = bins.keys()
	keys.sort()
	var out: Array = []
	for k in keys:
		var b: Dictionary = bins[k]
		while not out.is_empty() and _chance(b) < _chance(out[-1]):
			var p: Dictionary = out.pop_back()
			b["lo"] = float(p["lo"])
			b["n"] = int(b["n"]) + int(p["n"])
			b["our"] = int(b["our"]) + int(p["our"])
			b["gap"] = float(b["gap"]) + float(p["gap"])
		out.append(b)
	return out


func _chance(b: Dictionary) -> float:
	return float(b["our"]) / maxf(1.0, float(b["n"]))


func _band(chance: float) -> String:
	if chance < SPEC_POSSIBLE:
		return "unlikely"
	if chance < SPEC_RISK:
		return "possible"
	return "a real risk"


func _block_of(gap: float) -> Dictionary:
	for b in blocks:
		if gap >= float(b["lo"]) and gap < float(b["hi"]):
			return b
	return {}


## Every measured gap, and every block's mean gap, reads the band its pooled chance falls in.
func _check_table(S: GDScript) -> Array:
	var bad: Array = []
	for r in TABLE:
		var gap := float(r[0])
		var b: Dictionary = _block_of(gap)
		if b.is_empty():
			bad.append("gap %+.2f falls in no block" % gap)
			continue
		var want := _band(_chance(b))
		var got: String = S.call("word", gap)
		if got != want:
			bad.append("gap %+.2f (block %+.1f..%+.1f, %.1f%% stopped) reads '%s', want '%s'" % [gap, float(b["lo"]),
				float(b["hi"]), _chance(b) * 100.0, got, want])
	for bl in blocks:
		var mean := float(bl["gap"]) / maxf(1.0, float(bl["n"]))
		var said: String = S.call("word", mean)
		if said != _band(_chance(bl)):
			bad.append("block mean %+.2f reads '%s', want '%s'" % [mean, said, _band(_chance(bl))])
	return bad


## A bigger gap never reads safer: over a -40..+40 sweep, the measured gaps and two extremes.
func _check_monotone(S: GDScript) -> Array:
	var bad: Array = []
	var prev := -1
	var prev_g := 0.0
	for g in _probes():
		var rank: int = WORDS.find(S.call("word", float(g)))
		if rank < prev:
			bad.append("safer as the gap grows: %+.2f was '%s', %+.2f is '%s'" % [prev_g, WORDS[prev], float(g), WORDS[rank]])
		if rank >= prev:
			prev = rank
			prev_g = float(g)
	return bad


## Only the three words, and all three of them somewhere.
func _check_words(S: GDScript) -> Array:
	var bad: Array = []
	var seen := {}
	for g in _probes():
		var w: String = S.call("word", float(g))
		if not WORDS.has(w):
			bad.append("gap %+.2f returns '%s', not one of the three words" % [float(g), w])
		seen[w] = true
	for w in WORDS:
		if not seen.has(w):
			bad.append("the word '%s' is never returned" % w)
	return bad


## The edges are the module's own: below each edge the lower band, at it the upper one, and the lower edge first.
func _check_edges(S: GDScript) -> Array:
	var bad: Array = []
	var cm: Dictionary = S.get_script_constant_map()
	var p := float(cm.get("POSSIBLE_GAP", 0.0))
	var r := float(cm.get("RISK_GAP", 0.0))
	if p >= r:
		bad.append("POSSIBLE_GAP %+.2f is not below RISK_GAP %+.2f" % [p, r])
	var cases := [[p - 0.01, "unlikely"], [p, "possible"], [r - 0.01, "possible"], [r, "a real risk"]]
	for cs in cases:
		var got: String = S.call("word", float(cs[0]))
		if got != str(cs[1]):
			bad.append("word(%+.2f) = '%s', want '%s'" % [float(cs[0]), got, str(cs[1])])
	return bad


## The module carries the brief's chance edges, not a re-tune of them.
func _check_spec(S: GDScript) -> Array:
	var bad: Array = []
	var cm: Dictionary = S.get_script_constant_map()
	if absf(float(cm.get("CHANCE_POSSIBLE", -1.0)) - SPEC_POSSIBLE) > 1e-9:
		bad.append("CHANCE_POSSIBLE %s, want the brief's %.2f" % [str(cm.get("CHANCE_POSSIBLE")), SPEC_POSSIBLE])
	if absf(float(cm.get("CHANCE_RISK", -1.0)) - SPEC_RISK) > 1e-9:
		bad.append("CHANCE_RISK %s, want the brief's %.2f" % [str(cm.get("CHANCE_RISK")), SPEC_RISK])
	return bad


func _probes() -> Array:
	var out: Array = []
	var g := -40.0
	while g <= 40.0:
		out.append(g)
		g += 0.25
	for r in TABLE:
		out.append(float(r[0]))
	out.append(-1000000.0)
	out.append(1000000.0)
	out.sort()
	return out
