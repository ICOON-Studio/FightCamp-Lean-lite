extends SceneTree
## FP2POSE2 (S536, owner C454): bakes the cross takes' REAR LEG again (scripts/fight3d/v2/CrossLegs.gd says why). Per
## take, read off the take as bought on our body: the punch line (hips at the start -> the rear hand at its furthest),
## the hips' turn about the vertical, the rear foot's turn from the punch line and the pitch of the foot (ankle over the
## ball). Then, picture by picture, driven by the take's OWN hip turn (0 at the start, 1 at the contact; nothing while the
## take itself has the foot in the air):
##   - the rear foot turns about its BALL, the way the hips turn, until AT THE CONTACT its toes are YAW_TO off the punch
##     line (a cross's rear foot ends pointing nearly at the target; the stance has it 33-47 deg out);
##   - the foot is pitched up about the ball, PITCH_DEG at the contact: the heel comes up. Only what the take does not
##     do itself by that picture is added (the actor lifts his heel 2-5 cm AFTER the contact: that is kept);
##   - the leg is solved again onto the raised, swung ankle (two-bone IK, the knee in the plane it bends in), under the
##     take's own hips: the knee bends; the toes stay flat on the canvas, turned with the foot.
## A take whose hips turn little gets less (x the turn / FULL_TURN_DEG, at least LEAST). Saved: the rear leg's four
## rotation tracks only, CrossLegs.DIR/<take file>.res.
## <godot> --headless --audio-driver Dummy --path . --script res://tools/cross_legs_bake.gd -- [dry] [body=01] [show=<take>]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const CrossLegs := preload("res://scripts/fight3d/v2/CrossLegs.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const LEG := ["RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]
const YAW_TO := -12.0
const PITCH_DEG := 28.0
const FULL_TURN_DEG := 35.0
const LEAST := 0.7
const AIR_LO := 0.015
const AIR_HI := 0.06
const EDGE_S := 0.12          # eased in and out at the take's ends (the take joins a stance on both)

var skel: Skeleton3D
var ap: AnimationPlayer
var ids: Array = []


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _seek(clip: String, t: float) -> void:
	ap.play(clip)
	ap.seek(t, true)


func _g(b: int) -> Transform3D:
	return skel.get_bone_global_pose(b)


func _ang(v: Vector3) -> float:
	return atan2(v.x, v.z)


func _initialize() -> void:
	CrossLegs.off = true
	FightClips.as_bought = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("body", "01"), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "blue"})
	await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	Orbit.strip_modifiers(skel)
	ids = LEG.map(func(b): return skel.find_bone(str(b)))
	var dry := OS.get_cmdline_user_args().has("dry")
	DirAccess.make_dir_recursive_absolute(CrossLegs.DIR)
	var stems := {}
	for stem in FightClips.pro_stems():
		stems[FightClips.pro_name(str(stem))] = str(stem)
	var done := 0
	for name in CrossLegs.TAKES:
		if not ap.has_animation(str(name)) or not stems.has(name):
			print("CROSSLEGS MISSING ", name)
			continue
		var legs := _bake(str(name))
		if not dry and ResourceSaver.save(legs, CrossLegs.DIR + str(stems[name]) + ".res") != OK:
			print("CROSSLEGS SAVE FAIL ", name)
			continue
		done += 1
	print("CROSSLEGS DONE %d of %d -> %s%s" % [done, CrossLegs.TAKES.size(), CrossLegs.DIR, " (dry)" if dry else ""])
	quit(0 if done == CrossLegs.TAKES.size() else 1)


func _bake(clip: String) -> Animation:
	var src := ap.get_animation(clip)
	var n := int(round(src.length * 60.0))
	var hips := skel.find_bone("Hips")
	var head := skel.find_bone("Head")
	var hand := skel.find_bone("RightHand")
	# pass 1: the take's own numbers
	_seek(clip, 0.0)
	var hips0 := _g(hips)
	var ball0 := _g(int(ids[3])).origin
	var v0 := _g(int(ids[2])).origin - ball0
	var pitch0 := asin(clampf(v0.y / v0.length(), -1.0, 1.0))
	var turn: Array = []
	var far := -1.0
	var reach := Vector3.ZERO
	for k in n + 1:
		_seek(clip, minf(float(k) / 60.0, src.length))
		turn.append(rad_to_deg(angle_difference(_ang(hips0.basis.z), _ang(_g(hips).basis.z))))
		var d := _g(hand).origin - _g(head).origin
		if Vector2(d.x, d.z).length() > far:
			far = Vector2(d.x, d.z).length()
			reach = _g(hand).origin
	# the contact (the v2 census's, assets/data/clip_db.json; else the hand at its furthest)
	var kp := 0
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://assets/data/clip_db.json"))
	var row: Dictionary = (parsed as Dictionary).get("rows", {}).get(clip, {}) if parsed is Dictionary else {}
	if row.has("contact_s"):
		kp = clampi(int(round(float(row["contact_s"]) * 60.0)), 0, n)
	else:
		for k in turn.size():
			if float(turn[k]) > float(turn[kp]):
				kp = k
	var most := maxf(float(turn[kp]), 1.0)
	var axis := _ang(reach - hips0.origin)
	var yaw0 := rad_to_deg(angle_difference(axis, _ang(-v0)))
	var amp := clampf(most / FULL_TURN_DEG, LEAST, 1.0)
	var yaw_p := 0.0
	var yaw_now := 0.0
	var pitch_p := 0.0
	var pitch_now := 0.0
	var knee_was := 0.0
	var knee_now := 0.0
	var rise := 0.0
	var out := Animation.new()
	out.length = src.length
	out.step = 1.0 / 60.0
	var tr: Array = []
	for b in LEG:
		var t := out.add_track(Animation.TYPE_ROTATION_3D)
		out.track_set_path(t, NodePath(str(b)))
		tr.append(t)
	# pass 2: the leg again
	for k in n + 1:
		var t := minf(float(k) / 60.0, src.length)
		_seek(clip, t)
		var ball := _g(int(ids[3])).origin
		var foot := _g(int(ids[2]))
		var toes_q := _g(int(ids[3])).basis.get_rotation_quaternion()
		var d := smoothstep(0.15, 0.85, float(turn[k]) / most)
		d *= 1.0 - smoothstep(AIR_LO, AIR_HI, ball.y - ball0.y)
		d *= smoothstep(0.0, EDGE_S, t) * smoothstep(0.0, EDGE_S, src.length - t)
		# what the take does not do itself by this picture is added (its own late lift after the contact is kept)
		var v_own := foot.origin - ball
		var own_yaw := rad_to_deg(angle_difference(axis, _ang(-v_own)))
		var own_pitch := rad_to_deg(asin(clampf(v_own.y / v_own.length(), -1.0, 1.0)) - pitch0)
		var add_yaw := maxf(lerpf(yaw0, maxf(YAW_TO, yaw0), d * amp) - own_yaw, 0.0) if d > 0.0 else 0.0
		var add_pitch := maxf(PITCH_DEG * amp * d - own_pitch, 0.0) if d > 0.0 else 0.0
		d = 1.0 if add_yaw > 0.01 or add_pitch > 0.01 else 0.0
		if k == kp:
			yaw_p = own_yaw
			yaw_now = own_yaw + add_yaw
			pitch_p = own_pitch
			pitch_now = own_pitch + add_pitch
		if k == kp:
			var kn := _g(int(ids[1])).origin
			knee_was = rad_to_deg((_g(int(ids[0])).origin - kn).angle_to(foot.origin - kn))
		if d > 0.0005:
			var yaw := Quaternion(Vector3.UP, deg_to_rad(add_yaw * d))
			var v := yaw * (foot.origin - ball)
			var flat := Vector3(v.x, 0.0, v.z)
			var lift := Quaternion.IDENTITY
			if flat.length() > 0.01:
				var ax := flat.normalized().cross(Vector3.UP).normalized()
				var want := minf(asin(clampf(v.y / v.length(), -1.0, 1.0)) + deg_to_rad(add_pitch * d), deg_to_rad(80.0))
				lift = Quaternion(ax, want - asin(clampf(v.y / v.length(), -1.0, 1.0)))
				if (lift * v).y < v.y:
					lift = lift.inverse()
			var ankle := ball + lift * v
			var foot_q := (lift * yaw * foot.basis.get_rotation_quaternion()).normalized()
			_solve(ids, ankle)
			var shin := _g(int(ids[1])).basis.get_rotation_quaternion()
			skel.set_bone_pose_rotation(int(ids[2]), (shin.inverse() * foot_q).normalized())
			skel.set_bone_pose_rotation(int(ids[3]), (foot_q.inverse() * (yaw * toes_q)).normalized())
		if k == kp:
			var kn2 := _g(int(ids[1])).origin
			knee_now = rad_to_deg((_g(int(ids[0])).origin - kn2).angle_to(_g(int(ids[2])).origin - kn2))
			rise = _g(int(ids[2])).origin.y - foot.origin.y
		if _arg("show", "") == clip:
			print("CROSSLEGS   %.3f turn %+.0f d %.2f ankle up %+.1f cm, ball off %.1f mm" % [t, turn[k], d, (_g(int(ids[2])).origin.y - foot.origin.y) * 100.0, (_g(int(ids[3])).origin - ball).length() * 1000.0])
		for i in 4:
			out.rotation_track_insert_key(int(tr[i]), t, skel.get_bone_pose_rotation(int(ids[i])))
	print("CROSSLEGS %-26s %.2f s | at the contact %.2f s: hips turned %.0f deg (x %.2f) | rear foot %+.0f in the stance, %+.0f -> %+.0f deg off the punch line | foot pitched up %.0f -> %.0f deg, ankle %+.1f cm | rear knee %.0f -> %.0f deg" % [
		clip, src.length, float(kp) / 60.0, most, amp, yaw0, yaw_p, yaw_now, pitch_p, pitch_now, rise * 100.0, knee_was, knee_now])
	return out


## Two-bone IK in the skeleton's space (tools/step_bake.gd _solve): the ankle onto `t`, the knee in the plane it bends in.
func _solve(leg: Array, t: Vector3) -> void:
	var ga := skel.get_bone_global_pose(leg[0])
	var gb := skel.get_bone_global_pose(leg[1])
	var gc := skel.get_bone_global_pose(leg[2])
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
	var qa1 := r2 * r0 * ga.basis.get_rotation_quaternion()
	var qb1 := r2 * r1 * r0 * gb.basis.get_rotation_quaternion()
	var par := skel.get_bone_parent(leg[0])
	var qp := skel.get_bone_global_pose(par).basis.get_rotation_quaternion() if par >= 0 else Quaternion.IDENTITY
	skel.set_bone_pose_rotation(leg[0], (qp.inverse() * qa1).normalized())
	skel.set_bone_pose_rotation(leg[1], (qa1.inverse() * qb1).normalized())
