extends SceneTree
## S399 GRAPPLEFIX1: how thick our women really are around each capsule GrappleDrawn.parts uses (blind critics: "bodies inside
## bodies" where the capsules read clear). Every skinned vertex of the body meshes in the rest pose goes to the capsule whose
## surface it is nearest (the limbs are carried by MetaHuman helper bones, so the weights cannot say which); prints its distance
## from that capsule's segment, p50 / p75 / p90, against the radius in use.
##   godot --headless --path . --script res://tools/grapple_mesh_radii.gd

const MH := preload("res://scripts/fight3d/MHRig.gd")
const GD := preload("res://scripts/grapple/GrappleDrawn.gd")
const BODIES := ["res://assets/models/metahuman/mh_boxer_11.glb", "res://assets/models/metahuman/mh_boxer_10.glb"]
const SKIP := ["hair", "brow", "lash", "eye", "teeth", "tongue", "saliva", "cartilage", "fuzz", "glove", "boot", "shoe"]


func _initialize() -> void:
	var root3 := Node3D.new()
	root.add_child(root3)
	for path in BODIES:
		var body := MH.load_fighter(path)
		root3.add_child(body)
		await process_frame
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var d := {}
		for n in GD.BONES:
			var i := skel.find_bone(n)
			if i >= 0:
				d[n] = skel.global_transform * skel.get_bone_global_rest(i).origin
		var hi := skel.find_bone("Head")
		d["Face"] = skel.global_transform * (skel.get_bone_global_rest(hi) * GD.face_local(skel))
		var caps: Array = GD.parts(d)["all"]
		var dist := {}
		var offs := {}
		for c in caps:
			dist[c[0]] = PackedFloat32Array()
			offs[c[0]] = []
		var fwd := Vector3.ZERO
		for sd in ["Left", "Right"]:
			fwd += skel.get_bone_global_rest(skel.find_bone(sd + "Toes")).origin - skel.get_bone_global_rest(skel.find_bone(sd + "Foot")).origin
		fwd.y = 0.0
		fwd = (skel.global_transform.basis * fwd).normalized()
		var used := []
		for m in body.find_children("*", "MeshInstance3D", true, false):
			var mi := m as MeshInstance3D
			if mi.mesh == null:
				continue
			var low := str(mi.name).to_lower()
			var skip := false
			for s in SKIP:
				if s in low:
					skip = true
			if skip:
				continue
			used.append(str(mi.name))
			for sidx in mi.mesh.get_surface_count():
				var verts: PackedVector3Array = mi.mesh.surface_get_arrays(sidx)[Mesh.ARRAY_VERTEX]
				var stride := maxi(1, verts.size() / 20000)
				for v in range(0, verts.size(), stride):
					var p := mi.global_transform * verts[v]
					var best := ""
					var bs := INF
					var bd := 0.0
					for c in caps:
						var q := Geometry3D.get_closest_point_to_segment(p, c[1], c[2])
						var dd := p.distance_to(q)
						if dd - float(c[3]) < bs:
							bs = dd - float(c[3])
							best = c[0]
							bd = dd
					var arr: PackedFloat32Array = dist[best]
					arr.append(bd)
					dist[best] = arr
					for c in caps:
						if str(c[0]) == best:
							(offs[best] as Array).append(p - Geometry3D.get_closest_point_to_segment(p, c[1], c[2]))
							break
		print("MESH ", path.get_file(), " meshes: ", ", ".join(used))
		var seen := {}
		for c in caps:
			if seen.has(c[0]):
				continue
			seen[c[0]] = true
			var a: PackedFloat32Array = dist[c[0]]
			if a.is_empty():
				print("  %-9s no vertices" % c[0])
				continue
			a.sort()
			# Along the body's forward: how far the skin reaches in front and behind the segment (p90 of each side), and the
			# offset of the centre that would make a round capsule fit.
			var front := PackedFloat32Array()
			var back := PackedFloat32Array()
			var side := PackedFloat32Array()
			for o in offs[c[0]]:
				var f := (o as Vector3).dot(fwd)
				if f > 0.0:
					front.append(f)
				else:
					back.append(-f)
				side.append(absf((o as Vector3).dot(fwd.cross(Vector3.UP))))
			front.sort()
			back.sort()
			side.sort()
			var q := func(x: PackedFloat32Array) -> float: return x[int(x.size() * 0.9)] if x.size() > 0 else 0.0
			print("  %-9s n %6d  p50 %.3f  p75 %.3f  p90 %.3f   radius now %.3f | front p90 %.3f back p90 %.3f side p90 %.3f" % [c[0], a.size(), a[int(a.size() * 0.5)],
				a[int(a.size() * 0.75)], a[int(a.size() * 0.9)], float(c[3]), q.call(front), q.call(back), q.call(side)])
		body.queue_free()
	quit(0)
