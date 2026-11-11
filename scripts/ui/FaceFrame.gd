extends RefCounted
## One crop for every face slot. The head box (hair to chin, ear to ear) stays whole, with a margin of 6% of its
## height, and the head sits a little above the middle. The window matches the slot, so a covered stretch does not
## crop it again. Boxes: scripts/ui/face_boxes.json, one rect per picture in each set (studio, style_b, dark, poster,
## fullbody, guide), scanned from the pixels.

const BOXES := "res://scripts/ui/face_boxes.json"
const MARGIN := 0.06
const HEAD_AT := 0.42   # the head's centre, down the frame. 0.5 is the middle.

static var _sets: Dictionary = {}


static func box_for(tex: Texture2D) -> Rect2:
	var path := _root_path(tex)
	var stem := path.get_file().get_basename()
	var set_name := _set_of(path)
	if _sets.is_empty():
		var all = JSON.parse_string(FileAccess.get_file_as_string(BOXES))
		_sets = (all as Dictionary).get("sets", {}) if all is Dictionary else {}
	var table: Dictionary = _sets.get(set_name, {})
	var row = table.get(stem, [])
	if row is Array and (row as Array).size() == 4:
		return Rect2(float(row[0]), float(row[1]), float(row[2]), float(row[3]))
	var s := _root(tex).get_size()
	push_warning("FaceFrame: no head box for %s" % _root(tex).resource_path)
	return Rect2(s.x * 0.28, s.y * 0.06, s.x * 0.44, s.y * 0.34)


## Sets the texture's crop so the head box fills this slot. `round` keeps the head inside a circular mask.
static func fit(rect: TextureRect, head: Rect2, size: Vector2, round := false) -> void:
	var base := _root(rect.texture)
	rect.set_meta("face_head", head)
	rect.set_meta("face_base", base)
	rect.set_meta("face_round", round)
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	rect.clip_contents = true
	if size.x > 1.0 and size.y > 1.0:
		rect.custom_minimum_size = size
	if not rect.has_meta("face_hooked"):
		rect.set_meta("face_hooked", true)
		rect.resized.connect(_on_resize.bind(rect))
	var use := size
	if rect.size.x > 1.0 and rect.size.y > 1.0:
		use = rect.size
	_apply(rect, use)


static func _on_resize(rect: TextureRect) -> void:
	if bool(rect.get_meta("face_busy", false)):
		return
	if rect.size.x > 1.0 and rect.size.y > 1.0:
		_apply(rect, rect.size)


static func _apply(rect: TextureRect, slot: Vector2) -> void:
	var base := rect.get_meta("face_base") as Texture2D
	var head: Rect2 = rect.get_meta("face_head")
	if base == null or slot.x < 1.0 or slot.y < 1.0:
		return
	rect.set_meta("face_busy", true)
	var frame := window(head, base.get_size(), slot, bool(rect.get_meta("face_round", false)))
	var atlas := AtlasTexture.new()
	atlas.atlas = base
	atlas.region = frame
	rect.texture = atlas
	var mat := rect.material as ShaderMaterial
	if mat != null and mat.shader != null and mat.shader.code.contains("region"):
		var s := base.get_size()
		mat.set_shader_parameter("region", Vector4(frame.position.x / s.x, frame.position.y / s.y, frame.size.x / s.x, frame.size.y / s.y))
	rect.set_meta("face_busy", false)


## The source window, in picture pixels, that this slot should show.
static func window(head: Rect2, image: Vector2, slot: Vector2, round := false) -> Rect2:
	var safe := _safe(head).intersection(Rect2(Vector2.ZERO, image))
	if safe.size.x < 1.0 or safe.size.y < 1.0:
		safe = head
	var aspect := slot.x / maxf(slot.y, 0.001)
	var frame := _place(head, safe, image, aspect)
	if round:
		frame = _grow_circle(head, safe, image, aspect, frame, slot)
	return frame


static func _safe(head: Rect2) -> Rect2:
	var m := head.size.y * MARGIN
	return Rect2(head.position - Vector2(m, m), head.size + Vector2(m, m) * 2.0)


static func _place(head: Rect2, safe: Rect2, image: Vector2, aspect: float) -> Rect2:
	var hc := head.get_center()
	var above := maxf(1.0, hc.y - safe.position.y)
	var below := maxf(1.0, safe.end.y - hc.y)
	var left := maxf(1.0, hc.x - safe.position.x)
	var right := maxf(1.0, safe.end.x - hc.x)
	var fh := maxf(above / HEAD_AT, below / (1.0 - HEAD_AT))
	fh = maxf(fh, maxf(left, right) * 2.0 / aspect)
	var fw := fh * aspect
	var pos := Vector2(hc.x - fw * 0.5, hc.y - fh * HEAD_AT)
	return _shift(Rect2(pos, Vector2(fw, fh)), safe, image)


static func _shift(frame: Rect2, safe: Rect2, image: Vector2) -> Rect2:
	var aspect := frame.size.x / maxf(frame.size.y, 0.001)
	var size := frame.size
	if size.x > image.x or size.y > image.y:
		var s := minf(image.x / size.x, image.y / size.y)
		size *= s
		if size.y * aspect > image.x:
			size = Vector2(image.x, image.x / aspect)
		if size.x / aspect > image.y:
			size = Vector2(image.y * aspect, image.y)
	var pos := Vector2(
		clampf(frame.position.x, 0.0, maxf(0.0, image.x - size.x)),
		clampf(frame.position.y, 0.0, maxf(0.0, image.y - size.y)))
	var out := Rect2(pos, size)
	if safe.position.x < out.position.x:
		out.position.x = safe.position.x
	if safe.end.x > out.end.x:
		out.position.x -= safe.end.x - out.end.x
	if safe.position.y < out.position.y:
		out.position.y = safe.position.y
	if safe.end.y > out.end.y:
		out.position.y -= safe.end.y - out.end.y
	out.position.x = clampf(out.position.x, 0.0, maxf(0.0, image.x - out.size.x))
	out.position.y = clampf(out.position.y, 0.0, maxf(0.0, image.y - out.size.y))
	return out


## Grow the window until the safe box lands inside the slot's inscribed circle.
static func _grow_circle(head: Rect2, safe: Rect2, image: Vector2, aspect: float, frame: Rect2, slot: Vector2) -> Rect2:
	var out := frame
	for _i in 8:
		if _circle_holds(safe, out, slot):
			return out
		var hc := head.get_center()
		var bigger := Rect2(hc - out.size * 0.575, out.size * 1.15)
		out = _shift(bigger, safe, image)
		if out.size.x >= image.x - 1.0 and out.size.y >= image.y - 1.0:
			return out
	return out


static func _circle_holds(safe: Rect2, frame: Rect2, slot: Vector2) -> bool:
	var c := slot * 0.5
	var rad := minf(slot.x, slot.y) * 0.5 - 0.5
	for p in [safe.position, Vector2(safe.end.x, safe.position.y), safe.end, Vector2(safe.position.x, safe.end.y)]:
		var u := Vector2((p.x - frame.position.x) / frame.size.x, (p.y - frame.position.y) / frame.size.y)
		var at := Vector2(u.x * slot.x, u.y * slot.y)
		if at.distance_to(c) > rad:
			return false
	return true


static func _set_of(path: String) -> String:
	if path.contains("/style_b/"):
		return "style_b"
	if path.contains("/face/studio/"):
		return "studio"
	if path.contains("/face/poster/"):
		return "poster"
	if path.contains("/face/gym/"):
		return "gym"
	if path.contains("/fullbody/"):
		return "fullbody"
	if path.contains("guide_trainer"):
		return "guide"
	if path.contains("/face/"):
		return "dark"
	return ""


static func _root(tex: Texture2D) -> Texture2D:
	var t := tex
	while t is AtlasTexture:
		t = (t as AtlasTexture).atlas
	return t


static func _root_path(tex: Texture2D) -> String:
	var t := _root(tex)
	return "" if t == null else t.resource_path
