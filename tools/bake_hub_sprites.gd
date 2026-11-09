extends SceneTree
## HUBSPRITES1 - the gym menu's moving figures: each MetaHuman boxer as a strip of 16 frames per clip, transparent
## background, isometric view (30 deg down), soft top light, no floor, no shadow. Orthographic, so a figure is the same
## size anywhere on the painted floor. The body stands on one floor line in every frame.
##   python ops/Tools/godot_slot.py run --who claude -- python tools/hidden_desktop.py run --timeout=300 \
##       <godot.exe> --path . --windowed --resolution 1280x720 --audio-driver Dummy --script res://tools/bake_hub_sprites.gd \
##       [-- stems=mh_boxer_01,mh_boxer_02]
## Writes assets/ui/art/hub_sprites/<stem>_<clip>.png (16 frames x 192 wide, 256 tall).
## Four ways across an isometric floor from two views: walk (towards the lens) and walk_back (away), each mirrored in the UI.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")

const FRAME_W := 96
const FRAME_H := 128
const SUPER := 4             # rendered four times the size, then shrunk: clean edges at the small size
const N_FRAMES := 16
const OUT := "res://assets/ui/art/hub_sprites"
const MH_DIR := "res://assets/models/metahuman"
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
const STEMS := ["mh_boxer_01", "mh_boxer_02", "mh_boxer_03", "mh_boxer_07", "mh_boxer_08", "mh_boxer_10", "mh_boxer_11", "mh_boxer_12",
	"mh_boxer_13", "mh_boxer_14", "mh_boxer_15", "mh_boxer_16", "mh_boxer_17", "mh_boxer_18", "mh_boxer_19", "mh_boxer_20", "mh_boxer_21",
	"mh_boxer_22", "mh_boxer_23"]
## name -> [clip, degrees round from her front, hips held in place on every frame, gloves on]
const CLIPS := {
	"idle": ["pro_idle", 45.0, false, true],
	"jab": ["jab", 45.0, false, true],
	"jab_back": ["jab", 135.0, false, true],      # working a bag: her back to the lens, the bag beyond her
	"idle_back": ["pro_idle", 135.0, false, true],
	"stand": ["af_idle_foldarms", 45.0, false, false],
	"walk": ["rk_loc_walk", 45.0, true, false],
	"walk_back": ["rk_loc_walk", 135.0, true, false],
}
const BLUE_STEMS := ["02", "08", "12", "14", "17", "20", "23"]   # some vests blue, so a busy gym is not one red team
const CAM_PITCH_DEG := 30.0  # looking down
const CAM_DIST := 6.0
const VIEW_H_M := 2.2        # metres of world from the frame's bottom to its top
const LOOK_Y_M := 0.86       # the height the lens aims at

var _failures := 0
var _vp: SubViewport
var _cam: Camera3D


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT))
	_setup_scene()
	var stems: Array = STEMS.duplicate()
	for a in OS.get_cmdline_user_args():
		if a.begins_with("stems="):
			stems = a.substr(6).split(",")
	var results: Array = []
	for stem in stems:
		var glb: String = MH_DIR.path_join(str(stem) + ".glb")
		var body := MH.load_fighter(glb)
		if body == null:
			push_error("cannot load " + glb)
			_failures += 1
			continue
		var side: String = "blue" if str(stem).right(2) in BLUE_STEMS else "red"
		Kit.colour_vest(body, Stage.VESTS[side], Stage.CLOTH_ROUGHNESS)
		Kit.cloth_normals(body)
		Kit.dress(body, glb, "boxing")
		var gloves := Gloves.new()
		gloves.name = "Gloves"
		body.add_child(gloves)
		gloves.mount(body, Stage.CORNERS[side][0], Stage.CORNERS[side][1])
		_vp.add_child(body)
		await process_frame
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
		FightClips.load_into(ap, skel)
		ap.speed_scale = 0.0   # a clip runs on real time; every frame here is placed by hand
		for clip_name in CLIPS:
			var row: Array = CLIPS[clip_name]
			if not ap.has_animation(str(row[0])):
				push_error("missing clip %s (%s) on %s" % [clip_name, row[0], stem])
				_failures += 1
				continue
			_camera_at(float(row[1]))
			for g in gloves.gloves.values():
				g.visible = bool(row[3])
			var strip := await _render_strip(body, skel, ap, str(row[0]), bool(row[2]))
			var margin := _check_strip(strip)
			if margin < 0.0:
				push_error("strip %s_%s failed self-check (worst margin %.1f px)" % [stem, clip_name, margin])
				_failures += 1
				continue
			var path := ProjectSettings.globalize_path(OUT.path_join("%s_%s.png" % [stem, clip_name]))
			strip.save_png(path)
			var sz := FileAccess.get_file_as_bytes(path).size()
			print("HUBSPRITE %s_%s %s %.2fs (%dx%d, %d bytes, margin=%.1f)" % [stem, clip_name, row[0], ap.get_animation(str(row[0])).length, strip.get_width(), strip.get_height(), sz, margin])
			results.append({"stem": stem, "clip": clip_name, "w": strip.get_width(), "h": strip.get_height(), "bytes": sz, "margin": margin})
		body.queue_free()
		await process_frame
	_write_result_doc(results)
	print("HUBSPRITES done strips=%d failures=%d" % [results.size(), _failures])
	quit(0 if _failures == 0 else 1)


func _setup_scene() -> void:
	_vp = SubViewport.new()
	_vp.size = Vector2i(FRAME_W * SUPER, FRAME_H * SUPER)
	_vp.transparent_bg = true
	_vp.own_world_3d = true
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_vp.msaa_3d = Viewport.MSAA_4X
	root.add_child(_vp)
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_CLEAR_COLOR
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.85, 0.85, 0.85)
	e.ambient_light_energy = 0.6
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = e
	_vp.add_child(env)
	_cam = Camera3D.new()
	_cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	_cam.size = VIEW_H_M
	_vp.add_child(_cam)
	_cam.make_current()
	for l in [[Vector3(-75, 30, 0), 1.2, Color(1.0, 0.98, 0.95)], [Vector3(-60, -40, 0), 0.4, Color(0.95, 0.95, 1.0)]]:
		var light := DirectionalLight3D.new()
		light.rotation_degrees = l[0]
		light.light_energy = l[1]
		light.light_color = l[2]
		light.shadow_enabled = false
		_vp.add_child(light)


func _render_strip(body: Node3D, skel: Skeleton3D, ap: AnimationPlayer, anim_name: String, pin_each: bool) -> Image:
	var strip := Image.create(FRAME_W * N_FRAMES, FRAME_H, false, Image.FORMAT_RGBA8)
	var span: Vector2 = _stride(skel, ap, anim_name) if pin_each else Vector2(0.0, maxf(ap.get_animation(anim_name).length, 0.1))
	var anchor := Vector2.INF
	for i in N_FRAMES:
		ap.play(anim_name)
		ap.seek(span.x + float(i) / float(N_FRAMES) * (span.y - span.x), true)
		body.position = Vector3.ZERO
		var h := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Hips"))
		if anchor == Vector2.INF or pin_each:
			anchor = Vector2(h.origin.x, h.origin.z)
		body.position = Vector3(-anchor.x, 0.0, -anchor.y)
		await process_frame
		await RenderingServer.frame_post_draw
		var img := _vp.get_texture().get_image()
		img.convert(Image.FORMAT_RGBA8)
		img.fix_alpha_edges()
		img.resize(FRAME_W, FRAME_H, Image.INTERPOLATE_LANCZOS)
		strip.blit_rect(img, Rect2i(0, 0, FRAME_W, FRAME_H), Vector2i(i * FRAME_W, 0))
	return strip


## One whole stride of a walk (from, to in seconds): between two passes of the left foot going in front of the right, past
## the clip's first half second where the walk is still starting. A strip made from it loops without a jump.
func _stride(skel: Skeleton3D, ap: AnimationPlayer, anim_name: String) -> Vector2:
	var length: float = ap.get_animation(anim_name).length
	var l := skel.find_bone("LeftFoot")
	var r := skel.find_bone("RightFoot")
	var was := 0.0
	var starts: Array = []
	var t := 0.5
	while t < length:
		ap.play(anim_name)
		ap.seek(t, true)
		var gap := skel.get_bone_global_pose(l).origin.z - skel.get_bone_global_pose(r).origin.z
		if was < 0.0 and gap >= 0.0:
			starts.append(t)
		was = gap
		t += 1.0 / 60.0
	if starts.size() < 2:
		push_error("no whole stride in %s" % anim_name)
		return Vector2(0.0, maxf(length, 0.1))
	print("HUBSPRITE stride %s %.3f-%.3f (%.3f s)" % [anim_name, starts[0], starts[1], float(starts[1]) - float(starts[0])])
	return Vector2(float(starts[0]), float(starts[1]))


## The lens sits on her front's side, `round_deg` round from her front (+Z) and looking down.
func _camera_at(round_deg: float) -> void:
	var yaw := deg_to_rad(round_deg)
	var pitch := deg_to_rad(CAM_PITCH_DEG)
	var to_lens := Vector3(sin(yaw) * cos(pitch), sin(pitch), cos(yaw) * cos(pitch))
	var aim := Vector3(0.0, LOOK_Y_M, 0.0)
	_cam.look_at_from_position(aim + to_lens * CAM_DIST, aim, Vector3.UP)


## Corners clear on every frame, and the body inside the frame on all four sides. Returns the worst margin in px,
## negative when a corner is opaque, a frame is empty or the body touches an edge.
func _check_strip(strip: Image) -> float:
	var worst := 999.0
	for f in N_FRAMES:
		var x0 := f * FRAME_W
		for corner in [Vector2i(x0, 0), Vector2i(x0 + FRAME_W - 1, 0), Vector2i(x0, FRAME_H - 1), Vector2i(x0 + FRAME_W - 1, FRAME_H - 1)]:
			if strip.get_pixelv(corner).a > 0.05:
				return -1.0
		var used := strip.get_region(Rect2i(x0, 0, FRAME_W, FRAME_H)).get_used_rect()
		if used.size.x <= 0:
			return -1.0
		worst = minf(worst, minf(minf(float(used.position.y), float(FRAME_H - used.end.y)), minf(float(used.position.x), float(FRAME_W - used.end.x))))
	return worst - 1.0 if worst <= 0.0 else worst


func _write_result_doc(results: Array) -> void:
	var lines: Array = ["# HUBSPRITES1 Result", "", "| stem | clip | size | file size | margin |", "|------|------|------|-----------|--------|"]
	for r in results:
		lines.append("| %s | %s | %dx%d | %d bytes | %.1f px |" % [r["stem"], r["clip"], r["w"], r["h"], r["bytes"], r["margin"]])
	lines.append("")
	lines.append("Made by tools/bake_hub_sprites.gd (its header has the command).")
	var f := FileAccess.open(ProjectSettings.globalize_path("res://docs/HUBSPRITES1_RESULT.md"), FileAccess.WRITE)
	if f != null:
		f.store_string("\n".join(lines) + "\n")
		f.close()
