extends SceneTree
## S379 CAMPCARDS: the FIGHT CAMP modal as camp cards (docs/mockups/fight_camp_cards.png). Population: the golden path's
## quick-start career (seed 1) - Lucy signed, the coach hired, her first even offer accepted.
##   1. SET CAMP opens five cards, one per BoutRules.CAMP_FOCUSES, each with a station picture and CampForecast's fight-night
##      number; one check mark, on the chosen card; the fighter panel outlines the camp's stat.
##      S381 G1: each card's threshold bar (NightBar) runs now -> fight night; power / technique / conditioning carry the
##      night line's caption, gold exactly when the forecast crosses it; the old line on what the camp does is gone.
##   2. The forecast: Hard beats Standard beats Light on the camp's stat, and every card's forecast is above today.
##   3. Power + Hard: the card takes the check mark; S381 C229 stage 2: the club's nights and film are free (Hard in nights
##      and hours, its scratch-risk line), film off puts the Build-week pad night back in the forecast, the outside partner
##      reads "<mate> - $160 (partner)". Stage 3: the Partner card (club mates free with the round-1 southpaw cost; a click
##      books the southpaw mate - mirrored ink picture, green MATCHES MARIA, the cost gone).
##   4. Start writes the same camp Bouts.start_camp writes for those picks (the old modal's path), and pays $160.
##      S382 G4: the Hard card shows its edge only; the gauge row (LEGS / SCALE / RISK) reads the picked forecast and
##      the fatigue sentence, the agreed-weight line and the header's cut are gone.
##   5. No she/her on the modal.   6. Stepping the camp's real days lands on the forecast (power and the weigh-in kg).

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")
const CampCard := preload("res://scripts/ui/CampCard.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Gauges := preload("res://scripts/rules/Gauges.gd")

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
		var end := float(CampForecast.run(c, f, k, 2, true)["stats"][k])
		var lbl := m.find_child("Focus_" + k, true, false).find_child("Forecast", true, false) as Label
		_check(lbl != null and lbl.text == "%.1f -> %.1f by fight night" % [now, end] and end > now,
			"%s card: %s (forecast %.2f, now %.2f)" % [k, lbl.text if lbl != null else "?", end, now])
		# S381 G1: the threshold bar replaces the line on what the camp does; a gold tick + caption where the stat has a line.
		var card := m.find_child("Focus_" + k, true, false)
		var bar := card.find_child("NightBar", true, false)
		var cap := card.find_child("NightLine", true, false) as Label
		var words := BoutRules.night_line_words(k)
		_check(bar != null and is_equal_approx(float(bar.get("end")), end) and is_equal_approx(float(bar.get("now")), now),
			"%s card: the bar runs now -> fight night" % k)
		_check((cap == null) == (words == "") and (cap == null or cap.text == words), "%s card caption: %s" % [k, cap.text if cap else "-"])
		_check(cap == null or cap.get_theme_color("font_color") == (UI.GOLD if BoutRules.clears_night_line(k, end) else UI.MUTED),
			"%s caption is gold exactly when the forecast crosses" % k)
		_check(bar != null and bool(bar.call("crossed")) == BoutRules.clears_night_line(k, end), "%s bar gold = crossed" % k)
		_check(not " ".join(_labels(card)).contains("shadow and pads") and not " ".join(_labels(card)).contains("roadwork"),
			"%s card: no line on what the camp does" % k)
	# 2. The protocol's focus multiplier shows in the forecast.
	var pw := [0.0, 0.0, 0.0, 0.0]
	for p in [1, 2, 3]:
		pw[p] = float(CampForecast.run(c, f, "power", p, true)["stats"]["power"])
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
	# S381 C229 stage 2: the club's own nights and film are free; the outside partner is the only cash.
	_check(_text(m, "Summary") == "Power camp, Hard, club mates - %d days - free" % days, "summary: %s" % _text(m, "Summary"))
	_check(_text(m, "SummaryParts") == "(the club's own nights)", "the cost parts: %s" % _text(m, "SummaryParts"))
	_check(_text(m, "StartCamp") == "Start the camp", "start: %s" % _text(m, "StartCamp"))
	var hard_fc := m.find_child("Focus_power", true, false).find_child("Forecast", true, false) as Label
	_check(hard_fc != null and hard_fc.text.ends_with("%.1f by fight night" % pw[3]), "the Power card counts on to Hard's forecast: %s" % hard_fc.text)
	var hard_box := m.find_child("Protocol_3", true, false)
	var hard_words := _labels(hard_box)
	_check(hard_words.any(func(t): return str(t).begins_with("5 nights a week, 15 h (usual ")) and not " ".join(hard_words).contains("$"),
		"Hard: nights and hours, no price %s" % str(hard_words))
	# S382 G4: the Hard card's red risk line is gone - its legs and injury are the gauge row's (and the card's hover).
	var hard_risk := hard_box.find_child("Risk", true, false) as Label
	_check(hard_risk != null and hard_risk.text == "edge +1.0" and hard_risk.get_theme_color("font_color") == CampCard.SUB
		and not " ".join(hard_words).contains("injury") and not " ".join(hard_words).contains("scratch") and not " ".join(hard_words).contains("heavy legs")
		and str((hard_box as Control).tooltip_text) == "", "Hard: the edge only, legs and injury ghosted on the gauge row (no tooltip): %s" % str(hard_words))
	# S382 G4: the gauge row in the left column, one CampForecast; the fatigue sentence and the agreed-weight line are gone.
	var hard_fc_all := CampForecast.run(c, f, "power", 3, true)
	var gauges := m.find_child("CampSide", true, false).find_child("Gauges", true, false)
	_check(gauges != null and gauges.get_child_count() == 3, "the gauge row LEGS / SCALE / RISK in the fighter column")
	if gauges != null:
		var legs_word := (gauges.find_child("Word_legs", true, false) as Label).text
		var scale_word := (gauges.find_child("Word_scale", true, false) as Label).text
		var risk_word := (gauges.find_child("Word_risk", true, false) as Label).text
		_check(legs_word == str(Gauges.legs(float(hard_fc_all["fatigue_end"]), float(hard_fc_all["stale"]))["word"])
			and scale_word == "%.1f kg" % float(hard_fc_all["kg"]) and risk_word == "%d%%" % int(round(float(hard_fc_all["injury"]) * 100.0)),
			"the dials read Power + Hard's forecast: %s / %s / %s" % [legs_word, scale_word, risk_word])
	var all_words := " ".join(_labels(m))
	_check(not all_words.contains("Fatigue now") and not all_words.contains("Agreed weight") and not all_words.contains("it also cuts")
		and m.find_child("FatigueLine", true, false) == null and m.find_child("WeighIn", true, false) == null,
		"no fatigue sentence, no weight line beside the dials")
	_check(_labels(m.find_child("Protocol_1", true, false)).has("3 nights, spar 1 a week")
		and _labels(m.find_child("Protocol_2", true, false)).has("4 nights, spar 2 a week"), "Light and Standard in nights, no price")
	_check(_labels(m.find_child("Film", true, false)).has("Film on %s: yes, free" % f["bout"]["opp"]["name"]), "film is free: %s" % str(_labels(m.find_child("Film", true, false))))
	# S381 C229 stage 4: film is earned - nothing found and no plan yet: 0 of Maria's 4 answerable tells, +0.0.
	_check(_labels(m.find_child("Film", true, false)).has("0/4 answered - +0.0 on the night")
		and _labels(m.find_child("Protocol_1", true, false)).any(func(t): return str(t).ends_with("edge +0.25"))
		and _labels(m.find_child("Protocol_2", true, false)).any(func(t): return str(t).ends_with("edge +0.6")),
		"film 'N/M answered', the halved edges on Light / Standard: %s" % str(_labels(m.find_child("Film", true, false))))
	_press(m.find_child("Film", true, false) as Button, "film off")
	await _settle(0.8)
	m = main.modal_node()
	var pw_nofilm := float(CampForecast.run(c, f, "power", 3, false)["stats"]["power"])
	_check(_text(m, "Summary") == "Power camp, Hard, club mates - %d days - free" % days
		and (m.find_child("Focus_power", true, false).find_child("Forecast", true, false) as Label).text.ends_with("%.1f by fight night" % pw_nofilm),
		"film off: still free, the Build-week pad night is back in the forecast (%.2f vs %.2f)" % [pw_nofilm, pw[3]])
	_press(m.find_child("Film", true, false) as Button, "film back on")
	await _settle(0.8)
	# S381 C229 stage 3: the Partner card - club mates (free) until clicked; against southpaw Maria the orthodox boxer
	# pays 'never faced a southpaw' in round 1, the southpaw mate takes it away and carries "MATCHES MARIA".
	m = main.modal_node()
	var opp: Dictionary = f["bout"]["opp"]
	var mate := BoutRules.partner_word(opp)
	var pc := m.find_child("Partner", true, false) as Button
	_check(str(opp.get("stance", "")) == "southpaw" and str(f.get("stance", "orthodox")) == "orthodox" and mate == "southpaw mate",
		"seed 1: an orthodox boxer against a southpaw (%s, %s)" % [str(f.get("stance", "")), str(opp.get("stance", ""))])
	_check(pc != null and _text(pc, "Title") == "Club mates" and _text(pc, "Line") == "free (click: southpaw mate, $160)"
		and _text(pc, "Risk") == "'never faced a southpaw' -0.6 in round 1" and pc.find_child("Matches", true, false) == null
		and pc.find_child("Check", true, false) == null, "partner off: %s" % str(_labels(pc)))
	var pic := pc.find_child("Pic", true, false) as TextureRect if pc != null else null
	_check(pic != null and pic.texture != null and pic.texture.resource_path.ends_with("_sparring.png"), "club mates: an ink sparring picture")
	_press(pc, "the Partner card")
	await _settle(0.8)
	m = main.modal_node()
	pc = m.find_child("Partner", true, false) as Button
	_check(bool(main.modal["partner"]) and pc != null and _text(pc, "Title") == "Southpaw mate"
		and _text(pc, "Line") == "other club - 4 visits - $160" and _text(pc, "Risk") == "no 'never faced a southpaw' in round 1",
		"partner on: %s" % str(_labels(pc)))
	var tag := pc.find_child("Matches", true, false) if pc != null else null
	_check(tag != null and _labels(tag) == ["MATCHES MARIA"] and pc.find_child("Check", true, false) != null, "the green MATCHES MARIA tag and the check")
	pic = pc.find_child("Pic", true, false) as TextureRect if pc != null else null
	_check(pic != null and pic.texture != null and pic.texture.resource_path.ends_with("_southpaw.png")
		and not pic.texture.resource_path.contains("mh_boxer_11") and not pic.texture.resource_path.contains("mh_boxer_13"),
		"the southpaw mate: the mirrored ink card on another body (%s)" % (pic.texture.resource_path if pic != null and pic.texture != null else "none"))
	_check(_text(m, "Summary") == "Power camp, Hard, %s - %d days - $160" % [mate, days] and _text(m, "SummaryParts") == "(partner)"
		and _text(m, "StartCamp") == "Start the camp, $160", "partner on: %s %s / %s" % [_text(m, "Summary"), _text(m, "SummaryParts"), _text(m, "StartCamp")])
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
	var kg_fc := float(CampForecast.run(c, f, "power", 3, true)["kg"])
	var cash := c.cash
	_press(m.find_child("StartCamp", true, false) as Button, "Start the camp")
	_check(main.modal.is_empty(), "the modal closes")
	_check(c.cash == cash - 160, "the camp paid the partner's $160 (cash %d -> %d)" % [cash, c.cash])
	var paid := Bouts.start_camp(c, twin, "power", 3, true, true)
	_check(paid == 160, "the rule's own price for those picks: %d" % paid)
	_check(bool(f["camp"].get("partner", false)) and bool(f["camp"].get("film", false)), "the camp keeps film and the partner")
	_check(not BoutRules.never_faced(str(f.get("stance", "orthodox")), opp, f["camp"])
		and BoutRules.never_faced(str(f.get("stance", "orthodox")), opp, {"protocol": 3, "partner": false}),
		"with the mate: faced a southpaw; without one: round 1 costs 0.6")
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


func _labels(n: Node) -> Array:
	var out: Array = []
	if n != null:
		for l in n.find_children("*", "Label", true, false):
			out.append(str((l as Label).text))
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
