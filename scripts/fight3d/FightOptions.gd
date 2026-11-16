extends Node
## S500 the fight's options (owner: "also add options for pause during the fight and camera selection"): two buttons above
## the right end of the fight bar and their keys. PAUSE (P) stops the whole fight where it is - bodies, clock, sound
## timers - and shows PAUSED; the same button or key carries on. CAMERA (C) steps through FixedCam.NAMES: Side (the fixed
## tripod, the default), High (the same tripod high above the ring), TV (the coverage that rides and cuts).
## The pause is the scene tree's own: this node and its buttons run while paused, and it lets go by itself the moment the
## round is no longer playing (a skip, the bell, leaving the fight), so no other screen is ever left frozen.
##   mount(bar, view)

const FixedCam := preload("res://scripts/fight3d/FixedCam.gd")

var view: Node
var _pause: Button
var _cam: Button
var _note: Label


static func mount(bar: Control, fight_view: Node) -> void:
	var o: Node = (load("res://scripts/fight3d/FightOptions.gd") as Script).new()
	o.name = "FightOptions"
	o.view = fight_view
	o.process_mode = Node.PROCESS_MODE_ALWAYS
	bar.add_child(o)
	o._pause = bar.call("_btn", "Pause (P)", "Pause", o.toggle_pause)
	o._cam = bar.call("_btn", "Camera: Side (C)", "Camera", o.next_camera)
	var x := -8.0
	for b: Button in [o._cam, o._pause]:
		var w := 250.0 if b == o._cam else 160.0
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
	note.add_theme_color_override("font_outline_color", Color.BLACK)
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


func toggle_pause() -> void:
	if not _playing() and not get_tree().paused:
		return
	get_tree().paused = not get_tree().paused
	draw()


func next_camera() -> void:
	var stage: Variant = view.get("stage") if is_instance_valid(view) else null
	var cam: Node = (stage as Node).get("camera") if stage is Node and is_instance_valid(stage) else null
	FixedCam.pick(FixedCam.mode + 1, cam)
	draw()


func draw() -> void:
	var paused := is_inside_tree() and get_tree().paused
	_pause.text = "Resume (P)" if paused else "Pause (P)"
	_cam.text = "Camera: %s (C)" % str(FixedCam.NAMES[FixedCam.mode])
	_note.visible = paused


func _process(_delta: float) -> void:
	if get_tree().paused and not _playing():
		get_tree().paused = false   # the round ended under the pause (a skip, leaving): nothing stays frozen
		draw()


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
	elif key == KEY_C and _playing():
		next_camera()
		get_viewport().set_input_as_handled()
