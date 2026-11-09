extends Control
## S416 the club's boxers on the gym picture, one to a piece of kit. Takes no clicks.
## A redraw keeps the same people on the same spots: the pick is a hash of the owned ids.
## Every 8 to 16 seconds one person fades out and fades in on a free spot. Nobody walks.
##   var f := GymFloorPeople.new(); f.setup(career, stems); f.lay(corner, k)

const GymPeople := preload("res://scripts/rules/GymPeople.gd")
const GymFloorSpots := preload("res://scripts/rules/GymFloorSpots.gd")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")

const ART := "res://assets/ui/art/hub_sprites/%s_%s.png"
const FW := 96.0
const FH := 128.0
const FEET := Vector2(48.0, 107.0)   # where the floor is in a frame
const FPS := {"walk": 16.0, "walk_back": 16.0, "jab_back": 16.0, "idle_back": 10.0, "idle": 10.0, "stand": 8.0}
const FRAMES := 16
const FADE := 0.3
const GAP := Vector2(8.0, 16.0)

var people: Array = []
var spots: Array = []
var _career: Career
var _rng := RandomNumberGenerator.new()
var _tex := {}
var _corner := Vector2.ZERO
var _k := 0.0
var _mover: Dictionary = {}
var _wait := 0.0


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_arm()
	queue_redraw()


## Build from the career's day now. The day is not stored: a later read asks the career again.
func setup(c: Career, stems: Array) -> void:
	_career = c
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mover = {}
	_place(stems)
	_arm()
	queue_redraw()


## The same picture transform the pieces use: screen = corner + picture pixel * k.
func lay(corner: Vector2, k: float) -> void:
	_corner = corner
	_k = k
	queue_redraw()


func _arm() -> void:
	set_process(not MenuFx.instant and not people.is_empty())


func _place(stems: Array) -> void:
	spots = _read()
	var crowd: Array = GymPeople.crowd(_career.members, stems, _career.premises)
	var n: int = mini(crowd.size(), spots.size())
	_rng.seed = _seed()
	var picked: Array = _pick(spots.size(), n)
	people = []
	for i in n:
		var s: Dictionary = spots[int(picked[i])]
		people.append({"stem": str(crowd[i]), "id": str(s["id"]), "job": str(s["job"]), "at": s["at"],
			"clock": _rng.randf_range(0.0, 2.0), "alpha": 1.0, "phase": "hold"})
	_wait = _rng.randf_range(GAP.x, GAP.y)


## Owned ids, in order. The same floor always picks the same spots.
func _seed() -> int:
	var text := ""
	for id in GymSlots.owned(_career.gym_slots, _career.day):
		text += str(id)
		text += ","
	var h: int = hash(text)
	return 1 if h == 0 else h


func _read() -> Array:
	if _career == null:
		return []
	return GymFloorSpots.spots(_career.gym_slots, _career.day)


func _pick(count: int, n: int) -> Array:
	var idx: Array = []
	for i in count:
		idx.append(i)
	for i in idx.size():
		var j: int = _rng.randi_range(i, idx.size() - 1)
		var swap: int = int(idx[i])
		idx[i] = idx[j]
		idx[j] = swap
	var out: Array = []
	for i in n:
		out.append(int(idx[i]))
	return out


func _process(delta: float) -> void:
	for p in people:
		p["clock"] = float(p["clock"]) + delta
	if _mover.is_empty():
		_wait -= delta
		if _wait <= 0.0:
			_begin()
	else:
		_fade(delta)
	queue_redraw()


func _begin() -> void:
	if _career == null or people.is_empty():
		_wait = GAP.x
		return
	spots = _read()
	var who: int = _rng.randi_range(0, people.size() - 1)
	var free: Array = _free()
	if free.is_empty():
		_wait = GAP.x
		return
	_mover = people[who]
	_mover["phase"] = "out"
	_mover["fade"] = 0.0
	_mover["dest"] = str(free[_rng.randi_range(0, free.size() - 1)])


## Spots nobody is standing on. The person who is about to move still holds theirs.
func _free() -> Array:
	var taken := {}
	for p in people:
		taken[str(p["id"])] = true
	var free: Array = []
	for s in spots:
		var id := str(s["id"])
		if not taken.has(id):
			free.append(id)
	return free


func _fade(delta: float) -> void:
	_mover["fade"] = float(_mover["fade"]) + delta
	var t: float = clampf(float(_mover["fade"]) / FADE, 0.0, 1.0)
	if str(_mover["phase"]) == "out":
		_mover["alpha"] = 1.0 - t
		if float(_mover["fade"]) >= FADE:
			_land()
		return
	_mover["alpha"] = t
	if float(_mover["fade"]) >= FADE:
		_mover["alpha"] = 1.0
		_mover["phase"] = "hold"
		_mover = {}
		_wait = _rng.randf_range(GAP.x, GAP.y)


func _land() -> void:
	var dest := str(_mover.get("dest", ""))
	var spot: Dictionary = {}
	for s in spots:
		if str(s["id"]) == dest:
			spot = s
			break
	if spot.is_empty():
		_mover["alpha"] = 1.0
		_mover["phase"] = "hold"
		_mover = {}
		_wait = GAP.x
		return
	_mover["id"] = dest
	_mover["job"] = str(spot["job"])
	_mover["at"] = spot["at"]
	_mover["clock"] = 0.0
	_mover["alpha"] = 0.0
	_mover["phase"] = "in"
	_mover["fade"] = 0.0


func _draw() -> void:
	if people.is_empty() or _k <= 0.0:
		return
	var order: Array = people.duplicate()
	order.sort_custom(func(a, b): return (a["at"] as Vector2).y < (b["at"] as Vector2).y)
	for p in order:
		_blit(p)
	draw_set_transform(Vector2.ZERO)


func _blit(p: Dictionary) -> void:
	var clip := str(p["job"])
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


## 20% of the picture height on screen at the bottom edge, 15% at 40% down, linear in y.
## The same y is the same height, so a row of figures matches.
func _fig_h(y: float) -> float:
	var picture_h: float = GymFloorSpots.PICTURE.y * _k
	var t: float = y / GymFloorSpots.PICTURE.y
	return lerpf(0.15, 0.20, (t - 0.40) / 0.60) * picture_h


func _strip(stem: String, clip: String) -> Texture2D:
	var key := stem + clip
	if not _tex.has(key):
		var path := ART % [stem, clip]
		_tex[key] = load(path) if ResourceLoader.exists(path) else null
	return _tex[key]
