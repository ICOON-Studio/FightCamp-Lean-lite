extends SceneTree
## BODYLOOK1 (S492, operator: "their walking too"; the intro walk-in still showed knees folded in and feet crossing). The
## corner-to-centre walk in the game is the ow_walk clip (CornerCrew.walk; the captured rk_ takes are opt-in) with the
## footwork rig let go, under the leg layers (KneeTrack, FootPlant, FootLock, FloorStand). Plays it on both boxers of the
## real stage, the body carried at CornerCrew's speed, and after every skeleton update measures in her own frame: the
## ankles' sideways gap (a human walks with ~8-14 cm between the ankle centres; under 4 cm or negative = feet crossing)
## and each knee's offset from its hip-ankle line (+ = inward, knock-kneed); and her posture: the trunk's lean and the
## knees' bend (a human walk: trunk 2-6 deg forward, the stance knee almost straight - under ~10 deg - once a step,
## about 60 deg at most in the swing). `raw` = every leg layer off: the clip as
## baked, the control arm. `clip=<name>` another clip, `off=A,B` those layers alone off, `fight` = outside a scene.
##   <godot> --headless --fixed-fps 60 --path . --script res://tools/bodylook_walk.gd -- [raw] [clip=af_walk]
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RingFeet := preload("res://scripts/fight3d/RingFeet.gd")
const CornerCrew := preload("res://scripts/fight3d/CornerCrew.gd")
const SECONDS := 4.0

var stage: Node3D
var raw := false
var rows := {0: [], 1: []}
var t := 0.0
var clip := "ow_walk"
var off: Array = []   # `off=FootPlant,FootLock`: these layers alone switched off (which one bends the walk)


func _initialize() -> void:
	raw = OS.get_cmdline_user_args().has("raw")
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("clip="):
			clip = str(a).substr(5)
		if str(a).begins_with("off="):
			off = Array(str(a).substr(4).split(","))
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_14.glb", "corner": "blue"})
	stage.set_process(false)   # no fight: this probe is the director
	# The intro and the corner minute are SCENES: FloorStand and FootLock let go there by their own rule. `fight` = not a
	# scene (those two layers on), to see what they would do to a walk.
	stage.set("scene", not OS.get_cmdline_user_args().has("fight"))
	for i in 2:
		var bx: Dictionary = stage.boxers[i]
		RingFeet.release(bx)
		if not (bx["ap"] as AnimationPlayer).has_animation(clip):
			print("BODYLOOK_WALK boxer=%d has no clip %s" % [i, clip])
			quit(1)
			return
		if i == 0:
			var an := (bx["ap"] as AnimationPlayer).get_animation(clip)
			var rate: float = CornerCrew.OW_WALK_RATE if clip == "ow_walk" else 1.0
			var ms: float = CornerCrew.OW_WALK_MS if clip == "ow_walk" else CornerCrew.WALK_MS
			print("BODYLOOK_WALK clip %s: one stride cycle %.2f s, played at %.2fx = %.2f s a cycle = %.0f steps a minute at %.2f m/s (captured: %.0f steps a minute at %.2f m/s)" % [
				clip, an.length, rate, an.length / rate, 120.0 * rate / an.length, ms * rate, 120.0 / an.length, ms])
		(bx["node"] as Node3D).position = Vector3(-2.0 + 4.0 * i, 0, -1.5)
		(bx["node"] as Node3D).rotation.y = 0.0
		var skel: Skeleton3D = bx["skel"]
		if i == 0:
			print("BODYLOOK_WALK layers: ", skel.get_children().filter(func(c): return c is SkeletonModifier3D).map(func(c): return str(c.name)))
		for c in skel.get_children():
			if c is SkeletonModifier3D and c.name != "MetaHumanTwist" and (raw or off.has(str(c.name))):
				(c as SkeletonModifier3D).active = false
		(bx["ap"] as AnimationPlayer).play(clip, -1, CornerCrew.OW_WALK_RATE if clip == "ow_walk" else 1.0)
		skel.skeleton_updated.connect(_sample.bind(i))
	while t < SECONDS:
		await process_frame
		t += 1.0 / 60.0
		for i in 2:   # CornerCrew.tick: the body is carried forward at the clip's ground speed
			var n: Node3D = stage.boxers[i]["node"]
			var speed: float = (CornerCrew.OW_WALK_MS * CornerCrew.OW_WALK_RATE if clip == "ow_walk" else CornerCrew.WALK_MS) * n.scale.x
			n.position += n.global_transform.basis.z.normalized() * speed / 60.0
	for i in 2:
		_report(i)
	quit()


func _sample(i: int) -> void:
	if t < 0.5:
		return   # the join into the clip
	var bx: Dictionary = stage.boxers[i]
	var skel: Skeleton3D = bx["skel"]
	var node: Node3D = bx["node"]
	var g := func(b: String) -> Vector3: return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(b)).origin
	var hips: Vector3 = g.call("Hips")
	var basis := node.global_transform.basis.orthonormalized()
	var right := basis.x
	var la: Vector3 = g.call("LeftFoot")
	var ra: Vector3 = g.call("RightFoot")
	var lk: Vector3 = g.call("LeftLowerLeg")
	var rk: Vector3 = g.call("RightLowerLeg")
	var lh: Vector3 = g.call("LeftUpperLeg")
	var rh: Vector3 = g.call("RightUpperLeg")
	# her left is +x in a MetaHuman's own frame (the left joints sit at +x in rest)
	var gap := (la - ra).dot(right) * signf((lh - rh).dot(right))
	var inward_l := _inward(lh, lk, la, right, 1.0 if (lh - rh).dot(right) > 0 else -1.0)
	var inward_r := _inward(rh, rk, ra, right, -1.0 if (lh - rh).dot(right) > 0 else 1.0)
	# posture: the trunk's lean (hips to neck against upright, + = forward) and each knee's bend (0 = a straight leg)
	var fwd := basis.z
	var trunk: Vector3 = (g.call("Neck") as Vector3) - hips
	var lean := rad_to_deg(atan2(trunk.dot(fwd), trunk.y))
	var bend_l := rad_to_deg((lk - lh).angle_to(la - lk))
	var bend_r := rad_to_deg((rk - rh).angle_to(ra - rk))
	# the standing foot: the lower ankle against the ankle's own height when she stands in rest pose (0 = on the canvas)
	var rest_ankle: float = skel.get_bone_global_rest(skel.find_bone("LeftFoot")).origin.y * node.scale.y
	var low_ankle := minf(la.y, ra.y) - node.global_position.y - rest_ankle
	rows[i].append([gap, inward_l, inward_r, lean, bend_l, bend_r, hips.y / node.scale.y, low_ankle])


func _arm() -> String:
	var mode := "scene" if bool(stage.get("scene")) else "fight"
	return "raw" if raw else (mode if off.is_empty() else mode + " off=" + ",".join(off))


## The knee's sideways offset from the hip-ankle line, + toward the body's middle. `side` = +1 for the leg on +right.
static func _inward(hip: Vector3, knee: Vector3, ankle: Vector3, right: Vector3, side: float) -> float:
	var axis := (ankle - hip)
	var tt := clampf((knee - hip).dot(axis) / maxf(axis.length_squared(), 1e-6), 0.0, 1.0)
	var off := knee - (hip + axis * tt)
	return -off.dot(right) * side


func _report(i: int) -> void:
	var r: Array = rows[i]
	if r.is_empty():
		print("BODYLOOK_WALK boxer=%d no samples" % i)
		return
	var gaps: Array = r.map(func(x): return x[0])
	var knee: Array = []
	for x in r:
		knee.append(x[1])
		knee.append(x[2])
	gaps.sort()
	knee.sort()
	var crossed := gaps.filter(func(x): return x < 0.04).size()
	var leans: Array = r.map(func(x): return x[3])
	leans.sort()
	var bends: Array = []
	for x in r:
		bends.append(x[4])
		bends.append(x[5])
	bends.sort()
	var hip_y: Array = r.map(func(x): return x[6])
	hip_y.sort()
	var feet: Array = r.map(func(x): return x[7])
	feet.sort()
	print("BODYLOOK_WALK %s %s boxer=%d standing_ankle_over_rest_m min=%.3f median=%.3f max=%.3f" % [_arm(), clip, i, feet[0], feet[feet.size() / 2], feet[-1]])
	print("BODYLOOK_WALK %s %s boxer=%d trunk_lean_deg median=%.1f (min %.1f max %.1f) knee_bend_deg straightest=%.1f median=%.1f deepest=%.1f hips_height_m median=%.3f bob=%.3f" % [
		_arm(), clip, i, leans[leans.size() / 2], leans[0], leans[-1], bends[0], bends[bends.size() / 2], bends[-1],
		hip_y[hip_y.size() / 2], hip_y[-1] - hip_y[0]])
	print("BODYLOOK_WALK %s %s boxer=%d frames=%d ankle_gap_m min=%.3f p10=%.3f median=%.3f under4cm=%d%% knee_in_m median=%.3f p90=%.3f max=%.3f" % [
		_arm(), clip, i, r.size(), gaps[0], gaps[int(gaps.size() * 0.1)], gaps[gaps.size() / 2],
		int(100.0 * crossed / r.size()), knee[knee.size() / 2], knee[int(knee.size() * 0.9)], knee[-1]])
