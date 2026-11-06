extends RefCounted
## S382 PADWEEK1 (TRAINING_SCREEN_S381.md 5.2-5.3): one fighter's week of drilling, night by night (PadWeek.run_week - the
## same function the card projections call). Moved out of Sim (drill_week / drill_combos / _fade_own), which replaced the
## two fixed weekly lumps with the pad nights. Here: the gym's news when a move or combination lands, and the coach's next
## pick - the derived f["learning"] / f["combo_learning"] (the move and combo with the most pad minutes this week) that
## the coach's default nights, Sim.twist_needs and older readers keep reading.
##   run(career, f) -> {rows: [{name, before, after}], new_weapon, new_combo, pads: [[dow, card, before, after]],
##     review: PadReview.rows (the week review's PADS row, S382 CARDFLIP1)}
##   inputs(career, f) -> {skill, carded, mults, nights, week} (what run and the card projections share)

const Data := preload("res://scripts/state/Data.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const PadReview := preload("res://scripts/rules/PadReview.gd")

## f key: the evenings this week as they ran (note); {"<dow>": {kind, minutes, cards}}.
const NOTED := "week_nights"


static func run(career: Career, f: Dictionary) -> Dictionary:
	var moves: Dictionary = f["moves"]
	if not f.has("combos"):
		f["combos"] = {}
	var combos: Dictionary = f["combos"]
	var inp := inputs(career, f)
	var skill := float(inp["skill"])
	var carded: Array = inp["carded"]
	var mults: Dictionary = inp["mults"]
	var nights: Dictionary = inp["nights"]
	var week: Dictionary = inp["week"]
	var before_moves := moves.duplicate()
	var before_combos := combos.duplicate()
	var before_own: Dictionary = (f.get("own_combos", {}) as Dictionary).duplicate()
	var r := PadWeek.run_week(f, nights, week, skill, PadWeek.STATION_TIER, mults, carded)
	f.erase(NOTED)   # the week ran: next week's board lays its own nights
	var drilled: Dictionary = r["pads"]
	var rows: Array = []
	var new_weapon := ""
	for m in Data.MOVES:
		var before := float(before_moves.get(m, 0.0))
		var after := float(moves.get(m, 0.0))
		rows.append({"name": m, "before": before, "after": after})
		if before < BoutRules.WEAPON_MASTERY and after >= BoutRules.WEAPON_MASTERY:
			new_weapon = m
	var learning := _most(drilled, "move", str(f.get("learning", "")))
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
		learning = next
		if new_weapon != "":
			career.add_news("%s has a new weapon: the %s (%s)." % [f["first"], new_weapon.to_lower(),
				MoveMastery.describe(new_weapon, float(moves[new_weapon]))])
	f["learning"] = learning
	return {"rows": rows, "new_weapon": new_weapon, "new_combo": _combo_news(career, f, drilled, before_combos, before_own),
		"pads": r["log"], "review": PadReview.rows(r["log"], nights)}


## What the week runs on - the Training tab's card projections call PadWeek.project with the same (S382 DRILLCARD1):
## {skill: the coach's rating, carded: moves on her week cards, mults: the twist's pad multipliers, nights, week}.
static func inputs(career: Career, f: Dictionary) -> Dictionary:
	var carded: Array = []
	for card in f.get("cards", []):
		if Data.CARD_MOVES.has(card):
			carded.append(Data.CARD_MOVES[card])
	var tw := WeekTwist.active(f)   # S356 the twist card scales the pads ("Double down": combo x2, new move x0)
	var nights := PadWeek.nights_of(f)
	var week := PadWeek.week_of(f, nights)
	_lay_noted(f.get(NOTED, {}), nights, week)
	return {"skill": float(career.coach.get("rating", 0.0)), "carded": carded, "nights": nights, "week": week,
		"mults": {"move": float(tw.get("move_mult", 1.0)), "combo": float(tw.get("combo_mult", 1.0))}}


## S382 PLANTRAY1 review (the fight week drilled on Sunday what the board would lay AFTER the fight - the old coach's
## cards on between-fights nights - not the plan the strip carried Monday to Friday): Sim.step_day notes each evening's
## night as it runs ({kind: pads / spar / "", minutes, cards}); inputs() lays the noted evenings over the live week, so
## the week runs, and the review shows, what each evening carried. run() clears them.
static func note(career: Career, f: Dictionary, dow: int) -> void:
	if dow == 0:
		f.erase(NOTED)
	var inp := inputs(career, f)
	var n: Dictionary = inp["nights"]
	var kind := "pads" if (n["pads"] as Array).has(dow) else ("spar" if (n["spar"] as Array).has(dow) else "")
	(f.get_or_add(NOTED, {}) as Dictionary)[str(dow)] = {"kind": kind, "minutes": PadWeek.night_minutes(n, dow),
		"cards": ((inp["week"] as Dictionary).get(PadWeek.DAYS[dow], []) as Array).duplicate(true)}


static func _lay_noted(noted: Dictionary, nights: Dictionary, week: Dictionary) -> void:
	if noted.is_empty():
		return
	var pads: Array = (nights.get("pads", []) as Array).duplicate()
	var spar: Array = (nights.get("spar", []) as Array).duplicate()
	var per: Dictionary = {}
	for k in noted:
		var d := int(k)
		var e: Dictionary = noted[k]
		pads.erase(d)
		spar.erase(d)
		week.erase(PadWeek.DAYS[d])
		if str(e.get("kind", "")) == "pads":
			pads.append(d)
			per[d] = float(e.get("minutes", PadWeek.PAD_NIGHT_MINUTES))
			if not (e.get("cards", []) as Array).is_empty():
				week[PadWeek.DAYS[d]] = (e["cards"] as Array).duplicate(true)
		elif str(e.get("kind", "")) == "spar":
			spar.append(d)
	pads.sort()
	spar.sort()
	nights["pads"] = pads
	nights["spar"] = spar
	nights["per"] = per


## The book's and her own combinations that turned usable or signature this week, in the gym's words; the coach moves on
## to the next combination when the one she drilled most turns usable (her own: when it is her signature).
static func _combo_news(career: Career, f: Dictionary, drilled: Dictionary, before_combos: Dictionary, before_own: Dictionary) -> String:
	var moves: Dictionary = f["moves"]
	var combos: Dictionary = f["combos"]
	var drilling := _most(drilled, "combo", "")
	var new_combo := ""
	var own_done := false
	for id in combos.keys():
		var before := float(before_combos.get(id, 0.0))
		var after := float(combos[id])
		# S303 Kalli K-COMBOWORDS1: the coach's words when it turns usable and when it becomes her signature.
		if before < Combos.LEARN_AT and after >= Combos.LEARN_AT:
			new_combo = str(id)
			career.add_news("%s can throw the %s in a fight now. Coach: \"%s\"" % [f["first"], id,
				ComboWords.line(str(id), "coach_learning", str(f["first"]), career.day)])
		elif before < ComboWords.SIGNATURE_AT and after >= ComboWords.SIGNATURE_AT:
			career.add_news("Coach: \"%s\"" % ComboWords.line(str(id), "coach_signature", str(f["first"]), career.day))
	for e in OwnCombos.entries(f):
		var id := str(e["id"])
		var ob := float(before_own.get(id, 0.0))
		var oa := OwnCombos.mastery(f, id)
		if ob < Combos.LEARN_AT and oa >= Combos.LEARN_AT:
			career.add_news("%s can throw the %s in a fight now (%s)." % [f["first"], e["name"], Combos.describe("combination", oa)])
		elif ob < ComboWords.SIGNATURE_AT and oa >= ComboWords.SIGNATURE_AT:
			career.add_news("Signature: %s owns the %s - it lands whole more often, and fresh it runs one punch longer." % [f["first"], e["name"]])
			own_done = own_done or id == drilling
	if drilling == "":
		drilling = str(f.get("combo_learning", ""))
	var done := own_done or (new_combo != "" and new_combo == drilling)
	f["combo_learning"] = Combos.next_to_learn(moves, combos) if done or drilling == "" else drilling
	return new_combo


## The card of this kind with the most pad minutes this week ("move" -> the move name, "combo" -> the book id or own id).
static func _most(drilled: Dictionary, k: String, fallback: String) -> String:
	var best := ""
	var best_min := 0.0
	for card in drilled:
		var c := str(card)
		var ck := PadWeek.kind(c)
		if (k == "move" and ck != "move") or (k == "combo" and ck != "combo" and ck != "own"):
			continue
		if float(drilled[card]) > best_min:
			best_min = float(drilled[card])
			best = c
	if best == "":
		return fallback
	return PadWeek.key(best) if PadWeek.kind(best) != "own" else best
