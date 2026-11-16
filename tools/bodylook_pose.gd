extends RefCounted
## BODYLOOK1 (S495): a body's pose and the lens that saw it, carried from the game to the workbench. The coach's close-up
## (corner_film c07) is the only place his collar fault shows and costs six minutes a look; the workbench could not
## reproduce the pose from a clip + a look. So the film writes the pose it showed - every bone AFTER the modifiers ran
## (read inside Skeleton3D.skeleton_updated: outside it the bones are back on the clip) - and the workbench puts one body
## in it under the same lens (tools/bodylook_still.gd `pose=<file>`).
##   BodylookPose.record(actor, camera, path)   # call a frame before the still; writes on the next skeleton update
##   BodylookPose.apply(body, skel, path) -> {"cam": Transform3D, "fov": float}   ({} when the file is not a pose)


static func record(actor: Dictionary, cam: Camera3D, path: String) -> void:
	var skel: Skeleton3D = actor["skel"]
	var node: Node3D = actor["node"]
	var write := func():
		var bones := {}
		for i in skel.get_bone_count():
			var t := skel.get_bone_pose(i)
			var q := t.basis.get_rotation_quaternion()
			var s := t.basis.get_scale()
			bones[skel.get_bone_name(i)] = [t.origin.x, t.origin.y, t.origin.z, q.x, q.y, q.z, q.w, s.x, s.y, s.z]
		var f := FileAccess.open(path, FileAccess.WRITE)
		f.store_string(JSON.stringify({"node": _flat(node.global_transform), "skel": _flat(skel.global_transform),
			"cam": _flat(cam.global_transform), "fov": cam.fov, "bones": bones}))
		f.close()
		print("BODYLOOK_POSE wrote ", path)
	skel.skeleton_updated.connect(write, CONNECT_ONE_SHOT)


static func apply(body: Node3D, skel: Skeleton3D, path: String) -> Dictionary:
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not data is Dictionary or not data.has("bones"):
		return {}
	body.global_transform = _deep(data["node"])
	for name in data["bones"]:
		var id := skel.find_bone(str(name))
		if id < 0:
			continue
		var v: Array = data["bones"][name]
		skel.set_bone_pose_position(id, Vector3(v[0], v[1], v[2]))
		skel.set_bone_pose_rotation(id, Quaternion(v[3], v[4], v[5], v[6]))
		skel.set_bone_pose_scale(id, Vector3(v[7], v[8], v[9]))
	var drift := skel.global_transform.origin.distance_to(_deep(data["skel"]).origin)
	print("BODYLOOK_POSE applied %d bones, skeleton off its film place by %.4f m" % [(data["bones"] as Dictionary).size(), drift])
	return {"cam": _deep(data["cam"]), "fov": float(data["fov"])}


static func _flat(t: Transform3D) -> Array:
	return [t.basis.x.x, t.basis.x.y, t.basis.x.z, t.basis.y.x, t.basis.y.y, t.basis.y.z, t.basis.z.x, t.basis.z.y,
		t.basis.z.z, t.origin.x, t.origin.y, t.origin.z]


static func _deep(v: Array) -> Transform3D:
	return Transform3D(Basis(Vector3(v[0], v[1], v[2]), Vector3(v[3], v[4], v[5]), Vector3(v[6], v[7], v[8])),
		Vector3(v[9], v[10], v[11]))
