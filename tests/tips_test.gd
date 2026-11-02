extends SceneTree
## S359 the index cards (Tips, J90 tier 2): placement beside the control, inside the screen and never over it; the card
## waits the tooltip delay, locks LOCK_S later, Shift pins it, Esc closes it; a card's text never sits on a see-through
## box. Headless: the mouse rests at (0, 0), so the control sits under it there.

const Tips := preload("res://scripts/ui/Tips.gd")

var _fails := 0


func _initialize() -> void:
	var screen := Rect2(0, 0, 1920, 1080)
	var size := Vector2(300, 180)
	# Placement: room on the right -> right of it, top-aligned; at the right edge -> left; never over the anchor.
	var a := Rect2(200, 300, 140, 40)
	var r := Tips.place(size, a, screen)
	_check(r.position.x >= a.end.x and is_equal_approx(r.position.y, a.position.y), "room on the right: beside it, top-aligned (%s)" % r)
	var edge := Rect2(1800, 300, 100, 40)
	r = Tips.place(size, edge, screen)
	_check(r.end.x <= edge.position.x, "at the right edge: flipped to the left (%s)" % r)
	var low := Rect2(900, 1040, 140, 30)
	r = Tips.place(size, low, screen)
	_check(screen.grow(-16).encloses(r) and not r.intersects(low), "at the bottom: inside the screen, off the control (%s)" % r)
	for anchor in [a, edge, low, Rect2(0, 0, 60, 30), Rect2(1860, 1050, 60, 30)]:
		var p := Tips.place(size, anchor, screen)
		_check(not p.intersects(anchor), "never over its control %s" % anchor)

	# The live card on a control under the mouse.
	root.size = Vector2i(1920, 1080)
	var c := Button.new()
	c.text = "magnet"
	c.position = Vector2(0, 0)
	c.size = Vector2(160, 40)
	root.add_child(c)
	await process_frame
	Tips.card(c, func(): return {"title": "Hard intervals - morning", "rows": [["Conditioning", "+0.20", "▲", "good"],
		["Tired by night", "64 / 100", "OK", ""]], "means": "a hard day.", "hint": [["shift", "pin"]]})
	_check(c.tooltip_text == "", "the engine's tooltip is off on a carded control")
	c.mouse_entered.emit()
	await _secs(0.1)
	_check(Tips.state() == "pending" and Tips.open_card() == null, "before the delay: nothing shown (%s)" % Tips.state())
	await _secs(0.35)
	var card := Tips.open_card()
	_check(Tips.state() == "shown" and card != null, "after the delay: the card is shown (%s)" % Tips.state())
	if card != null:
		_check(not card.get_global_rect().intersects(c.get_global_rect()), "the card is not over the control")
		var panel := card.get_child(0) as PanelContainer
		var st := panel.get_theme_stylebox("panel") as StyleBoxFlat
		_check(st != null and st.bg_color.a >= 0.999, "the card is opaque")
	await _secs(0.8)
	_check(Tips.state() == "locked", "locked LOCK_S after showing (%s)" % Tips.state())
	var shift := InputEventKey.new()
	shift.keycode = KEY_SHIFT
	shift.pressed = true
	root.push_input(shift)
	await process_frame
	_check(Tips.state() == "pinned", "Shift pins it (%s)" % Tips.state())
	var esc := InputEventKey.new()
	esc.keycode = KEY_ESCAPE
	esc.pressed = true
	root.push_input(esc)
	await _secs(0.2)
	_check(Tips.state() == "hidden", "Esc closes it (%s)" % Tips.state())
	print("TIPS %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _secs(s: float) -> void:
	var t := Time.get_ticks_msec() + int(s * 1000.0)
	while Time.get_ticks_msec() < t:
		await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
