extends Control
## Front-view body figure that tints six places by BodyMap band and flashes on hit.
## Pure _draw() Control; no preloads except BodyMap. Design space 90 x 150, scaled to fit size.
## S320 (operator C146: "we have real andropoid,use it"): with a portrait (set_portrait / portrait_for) it draws the
## boxer's own baked front picture (tools/bake_body_portraits.gd) and the places where they sit on her body.

const BM := preload("res://scripts/rules/BodyMap.gd")
const BodyTrack := preload("res://scripts/rules/BodyTrack.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")

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
var _tex: Texture2D = null
var _anchors := {}   # place -> [x, y, rx, ry] as fractions of the portrait
const PORTRAITS := "res://assets/ui/body"
## The body is dimmed a little so the places' colours read on top of it.
const BODY_TINT := Color(0.7, 0.7, 0.74)
## S323 "the body is the track" step 3 (Q-S294-38 "Build it"): BodyLoad's Burn per part painted on her own body like tyre
## temperatures (BodyTrack colours), the baked strokes in the portrait's json "track". With a track the hurt places are
## drawn as outlines only (a hurt place rings in its BodyMap colour, a fine one is not drawn) so the two never mix.
var _track := {}     # body place (BodyTrack.body_place) -> Burn 0..100
var _pulse := {}     # body place -> 0..1, a part that just went up a band
const PULSE_S := 0.8
const TRACK_ALPHA := 0.82
## S324 (operator C149: "look like a human stop doing cube things as limbs"): with a baked part mask
## (tools/bake_body_masks.gd) her OWN body pixels take each part's Burn colour, her shading kept; the strokes are only the
## fallback for a portrait without a mask. Index i in the mask (value i * 32) = MASK_KEYS[i - 1].
const MASK_KEYS := ["core", "left_shoulder", "right_shoulder", "left_arm", "right_arm", "legs"]
const TINT_ALPHA := 0.86
## S332 the places that redden her own skin when hurt (the first place is where the spot sits): her face, each rib side.
const SPOTS := [["head", "left_eye", "right_eye", "nose"], ["left_ribs"], ["right_ribs"]]
const SPOT_ALPHA := {"fine": 0.0, "hurt": 0.45, "critical": 0.6, "doctor": 0.7}
const SPOT_GROW := 1.1
const FRESH_START := 12.5   # Burn up to this = untinted ...
const FRESH_END := 30.0     # ... fully coloured from here (warm)
const SKIN_SHADER := preload("res://scripts/ui/body_skin.gdshader")   # her body coloured by part mask + hurt spots
var _mask: Texture2D = null
var _skin: TextureRect = null
var layers_for_paint: Array = []   # S334 BodyTurn: [{skin, uv, anchors}] while she turns


## {"tex", "anchors"} for a boxer's body (her glb path) in her corner's colours; {} when it was never baked.
static func portrait_for(glb: String, corner: String) -> Dictionary:
	var stem := glb.get_file().get_basename()
	var png := PORTRAITS.path_join("%s_%s.png" % [stem, corner])
	var js := PORTRAITS.path_join(stem + ".json")
	if stem == "" or not ResourceLoader.exists(png) or not FileAccess.file_exists(js):
		return {}
	var anchors = JSON.parse_string(FileAccess.get_file_as_string(js))
	if not anchors is Dictionary:
		return {}
	var mask := PORTRAITS.path_join(stem + "_mask.png")
	return {"tex": load(png), "anchors": anchors, "mask": load(mask) if ResourceLoader.exists(mask) else null}


## Draw this picture instead of the drawn figure ({} keeps the drawn one).
func set_portrait(p: Dictionary) -> void:
	_tex = p.get("tex") as Texture2D
	_anchors = p.get("anchors", {})
	_mask = p.get("mask") as Texture2D
	if _tex != null and _mask != null:
		_build_skin()
	elif _skin != null:
		_skin.queue_free()
		_skin = null
	queue_redraw()


## Her body as a child drawn BEHIND this control's own drawing, coloured by the mask shader (parts + hurt SPOTS).
func _build_skin() -> void:
	if _skin == null:
		_skin = TextureRect.new()
		_skin.name = "Skin"
		_skin.show_behind_parent = true
		_skin.mouse_filter = MOUSE_FILTER_IGNORE
		_skin.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_skin.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		_skin.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
		var mat := ShaderMaterial.new()
		mat.shader = SKIN_SHADER
		_skin.material = mat
		add_child(_skin)
	_skin.texture = _tex
	(_skin.material as ShaderMaterial).set_shader_parameter("mask", _mask)
	_paint_skin()


## The shader's colour per mask part: its Burn colour (a fresh pulse whitens it), alpha 0 = her own colours.
func _paint_skin() -> void:
	if _skin == null:
		return
	var cols: Array[Color] = [Color(0, 0, 0, 0)]
	for key in MASK_KEYS:
		if not _track.has(key):
			cols.append(Color(0, 0, 0, 0))
			continue
		# A fresh part is her own skin and kit; the colour rises in as the part works (blue-for-fresh read as "a blue
		# statue" in the S324 still - both corners looked the same).
		var burn: float = float(_track[key])
		var pu: float = float(_pulse.get(key, 0.0))
		var col := BodyTrack.colour(maxf(burn, FRESH_END + 5.0)).lerp(Color.WHITE, 0.5 * pu)
		col.a = TINT_ALPHA * clampf((burn - FRESH_START) / (FRESH_END - FRESH_START), 0.0, 1.0)
		cols.append(col)
	# S332 (operator C151 on the hit ring over her face: "wtf is that"): a hurt or just-hit face or rib side reddens her
	# own skin, soft-edged, instead of a ring drawn over her.
	var spots: Array[Color] = []
	for group in SPOTS:
		spots.append(spot_colour(group))
	# S334 a turning body (BodyTurn) has two skins, each on its own frame of the strip: uv = that frame's part of it.
	var layers: Array = layers_for_paint if not layers_for_paint.is_empty() else [{"skin": _skin, "uv": Rect2(0, 0, 1, 1), "anchors": _anchors}]
	for l in layers:
		var uv: Rect2 = l["uv"]
		var boxes: Array[Vector4] = []
		for group in SPOTS:
			var a: Array = (l["anchors"] as Dictionary).get(group[0], [])
			boxes.append(Vector4(uv.position.x + float(a[0]) * uv.size.x, uv.position.y + float(a[1]) * uv.size.y,
				float(a[2]) * SPOT_GROW * uv.size.x, float(a[3]) * SPOT_GROW * uv.size.y) if a.size() >= 4 else Vector4.ZERO)
		var mat := (l["skin"] as TextureRect).material as ShaderMaterial
		mat.set_shader_parameter("part_col", cols)
		mat.set_shader_parameter("spot_box", boxes)
		mat.set_shader_parameter("spot_col", spots)


## The worst band among the group's places in its colour, clear when fine; a fresh hit warms it red for FLASH_S.
func spot_colour(group: Array) -> Color:
	var worst := 100.0
	var fl := 0.0
	for p in group:
		worst = minf(worst, float(_values.get(p, 100.0)))
		fl = maxf(fl, float(_flash.get(p, 0.0)))
	var b: String = BM.band(worst)
	var col: Color = BAND_COLOURS[b]
	col.a = float(SPOT_ALPHA[b])
	var hit := Color(BAND_COLOURS["critical"], float(SPOT_ALPHA["critical"]))
	if col.a <= 0.0:
		col = Color(hit, hit.a * fl)
	elif fl > 0.0:
		col = col.lerp(hit, fl)
	return col


func _portrait_rect() -> Rect2:
	var ts := Vector2(_tex.get_size())
	var k := minf(size.x / ts.x, size.y / ts.y)
	return Rect2((size - ts * k) * 0.5, ts * k)


func _ready() -> void:
	if custom_minimum_size == Vector2.ZERO:
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
	if _tex != null:
		_draw_portrait()
		return

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


func _draw_portrait() -> void:
	var edge := Color(0, 0, 0, 0.7)
	var strokes: Dictionary = _anchors.get("track", {})
	var tracked := not _track.is_empty() and (_skin != null or not strokes.is_empty())
	if _skin == null:
		draw_texture_rect(_tex, _portrait_rect(), false, BODY_TINT)
		if tracked:
			_draw_track(strokes)
	for p in BM.PLACES:
		var g := _geom_px(p)
		var col := colour_of(p)
		var c: Vector2 = g["c"]
		if tracked:
			if _skin != null:
				continue   # S332: hurt places redden her skin in the shader (SPOTS), no rings over her
			if BM.band(float(_values.get(p, 100.0))) != "fine" or float(_flash.get(p, 0.0)) > 0.0:
				draw_polyline(_ellipse_pts(c, g["rx"], g["ry"]), col, maxf(2.0, size.y * 0.014), true)
			continue
		if p == "head":
			_ellipse(c, g["rx"], g["ry"], Color(col.r, col.g, col.b, 0.22))
			draw_polyline(_ellipse_pts(c, g["rx"], g["ry"]), col, maxf(2.0, size.y * 0.012), true)
		else:
			_ellipse(c, g["rx"], g["ry"], Color(col.r, col.g, col.b, 0.62 if p.ends_with("ribs") else 0.92))
			draw_polyline(_ellipse_pts(c, g["rx"], g["ry"]), edge, 1.0, true)


## Each part as a thick stroke along her limb in its Burn colour, round-ended, a dark edge under it; a part that just went
## up a band swells and whitens for PULSE_S.
func _draw_track(strokes: Dictionary) -> void:
	var r := _portrait_rect()
	for place in strokes:
		var key := "legs" if str(place).begins_with("legs") else str(place)
		if not _track.has(key):
			continue
		var st: Dictionary = strokes[place]
		var pts := PackedVector2Array()
		for q in st["pts"]:
			pts.append(r.position + Vector2(float(q[0]) * r.size.x, float(q[1]) * r.size.y))
		var pu: float = float(_pulse.get(key, 0.0))
		var w: float = maxf(3.0, float(st["w"]) * r.size.x) * (1.0 + 0.35 * pu)
		var col := BodyTrack.colour(float(_track[key])).lerp(Color.WHITE, 0.5 * pu)
		col.a = TRACK_ALPHA
		draw_polyline(pts, Color(0, 0, 0, 0.55), w + 2.0, true)
		draw_circle(pts[0], (w + 2.0) * 0.5, Color(0, 0, 0, 0.55))
		draw_circle(pts[pts.size() - 1], (w + 2.0) * 0.5, Color(0, 0, 0, 0.55))
		draw_polyline(pts, col, w, true)
		draw_circle(pts[0], w * 0.5, col)
		draw_circle(pts[pts.size() - 1], w * 0.5, col)


## {body place: Burn} (BodyTrack.body_place keys: left/right shoulder and arm, core, legs). A part that went up a band
## pulses once.
func set_track(burns: Dictionary) -> void:
	for k in burns:
		if BodyTrack.pulse(float(_track.get(k, 0.0)), float(burns[k])):
			_pulse[k] = 1.0
		_track[k] = float(burns[k])
	_paint_skin()
	queue_redraw()


## e.g. "Jab shoulder: hot" for the part under the mouse ("" off the track).
func track_tip(local_pos: Vector2, southpaw: bool) -> String:
	var strokes: Dictionary = _anchors.get("track", {})
	if _track.is_empty() or strokes.is_empty():
		return ""
	var r := _portrait_rect()
	for place in strokes:
		var key := "legs" if str(place).begins_with("legs") else str(place)
		var st: Dictionary = strokes[place]
		var w: float = maxf(6.0, float(st["w"]) * r.size.x)
		var pts: Array = st["pts"]
		for i in pts.size() - 1:
			var a := r.position + Vector2(float(pts[i][0]) * r.size.x, float(pts[i][1]) * r.size.y)
			var b := r.position + Vector2(float(pts[i + 1][0]) * r.size.x, float(pts[i + 1][1]) * r.size.y)
			if Geometry2D.get_closest_point_to_segment(local_pos, a, b).distance_to(local_pos) <= w * 0.5:
				for part in BodyTrack.PARTS:
					if BodyTrack.body_place(part, southpaw) == key:
						return BodyTrack.label(part, float(_track.get(key, 0.0)))
	return ""


func _ellipse_pts(c: Vector2, rx: float, ry: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 33:
		var a := TAU * i / 32.0
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts


func _ellipse(c: Vector2, rx: float, ry: float, col: Color) -> void:
	var pts := _ellipse_pts(c, rx, ry)
	pts.remove_at(32)
	draw_colored_polygon(pts, col)


## A place in local pixels: {c, rx, ry} - on the portrait when there is one, else on the drawn figure.
func _geom_px(place: String) -> Dictionary:
	if _tex != null and _anchors.has(place):
		var r := _portrait_rect()
		var a: Array = _anchors[place]
		return {"c": r.position + Vector2(float(a[0]) * r.size.x, float(a[1]) * r.size.y),
			"rx": float(a[2]) * r.size.x, "ry": float(a[3]) * r.size.y}
	_update_xform()
	var g: Dictionary = _place_geom(place)
	var rad: float = float(g["radius"]) * _sc
	return {"c": (g["centre"] as Vector2) * _sc + _off, "rx": rad, "ry": rad}


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
	_paint_skin()
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
	var best := ""
	var best_r := INF
	for p in BM.PLACES:
		var g := _geom_px(p)
		var rx: float = maxf(0.001, g["rx"])
		var ry: float = maxf(0.001, g["ry"])
		var d: Vector2 = local_pos - (g["c"] as Vector2)
		if (d.x * d.x) / (rx * rx) + (d.y * d.y) / (ry * ry) <= 1.0 and rx * ry < best_r:
			best = p
			best_r = rx * ry
	return best


## S347 (operator: "lighten the ui/hud"): off a place, the figure's own words (the fight HUD puts the colour key and her
## punch stats here instead of on screen).
var extra_tip := ""
## S348 (C199): on a place, the caller's words for it (BodyLive: what that place has taken this bout, BodyTip.text).
var tip_fn := Callable()


func _get_tooltip(at_position: Vector2) -> String:
	var p: String = place_at(at_position)
	if p == "":
		return extra_tip
	tooltip_text = str(tip_fn.call(p)) if tip_fn.is_valid() else tip_of(p)
	return tooltip_text


func _make_custom_tooltip(for_text: String) -> Object:
	return BodyTip.panel(for_text) if tip_fn.is_valid() else null


## Exposed for tests: design-space centre of a place, mapped to local pixels.
func centre_of(place: String) -> Vector2:
	return _geom_px(place)["c"]


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
	for k in _pulse:
		if float(_pulse[k]) > 0.0:
			_pulse[k] = maxf(0.0, float(_pulse[k]) - delta / PULSE_S)
			any = true
	for p in BM.PLACES:
		var fa: float = _flash.get(p, 0.0)
		if fa > 0.0:
			fa -= delta / FLASH_S
			if fa < 0.0:
				fa = 0.0
			_flash[p] = fa
			any = true
	if any:
		_paint_skin()
		queue_redraw()
