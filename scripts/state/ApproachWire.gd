extends RefCounted
## S487 R58 APPROACHWIRE1 (map ops/research/R58_MAP_S439.md section 4 M4, M5, M7; sections 7 and 8): Approach.gd's rules
## made live in the club week.
##   monday(c)            every Monday: an approach left unanswered past its end day -> the boxer leaves (Leaving);
##                        a new approach for each boxer Approach.due says (loyalty under 35, worth taking, 12 weeks clear):
##                        f["approach"] = {day, group, line, ends, talk, holder}; news; a MOVE's grievance ticks
##   open_for(c) / is_open(f)   the boxers with an approach waiting (Needs: the red need, the APPROACHED flag)
##   columns(c, f)        Approach.answers on the boxer's own view (the card's five columns)
##   talk(c, fid)         TELL IT STRAIGHT once (Approach.talk on Loyalty.can_tell_straight): landed / failed
##   answer(c, fid, id)   MATCH / HALF / MOVE / PROMISE / LET GO acted on the club (see each branch)
##   show_night(c)        the club show's night: each show_top promise resolved (Promises.resolve); broken -> leaves
##   train_mult(c, f)     the training factor an answer set (HALF x0.925 to its end day), 1.0 otherwise (GymSpend.gain)
##   stipend_locked(c, f) the stipend held to the answer's end day (GymSpend.set_stipend refuses a change before it)
## A holder (HALF, MOVE) is the most loyal team-mate on the club stipend, and only for a "keep" offer (the map: MOVE and
## HALF answer a stipend ask; a bout or a debut has no holder). Names live only in the card's header (S448).
## Preloads rules + Leaving + Region only; GymSpend is load()ed at call time (GymSpend's day_events calls monday()).
## Ships ON (R58 is a core rule of the club week, not an opt-in).

const Approach := preload("res://scripts/rules/Approach.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Promises := preload("res://scripts/rules/Promises.gd")
const ClubShow := preload("res://scripts/rules/ClubShow.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Leaving := preload("res://scripts/state/Leaving.gd")
const Region := preload("res://scripts/state/Region.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const HomeBout := preload("res://scripts/state/HomeBout.gd")   # S488 HOMEBOUT1: the promised show's bout

const CLUB := Leaving.TO_CLUB
## The map's grievance (M4 MOVE): the team-mate whose stipend moved loses Approach.TICK every GRIEVANCE_DAYS to the end day.
const GRIEVANCE_DAYS := 28
## The forecast the card prints for a holder who is not Loyal (3 ticks of -3 in the 12 weeks); a Loyal one minds no day job.
const HOLDER_TICKS := 3
## PROMISE: the stipend ask ticks again after the night (28 days out, 84-day window): 2 ticks of 28 days.
const TICKS_AFTER_SHOW := 2


static func is_open(f: Dictionary) -> bool:
	return not (f.get("approach", {}) as Dictionary).is_empty()


static func open_for(c: Career) -> Array:
	return c.fighters.filter(func(f): return is_open(f))


## The view Approach.due reads.
static func due_view(c: Career, f: Dictionary) -> Dictionary:
	return {"loyalty": Loyalty.value(f), "potential": int(f.get("pot", 0)), "rank": Region.our_rank(c, f),
		"is_pro": bool(f.get("pro", false)), "last_approach_day": int(f.get("last_approach_day", -1)), "day": c.day}


## The most loyal team-mate on the club stipend (not the boxer, not a pro, no day job, paid): {} when none.
static func holder(c: Career, f: Dictionary) -> Dictionary:
	var best: Dictionary = {}
	for t in c.fighters:
		if str(t["id"]) == str(f["id"]) or bool(t.get("pro", false)) or bool(t.get("day_job", false)):
			continue
		if int(t.get("weekly_salary", 0)) <= 0:
			continue
		if best.is_empty() or Loyalty.value(t) > Loyalty.value(best):
			best = t
	return best


static func _can_book(c: Career) -> bool:
	return ClubShow.can_book(c.day, int(c.show.get("day", -1)), int(c.show.get("last", -1))) and c.cash >= show_cost(c)


## S546: what PROMISE: OUR SHOW pays today - the hall GymSpend.book_show takes (the read's hall), as the booking charges it.
static func show_cost(c: Career) -> int:
	return ClubShow.cost(str(load("res://scripts/state/GymSpend.gd").show_read(c)["hall"]))


## The view Approach.answers reads, from the open approach (its day, group and talk) and the club today.
static func answer_view(c: Career, f: Dictionary) -> Dictionary:
	var a: Dictionary = f.get("approach", {})
	var group := str(a.get("group", "keep"))
	var h: Dictionary = c.fighter_by_id(str(a.get("holder", ""))) if group == "keep" else {}
	var hv: Dictionary = {} if h.is_empty() else {"loyalty": Loyalty.value(h)}
	return {"loyalty": Loyalty.value(f), "talk": str(a.get("talk", "")), "group": group, "holder": hv,
		"can_book": _can_book(c) and HomeBout.reason(c, f) == "", "ticks_after_show": TICKS_AFTER_SHOW if group == "keep" else 0,
		"holder_ticks": 0 if h.is_empty() or Loyalty.value(h) >= Loyalty.LOYAL_AT else HOLDER_TICKS,
		"day": int(a.get("day", c.day)), "show_cost": show_cost(c)}


static func columns(c: Career, f: Dictionary) -> Array:
	return Approach.answers(answer_view(c, f))


## Monday: unanswered approaches end (the boxer leaves), new ones open, a MOVE's grievance ticks. Returns news lines.
static func monday(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters.duplicate():
		var fid := str(f["id"])
		_grievance(c, f)
		if is_open(f):
			if c.day >= int(f["approach"]["ends"]):
				f.erase("approach")
				var r := Leaving.leave(c, fid, "approach")
				out.append(str(r.get("line", "")))
			continue
		if f.has("leaves_after") or not Approach.due(due_view(c, f)):
			continue
		var o := Approach.offer(Loyalty.log_of(f), c.day)
		var group := str(o["group"])
		var h := holder(c, f) if group == "keep" and bool(f.get("day_job", false)) else {}
		if group == "keep" and not bool(f.get("day_job", false)):
			group = "bout"   # already on the stipend: Eastside offers a bout instead of the keep
			o["line"] = Approach.OFFER_LINES["bout"]
		f["approach"] = {"day": c.day, "group": group, "line": str(o["line"]), "ends": c.day + Approach.ANSWER_DAYS,
			"talk": "", "holder": str(h.get("id", ""))}
		f["last_approach_day"] = c.day
		var line := "%s wants %s: %s. Answer by %s." % [CLUB, f["first"], str(o["line"]).to_lower(), Clock.fmt(c.day + Approach.ANSWER_DAYS)]
		c.add_news(line)
		out.append(line)
	return out


static func _grievance(c: Career, f: Dictionary) -> void:
	var g: Dictionary = f.get("grievance", {})
	if g.is_empty():
		return
	if c.day >= int(g["until"]):
		f.erase("grievance")
		return
	if c.day > int(g["from"]) and (c.day - int(g["from"])) % GRIEVANCE_DAYS == 0:
		Loyalty.commit(f, Approach.TICK, "grievance", c.day)


## TELL IT STRAIGHT (once, optional, free): {ok, why, landed}. Seeded by the club seed, the day and the boxer.
static func talk(c: Career, fid: String) -> Dictionary:
	var f := c.fighter_by_id(fid)
	if f.is_empty() or not is_open(f):
		return {"ok": false, "why": "no approach", "landed": false}
	if str(f["approach"]["talk"]) != "":
		return {"ok": false, "why": "already talked", "landed": false}
	if not Loyalty.can_tell_straight(f, c.day):
		return {"ok": false, "why": "talked in the last 8 weeks", "landed": false}
	var rng := RandomNumberGenerator.new()
	rng.seed = c.seed * 977 + c.day * 31 + fid.hash()
	var r := Approach.talk(coachability(f), rng.randf())
	var landed := bool(r["landed"])
	Loyalty.commit(f, int(r["delta"]), "talk_straight_landed" if landed else "talk_straight_failed", c.day)
	f["approach"]["talk"] = "landed" if landed else "failed"
	return {"ok": true, "why": "", "landed": landed}


static func coachability(f: Dictionary) -> int:
	return roundi(float((f.get("personality", {}) as Dictionary).get("coachability", 50.0)))


## Acts an answer. Returns "" or why it cannot be taken.
static func answer(c: Career, fid: String, id: String) -> String:
	var f := c.fighter_by_id(fid)
	if f.is_empty() or not is_open(f):
		return "no approach"
	var col: Dictionary = {}
	for x in columns(c, f):
		if str(x["id"]) == id:
			col = x
	if col.is_empty():
		return "no such answer"
	if not bool(col["available"]):
		return str(col["why_not"])
	var a: Dictionary = f["approach"]
	var end := int(a["day"]) + Approach.WINDOW_DAYS
	var h := c.fighter_by_id(str(a.get("holder", "")))
	var first := str(f["first"])
	match id:
		"match":
			if str(a["group"]) == "keep":
				_on_stipend(f, GameMoney.FIGHTER_STIPEND)
				f["stipend_lock"] = end
			Loyalty.commit(f, int(Approach.GAIN["match"]), "approach_match", c.day)
			c.add_news("You match %s's offer: %s stays%s." % [CLUB, first, ", on the gym stipend to %s" % Clock.fmt(end) if str(a["group"]) == "keep" else ""])
		"half":
			var half := roundi(GameMoney.FIGHTER_STIPEND * 0.5)
			_on_stipend(f, half)
			h["weekly_salary"] = half
			for x in [f, h]:
				x["stipend_lock"] = end
				x["train_mult"] = {"x": float(Approach.TRAIN["half"]), "until": end}
			Loyalty.commit(f, int(col["loyalty_end"]) - Loyalty.value(f), "approach_half", c.day)
			Loyalty.commit(h, Approach.HOLDER_HALF, "approach_half_holder", c.day)
			c.add_news("The gym stipend is split in two to %s: half each, both train a little less." % Clock.fmt(end))
		"move":
			_on_stipend(f, GameMoney.FIGHTER_STIPEND)
			f["stipend_lock"] = end
			h["day_job"] = true
			h["weekly_salary"] = 0
			h["day_job_since"] = c.day
			h["stipend_lock"] = end
			Loyalty.commit(f, int(Approach.GAIN["move"]), "approach_move", c.day)
			Loyalty.commit(h, Approach.HOLDER_MOVE, "approach_move_holder", c.day)
			if Loyalty.value(h) < Loyalty.LOYAL_AT:
				h["grievance"] = {"from": c.day, "until": end}
			c.add_news("The gym stipend moves to %s; %s takes a day job and minds it." % [first, h["first"]])
		"promise":
			var why: String = HomeBout.reason(c, f)
			if why == "":
				why = load("res://scripts/state/GymSpend.gd").book_show(c)
			if why != "":
				return why
			var m := Promises.make(c.promises, fid, Promises.SHOW_TOP, int(c.show["day"]), c.day)
			if not bool(m["ok"]):
				return str(m["why"])
			c.promises = m["list"]
			HomeBout.book(c, f, int(c.show["day"]))   # S488 HOMEBOUT1: a legal novice on the night, no ticket cut
			Loyalty.commit(f, int(Approach.GAIN["promise"]), "approach_promise", c.day)
			f["ticks_wait_until"] = int(c.show["day"])
			c.add_news("You promise %s the top of the club show on %s." % [first, Clock.fmt(int(c.show["day"]))])
		"let_go":   # the map: leaves next Monday (Leaving.monday reads leaves_after)
			f["leaves_after"] = c.day
			f["leaves_why"] = "approach"
			c.add_news("You let %s go to %s: the boxer leaves on Monday." % [first, CLUB])
	f["approach_answer"] = {"id": id, "day": c.day}
	f.erase("approach")
	return ""


static func _on_stipend(f: Dictionary, weekly: int) -> void:
	f["day_job"] = false
	f["weekly_salary"] = weekly
	f.erase("day_job_since")


## The club show's night: an open show_top promise whose boxer has tonight's home bout waits for the fight (HomeBout.boxed
## keeps it when BoutFinish ends it); one with no bout tonight (missed weight, pulled out) is broken (leaves next Monday).
static func show_night(c: Career) -> Array:
	var out: Array = []
	var list: Array = c.promises.duplicate(true)
	for p in list:
		if str(p["kind"]) != Promises.SHOW_TOP or str(p["state"]) != "open":
			continue
		var f := c.fighter_by_id(str(p["fid"]))
		if f.is_empty():
			p["state"] = "broken"
			continue
		if HomeBout.is_home(f) and int(f["bout"]["day"]) == c.day:
			continue   # S488 HOMEBOUT1: kept by boxing it tonight (BoutFinish -> HomeBout.boxed)
		var inj: Dictionary = f.get("injury", {})
		var fit := inj.is_empty() or c.day >= int(inj.get("until_day", 0))
		var r := Promises.resolve(p, {"day": c.day, "fit": fit, "made_weight": true, "boxed": false})
		if str(r["state"]) == "open":
			continue
		p["state"] = r["state"]
		Loyalty.commit(f, int(r["loyalty"]), "promise_" + str(r["state"]), c.day)
		f.erase("ticks_wait_until")
		if bool(r["leaves"]):
			f["leaves_after"] = c.day
			f["leaves_why"] = "promise"
		var line := "%s: %s." % [f["first"], str(r["line"])]
		c.add_news(line)
		out.append(line)
	c.promises = list
	return out


static func train_mult(c: Career, f: Dictionary) -> float:
	var t: Dictionary = f.get("train_mult", {})
	return float(t["x"]) if not t.is_empty() and c.day < int(t["until"]) else 1.0


static func stipend_locked(c: Career, f: Dictionary) -> bool:
	return int(f.get("stipend_lock", -1)) > c.day
