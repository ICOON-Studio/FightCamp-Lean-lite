extends RefCounted
## S496 TRAININGK1: one fighter's week as numbers - moved out of the old Training tab (WeekBoard.gd, the approach-B page the
## operator removed: "remove this training picture from the game", C416) so Training K, Fight prep and the camp panels read
## the same week. No UI here.
##   goal_of(c, f)  plan_of(c, f) -> {goal, base, days, evs, ctx, wk, lines}  booked(goal)  camp_week(c, f)
##   tired_days(plan) -> [[start, end, rise, morning cost] x 7]  pack(c, f) -> {inp, projs, cards, usable}  fight_dow(c, f, goal)

const Sim := preload("res://scripts/state/Sim.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const PlanCards := preload("res://scripts/rules/PlanCards.gd")

const WEEKS_NO_BOUT := 4


static func goal_of(c: Career, f: Dictionary) -> Dictionary:
	var stat := Sim.focus_of(c, f)
	var g: Dictionary = f.get("goal", {})
	var key := str(g.get("stat", g.get("key", "")))
	var now := float((f["stats"] as Dictionary).get(stat, 50.0))
	var target := floorf(now) + 2.0
	if key == stat and g.has("target"):
		target = float(g["target"])
	var cg: Dictionary = (f.get("camp", {}) as Dictionary).get("goal", {})
	if str(cg.get("stat", "")) == stat:
		target = float(cg["target"])
	var bout: Dictionary = f.get("bout", {})
	var weeks := WEEKS_NO_BOUT
	if not bout.is_empty() and not bool(bout.get("done", false)):
		weeks = maxi(1, int(ceil((int(bout["day"]) - c.day) / 7.0)))
	var goal := {"stat": stat, "target": target, "weeks": weeks, "bout": bout}
	if not bout.is_empty() and not bool(bout.get("done", false)):
		goal["limit"] = float(f["limit"])
	return goal


static func plan_of(c: Career, f: Dictionary) -> Dictionary:
	if not bool(f.get("_ahead", false)):
		WeekPhase.ensure(f, c.day)
	var goal := goal_of(c, f)
	var tw := WeekTwist.active(f)
	var base := WeekPlan.days_of(f)
	var days := WeekTwist.days(tw, base)
	var evs := PadWeek.evenings(f)
	var ctx := Sim.week_ctx(c, f)
	var wk := WeekPlan.week(days, ctx, evs)
	var lines := WeekPlan.goal_lines(goal, days, ctx, int(goal["weeks"]), evs, PadWeek.ahead(f, c.day, int(goal["weeks"])))
	var bout: Dictionary = goal["bout"]
	if not bout.is_empty() and not bool(bout.get("done", false)):
		var opp := WeekOpp.line(bout["opp"], days, str(f.get("phase", "base")))
		if not opp.is_empty():
			lines.append(opp)
	return {"goal": goal, "base": base, "days": days, "evs": evs, "ctx": ctx, "wk": wk, "lines": lines}


static func camp_week(c: Career, f: Dictionary) -> int:
	var bout: Dictionary = f.get("bout", {})
	var camp: Dictionary = f.get("camp", {})
	if bout.is_empty() or bool(bout.get("done", false)) or camp.is_empty():
		return 0
	var weeks := maxi(1, int(ceil((int(bout["day"]) - c.day) / 7.0)))
	var total := maxi(weeks, int(ceil((int(bout["day"]) - int(camp.get("start", c.day))) / 7.0)))
	return clampi(total - weeks + 1, 1, total)


static func booked(goal: Dictionary) -> bool:
	return not (goal["bout"] as Dictionary).is_empty() and not bool((goal["bout"] as Dictionary).get("done", false))


static func tired_days(pl: Dictionary) -> Array:
	var out: Array = []
	var prev := float((pl["ctx"] as Dictionary).get("fatigue", 20.0))
	for r in (pl["wk"] as Dictionary)["days"]:
		var start := prev * WeekPlan.FATIGUE_KEEP
		var end := float(r["fatigue"])
		out.append([start, end, maxf(0.0, end - start), float(r.get("load", 0.0)) / WeekPlan.LOAD_PER_FATIGUE])
		prev = end
	return out


## The week's drilling as the card projections see it: {inp (DrillWeek.inputs), projs (PadWeek.project, each with eta and
## pads), cards (the tray), usable (tray cards that cross Usable this week)}.
static func pack(c: Career, f: Dictionary) -> Dictionary:
	var inp := DrillWeek.inputs(c, f)
	var nights: Dictionary = inp["nights"]
	var week: Dictionary = inp["week"]
	var projs := PadWeek.project(f, nights, week, float(inp["skill"]), PadWeek.STATION_TIER, 8, inp["mults"], inp["carded"])
	var plan := PlanCards.active(f)
	var cards: Array = PlanCards.tray(f, week) if plan else PadEdit.tray(f, week)
	var usable := 0
	for held in cards:
		if not projs.has(held):
			projs[held] = PadEdit.idle(f, str(held))
	for one in projs:
		projs[one]["eta"] = PadEdit.eta(f, str(one), projs[one], week, nights.get("spar", []))
		projs[one]["pads"] = nights.get("pads", [])
		if cards.has(one) and not PadEdit.crossing(f, str(one), projs[one]).is_empty():
			usable += 1
	if plan:
		var fd := int((f["bout"] as Dictionary)["day"])
		PlanCards.dress(f, projs, c.day - posmod(c.day, 7), fd, PlanCards.fight_paths(f, inp, c.day, fd))
	return {"inp": inp, "projs": projs, "cards": cards, "usable": usable}


## The weekday of her bout inside the week shown, else -1.
static func fight_dow(c: Career, f: Dictionary, goal: Dictionary) -> int:
	if not booked(goal):
		return -1
	var ahead := bool(f.get("_ahead", false))
	var mon := int(f["phase_day"]) if ahead else c.day - posmod(c.day, 7)
	var bd := int((goal["bout"] as Dictionary)["day"])
	return bd - mon if bd >= mon and bd < mon + 7 else -1
