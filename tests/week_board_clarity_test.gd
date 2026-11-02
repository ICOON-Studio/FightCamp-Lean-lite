extends SceneTree
## S359 Kalli SQ25's whiteboard clarity fixes on the real board (jump=camp: Lucy in camp, a twist with two answers dealt):
## fatigue as words, LIGHT / NORMAL / HARD on the magnets, the camp's phase strip with 'you are here', COACH'S PICK and the
## Monday rule, the grid dimmed until the twist is answered once, 'undo' on a changed day, a moved goal line shows its delta,
## and hovering an answer previews the lines.
## Population: the jump=camp career (TestJump "camp") - one amateur in camp, her bout booked.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")
const WeekBoard := preload("res://scripts/ui/WeekBoard.gd")

const WORDS := ["FRESH", "OK", "TIRED", "RED DAY", "OVERCOOKED"]

var _fails := 0
var main: Node


func _initialize() -> void:
	# The pure pieces first.
	_check(WB.level("light") == "LIGHT" and WB.level("hard") == "HARD" and WB.level("normal") == "NORMAL", "intensity as words")
	_check(str(WB.fatigue_word(30.0, false)[0]) == "FRESH" and str(WB.fatigue_word(60.0, false)[0]) == "OK" and str(WB.fatigue_word(75.0, false)[0]) == "TIRED"
		and str(WB.fatigue_word(65.0, true)[0]) == "RED DAY" and str(WB.fatigue_word(85.0, true)[0]) == "OVERCOOKED", "fatigue bands")
	_check(str(WB.fatigue_word(85.0, false)[1]).contains("60%") and str(WB.fatigue_word(85.0, false)[1]).contains("85"),
		"overcooked names its cost and the number on the hover")
	_check(WeekBoard.phase_cells(5) == ["BUILD", "BUILD", "BUILD", "PEAK", "TAPER"], "a 5-week camp's strip")
	_check(WeekBoard.phase_cells(1) == ["TAPER"], "a fight-week camp is one TAPER cell")

	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	_check(TestJump.run(main, "camp"), "jump=camp runs")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	var fid := str(f["id"])
	f.erase("board_taught")
	f.erase("twist_pick")
	main.act("fighter", fid)
	main.act("ftab", "3")
	await _settle(3)
	var b := _board()
	_check(b != null, "the whiteboard is on the Training tab")
	if b == null:
		_done()
		return
	_check(b.find_child("PhaseStrip", true, false) != null, "the phase strip is drawn")
	_check(_texts(b.find_child("PhaseStrip", true, false)).has("you are here"), "the strip says 'you are here'")
	var words := 0
	for i in 7:
		var l := b.find_child("Fatigue_%d" % i, true, false) as Label
		if l != null and WORDS.has(l.text) and not l.get_signal_connection_list("mouse_entered").is_empty():   # S359 its card (Tips)
			words += 1
	_check(words == 7, "seven days read their tiredness as a word with its card on hover (%d)" % words)
	var roman := 0
	for i in 7:
		for t in _texts(b.find_child("Session_%d" % i, true, false)):
			if t in ["I", "II", "III"]:
				roman += 1
	_check(roman == 0, "no roman numerals on the morning magnets (%d)" % roman)
	var twist_has_choice := b.find_child("TwistPick_a", true, false) != null
	_check(twist_has_choice, "the jump's twist has two answers")
	var pick_a := b.find_child("CoachPick_a", true, false) as Label
	var pick_b := b.find_child("CoachPick_b", true, false) as Label
	_check(pick_a != null and pick_b != null and (pick_a.text == "COACH'S PICK") != (pick_b.text == "COACH'S PICK"),
		"one answer is labelled COACH'S PICK")
	_check(b.find_child("TwistRule", true, false) != null, "the sticky says no answer by Monday = the coach's pick")
	var grid := b.find_child("Week", true, false) as Control
	_check(WeekBoard.teaching(f) and b.find_child("StartHere", true, false) != null, "first open: START HERE on the sticky")
	_check(grid != null and grid.get_parent().modulate.a < 0.5, "first open: the grid is dimmed")

	# Hovering an answer previews where the lines land.
	b._preview("b")
	var shown := 0
	for id in b._delta:
		if str((b._delta[id] as Label).text) != "":
			shown += 1
	_check(shown >= 2, "hovering an answer previews the goal lines (%d)" % shown)
	b._preview_off()

	main.act("twistpick", "%s|%s" % [fid, "a"])
	await _settle(2)
	b = _board()
	_check(bool(f.get("board_taught", false)), "answering the twist ends the teaching dim")
	grid = b.find_child("Week", true, false) as Control
	_check(grid.get_parent().modulate.a > 0.9, "the grid brightens once the twist is answered")

	# Change Sunday (the coach's rest) to Hard intervals: 'undo' appears and a goal line pulses its delta.
	main.act("wday", "%s|6|intervals|hard" % fid)
	await _settle(2)
	b = _board()
	_check(b.find_child("Undo_6", true, false) != null, "a changed day carries 'undo'")
	var moved := 0
	for id in b._delta:
		if str((b._delta[id] as Label).text) != "":
			moved += 1
	_check(moved >= 1, "a moved goal line shows its delta (%d)" % moved)
	(b.find_child("Undo_6", true, false) as Button).pressed.emit()
	await _settle(2)
	b = _board()
	_check(b.find_child("Undo_6", true, false) == null and not (f.get("week_edits", {}).get("days", {}) as Dictionary).has("6"),
		"'undo' puts the coach's card back")
	_done()


func _board() -> Node:
	return main.find_child("WeekBoard", true, false)


func _texts(n: Node) -> Array:
	var out: Array = []
	if n == null:
		return out
	if n is Label:
		out.append((n as Label).text)
	for k in n.get_children():
		out.append_array(_texts(k))
	return out


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1


func _done() -> void:
	print("WEEK_BOARD_CLARITY %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)
