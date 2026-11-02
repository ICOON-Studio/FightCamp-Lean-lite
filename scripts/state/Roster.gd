extends RefCounted
## Growing the roster and the end of the amateur arc: scouting trials (invite a prospect, watch her trial on the Monday,
## sign her or pass) and turning pro (a promoter's offer at the line, a contract, the pro debut).
## Turning-pro line and terms: Kalli K-PROLINE1 (Godot/research/K_PROLINE1_KALLI.md in the old repo), game-tuned, not
## measured against real purse data. S329 update 31 (John J-PRODEBUT1, measured): the debut is a small-hall show - the gym
## pays her BBBofC licence and brain scans when she signs, she sells tickets, and the debut pays her half of what she sells
## above the promoter's break-even (ProDebut); the flat purse starts from her second pro bout.

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
const PRO_OPP_NAMES := ["Kayleigh Doran", "Stacey Mills", "Jodie Kerr", "Paige Whitlow"]

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
	if p.is_empty() or str(p["state"]) != "scout":
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
	p["state"] = "signed"
	return sign_fighter(c, raw, picks)


## Signs a fighter (the walk-in, or a prospect after her trial) on the club stipend with her signing goal.
static func sign_fighter(c: Career, raw: Dictionary, picks: Array) -> Dictionary:
	var f := Data.fighter_state(raw.duplicate(true), c.day)
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
	f["registered"] = registered_day(f, c.day)   # S331 the nationals need 3 months REGISTERED (England Boxing), not with us
	var bouts: int = int(f.get("w", 0)) + int(f.get("l", 0)) + int(f.get("d", 0))
	f["goal"] = FighterGoal.goal_for(f, SIGNING_GOAL if bouts == 0 else SIGNING_GOAL_CARDED, c.day)
	c.fighters.append(f)
	c.add_news("%s signs for %s on the club stipend." % [f["name"], c.gym_name])
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
		return
	for f in c.fighters:
		if pro_ready(f) and (f["bout"] as Dictionary).is_empty() and not Champs.active(f):
			var declines := int(f.get("pro_declines", 0))
			var terms := 1.0 if declines == 0 else PRO_SECOND_TERMS
			var purse := int(round(PRO_PURSE * terms))
			c.pro_offer = {"fid": f["id"], "promoter": PROMOTERS[mini(declines, 1)], "purse": purse, "terms": terms,
				"step": int(round(PRO_PURSE_STEP * terms)), "top": int(round(PRO_PURSE_TOP * terms))}
			c.add_news(words("pro_offer", {"her": f["name"], "promoter": c.pro_offer["promoter"], "purse": GameMoney.text(purse)}, c.day))
			return


## The gym's cut of a pro purse.
static func gym_cut(purse: int) -> int:
	return int(round(purse * GYM_SHARE))


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
	return ProDebut.night(ProDebut.tickets_sold(c.members, int(f["w"]), titles(f)), float(f["bout"].get("terms", 1.0)))


static func debut_words(f: Dictionary, t: Dictionary) -> String:
	if int(t["above"]) == 0:
		return "%s sold %d of %d debut tickets - not past the promoter's %d, so the debut paid nothing. More members, more tickets." % [
			f["first"], int(t["sold"]), ProDebut.TICKETS, ProDebut.BREAK_EVEN]
	return "%s sold %d debut tickets, %d past the promoter's %d: the fighter's share %s, the gym's %s of it." % [f["first"], int(t["sold"]),
		int(t["above"]), ProDebut.BREAK_EVEN, GameMoney.text(int(t["share"])), GameMoney.text(int(t["gym"]))]


## She signs pro: the stipend and the amateur career end, the debut is booked.
static func turn_pro(c: Career) -> Dictionary:
	var o := c.pro_offer
	var f := c.fighter_by_id(str(o["fid"]))
	# S329 update 31: the gym pays her licence and brain scans (and the trainer's licence) now.
	var sheet := debut_sheet(c, f, float(o["terms"]))
	if int(sheet["costs"]) > 0:
		c.pay(-int(sheet["costs"]), "BBBofC licence and brain scans: %s" % f["first"])
	f["licensed"] = true
	if not c.coach.is_empty():
		c.coach["pro_licence"] = true
	f["pro"] = true
	f["promoter"] = o["promoter"]
	f["purse"] = int(o["purse"])
	f["purse_step"] = int(o["step"])
	f["purse_top"] = int(o["top"])
	f["pro_w"] = 0
	f["pro_l"] = 0
	f["weekly_salary"] = 0
	for x in f["offers"]:
		x["answered"] = true
	var opp_name: String = PRO_OPP_NAMES[posmod(c.day, PRO_OPP_NAMES.size())]
	var night := BoutRules.fight_power(f["stats"], {}, 1, "")
	var opp := {"name": opp_name, "first": opp_name.split(" ")[0], "club": "%s stable" % o["promoter"], "age": 24,
		"stance": "orthodox", "style": "Boxer-puncher", "w": 0, "l": 0, "rating": snappedf(night - PRO_OPP_GAP, 0.1),
		"threat": "Heavy right hand", "weak": "Fades after round 3", "div": f["div"], "pro": true}
	f["bout"] = {"opp": opp, "day": debut_day(c.day), "weighed": false, "made": false, "done": false,
		"film": BoutRules.FILM_DEPTH_DEFAULT, "pro": true, "rounds": PRO_ROUNDS, "purse": int(o["purse"]),
		"tickets": true, "terms": float(o["terms"])}
	f["booked_fight"] = true
	c.add_news("%s turns pro with %s." % [f["name"], o["promoter"]])
	c.add_news(words("pro_debut", {"her": f["name"], "opp": opp_name}, c.day + 1))
	c.pro_offer = {}
	return f


## The Saturday PRO_DEBUT_WEEKS weeks out.
static func debut_day(day: int) -> int:
	return day - posmod(day, 7) + 5 + PRO_DEBUT_WEEKS * 7


## She stays amateur for now: the offer returns after more wins; the second time the other promoter calls.
static func decline_pro(c: Career) -> void:
	var f := c.fighter_by_id(str(c.pro_offer["fid"]))
	f["pro_declines"] = int(f.get("pro_declines", 0)) + 1
	c.add_news("%s stays amateur for now. %s" % [f["first"],
		"The door is closed until she is number 1." if int(f["pro_declines"]) >= 3 else "The promoters will be back after more wins."])
	c.pro_offer = {}
