extends SceneTree
## S354 C205 the corner card's round in numbers (CornerStats) and the words each option shows (CornerJobsRow.talk_words,
## CallButtons.energy_words): what the player reads to decide in the minute.

const S := preload("res://scripts/ui/CornerStats.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const CornerJobsRow := preload("res://scripts/ui/CornerJobsRow.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const CallButtons := preload("res://scripts/ui/CallButtons.gd")
const EnergyPips := preload("res://scripts/ui/EnergyPips.gd")
const RecoverCards := preload("res://scripts/ui/RecoverCards.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

var _fails := 0


func _initialize() -> void:
	var names := ["Lucy", "Maria"]
	# Lucy: 3 jabs (2 land), 1 cross lands, 1 body hook misses. Maria: 2 lead hooks land, 1 body hook lands, 1 jab blocked.
	var beats := [_b("a", "jab", "lands"), _b("a", "jab", "lands"), _b("a", "jab", "missed"), _b("a", "cross", "lands"),
		_b("a", "body_hook", "missed"), _b("b", "lead_hook", "lands"), _b("b", "lead_hook", "lands"), _b("b", "body_hook", "lands"),
		_b("b", "jab", "blocked")]
	var map := BodyMap.fresh()
	(map["b"]["places"] as Dictionary)["nose"] = 48.0
	var st := {"round": 1, "won": true, "score": [1, 0], "counts": 0, "tally": BodyMap.tally(beats),
		"energy": {"a": 62.4, "b": 35.0}, "map": map}
	var rows := S.rows(st, names)
	var by := {}
	for r in rows:
		by[str(r["label"])] = r
	_check(rows.size() == 6, "six rows with a body map: landed, jabs, power, body, energy, worst spot (%d)" % rows.size())
	_check(str(by["Punches landed"]["a"]) == "3 of 5" and str(by["Punches landed"]["b"]) == "3 of 4",
		"landed of thrown, both women (%s / %s)" % [by["Punches landed"]["a"], by["Punches landed"]["b"]])
	_check(str(by["Jabs"]["a"]) == "2 of 3" and str(by["Jabs"]["b"]) == "0 of 1", "jabs: 2 of 3 vs 0 of 1")
	_check(str(by["To the body"]["a"]) == "0 of 1" and str(by["To the body"]["b"]) == "1 of 1", "body: 0 of 1 vs 1 of 1")
	_check(float(by["Jabs"]["fa"]) == 1.0 and float(by["Jabs"]["fb"]) == 0.0, "the bar: whoever landed more fills it")
	_check(str(by["Energy at the bell"]["a"]) == "62" and by["Energy at the bell"]["cb"] == S.UI.RED,
		"energy: 62 for her; Maria at 35 reads red")
	_check(str(by["Worst spot"]["b"]) == "Nose 48" and by["Worst spot"]["cb"] == S.UI.AMBER, "Maria's worst spot: nose 48, amber (hurt)")
	_check(S.rows({"tally": {}, "energy": {}}, names).size() == 5, "no body map: no worst-spot row, the rest still reads")
	_check(S.rows({}, names)[0]["a"] == "0 of 0", "an empty round reads 0 of 0, never an error")
	_check(S.head(st, names) == "ROUND 1: LUCY'S ROUND   -   10-9 ON YOUR CARD   -   ROUNDS 1-0", "head: %s" % S.head(st, names))
	st["won"] = false
	st["counts"] = 1
	st["score"] = [0, 1]
	_check(S.head(st, names).begins_with("ROUND 1: MARIA'S ROUND   -   10-8"), "a standing count makes it 10-8 (%s)" % S.head(st, names))
	# The talks: each says what it does to HER (her temper / confidence / discipline).
	var hot := {"temper": 80.0, "confidence": 60.0, "discipline": 50.0}
	var flat := {"temper": 40.0, "confidence": 40.0, "discipline": 70.0}
	_check(CornerJobsRow.talk_words(CornerJobs.talk("fire", flat)) == "+2.0 power, tiring, riskier", "fire, flat fighter: %s" %
		CornerJobsRow.talk_words(CornerJobs.talk("fire", flat)))
	_check(CornerJobsRow.talk_words(CornerJobs.talk("calm", hot)) == "+1.0 power, saves energy, safer", "calm, hothead: %s" %
		CornerJobsRow.talk_words(CornerJobs.talk("calm", hot)))
	_check(CornerJobsRow.talk_words(CornerJobs.talk("truth", flat)) == "-0.8 power", "truth, fragile but disciplined: %s" %
		CornerJobsRow.talk_words(CornerJobs.talk("truth", flat)))
	_check(CornerJobsRow.talk_words({}) == "", "no talk data: no line")
	_check(CallButtons.energy_words(-3.0) == "saves energy" and CallButtons.energy_words(0.0) == "energy even"
		and CallButtons.energy_words(1.5) == "costs energy" and CallButtons.energy_words(3.0) == "costs a lot of energy",
		"a call's energy price in words")
	var mn := CornerJobsRow.menu({"personality": flat, "bout": {"opp": {"style": "Out-boxer"}}}, {})
	_check((mn["talks"] as Dictionary).size() == 3, "the corner menu carries the three talks' effects on her")
	_s443(names, st)
	print("CORNER_STATS %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(1 if _fails > 0 else 0)


func _b(who: String, move: String, result: String) -> Dictionary:
	return {"who": who, "move": move, "result": result, "t": 0.0}


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])


## S443 the operator's marks on the 3D corner card (C321-C323).
func _s443(names: Array, st: Dictionary) -> void:
	# C322 "remove the good at it etc , shot the costs of energy instead": the plan cards draw the price, from CALLS cost.
	_check(EnergyPips.count(-3.0) == 3 and EnergyPips.count(-0.5) == 1 and EnergyPips.count(0.0) == 0 and EnergyPips.count(1.5) == 2
		and EnergyPips.count(3.0) == 3, "energy arrows: one per point, rounded up, 3 at most, none when even")
	_check(EnergyPips.colour(-2.0) == EnergyPips.SAVE and EnergyPips.colour(1.5) == EnergyPips.COST and EnergyPips.colour(3.0) == EnergyPips.HEAVY
		and EnergyPips.colour(0.0) == EnergyPips.EVEN, "saves green, costs amber, a lot red, even grey")
	_check(EnergyPips.tip(-3.0) == "Energy +3 each 30 seconds" and EnergyPips.tip(1.5) == "Energy -1.5 each 30 seconds", "the hover carries the number")
	var grades := {}
	for k in Exchanges.CALLS.keys():
		grades[k] = "Good"
	var grid := CallButtons.corner_grid(grades, "lead", names, func(_k): pass, {}, 4, true)
	var text := ""
	var pips := 0
	var named_when := 0
	for tile in grid.get_children():
		for l in (tile as Control).find_children("*", "Label", true, false):
			text += (l as Label).text + "
"
			if (l as Label).name == "When" and ((l as Label).text.contains(names[0]) or (l as Label).text.contains(names[1])):
				named_when += 1
		pips += (tile as Control).find_children("EnergyPips", "", true, false).size()
	_check(not text.contains("at it") and not text.contains("energy even") and not text.contains("saves energy"),
		"no 'Good at it, saves energy' on the plan cards")
	_check(pips == Exchanges.CALLS.size(), "every plan card draws its energy price (%d of %d)" % [pips, Exchanges.CALLS.size()])
	_check(named_when == 0 and text.contains("When pressed") and text.contains("When tired"), "C321: short whens, no names (\"When pressed\")")
	grid.free()
	# C321 the set-up's gaps name nobody either.
	var gap_named := CornerJobs.GAP_WORDS.values().filter(func(w): return str(w).contains("{"))
	_check(gap_named.is_empty() and CornerJobs.GAP_WORDS["press"] == "when pressed", "the set-up's gaps: \"when pressed\", no names")
	# C323 the recover row: a card per job saying what it changes now, points left as pips, and the energy bar's preview.
	var mn := {"recover": CornerJobs.recover_options(30.0, 9, false), "energy": 30.0, "body": 9, "hurt": false}
	var sel := {"rec": {"water": 2, "ice": 1, "head": 0}}
	var row := RecoverCards.build(mn, sel, func(): pass, Color.WHITE, Color.GRAY, true)
	var cards := row.find_children("RecCard_*", "", true, false)
	var now_w := row.find_child("RecNow_water", true, false) as Label
	var now_i := row.find_child("RecNow_ice", true, false) as Label
	var left := row.find_child("PointsLeft", true, false)
	_check(cards.size() == 2 and row.find_child("Rec_plus_water", true, false) != null, "a card per recover job, with its - and +")
	_check(now_w != null and now_w.text == "+%d energy" % int(2 * CornerJobs.WATER_TIRED) and now_i != null and now_i.text == "-%d body hits" % CornerJobs.ICE_HITS,
		"each card says what its points change now (%s / %s)" % [now_w.text if now_w else "-", now_i.text if now_i else "-"])
	_check(left != null and int(left.get("left")) == 0, "points left drawn as pips (0 of 3 left)")
	_check(RecoverCards.tip("water") != RecoverCards.tip("ice") and RecoverCards.tip("ice").contains("%.1f" % Exchanges.BODY_COST),
		"the hover says how water and ice differ")
	row.free()
	var table := S.build(st, names)
	S.preview(table, 9.0)
	var bar := table.find_child("EnergyBarA", true, false)
	var num := table.find_child("EnergyNumA", true, false) as Label
	_check(bar != null and absf(float(bar.get("ghost")) - 0.09) < 0.001 and num != null and num.text == "62  +9",
		"the energy bar previews the points before the bell (%s)" % (num.text if num else "-"))
	S.preview(table, 0.0)
	_check(num != null and num.text == "62" and float(bar.get("ghost")) == 0.0, "no points: the preview clears")
	table.free()
