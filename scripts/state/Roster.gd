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
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")   # S543 v17: one promoter, one offer
const ProStart := preload("res://scripts/rules/ProStart.gd")   # S543 TURNPRO17: patience, the two bars
const ProPair := preload("res://scripts/state/ProPair.gd")   # S543 TURNPRO17: pro fights 1-6, safe or risky

## The goal a new signing brings: a booked bout and her engine up inside a month - her debut, or her next bout when she
## already has bouts on her card (S352).
const SIGNING_GOAL := "debut_inside_a_month"
const SIGNING_GOAL_CARDED := "next_bout_inside_a_month"

## The offer comes at 7 amateur wins and a top-3 regional ranking, or at 9 wins whatever the ranking.
const PRO_WINS := 7
const PRO_RANK := 3
const PRO_WINS_ANY_RANK := 9
## S543 TURNPRO17 (v17): one promoter; a "Not yet" no longer moves the line (ProStart: three patience marks, the offer
## back in four weeks, then a rival gym's call). The v2 decline rule (+2 wins, 0.9x terms, rank 1 after two) is gone.
const PROMOTER := "Bow Lane Promotions"
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
	if p.is_empty() or not str(p["state"]) in ["scout", "later"] or GymSpend.place_blocked(c) != "":   # S397 roster places; S545 a name not yet scouted can be asked in
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
	if str(p.get("state", "")) == "trial":   # S545 KNOWBUILD1: a trial by the day signs through its own path (the read, the season)
		return load("res://scripts/state/ProspectWire.gd").sign(c, id)
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
	c.add_news("%s signs for %s on the gym stipend." % [f["name"], c.gym_name])
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

## Whether the boxer is at the line for an offer now: 7 wins and a regional top 3, or 9 wins; a national finalist is
## called whatever the record (S543 v17: no declines move it; a "Not yet" waits ProStart.NOT_YET_WEEKS, see check_pro).
static func pro_ready(f: Dictionary) -> bool:
	if bool(f.get("pro", false)):
		return false
	if bool(f.get("nat_final", false)):
		return true   # S328 a national finalist: the promoters call whatever the record
	var w := int(f["w"])
	var ranked := int(f.get("rank", 0)) > 0 and int(f.get("rank", 0)) <= PRO_RANK
	return (w >= PRO_WINS and ranked) or w >= PRO_WINS_ANY_RANK


## Checked after bouts and at the week's end: the promoter calls when a boxer is at the line (and four weeks after a
## Not yet); with no patience mark left the call is a rival gym's (ProStart.can_wait). Not during a nationals run.
static func check_pro(c: Career) -> void:
	if not c.pro_offer.is_empty():
		return
	for f in c.fighters:
		if pro_ready(f) and c.day >= int(f.get("pro_back", 0)) and (f["bout"] as Dictionary).is_empty() and not Champs.active(f):
			var o := ProOfferWire.make(c, f, titles(f), {"promoter": PROMOTER, "purse": PRO_PURSE, "step": PRO_PURSE_STEP, "top": PRO_PURSE_TOP})
			if o.is_empty():
				continue
			c.pro_offer = o
			if bool(o["rival"]):
				c.add_news("A rival gym wants %s: turn pro now, or the boxer leaves for good." % f["name"], true, true)
			else:
				c.add_news(words("pro_offer", {"her": f["name"], "promoter": PROMOTER, "purse": GameMoney.text(PRO_PURSE)}, c.day))
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
	return ProDebut.night(ProOfferWire.forecast(c, f, titles(f)), float(f["bout"].get("terms", 1.0)))


static func debut_words(f: Dictionary, t: Dictionary) -> String:
	if int(t["above"]) == 0:
		return "%s sold %d of %d debut tickets - not past the promoter's %d, so the debut paid nothing. More members, more tickets." % [
			f["first"], int(t["sold"]), ProDebut.TICKETS, ProDebut.BREAK_EVEN]
	return "%s sold %d debut tickets, %d past the promoter's %d: the fighter's share %s, the gym's %s of it." % [f["first"], int(t["sold"]),
		int(t["above"]), ProDebut.BREAK_EVEN, GameMoney.text(int(t["share"])), GameMoney.text(int(t["gym"]))]


## The boxer signs pro: the stipend and the amateur career end; the debut is pro fight 1 of six, picked on Fights from
## two bouts (ProPair: the promoter's tune-up or a step up), PRO_DEBUT_WEEKS after signing. S543 v17: one promoter.
static func turn_pro(c: Career, _house := "") -> Dictionary:
	var o := c.pro_offer
	if o.is_empty():   # S491: a second TURN PRO press (or a stale modal) after the offer was taken crashed here
		return {}
	var f := c.fighter_by_id(str(o["fid"]))
	if f.is_empty():
		c.pro_offer = {}
		return {}
	# S329 update 31: the gym pays the licence and brain scans (and the trainer's licence) now.
	var sheet := debut_sheet(c, f, 1.0)
	ProOfferWire.apply_morale(f, false, bool(Champs.check(c, f).get("ok", false)))
	if int(sheet["costs"]) > 0:
		c.pay(-int(sheet["costs"]), "BBBofC licence and brain scans: %s" % f["first"])
	f["licensed"] = true
	if not c.coach.is_empty():
		c.coach["pro_licence"] = true
	f["pro"] = true
	# S485 CLUBWEEK1 (his Q-244 "Yes"): under 50 loyalty an outside manager signs the boxer; the club keeps the trainer's 10%.
	if Loyalty.pro_share(f) < share_of(f):
		f["gym_share"] = Loyalty.pro_share(f)
		c.add_news("An outside manager signs %s: the gym keeps only the trainer's %d%%." % [f["first"], int(round(Loyalty.pro_share(f) * 100))])
	Loyalty.apply(f, "turn_pro", c.day)   # S486 LOYALHOOKS1: after the share is set (the share reads loyalty before it)
	f["promoter"] = PROMOTER
	f["pro_signed"] = {"d": c.day, "house": PROMOTER, "key": "", "stipend": int(f.get("weekly_salary", 0)), "costs": int(sheet["costs"])}   # S524 M11
	f["purse"] = int(o.get("purse", PRO_PURSE))
	f["purse_step"] = int(o.get("step", PRO_PURSE_STEP))
	f["purse_top"] = int(o.get("top", PRO_PURSE_TOP))
	f["pro_w"] = 0
	f["pro_l"] = 0
	f["weekly_salary"] = 0
	for x in f["offers"]:
		x["answered"] = true
	ProPair.state(f)
	f["pro_due"] = debut_day(c.day)
	f["pro_pair"] = ProPair.make(c, f, 1, int(f["purse"]))
	c.add_news("%s turns pro with %s." % [f["name"], PROMOTER])
	c.add_news("%s's debut is on %s: pick the promoter's tune-up or a step up on Fights." % [f["first"], Clock.fmt(int(f["pro_due"]))])
	c.pro_offer = {}
	return f


## The Saturday PRO_DEBUT_WEEKS weeks out.
static func debut_day(day: int, weeks := PRO_DEBUT_WEEKS) -> int:
	return day - posmod(day, 7) + 5 + weeks * 7


## "Not yet" (S543 v17): the boxer stays amateur for now - a patience mark and 15 hunger (ProStart.not_yet); the offer
## returns NOT_YET_WEEKS later. No morale, no loyalty, no line moved. Nothing on a rival gym's call (refuse_rival).
static func decline_pro(c: Career) -> void:
	if not c.pro_offer.has("fid") or bool(c.pro_offer.get("rival", false)):
		return   # S525 PROCONTRACT1: no offer on the table, nothing to decline
	var f := c.fighter_by_id(str(c.pro_offer["fid"]))
	if f.is_empty() or not ProStart.not_yet(ProPair.state(f)):
		return
	f["pro_back"] = c.day + ProStart.NOT_YET_WEEKS * 7
	var last := "" if ProStart.can_wait(f["pro_start"]) else " That was the last Not yet: next time a rival gym calls."
	c.add_news("%s stays amateur for now; the promoter calls again in %d weeks.%s" % [f["first"], ProStart.NOT_YET_WEEKS, last])
	c.pro_offer = {}


## The rival gym's call refused ("Let the boxer go"): the boxer leaves the club for good, through the game's leaving path.
static func refuse_rival(c: Career) -> void:
	if not bool(c.pro_offer.get("rival", false)):
		return
	var fid := str(c.pro_offer["fid"])
	c.pro_offer = {}
	load("res://scripts/state/Leaving.gd").leave(c, fid, "rival_gym")
