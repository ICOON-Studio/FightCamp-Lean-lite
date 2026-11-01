extends SceneTree
## ComboFlow: book control arm, clumsy chains, rule pairs, notes, energy.

const C := preload("res://scripts/rules/Combos.gd")
const CF := preload("res://scripts/rules/ComboFlow.gd")

var failures := 0


func _initialize() -> void:
	_test_book_flows()
	_test_slip_counter()
	_test_clumsy()
	_test_rule_pairs()
	_test_notes()
	_test_energy()
	print("COMBO_FLOW failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _approx(a: float, b: float, tol: float = 0.01) -> bool:
	return absf(a - b) < tol


func _min_book_score() -> float:
	var m := 100.0
	for row in C.BOOK:
		m = minf(m, float(CF.rate(row["beats"])["score"]))
	return m


func _test_book_flows() -> void:
	for row in C.BOOK:
		var id := str(row["id"])
		var beats: Array = row["beats"]
		var r := CF.rate(beats)
		_check(str(r["word"]) == "flows", "book %s flows (score=%d)" % [id, int(r["score"])])


func _test_slip_counter() -> void:
	var chain := ["slip", "cross", "lead_hook"]
	var r := CF.rate(chain)
	_check(str(r["word"]) == "flows", "slip 2-3 counter flows (score=%d)" % int(r["score"]))


func _test_clumsy() -> void:
	var floor := _min_book_score()
	var clumsy_chains := [
		["cross", "cross", "cross"],
		["lead_hook", "lead_hook", "lead_hook"],
		["cross", "rear_hook", "rear_uppercut"],
		["jab", "cross", "jab", "cross", "jab", "cross", "jab"],
		["rear_uppercut"],
	]
	var clumsy_words := 0
	for chain in clumsy_chains:
		var r := CF.rate(chain)
		if float(r["score"]) >= floor:
			_check(false, "clumsy below book floor (%.1f): %s -> %.0f" % [floor, str(chain), float(r["score"])])
		else:
			_check(true, "clumsy below book floor: %s -> %.0f" % [str(chain), float(r["score"])])
		if str(r["word"]) == "clumsy":
			clumsy_words += 1
	_check(clumsy_words >= 3, "at least three clumsy chains (%d)" % clumsy_words)


func _test_rule_pairs() -> void:
	var good_load := CF.rate(["jab", "cross", "lead_hook"])
	var bad_load := CF.rate(["jab", "cross", "rear_hook"])
	_check(float(good_load["score"]) > float(bad_load["score"]),
		"load: jab-cross-lead_hook beats jab-cross-rear_hook (%.0f > %.0f)" % [good_load["score"], bad_load["score"]])
	var good_level := CF.rate(["jab", "cross", "body_hook", "lead_hook"])
	var bad_level := CF.rate(["jab", "cross", "lead_hook", "lead_hook"])
	_check(float(good_level["score"]) > float(bad_level["score"]),
		"levels: body then head beats double lead hook finish (%.0f > %.0f)" % [good_level["score"], bad_level["score"]])


func _test_notes() -> void:
	for row in C.BOOK:
		var notes: Array = CF.rate(row["beats"])["notes"]
		_check(notes.size() >= 1, "book %s has notes" % str(row["id"]))
	var clumsy := CF.rate(["cross", "cross", "cross"])
	var cn: Array = clumsy["notes"]
	_check(cn.size() >= 1, "clumsy chain has notes")
	var joined := " ".join(cn).to_lower()
	_check(joined.contains("cross") or joined.contains("hand") or joined.contains("reload") or joined.contains("power"),
		"clumsy note names the problem")


func _test_energy() -> void:
	var three := ["jab", "cross", "lead_hook"]
	var four := ["jab", "cross", "lead_hook", "cross"]
	var e3 := CF.energy(three)
	var e4 := CF.energy(four)
	_check(e4 > e3, "energy: longer chain costs more (%.4f > %.4f)" % [e4, e3])
	var expected := C.combo_cost(3) * C.POWER_MIX
	_check(_approx(e3, expected), "energy: 3 punches = combo_cost(3)*POWER_MIX (%.4f ~ %.4f)" % [e3, expected])
