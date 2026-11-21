extends RefCounted
## S532 GUIDETIPS1: the FULL cards for the values that show on more than one screen, written once (the standard's worked
## examples, section 2f). Each returns a Tip.explain dictionary; every number is read from the rule it describes.
##   TipCards.tiredness(value, word)   TipCards.mastery(move, before, after)   TipCards.coach_money(tile, salary, hired)
##   TipCards.tiredness_week(ends)   TipCards.injury_risk(x, load, peak)   TipCards.morning(name, level, stat, gain, kg, coached)

const WhiteboardKit := preload("res://scripts/ui/WhiteboardKit.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const CoachAreas := preload("res://scripts/rules/CoachAreas.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")

const OK_AT := 50.0   # WhiteboardKit.fatigue_word: "OK" from 50


## The owner's example of a tooltip that fails: one line across the whole screen, four numbers, no "so what do I do".
static func tiredness(value: float, word: String = "") -> Dictionary:
	var amber := WhiteboardKit.AMBER_AT
	var red := WhiteboardKit.RED_AT
	# TIPFIX2 (owner Q-283 "Shorter cards"): three rows; the OK band (50 up to amber) is the title's word, no row of its own.
	var rows: Array = [["Fresh", "under %d" % int(OK_AT), "", ""], ["Tired", "from %d" % int(amber), "", "watch"],
		["Next day counts %d%%" % roundi(WeekPlan.TIRED_GAIN * 100.0), "from %d" % int(red), "", "bad"]]
	var at := 0 if value < OK_AT else (-1 if value < amber else (1 if value < red else 2))
	if at >= 0:
		rows[at][2] = "now"
	var todo := "Plan a rest day before %d." % int(red)
	if value >= red:
		todo = "Give a rest day now."
	return {"title": "Fatigue  %d of 100%s" % [roundi(value), (" - " + word.to_lower()) if word != "" else ""],
		"what": "How worn your boxer is. Spent: next day trains at %d%%." % roundi(WeekPlan.TIRED_GAIN * 100.0),
		"rows": rows, "moves": "Training raises it; rest days bring it down.", "do": todo,
		# S533 "reach 10": the bands drawn as a bar with a tick at the value (the rows stay in the spec for the checks)
		"band": {"value": value, "zones": [[0, OK_AT, "good", "Fresh"], [OK_AT, amber, "", "OK"], [amber, red, "watch", "Tired"],
			[red, 100, "bad", "Spent"]]}}


## "what are the small purple highlighted section on the bars ?" - the levels first, then the bar's parts.
static func mastery(move: String, before: float, after: float) -> Dictionary:
	# TIPFIX2: three rows - Sharp and Signature share the top one; "never thrown" moved from WHAT into the Learning row.
	var rows: Array = [["Learning", "under 30, never thrown", "now" if after < 30.0 else "", ""],
		["Usable", "from 30 (the flag)", "now" if after >= 30.0 and after < 60.0 else "", "good"],
		["Sharp, then Signature", "from 60, then 85", "now" if after >= 60.0 else "", ""]]
	var gain := after - before
	var todo := "Put it on a pad night to raise it."
	var nxt := MoveMastery.next_word(after)
	if gain > 0.05 and str(nxt[0]) != "":
		var nights := ceili((float(nxt[1]) - after) / gain)
		todo = "%d more pad night%s like this %s %s." % [nights, "" if nights == 1 else "s", "reaches" if nights == 1 else "reach", "the flag" if float(nxt[1]) == 30.0 else str(nxt[0])]
	var title := "%s  %d → %d  %s" % [move, roundi(before), roundi(after), MoveMastery.word(after)] if gain > 0.05 else "%s  %d  %s" % [move, roundi(after), MoveMastery.word(after)]
	return {"title": title, "what": "How well your boxer owns this move.",
		"rows": rows, "moves": "Light strip: tonight's gain. Dashed box: one more night.", "do": todo}


## "$450 wage a week" / "Cost a week": "what is it for ? cost a week to do what". One sum on all three money tiles.
## tile: "pay" | "classes" | "net".
static func coach_money(tile: String, salary: int, hired: bool) -> Dictionary:
	var classes := GameMoney.CLASSES_WITH_COACH
	var net := classes - salary
	var rows: Array = [["Pay", "-" + GameMoney.text(salary), "a week", ""], ["Classes bring in", "+" + GameMoney.text(classes), "a week", "good"],
		["Real cost" if net < 0 else "Left over", ("-" if net < 0 else "+") + GameMoney.text(absi(net)), "a week", "bad" if net < 0 else "good"]]
	var head: Dictionary = {
		"pay": ["Coach's pay", "A coach for every session, plus the evening classes."],
		"classes": ["Evening classes", "Classes this coach runs for members, paid every week."],
		"net": ["Real cost a week", "Coach's pay less what the evening classes bring in."]}
	var h: Array = head.get(tile, head["pay"])
	return {"title": h[0], "what": h[1], "rows": rows,
		"moves": "No coach: sessions count %d%% and no classes." % roundi(CoachAreas.ALONE_FACTOR * 100.0),
		"do": "" if hired else "Press Hire below to hire this coach.", "keys": ["classes"] if tile != "classes" else []}


## Training's tiredness line: the same card, read at the week's highest day.
static func tiredness_week(ends: Array) -> Dictionary:
	var peak := 0.0
	for x in ends:
		peak = maxf(peak, float(x))
	var d := tiredness(peak)
	d["title"] = "Fatigue this week  peak %d" % roundi(peak)
	return d


## Was one line with six numbers and "x2 at 76, x3 from 80". The two things that raise it, each against its safe line.
static func injury_risk(x: float, load: float, peak: float) -> Dictionary:
	var raised := x >= 1.05
	return {"title": "Injury risk  %s" % ("%.1f times the usual" % x if raised else "normal"),
		"what": "Chance of a training injury at week's end.",
		"rows": [["Hours, of a usual week", "%.1f, safe to %.1f" % [load, InjuryRoll.SAFE_RATIO], "over" if load > InjuryRoll.SAFE_RATIO else "", "bad"],
			["Fatigue peak", "%d, safe to %d" % [roundi(peak), int(InjuryRoll.FATIGUE_RISK_FROM)], "over" if peak > InjuryRoll.FATIGUE_RISK_FROM else "", "bad"]],
		"moves": "More hours and a tired week raise it.",
		"do": "Make a Hard morning Light, or rest a day." if raised else "Nothing to do: this week is safe."}


## A morning tile: what the session is for, what it gives today, how to change it.
static func morning(session: String, level: String, stat: String, gain: float, kg: float, coached: String = "") -> Dictionary:
	var rows: Array = []
	if stat != "":
		rows.append([stat, "%+.2f" % gain, "today", "good" if gain > 0.0 else ""])
	rows.append(["Weight", "%+.2f kg" % kg, "today", ""])
	if coached != "":
		rows.append(["Coached", coached, "", "good"])   # TIPFIX2: a row, not a sentence (was a NOW line)
	return {"title": "%s  %s" % [session, level.capitalize()], "what": "Builds one attribute and moves the weight.",
		"rows": rows, "moves": "Hard gains and tires more; Light the reverse.", "do": "Click L, N or H to set how hard."}
