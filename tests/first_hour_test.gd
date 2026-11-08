extends SceneTree
## S397 rank 5: the first hour's calendar and cast (FirstHour, FirstWeek; ops/research/RANK5_FIRST_HOUR_S397.md section 8).
##   1. the show's offer comes on Monday of week 2 (day 7) for Sat 24 Jan (day 19), never re-dated; its opponent is a legal one
##      drawn by the career's seed (two seeds, two opponents)
##   2. the weight is a decision: on the weeks as planned the walk-in lands over or on the line; starting the cut in week 1
##      makes it; the old hand's edge makes it with room
##   3. the weeks are quiet until the first bout: no twist card, no ask
##   4. after the bout: the rival's line, the second walk-in on the next Monday, Ana as a teaser, then Ana after the second bout
##   5. the three club tasks tick from what is true (second boxer, both booked, the first boxer's next goal); the backed start's verdict; the guide's stages follow the career
##   6. an old save (first_hour {}) keeps the old week 1: Ana joins, the guide ends

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")

var failures := 0


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)


func _new(seed_value: int, start: String = "fresh", bg: String = "expro", cut_now: bool = false) -> Career:
	var c := Career.quick_start("Test Gym", "London", start, HeadCoach.make("Sam", bg))
	c.seed = seed_value
	FirstWeek.begin(c)
	c.guide = "sign"
	Sim.sign(c, ["habit"])
	Sim.hire(c, "reid")
	FirstWeek.sync(c)
	FirstWeek.set_week(c)
	if cut_now:
		c.fighter()["diet"] = "cut"
	return c


func _to_day(c: Career, d: int) -> void:
	while c.day < d:
		Sim.step_day(c)


func _initialize() -> void:
	# 1. The show's offer.
	var c := _new(1)
	_check(int(c.fighter()["next_offer_day"]) == FirstHour.OFFER_DAY, "signing sets the first offer for Monday of week 2")
	_to_day(c, 6)
	_check((c.fighter()["offers"] as Array).is_empty(), "no offer in week 1")
	_to_day(c, 7)
	var offers: Array = c.fighter()["offers"]
	_check(offers.size() == 2, "day 7: the show's offer arrives with its unsafe pair (%d)" % offers.size())
	var show: Dictionary = offers[0] if not offers.is_empty() else {}
	_check(int(show.get("day", -1)) == FirstHour.SHOW_DAY and Clock.fmt(FirstHour.SHOW_DAY) == "Sat 31 Jan", "the show is Sat 31 Jan (day %d)" % int(show.get("day", -1)))
	_check(not bool(show.get("mismatch", true)), "the show's opponent is a legal match")
	_check(c.guide == "offer", "after week 1 the guide moves to the show (%s)" % c.guide)
	var other := _new(2)
	_to_day(other, 7)
	var o2: Dictionary = (other.fighter()["offers"] as Array)[0]
	_check(str(o2["opp"]["name"]) != str(show.get("opp", {}).get("name", "")), "another seed draws another opponent (%s vs %s)" % [o2["opp"]["name"], show.get("opp", {}).get("name", "")])
	_check((Data.DIVISIONS["wlw"]["opponents"] as Array).has(str(o2["opp"]["name"])), "drawn from the division's opponents")
	_check(Bouts.accept(c, str(show["id"])), "the show can be accepted")
	FirstWeek.sync(c)
	_check(c.guide == "prep", "the guide is on camp and plan (%s)" % c.guide)
	_check(int(c.fighter()["bout"]["day"]) == FirstHour.SHOW_DAY, "the show is never re-dated by makeable_day")

	# 2. The weight is a decision.
	var plain := Sim.weigh_forecast(c, c.fighter(), FirstHour.SHOW_DAY)
	var early := _new(1, "fresh", "expro", true)
	_to_day(early, 7)
	Bouts.accept(early, str((early.fighter()["offers"] as Array)[0]["id"]))
	var cut := Sim.weigh_forecast(early, early.fighter(), FirstHour.SHOW_DAY)
	var hand := _new(1, "fresh", "oldhand")
	_to_day(hand, 7)
	Bouts.accept(hand, str((hand.fighter()["offers"] as Array)[0]["id"]))
	var old := Sim.weigh_forecast(hand, hand.fighter(), FirstHour.SHOW_DAY)
	print("  forecast on the show's morning: as planned %.2f, cut from week 1 %.2f, old hand %.2f (limit 60.0)" % [plain["day"], cut["day"], old["day"]])
	_check(not bool(plain["ok"]), "as planned, the walk-in misses (%.2f): a real risk" % plain["day"])
	_check(bool(cut["ok"]) and float(cut["day"]) < float(plain["day"]) - 0.2, "starting the cut in week 1 makes weight (%.2f)" % cut["day"])
	_check(bool(old["ok"]) and float(old["day"]) < float(plain["day"]), "the old hand makes it on the coach's weeks (%.2f)" % old["day"])

	# 3. Quiet weeks.
	_to_day(c, 25)
	_check(str(c.fighter().get("twist", "")) == "", "no twist card or ask before the first bout (%s)" % c.fighter().get("twist", ""))
	_check(c.grapplers.is_empty(), "Ana is not in the first weeks")

	# 4. After the bout (the result booked as the fight night would: the rules' own after_fight).
	var f := c.fighter()
	c.results.push_front({"fid": f["id"], "win": true})
	c.day = FirstHour.SHOW_DAY
	Bouts.after_fight(c, f)
	_check(bool(c.first_hour["fought"]) and not FirstHour.quiet(c), "the first bout ends the quiet weeks")
	_check(c.news.any(func(n): return str(n["t"]).begins_with(FirstHour.RIVAL["coach"])), "a rival coach is named in the news")
	FirstWeek.sync(c)
	_check(c.guide == "club", "the guide moves to the club tasks (%s)" % c.guide)
	_to_day(c, 28)
	_check(str(c.applicant.get("id", "")) == FirstHour.SECOND_WALKIN and str(c.applicant.get("quote", "")) != "", "Monday after the show: the second walk-in, with an own line")
	_check(c.grapplers.is_empty(), "no Ana yet")
	var t := FirstHour.tasks(c)
	_check(not bool(t["second"]) and not bool(t["book"]), "tasks: nobody second yet")
	Sim.sign(c, ["habit"])
	_check(c.fighters.size() == 2 and str(Roster_prospect(c, "danny").get("state", "")) == "signed", "signing the walk-in signs the prospect too")
	_to_day(c, 35)
	_check(c.news.any(func(n): return str(n["t"]).contains("no-gi grappler has been asking")), "Ana's teaser the next Monday")
	c.fighter()["goal_talk"] = false
	_check(bool(FirstHour.tasks(c)["goal"]), "the office talk done ticks the goal task")
	c.first_hour["bouts"] = 2
	_to_day(c, 42)
	_check(c.grapplers.size() == 1, "after the club's second bout Ana joins")

	# 5. The backed start.
	var bk := _new(3, "backed")
	_to_day(bk, 7)
	Bouts.accept(bk, str((bk.fighter()["offers"] as Array)[0]["id"]))
	var cash := bk.cash
	var bf := bk.fighter()
	bk.results.push_front({"fid": bf["id"], "win": false})
	Bouts.after_fight(bk, bf)
	_check(bk.cash == cash - ClubStart.BACKERS_CLAWBACK and str(bk.first_hour["backers"]) == "pulled", "backed: a lost first show costs $5,000")
	var bk2 := _new(4, "backed")
	_to_day(bk2, 7)
	Bouts.accept(bk2, str((bk2.fighter()["offers"] as Array)[0]["id"]))
	bk2.results.push_front({"fid": bk2.fighter()["id"], "win": true})
	var cash2 := bk2.cash
	Bouts.after_fight(bk2, bk2.fighter())
	_check(bk2.cash == cash2 and str(bk2.first_hour["backers"]) == "kept", "backed: a won first show keeps the money")

	# 6. An old save.
	var o := Career.quick_start()
	o.seed = 5
	o.guide = "sign"
	Sim.sign(o, ["habit"])
	Sim.hire(o, "reid")
	o.guide = "go"
	_check(o.first_hour.is_empty() and int(o.fighter()["next_offer_day"]) == 8, "a career without the first hour keeps the old offer day")
	_to_day(o, 7)
	_check(o.grapplers.size() == 1 and o.guide == "offer", "and the old week 1: Ana joins, the guide moves to the offer (GUIDEFLAG2)")
	print("FIRST_HOUR failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func Roster_prospect(c: Career, id: String) -> Dictionary:
	for p in c.prospects:
		if str(p["id"]) == id:
			return p
	return {}
