extends SceneTree
## S391 (operator: "how come the gloves are not fixed yet ?"): under a glove no skin may be left past the wrist. The palm of a
## MetaHuman hangs on lower-case helper bones (index_metacarpal_l, pinky_01_half_l), so a cut that only knows Left*/Right* bones
## leaves it standing, and the glove in line with the forearm (S316) lets it poke out. Measured on the rest pose, every side.

const Gloves := preload("res://scripts/fight3d/Gloves.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const BODIES := ["res://assets/models/metahuman/mh_boxer_01.glb", "res://assets/models/metahuman/mh_boxer_10.glb"]
const MAX_PAST_M := 0.03   # the wrist stub the cuff covers

var _fails := 0


func _initialize() -> void:
	for glb in BODIES:
		var body := MH.load_fighter(glb)
		root.add_child(body)
		var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
		var gl := Gloves.new()
		body.add_child(gl)
		_check(gl.mount(body, Color.BLUE, Color.WHITE) == 2, "%s has two gloves" % glb)
		for side in ["Left", "Right"]:
			var past := _skin_past_wrist(body, skel, side)
			print("%s %s: %d skin vertices past the wrist, furthest %.3f m" % [glb, side, past[0], past[1]])
			_check(float(past[1]) <= MAX_PAST_M, "%s %s hand is gone under the glove" % [glb, side])
		body.free()
	print("glove_cut_test: %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


## [vertices past the wrist, the furthest one in metres along the hand], over the triangles still drawn.
func _skin_past_wrist(body: Node3D, skel: Skeleton3D, side: String) -> Array:
	var wrist := skel.get_bone_global_rest(skel.find_bone(side + "Hand")).origin
	var dir := (skel.get_bone_global_rest(skel.find_bone(side + "MiddleProximal")).origin - wrist).normalized()
	var count := 0
	var furthest := 0.0
	for found in body.find_children("*", "MeshInstance3D", true, false):
		var mi := found as MeshInstance3D
		if mi.skin == null or not (mi.mesh is ArrayMesh):
			continue
		var mesh := mi.mesh as ArrayMesh
		for s in mesh.get_surface_count():
			var mat := mesh.surface_get_material(s)
			if mat == null or not mat.resource_name.begins_with("MH_Skin"):
				continue
			var arr: Array = mesh.surface_get_arrays(s)
			var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
			var seen := {}
			for i in (arr[Mesh.ARRAY_INDEX] as PackedInt32Array):
				if seen.has(i):
					continue
				seen[i] = true
				var p: Vector3 = verts[i] - wrist
				var along := p.dot(dir)
				if p.length() < 0.25 and along > 0.0:
					count += 1
					furthest = maxf(furthest, along)
	return [count, furthest]


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
