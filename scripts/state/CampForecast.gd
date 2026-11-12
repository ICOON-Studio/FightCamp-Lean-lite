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
##   InjuryRoll.training_chance on the week's hours, ratio to her usual and peak fatigue) and the Tank off at the first bell
##   (S433 BoutRules.tank_for, camp or not: the bout reads the same number).
##   run(c, f, focus, protocol, film) -> {stats, attrs (her abilities on fight night), kg (weigh-in morning), limit, weigh_ok, fatigue_now, fatigue_end, peak, days,
##     injury (0..1 over the camp), stale (the Tank off at the first bell), tank_why (its parts in words)}
##   S434: protocol 0 for a fighter with no camp forecasts her real week (no camp set), not a protocol-0 "camp".
##   all(c, f, protocol) -> {focus: run(...)} for every BoutRules.CAMP_FOCUSES entry
##   for_read(c, f, opp) -> f, or a copy whose booked bout carries "tank_ahead" (the bout page's chance reads fight night)

const Sim := preload("res://scripts/state/Sim.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")


static func run(c: Career, f: Dictionary, focus: String, protocol: int, film := false) -> Dictionary:
	var g := f.duplicate(true)
	# S381 film takes a pad night of the camp's first week when that is a Build week (WeekPhase.film_night): her camp's own
	# start, else the camp opens today
	g["camp"] = {"focus": focus, "protocol": protocol, "film": film,
		"start": int((f.get("camp", {}) as Dictionary).get("start", c.day))}
	if protocol < 1 and (f.get("camp", {}) as Dictionary).is_empty():
		g["camp"] = {}   # S434 no camp is no camp: a protocol-0 "camp" cut weight (Sim.week_ctx) where her real week does not
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
		var evs := PadWeek.evenings(g)   # S382 EVENINGS1: the strip's nights
		var resting := d < until
		var m: Array = ["rest", "normal"] if resting else (days[dow] as Array)
		var r := WeekPlan.full_day(str(m[0]), str(m[1]), "rest" if resting else str(evs[dow]), Sim.week_ctx(c, g),
			float(g.get("week_fatigue", 20.0)))
		var mult := TrainingLoad.gain("rest") if resting else 1.0
		# S434 as Sim.step_day trains: through her attributes (Attrs.apply_session), so Recovery's gain reaches the next
		# day's fatigue as it does on the real days (the Training tab's Tank is the bout's)
		for k in [["stat", "gain"], ["stat2", "gain2"]]:
			var st := str(r.get(k[0], ""))
			if st != "" and (g["stats"] as Dictionary).has(st):
				var gain := minf(Sim.STAT_CAP - float(g["stats"][st]), float(r[k[1]]) * BoutRules.camp_gain_mult(g["camp"], st) * mult * GymSpend.gain(c, st, g))
				Attrs.apply_session(g, str(m[0]) if k[0] == "stat" else str(r.get("evening", "")), st, maxf(0.0, gain))
		if float(r.get("attr_gain", 0.0)) > 0.0:
			Attrs.apply_session(g, str(m[0]), "", float(r["attr_gain"]) * mult)
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
				safe *= pow(1.0 - InjuryRoll.training_chance(h, h / usual if usual > 0.0 else 1.0, wpeak, GymSpend.train_risk(c)), int(WeekTwist.active(g).get("risk", 1)))
			g["chronic"] = TrainingLoad.next_chronic(usual, h)
	var fe := float(g.get("week_fatigue", fat0))
	var tp := BoutRules.tank_parts_for(c.results, g, fe, int(bout.get("day", c.day)))   # S433 the Tank, camp or not
	# S439 CARDIO1 round 3: her attributes on fight night too (the Cardio card reads Stamina here, the number the bout reads)
	return {"stats": g["stats"], "attrs": (Attrs.of(g) as Dictionary).duplicate(), "kg": kg, "limit": lim, "weigh_ok": BoutRules.made_weight(kg, lim), "fatigue_now": fat0,
		"fatigue_end": fe, "peak": peak, "days": n, "injury": 1.0 - safe, "stale": float(tp["off"]), "tank_why": BoutRules.tank_words(tp)}


static func all(c: Career, f: Dictionary, protocol: int, film := false) -> Dictionary:
	var out := {}
	for key in BoutRules.CAMP_FOCUSES:
		out[key] = run(c, f, key, protocol, film)
	return out



## S434 the fighter as the bout page's chance reads her (BoutRead through BoutRules.tank_read): with a bout booked and not
## fought, a copy whose bout carries the Tank her own forecast puts on fight night ("tank_ahead": her camp, else her real
## week - the Training tab's number), not today's tiredness. opp another than the booked one (an offer): f as she is.
static func for_read(c: Career, f: Dictionary, opp: Dictionary = {}) -> Dictionary:
	var b: Dictionary = f.get("bout", {})
	if b.is_empty() or bool(b.get("done", false)) or b.has("stale") or int(b.get("day", -1)) < c.day:
		return f
	if not opp.is_empty() and str(opp.get("name", "")) != str((b.get("opp", {}) as Dictionary).get("name", "")):
		return f
	var cp: Dictionary = f.get("camp", {})
	var g := f.duplicate(true)
	g["bout"]["tank_ahead"] = float(run(c, f, str(cp.get("focus", "")), int(cp.get("protocol", 0)), bool(cp.get("film", false)))["stale"])
	return g
