extends SceneTree
## S517 (LADDERPROBE1: a novice frozen with no legal name once her whole sheet graduated): when every name on a novice's
## sheet is past 10 bouts, a newcomer novice joins the sheet, the matchmaker offers her (a legal, non-mismatch offer),
## she joins the region's table, nothing arrives while a legal name remains, and an open boxer (11+ bouts) brings none.
## Population: a quick-start club with Lucy (3-1) against the region's own named rivals (different records, ratings).
## Prints NEWCOMERS failures=N.

const Data := preload("res://scripts/state/Data.gd")
const Newcomers := preload("res://scripts/state/Newcomers.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Region := preload("res://scripts/state/Region.gd")

var _fails := 0


func _initialize() -> void:
	var c := Career.quick_start()
	c.seed = 23
	c.applicant = {}
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	var before := c.rivals.size()
	_check(Newcomers.arrive(c, f).is_empty() and c.rivals.size() == before, "legal names on the sheet: nobody new arrives")
	# Graduate every name on her sheet past the novice line.
	for n in Data.DIVISIONS["wlw"]["opponents"]:
		var r := c.rival(str(n))
		r["w"] = int(r["w"]) + 9
	var nc := Newcomers.arrive(c, f)
	_check(not nc.is_empty() and bool(nc["newcomer"]) and str(nc["div"]) == "wlw", "a whole sheet past 10 bouts: a newcomer arrives")
	_check(int(nc.get("w", 0)) + int(nc.get("l", 0)) <= 2, "the newcomer has 0-2 bouts: got %d-%d" % [int(nc.get("w", 0)), int(nc.get("l", 0))])
	_check(not (nc.get("bouts", []) as Array).is_empty() or int(nc.get("w", 0)) + int(nc.get("l", 0)) == 0, "her past matches her record")
	_check(Newcomers.sheet(c, "wlw").has(str(nc.get("name", ""))), "she is on the wlw sheet")
	_check(not Newcomers.sheet(c, "wfw").has(str(nc.get("name", ""))), "she is on no other sheet")
	_check(Newcomers.arrive(c, f).is_empty(), "with her on the sheet nobody else arrives")
	# The matchmaker offers her: a legal, non-mismatch first offer.
	f["bout"] = {}
	f["offers"] = []
	f["next_offer_day"] = c.day
	Bouts.day_events(c)
	var offers: Array = f.get("offers", [])
	_check(not offers.is_empty() and not bool(offers[0]["mismatch"]), "the first offer is a legal match: %s" % str(offers.map(func(o): return [o["opp"]["name"], o["mismatch"]])))
	_check(not offers.is_empty() and str(offers[0]["opp"]["name"]) == str(nc.get("name", "")), "and it is the newcomer")
	_check(Bouts.accept(c, str(offers[0]["id"])) if not offers.is_empty() else false, "the offer can be accepted")
	# Same seed, same newcomer (a replay agrees).
	var c2 := Career.quick_start()
	c2.seed = 23
	c2.applicant = {}
	c2.fighters.append(Data.fighter_state(Data.lucy(), c2.day))
	for n in Data.DIVISIONS["wlw"]["opponents"]:
		c2.rival(str(n))["w"] = int(c2.rival(str(n))["w"]) + 9
	_check(str(Newcomers.arrive(c2, c2.fighters[0]).get("name", "")) == str(nc.get("name", "")), "a replay brings the same newcomer")
	# An open boxer (11+ bouts) brings nobody.
	var c3 := Career.quick_start()
	c3.applicant = {}
	c3.fighters.append(Data.fighter_state(Data.lucy(), c3.day))
	c3.fighters[0]["w"] = 12
	for n in Data.DIVISIONS["wlw"]["opponents"]:
		c3.rival(str(n))["w"] = int(c3.rival(str(n))["w"]) + 9
	_check(Newcomers.arrive(c3, c3.fighters[0]).is_empty(), "an open boxer may meet anyone: no newcomer")
	# The cap: a fourth graduated newcomer pushes the oldest off the sheet.
	for k in 3:
		for r in c.rivals:
			if bool(r.get("newcomer", false)):
				r["w"] = 11
		Newcomers.arrive(c, f)
	var on_sheet := 0
	for r in c.rivals:
		if bool(r.get("newcomer", false)) and not bool(r.get("off_sheet", false)):
			on_sheet += 1
	_check(on_sheet <= Newcomers.MAX_A_DIV, "at most %d newcomers on a sheet: got %d" % [Newcomers.MAX_A_DIV, on_sheet])
	# R8 (S517): a booked or injured week is not a free week - the idle clock waits.
	var c4 := Career.quick_start()
	c4.applicant = {}
	c4.fighters.append(Data.fighter_state(Data.lucy(), c4.day))
	var g: Dictionary = c4.fighters[0]
	g["clock_from"] = 0
	g["rep"] = 30
	g["injury"] = {"type": "ribs", "until_day": 400}
	c4.day = 7 * 12
	Region.day_events(c4)
	_check(int(g["rep"]) == 30 and int(g["clock_from"]) == 7, "injured: no drain, the clock waits a week (clock_from %d)" % int(g["clock_from"]))
	g["injury"] = {}
	g["clock_from"] = 0
	Region.day_events(c4)
	_check(int(g["rep"]) < 30, "a free week with a legal name in reach: the clock drains (%d)" % int(g["rep"]))
	print("NEWCOMERS failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok   %s" % what)
	else:
		_fails += 1
		print("  FAIL %s" % what)
