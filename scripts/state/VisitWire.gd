extends RefCounted
## S533 P4PBUILD1 stage 1, THE VISIT on the career (rules: CardAsk; DESIGN_THREEP4P_V2 section 3). BoutFinish hands the
## settled bout here; reception (Interview) and RosterActs take the three answers; Sim.step_day runs the clock on it.
##   after_bout(c, f, m, opp, win, pro, rounds)   the evidence onto the bout, then the gates and the seeded roll
##   sign(c, picks) -> {ok, why, f}   capacity and the last day re-read NOW; the region's boxer moves onto the roster
##                                    once, with today's record; an offer against that boxer is withdrawn
##   pass_visit(c)   trial(c) -> bool   day(c)   each pass or expiry starts CardAsk.COOLDOWN_DAYS on that boxer
##   terms(c) -> what reception shows: places, stipend, last day, the trial Monday
## The identity is the rival row (the region knows its boxers by name). A beaten opponent the region has no row for is
## never made a visitor: nothing is invented. An old save's visitor without the link is matched by name, or signs as
## before when the region never knew the boxer.

const CardAsk := preload("res://scripts/rules/CardAsk.gd")
const PlanRecord := preload("res://scripts/rules/PlanRecord.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const StandDown := preload("res://scripts/rules/StandDown.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")

const TRANSIENT := ["quote", "expires", "met_day", "from_card", "trial_day", "rival", "evidence"]


## The call's or the plan line's own name, as the screens say it.
static func what_words(ev: Dictionary) -> String:
	var id := str(ev.get("what", ""))
	if str(ev.get("kind", "")) == "call":
		return str((Exchanges.CALLS.get(id, {}) as Dictionary).get("label", id))
	return str(StrikeMap.move(PlanFight.base_id(id)).get("name", id.replace("_", " "))).to_lower()


static func rival_of(c: Career, a: Dictionary) -> Dictionary:
	return c.rival(str(a.get("rival", a.get("name", ""))))


static func after_bout(c: Career, f: Dictionary, m: Dictionary, opp: Dictionary, win: bool, pro: bool, rounds: Array) -> void:
	var ev := CardAsk.evidence(rounds)
	m["evidence"] = ev
	if not c.results.is_empty():
		c.results[0]["evidence"] = ev
	if pro or not win:
		return
	var r: Dictionary = c.rival(str(opp.get("name", "")))
	var pr := PlanRecord.summary(rounds)
	var p := CardAsk.chance(c.reputation, bool(ev["qualifies"]), int(pr.get("worked", 0)), int(pr.get("used", 0)))
	var rng := RandomNumberGenerator.new()
	rng.seed = hash([c.seed, c.day, str(opp.get("name", "")), "card_ask"])
	# Reception is free only when nobody waits there and the story's own arrivals are done: the first hour's second
	# walk-in has come, and no scouted prospect is invited or on trial (the ask must never take their place).
	var story_due := not c.first_hour.is_empty() and not bool(c.first_hour.get("walkin", false))
	for row in c.prospects:
		story_due = story_due or str(row.get("state", "")) in ["invited", "trial"]
	var free := c.applicant.is_empty() and not story_due
	var place := GymSpend.place_blocked(c) == ""
	var is_cooled := CardAsk.cooled(r, c.day)
	if not CardAsk.asks(win, pro, free, place, not r.is_empty(), is_cooled, bool(ev["qualifies"]), p, rng.randf()):
		if bool(ev["qualifies"]):   # the work was seen even when nobody came: luck and coaching told apart
			var why := CardAsk.blocked(free, place, not r.is_empty(), is_cooled)
			m["visit_note"] = "The other corner saw it: %s. No visitor this time%s." % [CardAsk.noticed(ev, what_words(ev)),
				"" if why == "" else " (%s)" % why]
		return
	var d: Dictionary = CardAsk.walkin(r, f, c.day)
	d["quote"] = CardAsk.reason(ev, what_words(ev))
	d["evidence"] = ev
	var sd := StandDown.make(c.day, float((m.get("damage", {}) as Dictionary).get("b", 0.0)), false)
	if not sd.is_empty():
		d["stand_down"] = sd   # the rest the bout left comes along
	c.applicant = d
	m["card_ask"] = "After the bout, the opponent asked to train here: at reception until %s." % Clock.fmt(int(d["expires"]))
	c.add_news("After the bout, %s asked about training at your gym: at reception until %s (Fighters)." % [str(d["name"]), Clock.fmt(int(d["expires"]))])


## What reception shows before the answer: the place it takes, the weekly cost, the last day, the trial on offer.
static func terms(c: Career) -> Dictionary:
	var a := c.applicant
	return {"used": GymSpend.used(c), "places": GymSpend.places(c), "blocked": GymSpend.place_blocked(c),
		"stipend": int(a.get("weekly_salary", GameMoney.FIGHTER_STIPEND)), "expires": int(a.get("expires", c.day)),
		"trial_day": CardAsk.trial_day_for(a, c.day), "trial_booked": int(a.get("trial_day", -1)),
		"trial_seen": CardAsk.trial_seen(a, c.day)}


static func sign(c: Career, picks: Array) -> Dictionary:
	var a := c.applicant
	if a.is_empty() or not bool(a.get("from_card", false)):
		return {"ok": false, "why": "nobody from a bout is at reception"}
	if CardAsk.gone(a, c.day):
		return {"ok": false, "why": "the visit is over"}
	var why := GymSpend.place_blocked(c)
	if why != "":
		return {"ok": false, "why": why}
	var r := rival_of(c, a)
	var raw: Dictionary = a.duplicate(true)
	for k in TRANSIENT:
		raw.erase(k)
	if not r.is_empty():   # today's record and ladder points, not the night's: the world moved while the visitor waited
		raw["w"] = int(r.get("w", 0))
		raw["l"] = int(r.get("l", 0))
		raw["past_bouts"] = (r.get("bouts", []) as Array).duplicate(true)
		if r.has("rep"):
			raw["rep"] = int(r["rep"])
	var f := Roster.sign_fighter(c, raw, picks)
	f["next_offer_day"] = FirstHour.first_offer_day(c, int(f["next_offer_day"]))
	if not r.is_empty():
		var name := str(r["name"])
		c.rivals.erase(r)
		for t in c.fighters:   # an offer to box the boxer who now trains here is withdrawn
			if t.has("offers"):
				t["offers"] = (t["offers"] as Array).filter(func(o): return str(((o as Dictionary).get("opp", {}) as Dictionary).get("name", "")) != name)
			if str((t.get("rival_offer", {}) as Dictionary).get("name", "")) == name:
				t["rival_offer"] = {}
	c.applicant = {}
	return {"ok": true, "why": "", "f": f}


static func pass_visit(c: Career, expired: bool = false) -> void:
	var a := c.applicant
	if a.is_empty():
		return
	var r := rival_of(c, a)
	if not r.is_empty():
		r["visit_cool"] = c.day + CardAsk.COOLDOWN_DAYS
	c.add_news("%s %s." % [str(a.get("name", "The boxer")), "went back to the old club" if expired else "thanks you and goes back to the old club"])
	c.applicant = {}


## Trial first: the one Monday, no place held, then CardAsk.TRIAL_DECIDE_DAYS to answer.
static func trial(c: Career) -> bool:
	var a := c.applicant
	var monday := CardAsk.trial_day_for(a, c.day)
	if a.is_empty() or not bool(a.get("from_card", false)) or monday < 0:
		return false
	a["trial_day"] = monday
	a["expires"] = monday + CardAsk.TRIAL_DECIDE_DAYS
	c.add_news("%s trials on %s; the answer is due by %s." % [str(a.get("name", "The boxer")), Clock.fmt(monday), Clock.fmt(int(a["expires"]))])
	return true


## Each day (Sim.step_day): the visit ends the day after its last day; on the last day the feed says so.
static func day(c: Career) -> void:
	var a := c.applicant
	if a.is_empty() or not bool(a.get("from_card", false)):
		return
	if CardAsk.gone(a, c.day):
		pass_visit(c, true)
	elif c.day == int(a.get("expires", -1)):
		c.add_news("Last day: the boxer at reception goes back to the old club after today.")
