extends Node3D
## The fight-night set around the 3D ring (split from FightStage.gd in S301 to keep it under 500 lines): the ring with its
## posts and ropes, the lights, and the seated crowd. `ring_side` = the posts and ropes FightStage hides when they stand
## between the camera and the boxers.

var RING_M := 5.5
var APRON_M := 0.6
var ring_side: Array = []


func build(ring_m: float, apron_m: float) -> void:
	RING_M = ring_m
	APRON_M = apron_m
	_build_ring()
	_build_lights()


func _build_ring() -> void:
	var half := RING_M * 0.5
	_box(Vector3(RING_M + APRON_M * 2.0, 0.08, RING_M + APRON_M * 2.0), Vector3(0, -0.04, 0), Color(0.22, 0.31, 0.46), 0.95)
	_box(Vector3(RING_M + APRON_M * 2.0 + 0.02, 1.0, RING_M + APRON_M * 2.0 + 0.02), Vector3(0, -0.58, 0), Color(0.08, 0.08, 0.1), 0.8)
	var floor := MeshInstance3D.new()
	floor.mesh = PlaneMesh.new()
	(floor.mesh as PlaneMesh).size = Vector2(60, 60)
	floor.position.y = -1.08
	floor.material_override = _mat(Color(0.05, 0.05, 0.06), 0.9)
	add_child(floor)
	var posts := [Vector3(-half, 0, -half), Vector3(half, 0, -half), Vector3(half, 0, half), Vector3(-half, 0, half)]
	var post_cols := [Color(0.6, 0.06, 0.06), Color(0.9, 0.9, 0.9), Color(0.06, 0.16, 0.6), Color(0.9, 0.9, 0.9)]
	for i in 4:
		ring_side.append(_cyl(0.05, 1.45, posts[i] + Vector3(0, 0.725, 0), post_cols[i]))
	for h in [0.45, 0.85, 1.25]:
		for i in 4:
			var p0: Vector3 = posts[i]
			var p1: Vector3 = posts[(i + 1) % 4]
			var rope := MeshInstance3D.new()
			var cm := CylinderMesh.new()
			cm.top_radius = 0.018
			cm.bottom_radius = 0.018
			cm.height = p0.distance_to(p1)
			rope.mesh = cm
			rope.material_override = _mat(Color(0.85, 0.08, 0.08) if h == 0.85 else Color(0.92, 0.92, 0.92), 0.5)
			add_child(rope)
			ring_side.append(rope)
			rope.position = (p0 + p1) * 0.5 + Vector3(0, h, 0)
			rope.look_at(rope.position + (p1 - p0).normalized(), Vector3.UP)
			rope.rotate_object_local(Vector3.RIGHT, PI * 0.5)


## Fight-night lighting: the ring bright under an overhead rig, the hall dark around it, the crowd just readable.
func _build_lights() -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.012, 0.012, 0.018)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.45, 0.47, 0.55)
	e.ambient_light_energy = 0.32
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	e.tonemap_exposure = 1.05
	e.ssao_enabled = true
	e.ssao_intensity = 1.2
	e.glow_enabled = true
	e.glow_intensity = 0.35
	e.glow_hdr_threshold = 1.4
	e.fog_enabled = true
	e.fog_light_color = Color(0.1, 0.1, 0.13)
	e.fog_density = 0.012
	env.environment = e
	add_child(env)
	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-70, -30, 0)
	key.light_energy = 0.55
	key.shadow_enabled = true
	add_child(key)
	# The rig: four banks over the ring's corners, aimed at the centre, plus one straight down.
	var half := RING_M * 0.5
	for c in [Vector3(-half, 0, -half), Vector3(half, 0, -half), Vector3(half, 0, half), Vector3(-half, 0, half), Vector3.ZERO]:
		var spot := SpotLight3D.new()
		var top := Vector3(c.x * 0.8, 6.5, c.z * 0.8)
		add_child(spot)
		spot.look_at_from_position(top, Vector3(0, 0.8, 0) if c != Vector3.ZERO else Vector3(0, 0, 0.01), Vector3.UP)
		spot.spot_range = 12.0
		spot.spot_angle = 34.0
		spot.light_energy = 2.2 if c != Vector3.ZERO else 3.0
		spot.light_color = Color(1.0, 0.97, 0.92)
		spot.shadow_enabled = c == Vector3.ZERO
	# The hall: a dim warm wash over the crowd.
	for x in [-7.0, 7.0]:
		for z in [-7.0, 7.0]:
			var o := OmniLight3D.new()
			o.position = Vector3(x, 4.0, z)
			o.omni_range = 9.0
			o.light_energy = 0.35
			o.light_color = Color(1.0, 0.85, 0.7)
			add_child(o)
	_build_crowd()


## The crowd: tiered rows of seated figures on all four sides, in the dark beyond the ring (one MultiMesh, no animation).
func _build_crowd() -> void:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	var body := CapsuleMesh.new()
	body.radius = 0.2
	body.height = 0.78
	mm.mesh = body
	var rng := RandomNumberGenerator.new()
	rng.seed = 77
	var spots: Array = []
	for side in 4:
		for row in 9:
			var dist := 5.6 + row * 0.85
			var y := -0.55 + row * 0.42
			var n := int(dist * 2.0 / 0.58)
			for k in n:
				if rng.randf() < 0.12:
					continue   # empty seats
				var along := -dist + (k + 0.5) * (dist * 2.0 / n) + rng.randf_range(-0.06, 0.06)
				var p := Vector3(along, y + rng.randf_range(0.0, 0.08), dist)
				spots.append(Basis(Vector3.UP, side * PI * 0.5) * p)
	mm.instance_count = spots.size()
	var shirts := [Color(0.12, 0.12, 0.14), Color(0.2, 0.2, 0.24), Color(0.35, 0.08, 0.08), Color(0.08, 0.14, 0.3),
		Color(0.5, 0.48, 0.44), Color(0.15, 0.25, 0.18), Color(0.6, 0.6, 0.62)]
	for i in spots.size():
		var p: Vector3 = spots[i]
		var t := Transform3D(Basis.from_scale(Vector3(1.0, rng.randf_range(0.9, 1.1), 1.0)), p + Vector3(0, 0.39, 0))
		mm.set_instance_transform(i, t)
		mm.set_instance_color(i, shirts[rng.randi() % shirts.size()].darkened(rng.randf_range(0.7, 0.85)))
	var mi := MultiMeshInstance3D.new()
	mi.multimesh = mm
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 0.9
	mi.material_override = mat
	add_child(mi)
	# Heads, a skin-tone sphere above each body.
	var heads := MultiMesh.new()
	heads.transform_format = MultiMesh.TRANSFORM_3D
	heads.use_colors = true
	var hm := SphereMesh.new()
	hm.radius = 0.11
	hm.height = 0.24
	heads.mesh = hm
	heads.instance_count = spots.size()
	var skins := [Color(0.85, 0.66, 0.52), Color(0.55, 0.38, 0.26), Color(0.32, 0.21, 0.14), Color(0.72, 0.55, 0.4)]
	for i in spots.size():
		heads.set_instance_transform(i, Transform3D(Basis(), (spots[i] as Vector3) + Vector3(0, 0.9, 0)))
		heads.set_instance_color(i, skins[rng.randi() % skins.size()].darkened(0.62))
	var hi := MultiMeshInstance3D.new()
	hi.multimesh = heads
	hi.material_override = mat
	add_child(hi)
	# Tiers under the crowd.
	for side in 4:
		for row in 9:
			var dist := 5.6 + row * 0.85
			var tier := MeshInstance3D.new()
			var bm := BoxMesh.new()
			bm.size = Vector3(dist * 2.0 + 0.85, 0.42, 0.85)
			tier.mesh = bm
			tier.material_override = _mat(Color(0.07, 0.07, 0.08), 0.9)
			tier.position = Basis(Vector3.UP, side * PI * 0.5) * Vector3(0, -0.55 + row * 0.42 - 0.21, dist)
			tier.rotation.y = side * PI * 0.5
			add_child(tier)


func _box(size: Vector3, pos: Vector3, col: Color, rough: float) -> void:
	var m := MeshInstance3D.new()
	m.mesh = BoxMesh.new()
	(m.mesh as BoxMesh).size = size
	m.position = pos
	m.material_override = _mat(col, rough)
	add_child(m)


func _cyl(r: float, h: float, pos: Vector3, col: Color) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var c := CylinderMesh.new()
	c.top_radius = r
	c.bottom_radius = r
	c.height = h
	m.mesh = c
	m.position = pos
	m.material_override = _mat(col, 0.6)
	add_child(m)
	return m


func _mat(col: Color, rough: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = col
	m.roughness = rough
	return m
