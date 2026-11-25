extends "res://tools/pics2d_anim_more.gd"
## CAMPICK1 (S559, ops/research/TASK_CAMPICK1.md). The owner on the Ring Switches pictures: "can you make a tool for me to
## open the 2 fighters in the guard position on our 3d engine and i will take a picture of the best angle i can find".
## The picture tools' own stage, bodies, toon look and orthographic camera (pics2d_set.gd, the holds from
## pics2d_anim_more.gd); the window shows the picture square exactly as it is saved. He turns the camera and saves:
## tools/pics2d_camera.json (read by pics2d_set.gd as its camera from then on) + ops/previews/campick/campick_<n>.png.
##   double-click tools/camera_pick.cmd   (windowed on purpose: he asked for it)
##   test: ... --script res://tools/camera_pick.gd -- user://campick art=toon auto=1 pitch=12 yaw=20   (sets, saves once, quits)

const SAVE_DIR := "res://ops/previews/campick"
const RANGES := [["Long", ""], ["Mid", "_r2"], ["Inside", "_r1"]]
## [name, hold take ("" = the guard), s into the take]: the guard is the hold take's first picture (S554)
const POSES := [["guard", "", 0.0], ["both high", "both_high_high", 0.50], ["lead low + rear high", "both_low_high", 0.50],
	["both low", "both_low_low", 0.50]]
const TURN_DEG_PX := 0.25
const ZOOM_STEP := 1.06

class Catcher extends Node:
	var tool: Object
	func _input(e: InputEvent) -> void:
		tool.call("_on_input", e)

var rng := 0
var pose := 0
var busy := false
var dirty := false
var drag := -1
var label: Label
var note: Label
var view: TextureRect


## The pictures' boxers by default (set=m, south=blue: both men show the camera their chest, S553).
func _arg(key: String, def: String) -> String:
	return super._arg(key, str({"set": "m", "south": "blue"}.get(key, def)))


func _run() -> void:
	for i in 2:
		for p in POSES:
			if str(p[1]) != "":
				_add_hold(i, "hold_" + str(p[1]))
	_ui()
	await _repose()
	if _arg("auto", "") == "1":
		var ok: bool = await _save_pick()
		quit(0 if ok else 1)


func _ui() -> void:
	DisplayServer.window_set_title("FightCamp - camera pick")
	var bg := ColorRect.new()
	bg.color = Color(0.17, 0.18, 0.2)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(bg)
	view = TextureRect.new()
	view.texture = sv.get_texture()
	view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	view.set_anchors_preset(Control.PRESET_FULL_RECT)
	view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(view)
	label = _label(Vector2(16, 12), 17)
	note = _label(Vector2(16, 860), 22)
	note.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	var c := Catcher.new()
	c.tool = self
	root.add_child(c)


func _label(at: Vector2, px: int) -> Label:
	var l := Label.new()
	l.position = at
	l.add_theme_font_size_override("font_size", px)
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	l.add_theme_constant_override("outline_size", 4)
	root.add_child(l)
	return l


func _on_input(e: InputEvent) -> void:
	if e is InputEventMouseButton:
		var b := e as InputEventMouseButton
		if b.pressed and b.button_index == MOUSE_BUTTON_WHEEL_UP:
			camv["size"] = clampf(float(camv["size"]) / ZOOM_STEP, 0.8, 8.0)
		elif b.pressed and b.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camv["size"] = clampf(float(camv["size"]) * ZOOM_STEP, 0.8, 8.0)
		elif b.button_index == MOUSE_BUTTON_LEFT or b.button_index == MOUSE_BUTTON_RIGHT:
			drag = b.button_index if b.pressed else -1
	elif e is InputEventMouseMotion and drag != -1:
		var d := (e as InputEventMouseMotion).relative
		if drag == MOUSE_BUTTON_LEFT:
			yaw_deg += d.x * TURN_DEG_PX
			camv["pitch"] = clampf(float(camv["pitch"]) + d.y * TURN_DEG_PX, -CamPick.PITCH_MAX, CamPick.PITCH_MAX)
		else:   # grab the picture: it follows the mouse
			var m_px := float(camv["size"]) / maxf(1.0, minf(view.size.x, view.size.y))
			camv["look_shift"] = float(camv["look_shift"]) - d.x * m_px
			camv["look_y"] = float(camv["look_y"]) + d.y * m_px
	elif e is InputEventKey and (e as InputEventKey).pressed and not (e as InputEventKey).echo:
		var k := (e as InputEventKey).keycode
		if k == KEY_1 or k == KEY_2 or k == KEY_3:
			rng = int(k - KEY_1)
			_repose()
		elif k == KEY_H:
			pose = (pose + 1) % POSES.size()
			_repose()
		elif k == KEY_R:
			camv = CamPick.DEFAULTS.duplicate()
			yaw_deg = 0.0
		elif k == KEY_ENTER or k == KEY_KP_ENTER or k == KEY_S:
			_save_pick()
		elif k == KEY_ESCAPE:
			quit(0)
	if e is InputEventKey and (e as InputEventKey).pressed:   # the arrows repeat while held
		var step: Array = {KEY_UP: [0.0, 0.02], KEY_DOWN: [0.0, -0.02], KEY_LEFT: [-0.02, 0.0], KEY_RIGHT: [0.02, 0.0]}.get((e as InputEventKey).keycode, [])
		if not step.is_empty():
			camv["look_shift"] = float(camv["look_shift"]) + float(step[0])
			camv["look_y"] = float(camv["look_y"]) + float(step[1])
	_apply()


## Both men at the range, in the hold (or the guard), stopped.
func _repose() -> void:
	if busy:
		dirty = true
		return
	busy = true
	dirty = true
	while dirty:
		dirty = false
		note.text = "posing..."
		await _home_guard(float(RANGE_IN[RANGES[rng][1]]), 0)
		var p: Array = POSES[pose]
		var clip := "hold_" + (str(p[1]) if str(p[1]) != "" else "both_high_high")
		for i in 2:
			if (stage.boxers[i]["ap"] as AnimationPlayer).has_animation(clip):
				stage.v2._play(i, clip, 0.0, "block", false)
		var t := 0.0
		while t < float(p[2]) - EPS:
			await process_frame
			t += 1.0 / 60.0
		_freeze(0)
		_freeze(1)
		for f in 3:
			await process_frame
		note.text = ""
		_apply()
	busy = false


func _apply() -> void:
	camv["yaw"] = yaw_deg
	_aim([0, 1])
	label.text = "CAMERA PICK    pitch %.1f    yaw %.1f    zoom %.2f m    look height %.2f m    shift %.2f m\nRange: %s    Hands: %s\n\nLeft drag: turn the camera    Wheel: zoom    Right drag or arrows: move the view\n1 / 2 / 3: Long / Mid / Inside    H: hands    R: reset    Enter or S: save    Esc: close" % [
		float(camv["pitch"]), yaw_deg, float(camv["size"]), float(camv["look_y"]), float(camv["look_shift"]), RANGES[rng][0], POSES[pose][0]]


## tools/pics2d_camera.json + the picture as the picture tool frames it. False when a man is cut by the frame.
func _save_pick() -> bool:
	_apply()
	var d := {"saved_at": Time.get_datetime_string_from_system()}
	for k in CamPick.DEFAULTS:
		d[k] = snappedf(float(camv[k]), 0.001)
	var fh := FileAccess.open(ProjectSettings.globalize_path(CamPick.PATH), FileAccess.WRITE)
	fh.store_string(JSON.stringify(d, "  "))
	fh.close()
	var dir := ProjectSettings.globalize_path(SAVE_DIR)
	DirAccess.make_dir_recursive_absolute(dir)
	var n := 1
	while FileAccess.file_exists(dir.path_join("campick_%d.png" % n)):
		n += 1
	for f in 3:
		await process_frame
	await RenderingServer.frame_post_draw
	sv.get_texture().get_image().save_png(dir.path_join("campick_%d.png" % n))
	var bad := Gate.framed(stage, cam, [0, 1], SIZE)
	note.text = "SAVED  campick_%d.png  (this camera is now the pictures' camera)" % n + ("" if bad.is_empty() else "   - but a man is cut: " + "; ".join(PackedStringArray(bad)))
	print("CAMPICK SAVED %s %s framed=%s" % [dir.path_join("campick_%d.png" % n), JSON.stringify(d), "ok" if bad.is_empty() else "; ".join(PackedStringArray(bad))])
	return bad.is_empty()
