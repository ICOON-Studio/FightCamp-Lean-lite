extends Node
## S500 the fight's options (owner: "also add options for pause during the fight and camera selection"): two buttons above
## the right end of the fight bar and their keys. PAUSE (P) stops the whole fight where it is - bodies, clock, sound
## timers - and shows PAUSED; the same button or key carries on. CAMERA (C) steps through FixedCam.NAMES: Side (the fixed
## tripod, the default), High (the same tripod high above the ring), TV (the coverage that rides and cuts).
## The pause is the scene tree's own: this node and its buttons run while paused, and it lets go by itself the moment the
## round is no longer playing (a skip, the bell, leaving the fight), so no other screen is ever left frozen.
## S501 (owner: "Yes, do all three", after the Boxing Manager / UFC camera study): ZOOM - and + beside them (keys - and =,
## the mouse wheel) step FixedCam.zoom on the Side and High cameras; SKIP REPLAY (Space) shows only while a knockdown's
## slow-motion replay plays (KnockdownReplay.skip). The replay freezes the tree too: PAUSED shows only for the player's pause.
## S531 TOPDOWN1 (owner: "yes build it", after the Pound for Pound read): TOP-DOWN (T) lays the round seen from above
## over the 3D - RingTopDown, fed the exchanges that are over (CornerBar._ex_over) and the energy (LiveRound.state); the
## same button or key goes back to the 3D. The round plays on underneath either way.
##   mount(bar, view)

const FixedCam := preload("res://scripts/fight3d/FixedCam.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const RingTopDown := preload("res://scripts/ui/RingTopDown.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

var view: Node
var _pause: Button
var _cam: Button
var _note: Label
var _zin: Button
var _zout: Button
var _skip: Button
var _top: Button
var _plan: Button   # S533 the corner's eye: plan lines on the top-down view, or the clean view
var _map: Control
var _shown := -1
var _mine := false   # the tree is paused by the player's Pause (not by a replay)


static func mount(bar: Control, fight_view: Node) -> void:
	var o: Node = (load("res://scripts/fight3d/FightOptions.gd") as Script).new()
	o.name = "FightOptions"
	o.view = fight_view
	o.process_mode = Node.PROCESS_MODE_ALWAYS
	bar.add_child(o)
	o._pause = bar.call("_btn", "Pause (P)", "Pause", o.toggle_pause)
	o._cam = bar.call("_btn", "Camera: Side (C)", "Camera", o.next_camera)
	o._zin = bar.call("_btn", "+", "ZoomIn", func(): o.zoom(1))
	o._zout = bar.call("_btn", "-", "ZoomOut", func(): o.zoom(-1))
	o._skip = bar.call("_btn", "Skip replay (Space)", "SkipReplay", o.skip_replay)
	o._top = bar.call("_btn", "Top-down (T)", "TopDown", o.toggle_top)
	o._plan = bar.call("_btn", "Plan lines: on (V)", "PlanLines", o.toggle_plan)
	var map: Control = RingTopDown.make([], {}, Exchanges.EXCHANGES)
	map.backdrop = true
	map.ring_px = 600.0
	map.visible = false
	map.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map.anchor_left = 0.0
	map.anchor_right = 1.0
	map.offset_left = 440.0
	map.offset_right = -440.0
	map.offset_top = -730.0
	map.offset_bottom = -56.0
	bar.add_child(map)
	o._map = map
	var x := -8.0
	for b: Button in [o._zin, o._zout, o._cam, o._top, o._plan, o._pause, o._skip]:
		var w := 250.0 if b == o._cam else (56.0 if b == o._zin or b == o._zout else (260.0 if b == o._skip else (190.0 if b == o._top else (230.0 if b == o._plan else 160.0))))
		bar.add_child(b)
		b.process_mode = Node.PROCESS_MODE_ALWAYS
		b.anchor_left = 1.0
		b.anchor_right = 1.0
		b.offset_right = x
		b.offset_left = x - w
		b.offset_top = -44.0
		b.offset_bottom = -6.0
		x -= w + 8.0
	var note := Label.new()
	note.name = "PausedNote"
	note.text = "PAUSED"
	note.visible = false
	note.add_theme_font_size_override("font_size", 44)
	note.add_theme_color_override("font_outline_color", Palette.PAGE)
	note.add_theme_constant_override("outline_size", 10)
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.anchor_left = 0.0
	note.anchor_right = 1.0
	note.offset_top = -520.0
	note.offset_bottom = -460.0
	note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_child(note)
	o._note = note
	o.draw()


func _playing() -> bool:
	return is_instance_valid(view) and bool(view.get("playing"))


func _replay() -> Node:
	var r: Variant = view.get("replay") if is_instance_valid(view) else null
	return r as Node if r is Node and is_instance_valid(r) else null


func _replaying() -> bool:
	var r := _replay()
	return r != null and bool(r.call("active"))


func toggle_pause() -> void:
	if _replaying():
		return   # the replay holds the tree itself; Skip replay ends it
	if not _playing() and not get_tree().paused:
		return
	get_tree().paused = not get_tree().paused
	_mine = get_tree().paused
	draw()


func zoom(steps: int) -> void:
	FixedCam.zoom_by(steps)
	draw()


func skip_replay() -> void:
	var r := _replay()
	if r != null:
		r.call("skip")
	draw()


func toggle_top() -> void:
	_map.visible = not _map.visible
	_shown = -1
	_refresh_top()
	draw()


## S533: Show plan / Clean view on the top-down map. It hides or shows drawn lines only; nothing in the bout reads it.
func toggle_plan() -> void:
	_map.set("show_plan", not bool(_map.get("show_plan")))
	_map.queue_redraw()
	draw()


func _refresh_top() -> void:
	if not _map.visible:
		return
	var bar := get_parent()
	var exs: Array = bar.call("_ex_over") if bar != null and bar.has_method("_ex_over") else []
	if exs.size() == _shown:
		return
	_shown = exs.size()
	var main: Node = view.get("main") if is_instance_valid(view) else null
	var m: Variant = main.get("modal") if main != null else null
	var lv: Dictionary = (m as Dictionary).get("live", {}) if m is Dictionary else {}
	var st: Dictionary = LiveRound.state(lv, exs.size()) if not lv.is_empty() else {}
	if not lv.is_empty():   # S533 the next opening's plan line (faint) and the settled rounds (ghosts): read only
		st["next"] = {"at": str(lv.get("at", "")), "want": str(lv.get("next_want", ""))} if exs.size() < Exchanges.EXCHANGES else {}
		st["past"] = (m as Dictionary).get("rounds", [])
	_map.call("set_round", exs, st)


func next_camera() -> void:
	var stage: Variant = view.get("stage") if is_instance_valid(view) else null
	var cam: Node = (stage as Node).get("camera") if stage is Node and is_instance_valid(stage) else null
	FixedCam.pick(FixedCam.mode + 1, cam)
	draw()


func draw() -> void:
	var paused := is_inside_tree() and get_tree().paused
	_pause.text = "Resume (P)" if paused else "Pause (P)"
	_cam.text = "Camera: %s (C)" % str(FixedCam.NAMES[FixedCam.mode])
	_note.visible = paused and _mine and not _replaying()
	var zoomable := FixedCam.on
	_zin.visible = zoomable
	_zout.visible = zoomable
	_zin.disabled = FixedCam.zoom <= FixedCam.ZOOM.x + 1e-3
	_zout.disabled = FixedCam.zoom >= FixedCam.ZOOM.y - 1e-3
	_skip.visible = _replaying()
	_top.text = "3D view (T)" if _map.visible else "Top-down (T)"
	_plan.visible = _map.visible
	_plan.text = "Plan lines: on (V)" if bool(_map.get("show_plan")) else "Clean view (V)"


func _process(_delta: float) -> void:
	if get_tree().paused and not _playing() and not _replaying():
		get_tree().paused = false   # the round ended under the pause (a skip, leaving): nothing stays frozen
		_mine = false
		draw()
	elif _skip.visible != _replaying():
		draw()   # a replay began or ended
	_refresh_top()


func _exit_tree() -> void:
	if get_tree() != null and get_tree().paused:
		get_tree().paused = false


func _unhandled_key_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.pressed or (event as InputEventKey).echo:
		return
	var key := (event as InputEventKey).keycode
	if key == KEY_P and (_playing() or get_tree().paused):
		toggle_pause()
		get_viewport().set_input_as_handled()
	elif key == KEY_T and _playing():
		toggle_top()
		get_viewport().set_input_as_handled()
	elif key == KEY_V and _playing() and _map.visible:
		toggle_plan()
		get_viewport().set_input_as_handled()
	elif key == KEY_C and _playing():
		next_camera()
		get_viewport().set_input_as_handled()
	elif key == KEY_SPACE and _replaying():
		skip_replay()
		get_viewport().set_input_as_handled()
	elif (key == KEY_EQUAL or key == KEY_PLUS or key == KEY_KP_ADD) and _playing() and FixedCam.on:
		zoom(1)
		get_viewport().set_input_as_handled()
	elif (key == KEY_MINUS or key == KEY_KP_SUBTRACT) and _playing() and FixedCam.on:
		zoom(-1)
		get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton
	if mb == null or not mb.pressed or not _playing() or not FixedCam.on:
		return
	if mb.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom(1)
		get_viewport().set_input_as_handled()
	elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom(-1)
		get_viewport().set_input_as_handled()
