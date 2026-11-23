extends RefCounted
## S523 TURNPRO1B, cut down by S543 TURNPROBUILD17 (turning pro v17, owner Q-S294-320 / Q-S294-323; map
## DESIGN_TURNPRO1_V17.md sections 1 and 6): ONE promoter, ONE offer. The two houses side by side, who calls by the ticket
## forecast, the one ask and its counter-offers, the 14-day window and the "2 more wins" after a lapse are gone.
## c.pro_offer keeps its old keys (fid, promoter, purse, terms, step, top) so the screens that read it keep working, and
## gains: rival (no Not yet left: a rival gym's call), pair_now / pair_later (fight 1's two bouts today and four weeks on,
## ProPair: the chances the pop-up prints), forecast (the debut tickets). Roster passes the terms (no preload cycle).

const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const ProStart := preload("res://scripts/rules/ProStart.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const ProPair := preload("res://scripts/state/ProPair.gd")


## Tickets the boxer would sell on the debut today.
static func forecast(c: Career, f: Dictionary, titles: int) -> int:
	return mini(ProDebut.TICKETS, ProDebut.tickets_sold(c.members, int(f["w"]), titles) + int(f.get("followers", 0)))   # + club show followers


## The offer for f, or {} when no first call comes at this age (ProCall.AGE_STOP). The first offer starts the boxer's
## turning-pro state (ProStart: three patience marks, confidence 50, hunger 70); with no mark left the call is a rival's.
## terms = {promoter, purse, step, top} (Roster's numbers).
static func make(c: Career, f: Dictionary, titles: int, terms: Dictionary) -> Dictionary:
	if not f.has("pro_start") and not ProCall.calls_open(int(f.get("age", 22))):
		return {}
	var s := ProPair.state(f)
	var base := int(terms["purse"])
	return {"fid": f["id"], "promoter": str(terms["promoter"]), "purse": base, "terms": 1.0, "step": int(terms["step"]),
		"top": int(terms["top"]), "forecast": forecast(c, f, titles), "rival": not ProStart.can_wait(s), "day": c.day,
		"pair_now": ProPair.make(c, f, 1, base), "pair_later": ProPair.make(c, f, 1, base, ProPair.trained(c, f, ProPair.LATER_WEEKS))}


## The morale change on each button: the boxer's ambition (Recruit.ambition, the signing card's words).
static func morale(f: Dictionary, stay: bool, before_nationals: bool) -> int:
	return ProCall.morale(Recruit.ambition(f), stay, before_nationals)


## The offer's morale line: why turning pro moves the boxer's morale ("" = it does not). S534 (owner C442 "i do not
## understand why morale drops"): the reason in words, from the goal the boxer signed with. v17: Not yet costs no morale.
static func morale_line(f: Dictionary, before_nationals: bool) -> String:
	var go := morale(f, false, before_nationals)
	if go == 0:
		return ""
	var goal := Recruit.ambition(f).to_lower()
	if go < 0:
		return "MORALE: your boxer's goal is %s. Turning pro now gives it up: morale %d." % [goal, go]
	return "MORALE: your boxer's goal is to box for money. Turning pro: morale %+d." % go


static func apply_morale(f: Dictionary, stay: bool, before_nationals: bool) -> int:
	var d := morale(f, stay, before_nationals)
	if d != 0 and f.has("morale"):
		f["morale"] = clampf(float(f["morale"]) + d, 0.0, 100.0)
	return d
