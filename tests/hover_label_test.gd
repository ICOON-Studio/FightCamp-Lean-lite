extends SceneTree
## S443 hover labels (his Q-S294-197, the Hades idea): a small secondary button shows its word in a dark tag while the
## mouse is on it. At rest no tag; on hover the tag, under the button, never on it, inside the window; gone on exit.
## The top bar's back / forward arrows carry one, and their tooltip is empty (no second word half a second later).
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/hover_label_test.gd

const HoverLabel := preload("res://scripts/ui/HoverLabel.gd")

var failures := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var host := Control.new()
	host.size = Vector2(1920, 1080)
	root.add_child(host)
	await _unit(host)
	host.queue_free()
	await _game()
	print("HOVER_LABEL failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _button(host: Control, at: Vector2) -> Button:
	var b := Button.new()
	b.text = "<"
	b.tooltip_text = "Back: the last page"
	b.position = at
	b.size = Vector2(36, 36)
	host.add_child(b)
	return b


func _unit(host: Control) -> void:
	var b := _button(host, Vector2(100, 100))
	var tag := HoverLabel.attach(b, "Back")
	await process_frame
	_check(tag != null and tag.name == "HoverTag", "attach makes a HoverTag")
	_check(not tag.visible, "no tag at rest")
	_check(tag.mouse_filter == Control.MOUSE_FILTER_IGNORE, "the tag never takes the mouse")
	_check(HoverLabel.word(b) == "BACK", "the word reads BACK (%s)" % HoverLabel.word(b))
	_check(b.tooltip_text == "", "the button's tooltip is cleared")
	b.emit_signal("mouse_entered")
	await create_timer(0.25).timeout
	_check(tag.visible and tag.modulate.a > 0.95, "the tag shows on hover (visible %s, alpha %.2f)" % [tag.visible, tag.modulate.a])
	var br := b.get_global_rect()
	var tr := tag.get_global_rect()
	_check(tr.size.x > 20.0 and tr.size.y >= 16.0, "the tag has a size (%s)" % str(tr.size))
	_check(tr.position.y >= br.end.y and not tr.intersects(br), "the tag sits under the button, not on it (%s / %s)" % [str(tr), str(br)])
	_check(absf(tr.get_center().x - br.get_center().x) <= 2.0, "the tag is centred under the button")
	b.emit_signal("mouse_exited")
	await process_frame
	_check(not tag.visible, "the tag goes when the mouse leaves")
	HoverLabel.attach(b, "Back again")
	_check(b.find_children("HoverTag", "", false, false).size() == 1 and HoverLabel.word(b) == "BACK AGAIN", "attach twice keeps one tag and changes the word")
	b.emit_signal("focus_entered")
	await process_frame
	_check(tag.visible, "keyboard focus shows it too")
	b.visible = false
	await process_frame
	_check(not tag.visible, "a hidden button hides its tag")
	var view := host.get_viewport_rect()
	print("HOVER_LABEL view %s" % str(view))
	var low := _button(host, Vector2(600, view.end.y - 40.0))
	var low_tag := HoverLabel.attach(low, "Skip")
	low.emit_signal("mouse_entered")
	await process_frame
	_check(low_tag.get_global_rect().end.y <= low.get_global_rect().position.y, "at the bottom edge the tag goes above (%s)" % str(low_tag.get_global_rect()))
	var edge := _button(host, Vector2(view.end.x - 20.0, 300))
	var edge_tag := HoverLabel.attach(edge, "A long word here")
	edge.emit_signal("mouse_entered")
	await process_frame
	_check(edge_tag.get_global_rect().end.x <= view.end.x, "at the right edge the tag stays inside (%s)" % str(edge_tag.get_global_rect()))
	var col := _button(host, Vector2(1700, 500))
	var col_tag := HoverLabel.attach(col, "Speed (Space)", "left")
	col.emit_signal("mouse_entered")
	await process_frame
	var cr := col_tag.get_global_rect()
	_check(cr.end.x <= col.get_global_rect().position.x and absf(cr.get_center().y - col.get_global_rect().get_center().y) <= 2.0, "a left tag sits beside the button (%s)" % str(cr))


func _game() -> void:
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	main.act("go", "money:0")
	main.act("go", "fighters:1")
	await process_frame
	await process_frame
	for n in ["Nav_back", "Nav_fwd"]:
		var b := main.find_child(n, true, false) as Button
		_check(b != null, n + " is on the top bar")
		if b == null:
			continue
		_check(HoverLabel.word(b) != "", "%s carries a hover word" % n)
		_check(b.tooltip_text == "", "%s has no second tooltip (%s)" % [n, b.tooltip_text])
		print("HOVER_LABEL %s -> %s (disabled %s)" % [n, HoverLabel.word(b), b.disabled])
	var back := main.find_child("Nav_back", true, false) as Button
	if back != null:
		back.emit_signal("mouse_entered")
		await process_frame
		var tag := back.get_node_or_null("HoverTag") as Control
		_check(tag != null and tag.visible, "hovering the back arrow shows its word in the game")
		if tag != null:
			var r := tag.get_global_rect()
			var view := back.get_viewport_rect()
			_check(view.encloses(r) and not r.intersects(back.get_global_rect()), "the game's tag is inside the window (%s)" % str(r))
	main.queue_free()
