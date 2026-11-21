extends SkeletonModifier3D
## MHCORR2 (S535, the owner on the S534 build: "why the bodies look so terrible ?", "the stomach goes inside weirdly the
## chest on the black guy look weird") - the MetaHuman body correctives Unreal runs, from the body's own DNA (the old
## project's S263 MHCORR, which the lean restart never brought over). A MetaHuman's skin leans on helper joints that
## Unreal's post-process rig moves with the limb: clavicle_scap / pec / out and spine_04_latissimus (the shoulder
## girdle and the chest), upperarm_fwd / bck / in / out, bicep, tricep, lowerarm_fwd / bck / in / out, the thigh, knee,
## ankle and wrist helpers, and one correctiveRoot per limb segment. Left at rest they ride their parent bone rigidly:
## the chest and the shoulders fold whenever the arms leave the A-pose, which a boxing guard does all night.
##   helpers          CorrectiveRBF over the solver's DNA poses (assets/data/mh_correctives_<body>.json, built in the
##                    old project by Tools/mh_corrective_table.py from the UE 5.8 body DNA); each pose's CHANGE from the
##                    "default" pose is laid on this body's own rest.
##   correctiveRoot   RigLogic's twist/swing layer: invTwist * slerp(invSwing, I, 0.5) of the driver's rest-relative
##                    rotation about its X twist axis - the ring sits half way through the bend.
## Driver input = rest^-1 * pose of the driver bone (Godot's rest below the root equals the DNA's neutral, S263 check).
## WRITES position and rotation only, never scale: ArmBuild's Strength scale on some of the same helpers stays as set.
## Runs LAST in the chain (after the arm finish, the guard hold and the twist bones): it reads the limbs as drawn.
## Bodies without their own table (only boxer 01-04 were exported) take the table whose rest helpers sit nearest theirs.
##   `-- nomhcorr` = the bodies as they were (the control arm of the before | after stills).

const RBF := preload("res://scripts/fight3d/v2/CorrectiveRBF.gd")
const NAME := "MetaHumanCorrectiveRBF"
const TABLE_DIR := "res://assets/data/"
const TABLES := ["mh_correctives_boxer01.json", "mh_correctives_boxer02.json", "mh_correctives_boxer03.json", "mh_correctives_boxer04.json"]
const SWING_ROOTS := ["upperarm", "lowerarm", "thigh", "calf"]   # driver -> its correctiveRoot, weight 0.5 (DNA twsw1.0, all eight)
const SWING_WEIGHT := 0.5
## UE driver names -> ours (MHRig.UE5_TO_OURS, the joints the solvers read).
const DRIVERS := {"clavicle_l": "LeftShoulder", "upperarm_l": "LeftUpperArm", "lowerarm_l": "LeftLowerArm", "hand_l": "LeftHand",
	"clavicle_r": "RightShoulder", "upperarm_r": "RightUpperArm", "lowerarm_r": "RightLowerArm", "hand_r": "RightHand",
	"thigh_l": "LeftUpperLeg", "calf_l": "LeftLowerLeg", "foot_l": "LeftFoot",
	"thigh_r": "RightUpperLeg", "calf_r": "RightLowerLeg", "foot_r": "RightFoot"}

static var on: bool = not OS.get_cmdline_user_args().has("nomhcorr")
static var _tables: Dictionary = {}   # path -> table (read once; both boxers share it)

var table_path := ""
var _solvers: Array = []
var _roots: Array = []


static func load_table(path: String) -> Dictionary:
	if not _tables.has(path):
		var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(path)) if FileAccess.file_exists(path) else null
		_tables[path] = data if data is Dictionary else {}
	return _tables[path]


## mh_boxer_02.glb -> its own table; a body without one -> the table whose "default" helper places are nearest this
## skeleton's rest (mean distance over the helpers it has).
static func table_path_for(glb_path: String, skel: Skeleton3D = null) -> String:
	var own: String = TABLE_DIR + "mh_correctives_" + glb_path.get_file().get_basename().replace("mh_", "").replace("_", "") + ".json"
	if FileAccess.file_exists(own) or skel == null:
		return own if FileAccess.file_exists(own) else TABLE_DIR + str(TABLES[0])
	var best := TABLE_DIR + str(TABLES[0])
	var best_d := INF
	for file in TABLES:
		var sum := 0.0
		var n := 0
		for solver in load_table(TABLE_DIR + str(file)).get("solvers", []):
			for s in (solver as Dictionary).get("samples", []):
				if str((s as Dictionary).get("pose", "")) != "default":
					continue
				var outs: Dictionary = (s as Dictionary).get("outputs", {})
				for joint in outs:
					var b := skel.find_bone(str(joint))
					if b >= 0:
						sum += skel.get_bone_rest(b).origin.distance_to(_v3(outs[joint]["t"]))
						n += 1
		if n > 0 and sum / n < best_d:
			best_d = sum / n
			best = TABLE_DIR + str(file)
	return best


## Every bone this modifier writes.
static func driven_bones(table: Dictionary) -> Dictionary:
	var out := {}
	for solver in table.get("solvers", []):
		var samples: Array = (solver as Dictionary).get("samples", [])
		if not samples.is_empty():
			for joint in ((samples[0] as Dictionary).get("outputs", {}) as Dictionary):
				out[str(joint)] = true
	for part in SWING_ROOTS:
		for side in ["l", "r"]:
			out["%s_correctiveRoot_%s" % [part, side]] = true
	return out


## Both boxers of a built stage (Player2.setup): each body its table, the modifier last on its skeleton.
static func setup_stage(stage: Node) -> void:
	if not on:
		return
	for bx in stage.get("boxers"):
		var skel: Skeleton3D = bx["skel"]
		if skel.get_node_or_null(NAME) != null:
			continue
		var m := new()
		m.name = NAME
		var mesh: Variant = (bx["node"] as Node).find_children("*", "MeshInstance3D", true, false).filter(func(x): return x.has_meta("mh_body"))
		var body: String = str((mesh as Array)[0].get_meta("mh_body")) if not (mesh as Array).is_empty() else ""
		m.table_path = table_path_for(body + ".glb", skel)
		if m.setup(skel, load_table(m.table_path)) > 0:
			skel.add_child(m)   # last: after the arm finish, the guard hold and the twist bones
		else:
			m.free()


## Returns the bones driven (0 = not this rig: nothing is added).
func setup(skel: Skeleton3D, table: Dictionary) -> int:
	_solvers.clear()
	_roots.clear()
	var driven := 0
	for raw in table.get("solvers", []):
		var solver: Dictionary = raw
		var driver: int = skel.find_bone(str(DRIVERS.get(solver.get("driver", ""), solver.get("driver", ""))))
		var samples: Array = solver.get("samples", [])
		if driver < 0 or samples.size() < 2:
			continue
		var prep: Dictionary = RBF.prepare(solver)
		var base_out: Dictionary = (samples[int(prep["base"])] as Dictionary).get("outputs", {})
		var helpers: Array = []
		for joint in base_out:
			var bone: int = skel.find_bone(str(joint))
			if bone < 0:
				continue
			var dts: Array = []
			var dqs: Array = []
			var t0: Vector3 = _v3(base_out[joint]["t"])
			var q0: Quaternion = _q(base_out[joint]["q"])
			for s in samples:
				var o: Dictionary = ((s as Dictionary).get("outputs", {}) as Dictionary).get(joint, base_out[joint])
				dts.append(_v3(o["t"]) - t0)
				var dq: Quaternion = (q0.inverse() * _q(o["q"])).normalized()
				dqs.append(-dq if dq.w < 0.0 else dq)   # one hemisphere (the change from rest is small): q and -q never cancel
			var rest: Transform3D = skel.get_bone_rest(bone)
			helpers.append({"bone": bone, "rest_t": rest.origin, "rest_q": rest.basis.get_rotation_quaternion(), "dt": dts, "dq": dqs})
		if helpers.is_empty():
			continue
		driven += helpers.size()
		_solvers.append({"prep": prep, "driver": driver,
			"driver_rest_q": skel.get_bone_rest(driver).basis.get_rotation_quaternion(), "helpers": helpers})
	for part in SWING_ROOTS:
		for side in ["l", "r"]:
			var root: int = skel.find_bone("%s_correctiveRoot_%s" % [part, side])
			var driver: int = skel.find_bone(str(DRIVERS.get("%s_%s" % [part, side], "")))
			if root < 0 or driver < 0:
				continue
			_roots.append({"bone": root, "driver": driver,
				"driver_rest_q": skel.get_bone_rest(driver).basis.get_rotation_quaternion(),
				"rest_q": skel.get_bone_rest(root).basis.get_rotation_quaternion()})
			driven += 1
	return driven


## RigLogic swing output for a rest-relative driver rotation (twist axis X): invTwist * slerp(invSwing, I, w).
static func swing_output(q_rel: Quaternion, weight: float) -> Quaternion:
	var q := q_rel.normalized()
	var twist := Quaternion(q.x, 0.0, 0.0, q.w)
	twist = twist.normalized() if twist.length_squared() > 1e-12 else Quaternion.IDENTITY
	var inv_twist := twist.inverse()
	var swing := q * inv_twist
	return (inv_twist * swing.inverse().slerp(Quaternion.IDENTITY, weight)).normalized()


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	for solver in _solvers:
		var q_rel: Quaternion = ((solver["driver_rest_q"] as Quaternion).inverse() * skel.get_bone_pose_rotation(int(solver["driver"]))).normalized()
		var w: PackedFloat64Array = RBF.weights(solver["prep"], q_rel)
		for h in solver["helpers"]:
			var dts: Array = h["dt"]
			var dqs: Array = h["dq"]
			var t := Vector3.ZERO
			var acc := Quaternion(0.0, 0.0, 0.0, 0.0)
			for i in w.size():
				if w[i] <= 0.0:
					continue
				t += (dts[i] as Vector3) * w[i]
				acc += (dqs[i] as Quaternion) * w[i]
			var blended: Quaternion = acc.normalized() if acc.length_squared() > 1e-12 else Quaternion.IDENTITY
			var bone: int = int(h["bone"])
			skel.set_bone_pose_position(bone, (h["rest_t"] as Vector3) + t)
			skel.set_bone_pose_rotation(bone, ((h["rest_q"] as Quaternion) * blended).normalized())
	for r in _roots:
		var q_rel: Quaternion = ((r["driver_rest_q"] as Quaternion).inverse() * skel.get_bone_pose_rotation(int(r["driver"]))).normalized()
		skel.set_bone_pose_rotation(int(r["bone"]), ((r["rest_q"] as Quaternion) * swing_output(q_rel, SWING_WEIGHT)).normalized())


static func _v3(a: Variant) -> Vector3:
	var arr: Array = a
	return Vector3(float(arr[0]), float(arr[1]), float(arr[2]))


static func _q(a: Variant) -> Quaternion:
	var arr: Array = a
	return Quaternion(float(arr[0]), float(arr[1]), float(arr[2]), float(arr[3])).normalized()
