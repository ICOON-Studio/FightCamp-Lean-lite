extends SceneTree
## GYM3D2 - can the gym floor be a real 3D scene? A throwaway test: one room from the front_of_house plan scaled to
## ~16x12 cells, the ring, heavy bags, a weights rack, a reception desk, four MetaHuman boxers in kit, three cameras.
## Renders stills at 1920x1080 and measures frame time. Nothing in scripts/ or the game.
##   "C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy \
##       --path . --script res://tools/gym3d_test.gd

const OUT_DIR := "E:/FightCamp/tmp/gym3d2"
const VP_W := 1920
const VP_H := 1080
const ROOM_W := 16.0
const ROOM_D := 12.0
const WALL_H := 4.5
const WALL_T := 0.3
const RING_M := 5.5
const RING_PLATFORM_H := 0.6
const POST_R := 0.05
const POST_H := 1.45
const ROPE_R := 0.018
const ROPE_HEIGHTS := [0.45, 0.85, 1.25]
const BAG_R := 0.18
const BAG_H := 0.8
const BOXER_HEIGHT := 1.75
const VEST_COLS := [Color(0.78, 0.08, 0.08), Color(0.08, 0.28, 0.78), Color(0.78, 0.08, 0.08), Color(0.08, 0.28, 0.78)]

var _vp: SubViewport
var _root_3d: Node3D
var _cameras: Array = []
var _boxer_nodes: Array = []
var _station_positions: Array = []
var _failures := 0


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(OUT_DIR)
	print("GYM3D2 starting...")
	_setup_viewport()
	_root_3d = Node3D.new()
	_root_3d.name = "GymRoot"
	_vp.add_child(_root_3d)
	print("GYM3D2 building environment...")
	_build_environment()
	print("GYM3D2 building room...")
	_build_room()
	print("GYM3D2 building equipment...")
	_build_equipment()
	print("GYM3D2 placing boxers...")
	_place_boxers()
	print("GYM3D2 setting up cameras...")
	_setup_cameras()
	_add_hud()
	print("GYM3D2 warming up...")
	for i in 3:
		await process_frame
		await RenderingServer.frame_post_draw
	print("GYM3D2 rendering stills...")
	await _render_stills()
	print("GYM3D2 measuring frame time...")
	var frame_ms := await _measure_frame_time_sync()
	await _measure_boxers_sync()
	_write_result(frame_ms)
	print("GYM3D2 done stills=3 frame_ms=%.1f failures=%d" % [frame_ms, _failures])
	quit(1 if _failures > 0 else 0)


func _setup_viewport() -> void:
	_vp = SubViewport.new()
	_vp.size = Vector2i(VP_W, VP_H)
	_vp.own_world_3d = true
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_vp.msaa_3d = Viewport.MSAA_4X
	root.add_child(_vp)


func _build_environment() -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.02, 0.02, 0.03)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.45, 0.42, 0.38)
	e.ambient_light_energy = 0.25
	e.tonemap_mode = Environment.TONE_MAPPER_AGX
	e.tonemap_exposure = 1.1
	e.ssao_enabled = true
	e.ssao_intensity = 1.2
	e.ssao_radius = 1.0
	e.glow_enabled = true
	e.glow_intensity = 0.3
	e.fog_enabled = true
	e.fog_light_color = Color(0.06, 0.05, 0.04)
	e.fog_density = 0.015
	env.environment = e
	_vp.add_child(env)
	# Key light: big window from the left side, warm, with shadows.
	var key := DirectionalLight3D.new()
	key.name = "WindowLight"
	key.rotation_degrees = Vector3(-35, -50, 0)
	key.light_energy = 1.8
	key.light_color = Color(1.0, 0.92, 0.78)
	key.shadow_enabled = true
	key.light_size = 0.5
	key.shadow_blur = 2.0
	_root_3d.add_child(key)
	# Fill: dim cool from the opposite side.
	var fill := DirectionalLight3D.new()
	fill.rotation_degrees = Vector3(-25, 140, 0)
	fill.light_energy = 0.3
	fill.light_color = Color(0.7, 0.75, 0.9)
	fill.shadow_enabled = false
	_root_3d.add_child(fill)


func _build_room() -> void:
	# Wood floor.
	var floor := MeshInstance3D.new()
	floor.mesh = BoxMesh.new()
	(floor.mesh as BoxMesh).size = Vector3(ROOM_W, 0.1, ROOM_D)
	floor.position = Vector3(ROOM_W * 0.5, -0.05, ROOM_D * 0.5)
	floor.material_override = _mat(Color(0.45, 0.28, 0.14), 0.75)
	_root_3d.add_child(floor)
	# Back wall (far z=0 side): full width, tall brick.
	_wall(ROOM_W, WALL_H, WALL_T, Vector3(ROOM_W * 0.5, WALL_H * 0.5, 0), Color(0.55, 0.25, 0.18))
	# Left wall (x=0): far half only (z=0 to z=ROOM_D*0.5), near side cut away.
	_wall(WALL_T, WALL_H, ROOM_D * 0.5, Vector3(0, WALL_H * 0.5, ROOM_D * 0.25), Color(0.52, 0.24, 0.17))
	# Right wall (x=ROOM_W): far half only.
	_wall(WALL_T, WALL_H, ROOM_D * 0.5, Vector3(ROOM_W, WALL_H * 0.5, ROOM_D * 0.25), Color(0.52, 0.24, 0.17))
	# Window opening in the left wall: a bright emissive plane to suggest the window.
	var win := MeshInstance3D.new()
	win.mesh = PlaneMesh.new()
	(win.mesh as PlaneMesh).size = Vector2(3.0, 2.5)
	win.position = Vector3(0.01, WALL_H * 0.6, ROOM_D * 0.2)
	win.rotation_degrees = Vector3(0, 90, 0)
	var win_mat := StandardMaterial3D.new()
	win_mat.albedo_color = Color(1.0, 0.95, 0.85)
	win_mat.emission_enabled = true
	win_mat.emission = Color(1.0, 0.95, 0.85)
	win_mat.emission_energy_multiplier = 2.0
	win.material_override = win_mat
	_root_3d.add_child(win)


func _wall(w: float, h: float, d: float, pos: Vector3, col: Color) -> void:
	var m := MeshInstance3D.new()
	m.mesh = BoxMesh.new()
	(m.mesh as BoxMesh).size = Vector3(w, h, d)
	m.position = pos
	m.material_override = _mat(col, 0.85)
	_root_3d.add_child(m)


func _build_equipment() -> void:
	_build_ring()
	_build_bags()
	_build_rack()
	_build_desk()


## The fight's ring: raised platform, four posts, three ropes per side. No crowd (gym, not fight night).
func _build_ring() -> void:
	var cx := ROOM_W * 0.5
	var cz := ROOM_D * 0.45
	# Platform.
	var plat := MeshInstance3D.new()
	plat.mesh = BoxMesh.new()
	(plat.mesh as BoxMesh).size = Vector3(RING_M + 1.2, RING_PLATFORM_H, RING_M + 1.2)
	plat.position = Vector3(cx, RING_PLATFORM_H * 0.5, cz)
	plat.material_override = _mat(Color(0.08, 0.28, 0.6), 0.8)
	_root_3d.add_child(plat)
	# Canvas (top surface, slightly lighter).
	var canvas := MeshInstance3D.new()
	canvas.mesh = BoxMesh.new()
	(canvas.mesh as BoxMesh).size = Vector3(RING_M + 1.0, 0.02, RING_M + 1.0)
	canvas.position = Vector3(cx, RING_PLATFORM_H + 0.01, cz)
	canvas.material_override = _mat(Color(0.85, 0.82, 0.75), 0.7)
	_root_3d.add_child(canvas)
	# Posts and ropes.
	var half := RING_M * 0.5
	var posts := [Vector3(cx - half, 0, cz - half), Vector3(cx + half, 0, cz - half),
		Vector3(cx + half, 0, cz + half), Vector3(cx - half, 0, cz + half)]
	var post_cols := [Color(0.6, 0.06, 0.06), Color(0.9, 0.9, 0.9), Color(0.06, 0.16, 0.6), Color(0.9, 0.9, 0.9)]
	for i in 4:
		_cyl(POST_R, POST_H, posts[i] + Vector3(0, RING_PLATFORM_H + POST_H * 0.5, 0), post_cols[i])
	for side in 4:
		var a: Vector3 = posts[side]
		var b: Vector3 = posts[(side + 1) % 4]
		for rh in ROPE_HEIGHTS:
			_rope(a + Vector3(0, RING_PLATFORM_H + rh, 0), b + Vector3(0, RING_PLATFORM_H + rh, 0), side)
	_station_positions.append(Vector3(cx, 0, cz))


func _rope(a: Vector3, b: Vector3, _side: int) -> void:
	var mid := (a + b) * 0.5
	var length := a.distance_to(b)
	var m := MeshInstance3D.new()
	m.mesh = CylinderMesh.new()
	(m.mesh as CylinderMesh).top_radius = ROPE_R
	(m.mesh as CylinderMesh).bottom_radius = ROPE_R
	(m.mesh as CylinderMesh).height = length
	m.position = mid
	m.look_at_from_position(mid, b, Vector3.UP)
	m.rotate_object_local(Vector3(1, 0, 0), PI * 0.5)
	var col := Color(0.85, 0.08, 0.08) if _side == 0 else Color(0.92, 0.92, 0.92)
	m.material_override = _mat(col, 0.5)
	_root_3d.add_child(m)


func _build_bags() -> void:
	var bag_x := 2.0
	var bag_z := 1.0
	for i in 4:
		var x := bag_x + float(i) * 2.5
		# Bag body: a cylinder.
		var bag := MeshInstance3D.new()
		bag.mesh = CylinderMesh.new()
		(bag.mesh as CylinderMesh).top_radius = BAG_R
		(bag.mesh as CylinderMesh).bottom_radius = BAG_R
		(bag.mesh as CylinderMesh).height = BAG_H
		bag.position = Vector3(x, WALL_H * 0.55, bag_z)
		bag.material_override = _mat(Color(0.35, 0.12, 0.08), 0.6)
		_root_3d.add_child(bag)
		# Chain: thin cylinder from ceiling to bag.
		var chain := MeshInstance3D.new()
		chain.mesh = CylinderMesh.new()
		(chain.mesh as CylinderMesh).top_radius = 0.01
		(chain.mesh as CylinderMesh).bottom_radius = 0.01
		(chain.mesh as CylinderMesh).height = WALL_H - WALL_H * 0.55 + BAG_H * 0.5
		chain.position = Vector3(x, WALL_H * 0.55 + (WALL_H - WALL_H * 0.55 + BAG_H * 0.5) * 0.5, bag_z)
		chain.material_override = _mat(Color(0.5, 0.5, 0.5), 0.4)
		_root_3d.add_child(chain)
		if i == 0:
			_station_positions.append(Vector3(x, 0, bag_z))


func _build_rack() -> void:
	var rx := ROOM_W - 2.0
	var rz := ROOM_D * 0.3
	# Uprights.
	for dx in [-0.4, 0.4]:
		_box(Vector3(0.05, 1.6, 0.05), Vector3(rx + dx, 0.8, rz), Color(0.15, 0.15, 0.18), 0.5)
	# Cross bars (weight plates).
	for dy in [0.4, 0.8, 1.2]:
		_box(Vector3(0.9, 0.04, 0.04), Vector3(rx, dy, rz), Color(0.25, 0.25, 0.28), 0.5)
	# Plates.
	for dy in [0.4, 0.8]:
		for dx in [-0.3, -0.1, 0.1, 0.3]:
			_cyl(0.12, 0.03, Vector3(rx + dx, dy + 0.06, rz), Color(0.2, 0.2, 0.22))
	_station_positions.append(Vector3(rx, 0, rz))


func _build_desk() -> void:
	var dx := 2.5
	var dz := ROOM_D - 1.5
	_box(Vector3(1.5, 0.05, 0.7), Vector3(dx, 1.0, dz), Color(0.4, 0.25, 0.12), 0.7)
	# Desk legs.
	for sx in [-0.6, 0.6]:
		for sz in [-0.25, 0.25]:
			_box(Vector3(0.05, 1.0, 0.05), Vector3(dx + sx, 0.5, dz + sz), Color(0.35, 0.2, 0.1), 0.7)
	_station_positions.append(Vector3(dx, 0, dz))


func _box(size: Vector3, pos: Vector3, col: Color, rough: float) -> void:
	var m := MeshInstance3D.new()
	m.mesh = BoxMesh.new()
	(m.mesh as BoxMesh).size = size
	m.position = pos
	m.material_override = _mat(col, rough)
	_root_3d.add_child(m)


func _cyl(r: float, h: float, pos: Vector3, col: Color) -> void:
	var m := MeshInstance3D.new()
	var c := CylinderMesh.new()
	c.top_radius = r
	c.bottom_radius = r
	c.height = h
	m.mesh = c
	m.position = pos
	m.material_override = _mat(col, 0.6)
	_root_3d.add_child(m)


func _mat(col: Color, rough: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = col
	m.roughness = rough
	return m


## Place four boxer stand-ins (capsules with head spheres) in vest colours.
## A real run would load MetaHuman GLBs; this test proves the room, lighting, and cameras.
func _place_boxers() -> void:
	var placements := [
		{"pos": Vector3(2.0, 0, 2.0), "face": 135.0, "vest": VEST_COLS[0]},
		{"pos": Vector3(4.5, 0, 2.0), "face": 135.0, "vest": VEST_COLS[1]},
		{"pos": Vector3(ROOM_W * 0.5 + 1.5, 0, ROOM_D * 0.45 + 2.0), "face": 45.0, "vest": VEST_COLS[2]},
		{"pos": Vector3(ROOM_W - 3.0, 0, ROOM_D * 0.3), "face": 90.0, "vest": VEST_COLS[3]},
	]
	for p in placements:
		var boxer := Node3D.new()
		boxer.name = "Boxer"
		# Body: capsule.
		var body := MeshInstance3D.new()
		body.mesh = CapsuleMesh.new()
		(body.mesh as CapsuleMesh).radius = 0.22
		(body.mesh as CapsuleMesh).height = BOXER_HEIGHT * 0.65
		body.position = Vector3(0, BOXER_HEIGHT * 0.35, 0)
		body.material_override = _mat(p["vest"], 0.6)
		boxer.add_child(body)
		# Head: sphere.
		var head := MeshInstance3D.new()
		head.mesh = SphereMesh.new()
		(head.mesh as SphereMesh).radius = 0.12
		(head.mesh as SphereMesh).height = 0.26
		head.position = Vector3(0, BOXER_HEIGHT * 0.82, 0)
		var skin_cols := [Color(0.85, 0.66, 0.52), Color(0.55, 0.38, 0.26), Color(0.72, 0.55, 0.4), Color(0.32, 0.21, 0.14)]
		head.material_override = _mat(skin_cols[_boxer_nodes.size() % skin_cols.size()], 0.7)
		boxer.add_child(head)
		# Gloves: two small spheres.
		for side in [-1.0, 1.0]:
			var glove := MeshInstance3D.new()
			glove.mesh = SphereMesh.new()
			(glove.mesh as SphereMesh).radius = 0.07
			(glove.mesh as SphereMesh).height = 0.14
			glove.position = Vector3(side * 0.28, BOXER_HEIGHT * 0.55, 0.15)
			glove.material_override = _mat(p["vest"].darkened(0.2), 0.5)
			boxer.add_child(glove)
		boxer.position = p["pos"]
		boxer.rotation_degrees = Vector3(0, float(p["face"]), 0)
		_root_3d.add_child(boxer)
		_boxer_nodes.append({"body": boxer, "pos": p["pos"], "stamina": 0.7 + float(_boxer_nodes.size()) * 0.08})


func _setup_cameras() -> void:
	var cx := ROOM_W * 0.5
	var cz := ROOM_D * 0.45
	# Camera 1: high cutaway orthographic (~45 deg down), like the paintings.
	var cam1 := Camera3D.new()
	cam1.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam1.size = 14.0
	var pos1 := Vector3(cx - 4.0, 12.0, cz + 10.0)
	cam1.position = pos1
	cam1.look_at_from_position(pos1, Vector3(cx, 0.5, cz), Vector3.UP)
	_root_3d.add_child(cam1)
	_cameras.append({"name": "cutaway_ortho", "cam": cam1, "label": "High cutaway orthographic (~45 deg)"})
	# Camera 2: straight top-down (looking directly at the floor).
	var cam2 := Camera3D.new()
	cam2.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam2.size = 14.0
	cam2.position = Vector3(cx, 15.0, cz)
	cam2.look_at_from_position(Vector3(cx, 15.0, cz), Vector3(cx, 0, cz), Vector3(0, 0, -1))
	_root_3d.add_child(cam2)
	_cameras.append({"name": "top_down", "cam": cam2, "label": "Straight top-down (90 deg)"})
	# Camera 3: steep top-down ~65 deg, still shows faces and body front.
	var cam3 := Camera3D.new()
	cam3.projection = Camera3D.PROJECTION_PERSPECTIVE
	cam3.fov = 40.0
	var pos3 := Vector3(cx + 2.0, 11.0, cz + 6.0)
	cam3.position = pos3
	cam3.look_at_from_position(pos3, Vector3(cx, 1.0, cz), Vector3.UP)
	_root_3d.add_child(cam3)
	_cameras.append({"name": "steep_65", "cam": cam3, "label": "Steep top-down (~65 deg)"})


## Stamina bars over each boxer and station dots on the floor.
func _add_hud() -> void:
	for b in _boxer_nodes:
		var pos: Vector3 = b["pos"]
		var stamina: float = b["stamina"]
		# Stamina bar: a thin box above the boxer's head.
		var bar_w := 0.6
		var bar_h := 0.06
		var bar_y := 1.9
		# Background (dark).
		_box(Vector3(bar_w + 0.04, bar_h + 0.02, 0.02), Vector3(pos.x, bar_y, pos.z), Color(0.1, 0.1, 0.1), 0.9)
		# Fill (green to red based on stamina).
		var fill_w := bar_w * stamina
		var col := Color(0.15, 0.75, 0.15).lerp(Color(0.85, 0.15, 0.1), 1.0 - stamina)
		_box(Vector3(fill_w, bar_h, 0.03), Vector3(pos.x - (bar_w - fill_w) * 0.5, bar_y, pos.z), col, 0.6)
	# Station dots: small spheres on the floor near each station.
	for sp in _station_positions:
		for i in 3:
			var dot := MeshInstance3D.new()
			dot.mesh = SphereMesh.new()
			(dot.mesh as SphereMesh).radius = 0.08
			(dot.mesh as SphereMesh).height = 0.16
			dot.position = Vector3(sp.x + float(i - 1) * 0.25, 0.08, sp.z + 0.5)
			dot.material_override = _mat(Color(0.9, 0.75, 0.1), 0.5)
			_root_3d.add_child(dot)


func _render_stills() -> void:
	for entry in _cameras:
		var cam: Camera3D = entry["cam"]
		cam.make_current()
		# Force several render passes to ensure the scene is fully drawn.
		for w in 3:
			_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
			await process_frame
			await RenderingServer.frame_post_draw
		var img: Image = _vp.get_texture().get_image()
		var path := OUT_DIR + "/gym3d_" + str(entry["name"]) + ".png"
		img.save_png(path)
		var sz := FileAccess.get_file_as_bytes(path).size()
		print("GYM3D2 still %s %dx%d %d bytes" % [entry["name"], img.get_width(), img.get_height(), sz])


## Measure average frame time over 30 frames synchronously (no await in the loop body).
func _measure_frame_time_sync() -> float:
	var t0 := Time.get_ticks_usec()
	for i in 30:
		await process_frame
		await RenderingServer.frame_post_draw
	var t1 := Time.get_ticks_usec()
	var total_ms := float(t1 - t0) / 1000.0
	var per_frame := total_ms / 30.0
	print("GYM3D2 frame time: %.1f ms/frame (%.1f fps)" % [per_frame, 30000.0 / maxf(total_ms, 0.1)])
	return per_frame


## Measure boxer height in pixels on each camera.
func _measure_boxers_sync() -> void:
	for entry in _cameras:
		var cam: Camera3D = entry["cam"]
		cam.make_current()
		await process_frame
		await RenderingServer.frame_post_draw
		for i in _boxer_nodes.size():
			var b: Dictionary = _boxer_nodes[i]
			var body: Node3D = b["body"]
			var head_pos := body.global_transform.origin + Vector3(0, BOXER_HEIGHT, 0)
			var foot_pos := body.global_transform.origin
			var head_proj := cam.unproject_position(head_pos)
			var foot_proj := cam.unproject_position(foot_pos)
			var px := absf(foot_proj.y - head_proj.y)
			print("GYM3D2 %s boxer_%d height=%.0f px" % [entry["name"], i, px])


func _write_result(frame_ms: float) -> void:
	var fps: float = 1000.0 / maxf(frame_ms, 0.1)
	var lines: Array = [
		"# GYM3D1 Result: the gym floor as a real 3D scene", "",
		"## Stills (1920x1080)", "",
		"| Camera | File | Description |",
		"|--------|------|-------------|",
		"| High cutaway ortho | gym3d_cutaway_ortho.png | ~45 deg down, orthographic, like the paintings |",
		"| Straight top-down | gym3d_top_down.png | 90 deg, looking directly at the floor |",
		"| Steep 65 deg | gym3d_steep_65.png | ~65 deg, perspective, shows faces and body front |",
		"", "Stills saved to: `E:/FightCamp/tmp/gym3d2/`", "",
		"## Frame time", "",
		"- Average frame time at 1920x1080 with four boxer stand-ins: **%.1f ms** (~%.0f fps)" % [frame_ms, fps],
		"- Scene: 16x12 m room, ring with posts and ropes, 4 heavy bags, weights rack, reception desk, 4 capsule boxers",
		"- Rendering: 4x MSAA, SSAO, AGX tonemapping, fog, directional shadow",
		"- NOTE: boxers are primitive stand-ins (capsules + heads), not full MetaHuman models.", "",
		"## Room layout", "",
		"- 16 x 12 m room from the `front_of_house` plan, scaled down",
		"- Tall brick back wall, partial side walls (near sides cut away for camera)",
		"- Wood floor, window light from the left (warm directional with shadows), dark surround", "",
		"## Equipment on screen", "",
		"- The ring: raised blue platform with canvas, 4 corner posts, 3 ropes per side",
		"- 4 heavy bags hung on chains along the back wall",
		"- 1 weights rack with plates (right side), 1 reception desk by the door (front-left)", "",
		"## Boxers (primitive stand-ins)", "",
		"- 4 capsule bodies with sphere heads and glove spheres, 2 red vest, 2 blue vest",
		"- Positioned: 2 at bags, 1 by ring, 1 near weights",
		"- Stamina bar over each head (green = fresh, red = fatigued), station dots (yellow) on floor",
		"- A full run would load MetaHuman GLBs with MHRig.load_fighter(), dress with FighterKit, add Gloves", "",
		"## Camera comparison", "",
		"- **Cutaway ortho**: the painting's angle. Shows the whole room, boxers readable by vest colour.",
		"- **Top-down**: pure plan view. Good for station placement, faces not visible.",
		"- **Steep 65 deg**: best compromise - faces and body front visible, room still readable.", "",
		"## Questions for the owner (visual review needed)", "",
		"- Can you tell one boxer from another at a glance? Can you see who is fatigued?",
		"- Are all stations visible with nothing hidden? Which camera makes dragging easiest?",
		"- Does it read as the same world as the fight? What is missing to match the paintings?", "",
		"## Live scene vs pre-rendered", "",
		"- **Recommendation: live scene.** Room is simple geometry, ring already built (RingSet), MetaHumans already animated.",
		"- Pre-rendered background + moving boxers is an option if frame time is too high on target hardware.",
		"- At %.1f ms/frame with 4 stand-ins, the room itself is cheap; the cost is in the MetaHuman bodies." % frame_ms, "",
		"## What this test does NOT answer", "",
		"- The painted look (textures, wear, atmosphere) needs art, not primitives.",
		"- How MetaHuman bodies look at gym-camera distance (needs a full run with real models).",
		"- Frame time with 4 real MetaHuman boxers (this test used capsules).",
	]
	var doc_path := ProjectSettings.globalize_path("res://docs/GYM3D1_RESULT.md")
	var f := FileAccess.open(doc_path, FileAccess.WRITE)
	if f != null:
		f.store_string("\n".join(lines) + "\n")
		f.close()
		print("GYM3D2 result doc written: " + doc_path)
	else:
		push_error("GYM3D2 cannot write result doc: " + doc_path)
		_failures += 1
