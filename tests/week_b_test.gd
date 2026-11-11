extends SceneTree
## TRAININGB1: the Training tab as approach B. The tiredness curve sits on the seven day tiles, a click
## selects the day, and the evening editor is what changes the night. Headless.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/week_b_test.gd

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WeekBoard := preload("res://scripts/ui/WeekBoard.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
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
		# S432: the old column_center check became a tautology (it returns the tile's own centre); the DayNum check below
		# measures each number against its tile instead.
		await _settle(3)
		_curve_words(page)
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
	await _pads_block()
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


func _curve_words(page: Control) -> void:
	var curve := page.find_child("WeekTired", true, false) as Control
	_check(curve != null, "the tiredness strip is up")
	if curve == null:
		return
	print("WEEK_B curve size %.1f x %.1f" % [curve.size.x, curve.size.y])
	_check(curve.size.y <= 230.0, "the curve is at most 230 tall (%.1f)" % curve.size.y)
	## S432 (TRAININGB2 review): the numbers come from the plan, not from the labels' starting text "0"
	var tired := WeekBoard.tired_days(WeekBoard.plan_of(main.career, main.career.fighter()))
	var top := 0.0
	for r in tired:
		top = maxf(top, maxf(float(r[0]), float(r[1])))
	var go := main.find_child("StartWeek", true, false) as Control
	_check(go != null and go.is_visible_in_tree() and go.get_global_rect().end.y <= 1080.5,
		"Start week is whole on the 1080 screen (ends at %.0f)" % (go.get_global_rect().end.y if go != null else -1.0))
	var title: Label = null
	var peak: Label = null
	var danger: Label = null
	for n in curve.find_children("*", "Label", true, false):
		var l := n as Label
		if not l.is_visible_in_tree():
			continue
		if l.text.begins_with("Tiredness this week"):
			title = l
		if l.text.find("peaks") >= 0:
			peak = l
		if l.text.find("too tired") >= 0:
			danger = l
	_check(title != null, "the curve is titled Tiredness this week")
	_check(peak != null, "the curve names its peak")
	if title != null:
		print("WEEK_B title '%s' %dpx rect %s" % [title.text, title.get_theme_font_size("font_size"), title.get_global_rect()])
		_check(title.get_theme_font_size("font_size") >= 26, "the title is %d px" % title.get_theme_font_size("font_size"))
	if peak != null:
		print("WEEK_B peak '%s' rect %s" % [peak.text, peak.get_global_rect()])
		_check(peak.text.ends_with("at %d" % floori(top)), "the peak sentence names the week's top, %d ('%s')" % [floori(top), peak.text])
	_check(danger != null, "the danger line says too tired")
	if danger != null and curve.has_method("danger_y"):
		var line_y := float(curve.call("danger_y"))
		var dy := absf(danger.get_global_rect().get_center().y - line_y)
		print("WEEK_B danger '%s' centre %.1f line %.1f off %.1f rect %s" % [danger.text, danger.get_global_rect().get_center().y, line_y, dy, danger.get_global_rect()])
		var over := line_y - danger.get_global_rect().end.y
		_check(over >= 0.0 and over <= 10.0, "too tired sits just over the line, not struck through (%.1f px above)" % over)
		_check(danger.get_global_rect().size.x > 100.0 and danger.get_global_rect().size.y >= 22.0, "the line's words have a size")
		_check(danger.get_theme_font_size("font_size") >= 22, "the danger line is %d px" % danger.get_theme_font_size("font_size"))
	elif danger != null:
		_check(false, "the danger line y is readable")
	var hi := 0.0
	for p in (curve.get("points") as Array):
		hi = maxf(hi, float(p))
	if hi < 80.0:
		var under: Label = null
		for n2 in curve.find_children("*", "Label", true, false):
			var l2 := n2 as Label
			if l2.is_visible_in_tree() and l2.text.find("under the line") >= 0:
				under = l2
		_check(under != null, "the strip says how far under the line")
		if under != null:
			print("WEEK_B under '%s' rect %s" % [under.text, under.get_global_rect()])
			_check(under.text.begins_with("%d under" % ceili(80.0 - hi)), "'%s' counts from the week's top %.1f" % [under.text, hi])
	for i in 7:
		var lab := curve.find_child("DayNum_%d" % i, true, false) as Label
		var tile := page.find_child("DayTile_%d" % i, true, false) as Control
		var want := floori(float(tired[i][1])) if i < tired.size() else -1
		_check(lab != null and lab.text == str(want), "day %d prints its evening number %d (%s)" % [i, want, lab.text if lab != null else "none"])
		if lab == null or tile == null:
			continue
		var dot_y := curve.global_position.y + float(curve.call("_y", float(curve.call("night", i))))
		_check(lab.get_global_rect().end.y <= dot_y - 2.0 or lab.get_global_rect().position.y >= dot_y + 2.0,
			"day %d number stays off its dot (rect %s, dot y %.1f)" % [i, lab.get_global_rect(), dot_y])
		var cx := lab.get_global_rect().get_center().x
		var tx := tile.get_global_rect().get_center().x
		print("WEEK_B num %d '%s' cx %.1f tile %.1f off %.1f rect %s" % [i, lab.text, cx, tx, absf(cx - tx), lab.get_global_rect()])
		_check(absf(cx - tx) <= 6.0, "day %d number is over its card (%.1f)" % [i, absf(cx - tx)])
		_check(lab.get_theme_font_size("font_size") >= 22, "day %d number is %d px" % [i, lab.get_theme_font_size("font_size")])
	_no_overlap(curve)


func _pads_block() -> void:
	var page := _page()
	if page == null:
		_check(false, "the board is still up")
		return
	var title := page.find_child("EveningTitle", true, false) as Label
	if title == null or title.text != "Pads":
		var nights: Dictionary = PadWeek.nights_of(main.career.fighter())
		var pads: Array = nights.get("pads", [])
		_check(not pads.is_empty(), "Lucy has a pads night")
		if pads.is_empty():
			return
		var tile := page.find_child("DayTile_%d" % int(pads[0]), true, false) as BaseButton
		_check(tile != null, "the pads day can be selected")
		if tile == null:
			return
		tile.pressed.emit()
		await _settle(4)
		page = _page()
	await _settle(2)
	_curve_words(page)
	_pads_rows(page)
	_no_overlap(page.find_child("EveningEditor", true, false))
	_fonts(page)
	for fault in SlateWalk.faults(page):
		_check(false, str(fault))


func _pads_rows(page: Control) -> void:
	var editor := page.find_child("EveningEditor", true, false) as Control
	_check(editor != null, "the pads editor is open")
	if editor == null:
		return
	var title := editor.find_child("EveningTitle", true, false) as Label
	_check(title != null and title.text == "Pads", "the evening is Pads (%s)" % ("" if title == null else title.text))
	var head := title.get_parent() if title != null else null
	var icon: Control = null
	var mins := false
	if head != null:
		for c in head.get_children():
			if icon == null and c is TextureRect:
				icon = c
			if c is Label and str((c as Label).text).find("min tonight") >= 0:
				mins = true
				print("WEEK_B minutes '%s' rect %s" % [(c as Label).text, (c as Control).get_global_rect()])
	_check(icon != null, "the pads header has its icon")
	_check(mins, "the pads header says min tonight")
	if icon != null:
		print("WEEK_B icon rect %s" % icon.get_global_rect())
	var mast_x: Array = []
	var seen := 0
	for row in editor.find_children("Drill_*", "", true, false):
		if row is Control and not (row as Control).is_visible_in_tree():
			continue
		seen += 1
		var nm := row.find_child("DrillName", true, false) as Label
		var ms := row.find_child("DrillMastery", true, false) as Label
		_check(nm != null and ms != null, "%s has a name and a mastery" % row.name)
		if nm == null or ms == null or icon == null:
			continue
		var nr := nm.get_global_rect()
		var mr := ms.get_global_rect()
		var gap := mr.position.x - nr.end.x
		var from_name := mr.position.x - nr.position.x
		print("WEEK_B row %s name %s mast %s gap %.1f column %.1f" % [row.name, nr, mr, gap, from_name])
		_check(absf(nr.position.x - icon.get_global_rect().position.x) <= 2.0, "%s name lines up with the icon (%.1f vs %.1f)" % [row.name, nr.position.x, icon.get_global_rect().position.x])
		_check(absf(nr.get_center().y - mr.get_center().y) <= 4.0, "%s name and mastery share a row" % row.name)
		_check(gap < 40.0 or from_name <= 320.0, "%s mastery sits by the name (gap %.1f, column %.1f)" % [row.name, gap, from_name])
		mast_x.append(mr.position.x)
	_check(seen > 0, "pads rows (%d)" % seen)
	if mast_x.size() >= 2:
		var anchor := float(mast_x[0])
		for x in mast_x:
			_check(absf(float(x) - anchor) <= 2.0, "mastery column holds (%.1f vs %.1f)" % [float(x), anchor])


func _no_overlap(root: Node) -> void:
	if root == null:
		_check(false, "overlap root missing")
		return
	var labs: Array = []
	_vis_labels(root, labs)
	for i in labs.size():
		for j in range(i + 1, labs.size()):
			var a: Rect2 = (labs[i] as Control).get_global_rect()
			var b: Rect2 = (labs[j] as Control).get_global_rect()
			if a.size.x < 1.0 or b.size.x < 1.0 or not a.intersects(b):
				continue
			var hit := a.intersection(b)
			if hit.size.x > 4.0 and hit.size.y > 4.0:
				var la := labs[i] as Label
				var lb := labs[j] as Label
				_check(false, "%s '%s' overlaps %s '%s' (%.0fx%.0f)" % [la.name, la.text.left(24), lb.name, lb.text.left(24), hit.size.x, hit.size.y])


func _vis_labels(n: Node, out: Array) -> void:
	if n is Control and not (n as Control).is_visible_in_tree():
		return
	if n is Label and str((n as Label).text).strip_edges() != "":
		out.append(n)
	for c in n.get_children():
		_vis_labels(c, out)


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
