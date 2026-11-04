extends SceneTree
## S382 G4 (gym idea 1, without Peak): the fight-night gauge row (scripts/rules/Gauges.gd, scripts/ui/GaugeRow.gd).
##   1. Pure bands: LEGS green < 50 'fresh', amber 50-79 'heavy legs -N', red 80+ 'overreached'; SCALE green at or under
##      limit + 0.05 kg, amber to + 0.5, red beyond; RISK 1 pip < 4 %, 2 at 4-8 %, 3 from 8 %; the injury types on the pips.
##   2. The class window: the next class down of her own sex (women's 60 -> 57), at most 3 kg drawn (and under the lightest).
##   3. read(): the forecast's numbers; an injured fighter's pip and the days left.
##   4. The widget: three dials LEGS / SCALE / RISK, one word each in its band colour; a redraw from other numbers shows
##      the change under the dial; preview() ghosts another forecast (+N / -N, S382 G5) and preview_off() clears it.
##   5. The constants match the rules they mirror (BoutRules.FRESH_FATIGUE / WEIGH_TOLERANCE, WeekPlan.OVERREACHED).
## Population: Lucy Jackson (Data.lucy, women's lightweight 60 kg, 61.4 kg today), forecasts written by hand.

const Data := preload("res://scripts/state/Data.gd")
const Gauges := preload("res://scripts/rules/Gauges.gd")
const GaugeRow := preload("res://scripts/ui/GaugeRow.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const UI := preload("res://scripts/ui/UI.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")

var _fails := 0


func _initialize() -> void:
	_bands()
	_window()
	_read()
	await _widget()
	_check(is_equal_approx(Gauges.LEGS_HEAVY, BoutRules.FRESH_FATIGUE) and is_equal_approx(Gauges.LEGS_OVER, WeekPlan.OVERREACHED)
		and is_equal_approx(Gauges.SCALE_OK, BoutRules.WEIGH_TOLERANCE), "the gauge lines are the rules' own numbers")
	print("GAUGES %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _bands() -> void:
	_check(Gauges.legs(49.9, 0.0) == {"band": "green", "word": "fresh"}, "LEGS 49.9: fresh")
	_check(Gauges.legs(54.0, 8.0) == {"band": "amber", "word": "heavy legs -8"}, "LEGS 54: heavy legs -8")
	_check(Gauges.legs(79.9, 20.0)["band"] == "amber" and Gauges.legs(80.0, 20.0) == {"band": "red", "word": "overreached"}, "LEGS 80: overreached")
	_check(Gauges.scale(60.05, 60.0)["band"] == "green" and Gauges.scale(60.0, 60.0)["word"] == "60.0 kg", "SCALE at the limit + 0.05: green")
	_check(Gauges.scale(60.06, 60.0)["band"] == "amber" and Gauges.scale(60.5, 60.0)["band"] == "amber", "SCALE to + 0.5: amber")
	_check(Gauges.scale(60.51, 60.0)["band"] == "red", "SCALE beyond + 0.5: red")
	_check(Gauges.pips(0.0) == 1 and Gauges.pips(0.039) == 1 and Gauges.pips(0.04) == 2 and Gauges.pips(0.079) == 2
		and Gauges.pips(0.08) == 3 and Gauges.pips(0.3) == 3, "RISK pips: 1 < 4 %, 2 at 4-8 %, 3 from 8 %")
	_check(Gauges.slot("cut") == "cut" and Gauges.slot("nose") == "cut" and Gauges.slot("hand") == "hand" and Gauges.slot("ribs") == "hand"
		and Gauges.slot("strain") == "hand" and Gauges.slot("head") == "head" and Gauges.slot("ko") == "head", "injury types on the three pips")


func _window() -> void:
	var women := GaugeRow.limits_for({"sex": "f"})
	var men := GaugeRow.limits_for({"sex": "m"})
	_check(women.size() == 4 and men.size() == 4, "four classes a sex (%s / %s)" % [str(women), str(men)])
	_check(is_equal_approx(Gauges.class_floor(60.0, women), 57.0), "women's lightweight window 57-60")
	_check(is_equal_approx(Gauges.class_floor(57.0, women), 54.0), "the lightest class: limit - 3")
	_check(is_equal_approx(Gauges.class_floor(60.0, men), 57.5) and is_equal_approx(Gauges.class_floor(70.0, men), 67.0)
		and is_equal_approx(Gauges.class_floor(75.0, women), 72.0), "men 60 -> 57.5; a class 10 kg down draws its last 3 kg (men 70 -> 67, women 75 -> 72)")


func _fc(fat: float, stale: float, kg: float, inj: float) -> Dictionary:
	return {"fatigue_end": fat, "fatigue_now": 49.0, "peak": 69.0, "stale": stale, "kg": kg, "limit": 60.0, "injury": inj}


func _read() -> void:
	var f := {"sex": "f", "weight": 61.4, "injury": {}}
	var d := Gauges.read(_fc(48.0, 0.0, 59.9, 0.05), f, 100, GaugeRow.limits_for(f))
	_check(is_equal_approx(float(d["legs"]), 48.0) and d["legs_band"]["word"] == "fresh" and is_equal_approx(float(d["kg"]), 59.9)
		and is_equal_approx(float(d["kg_now"]), 61.4) and is_equal_approx(float(d["floor"]), 57.0) and int(d["pips"]) == 2
		and str(d["out"]) == "" and int(d["out_days"]) == 0, "read: the forecast's numbers, today's weight, 2 pips at 5 %%: %s" % str(d))
	f["injury"] = {"type": "hand", "days_out": 21, "until_day": 112}
	d = Gauges.read(_fc(48.0, 0.0, 59.9, 0.05), f, 100, GaugeRow.limits_for(f))
	_check(str(d["out"]) == "hand" and int(d["out_days"]) == 12, "injured: the hand pip, 12 days left")
	f["injury"]["until_day"] = 100
	d = Gauges.read(_fc(48.0, 0.0, 59.9, 0.05), f, 100, GaugeRow.limits_for(f))
	_check(str(d["out"]) == "" and int(d["out_days"]) == 0, "cleared today: no red pip")


func _widget() -> void:
	var f := {"sex": "f", "weight": 61.4, "injury": {}, "bout": {"day": 120}}
	var d := GaugeRow.read(_fc(54.0, 8.0, 59.9, 0.09), f, 100)
	var row = GaugeRow.make(d, {}, 330.0)
	root.add_child(row)
	await process_frame
	_check(row.name == "Gauges" and row.get_child_count() == 3, "three dials in one row")
	var titles := []
	for id in GaugeRow.IDS:
		var col: Node = row.find_child("Gauge_" + id, true, false)
		titles.append((col.get_child(0) as Label).text if col != null else "?")
	_check(titles == ["LEGS", "SCALE", "RISK"], "titles: %s" % str(titles))
	var w := _word(row, "legs")
	_check(w.text == "heavy legs -8" and w.get_theme_color("font_color") == UI.AMBER, "LEGS word amber: %s" % w.text)
	w = _word(row, "scale")
	_check(w.text == "59.9 kg" and w.get_theme_color("font_color") == UI.GREEN, "SCALE word green: %s" % w.text)
	w = _word(row, "risk")
	_check(w.text == "9%" and w.get_theme_color("font_color") == WB.RED, "RISK word red at 9 %%: %s" % w.text)
	_check(str((row.find_child("Gauge_scale", true, false) as Control).tooltip_text).contains("61.4"), "today's weight on SCALE's hover")
	var dial: Control = row.find_child("Gauge_scale", true, false).find_child("Dial", true, false)
	_check(dial != null and is_equal_approx(float(dial.get("v")), 59.9) and is_equal_approx(float(dial.get("today")), 61.4),
		"SCALE needle = forecast, ghost tick = today")
	var before: Dictionary = row.values()
	row.queue_free()
	# a redraw from other numbers: the change under the dial
	var row2 = GaugeRow.make(GaugeRow.read(_fc(48.0, 0.0, 60.4, 0.02), f, 100), before, 330.0)
	root.add_child(row2)
	await process_frame
	_check((row2.deltas["legs"] as Label).text == "-6" and (row2.deltas["scale"] as Label).text == "+0.5 kg"
		and (row2.deltas["risk"] as Label).text == "-7%", "the changes under the dials: %s %s %s" % [(row2.deltas["legs"] as Label).text,
		(row2.deltas["scale"] as Label).text, (row2.deltas["risk"] as Label).text])
	_check(_word(row2, "legs").text == "fresh" and _word(row2, "risk").text == "2%", "the words follow the new numbers")
	row2.preview(GaugeRow.read(_fc(48.0, 0.0, 60.4, 0.06), f, 100))
	var d2: Control = row2.find_child("Gauge_legs", true, false).find_child("Dial", true, false)
	await create_timer(GaugeRow.GHOST_S + 0.15).timeout   # S382 G5: the ghost's +N / -N counts up (hover_ghosts_test)
	_check((row2.deltas["legs"] as Label).text == "same" and (row2.deltas["risk"] as Label).text == "+4%", "preview: same / +4%%")
	row2.preview_off()
	_check((row2.deltas["risk"] as Label).text == "" and is_nan(float(d2.get("ghost"))), "preview off clears the ghost")
	f["injury"] = {"type": "cut", "days_out": 14, "until_day": 105}
	var row3 = GaugeRow.make(GaugeRow.read(_fc(48.0, 0.0, 60.0, 0.02), f, 100), {}, 330.0)
	root.add_child(row3)
	await process_frame
	var pd: Control = row3.find_child("Gauge_risk", true, false).find_child("Dial", true, false)
	_check(_word(row3, "risk").text == "out 5 d" and str(pd.get("out")) == "cut" and int(pd.get("out_days")) == 5, "injured: the cut pip red, 5 days")
	row2.queue_free()
	row3.queue_free()


func _word(row: Node, id: String) -> Label:
	return row.find_child("Word_" + id, true, false) as Label


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
