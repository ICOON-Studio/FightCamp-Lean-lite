extends SceneTree
## S382 DRILLCARD1 (TRAINING_SCREEN_S381.md sections 3-4, build order item 2): the Training tab's week strip on the real
## board, every click path the design counts:
##   1. the tab opens on the board (the awards card below it); the strip: LEARN tray + Build, Light / Standard / Hard, the
##      gauges in the header, GOAL and INTENSITY, 7 AM + 7 PM cards; nothing dimmed, no pick lists, no combo planner;
##   2. click-click: a tray card, then a PADS night -> the card on that night (2 clicks); a second click on the card unpicks;
##   3. drag: the card's payload drops on a PADS night (split 50/50 on an occupied night), never on a sparring or rest night;
##   4. the split badge cycles 50/50 -> 70/30; right-click a slot takes that card off; right-click the night clears it;
##   5. "+ drill it" on a card held by a punch puts that punch on a night;
##   6. Light / Standard / Hard set the camp's protocol and the PM pad cards follow PadWeek.nights_of;
##   7. a morning opens 9 picture cards; a pick changes the day and closes it.
## Population: the jump=camp career (TestJump "camp": Lucy in camp, her bout booked, a twist dealt).

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const DrillTray := preload("res://scripts/ui/DrillTray.gd")

var _fails := 0
var main: Node
var f: Dictionary
var fid := ""


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	_check(TestJump.run(main, "camp"), "jump=camp runs")
	var c: Career = main.career
	f = c.fighter()
	fid = str(f["id"])
	f["board_taught"] = true
	f["book"] = [{"name": "jab, jab, step in, lead hook", "chain": ["jab", "jab", "step_in", "lead_hook"], "score": 70}]
	OwnCombos.ensure_ids(f)
	f["moves"]["Lead hook"] = 37.3
	main.act("fighter", fid)
	main.act("ftab", "3")
	await _frames(3)
	var b := _board()
	_check(b != null, "the board is on the Training tab")
	if b == null:
		_done()
		return
	await _layout(b)
	await _click_click()
	await _drag_split_clear()
	await _drill_it()
	await _steps()
	await _picker()
	_done()


func _layout(b: Node) -> void:
	var page := b.get_parent()
	var award := page.find_child("AwardCard", false, false) if page != null else null
	_check(award != null and award.get_index() > b.get_index(), "the tab opens on the board, the awards card below it")
	_check(page.find_child("ComboPlanner", true, false) == null, "no combo planner card (the tray replaced it)")
	var tray := b.find_child("DrillTray", true, false)
	_check(tray != null and tray.find_child("BuildCombo", true, false) != null, "the LEARN tray with + Build a combination")
	_check(tray != null and _cards(tray).size() >= 2, "drill cards in the tray (%d)" % _cards(tray).size())
	_check(b.find_child("Step_0", true, false) != null and b.find_child("Step_2", true, false) != null, "Light / Standard / Hard")
	var head := b.find_child("BoardHead", true, false)
	_check(head != null and head.find_child("Gauges", true, false) != null and head.find_child("WeekStrip", true, false) != null,
		"the weeks strip and the gauges head the board")
	_check(b.find_child("GoalRow", true, false) != null and b.find_child("Intensity", true, false) != null, "GOAL and INTENSITY")
	var am := 0
	var pm := 0
	for i in 7:
		am += 1 if b.find_child("Session_%d" % i, true, false) != null else 0
		pm += 1 if b.find_child("Night_%d" % i, true, false) != null else 0
	_check(am == 7 and pm == 7, "7 AM and 7 PM cards (%d, %d)" % [am, pm])
	_check(b.find_child("More", true, false) == null and b.find_child("Learn_" + fid, true, false) == null
		and b.find_child("Combo_" + fid, true, false) == null, "no More row, no pick lists")
	var dim := false
	for n in [b.find_child("Week", true, false), b.find_child("DrillTray", true, false)]:
		if n != null and (n as CanvasItem).modulate.a < 0.9:
			dim = true
	_check(not dim, "nothing dimmed")


func _click_click() -> void:
	var nights := PadWeek.nights_of(f)
	var p := int(nights["pads"][0])
	var card := "move:Body hook"
	_pin(card)
	main.render()
	await _frames(2)
	var b := _board()
	var btn := b.find_child("Drill_move_Body_hook", true, false) as Button
	_check(btn != null, "the pinned Body hook card is in the tray")
	if btn == null:
		return
	btn.pressed.emit()
	await _frames(2)
	_check(DrillTray.picked == "%s|%s" % [fid, card], "click 1: the card waits for a night")
	b = _board()
	var hint := b.find_child("TrayHint", true, false) as Label
	_check(hint != null and hint.text.contains("now click a PADS night"), "the hint says click a PADS night")
	(b.find_child("Drill_move_Body_hook", true, false) as Button).pressed.emit()
	await _frames(2)
	_check(DrillTray.picked == "", "clicking it again unpicks")
	(_board().find_child("Drill_move_Body_hook", true, false) as Button).pressed.emit()
	await _frames(2)
	_left(_board().find_child("Night_%d" % p, true, false))
	await _frames(2)
	_check(_on(p).has(card) and DrillTray.picked == "", "click 2 on a PADS night: the card is on it (%s)" % str(_on(p)))


func _drag_split_clear() -> void:
	var nights := PadWeek.nights_of(f)
	var p := int(nights["pads"][0])
	var b := _board()
	var src := b.find_child("Drill_combo_1-1", true, false)
	if src == null:
		src = _cards(b.find_child("DrillTray", true, false)).filter(func(x): return not _on(p).has(str(x.card))).front()
	var card := str(src.card)
	var payload: Dictionary = src.payload()
	var spar := -1
	for d in nights["spar"]:
		spar = int(d)
	if spar >= 0:
		var sn := b.find_child("Night_%d" % spar, true, false)
		_check(not sn._can_drop_data(Vector2.ZERO, payload), "no drop on a sparring night")
	var night := b.find_child("Night_%d" % p, true, false)
	_check(night._can_drop_data(Vector2.ZERO, payload), "a PADS night takes the drag")
	night._drop_data(Vector2.ZERO, payload)
	await _frames(2)
	_check(_on(p).size() == 2 and _on(p).has(card), "the drop splits the night (%s)" % str(_on(p)))
	b = _board()
	var split := b.find_child("Split_%d" % p, true, false) as Button
	_check(split != null and split.text == "50%", "the split badge reads 50%")
	if split != null:
		split.pressed.emit()
		await _frames(2)
		var list: Array = PadWeek.week_of(f, PadWeek.nights_of(f))[PadWeek.DAYS[p]]
		_check(roundi(100.0 * float(list[0]["share"])) == 70 and roundi(100.0 * float(list[1]["share"])) == 30, "a click: 70/30")
	b = _board()
	var slot := b.find_child("Slot_%d_%s" % [p, card.replace(":", "_").replace(" ", "_")], true, false) as Control
	_check(slot != null, "the split night shows a slot per card")
	if slot != null:
		_right(slot, true)
		await _frames(2)
		_check(not _on(p).has(card) and _on(p).size() == 1, "right-click a slot: that card off (%s)" % str(_on(p)))
	_right(_board().find_child("Night_%d" % p, true, false))
	await _frames(2)
	_check(_on(p).is_empty() and (f["pad_week"] as Dictionary).has(PadWeek.DAYS[p]), "right-click the night: it stays empty")


func _drill_it() -> void:
	var nights := PadWeek.nights_of(f)
	main.act("drill", "%s|%d|own:1" % [fid, int(nights["pads"][0])])
	await _frames(2)
	var go := _board().find_child("Drill_own_1", true, false)
	var btn := go.find_child("DrillIt", true, false) as Button if go != null else null
	_check(btn != null, "the 1-1, in, 3 card is held by the Lead hook: + drill it")
	if btn == null:
		return
	btn.pressed.emit()
	await _frames(2)
	var on := false
	var week := PadWeek.week_of(f, PadWeek.nights_of(f))
	for d in week:
		for e in week[d]:
			on = on or str(e["card"]) == "move:Lead hook"
	_check(on and (f["tray"] as Array).has("move:Lead hook"), "+ drill it: the Lead hook on a night and in the tray")


func _steps() -> void:
	var b := _board()
	(b.find_child("Step_2", true, false) as Button).pressed.emit()
	await _frames(2)
	_check(int(f["camp"]["protocol"]) == 3, "Hard: the camp's protocol 3")
	var want: int = (PadWeek.nights_of(f)["pads"] as Array).size()
	_check(_pad_cards() == want, "the PADS cards follow the nights (%d / %d)" % [_pad_cards(), want])
	var hard := _pad_cards()
	(_board().find_child("Step_0", true, false) as Button).pressed.emit()
	await _frames(2)
	want = (PadWeek.nights_of(f)["pads"] as Array).size()
	_check(int(f["camp"]["protocol"]) == 1 and _pad_cards() == want, "Light: protocol 1, %d PADS cards" % want)
	# The step must change what the strip shows, not only agree with itself: Hard draws more PADS cards than Light.
	_check(hard > _pad_cards(), "Hard draws more PADS nights than Light (%d > %d)" % [hard, _pad_cards()])
	(_board().find_child("Step_2", true, false) as Button).pressed.emit()
	await _frames(2)
	var tip := str((_board().find_child("Step_0", true, false) as Button).tooltip_text)
	_check(tip == "%d pad night%s a week" % [want, "" if want == 1 else "s"], "Light's tooltip counts the nights the strip runs (%s)" % tip)
	(_board().find_child("Step_1", true, false) as Button).pressed.emit()
	await _frames(2)


func _picker() -> void:
	var c: Career = main.career
	var days := WeekPlan.days_of(f)
	var dow := posmod(c.day, 7)
	var b := _board()
	(b.find_child("Session_%d" % dow, true, false) as Button).pressed.emit()
	await _frames(2)
	var pk := _board().find_child("Picker", true, false)
	var n := 0
	if pk != null:
		for k in pk.find_children("Pick_*", "Button", true, false):
			n += 1
	_check(pk != null and n == 9, "a click on a morning: 9 picture cards (%d)" % n)
	var pick := "shadow" if str(days[dow][0]) != "shadow" else "roadwork"
	(pk.find_child("Pick_" + pick, true, false) as Button).pressed.emit()
	await _frames(2)
	_check(_board().find_child("Picker", true, false) == null and str(WeekPlan.days_of(f)[dow][0]) == pick,
		"a pick changes the morning to %s and closes the picker" % pick)


func _pin(card: String) -> void:
	var t: Array = f.get("tray", [])
	t.append(card)
	f["tray"] = t


func _pad_cards() -> int:
	var n := 0
	for i in 7:
		var nd = _board().find_child("Night_%d" % i, true, false)
		if nd != null and str(nd.kind) == "pads":
			n += 1
	return n


func _on(dow: int) -> Array:
	return (PadWeek.week_of(f, PadWeek.nights_of(f)).get(PadWeek.DAYS[dow], []) as Array).map(func(e): return str(e["card"]))


func _cards(tray: Node) -> Array:
	return tray.find_children("Drill_*", "Button", true, false).filter(func(x): return x.get("card") != null)


func _left(n: Node) -> void:
	var ev := InputEventMouseButton.new()
	ev.button_index = MOUSE_BUTTON_LEFT
	ev.pressed = true
	n._gui_input(ev)


func _right(n: Node, signal_only := false) -> void:
	var ev := InputEventMouseButton.new()
	ev.button_index = MOUSE_BUTTON_RIGHT
	ev.pressed = true
	if signal_only:
		n.gui_input.emit(ev)
	else:
		n._gui_input(ev)


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
	print("DRILL_CARD %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)
