extends Control
## S409 our real boxers as small moving figures on the gym floor (strips from tools/bake_hub_sprites.gd). Each stands at a
## piece of equipment, works for a while, then walks to another by GymPeople's route. Decoration: takes no clicks.
##   var f := HubFigures.new(); f.setup(iso, plan, stems, seed)   f.step(dt)   f.people -> [{tile: Vector2, walking: bool, ...}]

const GymPeople := preload("res://scripts/rules/GymPeople.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")

const ART := "res://assets/ui/art/hub_sprites/%s_%s.png"
const FW := 96.0
const FH := 128.0
const FEET := Vector2(48.0, 107.0)   # where the floor is in a frame
## The strips are 58 px a metre, the floor about 45 at scale 1; a little over life size so a small figure reads.
const SIZE := 0.9
const FPS := {"walk": 16.0, "walk_back": 16.0, "jab_back": 16.0, "idle_back": 10.0, "idle": 10.0, "stand": 8.0}
const FRAMES := 16
const WALK_TILES_S := 1.3
const WAIT_S := Vector2(4.0, 11.0)
const OTHER := {"jab_back": "idle_back", "idle_back": "jab_back"}   # at a bag: punches, then a breather

var people: Array = []
var _iso: Control
var _plan: Dictionary = {}
var _spots: Array = []
var _rng := RandomNumberGenerator.new()
var _tex := {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(not MenuFx.instant and not people.is_empty())


func setup(iso: Control, plan: Dictionary, stems: Array, seed_value: int) -> void:
	_iso = iso
	_plan = plan
	_rng.seed = seed_value
	_spots = GymPeople.spots(plan)
	_spots.sort_custom(func(a, b): return _key(a) < _key(b))
	people = []
	for i in mini(stems.size(), _spots.size()):
		if not ResourceLoader.exists(ART % [stems[i], "walk"]):
			continue
		var s: Dictionary = _spots[i]
		people.append({"stem": stems[i], "tile": Vector2(s["at"]), "spot": i, "path": [], "walking": false, "along": 0.0,
			"clip": str(s["act"]), "flip": bool(s["flip"]), "clock": _rng.randf_range(0.0, 2.0), "wait": _rng.randf_range(WAIT_S.x, WAIT_S.y)})


func _key(s: Dictionary) -> int:
	var at: Vector2i = s["at"]
	return hash([at.x, at.y, int(_rng.seed)])


func _process(delta: float) -> void:
	step(delta)
	queue_redraw()


## Move everyone on by dt seconds.
func step(dt: float) -> void:
	for p in people:
		p["clock"] = float(p["clock"]) + dt
		if bool(p["walking"]):
			_walk(p, dt)
		else:
			_work(p, dt)


func _work(p: Dictionary, dt: float) -> void:
	p["wait"] = float(p["wait"]) - dt
	var clip := str(p["clip"])
	if OTHER.has(clip) and float(p["clock"]) * float(FPS[clip]) >= float(FRAMES) * 2.0:
		p["clip"] = OTHER[clip]
		p["clock"] = 0.0
	if float(p["wait"]) > 0.0:
		return
	var free: Array = []
	for i in _spots.size():
		if i != int(p["spot"]) and not _taken(i):
			free.append(i)
	if free.is_empty():
		p["wait"] = WAIT_S.x
		return
	var to: int = free[_rng.randi_range(0, free.size() - 1)]
	var path := GymPeople.route(_plan, Vector2i(p["tile"]), _spots[to]["at"])
	if path.size() < 2:
		p["wait"] = WAIT_S.x
		return
	p["spot"] = to
	p["path"] = path
	p["along"] = 0.0
	p["walking"] = true
	_face(p)


func _taken(i: int) -> bool:
	for p in people:
		if int(p["spot"]) == i:
			return true
	return false


func _walk(p: Dictionary, dt: float) -> void:
	p["along"] = float(p["along"]) + dt * WALK_TILES_S
	var path: Array = p["path"]
	while float(p["along"]) >= 1.0 and path.size() >= 2:
		p["along"] = float(p["along"]) - 1.0
		path.pop_front()
		if path.size() >= 2:
			_face(p)
	if path.size() < 2:
		var s: Dictionary = _spots[int(p["spot"])]
		p["tile"] = Vector2(s["at"])
		p["walking"] = false
		p["clip"] = str(s["act"])
		p["flip"] = bool(s["flip"])
		p["clock"] = 0.0
		p["wait"] = _rng.randf_range(WAIT_S.x, WAIT_S.y)
		return
	p["tile"] = Vector2(path[0]).lerp(Vector2(path[1]), float(p["along"]))


## Two views, each mirrored, make the four ways across an isometric floor.
func _face(p: Dictionary) -> void:
	var path: Array = p["path"]
	var d: Vector2i = path[1] - path[0]
	p["clip"] = "walk" if d.x > 0 or d.y > 0 else "walk_back"
	p["flip"] = d.x != 0 if d.x > 0 else d.y < 0


func _draw() -> void:
	if _iso == null or people.is_empty():
		return
	var order := people.duplicate()
	order.sort_custom(func(a, b): return (a["tile"] as Vector2).x + (a["tile"] as Vector2).y < (b["tile"] as Vector2).x + (b["tile"] as Vector2).y)
	var k: float = SIZE * float(_iso._scale)
	for p in order:
		var clip := str(p["clip"])
		var tex := _strip(str(p["stem"]), clip)
		if tex == null:
			continue
		var frame := int(float(p["clock"]) * float(FPS[clip])) % FRAMES
		var at: Vector2 = _iso.tile((p["tile"] as Vector2) + Vector2(0.5, 0.5))
		draw_set_transform(at, 0.0, Vector2(-k if bool(p["flip"]) else k, k))
		draw_texture_rect_region(tex, Rect2(-FEET, Vector2(FW, FH)), Rect2(float(frame) * FW, 0.0, FW, FH))
	draw_set_transform(Vector2.ZERO)


func _strip(stem: String, clip: String) -> Texture2D:
	var key := stem + clip
	if not _tex.has(key):
		var path := ART % [stem, clip]
		_tex[key] = load(path) if ResourceLoader.exists(path) else null
	return _tex[key]
