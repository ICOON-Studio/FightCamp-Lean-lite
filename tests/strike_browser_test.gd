extends SceneTree
## S337 the boxing move map screen: it opens on Outside, a move out walks to its card and grows the route, a combo her punches
## cannot throw yet is greyed with its reason, and every card is on the map.

const Map := preload("res://scripts/rules/StrikeMap.gd")

var failures := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var s: Control = load("res://scenes/dev/StrikeBrowser.tscn").instantiate()
	root.add_child(s)
	await process_frame
	await process_frame
	_check(s.current == "outside", "opens on Outside")
	_check(s._map.get_child_count() == Map.CARDS.size(), "%d cards on the map" % s._map.get_child_count())
	s._take(Map.move("step_in"), true)
	_check(s.current == "long" and s.route.size() == 3, "Step in walks to Long range (route: %s)" % " > ".join(s.route))
	s.go("mid")
	var greyed: Array = s._side.find_children("*", "Button", true, false).filter(func(b): return (b as Button).disabled)
	var reasons: Array = greyed.map(func(b): return (b as Button).tooltip_text)
	print("  greyed at Mid range: ", reasons)
	_check(not greyed.is_empty() and reasons.all(func(r): return str(r).begins_with("Learn the")), "a combo she cannot throw yet says why")
	_check(reasons.any(func(r): return str(r).contains("Uppercut")), "Jab-uppercut-hook waits for the Uppercut (10 < 30)")
	print("FAIL %d" % failures if failures else "PASS strike_browser_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
