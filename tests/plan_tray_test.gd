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
	# Approach B: the plan's cards are the evening editor's rows. The "THE PLAN vs" header, the face,
	# and the GO-TO / R1 OPENER / ANSWER tags were dropped. A punch that will not be usable keeps the
	# late line on the row's tooltip (the old Eta / NOT THROWN stamp).
	var pads: Array = PadWeek.nights_of(f)["pads"]
	_check(not pads.is_empty(), "a pad night to open")
	if pads.is_empty():
		return
	await _day(int(pads[0]))
	b = _board()
	var hook := "move:Check hook"
	var go := str(f["plan_combo"])
	var late := _tip(b, hook)
	_check(late == PlanCards.LATE, "the check hook at 2 (a punch) reads 'not usable by fight night' (%s)" % late)
	_check(_row(b, go) != null and _tip(b, go) != PlanCards.LATE, "the usable GO-TO wears no late line (%s)" % _tip(b, go))
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
	_check(b.find_child("Stamp", true, false) == null and b.find_child("OppName", true, false) == null, "no stamp, no opponent")
	var head := b.find_child("BoardHead", true, false)
	_check(head != null and head.find_child("WeekStrip", true, false) == null, "the head is THIS WEEK again, no weeks strip")
	# The old tray's slide (LEARN ON THE PADS, TrayCards fading in) was dropped with the tray header.
	var pads: Array = PadWeek.nights_of(f)["pads"]
	if not pads.is_empty():
		await _day(int(pads[0]))
		b = _board()
	var late := false
	var rows := b.find_children("Drill_*", "", true, false)
	for row in rows:
		if _tip_of(row) == PlanCards.LATE:
			late = true
	_check(not late and rows.size() >= 1, "after the fight the rows are the learn list, with no late line (%d)" % rows.size())


func _day(dow: int) -> void:
	var tile := _board().find_child("DayTile_%d" % dow, true, false) as Button
	if tile != null:
		tile.pressed.emit()
	await _frames(2)


func _row(b: Node, card: String) -> Node:
	return b.find_child("Drill_" + card.replace(":", "_").replace(" ", "_"), true, false)


func _tip(b: Node, card: String) -> String:
	return _tip_of(_row(b, card))


func _tip_of(row: Node) -> String:
	if row == null:
		return ""
	var labs := row.find_children("*", "Label", true, false)
	return str((labs[0] as Label).tooltip_text) if not labs.is_empty() else ""


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
