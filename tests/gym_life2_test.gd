extends SceneTree
## S435 the gym picture: the shadow strip's joins, a walk that follows the route's bends,
## and a placed person who does not stand under a hub button.

const MAIN := preload("res://scenes/Main.tscn")
const Floor := preload("res://scripts/ui/GymFloorPeople.gd")
const Spots := preload("res://scripts/rules/GymFloorSpots.gd")
const People := preload("res://scripts/rules/GymPeople.gd")
const Bonus := preload("res://scripts/rules/GymBonus.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const ART := "res://assets/ui/art/hub_sprites"
const DT := 0.05
const LIMIT := 0.10
## The slip and the pull share a pose (gap about 0.005). No owned frame is within 0.10 of both a slip
## pose and a jab pose, so a jab join cannot reach 0.10. 0.80 is just above the closest pairs (0.682, 0.779)
## and still fails the previous strip (1.27 and above).
const JAB_JOIN := 0.80

var failures := 0


func _initialize() -> void:
	if OS.get_cmdline_user_args().has("stills"):
		await _stills()
		quit(0)
		return
	_shadow()
	await _page()
	print("GYM_LIFE2 failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _shadow() -> void:
	var strips: Array = []
	for fn in DirAccess.get_files_at(ART):
		var name := str(fn)
		if name.ends_with("_shadow.png"):
			strips.append(name)
	strips.sort()
	_check(strips.size() >= 12, "shadow strips baked (%d)" % strips.size())
	var worst := 0.0
	for name in strips:
		var png := ART.path_join(str(name))
		var tex := load(png) as Texture2D
		_check(tex != null and tex.get_width() == 96 * 16 and tex.get_height() == 128, "%s is 16 frames at 96 x 128" % name)
		var side := png.trim_suffix(".png") + ".json"
		_check(FileAccess.file_exists(side), "%s has join data" % name)
		if not FileAccess.file_exists(side):
			continue
		var data = JSON.parse_string(FileAccess.get_file_as_string(side))
		_check(data is Dictionary and (data as Dictionary).has("joins"), "%s join data is a table" % name)
		if not (data is Dictionary):
			continue
		var joins: Array = (data as Dictionary).get("joins", [])
		_check(joins.size() == 3, "%s has three joins (%d)" % [name, joins.size()])
		for join in joins:
			var gap := float(join.get("gap", 99.0))
			var src := str(join.get("from", ""))
			var dst := str(join.get("to", ""))
			var cap := JAB_JOIN if src == "jab" or dst == "jab" else LIMIT
			worst = maxf(worst, gap)
			_check(gap <= cap, "%s join %s@%.3f -> %s@%.3f gap %.3f" % [name, src, float(join.get("from_t", 0.0)), dst, float(join.get("to_t", 0.0)), gap])
			_check(gap < float(join.get("before", 0.0)), "%s join %s -> %s is tighter than the old cut" % [name, src, dst])
	print("SHADOW worst_gap=%.3f strips=%d" % [worst, strips.size()])


func _page() -> void:
	var main := MAIN.instantiate()
	root.add_child(main)
	await process_frame
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	main.act("quick")
	await process_frame
	await process_frame
	var hub := main.find_child("GymHub", true, false) as Control
	var floor = hub.find_child("GymFloorPeople", true, false) if hub != null else null
	_check(hub != null and floor != null, "the home screen builds the floor")
	if floor == null:
		main.free()
		return
	_walk(floor, main.career)
	_buttons(floor, hub, main.career)
	main.free()


func _walk(floor, c: Career) -> void:
	var saved: Array = c.gym_slots.duplicate(true)
	var corner: Vector2 = floor._corner
	var k: float = floor._k
	c.gym_slots = []
	floor.setup(c, _stems(c))
	floor.lay(corner, k)
	var plan: Dictionary = Bonus.plan(c.gym_plan)
	var ids: Array = []
	for s in floor.spots:
		var tile: Vector2i = floor._tile(str(s["id"]), plan)
		if tile.x > -100:
			ids.append(str(s["id"]))
	var bent: Array = []
	var straight: Array = []
	for a in ids:
		for b in ids:
			if a == b:
				continue
			var route: Array = People.route(plan, floor._tile(a, plan), floor._tile(b, plan))
			if route.size() < 2:
				continue
			var row := [a, b, route]
			if _bends(route) > 0:
				bent.append(row)
			else:
				straight.append(row)
	var rng := RandomNumberGenerator.new()
	rng.seed = 435
	for i in bent.size():
		var j := rng.randi_range(i, bent.size() - 1)
		var swap = bent[i]
		bent[i] = bent[j]
		bent[j] = swap
	_check(bent.size() >= 40, "forty routes with a bend (%d)" % bent.size())
	_check(not straight.is_empty(), "a route with no bend exists")
	var worst := 0.0
	for i in mini(40, bent.size()):
		worst = maxf(worst, _one_walk(floor, plan, bent[i]))
	var control := 0.0 if straight.is_empty() else _one_walk(floor, plan, straight[0])
	print("WALK bent_worst=%.2f control=%.2f bent_pairs=%d straight_pairs=%d" % [worst, control, bent.size(), straight.size()])
	_check(worst <= 6.0, "a bent walk stays within 6 px of the route (worst %.2f)" % worst)
	_check(control <= 6.0, "a straight walk stays within 6 px (%.2f)" % control)
	c.gym_slots = saved
	floor.setup(c, _stems(c))
	floor.lay(corner, k)


func _one_walk(floor, plan: Dictionary, row: Array) -> float:
	var a := str(row[0])
	var b := str(row[1])
	var route: Array = row[2]
	var start: Vector2 = floor._spot(a)["at"]
	var end: Vector2 = floor._spot(b)["at"]
	var poly: Array = Spots.route_px(route, start, end)
	var p := {"stem": "mh_boxer_01", "who": "walker", "id": a, "kind": str(floor._spot(a)["kind"]), "at": start, "clock": 0.0, "alpha": 1.0, "phase": "walk", "dest": b, "path": floor._route_px(a, b), "clip": "walk", "fade": 0.0}
	floor._face(p)
	var seen: Array = [p["at"]]
	var guard := 0
	while str(p["phase"]) == "walk" and guard < 4000:
		floor._step_walk(p, DT)
		seen.append(p["at"])
		guard += 1
	var off := 0.0
	for at in seen:
		off = maxf(off, _poly(at, poly))
	var reached: bool = str(p["phase"]) == "hold" and str(p["id"]) == b and (p["at"] as Vector2).distance_to(end) <= 1.0
	_check(reached, "walker %s -> %s reaches the end spot" % [a, b])
	return off if reached else 999.0


func _buttons(floor, hub: Control, c: Career) -> void:
	var buttons: Array = []
	for node in hub.get_children():
		if str(node.name).begins_with("Place_"):
			var box := node as Control
			buttons.append(Rect2(box.position, box.size))
	_check(buttons.size() == 7, "seven hub buttons (%d)" % buttons.size())
	var stems: Array = _stems(c)
	var worst := 0.0
	var worst_at := ""
	for seed in 200:
		floor.salt = seed
		floor.setup(c, stems)
		for p in floor.people:
			var body := _body(floor, p["at"])
			for button in buttons:
				var hit := _frac(body, button)
				if hit > worst:
					worst = hit
					worst_at = "%s@%s seed %d" % [p["who"], p["id"], seed]
	print("BUTTON worst=%.4f at %s people=%d" % [worst, worst_at, floor.people.size()])
	_check(worst <= LIMIT, "placed people overlap a button by at most 10 percent (worst %.1f percent, %s)" % [worst * 100.0, worst_at])
	floor.salt = 0


func _stems(c: Career) -> Array:
	var stems: Array = []
	for f in c.fighters:
		stems.append(Faces.stem(f))
	return stems


func _body(floor, at: Vector2) -> Rect2:
	var sc: float = floor._fig_h(at.y) / Floor.FH
	return Rect2(floor._corner + at * floor._k - Floor.FEET * sc, Vector2(Floor.FW, Floor.FH) * sc)


func _frac(a: Rect2, b: Rect2) -> float:
	var hit := a.intersection(b)
	if hit.size.x <= 0.0 or hit.size.y <= 0.0 or a.get_area() <= 0.0:
		return 0.0
	return hit.get_area() / a.get_area()


func _poly(pt: Vector2, poly: Array) -> float:
	var best := 999999.0
	if poly.size() == 1:
		return pt.distance_to(poly[0])
	for i in range(1, poly.size()):
		best = minf(best, _seg(pt, poly[i - 1], poly[i]))
	return best


func _seg(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab := b - a
	var den := ab.length_squared()
	if den < 0.0001:
		return p.distance_to(a)
	var t := clampf((p - a).dot(ab) / den, 0.0, 1.0)
	return p.distance_to(a + ab * t)


func _bends(route: Array) -> int:
	var n := 0
	for i in range(1, route.size() - 1):
		var d0: Vector2i = route[i] - route[i - 1]
		var d1: Vector2i = route[i + 1] - route[i]
		if d0 != d1:
			n += 1
	return n


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)


const STILLS := "res://docs/mockups/s435/gymlife2"


func _stills() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(STILLS))
	var main := MAIN.instantiate()
	root.add_child(main)
	await process_frame
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	main.act("quick")
	main.career.guide = ""
	main.render()
	await process_frame
	await process_frame
	var hub := main.find_child("GymHub", true, false) as Control
	var floor = hub.find_child("GymFloorPeople", true, false)
	await _shot(floor, "gym_0s")
	await _wait(5.0)
	floor.set_process(false)
	_send_to_bend(floor)
	await _shot(floor, "gym_5s")
	floor.set_process(true)
	await _wait(5.0)
	await _shot(floor, "gym_10s")


func _shot(floor, name: String) -> void:
	floor.queue_redraw()
	for _i in 8:
		await process_frame
	await RenderingServer.frame_post_draw
	var path := ProjectSettings.globalize_path(STILLS.path_join(name + ".png"))
	root.get_texture().get_image().save_png(path)
	print("STILL %s" % path)
	for p in floor.people:
		var clip := str(p["clip"])
		var frame := int(float(p["clock"]) * float(Floor.FPS.get(clip, 8.0))) % 16
		var body := _body(floor, p["at"])
		print("PERSON still=%s id=%s spot=%s clip=%s frame=%d rect=(%.1f,%.1f,%.1f,%.1f)" % [name, p["who"], p["id"], clip, frame, body.position.x, body.position.y, body.size.x, body.size.y])


func _wait(seconds: float) -> void:
	var start := Time.get_ticks_msec()
	while float(Time.get_ticks_msec() - start) / 1000.0 < seconds:
		await process_frame


func _send_to_bend(floor) -> void:
	var plan: Dictionary = Bonus.plan(floor._career.gym_plan)
	var ids: Array = []
	for s in floor.spots:
		if floor._tile(str(s["id"]), plan).x > -100:
			ids.append(str(s["id"]))
	for p in floor.people:
		if str(p["phase"]) != "hold":
			continue
		for dest in ids:
			if dest == str(p["id"]):
				continue
			var route: Array = People.route(plan, floor._tile(str(p["id"]), plan), floor._tile(dest, plan))
			if _bends(route) < 1:
				continue
			var path: Array = floor._route_px(str(p["id"]), str(dest))
			if path.size() < 3:
				continue
			var corner := _bend_px(route, path)
			p["dest"] = str(dest)
			p["path"] = path
			p["phase"] = "walk"
			p["alpha"] = 1.0
			floor._face(p)
			var guard := 0
			while str(p["phase"]) == "walk" and guard < 3000:
				var dist := (p["at"] as Vector2).distance_to(corner)
				if dist <= 8.0:
					break
				floor._step_walk(p, DT)
				guard += 1
			print("BEND id=%s spot=%s dest=%s px=%.1f phase=%s" % [p["who"], p["id"], dest, (p["at"] as Vector2).distance_to(corner), p["phase"]])
			return


func _bend_px(route: Array, path: Array) -> Vector2:
	for i in range(1, route.size() - 1):
		var d0: Vector2i = route[i] - route[i - 1]
		var d1: Vector2i = route[i + 1] - route[i]
		if d0 != d1 and i < path.size():
			return path[i]
	return path[1]
