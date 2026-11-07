extends SceneTree
## S399 ROKOKO2 - the Rokoko windows measured the way tools/raw_fbx_window.py measures the raw take, so the two compare
## like for like (planted toe-ball slide, leg snaps on the 8 leg bones' parent-relative turns, hips wander, stance).
##   mode=yaw   each RkClips window built with NO turn on a bare body: the fist's travel off +Z at full reach (punch) or
##              the hands' offset from the hips (guard), the turn that faces it at the opponent (yaw_deg) and contact_s.
##   mode=clip  each window as built (turned), on a bare body, no modifiers: what the retarget itself delivers.
##   mode=fight (default) each clip played on red in the fight stage (FightStage: the whole modifier stack, RingFeet,
##              RingPlace) after 1.5 s of her guard, measured on the DRAWN pose - bones read INSIDE skel.skeleton_updated
##              (outside it they are the clip without modifiers, tools/stance_probe.gd). clip=<name>@<t0>-<t1> plays a
##              window of any loaded clip (main's owned bake rk_boxing@2.10-2.77 = the broken S381 route).
##   <godot.exe> --headless --path . --script res://tools/rokoko_feet_probe.gd -- [mode=fight] [clips=a,b@t0-t1] [glb=mh_boxer_13]
## Prints RKFEET <clip> slide_m= leg_snaps= worst_deg= hips_xz_m= stance_m= frames= [pure=] per clip.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const RkClips := preload("res://scripts/fight3d/RkClips.gd")
const RkRetarget := preload("res://scripts/fight3d/RkRetarget.gd")
const DT := 1.0 / 30.0
const PLANT_M := 0.03
const SNAP_DEG := 6.0
const LEGS := ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes", "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]


func _arg(k: String, dflt: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(k + "="):
			return str(a).substr(k.length() + 1)
	return dflt


func _initialize() -> void:
	var glb := "res://assets/models/metahuman/%s.glb" % _arg("glb", "mh_boxer_13")
	var mode := _arg("mode", "fight")
	RkRetarget.xz_gain = float(_arg("rkxz", "1.0"))
	var clips: Array = Array(_arg("clips", ",".join(RkClips.CLIPS.keys())).split(",", false))
	if mode == "fight":
		await _fight(glb, clips)
	elif mode == "find":
		_find(glb, _arg("take", "Boxing"))
	elif mode == "steps":
		_steps(glb, _arg("take", "ShadowBoxing"))
	else:
		_bare(glb, clips, mode == "yaw")
	quit(0)


## --- bare body: the clip alone, posed bone by bone (no modifiers, no stage) ---
func _bare(glb: String, clips: Array, yaw_mode: bool) -> void:
	var body := MH.load_fighter(glb)
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var to_body := body.global_transform.affine_inverse() * skel.global_transform
	for name in clips:
		if not RkClips.CLIPS.has(name):
			continue
		var t_start := Time.get_ticks_msec()
		var anim := RkClips.build(skel, str(name), 0.0 if yaw_mode else INF)
		var ms := Time.get_ticks_msec() - t_start
		var w: Dictionary = RkClips.CLIPS[name]
		var n := int(round(anim.length / DT)) + 1
		var loco := {}
		if bool(w.get("loco", false)):   # an in-place loco clip: add its root curve back (her body travels by it)
			const RkLoco := preload("res://scripts/fight3d/RkLoco.gd")
			RkLoco.register(str(name), anim, skel, body, int(w.get("cycles", 1)))
			loco = RkLoco.info(skel, str(name))
		var frames: Array = []
		for f in n:
			var t := minf(f * DT, anim.length)
			for tr in anim.get_track_count():
				var b := skel.find_bone(str(anim.track_get_path(tr)))
				if b < 0:
					continue
				if anim.track_get_type(tr) == Animation.TYPE_ROTATION_3D:
					skel.set_bone_pose_rotation(b, anim.rotation_track_interpolate(tr, t))
				else:
					skel.set_bone_pose_position(b, anim.position_track_interpolate(tr, t))
			var off: Vector3 = Vector3.ZERO
			if not loco.is_empty():
				const RkLoco2 := preload("res://scripts/fight3d/RkLoco.gd")
				off = RkLoco2.sample(loco, t)
			frames.append(_pose(skel, func(i: int) -> Transform3D: return Transform3D(Basis.IDENTITY, off) * to_body * _global(skel, i)))
		if yaw_mode:
			_report_yaw(str(name), w, frames)
		else:
			var sc := float(anim.get_meta("rk_scale", 1.0))
			print("RKFEET %s (clip alone) %s build_ms=%d scale=%.3f" % [name, _measure(frames), ms, sc])
			if OS.get_cmdline_user_args().has("scaled"):   # the plant line at the actor's 3 cm, scaled to this body
				print("RKFEET %s (clip alone, plant %.4f m) %s" % [name, PLANT_M * sc, _measure(frames, PLANT_M * sc)])


## mode=find take=<Boxing|ShadowBoxing|FightingIdle>: every single punch in the whole take, as played ORTHODOX on our rig
## (the take mirrored where the actor stands southpaw): a fist's reach from the chest peaks over 0.48 m while the other
## stays within 0.32 m of the head, the lead foot on the punch's side for a jab (orthodox: the left), both fists within
## 0.45 m of the head at the 0.67 s window's two ends (PEAK_S before the peak, the rest after).
const PEAK_S := 0.30
const WIN_S := 0.67
func _find(glb: String, take: String) -> void:
	var body := MH.load_fighter(glb)
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var to_body := body.global_transform.affine_inverse() * skel.global_transform
	var path := RkClips.DIR + take + "_mixamo.fbx"
	for mirrored in [false, true]:
		var anim := RkRetarget.build(skel, path, 0.0, 999.0, true)
		if mirrored:
			anim = RkClips.mirrored(anim, skel)
		var frames: Array = []
		for f in int(anim.length / DT) + 1:
			var t := minf(f * DT, anim.length)
			for tr in anim.get_track_count():
				var b := skel.find_bone(str(anim.track_get_path(tr)))
				if b < 0:
					continue
				if anim.track_get_type(tr) == Animation.TYPE_ROTATION_3D:
					skel.set_bone_pose_rotation(b, anim.rotation_track_interpolate(tr, t))
				else:
					skel.set_bone_pose_position(b, anim.position_track_interpolate(tr, t))
			frames.append(_pose(skel, func(i: int) -> Transform3D: return to_body * _global(skel, i)))
		var reach := func(p: Dictionary, h: String) -> float:
			var d: Vector3 = p[h] - p["UpperChest"]
			return Vector2(d.x, d.z).length()
		for hand in ["LeftHand", "RightHand"]:
			var other := "RightHand" if hand == "LeftHand" else "LeftHand"
			for i in range(1, frames.size() - 1):
				var r: float = reach.call(frames[i], hand)
				if r < 0.48 or r < reach.call(frames[i - 1], hand) or r < reach.call(frames[i + 1], hand):
					continue
				var p: Dictionary = frames[i]
				if ((p[other] as Vector3) - (p["Head"] as Vector3)).length() > 0.32:
					continue
				var pd: Vector3 = p[hand] - p["UpperChest"]
				var fd: Vector3 = p["LeftToes"] - p["RightToes"]
				var lead_left := Vector2(fd.x, fd.z).dot(Vector2(pd.x, pd.z)) > 0.0   # the left foot toward the punch
				var a := i - int(round(PEAK_S / DT))
				var e := a + int(round(WIN_S / DT))
				if a < 0 or e >= frames.size():
					continue
				var ends := 0.0
				for k in [a, e]:
					for h in ["LeftHand", "RightHand"]:
						ends = maxf(ends, ((frames[k][h] as Vector3) - (frames[k]["Head"] as Vector3)).length())
				var back := -1.0   # the first frame after the peak with the punching fist home (within 0.28 m of the head)
				for k in range(i + 1, mini(i + 30, frames.size())):
					if ((frames[k][hand] as Vector3) - (frames[k]["Head"] as Vector3)).length() <= 0.28:
						back = (k - i) * DT
						break
				var left_home := -1.0   # the last frame BEFORE the peak with the punching fist home
				for k in range(i - 1, maxi(i - 30, -1), -1):
					if ((frames[k][hand] as Vector3) - (frames[k]["Head"] as Vector3)).length() <= 0.28:
						left_home = (i - k) * DT
						break
				if left_home > 0.0 and back > 0.0:
					print("RKCUT %s mirrored=%s %s %s peak %.2f home-to-home %.2f-%.2f s (%.2f s, contact %.2f s in)" % [take, mirrored,
						("JAB" if hand == "LeftHand" else "CROSS") if Vector2(fd.x, fd.z).dot(Vector2(pd.x, pd.z)) > 0.0 else "southpaw", hand,
						i * DT, i * DT - left_home - DT, i * DT + back + 2 * DT, left_home + back + 3 * DT, left_home + DT])
				var arm: Vector3 = p[hand] - p[hand.replace("Hand", "UpperArm")]
				var kind := ("JAB" if hand == "LeftHand" else "CROSS") if lead_left else "southpaw-stance"
				print("RKFIND %s mirrored=%s %s %s peak %.2f s reach %.2f m window %.2f-%.2f ends_fist_head %.2f m%s yaw %.1f" % [
					take, mirrored, kind, hand, i * DT, r, a * DT, e * DT, ends, " GUARD-OK" if ends <= 0.45 else "", -rad_to_deg(atan2(arm.x, arm.z))] + (" home %.2f s after the peak" % back))


## mode=steps take=<..>: captured STEPPING in guard - 1.5 s windows (every 0.1 s) where the hips travel on the floor while
## both fists stay within 0.36 m of the head every frame (no punch). Prints the travel, its direction against the facing
## (the hands' offset from the hips), and both feet's travel (a step, not a lean).
func _steps(glb: String, take: String) -> void:
	var body := MH.load_fighter(glb)
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var to_body := body.global_transform.affine_inverse() * skel.global_transform
	var anim := RkRetarget.build(skel, RkClips.DIR + take + "_mixamo.fbx", 0.0, 999.0, true)
	var frames: Array = []
	for f in int(anim.length / DT) + 1:
		var t := minf(f * DT, anim.length)
		for tr in anim.get_track_count():
			var b := skel.find_bone(str(anim.track_get_path(tr)))
			if b < 0:
				continue
			if anim.track_get_type(tr) == Animation.TYPE_ROTATION_3D:
				skel.set_bone_pose_rotation(b, anim.rotation_track_interpolate(tr, t))
			else:
				skel.set_bone_pose_position(b, anim.position_track_interpolate(tr, t))
		frames.append(_pose(skel, func(i: int) -> Transform3D: return to_body * _global(skel, i)))
	var span := int(1.5 / DT)
	var a := 0
	while a + span < frames.size():
		var worst := 0.0
		for k in range(a, a + span + 1):
			for h in ["LeftHand", "RightHand"]:
				worst = maxf(worst, ((frames[k][h] as Vector3) - (frames[k]["Head"] as Vector3)).length())
		var h0: Vector3 = frames[a]["Hips"]
		var h1: Vector3 = frames[a + span]["Hips"]
		var tv := Vector2(h1.x - h0.x, h1.z - h0.z)
		if worst <= 0.36 and tv.length() >= 0.25:
			var face: Vector3 = (frames[a]["LeftHand"] + frames[a]["RightHand"]) * 0.5 - h0
			var rel := rad_to_deg(Vector2(face.x, face.z).angle_to(tv))
			var fl := Vector2((frames[a + span]["LeftToes"] as Vector3).x - (frames[a]["LeftToes"] as Vector3).x, (frames[a + span]["LeftToes"] as Vector3).z - (frames[a]["LeftToes"] as Vector3).z).length()
			var fr := Vector2((frames[a + span]["RightToes"] as Vector3).x - (frames[a]["RightToes"] as Vector3).x, (frames[a + span]["RightToes"] as Vector3).z - (frames[a]["RightToes"] as Vector3).z).length()
			print("RKSTEP %s %.2f-%.2f s travel %.2f m at %.0f deg off her facing (0 fwd, 180 back) fists<=%.2f m feet %.2f/%.2f m" % [take, a * DT, (a + span) * DT, tv.length(), rel, worst, fl, fr])
		a += 3


func _report_yaw(name: String, w: Dictionary, frames: Array) -> void:
	if not w.has("hand"):
		var sum := Vector2.ZERO
		for p in frames:
			var hp: Vector3 = (p["LeftHand"] + p["RightHand"]) * 0.5 - p["Hips"]
			sum += Vector2(hp.x, hp.z)
		var ang := rad_to_deg(atan2(sum.x, sum.y))
		print("RKYAW %s guard hands off +Z %.1f deg -> yaw_deg %.1f (shipped %.1f)" % [name, ang, -ang, float(w["yaw_deg"])])
		return
	for hh in ["LeftHand", "RightHand"]:   # which fist actually goes out, and the arm-line turn of each
		var far := -1.0
		var far_t := 0.0
		var far_aim := 0.0
		for i in frames.size():
			var q: Vector3 = frames[i][hh] - frames[i]["UpperChest"]
			if Vector2(q.x, q.z).length() > far:
				far = Vector2(q.x, q.z).length()
				far_t = i * DT
				var a2: Vector3 = frames[i][hh] - frames[i][hh.replace("Hand", "UpperArm")]
				far_aim = rad_to_deg(atan2(a2.x, a2.z))
		var lead := 0.0
		for p in frames:
			lead += ((p["LeftToes"] as Vector3).z - (p["RightToes"] as Vector3).z) / frames.size()
		print("RKYAW %s BOTH %s reach %.2f m at %.3f s, arm line there %.1f deg -> yaw %.1f | lead_L at yaw 0 %.2f" % [name, hh, far, far_t, far_aim, -far_aim, lead])
	var hand := str(w["hand"])
	var best := -1.0
	var at := 0
	for i in frames.size():
		var p: Dictionary = frames[i]
		var d: Vector3 = p[hand] - p["UpperChest"]
		if Vector2(d.x, d.z).length() > best:
			best = Vector2(d.x, d.z).length()
			at = i
	var dd: Vector3 = frames[at][hand] - frames[at]["UpperChest"]
	var ang2 := rad_to_deg(atan2(dd.x, dd.z))
	# the fist's TRAVEL: full reach minus where it left from (its most-pulled-back frame before the reach), off the hips
	var back := 0
	var least := INF
	for i in at:
		var q: Vector3 = frames[i][hand] - frames[i]["UpperChest"]
		if Vector2(q.x, q.z).length() < least:
			least = Vector2(q.x, q.z).length()
			back = i
	var tv: Vector3 = (frames[at][hand] - frames[at]["Hips"]) - (frames[back][hand] - frames[back]["Hips"])
	var ang3 := rad_to_deg(atan2(tv.x, tv.z))
	# the OLD probe's aim (old tools/rokoko_window_probe.gd, which set the shipped 34.8 / 32.5): the ARM's line, upper arm
	# to hand, at its longest frame
	var arm := hand.replace("Hand", "UpperArm")
	var longest := -1.0
	var aim := 0.0
	var aim_t := 0.0
	for i in frames.size():
		var a: Vector3 = frames[i][hand] - frames[i][arm]
		if a.length() > longest:
			longest = a.length()
			aim = rad_to_deg(atan2(a.x, a.z))
			aim_t = i * DT
	print("RKYAW %s OLD-WAY arm line at its longest (%.3f s) %.1f deg off +Z -> yaw_deg %.1f" % [name, aim_t, aim, -aim])
	print("RKYAW %s %s full reach %.2f m at %.3f s; offset from chest %.1f deg off +Z; TRAVEL %.2f m from %.3f s, %.1f deg off +Z -> yaw_deg %.1f (shipped %.1f, contact_s shipped %.2f)" % [
		name, hand, best, at * DT, ang2, tv.length(), back * DT, ang3, -ang3, float(w["yaw_deg"]), float(w.get("contact_s", -1.0))])


## --- the fight stage: the drawn pose ---
func _fight(glb: String, clips: Array) -> void:
	var stage: Node3D = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": glb, "corner": "red"}, {"glb": glb, "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var drawn := {"pose": {}}
	skel.skeleton_updated.connect(func():
		var x := skel.global_transform
		drawn["pose"] = _pose(skel, func(i: int) -> Transform3D: return x * skel.get_bone_global_pose(i)))
	var mods: Array = skel.get_children().filter(func(c): return c is SkeletonModifier3D)
	print("RKFEET modifiers: ", ", ".join(mods.map(func(c): return str(c.name))))
	if _arg("mode", "fight") == "fight" and OS.get_cmdline_user_args().has("loco"):
		# S399 locomotion: the fight asks for a step (Footwork.walk), the picker plays a captured step clip and its own hip
		# travel moves her; the drawn toes in WORLD space while she travels
		for ask in ["advance:0.40", "retreat:0.50", "strafe_left:0.30", "strafe_right:0.30", "advance:0.15"]:
			stage.guard(0)
			for f in 45:
				await _step(stage)
			var dir := str(ask).get_slice(":", 0)
			var metres := str(ask).get_slice(":", 1).to_float()
			var p0: Vector3 = bx["pos"]
			stage.feet.walk(0, dir, metres / (float(stage.feet.STRIDE[dir][0]) * stage.feet.WALK_SCALE), stage.feet.WALK_SCALE)
			var clip := str(ap.current_animation)
			var frames: Array = []
			for f in 300:
				await _step(stage)
				if str(ap.current_animation) != clip:
					break
				if not (drawn["pose"] as Dictionary).is_empty():
					frames.append(drawn["pose"])
			var p1: Vector3 = bx["pos"]
			print("RKLOCO %s %.2f m asked -> %s, moved %.2f m: %s" % [dir, metres, clip, Vector2(p1.x - p0.x, p1.z - p0.z).length(), _measure(frames)])
			print("RKLOCO %s after the 0.3 s join: %s" % [clip, _measure(frames.slice(9))])
		return
	for spec in clips:
		var name := str(spec).get_slice("@", 0)
		var win := str(spec).get_slice("@", 1) if str(spec).contains("@") else ""
		if not ap.has_animation(name):
			print("RKFEET %s not loaded" % spec)
			continue
		stage.guard(0)
		for f in 45:
			await _step(stage)
		var t0 := win.get_slice("-", 0).to_float() if win != "" else 0.0
		var t1 := win.get_slice("-", 1).to_float() if win != "" else ap.get_animation(name).length
		if name.begins_with("rk_guard") or name in ["pro_idle", "idle"]:
			stage._start(0, name, 1.0, Stage.GUARD_FADE_S)
		else:
			stage.play(0, name, 1.0)
		if t0 > 0.0:
			ap.seek(t0, true)
		var frames: Array = []
		var pure_min := 1.0
		var step_frames := 0
		var n := int(round((t1 - t0) / DT))
		for f in n:
			await _step(stage)
			if str(ap.current_animation) != name:
				break
			if not (drawn["pose"] as Dictionary).is_empty():
				frames.append(drawn["pose"])
				if OS.get_cmdline_user_args().has("trace"):
					var pz: Dictionary = drawn["pose"]
					print("TRACE %s f%d t=%.3f L%s R%s hips%s node%s yaw=%.1f" % [name, f, ap.current_animation_position, pz["LeftToes"], pz["RightToes"], pz["Hips"],
						(bx["node"] as Node3D).global_position, rad_to_deg((bx["node"] as Node3D).global_rotation.y)])
			pure_min = minf(pure_min, float(bx.get("rk_pure", 0.0)) if f >= 6 else 1.0)
			if bx.get("rig") != null and not ((bx["rig"] as Node).plan.pair as Dictionary).is_empty():
				step_frames += 1
		print("RKFEET %s (drawn, fight) %s pure_min_after_0.2s=%.2f rig_step_frames=%d" % [spec, _measure(frames), pure_min, step_frames])
		# the join (JoinSmoother, 0.3 s) carries her from the last clip's feet to this one's; after it, the clip alone
		print("RKFEET %s (drawn, fight, after the 0.3 s join) %s" % [spec, _measure(frames.slice(9))])


func _step(stage: Node3D) -> void:
	stage.aim({"phase": "rest", "who": -1, "move": "jab"})
	stage._process(DT)
	await process_frame


func _pose(skel: Skeleton3D, g: Callable) -> Dictionary:
	var out := {}
	for b in LEGS + ["Hips", "UpperChest", "LeftHand", "RightHand", "LeftUpperArm", "RightUpperArm", "Head"]:
		var i := skel.find_bone(b)
		var tf: Transform3D = g.call(i)
		out[b] = tf.origin
		out[b + "_q"] = tf.basis.get_rotation_quaternion()
	for b in LEGS:
		var p := skel.get_bone_parent(skel.find_bone(b))
		out[b + "_local"] = ((g.call(p) as Transform3D).basis.get_rotation_quaternion().inverse() * (out[b + "_q"] as Quaternion)).normalized()
	return out


func _measure(frames: Array, plant: float = PLANT_M) -> String:
	if frames.size() < 3:
		return "frames=%d (too few)" % frames.size()
	var slide := 0.0
	for toe in ["LeftToes", "RightToes"]:
		var low := INF
		for p in frames:
			low = minf(low, (p[toe] as Vector3).y)
		for i in range(1, frames.size()):
			var a: Vector3 = frames[i - 1][toe]
			var b: Vector3 = frames[i][toe]
			if a.y - low < plant and b.y - low < plant:
				slide += Vector2(b.x - a.x, b.z - a.z).length()
	var snaps := 0
	var worst := 0.0
	for leg in LEGS:
		var prev := Quaternion.IDENTITY
		for i in range(1, frames.size()):
			var turn: Quaternion = (frames[i][leg + "_local"] as Quaternion) * (frames[i - 1][leg + "_local"] as Quaternion).inverse()
			if i >= 2:
				var d := rad_to_deg(turn.angle_to(prev))
				snaps += 1 if d > SNAP_DEG else 0
				worst = maxf(worst, d)
			prev = turn
	var h0: Vector3 = frames[0]["Hips"]
	var wander := 0.0
	var stance := 0.0
	var low_toe := INF
	for p in frames:
		wander = maxf(wander, Vector2((p["Hips"] as Vector3).x - h0.x, (p["Hips"] as Vector3).z - h0.z).length())
		var d: Vector3 = p["LeftToes"] - p["RightToes"]
		stance += Vector2(d.x, d.z).length()
		low_toe = minf(low_toe, minf((p["LeftToes"] as Vector3).y, (p["RightToes"] as Vector3).y))
	var lead := 0.0   # + = the LEFT foot ahead of the right along +Z (orthodox), metres, mean over the window
	for p in frames:
		lead += ((p["LeftToes"] as Vector3).z - (p["RightToes"] as Vector3).z) / frames.size()
	var sh := 0.0   # + = the LEFT shoulder ahead
	for p in frames:
		sh += ((p["LeftUpperArm"] as Vector3).z - (p["RightUpperArm"] as Vector3).z) / frames.size()
	lead = snappedf(lead, 0.01)
	return ("shoulder_L_m=%.2f " % sh) + "lead_L_m=%.2f slide_m=%.3f leg_snaps=%d worst_deg=%.1f hips_xz_m=%.3f stance_m=%.3f toe_low_y=%.3f frames=%d" % [
		lead, slide, snaps, worst, wander, stance / frames.size(), low_toe, frames.size()]


## A bone's pose in skeleton space up its parent chain from the local poses just set (headless: no global cache refresh).
static func _global(skel: Skeleton3D, b: int) -> Transform3D:
	var tf := skel.get_bone_pose(b)
	var p := skel.get_bone_parent(b)
	while p >= 0:
		tf = skel.get_bone_pose(p) * tf
		p = skel.get_bone_parent(p)
	return tf
