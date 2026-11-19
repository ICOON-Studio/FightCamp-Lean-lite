extends RefCounted
## S525 SPLIT500C: the pros' money and the club's grants, moved whole out of GymSpend.gd (CLAUDE.md item 5, no script over
## 500 lines) - a pro camp's bill and the cutman's night, the management firm's contract talks, what a pro earned the gym in
## the last year, and the small grant bids. The rules are pure modules (StarDeal, Grants, GymUpgrades, StaffRoles); this
## file applies them to the Career. Bouts pays the camp, GymActs answers the talks and bids, GymSpend's week calls the rest.
## No line of logic, no number and no string changed in the move.
## GymSpend is preloaded here for youth_on (a grant bid needs the youth section), so GymSpend reaches this file with load()
## at run time and never preloads it: one direction only, no cycle.

const StarDeal := preload("res://scripts/rules/StarDeal.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Grants := preload("res://scripts/rules/Grants.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")   # youth_on: the bid needs the youth section


## ---------- pros ----------

## A pro camp after the debut: the bill (6% of the purse, halved with the S&C coach) and the cutman's night. Paid at camp
## start. (The debut is a ticket-selling small-hall night the promoter stages: no camp bill.)
static func pro_camp(c: Career, f: Dictionary) -> int:
	var b: Dictionary = f.get("bout", {})
	if not bool(b.get("pro", false)):
		return 0
	var total := 0
	if not bool(b.get("tickets", false)):
		var bill := StarDeal.camp_bill(int(b.get("purse", 0)), c.staff_roles.has("strength"))
		c.pay(-bill, "Pro camp for %s: sparring partners and meals" % f["first"])
		total += bill
	var cut := StaffRoles.per_bout(c.staff_roles)
	if cut > 0:
		c.pay(-cut, "Cutman for %s's night" % f["first"])
		total += cut
	return total


## Contract talks open when a pro first reaches the top 10 or wins a belt (StarDeal.due); 14 days to answer, then the
## lower share stands.
static func check_talks(c: Career, f: Dictionary, rank: int, belt: String) -> void:
	if not bool(f.get("pro", false)) or not (f.get("talks", {}) as Dictionary).is_empty():
		return
	if belt != "" and not c.deals.any(func(d): return str(d["id"]) == str(GymUpgrades.TITLE_SPONSOR["id"])):
		c.deals.append(GymUpgrades.TITLE_SPONSOR.merged({"state": "offer"}))
		c.add_news("%s wants the champion's gym: %s a week for %s (Money > Deals)." % [GymUpgrades.TITLE_SPONSOR["name"],
			GameMoney.text(int(GymUpgrades.TITLE_SPONSOR["per"])), GymUpgrades.TITLE_SPONSOR["what"]])
	var step := StarDeal.due(f, rank, belt, c.day)
	if step == "":
		return
	var t := StarDeal.terms(f, step, year_take(c, f))
	f["talks"] = {"step": step, "until": c.day + 14, "take": year_take(c, f)}
	c.add_news("%s has reached %s, and a bigger management firm has called. Keep the gym's %d%% for a %s bonus, or drop to %d%% (Money)." % [
		f["first"], t["words"], roundi(float(t["keep"]) * 100), GameMoney.text(int(t["bonus"])), roundi(float(t["lower"]) * 100)])


static func answer_talks(c: Career, f: Dictionary, keep: bool) -> String:
	var talks: Dictionary = f.get("talks", {})
	if talks.is_empty():
		return "no talks open"
	var t := StarDeal.terms(f, str(talks["step"]), int(talks.get("take", 0)))
	if keep:
		if c.cash < int(t["bonus"]):
			return "$%d short of the price" % (int(t["bonus"]) - c.cash)
		c.pay(-int(t["bonus"]), "Signing bonus: %s stays on %d%%" % [f["first"], roundi(float(t["keep"]) * 100)])
	else:
		f["gym_share"] = float(t["lower"])
		c.add_news("%s re-signs: the gym's share is now %d%%." % [f["first"], roundi(float(t["lower"]) * 100)])
	(f.get_or_add("renewed", []) as Array).append(str(talks["step"]))
	f["talks_day"] = c.day
	f["talks"] = {}
	return ""


## What a pro earned the gym in the last year: the purse-share and ticket lines in the ledger with the pro's name.
static func year_take(c: Career, f: Dictionary) -> int:
	var total := 0
	var who := str(f.get("first", ""))
	for e in c.ledger:
		if c.day - int(e["d"]) > StarDeal.YEAR_DAYS:
			break
		var t := str(e["t"])
		if int(e["amount"]) > 0 and (t.begins_with("Purse share") or t.begins_with("Debut tickets")) and t.contains(who):
			total += int(e["amount"])
	return total


## ---------- grants (round 2, both critics: Sport England-style small grants, applied for, with conditions) ----------

static func grant_bid(c: Career) -> String:
	var why := Grants.blocked(c.day, c.grant, GymSpend.youth_on(c), c.staff_roles.has("assistant") or c.extra_coaches > 0)
	if why != "":
		return why
	var rng := RandomNumberGenerator.new()
	rng.seed = c.seed * 13 + c.day
	c.grant = {"due": c.day + Grants.ANSWER_DAYS, "last": c.day, "won": rng.randf() < Grants.chance(c.reputation),
		"amount": Grants.amount(rng.randf())}
	c.add_news("Grant bid sent: a small club grant for the juniors' nights. The answer comes on %s." % Clock.fmt(int(c.grant["due"])))
	return ""


static func grant_day(c: Career) -> void:
	if c.grant.is_empty() or int(c.grant.get("due", -1)) != c.day:
		return
	if bool(c.grant["won"]):
		c.pay(int(c.grant["amount"]), "Club grant: juniors' nights and kit")
		c.add_news("The grant bid won: %s for the juniors' nights and kit." % GameMoney.text(int(c.grant["amount"])))
	else:
		c.add_news("The grant bid was turned down this time: more bids than money. Bid again next year.")
	c.grant = {"last": int(c.grant["last"])}
