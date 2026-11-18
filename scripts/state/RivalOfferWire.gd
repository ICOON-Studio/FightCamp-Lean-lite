extends RefCounted
## S517b LADDERWIRE stage 3 R9 (map ops/research/DESIGN_LADDER1_V6_DOLA.md R9; rules scripts/rules/RivalOffer.gd, Goose #372):
## offers from rival gyms. Every Monday, for each amateur of ours with the Ask door open, a rival BELOW her on the ladder
## points who has her in reach may ring for a bout at the next region show 7-21 days out (RivalOffer.who_offers: the highest
## such rival whose own 8-week cooldown has run; never a random pick). At most one rival offer every OFFER_GAP_WEEKS a boxer,
## and only for a boxer on the ranking table (Region.RANK_MIN_WINS wins): a challenge needs a place to challenge.
##   monday(c)            GymSpend.day_events, beside LateAskWire.monday
##   is_open(f) / open_for(c)
##   view(c, f)           {rival, club, show, my_rep, their_rep, pass_cost, nts_left, free}
##   answer(c, fid, choice)  "accept" (books it through AskFlow.book, the sheet path: the rival already said yes) |
##                        "not_this_show" (free once a season with that rival) | "pass" (-2 points to the challenger; free
##                        while hurt or booked). "" or why. 1 January: LadderSeason.close calls season_reset(c).
## DUCKED / OWED (R6) wait: they need a hot streak (3 wins / +15 points in 8 weeks) the game does not track yet.

const RivalOffer := preload("res://scripts/rules/RivalOffer.gd")
const LadderRep := preload("res://scripts/rules/LadderRep.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const Data := preload("res://scripts/state/Data.gd")
const OFFER_GAP_WEEKS := 4
const ANSWER_DAYS := 4


static func _flow() -> GDScript:
	return load("res://scripts/state/AskFlow.gd")


static func _lp() -> GDScript:
	return load("res://scripts/state/LadderPoints.gd")


static func is_open(f: Dictionary) -> bool:
	return not (f.get("rival_offer", {}) as Dictionary).is_empty()


static func open_for(c: Career) -> Array:
	return c.fighters.filter(func(f): return is_open(f))


## The first region show 7-21 days out, and never inside the rest after her last bout (rest_end, -1 = none).
static func _show_after(day: int, rest_end := -1) -> int:
	var region: GDScript = load("res://scripts/state/Region.gd")
	for d in range(maxi(day + 7, rest_end), day + 22):
		if region.is_show_day(d):
			return d
	return -1


## Rivals of her division she may legally meet, as RivalOffer reads them.
static func _cands(c: Career, f: Dictionary) -> Array:
	var own := AmateurBooking.bouts_of(int(f["w"]), int(f["l"]))
	var out: Array = []
	for r in c.rivals:
		if str(r.get("div", "")) != str(f["div"]):
			continue
		if not AmateurBooking.experience_match_ok(own, AmateurBooking.bouts_of(int(r["w"]), int(r["l"]))):
			continue
		out.append({"name": str(r["name"]), "rep": int(_lp().rep_of(r)), "last_offer_week": int(r.get("ro_week", -1)),
			"booked": false})
	return out


static func monday(c: Career) -> Array:
	var out: Array = []
	if c.day <= 0 or c.day % 7 != 0:
		return out
	var week := int(c.day / 7)
	for f in c.fighters:
		if bool(f.get("pro", false)) or not Data.DIVISIONS.has(str(f.get("div", ""))) or is_open(f) \
				or not (f.get("late_ask", {}) as Dictionary).is_empty() or week < int(f.get("ro_next", 0)) \
				or int(f["w"]) < int(load("res://scripts/state/Region.gd").RANK_MIN_WINS):   # a challenge needs her on the table
			continue
		# S518 LADDERPROBE4: with the door read today no rival rang in 60 two-year runs (shut 99.7% of ranked Mondays:
		# booked 60%, resting 34%). A call in the rest after a bout is for a show after the rest: the door is read then.
		var rest_end := _rest_end(f)
		if not bool(_flow().open(c, f, maxi(c.day, rest_end))["open"]):
			continue
		var show := _show_after(c.day, rest_end)
		if show < 0:
			continue
		var who := RivalOffer.who_offers({"rep": int(_lp().rep_of(f)), "free": true}, _cands(c, f), week)
		if who.is_empty():
			continue
		var r := c.rival(str(who["name"]))
		r["ro_week"] = week
		f["ro_next"] = week + OFFER_GAP_WEEKS
		f["rival_offer"] = {"name": str(r["name"]), "club": str(r["club"]), "show": show, "day": c.day, "expires": c.day + ANSWER_DAYS}
		var line := "%s ring for %s: %s wants the bout at the show on %s." % [r["club"], f["first"], r["name"], Clock.fmt(show)]
		c.add_news(line)
		out.append(line)
	return out


static func _rest_end(f: Dictionary) -> int:
	var lb := int(f.get("last_bout_day", -1))
	return lb + int(load("res://scripts/state/Bouts.gd").AFTER_FIGHT) if lb >= 0 else -1


## Free to turn it down at no cost: hurt or already booked (map R9).
static func _free(f: Dictionary) -> bool:
	return (f.get("bout", {}) as Dictionary).is_empty() and (f.get("injury", {}) as Dictionary).is_empty()


static func view(c: Career, f: Dictionary) -> Dictionary:
	var o: Dictionary = f["rival_offer"]
	var r := c.rival(str(o["name"]))
	return {"rival": r, "club": str(o["club"]), "show": int(o["show"]), "my_rep": int(_lp().rep_of(f)),
		"their_rep": int(_lp().rep_of(r)) if not r.is_empty() else 0, "pass_cost": RivalOffer.PASS_COST if _free(f) else 0,
		"nts_left": not bool(r.get("not_this_show_used", false)), "expires": int(o["expires"])}


static func answer(c: Career, fid: String, choice: String) -> String:
	var f := c.fighter_by_id(fid)
	if f.is_empty() or not is_open(f):
		return "no offer is waiting"
	var o: Dictionary = f["rival_offer"]
	var r := c.rival(str(o["name"]))
	if r.is_empty():
		f["rival_offer"] = {}
		return "that boxer is gone"
	var res := RivalOffer.answer(choice, {"free": _free(f), "not_this_show_used": bool(r.get("not_this_show_used", false)),
		"week": int(c.day / 7)})
	if not bool(res["ok"]):
		return str(res["why"])
	if choice == "accept":
		var idx := int(f.get("opp_index", 0))
		for x in f.get("offers", []):   # the rival's bout replaces a sheet offer still waiting (book needs the Ask door open)
			if not bool(x["answered"]):
				x["answered"] = true
		if not _flow().book(c, f, "sheet", str(r["name"]), int(o["show"]), maxi(c.day, _rest_end(f))):
			return "the bout could not be booked"
		f["opp_index"] = idx   # the sheet's turn was not used
		f["bout"]["rival_offer"] = str(o["club"])
		f["rival_offer"] = {}
		c.add_news("%s takes %s's offer: %s on %s." % [f["first"], o["club"], r["name"], Clock.fmt(int(o["show"]))])
		return ""
	f["rival_offer"] = {}
	r["not_this_show_used"] = bool(res["not_this_show_used"])
	var my_d := int(res["my_delta"])
	if my_d != 0:
		f["rep"] = LadderRep.apply(int(_lp().rep_of(f)), my_d)
		r["rep"] = LadderRep.apply(int(_lp().rep_of(r)), int(res["their_delta"]))
		c.add_news("%s passes on %s's offer: %d ladder points to the challenger." % [f["first"], o["club"], -my_d])
	return ""


## Unanswered past its day: it lapses as a pass (the region hears you did not answer).
static func lapse(c: Career) -> void:
	for f in open_for(c):
		if c.day > int(f["rival_offer"]["expires"]):
			answer(c, str(f["id"]), "pass")


## 1 January: "Not this show" is free again with every rival (RivalOffer.season_reset).
static func season_reset(c: Career) -> void:
	for r in c.rivals:
		if r.has("not_this_show_used"):
			r["not_this_show_used"] = false
