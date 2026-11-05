extends SceneTree
## S375 COMBOPLAN1: his own combinations (OwnCombos) - planned on the Training tab, drilled on the week's pads (Sim), a
## signature at ComboWords.SIGNATURE_AT that lands whole more often and runs one punch past his hand speed in the ring
## (Combos.pick), longer chains slower to own and dearer in gas, whole_by_round from his own tank. The tray shows them (S382).

const Data := preload("res://scripts/state/Data.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const DrillTray := preload("res://scripts/ui/DrillTray.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")

var failures := 0


func _initialize() -> void:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	for mv in ["Jab", "Cross", "Lead hook", "Body hook"]:
		f["moves"][mv] = 70.0
	f["stats"]["technique"] = 80.0
	f["stats"]["fight_iq"] = 80.0
	f["stats"]["speed"] = 60.0   # RoundStyle.FAST: hand-speed cap 2
	f["book"] = [{"name": "jab, jab, step in, lead hook", "chain": ["jab", "jab", "step_in", "lead_hook"], "score": 70},
		{"name": "jab, cross", "chain": ["jab", "cross"], "score": 62},
		{"name": "jab, cross, lead hook, cross", "chain": ["jab", "cross", "lead_hook", "cross"], "score": 72}]
	OwnCombos.ensure_ids(f)
	var long_e: Dictionary = f["book"][0]
	var short_e: Dictionary = f["book"][1]
	var four_e: Dictionary = f["book"][2]
	_check(str(long_e["id"]) == "own:1" and str(short_e["id"]) == "own:2", "ids: own:1, own:2")
	_check(OwnCombos.row(long_e)["beats"] == ["jab", "jab", "lead_hook"] and OwnCombos.row(long_e)["moves"] == ["Jab", "Jab", "Lead hook"],
		"the ring row throws its punches; the step is the coach's cue")
	_check(OwnCombos.missing(f, long_e) == "" and not OwnCombos.usable(f, long_e), "every punch a weapon, not drilled yet: not usable")

	# a. Longer chains take longer to own (minutes split over every move).
	f["own_combos"] = {"own:1": 20.0, "own:2": 20.0}
	var a := OwnCombos.drill_week(f, "own:1", 40.0, 60.0, 1) - 20.0
	var b := OwnCombos.drill_week(f, "own:2", 40.0, 60.0, 1) - 20.0
	_check(a > 0.0 and b > a, "the same pad time: jab-cross %.1f > the 4-move chain %.1f" % [b, a])
	_check(OwnCombos.gas(f, long_e) > OwnCombos.gas(f, short_e), "the long chain costs more gas a throw (%.2f > %.2f)" % [OwnCombos.gas(f, long_e), OwnCombos.gas(f, short_e)])

	# b. The week's pads go to the planned combination; it never passes its weakest punch.
	f["own_combos"] = {"own:1": 20.0, "own:2": 40.0}
	f["combos"] = {"1-2": 50.0}
	f["combo_learning"] = "own:1"
	DrillWeek.run(c, f)   # S382 PADWEEK1: the coach's pad nights put the planned combination on Friday
	_check(OwnCombos.mastery(f, "own:1") > 20.0, "the week drills own:1 (%.1f)" % OwnCombos.mastery(f, "own:1"))
	_check(OwnCombos.mastery(f, "own:2") < 40.0 and float(f["combos"]["1-2"]) < 50.0, "the rest fade")
	f["own_combos"]["own:1"] = 99.0
	f["moves"]["Lead hook"] = 50.0
	OwnCombos.drill_week(f, "own:1", 40.0, 60.0, 1)
	_check(OwnCombos.mastery(f, "own:1") <= 99.0 and OwnCombos.cap(f, long_e) <= 50.0, "capped by the weakest punch (cap %.0f)" % OwnCombos.cap(f, long_e))
	f["moves"]["Lead hook"] = 70.0

	# c. Signature: drilling, not length, makes it; it lands whole more often.
	f["own_combos"] = {"own:1": 50.0, "own:2": 50.0, "own:3": 50.0}
	var usable_odds := OwnCombos.lands_whole(f, long_e)
	f["own_combos"]["own:1"] = ComboWords.SIGNATURE_AT
	f["own_combos"]["own:3"] = ComboWords.SIGNATURE_AT
	_check(OwnCombos.signature(f, long_e) and not OwnCombos.signature(f, short_e), "signature at %d on the pads" % int(ComboWords.SIGNATURE_AT))
	_check(OwnCombos.lands_whole(f, long_e) > usable_odds, "a signature lands whole more often (%.2f > %.2f)" % [OwnCombos.lands_whole(f, long_e), usable_odds])

	# S376 Kalli K_COMBOPLAN1: worth capped, long-signature gamble, use_share, ring_edge tired < fresh.
	_check(OwnCombos.worth(f, long_e) <= OwnCombos.COMBO_CAP, "worth never above COMBO_CAP (%.1f <= %.1f)" % [OwnCombos.worth(f, long_e), OwnCombos.COMBO_CAP])
	var odds3 := OwnCombos.lands_whole(f, long_e)
	var odds4 := OwnCombos.lands_whole(f, four_e)
	_check(absf(odds3 - 0.64) < 0.01, "3-punch signature lands whole 0.64 +- 0.01 (%.3f)" % odds3)
	_check(OwnCombos.long_signature(f, four_e) and absf(odds4 - 0.58) < 0.01, "4-punch signature lands whole 0.58 +- 0.01 (%.3f)" % odds4)
	_check(is_equal_approx(OwnCombos.use_share(100.0), 0.33), "use_share(100) == 0.33")
	_check(is_equal_approx(OwnCombos.use_share(35.0), 0.25), "use_share(35) == 0.25 (tired)")
	_check(is_equal_approx(OwnCombos.use_share(100.0, true), 0.40), "use_share(100, true) == 0.40 (named)")
	_check(OwnCombos.ring_edge(f, 100.0) > 0.0 and OwnCombos.ring_edge(f, 100.0) > OwnCombos.ring_edge(f, 35.0),
		"the bout pays the signature: %.2f a round fresh, less tired" % OwnCombos.ring_edge(f, 100.0))
	f["own_combos"]["own:3"] = 0.0
	var none := {"book": [], "moves": f["moves"], "stats": f["stats"]}
	_check(OwnCombos.ring_edge(none, 100.0) == 0.0, "no own combination: no edge")

	# d. In the ring: hand-speed cap 2 - the 3-punch signature still runs (one past), the same chain unsigned does not.
	var cap := RoundStyle.combo_cap(RoundStyle.of_fighter(f))
	var rows := OwnCombos.rows_for_ring(f)
	var sig_row: Dictionary = rows.filter(func(r): return str(r["id"]) == "own:1")[0]
	_check(cap == 2 and bool(sig_row["sig"]), "hand-speed cap 2, own:1 a signature row")
	var picked := Combos.pick({"own:1": 90.0}, cap, 0.5, rows)
	_check(str(picked.get("id", "")) == "own:1", "Combos.pick throws the 3-punch signature at cap 2")
	var plain := sig_row.duplicate()
	plain["sig"] = false
	_check(Combos.pick({"own:1": 90.0}, cap, 0.5, [plain]).is_empty(), "unsigned, it is too long for cap 2")
	var wr := OwnCombos.whole_by_round(f, long_e)
	_check(bool(wr[0]), "the signature is thrown whole in round 1 (%s)" % str(wr))
	f["own_combos"]["own:1"] = 50.0
	_check(not bool(OwnCombos.whole_by_round(f, long_e)[0]), "unsigned, never whole at cap 2 (%s)" % str(OwnCombos.whole_by_round(f, long_e)))

	# e. The fight profile and the bout's combo dict carry it.
	var prof := RoundStyle.of_fighter(f)
	_check((prof["combos"] as Dictionary).has("own:1") and (prof["own_rows"] as Array).size() == 2, "the fight profile has his own combinations")

	# g. S378 PLANCOMBO1 the plan's go-to: NAMED_SHARE while he throws it whole, picked more often in the ring.
	for bad in ["", "own:9", "own:3"]:
		f["plan_combo"] = bad
		_check(OwnCombos.named(f).is_empty(), "no go-to from %s (unset, gone, or not drilled)" % ("'%s'" % bad))
	f["own_combos"] = {"own:1": 0.0, "own:2": ComboWords.SIGNATURE_AT, "own:3": 0.0}
	f["plan_combo"] = ""
	var plain_edge := OwnCombos.ring_edge(f, 100.0)
	f["plan_combo"] = "own:2"
	var go_edge := OwnCombos.ring_edge(f, 100.0)
	_check(str(OwnCombos.named(f).get("id", "")) == "own:2" and plain_edge > 0.0
		and absf(go_edge / plain_edge - OwnCombos.NAMED_SHARE / OwnCombos.USE_SHARE) < 0.001,
		"named jab-cross signature pays %.2f vs %.2f a round (0.40 / 0.33)" % [go_edge, plain_edge])
	_check(is_equal_approx(OwnCombos.ring_edge(f, 35.0), OwnCombos.ring_edge(f, 100.0)),
		"named and whole, the share holds when tired (%.2f)" % OwnCombos.ring_edge(f, 35.0))
	f["own_combos"] = {"own:1": ComboWords.SIGNATURE_AT, "own:2": 0.0, "own:3": 0.0}
	f["plan_combo"] = "own:1"
	var fresh := OwnCombos.ring_edge(f, 100.0, 100.0)
	var gassed := OwnCombos.ring_edge(f, 100.0, 20.0)
	_check(OwnCombos.whole_at(f, long_e, 100.0) and not OwnCombos.whole_at(f, long_e, 20.0) and fresh > gassed
		and absf(fresh / gassed - OwnCombos.NAMED_SHARE / OwnCombos.USE_SHARE) < 0.001,
		"the 3-punch go-to pays while whole (%.2f), not once he is too tired to finish it (%.2f)" % [fresh, gassed])
	f["own_combos"] = {"own:1": 50.0, "own:2": 0.0, "own:3": 0.0}
	var unsigned := OwnCombos.ring_edge(f, 100.0)
	f["plan_combo"] = ""
	_check(is_equal_approx(unsigned, OwnCombos.ring_edge(f, 100.0)), "a go-to never thrown whole (unsigned 3 at cap 2) pays no named share")
	f["own_combos"] = {"own:1": 60.0, "own:2": 60.0, "own:3": 0.0}
	f["moves"]["Lead hook"] = 70.0
	f["plan_combo"] = "own:2"
	var go_rows := OwnCombos.rows_for_ring(f)
	var go_row: Dictionary = go_rows.filter(func(r): return str(r["id"]) == "own:2")[0]
	var other_row: Dictionary = go_rows.filter(func(r): return str(r["id"]) == "own:1")[0]
	_check(is_equal_approx(float(go_row["weight"]), OwnCombos.NAMED_SHARE / OwnCombos.USE_SHARE) and is_equal_approx(float(other_row["weight"]), 1.0),
		"the go-to's ring row weighs %.2f, the others 1.0" % float(go_row["weight"]))
	var go_n := 0
	for i in 100:
		if str(Combos.pick({"own:1": 60.0, "own:2": 60.0}, 3, (float(i) + 0.5) / 100.0, go_rows).get("id", "")) == "own:2":
			go_n += 1
	_check(go_n >= 53 and go_n <= 57, "equal pad time: the go-to is thrown in %d of 100 picks (1.21 : 1)" % go_n)
	f["plan_combo"] = ""
	f["own_combos"] = {"own:1": 50.0, "own:2": 50.0, "own:3": 0.0}

	# f. S382 DRILLCARD1: the Training tab's tray (it replaced the planner card) shows his own combinations as drill cards
	# beside + Build a combination.
	var cards := PadEdit.tray(f, {})
	var card := DrillTray.make(null, f, cards, {}, func(_c): pass, func(_c): pass)
	_check(cards.has("own:1") and cards.has("own:2") and card.find_child("Drill_own_1", true, false) != null
		and card.find_child("Drill_own_2", true, false) != null and card.find_child("BuildCombo", true, false) != null,
		"the tray: a drill card each, and Build (%s)" % str(cards))
	card.free()
	print("COMBO_PLAN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
