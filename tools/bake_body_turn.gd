extends "res://tools/bake_body_portraits.gd"
## S334 (operator C153 on the fight's body view: "still needs to be bigger maybe slightly autorotating"): bakes each boxer
## turning from -SWING to +SWING degrees in STEP steps (camera and key light orbit her, as if she turned on a turntable),
## the frames side by side in one strip per corner plus a part-mask strip, and her places + track per frame. BodyFigure
## cross-fades between neighbouring frames, so the turn is smooth on screen without a third 3D body in the fight.
##   python tools/hidden_desktop.py run --timeout=900 <godot.exe> --path . --windowed --resolution 720x1200 \
##       --script res://tools/bake_body_turn.gd [-- stems=mh_boxer_11]
## Writes assets/ui/body/<stem>_turn_red.png, _turn_blue.png, _turn_mask.png (L8) and <stem>_turn.json
## {"n", "deg": [...], "frames": [{place: [x, y, rx, ry], "track": {...}}]} (fractions of ONE frame).

const Masks := preload("res://tools/bake_body_masks.gd")

const SWING := 30.0
const STEP := 5.0
const FRAME_H := 480   # the strip's frame height in pixels: the fight panel draws her ~440 px tall (files stay light)

var _key: DirectionalLight3D


func _initialize() -> void:
	root.size = Vector2i(W, H)
	root.transparent_bg = true
	root.msaa_3d = Viewport.MSAA_8X
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_CLEAR_COLOR
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.55, 0.55, 0.6)
	env.environment.ambient_light_energy = 0.9
	root.add_child(env)
	_key = DirectionalLight3D.new()
	_key.light_energy = 1.4
	root.add_child(_key)
	_cam = Camera3D.new()
	_cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	root.add_child(_cam)
	await process_frame
	var stems: Array = Faces.CM.keys()
	for a in OS.get_cmdline_user_args():
		if a.begins_with("stems="):
			stems = Array(a.trim_prefix("stems=").split(","))
	var degs: Array = []
	var d := -SWING
	while d <= SWING + 0.01:
		degs.append(d)
		d += STEP
	for stem in stems:
		var shots := {"red": [], "blue": []}
		var frames: Array = []
		var crop := Rect2i()
		for corner in ["red", "blue"]:
			var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % stem)
			root.add_child(body)
			MH.colour_trunks(body, Stage.TRUNKS[corner], Stage.CLOTH_ROUGHNESS)
			Kit.colour_vest(body, Stage.VESTS[corner], Stage.CLOTH_ROUGHNESS)
			Kit.cloth_normals(body)
			Kit.dress(body, "res://assets/models/metahuman/%s.glb" % stem, "boxing")
			var g := _geometry(body)
			for deg in degs:
				_aim(g, float(deg))
				for i in 6:
					await process_frame
				await RenderingServer.frame_post_draw
				var img := root.get_texture().get_image()
				_img_size = Vector2(img.get_width(), img.get_height())
				shots[corner].append(img)
				if corner == "red":
					var box := _alpha_box(img)
					var knee_px: int = int(_px(Vector3(0, g["knee_y"], 0)).y) + PAD * 4
					box.size.y = mini(box.size.y, knee_px - box.position.y)
					crop = box if crop.size == Vector2i.ZERO else crop.merge(box)
			if corner == "red":
				for deg in degs:   # the places need the union crop, known only now
					_aim(g, float(deg))
					var places := _places(_cam, g, crop)
					places["track"] = _track(body, crop)
					frames.append(places)
			body.queue_free()
			await process_frame
		var fw := int(round(float(crop.size.x) * FRAME_H / crop.size.y))
		var n := degs.size()
		var strips := {}
		for corner in ["red", "blue"]:
			strips[corner] = Image.create(fw * n, FRAME_H, false, Image.FORMAT_RGBA8)
		var mask := Image.create(fw * n, FRAME_H, false, Image.FORMAT_L8)
		for k in n:
			for corner in ["red", "blue"]:
				var fr: Image = (shots[corner][k] as Image).get_region(crop)
				fr.convert(Image.FORMAT_RGBA8)
				fr.resize(fw, FRAME_H, Image.INTERPOLATE_LANCZOS)
				(strips[corner] as Image).blit_rect(fr, Rect2i(0, 0, fw, FRAME_H), Vector2i(k * fw, 0))
				if corner == "red":
					mask.blit_rect(Masks.mask_of(fr, frames[k]["track"]), Rect2i(0, 0, fw, FRAME_H), Vector2i(k * fw, 0))
		for corner in ["red", "blue"]:
			(strips[corner] as Image).save_png(ProjectSettings.globalize_path(OUT.path_join("%s_turn_%s.png" % [stem, corner])))
		mask.save_png(ProjectSettings.globalize_path(OUT.path_join("%s_turn_mask.png" % stem)))
		var f := FileAccess.open(OUT.path_join(stem + "_turn.json"), FileAccess.WRITE)
		f.store_string(JSON.stringify({"n": n, "deg": degs, "frames": frames}))
		f.close()
		print("TURN %s %d frames %dx%d" % [stem, n, fw, FRAME_H])
	quit(0)


## Camera and key light orbit her by deg (positive = we see more of her left side), as the front shot does at 0.
func _aim(g: Dictionary, deg: float) -> void:
	var fwd: float = g["fwd"]
	var a := deg_to_rad(deg)
	var back := Vector3(0, 0, 6.0 * fwd).rotated(Vector3.UP, a)
	_cam.position = Vector3(back.x, g["mid_y"], back.z)
	_cam.look_at(Vector3(0, g["mid_y"], 0), Vector3.UP)
	_cam.size = float(g["tall"]) * 1.06
	_key.look_at_from_position(Vector3(1.5, 3.0, 4.0).rotated(Vector3.UP, a), Vector3(0, 1.0, 0), Vector3.UP)
