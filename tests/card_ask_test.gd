extends SceneTree
## S531 "SHE ASKED ABOUT YOUR GYM", S533 P4PBUILD1 the visit's pure rules (CardAsk): evidence gates the ask, the chance is
## bounded and a share (never a count), the visitor is the region's boxer with the real record. The wiring, the screens
## and real bouts: tests/p4p_visit_test.gd.

const CardAsk := preload("res://scripts/rules/CardAsk.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	var low := CardAsk.chance(10, true, 0, 4)
	var high := CardAsk.chance(80, true, 4, 5)
	_check(high > low and high <= CardAsk.CAP, "a plan that worked and a known gym pull harder (%.2f > %.2f)" % [high, low])
	_check(CardAsk.chance(500, true, 20, 20) <= CardAsk.CAP, "never above the cap")
	_check(CardAsk.chance(80, false, 4, 5) < high, "evidence adds its part once")
	_check(CardAsk.asks(true, false, true, true, true, true, true, 0.2, 0.1), "an amateur win with evidence, reception and a place free: the opponent can ask")
	_check(not CardAsk.asks(true, false, true, true, true, true, false, 0.9, 0.0), "never without evidence")
	_check(not CardAsk.asks(false, false, true, true, true, true, true, 0.9, 0.0), "never after a loss")
	_check(CardAsk.blocked(true, false, true, true).contains("place") and CardAsk.blocked(true, true, true, true) == "", "a blocked ask names its gate; the roll names none")
	var opp := {"name": "Tara Quinn", "first": "Tara", "age": 20, "stance": "southpaw", "style": "Pressure fighter", "w": 4, "l": 3, "rating": 54.0, "club": "Eastside ABC"}
	var mine := {"sex": "f", "wc": "Lightweight", "limit": 60.0, "div": "wlw"}
	var d := CardAsk.walkin(opp, mine, 120)
	_check(d["name"] == "Tara Quinn" and d["w"] == 4 and d["l"] == 3 and d["style"] == "Pressure fighter" and d["club_before"] == "Eastside ABC" and d["rival"] == "Tara Quinn",
		"the visitor arrives with the real record, style, old club and the link to the region's boxer")
	_check(d["sex"] == "f" and d["div"] == "wlw" and float(d["limit"]) == 60.0, "same sex and division as the bout")
	var ok_stats := true
	for s in ["power", "speed", "technique", "defense", "conditioning", "fight_iq", "chin"]:
		ok_stats = ok_stats and absf(float(d["stats"][s]) - 54.0) <= 5.0
	_check(ok_stats and int(d["pot"]) > 54, "ability sits round the rating, potential above it (pot %d)" % int(d["pot"]))
	_check(CardAsk.walkin(opp, mine, 120)["stats"] == d["stats"], "the same boxer reads the same every time")
	_check(int(d["expires"]) == 120 + CardAsk.WAIT_DAYS and not CardAsk.gone(d, 127) and CardAsk.gone(d, 128) and not CardAsk.gone({"name": "x"}, 999),
		"a week at reception through the last day, gone the day after (a story walk-in never leaves)")
	_check(CardAsk.cooled({}, 5) and not CardAsk.cooled({"visit_cool": 200}, 199) and CardAsk.cooled({"visit_cool": 200}, 200), "the 120-day wait ends on its day")
	_check(CardAsk.trial_day_for(d, 120) == 126 and CardAsk.trial_day_for(d.merged({"trial_day": 126}, true), 121) == -1
		and CardAsk.trial_day_for(d.merged({"expires": 125}, true), 120) == -1, "one trial, on the Monday inside the visit")
	print("CARD_ASK failures=%d" % failures)
	quit(0 if failures == 0 else 1)
