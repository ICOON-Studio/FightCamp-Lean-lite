extends RefCounted
## S496 TRAININGK1 (operator Q-S294-259 "Yes, build it": Training K v6c, ops/AgentComms/board_attach/
## Q-S294-259_0_training_k_v6c_nobout.png): the club's week as the Training screen shows it. Every number comes from a rule:
## mornings and tiredness WeekPlan.week (through WeekData.plan_of), evenings PadWeek / PadEdit (WeekData.pack), the coach's
## pad session (PAD_MIN, every boxer on pads gets all of it), work mornings DayJob, the coach's pick WeekCoach, fight night CampForecast +
## Gauges. No UI here.
##   model(c, sel_id, sel_day) -> {cards, sel, days[7], tired, moves, totals, diet, pick, bout, night}

const Data := preload("res://scripts/state/Data.gd")
const WeekData := preload("res://scripts/state/WeekData.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekCoach := preload("res://scripts/rules/WeekCoach.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const CoachedMornings := preload("res://scripts/rules/CoachedMornings.gd")
const MorningWire := preload("res://scripts/state/MorningWire.gd")
const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")   # S519 the coach deals the coached mornings   # S511 club week 3.3: the WEAK SPOT line
const DayJob := preload("res://scripts/rules/DayJob.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const Gauges := preload("res://scripts/rules/Gauges.gd")
const GuardNotes := preload("res://scripts/rules/GuardNotes.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")

const SHORT := ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
const USABLE := 30.0
## S498 his Q-S294-260 "full pads, no sharing": a pad night is the coach's full 75-minute session for EVERY boxer on the pads
## that night, however many there are (the coach spec's pad session, COACHSPEC1_MAP_R5_S495.md). Drilling reads a full night.
const PAD_MIN := 75.0


## The boxer the screen opens on: the one asked for, else the first boxer.
static func pick(c: Career, sel_id: String) -> Dictionary:
	if sel_id != "":
		var f := c.fighter_by_id(sel_id)
		if not f.is_empty():
			return f
	return c.fighters[0] if not c.fighters.is_empty() else {}


static func model(c: Career, sel_id: String, sel_day: int) -> Dictionary:
	var f := pick(c, sel_id)
	var out := {"cards": cards(c), "sel": str(f.get("id", "")), "days": [], "monday": c.day - posmod(c.day, 7)}
	if f.is_empty():
		return out
	var g := f
	if WeekPhase.weekend(c.day):   # S397: on the weekend the board is next week's
		g = WeekPhase.ahead_view(f, c.day)
		g["_ahead"] = true
		out["monday"] = int(out["monday"]) + 7
		out["ahead"] = true
	var pl := WeekData.plan_of(c, g)
	var tired := WeekData.tired_days(pl)
	var pack := WeekData.pack(c, g)
	var goal: Dictionary = pl["goal"]
	var fdow := WeekData.fight_dow(c, g, goal)
	var wk: Dictionary = pl["wk"]
	var rest_days: Array = range(7).filter(func(k): return str((pl["days"][k] as Array)[0]) == "rest")
	var work: Array = DayJob.lost_days_of(f, rest_days)
	var changed: Dictionary = WeekPhase.edits(g).get("days", {})
	var coached: Dictionary = {} if out.get("ahead", false) else MorningWire.of(c, f)   # next week is not dealt yet
	var rows := PadEdit.night_rows(g, pack["projs"])
	var nights: Dictionary = (pack["inp"] as Dictionary)["nights"]
	for i in 7:
		var r: Dictionary = wk["days"][i]
		var m: Array = pl["days"][i]
		var am := {"id": str(m[0]), "intensity": str(m[1]), "stat": str(r.get("stat", "")), "gain": float(r.get("gain", 0.0)),
			"kg": float(r.get("kg", 0.0)), "rest": str(m[0]) == "rest", "work": work.has(i), "changed": changed.has(str(i)),
			"drop": float(tired[i][0]) - float(tired[i][1]) if i > 0 else 0.0, "red": (wk["red"] as Array).has(i),
			"coach": _coached(coached, i, str(r.get("stat", "")))}   # S519 club week 3.3: the coach's morning deal
		if str(m[0]) == "rest" and i > 0:
			am["drop"] = float(tired[i - 1][1]) - float(tired[i][1])
		out["days"].append({"dow": i, "date": "%s %d" % [SHORT[i], _date_n(int(out["monday"]) + i)],
			"coach": coach_cell(c, i, fdow),
			"am": am, "pm": evening(g, i, nights, rows, r, fdow), "tired": float(tired[i][1])})
	out["tired"] = {"start": float((pl["ctx"] as Dictionary).get("fatigue", 20.0)), "ends": tired.map(func(t): return float(t[1])),
		"limit": WeekPlan.OVERREACHED, "fresh": BoutRules.FRESH_FATIGUE, "peak": float(wk["peak"])}
	# S528 ONELOOK1 audit: the week-end injury roll (Injuries, InjuryRoll.training_chance) reads the hours against her usual
	# and the week's peak; outside a camp it was shown only in THIS CAMP, a hidden box. The Training row shows it now.
	var load := Injuries.ratio(g)
	out["tired"]["load"] = load
	out["tired"]["injury_x"] = InjuryRoll.load_mult(load) * InjuryRoll.fatigue_mult(float(wk["peak"]))
	out["moves"] = moves(g, rows)
	out["totals"] = totals(wk, out["days"])
	out["weak"] = CoachedMornings.weak_line(f.get("stats", {}))   # S511: the hole the fight finds, "" when none
	out["bout"] = {"booked": WeekData.booked(goal), "dow": fdow, "day": int((goal["bout"] as Dictionary).get("day", -1)),
		"phase": str(g.get("phase", "base"))}
	out["diet"] = diet(c, f, goal, wk)
	if bool(out["bout"]["booked"]):
		out["tired"]["bell"] = float(out["diet"].get("legs", -1.0))
	var said: Array = pl["lines"] if bool(out["bout"]["booked"]) else (pl["lines"] as Array).filter(func(l): return str(l["id"]) != "weight")
	out["pick"] = WeekCoach.advice(pl["days"], wk, said, str((pl["ctx"] as Dictionary).get("diet", "hold")))
	var opp: Dictionary = (goal["bout"] as Dictionary).get("opp", {})
	# S527: the guard notes (S526) lived in THIS CAMP, a hidden box on this screen; they show under COACH'S PICK instead.
	out["guard"] = GuardNotes.lines(OppFile.main_game(opp), not bool(f.get("pro", false))) if bool(out["bout"]["booked"]) and not opp.is_empty() else []
	out["opp_prep"] = ""
	for ln in pl["lines"]:
		if str(ln["id"]) == "opp":
			out["opp_prep"] = WeekOpp.words(ln)
	var oname := str(opp.get("name", ""))
	if oname != "":   # S448 names only in headers: the coach says "the opponent"
		out["pick"]["say"] = str(out["pick"]["say"]).replace(oname, "the opponent").replace(oname.get_slice(" ", 0), "the opponent")
	out["night"] = night(c, clampi(sel_day, 0, 6), fdow)
	return out


static func _date_n(day: int) -> int:
	return int(Clock.fmt(day).get_slice(" ", 1))


## Each fighter's card in the strip: boxers first (selectable), then the mat's grapplers.
static func cards(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		out.append(card(c, f))
	for g in c.grapplers:
		var b: Dictionary = g.get("bout", {})
		out.append({"id": str(g["id"]), "kind": "grappler", "name": str(g["name"]), "stem": Faces.stem(g),
			"line1": _short_class(str(g.get("wc", ""))) + ("" if str(g.get("wc", "")).contains("no-gi") else " · no-gi"), "line2": _bout_words(c, b),
			"tag": "MAT WEEK", "tag_kind": "mat", "note": "%d no-gi classes" % NoGi.CLASSES_PER_WEEK, "spark": []})
	return out


static func card(c: Career, f: Dictionary) -> Dictionary:
	var phase := str(f.get("phase", "base"))
	var b: Dictionary = f.get("bout", {})
	var on := not b.is_empty() and not bool(b.get("done", false))
	var tag := "BASE WEEK"
	var kind := "base"
	if on:
		kind = phase
		tag = "FIGHT WEEK" if phase == "taper" or int(b["day"]) - c.day <= 7 else str((WeekPhase.PHASES.get(phase, WeekPhase.PHASES["base"]) as Dictionary)["name"]).to_upper()
		if tag == "FIGHT WEEK":
			kind = "fight"
	var mins := 0.0
	for d in PadWeek.nights_of(f).get("pads", []):
		mins += PAD_MIN * (ClubClasses.BAG_SHARE if ClubClasses.on(c.coach, int(d)) else 1.0)
	var spark: Array = []
	var pl := WeekData.plan_of(c, f)
	for t in WeekData.tired_days(pl):
		spark.append(float(t[1]))
	var job := bool(f.get("day_job", false)) and not bool(f.get("pro", false))
	return {"id": str(f["id"]), "kind": "boxer", "name": str(f["name"]), "stem": Faces.stem(f),
		"line1": "%s %.0f kg · boxing" % [_short_class(str(f.get("wc", ""))), float(f.get("limit", 0.0))], "line2": _bout_words(c, b),
		"tag": tag, "tag_kind": kind, "note": "%d min" % roundi(mins), "coach_min": roundi(mins), "spark": spark,
		"work": job}


## "Featherweight" -> "Feather" (the card's short class word, as a gym board writes it).
static func _short_class(wc: String) -> String:
	return wc.replace("weight", "").strip_edges()


static func _bout_words(c: Career, b: Dictionary) -> String:
	if b.is_empty() or bool(b.get("done", false)):
		return "No bout booked"
	return "Bout %s · %d days" % [Clock.fmt(int(b["day"])), int(b["day"]) - c.day]


## The coach's evening on that weekday: a pad night (each boxer on the pads, each with the full session), sparring (he referees), the corner (a bout that
## night), Sunday closed, else no coaching.
static func coach_cell(c: Career, dow: int, fdow: int) -> Dictionary:
	if dow == 6:
		return {"kind": "closed", "boxers": []}
	var corner := false
	for f in c.fighters:
		var b: Dictionary = f.get("bout", {})
		if not b.is_empty() and not bool(b.get("done", false)) and int(b["day"]) == c.day - posmod(c.day, 7) + dow:
			corner = true
	if corner or dow == fdow:
		return {"kind": "corner", "boxers": []}
	var ids := DrillWeek.on_pads(c, dow)
	if not ids.is_empty():
		var bx: Array = []
		var cls := ClubClasses.on(c.coach, dow)   # S519 club week 3.2: a class night puts them on the bag
		for id in ids:
			bx.append({"fid": str(id), "stem": Faces.stem(c.fighter_by_id(str(id))), "min": PAD_MIN * (ClubClasses.BAG_SHARE if cls else 1.0)})
		return {"kind": "class" if cls else "pads", "boxers": bx}
	for f in c.fighters:
		if (PadWeek.nights_of(f).get("spar", []) as Array).has(dow):
			return {"kind": "spar", "boxers": []}
	return {"kind": "none", "boxers": []}


## Her evening: pads (her coach minutes, the card drilled and its mastery that night), sparring (Fight IQ), film, rest.
static func evening(f: Dictionary, i: int, nights: Dictionary, rows: Dictionary, r: Dictionary, fdow: int) -> Dictionary:
	var kind := "rest"
	if i == fdow:
		kind = "fight"
	elif (nights.get("pads", []) as Array).has(i):
		kind = "pads"
	elif (nights.get("spar", []) as Array).has(i):
		kind = "sparring"
	elif int(nights.get("film", -1)) == i:
		kind = "film"
	var out := {"kind": kind, "gain2": float(r.get("gain2", 0.0)), "stat2": str(r.get("stat2", "")), "cards": []}
	if kind == "pads":
		out["drill"] = PadWeek.night_minutes(nights, i)
	for card in rows:
		if (rows[card] as Dictionary).has(i):
			var a := float(rows[card][i][0])
			var b := float(rows[card][i][1])
			out["cards"].append({"card": str(card), "title": PadEdit.title(f, str(card)), "before": a, "after": b,
				"crosses": a < USABLE and b >= USABLE, "usable": b >= USABLE})
	return out


## THIS WEEK: every card the evenings drill - mastery at Monday and at Sunday, the night it turns Usable, else how far short.
static func moves(f: Dictionary, rows: Dictionary) -> Array:
	var out: Array = []
	for card in rows:
		var nights: Dictionary = rows[card]
		if nights.is_empty():
			continue
		var days := nights.keys()
		days.sort()
		var start := float(nights[days[0]][0])
		var end := float(nights[days[-1]][1])
		var day_usable := -1
		for d in days:
			if float(nights[d][0]) < USABLE and float(nights[d][1]) >= USABLE:
				day_usable = int(d)
		out.append({"card": str(card), "title": PadEdit.title(f, str(card)), "start": start, "end": end, "usable_dow": day_usable,
			"word": MoveMastery.word(end), "short": maxf(0.0, USABLE - end), "nights": days.size()})
	return out


## MORNINGS: the week's stat gains by attribute, their sum, and Sunday's rest (tiredness off).
static func totals(wk: Dictionary, days: Array) -> Dictionary:
	var gains: Dictionary = wk["gains"]
	var sum := 0.0
	for k in gains:
		sum += float(gains[k])
	var rest_drop := 0.0
	for d in days:
		if bool((d["am"] as Dictionary)["rest"]):
			rest_drop = maxf(rest_drop, float((d["am"] as Dictionary)["drop"]))
	return {"gains": gains, "sum": sum, "rest_drop": rest_drop}


## DIET (S537 WEIGHTCUT1: a fact, the booking decides - WeekPlan.diet_fact gives the line and its tooltip); with a bout the scale and the legs on fight night (CampForecast + Gauges, est.), else Sunday's weight.
static func diet(c: Career, f: Dictionary, goal: Dictionary, wk: Dictionary) -> Dictionary:
	var fact := WeekPlan.diet_fact(f, c.day)
	var out := {"diet": str(fact["diet"]), "line": str(fact["line"]), "tip": str(fact["tip"]), "end_kg": float(wk["weight_end"]),
		"limit": float(f.get("limit", 0.0)), "booked": WeekData.booked(goal)}
	if bool(out["booked"]):
		var cp: Dictionary = f.get("camp", {})
		var fc := CampForecast.run(c, f, str(cp.get("focus", goal["stat"])), int(cp.get("protocol", 0)), bool(cp.get("film", false)))
		var d := Gauges.read(fc, f, c.day, _limits(f))
		out["fight_kg"] = float(d["kg"])
		out["legs"] = float(d["legs"])
	return out


static func _limits(f: Dictionary) -> Array:
	var out: Array = []
	for k in Data.DIVISIONS:
		if str(Data.DIVISIONS[k]["sex"]) == str(f.get("sex", "f")):
			out.append(float(Data.DIVISIONS[k]["limit"]))
	return out


## The selected evening: the coach's cell, and for a pad night each boxer on it with her minutes and what her card gets.
static func night(c: Career, dow: int, fdow: int) -> Dictionary:
	var cell := coach_cell(c, dow, fdow)
	var sides: Array = []
	for s in cell["boxers"]:
		var f := c.fighter_by_id(str(s["fid"]))
		var pk := WeekData.pack(c, f)
		var rows := PadEdit.night_rows(f, pk["projs"])
		var best := {}
		for card in rows:
			if (rows[card] as Dictionary).has(dow):
				best = {"title": PadEdit.title(f, str(card)), "before": float(rows[card][dow][0]), "after": float(rows[card][dow][1])}
				break
		var b: Dictionary = f.get("bout", {})
		var when := "no bout booked"
		if not b.is_empty() and not bool(b.get("done", false)):
			var left := int(b["day"]) - (c.day - posmod(c.day, 7) + dow)
			when = "fights tomorrow" if left == 1 else "fights in %d days" % left
		sides.append({"fid": str(s["fid"]), "stem": str(s["stem"]), "min": float(s["min"]), "when": when, "card": best})
	return {"dow": dow, "cell": cell, "sides": sides}


## S519: the morning's coach tag {short, long} when the deal coached this day on the stat the tile trains, else {}.
static func _coached(coached: Dictionary, dow: int, stat: String) -> Dictionary:
	var m: Dictionary = coached.get(str(dow), {})
	if m.is_empty() or str(m.get("ability", "")) != stat:
		return {}
	return {"short": ("SHARED x%.2f" if str(m["use"]) == "shared" else "1-TO-1 x%.2f") % float(m["mult"]),
		"long": CoachedMornings.tile_word(m)}
