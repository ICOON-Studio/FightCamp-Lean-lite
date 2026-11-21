extends SceneTree
## MHCORR2 (S535; the old project's S263 mh_dna_correctives_test, for the lean rig and fight player v2): the MetaHuman
## body correctives on a real body with its DNA table.
##   REST     at rest every helper stays at its rest (the interpolative solve gives the "default" pose back exactly)
##   ELBOW    a 90-degree elbow moves the elbow helpers centimetres and turns the correctiveRoot HALF the bend
##   SWING    RigLogic's swing output: a pure twist is undone, a 60-degree swing turns back 30
##   GUARD    arms up in front (a guard): the shoulder girdle's helpers (clavicle_scap / pec, upperarm_fwd) leave rest
##   BUILD    ArmBuild's Strength scale on the same helpers is still there after the correctives ran (composed)
##   TABLE    a body with no table of its own takes the nearest one; all four tables load and drive this rig
##   WIRED    Player2 keeps the layer on, and it is the LAST modifier on a v2 boxer's skeleton
## Two DIFFERENT bodies. Red on main before MHCORR2 (the scripts do not exist: every helper sits at rest).
## Run: <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/mh_dna_correctives_test.gd

const MH := preload("res://scripts/fight3d/MHRig.gd")
const ArmBuild := preload("res://scripts/fight3d/v2/ArmBuild.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const MOD := "res://scripts/fight3d/v2/MetaHumanCorrectiveRBF.gd"
const BODY := "res://assets/models/metahuman/mh_boxer_01.glb"
const OTHER := "res://assets/models/metahuman/mh_boxer_11.glb"

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _end() -> void:
	print("MH_DNA_CORRECTIVES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _initialize() -> void:
	if not ResourceLoader.exists(MOD):
		_check(false, "ELBOW no corrective layer in this tree: every helper sits at rest in a 90-degree elbow")
		_end()
		return
	var C: GDScript = load(MOD)
	var table: Dictionary = C.load_table(C.table_path_for(BODY))
	_check(not table.is_empty() and str(C.table_path_for(BODY)).ends_with("boxer01.json"), "TABLE mh_boxer_01 has its own table")
	var fighter: Node3D = MH.load_fighter(BODY)
	root.add_child(fighter)
	var skel: Skeleton3D = fighter.find_children("*", "Skeleton3D", true, false)[0]
	for old in skel.find_children("*", "SkeletonModifier3D", false, false):
		skel.remove_child(old)
		(old as Node).free()
	var mod: SkeletonModifier3D = C.new()
	var driven: int = mod.setup(skel, table)
	skel.add_child(mod)
	await process_frame   # the tree is running: a modifier knows its skeleton only inside it
	_check(driven >= 60, "TABLE drives the DNA helpers + correctiveRoots (%d bones)" % driven)

	skel.reset_bone_poses()
	mod._process_modification()
	var worst := 0.0
	for bone_name in C.driven_bones(table):
		var b: int = skel.find_bone(str(bone_name))
		if b >= 0:
			worst = maxf(worst, skel.get_bone_pose_position(b).distance_to(skel.get_bone_rest(b).origin))
	_check(worst < 0.002, "REST helpers stay at rest (worst %.4f m, bar 2 mm)" % worst)

	var lower: int = skel.find_bone("LeftLowerArm")
	var bck: int = skel.find_bone("lowerarm_bck_l")
	var croot: int = skel.find_bone("lowerarm_correctiveRoot_l")
	_check(lower >= 0 and bck >= 0 and croot >= 0, "ELBOW the rig has the elbow's helper bones")
	var rest_q: Quaternion = skel.get_bone_rest(lower).basis.get_rotation_quaternion()
	var moved := 0.0
	var root_angle := 0.0
	var finite := true
	for axis in [Vector3.FORWARD, Vector3.BACK, Vector3.UP, Vector3.DOWN]:
		skel.reset_bone_poses()
		skel.set_bone_pose_rotation(lower, rest_q * Quaternion(axis, deg_to_rad(90.0)))
		mod._process_modification()
		var m: float = skel.get_bone_pose_position(bck).distance_to(skel.get_bone_rest(bck).origin)
		if m > moved:
			moved = m
			root_angle = rad_to_deg((skel.get_bone_rest(croot).basis.get_rotation_quaternion().inverse() * skel.get_bone_pose_rotation(croot)).get_angle())
		for b in skel.get_bone_count():
			finite = finite and skel.get_bone_pose_position(b).is_finite() and skel.get_bone_pose_rotation(b).is_finite()
	_check(finite, "ELBOW no bone goes NaN in a 90-degree bend")
	_check(moved > 0.01, "ELBOW a 90-degree bend moves lowerarm_bck_l %.4f m (bar: over 1 cm)" % moved)
	_check(absf(root_angle - 45.0) < 6.0, "ELBOW the correctiveRoot turns half the bend (%.1f deg, want 45)" % root_angle)

	var tw: Quaternion = C.swing_output(Quaternion(Vector3.RIGHT, deg_to_rad(50.0)), 0.5)
	_check(absf(rad_to_deg(tw.get_angle()) - 50.0) < 0.5, "SWING a pure twist of 50 is undone (%.2f)" % rad_to_deg(tw.get_angle()))
	var sw: Quaternion = C.swing_output(Quaternion(Vector3.UP, deg_to_rad(60.0)), 0.5)
	_check(absf(rad_to_deg(sw.get_angle()) - 30.0) < 0.5, "SWING a swing of 60 turns back 30 (%.2f)" % rad_to_deg(sw.get_angle()))

	# The guard's shoulders: the upper arm swung 70 degrees off rest and the clavicle 20, each way round; the girdle answers.
	var girdle := 0.0
	for axis in [Vector3.FORWARD, Vector3.BACK, Vector3.UP, Vector3.DOWN]:
		skel.reset_bone_poses()
		for pair in [["LeftUpperArm", 70.0], ["LeftShoulder", 20.0]]:
			var id := skel.find_bone(str(pair[0]))
			skel.set_bone_pose_rotation(id, skel.get_bone_rest(id).basis.get_rotation_quaternion() * Quaternion(axis, deg_to_rad(float(pair[1]))))
		mod._process_modification()
		for h in ["clavicle_scap_l", "clavicle_pec_l", "upperarm_fwd_l", "upperarm_bck_l"]:
			var b := skel.find_bone(h)
			if b >= 0:
				girdle = maxf(girdle, skel.get_bone_pose_position(b).distance_to(skel.get_bone_rest(b).origin))
	_check(girdle > 0.005, "GUARD the shoulder girdle's helpers move with the arm (most %.4f m, bar: over 5 mm)" % girdle)

	skel.reset_bone_poses()
	var scaled: int = ArmBuild.apply(skel, 1.24)
	skel.set_bone_pose_rotation(lower, rest_q * Quaternion(Vector3.UP, deg_to_rad(90.0)))
	mod._process_modification()
	var kept := scaled > 0
	for stem in ArmBuild.BONES:
		var b := skel.find_bone(str(stem) + "_l")
		if b >= 0:
			var s: Vector3 = skel.get_bone_pose_scale(b)
			kept = kept and absf(maxf(s.x, maxf(s.y, s.z)) - (1.0 + 0.24 * float(ArmBuild.BONES[stem]))) < 0.0001
	_check(kept, "BUILD every helper ArmBuild thickened (%d) keeps its Strength scale under the correctives" % scaled)
	fighter.queue_free()

	for file in C.TABLES:
		var t: Dictionary = C.load_table(str(C.TABLE_DIR) + str(file))
		var probe: SkeletonModifier3D = C.new()
		_check(probe.setup(skel, t) >= 60, "TABLE %s loads and drives the rig" % str(file))
		probe.free()

	Player2.force = true
	FightClips.untouched = true
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": OTHER, "corner": "red"}, {"glb": BODY, "corner": "blue"})
	_check(Player2.KEEP.has(str(C.NAME)), "WIRED the v2 player keeps the corrective layer on")
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var m: Node = sk.get_node_or_null(str(C.NAME))
		var mods: Array = sk.get_children().filter(func(x): return x is SkeletonModifier3D)
		_check(m != null and mods[mods.size() - 1] == m and (m as SkeletonModifier3D).active, "WIRED boxer %d: the correctives are the last layer on his skeleton (%s)" % [i, str(m.table_path).get_file() if m != null else "none"])
	# In his guard, AS DRAWN (a modifier's work is read when the skeleton has been updated): the helpers have left rest.
	var seen: Array = [{}, {}]
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var d: Dictionary = seen[i]
		sk.skeleton_updated.connect(func() -> void:
			for h in ["clavicle_scap_l", "clavicle_pec_l", "upperarm_fwd_l", "lowerarm_bck_l", "clavicle_scap_r", "lowerarm_bck_r"]:
				var b := sk.find_bone(h)
				if b >= 0:
					var local: Transform3D = sk.get_bone_global_pose(sk.get_bone_parent(b)).affine_inverse() * sk.get_bone_global_pose(b)
					d[h] = local.origin.distance_to(sk.get_bone_rest(b).origin))
	for f in 40:
		await process_frame
	for i in 2:
		var off := 0.0
		for h in seen[i]:
			off = maxf(off, float(seen[i][h]))
		_check(off > 0.005, "WIRED boxer %d in his guard: helpers are off rest as drawn (most %.4f m of %d read)" % [i, off, (seen[i] as Dictionary).size()])
	_end()
