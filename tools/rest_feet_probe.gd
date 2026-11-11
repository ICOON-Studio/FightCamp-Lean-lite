extends SceneTree
## HUMANFIGHT1: each MetaHuman body's standing heights in its rest pose (skeleton space, scale 1): the toe ball joint, the
## ankle joint and the lowest vertex of the body's meshes (the sole). The foot rulers' absolute floor.
##   <godot> --headless --path . --script res://tools/rest_feet_probe.gd

const MH := preload("res://scripts/fight3d/MHRig.gd")


func _initialize() -> void:
	var dir := DirAccess.open("res://assets/models/metahuman")
	for f in dir.get_files():
		if not f.ends_with(".glb") or not f.begins_with("mh_boxer"):
			continue
		var body := MH.load_fighter("res://assets/models/metahuman/" + f)
		root.add_child(body)
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var out := []
		for b in ["LeftToes", "RightToes", "LeftFoot", "RightFoot", "Hips"]:
			out.append("%s %.4f" % [b, skel.get_bone_global_rest(skel.find_bone(b)).origin.y])
		var low := INF
		for mi in body.find_children("*", "MeshInstance3D", true, false):
			var m := (mi as MeshInstance3D).mesh
			if m == null:
				continue
			var ab: AABB = (mi as MeshInstance3D).global_transform * m.get_aabb()
			low = minf(low, ab.position.y)
		print("REST_FEET %s skel_y %.4f %s lowest_mesh %.4f" % [f, skel.global_position.y, " ".join(out), low])
		body.queue_free()
	quit(0)
