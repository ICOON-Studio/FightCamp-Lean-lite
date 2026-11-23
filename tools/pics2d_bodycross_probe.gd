extends SceneTree
## BODYCROSS1 (S542, ops/research/TASK_BODYCROSS1.md step 3): THE PREFAB CHECK. Every take on disk that could be a rear
## straight to the body, measured the census's way (tools/clip_census.gd: the census body mh_boxer_10, as bought, every
## fight layer off): for each hand, every time the glove front reaches out (a peak of its reach in front of the hips),
## the glove's height against the other man's rib point, the hips' drop, the knees, the head. Prints one line a take
## and hand: the reach peak nearest the ribs. Nothing is written.
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/pics2d_bodycross_probe.gd [-- only=<word>]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const HZ := 60.0
const REACH_MIN_M := 0.45   # a glove front this far in front of his own hips is a thrown punch
const WINDOW := 12          # a peak is the most reach within this many frames each way
const EXTRA := {"res://assets/anim/af_retarget/": "afr_", "res://assets/anim/baked/ailive_trial/": "ai_"}
const BONES := ["Hips", "Head", "Chest", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm",
	"RightUpperArm", "LeftMiddleProximal", "RightMiddleProximal", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg",
	"RightLowerLeg", "LeftFoot", "RightFoot"]

var skel: Skeleton3D
var ap: AnimationPlayer
var ids := {}
var fwd := Vector3.BACK
var side := Vector3.RIGHT
var scale := 1.0
var front := 0.15
var ribs_y := 0.0
var face_y := 0.0


func _initialize() -> void:
	var only := ""
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("only="):
			only = str(a).substr(5)
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
	scale = (bx["node"] as Node3D).scale.x
	front = float(bx.get("front", 0.15))
	fwd = (bx["node"] as Node3D).global_transform.basis.z.normalized()
	side = Vector3.UP.cross(fwd).normalized()
	Orbit.strip_modifiers(skel)
	for b in BONES:
		ids[b] = skel.find_bone(b)
	# the other man's rib point, the census's rule (guard's first frame, his layers off)
	var d: Dictionary = st.boxers[1]
	var ds: Skeleton3D = d["skel"]
	var dap: AnimationPlayer = d["ap"]
	Orbit.strip_modifiers(ds)
	var guard := BeatClips.first(BeatClips.GUARD, dap.has_animation)
	dap.play(guard)
	dap.seek(0.0, true)
	var s: float = (d["node"] as Node3D).scale.x
	ribs_y = (ds.global_transform * ds.get_bone_global_pose(ds.find_bone("Chest")).origin).y - 0.14 * s
	face_y = (ds.global_transform * ds.get_bone_global_pose(ds.find_bone("Head")).origin).y + Stage.FACE_UP_M * s
	print("BODYCROSS_PROBE ribs %.3f m, face %.3f m up (census body mh_boxer_10 v mh_boxer_11)" % [ribs_y, face_y])
	var lib: AnimationLibrary = ap.get_animation_library("")
	var prefix := str(ap.get_node(ap.root_node).get_path_to(skel))
	for dir in EXTRA:
		for f in DirAccess.get_files_at(str(dir)):
			var file := str(f).trim_suffix(".remap")
			if file.ends_with(".res"):
				FightClips._add_baked(lib, skel, prefix, str(EXTRA[dir]) + file.trim_suffix(".res"), str(dir) + file)
	var names: Array = []
	for n in ap.get_animation_list():
		if only == "" or str(n).contains(only):
			names.append(str(n))
	names.sort()
	for name in names:
		_measure(name)
	print("BODYCROSS_PROBE DONE %d takes" % names.size())
	quit(0)


func _pose(clip: String, t: float) -> Dictionary:
	ap.play(clip)
	ap.seek(t, true)
	var w := skel.global_transform
	var p := {}
	for b in BONES:
		p[b] = w * skel.get_bone_global_pose(int(ids[b])).origin
	for s in ["Left", "Right"]:
		var axis: Vector3 = ((p[s + "MiddleProximal"] as Vector3) - (p[s + "Hand"] as Vector3)).normalized()
		var fore: Vector3 = ((p[s + "Hand"] as Vector3) - (p[s + "LowerArm"] as Vector3)).normalized()
		if PR.STRAIGHT > 0.0 and axis.angle_to(fore) > 1e-3:
			axis = axis.slerp(fore, PR.STRAIGHT).normalized()
		p[s + "Glove"] = (p[s + "Hand"] as Vector3) + axis * front * scale
	return p


static func _ang(a: Vector3, k: Vector3, b: Vector3) -> float:
	return rad_to_deg((a - k).angle_to(b - k))


func _measure(clip: String) -> void:
	var length: float = ap.get_animation(clip).length
	var n := maxi(2, int(floor(length * HZ)) + 1)
	var ps: Array = []
	for i in n:
		ps.append(_pose(clip, minf(i / HZ, length)))
	var p0: Dictionary = ps[0]
	for hand in ["Left", "Right"]:
		var reach := PackedFloat32Array()
		for i in n:
			reach.append(((ps[i][hand + "Glove"] as Vector3) - (ps[i]["Hips"] as Vector3)).dot(fwd))
		var best := -1
		var peaks := 0
		for i in n:
			if reach[i] < REACH_MIN_M:
				continue
			var top := true
			for k in range(maxi(0, i - WINDOW), mini(n, i + WINDOW + 1)):
				if reach[k] > reach[i]:
					top = false
					break
			if not top:
				continue
			peaks += 1
			if best < 0 or absf((ps[i][hand + "Glove"] as Vector3).y - ribs_y) < absf((ps[best][hand + "Glove"] as Vector3).y - ribs_y):
				best = i
		if best < 0:
			continue
		var p: Dictionary = ps[best]
		var g: Vector3 = p[hand + "Glove"]
		var trunk: Vector3 = (p["Head"] as Vector3) - (p["Hips"] as Vector3)
		print("BODYCROSS_ROW %s" % JSON.stringify({"clip": clip, "hand": hand, "peaks": peaks, "t": snappedf(best / HZ, 0.001), "len": snappedf(length, 0.01),
			"glove_y": snappedf(g.y, 0.001), "gap_ribs": snappedf(g.y - ribs_y, 0.001), "reach": snappedf(reach[best], 0.001),
			"side": snappedf((g - (p["Hips"] as Vector3)).dot(side), 0.001),
			"hips_drop": snappedf((p0["Hips"] as Vector3).y - (p["Hips"] as Vector3).y, 0.001),
			"head_drop": snappedf((p0["Head"] as Vector3).y - (p["Head"] as Vector3).y, 0.001), "head_y": snappedf((p["Head"] as Vector3).y, 0.001),
			"lean_deg": snappedf(rad_to_deg(trunk.angle_to(Vector3.UP)), 0.1),
			"knee_l": snappedf(_ang(p["LeftUpperLeg"], p["LeftLowerLeg"], p["LeftFoot"]), 0.1),
			"knee_r": snappedf(_ang(p["RightUpperLeg"], p["RightLowerLeg"], p["RightFoot"]), 0.1),
			"elbow": snappedf(_ang(p[hand + "UpperArm"], p[hand + "LowerArm"], p[hand + "Hand"]), 0.1)}))
