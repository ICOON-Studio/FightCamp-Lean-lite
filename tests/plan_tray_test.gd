extends SceneTree
## S382 PLANTRAY1 (TRAINING_SCREEN_S381.md sections 2-3, build order item 4): the Training tab's tray on the real board.
##   1. in camp: the tray reads "THE PLAN vs" with her face and name, its cards wear the plan's tags (GO-TO, R1 OPENER,
##      ANSWER), a card she cannot have by fight night wears the red stamp (a punch: NOT THROWN) and "not usable by fight night";
##   2. the coach's pad nights carry the plan's cards; a sparring night shows the "southpaw mate" chip once the camp books
##      the outside partner, and none with club mates;
##   3. after the fight the tray is LEARN again (no stamp, no plan tags), the board's head is THIS WEEK, and the cards slide in.
## Population: the jump=camp career (Lucy in camp, her bout booked), her plan and her opponent's file set by the test.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PlanCards := preload("res://scripts/rules/PlanCards.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")

var _fails := 0
var main: Node
var f: Dictionary


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	_check(TestJump.run(main, "camp"), "jump=camp runs")
	var c: Career = main.career
	f = c.fighter()
	f["board_taught"] = true
	f["book"] = [{"name": "jab, jab, cross", "chain": ["jab", "jab", "cross"], "score": 70}]
	OwnCombos.ensure_ids(f)
	for mv in ["Jab", "Cross"]:
		f["moves"][mv] = maxf(float(f["moves"][mv]), 50.0)
	f["moves"]["Check hook"] = 2.0
	f["plan_combo"] = str(OwnCombos.entries(f)[0]["id"])
	f["own_combos"] = {f["plan_combo"]: 40.0}
	f["arrows"] = [{"move": "1-1"}, {"move": "slip 2-3", "when": "press"}, {"move": "step_back"}]
	var opp: Dictionary = f["bout"]["opp"]
	opp["stance"] = "southpaw"
	opp["threat"] = "hooks in close"
	opp["file_found"] = ["weapon"]
	f["camp"]["partner"] = false
	f["pad_week"] = {}
	print("  fight day %d, today %d, plan %s" % [int(f["bout"]["day"]), c.day, str(PlanCards.cards(f))])
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _frames(3)
	await _plan()
	await _partner()
	await _after()
	_done()


func _plan() -> void:
	var b := _board()
	_check(b != null, "the board is on the Training tab")
	if b == null:
		return
	var title := b.find_child("TrayTitle", true, false) as Label
	_check(title != null and title.text == "THE PLAN vs", "the tray title: THE PLAN vs (%s)" % (title.text if title else "none"))
	var who := b.find_child("OppName", true, false) as Label
	var first := str(f["bout"]["opp"].get("first", str(f["bout"]["opp"].get("name", "")).get_slice(" ", 0))).to_upper()
	_check(who != null and who.text == first, "her name after vs (%s)" % (who.text if who else "none"))
	_check(b.find_child("OppFace", true, false) != null, "her face after vs")
	var tags := {}
	for card in _cards(b):
		var t := card.find_child("Tag", true, false) as Label
		if t != null:
			tags[str(card.card)] = t.text
	print("  tray tags: ", tags)
	var go := str(f["plan_combo"])
	_check(str(tags.get(go, "")) == PlanCards.GO_TO, "the GO-TO combination is in the tray, tagged GO-TO")
	_check(str(tags.get("combo:1-1", "")) == PlanCards.OPENER, "the 1-1 is the R1 OPENER")
	_check(str(tags.get("move:Check hook", "")) == PlanCards.ANSWER, "the check hook card is the ANSWER to her hooks")
	var ch := b.find_child("Drill_move_Check_hook", true, false)
	var stamp := ch.find_child("Stamp", true, false) if ch != null else null
	var eta := ch.find_child("Eta", true, false) as Label if ch != null else null
	var sw := stamp.find_child("*", true, false) as Label if stamp != null else null
	# S382 review: a punch's card stands for a line greyed on the night (StrikeMap.grey_reason), not one played at x0.8
	_check(sw != null and sw.text == PlanCards.STAMP_PUNCH, "the check hook at 2 (a punch) wears the NOT THROWN stamp (%s)" % (sw.text if sw else "none"))
	_check(eta != null and eta.text == PlanCards.LATE, "and reads 'not usable by fight night' (%s)" % (eta.text if eta else "none"))
	var gc := b.find_child("Drill_" + go.replace(":", "_"), true, false)
	_check(gc != null and gc.find_child("Stamp", true, false) == null, "the usable GO-TO wears no stamp")
	var week := PadWeek.week_of(f, PadWeek.nights_of(f))
	var on := PadWeek.cards_in(week)
	_check(not on.is_empty() and on.all(func(x): return PlanCards.cards(f).has(x)), "the coach's pad nights drill the plan (%s)" % str(on))


func _partner() -> void:
	var spar: Array = PadWeek.nights_of(f)["spar"]
	_check(not spar.is_empty(), "the camp week has a sparring night")
	if spar.is_empty():
		return
	var night := _board().find_child("Night_%d" % int(spar[0]), true, false)
	_check(night != null and night.find_child("Partner", true, false) == null, "club mates: no partner chip")
	f["camp"]["partner"] = true
	main.render()
	await _frames(2)
	night = _board().find_child("Night_%d" % int(spar[0]), true, false)
	var chip := night.find_child("Partner", true, false) if night != null else null
	var l := chip.find_child("*", true, false) as Label if chip != null else null
	_check(l != null and l.text == "southpaw mate", "the outside partner booked: 'southpaw mate' on the sparring night")


func _after() -> void:
	f["bout"]["done"] = true
	main.render()
	await _frames(2)
	var b := _board()
	var title := b.find_child("TrayTitle", true, false) as Label
	_check(title != null and title.text == "LEARN ON THE PADS", "after the fight: LEARN ON THE PADS (%s)" % (title.text if title else "none"))
	_check(b.find_child("Stamp", true, false) == null and b.find_child("OppName", true, false) == null, "no stamp, no opponent")
	var head := b.find_child("BoardHead", true, false)
	_check(head != null and head.find_child("WeekStrip", true, false) == null, "the head is THIS WEEK again, no weeks strip")
	var row := b.find_child("TrayCards", true, false) as Control
	_check(row != null and row.modulate.a < 0.99, "the switch slides the cards in (alpha %.2f)" % (row.modulate.a if row else -1.0))
	await create_timer(0.8).timeout
	row = _board().find_child("TrayCards", true, false) as Control
	_check(row != null and is_equal_approx(row.modulate.a, 1.0), "and they land")
	for card in _cards(b):
		var t := card.find_child("Tag", true, false) as Label
		if t != null and [PlanCards.GO_TO, PlanCards.OPENER, PlanCards.ANSWER].has(t.text):
			_check(false, "a plan tag left on %s" % str(card.card))


func _cards(n: Node) -> Array:
	var tray := n.find_child("DrillTray", true, false)
	if tray == null:
		return []
	return tray.find_children("Drill_*", "Button", true, false).filter(func(x): return x.get("card") != null)


func _board() -> Node:
	return main.find_child("WeekBoard", true, false)


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1


func _done() -> void:
	print("PLAN_TRAY %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)
