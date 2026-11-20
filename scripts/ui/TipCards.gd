extends RefCounted
## S532 GUIDETIPS1: the FULL cards for the values that show on more than one screen, written once (the standard's worked
## examples, section 2f). Each returns a Tip.explain dictionary; every number is read from the rule it describes.
##   TipCards.tiredness(value, word)   TipCards.mastery(move, before, after)   TipCards.coach_money(tile, salary, hired)

const WhiteboardKit := preload("res://scripts/ui/WhiteboardKit.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const CoachAreas := preload("res://scripts/rules/CoachAreas.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

const OK_AT := 50.0   # WhiteboardKit.fatigue_word: "OK" from 50


## The owner's example of a tooltip that fails: one line across the whole screen, four numbers, no "so what do I do".
static func tiredness(value: float, word: String = "") -> Dictionary:
	var amber := WhiteboardKit.AMBER_AT
	var red := WhiteboardKit.RED_AT
	var at := 0 if value < OK_AT else (1 if value < amber else (2 if value < red else 3))
	var rows: Array = [["Fresh", "under %d" % int(OK_AT), "", ""], ["OK", "from %d" % int(OK_AT), "", ""],
		["Tired", "from %d" % int(amber), "", "watch"], ["Next morning counts %d%%" % roundi(WeekPlan.TIRED_GAIN * 100.0), "from %d" % int(red), "", "bad"]]
	rows[at][2] = "now"
	var todo := "Give a rest day in the week plan before it reaches %d." % int(red)
	if value >= red:
		todo = "Give a rest day now: the next morning's training is mostly lost."
	return {"title": "Tiredness  %d of 100%s" % [roundi(value), (" - " + word.to_lower()) if word != "" else ""],
		"what": "How worn your fighter is. Tired fighters train worse and get hurt more.",
		"rows": rows, "moves": "Fights and hard sessions raise it. Rest days bring it down.", "do": todo}


## "what are the small purple highlighted section on the bars ?" - the levels first, then the bar's parts.
static func mastery(move: String, before: float, after: float) -> Dictionary:
	var edges := [[30.0, "Usable", "from 30 (the flag)"], [60.0, "Sharp", "from 60"], [85.0, "Signature", "from 85"]]
	var rows: Array = [["Learning", "under 30", "now" if after < 30.0 else "", ""]]
	for i in edges.size():
		var top: float = edges[i + 1][0] if i + 1 < edges.size() else 101.0
		rows.append([edges[i][1], edges[i][2], "now" if after >= float(edges[i][0]) and after < top else "", "good" if i == 0 else ""])
	var gain := after - before
	var todo := "Put it on a pad night to raise it."
	var nxt := MoveMastery.next_word(after)
	if gain > 0.05 and str(nxt[0]) != "":
		var nights := ceili((float(nxt[1]) - after) / gain)
		todo = "%d more pad night%s like this %s %s." % [nights, "" if nights == 1 else "s", "reaches" if nights == 1 else "reach", "the flag" if float(nxt[1]) == 30.0 else str(nxt[0])]
	var title := "%s  %d → %d  %s" % [move, roundi(before), roundi(after), MoveMastery.word(after)] if gain > 0.05 else "%s  %d  %s" % [move, roundi(after), MoveMastery.word(after)]
	return {"title": title, "what": "How well your boxer owns this move. Under 30 it is not thrown in a fight.",
		"rows": rows, "moves": "Light strip: tonight's gain. Dashed box: one more night like this.", "do": todo}


## "$450 wage a week" / "Cost a week": "what is it for ? cost a week to do what". One sum on all three money tiles.
## tile: "pay" | "classes" | "net".
static func coach_money(tile: String, salary: int, hired: bool) -> Dictionary:
	var classes := GameMoney.CLASSES_WITH_COACH
	var net := classes - salary
	var rows: Array = [["Pay", "-" + GameMoney.text(salary), "a week", ""], ["Classes bring in", "+" + GameMoney.text(classes), "a week", "good"],
		["Real cost" if net < 0 else "Left over", ("-" if net < 0 else "+") + GameMoney.text(absi(net)), "a week", "bad" if net < 0 else "good"]]
	var head: Dictionary = {
		"pay": ["Coach's pay", "Buys a coach in the gym for every session, and the evening classes."],
		"classes": ["Evening classes", "Classes this coach runs for members in the evenings. They pay every week."],
		"net": ["Real cost a week", "The coach's pay less what the evening classes bring in."]}
	var h: Array = head.get(tile, head["pay"])
	return {"title": h[0], "what": h[1], "rows": rows,
		"moves": "With no coach a session counts %d%% and there are no classes." % roundi(CoachAreas.ALONE_FACTOR * 100.0),
		"do": "" if hired else "Press Hire below to take this coach on.", "keys": ["classes"] if tile != "classes" else []}
