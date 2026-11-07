extends SceneTree
## FIGHTERLOOK1 probe: is the eye maths' frame right? Loads a boxer and a staff body, prints the skeleton's transform under the
## body root, the mesh instance's, the head bone's rest basis, where the eye surface's centre sits in skeleton space vs
## FighterLife.EYE_BIND mapped through the head rest, and which way +Z (the face) points.
##   <godot> --headless --path . --script res://tools/eye_frame_probe.gd

const MH := preload("res://scripts/fight3d/MHRig.gd")


func _initialize() -> void:
	for glb in ["res://assets/models/metahuman/mh_boxer_11.glb", "res://assets/models/metahuman/mh_staff_coach.glb"]:
		var body := MH.load_fighter(glb)
		root.add_child(body)
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var hb := skel.find_bone("Head")
		print("== ", glb.get_file())
		print("skel transform (to parent) ", skel.transform, "  parent ", skel.get_parent().name)
		var rest: Transform3D = skel.get_bone_global_rest(hb)
		print("head rest global ", rest)
		for m in body.find_children("*", "MeshInstance3D", true, false):
			var mi := m as MeshInstance3D
			for s in mi.mesh.get_surface_count():
				var mat := mi.mesh.surface_get_material(s)
				if mat == null or not mat.resource_name.begins_with("MH_Eye") or mat.resource_name.begins_with("MH_Eyelashes"):
					continue
				var v: PackedVector3Array = mi.mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX]
				var c := Vector3.ZERO
				for p in v:
					c += p
				c /= float(v.size())
				print("mesh ", mi.name, " transform ", mi.transform, " skeleton path ", mi.skeleton)
				var skin := mi.skin
				var bind_head := -1
				if skin != null:
					for b in skin.get_bind_count():
						if skin.get_bind_name(b) == "Head" or skin.get_bind_bone(b) == hb:
							bind_head = b
					if bind_head >= 0:
						print("skin bind Head = ", skin.get_bind_pose(bind_head), "  rest^-1 = ", rest.affine_inverse())
				print("eye centre (mesh space) ", c, "   EYE_BIND (0, 1.587, 0.086)")
				# Bone-space of the eye centre through the skin bind, back to skeleton space via the rest:
				if bind_head >= 0:
					var in_bone: Vector3 = skin.get_bind_pose(bind_head) * c
					print("eye centre via bind -> skeleton rest space ", rest * in_bone)
				break
		print("head rest basis * +Z = ", rest.basis * Vector3.BACK, "   rest^-1 basis * +Z = ", rest.affine_inverse().basis * Vector3.BACK)
		body.queue_free()
	quit(0)
