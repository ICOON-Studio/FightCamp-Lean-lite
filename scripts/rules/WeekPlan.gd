extends RefCounted
## S354 CORE3 step 1 (operator: "when picking up the morning exercises it has to sum up gains/loses towards a goal , first
## week comes close to the goals,then the player adjust a bit the intesity to burn weight"): the week as seven mornings
## {session, intensity}; each morning's numbers (stat gain, kg, fatigue) and where the week - and the camp - lands against
## the goal. Design: Game Godot/research/CORE3_DESIGN_S354.md; mockup docs/mockups/S354_core_loop.png.
##   day(id, intensity, ctx, fatigue) -> {stat, gain, kcal, kg, load, fatigue}
##   week(days, ctx) -> {days, gains, kg, weight_end, fatigue_end, peak, peak_day, red, stats_end}
##   project(days, ctx, weeks) -> the same week repeated: {weight, stats, peak, weeks}
##   goal_lines(goal, days, ctx, weeks) -> [{id, label, now, week, end, target, ok, short}]
## ctx = {stats, pot, coach (rating), weight, diet: hold|cut, fatigue (carried in)}; days = [[id, intensity] x 7].
## Real-world numbers:
## - Energy: kcal = MET x kg x hours (Compendium of Physical Activities 2024, checked by John S354): running 10 km/h 9.3,
##   high-intensity intervals 11.0, vigorous circuit weights 6.0, heavy bag 5.8. Body fat ~7,700 kcal a kg (it overstates
##   the loss after a few weeks as the body adapts - Hall 2008 - fine for a 4-6 week camp).
## - The diet: HOLD eats for daily life + a 300 kcal training allowance; CUT eats 500 kcal less (a 500 kcal deficit is the
##   usual ~0.5 kg a week; a safe cut is 0.5-1 % of body weight a week - Reale et al. 2017, combat sports weight making).
## - Load = session RPE x minutes (Foster 2001; valid in boxers, Uchida 2014). Fatigue keeps 87 % a night: the Banister
##   model's ~7-day fatigue constant (John S354; the S354 first cut kept 75 %). 80+ = overreached (an ESTIMATE, playtest it):
##   one greedy week climbs toward it, a second one gets there; the coach's week settles in the 50s.
## - Gain: a session is a fifth of a focused week (TrainingPreview's rule, so the planner and the sim read one number);
##   light / normal / hard x 0.6 / 1.0 / 1.3 (TrainingLoad's settings). A morning started at 80+ fatigue trains at 0.6.

const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")

## id -> {name, stat, met, min (minutes at normal), rpe}. Rest trains nothing and is where fatigue drains.
const SESSIONS := {
	"roadwork": {"name": "Roadwork", "stat": "conditioning", "met": 9.3, "min": 45.0, "rpe": 5.0},
	"intervals": {"name": "Intervals", "stat": "conditioning", "met": 11.0, "min": 30.0, "rpe": 8.0},
	"heavy_bag": {"name": "Heavy bag", "stat": "power", "met": 5.8, "min": 40.0, "rpe": 6.0},
	"strength": {"name": "Strength circuit", "stat": "power", "met": 6.0, "min": 45.0, "rpe": 6.0},
	"speed_bag": {"name": "Speed bag", "stat": "speed", "met": 5.5, "min": 30.0, "rpe": 4.0},
	"slip_rope": {"name": "Slip rope", "stat": "defense", "met": 4.5, "min": 30.0, "rpe": 4.0},
	"shadow": {"name": "Shadow boxing", "stat": "technique", "met": 5.5, "min": 30.0, "rpe": 4.0},
	"neck": {"name": "Neck work", "stat": "chin", "met": 3.5, "min": 20.0, "rpe": 3.0},
	"rest": {"name": "Rest", "stat": "", "met": 0.0, "min": 0.0, "rpe": 0.0},
}
const ORDER := ["roadwork", "intervals", "heavy_bag", "strength", "speed_bag", "slip_rope", "shadow", "neck", "rest"]
## intensity -> {gain, burn (kcal x), load (RPE x minutes x)}
const INTENSITY := {
	"light": {"gain": 0.6, "burn": 0.7, "load": 0.6, "label": "Light"},
	"normal": {"gain": 1.0, "burn": 1.0, "load": 1.0, "label": "Normal"},
	"hard": {"gain": 1.3, "burn": 1.35, "load": 1.5, "label": "Hard"},
}
const SESSION_SHARE := 0.2
const KCAL_PER_KG := 7700.0
const ALLOWANCE := 300.0
const CUT_DEFICIT := 500.0
const FATIGUE_KEEP := 0.87
const LOAD_PER_FATIGUE := 26.0
const OVERREACHED := 80.0
const TIRED_GAIN := 0.6
## The coach's week: a camp's opening week that lands NEAR the goal and leaves the player dials to turn.
const COACH_WEEK := [["roadwork", "normal"], ["heavy_bag", "normal"], ["intervals", "normal"], ["speed_bag", "light"],
	["roadwork", "normal"], ["strength", "normal"], ["rest", "normal"]]


static func session(id: String) -> Dictionary:
	return SESSIONS.get(id, SESSIONS["rest"])


static func day(id: String, intensity: String, ctx: Dictionary, fatigue: float) -> Dictionary:
	var s := session(id)
	var it: Dictionary = INTENSITY.get(intensity, INTENSITY["normal"])
	var kg_body := float(ctx.get("weight", 60.0))
	var kcal := float(s["met"]) * kg_body * float(s["min"]) / 60.0 * float(it["burn"])
	var load := float(s["rpe"]) * float(s["min"]) * float(it["load"])
	var stat := str(s["stat"])
	var gain := 0.0
	var stats: Dictionary = ctx.get("stats", {})
	if stat != "" and stats.has(stat):
		var share := SESSION_SHARE * float(it["gain"]) * (TIRED_GAIN if fatigue >= OVERREACHED else 1.0)
		gain = float(TrainingPreview.preview_gain(stats, int(ctx.get("pot", 70)), {"training_modifiers": [stat]},
			float(ctx.get("coach", 50.0)), 1.0, share).get(stat, 0.0))
	var deficit := CUT_DEFICIT if str(ctx.get("diet", "hold")) == "cut" else 0.0
	var kg := -(kcal - ALLOWANCE + deficit) / KCAL_PER_KG
	var after := clampf(fatigue * FATIGUE_KEEP + load / LOAD_PER_FATIGUE, 0.0, 100.0)
	return {"id": id, "intensity": intensity, "stat": stat, "gain": gain, "kcal": kcal, "kg": kg, "load": load, "fatigue": after}


static func week(days: Array, ctx: Dictionary) -> Dictionary:
	var stats: Dictionary = (ctx.get("stats", {}) as Dictionary).duplicate()
	var weight := float(ctx.get("weight", 60.0))
	var fat := float(ctx.get("fatigue", 20.0))
	var out_days: Array = []
	var gains := {}
	var peak := fat
	var peak_day := -1
	var red: Array = []
	for i in days.size():
		var d: Array = days[i]
		var c := ctx.duplicate()
		c["stats"] = stats
		c["weight"] = weight
		var r := day(str(d[0]), str(d[1]), c, fat)
		if r["stat"] != "":
			stats[r["stat"]] = float(stats[r["stat"]]) + float(r["gain"])
			gains[r["stat"]] = float(gains.get(r["stat"], 0.0)) + float(r["gain"])
		weight += float(r["kg"])
		fat = float(r["fatigue"])
		if fat > peak:
			peak = fat
			peak_day = i
		# Two hard mornings in a row: the second is the red day (S353 mockup rule).
		if i > 0 and str(d[1]) == "hard" and str((days[i - 1] as Array)[1]) == "hard" and str(d[0]) != "rest":
			red.append(i)
		out_days.append(r)
	return {"days": out_days, "gains": gains, "kg": weight - float(ctx.get("weight", 60.0)), "weight_end": weight,
		"fatigue_end": fat, "peak": peak, "peak_day": peak_day, "red": red, "stats_end": stats}


## The same week repeated `weeks` times (the camp to fight night): stats, weight and fatigue carried week to week.
static func project(days: Array, ctx: Dictionary, weeks: int) -> Dictionary:
	var c := ctx.duplicate()
	var peak := 0.0
	for _w in maxi(0, weeks):
		var w := week(days, c)
		c["stats"] = w["stats_end"]
		c["weight"] = w["weight_end"]
		c["fatigue"] = w["fatigue_end"]
		peak = maxf(peak, float(w["peak"]))
	return {"weight": float(c.get("weight", 60.0)), "stats": c.get("stats", {}), "peak": peak, "weeks": weeks}


## goal = {limit (kg at the weigh-in), stat, target}; weeks = weeks to fight night (this week included).
static func goal_lines(goal: Dictionary, days: Array, ctx: Dictionary, weeks: int) -> Array:
	var w := week(days, ctx)
	var p := project(days, ctx, weeks)
	var out: Array = []
	if goal.has("limit"):
		var lim := float(goal["limit"])
		out.append({"id": "weight", "label": "Weight", "now": float(ctx.get("weight", 60.0)), "week": float(w["weight_end"]),
			"end": float(p["weight"]), "target": lim, "ok": float(p["weight"]) <= lim, "short": maxf(0.0, float(p["weight"]) - lim)})
	var stat := str(goal.get("stat", ""))
	if stat != "":
		var now := float((ctx.get("stats", {}) as Dictionary).get(stat, 0.0))
		var end := float((p["stats"] as Dictionary).get(stat, now))
		out.append({"id": stat, "label": stat.capitalize().replace("_", " "), "now": now,
			"week": float((w["stats_end"] as Dictionary).get(stat, now)), "end": end, "target": float(goal.get("target", now)),
			"ok": end >= float(goal.get("target", now)), "short": maxf(0.0, float(goal.get("target", now)) - end)})
	out.append({"id": "fatigue", "label": "Fatigue peak", "now": float(ctx.get("fatigue", 20.0)), "week": float(w["peak"]),
		"end": float(p["peak"]), "target": OVERREACHED, "ok": float(p["peak"]) < OVERREACHED,
		"short": maxf(0.0, float(p["peak"]) - OVERREACHED + 0.001)})
	return out
