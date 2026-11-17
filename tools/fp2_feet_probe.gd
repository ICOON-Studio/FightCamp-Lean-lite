extends SceneTree
## FIGHTPLAYER2: what the feet do when the v2 player moves a body in its guard (headless). Boxer 0 is carried 0.5 m
## back and forth; every frame prints his body, both balls as drawn and what the foot lock holds.
##   <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/fp2_feet_probe.gd -- fightplayer2

const Stage := preload("res://scripts/fight3d/FightStage.gd")


func _initialize() -> void:
	var st: Node3D = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_12.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_07.glb", "corner": "blue"})
	var bx: Dictionary = st.boxers[0]
	var sk: Skeleton3D = bx["skel"]
	var ids := [sk.find_bone("LeftToes"), sk.find_bone("RightToes"), sk.find_bone("Hips")]
	var shown := [Vector3.ZERO, Vector3.ZERO, Vector3.ZERO]
	sk.skeleton_updated.connect(func():
		for k in 3:
			shown[k] = sk.global_transform * sk.get_bone_global_pose(int(ids[k])).origin)
	for i in 40:
		await process_frame
	var lock: Node = bx.get("lock")
	print("FEET lock ", lock, " active ", (lock as SkeletonModifier3D).active if lock != null else false, " w ", lock.get("_w") if lock != null else "-", " stand ", bx.get("stand"), " scene ", st.scene)
	var p2: Node = st.v2
	var home0: Vector3 = p2._home[0]
	for f in 150:
		var ph := float(f) / 60.0
		var x := 0.0
		if ph > 0.3 and ph <= 0.8:
			x = (ph - 0.3) / 0.5 * 0.5
		elif ph > 0.8 and ph <= 1.5:
			x = 0.5
		elif ph > 1.5 and ph <= 2.0:
			x = 0.5 - (ph - 1.5) / 0.5 * 0.5
		p2._home[0] = home0 + Vector3(0.0, 0.0, -x)
		await process_frame
		if f % 3 == 0:
			print("FEET %.2f body z %+.3f  L %+.3f %+.3f y %.3f  R %+.3f %+.3f y %.3f  hips %+.3f held %s carried %s" % [ph, (bx["node"] as Node3D).position.z, shown[0].x, shown[0].z, shown[0].y,
				shown[1].x, shown[1].z, shown[1].y, shown[2].z, str(lock.get("held")) if lock != null else "-", str(lock.get("_carried")) if lock != null else "-"])
	quit(0)
