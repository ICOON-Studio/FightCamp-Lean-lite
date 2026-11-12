extends RefCounted
## What happens in a day and at a week's end, and the player's roster moves (sign, hire, plan).

const Attrs := preload("res://scripts/rules/Attrs.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Data := preload("res://scripts/state/Data.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const Region := preload("res://scripts/state/Region.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")
const TrainingPlan := preload("res://scripts/rules/TrainingPlan.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekCause := preload("res://scripts/rules/WeekCause.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")
const TestDay := preload("res://scripts/rules/TestDay.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekActual := preload("res://scripts/rules/WeekActual.gd")
const PerkRoad := preload("res://scripts/rules/PerkRoad.gd")
const Overdraft := preload("res://scripts/rules/Overdraft.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const PushBack := preload("res://scripts/rules/PushBack.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")   # S382 PADWEEK1: the week's drilling, night by night (PadWeek)
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const WeekRead := preload("res://scripts/rules/WeekRead.gd")   # S387 MENUREVIEW1: what the week really did, for the report
const ProLadder := preload("res://scripts/state/ProLadder.gd")
## S397 rank 5: the head coach's edge, the start's rent and loan, the first hour's quiet weeks.
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")

## Without a coach training runs at 60%: the coach factor 0.5 + r x 0.7 equals 0.6 at this rating.
const NO_COACH_RATING := 100.0 / 7.0
const STAT_CAP := 99.0
static func coach_rating(career: Career) -> float:
	return float(career.coach.get("rating", NO_COACH_RATING)) if not career.coach.is_empty() else NO_COACH_RATING

## The stat her week trains most: her camp's focus while she is in camp, else her plan's.
static func focus_of(_career: Career, f: Dictionary) -> String:
	var camp: Dictionary = f.get("camp", {})
	return str(camp["focus"]) if not camp.is_empty() else str(f["focus"])
## S356 Monday: the twist card's answer is locked (the coach's call when none) and its once-effects land: cash, morale,
## reputation, members, the old coach's note (1 in 3 an old habit costs technique), the lefty edge and the hot head for her bout.
static func twist_monday(career: Career, f: Dictionary) -> void:
	var once := WeekTwist.lock(f)
	var t := WeekTwist.active(f)
	# (No news line for the answer: the Training tab and the review show it - S355 a weekly line flooded Mail.)
	if once.has("cash"):
		career.pay(int(once["cash"]), "%s: %s" % [str(t["name"]), str(t["label"])])
	if once.has("morale"):
		FighterProfile.apply_morale(f, str(once["morale"]), str(t["name"]))
	if once.has("rep"):
		career.reputation = maxi(0, career.reputation + int(once["rep"]))
	if once.has("members"):
		career.members += int(once["members"])
	if bool(once.get("reveal", false)):
		Bouts.coach_note(career, f, "sparring")
		var rng := RandomNumberGenerator.new()
		rng.seed = career.seed + career.day * 13 + 7
		if rng.randf() < 1.0 / 3.0:
			f["stats"]["technique"] = maxf(0.0, float(f["stats"]["technique"]) - 0.5)
			career.add_news("%s slips back into an old habit: technique -0.5." % f["first"])
	var b: Dictionary = f.get("bout", {})
	if not b.is_empty() and not bool(b.get("done", false)):
		for k in ["lefty", "hot"]:
			if bool(once.get(k, false)):
				b[k] = true
	# S357 the short-notice swap: take the tougher opponent, or withdraw and end the camp.
	if bool(once.get("swap_opp", false)):
		Bouts.short_notice(career, f)
	elif bool(once.get("withdraw", false)):
		Bouts.withdraw_bout(career, f)


## What her coming week holds for the twist cards' needs: a booked bout, a cut, a combo on the pads, a southpaw opponent, a
## short-notice swap (S357: an amateur bout 2+ weeks out with a tougher opponent to send - needs the career).
static func twist_needs(f: Dictionary, career: Career = null) -> Array:
	var out: Array = []
	var b: Dictionary = f.get("bout", {})
	if not b.is_empty() and not bool(b.get("done", false)):
		out.append("bout")
		if str((b.get("opp", {}) as Dictionary).get("stance", "")).to_lower() == "southpaw":
			out.append("southpaw")
		if career != null and Bouts.can_swap(career, f):
			out.append("swap")
	if float(f["weight"]) > float(f["limit"]) - 0.15 and (str(f["diet"]) == "cut" or not (f["camp"] as Dictionary).is_empty()):
		out.append("cut")
	if str(f.get("combo_learning", "")) != "":
		out.append("combo")
	return out


## S351 her week's plan (TrainingPlan: blocks per session): the one she has set, else the coach's week for her focus. In
## camp the camp writes the week (its focus as the main session).
static func plan_of(career: Career, f: Dictionary) -> Dictionary:
	var focus := focus_of(career, f)
	var partner := str(TrainingPreview.PARTNER.get(focus, ""))
	if not (f.get("camp", {}) as Dictionary).is_empty():
		return TrainingPlan.default_plan(focus, partner)
	return TrainingPlan.plan_of(f.get("week_plan"), focus, partner)

## The day's morning and evening: stat gains, weight and fatigue. CUT while over the limit, else HOLD.
static func week_ctx(career: Career, f: Dictionary) -> Dictionary:
	var cutting := (str(f["diet"]) == "cut" or not (f["camp"] as Dictionary).is_empty()) and float(f["weight"]) > float(f["limit"]) - 0.15
	var ev := BoutRules.camp_evening(f.get("camp", {}))   # S380: the protocol sets the camp's evenings
	return {"stats": f["stats"], "pot": int(f["pot"]), "coach": career.coach.duplicate(true), "weight": float(f["weight"]),
		"diet": "cut" if cutting else "hold", "fatigue": float(f.get("week_fatigue", 20.0)), "phase": str(f.get("phase", "base")),
		"recovery": float(Attrs.of(f).get("recovery", 55.0)),
		"twist_kg": float(WeekTwist.active(f).get("kg_day", 0.0)), "twist_fat": float(WeekTwist.active(f).get("fat_day", 0.0)),
		"camp_stat": str(ev["stat"]), "eve_drill": float(ev["drill"]), "eve_load": float(ev["load"]), "camp_on": PadWeek.in_camp(f),
		"camp_mult": BoutRules.camp_gain_mult(f.get("camp", {}), str(ev["stat"]))}.merged(HeadCoach.ctx(career.head))


## S373 (Danny 61.6 kg missed 60.0 on his first offer, ~17 days out, with no warning on the offer): her weight on the
## weigh-in morning if she takes a bout on `bout_day` and cuts in camp from tomorrow - a dry run of the same days the real
## ones step (the coach's phase weeks, the cut while over, the fight-week drop). {now, day, limit, ok, over, days}.
static func weigh_forecast(career: Career, f: Dictionary, bout_day: int) -> Dictionary:
	var g := f.duplicate(true)
	g["bout"] = {"day": bout_day, "done": false}
	if (g.get("camp", {}) as Dictionary).is_empty():
		g["camp"] = {"focus": focus_of(career, f)}   # a camp cuts while she is over the limit (week_ctx)
	var lim := float(f["limit"])
	var n := maxi(0, bout_day - 1 - career.day)   # the weigh-in is the day before the bout
	WeekPhase.sync(g, career.day)   # as Bouts.accept does; after that the phase moves on Mondays (step_day)
	for i in n:
		var d := career.day + i
		var dow := posmod(d, 7)
		if dow == 0:
			WeekPhase.sync(g, d)
			g.erase("twist")   # next week's card is not drawn yet
		var tw := WeekTwist.active(g)
		var days := WeekTwist.days(tw, WeekPlan.days_of(g))
		var r := WeekPlan.full_day(str((days[dow] as Array)[0]), str((days[dow] as Array)[1]),
			str(PadWeek.evenings(g)[dow]), week_ctx(career, g), float(g.get("week_fatigue", 20.0)))
		var lo := minf(float(g["weight"]), lim - 1.5)
		var hi := maxf(float(g["weight"]), lim + 1.6)
		g["weight"] = clampf(float(g["weight"]) + float(r["kg"]), lo, hi)
		g["week_fatigue"] = float(r["fatigue"])
	var day_kg := float(g["weight"])
	return {"now": float(f["weight"]), "day": day_kg, "limit": lim, "ok": BoutRules.made_weight(day_kg, lim),
		"over": maxf(0.0, day_kg - lim), "days": n}


## {stat: points a day} averaged over her week (the old seven); a camp multiplies its focus by the protocol. goal_keys (a
## goal's read, S433 CARDIO1): each ability's own pace laid over them, so speed and fight_iq read the ability, never the old stat.
static func daily_gain(career: Career, f: Dictionary, goal_keys := false) -> Dictionary:
	var ctx := week_ctx(career, f)
	var w := WeekPlan.week(WeekTwist.days(WeekTwist.active(f), WeekPlan.days_of(f)), ctx, PadWeek.evenings(f))
	var out: Dictionary = {}
	for key in f["stats"].keys():
		# S396 truth pass: WeekPlan.week already takes the camp multiplier (S380); a second one here counted the camp twice.
		out[key] = float((w["gains"] as Dictionary).get(key, 0.0)) / 7.0
	return out.merged(Attrs.week_rates(f, w["days"], str(ctx.get("camp_stat", "")), float(ctx.get("camp_mult", 1.0))), true) if goal_keys else out


static func step_day(career: Career) -> void:
	for f in career.fighters:
		var mult := Injuries.gain_mult(career, f)   # S325 an injured fighter trains at the rest week's share
		var dow := posmod(career.day, 7)   # day 0 is a Monday (Clock)
		var resting := Injuries.out(career, f)
		# S355 CORE3 step 2: the week's twist card changes the week she runs; Monday keeps what the plan says it will do
		# (WeekActual), and a day that runs other than planned goes on the log the week review reads.
		# S356 the camp's phase writes the week on Monday (WeekPhase; a new phase drops last week's exceptions).
		if dow == 0 or not f.has("phase") or not f.has("phase_day"):   # S382 phase_day: a save from before it
			WeekPhase.sync(f, career.day)
		if dow == 0:
			twist_monday(career, f)
		var tw := WeekTwist.active(f)
		var days := WeekTwist.days(tw, WeekPlan.days_of(f))
		var evs := PadWeek.evenings(f)   # S382 EVENINGS1: the strip's nights; an evening drawn REST rests
		DrillWeek.note(career, f, dow)   # S382 PLANTRAY1 review: Sunday drills what this evening carried
		if dow == 0:
			f["week_planned"] = WeekActual.snapshot(WeekPlan.week(days, week_ctx(career, f), evs), WeekPlan.days_of(f), float(f["weight"]), career.day)
			# S360 Q-S294-90: a camp week that starts with the opponent's line met is a week of preparation (WeekOpp).
			var ob: Dictionary = f.get("bout", {})
			if not (f.get("camp", {}) as Dictionary).is_empty() and not ob.is_empty() and not bool(ob.get("done", false)):
				WeekOpp.record(ob, days, str(f.get("phase", "base")))
			f["week_log"] = []
			f["week_src"] = {}   # S370 WeekCause: which sessions moved which stat this week
			f["week_peak"] = float(f.get("week_fatigue", 20.0))
		var planned_days: Array = (f.get("week_planned", {}) as Dictionary).get("days", [])
		if resting and str((days[dow] as Array)[0]) != "rest":
			(f.get_or_add("week_log", []) as Array).append(WeekActual.log_entry(dow, days[dow], ["rest", "normal"], "injured"))
		elif not resting and planned_days.size() == 7 and planned_days[dow] != WeekPlan.days_of(f)[dow]:
			(f.get_or_add("week_log", []) as Array).append(WeekActual.log_entry(dow, planned_days[dow], days[dow], "changed"))
		var m: Array = ["rest", "normal"] if resting else (days[dow] as Array)
		var r := WeekPlan.full_day(str(m[0]), str(m[1]), "rest" if resting else str(evs[dow]),
			week_ctx(career, f), float(f.get("week_fatigue", 20.0)))
		SkillAwards.count_session(f, str(r["evening"]))   # S370 GOALTESTS1: a coached evening toward her next award
		var by: Array = [str(WeekPlan.session(str(m[0]))["name"]), str((WeekPlan.EVENINGS.get(str(r["evening"]), {}) as Dictionary).get("name", ""))]
		for k in [["stat", "gain", 0], ["stat2", "gain2", 1]]:
			var st := str(r.get(k[0], ""))
			if st != "" and (f["stats"] as Dictionary).has(st):
				var was := float(f["stats"][st])
				var sid := str(m[0]) if int(k[2]) == 0 else str(r.get("evening", ""))
				var gain := minf(STAT_CAP - was, float(r[k[1]]) * BoutRules.camp_gain_mult(f.get("camp", {}), st) * mult * GymSpend.gain(career, st, f))
				Attrs.apply_session(f, sid, st, maxf(0.0, gain))
				WeekCause.add(f.get_or_add("week_src", {}), st, str(by[k[2]]), float(f["stats"][st]) - was, dow)
		if float(r.get("attr_gain", 0.0)) > 0.0:
			Attrs.apply_session(f, str(m[0]), "", float(r["attr_gain"]) * mult)
		var lo := minf(float(f["weight"]), float(f["limit"]) - 1.5)
		var hi := maxf(float(f["weight"]), float(f["limit"]) + 1.6)
		f["weight"] = clampf(float(f["weight"]) + float(r["kg"]), lo, hi)
		f["week_fatigue"] = float(r["fatigue"])
		f["week_peak"] = maxf(float(f.get("week_peak", 0.0)), float(r["fatigue"]))
		if not (f["camp"] as Dictionary).is_empty():
			f["camp"]["peak"] = maxf(float(f["camp"].get("peak", 0.0)), float(r["fatigue"]))
	career.day += 1
	Injuries.day_tick(career)
	Bouts.day_events(career)
	ProLadder.day_events(career)   # S397 the pro tables: a month of world bouts, her offers
	GymSpend.day_events(career)   # S397 money bites: a club show's night
	Region.day_events(career)
	if career.day % 7 == 0:
		end_week(career)
	Champs.day_events(career)   # S328 last: a pull-out from the week's injuries ends her championship run today


## S324: rent and the governing body's yearly fees (GymBills). The coach's sessional pay stays the staff line.
static func weekly_costs(career: Career) -> Dictionary:
	var staff: Array = [] if career.coach.is_empty() else [career.coach]
	var bills: Dictionary = GymBills.week(bills_setup(career))
	var out := GameMoney.weekly_costs(staff, career.fighters, int(bills["rent"]) + int(bills["fees"]))
	out["rent"] = int(bills["rent"])
	out["fees"] = int(bills["fees"])
	out["bjj"] = int(bjj_money(career)["coach"])
	# S397 money bites: heating and power by the season, insurance, and what the gym spends on (GymSpend.costs).
	out["power"] = int(bills["power"]) + int(bills["insurance"])
	var spend := GymSpend.costs(career)
	out.merge(spend)
	out["loan"] = int(ClubStart.loan(career.start)[0]) if career.loan_weeks > 0 else 0   # S397 the debt start's loan
	out["total"] = int(out["total"]) + int(out["bjj"]) + int(out["power"]) + int(spend["total"]) + int(out["loan"])
	return out


## S365 the BJJ classes' week (BjjSide.money): {dues, coach, net, members}; all 0 without a no-gi athlete.
static func bjj_money(career: Career) -> Dictionary:
	if not career.bjj_on():
		return {"dues": 0, "coach": 0, "net": 0, "members": 0}
	return BjjSide.money(career.bjj_side, career.bjj_teaches())


static func bills_setup(career: Career) -> Dictionary:
	return {"members": career.members, "coach_hours_week": 0.0, "coaches": 0 if career.coach.is_empty() else 1,
		"boxers": career.fighters.size(), "rent_month": int(GymSpend.premises(career)["rent"]),
		"rent_mult": ClubStart.rent_mult(career.start), "month": int(Clock._date(career.day)["month"])}



static func sponsors(career: Career) -> int:
	var total := 0
	for d in career.deals:
		if str(d["state"]) == "signed":
			total += int(d["per"])
	return total


static func weekly_income(career: Career) -> Dictionary:
	return _with_bjj(career, GameMoney.weekly_income(Membership.weekly_dues(career.members, career.dues_band), not career.coach.is_empty(), sponsors(career)))


static func _with_bjj(career: Career, income: Dictionary) -> Dictionary:
	income["bjj"] = int(bjj_money(career)["dues"])
	var spend := GymSpend.income(career)
	income["fitness"] = int(spend["fitness"])
	income["juniors"] = int(spend["juniors"])
	income["total"] = int(income["total"]) + int(income["bjj"]) + int(spend["total"])
	return income


static func end_week(career: Career) -> void:
	var week := int(floor((career.day - 1) / 7.0)) + 1
	for f in career.fighters:
		# S354 the RPG layer: the starting focus's habit fix comes due; the perk road opens perks as training lands.
		var hf: Dictionary = f.get("habit_fix", {})
		if not hf.is_empty() and career.day >= int(hf["until"]):
			(f.get("habits", []) as Array).erase(str(hf["id"]))
			f.erase("habit_fix")
			career.add_news("%s has trained out a habit (%s)." % [f["first"], str(hf["id"]).replace("_", " ")])
		for perk in PerkRoad.newly_open(f, career.day):
			career.add_news("%s opens a perk on the road: %s." % [f["first"], perk])
	var roll: Dictionary = Membership.settle_week(career.members, career.reputation, GymSpend.member_cap(career), career.dues_band, GymSpend.GymBonus.members(career.gym_plan))
	career.members = int(roll["members"])
	var income: Dictionary = _with_bjj(career, GameMoney.weekly_income(int(roll["dues"]), not career.coach.is_empty(), sponsors(career)))
	var costs: Dictionary = weekly_costs(career)
	var bjj_left := 0
	if career.bjj_on():
		bjj_left = int(BjjSide.week(career.bjj_side, career.bjj_teaches())["left"])
		if bjj_left > 0:
			career.add_news("%d left the BJJ classes this week. %d on the mat." % [bjj_left, int(career.bjj_side["members"])], false, true)
	var money: Dictionary = GameMoney.settle_week(career.cash, career.accrued, int(income["total"]), int(costs["total"]), career.day)
	career.loan_weeks = maxi(0, career.loan_weeks - 1)
	career.cash = int(money["cash"])
	career.accrued = int(money["accrued"])
	career.week_money["in"] = int(career.week_money["in"]) + int(income["total"])
	career.week_money["out"] = int(career.week_money["out"]) + int(money["billed"])
	if int(money["billed"]) > 0:
		career.ledger.push_front({"d": career.day, "t": "Month-end bill: wages and upkeep", "amount": -int(money["billed"])})
		(career.week_money.get_or_add("items", []) as Array).append("Month-end bill: wages and upkeep")
		career.add_news("Month-end bill paid: %s for wages and upkeep." % GameMoney.text(int(money["billed"])))
	if int(roll["delta"]) > 0:
		career.add_news("%d new member%s joined this week. %d on the books." % [int(roll["delta"]), "" if int(roll["delta"]) == 1 else "s", career.members], false, true)
	# S399 the arranged overdraft: interest on the drawn balance, the income trail for the limit, the 12-week pull.
	if career.overdraft_on and career.cash < 0:
		var _oi := Overdraft.weekly_interest(career.cash)
		career.cash -= _oi
		career.ledger.push_front({"d": career.day, "t": "Overdraft interest", "amount": -_oi})
	career.income_history = Overdraft.trail(career.income_history, int(income["total"]))
	var od_lim := Overdraft.limit(career.income_history.slice(-4).reduce(func(a, b): return a + b, 0), int(floor(float(career.day) / 7.0))) if career.overdraft_on else 0
	career.overdraft_drawn_weeks = Overdraft.next_drawn(career.cash, career.overdraft_drawn_weeks)
	if career.overdraft_on and Overdraft.should_pull(career.overdraft_drawn_weeks):
		career.overdraft_on = false
		career.overdraft_drawn_weeks = 0
		career.add_news("The bank has pulled the overdraft: twelve weeks drawn.")
	var net := int(income["total"]) - int(costs["total"])
	career.weeks_below = GymBills.next_below(career.cash, career.weeks_below, od_lim)
	var status := GymBills.status(career.cash, net, career.weeks_below)
	if status == "closed" and not career.closed:
		career.closed = true
		career.add_news("%s has closed its doors: %d weeks below $0." % [career.gym_name, career.weeks_below])
	elif status == "red":
		career.add_news("The bank balance is below $0. %s." % GymBills.line(career.cash, net, career.weeks_below))
	Injuries.end_week(career)
	GymSpend.end_week(career)
	var reports: Array = []
	for f in career.fighters:
		var rows: Array = []
		var start: Dictionary = f.get("week_start", {})
		for key in Data.STATS:
			rows.append({"st": key, "before": float(start.get(key, f["stats"][key])), "after": float(f["stats"][key]),
				"why": WeekCause.words(f.get("week_src", {}), key), "src": WeekCause.top(f.get("week_src", {}), key)})
		var drill := DrillWeek.run(career, f)
		var plan := {}
		var planned: Dictionary = f.get("week_planned", {})
		var tw := WeekTwist.active(f)
		if not planned.is_empty():
			var rws := WeekActual.rows(planned, start, f["stats"], float(f["weight"]), float(f.get("week_peak", 0.0)))
			plan = {"rows": rws, "twist": str(tw.get("name", "")),
				"reason": WeekActual.reason(f.get("week_log", []), tw, str((f.get("camp", {}) as Dictionary).get("focus", ""))),
				"change": WeekActual.suggest(rws, WeekPlan.days_of(f), week_ctx(career, f), float(f["weight"]) > float(f["limit"]) + 0.05 and not (f.get("bout", {}) as Dictionary).is_empty())}
		f.erase("week_planned")
		# The next week's twist card (never the same one twice running).
		var bt: Dictionary = f.get("bout", {})
		var fight_week := not bt.is_empty() and not bool(bt.get("done", false)) and int(bt.get("day", 0)) - career.day <= 7
		var nt := WeekTwist.draw(week + 1 + career.fighters.find(f) * 31, str(f.get("twist", "")), fight_week, twist_needs(f, career))
		if FirstHour.quiet(career):   # S397 rank 5 (critic point 9): no card and no ask before the club's first bout
			nt = {"id": "", "rare": true}
		# S361 some weeks her own ask takes the card's place (PushBack; never over the rare short-notice swap).
		if not bool(nt.get("rare", false)):
			var ask := PushBack.pick(f, week + 1, WeekPlan.days_of(f), PadWeek.evenings(f, false), float(f.get("week_peak", 0.0)), str(f.get("twist", "")))
			if ask != "":
				nt = WeekTwist.card(ask)
		WeekTwist.deal(f, nt)
		# (No news line: the Training tab shows the card all week and the review names it - a weekly line flooded Mail.)
		var route := week_path(career, f)
		var wait := weeks_out(career, f)
		for x in rows:
			x["read"] = WeekRead.stat(x, route, str(Data.LABEL[x["st"]]), wait)
		var rank_before := int(f.get("rank_at_review", f.get("rank", 0)))
		# S370 GOALTESTS1: Sunday is the coach's assessment for a ready grade, and her bleep level is read for the review.
		var award := SkillAwards.assess(f, career.day)
		if not award.is_empty():
			# News, not mail: the week review shows it in gold (golden_path: mail counts mail, not every result).
			career.add_news("%s passed the %s award: a medal and a certificate on the gym wall." % [f["first"], award["name"]], false, true)
		reports.append({"id": f["id"], "name": f["name"], "rows": rows, "moves": drill["rows"], "new_weapon": drill["new_weapon"], "pads": drill["review"],
			"award": str(award.get("name", "")), "award_p": SkillAwards.progress(f), "bests": TestDay.record(f, career.day),
			"bleep": [SkillAwards.bleep(float(start.get("conditioning", f["stats"]["conditioning"])), Data.sex_of(f)),
				SkillAwards.bleep(float(f["stats"]["conditioning"]), Data.sex_of(f))]
				if SkillAwards.bleep_known(Data.sex_of(f)) else [],
			"rank_before": rank_before, "rank_after": int(f.get("rank", 0)), "div": Data.DIVISIONS[f["div"]]["short"],
			"coach": coach_line(career, f), "plan": plan, "peak": str(f.get("peak_line", "")), "injury": Injuries.new_this_week(career, f),
			"goal": WeekRead.goal(goal_read(career, f), float(goal_read(career, _as_of(f, start)).get("share", 0.0))),
			"rank": WeekRead.rank(rank_before, int(f.get("rank", 0)), str(Data.DIVISIONS[f["div"]]["short"]))})
		f.erase("peak_line")
		f["rank_at_review"] = int(f.get("rank", 0))
		if not career.coach.is_empty():
			Bouts.coach_note(career, f, "sparring")
		f["week_start"] = (f["stats"] as Dictionary).duplicate()
		f["attrs_week"] = Attrs.of(f).duplicate()   # S398 the board's weekly change per attribute
	career.last_report = {
		"week": week, "fighters": reports, "grapplers": Grapplers.week_report(career), "members": career.members, "members_delta": int(roll["delta"]),
		"members_why": str(roll.get("why", "")),
		# S352 (board review: "Paid this week -$1,000" vs Home's "Costs this week -$1,123"): the week's running costs go on the
		# month-end bill; "out" is the cash that left - the review shows both, and names what was paid.
		"money": {"in": int(career.week_money["in"]), "out": int(career.week_money["out"]), "costs": int(costs["total"]),
			"paid": (career.week_money.get("items", []) as Array).duplicate(), "line": GymBills.line(career.cash, net, career.weeks_below), "status": status,
			"runway": WeekRead.runway(career.cash, career.accrued, int(income["total"]), int(costs["total"]), career.day, career.weeks_below)},
		"coach": coach_line(career, career.fighter()),
	}
	# S387 (menu critic: "empty week reviews fire"): a week in which nobody trained has nothing to review.
	career.review_pending = not (reports.is_empty() and (career.last_report["grapplers"] as Array).is_empty())
	FirstWeek.end_of_week(career, week)
	Roster.check_pro(career)
	career.week_money = {"in": 0, "out": 0}
	career.cash_history.append({"w": week + 1, "c": career.cash})


## S387 the stats she is headed for, week by week (WeekRead.path): Monday's phase and the twist card in play, the coach's
## weeks to fight night (PadWeek.ahead), then her own week with no bout. A copy: the fighter is not touched.
static func week_path(career: Career, f: Dictionary) -> Array:
	var g := f.duplicate(true)
	WeekPhase.sync(g, career.day)
	var bout: Dictionary = g.get("bout", {})
	var open := not bout.is_empty() and not bool(bout.get("done", false))
	var later := PadWeek.ahead(g, career.day, int(ceil((int(bout["day"]) - career.day) / 7.0))) if open else []
	var free := g.duplicate(true)
	free["bout"] = {}
	free["camp"] = {}
	free.erase("twist")
	WeekPhase.sync(free, career.day)
	while later.size() < WeekRead.HORIZON:
		later.append([WeekPlan.days_of(free), PadWeek.evenings(free), "base"])
	return WeekRead.path(WeekTwist.days(WeekTwist.active(g), WeekPlan.days_of(g)), week_ctx(career, g), PadWeek.evenings(g), later)


## The whole weeks an injury keeps her out (0 when fit): her ETAs wait for them.
static func weeks_out(career: Career, f: Dictionary) -> int:
	if not Injuries.out(career, f):
		return 0
	return int(ceil((int((f["injury"] as Dictionary)["until_day"]) - career.day) / 7.0))


## The fighter with the stats she had at `stats` (a shallow copy, for a read).
static func _as_of(f: Dictionary, stats: Dictionary) -> Dictionary:
	var g := f.duplicate()
	if not stats.is_empty():
		g["stats"] = stats
	return g


static func coach_line(career: Career, f: Dictionary) -> String:
	if f.is_empty():
		return "No fighter on the books yet. The walk-in at reception is worth a look."
	if career.coach.is_empty():
		return "%s trained alone this week. A coach would make every session count." % f["first"]
	return "%s: \"%s put the work in on %s. %s\"" % [career.coach["name"], f["first"],
		str(Data.LABEL[focus_of(career, f)]).to_lower(),
		"We know what Saturday needs." if not (f.get("bout", {}) as Dictionary).is_empty() else "Get a fight booked and watch."]


## Signs the walk-in at reception.
static func sign(career: Career, picks: Array) -> void:
	var f := Roster.sign_fighter(career, career.applicant, picks)
	f["next_offer_day"] = FirstHour.first_offer_day(career, int(f["next_offer_day"]))   # S397 the show's offer: Monday week 2
	for p in career.prospects:   # S397 a prospect who walked in (FirstHour's second walk-in) is signed, not scouted
		if str(p["id"]) == str(f["id"]):
			p["state"] = "signed"
	career.applicant = {}


static func hire(career: Career, coach_id: String) -> Dictionary:
	var c := Data.coach(coach_id)
	if c.is_empty() or not career.coach.is_empty():
		return {}
	career.coach = c
	career.pay(-GameMoney.COACH_SIGNING_FEE, "Signing fee: %s" % c["name"])
	career.add_news("%s joins as %s." % [c["name"], str(c["kind"]).to_lower()])
	return c


## FighterGoal's read of her goal, at today's training pace. {} when she has none.
static func goal_read(career: Career, f: Dictionary) -> Dictionary:
	if f.is_empty() or (f.get("goal", {}) as Dictionary).is_empty():
		return {}
	var goal: Dictionary = f["goal"]
	var rate := daily_gain(career, f, true)
	var p: Dictionary = FighterGoal.progress(goal, f, career.day, rate)
	var card: Dictionary = FighterGoal.card(goal, p)
	# The bar shows the share of the climb from her start to the target, not current / target.
	var share := 0.0
	var n := 0
	for row in p["per_target"]:
		var key := str(row["key"])
		if key == "booked_fight":
			share += float(row["current"])
		else:
			var start := float((goal["start_stats"] as Dictionary).get(key, 0.0))
			share += clampf((float(row["current"]) - start) / maxf(0.001, float(row["target"]) - start), 0.0, 1.0)
		n += 1
	var chip := {"MET": "green", "ON_TRACK": "green", "AT_RISK": "amber"}
	return {
		"title": goal["title"], "status": card["status"], "cls": chip.get(card["status_code"], "red"),
		"left": maxi(0, int(p["days_left"])), "share": share / maxf(1.0, float(n)), "row": ", ".join(card["targets"]).to_lower(),
		"line": goal.get("persona_line", ""),
		"code": card["status_code"], "days_left": int(p["days_left"]), "targets": p["per_target"], "rate": rate,   # S387 WeekRead.goal
	}
