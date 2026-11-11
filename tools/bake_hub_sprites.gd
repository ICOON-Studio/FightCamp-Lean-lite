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
	# S429 workouts. Bag work faces away (135), the same angle as jab_back. Floor and rest face the room (45).
	"bag_combo": ["pro_combo_punch", 135.0, false, true],
	"bag_body": ["body_hook", 135.0, true, true],
	"bag_upper": ["rear_uppercut", 135.0, true, true],
	"guard_move": ["pro_block_loop", 45.0, false, true],
	"rest_drink": ["af_drink", 45.0, false, false],
	"rest_talk": ["af_talk", 45.0, false, false],
	"stretch": ["af_crouch_idle", 45.0, false, false],
	"shadow": ["slip", 45.0, false, true],
}
## Loop window in seconds where the whole clip does not close. Sampled the same way as a full clip: the end pose is the
## point the next frame would land on, so it is not drawn. Numbers from a pose match on Hips, Head, both hands, both feet.
const SPAN := {
	"bag_body": Vector2(0.374, 1.373),    # full body_hook pose delta 0.81; this window 0.41
	"bag_upper": Vector2(0.250, 1.185),   # full rear_uppercut pose delta 0.81; this window 0.38
}
## shadow, one row per frame: clip, seconds. 6 slip + 4 pull + 6 jab. The slip ends on the pose it
## shares with the pull. The pull ends on its closest jab frame, and the jab ends on its closest slip frame.
const SHADOW_FRAMES := [
	["slip", 0.533], ["slip", 0.450], ["slip", 0.360], ["slip", 0.280], ["slip", 0.480], ["slip", 0.600],
	["pull", 0.600], ["pull", 0.560], ["pull", 0.540], ["pull", 0.533],
	["jab", 0.333], ["jab", 0.250], ["jab", 0.150], ["jab", 0.050], ["jab", 0.100], ["jab", 0.167],
]
## The previous strip's three joins, so a bake can print the gap before this cut.
const SHADOW_BEFORE := [["slip", 0.448, "pull", 0.000], ["pull", 0.448, "jab", 0.000], ["jab", 0.556, "slip", 0.000]]
const POSE_BONES := ["Hips", "Head", "LeftHand", "RightHand", "LeftFoot", "RightFoot"]
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
	var only: Array = []
	for a in OS.get_cmdline_user_args():
		if a.begins_with("stems="):
			stems = a.substr(6).split(",")
		elif a.begins_with("clips="):
			only = a.substr(6).split(",")
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
			if not only.is_empty() and not only.has(str(clip_name)):
				continue
			var row: Array = CLIPS[clip_name]
			if not ap.has_animation(str(row[0])):
				push_error("missing clip %s (%s) on %s" % [clip_name, row[0], stem])
				_failures += 1
				continue
			_camera_at(float(row[1]))
			for g in gloves.gloves.values():
				g.visible = bool(row[3])
			var strip: Image
			if str(clip_name) == "shadow":
				strip = await _paint(body, skel, ap, SHADOW_FRAMES, false)
			else:
				strip = await _render_strip(body, skel, ap, str(row[0]), bool(row[2]), SPAN.get(str(clip_name), Vector2(-1, -1)))
			var margin := _check_strip(strip)
			if margin < 0.0:
				push_error("strip %s_%s failed self-check (worst margin %.1f px)" % [stem, clip_name, margin])
				_failures += 1
				continue
			var path := ProjectSettings.globalize_path(OUT.path_join("%s_%s.png" % [stem, clip_name]))
			strip.save_png(path)
			if str(clip_name) == "shadow":
				_shadow_json(skel, ap, path.trim_suffix(".png") + ".json")
			var sz := FileAccess.get_file_as_bytes(path).size()
			print("HUBSPRITE %s_%s %s %.2fs (%dx%d, %d bytes, margin=%.1f)" % [stem, clip_name, row[0], ap.get_animation(str(row[0])).length, strip.get_width(), strip.get_height(), sz, margin])
			results.append({"stem": stem, "clip": clip_name, "w": strip.get_width(), "h": strip.get_height(), "bytes": sz, "margin": margin})
		body.queue_free()
		await process_frame
	if only.is_empty():
		_write_result_doc(results)
	print("HUBSPRITES done strips=%d failures=%d" % [results.size(), _failures])
	quit(0 if _failures == 0 else 1)


## Sum of the six bone distances, in metres, after the hips' sideways shift is taken off.
## That sum is the pose gap in the GYMLIFE1 table (a printed 0.81 is this sum, to two decimals).
func _pose_gap(skel: Skeleton3D, ap: AnimationPlayer, anim_a: String, ta: float, anim_b: String, tb: float) -> float:
	var a := _pose_norm(skel, ap, anim_a, ta)
	var b := _pose_norm(skel, ap, anim_b, tb)
	var total := 0.0
	for i in POSE_BONES.size():
		total += a[i].distance_to(b[i])
	return total


func _pose_norm(skel: Skeleton3D, ap: AnimationPlayer, anim: String, t: float) -> Array:
	if not ap.has_animation(anim):
		return []
	ap.play(anim)
	ap.seek(clampf(t, 0.0, ap.get_animation(anim).length), true)
	var hips := skel.get_bone_global_pose(skel.find_bone("Hips")).origin
	var out: Array = []
	for bone_name in POSE_BONES:
		var origin := skel.get_bone_global_pose(skel.find_bone(bone_name)).origin
		out.append(origin - Vector3(hips.x, 0.0, hips.z))
	return out


func _shadow_json(skel: Skeleton3D, ap: AnimationPlayer, path: String) -> void:
	var joins: Array = []
	var n := SHADOW_FRAMES.size()
	for i in n:
		var here: Array = SHADOW_FRAMES[i]
		var nxt: Array = SHADOW_FRAMES[(i + 1) % n]
		if str(here[0]) == str(nxt[0]):
			continue
		var old: Array = SHADOW_BEFORE[joins.size()]
		var before := _pose_gap(skel, ap, str(old[0]), float(old[1]), str(old[2]), float(old[3]))
		var after := _pose_gap(skel, ap, str(here[0]), float(here[1]), str(nxt[0]), float(nxt[1]))
		print("SHADOW join %s@%.3f -> %s@%.3f before=%.3f after=%.3f" % [here[0], here[1], nxt[0], nxt[1], before, after])
		joins.append({
			"from": str(here[0]), "from_t": float(here[1]),
			"to": str(nxt[0]), "to_t": float(nxt[1]),
			"before": snapped(before, 0.001), "gap": snapped(after, 0.001),
		})
	var body := {"frames": n, "wide": FRAME_W, "tall": FRAME_H, "joins": joins}
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("cannot write " + path)
		_failures += 1
		return
	f.store_string(JSON.stringify(body, "  "))
	f.close()



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


func _render_strip(body: Node3D, skel: Skeleton3D, ap: AnimationPlayer, anim_name: String, pin_each: bool, span_override: Vector2 = Vector2(-1, -1), nudge: Vector2i = Vector2i.ZERO) -> Image:
	var span := span_override if span_override.x >= 0.0 else (_stride(skel, ap, anim_name) if pin_each else Vector2(0.0, maxf(ap.get_animation(anim_name).length, 0.1)))
	var parts: Array = []
	for i in N_FRAMES:
		parts.append([anim_name, span.x + float(i) / float(N_FRAMES) * (span.y - span.x)])
	return await _paint(body, skel, ap, parts, pin_each, nudge)


## parts: [anim, time] per frame, or the SHADOW rows expanded by the caller. 16 frames, hips on one floor line.
func _render_parts(body: Node3D, skel: Skeleton3D, ap: AnimationPlayer, rows: Array, pin_each: bool, nudge: Vector2i = Vector2i.ZERO) -> Image:
	var parts: Array = []
	for row in rows:
		var count := int(row[3])
		for i in count:
			var t: float = float(row[1]) + float(i) / float(count) * (float(row[2]) - float(row[1]))
			parts.append([str(row[0]), t])
	return await _paint(body, skel, ap, parts, pin_each, nudge)


func _paint(body: Node3D, skel: Skeleton3D, ap: AnimationPlayer, parts: Array, pin_each: bool, nudge: Vector2i = Vector2i.ZERO) -> Image:
	var strip := Image.create(FRAME_W * N_FRAMES, FRAME_H, false, Image.FORMAT_RGBA8)
	var anchor := Vector2.INF
	for i in parts.size():
		var part: Array = parts[i]
		ap.play(str(part[0]))
		ap.seek(float(part[1]), true)
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
	return _fit(strip)


## Slide every frame by the same amount so a wide punch stays off the side and a crouch's feet sit on the jab line (y=111).
func _fit(strip: Image) -> Image:
	var left := 999
	var right := 999
	var top := 999
	var bottom := -1
	for f in N_FRAMES:
		var used := strip.get_region(Rect2i(f * FRAME_W, 0, FRAME_W, FRAME_H)).get_used_rect()
		if used.size.x <= 0:
			continue
		left = mini(left, used.position.x)
		right = mini(right, FRAME_W - used.end.x)
		top = mini(top, used.position.y)
		bottom = maxi(bottom, used.end.y - 1)
	var dx := 0
	if left < 2 and right >= 2:
		dx = mini(2 - left, right - 2)
	elif right < 2 and left >= 2:
		dx = -mini(2 - right, left - 2)
	var dy := 0
	if bottom > 111:
		dy = 111 - bottom
	if top + dy < 2:
		dy = 2 - top
	if dx == 0 and dy == 0:
		return strip
	var out := Image.create(strip.get_width(), strip.get_height(), false, Image.FORMAT_RGBA8)
	for f in N_FRAMES:
		var frame := strip.get_region(Rect2i(f * FRAME_W, 0, FRAME_W, FRAME_H))
		out.blit_rect(_slide(frame, Vector2i(dx, dy)), Rect2i(0, 0, FRAME_W, FRAME_H), Vector2i(f * FRAME_W, 0))
	print("HUBSPRITE fit dx=%d dy=%d left=%d right=%d top=%d bottom=%d" % [dx, dy, left, right, top, bottom])
	return out


func _slide(img: Image, d: Vector2i) -> Image:
	var out := Image.create(FRAME_W, FRAME_H, false, Image.FORMAT_RGBA8)
	var x0 := maxi(0, d.x)
	var y0 := maxi(0, d.y)
	var x1 := mini(FRAME_W, d.x + FRAME_W)
	var y1 := mini(FRAME_H, d.y + FRAME_H)
	if x1 > x0 and y1 > y0:
		out.blit_rect(img, Rect2i(x0 - d.x, y0 - d.y, x1 - x0, y1 - y0), Vector2i(x0, y0))
	return out


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
				print("CHECK corner frame %d px %s a=%.2f" % [f, corner - Vector2i(x0, 0), strip.get_pixelv(corner).a])
				return -1.0
		var used := strip.get_region(Rect2i(x0, 0, FRAME_W, FRAME_H)).get_used_rect()
		if used.size.x <= 0:
			print("CHECK empty frame %d" % f)
			return -1.0
		var margin := minf(minf(float(used.position.y), float(FRAME_H - used.end.y)), minf(float(used.position.x), float(FRAME_W - used.end.x)))
		if margin < 1.0:
			print("CHECK tight frame %d margin %.1f rect %s" % [f, margin, used])
		worst = minf(worst, margin)
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
