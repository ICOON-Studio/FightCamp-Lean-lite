extends RefCounted
## S397 money bites (ops/research/MONEY_BITES_S397.md 7.1): what the gym spends on, as career state - upgrades, premises,
## staff roles, the kit budget, the youth section and its intakes, club shows, pros' contract talks and camp bills.
## The rules are pure modules (GymUpgrades, StaffRoles, ClubShow, StarDeal); this file applies them to the Career and is
## read by Sim (weekly lines, gains), Injuries (risk, days out), Membership (the cap) and Roster (places).

const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const ClubShow := preload("res://scripts/rules/ClubShow.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymKinds := preload("res://scripts/rules/GymKinds.gd")
const StarDeal := preload("res://scripts/rules/StarDeal.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const HomeJuniors := preload("res://scripts/state/HomeJuniors.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const Grants := preload("res://scripts/rules/Grants.gd")

const KIT := GymBills.KIT_BUDGET
const KIT_ORDER := GymBills.KIT_ORDER
## The youth section: 20 juniors at $25 a month (real GBP 20-43); the juniors' coach 6 h at $28.
const JUNIORS := 20
const JUNIOR_FEE_MONTH := 25
const JUNIORS_COACH := 168
## Coach education and safeguarding renewals, a year for each coach on the books (real: a Level 2 badge GBP 300-500), paid
## in the year's week 26 (S397 designer pass).
const COACH_COURSE := 400
const DAY_JOB_GAIN := 0.85
const COURSE_WEEK := 26
## GYMKIND1: each kind of kit builds something. Off for players (the operator has not approved the rule); the bots test
## switches it on to measure what each kind is worth.
static var kit_gain_on := false


static func kit(c: Career) -> Dictionary:
	return KIT.get(c.kit_level, KIT["standard"])


static func premises(c: Career) -> Dictionary:
	return GymUpgrades.premises(c.premises)


static func youth_on(c: Career) -> bool:
	return GymUpgrades.ready(c.upgrades, "youth", c.day)


static func fitness_on(c: Career) -> bool:
	return GymUpgrades.ready(c.upgrades, "fitkit", c.day) and c.staff_roles.has("assistant")


## ---------- the week's money ----------

## The spending lines a week: {upgrades (their upkeep), staff_roles, kit, juniors_coach, total}.
static func costs(c: Career) -> Dictionary:
	var out := {"upgrades": GymUpgrades.upkeep(c.upgrades),
		"staff_roles": StaffRoles.wages(c.staff_roles) + StaffRoles.EVENING_WAGE * c.extra_coaches, "kit": int(kit(c)["week"]),
		"juniors_coach": JUNIORS_COACH if youth_on(c) else 0}
	out["total"] = int(out["upgrades"]) + int(out["staff_roles"]) + int(out["kit"]) + int(out["juniors_coach"])
	return out


## The income lines a week: {fitness, juniors, total}.
static func income(c: Career) -> Dictionary:
	var out := {"fitness": int(GymUpgrades.item("fitkit")["value"]) if fitness_on(c) else 0,
		"juniors": juniors_dues() if youth_on(c) else 0}
	out["total"] = int(out["fitness"]) + int(out["juniors"])
	return out


static func juniors_dues() -> int:
	return roundi(float(JUNIORS * JUNIOR_FEE_MONTH) / GymBills.WEEKS_A_MONTH)


## ---------- what the spending does ----------

## Training injury risk: the floor, the S&C coach and the kit budget; every cut together stops at StaffRoles.RISK_FLOOR.
static func train_risk(c: Career) -> float:
	var m := GymUpgrades.mult(c.upgrades, "train_risk", c.day) * (StaffRoles.STRENGTH_RISK if c.staff_roles.has("strength") else 1.0)
	m *= float(kit(c)["risk"])
	return maxf(m, StaffRoles.RISK_FLOOR) if m < 1.0 else m


static func days_out(c: Career) -> float:
	return (StaffRoles.PHYSIO_DAYS if c.staff_roles.has("physio") else 1.0) * GymBonus.days_out(c.gym_plan)


static func gain(c: Career, stat: String, f: Dictionary = {}) -> float:
	var m := GymUpgrades.gain_mult(c.upgrades, stat, c.day) * (DAY_JOB_GAIN if bool(f.get("day_job", false)) else 1.0) * GymBonus.training(c.gym_plan, stat)
	if kit_gain_on:
		m *= GymKinds.gain_mult(c.gym_slots, c.day, stat)
	return m


## ---------- stipends (STRUCTURE_DESIGN_S395 5.3b: "most fighters cost little; a stipend is a special deal") ----------
## An amateur on the club stipend trains full time; one with a day job pays nothing and trains evenings, gaining less.
## Real: most amateurs work or study; a stipend lets one or two top prospects train full time (round 1, club owner).
## GAME value: evenings-only gains 15% less.

static func set_stipend(c: Career, f: Dictionary, on: bool) -> String:
	if bool(f.get("pro", false)):
		return "a pro lives on purses"
	if on == not bool(f.get("day_job", false)):
		return "already so"
	f["day_job"] = not on
	var home := bool(f.get("home", false)) and int(f.get("home_until", 0)) > c.day
	f["weekly_salary"] = (roundi(GameMoney.FIGHTER_STIPEND * HomeJuniors.HALF) if home else GameMoney.FIGHTER_STIPEND) if on else 0
	c.add_news("%s %s." % [f["first"], "is back on the club stipend and trains full time" if on else "takes a day job: off the stipend, training evenings"])
	return ""


## The members the gym holds: the premises' room, what its coaches can carry or what its floor has places for, the smallest (the
## kit budget moves it a little). S397 round 2: growth brings its own wage bill. S415: and its own equipment.
static func member_cap(c: Career) -> int:
	return mini(mini(int(premises(c)["cap"]) - GymUpgrades.room(c.upgrades), coaching_cap(c)), GymSlots.member_room(c.gym_slots, c.day)) + int(kit(c)["members"])


## S415 buys one piece on the picture: paid now, standing and counted once the fitters have had their week.
static func buy_slot(c: Career, id: String) -> String:
	var why := GymSlots.blocked(id, c.gym_slots, c.cash)
	if why != "":
		return why
	var s := GymSlots.item(id)
	c.pay(-int(s["price"]), "Equipment: %s" % str(s["name"]).to_lower())
	c.gym_slots.append({"id": id, "day": c.day})
	c.add_news("Fitters are in: %s, ready on %s." % [str(s["name"]).to_lower(), Clock.fmt(c.day + GymSlots.FIT_DAYS)])
	return ""


## Where the member count is heading: what the gym's name and dues draw, held to the room (Membership.settle_week's target).
static func member_target(c: Career) -> int:
	return mini(Membership.natural_members(c.reputation, c.dues_band), member_cap(c))


static func coaching_cap(c: Career) -> int:
	return StaffRoles.coaching_cap(not c.coach.is_empty(), c.staff_roles, c.extra_coaches)


## What holds the members back now: "premises", "coaches", "equipment" or "" (room to grow).
static func member_limit(c: Career) -> String:
	if c.members < member_cap(c) - 2:
		return ""
	var building := int(premises(c)["cap"]) - GymUpgrades.room(c.upgrades)
	if GymSlots.member_room(c.gym_slots, c.day) < mini(building, coaching_cap(c)):
		return "equipment"
	return "coaches" if coaching_cap(c) < building else "premises"


static func places(c: Career) -> int:
	return int(premises(c)["places"]) + StaffRoles.places(c.staff_roles)


static func used(c: Career) -> int:
	return c.fighters.size() + c.grapplers.size()


## "" when a place is free, else what opens one.
static func place_blocked(c: Career) -> String:
	if used(c) < places(c):
		return ""
	if not c.staff_roles.has("assistant"):
		return "every place is taken: a second club coach opens one"
	if c.premises < GymUpgrades.PREMISES.size() - 1:
		return "every place is taken: bigger premises open two"
	return "every place is taken"


## ---------- the player's moves ----------

static func buy(c: Career, id: String) -> String:
	var why := GymUpgrades.blocked(id, c.upgrades, c.cash)
	if why != "":
		return why
	var u := GymUpgrades.item(id)
	c.pay(-int(u["price"]), "Upgrade: %s" % str(u["name"]).to_lower())
	c.upgrades.append({"id": id, "day": c.day})
	c.add_news("Fitters are in: %s, ready on %s." % [str(u["name"]).to_lower(), Clock.fmt(c.day + GymUpgrades.FIT_DAYS)])
	return ""


static func move(c: Career) -> String:
	var why := GymUpgrades.move_blocked(c.premises, c.cash)
	if why != "":
		return why
	var next := GymUpgrades.premises(c.premises + 1)
	c.pay(-int(next["move"]), "Moving premises: %s" % str(next["name"]).to_lower())
	c.premises += 1
	var sp: Dictionary = GymUpgrades.SPONSORS[c.premises]
	if not sp.is_empty() and not c.deals.any(func(d): return str(d["id"]) == str(sp["id"])):
		c.deals.append(sp.merged({"state": "offer"}))
		c.add_news("%s wants a deal with a club this size: %s a week for %s (Money > Deals)." % [sp["name"], GameMoney.text(int(sp["per"])), sp["what"]])
	c.add_news("%s moves into a %s: room for %d members, rent %s a month." % [c.gym_name, str(next["name"]).to_lower(),
		int(next["cap"]), GameMoney.text(int(next["rent"]))])
	return ""


static func hire(c: Career, id: String) -> String:
	if StaffRoles.role(id).is_empty() or c.staff_roles.has(id):
		return "already on the staff"
	c.staff_roles.append(id)
	c.add_news("%s joins the staff." % StaffRoles.role(id)["name"])
	return ""


static func let_go(c: Career, id: String) -> String:
	if not c.staff_roles.has(id):
		return "not on the staff"
	var notice := StaffRoles.notice(id)
	if notice > 0:
		c.pay(-notice, "A week's notice: %s" % str(StaffRoles.role(id)["name"]).to_lower())
	c.staff_roles.erase(id)
	return ""


static func set_kit(c: Career, level: String) -> void:
	if KIT.has(level):
		c.kit_level = level


## Calendar month, the same one GymBills.week reads off the clock. A new month starts on the first week
## whose date falls in a different month from the week before.
static func _dues_month(c: Career) -> bool:
	if c.day < 7:
		return false
	return _month_index(c.day) != _month_index(c.day - 7)


static func _month_index(day: int) -> int:
	var d := Clock._date(day)
	return int(d["year"]) * 12 + int(d["month"])


static func set_dues(c: Career, band: String) -> void:
	if not Membership.DUES.has(band):
		return
	if c.dues_band == band:
		c.dues_band_next = ""
		return
	# end_week calls this once the month has turned and the pending band is already stored.
	if c.dues_band_next == band and _dues_month(c):
		c.dues_band = band
		c.dues_band_next = ""
		c.add_news("Dues are now %s a month (%s)." % [GameMoney.text(Membership.fee(band)), str(Membership.DUES[band]["name"]).to_lower()])
		return
	if c.dues_band_next == band:
		return
	c.dues_band_next = band
	c.add_news("%s dues, %s a month, from next month." % [str(Membership.DUES[band]["name"]), GameMoney.text(Membership.fee(band))])


## An evening coach more (+1) or fewer (-1); letting one go costs a week's pay.
static func evening_coach(c: Career, delta: int) -> String:
	if delta > 0:
		c.extra_coaches += 1
		c.add_news("An evening coach joins: room for %d more members." % StaffRoles.COACH_MEMBERS)
		return ""
	if c.extra_coaches <= 0:
		return "no evening coach to let go"
	c.pay(-StaffRoles.EVENING_WAGE, "A week's notice: an evening coach")
	c.extra_coaches -= 1
	return ""


## ---------- club shows ----------

static func home_boxers(c: Career) -> int:
	return c.fighters.filter(func(f): return not bool(f.get("pro", false)) and (f.get("injury", {}) as Dictionary).is_empty()).size()


static func show_preview(c: Career) -> Dictionary:
	return ClubShow.preview(c.members, c.reputation, JUNIORS if youth_on(c) else 0, home_boxers(c), GymBonus.show(c.gym_plan))


static func book_show(c: Career) -> String:
	if not ClubShow.can_book(c.day, int(c.show.get("day", -1)), int(c.show.get("last", -1))):
		return "one show at a time, %d weeks apart" % (ClubShow.EVERY_DAYS / 7)
	if c.cash < ClubShow.COST:
		return "$%d short of the price" % (ClubShow.COST - c.cash)
	c.pay(-ClubShow.COST, "Club show: hall, officials, doctor and ambulance, trophies")
	c.show["day"] = ClubShow.show_day(c.day)
	c.add_news("%s's club show is booked for %s. Tickets go on sale at the desk." % [c.gym_name, Clock.fmt(int(c.show["day"]))])
	return ""


static func day_events(c: Career) -> void:
	grant_day(c)
	if int(c.show.get("day", -1)) != c.day:
		return
	var rng := RandomNumberGenerator.new()
	rng.seed = c.seed * 31 + c.day
	var n := ClubShow.night(c.members, c.reputation, JUNIORS if youth_on(c) else 0, home_boxers(c),
		rng.randf_range(ClubShow.LUCK.x, ClubShow.LUCK.y) * GymBonus.show(c.gym_plan), rng.randi_range(ClubShow.RAFFLE.x, ClubShow.RAFFLE.y))
	c.pay(int(n["tickets"]) + int(n["raffle"]), "Club show: %d tickets and the raffle" % int(n["sold"]))
	c.members += int(n["members"])
	c.show = {"day": -1, "last": c.day, "night": n}
	var net := int(n["net"])
	c.add_news("Club show night: %d sold, the raffle %s. %s" % [int(n["sold"]), GameMoney.text(int(n["raffle"])),
		("The night made %s after the hall, and %d new members signed up." % [GameMoney.text(net), int(n["members"])]) if net > 0
		else "A thin crowd: the night lost %s." % GameMoney.text(-net)])


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


## ---------- the week's end ----------

## ---------- grants (round 2, both critics: Sport England-style small grants, applied for, with conditions) ----------

static func grant_bid(c: Career) -> String:
	var why := Grants.blocked(c.day, c.grant, youth_on(c), c.staff_roles.has("assistant") or c.extra_coaches > 0)
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


static func end_week(c: Career) -> void:
	HomeJuniors.end_week(c, youth_on(c), c.staff_roles.has("assistant"))
	var coaches := (0 if c.coach.is_empty() else 1) + (1 if c.staff_roles.has("assistant") else 0)
	if coaches > 0 and HomeJuniors.week_of_year(c.day - 1) == COURSE_WEEK:
		c.pay(-COACH_COURSE * coaches, "Coach education and safeguarding renewals: %d coach%s" % [coaches, "" if coaches == 1 else "es"])
	for f in c.fighters:
		if ProLadder.on_ladder(c, f):
			var e := ProLadder.entry(c, f)
			check_talks(c, f, int(e.get("rank", 0)), str(e.get("belt", "")))
		var talks: Dictionary = f.get("talks", {})
		if not talks.is_empty() and c.day >= int(talks["until"]):
			answer_talks(c, f, false)
	if c.dues_band_next != "" and _dues_month(c):
		set_dues(c, str(c.dues_band_next))
