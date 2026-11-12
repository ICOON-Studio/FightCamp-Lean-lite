extends SceneTree
## Tally (S442 owner, animated numbers): a changed value rolls to its target, a first sight is set at once, a second call
## retargets without stacking, skip_all jumps to the end, a bar slides the same way. Prints TALLY failures=N.

const Tally := preload("res://scripts/ui/Tally.gd")
const Bar := preload("res://scripts/ui/Bar.gd")

var failures := 0


func _initialize() -> void:
	Tally.instant = false
	Tally.last.clear()
	var fmt := func(n: int) -> String: return "$%d" % n
	var l := Label.new()
	root.add_child(l)
	await process_frame
	Tally.number(l, "t:cash", 100, fmt)
	_check(l.text == "$100" and not Tally.running("t:cash"), "first sight: set at once, no roll (%s)" % l.text)
	Tally.number(l, "t:cash", 100, fmt)
	_check(not Tally.running("t:cash"), "same value: nothing moves")
	Tally.number(l, "t:cash", 500, fmt)
	_check(Tally.running("t:cash") and l.text == "$100", "a change starts from the old value (%s)" % l.text)
	await create_timer(0.2).timeout
	var mid := int(l.text.substr(1))
	_check(mid > 100 and mid < 500, "it rolls through the values (%s)" % l.text)
	await create_timer(0.5).timeout
	_check(l.text == "$500" and not Tally.running("t:cash"), "it reaches the target and stops (%s)" % l.text)
	_check(l.modulate == Color.WHITE, "the tint is gone at the end")

	# A rebuilt screen: a NEW label for the same key carries on from what the player saw.
	var l2 := Label.new()
	Tally.number(l2, "t:cash", 300, fmt)
	root.add_child(l2)
	await process_frame
	_check(Tally.running("t:cash") and l2.text != "$300", "a rebuilt label rolls from the last value (%s)" % l2.text)
	# Retarget mid-roll: one roll, ends on the new target.
	Tally.number(l2, "t:cash", 900, fmt)
	await create_timer(0.7).timeout
	_check(l2.text == "$900" and not Tally.running("t:cash"), "a second call retargets without stacking (%s)" % l2.text)

	Tally.number(l2, "t:cash", 50, fmt)
	await process_frame
	Tally.skip_all()
	_check(l2.text == "$50" and not Tally.running("t:cash") and l2.modulate == Color.WHITE, "skip jumps to the end (%s)" % l2.text)

	Tally.number(l2, "t:cash", 70, fmt)
	await process_frame
	await process_frame
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	root.push_input(click)
	await process_frame
	_check(l2.text == "$70" and not Tally.running("t:cash"), "a click skips the roll (%s)" % l2.text)

	var b: Control = Bar.new()
	root.add_child(b)
	await process_frame
	Tally.bar(b, "t:bar", 0.2)
	_check(is_equal_approx(float(b.get("frac")), 0.2), "bar first sight: set at once")
	Tally.bar(b, "t:bar", 0.8)
	await create_timer(0.2).timeout
	var f := float(b.get("frac"))
	_check(f > 0.2 and f < 0.8, "the bar slides (%.2f)" % f)
	await create_timer(0.5).timeout
	_check(is_equal_approx(float(b.get("frac")), 0.8), "the bar reaches its value")

	l.queue_free()
	Tally.number(l2, "t:gone", 1, fmt)
	Tally.number(l2, "t:gone", 2, fmt)
	l2.free()
	Tally.skip_all()
	_check(true, "skip with a freed label does not crash")
	print("TALLY failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
