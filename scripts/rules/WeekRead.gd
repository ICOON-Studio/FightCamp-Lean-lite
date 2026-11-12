extends RefCounted
## S387 MENUREVIEW1 (ops/research/MENU_CRITIC_S386.md, build list 3): what the week really did, in numbers the player can act
## on. Pure static functions over the game's own rules: the pace is WeekPlan.project (TrainingPreview's gain), the goal is
## Sim.goal_read (FighterGoal), the cash steps GameMoney.settle_week and the close clock is GymBills. WeekReview draws it.
##   path(days, ctx, evenings, later) -> [{stat: value} after each coming week, HORIZON of them]
##   cause(top) -> "roadwork Mon + Fri, intervals Wed"   (top = WeekCause.top)
##   stat(x, path, label, wait) -> {tick, gain, next, eta, text, why}
##   goal(gr, share_was) -> {state, word, share, was, short, days, text}   (gr = Sim.goal_read)
##   rank(before, after, div) -> {kind, move, text}
##   runway(cash, accrued, income, costs, day, weeks_below) -> {state, word, net, weeks, back, close, frac, text}

const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

## How many weeks ahead an ETA looks: past this a stat reads "12+ weeks".
const HORIZON := 12
## How many sessions a cause names.
const SHOWN := 3
## Stats stop here (Sim.STAT_CAP; a rule module cannot preload Sim).
const STAT_CAP := 99.0
## How many weeks ahead the runway steps the cash: past this it reads as more than a year.
const RUNWAY_WEEKS := 52
## The runway bar is full at twice the warning line (GymBills: under 8 weeks the cash turns amber).
const RUNWAY_FULL := GymBills.WARN_RUNWAY_WEEKS * 2
## The evening sessions' long names (WeekPlan.EVENINGS), said short.
const SHORT := {"Pads and drills": "pads", "Sparring vs a partner": "sparring"}


## The stats after each of the next HORIZON weeks: this week's plan, then `later` ([days, evenings, phase] a week), each
## week stepped as WeekPlan.project steps it (stats, weight and fatigue carried over).
## S443: with the fighter `f`, each week also carries her attributes ("attrs", the days run through Attrs.run_days as
## Sim.step_day runs them), so a row shown as an attribute (StatBlock.SHOWN_AS) reads its own number's pace.
static func path(days: Array, ctx: Dictionary, evenings: Array, later: Array, f: Dictionary = {}) -> Array:
	var c := ctx.duplicate()
	var g := {}
	if not f.is_empty():
		g = f.duplicate()
		g["attrs"] = Attrs.of(f).duplicate()
		g["stats"] = (f["stats"] as Dictionary).duplicate()
		g["stats_seen"] = (f.get("stats_seen", {}) as Dictionary).duplicate()
	var out: Array = []
	for k in HORIZON:
		var wk: Array = later[k - 1] if k > 0 and k - 1 < later.size() else [days, evenings, str(ctx.get("phase", ""))]
		c["phase"] = str(wk[2])
		var w := WeekPlan.week(wk[0], c, wk[1])
		c["stats"] = w["stats_end"]
		c["weight"] = w["weight_end"]
		c["fatigue"] = w["fatigue_end"]
		var row: Dictionary = (w["stats_end"] as Dictionary).duplicate()
		if not g.is_empty():
			Attrs.run_days(g, w["days"], str(c.get("camp_stat", "")), float(c.get("camp_mult", 1.0)))
			row["attrs"] = (g["attrs"] as Dictionary).duplicate()
		out.append(row)
	return out


## The first week on `route` that `stat` reaches `target`; 0 when none does. `attr`: `stat` is an attribute (the week's "attrs").
static func eta(stat: String, target: float, route: Array, attr := false) -> int:
	for i in route.size():
		if at(route[i], stat, attr, 0.0) >= target:
			return i + 1
	return 0


## One week's value on the route: an old stat, or an attribute from the week's "attrs".
static func at(week: Dictionary, stat: String, attr: bool, missing: float) -> float:
	var d: Dictionary = week.get("attrs", {}) if attr else week
	return float(d.get(stat, missing))


## The sessions behind a gain and their days: "roadwork Mon + Fri, intervals Wed". "" when nothing trained it.
static func cause(top: Array) -> String:
	var parts: Array = []
	for r in top.slice(0, SHOWN):
		var who := str(SHORT.get(str(r[0]), str(r[0]).to_lower()))
		var days: Array = (r[3] as Array).duplicate() if (r as Array).size() > 3 else []
		days.sort()
		parts.append("%s %s" % [who, " + ".join(days.map(func(d): return Clock.DAYS[posmod(int(d), 7)]))] if not days.is_empty()
			else "%s x%d" % [who, int(r[1])])
	return ", ".join(parts)


## One stat's line. `x` is a report row ({st, before, after, src}), `wait` the weeks she is out injured.
## A crossed point: "+1 Technique: pads Tue + Thu". Otherwise the next point: "Technique 61 in ~3 weeks".
static func stat(x: Dictionary, route: Array, label: String, wait := 0) -> Dictionary:
	var ab := str(x.get("attr", ""))   # S443: a row shown as an attribute (StatBlock.week_rows) reads that attribute's pace
	var key := ab if ab != "" else str(x["st"])
	var before := float(x["before"])
	var after := float(x["after"])
	var why := cause(x.get("src", []))
	var next := int(floorf(after)) + 1
	var out := {"tick": TrainingPreview.crossed_point(before, after), "gain": int(floorf(after)) - int(floorf(before)),
		"next": next, "eta": 0, "why": why}
	var weeks := eta(key, float(next), route, ab != "")
	out["eta"] = weeks + wait if weeks > 0 else 0
	if bool(out["tick"]):
		out["text"] = "+%d %s" % [int(out["gain"]), label] + (": " + why if why != "" else "")
	elif float(next) > STAT_CAP:
		out["text"] = "%s at the top" % label
	elif weeks > 0:
		out["text"] = "%s %d %s" % [label, next, "next week" if int(out["eta"]) == 1 else "in ~%d weeks" % int(out["eta"])]
	elif not route.is_empty() and at(route[-1], key, ab != "", after) > after + 0.005:
		out["text"] = "%s %d in %d+ weeks" % [label, next, route.size() + wait]
	else:
		out["text"] = "Not on the plan"
	return out


## The goal against its deadline at this pace. `gr` is Sim.goal_read, `share_was` the bar's share a week ago.
## state: met, on_pace, tight (lands, but inside FighterGoal's 2-day buffer), behind or missed.
static func goal(gr: Dictionary, share_was := 0.0) -> Dictionary:
	if gr.is_empty():
		return {}
	var code := str(gr.get("code", ""))
	var left := int(gr.get("days_left", gr.get("left", 0)))
	var rate: Dictionary = gr.get("rate", {})
	var worst := {}
	var unbooked := false
	for row in gr.get("targets", []):
		if str(row["key"]) == "booked_fight":
			unbooked = not bool(row["met"])
		elif not bool(row["met"]) and (worst.is_empty() or float(row["projected"]) - float(row["target"]) < float(worst["projected"]) - float(worst["target"])):
			worst = row
	var margin := 0.0 if worst.is_empty() else float(worst["projected"]) - float(worst["target"])
	var per_day := 0.0 if worst.is_empty() else float(rate.get(str(worst["key"]), 0.0))
	var state := "behind"
	if code == "MET":
		state = "met"
	elif code == "MISSED":
		state = "missed"
	elif code == "ON_TRACK":
		state = "on_pace"
	elif margin >= 0.0:
		state = "tight"
	var days := roundi(margin / per_day) if per_day > 0.0 else 0   # days to spare, or below 0 days late
	var text := "Goal met."
	if state == "missed":
		text = "Deadline passed %s ago." % _days(-left)
		if not worst.is_empty():
			text = "%s: deadline passed %s ago." % [str(worst["line"]), _days(-left)]
	elif state != "met":
		text = _pace(worst, margin, days, per_day, left) + ("%s left." % _days(left) if left > 0 else "deadline today.")
		if unbooked:
			text += " No fight booked yet."
	return {"state": state, "word": {"met": "MET", "on_pace": "ON PACE", "tight": "TIGHT", "behind": "BEHIND", "missed": "MISSED"}[state],
		"title": str(gr.get("title", "")), "share": float(gr.get("share", 0.0)), "was": minf(share_was, float(gr.get("share", 0.0))),
		"short": maxf(0.0, -margin), "days": days, "text": text}


## "Conditioning 58.2 / 59.8: 5 days early, " - how far ahead of or behind the deadline this pace lands.
static func _pace(worst: Dictionary, margin: float, days: int, per_day: float, left: int) -> String:
	if worst.is_empty():
		return ""
	var head := str(worst["line"]) + ": "
	if per_day <= 0.0:
		return head + "not on the plan, "
	if margin >= 0.0:
		return head + ("%s early, " % _span(days) if days > 0 else "lands on the deadline, ")
	return head + "%.1f short%s (%s late), " % [-margin, " at the deadline" if left > 0 else "", _span(maxi(1, -days))]


## "5 days", "~2 weeks".
static func _span(days: int) -> String:
	if days < 7:
		return _days(days)
	var w := roundi(days / 7.0)
	return "~1 week" if w == 1 else "~%d weeks" % w


static func _days(n: int) -> String:
	return "1 day" if n == 1 else "%d days" % n


## The rank move this week (0 = unranked). kind: up, down, same, first, out or none; move = places, up positive.
static func rank(before: int, after: int, div: String) -> Dictionary:
	if after == before:
		return {"kind": "none" if after == 0 else "same", "move": 0,
			"text": "Unranked in the %s rankings." % div if after == 0 else "%d in the %s rankings, no change." % [after, div]}
	if before == 0:
		return {"kind": "first", "move": 0, "text": "%d in the %s rankings, a first ranking." % [after, div]}
	if after == 0:
		return {"kind": "out", "move": 0, "text": "Out of the %s rankings (was %d)." % [div, before]}
	return {"kind": "up" if after < before else "down", "move": before - after,
		"text": "%s %d to %d in the %s rankings." % ["Up" if after < before else "Down", absi(before - after), after, div]}


## The cash ahead at this week's running balance, stepped week by week as Sim.end_week steps it: income in, costs on the
## month-end bill (GameMoney.settle_week), the close clock counting weeks in a row below $0 (GymBills). `accrued` is the
## bill already run up and `day` is today. Steps land on week ends (multiples of 7). On a week-end day that is
## `day + 7 * w`, unchanged. One-offs (purses, signing fees) are left out: they are not a pace.
## weeks: weeks until a week ends below $0 (-1 not inside RUNWAY_WEEKS, 0 already below); back: weeks until it is back above
## $0 (-1 not while below); close: weeks until the gym closes (-1 not inside RUNWAY_WEEKS). state follows GymBills.status.
static func runway(cash: int, accrued: int, income: int, costs: int, day: int, weeks_below: int) -> Dictionary:
	var net := income - costs
	var now := cash
	var owed := accrued
	var below := weeks_below
	var dry := 0 if cash < 0 else -1
	var back := -1
	var close := 0 if weeks_below >= GymBills.CLOSE_AFTER_WEEKS else -1
	for w in range(1, RUNWAY_WEEKS + 1):
		if close >= 0:
			break
		var s := GameMoney.settle_week(now, owed, income, costs, _week_end(day, w))
		now = int(s["cash"])
		owed = int(s["accrued"])
		below = GymBills.next_below(now, below)
		if now < 0 and dry < 0:
			dry = w
		if now >= 0 and cash < 0 and back < 0:
			back = w
		if below >= GymBills.CLOSE_AFTER_WEEKS:
			close = w
	var state := "ok"
	if weeks_below >= GymBills.CLOSE_AFTER_WEEKS:
		state = "closed"
	elif cash < 0:
		state = "red"
	elif dry >= 0 and dry < GymBills.WARN_RUNWAY_WEEKS:
		state = "warn"
	var frac := 1.0 if dry < 0 else clampf(float(dry) / float(RUNWAY_FULL), 0.0, 1.0)
	if cash < 0:   # below $0 the bar is what is left of the close clock
		frac = clampf(1.0 - float(weeks_below) / float(GymBills.CLOSE_AFTER_WEEKS), 0.0, 1.0)
	return {"state": state, "word": {"ok": "SAFE", "warn": "LOW", "red": "BELOW $0", "closed": "CLOSED"}[state], "net": net,
		"weeks": dry, "back": back, "close": close, "frac": frac, "text": _runway_text(state, cash, net, dry, back, close, weeks_below)}


static func _runway_text(state: String, cash: int, net: int, dry: int, back: int, close: int, weeks_below: int) -> String:
	var rule := GymBills.CLOSE_AFTER_WEEKS
	var pace := "%s%s a week" % ["+" if net > 0 else "", GameMoney.text(net)]
	if state == "closed":
		return "The gym has closed: %d weeks in a row below $0." % weeks_below
	if state == "red":
		var clock := "%s in a row below $0, %d more closes the gym." % [_weeks(weeks_below), rule - weeks_below]
		# Costs wait for the month-end bill, so a losing gym can climb above $0 for a week and fall back: only the close counts.
		if close >= 0 and (back < 0 or net < 0):
			return "%s %s: closes in ~%s." % [clock, pace, _weeks(close)]
		return "%s %s: back above $0 in ~%s." % [clock, pace, _weeks(back)]
	if dry < 0:
		if net > 0:
			return "%s: cash grows, no limit at this pace." % pace
		if net == 0:
			return "%s: cash holds at %s." % [pace, GameMoney.text(cash)]
		return "%s: cash lasts over %d weeks." % [pace, RUNWAY_WEEKS]
	var then := "%d weeks in a row below $0 closes the gym" % rule
	if net >= 0:
		return "%s, but the month-end bill takes cash below $0 in ~%s. %s." % [pace, _weeks(dry), then]
	return "%s: cash lasts ~%s, then %s." % [pace, _weeks(dry), then]


static func _weeks(n: int) -> String:
	return "1 week" if n == 1 else "%d weeks" % n


## The day the w-th coming week ends (1-based). Sim closes a week when the day is a multiple of 7.
static func _week_end(day: int, w: int) -> int:
	if day % 7 == 0:
		return day + 7 * w
	return day + (7 - day % 7) + 7 * (w - 1)
