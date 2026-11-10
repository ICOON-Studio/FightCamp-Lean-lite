extends SceneTree
## The word over each head. Every sit uses the mode's label. Off screen and behind the lens hide it.
## A head that lands under a panel is clamped into the open middle. Moving the head moves the chip.

const IntentChip := preload("res://scripts/fight3d/IntentChip.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

var failures := 0


func _initialize() -> void:
	_words()
	await _follow()
	print("INTENT_CHIP failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _words() -> void:
	for sit in Exchanges.MODES.keys():
		var want := str((Exchanges.MODES[sit] as Dictionary)["label"])
		_check(IntentChip.opp_words(str(sit)) == want, "sit %s reads %s" % [sit, want])
	_check(IntentChip.opp_words("") == "", "no sit, no word")
	_check(IntentChip.own_words(true, 90.0, "long") == "Hurt", "hurt wins over the call")
	_check(IntentChip.own_words(false, 10.0, "long") == "Tired", "the energy line says Tired")
	_check(IntentChip.own_words(false, 80.0, "long") == "Jab and move", "the call in force keeps its label")
	_check(IntentChip.own_words(false, 80.0, "") == "", "nothing to say stays blank")
	_check(not IntentChip.shown(false, "Pressing", true), "hidden while the scorebug is down")
	_check(IntentChip.shown(true, "Pressing", true), "shown with the scorebug, a word, and the head on screen")
	_check(not IntentChip.shown(true, "Pressing", false), "hidden when the head is off screen")
	_check(not IntentChip.shown(true, "", true), "hidden when there is nothing to say")


func _follow() -> void:
	root.size = Vector2i(1920, 1080)
	var cam := Camera3D.new()
	cam.position = Vector3(0, 1.6, 4.0)
	cam.current = true
	root.add_child(cam)
	await process_frame
	var view := Vector2(1920, 1080)
	var open_l := 384.0
	var open_r := 1536.0
	var chip := IntentChip.new()
	chip.name = "IntentChip0"
	chip.side = 0
	root.add_child(chip)
	await process_frame
	chip.place(cam, Vector3(-0.25, 1.7, 0.0), open_l, open_r, view, true, "Pressing")
	var x0 := chip.position.x
	_check(chip.visible, "a head in frame shows the chip (%s)" % chip.position)
	chip.place(cam, Vector3(0.55, 1.7, 0.0), open_l, open_r, view, true, "Pressing")
	var x1 := chip.position.x
	_check(chip.visible and absf(x1 - x0) > 5.0, "the chip follows a moved head (%.0f -> %.0f)" % [x0, x1])
	var under := Vector3.ZERO
	var found := false
	for i in 24:
		var world := Vector3(-0.2 * float(i), 1.7, 0.0)
		var hit: Dictionary = IntentChip.screen_of(cam, world, view)
		if bool(hit.get("ok", false)) and float((hit["pos"] as Vector2).x) < open_l:
			under = world
			found = true
			break
	_check(found, "a head can sit on screen under the left panel")
	if found:
		chip.place(cam, under, open_l, open_r, view, true, "Pressing")
		_check(chip.visible and chip.position.x >= open_l - 0.5 and chip.position.x + chip.size.x <= open_r + 0.5,
			"clamped between the panels (%s size %s)" % [chip.position, chip.size])
	chip.place(cam, Vector3(0, 1.7, 8.0), open_l, open_r, view, true, "Pressing")
	_check(not chip.visible, "hidden when the head is behind the lens")
	chip.place(cam, Vector3(40, 1.7, 0.0), open_l, open_r, view, true, "Pressing")
	_check(not chip.visible, "hidden when the head is off screen")
	chip.place(cam, Vector3(0, 1.7, 0.0), open_l, open_r, view, false, "Pressing")
	_check(not chip.visible, "hidden when the scorebug is down")
	chip.place(cam, Vector3(0, 1.7, 0.0), open_l, open_r, view, true, "Hurt")
	_check(chip.find_child("Halo", true, false) != null, "a state that just changed gets a halo")
	var word := chip.find_child("ChipWord", true, false) as Label
	_check(word != null and word.get_theme_font_size("font_size") >= 20, "the word is at least 20 px")
	chip._process(1.1)
	await process_frame
	_check(chip.find_child("Halo", true, false) == null, "the halo is gone after 1 s")
	_check(chip.mouse_filter == Control.MOUSE_FILTER_IGNORE, "the chip does not take a click")


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
