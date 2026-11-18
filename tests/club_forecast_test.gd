extends SceneTree
## S519 club week v11 3.7: the 4-week forecast and the clash line before Accept. Test club (Lucy, Kira, Josh - three
## different boxers), sessional coach (2 film nights): bouts booked in week 2 for two boxers fit; a third in that week
## runs film short (amber, one watches alone) and its offer says so; a full-time coach (3) clears it; class nights show.
## Prints CLUB_FORECAST failures=N.

const ClubForecast := preload("res://scripts/state/ClubForecast.gd")
const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")

var _fails := 0


func _initialize() -> void:
	var c := Career.quick_start()
	c.seed = 7
	TestClub.make(c)
	var mon := c.day - posmod(c.day, 7)
	var w := ClubForecast.weeks(c, 4)
	_check(w.size() == 4 and int(w[0]["monday"]) == mon and int(w[3]["monday"]) == mon + 21, "four weeks from this Monday")
	_check(str(w[1]["words"]) == "quiet" and not bool(w[1]["risk"]), "no bouts: quiet weeks (%s)" % w[1]["words"])
	var sat := mon + 7 + 5
	c.fighters[0]["bout"] = {"day": sat, "done": false}
	_check(ClubForecast.clash(c, c.fighters[1], sat) == "", "a second bout that week: 2 of 2 film nights, no clash")
	c.fighters[1]["bout"] = {"day": sat, "done": false}
	w = ClubForecast.weeks(c, 4)
	_check(int(w[1]["fights"]) == 2 and not bool(w[1]["risk"]) and str(w[1]["words"]).contains("film 2/2"), "week 2: %s" % w[1]["words"])
	var cl := ClubForecast.clash(c, c.fighters[2], sat)
	_check(cl.contains("film 3 of 2") and cl.contains("alone"), "a third bout that week: the offer says so (%s)" % cl)
	_check(ClubForecast.clash(c, c.fighters[2], sat + 7) == "", "the week after: no clash")
	c.fighters[2]["bout"] = {"day": sat - 1, "done": false}
	w = ClubForecast.weeks(c, 4)
	_check(bool(w[1]["risk"]) and int(w[1]["alone"]) == 1, "three fight weeks: amber, one alone")
	c.coach["full_time"] = true
	w = ClubForecast.weeks(c, 4)
	_check(not bool(w[1]["risk"]) and str(w[1]["words"]).contains("film 3/3"), "a full-time coach: 3 film nights (%s)" % w[1]["words"])
	ClubClasses.toggle(c.coach, 2)
	_check(int(ClubForecast.weeks(c, 4)[0]["classes"]) == 1, "class nights counted")
	c.fighters[0]["bout"]["done"] = true
	_check(int(ClubForecast.weeks(c, 4)[1]["fights"]) == 2, "a fought bout leaves the forecast")
	print("CLUB_FORECAST failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
