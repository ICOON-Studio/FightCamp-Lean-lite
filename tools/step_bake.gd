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
		var anim := _refit(raw, lib, prefix, stride, guard, WAIT_LIFT if str(name) in StepClips.LOOPS else 1.0)
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
## S530 A STANDING FOOT IS FLAT (the owner on film 7: "blues shoes are not stepping normal he is mostly on his toes").
## The bought boxing steps hold the LEAD heel 3-6 cm off the canvas through the whole take (the actor's bouncing
## stance); the Punch PRO guard stands flat, so every step popped the front boot onto its toes for 0.8 s. While a
## foot's toes are on the canvas the refit turns the boot down flat about its ball (the ankle comes down by the heel's
## rise, the toes' own bend goes back to the guard's); it keeps the take's own boot once the toes are TOE_AIR_M up
## (a foot in the air swings as it was captured).
const TOES := ["LeftToes", "RightToes"]
const TOE_DOWN_M := 0.015
const TOE_AIR_M := 0.06
## S531: the bouncing wait lifts its feet 4-7 cm in its shuffles; on film 9 they counted as 25 steps a minute a man
## ("nervous"). In the wait loops a foot leaves the canvas by this share of its captured lift: a bounce, not a shuffle.
const WAIT_LIFT := 0.15


## The hips and both ankles of `clip` at `t` (skeleton space).
func _stance(clip: String, t: float) -> Dictionary:
	ap.play(clip)
	ap.seek(t, true)
	return {"hips": skel.get_bone_global_pose(skel.find_bone("Hips")).origin,
		"feet": [skel.get_bone_global_pose(skel.find_bone("LeftFoot")).origin, skel.get_bone_global_pose(skel.find_bone("RightFoot")).origin],
		"toes": [skel.get_bone_global_pose(skel.find_bone("LeftToes")).origin, skel.get_bone_global_pose(skel.find_bone("RightToes")).origin]}


## `raw` (bare tracks, the hips carrying the floor travel) on the guard's stance, its travel x `stride`.
func _refit(raw: Animation, lib: AnimationLibrary, prefix: String, stride: float, guard: Dictionary, lift: float = 1.0) -> Animation:
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
	drop.append_array(TOES)
	var toe_ids: Array = TOES.map(func(b): return skel.find_bone(str(b)))
	# the guard's flat boot: how high the ankle rides over the toes, where the toes rest, how the toes are bent
	var gs := _stance(GUARD, 0.0)
	var flat: Array = []
	var toe_floor: Array = []
	var toe_rest: Array = []
	for i in 2:
		flat.append((gs["feet"][i] as Vector3).y - (gs["toes"][i] as Vector3).y)
		toe_floor.append((gs["toes"][i] as Vector3).y)
		toe_rest.append(skel.get_bone_pose_rotation(int(toe_ids[i])))
	var flattened := 0.0
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
	for b in toe_ids:
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
		var heel: Array = []   # per foot: how much of the heel's rise comes off this picture (m)
		for i in 2:
			var a: Vector3 = st["feet"][i]
			var gi: Vector3 = g[i]
			var oi: Vector3 = o[i]
			var tip: Vector3 = st["toes"][i]
			var rise := maxf((a.y - tip.y) - float(flat[i]), 0.0)
			var w := 1.0 - smoothstep(TOE_DOWN_M, TOE_AIR_M, tip.y - float(toe_floor[i]))
			heel.append(rise * w)
			flattened = maxf(flattened, rise * w)
			var fy0: float = (s0["feet"][i] as Vector3).y
			var fs: float = stride if lift >= 1.0 else 0.0   # a wait loop keeps its feet on their spots (its shuffles read as steps)
			to.append(Vector3(h0.x + gi.x + fs * (a.x - h0.x - oi.x), fy0 + lift * (a.y - rise * w - fy0), h0.z + gi.z + fs * (a.z - h0.z - oi.z)))
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
		frames.append({"t": t, "hips": hn, "to": to, "heel": heel})
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
			_flatten(ids[i], int(toe_ids[i]), float(fr["heel"][i]), toe_rest[i])
		out.position_track_insert_key(pos_t, float(fr["t"]), pinv * hn)
		for b in toe_ids:
			out.rotation_track_insert_key(rot_t[b], float(fr["t"]), skel.get_bone_pose_rotation(int(b)))
		for leg in ids:
			for b in leg:
				out.rotation_track_insert_key(rot_t[b], float(fr["t"]), skel.get_bone_pose_rotation(int(b)))
	lib.remove_animation("_probe")
	_guard_up(out, lib, prefix)   # every refitted take: the walking steps carried the same long guard (25 % of the round)
	var gspread := Vector2((g[0] as Vector3).x - (g[1] as Vector3).x, (g[0] as Vector3).z - (g[1] as Vector3).z).length()
	print("STEPBAKE   refit: hips %+.3f m, feet apart at most %.2f -> %.2f m (the guard %.2f), hips lowered for reach at most %.3f m, a standing heel brought down at most %.3f m, %d frames" % [
		up, spread.x, spread.y, gspread, lowered, flattened, n + 1])
	return out


## S531 THE GUARD PROTECTS THE HEAD (the owner on film 11: "the guard is supposed to protect the head, your fighters
## holding their hands away from their heads and they look like robots"). Measured on film 11: in the wait the lead
## wrist rides 41 cm from the head bone (31 cm out in front, 14 cm under it), the rear one 31 cm - the bought idle's
## long, low guard. In every refitted take (the wait loops and the walking steps) both wrists come in: their mean place
## over the loop goes to GUARD_AT, the take's own hand motion about that place kept at GUARD_LIVE. The arms are solved again (two-bone IK, the elbow in the plane it
## bends in), the hand keeps its own turn.
const ARMS := [["LeftUpperArm", "LeftLowerArm", "LeftHand"], ["RightUpperArm", "RightLowerArm", "RightHand"]]
## S531 b (the owner on film 12: "you put the blues hands way to back now ... get it from our research"): the first
## version drew each wrist toward the HEAD BONE, which sits at the back of the skull - the gloves ended beside the ears.
## The research (ops/research/D64_GUARD_STYLES.md, the orthodox classic: lead hand at the cheek about 15 cm in front of
## the face, rear hand at the jaw, elbows tucked; ZIVA_GUARD_S274.md: a tucked guard's wrist is 0.21-0.23 m from the
## head bone, measured in the head's frame - in front of, out to the side of, under) puts the gloves IN FRONT of the
## face. GUARD_AT = where each wrist's mean place over the take goes, from the head bone: [in front, out to its own
## side, up] (the wrist rides under its glove: the glove is at the cheek / the jaw). ChoreoRules.GUARD_AT is the same table.
const GUARD_AT := [Vector3(0.21, 0.06, -0.11), Vector3(0.15, 0.08, -0.13)]   # lead (left), rear (right)
const GUARD_LIVE := 0.6


func _guard_up(out: Animation, lib: AnimationLibrary, prefix: String) -> void:
	var probe := out.duplicate(true) as Animation
	for t in probe.get_track_count():
		probe.track_set_path(t, NodePath("%s:%s" % [prefix, str(probe.track_get_path(t))]))
	lib.add_animation("_probe2", probe)
	var head := skel.find_bone("Head")
	var arms: Array = []
	for arm in ARMS:
		arms.append((arm as Array).map(func(b): return skel.find_bone(str(b))))
	var n := int(round(out.length * 60.0))
	var mean: Array = [Vector3.ZERO, Vector3.ZERO]
	for k in n + 1:
		_stance("_probe2", minf(float(k) / 60.0, out.length))
		var h := skel.get_bone_global_pose(head).origin
		for i in 2:
			mean[i] = (mean[i] as Vector3) + (skel.get_bone_global_pose(int(arms[i][2])).origin - h) / float(n + 1)
	for t in range(out.get_track_count() - 1, -1, -1):
		if out.track_get_type(t) == Animation.TYPE_ROTATION_3D and (ARMS[0] + ARMS[1]).has(str(out.track_get_path(t))):
			out.remove_track(t)
	var rot_t := {}
	for arm in arms:
		for b in arm:
			rot_t[b] = out.add_track(Animation.TYPE_ROTATION_3D)
			out.track_set_path(rot_t[b], NodePath(skel.get_bone_name(int(b))))
	# in front = where the take holds its hands from the head, on the canvas (both wrists' mean); his right = fwd x up
	var fwd := Vector3((mean[0] as Vector3).x + (mean[1] as Vector3).x, 0.0, (mean[0] as Vector3).z + (mean[1] as Vector3).z).normalized()
	var right := fwd.cross(Vector3.UP)
	print("STEPBAKE   guard up: the hands are held %.0f deg off the skeleton's +Z" % rad_to_deg(Vector3(0, 0, 1).signed_angle_to(fwd, Vector3.UP)))
	var was := [0.0, 0.0]
	var now := [0.0, 0.0]
	for k in n + 1:
		var t := minf(float(k) / 60.0, out.length)
		_stance("_probe2", t)
		var h := skel.get_bone_global_pose(head).origin
		for i in 2:
			var m: Vector3 = mean[i]
			var d := skel.get_bone_global_pose(int(arms[i][2])).origin - h
			var at: Vector3 = GUARD_AT[i]
			var to := h + fwd * at.x + right * at.y * (-1.0 if i == 0 else 1.0) + Vector3.UP * at.z + (d - m) * GUARD_LIVE
			was[i] = float(was[i]) + d.length() / float(n + 1)
			_solve(arms[i], to)
			now[i] = float(now[i]) + (skel.get_bone_global_pose(int(arms[i][2])).origin - h).length() / float(n + 1)
			for b in arms[i]:
				out.rotation_track_insert_key(rot_t[b], t, skel.get_bone_pose_rotation(int(b)))
	lib.remove_animation("_probe2")
	print("STEPBAKE   guard up: wrist from the head, lead %.2f -> %.2f m, rear %.2f -> %.2f m" % [float(was[0]), float(now[0]), float(was[1]), float(now[1])])


## The boot of a solved leg turned down about its ball until its heel is `down` m lower (the ankle is already there:
## the leg was solved onto the lowered ankle), the toes' bend eased to the guard's by the same share.
func _flatten(leg: Array, toes: int, down: float, toe_rest: Quaternion) -> void:
	if down < 0.001:
		return
	var foot := skel.get_bone_global_pose(int(leg[2]))
	var v := skel.get_bone_global_pose(toes).origin - foot.origin
	var ln := v.length()
	var head := Vector3(v.x, 0.0, v.z)
	if ln < 0.01 or head.length() < 0.01:
		return
	var axis := head.normalized().cross(Vector3.UP).normalized()
	var ang := asin(clampf((v.y + down) / ln, -1.0, 1.0)) - asin(clampf(v.y / ln, -1.0, 1.0))
	var turn := Quaternion(axis, ang)
	if absf((turn * v).y - (v.y + down)) > absf((turn.inverse() * v).y - (v.y + down)):
		turn = turn.inverse()
	var shin := skel.get_bone_global_pose(int(leg[1])).basis.get_rotation_quaternion()
	skel.set_bone_pose_rotation(int(leg[2]), (shin.inverse() * (turn * foot.basis.get_rotation_quaternion())).normalized())
	skel.set_bone_pose_rotation(toes, skel.get_bone_pose_rotation(toes).slerp(toe_rest, clampf(down / 0.03, 0.0, 1.0)))


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
