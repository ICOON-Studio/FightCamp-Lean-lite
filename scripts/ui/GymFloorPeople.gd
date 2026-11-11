extends Control
## S416 boxers on the gym picture. Takes no clicks. S429 fighters stand at today's station; strips from GymWorkouts.
## A new spot walks GymPeople.route when one exists (two walkers at most), otherwise the figure fades.
const GymPeople := preload("res://scripts/rules/GymPeople.gd")
const GymWorkouts := preload("res://scripts/rules/GymWorkouts.gd")
const GymFloorSpots := preload("res://scripts/rules/GymFloorSpots.gd")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const ART := "res://assets/ui/art/hub_sprites/%s_%s.png"
const FW := 96.0
const FH := 128.0
const FEET := Vector2(48.0, 107.0)
const FPS := {"walk": 16.0, "walk_back": 16.0, "jab_back": 16.0, "bag_combo": 12.0, "bag_body": 12.0, "bag_upper": 12.0, "shadow": 12.0, "guard_move": 8.0, "stretch": 8.0, "rest_drink": 8.0, "rest_talk": 8.0, "idle_back": 10.0, "idle": 10.0, "stand": 8.0}
const FRAMES := 16
const FADE := 0.3
const GAP := Vector2(6.0, 14.0)
const WALK_PX := 160.0
const MORE := ["mh_boxer_02", "mh_boxer_10", "mh_boxer_12", "mh_boxer_14", "mh_boxer_15", "mh_boxer_18", "mh_boxer_20"]
var people: Array = []
var spots: Array = []
var _career: Career
var _rng := RandomNumberGenerator.new()
var _tex := {}
var _corner := Vector2.ZERO
var _k := 0.0
var _wait := 0.0
var _minute := 0.0
var _stems: Array = []
var _pins: Array = []
var salt := 0
func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_arm()
	queue_redraw()
func setup(c: Career, stems: Array) -> void:
	_career = c
	_stems = stems.duplicate()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_minute = 0.0
	_place(stems)
	_arm()
	queue_redraw()
func lay(corner: Vector2, k: float) -> void:
	_corner = corner
	_k = k
	if _blocked_now():
		_place(_stems)
	queue_redraw()
func _arm() -> void:
	set_process(not MenuFx.instant and not people.is_empty())
func _place(stems: Array) -> void:
	spots = _read()
	_pins = GymFloorSpots.pin_rects(self, _corner, _k)
	var crowd: Array = GymPeople.crowd(_career.members, stems, _career.premises)
	var n: int = mini(crowd.size(), spots.size())
	_rng.seed = _seed()
	people = []
	var used := {}
	var indoors := {}
	for row in GymWorkouts.fighters_today(_career.fighters, _career.day):
		if people.size() >= n:
			break
		if indoors.has(str(row["stem"])):
			continue
		var spot := _free_kind(str(row["kind"]), used)
		if spot.is_empty():
			continue
		used[str(spot["id"])] = true
		indoors[str(row["stem"])] = true
		people.append(_person(str(row["stem"]), str(row["id"]), spot))
	var outside := {}
	for f in _career.fighters:
		var stem := Faces.stem(f)
		if not indoors.has(stem):
			outside[stem] = true
	var pool: Array = []
	for src in [crowd, GymPeople.MEMBER_STEMS, MORE]:
		for s in src:
			if people.size() + pool.size() >= n:
				break
			var stem := str(s)
			if not outside.has(stem) and not indoors.has(stem) and not pool.has(stem):
				pool.append(stem)
	var open: Array = []
	for i in spots.size():
		if not used.has(str(spots[i]["id"])) and _stands(spots[i]["at"]):
			open.append(i)
	var picked := _shuffle(open, pool.size())
	for i in picked.size():
		people.append(_person(str(pool[i]), str(pool[i]), spots[int(picked[i])]))
	_wait = 2.0
func _person(stem: String, who: String, spot: Dictionary) -> Dictionary:
	var kind := str(spot["kind"])
	return {"stem": stem, "who": who, "id": str(spot["id"]), "kind": kind, "at": spot["at"], "clock": _rng.randf_range(0.0, 2.0), "alpha": 1.0, "phase": "hold", "dest": "", "path": [], "clip": GymWorkouts.pick(kind, who, 0.0), "fade": 0.0}
func _seed() -> int:
	var text := ",".join(PackedStringArray(GymSlots.owned(_career.gym_slots, _career.day)))
	var h := hash(text if salt == 0 else "%s#%d" % [text, salt])
	return 1 if h == 0 else h
func _read() -> Array:
	return [] if _career == null else GymFloorSpots.spots(_career.gym_slots, _career.day)
func _free_kind(kind: String, used: Dictionary) -> Dictionary:
	for s in spots:
		if str(s["kind"]) == kind and not used.has(str(s["id"])) and _stands(s["at"]):
			return s
	return {}
func _shuffle(idx: Array, n: int) -> Array:
	var copy := idx.duplicate()
	for i in copy.size():
		var j: int = _rng.randi_range(i, copy.size() - 1)
		var swap = copy[i]
		copy[i] = copy[j]
		copy[j] = swap
	return copy.slice(0, mini(n, copy.size()))
func _process(delta: float) -> void:
	_minute += delta / 60.0
	for p in people:
		p["clock"] = float(p["clock"]) + delta
		var phase := str(p["phase"])
		if phase == "walk":
			_step_walk(p, delta)
		elif phase == "out" or phase == "in":
			_fade_one(p, delta)
		else:
			p["clip"] = GymWorkouts.pick(str(p["kind"]), str(p["who"]), _minute)
	if _count(["out", "in"]) == 0 and _count(["walk"]) < 2:
		_wait -= delta
		if _wait <= 0.0:
			_begin()
	queue_redraw()
func _begin() -> void:
	_wait = _rng.randf_range(GAP.x, GAP.y)
	if _career == null or people.is_empty():
		return
	spots = _read()
	var hold: Array = []
	for i in people.size():
		if str(people[i]["phase"]) == "hold":
			hold.append(i)
	if hold.is_empty():
		return
	var free := _open_ids()
	if free.is_empty():
		return
	var p: Dictionary = people[int(hold[_rng.randi_range(0, hold.size() - 1)])]
	var fade_to := ""
	for dest in _shuffle(free, free.size()):
		var path := _route_px(str(p["id"]), str(dest))
		if path.size() >= 2 and _count(["walk"]) < 2:
			p["dest"] = str(dest)
			p["path"] = path
			p["phase"] = "walk"
			p["alpha"] = 1.0
			_face(p)
			return
		if fade_to == "":
			fade_to = str(dest)
	if fade_to == "":
		return
	p["dest"] = fade_to
	p["phase"] = "out"
	p["fade"] = 0.0
func _open_ids() -> Array:
	var taken := {}
	for p in people:
		taken[str(p["id"])] = true
		if str(p["dest"]) != "":
			taken[str(p["dest"])] = true
	var free: Array = []
	for s in spots:
		if not taken.has(str(s["id"])) and _stands(s["at"]):
			free.append(str(s["id"]))
	return free
func _count(phases: Array) -> int:
	var n := 0
	for p in people:
		if phases.has(str(p["phase"])):
			n += 1
	return n
func _fade_one(p: Dictionary, delta: float) -> void:
	p["fade"] = float(p["fade"]) + delta
	var t: float = clampf(float(p["fade"]) / FADE, 0.0, 1.0)
	if str(p["phase"]) == "out":
		p["alpha"] = 1.0 - t
		if float(p["fade"]) >= FADE:
			_sit(p, "in", 0.0)
		return
	p["alpha"] = t
	if float(p["fade"]) >= FADE:
		p["alpha"] = 1.0
		p["phase"] = "hold"
		p["dest"] = ""
		p["fade"] = 0.0
func _step_walk(p: Dictionary, dt: float) -> void:
	var path: Array = p["path"]
	var left := dt
	while left > 0.0 and path.size() >= 2:
		var a: Vector2 = path[0]
		var b: Vector2 = path[1]
		var need := maxf(a.distance_to(b), 0.001) / WALK_PX
		if left >= need:
			left -= need
			path.pop_front()
			_face(p)
		else:
			path[0] = a.lerp(b, left / need)
			left = 0.0
	if path.size() < 2:
		_sit(p, "hold", 1.0)
	else:
		p["at"] = path[0]
func _sit(p: Dictionary, phase: String, alpha: float) -> void:
	var spot := _spot(str(p["dest"]))
	p["path"] = []
	p["clock"] = 0.0
	p["fade"] = 0.0
	p["phase"] = phase
	p["alpha"] = alpha
	if phase == "hold":
		p["dest"] = ""
	if spot.is_empty():
		p["phase"] = "hold"
		p["dest"] = ""
		p["alpha"] = 1.0
		return
	p["id"] = str(spot["id"])
	p["kind"] = str(spot["kind"])
	p["at"] = spot["at"]
	p["clip"] = GymWorkouts.pick(str(p["kind"]), str(p["who"]), _minute)
func _face(p: Dictionary) -> void:
	var path: Array = p["path"]
	if path.size() < 2:
		return
	var d: Vector2 = (path[1] as Vector2) - (path[0] as Vector2)
	p["clip"] = "walk_back" if d.y < 0.0 else "walk"
func _route_px(from_id: String, to_id: String) -> Array:
	if _career == null:
		return []
	var plan: Dictionary = GymBonus.plan(_career.gym_plan)
	var a := _tile(from_id, plan)
	var b := _tile(to_id, plan)
	if a.x < -100 or b.x < -100:
		return []
	var route: Array = GymPeople.route(plan, a, b)
	if route.size() < 2:
		return []
	return GymFloorSpots.route_px(route, _spot(from_id)["at"], _spot(to_id)["at"])
func _tile(spot_id: String, plan: Dictionary) -> Vector2i:
	return GymFloorSpots.plan_tile(spot_id, str(_spot(spot_id).get("kind", "")), plan)
func _stands(at) -> bool:
	return not GymFloorSpots.covered(at, _corner, _k, _pins)
func _blocked_now() -> bool:
	_pins = GymFloorSpots.pin_rects(self, _corner, _k)
	for p in people:
		if not _stands(p["at"]):
			return true
	return false
func _spot(id: String) -> Dictionary:
	for s in spots:
		if str(s["id"]) == id:
			return s
	return {}
func _draw() -> void:
	if people.is_empty() or _k <= 0.0:
		return
	var order: Array = people.duplicate()
	order.sort_custom(func(a, b): return (a["at"] as Vector2).y < (b["at"] as Vector2).y)
	for p in order:
		_blit(p)
	draw_set_transform(Vector2.ZERO)
func _blit(p: Dictionary) -> void:
	var clip := str(p["clip"])
	if not FPS.has(clip):
		return
	var tex: Texture2D = _strip(str(p["stem"]), clip)
	if tex == null:
		return
	var frame: int = int(float(p["clock"]) * float(FPS[clip])) % FRAMES
	var feet: Vector2 = p["at"]
	var sc: float = _fig_h(feet.y) / FH
	draw_set_transform(_corner + feet * _k, 0.0, Vector2(sc, sc))
	draw_texture_rect_region(tex, Rect2(-FEET, Vector2(FW, FH)), Rect2(float(frame) * FW, 0.0, FW, FH), Color(1, 1, 1, float(p["alpha"])))
func _fig_h(y: float) -> float:
	return GymFloorSpots.fig_h(y, _k)
func _strip(stem: String, clip: String) -> Texture2D:
	var key := stem + clip
	if not _tex.has(key):
		var path := ART % [stem, clip]
		_tex[key] = load(path) if ResourceLoader.exists(path) else null
	return _tex[key]
