extends SceneTree
const Drift := preload("res://tools/orbit_drift.gd")   # S379 operator: "the camera spins too fast ... got me dizzy"
## S379 the board's Grappling animations page (operator: "i want to see the progress on animations on board, make a new
## one for the grappling animations"): each GrappleMap move the belt match plays, PURE - the recorded data on our two
## women and nothing laid on top: main's S335 GrapplePlayer (Catmull-Rom between the data's keyframes, GrappleTiming's
## pace), the per-frame push-out OFF (`contact = false`), GrapplePose's wrist/ankle IK OFF and no GrappleGrip (the S379
## audit's `nolayers` arm - the idle hump, routed waypoints and finish of claude/bjj9base are not on main at all).
## The pair alone on the boxing page's grey grid (clip_orbit.gd's studio), a camera circling once; the move plays once
## and holds its last frame (no loop cut inside a measured play); a move over PLAY_MAX_S plays evenly faster to fit.
## Frames -> <out>/<id>/f0000.jpg in a fixed 960x540 SubViewport; ops/Tools/lean_grapple_render.py encodes each to an mp4.
## While it films it MEASURES the women AS DRAWN (bones read on Skeleton3D.skeleton_updated, after GrapplePose - the S307
## trap; tools/bjj_tremble_probe.gd's definitions on claude/bjj9base):
##   jerk  the third difference of each tracked bone at 30 fps in m/s^3, p95 pooled over both women (S379: clean S335 film
##         code 44, the r10 match with its layers 1312)
##   flips velocity direction reversals per second per bone (steps over 0.5 mm turning more than 90 deg; 0.05 vs 3.75)
##   spike the worst one-frame step that is over SPIKE_X times both its neighbours (a pop), metres
##   overlap capsules on the drawn bones: either woman's limbs, head and neck into the other's pelvis + trunk; peak depth
##         in metres and the frames deeper than 6 cm (bodies inside bodies)
## S399 GRAPPLEFIX1 `game=1`: the move AS THE BELT MATCH DRAWS IT - GrapplePlayer with `contact` on (GrappleDrawn's placement,
## GrappleLimbs' clearance and holds), GrapplePose's IK on, GrappleGrip's fingers, the browser's pacing (GrappleBrowser.play_out:
## a takedown/sweep lands in LANDS_S, a plain move is shaped to at most MOVE_MAX_S). The layers step a fixed 1/30 s a frame
## (GrapplePlayer.step_dt), settle SETTLE_F frames on the first pose, and start from the recording (reset_layers). An id may carry
## `r` (played reversed) and `l` (a landing: takedown or sweep), e.g. ids=1295r,1470l. `nofilm=1`: numbers only, no frames
## saved (runs headless). Extra numbers per move (GrappleDrawn.parts, the placement's own body model):
##   torso_in_m   the deepest torso (pelvis/trunk) inside the other's torso, and frames past 6 cm
##   limb_park_m  the deepest a limb or head stays inside the other's torso or head for a run over 0.2 s (the worst
##                limb's depth held for PARK_F frames in a row), and which one
## One `GORBIT_JSON {...}` line per move.
##   python tools/hidden_desktop.py run --timeout=1800 <godot.exe> --path . --windowed --resolution 960x540 \
##       --audio-driver Dummy --script res://tools/grapple_orbit.gd -- out=<dir> ids=<GrappleMap sequence index,...>

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const GD := preload("res://scripts/grapple/GrappleDrawn.gd")
const Grip := preload("res://scripts/grapple/GrappleGrip.gd")
const Timing := preload("res://scripts/grapple/GrappleTiming.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const Browser := preload("res://scripts/grapple/GrappleBrowser.gd")
const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")
const Pose := preload("res://scripts/grapple/GrapplePose.gd")
const Player := preload("res://scripts/grapple/GrapplePlayer.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const Kit := preload("res://scripts/fight3d/FighterKit.gd")
## The browser's two women and their colours (GrappleBrowser.gd: BODIES / TOPS / TRUNKS / TRIM_DARKEN).
const BODIES := ["res://assets/models/metahuman/mh_boxer_11.glb", "res://assets/models/metahuman/mh_boxer_10.glb"]
const TOPS := [Color("#ff6a5c"), Color("#5b93ff")]
const TRUNKS := [Color("#e2483d"), Color("#2f6fdb")]
const TRIM_DARKEN := 0.45
const W := 960
const H := 540
const FPS := 30.0
const HOLD_S := 0.8
const MIN_S := 4.0
const MAX_S := 9.0
const GAME_MIN_S := 1.5
## S399 GRAPPLEFIX1 joins (operator: "what matters is the sequence blending"): `chain=<id>,<id>,...` plays the moves back to back
## the way GrappleBrowser does in the belt match - a move lands, its landed POSITION holds HUB_S (go_position: two frames of the
## position laid on the pose on screen), the next move is laid on the pose on screen (Graph.align + Graph.placed) and paced as
## play_out paces it (a fall from standing lands in LANDS_S, a plain move is shaped to at most MOVE_MAX_S). Every join measured
## around JOIN_PRE..JOIN_POST frames: the pose mismatch the curve absorbs, the worst velocity snap, pops, the deepest limb and
## torso during the blend; the whole film's longest still stretch. `cam=fixed` holds one broadcast angle (default: a slow orbit).
## The match moves again HOLD_GAP_S after a landed move (BeltMatch._act: `_wait = 0.5` after a hit), while the landed position's
## own hold (GrappleBrowser.HUB_S) is still easing in.
const HOLD_GAP_S := 0.5
const JOIN_PRE := 9
const JOIN_POST := 18
const ORBIT_DEG_S := 6.0
const CHAIN_RADIUS := 3.0
const STILL_MS := 0.02   # every tracked bone slower than this (m/s) = the pair stands still
## GrappleMap stores no timing (GrappleTiming paces it): a move longer than PLAY_MAX_S plays faster, evenly, so the whole
## move fits a short preview (the belt match itself caps a move at 4 s and lands a takedown in 1.9 s).
const PLAY_MAX_S := 6.0
## The camera fits the move: far enough that the pair's widest reach over the move and its tallest point stay in frame.
const RADIUS_MIN := 2.1
const FOLLOW_S := 0.6   # S379: the camera eases after the pair's centre with this lag (a travelling move stays framed)
const FIT_MARGIN := 1.5
const ELEVATION_DEG := 24.0
const V_MIN := 0.0005
const SPIKE_X := 3.0
const DEEP_M := 0.06
const SETTLE_F := 15
const PARK_F := 7   # frames: a limb inside for longer than 0.2 s at 30 fps
const LIMB_KEYS := ["head", "face", "neck", "upperarmL", "upperarmR", "forearmL", "forearmR", "thighL", "thighR", "shinL", "shinR",
	"footL", "footR"]
const BODY_KEYS := ["pelvis", "trunk", "head", "face"]
## S399 operator: GrappleMap's own figures have volume and do not overlap in its viewer. The SOURCE figure measured the same way:
## its joints as played (joints_at), with the viewer's own thickness (Eelis/GrappleMap src/positions.cpp jointDefs radii: Head 0.11,
## Core 0.1, hips 0.09, shoulders 0.08, knees 0.05, elbows 0.045, ankles 0.03; src/players.hpp limbs() midpoint radii: thigh 0.085,
## shin 0.055, forearm 0.03, neck 0.05), scaled with the pair. Its torso is no tube, only the core, hip and shoulder spheres: capsules
## between them at the smaller sphere's radius.
const SRC_TORSO := [["Core", "LeftHip", 0.09], ["Core", "RightHip", 0.09], ["LeftHip", "RightHip", 0.09], ["Core", "Neck", 0.08],
	["LeftShoulder", "RightShoulder", 0.08], ["Core", "LeftShoulder", 0.08], ["Core", "RightShoulder", 0.08]]
const SRC_HEAD := [["Head", "Head", 0.11]]
const SRC_LIMBS := [["head", "Head", "Head", 0.11], ["neck", "Neck", "Head", 0.05], ["upperarmL", "LeftShoulder", "LeftElbow", 0.0625],
	["upperarmR", "RightShoulder", "RightElbow", 0.0625], ["forearmL", "LeftElbow", "LeftWrist", 0.03], ["forearmR", "RightElbow", "RightWrist", 0.03],
	["thighL", "LeftHip", "LeftKnee", 0.085], ["thighR", "RightHip", "RightKnee", 0.085], ["shinL", "LeftKnee", "LeftAnkle", 0.055],
	["shinR", "RightKnee", "RightAnkle", 0.055], ["footL", "LeftHeel", "LeftToe", 0.0275], ["footR", "RightHeel", "RightToe", 0.0275]]
const TRACK := ["LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftFoot", "RightFoot", "LeftLowerLeg",
	"RightLowerLeg", "Head", "Hips"]
const BONES := ["Hips", "Spine", "Neck", "Head", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
	"LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot",
	"LeftToes", "RightToes"]
## The other woman's parts [bone a, bone b, radius] tested against a torso (bjj_tremble_probe.gd's mesh-true radii).
const PARTS := [["Head", "Head", 0.11], ["Neck", "Head", 0.07], ["LeftUpperArm", "LeftLowerArm", 0.06],
	["RightUpperArm", "RightLowerArm", 0.06], ["LeftLowerArm", "LeftHand", 0.045], ["RightLowerArm", "RightHand", 0.045],
	["LeftUpperLeg", "LeftLowerLeg", 0.10], ["RightUpperLeg", "RightLowerLeg", 0.10], ["LeftLowerLeg", "LeftFoot", 0.065],
	["RightLowerLeg", "RightFoot", 0.065], ["LeftFoot", "LeftToes", 0.068], ["RightFoot", "RightToes", 0.068]]
const TORSO := [["LeftUpperLeg", "RightUpperLeg", 0.118], ["Spine", "Neck", 0.12]]
const GRID_SHADER := """
shader_type spatial;
uniform vec3 base : source_color = vec3(0.46, 0.47, 0.49);
uniform vec3 line : source_color = vec3(0.30, 0.31, 0.33);
uniform vec3 major : source_color = vec3(0.20, 0.21, 0.23);
varying vec3 wp;
void vertex() { wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }
float grid(vec2 p, float step, float w) {
	vec2 g = abs(fract(p / step - 0.5) - 0.5) / fwidth(p / step);
	return 1.0 - clamp(min(g.x, g.y) - w, 0.0, 1.0);
}
void fragment() {
	vec3 c = mix(base, line, grid(wp.xz, 0.25, 0.0));
	c = mix(c, major, grid(wp.xz, 1.0, 0.5));
	ALBEDO = c;
	ROUGHNESS = 0.95;
}
"""

var out_dir := "user://grapple_orbit"
var _cache: Array = [{}, {}]
var game := false
var nofilm := false
var noik := false
var chain: Array = []
var fixed_cam := false
var _dbg: Array = []   # `debugcaps=1`: GrappleDrawn.parts drawn as translucent capsules over the women (S399 critic check)


func _initialize() -> void:
	var ids: Array = []
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("out="):
			out_dir = s.substr(4)
		elif s.begins_with("ids="):
			ids = Array(s.substr(4).split(",", false))
		elif s == "game=1":
			game = true
		elif s == "nofilm=1":
			nofilm = true
		elif s == "noik=1":
			noik = true
		elif s.begins_with("chain="):
			chain = Array(s.substr(6).split(",", false))
			game = true
		elif s == "cam=fixed":
			fixed_cam = true
	var rows: Array = await measure(chain if not chain.is_empty() else ids)
	print("GORBIT DONE %d/%d" % [rows.size(), ids.size()])
	quit(0)


## Builds the studio and the two women, then films and/or measures each move: one row of numbers per move found (also printed
## as a GORBIT_JSON line). tests/grapple_fix_test.gd calls it with `game` and `nofilm` set.
func measure(ids: Array) -> Array:
	var rows: Array = []
	# The picture is a fixed 960x540 SubViewport: the hidden desktop's window comes out 960x504 (S379 726da2ef).
	var vp := SubViewport.new()
	vp.size = Vector2i(W, H)
	vp.msaa_3d = Viewport.MSAA_4X
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var world := Node3D.new()
	vp.add_child(world)
	_studio(world)
	var cam := Camera3D.new()
	cam.fov = 45.0
	world.add_child(cam)
	cam.current = true
	var poses: Array = []
	var legs: Array = []
	var skels: Array = []
	for i in 2:
		var body := MH.load_fighter(BODIES[i])
		world.add_child(body)
		MH.colour_trunks(body, TRUNKS[i])
		Kit.colour_vest(body, TOPS[i], 0.8)
		_mma_trim(body, TRUNKS[i].darkened(TRIM_DARKEN))
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var pose: Node = Pose.attach(skel)
		pose.set("ik", game and not noik)
		if game:
			pose.set("step_dt", 1.0 / FPS)
		poses.append(pose)
		skels.append(skel)
		var sw := skel.global_transform
		legs.append((sw * skel.get_bone_global_rest(skel.find_bone("LeftUpperLeg")).origin).distance_to(
			sw * skel.get_bone_global_rest(skel.find_bone("LeftFoot")).origin))
		_watch(skel, i)
	var player: Node = Player.new()
	player.set("contact", game)
	if game:
		# The browser's player: in the tree, so its layers run; paused, so only seek() moves it (one fixed step a frame).
		player.set("paused", true)
		player.set("step_dt", 1.0 / FPS)
		root.add_child(player)
		player.set("men", poses)
		for i in 2:
			Grip.attach(skels[i], poses[i], poses[1 - i])
	var db: Array = DB.load_db()
	await process_frame
	if not chain.is_empty():
		rows.append(await _chain(chain, db, player, poses, legs, cam, vp))
		return rows
	for id in ids:
		var tok := str(id)
		var rev := game and tok.contains("r")
		var lands := game and tok.contains("l")
		var idx := int(tok.rstrip("rl"))
		if idx < 0 or idx >= db.size() or not DB.is_transition(db[idx]):
			print("GORBIT MISSING ", id)
			continue
		var seq: Dictionary = db[idx]
		if game:
			var g := seq.duplicate()
			if rev:
				var fr: Array = (seq["frames"] as Array).duplicate()
				fr.reverse()
				g["frames"] = fr
			if player.has_method("reset_layers"):
				player.reset_layers()
			player.set("step_dt", 1.0 / FPS)
			player.play(g, poses, Player.pair_scale(legs), Transform3D.IDENTITY)
			var placed: Array = player.seq["frames"]
			player.play_frames(placed, Browser.move_times(placed, lands))
			for _s in SETTLE_F:
				player.seek(0.0)
				await _frame()
		else:
			player.play(seq, poses, Player.pair_scale(legs), Transform3D.IDENTITY)
		var length: float = player.length_s()
		var speed := maxf(1.0, length / PLAY_MAX_S)
		var shown := length / speed
		# S399: the game arm films the move and a short hold, not a 4 s clip padded with a frozen last frame (every blind critic
		# scored that freeze as "mannequin": 688 moves for 0.54 s and then stood still for 3.5 s).
		var total := clampf(shown + HOLD_S, GAME_MIN_S if game else MIN_S, MAX_S)
		var frames := int(ceil(total * FPS))
		var fit := _fit(player, length)
		var look: Vector3 = fit[0]
		var radius: float = fit[1]
		var core := DB.joint("Core")
		var follow := look
		var dir := out_dir.path_join(str(idx) + ("r" if rev else ""))
		if not nofilm:
			DirAccess.make_dir_recursive_absolute(dir)
		var tracks: Array = []   # per woman, per TRACK bone: an Array of Vector3 over the measured frames (Arrays, not
		for w in 2:              # PackedVector3Array: a packed array read out of an Array is a copy, appends would be lost)
			var per: Array = []
			for _b in TRACK:
				per.append([])
			tracks.append(per)
		var ov := PackedFloat32Array()
		var tin := PackedFloat32Array()
		var limb_depth := {}
		for k in LIMB_KEYS:
			limb_depth[k] = PackedFloat32Array()
		var src_tin := PackedFloat32Array()
		var src_depth := {}
		for k in LIMB_KEYS:
			src_depth[k] = PackedFloat32Array()
		var rad_k := float(Player.pair_scale(legs))
		var measured := int(ceil(minf(shown, total) * FPS)) + 1
		# One unrecorded settle frame so the first saved frame already shows this move's first pose.
		if game:
			player.set("step_dt", speed / FPS)
			for pz in poses:
				pz.set("step_dt", speed / FPS)
		player.seek(0.0)
		await _frame()
		if nofilm:
			frames = mini(frames, measured)
		for f in frames:
			var t := minf(float(f) / FPS * speed, length)
			player.seek(t)
			var ang := deg_to_rad(35.0) + Drift.angle(f, frames, FPS)
			var flat := radius * cos(deg_to_rad(ELEVATION_DEG))
			var js_now: Array = player.joints_at(t)
			var c_now: Vector3 = ((js_now[0] as PackedVector3Array)[core] + (js_now[1] as PackedVector3Array)[core]) * 0.5
			follow = Vector3(c_now.x, look.y, c_now.z) if f == 0 else follow.lerp(Vector3(c_now.x, look.y, c_now.z), 1.0 - exp(-1.0 / (FPS * FOLLOW_S)))
			cam.look_at_from_position(follow + Vector3(sin(ang) * flat, radius * sin(deg_to_rad(ELEVATION_DEG)), cos(ang) * flat),
				follow, Vector3.UP)
			if OS.get_cmdline_user_args().has("debugcaps=1"):
				_draw_caps(world)
			await _frame()
			if game and OS.get_cmdline_user_args().has("trace=1"):
				var pl: Dictionary = player.get("_place")
				var ps: Dictionary = player.get("_place_shown")
				print("GTRACE %d rel %s shown %s lift %.3f shown_lift %.3f pen %.3f" % [f, str((pl["rel"] as Vector3).snapped(Vector3.ONE * 0.001)),
					str((ps["rel"] as Vector3).snapped(Vector3.ONE * 0.001)), float(pl["lift"]), (ps["lift"] as Vector3).y, float(pl.get("pen", 0.0))])
			for ua in OS.get_cmdline_user_args():
				if str(ua).begins_with("bone="):
					var bw := 1 if str(ua).contains("blue") else 0
					var bn := str(ua).substr(5).replace("blue", "").replace("red", "")
					var pu: Vector3 = _cache[bw].get(bn.replace("Lower", "Upper"), Vector3.ZERO)
					var pl: Vector3 = _cache[bw].get(bn, Vector3.ZERO)
					var ph: Vector3 = _cache[bw].get(bn.replace("LowerArm", "Hand").replace("LowerLeg", "Foot"), Vector3.ZERO)
					print("BTRACE %d mid %s end %s straight %.3f" % [f, str(pl.snapped(Vector3.ONE * 0.001)), str(ph.snapped(Vector3.ONE * 0.001)),
						(pl - pu).normalized().dot((ph - pl).normalized())])
			if OS.get_cmdline_user_args().has("facedbg=1") and f % 3 == 0:
				for w in 2:
					var me: Dictionary = _cache[w]
					var ot: Dictionary = _cache[1 - w]
					if not me.has("Face"):
						continue
					var line := "FACEDBG %d %s face-head %.3f" % [f, ["red", "blue"][w], (me["Face"] as Vector3).distance_to(me["Head"])]
					for seg in [["LeftUpperLeg", "LeftLowerLeg", 0.10], ["RightUpperLeg", "RightLowerLeg", 0.10]]:
						var cp := Geometry3D.get_closest_point_to_segment(me["Face"], ot[seg[0]], ot[seg[1]])
						line += " | other %s gap %.3f" % [seg[0], (me["Face"] as Vector3).distance_to(cp) - 0.07 - float(seg[2])]
					print(line)
			if game and OS.get_cmdline_user_args().has("ltrace=1"):
				var lm: Dictionary = player.get("_limbs")
				var line := "LTRACE %d" % f
				for key in ["0LeftArm", "0RightArm", "0LeftLeg", "0RightLeg", "1LeftArm", "1RightArm", "1LeftLeg", "1RightLeg"]:
					var ls: Dictionary = lm.get(key, {})
					var hs: Dictionary = lm.get(key + "Hold", {})
					if ls.is_empty():
						continue
					line += " | %s w%.3f o%.3f h%.2f" % [key, (ls["ease_w"] as Vector3).length(), (ls["ease_o"] as Vector3).length(), float(hs.get("w", 0.0))]
				print(line)
			if not nofilm:
				vp.get_texture().get_image().save_jpg(dir.path_join("f%04d.jpg" % f), 0.88)
			if f < measured:
				for w in 2:
					for k in TRACK.size():
						(tracks[w][k] as Array).append(_cache[w].get(TRACK[k], Vector3.ZERO))
				ov.append(_overlap())
				_inside(tin, limb_depth)
				_src_inside(player.joints_at(t), rad_k, src_tin, src_depth)
		var row := _numbers(tracks, ov, shown)
		_inside_numbers(row, tin, limb_depth)
		var src := {}
		_inside_numbers(src, src_tin, src_depth)
		row["src_torso_in_m"] = src["torso_in_m"]
		row["src_limb_park_m"] = src["limb_park_m"]
		row["src_limb_park_at"] = src["limb_park_at"]
		row["arm"] = "game" if game else "pure"
		row["reverse"] = rev
		row["speed"] = snappedf(speed, 0.01)
		row["id"] = str(idx) + ("r" if rev else "")
		row["title"] = str(seq["title"])
		row["length_s"] = snappedf(length, 0.01)
		row["frames"] = frames
		print("GORBIT_JSON " + JSON.stringify(row))
		rows.append(row)
	return rows


func _draw_caps(world: Node3D) -> void:
	var caps: Array = []
	for w in 2:
		if _cache[w].size() >= GD.BONES.size():
			for c in GD.parts(_cache[w])["all"]:
				caps.append([w, c])
	while _dbg.size() < caps.size():
		var mi := MeshInstance3D.new()
		var m := StandardMaterial3D.new()
		m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		m.no_depth_test = true
		mi.material_override = m
		world.add_child(mi)
		_dbg.append(mi)
	for i in _dbg.size():
		var mi: MeshInstance3D = _dbg[i]
		mi.visible = i < caps.size()
		if not mi.visible:
			continue
		var c: Array = caps[i][1]
		var a: Vector3 = c[1]
		var b: Vector3 = c[2]
		var r := float(c[3])
		var cm := CapsuleMesh.new()
		cm.radius = r
		cm.height = a.distance_to(b) + 2.0 * r
		cm.radial_segments = 12
		cm.rings = 4
		mi.mesh = cm
		(mi.material_override as StandardMaterial3D).albedo_color = Color(1, 1, 0, 0.25) if caps[i][0] == 0 else Color(0, 1, 1, 0.25)
		var mid := (a + b) * 0.5
		var up := (b - a).normalized() if a.distance_to(b) > 1e-4 else Vector3.UP
		var side := up.cross(Vector3.RIGHT if absf(up.dot(Vector3.RIGHT)) < 0.9 else Vector3.FORWARD).normalized()
		mi.global_transform = Transform3D(Basis(side, up, side.cross(up)).orthonormalized(), mid)


## The chain film (see HUB_S). Returns the sequence's own row; prints GJOIN_JSON per join and GSEQ_JSON.
func _chain(toks: Array, db: Array, player: Node, poses: Array, legs: Array, cam: Camera3D, vp: SubViewport) -> Dictionary:
	var graph := Graph.new()
	var label := "chain_" + "_".join(toks)
	var dir := out_dir.path_join(str(toks[0]) + "_chain" + ("_fixed" if fixed_cam else ""))
	if not nofilm:
		DirAccess.make_dir_recursive_absolute(dir)
	var tracks: Array = []
	for w in 2:
		var per: Array = []
		for _b in TRACK:
			per.append([])
		tracks.append(per)
	var tin := PackedFloat32Array()
	var limb_depth := {}
	for k in LIMB_KEYS:
		limb_depth[k] = PackedFloat32Array()
	var joins: Array = []   # [frame, kind, from title, to title, mismatch m]
	var st := {"f": 0, "follow": Vector3.ZERO}
	player.reset_layers()
	player.set("step_dt", 1.0 / FPS)
	for pz in poses:
		pz.set("step_dt", 1.0 / FPS)
	var prev_land: Variant = null
	var prev_title := ""
	for i in toks.size():
		var tok := str(toks[i])
		var rev := tok.contains("r")
		var idx := int(tok.rstrip("rl"))
		var tr: Dictionary = graph.get_entry(idx)
		if idx < 0 or idx >= db.size() or tr.is_empty():
			print("GORBIT MISSING ", tok)
			continue
		var frames: Array = db[idx]["frames"]
		var start_pos: Variant = tr["to"] if rev else tr["from"]
		var land: Variant = tr["from"] if rev else tr["to"]
		var title := Graph.clean(str(db[idx]["title"]))
		var placed: Array
		if i == 0:
			var g := (db[idx] as Dictionary).duplicate()
			if rev:
				var fr: Array = frames.duplicate()
				fr.reverse()
				g["frames"] = fr
			player.play(g, poses, Player.pair_scale(legs), Transform3D.IDENTITY)
			placed = player.seq["frames"]
		else:
			# The landed position's hold first (GrappleBrowser.go_position), then the move.
			if prev_land != null and int(prev_land) >= 0 and int(prev_land) < db.size():
				var pf: Array = db[int(prev_land)]["frames"][0]
				var hub: Array = Graph.placed([pf, pf], Graph.align(player.shown_frame(), pf))
				joins.append([st["f"], "hold", prev_title, Graph.clean(str(db[int(prev_land)]["title"])), _mismatch(player, hub[0])])
				player.play_frames(hub, PackedFloat32Array([0.0, Browser.HUB_S]))
				await _chain_run(player, HOLD_GAP_S, cam, vp, dir, tracks, tin, limb_depth, st)
			var first: Array = frames.back() if rev else frames[0]
			placed = Graph.placed(frames, Graph.align(player.shown_frame(), first), rev)
			joins.append([st["f"], "move", prev_title, title, _mismatch(player, placed[0])])
		var lands := false
		if start_pos != null and land != null:
			lands = BjjMatch.classify(db[int(start_pos)]["tags"]) == "standing" and BjjMatch.classify(db[int(land)]["tags"]) != "standing"
		lands = lands or tok.contains("l")
		player.play_frames(placed, Browser.move_times(placed, lands))
		if i == 0:
			for _s in SETTLE_F:
				player.seek(0.0)
				await _frame()
		await _chain_run(player, float(player.length_s()), cam, vp, dir, tracks, tin, limb_depth, st)
		prev_land = land
		prev_title = title
	# the last position's hold, so the film ends on a settle like the match does
	if prev_land != null and int(prev_land) >= 0 and int(prev_land) < db.size():
		var pf2: Array = db[int(prev_land)]["frames"][0]
		var hub2: Array = Graph.placed([pf2, pf2], Graph.align(player.shown_frame(), pf2))
		joins.append([st["f"], "hold", prev_title, Graph.clean(str(db[int(prev_land)]["title"])), _mismatch(player, hub2[0])])
		player.play_frames(hub2, PackedFloat32Array([0.0, Browser.HUB_S]))
		await _chain_run(player, Browser.HUB_S, cam, vp, dir, tracks, tin, limb_depth, st)
	var n := int(st["f"])
	var row := _numbers(tracks, PackedFloat32Array(), n / FPS)
	_inside_numbers(row, tin, limb_depth)
	# the longest stretch with every tracked bone still
	var still := 0
	var still_best := 0
	var still_at := 0
	for f in range(1, n):
		var fast := 0.0
		for w in 2:
			for k in TRACK.size():
				fast = maxf(fast, ((tracks[w][k][f] as Vector3) - (tracks[w][k][f - 1] as Vector3)).length() * FPS)
		still = still + 1 if fast < STILL_MS else 0
		if still > still_best:
			still_best = still
			still_at = f - still + 1
	row["still_s"] = snappedf(still_best / FPS, 0.01)
	row["still_at_s"] = snappedf(still_at / FPS, 0.01)
	row["id"] = label
	row["frames"] = n
	row["joins"] = joins.size()
	var worst := 0.0
	for jn in joins:
		var jr := _join_numbers(jn, tracks, tin, limb_depth, n)
		print("GJOIN_JSON " + JSON.stringify(jr))
		worst = maxf(worst, float(jr["snap_ms2"]))
	row["worst_join_snap_ms2"] = snappedf(worst, 0.1)
	print("GSEQ_JSON " + JSON.stringify(row))
	return row


## One stretch of the chain at the game's own step, filmed and measured frame by frame.
func _chain_run(player: Node, length: float, cam: Camera3D, vp: SubViewport, dir: String, tracks: Array, tin: PackedFloat32Array,
		limb_depth: Dictionary, st: Dictionary) -> void:
	var core := DB.joint("Core")
	var steps := maxi(1, int(round(length * FPS)))
	for q in steps:
		var t := minf(float(q + 1) / FPS, length)
		player.seek(t)
		var f := int(st["f"])
		var js: Array = player.joints_at(t)
		var c_now: Vector3 = ((js[0] as PackedVector3Array)[core] + (js[1] as PackedVector3Array)[core]) * 0.5
		var target := Vector3(c_now.x, 0.45, c_now.z)
		st["follow"] = target if f == 0 else (st["follow"] as Vector3).lerp(target, 1.0 - exp(-1.0 / (FPS * FOLLOW_S)))
		var ang := deg_to_rad(35.0) + (0.0 if fixed_cam else deg_to_rad(ORBIT_DEG_S) * f / FPS)
		var flat := CHAIN_RADIUS * cos(deg_to_rad(ELEVATION_DEG))
		var fl: Vector3 = st["follow"]
		cam.look_at_from_position(fl + Vector3(sin(ang) * flat, CHAIN_RADIUS * sin(deg_to_rad(ELEVATION_DEG)), cos(ang) * flat), fl, Vector3.UP)
		await _frame()
		if not nofilm:
			vp.get_texture().get_image().save_jpg(dir.path_join("f%04d.jpg" % f), 0.88)
		for ua in OS.get_cmdline_user_args():
			if str(ua).begins_with("bone="):
				var bw := 1 if str(ua).contains("blue") else 0
				var bn := str(ua).substr(5).replace("blue", "").replace("red", "")
				var lkey := "%d%s%s" % [bw, "Right" if bn.begins_with("Right") else "Left", "Arm" if bn.contains("Arm") else "Leg"]
				var ls: Dictionary = (player.get("_limbs") as Dictionary).get(lkey, {})
				var hs: Dictionary = (player.get("_limbs") as Dictionary).get(lkey + "Hold", {})
				print("CTRACE %d %s %s w %s o %s hold %.2f" % [f, bn, str((_cache[bw].get(bn, Vector3.ZERO) as Vector3).snapped(Vector3.ONE * 0.001)),
					str((ls.get("ease_w", Vector3.ZERO) as Vector3).snapped(Vector3.ONE * 0.001)), str((ls.get("ease_o", Vector3.ZERO) as Vector3).snapped(Vector3.ONE * 0.001)),
					float(hs.get("w", 0.0))])
		for w in 2:
			for k in TRACK.size():
				(tracks[w][k] as Array).append(_cache[w].get(TRACK[k], Vector3.ZERO))
		_inside(tin, limb_depth)
		st["f"] = f + 1


## How far the pose on screen sits from the next stretch's first keyframe (what its first curve gap has to absorb), metres.
func _mismatch(player: Node, first: Array) -> float:
	var worst := 0.0
	for m in 2:
		var now: PackedVector3Array = (player.get("men")[m] as Node).get("joints")
		var nxt: PackedVector3Array = player.to_world(first[m])
		for j in mini(now.size(), nxt.size()):
			worst = maxf(worst, now[j].distance_to(nxt[j]))
	return worst


## A join's numbers in the frames around it: the worst velocity snap (second difference, m/s^2), the worst jerk, a pop, and the
## deepest limb and torso while the bodies blend.
func _join_numbers(jn: Array, tracks: Array, tin: PackedFloat32Array, limb_depth: Dictionary, n: int) -> Dictionary:
	var jf := int(jn[0])
	var a := maxi(1, jf - JOIN_PRE)
	var b := mini(n - 2, jf + JOIN_POST)
	var snap := 0.0
	var snap_at := ""
	var jerk := 0.0
	var pop := 0.0
	for w in 2:
		for k in TRACK.size():
			var p: Array = tracks[w][k]
			for f in range(a, b + 1):
				var acc: float = ((p[f + 1] as Vector3) - 2.0 * (p[f] as Vector3) + (p[f - 1] as Vector3)).length() * FPS * FPS
				if acc > snap:
					snap = acc
					snap_at = "%s %s %+.2fs" % [["red", "blue"][w], TRACK[k], (f - jf) / FPS]
				if f >= 2:
					var j3: float = ((p[f + 1] as Vector3) - 3.0 * (p[f] as Vector3) + 3.0 * (p[f - 1] as Vector3) - (p[f - 2] as Vector3)).length()
					jerk = maxf(jerk, j3 * FPS * FPS * FPS)
				var s0: float = (p[f] as Vector3).distance_to(p[f - 1])
				var before: float = (p[f - 1] as Vector3).distance_to(p[maxi(f - 2, 0)])
				var after: float = (p[f + 1] as Vector3).distance_to(p[f])
				if s0 > SPIKE_X * maxf(before, 0.002) and s0 > SPIKE_X * maxf(after, 0.002):
					pop = maxf(pop, s0)
	var limb := 0.0
	var limb_at := ""
	var torso := 0.0
	for f in range(a, b + 1):
		torso = maxf(torso, tin[f])
		for key in limb_depth:
			var d: float = (limb_depth[key] as PackedFloat32Array)[f]
			if d > limb:
				limb = d
				limb_at = str(key)
	return {"frame": jf, "t": snappedf(jf / FPS, 0.01), "kind": jn[1], "from": jn[2], "to": jn[3], "mismatch_m": snappedf(float(jn[4]), 0.001),
		"snap_ms2": snappedf(snap, 0.1), "snap_at": snap_at, "jerk_max": snappedf(jerk, 0.1), "pop_m": snappedf(pop, 0.001),
		"limb_in_m": snappedf(limb, 0.001), "limb_in": limb_at, "torso_in_m": snappedf(torso, 0.001)}


## A frame drawn: the next frame's start in a numbers-only run (the skeleton updates inside the frame seek() ran in), the
## picture's post-draw when filming.
func _frame() -> void:
	if nofilm:
		await process_frame
	else:
		await RenderingServer.frame_post_draw


## This frame's torso-in-torso depth and each limb's depth inside the other's torso or head (both women, GrappleDrawn.parts).
func _inside(tin: PackedFloat32Array, limb_depth: Dictionary) -> void:
	if _cache[0].size() < GD.BONES.size() or _cache[1].size() < GD.BONES.size():
		tin.append(0.0)
		for k in limb_depth:
			var a0: PackedFloat32Array = limb_depth[k]
			a0.append(0.0)
			limb_depth[k] = a0
		return
	var p := [GD.parts(_cache[0]), GD.parts(_cache[1])]
	tin.append(GD.deepest(p[0]["torso"], p[1]["torso"]))
	var by := {}
	for w in 2:
		var body: Array = []
		for c in p[1 - w]["all"]:
			if str(c[0]) in BODY_KEYS:
				body.append(c)
		for c in p[w]["all"]:
			var k := str(c[0])
			if k in LIMB_KEYS:
				by[k] = maxf(float(by.get(k, 0.0)), GD.deepest([c], body))
	for k in limb_depth:
		var arr: PackedFloat32Array = limb_depth[k]
		arr.append(float(by.get(k, 0.0)))
		limb_depth[k] = arr


## The source figure's torso-in-torso and each limb's depth in the other's torso or head this frame (`js` = joints_at, world).
func _src_inside(js: Array, k: float, tin: PackedFloat32Array, depth: Dictionary) -> void:
	var caps := [{}, {}]
	for w in 2:
		var p: PackedVector3Array = js[w]
		var torso: Array = []
		for c in SRC_TORSO:
			torso.append(["t", p[DB.joint(c[0])], p[DB.joint(c[1])], float(c[2]) * k])
		var body: Array = torso.duplicate()
		for c in SRC_HEAD:
			body.append(["h", p[DB.joint(c[0])], p[DB.joint(c[1])], float(c[2]) * k])
		var limbs: Array = []
		for c in SRC_LIMBS:
			limbs.append([c[0], p[DB.joint(c[1])], p[DB.joint(c[2])], float(c[3]) * k])
		caps[w] = {"torso": torso, "body": body, "limbs": limbs}
	tin.append(GD.deepest(caps[0]["torso"], caps[1]["torso"]))
	var by := {}
	for w in 2:
		for c in caps[w]["limbs"]:
			by[c[0]] = maxf(float(by.get(c[0], 0.0)), GD.deepest([c], caps[1 - w]["body"]))
	for key in depth:
		var arr: PackedFloat32Array = depth[key]
		arr.append(float(by.get(key, 0.0)))
		depth[key] = arr


func _inside_numbers(row: Dictionary, tin: PackedFloat32Array, limb_depth: Dictionary) -> void:
	var peak := 0.0
	var deep := 0
	for d in tin:
		peak = maxf(peak, d)
		if d > DEEP_M:
			deep += 1
	var park := 0.0
	var park_at := ""
	for k in limb_depth:
		var arr: PackedFloat32Array = limb_depth[k]
		for i in range(0, arr.size() - PARK_F + 1):
			var lo := INF
			for q in PARK_F:
				lo = minf(lo, arr[i + q])
			if lo > park:
				park = lo
				park_at = "%s %.2fs" % [k, i / FPS]
	row["torso_in_m"] = snappedf(peak, 0.001)
	row["torso_deep_frames"] = deep
	row["limb_park_m"] = snappedf(park, 0.001)
	row["limb_park_at"] = park_at


## Every bone of the women as drawn this frame (after GrapplePose ran), world space.
func _watch(skel: Skeleton3D, who: int) -> void:
	var ids := {}
	for n in BONES:
		ids[n] = skel.find_bone(n)
	skel.skeleton_updated.connect(func() -> void:
		var d := {}
		var gt := skel.global_transform
		for n in BONES:
			if int(ids[n]) >= 0:
				d[n] = gt * skel.get_bone_global_pose(int(ids[n])).origin
		var hb := skel.find_bone("Head")
		if hb >= 0:
			d["Face"] = gt * (skel.get_bone_global_pose(hb) * GD.face_local(skel))
		_cache[who] = d)


## The camera's target and distance for the whole move (steady - no chasing the bodies): the pair's mean core, half its
## tallest point high; far enough for the widest joint (16:9 at 45 deg: half-width tan 36 deg) and the height (tan 22.5).
func _fit(player: Node, length: float) -> Array:
	var c := Vector3.ZERO
	var n := 0
	var core := DB.joint("Core")
	var samples: Array = []
	for k in 9:
		var js: Array = player.joints_at(length * k / 8.0)
		samples.append(js)
		for w in 2:
			c += (js[w] as PackedVector3Array)[core]
			n += 1
	c /= float(n)
	var reach := 0.0
	var top := 0.0
	for js in samples:
		# S379: the camera follows the pair (see FOLLOW_S), so the frame only has to hold the pair's own spread at each
		# moment, not the whole path a travelling move covers (the pair shrank into the distance on takedowns)
		var cs: Vector3 = ((js[0] as PackedVector3Array)[core] + (js[1] as PackedVector3Array)[core]) * 0.5
		for w in 2:
			for p in (js[w] as PackedVector3Array):
				reach = maxf(reach, Vector2(p.x - cs.x, p.z - cs.z).length())
				top = maxf(top, p.y)
	var look := Vector3(c.x, clampf(top * 0.45, 0.25, 0.9), c.z)
	var radius := maxf(RADIUS_MIN, FIT_MARGIN * maxf(reach / tan(deg_to_rad(36.0)), (top * 0.5 + 0.15) / tan(deg_to_rad(22.5))))
	return [look, radius]


## The deepest part of one woman inside the other's pelvis or trunk this frame (both ways), metres.
func _overlap() -> float:
	var worst := 0.0
	for w in 2:
		var me: Dictionary = _cache[w]
		var other: Dictionary = _cache[1 - w]
		if me.is_empty() or other.is_empty():
			continue
		for tc in TORSO:
			if not (other.has(tc[0]) and other.has(tc[1])):
				continue
			for p in PARTS:
				if not (me.has(p[0]) and me.has(p[1])):
					continue
				var cp := Geometry3D.get_closest_points_between_segments(me[p[0]], me[p[1]], other[tc[0]], other[tc[1]])
				worst = maxf(worst, float(p[2]) + float(tc[2]) - cp[0].distance_to(cp[1]))
	return worst


func _numbers(tracks: Array, ov: PackedFloat32Array, length: float) -> Dictionary:
	var jerks := PackedFloat32Array()
	var per_bone: Array = []   # [p95, name] per woman and bone: which bone carries the jerk
	var flips := 0
	var spike := 0.0
	var spike_at := ""
	var n_frames := 0
	for w in 2:
		for k in TRACK.size():
			var p: Array = tracks[w][k]
			n_frames = p.size()
			var mine := PackedFloat32Array()
			for i in range(3, p.size()):
				var j3: Vector3 = (p[i] as Vector3) - 3.0 * (p[i - 1] as Vector3) + 3.0 * (p[i - 2] as Vector3) - (p[i - 3] as Vector3)
				jerks.append(j3.length() * FPS * FPS * FPS)
				mine.append(j3.length() * FPS * FPS * FPS)
			mine.sort()
			if mine.size() > 0:
				per_bone.append([mine[int(mine.size() * 0.95)], "%s %s" % [["red", "blue"][w], TRACK[k]]])
			for i in range(2, p.size()):
				var a: Vector3 = p[i - 1] - p[i - 2]
				var b: Vector3 = p[i] - p[i - 1]
				if a.length() > V_MIN and b.length() > V_MIN and a.dot(b) < 0.0:
					flips += 1
			for i in range(2, p.size() - 1):
				var s: float = (p[i] as Vector3).distance_to(p[i - 1])
				var before: float = (p[i - 1] as Vector3).distance_to(p[i - 2])
				var after: float = (p[i + 1] as Vector3).distance_to(p[i])
				if s > SPIKE_X * maxf(before, 0.002) and s > SPIKE_X * maxf(after, 0.002) and s > spike:
					spike = s
					spike_at = "%s %s %.2fs" % [["red", "blue"][w], TRACK[k], i / FPS]
	jerks.sort()
	var deep := 0
	var peak := 0.0
	for d in ov:
		peak = maxf(peak, d)
		if d > DEEP_M:
			deep += 1
	var secs := maxf(length, 1.0 / FPS)
	per_bone.sort_custom(func(x, y): return float(x[0]) > float(y[0]))
	var worst := []
	for q in mini(4, per_bone.size()):
		worst.append("%s %d" % [per_bone[q][1], int(per_bone[q][0])])
	return {"jerk_worst": ", ".join(worst), "jerk_p95": snappedf(jerks[int(jerks.size() * 0.95)] if jerks.size() > 0 else 0.0, 0.1),
		"flips_s": snappedf(float(flips) / (2.0 * TRACK.size()) / secs, 0.01),
		"spike_m": snappedf(spike, 0.001), "spike_at": spike_at,
		"overlap_peak_m": snappedf(peak, 0.001), "overlap_deep_frames": deep, "measured_frames": n_frames}


## clip_orbit.gd's studio: grey grid floor (it shows a sliding foot), plain backdrop, three-point light.
func _studio(world: Node3D) -> void:
	var floor := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(40, 40)
	floor.mesh = plane
	var mat := ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = GRID_SHADER
	mat.shader = sh
	floor.material_override = mat
	floor.position.y = 0.002
	world.add_child(floor)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.62, 0.64, 0.67)
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color(0.55, 0.56, 0.6)
	env.environment.ambient_light_energy = 0.6
	world.add_child(env)
	for l in [[Vector3(-50, 35, 0), 1.3], [Vector3(-25, -140, 0), 0.55], [Vector3(-15, 160, 0), 0.7]]:
		var d := DirectionalLight3D.new()
		d.rotation_degrees = l[0]
		d.light_energy = l[1]
		d.shadow_enabled = l[1] > 1.0
		world.add_child(d)


## GrappleBrowser._mma_trim: the boxing kit's white trim in the corner's dark shade (MMA shorts and top).
static func _mma_trim(body: Node3D, colour: Color) -> void:
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			var src := mi.mesh.surface_get_material(s)
			if src != null and src.resource_name.begins_with("MH_Trim"):
				var trim := StandardMaterial3D.new()
				trim.albedo_color = colour
				trim.roughness = 0.8
				mi.set_surface_override_material(s, trim)
