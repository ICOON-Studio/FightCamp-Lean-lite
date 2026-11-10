extends SceneTree
## DUESCARD1: three dues boards on Club > Money. Numbers come from Membership.band_preview.
## A click asks, then waits for the next calendar month. No explanation on the face.
##   Godot --headless --audio-driver Dummy --path . --script res://tests/dues_card_test.gd

const Membership := preload("res://scripts/rules/Membership.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const UI := preload("res://scripts/ui/UI.gd")

var failures := 0


func _initialize() -> void:
	_pure()
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	main.act("quick")
	main.act("go", "money:0")
	for _i in 4:
		await process_frame
	var c: Career = main.career
	_boards(main, c, false)
	await _layout(main)
	_no(main, c)
	await _yes(main, c, "cheap")
	_check(c.dues_band == "standard" and c.dues_band_next == "cheap", "yes sets next month, not this one (%s / %s)" % [c.dues_band, c.dues_band_next])
	_tag(main, "cheap", true)
	var back := main.find_child("Dues_standard", true, false) as Button
	_check(back != null, "the band in force is still a button")
	if back != null:
		back.emit_signal("pressed")
	for _i in 3:
		await process_frame
	_check(c.dues_band_next == "", "clicking the band in force clears the pending change")
	await _yes(main, c, "premium")
	_month(c)
	_words(main)
	_paint(main)
	_youth(main)
	_full(main)
	_old_save()
	print("DUES_CARD failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _pure() -> void:
	var row: Dictionary = Membership.band_preview(10, 70, "cheap", 1.0, true)
	var members := mini(roundi(Membership.natural_members(10, "cheap") * 1.0), 70)
	_check(int(row["members"]) == members and int(row["month"]) == members * Membership.fee("cheap"), "preview members and month money")
	_check(is_equal_approx(float(row["home_5y"]), 10.0 * Membership.intake_chance("cheap")), "two intakes a year for five years")
	var off: Dictionary = Membership.band_preview(10, 70, "premium", 1.0, false)
	_check(is_equal_approx(float(off["home_5y"]), 0.0), "no youth section, no home-grown boxers")


func _boards(main: Node, c: Career, youth: bool) -> void:
	var seen := {}
	for band in Membership.DUES_ORDER:
		var node := main.find_child("Dues_" + str(band), true, false) as Button
		_check(node != null, "board Dues_%s" % band)
		if node == null:
			continue
		seen[str(band)] = node
		var preview: Dictionary = _preview(c, str(band), youth)
		var words := _texts(node)
		var fee := "%s a month" % UI.money(Membership.fee(str(band)))
		_check(words.has(fee), "%s shows %s (%s)" % [band, fee, " ".join(words)])
		_check(words.has(UI.money(int(preview["month"]))), "%s shows month money %s" % [band, UI.money(int(preview["month"]))])
		_check(words.has(str(int(preview["members"]))), "%s shows %d members" % [band, int(preview["members"])])
		if youth:
			_check(words.has("%.1f" % float(preview["home_5y"])), "%s shows %.1f boxers" % [band, float(preview["home_5y"])])
		else:
			_check(words.has("needs a youth section"), "%s boxers row needs a youth section" % band)
		var force := node.find_child("InForce", true, false)
		_check((force != null) == (str(band) == c.dues_band), "IN FORCE on %s only when it is the band (%s)" % [band, c.dues_band])
	_check(seen.size() == 3, "three boards")


## DUESCARD2: a Dues tab, three boards at full size, every word inside its label.
func _layout(main: Node) -> void:
	var books := main.find_child("BooksPage", true, false) as Control
	var host := main.find_child("BooksBoard", true, false) as Control
	var area := host.get_global_rect() if host != null else Rect2()
	var btn := _dues_button(main)
	_check(btn != null, "the Dues button is on the money page")
	if btn != null:
		btn.emit_signal("pressed")
	for _i in 4:
		await process_frame
	_check(books != null and not books.visible, "Dues opens the boards and the books page steps aside")
	_check(books == null or books.find_child("Dues_cheap", true, false) == null, "the books page has no dues strip")
	var rects: Array[Rect2] = []
	for band in Membership.DUES_ORDER:
		var node := main.find_child("Dues_" + str(band), true, false) as Control
		_check(node != null and node.is_visible_in_tree(), "Dues shows %s" % band)
		if node == null:
			continue
		var r := node.get_global_rect()
		print("DUES_CARD %s %.0fx%.0f" % [band, r.size.x, r.size.y])
		_check(r.size.x >= 400.0 and r.size.y >= 600.0, "%s is at least 400 x 600 (%.0f x %.0f)" % [band, r.size.x, r.size.y])
		_check(_inside_rect(r, area), "%s stays inside the board (%.0f,%.0f %.0fx%.0f vs %.0f,%.0f %.0fx%.0f)" % [band, r.position.x, r.position.y, r.size.x, r.size.y, area.position.x, area.position.y, area.size.x, area.size.y])
		_labels(node, str(band))
		rects.append(r)
	rects.sort_custom(func(a: Rect2, b: Rect2) -> bool: return a.position.x < b.position.x)
	var gap_ok := rects.size() == 3
	for i in range(1, rects.size()):
		var gap := rects[i].position.x - rects[i - 1].end.x
		if gap < 24.0 or _hit(rects[i - 1], rects[i]):
			gap_ok = false
		print("DUES_CARD gap %.1f" % gap)
	_check(gap_ok, "three boards side by side, 24 px apart, none overlapping")


func _dues_button(main: Node) -> Button:
	var named := main.find_child("DuesTab", true, false) as Button
	if named != null and named.text == "Dues":
		return named
	for node in main.find_children("*", "Button", true, false):
		if (node as Button).text == "Dues":
			return node as Button
	return null


func _labels(node: Node, band: String) -> void:
	var fee := "%s a month" % UI.money(Membership.fee(band))
	var fee_big := false
	for lab_n in node.find_children("*", "Label", true, false):
		var lab := lab_n as Label
		var px := lab.get_theme_font_size("font_size")
		_check(px >= 24, "%s type is %d px: %s" % [band, px, lab.text])
		if lab.text == fee:
			fee_big = px >= 44
		var font := lab.get_theme_font("font")
		var measured := font.get_string_size(lab.text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x if font != null else 0.0
		var min_w := lab.get_minimum_size().x
		_check(measured <= lab.size.x + 1.0 and min_w <= lab.size.x + 1.0, "%s '%s' fits (text %.0f, min %.0f, rect %.0f)" % [band, lab.text, measured, min_w, lab.size.x])
		_check(not lab.clip_text and lab.text_overrun_behavior != TextServer.OVERRUN_TRIM_ELLIPSIS, "%s '%s' is not clipped" % [band, lab.text])
		_check(not lab.text.ends_with("…") and not lab.text.ends_with("..."), "%s '%s' has no ellipsis" % [band, lab.text])
	_check(fee_big, "%s fee is at least 44 px" % band)


func _inside_rect(r: Rect2, area: Rect2) -> bool:
	return r.position.x >= area.position.x - 1.0 and r.position.y >= area.position.y - 1.0 and r.end.x <= area.end.x + 1.0 and r.end.y <= area.end.y + 1.0


func _hit(a: Rect2, b: Rect2) -> bool:
	if not a.intersects(b, true):
		return false
	var hit := a.intersection(b)
	return hit.size.x > 1.0 and hit.size.y > 1.0


func _no(main: Node, c: Career) -> void:
	var premium := main.find_child("Dues_premium", true, false) as Button
	if premium == null:
		_check(false, "premium board to decline")
		return
	premium.emit_signal("pressed")
	var no := main.find_child("Btn_close", true, false) as Button
	var asked := _modal_text(main)
	_check(no != null and asked.find("Change dues to Premium from next month?") >= 0, "no asks once (%s)" % asked)
	if no != null:
		no.emit_signal("pressed")
	_check(c.dues_band == "standard" and c.dues_band_next == "", "no leaves the dues alone")


func _yes(main: Node, c: Career, band: String) -> void:
	# Closing the confirm redraws the page; the Dues tab is added on the next idle.
	for _i in 2:
		await process_frame
	var node := main.find_child("Dues_" + band, true, false) as Button
	_check(node != null, "click %s" % band)
	if node == null:
		return
	node.emit_signal("pressed")
	var yes := main.find_child("Btn_dues", true, false) as Button
	var name := str(Membership.DUES[band]["name"])
	var asked := _modal_text(main)
	_check(yes != null and asked.find("Change dues to %s from next month?" % name) >= 0, "yes asks for %s (%s)" % [name, asked])
	if yes != null:
		yes.emit_signal("pressed")
	for _i in 4:
		await process_frame


func _month(c: Career) -> void:
	_check(c.dues_band == "standard" and c.dues_band_next == "premium", "still waiting at the start of the month walk")
	for _i in 4:
		c.day += 7
		GymSpend.end_week(c)
	_check(c.dues_band == "premium" and c.dues_band_next == "", "four weeks later, across the month turn, premium is in force (day %d, %s / %s)" % [c.day, c.dues_band, c.dues_band_next])


func _words(main: Node) -> void:
	var board := main.find_child("DuesBoard", true, false)
	_check(board != null, "DuesBoard")
	if board == null:
		return
	for node in board.find_children("*", "Label", true, false):
		var text := str((node as Label).text)
		_check(text.length() < 40, "label under 40 (%d): %s" % [text.length(), text])
		_check(text.find("trials") < 0 and text.find("leave over") < 0, "no explanation on the face: %s" % text)


func _paint(main: Node) -> void:
	for band in Membership.DUES_ORDER:
		var node := main.find_child("Dues_" + str(band), true, false)
		if node == null:
			_check(false, "paint on %s" % band)
			continue
		var pic := node.find_child("Painting", true, false) as TextureRect
		_check(pic != null and pic.texture != null, "%s painting has a texture" % band)


func _youth(main: Node) -> void:
	var c: Career = main.career
	c.upgrades = [{"id": "youth", "day": -30}]
	main.render()
	for _i in 3:
		await process_frame
	_boards(main, c, true)


func _full(main: Node) -> void:
	var c: Career = main.career
	c.members = GymSpend.member_cap(c)
	main.render()
	for _i in 3:
		await process_frame
	var cheap := main.find_child("Dues_cheap", true, false)
	_check(cheap != null and _texts(cheap).has("the place is full"), "a full gym: the cheap members row")
	if cheap == null:
		return
	var red := false
	for node in cheap.find_children("*", "Label", true, false):
		var lab := node as Label
		if lab.text == "the place is full" and lab.get_theme_color("font_color").is_equal_approx(UI.RED):
			red = true
	_check(red, "the place is full is red")


func _tag(main: Node, band: String, on: bool) -> void:
	var node := main.find_child("Dues_" + band, true, false)
	var tag := node.find_child("NextTag", true, false) if node != null else null
	_check((tag != null) == on, "From next month tag on %s" % band)


func _old_save() -> void:
	var c := Career.new()
	c.dues_band_next = "cheap"
	var d := SaveGame.to_dict(c)
	(d["props"] as Dictionary).erase("dues_band_next")
	var back := SaveGame.from_dict(d)
	_check(back.dues_band_next == "", "a save without the field loads as empty")


func _preview(c: Career, band: String, youth: bool) -> Dictionary:
	return Membership.band_preview(c.reputation, GymSpend.member_cap(c), band, GymBonus.members(c.gym_plan), youth)


func _texts(node: Node) -> PackedStringArray:
	var out: PackedStringArray = []
	for lab in node.find_children("*", "Label", true, false):
		out.append(str((lab as Label).text))
	return out


func _modal_text(main: Node) -> String:
	var modal := main.modal_node() as Node
	if modal == null:
		return ""
	var bits := ""
	for lab in modal.find_children("*", "Label", true, false):
		bits += (lab as Label).text + " "
	return bits


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
