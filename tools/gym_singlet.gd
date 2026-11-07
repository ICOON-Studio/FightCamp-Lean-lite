extends RefCounted
## S394 portraits only (bake_gym_portraits.gd): a singlet that survives a close-up. The fight's MH_Top is the body's own triangles
## painted one colour, fine at ring distance; at portrait size its straps are a jagged stair and the chest reads as body paint.
## Here the body's triangles are copied into a shell 2.5 mm off the skin, skinned like the body, the hollows between and under
## the breasts bridged as cloth bridges them, and the garment's edge is drawn per pixel from two ellipses in rest-pose space, so
## the neck and arm holes are smooth curves on every body. MH_Top goes back to skin under it.

const SURFACES := ["MH_Skin_Body", "MH_Top", "MH_Trim", "MH_Skin_Head"]
const OFFSET_M := 0.0025
const HEM_Y_UNDER_SHOULDER := 0.34   # the shell stops this far under the shoulder joints: well out of frame
const BRIDGE_PASSES := 60
const WELDED := ["MH_Skin_Body", "MH_Top", "MH_Trim", "MH_Trunks", "MH_Skin_Head"]   # S395 the head mesh ends in an arc on the chest
const WELD_PER_M := 1250.0   # 0.8 mm: copies of a vertex along the old kit's edges are not quite on each other
const SHADER := """
shader_type spatial;
render_mode cull_disabled;
uniform vec3 colour : source_color = vec3(0.1);
uniform vec3 trim : source_color = vec3(0.7);
uniform vec2 neck_c;
uniform vec2 neck_r;
uniform vec2 arm_c;
uniform vec2 arm_r;
uniform float binding = 0.0055;

float edge(vec2 p, vec2 c, vec2 r) {   // about the distance to the ellipse, + outside it
	vec2 q = (p - c) / r;
	float l = max(length(q), 1e-4);
	return (l - 1.0) * l / max(length(q / r), 1e-4);
}

float neck_edge(vec2 p, vec2 c, vec2 r) {   // a U: the half ellipse below, straight strap edges above it
	return edge(vec2(p.x, min(p.y, c.y)), c, r);
}

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1, 0)), f.x), mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), f.x), f.y);
}

void fragment() {
	vec2 p = vec2(abs(UV.x), UV.y);
	float d = min(neck_edge(p, neck_c, neck_r), edge(p, arm_c, arm_r));
	if (d < 0.0) {
		discard;
	}
	float t = smoothstep(binding, binding - 0.0015, d);
	vec2 w = UV * vec2(30.0, 13.0);   // slack in the cloth: soft creases and a little unevenness, so it is not paint
	float n0 = noise(w) + 0.5 * noise(w * 2.3);
	float nx = noise(w + vec2(0.35, 0.0)) + 0.5 * noise((w + vec2(0.35, 0.0)) * 2.3);
	float ny = noise(w + vec2(0.0, 0.35)) + 0.5 * noise((w + vec2(0.0, 0.35)) * 2.3);
	NORMAL = normalize(NORMAL + vec3(n0 - nx, n0 - ny, 0.0) * 0.14);
	ALBEDO = mix(colour * (0.95 + 0.1 * n0 / 1.5), trim, t);
	ROUGHNESS = 0.82;
	SPECULAR = 0.25;
}
"""


## The old kit's edges are split vertices with different bone weights, some not quite on each other, so a posed body creases
## there. Every copy of a vertex takes the first copy's place, normal and weights. Returns how many copies were moved.
static func weld_weights(mi: MeshInstance3D) -> int:
	var src := mi.mesh as ArrayMesh
	var over: Array = []
	var seen := {}
	var moved := 0
	var out := ArrayMesh.new()
	out.blend_shape_mode = src.blend_shape_mode
	for b in src.get_blend_shape_count():
		out.add_blend_shape(src.get_blend_shape_name(b))
	for s in src.get_surface_count():
		over.append(mi.get_surface_override_material(s))
		var arr: Array = src.surface_get_arrays(s)
		var mat := src.surface_get_material(s)
		var name: String = mat.resource_name if mat != null else ""
		if WELDED.any(func(n): return name.begins_with(n)):
			var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
			var nr: PackedVector3Array = arr[Mesh.ARRAY_NORMAL]
			var bo: PackedInt32Array = arr[Mesh.ARRAY_BONES]
			var we: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
			var per: int = bo.size() / v.size()
			for i in v.size():
				var j := _twin(seen, v[i])
				if j.is_empty():
					seen[_key(v[i], WELD_PER_M)] = [v[i], nr[i], bo.slice(i * per, i * per + per), we.slice(i * per, i * per + per)]
					continue
				v[i] = j[0]
				nr[i] = j[1]
				for c in per:
					bo[i * per + c] = j[2][c]
					we[i * per + c] = j[3][c]
				moved += 1
			arr[Mesh.ARRAY_VERTEX] = v
			arr[Mesh.ARRAY_NORMAL] = nr
			arr[Mesh.ARRAY_BONES] = bo
			arr[Mesh.ARRAY_WEIGHTS] = we
		out.add_surface_from_arrays(src.surface_get_primitive_type(s), arr, src.surface_get_blend_shape_arrays(s), {},
			src.surface_get_format(s) & Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS)
		out.surface_set_material(s, mat)
	mi.mesh = out
	for s in over.size():
		mi.set_surface_override_material(s, over[s])
	return moved


## The old painted kit back to skin: the surfaces share the body's UVs and take its material.
static func bare_top(mi: MeshInstance3D) -> void:
	var skin: Material = null
	for s in mi.mesh.get_surface_count():
		var m := mi.mesh.surface_get_material(s)
		if m != null and m.resource_name.begins_with("MH_Skin_Body"):
			skin = mi.get_active_material(s)
	for s in mi.mesh.get_surface_count():
		var m := mi.mesh.surface_get_material(s)
		if skin != null and m != null and (m.resource_name.begins_with("MH_Top") or m.resource_name.begins_with("MH_Trim")):
			mi.set_surface_override_material(s, skin)


## Puts the singlet on. Returns its mesh instance.
static func wear(mi: MeshInstance3D, skel: Skeleton3D, colour: Color, trim: Color) -> MeshInstance3D:
	var arm := skel.get_bone_global_rest(skel.find_bone("LeftUpperArm")).origin
	var neck := skel.get_bone_global_rest(skel.find_bone("Neck")).origin
	var lim := Vector3(arm.x + 0.05, neck.y + 0.03, arm.y - HEM_Y_UNDER_SHOULDER)   # half width, top, hem
	var pos := PackedVector3Array()
	var nor := PackedVector3Array()
	var bon := PackedInt32Array()
	var wei := PackedFloat32Array()
	var idx := PackedInt32Array()
	var groups := {}        # welded position -> group
	var group_of := PackedInt32Array()
	var per := 4
	for s in mi.mesh.get_surface_count():
		var mat := mi.mesh.surface_get_material(s)
		if mat == null or not SURFACES.any(func(n): return mat.resource_name.begins_with(n)):
			continue
		var a: Array = mi.mesh.surface_get_arrays(s)
		var v: PackedVector3Array = a[Mesh.ARRAY_VERTEX]
		var n: PackedVector3Array = a[Mesh.ARRAY_NORMAL]
		var b: PackedInt32Array = a[Mesh.ARRAY_BONES]
		var w: PackedFloat32Array = a[Mesh.ARRAY_WEIGHTS]
		var ix: PackedInt32Array = a[Mesh.ARRAY_INDEX]
		per = b.size() / v.size()
		var remap := {}
		for t in range(0, ix.size(), 3):
			var keep := true
			for c in 3:
				var p := v[ix[t + c]]
				keep = keep and absf(p.x) < lim.x and p.y < lim.y and p.y > lim.z
			if not keep:
				continue
			for c in 3:
				var o := ix[t + c]
				if not remap.has(o):
					remap[o] = pos.size()
					pos.append(v[o])
					nor.append(n[o])
					bon.append_array(b.slice(o * per, o * per + per))
					wei.append_array(w.slice(o * per, o * per + per))
					var k := _key(v[o], 4000.0)
					if not groups.has(k):
						groups[k] = groups.size()
					group_of.append(groups[k])
				idx.append(remap[o])
	var rest := pos.duplicate()
	_lift(pos, nor, idx, group_of, groups.size(), arm.y, lim.x)
	var uv := PackedVector2Array()
	var uv2 := PackedVector2Array()
	for p in rest:
		uv.append(Vector2(p.x, p.y))
		uv2.append(Vector2(p.z, 0.0))
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = pos
	arrays[Mesh.ARRAY_NORMAL] = nor
	arrays[Mesh.ARRAY_TEX_UV] = uv
	arrays[Mesh.ARRAY_TEX_UV2] = uv2
	arrays[Mesh.ARRAY_BONES] = bon
	arrays[Mesh.ARRAY_WEIGHTS] = wei
	arrays[Mesh.ARRAY_INDEX] = idx
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var sh := Shader.new()
	sh.code = SHADER
	var m := ShaderMaterial.new()
	m.shader = sh
	m.set_shader_parameter("colour", colour)
	m.set_shader_parameter("trim", trim)
	m.set_shader_parameter("neck_c", Vector2(0.0, arm.y + 0.02))
	m.set_shader_parameter("neck_r", Vector2(arm.x * 0.66, 0.085))
	m.set_shader_parameter("arm_c", Vector2(arm.x + 0.085, arm.y + 0.03))
	m.set_shader_parameter("arm_r", Vector2(0.09, 0.19))
	var shell := MeshInstance3D.new()
	shell.name = "GymSinglet"
	shell.mesh = mesh
	shell.material_override = m
	shell.skin = mi.skin
	shell.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	shell.extra_cull_margin = 0.6
	skel.add_child(shell)
	shell.skeleton = shell.get_path_to(skel)
	return shell


## Off the skin along the welded normals, then the front hollows filled (a point only ever moves out, to its neighbours' mean),
## then the normals again from the new surface.
static func _lift(pos: PackedVector3Array, nor: PackedVector3Array, idx: PackedInt32Array, group_of: PackedInt32Array, count: int,
		shoulder_y: float, half_w: float) -> void:
	var gp := PackedVector3Array()
	var gn := PackedVector3Array()
	gp.resize(count)
	gn.resize(count)
	var seen := PackedByteArray()
	seen.resize(count)
	for i in pos.size():
		var g := group_of[i]
		gp[g] = pos[i]
		gn[g] += nor[i]
		seen[g] = 1
	for g in count:
		gn[g] = gn[g].normalized()
		gp[g] += gn[g] * OFFSET_M
	var near: Array = []
	near.resize(count)
	for g in count:
		near[g] = {}
	for t in range(0, idx.size(), 3):
		for c in 3:
			var a := group_of[idx[t + c]]
			var b := group_of[idx[t + (c + 1) % 3]]
			if a != b:
				near[a][b] = true
				near[b][a] = true
	var front := PackedInt32Array()
	for g in count:
		if gn[g].z > 0.15 and gp[g].y < shoulder_y - 0.035 and absf(gp[g].x) < half_w - 0.04:
			front.append(g)
	for pass_i in BRIDGE_PASSES:
		for g in front:
			var z := 0.0
			var keys: Array = near[g].keys()
			for o in keys:
				z += gp[o].z
			if not keys.is_empty():
				gp[g].z = maxf(gp[g].z, z / keys.size())
	var fn := PackedVector3Array()
	fn.resize(count)
	var sign := 0.0
	for t in range(0, idx.size(), 3):
		var a := group_of[idx[t]]
		var b := group_of[idx[t + 1]]
		var c := group_of[idx[t + 2]]
		var f := (gp[b] - gp[a]).cross(gp[c] - gp[a])
		sign += f.dot(gn[a])
		fn[a] += f
		fn[b] += f
		fn[c] += f
	for i in pos.size():
		var g := group_of[i]
		pos[i] = gp[g]
		nor[i] = (fn[g] * signf(sign)).normalized()


## S395 the copy of this vertex already seen, [] if none. It can sit across a cell's rounding edge from its twin (the slits on
## the chest along the old neckline), so the cells around are searched too.
static func _twin(seen: Dictionary, p: Vector3) -> Array:
	var c := _key(p, WELD_PER_M)
	for x in [0, -1, 1]:
		for y in [0, -1, 1]:
			for z in [0, -1, 1]:
				var j: Variant = seen.get(c + Vector3i(x, y, z))
				if j != null and (j[0] as Vector3).distance_to(p) < 1.0 / WELD_PER_M:
					return j
	return []


static func _key(p: Vector3, per_m: float) -> Vector3i:
	return Vector3i((p * per_m).round())
