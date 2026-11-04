extends SceneTree
## S381 G2 (gym idea 3): the WEEKS STRIP (scripts/ui/WeekStrip.gd). Population: the golden path's quick-start career
## (seed 1) - Lucy signed, the coach hired, her first even offer accepted (camp_cards_test's _book).
##   1. Pure: a 25-day camp is "4 BUILD | 3 BUILD | 2 PEAK | 1 TAPER" with glove pips 1/1/2/0 (WeekPhase.spar), this week
##      first, the red tick after the Peak week; a camp set a week ago shows that week gone; this week's own sparring count
##      wins; a fight-week camp is one TAPER cell with no tick. The coach's projected week: 7 lines, sparring twice in Peak,
##      none in the taper, film takes a Build pad night.
##   2. SET CAMP draws the strip top right: one cell a week to go, this week gold and not clickable, the fight poster with
##      the opponent's face and the date; a click on a week to come opens the coach's week read-only.
##   3. With the camp started, the whiteboard header carries the strip and no "camp week N of M" text.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WeekStrip := preload("res://scripts/ui/WeekStrip.gd")
const UI := preload("res://scripts/ui/UI.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	_pure()
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var f := _book()
	_check(not f.is_empty(), "Lucy has an even bout booked")
	if f.is_empty():
		_done()
		return
	var c: Career = main.career
	var bout_day := int(f["bout"]["day"])
	main.act("camp", str(f["id"]))
	await _settle(0.1)
	var m: Node = main.modal_node()
	var s := m.find_child("WeekStrip", true, false) if m != null else null
	_check(s != null, "SET CAMP draws the weeks strip")
	if s == null:
		_done()
		return
	var want := WeekStrip.cells(bout_day, c.day, c.day)
	var words: Array = []
	for cl in want:
		var b := s.find_child("Week_%d" % int(cl["to_go"]), false, false) as Button
		if b == null:
			continue
		words.append((b.find_child("Word", true, false) as Label).text)
		_check(b.disabled == not bool(cl["future"]), "%s: clickable only when still to come" % cl["word"])
		_check(int(b.find_child("Pips", true, false).get("n")) == int(cl["spar"]), "%s: %d glove pips" % [cl["word"], int(cl["spar"])])
		var bg := (b.get_theme_stylebox("normal") as StyleBoxFlat).bg_color
		_check((bg == UI.YELLOW) == bool(cl["now"]), "%s: gold exactly when it is this week" % cl["word"])
	_check(words == want.map(func(x): return str(x["word"])) and words.size() == int(ceil((bout_day - c.day) / 7.0)),
		"one cell a week to go: %s" % " | ".join(words))
	_check(s.find_child("LastSpar", false, false) != null, "the red tick at the last hard spar")
	var poster := s.find_child("Poster", false, false)
	_check(poster != null and (poster.find_child("Face", true, false) as TextureRect).texture != null, "the poster has the opponent's face")
	_check(poster != null and (poster.find_child("Date", true, false) as Label).text == Clock.fmt(bout_day).to_upper(),
		"the poster has the date (%s)" % Clock.fmt(bout_day).to_upper())
	var not_on := " ".join(_texts(m))
	_check(not not_on.contains("camp week") and not not_on.contains("Build 1"), "no 'camp week' text, no phase bar")
	# A week to come: the coach's week, read-only.
	var fut := -1
	for i in want.size():
		if bool(want[i]["future"]):
			fut = i
			break
	_check(fut >= 0, "the camp has a week to come")
	if fut >= 0:
		var peek := s.find_child("WeekPeek", false, false) as PopupPanel
		_check(peek != null and not peek.visible, "nothing opens on its own")
		(s.find_child("Week_%d" % int(want[fut]["to_go"]), false, false) as Button).pressed.emit()
		await _settle(0.1)
		var lines := _texts(peek)
		var exp := WeekStrip.week_lines(str(want[fut]["phase"]), str(main.modal["focus"]), false)   # film: the first week only
		_check(peek.visible and lines.size() == 8 and lines.slice(1) == exp, "the click shows the coach's week: %s" % [lines])
		_check(peek.find_children("*", "BaseButton", true, false).is_empty(), "read-only: no buttons in it")
		peek.hide()
	# 3. The whiteboard header after the camp starts.
	main.act("startcamp")
	await _settle(0.1)
	if not main.modal.is_empty():
		main.act("close")
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _settle(0.2)
	var board := main.find_child("WeekBoard", true, false)
	_check(board != null and board.find_child("WeekStrip", true, false) != null, "the whiteboard header carries the strip")
	_check(board != null and not " ".join(_texts(board)).contains("camp week"), "no 'camp week N of M' on the board")
	_done()


func _pure() -> void:
	var cs := WeekStrip.cells(25, 0, 0)
	_check(cs.map(func(x): return str(x["word"])) == ["4 BUILD", "3 BUILD", "2 PEAK", "1 TAPER"], "25 days: 4 BUILD | 3 BUILD | 2 PEAK | 1 TAPER")
	_check(cs.map(func(x): return int(x["spar"])) == [1, 1, 2, 0], "glove pips 1/1/2/0")
	_check(bool(cs[0]["now"]) and not bool(cs[0]["future"]) and bool(cs[3]["future"]), "this week first, the rest to come")
	_check(WeekStrip.last_spar(cs) == 2, "the red tick after the Peak week")
	var mid := WeekStrip.cells(25, 7, 0)
	_check(mid.size() == 4 and bool(mid[0]["past"]) and bool(mid[1]["now"]), "a week into the camp: the first week gone")
	var own := WeekStrip.cells(25, 7, 0, 2)
	_check(int(own[1]["spar"]) == 2 and int(own[2]["spar"]) == 2, "this week's own sparring count wins")
	var late := WeekStrip.cells(25, 7, 7)
	_check(late.size() == 3 and bool(late[0]["now"]), "a camp set late counts from the day it was set")
	var fw := WeekStrip.cells(5, 0, 0)
	_check(fw.size() == 1 and str(fw[0]["word"]) == "1 TAPER" and WeekStrip.last_spar(fw) == -1, "fight week: one TAPER cell, no tick")
	var peak := WeekStrip.week_lines("peak", "power", false)
	_check(peak.size() == 7 and peak.filter(func(l): return str(l).ends_with("sparring")).size() == 2, "Peak: 7 lines, sparring twice")
	_check(str(peak[1]) == "Tue  Normal heavy bag - sparring", "Peak Tuesday: %s" % peak[1])
	_check(WeekStrip.week_lines("taper", "power", false).filter(func(l): return str(l).contains("sparring")).is_empty(), "taper: no sparring")
	_check(WeekStrip.week_lines("build", "power", true).filter(func(l): return str(l).ends_with("film")).size() == 1, "film takes a Build pad night")


func _book() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			main.act("accept", str(o["id"]))
			return f
	return {}


func _texts(n: Node) -> Array:
	var out: Array = []
	if n == null:
		return out
	if n is Label:
		out.append((n as Label).text)
	for k in n.get_children():
		out.append_array(_texts(k))
	return out


func _settle(t: float) -> void:
	await create_timer(t).timeout
	await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1


func _done() -> void:
	print("WEEK_STRIP %s" % ("PASS" if failures == 0 else "FAIL %d" % failures))
	quit(0 if failures == 0 else 1)
