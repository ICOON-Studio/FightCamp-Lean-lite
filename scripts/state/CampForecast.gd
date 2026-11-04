extends RefCounted
## S379 CAMPCARDS: the FIGHT CAMP modal's forecast - a dry run of the days to fight night exactly as Sim.step_day steps them,
## for one camp focus and protocol, on a copy of the fighter (never the fighter itself):
## - the week: the coach's phase week with the camp's stat as the main session (WeekPhase / WeekPlan.days_of), the twist card
##   in play and the player's own exceptions; a fresh Monday drops the twist (the next card is not drawn yet - as
##   Sim.weigh_forecast does);
## - each day's gain: WeekPlan.full_day - TrainingPreview's pace (1.0 a focused week x coach x headroom
##   clamp((pot - stat) / 25, 0.10, 1.25), a session a fifth of it, x0.6 / 1.0 / 1.3 Light / Normal / Hard, x0.6 from 80
##   fatigue) - times BoutRules.camp_gain_mult (the protocol's x1.1 / 1.2 / 1.35 on the camp's stat); an injured day rests
##   at TrainingLoad's rest share (Injuries.gain_mult);
## - the weight: the cut while over the limit (Sim.week_ctx), clamped as the real day clamps it; the fatigue: the camp's peak.
## - S380 the protocol's evenings (BoutRules.camp_evening through Sim.week_ctx: pads drill the camp's stat, their load
##   scales fatigue and hours), the injury chance of the week-end training rolls before the bout (Injuries.end_week:
##   InjuryRoll.training_chance on the week's hours, ratio to her usual and peak fatigue) and the heavy legs on the night.
##   run(c, f, focus, protocol, film) -> {stats, kg (weigh-in morning), limit, weigh_ok, fatigue_now, fatigue_end, peak, days,
##     injury (0..1 over the camp), stale (energy lost at the first bell)}
##   all(c, f, protocol) -> {focus: run(...)} for every BoutRules.CAMP_FOCUSES entry

const Sim := preload("res://scripts/state/Sim.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")


static func run(c: Career, f: Dictionary, focus: String, protocol: int, film := false) -> Dictionary:
	var g := f.duplicate(true)
	# S381 film takes a pad night of the camp's first week when that is a Build week (WeekPhase.film_night): her camp's own
	# start, else the camp opens today
	g["camp"] = {"focus": focus, "protocol": protocol, "film": film,
		"start": int((f.get("camp", {}) as Dictionary).get("start", c.day))}
	var bout: Dictionary = g.get("bout", {})
	var n := maxi(0, int(bout.get("day", c.day)) - c.day)   # fight night is stepped to, never trained on
	var inj: Dictionary = g.get("injury", {})
	var until := int(inj.get("until_day", -1)) if not inj.is_empty() else -1
	var lim := float(g["limit"])
	var fat0 := float(g.get("week_fatigue", 20.0))
	var peak := fat0
	var kg := float(g["weight"])
	var wpeak := float(g.get("week_peak", fat0))
	var safe := 1.0   # the chance no week-end training roll before the bout hurts her
	for i in n:
		var d := c.day + i
		var dow := posmod(d, 7)   # day 0 is a Monday (Clock)
		if dow == 0 or not g.has("phase"):
			WeekPhase.sync(g, d)
		if dow == 0:
			g.erase("twist")
			wpeak = float(g.get("week_fatigue", 20.0))
		var tw := WeekTwist.active(g)
		var days := WeekTwist.days(tw, WeekPlan.days_of(g))
		var evs := WeekTwist.evenings(tw, WeekPlan.evenings_of(g))
		var resting := d < until
		var m: Array = ["rest", "normal"] if resting else (days[dow] as Array)
		var r := WeekPlan.full_day(str(m[0]), str(m[1]), "rest" if resting else str(evs[dow]), Sim.week_ctx(c, g),
			float(g.get("week_fatigue", 20.0)))
		var mult := TrainingLoad.gain("rest") if resting else 1.0
		for k in [["stat", "gain"], ["stat2", "gain2"]]:
			var st := str(r.get(k[0], ""))
			if st != "" and (g["stats"] as Dictionary).has(st):
				g["stats"][st] = minf(Sim.STAT_CAP, float(g["stats"][st]) + float(r[k[1]]) * BoutRules.camp_gain_mult(g["camp"], st) * mult)
		var lo := minf(float(g["weight"]), lim - 1.5)
		var hi := maxf(float(g["weight"]), lim + 1.6)
		g["weight"] = clampf(float(g["weight"]) + float(r["kg"]), lo, hi)
		g["week_fatigue"] = float(r["fatigue"])
		peak = maxf(peak, float(r["fatigue"]))
		wpeak = maxf(wpeak, float(r["fatigue"]))
		if i + 1 == n - 1:   # the weigh-in is the morning before the bout
			kg = float(g["weight"])
		if posmod(d + 1, 7) == 0:   # Injuries.end_week, as the next Monday starts
			var usual := Injuries.chronic(g)
			var h := TrainingLoad.hours("rest") if d + 1 < until else Injuries.week_hours(g)
			if d + 1 >= until:
				# a twist answered "push through" (risk 2) rolls twice, as Injuries.end_week does (this week's card only)
				safe *= pow(1.0 - InjuryRoll.training_chance(h, h / usual if usual > 0.0 else 1.0, wpeak), int(WeekTwist.active(g).get("risk", 1)))
			g["chronic"] = TrainingLoad.next_chronic(usual, h)
	var fe := float(g.get("week_fatigue", fat0))
	return {"stats": g["stats"], "kg": kg, "limit": lim, "weigh_ok": BoutRules.made_weight(kg, lim), "fatigue_now": fat0,
		"fatigue_end": fe, "peak": peak, "days": n, "injury": 1.0 - safe, "stale": BoutRules.stale_energy(fe, g["camp"])}


static func all(c: Career, f: Dictionary, protocol: int, film := false) -> Dictionary:
	var out := {}
	for key in BoutRules.CAMP_FOCUSES:
		out[key] = run(c, f, key, protocol, film)
	return out

