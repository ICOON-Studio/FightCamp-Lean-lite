extends SceneTree
## FIGHTPLAYER2 (S528, C434): bakes the captured boxing steps (scripts/fight3d/v2/StepClips.gd SOURCES, raw Mixamo FBX in
## a folder OUTSIDE the repo) onto our body: RkRetarget (the route the side-step walks used: the take's own floor travel
## on the hips, planted feet held), then TURNED about the hips so the take's feet stand on the guard's own line on its
## first frame (the Mixamo actor stands more side-on than the Punch PRO guard; a step that starts on another line would
## turn the feet at every join). Saved as bare bone tracks, the hips as travel from the body's rest.
## S529 THE REFIT (StepClips.REFIT; film 6, both critics: "a fencing lunge", "stance width jumps", "one stance per man"):
## the Mixamo actor stands 25 % wider and 8 cm lower than the Punch PRO guard and his "short" step is half a metre, so
## every step was a lunge that dipped and came back up. The walking takes are baked a second time ON THE GUARD'S STANCE:
## each foot starts and ends on the guard's own spot under the hips, the hips ride at the guard's height, and the take's
## travel (hips and stepping feet alike) is scaled to a boxing step (StepClips.REFIT: [source, stride]). A foot the actor
## keeps planted stays planted; the legs are solved again (two-bone IK, the knee in the plane it bends in), the foot
## keeps its own turn and height; everything above the hips is the take's own.
## Headless: <godot> --headless --audio-driver Dummy --path . --script res://tools/step_bake.gd -- <src dir> [dry] [refit]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const RkRetarget := preload("res://scripts/fight3d/RkRetarget.gd")
const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const StepClips := preload("res://scripts/fight3d/v2/StepClips.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const GUARD := "pro_idle"

var skel: Skeleton3D
var ap: AnimationPlayer


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var src := str(args[0]) if args.size() > 0 else "E:/FightCamp/packs/mixamo_steps"
	var dry := args.has("dry")
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	Orbit.strip_modifiers(skel)
	var lib: AnimationLibrary = ap.get_animation_library("")
	var prefix := str(ap.get_node(ap.root_node).get_path_to(skel))
	var rest: Vector3 = skel.get_bone_rest(skel.find_bone("Hips")).origin
	var want := _feet_line(GUARD)
	var want_face := _facing(GUARD)
	DirAccess.make_dir_recursive_absolute(StepClips.DIR)
	var done := 0
	for stem in StepClips.SOURCES:
		if args.has("refit"):   # only the refitted walking takes (the takes as bought are not written again)
			done += 1
			continue
		var name := str(StepClips.SOURCES[stem])
		var path := src.path_join(str(stem) + ".fbx")
		var anim := RkRetarget.build(skel, path, 0.0, 999.0, true)
		if anim == null:
			print("STEPBAKE MISSING ", path)
			continue
		# measure the take's own feet line on our body, then turn it onto the guard's
		var probe := anim.duplicate(true) as Animation
		for t in probe.get_track_count():
			probe.track_set_path(t, NodePath("%s:%s" % [prefix, str(probe.track_get_path(t))]))
		lib.add_animation("_probe", probe)
		var yaw := rad_to_deg(angle_difference(_feet_line("_probe"), want))
		var face_off := rad_to_deg(angle_difference(_facing("_probe"), want_face))
		lib.remove_animation("_probe")
		RkClips.turn(anim, skel, yaw)
		for t in anim.get_track_count():
			if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
				for k in anim.track_get_key_count(t):
					anim.track_set_key_value(t, k, (anim.track_get_key_value(t, k) as Vector3) - rest)
		anim.loop_mode = Animation.LOOP_NONE
		anim.set_meta("step_yaw_deg", yaw)
		print("STEPBAKE %s <- %s  %.2f s  turned %.1f deg (the hips then face %.1f deg off the guard's)" % [name, stem, anim.length, yaw, face_off - yaw])
		if not dry:
			var err := ResourceSaver.save(anim, StepClips.DIR + name + ".res")
			if err != OK:
				print("STEPBAKE SAVE FAIL ", name, " ", err)
				continue
		done += 1
	var guard := _stance(GUARD, 0.0)
	var fit := 0
	for name in StepClips.REFIT:
		var stem := str(StepClips.REFIT[name][0])
		var stride := float(StepClips.REFIT[name][1])
		var raw := RkRetarget.build(skel, src.path_join(stem + ".fbx"), 0.0, 999.0, true)
		if raw == null:
			print("STEPBAKE MISSING ", stem)
			continue
		var probe := raw.duplicate(true) as Animation
		for t in probe.get_track_count():
			probe.track_set_path(t, NodePath("%s:%s" % [prefix, str(probe.track_get_path(t))]))
		lib.add_animation("_probe", probe)
		var yaw := rad_to_deg(angle_difference(_feet_line("_probe"), want))
		lib.remove_animation("_probe")
		RkClips.turn(raw, skel, yaw)
		print("STEPBAKE %s <- %s x %.2f" % [name, stem, stride])
		var anim := _refit(raw, lib, prefix, stride, guard)
		for t in anim.get_track_count():
			if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
				for k in anim.track_get_key_count(t):
					anim.track_set_key_value(t, k, (anim.track_get_key_value(t, k) as Vector3) - rest)
		anim.loop_mode = Animation.LOOP_NONE
		anim.set_meta("step_yaw_deg", yaw)
		anim.set_meta("stride", stride)
		if not dry and ResourceSaver.save(anim, StepClips.DIR + str(name) + ".res") != OK:
			print("STEPBAKE SAVE FAIL ", name)
			continue
		fit += 1
	print("STEPBAKE DONE %d of %d, refit %d of %d -> %s" % [done, StepClips.SOURCES.size(), fit, StepClips.REFIT.size(), StepClips.DIR])
	quit(0 if done == StepClips.SOURCES.size() and fit == StepClips.REFIT.size() else 1)


const LEGS := [["LeftUpperLeg", "LeftLowerLeg", "LeftFoot"], ["RightUpperLeg", "RightLowerLeg", "RightFoot"]]
## The refit never straightens a leg past this share of its length (knee about 152 deg; the guard holds 150 / 145): the hips come
## down instead, and that sink is smoothed over the take (SINK_F pictures each way at 60 a second) - solved picture by
## picture the first refit left the lead leg at its reach until its foot lifted, then bent it 13 deg in one picture.
const REACH := 0.97
const SINK_F := 6


## The hips and both ankles of `clip` at `t` (skeleton space).
func _stance(clip: String, t: float) -> Dictionary:
	ap.play(clip)
	ap.seek(t, true)
	return {"hips": skel.get_bone_global_pose(skel.find_bone("Hips")).origin,
		"feet": [skel.get_bone_global_pose(skel.find_bone("LeftFoot")).origin, skel.get_bone_global_pose(skel.find_bone("RightFoot")).origin]}


## `raw` (bare tracks, the hips carrying the floor travel) on the guard's stance, its travel x `stride`.
func _refit(raw: Animation, lib: AnimationLibrary, prefix: String, stride: float, guard: Dictionary) -> Animation:
	var probe := raw.duplicate(true) as Animation
	for t in probe.get_track_count():
		probe.track_set_path(t, NodePath("%s:%s" % [prefix, str(probe.track_get_path(t))]))
	lib.add_animation("_probe", probe)
	var hips := skel.find_bone("Hips")
	var parent := skel.get_bone_parent(hips)
	var ids: Array = []
	var drop: Array = []
	for leg in LEGS:
		ids.append((leg as Array).map(func(b): return skel.find_bone(str(b))))
		drop.append_array(leg)
	var out := raw.duplicate(true) as Animation
	for t in range(out.get_track_count() - 1, -1, -1):
		var bone := str(out.track_get_path(t))
		if (bone == "Hips" and out.track_get_type(t) == Animation.TYPE_POSITION_3D) or drop.has(bone):
			out.remove_track(t)
	var pos_t := out.add_track(Animation.TYPE_POSITION_3D)
	out.track_set_path(pos_t, NodePath("Hips"))
	var rot_t := {}
	for leg in ids:
		for b in leg:
			rot_t[b] = out.add_track(Animation.TYPE_ROTATION_3D)
			out.track_set_path(rot_t[b], NodePath(skel.get_bone_name(int(b))))
	var s0 := _stance("_probe", 0.0)
	var h0: Vector3 = s0["hips"]
	var gh: Vector3 = guard["hips"]
	var o: Array = [(s0["feet"][0] as Vector3) - h0, (s0["feet"][1] as Vector3) - h0]
	var g: Array = [(guard["feet"][0] as Vector3) - gh, (guard["feet"][1] as Vector3) - gh]
	# the hips as high over the ankles as the guard holds them
	var up: float = (gh.y - ((guard["feet"][0] as Vector3).y + (guard["feet"][1] as Vector3).y) * 0.5) - (h0.y - ((s0["feet"][0] as Vector3).y + (s0["feet"][1] as Vector3).y) * 0.5)
	var dip := minf(stride, 1.0)   # a shorter step sinks less
	var n := int(round(raw.length * 60.0))
	var spread := Vector2.ZERO
	var pinv: Transform3D = skel.get_bone_global_pose(parent).affine_inverse() if parent >= 0 else Transform3D.IDENTITY
	# pass 1: where the hips and the ankles go, and how far the hips must sink for the legs to reach
	var frames: Array = []
	var sink: Array = []
	for k in n + 1:
		var t := minf(float(k) / 60.0, raw.length)
		var st := _stance("_probe", t)
		var h: Vector3 = st["hips"]
		var hn := Vector3(h0.x + stride * (h.x - h0.x), h0.y + up + dip * (h.y - h0.y), h0.z + stride * (h.z - h0.z))
		var to: Array = []
		for i in 2:
			var a: Vector3 = st["feet"][i]
			var gi: Vector3 = g[i]
			var oi: Vector3 = o[i]
			to.append(Vector3(h0.x + gi.x + stride * (a.x - h0.x - oi.x), a.y, h0.z + gi.z + stride * (a.z - h0.z - oi.z)))
		var f0: Vector3 = st["feet"][0]
		var f1: Vector3 = st["feet"][1]
		spread.x = maxf(spread.x, Vector2(f0.x - f1.x, f0.z - f1.z).length())
		spread.y = maxf(spread.y, Vector2((to[0] as Vector3).x - (to[1] as Vector3).x, (to[0] as Vector3).z - (to[1] as Vector3).z).length())
		var need := 0.0
		for tries in 12:
			skel.set_bone_pose_position(hips, pinv * (hn + Vector3.DOWN * need))
			var far := 0.0
			for i in 2:
				var a := skel.get_bone_global_pose(int(ids[i][0])).origin
				var knee := skel.get_bone_global_pose(int(ids[i][1])).origin
				var leg_m := (knee - a).length() + (skel.get_bone_global_pose(int(ids[i][2])).origin - knee).length()
				far = maxf(far, ((to[i] as Vector3) - a).length() - REACH * leg_m)
			if far <= 0.0:
				break
			need += far + 0.002
		frames.append({"t": t, "hips": hn, "to": to})
		sink.append(need)
	# the sink as a smooth curve that covers every picture's need (the widest need nearby, then averaged)
	var wide: Array = []
	for k in sink.size():
		var m := 0.0
		for j in range(maxi(k - SINK_F, 0), mini(k + SINK_F, sink.size() - 1) + 1):
			m = maxf(m, float(sink[j]))
		wide.append(m)
	var lowered := 0.0
	# pass 2: the legs solved under the sunk hips
	for k in frames.size():
		var fr: Dictionary = frames[k]
		var sum := 0.0
		var cnt := 0
		for j in range(maxi(k - SINK_F, 0), mini(k + SINK_F, wide.size() - 1) + 1):
			sum += float(wide[j])
			cnt += 1
		var down := sum / cnt
		lowered = maxf(lowered, down)
		_stance("_probe", float(fr["t"]))
		var hn: Vector3 = (fr["hips"] as Vector3) + Vector3.DOWN * down
		skel.set_bone_pose_position(hips, pinv * hn)
		for i in 2:
			_solve(ids[i], fr["to"][i])
		out.position_track_insert_key(pos_t, float(fr["t"]), pinv * hn)
		for leg in ids:
			for b in leg:
				out.rotation_track_insert_key(rot_t[b], float(fr["t"]), skel.get_bone_pose_rotation(int(b)))
	lib.remove_animation("_probe")
	var gspread := Vector2((g[0] as Vector3).x - (g[1] as Vector3).x, (g[0] as Vector3).z - (g[1] as Vector3).z).length()
	print("STEPBAKE   refit: hips %+.3f m, feet apart at most %.2f -> %.2f m (the guard %.2f), hips lowered for reach at most %.3f m, %d frames" % [
		up, spread.x, spread.y, gspread, lowered, n + 1])
	return out


## Two-bone IK in the skeleton's space (FootPlant._solve): the ankle onto `t`, the knee bending in the plane it bends in
## now, the foot keeping the turn the take gave it.
func _solve(ids: Array, t: Vector3) -> void:
	var ga := skel.get_bone_global_pose(ids[0])
	var gb := skel.get_bone_global_pose(ids[1])
	var gc := skel.get_bone_global_pose(ids[2])
	var a := ga.origin
	var b := gb.origin
	var c := gc.origin
	var lab := (b - a).length()
	var lcb := (c - b).length()
	if lab < 1e-5 or lcb < 1e-5 or (c - a).length() < 1e-5 or (t - a).length() < 1e-5:
		return
	var lat := clampf((t - a).length(), absf(lab - lcb) + 1e-4, lab + lcb - 1e-4)
	var ac_ab_0 := acos(clampf((c - a).normalized().dot((b - a).normalized()), -1.0, 1.0))
	var ba_bc_0 := acos(clampf((a - b).normalized().dot((c - b).normalized()), -1.0, 1.0))
	var ac_at_0 := acos(clampf((c - a).normalized().dot((t - a).normalized()), -1.0, 1.0))
	var ac_ab_1 := acos(clampf((lcb * lcb - lab * lab - lat * lat) / (-2.0 * lab * lat), -1.0, 1.0))
	var ba_bc_1 := acos(clampf((lat * lat - lab * lab - lcb * lcb) / (-2.0 * lab * lcb), -1.0, 1.0))
	var axis0 := (c - a).cross(b - a)
	if axis0.length() < 1e-6:
		return
	axis0 = axis0.normalized()
	var r0 := Quaternion(axis0, ac_ab_1 - ac_ab_0)
	var r1 := Quaternion(axis0, ba_bc_1 - ba_bc_0)
	var axis1 := (c - a).cross(t - a)
	var r2 := Quaternion(axis1.normalized(), ac_at_0) if axis1.length() > 1e-6 else Quaternion.IDENTITY
	var qa := ga.basis.get_rotation_quaternion()
	var qb := gb.basis.get_rotation_quaternion()
	var qc := gc.basis.get_rotation_quaternion()
	var qa1 := r2 * r0 * qa
	var qb1 := r2 * r1 * r0 * qb
	var par := skel.get_bone_parent(ids[0])
	var qp := skel.get_bone_global_pose(par).basis.get_rotation_quaternion() if par >= 0 else Quaternion.IDENTITY
	skel.set_bone_pose_rotation(ids[0], (qp.inverse() * qa1).normalized())
	skel.set_bone_pose_rotation(ids[1], (qa1.inverse() * qb1).normalized())
	skel.set_bone_pose_rotation(ids[2], (qb1.inverse() * qc).normalized())


## The line from the rear (right) ankle to the lead (left) ankle on the take's first frame, as an angle about +Y.
func _feet_line(clip: String) -> float:
	ap.play(clip)
	ap.seek(0.0, true)
	var w := skel.global_transform
	var d: Vector3 = w * skel.get_bone_global_pose(skel.find_bone("LeftFoot")).origin - w * skel.get_bone_global_pose(skel.find_bone("RightFoot")).origin
	return atan2(d.x, d.z)


func _facing(clip: String) -> float:
	ap.play(clip)
	ap.seek(0.0, true)
	var b := (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Hips"))).basis.orthonormalized()
	return atan2(b.z.x, b.z.z)
