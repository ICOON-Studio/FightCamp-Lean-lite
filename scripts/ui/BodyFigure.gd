extends Control
## Front-view body figure that tints six places by BodyMap band and flashes on hit.
## Pure _draw() Control; no preloads except BodyMap. Design space 90 x 150, scaled to fit size.

const BM := preload("res://scripts/rules/BodyMap.gd")

const DESIGN_W := 90.0
const DESIGN_H := 150.0
const FLASH_S := 0.35

const BAND_COLOURS := {
	"fine": Color("#6cc27a"),
	"hurt": Color("#f0a020"),
	"critical": Color("#e0503c"),
	"doctor": Color("#a050e0"),
}

const FILL := Color(0.18, 0.18, 0.2)
const OUTLINE := Color(1, 1, 1, 0.35)

const NAMES := {
	"head": "Head", "left_eye": "Left eye", "right_eye": "Right eye",
	"nose": "Nose", "left_ribs": "Left ribs", "right_ribs": "Right ribs",
}

# Front view: boxer's LEFT is on the VIEWER'S RIGHT (as when you face a person).
# So left_eye centre.x > right_eye centre.x, and same for ribs.
var _values := {}
var _flash := {}
var _punches := {}
var _sc := 1.0
var _off := Vector2.ZERO


func _ready() -> void:
	custom_minimum_size = Vector2(DESIGN_W, DESIGN_H)
	mouse_filter = MOUSE_FILTER_PASS
	for p in BM.PLACES:
		_values[p] = 100.0
		_flash[p] = 0.0
		_punches[p] = []


## Recompute the design -> screen transform from current size.
func _update_xform() -> void:
	_sc = minf(size.x / DESIGN_W, size.y / DESIGN_H)
	_off = Vector2((size.x - DESIGN_W * _sc) * 0.5, (size.y - DESIGN_H * _sc) * 0.5)


## Map a design-space point to local pixels.
func _s(d: Vector2) -> Vector2:
	return d * _sc + _off


func _draw() -> void:
	_update_xform()

	# Body silhouette fill.
	var body := PackedVector2Array([
		_s(Vector2(37, 36)), _s(Vector2(15, 44)), _s(Vector2(23, 75)),
		_s(Vector2(25, 92)), _s(Vector2(65, 92)), _s(Vector2(67, 75)),
		_s(Vector2(75, 44)), _s(Vector2(53, 36)),
	])
	draw_polygon(body, PackedColorArray([FILL]))
	# Arms (upper, hanging at sides).
	draw_polygon(PackedVector2Array([
		_s(Vector2(12, 46)), _s(Vector2(18, 46)), _s(Vector2(17, 80)), _s(Vector2(11, 80)),
	]), PackedColorArray([FILL]))
	draw_polygon(PackedVector2Array([
		_s(Vector2(72, 46)), _s(Vector2(78, 46)), _s(Vector2(79, 80)), _s(Vector2(73, 80)),
	]), PackedColorArray([FILL]))
	# Legs (down to hips).
	draw_polygon(PackedVector2Array([
		_s(Vector2(27, 92)), _s(Vector2(43, 92)), _s(Vector2(43, 137)), _s(Vector2(27, 137)),
	]), PackedColorArray([FILL]))
	draw_polygon(PackedVector2Array([
		_s(Vector2(47, 92)), _s(Vector2(63, 92)), _s(Vector2(63, 137)), _s(Vector2(47, 137)),
	]), PackedColorArray([FILL]))
	# Head.
	draw_circle(_s(Vector2(45, 22)), 14.0 * _sc, FILL)

	# Region overlays.
	for p in BM.PLACES:
		var v: float = _values.get(p, 100.0)
		var b: String = BM.band(v)
		var bc: Color = BAND_COLOURS[b]
		var fa: float = _flash.get(p, 0.0)
		var col: Color = _flash_colour(bc, fa)
		_draw_place(p, col)

	# Body outline on top.
	draw_polyline(body, OUTLINE, 1.5)
	draw_arc(_s(Vector2(45, 22)), 14.0 * _sc, 0, TAU, 32, OUTLINE, 1.5)


func _draw_place(place: String, col: Color) -> void:
	match place:
		"head":
			draw_circle(_s(Vector2(45, 22)), 14.0 * _sc, Color(col.r, col.g, col.b, 0.45))
		"left_eye":
			draw_circle(_s(Vector2(53, 20)), 3.5 * _sc, col)
		"right_eye":
			draw_circle(_s(Vector2(37, 20)), 3.5 * _sc, col)
		"nose":
			draw_circle(_s(Vector2(45, 27)), 2.5 * _sc, col)
		"left_ribs":
			_rect(_s(Vector2(49, 58)), 14.0 * _sc, 18.0 * _sc, 4.0 * _sc, col)
		"right_ribs":
			_rect(_s(Vector2(27, 58)), 14.0 * _sc, 18.0 * _sc, 4.0 * _sc, col)


func _rect(tl: Vector2, w: float, h: float, r: float, col: Color) -> void:
	var pts := PackedVector2Array([
		tl + Vector2(r, 0), tl + Vector2(w - r, 0),
		tl + Vector2(w, r), tl + Vector2(w, h - r),
		tl + Vector2(w - r, h), tl + Vector2(r, h),
		tl + Vector2(0, h - r), tl + Vector2(0, r),
	])
	draw_polygon(pts, PackedColorArray([col]))


func _flash_colour(base: Color, alpha: float) -> Color:
	if alpha <= 0.0:
		return base
	return base.lerp(Color.WHITE, alpha)


## Set place -> 0..100 (missing places = 100).
func set_values(values: Dictionary) -> void:
	for p in BM.PLACES:
		_values[p] = float(values.get(p, 100.0))
	queue_redraw()


## Flash that place white, fading over FLASH_S. Remember the punch (keep last 3 per place, newest first).
func hit(place: String, punch: String) -> void:
	_flash[place] = 1.0
	var arr: Array = _punches.get(place, [])
	arr.push_front(punch)
	if arr.size() > 3:
		arr.resize(3)
	_punches[place] = arr
	queue_redraw()


## The colour that place is drawn in now (band colour, flash blended in).
func colour_of(place: String) -> Color:
	var v: float = _values.get(place, 100.0)
	var b: String = BM.band(v)
	return _flash_colour(BAND_COLOURS[b], _flash.get(place, 0.0))


## e.g. "Nose 62 (hurt) - cross, jab, jab"; with no punches: "Nose 100 (fine)".
func tip_of(place: String) -> String:
	var v: float = _values.get(place, 100.0)
	var b: String = BM.band(v)
	var t: String = "%s %d (%s)" % [NAMES.get(place, place), int(v), b]
	var arr: Array = _punches.get(place, [])
	if arr.is_empty():
		return t
	var parts: PackedStringArray = []
	for p in arr:
		parts.append(str(p))
	return t + " - " + ", ".join(parts)


## Which place a point (in local pixels) is on, "" if none.
## When regions overlap (eyes/nose inside the head circle), the smaller (more specific) wins.
func place_at(local_pos: Vector2) -> String:
	_update_xform()
	var d: Vector2 = (local_pos - _off) / _sc
	var best := ""
	var best_r := 999.0
	for p in BM.PLACES:
		var g: Dictionary = _place_geom(p)
		var c: Vector2 = g["centre"]
		var r: float = g["radius"]
		if d.distance_to(c) <= r and r < best_r:
			best = p
			best_r = r
	return best


func _get_tooltip(at_position: Vector2) -> String:
	var p: String = place_at(at_position)
	if p == "":
		return ""
	tooltip_text = tip_of(p)
	return tooltip_text


## Exposed for tests: design-space centre of a place, mapped to local pixels.
func centre_of(place: String) -> Vector2:
	_update_xform()
	var g: Dictionary = _place_geom(place)
	var c: Vector2 = g["centre"]
	return c * _sc + _off


func _place_geom(place: String) -> Dictionary:
	match place:
		"head":
			return {"centre": Vector2(45, 22), "radius": 14.0}
		"left_eye":
			return {"centre": Vector2(53, 20), "radius": 3.5}
		"right_eye":
			return {"centre": Vector2(37, 20), "radius": 3.5}
		"nose":
			return {"centre": Vector2(45, 27), "radius": 2.5}
		"left_ribs":
			return {"centre": Vector2(56, 67), "radius": 11.0}
		"right_ribs":
			return {"centre": Vector2(34, 67), "radius": 11.0}
	return {"centre": Vector2.ZERO, "radius": 0.0}


func _process(delta: float) -> void:
	var any := false
	for p in BM.PLACES:
		var fa: float = _flash.get(p, 0.0)
		if fa > 0.0:
			fa -= delta / FLASH_S
			if fa < 0.0:
				fa = 0.0
			_flash[p] = fa
			any = true
	if any:
		queue_redraw()
