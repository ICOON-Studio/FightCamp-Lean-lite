extends SceneTree
## FIGHT_OPTIONS (S500, owner: "also add options for pause during the fight and camera selection"): the Pause button
## freezes the tree only while a round plays and lets go by itself when the round ends; the Camera button steps through
## Side / High / TV. A stand-in bar and view (no 3D): the buttons, their words and the pause are what is read.

const FightOptions := preload("res://scripts/fight3d/FightOptions.gd")
const FixedCam := preload("res://scripts/fight3d/FixedCam.gd")

var failures := 0


class FakeView extends Node:
	var playing := true
	var stage: Node = null
	var replay: Node = null


class FakeReplay extends Node:
	var on := false
	var skipped := 0
	func active() -> bool:
		return on
	func skip() -> void:
		skipped += 1
		on = false


class FakeBar extends Control:
	func _btn(text: String, named: String, on_press: Callable) -> Button:
		var b := Button.new()
		b.name = named
		b.text = text
		b.pressed.connect(on_press)
		return b


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _initialize() -> void:
	var view := FakeView.new()
	var bar := FakeBar.new()
	root.add_child(view)
	root.add_child(bar)
	FixedCam.pick(0, null)
	FightOptions.mount(bar, view)
	await process_frame   # nodes added in _initialize are in the tree from the first frame
	var o: Node = bar.get_node("FightOptions")
	var pause: Button = bar.get_node("Pause")
	var cam: Button = bar.get_node("Camera")
	var note: Label = bar.get_node("PausedNote")
	_check(pause.text == "Pause (P)" and cam.text == "Camera: Side (C)" and not note.visible, "the two buttons say what they do and their keys")
	pause.pressed.emit()
	_check(paused and pause.text == "Resume (P)" and note.visible, "Pause freezes the fight and shows PAUSED")
	_check(pause.process_mode == Node.PROCESS_MODE_ALWAYS and o.process_mode == Node.PROCESS_MODE_ALWAYS, "the buttons still work while paused")
	pause.pressed.emit()
	_check(not paused and pause.text == "Pause (P)" and not note.visible, "the same button carries on")
	pause.pressed.emit()
	view.playing = false
	await process_frame
	await process_frame
	_check(not paused, "a round that ends under the pause is let go: no other screen stays frozen")
	pause.pressed.emit()
	_check(not paused, "Pause does nothing when no round is playing")
	view.playing = true
	cam.pressed.emit()
	_check(FixedCam.mode == 1 and FixedCam.on and cam.text == "Camera: High (C)", "Camera steps to High")
	cam.pressed.emit()
	_check(FixedCam.mode == 2 and not FixedCam.on and cam.text == "Camera: TV (C)", "then to TV (the coverage that cuts)")
	cam.pressed.emit()
	_check(FixedCam.mode == 0 and FixedCam.on and cam.text == "Camera: Side (C)", "then back to Side")
	# S531 TOPDOWN1: Top-down lays the round from above over the 3D; the same button goes back.
	var top: Button = bar.get_node("TopDown")
	var map: Control = bar.get_node("RingTopDown")
	_check(top.text == "Top-down (T)" and not map.visible, "Top-down starts off, the button says so")
	top.pressed.emit()
	_check(map.visible and top.text == "3D view (T)", "Top-down shows the ring from above")
	top.pressed.emit()
	_check(not map.visible and top.text == "Top-down (T)", "and the same button goes back to the 3D")
	# S501 zoom + / - and Skip replay (owner: "Yes, do all three")
	var zin: Button = bar.get_node("ZoomIn")
	var zout: Button = bar.get_node("ZoomOut")
	var z0: float = FixedCam.zoom
	zin.pressed.emit()
	_check(FixedCam.zoom < z0 and zin.visible and zout.visible, "+ zooms in on the Side camera (%.2f -> %.2f)" % [z0, FixedCam.zoom])
	for k in 20:
		zin.pressed.emit()
	_check(is_equal_approx(FixedCam.zoom, FixedCam.ZOOM.x) and zin.disabled, "zoom in stops at its closest and + greys out")
	for k in 20:
		zout.pressed.emit()
	_check(is_equal_approx(FixedCam.zoom, FixedCam.ZOOM.y) and zout.disabled, "zoom out stops at its widest and - greys out")
	FixedCam.zoom = 1.0
	_check(FixedCam.fov_for(4.6, 0.8, 16.0 / 9.0) > 20.0 and FixedCam.fov_for(4.6, 0.8, 16.0 / 9.0) < 45.0, "the Side lens frames the pair mid-ring at a normal angle")
	var skip: Button = bar.get_node("SkipReplay")
	_check(not skip.visible, "no Skip replay button outside a replay")
	var rp := FakeReplay.new()
	root.add_child(rp)
	view.replay = rp
	rp.on = true
	paused = true   # a replay holds the tree itself
	await process_frame
	_check(skip.visible and not note.visible, "during a replay: Skip replay shows, PAUSED does not")
	skip.pressed.emit()
	_check(rp.skipped == 1, "Skip replay ends it")
	paused = false
	view.replay = null
	rp.queue_free()
	await process_frame
	pause.pressed.emit()
	bar.queue_free()
	await process_frame
	await process_frame
	_check(not paused, "leaving the fight while paused lets go")
	print("FIGHT_OPTIONS failures=%d" % failures)
	quit(1 if failures > 0 else 0)
