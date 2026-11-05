extends RefCounted
## S387 (operator on the fighter's photo: "this looks so bad ... maybe zoom a bit so hands do not show", "slighlty animated"): a promo
## shot shown as head and shoulders, framed on the face's own marks (promo_face.json), so the crossed arms and hands stay out of frame
## for every body. live(rect) adds a slow breath: a shader moves the chest and sways the head a little; no 3D model is loaded.
## S387 (operator: "black people on black background ?"): the menus show the set baked on a slate backdrop (STUDIO, tools/bake_promo.gd
## studio=... bg=0.50,0.55,0.60), so dark skin and hair read against it; the dark set stays for the posters and body close-ups.

const FACES := "res://assets/ui/face"
const STUDIO := "res://assets/ui/face/studio"
const BREATH := preload("res://assets/ui/promo_breath.gdshader")
const CROP_H := 0.52       # of the shot's height (and width: the frames are the shot's own 4:5)
const ABOVE_EYES := 0.23   # how far above the eyes the frame starts, for tall hair

static var _marks := {}


## Fractions of the shot: {} when the body has no marks (the caller keeps the whole shot).
static func region(stem: String) -> Rect2:
	if _marks.is_empty():
		var all = JSON.parse_string(FileAccess.get_file_as_string(FACES.path_join("promo_face.json")))
		_marks = all if all is Dictionary else {}
	var m: Dictionary = _marks.get(stem, {})
	if m.is_empty():
		return Rect2()
	var x := clampf(float(m["nose"][0]) - CROP_H * 0.5, 0.0, 1.0 - CROP_H)
	var y := clampf(float(m["eye_l"][1]) - ABOVE_EYES, 0.0, 1.0 - CROP_H)
	return Rect2(x, y, CROP_H, CROP_H)


static func crop(tex: Texture2D, stem: String) -> Texture2D:
	var r := region(stem)
	if r.size == Vector2.ZERO:
		return tex
	var s := tex.get_size()
	var a := AtlasTexture.new()
	a.atlas = tex
	a.region = Rect2(r.position * s, r.size * s)
	return a


## The photo of a body on the slate backdrop, null when it has none.
static func shot(stem: String) -> Texture2D:
	var path := STUDIO.path_join(stem + ".jpg")
	return crop(load(path), stem) if ResourceLoader.exists(path) else null


## A breathing head-and-shoulders picture of this size; null when the body has no photo.
static func picture(stem: String, size: Vector2) -> TextureRect:
	var tex := shot(stem)
	if tex == null:
		return null
	var r := TextureRect.new()
	r.name = "Face"
	r.custom_minimum_size = size
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.texture = tex
	live(r)
	return r


## The breath, on a TextureRect showing a crop. Each picture gets its own phase, so a roster does not breathe in step.
static func live(rect: TextureRect) -> void:
	var a := rect.texture as AtlasTexture
	if a == null:
		return
	var s := a.atlas.get_size()
	var m := ShaderMaterial.new()
	m.shader = BREATH
	m.set_shader_parameter("region", Vector4(a.region.position.x / s.x, a.region.position.y / s.y, a.region.size.x / s.x, a.region.size.y / s.y))
	m.set_shader_parameter("phase", float(hash(a.atlas.resource_path) % 628) / 100.0)
	rect.material = m
