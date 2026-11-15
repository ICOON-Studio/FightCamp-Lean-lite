extends SceneTree
## S489 R58 APPROACHUI3 (map section 7, "Week review (Monday) | loyalty moves by cause; band crossed"): Loyalty.week sums
## the week's moves by cause, names a band crossed, ignores moves outside the week and zero moves, and the week review's
## LOYALTY row (WeekReadRows.loyalty) shows it - none when nothing moved. Run:
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/loyalty_week_test.gd

const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const WeekReadRows := preload("res://scripts/ui/WeekReadRows.gd")

var fails := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		fails += 1
		print("FAIL ", what)


func _initialize() -> void:
	var f := {"id": "a", "loyalty": 58}
	Loyalty.apply(f, "bout_won", 3)          # before the week: +2 -> 60
	Loyalty.apply(f, "short", 10)            # -3 -> 57
	Loyalty.apply(f, "offer_passed", 11)     # -3 -> 54
	Loyalty.apply(f, "short_running", 12)    # -6 -> 48, Settled -> Wavering
	Loyalty.commit(f, 0, "word_card", 13)    # a zero move: never a cause
	var w := Loyalty.week(f, 8, 15)
	_check(not w.is_empty(), "a week with moves gives a row")
	_check(int(w.get("before", -1)) == 60 and int(w.get("after", -1)) == 48, "60 to 48 (was %s)" % str(w))
	_check(str(w.get("kind", "")) == "down", "kind down")
	_check(bool(w.get("crossed", false)) and str(w["band_before"]) == "Settled" and str(w["band_after"]) == "Wavering",
		"Settled to Wavering crossed")
	var causes: Array = w.get("causes", [])
	_check(causes.size() == 3, "three causes, the zero move and the earlier win left out (%d)" % causes.size())
	_check(causes.size() > 0 and int(causes[0]["n"]) == -6 and str(causes[0]["word"]) == "short again", "biggest first")
	var text := str(w.get("text", ""))
	_check(text.begins_with("60 to 48, Settled to Wavering.") and text.contains("Short again -6") and text.contains("an offer passed -3"),
		"text names the band and the causes: " + text)
	_check(not text.contains("_"), "no code words in the text")
	# Two moves of one cause add up.
	var g := {"id": "b", "loyalty": 72}
	Loyalty.apply(g, "held_pads", 20)
	Loyalty.apply(g, "full_week", 21)
	Loyalty.apply(g, "full_week", 22)
	var gw := Loyalty.week(g, 18, 25)
	_check(str(gw.get("kind", "")) == "up" and not bool(gw.get("crossed", true)), "up, no band crossed: " + str(gw))
	_check(str(gw.get("text", "")).contains("a full week +2"), "full week summed to +2: " + str(gw.get("text", "")))
	# Nothing in the week: no row.
	_check(Loyalty.week(g, 30, 37).is_empty(), "a quiet week gives nothing")
	_check(WeekReadRows.loyalty("b", g, 30, 37) == null, "no row on a quiet week")
	var row: Control = WeekReadRows.loyalty("a", f, 8, 15)
	_check(row != null and row.name == "Loyalty_a", "the row lands, named Loyalty_a")
	if row != null:
		var t: Label = row.find_child("Loyalty_a_text", true, false)
		_check(t != null and t.text == text, "the row's text is the week's text")
		_check(is_equal_approx(float(row.get_meta("to", -1.0)), 0.48), "the bar ends at 48")
		row.free()
	print("loyalty_week_test %s" % ("PASS" if fails == 0 else "FAIL (%d)" % fails))
	quit(0 if fails == 0 else 1)
