extends RefCounted
## What happens in a day and at a week's end, and the player's roster moves (sign, hire, plan). Reads the rule modules;
## the bouts' days are Bouts.day_events, the region's Region.day_events. Every fighter trains on her own plan (her camp's
## focus while in camp) and drills her moves; the week review reports each fighter.

const Data := preload("res://scripts/state/Data.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const Region := preload("res://scripts/state/Region.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
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
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const PushBack := preload("res://scripts/rules/PushBack.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")

## Without a coach training runs at 60%: the coach factor 0.5 + r x 0.7 equals 0.6 at this rating.
const NO_COACH_RATING := 100.0 / 7.0
const STAT_CAP := 99.0
## Move drilling a week: the move she is learning gets pad time (USABLE in 2 weeks with a coach, 3 without); each move a
## week card drills gets bag time; the rest decay (MoveMastery.decay_week).
const LEARN_STATION := "pads"
const LEARN_MINUTES := 420.0
const CARD_STATION := "heavy_bag"
const CARD_MINUTES := 120.0
const STATION_TIER := 2
## S302 combos: the combo she is drilling gets this much pad time a week (on top of the move she is learning).
const COMBO_MINUTES := 240.0


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


## S354 CORE3 step 1 (operator: "when picking up the morning exercises it has to sum up gains/loses towards a goal"): the
## day is her week's morning + evening (WeekPlan) - the stat gains, the weight (her diet + the morning's burn) and her
## fatigue. What she eats: CUT while over the limit (in camp or on the cut diet), else HOLD.
static func week_ctx(career: Career, f: Dictionary) -> Dictionary:
	var cutting := (str(f["diet"]) == "cut" or not (f["camp"] as Dictionary).is_empty()) and float(f["weight"]) > float(f["limit"]) - 0.15
	return {"stats": f["stats"], "pot": int(f["pot"]), "coach": coach_rating(career), "weight": float(f["weight"]),
		"diet": "cut" if cutting else "hold", "fatigue": float(f.get("week_fatigue", 20.0)), "phase": str(f.get("phase", "base")),
		"twist_kg": float(WeekTwist.active(f).get("kg_day", 0.0)), "twist_fat": float(WeekTwist.active(f).get("fat_day", 0.0))}


## {stat: points a day} averaged over her week; a camp multiplies its focus by the protocol.
static func daily_gain(career: Career, f: Dictionary) -> Dictionary:
	var tw := WeekTwist.active(f)
	var w := WeekPlan.week(WeekTwist.days(tw, WeekPlan.days_of(f)), week_ctx(career, f), WeekTwist.evenings(tw, WeekPlan.evenings_of(f)))
	var out: Dictionary = {}
	for key in f["stats"].keys():
		out[key] = float((w["gains"] as Dictionary).get(key, 0.0)) / 7.0 * BoutRules.camp_gain_mult(f.get("camp", {}), str(key))
	return out


static func step_day(career: Career) -> void:
	for f in career.fighters:
		var mult := Injuries.gain_mult(career, f)   # S325 an injured fighter trains at the rest week's share
		var dow := posmod(career.day, 7)   # day 0 is a Monday (Clock)
		var resting := Injuries.out(career, f)
		# S355 CORE3 step 2: the week's twist card changes the week she runs; Monday keeps what the plan says it will do
		# (WeekActual), and a day that runs other than planned goes on the log the week review reads.
		# S356 the camp's phase writes the week on Monday (WeekPhase; a new phase drops last week's exceptions).
		if dow == 0 or not f.has("phase"):
			WeekPhase.sync(f, career.day)
		if dow == 0:
			twist_monday(career, f)
		var tw := WeekTwist.active(f)
		var days := WeekTwist.days(tw, WeekPlan.days_of(f))
		var evs := WeekTwist.evenings(tw, WeekPlan.evenings_of(f))
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
				f["stats"][st] = minf(STAT_CAP, was + float(r[k[1]]) * BoutRules.camp_gain_mult(f.get("camp", {}), st) * mult)
				WeekCause.add(f.get_or_add("week_src", {}), st, str(by[k[2]]), float(f["stats"][st]) - was)
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
	Region.day_events(career)
	if career.day % 7 == 0:
		end_week(career)
	Champs.day_events(career)   # S328 last: a pull-out from the week's injuries ends her championship run today


## S324 update 27: the flat $500 upkeep became the real bills (GymBills): rent, and the governing body's yearly fees by the
## week. The coach's own sessional pay stays the staff line (it is his hours), so GymBills' coaching line is not used.
static func weekly_costs(career: Career) -> Dictionary:
	var staff: Array = [] if career.coach.is_empty() else [career.coach]
	var bills: Dictionary = GymBills.week(bills_setup(career))
	var out := GameMoney.weekly_costs(staff, career.fighters, int(bills["rent"]) + int(bills["fees"]))
	out["rent"] = int(bills["rent"])
	out["fees"] = int(bills["fees"])
	out["bjj"] = int(bjj_money(career)["coach"])
	out["total"] = int(out["total"]) + int(out["bjj"])
	return out


## S365 the BJJ classes' week (BjjSide.money): {dues, coach, net, members}; all 0 without a no-gi athlete.
static func bjj_money(career: Career) -> Dictionary:
	if not career.bjj_on():
		return {"dues": 0, "coach": 0, "net": 0, "members": 0}
	return BjjSide.money(career.bjj_side, career.bjj_teaches())


static func bills_setup(career: Career) -> Dictionary:
	return {"members": career.members, "coach_hours_week": 0.0, "coaches": 0 if career.coach.is_empty() else 1,
		"boxers": career.fighters.size()}



static func sponsors(career: Career) -> int:
	var total := 0
	for d in career.deals:
		if str(d["state"]) == "signed":
			total += int(d["per"])
	return total


static func weekly_income(career: Career) -> Dictionary:
	return _with_bjj(career, GameMoney.weekly_income(Membership.weekly_dues(career.members), not career.coach.is_empty(), sponsors(career)))


static func _with_bjj(career: Career, income: Dictionary) -> Dictionary:
	income["bjj"] = int(bjj_money(career)["dues"])
	income["total"] = int(income["total"]) + int(income["bjj"])
	return income


## One week of move drilling for one fighter. Returns {rows: [{name, before, after}], new_weapon: "" or the move}.
static func drill_week(career: Career, f: Dictionary) -> Dictionary:
	var moves: Dictionary = f["moves"]
	var cap := MoveMastery.cap(float(f["stats"]["technique"]), float(f["stats"]["fight_iq"]))
	var skill := float(career.coach.get("rating", 0.0))
	var carded: Array = []
	for card in f["cards"]:
		if Data.CARD_MOVES.has(card):
			carded.append(Data.CARD_MOVES[card])
	var learning := str(f.get("learning", ""))
	var pads := TrainingPlan.pads_factor(plan_of(career, f)) * float(WeekTwist.active(f).get("move_mult", 1.0))   # S351 pad rounds set the pace; S356 the twist
	var rows: Array = []
	var new_weapon := ""
	for m in Data.MOVES:
		var before := float(moves.get(m, 0.0))
		var after := before
		if m == learning and pads > 0.0:
			after = MoveMastery.gain(before, LEARN_STATION, LEARN_MINUTES * pads, skill, STATION_TIER, 1.0, cap)
		elif carded.has(m):
			after = MoveMastery.gain(before, CARD_STATION, CARD_MINUTES, skill, STATION_TIER, 1.0, cap)
		else:
			after = MoveMastery.decay_week(before, false)
		moves[m] = after
		rows.append({"name": m, "before": before, "after": after})
		if before < BoutRules.WEAPON_MASTERY and after >= BoutRules.WEAPON_MASTERY:
			new_weapon = m
	if (new_weapon != "" and new_weapon == learning) or learning == "":
		# Next: the first move not yet a weapon; once all are, pad time sharpens her weakest one.
		var next := ""
		for m in Data.MOVES:
			if float(moves[m]) < BoutRules.WEAPON_MASTERY:
				next = m
				break
		if next == "":
			for m in Data.MOVES:
				if next == "" or float(moves[m]) < float(moves[next]):
					next = m
		f["learning"] = next
		career.add_news("%s has a new weapon: the %s (%s)." % [f["first"], new_weapon.to_lower(),
			MoveMastery.describe(new_weapon, float(moves[new_weapon]))])
	var new_combo := drill_combos(career, f, skill)
	return {"rows": rows, "new_weapon": new_weapon, "new_combo": new_combo}


## S302 combos (operator: "Yes, build combos"): the combo she is drilling gets pad time, never sharper than its weakest
## punch; the others fade slowly. When it turns USABLE, or none is set, the coach picks the next she can learn.
static func drill_combos(career: Career, f: Dictionary, skill: float) -> String:
	var moves: Dictionary = f["moves"]
	if not f.has("combos"):
		f["combos"] = {}
	var combos: Dictionary = f["combos"]
	var drilling := str(f.get("combo_learning", ""))
	if drilling == "" or not Combos.unlocked(moves).has(drilling):
		drilling = Combos.next_to_learn(moves, combos)
	var ids: Array = combos.keys()
	if drilling != "" and not ids.has(drilling):
		ids.append(drilling)
	var new_combo := ""
	var pads := TrainingPlan.pads_factor(plan_of(career, f)) * float(WeekTwist.active(f).get("combo_mult", 1.0))
	for id in ids:
		var before := float(combos.get(id, 0.0))
		var after := Combos.fade(before, false)
		if id == drilling and pads > 0.0:
			var cap := Combos.cap(id, moves, float(f["stats"]["technique"]), float(f["stats"]["fight_iq"]))
			after = Combos.drill(before, id, COMBO_MINUTES * pads, skill, STATION_TIER, cap)
		combos[id] = after
		# S303 Kalli K-COMBOWORDS1: the coach's words when it turns usable and when it becomes her signature.
		if before < Combos.LEARN_AT and after >= Combos.LEARN_AT:
			new_combo = id
			career.add_news("%s can throw the %s in a fight now (%s). Coach: \"%s\"" % [f["first"], id, Combos.describe(id, after),
				ComboWords.line(id, "coach_learning", str(f["first"]), career.day)])
		elif before < ComboWords.SIGNATURE_AT and after >= ComboWords.SIGNATURE_AT:
			career.add_news("Coach: \"%s\"" % ComboWords.line(id, "coach_signature", str(f["first"]), career.day))
	f["combo_learning"] = Combos.next_to_learn(moves, combos) if new_combo == drilling else drilling
	return new_combo


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
	var roll: Dictionary = Membership.settle_week(career.members, career.reputation)
	career.members = int(roll["members"])
	var income: Dictionary = _with_bjj(career, GameMoney.weekly_income(int(roll["dues"]), not career.coach.is_empty(), sponsors(career)))
	var costs: Dictionary = weekly_costs(career)
	var bjj_left := 0
	if career.bjj_on():
		bjj_left = int(BjjSide.week(career.bjj_side, career.bjj_teaches())["left"])
		if bjj_left > 0:
			career.add_news("%d left the BJJ classes this week. %d on the mat." % [bjj_left, int(career.bjj_side["members"])], false)
	var money: Dictionary = GameMoney.settle_week(career.cash, career.accrued, int(income["total"]), int(costs["total"]), career.day)
	career.cash = int(money["cash"])
	career.accrued = int(money["accrued"])
	career.week_money["in"] = int(career.week_money["in"]) + int(income["total"])
	career.week_money["out"] = int(career.week_money["out"]) + int(money["billed"])
	if int(money["billed"]) > 0:
		career.ledger.push_front({"d": career.day, "t": "Month-end bill: wages and upkeep", "amount": -int(money["billed"])})
		(career.week_money.get_or_add("items", []) as Array).append("Month-end bill: wages and upkeep")
		career.add_news("Month-end bill paid: %s for wages and upkeep." % GameMoney.text(int(money["billed"])))
	if int(roll["delta"]) > 0:
		career.add_news("%d new members joined this week. %d on the books." % [int(roll["delta"]), career.members])
	var net := int(income["total"]) - int(costs["total"])
	career.weeks_below = GymBills.next_below(career.cash, career.weeks_below)
	var status := GymBills.status(career.cash, net, career.weeks_below)
	if status == "closed" and not career.closed:
		career.closed = true
		career.add_news("%s has closed its doors: %d weeks below $0." % [career.gym_name, career.weeks_below])
	elif status == "red":
		career.add_news("The bank balance is below $0. %s." % GymBills.line(career.cash, net, career.weeks_below))
	Injuries.end_week(career)
	var reports: Array = []
	for f in career.fighters:
		var rows: Array = []
		var start: Dictionary = f.get("week_start", {})
		for key in Data.STATS:
			rows.append({"st": key, "before": float(start.get(key, f["stats"][key])), "after": float(f["stats"][key]),
				"why": WeekCause.words(f.get("week_src", {}), key)})
		var drill := drill_week(career, f)
		var plan := {}
		var planned: Dictionary = f.get("week_planned", {})
		var tw := WeekTwist.active(f)
		if not planned.is_empty():
			var rws := WeekActual.rows(planned, start, f["stats"], float(f["weight"]), float(f.get("week_peak", 0.0)))
			plan = {"rows": rws, "twist": str(tw.get("name", "")),
				"reason": WeekActual.reason(f.get("week_log", []), tw, str((f.get("camp", {}) as Dictionary).get("focus", ""))),
				"change": WeekActual.suggest(rws, WeekPlan.days_of(f), week_ctx(career, f), float(f["weight"]) > float(f["limit"]) + 0.05)}
		f.erase("week_planned")
		# The next week's twist card (never the same one twice running).
		var bt: Dictionary = f.get("bout", {})
		var fight_week := not bt.is_empty() and not bool(bt.get("done", false)) and int(bt.get("day", 0)) - career.day <= 7
		var nt := WeekTwist.draw(week + 1 + career.fighters.find(f) * 31, str(f.get("twist", "")), fight_week, twist_needs(f, career))
		# S361 some weeks her own ask takes the card's place (PushBack; never over the rare short-notice swap).
		if not bool(nt.get("rare", false)):
			var ask := PushBack.pick(f, week + 1, WeekPlan.days_of(f), WeekPlan.evenings_of(f), float(f.get("week_peak", 0.0)), str(f.get("twist", "")))
			if ask != "":
				nt = WeekTwist.card(ask)
		WeekTwist.deal(f, nt)
		# (No news line: the Training tab shows the card all week and the review names it - a weekly line flooded Mail.)
		var rank_before := int(f.get("rank_at_review", f.get("rank", 0)))
		# S370 GOALTESTS1: Sunday is the coach's assessment for a ready grade, and her bleep level is read for the review.
		var award := SkillAwards.assess(f, career.day)
		if not award.is_empty():
			# News, not mail: the week review shows it in gold (golden_path: mail counts mail, not every result).
			career.add_news("%s passed the %s award: a medal and a certificate on the gym wall." % [f["first"], award["name"]], false)
		reports.append({"id": f["id"], "name": f["name"], "rows": rows, "moves": drill["rows"], "new_weapon": drill["new_weapon"],
			"award": str(award.get("name", "")), "award_p": SkillAwards.progress(f), "bests": TestDay.record(f, career.day),
			"bleep": [SkillAwards.bleep(float(start.get("conditioning", f["stats"]["conditioning"]))), SkillAwards.bleep(float(f["stats"]["conditioning"]))]
				if SkillAwards.bleep_known(Data.sex_of(f)) else [],
			"rank_before": rank_before, "rank_after": int(f.get("rank", 0)), "div": Data.DIVISIONS[f["div"]]["short"],
			"coach": coach_line(career, f), "plan": plan, "peak": str(f.get("peak_line", "")), "injury": Injuries.new_this_week(career, f)})
		f.erase("peak_line")
		f["rank_at_review"] = int(f.get("rank", 0))
		if not career.coach.is_empty():
			Bouts.coach_note(career, f, "sparring")
		f["week_start"] = (f["stats"] as Dictionary).duplicate()
	career.last_report = {
		"week": week, "fighters": reports, "grapplers": Grapplers.week_report(career), "members": career.members, "members_delta": int(roll["delta"]),
		# S352 (board review: "Paid this week -$1,000" vs Home's "Costs this week -$1,123"): the week's running costs go on the
		# month-end bill; "out" is the cash that left - the review shows both, and names what was paid.
		"money": {"in": int(career.week_money["in"]), "out": int(career.week_money["out"]), "costs": int(costs["total"]),
			"paid": (career.week_money.get("items", []) as Array).duplicate(), "line": GymBills.line(career.cash, net, career.weeks_below), "status": status},
		"coach": coach_line(career, career.fighter()),
	}
	career.review_pending = true
	Roster.check_pro(career)
	career.week_money = {"in": 0, "out": 0}
	career.cash_history.append({"w": week + 1, "c": career.cash})


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
	Roster.sign_fighter(career, career.applicant, picks)
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
	var p: Dictionary = FighterGoal.progress(goal, f, career.day, daily_gain(career, f))
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
	}
