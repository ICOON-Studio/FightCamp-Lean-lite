extends RefCounted
## S355 CORE3 step 2, planned vs actual (CORE3_DESIGN_S354.md "the payoff screen": "the week ends with planned vs actual per
## goal line, with the one-line reason ... The coach suggests one change. That is where the player feels each decision
## mattered."). Monday's projection of her week (WeekPlan.week on the week the twist card leaves) is kept on
## f["week_planned"]; each day the sim logs what it ran when that differs from the plan; the review sets the two side by side.
## Pure static.
##   snapshot(w, days, weight, day) -> f["week_planned"]   log_entry(dow, planned, ran, why) -> one f["week_log"] row
##   rows(planned, start_stats, stats, weight, peak) -> [{id, label, plan, actual, unit, ok}]
##   reason(log, twist, camp_stat) -> String   suggest(rows, days, ctx, over_limit) -> String
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

## A stat line shows when the plan trains it at least this much a week.
const SHOWN_GAIN := 0.05
## Within this of the plan (or better) a line is on plan.
const CLOSE := {"stat": 0.05, "kg": 0.15, "fatigue": 5.0}
const DAY_NAMES := ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const LABEL := {"power": "Power", "speed": "Speed", "technique": "Technique", "defense": "Defence", "conditioning": "Conditioning",
	"fight_iq": "Ring IQ", "chin": "Chin"}


## What Monday's plan said the week would do (w = WeekPlan.week; days = the saved mornings, to see a mid-week change).
static func snapshot(w: Dictionary, days: Array, weight: float, day: int) -> Dictionary:
	return {"day": day, "gains": (w.get("gains", {}) as Dictionary).duplicate(), "kg": float(w.get("kg", 0.0)), "weight": weight,
		"peak": float(w.get("peak", 0.0)), "days": days.duplicate(true)}


## One log row: dow 0..6; planned / ran = [session, intensity]; why = "injured" | "changed".
static func log_entry(dow: int, planned: Array, ran: Array, why: String) -> Dictionary:
	return {"dow": dow, "planned": planned.duplicate(), "ran": ran.duplicate(), "why": why}


## The lines: every stat the plan trains, the weight, the fatigue peak. ok = on plan or better.
static func rows(planned: Dictionary, start_stats: Dictionary, stats: Dictionary, weight: float, peak: float) -> Array:
	var out: Array = []
	var gains: Dictionary = planned.get("gains", {})
	for st in LABEL.keys():
		var plan := float(gains.get(st, 0.0))
		if plan < SHOWN_GAIN:
			continue
		var actual := float(stats.get(st, 0.0)) - float(start_stats.get(st, stats.get(st, 0.0)))
		out.append({"id": st, "label": LABEL[st], "plan": plan, "actual": actual, "unit": "stat", "ok": actual >= plan - CLOSE["stat"]})
	var kg_plan := float(planned.get("kg", 0.0))
	var kg := weight - float(planned.get("weight", weight))
	# A cut wants the number down: on plan when she lost at least the plan's kilos (or gained no more than it said).
	out.append({"id": "weight", "label": "Weight", "plan": kg_plan, "actual": kg, "unit": "kg", "ok": kg <= kg_plan + CLOSE["kg"]})
	var pk := float(planned.get("peak", 0.0))
	out.append({"id": "fatigue", "label": "Fatigue peak", "plan": pk, "actual": peak, "unit": "fatigue", "ok": peak <= pk + CLOSE["fatigue"]})
	return out


## The one-line reason the week ran as it did. twist = the week's card ({} = none); camp_stat = the camp's focus ("" none).
static func reason(log: Array, twist: Dictionary, camp_stat: String = "") -> String:
	var parts := PackedStringArray()
	var hurt: Array = log.filter(func(x): return str(x["why"]) == "injured")
	var changed: Array = log.filter(func(x): return str(x["why"]) == "changed")
	if not hurt.is_empty():
		parts.append("%d %s lost to injury" % [hurt.size(), "day" if hurt.size() == 1 else "days"])
	if not changed.is_empty():
		var names := PackedStringArray()
		for x in changed:
			names.append(DAY_NAMES[int(x["dow"])])
		parts.append("the plan changed on %s" % ", ".join(names))
	if not twist.is_empty() and str(twist.get("id", "")) != "quiet":
		parts.append("the twist: %s" % str(twist["name"]).to_lower())
	if camp_stat != "":
		parts.append("camp focus on %s trained it harder" % str(LABEL.get(camp_stat, camp_stat)).to_lower())
	if parts.is_empty():
		return "Every session went as planned."
	var s := "; ".join(parts) + "."
	return s.substr(0, 1).to_upper() + s.substr(1)


## The coach's one change for next week, from the line furthest off plan. days = the saved mornings, ctx = Sim.week_ctx.
static func suggest(rws: Array, days: Array, ctx: Dictionary, over_limit: bool) -> String:
	var by := {}
	for r in rws:
		by[str(r["id"])] = r
	var fat: Dictionary = by.get("fatigue", {})
	if not fat.is_empty() and float(fat["actual"]) >= WeekPlan.OVERREACHED:
		return "Make one HARD morning NORMAL: fatigue reached %d, and overreached days train at %d%%." % [
			int(round(float(fat["actual"]))), int(round(WeekPlan.TIRED_GAIN * 100.0))]
	var wt: Dictionary = by.get("weight", {})
	if over_limit and not wt.is_empty() and not bool(wt["ok"]):
		# The diet moves the scale far more than one session does (a 500 kcal cut ~0.45 kg a week; a hard run over a light
		# shadow morning ~0.05 kg), so the coach names the diet first.
		if str(ctx.get("diet", "hold")) != "cut":
			return "Switch to the cut diet: about %.2f kg off a week (%d kcal a day under)." % [
				WeekPlan.CUT_DEFICIT * 7.0 / WeekPlan.KCAL_PER_KG, int(WeekPlan.CUT_DEFICIT)]
		var fat0 := float(ctx.get("fatigue", 20.0))
		var more := float(WeekPlan.day("shadow", "light", ctx, fat0)["kg"]) - float(WeekPlan.day("roadwork", "hard", ctx, fat0)["kg"])
		return "Swap a light morning for HARD roadwork: about %.2f kg more off a week toward the limit." % more
	var worst := {}
	for r in rws:
		if str(r["unit"]) == "stat" and not bool(r["ok"]) and (worst.is_empty() or float(r["plan"]) - float(r["actual"]) > float(worst["plan"]) - float(worst["actual"])):
			worst = r
	if not worst.is_empty():
		for id in WeekPlan.ORDER:
			if str(WeekPlan.SESSIONS[id]["stat"]) == str(worst["id"]):
				return "Add a %s morning: %s came in under the plan." % [str(WeekPlan.SESSIONS[id]["name"]).to_lower(), str(worst["label"]).to_lower()]
	return "Keep the week: it did what it said. It repeats on its own."
