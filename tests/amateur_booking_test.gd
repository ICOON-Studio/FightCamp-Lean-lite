extends SceneTree
## AmateurBooking: the lead time and the novice rule. Written fresh for the lean module: the old
## amateur_booking_lead_time_test.gd plays GameState, which did not come over; the rules it pinned are the same.

const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_lead_weeks()
	_test_fight_day()
	_test_novice_rule()
	print("AMATEUR_BOOKING checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


func _test_lead_weeks() -> void:
	var seen := {}
	for i in 60:
		var w := AmateurBooking.lead_weeks("o%d" % i)
		_check(w >= AmateurBooking.LEAD_WEEKS_MIN and w <= AmateurBooking.LEAD_WEEKS_MAX, "offer o%d is %d weeks out (2-4)" % [i, w])
		seen[w] = true
	_check(seen.size() == 3, "over 60 offers every lead of 2, 3 and 4 weeks appears (%d kinds)" % seen.size())
	_check(AmateurBooking.lead_weeks("o8") == AmateurBooking.lead_weeks("o8"), "the same offer always gets the same lead")


func _test_fight_day() -> void:
	# Day 0 is Monday 5 Jan 2026; the Saturday of that week is day 5.
	_check(AmateurBooking.fight_day(0, 0) == 5, "the Saturday of week 1 is day 5")
	_check(AmateurBooking.fight_day(8, 3) == 33, "an offer on Tue day 8, 3 weeks out: Saturday day 33")
	_check(posmod(AmateurBooking.fight_day(17, 2), 7) == 5, "fight night is always a Saturday")
	for d in 30:
		_check(AmateurBooking.fight_day(d, AmateurBooking.LEAD_WEEKS_MIN) - d >= 8,
			"from day %d the shortest lead still leaves more than a week for a camp" % d)


func _test_novice_rule() -> void:
	_check(AmateurBooking.bouts_of(3, 1) == 4, "3-1 is four bouts")
	_check(AmateurBooking.experience_match_ok(4, 6), "a 4-bout novice may meet a 6-bout novice")
	_check(AmateurBooking.experience_match_ok(4, 10), "a novice may meet a 10-bout novice (still novice)")
	_check(not AmateurBooking.experience_match_ok(4, 16), "a 4-bout novice may not meet a 16-bout open fighter")
	_check(not AmateurBooking.experience_match_ok(10, 11), "the 11th bout makes an open fighter")
	_check(AmateurBooking.experience_match_ok(16, 4), "an open fighter may meet anyone")
