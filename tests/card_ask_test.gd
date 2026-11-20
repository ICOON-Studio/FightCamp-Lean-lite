extends SceneTree
## S531 "SHE ASKED ABOUT YOUR GYM": the beaten opponent may ask to train here - more likely when the plan worked and the
## gym has a name; never after a loss, a pro bout, with reception taken or the roster full; she arrives as a walk-in.

const CardAsk := preload("res://scripts/rules/CardAsk.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	var low := CardAsk.chance(0, 4, 10, 2, 3)
	var high := CardAsk.chance(4, 5, 80, 2, 3)
	_check(high > low and high <= CardAsk.CAP, "a plan that worked and a known gym pull harder (%.2f > %.2f)" % [high, low])
	_check(CardAsk.chance(4, 5, 80, 9, 3) < high, "a boxer with the better record is less likely to leave her club")
	_check(CardAsk.chance(20, 20, 500, 0, 9) <= CardAsk.CAP, "never above the cap")
	_check(CardAsk.asks(true, false, true, 2, 0.4, 0.1), "an amateur win, reception free, room on the roster: she can ask")
	_check(not CardAsk.asks(false, false, true, 2, 0.9, 0.0), "never after a loss")
	_check(not CardAsk.asks(true, true, true, 2, 0.9, 0.0), "never after a pro bout")
	_check(not CardAsk.asks(true, false, false, 2, 0.9, 0.0), "never while someone waits at reception")
	_check(not CardAsk.asks(true, false, true, CardAsk.ROSTER_MAX, 0.9, 0.0), "never with the roster full")
	var opp := {"name": "Tara Quinn", "first": "Tara", "age": 20, "stance": "southpaw", "style": "Pressure fighter", "w": 4, "l": 3, "rating": 54.0, "club": "Eastside ABC"}
	var mine := {"sex": "f", "wc": "Lightweight", "limit": 60.0, "div": "wlw"}
	var d := CardAsk.walkin(opp, mine, 120)
	_check(d["name"] == "Tara Quinn" and d["w"] == 4 and d["l"] == 3 and d["style"] == "Pressure fighter" and d["club_before"] == "Eastside ABC",
		"she arrives with her real record, style and old club")
	_check(d["sex"] == "f" and d["div"] == "wlw" and float(d["limit"]) == 60.0, "same sex and division as the boxer she fought")
	var ok_stats := true
	for s in ["power", "speed", "technique", "defense", "conditioning", "fight_iq", "chin"]:
		ok_stats = ok_stats and absf(float(d["stats"][s]) - 54.0) <= 5.0
	_check(ok_stats and int(d["pot"]) > 54, "her ability sits round her rating, her potential above it (pot %d)" % int(d["pot"]))
	_check(CardAsk.walkin(opp, mine, 120)["stats"] == d["stats"], "the same boxer reads the same every time")
	_check(CardAsk.reason(4, 5, false).contains("had my number") and CardAsk.reason(0, 0, true).contains("stopped me"),
		"what she says follows the night")
	_check(int(d["expires"]) == 120 + CardAsk.WAIT_DAYS and not CardAsk.gone(d, 127) and CardAsk.gone(d, 128) and not CardAsk.gone({"name": "x"}, 999),
		"she waits a week at reception, then goes back to her club (a story walk-in never leaves)")
	print("CARD_ASK failures=%d" % failures)
	quit(0 if failures == 0 else 1)
