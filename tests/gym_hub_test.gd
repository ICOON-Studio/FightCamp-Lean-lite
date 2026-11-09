extends SceneTree
## S408 the gym is the menu: Home shows the painted club, every place is there and each click goes where its name says.

const MAIN := preload("res://scenes/Main.tscn")
const GymPlan := preload("res://scripts/rules/GymPlan.gd")

var failures := 0


func _initialize() -> void:
	var main := MAIN.instantiate()
	root.add_child(main)
	await process_frame
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	main.act("quick")
	await process_frame
	await process_frame
	var hub := main.find_child("GymHub", true, false) as Control
	_check(hub != null, "Home shows the gym")
	if hub != null:
		_check(hub.size.x > 800.0, "the gym fills the page (%.0f wide)" % hub.size.x)
		for id in ["reception", "training", "playbook", "fights", "office", "world"]:
			var s := hub.find_child("Place_" + id, true, false) as Button
			_check(s != null, "the gym has " + id)
			if s != null:
				_check(s.position.x >= 0.0 and s.position.x + s.size.x <= hub.size.x + 1.0 and s.size.y > 40.0, "%s is on the painting (%s, %s)" % [id, s.position, s.size])
	if hub != null:
		_check(hub.size.y >= 1080.0 - 101.0, "the gym takes the whole window under the top bar (%.0f tall)" % hub.size.y)
		var iso := hub.find_child("IsoGym", true, false)
		_check(float(iso._scale) >= 1.2, "the gym is drawn big (scale %.2f)" % float(iso._scale))
		for corner in ["CornerTopLeft", "CornerTopRight", "CornerBottomRight"]:
			var box := hub.find_child(corner, true, false) as Control
			_check(box != null and hub.get_global_rect().encloses(box.get_global_rect()), "%s is inside the window" % corner)
			for id in ["reception", "training", "playbook", "fights", "office", "world"]:
				var pin := hub.find_child("Place_" + id, true, false) as Control
				_check(box != null and pin != null and not box.get_global_rect().intersects(pin.get_global_rect()), "%s does not cover %s" % [corner, id])
	_check(hub != null and hub.find_child("GymLayout", true, false) == null, "the building is chosen at setup, not swapped for free on Home")
	_figures(hub)
	await _click(main, "fights", "fights", 0)
	await _click(main, "office", "gym", 1)
	await _click(main, "world", "world", 1)
	await _click(main, "training", "fighters", 0)
	print("GYM_HUB failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## People stand in the gym, and in a minute of walking about they keep to the floor.
func _figures(hub: Control) -> void:
	var f := hub.find_child("HubFigures", true, false)
	_check(f != null and f.people.size() >= 2, "there are people in the gym (%d)" % (f.people.size() if f != null else 0))
	if f == null:
		return
	var plan: Dictionary = f._plan
	var blocked: Dictionary = GymPlan.taken(plan)
	var walked := 0
	for _i in 1800:
		f.step(1.0 / 30.0)
		for p in f.people:
			walked += 1 if bool(p["walking"]) else 0
			var t: Vector2 = p["tile"]
			_check(not blocked.has(Vector2i(int(round(t.x)), int(round(t.y)))), "nobody walks through equipment (%s)" % t)
	_check(walked > 0, "people walk about")


func _click(main: Node, id: String, area: String, tab: int) -> void:
	main.nav({"area": "home", "tab": 0})
	await process_frame
	var s := main.find_child("Place_" + id, true, false) as Button
	_check(s != null, "back home the gym has " + id)
	if s == null:
		return
	s.pressed.emit()
	await process_frame
	_check(str(main.route["area"]) == area and int(main.route["tab"]) == tab, "%s goes to %s tab %d (went to %s tab %d)" % [id, area, tab, main.route["area"], main.route["tab"]])


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
