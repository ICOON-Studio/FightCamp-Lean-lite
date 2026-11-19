extends RefCounted
## S523 TURNPRO1B: the turning-pro v2 rules (ProCall, Goose #376, design DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI.md) wired
## into the game. c.pro_offer keeps its old keys (fid, promoter, purse, terms, step, top = the first house) so the dozen
## screens that read it keep working, and gains: offers (one or two houses' terms, side by side when the ticket forecast
## sits within 15 of break-even), forecast, expires (14 days), asked {house key: the one ask and its answer}, plain
## {house key: the terms before the ask}. Roster passes what it knows (titles, share, nationals) so this file preloads no
## state module (no preload cycle with Roster).
## Decided S523 (Claude): the window running out is not a decline (the map: only Stay amateur is) - the promoter walks
## and calls again after PRO_RETURN_WINS more wins, no morale or loyalty change.

const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")

const RETURN_WINS := 2   ## mirrors Roster.PRO_RETURN_WINS


## Tickets the boxer would sell on the debut today.
static func forecast(c: Career, f: Dictionary, titles: int) -> int:
	return ProDebut.tickets_sold(c.members, int(f["w"]), titles)


## The offer for f, or {} when no first call comes at this age (ProCall.AGE_STOP).
static func make(c: Career, f: Dictionary, titles: int) -> Dictionary:
	var declines := int(f.get("pro_declines", 0))
	if declines == 0 and not ProCall.calls_open(int(f.get("age", 22))):
		return {}
	var fc := forecast(c, f, titles)
	var keys: Array = ProCall.who_calls(fc)
	var last := str(f.get("pro_last_house", ""))
	if declines > 0 and last != "":
		keys = [last]   # after a decline the same promoter calls again
	var title_since := titles > int(f.get("pro_titles_at_decline", 0))
	var offers: Array = []
	for k in keys:
		offers.append(ProCall.terms(str(k), declines, title_since))
	var o := {"fid": f["id"], "offers": offers, "forecast": fc, "expires": ProCall.expires(c.day), "asked": {}, "plain": {}}
	sync(o, str(offers[0]["key"]))
	return o


## The old keys follow the house named (the one the player signs with, or the first).
static func sync(o: Dictionary, key: String) -> void:
	var t := offer(o, key)
	if t.is_empty():
		return
	o["promoter"] = t["name"]
	o["purse"] = int(t["purse"])
	o["terms"] = float(t["factor"])
	o["step"] = int(t["step"])
	o["top"] = int(t["top"])


static func offer(o: Dictionary, key: String) -> Dictionary:
	for t in o.get("offers", []):
		if str(t["key"]) == key:
			return t
	return {}


static func days_left(c: Career) -> int:
	return maxi(0, int(c.pro_offer.get("expires", c.day + ProCall.WINDOW_DAYS)) - c.day)


## Each ask's answer for one house, shown before it is pressed.
static func answers(c: Career, key: String, runway_weeks: int) -> Array:
	var o := c.pro_offer
	var t: Dictionary = (o.get("plain", {}) as Dictionary).get(key, offer(o, key))
	return ProCall.ask_answers(t, int(o.get("forecast", 0)), runway_weeks)


## The one ask on a house's offer. A "take" or "counter" answer changes the terms (pressing a counter takes it - its terms
## are on the button before it is pressed); "wont" changes nothing and is not spent. Returns the promoter's words.
static func ask(c: Career, key: String, kind: String, runway_weeks: int) -> String:
	var o := c.pro_offer
	if o.is_empty() or (o["asked"] as Dictionary).has(key):
		return ""
	for e in answers(c, key, runway_weeks):
		if str(e["kind"]) != kind:
			continue
		if str(e["answer"]) == "wont":
			return str(e["words"])
		var plain := offer(o, key)
		o["plain"][key] = plain
		_replace(o, key, ProCall.apply_ask(plain, e, true))
		o["asked"][key] = {"kind": kind, "label": e["label"], "answer": e["answer"], "words": e["words"]}
		return str(e["words"])
	return ""


## Back to the plain offer after a counter: the ask stays spent (one ask per offer).
static func back_to_plain(c: Career, key: String) -> void:
	var o := c.pro_offer
	if (o.get("plain", {}) as Dictionary).has(key):
		_replace(o, key, o["plain"][key])
		o["asked"][key]["answer"] = "back"


static func _replace(o: Dictionary, key: String, t: Dictionary) -> void:
	var list: Array = o["offers"]
	for i in list.size():
		if str(list[i]["key"]) == key:
			list[i] = t


## The terms the player signs on: the house's terms, and the costs moved into the purse when that ask was taken.
static func signed(o: Dictionary, key: String, costs: int) -> Dictionary:
	var t := offer(o, key).duplicate()
	if bool(t.get("costs_covered", false)):
		t["costs_paid"] = costs   # the promoter paid these at signing; the night takes them (and the fee) from the purse
	sync(o, key)
	o["deal"] = t
	return t


## The money of one house's offer, the gym and the boxer apart (ProCall.money), with the costs ask folded in.
static func money(c: Career, f: Dictionary, t: Dictionary, costs: int, share: float) -> Dictionary:
	var deal := t.duplicate()
	var pay_now := costs
	if bool(deal.get("costs_covered", false)):
		deal["purse"] = maxi(0, int(deal["purse"]) - costs - int(deal.get("costs_from_purse", 0)))
		pay_now = 0
	var sold := mini(ProDebut.TICKETS, int(c.pro_offer.get("forecast", 0)) + int(deal.get("extra_tickets", 0)))
	var m := ProCall.money(deal, sold, pay_now, share, int(f.get("weekly_salary", 0)) > 0, maxi(0, int(f.get("weekly_salary", 0))))
	m["sold"] = sold
	m["costs_now"] = pay_now
	return m


## The debut night's money under a v2 deal (BoutFinish pays "gym"): the purse and the ticket share, the gym's cut of both.
static func night(f: Dictionary, deal: Dictionary, sold_today: int, share: float) -> Dictionary:
	var d := deal.duplicate()
	if bool(d.get("costs_covered", false)):
		d["purse"] = maxi(0, int(d["purse"]) - int(d.get("costs_paid", 0)) - int(d.get("costs_from_purse", 0)))
	var sold := mini(ProDebut.TICKETS, sold_today + int(d.get("extra_tickets", 0)))
	var m := ProCall.money(d, sold, 0, share, false, 0)
	var gym := int(m["gym_at_signing"])   # costs 0 here, so this is the gym's cut of the purse and the ticket share
	var be := int(d.get("break_even", ProDebut.BREAK_EVEN))
	return {"sold": sold, "money": sold * ProDebut.TICKET_PRICE, "above": maxi(0, sold - be), "share": int(m["ticket_share"]),
		"purse": int(m["purse"]), "gym": gym, "her": int(m["boxer"]), "break_even": be, "house": str(d.get("name", ""))}


static func night_words(f: Dictionary, t: Dictionary) -> String:
	return "%s sold %d debut tickets (%s's break-even %d): purse %s, ticket share %s. The gym's cut %s; the boxer keeps %s." % [
		f["first"], int(t["sold"]), t["house"], int(t["break_even"]), _m(int(t["purse"])), _m(int(t["share"])), _m(int(t["gym"])),
		_m(int(t["her"]))]


static func _m(v: int) -> String:
	return "$%s" % str(v)


## The morale change on each button: the boxer's ambition (Recruit.ambition, the signing card's words).
static func morale(f: Dictionary, stay: bool, before_nationals: bool) -> int:
	return ProCall.morale(Recruit.ambition(f), stay, before_nationals)


static func apply_morale(f: Dictionary, stay: bool, before_nationals: bool) -> int:
	var d := morale(f, stay, before_nationals)
	if d != 0 and f.has("morale"):
		f["morale"] = clampf(float(f["morale"]) + d, 0.0, 100.0)
	return d


## After a Stay amateur: the same house calls next time; a title won since clears the 0.9x terms.
static func on_decline(f: Dictionary, o: Dictionary, titles: int) -> void:
	f["pro_last_house"] = str((o.get("offers", [{}]) as Array)[0].get("key", ""))
	f["pro_titles_at_decline"] = titles


## The window ran out: the offer goes, the promoter waits RETURN_WINS more wins. Returns the news line ("" = not due).
static func lapse_if_due(c: Career) -> String:
	var o := c.pro_offer
	if o.is_empty() or not o.has("expires") or c.day < int(o["expires"]):
		return ""
	var f := c.fighter_by_id(str(o["fid"]))
	c.pro_offer = {}
	if f.is_empty():
		return ""
	f["pro_wait_w"] = int(f["w"]) + RETURN_WINS
	return "%s's offer ran out after 14 days with no answer. The promoters will call again after %d more wins." % [
		str(o.get("promoter", "The promoter")), RETURN_WINS]


## Whether a promoter that walked has seen enough wins since.
static func waited(f: Dictionary) -> bool:
	return int(f["w"]) >= int(f.get("pro_wait_w", 0))
