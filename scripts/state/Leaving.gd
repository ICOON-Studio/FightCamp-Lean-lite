extends RefCounted
## S486 R58 LEAVE1 (map ops/research/R58_MAP_S439.md section 4 M6 and M7): a boxer leaves the club - on their own (loyalty
## under 25 after two words, Loyalty.leaves), at the end of an approach (Approach, the answer LET THEM GO or no answer), or
## let go by the player (the Overview's contract line). Before S486 no code path removed a fighter.
## What leaving does, in this order:
##   1. a bout booked inside FAREWELL_DAYS is boxed first: the boxer leaves the Monday after it (f["leaves_after"]); a bout
##      further off goes with them (it lives on the fighter; withdrawn, no fine);
##   2. the promoter's pro offer to them is withdrawn; the stipend stops with them (it lives on the fighter);
##   3. reputation REP_LEAVE (REP_LEAVE_RANKED for a regional top 5 or a professional); let go: REP_LET_GO / REP_LET_GO_RANKED;
##   4. a professional's manager pays the release fee: StarDeal.YEAR_BONUS of what they earned the gym in the last year,
##      at least FEE_MIN;
##   5. they leave c.fighters (the place frees: GymSpend.used counts c.fighters) and box on as a row in c.rivals for
##      TO_CLUB (an amateur; Rankings and the offers read it like any rival), "left": the day;
##   6. every team-mate under Loyalty.SETTLED_AT takes Loyalty "teammate_left"; the news says it (Records).
## The rest of the game reads c.fighters, so a fighter gone from it is gone from every menu; anything else that names the
## fighter by id must accept c.fighter_by_id(...) == {} (it already does: it returns {} for an unknown id).
## Preloads Loyalty, Region, StarDeal (no loop: GymSpend's day_events calls monday()). Ships ON (GameSwitches: R58 is a
## core rule of the club week, not an opt-in).

const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Region := preload("res://scripts/state/Region.gd")
const StarDeal := preload("res://scripts/rules/StarDeal.gd")
const Clock := preload("res://scripts/state/Clock.gd")

const TO_CLUB := "Eastside ABC"
const FAREWELL_DAYS := 14
const REP_LEAVE := -2
const REP_LEAVE_RANKED := -5
const REP_LET_GO := -1
const REP_LET_GO_RANKED := -3
const RANKED_TOP := 5
const FEE_MIN := 500
## A rival row's rating for a boxer who left (Region's rival ratings run ~55-65; the ladder only orders by it on ties).
const LEFT_RATING := 60.0


## True for a regional top 5 or a professional (the bigger reputation cost).
static func ranked(c: Career, f: Dictionary) -> bool:
	if bool(f.get("pro", false)):
		return true
	var r := Region.our_rank(c, f)
	return r >= 1 and r <= RANKED_TOP


## The release fee a professional's manager pays (0 for an amateur).
static func release_fee(c: Career, f: Dictionary) -> int:
	if not bool(f.get("pro", false)):
		return 0
	var take := int(load("res://scripts/state/GymDeals.gd").year_take(c, f))   # load(): GymDeals preloads GymSpend, which preloads this file
	return maxi(FEE_MIN, roundi(float(take) * StarDeal.YEAR_BONUS / 100.0) * 100)


## The boxer leaves (why: "loyalty" on their own, "approach" to the club that came for them). Returns
## {ok, deferred, day, rep, fee, line}. deferred: a bout inside FAREWELL_DAYS is boxed first.
static func leave(c: Career, fid: String, why := "loyalty", to_club := TO_CLUB) -> Dictionary:
	return _go(c, fid, why, to_club, false)


## The player lets the boxer go (M7): free in cash, the smaller reputation cost, the same knock-on.
static func let_go(c: Career, fid: String) -> Dictionary:
	return _go(c, fid, "let_go", TO_CLUB, true)


## What letting go costs, for the confirm (M7): {rep, ranked, why_not}. why_not "" = allowed.
static func let_go_price(c: Career, fid: String) -> Dictionary:
	var f := c.fighter_by_id(fid)
	if f.is_empty():
		return {"rep": 0, "ranked": false, "why_not": "not in the club"}
	var rk := ranked(c, f)
	var why_not := ""
	if int(f.get("bout", {}).get("day", -1)) >= c.day and not bool(f.get("bout", {}).get("done", false)):
		why_not = "a bout is booked"
	return {"rep": REP_LET_GO_RANKED if rk else REP_LET_GO, "ranked": rk, "why_not": why_not}


static func _go(c: Career, fid: String, why: String, to_club: String, mine: bool) -> Dictionary:
	var f := c.fighter_by_id(fid)
	if f.is_empty():
		return {"ok": false, "deferred": false, "day": c.day, "rep": 0, "fee": 0, "line": ""}
	var bout: Dictionary = f.get("bout", {})
	var bday := int(bout.get("day", -1))
	if not mine and not bool(bout.get("done", false)) and bday >= c.day and bday - c.day <= FAREWELL_DAYS:
		f["leaves_after"] = bday
		f["leaves_why"] = why
		var later := "%s boxes one last bout for %s on %s, then leaves for %s." % [str(f["name"]), c.gym_name, Clock.fmt(bday), to_club]
		c.add_news(later, true, true)
		return {"ok": true, "deferred": true, "day": bday, "rep": 0, "fee": 0, "line": later}
	var rk := ranked(c, f)
	var rep := (REP_LET_GO_RANKED if rk else REP_LET_GO) if mine else (REP_LEAVE_RANKED if rk else REP_LEAVE)
	c.reputation = maxi(0, c.reputation + rep)
	var fee := release_fee(c, f)
	if fee > 0:
		c.pay(fee, "Release fee: %s's new manager" % str(f.get("first", f["name"])))
	if str(c.pro_offer.get("fid", "")) == fid:
		c.pro_offer = {}
	c.fighters.erase(f)
	if not bool(f.get("pro", false)):
		c.rivals.append(rival_row(c, f, to_club))
	for t in c.fighters:
		if Loyalty.value(t) < Loyalty.SETTLED_AT:
			Loyalty.apply(t, "teammate_left", c.day)
	var line := ("%s leaves %s: let go." % [str(f["name"]), c.gym_name]) if mine else ("%s leaves for %s." % [str(f["name"]), to_club])
	c.add_news(line, true, true)
	return {"ok": true, "deferred": false, "day": c.day, "rep": rep, "fee": fee, "line": line}


## The boxer as a rival amateur at the new club (Region's rival shape; Rankings tags "left": the day).
static func rival_row(c: Career, f: Dictionary, to_club: String) -> Dictionary:
	return {"div": str(f.get("div", "wlw")), "name": str(f["name"]), "first": str(f.get("first", "")),
		"club": to_club, "age": int(f.get("age", 20)), "stance": str(f.get("stance", "orthodox")),
		"style": str(f.get("style", "Boxer-puncher")), "w": int(f.get("w", 0)), "l": int(f.get("l", 0)),
		"rating": LEFT_RATING, "threat": "", "weak": "", "left": c.day, "from": c.gym_name, "bouts": []}


## Monday (GymSpend.day_events): a farewell bout boxed -> they leave now; loyalty under 25 after two words -> they leave.
## Returns the lines of who left.
static func monday(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters.duplicate():
		var fid := str(f["id"])
		if f.has("leaves_after"):
			if c.day > int(f["leaves_after"]):
				var bout: Dictionary = f.get("bout", {})
				bout["day"] = -1   # boxed (or past): the farewell is over, nothing defers them again
				var r := leave(c, fid, str(f.get("leaves_why", "loyalty")))
				out.append(str(r["line"]))
			continue
		if Loyalty.leaves(f, c.day):
			var r2 := leave(c, fid, "loyalty")
			out.append(str(r2["line"]))
	return out
