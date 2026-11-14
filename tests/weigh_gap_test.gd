extends SceneTree
## WeighGap: the club-show weight gap (England Boxing 2026 rules 7.1.3, 2.7.8).

const WeighGap := preload("res://scripts/rules/WeighGap.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_gap_kg()
	_test_margin()
	_test_in_gap()
	_test_ways()
	_test_best_cut()
	_test_miss()
	_test_championship()
	print("WEIGH_GAP checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


func _test_gap_kg() -> void:
	_check(WeighGap.gap_kg(57.0) == 2.5, "57 kg class -> 2.5 gap")
	_check(WeighGap.gap_kg(60.0) == 2.5, "60 kg class -> 2.5 gap")
	_check(WeighGap.gap_kg(65.0) == 2.5, "65 kg class -> 2.5 gap (boundary)")
	_check(WeighGap.gap_kg(70.0) == 5.0, "70 kg class -> 5.0 gap")
	_check(WeighGap.gap_kg(75.0) == 5.0, "75 kg class -> 5.0 gap")
	_check(WeighGap.gap_kg(60.0, true) == 2.0, "skills bout at 60 kg -> 2.0 gap")
	_check(WeighGap.gap_kg(75.0, true) == 2.0, "skills bout at 75 kg -> 2.0 gap")


func _test_margin() -> void:
	# 60 kg class, gap 2.5: own 60.0, opp 58.5 -> diff 1.5, margin = 2.5 - 1.5 = 1.0 (inside)
	_check(absf(WeighGap.margin(60.0, 58.5, 60.0) - 1.0) < 0.001, "margin inside: 60.0 vs 58.5 at 60 kg class = +1.0")
	# 60 kg class, gap 2.5: own 60.0, opp 57.0 -> diff 3.0, margin = 2.5 - 3.0 = -0.5 (outside)
	_check(absf(WeighGap.margin(60.0, 57.0, 60.0) - (-0.5)) < 0.001, "margin outside: 60.0 vs 57.0 at 60 kg class = -0.5")
	# symmetric: margin(58.5, 60.0) == margin(60.0, 58.5)
	_check(absf(WeighGap.margin(58.5, 60.0, 60.0) - 1.0) < 0.001, "margin is symmetric")


func _test_in_gap() -> void:
	# exactly on the edge: diff == gap -> margin == 0 -> in
	_check(WeighGap.in_gap(60.0, 57.5, 60.0), "exactly on the edge (diff = gap) is in")
	# 0.1 kg over: diff = gap + 0.1 -> margin = -0.1 -> out
	_check(not WeighGap.in_gap(60.0, 57.4, 60.0), "0.1 kg over the edge is out")
	# well inside
	_check(WeighGap.in_gap(59.0, 58.5, 60.0), "well inside the gap")
	# heavy class
	_check(WeighGap.in_gap(72.0, 68.0, 75.0), "75 kg class: 72 vs 68 (diff 4, gap 5) is in")
	_check(not WeighGap.in_gap(72.0, 66.0, 75.0), "75 kg class: 72 vs 66 (diff 6, gap 5) is out")


func _test_ways() -> void:
	var w := WeighGap.ways(60.0, 57.0, 60.0, 1, 30)  # margin = -0.5, 0.5 kg out
	_check(w.size() == 3, "ways returns 3 entries")
	_check((w[0] as Dictionary).get("id", "") == "eat_less", "ways[0] is eat_less")
	_check((w[1] as Dictionary).get("id", "") == "train_off", "ways[1] is train_off")
	_check((w[2] as Dictionary).get("id", "") == "ask_kilo", "ways[2] is ask_kilo")

	# eat_less always ok
	var eat := w[0] as Dictionary
	_check(eat.get("ok", false) == true, "eat_less is always ok")
	_check(eat.get("tank", 0) == 4, "eat_less costs 4 tank")
	_check(eat.get("tired", 0) == 0, "eat_less adds 0 tired")
	_check(eat.get("favours", 0) == 0, "eat_less spends 0 favours")
	_check(absf(float(eat.get("kg", -1.0))) < 0.001, "eat_less moves 0.0 kg")

	# train_off always ok
	var train := w[1] as Dictionary
	_check(train.get("ok", false) == true, "train_off is always ok")
	_check(train.get("tired", 0) == 8, "train_off adds 8 tired")
	_check(absf(float(train.get("kg", -1.0)) - 0.3) < 0.001, "train_off moves 0.3 kg")

	# ask_kilo: 0.5 kg out with 1 favour -> ok
	var ask := w[2] as Dictionary
	_check(ask.get("ok", false) == true, "ask_kilo ok at 0.5 kg out with 1 favour")
	_check(ask.get("favours", 0) == 1, "ask_kilo spends 1 favour when ok")
	_check(absf(float(ask.get("kg", -1.0)) - 1.0) < 0.001, "ask_kilo moves 1.0 kg when ok")

	# ask_kilo: 1.5 kg out -> not ok, why = "only within 1 kg of the gap"
	var w2 := WeighGap.ways(60.0, 56.0, 60.0, 1, 30)  # margin = -1.5
	var ask2 := (w2[2] as Dictionary)
	_check(ask2.get("ok", true) == false, "ask_kilo not ok at 1.5 kg out")
	_check(ask2.get("why", "") == "only within 1 kg of the gap", "ask_kilo why at 1.5 kg out")

	# ask_kilo: 0 favours -> not ok, why = "no favour with the host"
	var w3 := WeighGap.ways(60.0, 57.0, 60.0, 0, 30)  # margin = -0.5, 0 favours
	var ask3 := (w3[2] as Dictionary)
	_check(ask3.get("ok", true) == false, "ask_kilo not ok with 0 favours")
	_check(ask3.get("why", "") == "no favour with the host", "ask_kilo why with 0 favours")

	# ask_kilo: already inside -> not ok, why = "already inside the gap"
	var w4 := WeighGap.ways(59.0, 58.5, 60.0, 1, 30)  # margin = +2.0
	var ask4 := (w4[2] as Dictionary)
	_check(ask4.get("ok", true) == false, "ask_kilo not ok when already inside")
	_check(ask4.get("why", "") == "already inside the gap", "ask_kilo why when already inside")

	# every entry has all expected keys
	for i in 3:
		var d := w[i] as Dictionary
		for key in ["id", "ok", "why", "tank", "tired", "favours", "kg"]:
			_check(d.has(key), "ways[%d] has key '%s'" % [i, key])


func _test_best_cut() -> void:
	_check(WeighGap.best_cut(41) == "train_off", "best_cut at 41 tired -> train_off")
	_check(WeighGap.best_cut(42) == "eat_less", "best_cut at 42 tired -> eat_less")
	_check(WeighGap.best_cut(50) == "eat_less", "best_cut at 50 tired -> eat_less")


func _test_miss() -> void:
	# with spare, roll < 1/3 -> rematched
	var m1 := WeighGap.miss(0.2, true)
	_check(m1.get("rematched", false) == true, "miss: spare + roll 0.2 -> rematched")
	_check(m1.get("off", true) == false, "miss: spare + roll 0.2 -> not off")
	_check(m1.get("cost", 999) == 0, "miss: spare + roll 0.2 -> cost 0")

	# with spare, roll >= 1/3 -> off
	var m2 := WeighGap.miss(0.5, true)
	_check(m2.get("rematched", true) == false, "miss: spare + roll 0.5 -> not rematched")
	_check(m2.get("off", false) == true, "miss: spare + roll 0.5 -> off")
	_check(m2.get("cost", 0) == 300, "miss: spare + roll 0.5 -> cost 300")
	_check(m2.get("favours", 0) == 1, "miss: spare + roll 0.5 -> costs 1 favour")

	# no spare -> off regardless of roll
	var m3 := WeighGap.miss(0.1, false)
	_check(m3.get("rematched", true) == false, "miss: no spare + roll 0.1 -> not rematched")
	_check(m3.get("off", false) == true, "miss: no spare + roll 0.1 -> off")


func _test_championship() -> void:
	_check(WeighGap.championship(60.0, 60.0, 0.5), "championship: on limit is in")
	_check(WeighGap.championship(60.4, 60.0, 0.5), "championship: within tolerance is in")
	_check(not WeighGap.championship(60.6, 60.0, 0.5), "championship: over tolerance is out")
