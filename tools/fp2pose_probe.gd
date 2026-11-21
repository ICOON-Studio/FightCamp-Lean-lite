extends SceneTree
## FP2POSE1 (S536, owner C454 "wtf is that legs doing and where the fuck is he looking at", C458 "legs are weird and
## looks like a weak 12 year old kid"): the v2 player's POSE in numbers, headless, read AS DRAWN (after every layer).
## Per boxer, against the line to the other man: where each foot stands (side = across the line, + = each foot on its
## own side, - = crossed; fwd = lead ahead of rear), the knees (angle, and how far each caves toward the other leg),
## the trunk's lean, and how far the face points off the other man's head.
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/fp2pose_probe.gd -- [red=02 blue=01]
##   raw          every pose layer off (the take as baked)        off=A,B   those layers off
##   show=<take>  every picture of that take                      only=guard|cross
##   only=c458    what tools/fight3d_still.gd did under v2 for its f05 close guard (the owner's C458 still)

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BONES := ["Hips", "Chest", "UpperChest", "Neck", "Head", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
	"LeftFoot", "RightFoot", "LeftToes", "RightToes", "LeftUpperArm", "RightUpperArm", "LeftHand", "RightHand"]
const KEYS := ["feet_side", "feet_fwd", "feet_apart", "toes_side", "shoulders", "knee_l", "knee_r", "cave_l", "cave_r", "knees_apart",
	"lean_fwd", "lean_side", "hips_back", "head_yaw", "head_pitch", "head_off", "chest_yaw", "pelvis_yaw", "toe_l", "toe_r", "hips_y", "hand_l", "hand_r", "heel_l", "heel_r"]

var st: Node3D
var drawn: Array = [{}, {}]


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _w(i: int, bone: String) -> Vector3:
	return (st.boxers[i]["skel"] as Skeleton3D).global_transform * ((drawn[i][bone] as Transform3D).origin)


## The way the bone's rest-forward (the body's own front) points now, in the world.
func _dir(i: int, bone: String) -> Vector3:
	var sk: Skeleton3D = st.boxers[i]["skel"]
	var node: Node3D = st.boxers[i]["node"]
	var sb := sk.global_transform.basis.orthonormalized()
	var front: Vector3 = sb.inverse() * node.global_transform.basis.orthonormalized().z
	var g: Transform3D = drawn[i][bone]
	return (sb * (g.basis.orthonormalized() * sk.get_bone_global_rest(sk.find_bone(bone)).basis.orthonormalized().inverse() * front)).normalized()


func _flat(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


func _yaw(v: Vector3, axis: Vector3, side: Vector3) -> float:
	return rad_to_deg(atan2(v.dot(side), v.dot(axis)))


func _knee(i: int, s: String) -> float:
	var k := _w(i, s + "LowerLeg")
	return rad_to_deg((_w(i, s + "UpperLeg") - k).angle_to(_w(i, s + "Foot") - k))


## How far the knee is off the hip-ankle line toward the other leg, cm (+ = caved in).
func _cave(i: int, s: String, o: String) -> float:
	var h := _w(i, s + "UpperLeg")
	var a := _w(i, s + "Foot")
	var k := _w(i, s + "LowerLeg")
	var l := (a - h).normalized()
	var off := (k - h) - l * (k - h).dot(l)
	var inward := _flat(_w(i, o + "UpperLeg") - h).normalized()
	return off.dot(inward) * 100.0


func _read(i: int) -> Dictionary:
	var o := 1 - i
	var sk: Skeleton3D = st.boxers[i]["skel"]
	var s: float = (st.boxers[i]["node"] as Node3D).scale.x
	var axis := _flat((st.boxers[o]["node"] as Node3D).global_position - (st.boxers[i]["node"] as Node3D).global_position).normalized()
	var side := Vector3.UP.cross(axis)
	var rl: Vector3 = sk.global_transform.basis * (sk.get_bone_global_rest(sk.find_bone("LeftFoot")).origin - sk.get_bone_global_rest(sk.find_bone("RightFoot")).origin)
	var sgn := 1.0 if rl.dot((st.boxers[i]["node"] as Node3D).global_transform.basis.x) >= 0.0 else -1.0
	var lf := _w(i, "LeftFoot")
	var rf := _w(i, "RightFoot")
	var trunk := _w(i, "UpperChest") - _w(i, "Hips")
	var face := _dir(i, "Head")
	var to := _w(o, "Head") - _w(i, "Head")
	var out := {}
	out["feet_side"] = sgn * side.dot(lf - rf) * 100.0 / s
	out["feet_fwd"] = axis.dot(lf - rf) * 100.0 / s
	out["feet_apart"] = _flat(lf - rf).length() * 100.0 / s
	out["toes_side"] = sgn * side.dot(_w(i, "LeftToes") - _w(i, "RightToes")) * 100.0 / s
	out["shoulders"] = (_w(i, "LeftUpperArm") - _w(i, "RightUpperArm")).length() * 100.0 / s
	out["knee_l"] = _knee(i, "Left")
	out["knee_r"] = _knee(i, "Right")
	out["cave_l"] = _cave(i, "Left", "Right") / s
	out["cave_r"] = _cave(i, "Right", "Left") / s
	out["knees_apart"] = _flat(_w(i, "LeftLowerLeg") - _w(i, "RightLowerLeg")).length() * 100.0 / s
	out["lean_fwd"] = rad_to_deg(atan2(trunk.dot(axis), trunk.y))
	out["lean_side"] = rad_to_deg(atan2(trunk.dot(side) * sgn, trunk.y))
	out["hips_back"] = axis.dot(_w(i, "UpperChest") - _w(i, "Hips")) * 100.0 / s
	out["head_yaw"] = _yaw(face, _flat(to).normalized(), Vector3.UP.cross(_flat(to).normalized())) * sgn
	out["head_pitch"] = rad_to_deg(asin(clampf(face.y, -1.0, 1.0)) - asin(clampf(to.normalized().y, -1.0, 1.0)))
	out["head_off"] = rad_to_deg(face.angle_to(to))
	out["chest_yaw"] = _yaw(_dir(i, "UpperChest"), axis, side) * sgn
	out["pelvis_yaw"] = _yaw(_dir(i, "Hips"), axis, side) * sgn
	out["toe_l"] = _yaw(_flat(_w(i, "LeftToes") - lf), axis, side) * sgn
	out["toe_r"] = _yaw(_flat(_w(i, "RightToes") - rf), axis, side) * sgn
	out["hips_y"] = (_w(i, "Hips").y - minf(_w(i, "LeftToes").y, _w(i, "RightToes").y)) * 100.0 / s
	out["heel_l"] = (lf.y - _w(i, "LeftToes").y) * 100.0 / s   # the ankle over the ball of the foot: it rises as the heel lifts
	out["heel_r"] = (rf.y - _w(i, "RightToes").y) * 100.0 / s
	out["hand_l"] = (_w(i, "LeftHand") - _w(i, "Head")).length() * 100.0 / s
	out["hand_r"] = (_w(i, "RightHand") - _w(i, "Head")).length() * 100.0 / s
	return out


func _line(d: Dictionary) -> String:
	return "feet side %+.0f fwd %+.0f apart %.0f (toes side %+.0f; shoulders %.0f) | knees L %.0f R %.0f deg, cave L %+.1f R %+.1f, apart %.0f | trunk fwd %+.0f side %+.0f deg, chest over hips %+.0f cm | head off %.0f (yaw %+.0f pitch %+.0f) chest yaw %+.0f pelvis yaw %+.0f | toes L %+.0f R %+.0f deg | hips %.0f cm up | hands L %.0f R %.0f cm from head | ankle over ball L %.1f R %.1f cm" % [
		d["feet_side"], d["feet_fwd"], d["feet_apart"], d["toes_side"], d["shoulders"], d["knee_l"], d["knee_r"], d["cave_l"], d["cave_r"], d["knees_apart"],
		d["lean_fwd"], d["lean_side"], d["hips_back"], d["head_off"], d["head_yaw"], d["head_pitch"], d["chest_yaw"], d["pelvis_yaw"], d["toe_l"], d["toe_r"], d["hips_y"], d["hand_l"], d["hand_r"], d["heel_l"], d["heel_r"]]


func _who(i: int) -> String:
	return "%s mh_boxer_%s" % ["red" if i == 0 else "blue", _arg("red" if i == 0 else "blue", "02" if i == 0 else "01")]


## The guard over `frames` pictures: the mean, and the spread of what moves.
func _span(i: int, label: String, frames: int) -> void:
	var sum := {}
	var lo := {}
	var hi := {}
	for f in frames:
		await process_frame
		var d := _read(i)
		for k in KEYS:
			sum[k] = float(sum.get(k, 0.0)) + float(d[k])
			lo[k] = minf(float(lo.get(k, 1e9)), float(d[k]))
			hi[k] = maxf(float(hi.get(k, -1e9)), float(d[k]))
	var mean := {}
	for k in KEYS:
		mean[k] = float(sum[k]) / float(frames)
	print("POSE GUARD %s | %s | %s" % [_who(i), label, _line(mean)])
	print("POSE GUARD %s | %s | spread: feet apart %.0f..%.0f, feet side %+.0f..%+.0f, knees L %.0f..%.0f R %.0f..%.0f, cave L %+.1f..%+.1f R %+.1f..%+.1f, head off %.0f..%.0f, hips %.0f..%.0f cm up" % [_who(i), label,
		lo["feet_apart"], hi["feet_apart"], lo["feet_side"], hi["feet_side"], lo["knee_l"], hi["knee_l"], lo["knee_r"], hi["knee_r"], lo["cave_l"], hi["cave_l"], lo["cave_r"], hi["cave_r"], lo["head_off"], hi["head_off"], lo["hips_y"], hi["hips_y"]])


## The three joints the waiting takes did not key (spine_02, spine_04, neck_02), degrees off their rest, as animated.
func _joints(i: int) -> String:
	var sk: Skeleton3D = st.boxers[i]["skel"]
	var out: Array = []
	for n in ["spine_02", "spine_04", "neck_02"]:
		var b := sk.find_bone(n)
		out.append("%s %.0f" % [n, rad_to_deg(sk.get_bone_pose_rotation(b).angle_to(sk.get_bone_rest(b).basis.get_rotation_quaternion())) if b >= 0 else -1.0])
	return ", ".join(PackedStringArray(out))


## What a take leaves behind in the guard: blue plays it, goes back to his waiting take, and is read a second later.
func _stuck() -> void:
	var p2: Node = st.v2
	var ap: AnimationPlayer = st.boxers[1]["ap"]
	for f in 60:
		await process_frame
	var d0 := _read(1)
	print("POSE STUCK %s | the guard before anything | joints off rest: %s | trunk fwd %+.0f side %+.0f, chest yaw %+.0f pelvis yaw %+.0f, hips %.0f cm up" % [_who(1), _joints(1), d0["lean_fwd"], d0["lean_side"], d0["chest_yaw"], d0["pelvis_yaw"], d0["hips_y"]])
	for take in ["pro_right_cross", "pro_left_hook_ft", "pro_hit_by_hook_v3", "pro_idle_tired", "af_sit_idle", "af_walk", "win", "cross"]:
		if not ap.has_animation(take):
			print("POSE STUCK no take %s" % take)
			continue
		if str(take).begins_with("pro_"):
			p2._play(1, take, 0.0, "punch", true)
		else:
			ap.play(take)   # behind v2's back, as a director's scene plays its clips
		for f in 24:
			await process_frame
		var mid := _joints(1)
		p2.guard(1)
		for f in 60:
			await process_frame
		var d := _read(1)
		print("POSE STUCK %s | after %s (in it: %s) | back in the guard, joints off rest: %s | trunk fwd %+.0f side %+.0f, chest yaw %+.0f pelvis yaw %+.0f, hips %.0f cm up" % [_who(1), take, mid, _joints(1), d["lean_fwd"], d["lean_side"], d["chest_yaw"], d["pelvis_yaw"], d["hips_y"]])
	print("POSE done")
	quit(0)


## Which bones each clip keys: a bone one clip keys and the next does not stays where the first left it.
func _tracks() -> void:
	var ap: AnimationPlayer = st.boxers[1]["ap"]
	var base := {}
	var groups := {}
	for pass_n in 2:
		for name in ap.get_animation_list():
			var a := ap.get_animation(name)
			var bones := {}
			for t in a.get_track_count():
				var path := a.track_get_path(t)
				if path.get_subname_count() > 0:
					bones["%s%s" % [str(path.get_subname(0)), "@pos" if a.track_get_type(t) == Animation.TYPE_POSITION_3D else ("@scale" if a.track_get_type(t) == Animation.TYPE_SCALE_3D else "")]] = true
			if pass_n == 0:
				if str(name) == "st_wait_g":
					base = bones
				continue
			var extra: Array = bones.keys().filter(func(b): return not base.has(b))
			var missing: Array = base.keys().filter(func(b): return not bones.has(b))
			extra.sort()
			missing.sort()
			var sig := "keys %d bones; MORE than st_wait_g: %s; FEWER: %s" % [bones.size(), ", ".join(PackedStringArray(extra)) if not extra.is_empty() else "-", ", ".join(PackedStringArray(missing)) if not missing.is_empty() else "-"]
			if not groups.has(sig):
				groups[sig] = []
			(groups[sig] as Array).append(str(name))
	for sig in groups:
		var names: Array = groups[sig]
		print("POSE TRACKS %d clips (%s%s) | %s" % [names.size(), ", ".join(PackedStringArray(names.slice(0, 8))), " ..." if names.size() > 8 else "", sig])
	print("POSE done")
	quit(0)


## The old still tool's own sequence on a v2 stage: the shipped player's clips frozen on the animation player (v2 is
## not told), stage.guard() back through v2's 0.30 s join, and the picture 6 frames (0.1 s) later.
func _c458() -> void:
	for f in 6:
		await process_frame
	print("POSE C458 %s | f01 guard        | %s" % [_who(1), _line(_read(1))])
	Stage.IdleMatch.freeze(st.boxers[0], "jab", Stage.CONTACT_S)
	for f in 6:
		await process_frame
	st.guard(0)
	Stage.IdleMatch.freeze(st.boxers[1], "cross", Stage.CONTACT_S)
	for f in 6:
		await process_frame
	print("POSE C458 %s | f03 frozen cross | %s" % [_who(1), _line(_read(1))])
	st.guard(1)
	Stage.IdleMatch.freeze(st.boxers[0], "lead_hook", Stage.CONTACT_S)
	for f in 6:
		await process_frame
	st.guard(0)
	for f in 6:
		await process_frame
	print("POSE C458 %s | f05 AS SHOT (0.2 s into the join back) | %s" % [_who(1), _line(_read(1))])
	for n in 5:
		for f in 18:
			await process_frame
		print("POSE C458 %s | %.1f s later | %s" % [_who(1), float(n + 1) * 0.3, _line(_read(1))])
	print("POSE done")
	quit(0)


func _initialize() -> void:
	Engine.max_fps = 60
	Player2.force = true
	FightClips.untouched = true
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("red", "02"), "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_%s.glb" % _arg("blue", "01"), "corner": "blue"})
	if st.v2 == null:
		print("POSE FAIL the v2 player was not built")
		quit(1)
		return
	var args := OS.get_cmdline_user_args()
	var off: Array = Array(_arg("off", "").split(",", false))
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var ids: Array = BONES.map(func(b): return sk.find_bone(str(b)))
		var d: Dictionary = drawn[i]
		sk.skeleton_updated.connect(func():
			for k in BONES.size():
				d[BONES[k]] = sk.get_bone_global_pose(int(ids[k])))
	if _arg("only", "") == "c458":
		await _c458()
		return
	if _arg("only", "") == "tracks":
		_tracks()
		return
	if _arg("only", "") == "stuck":
		await _stuck()
		return
	for f in 60:
		await process_frame
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var on: Array = []
		for c in sk.get_children():
			if c is SkeletonModifier3D and (c as SkeletonModifier3D).active:
				if args.has("raw") or off.has(str(c.name)):
					(c as SkeletonModifier3D).active = false
				else:
					on.append(str(c.name))
		print("POSE %s layers on: %s | scale %.3f south %s" % [_who(i), ", ".join(PackedStringArray(on)), (st.boxers[i]["node"] as Node3D).scale.x, str(st.boxers[i].get("south", false))])
	for f in 30:
		await process_frame
	var p2: Node = st.v2
	var only := _arg("only", "")
	if only != "cross":
		for i in 2:
			await _span(i, "as played (%s)" % str((st.boxers[i]["ap"] as AnimationPlayer).current_animation), 150)
			for clip in ["pro_idle", "st_wait", "st_wait_g", "st_idle", "st_bounce_guard"]:
				if not (st.boxers[i]["ap"] as AnimationPlayer).has_animation(clip):
					continue
				p2._play(i, clip, 0.0, "guard", false)
				for f in 40:
					await process_frame
				await _span(i, clip, 150)
			p2.guard(i)
	if only != "guard":
		var rows: Dictionary = p2.db.get("rows", {})
		var show := _arg("show", "")
		for who in [1, 0]:
			var ap: AnimationPlayer = st.boxers[who]["ap"]
			for n in rows:
				var r: Dictionary = rows[n]
				var fam := str(r.get("family", ""))
				if str(r.get("kind", "")) != "punch" or not (fam in (["cross"] if who == 1 else ["cross", "lead_hook", "jab"])) or not bool(r.get("played", false)) or not (r.get("drop", []) as Array).is_empty() or not ap.has_animation(str(n)):
					continue
				if who == 0 and fam != "cross" and not args.has("all"):
					continue
				p2.guard(who)
				for f in 45:
					await process_frame
				var g := _read(who)
				p2._play(who, str(n), 0.0, "punch", true)
				var cs := float(r.get("contact_s", 0.3))
				var at := {}
				var worst_side := 1e9
				var worst_side_t := 0.0
				var worst_toes := 1e9
				var worst_head := 0.0
				var worst_head_t := 0.0
				var worst_lean := 0.0
				var seen := false
				for f in int((cs + 0.25) * 60.0):
					await process_frame
					if str(ap.current_animation) != str(n):
						break
					var tt := ap.current_animation_position
					var d := _read(who)
					if show == str(n):
						print("POSE   %s %.3f %s" % [str(n), tt, _line(d)])
					if float(d["feet_side"]) < worst_side:
						worst_side = float(d["feet_side"])
						worst_side_t = tt
					worst_toes = minf(worst_toes, float(d["toes_side"]))
					if tt <= cs + 0.05 and float(d["head_off"]) > worst_head:
						worst_head = float(d["head_off"])
						worst_head_t = tt
					worst_lean = maxf(worst_lean, absf(float(d["lean_side"])))
					if not seen and tt >= cs - 0.008:
						seen = true
						at = d
				if at.is_empty():
					print("POSE CROSS %s | %s never reached its contact" % [_who(who), str(n)])
					continue
				print("POSE PUNCH %s | %s (%s) contact %.2f s | guard before: feet side %+.0f fwd %+.0f apart %.0f, head off %.0f, toes L %+.0f R %+.0f deg, ankle over ball L %.1f R %.1f cm, knee R %.0f" % [_who(who), str(n), fam, cs, g["feet_side"], g["feet_fwd"], g["feet_apart"], g["head_off"], g["toe_l"], g["toe_r"], g["heel_l"], g["heel_r"], g["knee_r"]])
				print("POSE PUNCH %s | %s | AT CONTACT %s" % [_who(who), str(n), _line(at)])
				print("POSE PUNCH %s | %s | WORST feet side %+.0f cm at %.2f s (toes %+.0f), head off %.0f deg at %.2f s, trunk side lean %.0f deg" % [_who(who), str(n), worst_side, worst_side_t, worst_toes, worst_head, worst_head_t, worst_lean])
			p2.guard(who)
	print("POSE done")
	quit(0)
