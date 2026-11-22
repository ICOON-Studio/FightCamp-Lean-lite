extends RefCounted
## KNEEROOT1 (S537): the rulers of tools/kneeroot_probe.gd and tools/kneeroot_still.gd, and the bought FBX take read at
## run time (FBXDocument: the raw files stay out of the project, E:/FightCamp/packs).
## The same maths for the bought take on its own skeleton and for our body as drawn: each leg from four world points.

const GAME_BONES := {"hips": "Hips", "chest": "UpperChest", "head": "Head",
	"hip_L": "LeftUpperLeg", "knee_L": "LeftLowerLeg", "ankle_L": "LeftFoot", "toe_L": "LeftToes",
	"hip_R": "RightUpperLeg", "knee_R": "RightLowerLeg", "ankle_R": "RightFoot", "toe_R": "RightToes",
	"hand_L": "LeftHand", "hand_R": "RightHand", "elbow_L": "LeftLowerArm", "elbow_R": "RightLowerArm"}
## The same joints by their names in the bought files (MoCap Online; Mixamo adds a `mixamorig:` prefix).
const SRC_BONES := {"hips": "Hips", "chest": "Spine2", "head": "Head",
	"hip_L": "LeftUpLeg", "knee_L": "LeftLeg", "ankle_L": "LeftFoot", "toe_L": "LeftToeBase",
	"hip_R": "RightUpLeg", "knee_R": "RightLeg", "ankle_R": "RightFoot", "toe_R": "RightToeBase",
	"hand_L": "LeftHand", "hand_R": "RightHand", "elbow_L": "LeftForeArm", "elbow_R": "RightForeArm"}
const KEYS := ["valgus", "flex", "yaw", "twist"]


## The bought take: {scene, skel, ap, anim, name, ids} or {} (added under `parent`, never shown unless asked).
static func load_fbx(parent: Node, path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var doc := FBXDocument.new()
	var state := FBXState.new()
	if doc.append_from_file(path, state) != OK:
		return {}
	var scene := doc.generate_scene(state, 30.0)
	if scene == null:
		return {}
	parent.add_child(scene)
	var skels := scene.find_children("*", "Skeleton3D", true, false)
	var aps := scene.find_children("*", "AnimationPlayer", true, false)
	if skels.is_empty() or aps.is_empty():
		scene.queue_free()
		return {}
	var skel := skels[0] as Skeleton3D
	var ap := aps[0] as AnimationPlayer
	var names := ap.get_animation_list()
	if names.is_empty():
		scene.queue_free()
		return {}
	var ids := {}
	for b in SRC_BONES:
		var want := str(SRC_BONES[b])
		ids[b] = skel.find_bone(want)
		if int(ids[b]) < 0:
			for n in skel.get_bone_count():
				if skel.get_bone_name(n).ends_with(":" + want) or skel.get_bone_name(n).ends_with("_" + want):
					ids[b] = n
		if int(ids[b]) < 0:
			scene.queue_free()
			return {}
	ap.play(names[0])
	ap.speed_scale = 0.0
	return {"scene": scene, "skel": skel, "ap": ap, "anim": ap.get_animation(names[0]), "name": str(names[0]), "ids": ids}


static func _seek(src: Dictionary, t: float) -> void:
	var ap: AnimationPlayer = src["ap"]
	ap.seek(clampf(t, 0.0, (src["anim"] as Animation).length), true)
	(src["skel"] as Skeleton3D).force_update_all_bone_transforms()


## The bought take's joints at time t (world), with the actor's facing (his skeleton's +Z, on the canvas).
static func src_pts(src: Dictionary, t: float) -> Dictionary:
	_seek(src, t)
	var skel: Skeleton3D = src["skel"]
	var out := {}
	for b in src["ids"]:
		out[b] = skel.global_transform * skel.get_bone_global_pose(int(src["ids"][b])).origin
	var z := skel.global_transform.basis.z
	out["fwd"] = Vector3(z.x, 0.0, z.z).normalized()
	return out


static func src_hands(src: Dictionary, t: float) -> Dictionary:
	_seek(src, t)
	var skel: Skeleton3D = src["skel"]
	var out := {}
	for b in src["ids"]:
		out[b] = skel.global_transform * skel.get_bone_global_pose(int(src["ids"][b]))
	return out


## 1 / the bought skeleton's size against a 1.0 body of ours is not known: lengths are given on HIS body, in cm of his
## own metres (MoCap Online and Mixamo both come out in metres or centimetres - this returns the factor to metres).
static func src_scale(src: Dictionary) -> float:
	var skel: Skeleton3D = src["skel"]
	var ids: Dictionary = src["ids"]
	var leg := (skel.get_bone_global_rest(int(ids["hip_L"])).origin - skel.get_bone_global_rest(int(ids["knee_L"])).origin).length() + (skel.get_bone_global_rest(int(ids["knee_L"])).origin - skel.get_bone_global_rest(int(ids["ankle_L"])).origin).length()
	leg *= skel.global_transform.basis.get_scale().x
	return 0.87 / maxf(leg, 1e-4)   # a man's leg (hip joint to ankle): the readings are on a 0.87 m leg


static func leg_len(p: Dictionary) -> float:
	return ((p["hip_L"] as Vector3) - (p["knee_L"] as Vector3)).length() + ((p["knee_L"] as Vector3) - (p["ankle_L"] as Vector3)).length()


static func _flat(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


## Both legs' readings from the world points `p`, lengths scaled to a leg of `leg` metres. `south`: the lead leg is
## the right one (a mirrored library). -> {"lead": {valgus, flex, yaw, twist}, "rear": {...}, "width", "length"}
static func legs(p: Dictionary, leg: float, south: bool) -> Dictionary:
	var k := leg / maxf(leg_len(p), 1e-4) * 100.0
	var fwd: Vector3 = p["fwd"]
	var left := Vector3.UP.cross(fwd).normalized()
	var out := {}
	for s in ["L", "R"]:
		var o := "R" if s == "L" else "L"
		var h: Vector3 = p["hip_" + s]
		var kn: Vector3 = p["knee_" + s]
		var a: Vector3 = p["ankle_" + s]
		var toe: Vector3 = p["toe_" + s]
		var l := (a - h).normalized()
		var off := (kn - h) - l * (kn - h).dot(l)
		var inward := _flat((p["hip_" + o] as Vector3) - h).normalized()
		var outside := left if s == "L" else -left
		var foot := _flat(toe - a).normalized()
		var bend := _flat(off)
		var d := {}
		d["valgus"] = off.dot(inward) * k
		d["flex"] = 180.0 - rad_to_deg((h - kn).angle_to(a - kn))
		d["yaw"] = rad_to_deg(atan2(foot.dot(outside), foot.dot(fwd)))
		# the knee's own bend direction against its toes, on the canvas: + = the knee points inside its foot
		d["twist"] = wrapf(float(d["yaw"]) - rad_to_deg(atan2(bend.normalized().dot(outside), bend.normalized().dot(fwd))), -180.0, 180.0) if bend.length() > 0.01 else 0.0
		out["lead" if (s == "L") != south else "rear"] = d
	var lead_s := "R" if south else "L"
	var rear_s := "L" if south else "R"
	var span: Vector3 = (p["ankle_" + lead_s] as Vector3) - (p["ankle_" + rear_s] as Vector3)
	out["width"] = absf(span.dot(left)) * k
	out["length"] = span.dot(fwd) * k
	return out


static func line(r: Dictionary) -> String:
	var parts: Array = []
	for w in ["lead", "rear"]:
		var d: Dictionary = r[w]
		parts.append("%s knee: in %+5.1f cm, flex %3.0f, foot out %+4.0f, knee inside toes %+4.0f deg" % [w, d["valgus"], d["flex"], d["yaw"], d["twist"]])
	return "%s | stance %.0f wide %.0f long" % [" | ".join(PackedStringArray(parts)), r["width"], r["length"]]


## ours against the bought take: the difference at picture `ci`, and the worst over every picture both have.
static func diff_line(ours: Array, src: Array, ci: int) -> String:
	var parts: Array = []
	for w in ["lead", "rear"]:
		for key in ["valgus", "flex", "yaw"]:
			var at := 0.0
			var worst := 0.0
			var worst_n := -1
			for n in mini(ours.size(), src.size()):
				if ours[n] == null:
					continue
				var d := float(ours[n][w][key]) - float(src[n][w][key])
				if key == "yaw":
					d = wrapf(d, -180.0, 180.0)
				if n == ci:
					at = d
				if absf(d) > absf(worst):
					worst = d
					worst_n = n
			parts.append("%s %s %+.1f (worst %+.1f at %.2f s)" % [w, {"valgus": "knee in cm", "flex": "flex deg", "yaw": "foot deg"}[key], at, worst, float(worst_n) / 60.0])
	var dw := 0.0
	var dl := 0.0
	if ci < ours.size() and ours[ci] != null:
		dw = float(ours[ci]["width"]) - float(src[ci]["width"])
		dl = float(ours[ci]["length"]) - float(src[ci]["length"])
	return "%s | stance wide %+.0f long %+.0f cm" % ["; ".join(PackedStringArray(parts)), dw, dl]


## The worst knee-in difference (cm) between two runs of legs() rows, over every picture both have.
static func worst_valgus(ours: Array, src: Array) -> float:
	var worst := 0.0
	for n in mini(ours.size(), src.size()):
		if ours[n] == null or src[n] == null:
			continue
		for w in ["lead", "rear"]:
			worst = maxf(worst, absf(float(ours[n][w]["valgus"]) - float(src[n][w]["valgus"])))
	return worst


## Where the wrists go over a stretch of pictures: against the chest and the head, and each glove on its own hand.
class Trail:
	var rel: Dictionary = {}      # key -> Array of Vector3
	var turn: Dictionary = {}     # side -> Array of Basis (the glove in its hand's frame)
	var lean: Dictionary = {}     # side -> Array of float: the glove's long axis off its forearm's line, deg

	func add(xf: Dictionary, gloves: Dictionary) -> void:
		if not xf.has("chest"):
			return
		var chest: Transform3D = xf["chest"]
		var head: Transform3D = xf["head"]
		for s in ["L", "R"]:
			var hand: Transform3D = xf["hand_" + s]
			_push("chest_" + s, hand.origin - chest.origin)
			_push("head_" + s, hand.origin - head.origin)
			var side := "l" if s == "L" else "r"
			if gloves.has(side):
				var gw: Transform3D = gloves[side]
				var g: Transform3D = hand.affine_inverse() * gw
				_push("glove_" + s, g.origin)
				if not turn.has(s):
					turn[s] = []
					lean[s] = []
				(turn[s] as Array).append(g.basis.orthonormalized())
				(lean[s] as Array).append(rad_to_deg(gw.basis.y.normalized().angle_to((hand.origin - (xf["elbow_" + s] as Transform3D).origin).normalized())))

	func _push(key: String, v: Vector3) -> void:
		if not rel.has(key):
			rel[key] = []
		(rel[key] as Array).append(v)

	## the box the point stays in (its diagonal, m)
	func box(key: String) -> float:
		var pts: Array = rel.get(key, [])
		if pts.is_empty():
			return 0.0
		var lo: Vector3 = pts[0]
		var hi: Vector3 = pts[0]
		for p in pts:
			lo = lo.min(p)
			hi = hi.max(p)
		return (hi - lo).length()

	func path(key: String) -> float:
		var pts: Array = rel.get(key, [])
		var sum := 0.0
		for n in range(1, pts.size()):
			sum += (pts[n] as Vector3).distance_to(pts[n - 1])
		return sum

	## how far the glove turns on its hand over the stretch (deg, the first picture against the rest)
	func glove_turn(s: String) -> float:
		var all: Array = turn.get(s, [])
		var worst := 0.0
		for b in all:
			worst = maxf(worst, rad_to_deg((all[0] as Basis).get_rotation_quaternion().angle_to((b as Basis).get_rotation_quaternion())))
		return worst

	## the widest and the fastest the glove swings against its own forearm: [least, most, most in one picture] deg
	func swing(s: String) -> Array:
		var all: Array = lean.get(s, [])
		if all.is_empty():
			return [0.0, 0.0, 0.0]
		var fast := 0.0
		for n in range(1, all.size()):
			fast = maxf(fast, absf(float(all[n]) - float(all[n - 1])))
		return [float(all.min()), float(all.max()), fast]

	func line(k: float) -> String:
		var parts: Array = []
		for s in ["L", "R"]:
			var txt := "%s wrist from chest: box %.1f cm, path %.0f cm; from head: box %.1f cm" % [s, box("chest_" + s) * k * 100.0, path("chest_" + s) * k * 100.0, box("head_" + s) * k * 100.0]
			if rel.has("glove_" + s):
				var sw := swing(s)
				txt += "; GLOVE ON ITS HAND slides %.1f cm, turns %.0f deg; off its forearm's line %.0f..%.0f deg (%.1f in one picture)" % [box("glove_" + s) * k * 100.0, glove_turn(s), sw[0], sw[1], sw[2]]
			parts.append(txt)
		return " | ".join(PackedStringArray(parts))
