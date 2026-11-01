extends Node
## Mitts: procedural focus mitts for the coach's hands in pad work.
## A smooth rounded pad (~0.24 x 0.20 x 0.06 m, black with a white ring on its face)
## attached to a hand bone. Proper normals, no stacked discs.
##   mount(body)  mitt_pos(side) -> Vector3  set_target_pos(side, pos)  position_mitt(side, pos)

const FACE_W := 0.24
const FACE_H := 0.20
const DEPTH := 0.06
const FACE_OFFSET := 0.03
const RING_INNER_R := 0.04
const RING_OUTER_R := 0.055

var skel: Skeleton3D
var mitts := {}
var _targets := {}
var _hand_bones := {}


func mount(body: Node3D) -> int:
	var skels := body.find_children("*", "Skeleton3D", true, false)
	if skels.is_empty():
		return 0
	skel = skels[0] as Skeleton3D
	for side in ["Left", "Right"]:
		var bone_name: String = side + "Hand"
		var bone_id: int = skel.find_bone(bone_name)
		if bone_id < 0:
			continue
		_hand_bones[side] = bone_id
		var mitt := _build_mitt(side)
		skel.add_child(mitt)
		mitts[side] = mitt
		_targets[side] = Callable()
	skel.skeleton_updated.connect(_follow)
	_follow()
	return mitts.size()


## Builds a smooth rounded focus mitt from an ArrayMesh.
## The face is an ellipse with a subtle dome, backed by a padded rear.
func _build_mitt(side: String) -> Node3D:
	var root := Node3D.new()
	root.name = "Mitt_" + side
	# The pad body: a smooth elliptical shape.
	var pad_mesh := MeshInstance3D.new()
	pad_mesh.mesh = _build_pad_mesh()
	var pad_mat := StandardMaterial3D.new()
	pad_mat.albedo_color = Color(0.05, 0.05, 0.05)
	pad_mat.roughness = 0.7
	pad_mat.metallic = 0.02
	pad_mesh.material_override = pad_mat
	root.add_child(pad_mesh)
	# White ring on the striking face.
	var ring_mesh := MeshInstance3D.new()
	ring_mesh.mesh = _build_ring_mesh(RING_INNER_R, RING_OUTER_R, 32)
	var ring_mat := StandardMaterial3D.new()
	ring_mat.albedo_color = Color(0.92, 0.92, 0.90)
	ring_mat.roughness = 0.4
	ring_mesh.material_override = ring_mat
	ring_mesh.position = Vector3(0, 0, DEPTH * 0.5 + 0.001)
	root.add_child(ring_mesh)
	return root


## Builds a smooth elliptical pad with a domed front face and rounded edges.
## Uses a lathe-like approach: elliptical cross-sections stacked along Z.
func _build_pad_mesh() -> ArrayMesh:
	var mesh := ArrayMesh.new()
	var verts := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	# Build as stacked elliptical rings along Z axis.
	var n_slices := 16  # rings along Z
	var n_segments := 32  # points per ring
	var half_w := FACE_W * 0.5
	var half_h := FACE_H * 0.5
	var half_d := DEPTH * 0.5
	for iz in n_slices + 1:
		var t: float = float(iz) / float(n_slices)
		var z: float = -half_d + t * DEPTH
		# Ellipse size varies along Z: full at front (t=1), smaller at back (t=0).
		var scale: float = 0.7 + 0.3 * t  # back is 70% of front size
		# Dome curve: front face bulges slightly.
		var dome: float = 0.012 * sin(t * PI) if t > 0.5 else 0.0
		for iseg in n_segments:
			var a: float = TAU * float(iseg) / float(n_segments)
			var ca: float = cos(a)
			var sa: float = sin(a)
			var x: float = ca * half_w * scale
			var y: float = sa * half_h * scale
			verts.append(Vector3(x, y, z + dome))
			# Normal: points outward from the elliptical cross-section.
			var nx: float = ca / half_w
			var ny: float = sa / half_h
			var nlen: float = sqrt(nx * nx + ny * ny)
			if nlen > 0.001:
				nx /= nlen
				ny /= nlen
			normals.append(Vector3(nx, ny, 0.1).normalized())
	# Connect rings with triangles.
	for iz in n_slices:
		for iseg in n_segments:
			var next_seg: int = (iseg + 1) % n_segments
			var i00: int = iz * n_segments + iseg
			var i10: int = iz * n_segments + next_seg
			var i01: int = (iz + 1) * n_segments + iseg
			var i11: int = (iz + 1) * n_segments + next_seg
			# Front face (CCW from outside).
			indices.append(i00)
			indices.append(i10)
			indices.append(i11)
			indices.append(i00)
			indices.append(i11)
			indices.append(i01)
	# Cap the back face (flat ellipse at z = -half_d).
	var back_center_idx: int = verts.size()
	verts.append(Vector3(0, 0, -half_d))
	normals.append(Vector3(0, 0, -1))
	for iseg in n_segments:
		var next_seg: int = (iseg + 1) % n_segments
		indices.append(back_center_idx)
		indices.append(iseg)
		indices.append(next_seg)
	# Cap the front face (domed ellipse at z = half_d).
	var front_center_idx: int = verts.size()
	verts.append(Vector3(0, 0, half_d + 0.012))
	normals.append(Vector3(0, 0, 1))
	var front_ring_start: int = n_slices * n_segments
	for iseg in n_segments:
		var next_seg: int = (iseg + 1) % n_segments
		indices.append(front_center_idx)
		indices.append(front_ring_start + next_seg)
		indices.append(front_ring_start + iseg)
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh


## Builds a ring (annulus) mesh in the XY plane.
func _build_ring_mesh(inner_r: float, outer_r: float, segments: int) -> ArrayMesh:
	var mesh := ArrayMesh.new()
	var verts := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	for i in segments:
		var a: float = TAU * float(i) / float(segments)
		var c: float = cos(a)
		var s: float = sin(a)
		verts.append(Vector3(c * inner_r, s * inner_r, 0))
		normals.append(Vector3(0, 0, 1))
		verts.append(Vector3(c * outer_r, s * outer_r, 0))
		normals.append(Vector3(0, 0, 1))
	for i in segments:
		var next_i: int = (i + 1) % segments
		var i0 := i * 2
		var i1 := i * 2 + 1
		var n0 := next_i * 2
		var n1 := next_i * 2 + 1
		indices.append(i0)
		indices.append(i1)
		indices.append(n1)
		indices.append(i0)
		indices.append(n1)
		indices.append(n0)
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh


func mitt_pos(side: String) -> Vector3:
	var mitt: Node3D = mitts.get(side)
	if mitt == null:
		return Vector3.ZERO
	return mitt.global_transform.origin + mitt.global_transform.basis.z.normalized() * FACE_OFFSET


func set_target(side: String, target: Variant) -> void:
	_targets[side] = target if target != null else Callable()


## Sets a fixed target position.
func set_target_pos(side: String, pos: Vector3) -> void:
	_targets[side] = func(): return pos


func position_mitt(side: String, world_pos: Vector3) -> void:
	var mitt: Node3D = mitts.get(side)
	if mitt == null:
		return
	var coach_node: Node3D = mitt.get_parent().get_parent() if mitt.get_parent() != null else null
	var forward := -coach_node.global_transform.basis.z.normalized() if coach_node != null else Vector3.FORWARD
	var up := Vector3.UP
	var right := up.cross(forward).normalized()
	if right.length() < 0.01:
		right = Vector3.RIGHT
	up = forward.cross(right).normalized()
	mitt.global_transform = Transform3D(Basis(right, up, forward), world_pos)


func _follow() -> void:
	for side in mitts:
		var bone_id: int = _hand_bones[side]
		var hand_pose := skel.get_bone_global_pose(bone_id)
		var mitt: Node3D = mitts[side]
		var hand_world := skel.global_transform * hand_pose
		var target: Callable = _targets.get(side, Callable())
		if target.is_valid():
			var want: Vector3 = target.call()
			var to_target := (want - hand_world.origin).normalized()
			if to_target.length() > 0.01:
				var up := Vector3.UP
				var right := up.cross(to_target).normalized()
				if right.length() < 0.01:
					right = hand_world.basis.x.normalized()
				up = to_target.cross(right).normalized()
				mitt.global_transform = Transform3D(Basis(right, up, to_target), want - to_target * FACE_OFFSET)
			else:
				mitt.global_transform = hand_world
		else:
			var guard_pos := hand_world.origin + hand_world.basis.z.normalized() * 0.08
			mitt.global_transform = Transform3D(hand_world.basis, guard_pos)
