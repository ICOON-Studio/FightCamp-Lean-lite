extends SceneTree
## S399 GRAPPLEFIX1: how thick our women really are around each capsule GrappleDrawn.parts uses (blind critics: "bodies inside
## bodies" where the capsules read clear). Every skinned vertex in the rest pose goes to the capsule of the bone that carries most
## of its weight; prints the distance from the capsule's segment, p50 / p90 / p98, against the radius in use.
##   godot --headless --path . --script res://tools/grapple_mesh_radii.gd

const MH := preload("res://scripts/fight3d/MHRig.gd")
const BODIES := ["res://assets/models/metahuman/mh_boxer_11.glb", "res://assets/models/metahuman/mh_boxer_10.glb"]
## capsule -> [bone a, bone b, radius now, bones whose vertices belong to it]
const CAPS := {
	"pelvis": ["LeftUpperLeg", "RightUpperLeg", 0.118, ["Hips"]],
	"trunk": ["Spine", "Neck", 0.12, ["Spine", "Chest", "UpperChest", "Spine1", "Spine2", "Spine3", "LeftShoulder", "RightShoulder"]],
	"head": ["Head", "Head", 0.11, ["Head"]],
	"neck": ["Neck", "Head", 0.07, ["Neck"]],
	"thighL": ["LeftUpperLeg", "LeftLowerLeg", 0.10, ["LeftUpperLeg"]],
	"shinL": ["LeftLowerLeg", "LeftFoot", 0.065, ["LeftLowerLeg"]],
	"upperarmL": ["LeftUpperArm", "LeftLowerArm", 0.06, ["LeftUpperArm"]],
	"forearmL": ["LeftLowerArm", "LeftHand", 0.045, ["LeftLowerArm"]],
}


func _initialize() -> void:
	var root3 := Node3D.new()
	root.add_child(root3)
	for path in BODIES:
		var body := MH.load_fighter(path)
		root3.add_child(body)
		await process_frame
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var names := {}
		for i in skel.get_bone_count():
			names[i] = skel.get_bone_name(i)
		var dist := {}
		for k in CAPS:
			dist[k] = PackedFloat32Array()
		var head_ofs := PackedFloat32Array()
		for m in body.find_children("*", "MeshInstance3D", true, false):
			var mi := m as MeshInstance3D
			if mi.skin == null or mi.mesh == null:
				continue
			for sidx in mi.mesh.get_surface_count():
				var arr := mi.mesh.surface_get_arrays(sidx)
				var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
				var bones: PackedInt32Array = arr[Mesh.ARRAY_BONES]
				var wts: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
				if bones.is_empty() or verts.is_empty():
					continue
				var per := bones.size() / verts.size()
				for v in verts.size():
					var best := -1
					var bw := 0.0
					for q in per:
						if wts[v * per + q] > bw:
							bw = wts[v * per + q]
							best = bones[v * per + q]
					if best < 0:
						continue
					var bname := str(mi.skin.get_bind_name(best)) if mi.skin.get_bind_name(best) != &"" else str(names.get(mi.skin.get_bind_bone(best), ""))
					var p := mi.global_transform * verts[v]
					for k in CAPS:
						if bname in CAPS[k][3]:
							var a := skel.global_transform * skel.get_bone_global_rest(skel.find_bone(CAPS[k][0])).origin
							var b := skel.global_transform * skel.get_bone_global_rest(skel.find_bone(CAPS[k][1])).origin
							var c := Geometry3D.get_closest_point_to_segment(p, a, b)
							var arr2: PackedFloat32Array = dist[k]
							arr2.append(p.distance_to(c))
							dist[k] = arr2
		print("MESH ", path.get_file())
		for k in CAPS:
			var d: PackedFloat32Array = dist[k]
			if d.is_empty():
				print("  %-9s no vertices" % k)
				continue
			d.sort()
			print("  %-9s n %5d  p50 %.3f  p90 %.3f  p98 %.3f   radius now %.3f" % [k, d.size(), d[int(d.size() * 0.5)], d[int(d.size() * 0.9)],
				d[int(d.size() * 0.98)], float(CAPS[k][2])])
		body.queue_free()
	var bn: Array = []
	var s0 := MH.load_fighter(BODIES[0]).find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	for i in s0.get_bone_count():
		bn.append(s0.get_bone_name(i))
	print("BONES ", ", ".join(bn.slice(0, 40)))
	quit(0)
