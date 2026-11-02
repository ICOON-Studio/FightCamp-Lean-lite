extends SceneTree
## TRAINCLIPS1 r5 - bakes her eight training sessions as ink exercise cards, one set per MetaHuman boxer.
##
##   python tools/hidden_desktop.py run --timeout=900 "<godot>" --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --script res://tools/bake_session_pics.gd -- all=1
##
##   Writes assets/ui/training/<body stem>_<session id>.png (256 px, opaque charcoal tile) and session_pics.json.
##   The look is drawn in 3D (flat toon fill + inverted-hull ink line, see tools/session_pic_style.gd), rendered at 1024
##   and downsampled; the framing is measured on the RENDERED figures' bounds, never on the skeleton. Each session is shot
##   from its own camera (tools/session_pic_poses.gd) - the poses are frames of clips already in assets/anim/baked.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const SPS := preload("res://tools/session_pic_style.gd")
const SPC := preload("res://tools/session_pic_card.gd")
const Poses := preload("res://tools/session_pic_poses.gd")
const TW := preload("res://scripts/rules/TrainingWeek.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")

const OUT := "res://assets/ui/training"
const MH_DIR := "res://assets/models/metahuman"
const BIG := 1024            # the render the card is downsampled from
const MEASURE := 256         # the framing pass: exact for an orthographic camera, and four times cheaper
const OUTLINE_PX := 2.5      # the ink line's weight in the finished 256 card
const GHOST := 0.35          # the start figure's opacity
const CARD := 256
const CAM_DIST := 6.0
const BAG_R := 0.175         # 0.35 m wide
const BAG_H := 1.0           # 1.0 m tall
const MITT_R := 0.12         # 0.24 m
const MITT_THICK := 0.07
const BALL_R := 0.11
const ARROW_LIFT := {"Head": Vector3(0.0, 0.10, 0.0), "LeftFoot": Vector3(0.0, 0.03, 0.0)}

var _cam: Camera3D
var _vp: SubViewport
var _props: Node3D
var _img_size := Vector2(BIG, BIG)
var _hulls: Array = []
var _fills: Array = []
var _hull_shader: Shader
var _json: Dictionary = {}
var _stem := ""
var _from_bone := "LeftHand"
var _to_bone := "LeftHand"
var _size := BIG


func _initialize() -> void:
	root.size = Vector2i(320, 240)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT))
	_vp = SubViewport.new()
	_vp.size = Vector2i(BIG, BIG)
	_vp.transparent_bg = true
	_vp.msaa_3d = Viewport.MSAA_DISABLED     # the 4:1 downsample is the anti-aliasing
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(_vp)
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0, 0, 0, 0)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_DISABLED
	e.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	env.environment = e
	_vp.add_child(env)
	_cam = Camera3D.new()
	_cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	_cam.keep_aspect = Camera3D.KEEP_HEIGHT
	_cam.near = 0.05
	_cam.far = 60.0
	_vp.add_child(_cam)
	_props = Node3D.new()
	_props.name = "Props"
	_vp.add_child(_props)
	_hull_shader = load(SPS.HULL_SHADER) as Shader
	await process_frame
	for stem in _stems():
		await _bake_stem(stem)
	var jf := FileAccess.open(OUT.path_join("session_pics.json"), FileAccess.WRITE)
	jf.store_string(JSON.stringify(_json, "\t"))
	jf.close()
	print("SESSION_PICS_JSON %s" % OUT.path_join("session_pics.json"))
	quit(0)


func _stems() -> Array:
	var out: Array = []
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("stems="):
			for name in s.trim_prefix("stems=").split(","):
				out.append(str(name).get_file().get_basename())
	if not out.is_empty():
		return out
	for f in DirAccess.get_files_at(MH_DIR):
		var file := str(f)
		if file.begins_with("mh_boxer_") and file.ends_with(".glb"):
			out.append(file.get_basename())
	out.sort()
	return out


# ---------------------------------------------------------------- one body -------------------------------------------------

func _bake_stem(stem: String) -> void:
	_stem = stem
	var glb := MH_DIR.path_join(stem + ".glb")
	var body := MH.load_fighter(glb)
	if body == null:
		push_error("cannot load " + glb)
		return
	Kit.dress(body, glb, "boxing")
	var gloves := Gloves.new()
	gloves.name = "Gloves"
	body.add_child(gloves)
	gloves.mount(body, Stage.CORNERS["red"][0], Stage.CORNERS["red"][1])
	_vp.add_child(body)
	await process_frame
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var ap := body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(ap, skel)
	var bx := {"node": body, "skel": skel, "ap": ap, "gloves": gloves}
	var mats := SPS.ink_materials()
	_fills = mats.values()
	_hulls = SPS.ink_body(body, mats)
	_json[stem] = {}
	for s in TW.SESSIONS:
		await _bake_session(str(s["id"]), bx)
	body.queue_free()
	await process_frame


# ---------------------------------------------------------------- one session -------------------------------------------------

func _bake_session(id: String, bx: Dictionary) -> void:
	var finish := Poses.finish(id, bx)
	_clear_props()
	_pose(bx, finish, Vector3.ZERO)
	_add_props(id, bx)
	var start := Poses.start_pose(id, bx, finish)
	var align := Vector3.ZERO
	if not start.is_empty():
		align = _hips_align(bx, finish, start)
	var arrow := Poses.arrow_bones(id, finish)
	_from_bone = str(arrow["from"])
	_to_bone = str(arrow["to"])
	_aim(id, bx, finish)
	# The correction is exact (orthographic camera), so the cheap pass is measured once and the card render follows it;
	# it is then re-measured on the render itself and corrected once more only if the drawing did not land.
	var pair := await _shoot(bx, finish, start, align, MEASURE)
	for i in 3:
		if _inside(pair["box"], MEASURE):
			break
		_cam.size *= 1.25     # the drawing is off the frame: a clipped box cannot be corrected, only zoomed out of
		pair = await _shoot(bx, finish, start, align, MEASURE)
	_correct(pair["box"], MEASURE, CARD - 2 * SPS.MARGIN - 6)
	pair = await _shoot(bx, finish, start, align, BIG)
	if not _fits(pair["box"], BIG, SPS.MARGIN):
		if _inside(pair["box"], BIG):
			_correct(pair["box"], BIG)
		else:
			_cam.size *= 1.06
		pair = await _shoot(bx, finish, start, align, BIG)
	_pose(bx, finish, Vector3.ZERO)
	var row := _measure(bx, id, finish)
	row["box"] = [pair["box"].position.x, pair["box"].position.y, pair["box"].size.x, pair["box"].size.y]
	row["margin"] = _margin(pair["box"], BIG)
	_json[_stem][id] = row
	var ghost: Image = pair.get("start", null)
	var from: Vector2 = pair.get("from", Vector2.ZERO)
	var to: Vector2 = pair.get("to", from)
	var img := SPC.card(SPC.ink_layer(pair["finish"]), SPC.ink_layer(ghost) if ghost != null else null,
		from, to if not start.is_empty() else from)
	img.save_png(ProjectSettings.globalize_path(OUT.path_join("%s_%s.png" % [_stem, id])))
	print("SESSION_PIC %s_%s %s" % [_stem, id, JSON.stringify(row)])


## Both figures rendered at `size` with the pose that belongs to each, and the box the drawing actually covers.
func _shoot(bx: Dictionary, finish: Dictionary, start: Dictionary, align: Vector3, size: int) -> Dictionary:
	var out: Dictionary = {}
	_pose(bx, finish, Vector3.ZERO)
	out["finish"] = await _render(size)
	out["box"] = (out["finish"] as Image).get_used_rect()
	_img_size = Vector2(CARD, CARD)
	out["to"] = _bone_px(bx, _to_bone)
	if not start.is_empty():
		_pose(bx, start, align)
		out["start"] = await _render(size)
		out["box"] = (out["box"] as Rect2i).merge((out["start"] as Image).get_used_rect())
		_img_size = Vector2(CARD, CARD)
		out["from"] = _bone_px(bx, _from_bone)
	return out


func _render(size: int) -> Image:
	if _vp.size.x != size:
		_vp.size = Vector2i(size, size)
	_size = size
	_img_size = Vector2(size, size)
	_push_camera()
	for i in 3:
		await process_frame
	await RenderingServer.frame_post_draw
	var img := _vp.get_texture().get_image()
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	# No colour-space conversion here. A flat tone put through this exact viewport comes back as the value itself (0.30 in,
	# 0.298 out - measured S352 with a probe quad per palette tone), so the pipeline is already sRGB end to end and an
	# extra linear_to_srgb() would push every tone a stop up: the bag's 0.60 came back as 0.74 and every prop read as
	# body grey.
	return img


## The ink line's weight and the key light belong to the camera, so they are set before every shot.
func _push_camera() -> void:
	var width := OUTLINE_PX * _cam.size / float(CARD)
	for h in _hulls:
		h.set_shader_parameter("width_m", width)
	var b := _cam.global_transform.basis
	# The key light sits near the eye (28 deg off the view axis, a little up and to the card's right): from further off, a
	# limb's visible half falls to the dark tone and the figure reads as a silhouette (S352's first attempt).
	var light := (b.z + b.x * 0.40 + b.y * 0.35).normalized()
	for f in _fills:
		f.set_shader_parameter("light_dir", light)


func _pose(bx: Dictionary, pose: Dictionary, offset: Vector3) -> void:
	IdleMatch.freeze(bx, str(pose["clip"]), float(pose["t"]))
	(bx["node"] as Node3D).position = offset
	(bx["ap"] as AnimationPlayer).advance(0.001)
	# The gloves ride the palm frame on skeleton_updated, and a seek does not always raise it: without this the fist the
	# props are hung off is still the pose of the previous frame (S352: the heavy bag sat 0.19 m high, 0.32 m off the glove).
	(bx["skel"] as Skeleton3D).emit_signal("skeleton_updated")


## Where the start figure's hips sit on the finish figure's mark: a travelling clip would otherwise walk the ghost off
## the card, and the two figures of a stride belong over each other.
func _hips_align(bx: Dictionary, finish: Dictionary, start: Dictionary) -> Vector3:
	_pose(bx, finish, Vector3.ZERO)
	var f := _bone(bx, "Hips")
	_pose(bx, start, Vector3.ZERO)
	var s := _bone(bx, "Hips")
	return Vector3(f.x - s.x, 0.0, f.z - s.z)


## The camera a session is shot from: `az` degrees round her (0 = face on, -90 = her right side), `elev` above her middle.
func _aim(id: String, bx: Dictionary, finish: Dictionary) -> void:
	_pose(bx, finish, Vector3.ZERO)
	var s := Poses.spec(id)
	var lo := INF
	var hi := -INF
	for bone in ["Head", "LeftFoot", "RightFoot", "LeftToes", "RightToes"]:
		var p := _bone(bx, bone)
		if p == Vector3.ZERO:
			continue
		lo = minf(lo, p.y)
		hi = maxf(hi, p.y)
	var hips := _bone(bx, "Hips")
	var focus := Vector3(hips.x, (lo + hi) * 0.5 + 0.06, hips.z)
	var az := deg_to_rad(float(s["az"]))
	var el := deg_to_rad(float(s["elev"]))
	_cam.position = focus + Vector3(sin(az) * cos(el), sin(el), cos(az) * cos(el)).normalized() * CAM_DIST
	_cam.look_at(focus, Vector3.UP)
	_cam.size = (hi - lo + 0.42) * float(s["size"])


## The correction that puts the measured box in the middle of the card inside the margin - exact, because the camera is
## orthographic: scaling about the look target is linear in the pixel space.
func _correct(box: Rect2i, size: int, target: int = CARD - 2 * SPS.MARGIN) -> void:
	var f := float(CARD) / float(size)
	var pos := Vector2(box.position) * f
	var ext := Vector2(box.size) * f
	var avail := float(target)
	var s := minf(avail / maxf(ext.x, 1.0), avail / maxf(ext.y, 1.0))
	_cam.size /= s
	var u := _cam.size / float(CARD)
	var shift := (Vector2(CARD, CARD) * 0.5 - (pos + ext * 0.5)) * s
	var b := _cam.global_transform.basis
	# Moving the camera right moves the drawing LEFT on the card; moving it up moves the drawing UP.
	_cam.position += b.x * (-shift.x * u) + b.y * (shift.y * u)


## True while the drawing is clear of the frame's own edges (so its bounds are real, not cut off by the picture).
func _inside(box: Rect2i, size: int) -> bool:
	if box.size.x <= 0 or box.size.y <= 0:
		return false
	return box.position.x > 1 and box.position.y > 1 		and box.position.x + box.size.x < size - 1 and box.position.y + box.size.y < size - 1


func _fits(box: Rect2i, size: int, margin: int) -> bool:
	if box.size.x <= 0 or box.size.y <= 0:
		return false
	var m := float(margin) * float(size) / float(CARD)
	return box.position.x >= m and box.position.y >= m \
		and float(box.position.x + box.size.x) <= float(size) - m \
		and float(box.position.y + box.size.y) <= float(size) - m


## How much room the drawing leaves on each side of the finished card (px) - the brief asks for 6.
func _margin(box: Rect2i, size: int) -> Array:
	var f := float(CARD) / float(size)
	return [int(round(box.position.x * f)), int(round(box.position.y * f)),
		int(round((size - box.position.x - box.size.x) * f)), int(round((size - box.position.y - box.size.y) * f))]


# ---------------------------------------------------------------- the props -------------------------------------------------

func _clear_props() -> void:
	for c in _props.get_children():
		c.free()


func _tag(mi: MeshInstance3D, kind: String, centre: Vector3, r: float, half: float) -> void:
	mi.set_meta("prop_kind", kind)
	mi.set_meta("prop_c", centre)
	mi.set_meta("prop_r", r)
	mi.set_meta("prop_h", half)


func _add_props(id: String, bx: Dictionary) -> void:
	match id:
		"heavy_bag":
			_add_bag(bx, "RightHand")
		"pads":
			_add_mitt(bx, "LeftHand")
		"slip_rope":
			_add_rope(bx, "Head")
		"speed_bag":
			_add_speed_bag(bx, "LeftHand")


## A heavy bag hanging where her cross lands: the glove's own striking face touches the bag, the fist in its top third.
func _add_bag(bx: Dictionary, hand: String) -> void:
	var face := _glove_tip(bx, hand)
	var dir := _glove_dir(bx, hand)
	dir.y = 0.0
	dir = dir.normalized()
	var centre := Vector3(face.x, 0.0, face.z) + dir * BAG_R
	centre.y = face.y - (BAG_H * 0.5 - 0.16)
	var bag := SPS.prop_cyl(BAG_R, BAG_H, SPS.PROP_GREY, _hull_shader)
	(bag[0] as MeshInstance3D).position = centre
	_tag(bag[0], "cyl", centre, BAG_R, BAG_H * 0.5)
	_hulls.append(bag[1])
	_props.add_child(bag[0])


## The coach's mitt where the lead hook lands, its face square to the fist.
func _add_mitt(bx: Dictionary, hand: String) -> void:
	var face := _glove_tip(bx, hand)
	var dir := _glove_dir(bx, hand)
	var mitt := SPS.prop_cyl(MITT_R, MITT_THICK, SPS.PROP_DARK, _hull_shader)
	var mi := mitt[0] as MeshInstance3D
	mi.position = face - dir * (MITT_THICK * 0.5)
	var to_cam := _cam.global_position - mi.position
	to_cam.y = 0.0
	var normal := (dir + to_cam.normalized()).normalized()
	var side_ax := Vector3.RIGHT if absf(normal.dot(Vector3.RIGHT)) < 0.9 else Vector3.FORWARD
	var ax := side_ax.cross(normal).normalized()
	# The mitt is a disc: its face is the cylinder's local +Y, so the punch runs along Y, not along look_at's -Z.
	mi.transform = Transform3D(Basis(ax, normal, ax.cross(normal)), mi.position)
	_tag(mi, "disc", mi.position, MITT_R, MITT_THICK * 0.5)
	_hulls.append(mitt[1])
	_props.add_child(mi)


## The slip rope: a line across her front at head height, running left-right of the card so it never points at the eye.
func _add_rope(bx: Dictionary, bone: String) -> void:
	var head := _bone_world(bx, bone)
	var rope := SPS.prop_cyl(0.012, 1.9, SPS.PROP_GREY, _hull_shader, 12)
	var mi := rope[0] as MeshInstance3D
	var right := _cam.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()
	var y := head.y + 0.20
	# The cylinder's own axis is its local +Y, so the second basis vector is the card's horizontal - not UP.
	mi.transform = Transform3D(Basis(Vector3.UP, right, Vector3.UP.cross(right)), Vector3(head.x, y, head.z))
	_hulls.append(rope[1])
	_props.add_child(mi)   # not tagged: the gap of a tilted prop is not a prop_gap


## The speed bag: the ball hung where her fist meets it, on a board above her eye line.
func _add_speed_bag(bx: Dictionary, hand: String) -> void:
	var centre := _glove_tip(bx, hand) + _glove_dir(bx, hand) * BALL_R
	var ball := SPS.prop_sphere(BALL_R, SPS.PROP_GREY, _hull_shader)
	(ball[0] as MeshInstance3D).position = centre
	_tag(ball[0], "sphere", centre, BALL_R, 0.0)
	_hulls.append(ball[1])
	_props.add_child(ball[0])
	var board := SPS.prop_box(Vector3(0.52, 0.06, 0.16), SPS.PROP_GREY, _hull_shader)
	var bm := board[0] as MeshInstance3D
	var at := centre + Vector3(0.0, BALL_R + 0.045, 0.0)   # its lower edge just clears the ball it hangs
	var face := -_cam.global_transform.basis.z
	var ax2 := face.cross(Vector3.UP).normalized()
	# The board's wide face looks at the card: its local Z is the view direction, its long side the card's horizontal.
	bm.transform = Transform3D(Basis(ax2, Vector3.UP, face), at)
	_hulls.append(board[1])
	_props.add_child(bm)


# ---------------------------------------------------------------- geometry helpers -------------------------------------------------

## A bone's point in the body's own frame (unaffected by where the body node stands).
func _bone(bx: Dictionary, bone: String) -> Vector3:
	var skel: Skeleton3D = bx["skel"]
	var idx := skel.find_bone(bone)
	if idx < 0:
		return Vector3.ZERO
	var to_body := (bx["node"] as Node3D).global_transform.affine_inverse() * skel.global_transform
	return to_body * skel.get_bone_global_pose(idx).origin


func _bone_world(bx: Dictionary, bone: String) -> Vector3:
	return (bx["node"] as Node3D).global_transform * _bone(bx, bone)


func _bone_px(bx: Dictionary, bone: String) -> Vector2:
	return _px(_bone_world(bx, bone) + ARROW_LIFT.get(bone, Vector3.ZERO))


## The world point of a camera-facing pixel - the orthographic camera keeps the height correct through cam.size.
func _px(p: Vector3) -> Vector2:
	var l: Vector3 = _cam.global_transform.affine_inverse() * p
	var ppm: float = _img_size.y / _cam.size
	return Vector2(_img_size.x * 0.5 + l.x * ppm, _img_size.y * 0.5 - l.y * ppm)


## The glove's own striking face: the palm frame Gloves mounts (its local +Y runs wrist -> knuckles), walked out by
## the length of the mounted glove mesh. The wrist bone alone sits a glove's length short of where the fist really is.
func _glove_tip(bx: Dictionary, hand: String) -> Vector3:
	var gl: Gloves = bx["gloves"]
	var node: Node3D = gl.gloves.get("l" if hand.begins_with("Left") else "r") if gl != null else null
	if node == null:
		return _bone_world(bx, hand)
	return node.global_transform * Vector3(0.0, gl.front_m(), 0.0)


func _glove_dir(bx: Dictionary, hand: String) -> Vector3:
	var d := _glove_tip(bx, hand) - _bone_world(bx, hand)
	if d.length() < 0.04:
		return Vector3(0, 0, 1)
	return d.normalized()


# ---------------------------------------------------------------- the measured row -------------------------------------------------

func _measure(bx: Dictionary, id: String, finish: Dictionary) -> Dictionary:
	var hand := str(finish.get("hand", "LeftHand"))
	var glove := _bone_world(bx, hand)
	var head := _bone_world(bx, "Head")
	var side := "Left" if hand.begins_with("Left") else "Right"
	var row := {
		"clip": str(finish["clip"]),
		"t": snappedf(float(finish["t"]), 0.001),
		"stand_in": Poses.STAND_IN.get(id, ""),
	}
	if hand.ends_with("Foot"):
		row["reach"] = snappedf(glove.distance_to(_bone_world(bx, "Hips")), 0.001)
	else:
		row["reach"] = snappedf(glove.distance_to(_bone_world(bx, side + "UpperArm")), 0.001)
	var gg := INF
	var hp := INF
	for c in _props.get_children():
		if not c.has_meta("prop_kind"):
			continue
		gg = minf(gg, SPS.prop_gap(glove, c, true))
		hp = minf(hp, SPS.prop_gap(head, c, false))
	if gg < INF:
		row["glove_gap"] = snappedf(gg, 0.001)
	if hp < INF:
		row["head_prop"] = snappedf(hp, 0.001)
	if id == "speed_bag":
		var ball := head
		for c in _props.get_children():
			if str(c.get_meta("prop_kind", "")) == "sphere":
				ball = c.get_meta("prop_c")
				break
		row["ball_below_head"] = snappedf(head.y - ball.y, 0.001)
		row["ball_in_front"] = snappedf(ball.z - head.z, 0.001)
		row["hand_above_chest"] = snappedf(glove.y - _bone_world(bx, "Chest").y, 0.001)
		row["hand_below_eyes"] = snappedf(_eye_y(bx) - glove.y, 0.001)
	if id == "neck":
		row["hand_below_eyes"] = snappedf(_eye_y(bx) - _bone_world(bx, "LeftHand").y, 0.001)
	if id == "heavy_bag":
		for c in _props.get_children():
			if str(c.get_meta("prop_kind", "")) == "cyl":
				row["bag_top"] = snappedf(float((c.get_meta("prop_c") as Vector3).y) + BAG_H * 0.5, 0.001)
		row["head_y"] = snappedf(head.y, 0.001)
	return row


func _eye_y(bx: Dictionary) -> float:
	var skel: Skeleton3D = bx["skel"]
	var l := skel.find_bone("LeftEye")
	var r := skel.find_bone("RightEye")
	if l < 0 or r < 0:
		return _bone_world(bx, "Head").y + 0.10
	return (_bone_world(bx, "LeftEye").y + _bone_world(bx, "RightEye").y) * 0.5