extends SceneTree
## Plan board on the boxing move map: Build plan toggle, arrow limit, coverage line, remove re-enables outs.

const Map := preload("res://scripts/rules/StrikeMap.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")

var failures := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var s: Control = load("res://scenes/dev/StrikeBrowser.tscn").instantiate()
	root.add_child(s)
	await process_frame
	await process_frame

	var limit := PlanBoard.arrow_limit(s.DEMO_COACH)
	var build := _find_button(root, "Build plan")
	_check(build != null, "Build plan button exists")
	build.pressed.emit()
	await process_frame
	await process_frame

	# Six arrows from six different cards (one per from-place).
	var steps: Array = [
		["outside", "step_in"],
		["long", "1-2"],
		["mid", "3b-3"],
		["inside", "tie_up"],
		["clinch", "push_off"],
		["own_ropes", "pivot_out"],
	]
	for step in steps:
		var card_id: String = step[0]
		var move_id: String = step[1]
		if s.current != card_id:
			s.go(card_id)
			await process_frame
		s._take(Map.move(move_id), true)
		await process_frame

	_check(s.plan.size() == limit, "plan holds %d arrows (got %d)" % [limit, s.plan.size()])
	s.go("clinch")
	await process_frame
	_check(_arrows_label_text(s) == "Arrows %d / %d" % [limit, limit], "panel reads Arrows %d / %d" % [limit, limit])
	_check(_all_move_outs_full(s), "every move-out disabled with plan-full reason")

	var remove := _find_button(s._side, "Remove")
	_check(remove != null, "Remove button on an arrow row")
	remove.pressed.emit()
	await process_frame
	await process_frame

	_check(s.plan.size() == limit - 1, "remove one drops count to %d" % (limit - 1))
	_check(_arrows_label_text(s) == "Arrows %d / %d" % [limit - 1, limit], "count drops by one on panel")
	s.go("clinch")
	await process_frame
	_check(_any_move_out_enabled(s), "move-out buttons enable again after remove")

	var cov := PlanBoard.coverage(s.plan, Map.MOVES)
	var want_cov := "Covers %d%% of her map" % int(round(cov * 100.0))
	_check(_label_exists(s._side, want_cov), "coverage line equals PlanBoard.coverage (%s)" % want_cov)

	print("FAIL %d" % failures if failures else "PASS plan_screen_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1


func _find_button(from: Node, big: String) -> Button:
	for b in from.find_children("*", "Button", true, false):
		var btn: Button = b
		if btn.text == big or _button_big(btn) == big:
			return btn
	return null


func _button_big(b: Button) -> String:
	for l in b.find_children("*", "Label", true, false):
		var lb: Label = l
		if lb.get_theme_font_size("font_size") >= 20:
			return lb.text
	return ""


func _arrows_label_text(s: Control) -> String:
	for l in s._side.find_children("*", "Label", true, false):
		var t := str(l.text)
		if t.begins_with("Arrows "):
			return t
	return ""


func _move_out_buttons(side: Node) -> Array:
	var outs: Array = []
	var in_out := false
	for c in side.get_children():
		if c is Label and str(c.text).begins_with("MOVES OUT"):
			in_out = true
			continue
		if c is Label and str(c.text).begins_with("MOVES IN"):
			break
		if in_out and c is Button:
			outs.append(c)
	return outs


func _all_move_outs_full(s: Control) -> bool:
	var limit := PlanBoard.arrow_limit(s.DEMO_COACH)
	var reason := "The plan is full (%d arrows for this coach)" % limit
	var outs := _move_out_buttons(s._side)
	if outs.is_empty():
		return false
	for b in outs:
		if not (b as Button).disabled:
			return false
		if not _out_shows_reason(b as Button, reason):
			return false
	return true


func _out_shows_reason(b: Button, reason: String) -> bool:
	if b.tooltip_text == reason:
		return true
	for l in b.find_children("*", "Label", true, false):
		if str(l.text) == reason:
			return true
	return false


func _any_move_out_enabled(s: Control) -> bool:
	for b in _move_out_buttons(s._side):
		if not (b as Button).disabled:
			return true
	return false


func _label_exists(from: Node, text: String) -> bool:
	for l in from.find_children("*", "Label", true, false):
		if str(l.text) == text:
			return true
	return false
