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
	var cards: Array = s._map.get_children().filter(func(c): return c is Button)   # S342: the key sits on the map too
	_check(cards.size() == Map.CARDS.size(), "%d cards on the map" % cards.size())
	s._take(Map.move("step_in"), true)
	_check(s.current == "long" and s.route.size() == 3, "Step in walks to Long range (route: %s)" % " > ".join(s.route))
	s.go("mid")
	var greyed: Array = s._side.find_children("*", "Button", true, false).filter(func(b): return (b as Button).disabled)
	var reasons: Array = greyed.map(func(b): return (b as Button).tooltip_text)
	print("  greyed at Mid range: ", reasons)
	_check(not greyed.is_empty() and reasons.all(func(r): return str(r).begins_with("Learn the")), "a combo she cannot throw yet says why")
	_check(reasons.any(func(r): return str(r).contains("Uppercut")), "Jab-uppercut-hook waits for the Uppercut (10 < 30)")
	# S341 the WHEN picker (fight flows step 2): her board holds one arrow per card and situation plus one any time.
	s.fighter = {"name": "Lucy Jackson", "first": "Lucy"}
	s.plan = []
	s._set_plan_mode(true)
	s.go("long")
	var picker: Array = s._side.find_children("*", "Button", true, false).filter(func(b): return (b as Button).theme_type_variation in ["Pill", "PillOn"])   # S342 pills
	_check(picker.size() == 9, "the WHEN picker: Any time + 8 of her games (%d)" % picker.size())
	s._take(Map.move("1-1"), true)
	s.go("long")
	s._take(Map.move("1-2"), true)
	_check(s.plan == [{"move": "1-2"}], "any time: a second move from long replaces the first (%s)" % str(s.plan))
	s.when = "tiring"
	s.go("long")
	s._take(Map.move("1-2-3"), true)
	s.go("long")
	s._take(Map.move("1-2-3-2"), true)
	_check(s.plan == [{"move": "1-2"}, {"move": "1-2-3-2", "when": "tiring"}], "if she tires: a branch beside it, replaced by the next tiring move (%s)" % str(s.plan))
	s.go("long")
	var rows: Array = s._side.find_children("*", "Label", true, false).filter(func(l): return str((l as Label).tooltip_text).begins_with("If she tires: "))   # S342 the row's tooltip
	_check(rows.size() == 1, "the plan list reads 'If she tires: One-two-hook-cross ...'")
	# S341 the real fight plans: listed, the one for her opponent's game first; Load merges it into her plan.
	s.fighter["bout"] = {"opp": {"first": "Maria", "style": "Pressure fighter"}}
	s.templates = true
	s.go("long")
	var loads: Array = s._side.find_children("*", "Button", true, false).filter(func(b): return str((b as Button).tooltip_text).begins_with("Load it: "))
	var first_label: Array = s._side.find_children("*", "TextureRect", true, false).filter(func(l): return str((l as Control).tooltip_text) == "Made for her next opponent's game.")
	_check(loads.size() == 8 and first_label.size() >= 1, "8 real fight plans listed; %d marked for Maria's game" % first_label.size())
	(loads[0] as Button).pressed.emit()
	_check(not s.templates and s.plan.size() == s._arrow_limit() and str(s.plan[0]["move"]) == "1-1", "Load: Leonard's plan first on her board (%s)" % str(s.plan))
	print("FAIL %d" % failures if failures else "PASS strike_browser_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
