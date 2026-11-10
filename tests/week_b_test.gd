extends SceneTree
## TRAININGB1: the Training tab as approach B. The tiredness curve sits on the seven day tiles, a click
## selects the day, and the evening editor is what changes the night. Headless.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/week_b_test.gd

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WeekBoard := preload("res://scripts/ui/WeekBoard.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const SlateWalk := preload("res://tests/slate_walk.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	_check(TestJump.run(main, "camp"), "jump=camp runs")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	var fid := str(f["id"])
	main.act("fighter", fid)
	main.act("ftab", "3")
	await _settle(3)
	var page := _page()
	_check(page != null, "the Training tab draws the week")
	if page == null:
		_done()
		return
	var curve := page.find_child("WeekTired", true, false) as Control
	_check(curve != null and curve.get("line_80") == true, "WeekTired draws the 80 line")
	var tiles: Array = []
	var tops := 100000.0
	var have := true
	for i in 7:
		var t := page.find_child("DayTile_%d" % i, true, false) as Control
		tiles.append(t)
		if t == null:
			have = false
		else:
			tops = minf(tops, t.get_global_rect().position.y)
	_check(have, "seven day tiles")
	if curve != null and have:
		var bottom := curve.get_global_rect().end.y
		print("WEEK_B curve bottom %.1f  tiles top %.1f" % [bottom, tops])
		_check(bottom <= tops + 0.5, "the curve sits above the tiles (%.1f vs %.1f)" % [bottom, tops])
		var span := (tiles[6] as Control).get_global_rect().get_center().x - (tiles[0] as Control).get_global_rect().get_center().x
		print("WEEK_B tile span %.1f" % span)
		_check(span > 200.0, "the tiles span the week (%.1f)" % span)
		for i in 7:
			var cx := (tiles[i] as Control).get_global_rect().get_center().x
			var cc := float(curve.call("column_center", i))
			print("WEEK_B col %d tile %.1f curve %.1f gap %.1f" % [i, cx, cc, absf(cx - cc)])
			_check(absf(cx - cc) <= 12.0, "day %d lines up within 12 px (%.1f)" % [i, absf(cx - cc)])
		var pl := WeekBoard.plan_of(c, c.fighter())
		var tired := WeekBoard.tired_days(pl)
		var mx := 0.0
		for row in tired:
			mx = maxf(mx, maxf(float(row[0]), float(row[1])))
		var peak := float(curve.get("peak"))
		print("WEEK_B peak %.2f  max tired %.2f" % [peak, mx])
		_check(is_equal_approx(peak, mx), "the curve peak is max tired (%.2f vs %.2f)" % [peak, mx])
		var before := float(curve.call("night", 2))
		print("WEEK_B Wed night before %.2f" % before)
		_fonts(page)
		for fault in SlateWalk.faults(page):
			_check(false, str(fault))
		(tiles[2] as BaseButton).pressed.emit()
		await _settle(3)
		page = _page()
		print("WEEK_B picking %s" % WeekBoard.picking)
		_check(WeekBoard.picking == "%s|2" % fid, "clicking Wed sets picking (%s)" % WeekBoard.picking)
		var title := page.find_child("MorningTitle", true, false) as Label
		var expect := str(WeekPlan.session(str((pl["days"] as Array)[2][0]))["name"])
		print("WEEK_B morning title '%s'  session '%s'" % ["" if title == null else title.text, expect])
		_check(title != null and title.text == expect, "the morning title is Wednesday's session")
		var rest := page.find_child("Eve_rest", true, false) as Button
		_check(rest != null, "the evening editor has Rest")
		if rest != null:
			rest.pressed.emit()
			await _settle(3)
			page = _page()
			curve = page.find_child("WeekTired", true, false) as Control
			var after := float(curve.call("night", 2)) if curve != null else before
			print("WEEK_B Wed night after %.2f" % after)
			_check(after < before - 0.05, "Rest lowers Wednesday night (%.2f -> %.2f)" % [before, after])
	_fonts(page)
	for fault in SlateWalk.faults(page):
		_check(false, str(fault))
	_done()


func _fonts(n: Node) -> void:
	if n is Control and not (n as Control).is_visible_in_tree():
		return
	if n is Label:
		var l := n as Label
		if l.text.strip_edges() != "":
			var sz := l.get_theme_font_size("font_size")
			var need := l.get_minimum_size().x
			print("WEEK_B label %s %dpx need %.0f has %.0f '%s'" % [l.name, sz, need, l.size.x, l.text.left(32)])
			_check(sz >= 20, "%s text is %d px" % [l.name, sz])
			_check(need <= l.size.x + 1.0, "%s is clipped (needs %.0f, has %.0f)" % [l.name, need, l.size.x])
	elif n is Button:
		var b := n as Button
		if b.text.strip_edges() != "":
			var sz2 := b.get_theme_font_size("font_size")
			print("WEEK_B button %s %dpx '%s'" % [b.name, sz2, b.text.left(32)])
			_check(sz2 >= 20, "%s text is %d px" % [b.name, sz2])
	for child in n.get_children():
		_fonts(child)


func _page() -> Control:
	return main.find_child("WeekBoard", true, false) as Control


func _settle(frames: int) -> void:
	for _i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok   ", what)
	else:
		failures += 1
		print("  FAIL ", what)


func _done() -> void:
	print("WEEK_B failures=%d" % failures)
	quit(1 if failures > 0 else 0)
