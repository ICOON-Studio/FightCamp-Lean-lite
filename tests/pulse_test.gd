extends SceneTree
## Pulse (S442 owner: "slowly expand and shrink to draw players eyes"): breathe starts one looping scale tween, stop
## returns the scale to exactly 1, a disabled or hidden control never pulses, a second breathe does not stack tweens.
## Prints PULSE failures=N.

const Pulse := preload("res://scripts/ui/Pulse.gd")

var failures := 0


func _initialize() -> void:
	var b := Button.new()
	b.text = "Answer the offer"
	b.size = Vector2(240, 48)
	root.add_child(b)
	await process_frame
	Pulse.breathe(b)
	var first = b.get_meta(Pulse.TWEEN) if b.has_meta(Pulse.TWEEN) else null
	_check(Pulse.running(b), "breathe starts a tween")
	_check(first is Tween and (first as Tween).get_loops_left() < 0, "the tween loops for ever")
	await create_timer(0.4).timeout
	_check(b.scale.x > 1.0 and b.scale.x <= Pulse.PEAK + 0.001, "the button grows, never past %.2f (%.3f)" % [Pulse.PEAK, b.scale.x])
	_check(b.size == Vector2(240, 48), "scale only: the size never changes")
	_check(b.pivot_offset == b.size / 2.0, "it breathes about its centre")
	Pulse.breathe(b)
	_check(not (first as Tween).is_valid() and Pulse.running(b), "a second breathe replaces the first tween, never stacks")
	Pulse.stop(b)
	_check(b.scale == Vector2.ONE and not Pulse.running(b), "stop puts the scale back to exactly 1")
	for i in 5:
		await process_frame
	_check(b.scale == Vector2.ONE, "after stop it stays at 1")

	var off := Button.new()
	off.disabled = true
	root.add_child(off)
	await process_frame
	Pulse.breathe(off)
	_check(not Pulse.running(off), "a disabled button does not pulse")

	var hid := Button.new()
	hid.visible = false
	root.add_child(hid)
	await process_frame
	Pulse.breathe(hid)
	_check(not Pulse.running(hid), "a hidden button does not pulse")
	hid.visible = true
	await process_frame
	_check(Pulse.running(hid), "it starts once shown")
	hid.visible = false
	_check(not Pulse.running(hid) and hid.scale == Vector2.ONE, "hiding it stops it at 1")

	var later := Button.new()
	Pulse.breathe(later)
	_check(not Pulse.running(later), "out of the tree: nothing runs yet")
	root.add_child(later)
	await process_frame
	_check(Pulse.running(later), "it starts when it enters the tree")
	later.disabled = true
	await create_timer(1.9).timeout
	_check(not Pulse.running(later) and later.scale == Vector2.ONE, "disabled mid-pulse: it stops at the end of the breath")

	var pressed := Button.new()
	root.add_child(pressed)
	await process_frame
	Pulse.breathe(pressed)
	pressed.button_down.emit()
	pressed.mouse_exited.emit()
	_check(not Pulse.running(pressed) and pressed.scale == Vector2.ONE, "a press stops it for good")
	print("PULSE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
