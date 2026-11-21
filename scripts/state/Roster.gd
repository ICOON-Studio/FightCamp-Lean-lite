extends RefCounted
## Growing the roster and the end of the amateur arc: scouting trials (invite a prospect, watch her trial on the Monday,
## sign her or pass) and turning pro (a promoter's offer at the line, a contract, the pro debut).
## Turning-pro line and terms: Kalli K-PROLINE1 (Godot/research/K_PROLINE1_KALLI.md in the old repo), game-tuned, not
## measured against real purse data. S329 update 31 (John J-PRODEBUT1, measured): the debut is a small-hall show - the gym
## pays her BBBofC licence and brain scans when she signs, she sells tickets, and the debut pays her half of what she sells
## above the promoter's break-even (ProDebut); the flat purse starts from her second pro bout.

const KnowWire := preload("res://scripts/state/KnowWire.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const PerkRoad := preload("res://scripts/rules/PerkRoad.gd")
const Data := preload("res://scripts/state/Data.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FightWords := preload("res://scripts/state/FightWords.gd")
const Region := preload("res://scripts/state/Region.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const HomeJuniors := preload("res://scripts/state/HomeJuniors.gd")
const StarDeal := preload("res://scripts/rules/StarDeal.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")   # TURNPRO6: the debut opponent, shared with the offer's read
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")   # S523 TURNPRO1B: two houses, one ask, 14 days

## The goal a new signing brings: a booked bout and her engine up inside a month - her debut, or her next bout when she
## already has bouts on her card (S352).
const SIGNING_GOAL := "debut_inside_a_month"
const SIGNING_GOAL_CARDED := "next_bout_inside_a_month"

## The offer comes at 7 amateur wins and a top-3 regional ranking, or at 9 wins whatever the ranking.
const PRO_WINS := 7
const PRO_RANK := 3
const PRO_WINS_ANY_RANK := 9
## A declined offer comes back after this many more amateur wins; the second promoter's terms are 10% worse.
const PRO_RETURN_WINS := 2
## S525 PROCONTRACT1 (design TURNPRO1 v2 s1): after 2 declines only a regional number 1 calls; after 3 the door is closed.
const DECLINE_NEWS := ["The promoters will be back after more wins.", "Only a regional number 1 brings another call.", "No promoter will call."]
const PRO_SECOND_TERMS := 0.9
const PROMOTERS: Array[String] = ["Bow Lane Promotions", "Harrow & Finch Boxing"]
## Her purse from the second pro bout, rising per pro win to the top; the gym's cut (manager 15% + trainer 10%, John
## J-PRODEBUT1 - the 25% manager cut of K-PROLINE1 had no source).
const PRO_PURSE := 1500
const PRO_PURSE_STEP := 500
const PRO_PURSE_TOP := 3000
const GYM_SHARE := ProDebut.MANAGER + ProDebut.TRAINER
const PRO_ROUNDS := 4
## The debut is booked this many weeks after she signs.
const PRO_DEBUT_WEEKS := 4
## Her pro debut opponent: a fellow debutant at about her level (rating = her night's strength minus this).
const PRO_OPP_GAP := 1.0
const PRO_OPP_NAMES := DebutOpp.NAMES_F   # TURNPRO6: the names live with the opponent's rule (men have their own list there)

const TRIAL_FALLBACK := {
	"trial_open": ["{name} is in for a trial at {gym}."],
	"trial_good": ["Good trial. {name}'s {best} is the real thing."],
	"trial_mixed": ["{name}'s {best} is good, but the {worst} needs work."],
	"pro_offer": ["{promoter} wants {her} on their card: a pro contract, the debut paid from ticket sales."],
	"pro_debut": ["{her} makes a pro debut against {opp} over four rounds."],
}
const WORDS_PATH := "res://assets/data/roster_words.json"
static var _bank: Dictionary = {}


static func words(kind: String, subs: Dictionary, seed_value: int) -> String:
	if _bank.is_empty():
		_bank = TRIAL_FALLBACK.duplicate(true)
		if FileAccess.file_exists(WORDS_PATH):
			var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(WORDS_PATH))
			if parsed is Dictionary:
				for k in (parsed as Dictionary).keys():
					if parsed[k] is Array and not (parsed[k] as Array).is_empty():
						_bank[k] = parsed[k]
	var pool: Array = _bank.get(kind, [])
	return "" if pool.is_empty() else FightWords.fill(str(pool[absi(seed_value) % pool.size()]), subs)


static func prospect(c: Career, id: String) -> Dictionary:
	for p in c.prospects:
		if str(p["id"]) == id:
			return p
	return {}


## The trial day for an invite made today: next Monday.
static func trial_day_for(day: int) -> int:
	return day - posmod(day, 7) + 7


static func invite(c: Career, id: String) -> bool:
	var p := prospect(c, id)
	if p.is_empty() or str(p["state"]) != "scout" or GymSpend.place_blocked(c) != "":   # S397 roster places
		return false
	p["state"] = "invited"
	p["trial_day"] = trial_day_for(c.day)
	c.add_news("%s is invited for a trial on %s." % [p["name"], Clock.fmt(int(p["trial_day"]))])
	return true


## What scouting shows before a trial: a range per stat ("54-64").
static func scouted_range(p: Dictionary, stat: String) -> String:
	var v := float(p["stats"][stat])
	return "%d-%d" % [int(v) - Data.SCOUT_SPREAD, int(v) + Data.SCOUT_SPREAD]


## The trial's read: {best, worst, good, open, verdict}; a trial is good when her potential is 80 or more.
static func trial_read(c: Career, p: Dictionary) -> Dictionary:
	var best := ""
	var worst := ""
	for k in Data.STATS:
		if best == "" or float(p["stats"][k]) > float(p["stats"][best]):
			best = k
		if worst == "" or float(p["stats"][k]) < float(p["stats"][worst]):
			worst = k
	var good := int(p["pot"]) >= 80
	var subs := {"name": p["first"], "best": str(Data.LABEL[best]).to_lower(), "worst": str(Data.LABEL[worst]).to_lower(), "gym": c.gym_name}
	return {"best": best, "worst": worst, "good": good,
		"open": words("trial_open", subs.merged({"name": p["name"]}, true), c.day),
		"verdict": words("trial_good" if good else "trial_mixed", subs, c.day + 3)}


## Signs a prospect after her trial (her stats are now known exactly).
static func sign_prospect(c: Career, id: String, picks: Array) -> Dictionary:
	var p := prospect(c, id)
	if p.is_empty() or str(p["state"]) != "invited":
		return {}
	var raw: Dictionary = p.duplicate(true)
	for k in ["state", "trial_day", "note"]:
		raw.erase(k)
	if GymSpend.place_blocked(c) != "":   # S397 a place filled since the invite
		return {}
	p["state"] = "signed"
	var f := sign_fighter(c, raw, picks)
	HomeJuniors.on_sign(c, raw, f)   # S397 a home-grown signing: half the stipend for a year
	return f


## Signs a fighter (the walk-in, or a prospect after her trial) on the club stipend with her signing goal.
static func sign_fighter(c: Career, raw: Dictionary, picks: Array) -> Dictionary:
	var f := Data.fighter_state(raw.duplicate(true), c.day)
	KnowWire.start(f)   # S524 KNOWLEDGE1: a new signing starts with day-one ranges (old saves stay exact)
	var focus := ""
	for p in picks:
		if Recruit.FOCUS.has(str(p)):
			focus = str(p)
	f["cards"] = Recruit.default_cards(str(f.get("style", ""))) if focus != "" else picks.duplicate()
	if focus != "":
		f["start_focus"] = focus
		c.add_news(Recruit.apply_focus(f, focus, c.day))
	PerkRoad.newly_open(f, c.day)
	f["joined"] = c.day
	for t in c.fighters:   # S486 LOYALHOOKS1: a signing in the same class (map M1: -4 once)
		if str(t.get("div", "")) == str(f.get("div", "")):
			Loyalty.apply(t, "signing_class", c.day)
	f["registered"] = registered_day(f, c.day)   # S331 the nationals need 3 months REGISTERED (England Boxing), not with us
	var bouts: int = int(f.get("w", 0)) + int(f.get("l", 0)) + int(f.get("d", 0))
	f["goal"] = FighterGoal.goal_for(f, SIGNING_GOAL if bouts == 0 else SIGNING_GOAL_CARDED, c.day)
	c.fighters.append(f)
	c.add_news("%s signs for %s on the club stipend." % [f["name"], c.gym_name])
	if c.fighters.size() == 2:   # S519 club week v11 s2: said once, when the coach's time first has two to cover
		c.add_news("Two boxers now share the coach's time: the coached mornings are dealt on Training (1-to-1 or shared), a class night costs that evening's pads, and the film nights are shared in a fight week.")
	return f


## The day she registered with England Boxing: a fighter with bouts on her card boxed them at the club-show pace (one bout
## per AmateurBooking.LEAD_WEEKS_MAX weeks at most), so she registered at least that long before signing; a novice registers now.
static func registered_day(f: Dictionary, day: int) -> int:
	if f.has("registered"):
		return int(f["registered"])
	var bouts: int = int(f.get("w", 0)) + int(f.get("l", 0)) + int(f.get("d", 0))
	return day - bouts * 7 * AmateurBooking.LEAD_WEEKS_MAX


static func pass_on(c: Career, id: String) -> void:
	var p := prospect(c, id)
	if not p.is_empty():
		p["state"] = "passed"
		c.add_news("%s thanks the gym for the trial and moves on." % p["name"])


## ---------- turning pro ----------

## Whether she is at the line for an offer now (wins, rank, and the declines so far).
static func pro_ready(f: Dictionary) -> bool:
	if bool(f.get("pro", false)) or int(f.get("pro_declines", 0)) >= 3:
		return false
	if bool(f.get("nat_final", false)) and int(f.get("pro_declines", 0)) == 0:
		return true   # S328 a national finalist: the promoters call whatever her record
	var w := int(f["w"])
	var need := PRO_WINS + int(f.get("pro_declines", 0)) * PRO_RETURN_WINS
	if int(f.get("pro_declines", 0)) >= 2:
		return int(f.get("rank", 0)) == 1
	var ranked := int(f.get("rank", 0)) > 0 and int(f.get("rank", 0)) <= PRO_RANK
	return (w >= need and ranked) or w >= PRO_WINS_ANY_RANK + int(f.get("pro_declines", 0)) * PRO_RETURN_WINS


## Checked after her bouts and at the week's end: a promoter calls when she is at the line.
static func check_pro(c: Career) -> void:
	if not c.pro_offer.is_empty():
		var lapsed := ProOfferWire.lapse_if_due(c)   # S523: the offer stands 14 days
		if lapsed != "":
			c.add_news(lapsed)
		return
	for f in c.fighters:
		if pro_ready(f) and ProOfferWire.waited(f) and (f["bout"] as Dictionary).is_empty() and not Champs.active(f):
			# S523 TURNPRO1B: who calls by the ticket forecast (one house, or both side by side), no first call at 32+
			var o := ProOfferWire.make(c, f, titles(f))
			if o.is_empty():
				continue
			c.pro_offer = o
			c.add_news(words("pro_offer", {"her": f["name"], "promoter": c.pro_offer["promoter"], "purse": GameMoney.text(int(o["purse"]))}, c.day))
			return


## The gym's cut of a pro purse. S397 (StarDeal): the fighter's own share after contract talks (GYM_SHARE until then).
static func gym_cut(purse: int, f: Dictionary = {}) -> int:
	return int(round(purse * share_of(f)))


## The share the club will keep if she signs pro today: the usual cut, or the trainer's 10% under 50 loyalty (Loyalty.pro_share).
static func signing_share(f: Dictionary) -> float:
	return minf(share_of(f), Loyalty.pro_share(f))


static func share_of(f: Dictionary) -> float:
	return GYM_SHARE if f.is_empty() else StarDeal.share(f)


## Her championship titles (London or national champion) - each sells tickets.
static func titles(f: Dictionary) -> int:
	return (f.get("titles", []) as Array).filter(func(t): return str(t["t"]).to_lower().contains("champion")).size()


## The gym's trainer needs a BBBofC licence to work her pro corner (no coach: nobody to license).
static func trainer_licensed(c: Career) -> bool:
	return c.coach.is_empty() or bool(c.coach.get("pro_licence", false))


## The pro offer's money sheet: what signing costs the gym, the tickets she would sell today, the night that pays.
static func debut_sheet(c: Career, f: Dictionary, terms: float) -> Dictionary:
	return ProDebut.sheet(c.members, int(f["w"]), titles(f), not bool(f.get("licensed", false)), trainer_licensed(c), terms)


## The debut night's tickets, sold from the gym's members and her amateur record as they are on the night.
static func debut_night(c: Career, f: Dictionary) -> Dictionary:
	var deal: Dictionary = f["bout"].get("deal", {})
	if not deal.is_empty():   # S523: the v2 deal pays the purse and the ticket share past the house's break-even
		return ProOfferWire.night(f, deal, ProOfferWire.forecast(c, f, titles(f)), share_of(f))
	return ProDebut.night(ProOfferWire.forecast(c, f, titles(f)), float(f["bout"].get("terms", 1.0)))


static func debut_words(f: Dictionary, t: Dictionary) -> String:
	if t.has("purse"):
		return ProOfferWire.night_words(f, t)
	if int(t["above"]) == 0:
		return "%s sold %d of %d debut tickets - not past the promoter's %d, so the debut paid nothing. More members, more tickets." % [
			f["first"], int(t["sold"]), ProDebut.TICKETS, ProDebut.BREAK_EVEN]
	return "%s sold %d debut tickets, %d past the promoter's %d: the fighter's share %s, the gym's %s of it." % [f["first"], int(t["sold"]),
		int(t["above"]), ProDebut.BREAK_EVEN, GameMoney.text(int(t["share"])), GameMoney.text(int(t["gym"]))]


## She signs pro: the stipend and the amateur career end, the debut is booked.
static func turn_pro(c: Career, house := "") -> Dictionary:
	var o := c.pro_offer
	if o.is_empty():   # S491: a second TURN PRO press (or a stale modal) after the offer was taken crashed here
		return {}
	var f := c.fighter_by_id(str(o["fid"]))
	# S523 TURNPRO1B: sign with the house picked (the first when only one called or none is named)
	if house == "" and o.has("offers"):
		house = str(o["offers"][0]["key"])
	var deal: Dictionary = {}
	# S329 update 31: the gym pays her licence and brain scans (and the trainer's licence) now.
	var sheet := debut_sheet(c, f, float(o["terms"]))
	if o.has("offers"):
		deal = ProOfferWire.signed(o, house, int(sheet["costs"]))
		ProOfferWire.apply_morale(f, false, bool(Champs.check(c, f).get("ok", false)))
	if int(sheet["costs"]) > 0 and bool(deal.get("costs_covered", false)):
		c.add_news("%s pays the licence and scans; it comes off the debut purse." % str(deal["name"]))
	elif int(sheet["costs"]) > 0:
		c.pay(-int(sheet["costs"]), "BBBofC licence and brain scans: %s" % f["first"])
	f["licensed"] = true
	if not c.coach.is_empty():
		c.coach["pro_licence"] = true
	f["pro"] = true
	# S485 CLUBWEEK1 (his Q-244 "Yes"): under 50 loyalty an outside manager signs her; the club keeps the trainer's 10%.
	if Loyalty.pro_share(f) < share_of(f):
		f["gym_share"] = Loyalty.pro_share(f)
		c.add_news("An outside manager signs %s: the club keeps only the trainer's %d%%." % [f["first"], int(round(Loyalty.pro_share(f) * 100))])
	Loyalty.apply(f, "turn_pro", c.day)   # S486 LOYALHOOKS1: after the share is set (the share reads loyalty before it)
	f["promoter"] = o["promoter"]
	f["pro_house"] = str(deal.get("key", ""))
	f["pro_signed"] = {"d": c.day, "house": str(o["promoter"]), "key": str(deal.get("key", "")), "stipend": int(f.get("weekly_salary", 0)),   # S524 M11: the week review's ledger
		"costs": 0 if bool(deal.get("costs_covered", false)) else int(sheet["costs"])}   # S523 map M15: the History tab's milestone   # S523: the house leans the first pro offers (ProLean)
	f["purse"] = int(o["purse"])
	f["purse_step"] = int(o["step"])
	f["purse_top"] = int(o["top"])
	f["pro_w"] = 0
	f["pro_l"] = 0
	f["weekly_salary"] = 0
	for x in f["offers"]:
		x["answered"] = true
	# TURNPRO6 (S533): the opponent comes from DebutOpp, the one rule the offer's shown chance (DebutRead) also reads.
	var opp := DebutOpp.make(f, float(deal.get("opp_gap", PRO_OPP_GAP)), c.day, str(o["promoter"]))
	var opp_name: String = opp["name"]
	f["bout"] = {"opp": opp, "day": debut_day(c.day, int(deal.get("debut_weeks", PRO_DEBUT_WEEKS))), "weighed": false, "made": false, "done": false,
		"film": BoutRules.FILM_DEPTH_DEFAULT, "pro": true, "rounds": PRO_ROUNDS, "purse": int(o["purse"]),
		"tickets": true, "terms": float(o["terms"]), "deal": deal}
	f["pro_tune_ups"] = int(deal.get("tune_ups", 0))   # the softer-opponent ask: the next pro offers lean tune-up
	f["booked_fight"] = true
	c.add_news("%s turns pro with %s." % [f["name"], o["promoter"]])
	c.add_news(words("pro_debut", {"her": f["name"], "opp": opp_name}, c.day + 1))
	c.pro_offer = {}
	return f


## The Saturday PRO_DEBUT_WEEKS weeks out.
static func debut_day(day: int, weeks := PRO_DEBUT_WEEKS) -> int:
	return day - posmod(day, 7) + 5 + weeks * 7


## She stays amateur for now: the offer returns after more wins; the second time the other promoter calls.
static func decline_pro(c: Career) -> void:
	if not c.pro_offer.has("fid"):
		return   # S525 PROCONTRACT1: no offer on the table, nothing to decline
	var f := c.fighter_by_id(str(c.pro_offer["fid"]))
	f["pro_declines"] = int(f.get("pro_declines", 0)) + 1
	ProOfferWire.on_decline(f, c.pro_offer, titles(f))   # S523: the same house calls next time
	ProOfferWire.apply_morale(f, true, bool(Champs.check(c, f).get("ok", false)))
	Loyalty.apply(f, "decline_pro", c.day)   # S486 LOYALHOOKS1: kept amateur for the nationals, against the boxer's wish
	c.add_news("%s stays amateur for now. %s" % [f["first"],
		DECLINE_NEWS[mini(int(f["pro_declines"]), 3) - 1]])
	c.pro_offer = {}
