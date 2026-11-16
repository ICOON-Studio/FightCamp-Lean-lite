extends RefCounted
## FIGHT VIDEO DATASET (S495): what one synthetic clip looks like - the camera, the light, the room, the canvas and both
## kits - so a model trained on the clips does not learn one picture. Everything here is ours: the ring, the bodies and
## the gym room (plain boxes and cylinders built below, not a modelled gym).
##   plan(rng, index) -> a Dictionary that goes into the clip's labels as written
##   apply(stage, plan, st)   once before the clip;   camera(stage, plan, st, t, dt)   every frame
## Cameras: "tv" = the game's own broadcast lens (it cuts between shots; ropes fade as in the game); "corner" = a still
## wide lens above a ring corner (how the Olympic test set was filmed); "phone" = hand-held at ringside, following the
## pair late and shaking; "tripod" = a still lens further back, low or high. Outside lenses see the ropes solid.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")

const MODES := ["corner", "phone", "tv", "tripod"]
const KITS := {"red": Color(0.78, 0.08, 0.08), "blue": Color(0.08, 0.28, 0.78), "white": Color(0.92, 0.92, 0.9),
	"black": Color(0.05, 0.05, 0.06), "green": Color(0.1, 0.5, 0.2), "yellow": Color(0.9, 0.78, 0.1),
	"purple": Color(0.45, 0.15, 0.6), "orange": Color(0.92, 0.45, 0.08), "grey": Color(0.5, 0.5, 0.52),
	"navy": Color(0.05, 0.08, 0.28), "maroon": Color(0.4, 0.05, 0.1), "teal": Color(0.05, 0.5, 0.5), "pink": Color(0.9, 0.4, 0.6)}
const CANVAS := [Color(0.09, 0.28, 0.6), Color(0.8, 0.8, 0.78), Color(0.55, 0.08, 0.08), Color(0.2, 0.2, 0.22),
	Color(0.1, 0.4, 0.25), Color(0.75, 0.7, 0.5)]
const WALLS := [Color(0.85, 0.85, 0.82), Color(0.8, 0.74, 0.6), Color(0.55, 0.56, 0.6), Color(0.5, 0.22, 0.16),
	Color(0.3, 0.4, 0.5), Color(0.35, 0.45, 0.35), Color(0.25, 0.25, 0.27)]
const FLOORS := [Color(0.3, 0.3, 0.32), Color(0.5, 0.36, 0.22), Color(0.12, 0.12, 0.13), Color(0.2, 0.3, 0.45)]
const SAME_KIT_CHANCE := 0.12   # both boxers in the same colours (the hard case for telling them apart)
const GYM_CHANCE := 0.45


static func _rgb(c: Color) -> Array:
	return [snappedf(c.r, 0.01), snappedf(c.g, 0.01), snappedf(c.b, 0.01)]


static func _col(a: Variant) -> Color:
	return Color(float(a[0]), float(a[1]), float(a[2]))


static func plan(rng: RandomNumberGenerator, index: int) -> Dictionary:
	var mode: String = MODES[index % MODES.size()]
	var cam := {"mode": mode, "angle_deg": rng.randf_range(0.0, 360.0)}
	match mode:
		"corner":
			cam["angle_deg"] = 45.0 + 90.0 * (rng.randi() % 4) + rng.randf_range(-6.0, 6.0)
			cam.merge({"dist": rng.randf_range(4.6, 5.4), "h": rng.randf_range(2.0, 2.9), "fov": rng.randf_range(32.0, 50.0),
				"look_h": rng.randf_range(0.7, 1.1)})
		"phone":
			# Beside one side of the ring, never behind a corner post, and the lens between two ropes or above the top one
			# (ropes at 0.45, 0.85 and 1.25 m): the first render had a post or a rope filling a quarter of these clips.
			cam["angle_deg"] = 90.0 * (rng.randi() % 4) + rng.randf_range(-28.0, 28.0)
			var gaps := [Vector2(0.56, 0.74), Vector2(0.96, 1.14), Vector2(1.4, 1.75)]
			var gap: Vector2 = gaps[rng.randi() % gaps.size()]
			cam.merge({"dist": rng.randf_range(3.8, 5.0), "h": rng.randf_range(gap.x, gap.y), "fov": rng.randf_range(38.0, 58.0),
				"look_h": rng.randf_range(1.0, 1.3), "lag_s": rng.randf_range(0.25, 0.6), "shake": rng.randf_range(0.4, 1.4)})
		"tripod":
			cam.merge({"dist": rng.randf_range(4.8, 6.0), "h": rng.randf_range(1.3, 1.9) if rng.randf() < 0.6 else rng.randf_range(2.8, 4.2),
				"fov": rng.randf_range(30.0, 46.0), "look_h": rng.randf_range(0.9, 1.2)})
	var names: Array = KITS.keys()
	var a := str(names[rng.randi() % names.size()])
	var b := a
	if rng.randf() >= SAME_KIT_CHANCE:
		while b == a:
			b = str(names[rng.randi() % names.size()])
	var kits: Array = []
	for n in [a, b]:
		var vest: Color = KITS[n]
		# Trunks: the vest's colour darker (an amateur kit), or their own colour (a third of the time).
		var trunks: Color = vest.darkened(0.45) if rng.randf() < 0.67 else (KITS[names[rng.randi() % names.size()]] as Color)
		var gloves: Color = vest if rng.randf() < 0.5 else ([KITS["red"], KITS["blue"], KITS["black"], KITS["white"]][rng.randi() % 4] as Color)
		kits.append({"name": n, "vest": _rgb(vest), "trunks": _rgb(trunks), "gloves": _rgb(gloves)})
	var gym := rng.randf() < GYM_CHANCE
	var p := {"camera": cam, "room": "gym" if gym else "arena", "kit": kits,
		"canvas": _rgb(CANVAS[rng.randi() % CANVAS.size()]),
		"light": {"spots": snappedf(rng.randf_range(0.65, 1.35), 0.01), "exposure": snappedf(rng.randf_range(0.95, 1.35), 0.01),
			"ambient": snappedf(rng.randf_range(0.9, 1.5) if gym else rng.randf_range(0.15, 0.5), 0.01),
			"warm": snappedf(rng.randf_range(-0.08, 0.08), 0.01)}}
	if gym:
		p["gym"] = {"wall": _rgb(WALLS[rng.randi() % WALLS.size()]), "floor": _rgb(FLOORS[rng.randi() % FLOORS.size()]),
			"wall_m": snappedf(rng.randf_range(7.0, 11.0), 0.1), "bags": 3 + rng.randi() % 5, "posters": 4 + rng.randi() % 5,
			"seed": rng.randi()}
	return p


## First call: remembers the set as the game built it (st["base"]).
static func _base(stage: Node3D, st: Dictionary) -> void:
	if st.has("base"):
		return
	var ring: Node3D = stage.get_node("RingSet")
	var env: Environment = (ring.find_children("*", "WorldEnvironment", true, false)[0] as WorldEnvironment).environment
	var b := {"env": env, "bg": env.background_color, "amb": env.ambient_light_energy, "fog": env.fog_enabled,
		"exposure": env.tonemap_exposure, "glow": env.glow_intensity, "spots": [], "omnis": [], "crowd": [], "ring_side": stage._ring_side}
	for n in ring.get_children():
		if n is SpotLight3D:
			(b["spots"] as Array).append([n, (n as SpotLight3D).light_energy])
		elif n is OmniLight3D:
			(b["omnis"] as Array).append([n, (n as OmniLight3D).light_energy])
		elif n is MultiMeshInstance3D or n.name == "CrowdFlashes":
			(b["crowd"] as Array).append(n)
		elif n is MeshInstance3D and (n as MeshInstance3D).mesh is BoxMesh:
			var size: Vector3 = ((n as MeshInstance3D).mesh as BoxMesh).size
			if is_equal_approx(size.y, 0.42):
				(b["crowd"] as Array).append(n)        # a tier under the crowd
			elif is_equal_approx(size.y, 0.08):
				b["canvas"] = n
		elif n is MeshInstance3D and (n as MeshInstance3D).mesh is PlaneMesh:
			b["floor"] = n
			b["floor_col"] = ((n as MeshInstance3D).material_override as StandardMaterial3D).albedo_color
	st["base"] = b


static func apply(stage: Node3D, p: Dictionary, st: Dictionary) -> void:
	_base(stage, st)
	var b: Dictionary = st["base"]
	for n in st.get("made", []):
		(n as Node).queue_free()
	st["made"] = []
	var gym := str(p["room"]) == "gym"
	var light: Dictionary = p["light"]
	var env: Environment = b["env"]
	env.background_color = Color(0.6, 0.62, 0.66) if gym else (b["bg"] as Color)
	env.ambient_light_energy = float(light["ambient"])
	env.fog_enabled = false if gym else bool(b["fog"])
	env.tonemap_exposure = float(light["exposure"])
	env.glow_intensity = 0.2 if gym else float(b["glow"])
	var warm := float(light["warm"])
	for row in b["spots"]:
		(row[0] as SpotLight3D).light_energy = float(row[1]) * float(light["spots"])
		(row[0] as SpotLight3D).light_color = Color(1.0 + warm, 0.97, 0.92 - warm)
	for row in b["omnis"]:
		(row[0] as OmniLight3D).light_energy = float(row[1]) * (8.0 if gym else 1.0)
	for n in b["crowd"]:
		(n as Node3D).visible = not gym
	((b["canvas"] as MeshInstance3D).material_override as StandardMaterial3D).albedo_color = _col(p["canvas"])
	((b["floor"] as MeshInstance3D).material_override as StandardMaterial3D).albedo_color = _col(p["gym"]["floor"]) if gym else (b["floor_col"] as Color)
	if gym:
		_gym(stage, p["gym"], st)
	for i in 2:
		dress(stage, i, p["kit"][i])
	var cam: Dictionary = p["camera"]
	var tv := str(cam["mode"]) == "tv"
	stage._ring_side = b["ring_side"] if tv else []   # an outside lens sees the ropes solid, as a real one does
	(stage.camera.attributes as CameraAttributesPractical).dof_blur_far_enabled = tv
	st["look"] = Vector3(0, float(cam.get("look_h", 1.1)), 0)
	if tv:
		stage.camera.close = false
		stage.broadcast(true)


## The gym room round the ring: four painted walls, heavy bags and posters (boxes and cylinders, built here).
static func _gym(stage: Node3D, g: Dictionary, st: Dictionary) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(g["seed"])
	var d := float(g["wall_m"])
	var wall := _col(g["wall"])
	var made: Array = st["made"]
	for k in 4:
		var turn := Basis(Vector3.UP, k * PI * 0.5)
		made.append(_box(stage, Vector3(d * 2.0 + 0.4, 7.0, 0.3), turn * Vector3(0, 2.4, d), k * PI * 0.5, wall, 0.9))
		for j in int(g["posters"]) / 2 + (k % 2):
			var w := rng.randf_range(0.6, 1.6)
			var paint := Color.from_hsv(rng.randf(), rng.randf_range(0.3, 0.9), rng.randf_range(0.4, 0.95))
			made.append(_box(stage, Vector3(w, w * rng.randf_range(0.7, 1.5), 0.05),
				turn * Vector3(rng.randf_range(-d * 0.8, d * 0.8), rng.randf_range(0.6, 2.6), d - 0.2), k * PI * 0.5, paint, 0.7))
	for j in int(g["bags"]):
		var ang := rng.randf() * TAU
		var r := rng.randf_range(4.6, d - 1.0)
		var m := MeshInstance3D.new()
		var c := CylinderMesh.new()
		c.top_radius = rng.randf_range(0.16, 0.2)
		c.bottom_radius = c.top_radius
		c.height = rng.randf_range(1.0, 1.3)
		m.mesh = c
		m.position = Vector3(cos(ang) * r, 0.25, sin(ang) * r)
		m.material_override = _mat([Color(0.06, 0.06, 0.07), Color(0.5, 0.06, 0.06), Color(0.08, 0.15, 0.45)][rng.randi() % 3], 0.6)
		stage.add_child(m)
		made.append(m)


static func _box(stage: Node3D, size: Vector3, pos: Vector3, yaw: float, col: Color, rough: float) -> Node:
	var m := MeshInstance3D.new()
	m.mesh = BoxMesh.new()
	(m.mesh as BoxMesh).size = size
	m.position = pos
	m.rotation.y = yaw
	m.material_override = _mat(col, rough)
	stage.add_child(m)
	return m


static func _mat(col: Color, rough: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = col
	m.roughness = rough
	return m


## Boxer i in this clip's kit: vest, trunks, gloves.
static func dress(stage: Node3D, i: int, kit: Dictionary) -> void:
	var body: Node3D = stage.boxers[i]["node"]
	MH.colour_trunks(body, _col(kit["trunks"]), stage.CLOTH_ROUGHNESS)
	FighterKit.colour_vest(body, _col(kit["vest"]), stage.CLOTH_ROUGHNESS)
	FighterKit.cloth_normals(body)
	var gl: Node = stage.boxers[i]["gloves"]
	for side in gl.gloves:
		for mi in (gl.gloves[side] as Node).find_children("*", "MeshInstance3D", true, false):
			var mat := (mi as MeshInstance3D).material_override as ShaderMaterial
			if mat != null:
				mat.set_shader_parameter("colour", _col(kit["gloves"]))


## Every frame, before the stage moves: where an outside lens stands and looks. The tv lens is the game's own.
static func camera(stage: Node3D, p: Dictionary, st: Dictionary, t: float, dt: float) -> void:
	var cam: Dictionary = p["camera"]
	var mode := str(cam["mode"])
	if mode == "tv":
		return
	var ang := deg_to_rad(float(cam["angle_deg"]))
	var pos := Vector3(cos(ang), 0.0, sin(ang)) * float(cam["dist"]) + Vector3(0, float(cam["h"]), 0)
	var look: Vector3 = st["look"]
	if mode == "phone":
		var mid: Vector3 = ((stage.boxers[0]["pos"] as Vector3) + (stage.boxers[1]["pos"] as Vector3)) * 0.5
		mid.y = float(cam["look_h"])
		look = look.lerp(mid, 1.0 - exp(-dt / float(cam["lag_s"])))
		st["look"] = look
		var k := float(cam["shake"])
		# A hand: slow drift plus a faster tremble, a few centimetres and a fraction of a degree.
		pos += Vector3(sin(t * 1.3) + 0.5 * sin(t * 3.1 + 1.0), sin(t * 1.7 + 2.0) + 0.4 * sin(t * 4.3), sin(t * 1.1 + 0.5)) * 0.012 * k
		look += Vector3(sin(t * 2.3 + 0.7) + 0.5 * sin(t * 5.9), sin(t * 1.9 + 1.4) + 0.5 * sin(t * 6.7 + 0.3), 0.0) * 0.02 * k
	stage.camera.film(pos, look, float(cam["fov"]), 0.0)
	(stage.camera.attributes as CameraAttributesPractical).dof_blur_far_enabled = false
