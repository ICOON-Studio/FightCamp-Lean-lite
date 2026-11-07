extends SceneTree
## S382 PLANTRAY1 (TRAINING_SCREEN_S381.md section 2, build order item 4): PlanCards, the tray in camp mode.
##   1. a booked bout turns the tray to THE PLAN; done or gone, it is LEARN again;
##   2. the cards: GO-TO first, the plan's first any-time combination = R1 OPENER, a line in a found tell's situation =
##      ANSWER ("answer: <her tell>"), a combination with a punch under 30 = that punch's card;
##   3. fight night: a card under 30 whose crossing lands on or after the bout's day is stamped UNDRILLED x0.8 and reads
##      "not usable by fight night"; one that crosses before it, or is already usable, is not;
##   4. the coach's camp nights drill the plan in order (PadWeek.defaults), and the old week returns after the fight;
##   5. the tray: the plan cards on nights first, then her other night cards, then the rest of the plan;
##   6. the sparring partner chip: "southpaw mate" only when the camp booked the outside mate.
##   S382 review: a crossing in the fight's own week is too late (the week lands Sunday night); a punch's card is NOT
##   THROWN; only plan cards are stamped; fight_paths walks the camp's real weeks; Drill it in camp goes on a night;
##   DrillWeek's noted evenings lay over the live week.

const PlanCards := preload("res://scripts/rules/PlanCards.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")

var _fails := 0


func _initialize() -> void:
	_mode()
	_entries()
	_fight_night()
	_fight_paths()
	_drill_it()
	_noted()
	_spar()
	_coach()
	_tray()
	_partner()
	print("PLAN_CARDS %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _lucy() -> Dictionary:
	var f := {"id": "f1", "first": "Lucy", "stats": {"technique": 60.1, "fight_iq": 59.0},
		"moves": {"Jab": 55.0, "Cross": 50.0, "Lead hook": 37.3, "Body hook": 32.0, "Uppercut": 12.0, "Check hook": 5.0},
		"combos": {"1-1": 25.2}, "learning": "Uppercut", "combo_learning": "1-2",
		"book": [{"name": "jab, jab, cross", "chain": ["jab", "jab", "cross"], "score": 70}],
		"arrows": [{"move": "1-6-3@corner"}, {"move": "slip 2-3", "when": "press"}, {"move": "1-1"}, {"move": "step_back"}],
		"bout": {"day": 100, "done": false, "opp": {"first": "Maria", "name": "Maria Lopez", "style": "Pressure fighter",
			"threat": "hooks in close", "weak": "walks in straight", "stance": "southpaw", "file_found": ["weapon"]}},
		"camp": {"protocol": 2, "start": 72, "partner": true}}
	OwnCombos.ensure_ids(f)
	f["plan_combo"] = str(OwnCombos.entries(f)[0]["id"])
	return f


func _mode() -> void:
	var f := _lucy()
	_check(PlanCards.active(f), "a booked bout: THE PLAN")
	f["bout"]["done"] = true
	_check(not PlanCards.active(f) and PlanCards.entries(f).is_empty(), "the bout fought: LEARN again, no plan cards")
	f["bout"] = {}
	_check(not PlanCards.active(f) and PlanCards.opp(f).is_empty(), "no bout: LEARN")


func _entries() -> void:
	var f := _lucy()
	var es := PlanCards.entries(f)
	var got := es.map(func(e): return "%s=%s" % [e["card"], e["tag"]])
	print("  entries: ", got)
	_check(es.size() == 4, "four plan cards (%d)" % es.size())
	if es.size() < 4:
		return
	_check(str(es[0]["card"]) == str(f["plan_combo"]) and str(es[0]["tag"]) == PlanCards.GO_TO, "the GO-TO combination first")
	_check(str(es[1]["card"]) == "combo:1-1" and str(es[1]["tag"]) == PlanCards.OPENER, "the long-range any-time 1-1 is the R1 OPENER")
	_check(str(es[2]["card"]) == "move:Check hook" and str(es[2]["tag"]) == PlanCards.ANSWER,
		"slip 2-3 'if she presses' answers her found weapon; the check hook at 5 is the card")
	_check(str(es[2]["sub"]) == "answer: hooks in close", "the answer names her tell (%s)" % str(es[2]["sub"]))
	_check(str(es[3]["card"]) == "move:Uppercut" and str(es[3]["tag"]) == PlanCards.PLAN
		and str(es[3]["sub"]) == "for the jab, uppercut, hook", "1-6-3 lacks the uppercut: the uppercut's card, for the combination")
	_check(PlanCards.card_for(f, "step_back") == "" and PlanCards.card_for(f, "pivot_out") == "", "a step is no drill card")
	# A found tell no line answers: the first book combination that beats it (her weakness: walks in straight -> press).
	f["arrows"] = [{"move": "1-2"}]
	f["bout"]["opp"]["file_found"] = ["weakness"]
	var es2 := PlanCards.entries(f)
	var ans := es2.filter(func(e): return str(e["tag"]) == PlanCards.ANSWER)
	_check(ans.size() == 1 and str(ans[0]["card"]) == "combo:1-1" and str(ans[0]["sub"]) == "answer: walks in straight",
		"an unanswered tell brings its answer card (%s)" % str(ans))


func _fight_night() -> void:
	var f := _lucy()
	var monday := 91
	_check(PlanCards.usable_by(f, "combo:1-1", {"path": [[0, 2, 31.0]]}, monday, 100), "crosses Wednesday, fight day 100: usable")
	_check(not PlanCards.usable_by(f, "combo:1-1", {"path": [[1, 2, 31.0]]}, monday, 100), "crosses on the fight's own day: too late")
	# S382 review: the week's drilling lands Sunday night (Sim.end_week), so the fight's own week is too late.
	_check(not PlanCards.usable_by(f, "combo:1-1", {"path": [[0, 2, 31.0]]}, monday, 96),
		"crosses Wednesday, fight that Saturday: the week lands after the fight")
	_check(PlanCards.usable_by(f, "combo:1-1", {"path": [[0, 6, 31.0]]}, monday, 98), "crosses Sunday, fight next Monday: lands in time")
	_check(not PlanCards.usable_by(f, "combo:1-1", {"path": []}, monday, 100), "no night carries it: not usable")
	_check(PlanCards.usable_by(f, "move:Lead hook", {"path": []}, monday, 100), "already over 30: usable")
	# The real projection: a week to go, the check hook (5) on every pad night cannot get there.
	var nights := PadWeek.nights_for(1, true)
	var week := {}
	for d in nights["pads"]:
		week[PadWeek.DAYS[d]] = [{"card": "move:Check hook", "share": 1.0}]
	var projs := PadWeek.project(f, nights, week, 58.0, PadWeek.STATION_TIER, 8)
	projs["combo:1-1"] = {"path": [[0, 4, 30.4]], "eta": {"text": "usable Fri", "tone": "good"}}
	PlanCards.dress(f, projs, monday, 98)
	var ch: Dictionary = projs.get("move:Check hook", {})
	_check(str(ch.get("stamp", "")) == PlanCards.STAMP_PUNCH and str((ch.get("eta", {}) as Dictionary).get("text", "")) == PlanCards.LATE,
		"the check hook (a punch: its line greyed on the night): NOT THROWN, not usable by fight night")
	_check(str(ch.get("tag", "")) == PlanCards.ANSWER, "dress tags the card")
	var one: Dictionary = projs["combo:1-1"]
	_check(not one.has("stamp") and str(one["eta"]["text"]) == "usable Fri" and str(one["tag"]) == PlanCards.OPENER,
		"the 1-1 crossing Friday keeps its line, no stamp")
	_check(PlanCards.STAMP == "UNDRILLED x%.1f" % PlanCards.PlanBoard.UNDRILLED, "the stamp says PlanBoard's rate")
	# Only plan cards are dressed: her own pin under 30 is no plan line, so no fight-night stamp.
	projs["move:Body hook"] = {"path": [], "eta": {"text": "not on a night", "tone": ""}}
	f["moves"]["Body hook"] = 10.0
	PlanCards.dress(f, projs, monday, 98)
	_check(not (projs["move:Body hook"] as Dictionary).has("stamp"), "a card outside the plan wears no fight-night stamp")
	# A combination under 30 she will not have: the x0.8 stamp.
	var p12 := {"combo:1-1": {"path": [], "eta": {"text": "x", "tone": ""}}}
	PlanCards.dress(f, p12, monday, 98)
	_check(str(p12["combo:1-1"].get("stamp", "")) == PlanCards.STAMP, "a combination short of 30: UNDRILLED x0.8")


## The road to the fight: the camp's real weeks, not this week repeated.
func _fight_paths() -> void:
	var f := _lucy()
	f["bout"]["day"] = 96   # Saturday, day 77 a Monday: weeks 77 and 84 land before it (91's lands after)
	var inp := {"skill": 58.0, "carded": [], "mults": {}, "week": {},
		"nights": {"pads": [], "spar": [], "film": 1, "minutes": PadWeek.PAD_NIGHT_MINUTES}}
	var paths := PlanCards.fight_paths(f, inp, 77, 96)
	var go := str(f["plan_combo"])
	var gp: Array = (paths.get(go, {}) as Dictionary).get("path", [])
	print("  GO-TO path: ", gp)
	_check(not gp.is_empty() and gp.all(func(p): return int(p[0]) >= 1),
		"no pad night this week, the coach's nights next week drill the GO-TO (week 1 on)")
	var weeks := []
	for c in paths:
		for p in paths[c]["path"]:
			if not weeks.has(int(p[0])):
				weeks.append(int(p[0]))
	_check(not weeks.is_empty() and weeks.max() <= 1, "nothing from the fight's own week (weeks %s)" % str(weeks))
	var none := PlanCards.fight_paths(f, inp, 91, 96)
	_check(none.values().all(func(v): return (v["path"] as Array).is_empty()), "the fight this week: no night counts")
	var projs := {"combo:1-1": {"path": [], "eta": {"text": "not on a night - it fades", "tone": "bad"}}}
	PlanCards.dress(f, projs, 77, 96, paths)
	var one: Dictionary = projs["combo:1-1"]
	var op: Array = (paths.get("combo:1-1", {}) as Dictionary).get("path", [])
	var lands := op.any(func(p): return float(p[2]) >= 30.0)
	print("  1-1 path: ", op, " -> ", one)
	_check(lands and not one.has("stamp"), "the 1-1 (25.2) lands on next week's coach night: no stamp, though this week is empty")
	_check(str(one["eta"]["text"]) == "usable in 2 weeks", "and its line says the week it lands (%s)" % str(one["eta"]))


## In camp the Playbook's Drill it puts the combination on a night (the coach's camp week ignores the old slot).
func _drill_it() -> void:
	var f := _lucy()
	var dow := PlanCards.drill_it(f, "1-2")
	var nights := PadWeek.nights_of(f)
	var on: Array = (PadWeek.week_of(f, nights).get(PadWeek.DAYS[dow], []) as Array).map(func(e): return str(e["card"])) if dow >= 0 else []
	_check(on.has("combo:1-2") and (f.get("tray", []) as Array).has("combo:1-2"),
		"Drill it in camp: the 1-2 on her pad night %d (beside the coach's card: %s) and in the tray" % [dow, str(on)])
	f["bout"]["done"] = true
	_check(PlanCards.drill_it(f, "1-1") == -1, "after the fight Drill it leaves the nights to the old slot")


## Spec 5.3: in camp a sparring night shares out every plan card already >= 30, not only the night cards and pins.
func _spar() -> void:
	var f := _lucy()
	f["own_combos"] = {str(f["plan_combo"]): 40.0}
	var nights := {"pads": [0], "spar": [3], "film": -1, "minutes": PadWeek.PAD_NIGHT_MINUTES}
	var week := {"mon": [{"card": "move:Uppercut", "share": 1.0}]}
	var r := PadWeek.run_week(f.duplicate(true), nights, week, 58.0, PadWeek.STATION_TIER)
	var sparred: Array = (r["log"] as Array).filter(func(x): return int(x[0]) == 3).map(func(x): return str(x[1]))
	_check(sparred.has(str(f["plan_combo"])), "Thursday's sparring works the GO-TO at 40 though no night carries it (%s)" % str(sparred))
	var projs := PadWeek.project(f, nights, week, 58.0, PadWeek.STATION_TIER, 1)
	_check(projs.has(str(f["plan_combo"])), "and the board's projection draws it (the spar night's list)")
	f["bout"]["done"] = true
	r = PadWeek.run_week(f.duplicate(true), nights, week, 58.0, PadWeek.STATION_TIER)
	_check((r["log"] as Array).filter(func(x): return int(x[0]) == 3).is_empty(), "after the fight the plan is no spar pool")


## The evenings as they ran: noted nights lay over the live week (DrillWeek.note / inputs).
func _noted() -> void:
	var nights := {"pads": [2, 4], "spar": [1, 3], "film": -1, "minutes": 120.0}
	var week := {"wed": [{"card": "move:Uppercut", "share": 1.0}], "fri": [{"card": "move:Uppercut", "share": 1.0}]}
	var noted := {"0": {"kind": "pads", "minutes": 240.0, "cards": [{"card": "combo:1-1", "share": 1.0}]},
		"1": {"kind": "", "minutes": 240.0, "cards": []}}
	DrillWeek._lay_noted(noted, nights, week)
	_check(nights["pads"] == [0, 2, 4] and nights["spar"] == [3], "Monday ran as pads, Tuesday as nothing (%s)" % str(nights))
	_check(str(week["mon"][0]["card"]) == "combo:1-1" and is_equal_approx(PadWeek.minutes_for("combo:1-1", week, nights), 240.0)
		and is_equal_approx(PadWeek.minutes_for("move:Uppercut", week, nights), 240.0),
		"Monday keeps its card and its full minutes; the live nights keep theirs")


func _coach() -> void:
	var f := _lucy()
	var plan := PlanCards.cards(f)
	var nights := {"pads": [0, 2], "spar": [1, 3], "film": -1, "minutes": PadWeek.PAD_NIGHT_MINUTES}
	var w := PadWeek.defaults(f, nights)
	_check(str(w["mon"][0]["card"]) == plan[0] and str(w["wed"][0]["card"]) == plan[1], "camp: the GO-TO Monday, the opener Wednesday")
	var five := PadWeek.defaults(f, {"pads": [0, 1, 2, 4, 5], "spar": []})
	_check(str(five["sat"][0]["card"]) == plan[0], "more nights than cards: round again")
	f["pad_week"] = {"mon": [{"card": "move:Lead hook", "share": 1.0}]}
	_check(str(PadWeek.week_of(f, nights)["mon"][0]["card"]) == "move:Lead hook", "a night she set stays hers")
	f["bout"]["done"] = true
	var after := PadWeek.defaults(f, nights)
	_check(str(after["mon"][0]["card"]) == "move:Uppercut", "after the fight the coach drills the new move again (%s)" % str(after))


func _tray() -> void:
	var f := _lucy()
	var plan := PlanCards.cards(f)
	var week := {"mon": [{"card": plan[2], "share": 1.0}], "wed": [{"card": "move:Body hook", "share": 1.0}]}
	var t := PlanCards.tray(f, week)
	_check(t.size() == 4 and t[0] == plan[2] and t[1] == "move:Body hook" and t[2] == plan[0],
		"the tray: plan cards on nights, her own night card, then the plan (%s)" % str(t))


func _partner() -> void:
	var f := _lucy()
	_check(PlanCards.partner(f) == "southpaw mate", "the camp booked the southpaw mate")
	f["camp"]["partner"] = false
	_check(PlanCards.partner(f) == "", "club mates: no chip")


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
