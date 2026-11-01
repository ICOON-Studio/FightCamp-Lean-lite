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
const Region := preload("res://scripts/state/Region.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")
const TrainingPlan := preload("res://scripts/rules/TrainingPlan.gd")
const Champs := preload("res://scripts/state/Champs.gd")

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


## S351 her week's plan (TrainingPlan: blocks per session): the one she has set, else the coach's week for her focus. In
## camp the camp writes the week (its focus as the main session).
static func plan_of(career: Career, f: Dictionary) -> Dictionary:
	var focus := focus_of(career, f)
	var partner := str(TrainingPreview.PARTNER.get(focus, ""))
	if not (f.get("camp", {}) as Dictionary).is_empty():
		return TrainingPlan.default_plan(focus, partner)
	return TrainingPlan.plan_of(f.get("week_plan"), focus, partner)


## {stat: points a day} for her plan this week; a camp multiplies its focus by the protocol.
static func daily_gain(career: Career, f: Dictionary) -> Dictionary:
	var week: Dictionary = TrainingPreview.fractions_gain(f["stats"], int(f["pot"]),
		TrainingPlan.fractions(plan_of(career, f)), coach_rating(career))
	var out: Dictionary = {}
	for key in week.keys():
		out[key] = float(week[key]) / 7.0 * BoutRules.camp_gain_mult(f.get("camp", {}), str(key)) * TrainingLoad.gain(Injuries.setting(f))
	return out


static func step_day(career: Career) -> void:
	for f in career.fighters:
		var gain := daily_gain(career, f)
		var mult := Injuries.gain_mult(career, f)   # S325 an injured fighter trains at the rest week's share
		for key in Data.STATS:
			f["stats"][key] = minf(STAT_CAP, float(f["stats"][key]) + float(gain.get(key, 0.0)) * mult)
		if str(f["diet"]) == "cut" or not (f["camp"] as Dictionary).is_empty():
			f["weight"] = maxf(float(f["limit"]) - 0.15, float(f["weight"]) - 0.11)
		else:
			f["weight"] = minf(float(f["limit"]) + 1.6, float(f["weight"]) + 0.01)
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
	return out


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
	return GameMoney.weekly_income(Membership.weekly_dues(career.members), not career.coach.is_empty(), sponsors(career))


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
	var pads := TrainingPlan.pads_factor(plan_of(career, f))   # S351 her pad rounds set the new move's pace
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
	var pads := TrainingPlan.pads_factor(plan_of(career, f))
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
	var roll: Dictionary = Membership.settle_week(career.members, career.reputation)
	career.members = int(roll["members"])
	var income: Dictionary = GameMoney.weekly_income(int(roll["dues"]), not career.coach.is_empty(), sponsors(career))
	var costs: Dictionary = weekly_costs(career)
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
			rows.append({"st": key, "before": float(start.get(key, f["stats"][key])), "after": float(f["stats"][key])})
		var drill := drill_week(career, f)
		var rank_before := int(f.get("rank_at_review", f.get("rank", 0)))
		reports.append({"id": f["id"], "name": f["name"], "rows": rows, "moves": drill["rows"], "new_weapon": drill["new_weapon"],
			"rank_before": rank_before, "rank_after": int(f.get("rank", 0)), "div": Data.DIVISIONS[f["div"]]["short"],
			"coach": coach_line(career, f)})
		f["rank_at_review"] = int(f.get("rank", 0))
		if not career.coach.is_empty():
			Bouts.coach_note(career, f, "sparring")
		f["week_start"] = (f["stats"] as Dictionary).duplicate()
	career.last_report = {
		"week": week, "fighters": reports, "members": career.members, "members_delta": int(roll["delta"]),
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
		"We know what Saturday needs." if not (f.get("bout", {}) as Dictionary).is_empty() else "Get her a fight and she will show you."]


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
