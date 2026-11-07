extends SceneTree
## S382 DRILLCARD1 (TRAINING_SCREEN_S381.md sections 4-6): the player's hand on the pad nights (PadEdit, pure).
##   1. place: an empty night takes the card whole, a second card splits it 50/50, a third swaps the second; not on a
##      non-pad night, not a card she cannot drill, not twice; the night is hers (PadWeek.week_of keeps it) and pinned;
##   2. cycle 50/50 -> 70/30 -> 30/70 -> 50/50, and the run drills 70/30 of the night's minutes;
##   3. remove (the other card whole), clear (the night stays empty: no coach default creeps back);
##   4. drill_it: the held punch on the first pad night she has not set; pin keeps TRAY_MAX;
##   5. tray order and the card words (title in numbers, sub, kind word), night_rows and crossing from project;
##   6. eta: "usable <day>", "<tier> in N weeks", "spar nights only", "not on a night - fades", "signature needs Technique 83".
## Population: Lucy (Data.lucy) with coach Luke (58), as in test_pad_week.

const Data := preload("res://scripts/state/Data.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")

var failures := 0


func _initialize() -> void:
	var c := Career.quick_start()
	c.coach = Data.coach("reid")
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["learning"] = "Uppercut"
	f["combo_learning"] = "1-1"
	var nights := PadWeek.nights_for(1, false)   # Standard between fights: pads Mon / Wed / Fri, spar Thu
	_check(nights["pads"] == [0, 2, 4] and nights["spar"] == [3], "Standard: pads Mon Wed Fri, spar Thu (%s)" % str(nights))

	# 1. place
	f["pad_week"] = {}
	_check(not PadEdit.place(f, nights, 3, "move:Jab"), "no drop on a sparring night")
	_check(not PadEdit.place(f, nights, 0, "move:Nope"), "no drop of a card she does not have")
	PadEdit.clear(f, nights, 0)
	_check(PadWeek.week_of(f, nights).get("mon", []).is_empty(), "a cleared night stays empty (the coach does not refill it)")
	_check(PadEdit.place(f, nights, 0, "combo:1-1") and _night(f, nights, "mon") == [["combo:1-1", 1.0]], "an empty night takes it whole")
	_check(not PadEdit.place(f, nights, 0, "combo:1-1"), "the same card twice: no change")
	_check(PadEdit.place(f, nights, 0, "move:Uppercut") and _night(f, nights, "mon") == [["combo:1-1", 0.5], ["move:Uppercut", 0.5]],
		"a second card splits it 50/50")
	PadEdit.place(f, nights, 0, "move:Lead hook")
	_check(_night(f, nights, "mon") == [["combo:1-1", 0.5], ["move:Lead hook", 0.5]], "a third card swaps the second")
	_check((f["tray"] as Array).has("move:Uppercut") and (f["tray"] as Array).has("move:Lead hook"), "a placed card is pinned in the tray")
	# A night the player never touched keeps the coach's card (Wednesday: the new move).
	_check(_night(f, nights, "wed") == [["move:Uppercut", 1.0]], "untouched Wednesday keeps the coach's card (%s)" % str(_night(f, nights, "wed")))

	# 2. cycle
	var shares: Array = []
	for i in 4:
		PadEdit.cycle(f, nights, 0)
		shares.append(roundi(100.0 * float(_night(f, nights, "mon")[0][1])))
	_check(shares == [70, 30, 50, 70], "the split cycles 70/30 -> 30/70 -> 50/50 -> 70/30 (%s)" % str(shares))
	_check(not PadEdit.cycle(f, nights, 2), "a one-card night has no split")
	var g := f.duplicate(true)
	g["pad_week"]["fri"] = []   # Friday's coach default drills the 1-1 too
	var r := PadWeek.run_week(g, nights, PadWeek.week_of(g, nights), 58.0, 2.0)
	var mon := (r["log"] as Array).filter(func(x): return int(x[0]) == 0)
	_check(mon.size() == 2 and is_equal_approx(float(r["pads"]["combo:1-1"]), 0.7 * PadWeek.PAD_NIGHT_MINUTES),
		"the run drills the 1-1 for 70 %% of Monday (%.0f min)" % float(r["pads"].get("combo:1-1", 0.0)))

	# 3. remove / clear
	_check(PadEdit.remove(f, nights, 0, "combo:1-1") and _night(f, nights, "mon") == [["move:Lead hook", 1.0]], "one card off: the other whole")
	_check(PadEdit.clear(f, nights, 0) and _night(f, nights, "mon").is_empty(), "right-click clears the night")
	_check(not PadEdit.clear(f, nights, 3), "a sparring night has nothing to clear")

	# 4. drill_it and pin
	f["pad_week"] = {"mon": [{"card": "move:Uppercut", "share": 1.0}]}
	_check(PadEdit.drill_it(f, nights, "move:Lead hook") == 2 and _night(f, nights, "wed") == [["move:Uppercut", 0.5], ["move:Lead hook", 0.5]],
		"+ drill it: the first pad night she has not set (Wednesday), split with the coach's card")
	f["tray"] = []
	for k in ["move:Jab", "move:Cross", "move:Lead hook", "move:Body hook", "move:Uppercut", "combo:1-1"]:
		PadEdit.pin(f, k)
	_check((f["tray"] as Array).size() == PadEdit.TRAY_MAX and not (f["tray"] as Array).has("move:Jab"), "the tray keeps %d, oldest out" % PadEdit.TRAY_MAX)

	# 5. tray and words
	f["tray"] = []
	f["pad_week"] = {}
	f["book"] = [{"name": "jab, jab, step in, lead hook", "chain": ["jab", "jab", "step_in", "lead_hook"], "score": 70}]
	OwnCombos.ensure_ids(f)
	var week := PadWeek.week_of(f, nights)
	var tray := PadEdit.tray(f, week)
	_check(tray.size() <= 4 and tray[0] == "move:Uppercut" and tray.has("combo:1-1"), "the tray: this week's nights first (%s)" % str(tray))
	_check(PadEdit.title(f, "own:1") == "1-1, in, 3" and PadEdit.sub(f, "own:1") == "jab, jab, step in, lead hook", "own combination in numbers")
	_check(PadEdit.title(f, "combo:1-1") == "1-1" and PadEdit.sub(f, "combo:1-1") == "jab, jab", "book combination")
	_check(PadEdit.kind_word(f, "move:Uppercut") == "NEW MOVE" and PadEdit.kind_word(f, "own:1") == "OWN COMBO", "kind words")
	var projs := PadWeek.project(f, nights, week, 58.0, 2.0, 8)
	var rows := PadEdit.night_rows(f, projs)
	var up: Dictionary = rows["move:Uppercut"]
	_check(up.has(0) and up.has(2) and float(up[0][0]) == float(f["moves"]["Uppercut"]) and is_equal_approx(float(up[2][0]), float(up[0][1])),
		"night_rows: Uppercut on Mon then Wed, each from the last (%s)" % str(up))

	# 6. eta
	var e := PadEdit.eta(f, "move:Uppercut", projs["move:Uppercut"], week, nights["spar"])
	_check(str(e["text"]) == "usable in 2 weeks", "Uppercut from 0: usable in 2 weeks (%s)" % e["text"])
	f["moves"]["Uppercut"] = 19.3
	projs = PadWeek.project(f, nights, week, 58.0, 2.0, 8)
	e = PadEdit.eta(f, "move:Uppercut", projs["move:Uppercut"], week, nights["spar"])
	var cr := PadEdit.crossing(f, "move:Uppercut", projs["move:Uppercut"])
	_check(str(e["text"]) == "usable Wed" and str(e["tone"]) == "good" and str(cr.get("tier", "")) == "usable" and int(cr["dow"]) == 2,
		"at 19.3: usable Wed, and the card crosses on Wednesday (%s, %s)" % [e["text"], str(cr)])
	f["tray"] = ["move:Jab"]
	projs = PadWeek.project(f, nights, week, 58.0, 2.0, 8)
	e = PadEdit.eta(f, "move:Jab", projs["move:Jab"], week, nights["spar"])
	_check(str(e["text"]).begins_with("spar nights only"), "a pinned usable card off the pads: spar nights only (%s)" % e["text"])
	var off := {"path": [], "sig_needs_t": 0.0}
	e = PadEdit.eta(f, "move:Body hook", off, week, [])
	_check(str(e["text"]) == "on no pads night: it fades" and str(e["tone"]) == "bad", "on no night: it fades (%s)" % e["text"])
	f["combos"] = {}
	e = PadEdit.eta(f, "combo:1-2", off, week, [])
	_check(str(e["text"]) == "on no pads night yet" and str(e["tone"]) == "", "never drilled (0.0): nothing to fade, no red (%s)" % e["text"])
	f["moves"]["Jab"] = 70.0
	e = PadEdit.eta(f, "move:Jab", {"path": [], "sig_needs_t": 82.75}, week, [])
	_check(str(e["text"]) == "signature needs Technique 83", "Lucy's cap 75.8: signature needs Technique 83 (%s)" % e["text"])
	print("PAD_EDIT failures=%d" % failures)
	quit(0 if failures == 0 else 1)


## A night as [[card, share]] for easy comparison.
func _night(f: Dictionary, nights: Dictionary, day: String) -> Array:
	return (PadWeek.week_of(f, nights).get(day, []) as Array).map(func(e): return [str(e["card"]), snappedf(float(e["share"]), 0.01)])


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
