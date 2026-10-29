extends SkeletonModifier3D
## S246 - the MetaHuman TWIST bones, driven every frame the way UE's MetaHuman post-process rig drives them (operator: "the moment the
## fighter moves he stops looking like a human"). MetaHuman skin leans on these helpers (each forearm twist bone carries more weight
## than the forearm itself): left at rest - or folded into the elbow, as fold_static_skin_weights did - a wrist roll wrings the whole
## forearm into a flat band at the wrist and an arm roll caves the shoulder.
##   forearm  lowerarm_twist_0N  follows the HAND's roll about the forearm, by its distance from the elbow (0.69 / 0.34)
##   shin     calf_twist_0N      follows the FOOT's roll about the shin, by its distance from the knee
##   upper arm upperarm_twist_0N  undoes the UPPER ARM's own roll, by its distance from the elbow (-0.65 / -0.29)
##   thigh    thigh_twist_0N     undoes the THIGH's own roll, by its distance from the knee
## Built by MetaHumanRig.load_fighter; a body without these bones gets no spec and the modifier does nothing.
## S265 MHTWIST1 (switch mh_dna_twist, GAME_ON): setup_dna() replaces the fractions above with RigLogic's own twist layer from the
## body DNA (mh_correctives_<body>.json "twist_swing", rules/TwistSwing.gd): forearm 0.8/0.2 of the hand's roll, shin 1.0/0.5 of the
## foot's, upper arm -0.8/-0.2 and thigh -1.0/-0.5 of the bone's own (RigLogic merges those with the swing = inverse twist).
## Swing outputs are dropped here - MetaHumanCorrectiveRBF drives the correctiveRoots.

const TwistSwing := preload("res://scripts/rules/TwistSwing.gd")

const LIMBS := [
	## [twist prefix, parent (the bone the twist hangs on), driver, follows the driver (true) or undoes it (false), child for the length]
	["lowerarm_twist_0", "LowerArm", "Hand", true, "Hand"],
	["upperarm_twist_0", "UpperArm", "UpperArm", false, "LowerArm"],
	["calf_twist_0", "LowerLeg", "Foot", true, "Foot"],
	["thigh_twist_0", "UpperLeg", "UpperLeg", false, "LowerLeg"],
]

var _specs: Array = []
var _dna: Array = []          # TwistSwing setups, this skeleton's bone names, twist outputs only
var _dna_bones: Dictionary = {}   # bone name -> [bone index, rest rotation]


static func is_twist_bone(bone_name: String) -> bool:
	for limb in LIMBS:
		if bone_name.begins_with(str(limb[0])) and (bone_name.ends_with("_l") or bone_name.ends_with("_r")):
			return true
	return false


## One spec per twist bone: {twist, driver, axis_driver (driver rest frame), axis_twist (twist rest frame), frac, rest_twist, rest_driver}.
func setup(skel: Skeleton3D) -> int:
	_specs.clear()
	for side in ["l", "r"]:
		var lr := "Left" if side == "l" else "Right"
		for limb in LIMBS:
			var parent := skel.find_bone(lr + str(limb[1]))
			var driver := skel.find_bone(lr + str(limb[2]))
			var child := skel.find_bone(lr + str(limb[4]))
			if parent < 0 or driver < 0 or child < 0:
				continue
			var length := skel.get_bone_rest(child).origin.length()
			if length < 0.001:
				continue
			for n in range(1, 4):
				var twist := skel.find_bone("%s%d_%s" % [str(limb[0]), n, side])
				if twist < 0 or skel.get_bone_parent(twist) != parent:
					continue
				var along := skel.get_bone_rest(twist).origin.length() / length
				var limb_dir := skel.get_bone_rest(child).origin.normalized()   # parent space (= the twist bone's parent)
				var rest_twist := skel.get_bone_rest(twist).basis.get_rotation_quaternion()
				var rest_driver := skel.get_bone_rest(driver).basis.get_rotation_quaternion()
				var axis_driver: Vector3
				if driver == child:   # forearm/shin: the hand's (foot's) roll, read in its own rest frame
					axis_driver = (rest_driver.inverse() * limb_dir).normalized()
				else:                 # upper arm/thigh: the bone's own roll, in its own frame
					axis_driver = limb_dir
				_specs.append({
					"twist": twist, "driver": driver, "axis_driver": axis_driver,
					"axis_twist": (rest_twist.inverse() * limb_dir).normalized(),
					"frac": clampf(along, 0.0, 1.0) if bool(limb[3]) else -clampf(1.0 - along, 0.0, 1.0),
					"rest_twist": rest_twist, "rest_driver": rest_driver,
				})
	return _specs.size()


## The DNA's twist setups (table "twist_swing", UE names) on this skeleton; `driver_names` maps upperarm_l -> LeftUpperArm.
## Returns the twist bones driven (0 = the S246 fractions stay in charge).
func setup_dna(skel: Skeleton3D, setups: Array, driver_names: Dictionary) -> int:
	_dna.clear()
	_dna_bones.clear()
	var driven := 0
	for raw in setups:
		if typeof(raw) != TYPE_DICTIONARY or ((raw as Dictionary).get("twist_outputs", []) as Array).is_empty():
			continue
		var s: Dictionary = (raw as Dictionary).duplicate(true)
		s["swing_weights"] = []
		s["swing_outputs"] = []
		var ok := true
		for key in ["swing_input", "twist_input"]:
			if s.get(key) is String:
				var bone_name := str(driver_names.get(s[key], s[key]))
				ok = ok and _track(skel, bone_name)
				s[key] = bone_name
		for joint in s["twist_outputs"]:
			ok = ok and _track(skel, str(joint))
		if ok and TwistSwing.validate(s).is_empty():
			_dna.append(s)
			driven += (s["twist_outputs"] as Array).size()
	if driven == 0:
		_dna.clear()
	return driven


func _track(skel: Skeleton3D, bone_name: String) -> bool:
	var bone := skel.find_bone(bone_name)
	if bone >= 0:
		_dna_bones[bone_name] = [bone, skel.get_bone_rest(bone).basis.get_rotation_quaternion()]
	return bone >= 0


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	if not _dna.is_empty():
		## RigLogic input = InvNeutral * local pose (Godot rest == DNA neutral, S263 check), output = neutral * twist.
		var inputs := {}
		for bone_name in _dna_bones:
			var entry: Array = _dna_bones[bone_name]
			inputs[bone_name] = ((entry[1] as Quaternion).inverse() * skel.get_bone_pose_rotation(int(entry[0]))).normalized()
		var out: Dictionary = TwistSwing.evaluate_all(_dna, inputs)
		for joint in out:
			var entry: Array = _dna_bones[joint]
			skel.set_bone_pose_rotation(int(entry[0]), ((entry[1] as Quaternion) * (out[joint] as Quaternion)).normalized())
		return
	for spec in _specs:
		var delta: Quaternion = (spec["rest_driver"] as Quaternion).inverse() * skel.get_bone_pose_rotation(int(spec["driver"]))
		var axis: Vector3 = spec["axis_driver"]
		var roll := 2.0 * atan2(Vector3(delta.x, delta.y, delta.z).dot(axis), delta.w)
		if roll > PI:
			roll -= TAU
		elif roll < -PI:
			roll += TAU
		skel.set_bone_pose_rotation(int(spec["twist"]),
			(spec["rest_twist"] as Quaternion) * Quaternion(spec["axis_twist"], float(spec["frac"]) * roll))
