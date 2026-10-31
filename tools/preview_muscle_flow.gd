extends SceneTree
## S321 preview (operator: "highlight the muscle part eg right biscep (what flows on the muscle that the corner should
## counteract)", documentary style): her own MetaHuman body as glass, the punching muscles inside it glowing. Her right
## deltoid, biceps and forearm fill up during the round (the flow speeds up, orange -> deep red), then the corner's ice
## and shake-out send a cool wave down the arm and the flow slows. The other arm stays mild, so the problem side reads.
## A look test only; nothing in the game reads it.
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --script res://tools/preview_muscle_flow.gd
## Writes E:/FightCamp/gen/s321_anatomy/flow/f_###.png

const MH := preload("res://scripts/fight3d/MHRig.gd")

const OUT := "E:/FightCamp/gen/s321_anatomy/flow"
const STEM := "mh_boxer_10"
const FRAMES := 96   # 4 s at 24 fps: 0-2 s the round builds it, 2-4 s the corner cools it

const GLASS := "shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_back;
uniform vec3 rim = vec3(0.25, 0.72, 1.0);
void fragment() {
	float f = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 2.4);
	ALBEDO = rim * (0.05 + 1.3 * f);
}"

## Fibres along the muscle (object y), streaks that run toward the tendon; heat 0..1 colours and speeds them,
## cool 0..1 is the corner's wave (a front that travels down the muscle, behind it the flow turns cool and slow).
const FLOW := "shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_back;
uniform float heat = 0.2;
uniform float cool = 0.0;
uniform float t = 0.0;
uniform float seed = 0.0;
varying vec3 lp;
void vertex() {
	lp = VERTEX;
	VERTEX.xz *= 1.0 - 0.45 * pow(abs(VERTEX.y * 2.0), 1.6);
}
float h(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7)) + seed) * 43758.5453); }
void fragment() {
	float ang = atan(lp.x, lp.z);
	float lane = floor(ang * 7.0);
	float speed = mix(0.25, 1.6, heat) * (1.0 - 0.75 * cool);
	float s = fract(lp.y * 3.0 + t * speed + h(vec2(lane, 1.0)));
	float streak = smoothstep(0.0, 0.08, s) * smoothstep(0.45, 0.1, s);
	float fib = 0.55 + 0.45 * sin(ang * 22.0 + h(vec2(lane, 2.0)) * 6.0);
	float edge = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 1.2);
	vec3 c0 = vec3(0.2, 0.55, 1.0); vec3 c1 = vec3(0.2, 0.95, 0.45); vec3 c2 = vec3(1.0, 0.85, 0.15); vec3 c3 = vec3(1.0, 0.12, 0.06);
	vec3 hot = heat < 0.35 ? mix(c0, c1, heat / 0.35) : (heat < 0.65 ? mix(c1, c2, (heat - 0.35) / 0.3) : mix(c2, c3, (heat - 0.65) / 0.35));
	float front = smoothstep(lp.y + 0.15, lp.y - 0.15, mix(0.6, -0.6, cool));
	vec3 col = mix(hot, vec3(0.3, 0.8, 1.0), front * cool);
	float k = (0.3 + 0.4 * heat) * (0.3 + 0.9 * streak * fib) * (0.4 + 0.6 * edge);
	float line = smoothstep(0.80, 0.93, 1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0));
	ALBEDO = col * k + mix(col, vec3(1.0), 0.35) * line * 1.1;
}"

var _flow_mats: Array = []   # [material, is_hot_side]


func _initialize() -> void:
	root.size = Vector2i(1280, 1280)
	DirAccess.make_dir_recursive_absolute(OUT)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color(0.015, 0.03, 0.07)
	env.environment.glow_enabled = true
	env.environment.glow_intensity = 1.0
	env.environment.glow_bloom = 0.2
	root.add_child(env)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	root.add_child(cam)
	var glass := ShaderMaterial.new()
	glass.shader = Shader.new()
	glass.shader.code = GLASS
	var flow := Shader.new()
	flow.code = FLOW
	await process_frame
	var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % STEM)
	root.add_child(body)
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		var mat0: Material = mi.mesh.surface_get_material(0)
		var n := (mi.name + (mat0.resource_name if mat0 != null else "")).to_lower()
		mi.visible = not (n.contains("hair") or n.contains("brow") or n.contains("lash") or n.contains("fuzz")
			or n.contains("teeth") or n.contains("tongue") or n.contains("mouth"))
		mi.material_override = glass
	await process_frame
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var pos := func(b: String) -> Vector3:
		return (skel.global_transform * skel.get_bone_global_pose(skel.find_bone(b))).origin
	var fwd := 1.0 if (pos.call("LeftToes") as Vector3).z > (pos.call("LeftFoot") as Vector3).z else -1.0
	for side in ["Right", "Left"]:
		var hot: bool = side == "Right"
		var sh: Vector3 = pos.call(side + "UpperArm")
		var el: Vector3 = pos.call(side + "LowerArm")
		var wr: Vector3 = pos.call(side + "Hand")
		var out := Vector3(signf(sh.x), 0, 0)
		var front := Vector3(0, 0, fwd)
		# deltoid cap over the shoulder joint, biceps on the front of the upper arm, forearm flexors below the elbow
		_muscle(root, sh + out * 0.012 + Vector3(0, 0.005, 0), sh.lerp(el, 0.42) + out * 0.018, 0.052, flow, hot, 1.0)
		_muscle(root, sh.lerp(el, 0.18) + front * 0.022, el + front * 0.018 - (el - sh).normalized() * 0.03, 0.034, flow, hot, 2.0)
		_muscle(root, el.lerp(wr, 0.06) + front * 0.012, el.lerp(wr, 0.72), 0.03, flow, hot, 3.0)
	# The trunk groups, outlined like the arms (front view: their depth does not matter, the glass writes no depth).
	var ch: Vector3 = pos.call("Chest")
	var up: Vector3 = pos.call("UpperChest")
	var sp: Vector3 = pos.call("Spine")
	var hp: Vector3 = pos.call("Hips")
	var fz := Vector3(0, 0, 0.1 * fwd)
	for sx in [-1.0, 1.0]:
		_muscle(root, Vector3(sx * 0.025, up.y - 0.035, up.z) + fz, Vector3(sx * 0.15, up.y + 0.02, up.z) + fz, 0.05, flow, false, 4.0 + sx)
		_muscle(root, Vector3(sx * 0.105, ch.y + 0.02, ch.z) + fz, Vector3(sx * 0.09, sp.y - 0.06, sp.z) + fz, 0.032, flow, false, 6.0 + sx)
		_muscle(root, Vector3(sx * 0.035, ch.y - 0.04, ch.z) + fz, Vector3(sx * 0.03, hp.y + 0.03, hp.z) + fz, 0.03, flow, false, 8.0 + sx)
	# Documentary close-up: head to hips, a little room on both sides for the arms.
	var hips: Vector3 = pos.call("Hips")
	var head: Vector3 = pos.call("Head")
	var lo := hips.y - 0.12
	var hi := head.y + 0.16
	cam.size = (hi - lo) * 1.02
	cam.position = Vector3(0, (lo + hi) * 0.5, 6.0 * fwd)
	cam.look_at(Vector3(0, (lo + hi) * 0.5, 0), Vector3.UP)
	for f in FRAMES:
		var sec := float(f) / 24.0
		var build := clampf(sec / 2.0, 0.0, 1.0)
		var cool := clampf((sec - 2.2) / 1.5, 0.0, 1.0)
		for e in _flow_mats:
			var mat: ShaderMaterial = e[0]
			var hot_side: bool = e[1]
			var heat := (0.15 + 0.85 * build) if hot_side else (0.12 + 0.25 * build)
			if hot_side:
				heat = lerpf(heat, 0.45, cool)
			mat.set_shader_parameter("heat", heat)
			mat.set_shader_parameter("cool", cool if hot_side else 0.0)
			mat.set_shader_parameter("t", sec)
		for i in 2:
			await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(OUT.path_join("f_%03d.png" % f))
	print("FLOW frames=%d" % FRAMES)
	quit(0)


## An ellipsoid muscle from a to b (radius r across, the length between), with its own flow material.
func _muscle(parent: Node, a: Vector3, b: Vector3, r: float, shader: Shader, hot: bool, seed: float) -> void:
	var mat := ShaderMaterial.new()
	mat.shader = shader
	mat.set_shader_parameter("seed", seed + (10.0 if hot else 0.0))
	_flow_mats.append([mat, hot])
	var mi := MeshInstance3D.new()
	var sp := SphereMesh.new()
	sp.radius = 0.5
	sp.height = 1.0
	sp.radial_segments = 48
	sp.rings = 32
	mi.mesh = sp
	mi.material_override = mat
	parent.add_child(mi)
	var y := b - a
	var len := y.length()
	y = y / len
	var x := y.cross(Vector3.FORWARD if absf(y.dot(Vector3.FORWARD)) < 0.9 else Vector3.RIGHT).normalized()
	var z := x.cross(y)
	mi.global_transform = Transform3D(Basis(x * r * 2.0, y * len, z * r * 1.7), (a + b) * 0.5)
