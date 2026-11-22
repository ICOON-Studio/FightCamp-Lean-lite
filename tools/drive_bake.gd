extends SceneTree
## FP2POSE4 (S537): bakes THE HIP DRIVE into the rear-hand power punches v2 plays (scripts/fight3d/v2/Drive.gd says
## why and what). Run AFTER tools/cross_legs_bake.gd and tools/stance_bake.gd: the take is read as those left it.
## Per take, 60 pictures a second, in the take's own space:
##   the load   over LOAD_S before the drive the hips sit LOAD_BACK_M back and LOAD_DOWN_M down onto the rear leg
##              (less where the take has no time for it), let go through the drive;
##   the drive  over DRIVE_S, ending PAST_S after the contact (the hips are still going forward as the glove lands:
##              real gloves carry most of their speed into the target, CROSS_POWER_S439), the hips go forward along
##              the line so that AT THE CONTACT they are Drive.amp() further on than at the take's start, less what the
##              take travels itself; back over BACK_S on the recoil;
##   the legs   the rear ankle stays over its ball (pitched up further about the ball where the leg would be past
##              REACH of its length), the lead ankle stays; the lead knee may give Drive.BRACE_DEG, the hips rise for
##              the rest (never over RISE_MAX_M); both legs solved again, the feet keep their turn.
## It prints, per take, before -> after: the hips forward at the contact, the rear knee at its deepest in the load and
## at the contact (what it extends through the drive), the lead knee, the rear ankle's height, and the glove face's
## top speed (the hand's striking face, m/s) with how long before the contact it comes.
## <godot> --headless --audio-driver Dummy --path . --script res://tools/drive_bake.gd -- [dry] [body=01] [only=<take>] [show=<take>]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Drive := preload("res://scripts/fight3d/v2/Drive.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const HZ := 60.0
const DRIVE_S := 0.18
const PAST_S := 0.04
const BACK_S := 0.40
const LOAD_S := 0.14
const LOAD_BACK_M := 0.02
## A cross sits a little; a rear hook sits onto the rear leg, a rear uppercut dips to come up through the legs.
const LOAD_DOWN_M := {"cross": 0.015, "rear_hook": 0.03, "rear_uppercut": 0.04}
const RISE_MAX_M := 0.025
const REACH := 0.94           # the rear leg is never straighter than this share of its length (knee about 140 deg: Dinu & Louis 143 +- 16 at the impact; the foot pins of v2 straighten it further on another body)
const PITCH_MAX_DEG := 40.0   # the most the rear foot is pitched up further about its ball
const PITCH_TOP_DEG := 70.0   # ... and never steeper than this over the canvas
const GLOVE_M := 0.192        # the glove's striking face ahead of the wrist (clip_db.json meta glove_front_m)

var skel: Skeleton3D
var ap: AnimationPlayer
var fwd := Vector3.BACK
var hips := -1
var _short := 0.0
var _pitch := 0.0


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _seek(clip: String, t: float) -> void:
	ap.play(clip)
	ap.seek(t, true)


func _o(b: String) -> Vector3:
	return skel.get_bone_global_pose(skel.find_bone(b)).origin


func _knee(s: String) -> float:
	var k := _o(s + "LowerLeg")
	return rad_to_deg((_o(s + "UpperLeg") - k).angle_to(_o(s + "Foot") - k))


func _glove() -> Vector3:
	var h := _o("RightHand")
	return h + (_o("RightMiddleProximal") - h).normalized() * GLOVE_M


func _initialize() -> void:
	Drive.off = true
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
	hips = skel.find_bone("Hips")
	var f: Vector3 = skel.global_transform.basis.orthonormalized().inverse() * (bx["node"] as Node3D).global_transform.basis.z
	fwd = Vector3(f.x, 0.0, f.z).normalized()
	var dry := OS.get_cmdline_user_args().has("dry")
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://assets/data/clip_db.json"))
	var rows: Dictionary = (parsed as Dictionary).get("rows", {}) if parsed is Dictionary else {}
	var names: Array = Drive.takes(rows, Array(ap.get_animation_list()))
	if _arg("only", "") != "":
		names = names.filter(func(nm): return str(nm).begins_with(_arg("only", "")))
	DirAccess.make_dir_recursive_absolute(Drive.DIR)
	print("DRIVE the line is %s in the skeleton's space; %d takes" % [str(fwd.snapped(Vector3.ONE * 0.01)), names.size()])
	var done := 0
	for name in names:
		var out := _bake(str(name), rows[str(name)])
		out.set_meta(Drive.REST_META, skel.get_bone_rest(hips).origin.y)
		if not dry and ResourceSaver.save(out, Drive.DIR + str(name) + ".res") != OK:
			print("DRIVE SAVE FAIL ", name)
			continue
		done += 1
	print("DRIVE DONE %d of %d -> %s%s" % [done, names.size(), Drive.DIR, " (dry)" if dry else ""])
	quit(0 if done == names.size() else 1)


func _bake(clip: String, row: Dictionary) -> Animation:
	var src := ap.get_animation(clip)
	var n := int(ceil(src.length * HZ - 0.001))
	var tc := float(row.get("contact_s", 0.3))
	var kp := clampi(int(round(tc * HZ)), 0, n)
	_seek(clip, 0.0)
	var lead := "Left" if fwd.dot(_o("LeftFoot") - _o("RightFoot")) >= 0.0 else "Right"
	var rear := "Right" if lead == "Left" else "Left"
	var hips0 := _o("Hips")
	# the windows
	var tp := minf(tc + PAST_S, src.length)
	var t0 := maxf(tp - DRIVE_S, 0.0)
	var t1 := minf(tp + BACK_S, maxf(src.length - 0.05, tp + 0.1))
	var load_x := clampf(t0 / LOAD_S, 0.0, 1.0)
	_seek(clip, tc)
	var own_c := fwd.dot(_o("Hips") - hips0)
	var add := clampf(Drive.amp(row) - maxf(own_c, 0.0), 0.0, Drive.MOST_M)
	var wc := smoothstep(t0, tp, tc)
	# pass 1: the move of the hips, picture by picture (the rise from the lead leg's brace, then eased)
	var move: Array = []
	var was: Array = []       # [rear knee, lead knee, rear ankle y, glove, hips forward]
	for k in n + 1:
		var t := minf(float(k) / HZ, src.length)
		_seek(clip, t)
		var w := smoothstep(t0, tp, t) * (1.0 - smoothstep(tp, t1, t))
		var l := smoothstep(t0 - LOAD_S, t0, t) * (1.0 - smoothstep(t0, tc, t)) * load_x
		var d := fwd * (add / maxf(wc, 0.01) * w - LOAD_BACK_M * l) + Vector3.DOWN * float(LOAD_DOWN_M.get(str(row.get("family", "")), 0.015)) * l
		# the brace: the lead knee gives BRACE_DEG at most; the hips rise for the rest
		var a := _o(lead + "UpperLeg")
		var b := _o(lead + "LowerLeg")
		var c := _o(lead + "Foot")
		var th := deg_to_rad(maxf(_knee(lead) - Drive.BRACE_DEG * w, 20.0))
		var keep := sqrt((b - a).length_squared() + (c - b).length_squared() - 2.0 * (b - a).length() * (c - b).length() * cos(th))
		var v := a + d - c
		var flat := Vector2(v.x, v.z).length()
		if w > 0.0 and keep > flat and v.y < sqrt(keep * keep - flat * flat):
			d.y += minf(sqrt(keep * keep - flat * flat) - v.y, RISE_MAX_M)
		move.append(d)
		was.append([_knee(rear), _knee(lead), _o(rear + "Foot").y, _glove(), fwd.dot(_o("Hips") - hips0)])
	for pass_i in 2:          # the rise comes in at a corner: eased over 5 pictures
		var eased: Array = []
		for k in move.size():
			var y := 0.0
			for j in range(-2, 3):
				y += (move[clampi(k + j, 0, move.size() - 1)] as Vector3).y / 5.0
			eased.append(Vector3((move[k] as Vector3).x, y, (move[k] as Vector3).z))
		move = eased
	# pass 2: the legs again
	var out := Animation.new()
	out.length = src.length
	out.step = 1.0 / HZ
	var ht := out.add_track(Animation.TYPE_POSITION_3D)
	out.track_set_path(ht, NodePath("Hips"))
	var bones: Array = []
	for s in [lead, rear]:
		for b in ["UpperLeg", "LowerLeg", "Foot"]:
			bones.append(str(s) + str(b))
	bones.append(rear + "Toes")
	var tr: Array = []
	for b in bones:
		var t := out.add_track(Animation.TYPE_ROTATION_3D)
		out.track_set_path(t, NodePath(str(b)))
		tr.append(t)
	var par := skel.get_bone_parent(hips)
	var now: Array = []
	var short := 0.0
	var pitch := 0.0
	var rise := 0.0
	for k in n + 1:
		var t := minf(float(k) / HZ, src.length)
		_seek(clip, t)
		var d: Vector3 = move[k]
		var pb := skel.get_bone_global_pose(par).basis.orthonormalized() if par >= 0 else Basis.IDENTITY
		var delta: Vector3 = pb.inverse() * d
		if d.length() > 0.00005:
			_legs(delta, lead, rear)
			short = maxf(short, _short)
			pitch = maxf(pitch, _pitch)
			rise = maxf(rise, d.y)
		out.position_track_insert_key(ht, t, delta if d.length() > 0.00005 else Vector3.ZERO)
		for i in bones.size():
			out.rotation_track_insert_key(int(tr[i]), t, skel.get_bone_pose_rotation(skel.find_bone(str(bones[i]))))
		now.append([_knee(rear), _knee(lead), _o(rear + "Foot").y, _glove(), fwd.dot(_o("Hips") - hips0)])
		if _arg("show", "") == clip:
			print("DRIVE   %.3f hips %+.1f cm fwd %+.1f up | rear knee %.0f -> %.0f, lead %.0f -> %.0f" % [t, fwd.dot(d) * 100.0, d.y * 100.0, was[k][0], now[k][0], was[k][1], now[k][1]])
	# what it did
	var k0 := clampi(int(floor((t0 - LOAD_S) * HZ)), 0, kp)
	var deep_was := 999.0
	var deep_now := 999.0
	for k in range(k0, kp + 1):
		deep_was = minf(deep_was, float(was[k][0]))
		deep_now = minf(deep_now, float(now[k][0]))
	var sp_was := _speed(was, kp)
	var sp_now := _speed(now, kp)
	print("DRIVE %-26s %s | contact %.2f s | hips forward %+.1f -> %+.1f cm (drive %.2f..%.2f s, +%.1f cm) | rear knee deepest %.0f -> %.0f, at the contact %.0f -> %.0f: through the drive %+.0f -> %+.0f deg | lead knee %.0f -> %.0f | rear ankle %+.1f cm, foot pitched %.0f deg more, hips rise %.1f cm | a foot short by %.1f mm | glove face top %.1f m/s %.0f ms before -> %.1f m/s %.0f ms before, at the contact %.1f -> %.1f" % [
		clip, str(row.get("family", "")), tc, float(was[kp][4]) * 100.0, float(now[kp][4]) * 100.0, t0, tp, add * 100.0, deep_was, deep_now, was[kp][0], now[kp][0],
		float(was[kp][0]) - deep_was, float(now[kp][0]) - deep_now, was[kp][1], now[kp][1], (float(now[kp][2]) - float(was[kp][2])) * 100.0, pitch, rise * 100.0, short * 1000.0,
		sp_was[0], sp_was[1], sp_now[0], sp_now[1], sp_was[2], sp_now[2]])
	return out


## [the glove face's top speed up to the contact (m/s), how long before the contact (ms), its speed at the contact].
func _speed(rows: Array, kp: int) -> Array:
	var top := 0.0
	var at := 0
	for k in range(1, mini(kp + 2, rows.size())):
		var v: float = ((rows[k][3] as Vector3) - (rows[k - 1][3] as Vector3)).length() * HZ
		if v > top and k <= kp:
			top = v
			at = k
	var kc := clampi(kp, 1, rows.size() - 1)
	return [top, float(kp - at) / HZ * 1000.0, ((rows[kc][3] as Vector3) - (rows[kc - 1][3] as Vector3)).length() * HZ]


## The posed skeleton with the hips moved `delta` (their parent's space) and both ankles where they stood: the rear
## ankle pitched up further about its ball where its leg would be past REACH.
func _legs(delta: Vector3, lead: String, rear: String) -> void:
	var want := {}
	var foot_q := {}
	for s in [lead, rear]:
		var g := skel.get_bone_global_pose(skel.find_bone(str(s) + "Foot"))
		want[s] = g.origin
		foot_q[s] = g.basis.get_rotation_quaternion()
	var ball := _o(rear + "Toes")
	var toes_q := skel.get_bone_global_pose(skel.find_bone(rear + "Toes")).basis.get_rotation_quaternion()
	var len := ((_o(rear + "LowerLeg") - _o(rear + "UpperLeg")).length() + ((want[rear] as Vector3) - _o(rear + "LowerLeg")).length()) * REACH
	skel.set_bone_pose_position(hips, skel.get_bone_pose_position(hips) + delta)
	# the rear heel: up about the ball until the leg reaches
	_pitch = 0.0
	var a := _o(rear + "UpperLeg")
	var v: Vector3 = (want[rear] as Vector3) - ball
	var flat := Vector3(v.x, 0.0, v.z)
	if ((want[rear] as Vector3) - a).length() > len and flat.length() > 0.01:
		var ax := flat.normalized().cross(Vector3.UP).normalized()
		if (Quaternion(ax, 0.1) * v).y < v.y:
			ax = -ax
		var lo := 0.0
		var hi := clampf(deg_to_rad(PITCH_TOP_DEG) - asin(clampf(v.y / v.length(), -1.0, 1.0)), 0.0, deg_to_rad(PITCH_MAX_DEG))
		for i in 16:
			var mid := (lo + hi) * 0.5
			if (ball + Quaternion(ax, mid) * v - a).length() > len:
				lo = mid
			else:
				hi = mid
		var lift := Quaternion(ax, hi)
		want[rear] = ball + lift * v
		foot_q[rear] = (lift * (foot_q[rear] as Quaternion)).normalized()
		_pitch = rad_to_deg(hi)
	_short = 0.0
	for s in [lead, rear]:
		var leg: Array = [skel.find_bone(str(s) + "UpperLeg"), skel.find_bone(str(s) + "LowerLeg"), skel.find_bone(str(s) + "Foot")]
		_solve(leg, want[s])
		var shin := skel.get_bone_global_pose(int(leg[1])).basis.get_rotation_quaternion()
		skel.set_bone_pose_rotation(int(leg[2]), (shin.inverse() * (foot_q[s] as Quaternion)).normalized())
		_short = maxf(_short, (skel.get_bone_global_pose(int(leg[2])).origin - (want[s] as Vector3)).length())
	skel.set_bone_pose_rotation(skel.find_bone(rear + "Toes"), ((foot_q[rear] as Quaternion).inverse() * toes_q).normalized())


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
