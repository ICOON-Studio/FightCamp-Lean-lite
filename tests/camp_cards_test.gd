extends SceneTree
## S379 CAMPCARDS: the FIGHT CAMP modal as camp cards (docs/mockups/fight_camp_cards.png). Population: the golden path's
## quick-start career (seed 1) - Lucy signed, the coach hired, her first even offer accepted.
##   1. SET CAMP opens five cards, one per BoutRules.CAMP_FOCUSES, each with a station picture and CampForecast's fight-night
##      number; one check mark, on the chosen card; the fighter panel outlines the camp's stat.
##   2. The forecast: Hard beats Standard beats Light on the camp's stat, and every card's forecast is above today.
##   3. Power + Hard: the card takes the check mark, the summary line and the Start button read $850; film off reads $700.
##   4. Start writes the same camp Bouts.start_camp writes for those picks (the old modal's path), and pays $850.
##   5. No she/her on the modal.   6. Stepping the camp's real days lands on the forecast (power and the weigh-in kg).

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")
const CampCard := preload("res://scripts/ui/CampCard.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var f := _book()
	_check(not f.is_empty(), "Lucy has an even bout booked")
	if f.is_empty():
		_done()
		return
	var c: Career = main.career
	main.act("camp", str(f["id"]))
	await _settle(0.1)
	var m: Node = main.modal_node()
	_check(main.modal.get("type", "") == "camp" and m != null, "SET CAMP opens the camp modal")
	# 1. Five cards.
	var keys: Array = BoutRules.CAMP_FOCUSES
	var cards := 0
	for k in keys:
		var b := m.find_child("Focus_" + k, true, false) as Button
		if b == null:
			continue
		cards += 1
		var pic := b.find_child("Pic", true, false) as TextureRect
		_check(pic != null and pic.texture != null, "%s card has a station picture" % k)
	_check(cards == 5, "five camp cards (%d)" % cards)
	_check(_checks(m) == [str(main.modal["focus"])], "one check mark, on the chosen card (%s)" % str(_checks(m)))
	var side := m.find_child("CampSide", true, false)
	_check(side != null and side.find_child("Stat_" + str(main.modal["focus"]), true, false).find_child("Forecast", true, false) != null,
		"the fighter panel outlines the camp's stat with its forecast")
	await _settle(0.8)
	for k in keys:
		var now := float(f["stats"][k])
		var end := float(CampForecast.run(c, f, k, 2)["stats"][k])
		var lbl := m.find_child("Focus_" + k, true, false).find_child("Forecast", true, false) as Label
		_check(lbl != null and lbl.text == "%.1f -> %.1f by fight night" % [now, end] and end > now,
			"%s card: %s (forecast %.2f, now %.2f)" % [k, lbl.text if lbl != null else "?", end, now])
	# 2. The protocol's focus multiplier shows in the forecast.
	var pw := [0.0, 0.0, 0.0, 0.0]
	for p in [1, 2, 3]:
		pw[p] = float(CampForecast.run(c, f, "power", p)["stats"]["power"])
	_check(pw[3] > pw[2] and pw[2] > pw[1] and pw[1] > float(f["stats"]["power"]),
		"power by fight night: Hard %.2f > Standard %.2f > Light %.2f > now %.2f" % [pw[3], pw[2], pw[1], float(f["stats"]["power"])])
	# 3. Power + Hard (film study stays on).
	_press(m.find_child("Focus_power", true, false) as Button, "the Power card")
	_press(main.modal_node().find_child("Protocol_3", true, false) as Button, "the Hard box")
	await _settle(0.8)
	m = main.modal_node()
	var days := int(f["bout"]["day"]) - c.day
	_check(str(main.modal["focus"]) == "power" and int(main.modal["protocol"]) == 3 and bool(main.modal["film"]), "picks: power, hard, film")
	_check(_checks(m) == ["power"], "the check mark moved to Power (%s)" % str(_checks(m)))
	_check(_text(m, "Summary") == "Power camp, Hard - %d days - $850" % days, "summary: %s" % _text(m, "Summary"))
	_check(_text(m, "SummaryParts") == "(camp $700 + film $150)", "the cost parts: %s" % _text(m, "SummaryParts"))
	_check(_text(m, "StartCamp") == "Start the camp, $850", "start: %s" % _text(m, "StartCamp"))
	var hard_fc := m.find_child("Focus_power", true, false).find_child("Forecast", true, false) as Label
	_check(hard_fc != null and hard_fc.text.ends_with("%.1f by fight night" % pw[3]), "the Power card counts on to Hard's forecast: %s" % hard_fc.text)
	_press(m.find_child("Film", true, false) as Button, "film study off")
	await _settle(0.8)
	m = main.modal_node()
	_check(_text(m, "Summary") == "Power camp, Hard - %d days - $700" % days and _text(m, "SummaryParts") == "(camp $700, no film study)",
		"film off: %s %s" % [_text(m, "Summary"), _text(m, "SummaryParts")])
	_press(m.find_child("Film", true, false) as Button, "film study back on")
	await _settle(0.8)
	m = main.modal_node()
	# 5. Words.
	var pron := RegEx.create_from_string("(?i)\\b(she|her|hers|herself|he|his|him)\\b")
	var said: Array = []
	for n in m.find_children("*", "Label", true, false) + m.find_children("*", "Button", true, false):
		var t := str(n.get("text"))
		if pron.search(t) != null:
			said.append(t)
	_check(said.is_empty(), "no pronouns on the modal %s" % str(said))
	# 4. Start writes the camp the rule writes.
	var twin: Dictionary = f.duplicate(true)
	var kg_fc := float(CampForecast.run(c, f, "power", 3)["kg"])
	var cash := c.cash
	_press(m.find_child("StartCamp", true, false) as Button, "Start the camp")
	_check(main.modal.is_empty(), "the modal closes")
	_check(c.cash == cash - 850, "the camp paid $850 (cash %d -> %d)" % [cash, c.cash])
	var paid := Bouts.start_camp(c, twin, "power", 3, true)
	_check(paid == 850, "the rule's own price for those picks: %d" % paid)
	_check(f["camp"] == twin["camp"], "the modal wrote the camp the rule writes:\n    %s\n    %s" % [str(f["camp"]), str(twin["camp"])])
	_check(str(f["load_setting"]) == str(twin["load_setting"]) and str(f["load_setting"]) == "hard", "Hard sets the hard training load")
	# 6. The forecast is the real days: step the camp to fight night (seed 1; a twist card drawn on a later Monday is
	# not in the forecast, so allow a little).
	var bd := int(f["bout"]["day"])
	var kg_at := 0.0
	while c.day < bd:
		if c.day == bd - 1:
			kg_at = float(f["weight"])
		Sim.step_day(c)
	_check(absf(float(f["stats"]["power"]) - pw[3]) < 0.15 and absf(kg_at - kg_fc) < 0.15,
		"fight night as forecast: power %.2f (forecast %.2f), weigh-in %.2f kg (forecast %.2f)" % [float(f["stats"]["power"]), pw[3], kg_at, kg_fc])
	_done()


## The golden path's first weeks: quick start, Lucy signed with three cards, Luke Reid hired, her first even offer taken.
func _book() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			main.act("accept", str(o["id"]))
			return f
	return {}


## The cards that carry the check mark.
func _checks(m: Node) -> Array:
	var out: Array = []
	for k in BoutRules.CAMP_FOCUSES:
		var b := m.find_child("Focus_" + k, true, false)
		if b != null and b.find_child("Check", true, false) != null:
			out.append(k)
	return out


func _text(m: Node, name: String) -> String:
	var n := m.find_child(name, true, false)
	return "" if n == null else str(n.get("text"))


func _press(b: Button, label: String) -> void:
	_check(b != null and not b.disabled, label)
	if b != null and not b.disabled:
		b.emit_signal("pressed")


func _settle(s: float) -> void:
	await create_timer(s).timeout
	await process_frame


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)


func _done() -> void:
	print("CAMP_CARDS failures=%d" % failures)
	quit(1 if failures > 0 else 0)
