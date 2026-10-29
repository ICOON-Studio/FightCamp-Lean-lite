extends RefCounted
## S305 pose matching (operator: "make it more fluid", "doesnt always reset to a default clip"). The way shipped games join
## an action back into a loop (motion matching, Unreal's pose search): instead of restarting the guard idle at a random
## point, enter it at the frame whose pose is nearest the one she shows. Hands and head relative to the hips, in her own
## frame, at SAMPLES points of the loop; one of the PICK nearest at random, so the two boxers never fall into step.
## Pure apart from the skeleton reads; zero preloads.

const SAMPLES := 32
const PICK := 3
const BONES := ["LeftHand", "RightHand", "Head"]


## {clip, t: [s], p: [[Vector3 per BONES]]} for boxer `bx` ({ap, skel, node}); {} without an idle. Plays the clip: call
## before the fight starts.
static func sample(bx: Dictionary, idle: String) -> Dictionary:
	var ap: AnimationPlayer = bx["ap"]
	if idle == "" or not ap.has_animation(idle):
		return {}
	var length := ap.get_animation(idle).length
	var ts: Array = []
	var poses: Array = []
	for k in SAMPLES:
		var t := length * float(k) / float(SAMPLES)
		var hips := pose_point(bx, idle, t, "Hips")
		var p: Array = []
		for bone in BONES:
			p.append(pose_point(bx, idle, t, bone) - hips)
		ts.append(t)
		poses.append(p)
	return {"clip": idle, "t": ts, "p": poses}


## The idle time to enter at for boxer `bx` ({skel, node, idle_match}); `fallback` when the loop was not sampled.
static func pick(bx: Dictionary, idle: String, fallback: float, rng: RandomNumberGenerator) -> float:
	var m: Dictionary = bx.get("idle_match", {})
	if m.is_empty() or str(m["clip"]) != idle:
		return fallback
	var now := current(bx)
	var scored: Array = []
	for k in (m["t"] as Array).size():
		scored.append([distance(m["p"][k], now), float(m["t"][k])])
	scored.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
	return float(scored[rng.randi() % mini(PICK, scored.size())][1])


## The pose she shows now, the same way sample() reads it.
static func current(bx: Dictionary) -> Array:
	var skel: Skeleton3D = bx["skel"]
	var to_body := (bx["node"] as Node3D).global_transform.affine_inverse() * skel.global_transform
	var hips := to_body * skel.get_bone_global_pose(skel.find_bone("Hips")).origin
	var out: Array = []
	for bone in BONES:
		out.append(to_body * skel.get_bone_global_pose(skel.find_bone(bone)).origin - hips)
	return out


## Sum of squared distances, bone by bone.
static func distance(a: Array, b: Array) -> float:
	var d := 0.0
	for j in mini(a.size(), b.size()):
		d += ((a[j] as Vector3) - (b[j] as Vector3)).length_squared()
	return d


## A bone's point in the body's own frame (facing +Z, unscaled) at time t of a clip (FightStage moved it here, S305).
static func pose_point(bx: Dictionary, move: String, t: float, bone: String) -> Vector3:
	var ap: AnimationPlayer = bx["ap"]
	ap.play(move)
	ap.seek(t, true)
	var skel: Skeleton3D = bx["skel"]
	var to_body := (bx["node"] as Node3D).global_transform.affine_inverse() * skel.global_transform
	return to_body * skel.get_bone_global_pose(skel.find_bone(bone)).origin


## Freezes boxer `bx` at time t of a move, for stills and probes (FightStage.pose moved here, S305).
static func freeze(bx: Dictionary, move: String, t: float) -> void:
	var ap: AnimationPlayer = bx["ap"]
	ap.play(move)
	ap.seek(t, true)
	ap.pause()
