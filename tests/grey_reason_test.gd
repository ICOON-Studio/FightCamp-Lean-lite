extends SceneTree
## Every visible disabled BaseButton on the layout-snapshot route must carry a real tooltip reason (>= 12 chars, not generic).

const Bouts := preload("res://scripts/state/Bouts.gd")
const Needs := preload("res://scripts/state/Needs.gd")

const W := 1920
const H := 1080

var main: Node
var failures := 0
var disabled_total := 0


func _initialize() -> void:
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(W, H)
	await _settle()
	await _check_moment("01_title")
	main.act("newcareer")
	await _check_moment("02_create")
	main.act("quick")
	await _check_moment("03_home_start")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	await _check_moment("04_interview")
	main.act("sign")
	main.act("go", "gym:1")
	await _check_moment("05_gym_staff")
	main.act("hire", "reid")
	main.act("go", "fighters:1")
	await _check_moment("06_training")
	main.run_to_stop()
	main.act("area", "home")
	await _check_moment("07_home_week1")
	main.act("review")
	await _settle(80)
	await _check_moment("08_review")
	main.act("close")
	main.act("fighter", "lucy")
	await _check_moment("09_fighter")
	var c: Career = main.career
	_run_until(func(): return not (c.fighter()["offers"] as Array).is_empty())
	main.act("go", "fights:0")
	await _check_moment("10_offers")
	main.act("openBout", "lucy:m8")
	await _check_moment("11_bout_unsafe")
	main.act("openBout", "lucy:o8")
	await _check_moment("12_bout")
	main.act("accept", "lucy:o8")
	await _check_moment("13_home_booked")
	main.act("camp", "lucy")
	await _check_moment("14_camp")
	main.act("startcamp")
	main.act("go", "fighters:2")
	await _check_moment("15_fight_camps")
	_run_until(func(): return Bouts.weigh_in_today(c, c.fighter()))
	main.act("weighin", "lucy")
	await _check_moment("16_weighin")
	main.act("doWeigh")
	main.run_to_stop()
	main.act("area", "home")
	await _check_moment("17_home_fightnight")
	main.act("go_btn")
	await _check_moment("18_tape")
	main.act("fightstep", "start")
	await _check_moment("19_round1")
	main.act("fightwatched", "1")
	await _check_moment("19b_corner1")
	main.act("fightstep", "corner:body")
	main.act("fightwatched", "2")
	await _check_moment("19c_corner2")
	main.act("fightstep", "corner:long")
	await _check_moment("20_round3")
	main.act("fightstep", "end")
	await _check_moment("21_result")
	main.act("afterfight")
	main.act("goaltalk", "lucy")
	main.act("pickgoal", "five_round_engine")
	await _check_moment("22_goaltalk")
	main.act("setgoal")
	main.act("fighter", "lucy")
	main.act("ftab", "4")
	await _check_moment("23_record")
	main.act("ftab", "0")
	await _check_moment("23b_coach_notes")
	main.act("ftab", "1")
	await _check_moment("23c_combos")
	main.act("go", "fighters:1")
	await _check_moment("23d_training_combo")
	main.act("go", "money:3")
	main.act("deal", "ironclad")
	await _check_moment("24_deals")
	main.act("go", "gym:3")
	await _check_moment("25_facilities")
	main.act("repair", "bags")
	_run_until(func(): return c.day >= 40)
	main.act("go", "money:0")
	await _check_moment("26_money")
	main.act("go", "money:2")
	await _check_moment("27_bills")
	main.act("go", "gym:2")
	await _check_moment("28_members")
	main.act("go", "world:0")
	await _check_moment("29_news")
	main.act("go", "world:1")
	await _check_moment("30_rankings")
	main.act("go", "world:2")
	await _check_moment("31_events")
	main.act("go", "world:3")
	var box: LineEdit = main._shell.find_child("SearchBox", true, false)
	box.text = "ri"
	box.text_changed.emit("ri")
	await _check_moment("32_search")
	if disabled_total <= 0:
		failures += 1
		print("FAIL: no disabled buttons seen on the route")
	print("disabled buttons on route: %d" % disabled_total)
	if failures > 0:
		print("FAIL grey_reason_test %d" % failures)
	else:
		print("PASS grey_reason_test")
	quit(1 if failures > 0 else 0)


func _run_until(until: Callable, close_reviews: bool = true) -> void:
	var c: Career = main.career
	for i in 40:
		if until.call():
			return
		for f in c.fighters:
			for o in f["offers"]:
				if not bool(o["answered"]) and not bool(o["mismatch"]):
					main.act("declineOffer", str(o["id"]))
			if Bouts.weigh_in_today(c, f):
				main.act("weighin", f["id"])
				main.act("doWeigh")
			if Bouts.fight_day(c, f):
				main.act("fightnight")
				main.act("fightstep", "sim")
				main.act("afterfight")
			if bool(f["goal_talk"]):
				main.act("goaltalk", f["id"])
				main.act("pickgoal", "five_round_engine")
				main.act("setgoal")
		if until.call():
			return
		if c.review_pending and close_reviews:
			main.act("review")
			main.act("close")
		main.run_to_stop()


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _check_moment(name: String) -> void:
	await _settle()
	for node in _walk_buttons(main):
		var b := node as BaseButton
		if not b.disabled:
			continue
		if not (node as CanvasItem).is_visible_in_tree():
			continue
		disabled_total += 1
		var reason := str(b.tooltip_text).strip_edges()
		var label := _button_label(b)
		print("%s | %s | %s" % [name, label, reason])
		if reason.length() < 12:
			failures += 1
		elif reason.to_lower().contains("not available"):
			failures += 1


func _walk_buttons(node: Node) -> Array:
	var out: Array = []
	if node is BaseButton:
		out.append(node)
	for child in node.get_children():
		out.append_array(_walk_buttons(child))
	return out


func _button_label(b: BaseButton) -> String:
	if b.text != "":
		return b.text
	if b.name != "" and b.name != "Button":
		return str(b.name)
	for child in b.get_children():
		var t := _labels_text(child)
		if t != "":
			return t
	return "(no text)"


func _labels_text(node: Node) -> String:
	if node is Label and (node as Label).text != "":
		return (node as Label).text
	for child in node.get_children():
		var t := _labels_text(child)
		if t != "":
			return t
	return ""
