extends SceneTree
## S382 DRILLCARD1 (TRAINING_SCREEN_S381.md sections 3-4, build order item 2): the Training tab's week strip on the real
## board, every click path the design counts:
##   1. the tab opens on the board (the awards card below it); the strip: LEARN tray + Build, the gauges and WEEK TIREDNESS
##      in the header, PLAN TOTALS, GOAL, 7 AM + 7 PM cards; nothing dimmed, no pick lists, no combo planner;
##   2. click-click: a tray card, then a PADS night -> the card on that night (2 clicks); a second click on the card unpicks;
##   3. drag: the card's payload drops on a PADS night (split 50/50 on an occupied night); S398 v8: any evening but film takes
##      it (it becomes a pads night);
##   4. the split badge cycles 50/50 -> 70/30; right-click a slot takes that card off; right-click the night clears it;
##   5. "+ drill it" on a card held by a punch puts that punch on a night;
##   6. S398 v8: an evening's popover sets it Rest / Pads / Sparring and the PM cards follow PadWeek.nights_of;
##   7. a morning opens 9 picture cards; a pick changes the day and closes it.
## Population: the jump=camp career (TestJump "camp": Lucy in camp, her bout booked, a twist dealt).

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

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
	var pads: Array = PadWeek.nights_of(f)["pads"]
	if not pads.is_empty():
		await _day(int(pads[0]))
		b = _board()
	var combo := _button_text(b.find_child("EveningEditor", true, false), "Combo")
	_check(combo != null and str(combo.tooltip_text).contains("Build a combination"), "the evening editor builds a combination")
	var drills := b.find_children("Drill_*", "", true, false).size()
	_check(drills >= 2, "drill rows on the pad evening (%d)" % drills)
	_check(b.find_child("Step_0", true, false) == null and b.find_child("WeekTired", true, false) != null,
		"the tiredness curve, no old step row")
	_check(_button_text(b.find_child("MorningEditor", true, false), "Light") != null
		and _button_text(b.find_child("MorningEditor", true, false), "Normal") != null
		and _button_text(b.find_child("MorningEditor", true, false), "Hard") != null, "Light, Normal and Hard")
	var head := b.find_child("BoardHead", true, false)
	_check(head != null and head.find_child("Gauges", true, false) != null and head.find_child("WeekStrip", true, false) == null,
		"the gauges head the board; S398: the weeks strip is Fight prep's")
	_check(b.find_child("GoalLine", true, false) != null and b.find_child("Intensity", true, false) == null, "the goal line, no blocks count")
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
	# The two-click wait (pick a card, then an evening) was replaced by + and − on the row.
	var nights := PadWeek.nights_of(f)
	var p := int(nights["pads"][0])
	var card := "move:Body hook"
	_pin(card)
	main.render()
	await _frames(2)
	await _day(p)
	var b := _board()
	var row := b.find_child("Drill_move_Body_hook", true, false)
	_check(row != null, "the pinned Body hook card is on the evening")
	if row == null:
		return
	var plus := _button_text(row, "+")
	_check(plus != null, "the row can put the card on the night")
	if plus == null:
		return
	plus.pressed.emit()
	await _frames(2)
	_check(_on(p).has(card), "the card is on the pad night (%s)" % str(_on(p)))
	b = _board()
	row = b.find_child("Drill_move_Body_hook", true, false)
	var minus := row.find_child("DropDrill", true, false) as Button if row != null else null
	if minus != null:
		minus.pressed.emit()
		await _frames(2)
	_check(not _on(p).has(card), "taking it off clears it (%s)" % str(_on(p)))


func _drag_split_clear() -> void:
	# Drag onto a night became: Pads on that evening, then + on the row. − takes one card off.
	var nights := PadWeek.nights_of(f)
	var spar := -1
	for d in nights["spar"]:
		spar = int(d)
	if spar >= 0:
		await _day(spar)
		var pads_btn := _board().find_child("Eve_pads", true, false) as Button
		_check(pads_btn != null, "a sparring evening can become pads")
		if pads_btn != null:
			pads_btn.pressed.emit()
			await _frames(2)
			var added := _first_plus(_board(), [])
			if added != "":
				_press_plus(_board(), added)
				await _frames(2)
				_check(_on(spar).has(added) and (PadWeek.nights_of(f)["pads"] as Array).has(spar),
					"the sparring night takes the drill and becomes pads (%s)" % added)
			var back := _board().find_child("Eve_sparring", true, false) as Button
			if back != null:
				back.pressed.emit()
				await _frames(2)
	var p := int(PadWeek.nights_of(f)["pads"][0])
	await _day(p)
	var card := _first_plus(_board(), _on(p))
	_check(card != "", "a card to add beside the night's drill")
	if card == "":
		return
	_press_plus(_board(), card)
	await _frames(2)
	_check(_on(p).size() == 2 and _on(p).has(card), "the add splits the night (%s)" % str(_on(p)))
	var list: Array = PadWeek.week_of(f, PadWeek.nights_of(f))[PadWeek.DAYS[p]]
	_check(roundi(100.0 * float(list[0]["share"])) == 50 and roundi(100.0 * float(list[1]["share"])) == 50, "the split is 50/50")
	var bar := _board().find_child("SplitBar", true, false)
	var split := bar.get_child(0) as Button if bar != null and bar.get_child_count() > 0 else null
	_check(split != null, "the split bar is on the pad night")
	if split != null:
		split.pressed.emit()
		await _frames(2)
		list = PadWeek.week_of(f, PadWeek.nights_of(f))[PadWeek.DAYS[p]]
		_check(roundi(100.0 * float(list[0]["share"])) == 70 and roundi(100.0 * float(list[1]["share"])) == 30, "a click: 70/30")
	_take_off(card)
	await _frames(2)
	_check(not _on(p).has(card) and _on(p).size() == 1, "taking that card off (%s)" % str(_on(p)))
	var left: Array = _on(p)
	if not left.is_empty():
		_take_off(str(left[0]))
		await _frames(2)
	_check(_on(p).is_empty() and (f["pad_week"] as Dictionary).has(PadWeek.DAYS[p]), "the night stays empty")


func _drill_it() -> void:
	var nights := PadWeek.nights_of(f)
	var p := int(nights["pads"][0])
	main.act("drill", "%s|%d|own:1" % [fid, p])
	await _frames(2)
	await _day(p)
	var go := _board().find_child("Drill_own_1", true, false)
	var btn := go.find_child("DrillIt", true, false) as Button if go != null else null
	_check(btn != null, "the 1-1, in, 3 card is held by the Lead hook: + drill it")
	if btn == null:
		return
	# S418: the wooden button hung out of the card's bottom edge and its sentence was cut mid-word
	var card := go as Control
	var over := btn.get_global_rect().end.y - card.get_global_rect().end.y
	_check(over <= 0.5, "the Drill button sits inside its card (%.0f px past the bottom edge)" % over)
	var held := card.find_child("Held", true, false)
	var words := held.get_child(0) as Label if held != null else null
	_check(words != null and words.text.length() <= 30, "the held line is a few words (%s)" % (words.text if words != null else "none"))
	btn.pressed.emit()
	await _frames(2)
	var on := false
	var week := PadWeek.week_of(f, PadWeek.nights_of(f))
	for d in week:
		for e in week[d]:
			on = on or str(e["card"]) == "move:Lead hook"
	_check(on and (f["tray"] as Array).has("move:Lead hook"), "+ drill it: the Lead hook on a night and in the tray")


func _steps() -> void:
	# S398 v8: an evening is set in its own popover (Rest | Pads | Sparring); the PM cards follow PadWeek.nights_of.
	var rest := -1
	for i in 7:
		var nd = _board().find_child("Night_%d" % i, true, false)
		if nd != null and str(nd.kind) == "rest":
			rest = i
	_check(rest >= 0, "a rest evening to set (%d)" % rest)
	if rest < 0:
		return
	var before := _pad_cards()
	await _day(rest)
	var pads := _board().find_child("Eve_pads", true, false) as Button
	_check(pads != null, "the evening editor offers Pads")
	if pads == null:
		return
	pads.pressed.emit()
	await _frames(2)
	var want: int = (PadWeek.nights_of(f)["pads"] as Array).size()
	_check(_pad_cards() == want and want == before + 1, "Pads: that evening is a pads night (%d -> %d)" % [before, _pad_cards()])
	_check(_board().find_child("Eve_pads", true, false) != null, "the editor stays open on Pads, for its drill")
	var back := _board().find_child("Eve_rest", true, false) as Button
	if back != null:
		back.pressed.emit()
		await _frames(2)
	var title := _board().find_child("EveningTitle", true, false) as Label
	_check(_pad_cards() == before and title != null and title.text == "Rest", "Rest: back to %d pads nights" % before)


func _picker() -> void:
	# The 9 picture cards are the morning editor's session icons. The editor stays open; the title changes.
	var c: Career = main.career
	var days := WeekPlan.days_of(f)
	var dow := posmod(c.day, 7)
	await _day(dow)
	var icons := _session_icons(_board())
	_check(icons.size() == 9, "the morning editor has 9 session icons (%d)" % icons.size())
	var pick := "shadow" if str(days[dow][0]) != "shadow" else "roadwork"
	var want := str(WeekPlan.session(pick)["name"])
	var btn: Button = null
	for ic in icons:
		if str((ic as Button).tooltip_text) == want:
			btn = ic
	if btn != null:
		btn.pressed.emit()
		await _frames(2)
	var title := _board().find_child("MorningTitle", true, false) as Label
	_check(str(WeekPlan.days_of(f)[dow][0]) == pick and title != null and title.text == want,
		"a pick changes the morning to %s" % pick)


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


func _day(dow: int) -> void:
	var tile := _board().find_child("DayTile_%d" % dow, true, false) as Button
	if tile != null:
		tile.pressed.emit()
	await _frames(2)


func _button_text(root: Node, text: String) -> Button:
	if root == null:
		return null
	for n in root.find_children("*", "Button", true, false):
		if str((n as Button).text) == text:
			return n
	return null


func _session_icons(b: Node) -> Array:
	var ed := b.find_child("MorningEditor", true, false)
	var out: Array = []
	if ed == null:
		return out
	for n in ed.find_children("*", "Button", true, false):
		var btn := n as Button
		if btn.text == "" and str(btn.tooltip_text) != "":
			out.append(btn)
	return out


func _drill_name(card: String) -> String:
	return "Drill_" + card.replace(":", "_").replace(" ", "_")


func _card_of(row: Node) -> String:
	var rest := str(row.name).trim_prefix("Drill_")
	if rest == str(row.name):
		return ""
	for kind in ["move", "combo", "own"]:
		var head := str(kind) + "_"
		if rest.begins_with(head):
			return kind + ":" + rest.substr(head.length()).replace("_", " ")
	return ""


func _first_plus(b: Node, skip: Array) -> String:
	for row in b.find_children("Drill_*", "", true, false):
		var id := _card_of(row)
		if id != "" and not skip.has(id) and _button_text(row, "+") != null:
			return id
	return ""


func _press_plus(b: Node, card: String) -> void:
	var plus := _button_text(b.find_child(_drill_name(card), true, false), "+")
	if plus != null:
		plus.pressed.emit()


func _take_off(card: String) -> void:
	var row := _board().find_child(_drill_name(card), true, false)
	var minus := row.find_child("DropDrill", true, false) as Button if row != null else null
	if minus != null:
		minus.pressed.emit()


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
