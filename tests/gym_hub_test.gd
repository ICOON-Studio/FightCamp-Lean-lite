extends SceneTree
## S408 the gym is the menu: Home shows the painted club, every place is there and each click goes where its name says.

const MAIN := preload("res://scenes/Main.tscn")

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
	_check(hub != null and hub.find_child("GymLayout", true, false) != null, "the player can change the layout")
	await _click(main, "fights", "fights", 0)
	await _click(main, "office", "gym", 1)
	await _click(main, "world", "world", 1)
	await _click(main, "training", "fighters", 0)
	print("GYM_HUB failures=%d" % failures)
	quit(1 if failures > 0 else 0)


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
