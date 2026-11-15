extends SceneTree
## The status word per boxer. Every sit uses the mode's label. Off screen and behind the lens hide it.
## S491 ("remove that from his face"): the chip sits in its lane under the boxer's plate and never follows the head.

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
	var p0 := chip.position
	_check(chip.visible, "a head in frame shows the chip (%s)" % chip.position)
	var head: Dictionary = IntentChip.screen_of(cam, Vector3(-0.25, 1.7, 0.0), view)
	var face := Rect2((head["pos"] as Vector2) - Vector2(80, 60), Vector2(160, 180))
	_check(not Rect2(chip.position, chip.size).intersects(face), "the chip is off the face (%s vs %s)" % [chip.position, face])
	_check(chip.position.y >= 200.0 and chip.position.y + chip.size.y <= 350.0, "under the plate, above the body maps (%s)" % chip.position)
	chip.place(cam, Vector3(0.55, 1.7, 0.0), open_l, open_r, view, true, "Pressing")
	_check(chip.visible and chip.position == p0, "a moved head does not move the chip (%s -> %s)" % [p0, chip.position])
	var opp := IntentChip.new()
	opp.side = 1
	root.add_child(opp)
	await process_frame
	opp.place(cam, Vector3(0.25, 1.7, 0.0), open_l, open_r, view, true, "Pressing")
	_check(opp.visible and absf(opp.position.x + opp.size.x - 1900.0) < 0.5, "the opponent's chip ends at the right edge (%s)" % opp.position)
	opp.queue_free()
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
