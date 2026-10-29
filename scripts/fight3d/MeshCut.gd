extends RefCounted
## Cuts skinned triangles away: every triangle with a vertex that the named bones carry (weight >= `min_w`) goes.
## Gloves use it on the hands (no finger through a glove); the vest uses it on the tee's sleeves.


## Bones of `skel` whose names contain any of `parts` (case-insensitive): {name: true}.
static func bones_named(skel: Skeleton3D, parts: Array) -> Dictionary:
	var out := {}
	for bi in skel.get_bone_count():
		var bn := str(skel.get_bone_name(bi))
		for p in parts:
			if bn.to_lower().contains(str(p).to_lower()):
				out[bn] = true
	return out


## Cuts the triangles of every surface of `mi` whose material name starts with `only` ("" = every surface).
static func cut(mi: MeshInstance3D, skel: Skeleton3D, names: Dictionary, only: String = "", min_w: float = 0.25) -> int:
	if mi.skin == null or mi.mesh == null:
		return 0
	var binds := {}
	for bi in mi.skin.get_bind_count():
		var nm := str(mi.skin.get_bind_name(bi))
		if nm.is_empty():
			nm = str(skel.get_bone_name(mi.skin.get_bind_bone(bi)))
		if names.has(nm):
			binds[bi] = true
	var src := mi.mesh as ArrayMesh
	if binds.is_empty() or src == null:
		return 0
	var removed := 0
	var overrides: Array = []
	for s in src.get_surface_count():
		overrides.append(mi.get_surface_override_material(s))
	var out := ArrayMesh.new()
	out.blend_shape_mode = src.blend_shape_mode
	for bs in src.get_blend_shape_count():
		out.add_blend_shape(src.get_blend_shape_name(bs))
	for s in src.get_surface_count():
		var arr: Array = src.surface_get_arrays(s)
		var shapes: Array = src.surface_get_blend_shape_arrays(s)
		var flags: int = src.surface_get_format(s) & Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS
		var mat := src.surface_get_material(s)
		var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
		var bones: PackedInt32Array = arr[Mesh.ARRAY_BONES] if arr[Mesh.ARRAY_BONES] != null else PackedInt32Array()
		var weights: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS] if arr[Mesh.ARRAY_WEIGHTS] != null else PackedFloat32Array()
		var index: PackedInt32Array = arr[Mesh.ARRAY_INDEX] if arr[Mesh.ARRAY_INDEX] != null else PackedInt32Array()
		var wanted := only == "" or (mat != null and mat.resource_name.begins_with(only))
		if wanted and not (bones.is_empty() or index.is_empty() or verts.is_empty()):
			var per: int = bones.size() / verts.size()
			var hit := PackedByteArray()
			hit.resize(verts.size())
			for vi in verts.size():
				var w := 0.0
				for k in per:
					if binds.has(bones[vi * per + k]):
						w += weights[vi * per + k]
				hit[vi] = 1 if w >= min_w else 0
			var kept := PackedInt32Array()
			var t := 0
			while t + 2 < index.size():
				if hit[index[t]] == 0 and hit[index[t + 1]] == 0 and hit[index[t + 2]] == 0:
					kept.append_array([index[t], index[t + 1], index[t + 2]])
				else:
					removed += 1
				t += 3
			arr[Mesh.ARRAY_INDEX] = kept
		out.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr, shapes, {}, flags)
		out.surface_set_material(out.get_surface_count() - 1, mat)
	out.custom_aabb = src.get_aabb()
	var values: Array = []
	for bs in src.get_blend_shape_count():
		values.append(mi.get_blend_shape_value(bs))
	mi.mesh = out
	for bs in values.size():
		mi.set_blend_shape_value(bs, float(values[bs]))
	for s in overrides.size():
		mi.set_surface_override_material(s, overrides[s])
	return removed
