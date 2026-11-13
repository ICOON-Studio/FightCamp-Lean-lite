extends Control
## S382 HOLOOFF R2 (skeptic on the corner card: a round-1 holo is all clean cyan - every place is still 'fine' (above
## BodyMap.HURT), so BodyFigure.SPOT_ALPHA paints nothing and the player reads "she is clean"): on the CORNER card the holo
## shows where she was hit THIS round even while fine - a light tint per spot graded by the punches that landed there this
## round (warm amber for a few, orange for many); the band colours (hurt and worse) stay on top. One number per hot spot, on the spot (S426: no
## words; the place it sits on says where).
##   count(log, round_n, struck_places)   tint(n) -> Color   lay_on(figure, hits) -> RoundHits (the words layer)
## Keys are each BodyFigure.SPOTS group's first place: "head" (head, eyes, nose), "left_ribs", "right_ribs" (the liver).

const SPOTS := [["head", "left_eye", "right_eye", "nose"], ["left_ribs"], ["right_ribs"]]   # = BodyFigure.SPOTS
const WORDS := {"head": "head", "left_ribs": "ribs", "right_ribs": "liver"}
const FEW := Color("#ffcf6a")    # warm amber: a punch or two
const MANY := Color("#ff7a1f")   # orange: MANY_AT and more
const MANY_AT := 6
const ALPHA_FEW := 0.34
const ALPHA_MANY := 0.55
const FONT_SIZE := 13

var fig: Control
var hits := {}
var size_px := FONT_SIZE   # S405 the live holo, with no plate behind it, writes them bigger
var icons := false   # S444 the small live maps (HudRegroup): each count sits on its organ's picture
const ORGANS := {"head": preload("res://assets/ui/body/organ_brain.png"), "left_ribs": preload("res://assets/ui/body/organ_ribs.png"),
	"right_ribs": preload("res://assets/ui/body/organ_liver.png")}
var drawn: Array = []   # the words this layer drew last ([text, position]) - tests read the drawn state


static var _clear := {}


## The organ picture with its baked dark ground made see-through (the PNGs are RGB on #090f17): alpha follows brightness.
static func _clear_pic(key: String) -> Texture2D:
	if _clear.has(key):
		return _clear[key]
	var src: Texture2D = ORGANS.get(key)
	if src == null:
		return null
	var img := src.get_image()
	if img.is_compressed():
		img.decompress()
	img.convert(Image.FORMAT_RGBA8)
	for y in img.get_height():
		for x in img.get_width():
			var c := img.get_pixel(x, y)
			var a := clampf((maxf(c.r, maxf(c.g, c.b)) - 0.06) * 2.2, 0.0, 1.0)
			img.set_pixel(x, y, Color(c.r, c.g, c.b, a))
	var tex := ImageTexture.create_from_image(img)
	_clear[key] = tex
	return tex


## One landed punch's places (`struck`, the places whose value just went down) into the log {round_n: {spot: n}}: a punch
## counts once per spot (a jab on the nose also marks the head - one hit to the head).
static func count(log: Dictionary, round_n: int, struck: Array) -> void:
	var r: Dictionary = log.get(round_n, {})
	for group in SPOTS:
		for p in group:
			if struck.has(p):
				r[group[0]] = int(r.get(group[0], 0)) + 1
				break
	log[round_n] = r


## The tint for n punches this round: clear at 0, amber at 1, orange from MANY_AT.
static func tint(n: int) -> Color:
	if n <= 0:
		return Color(0, 0, 0, 0)
	var t := clampf(float(n - 1) / float(MANY_AT - 1), 0.0, 1.0)
	var c := FEW.lerp(MANY, t)
	c.a = lerpf(ALPHA_FEW, ALPHA_MANY, t)
	return c


## Hand the figure this round's hits (its spots take the tint) and lay the words over it.
static func lay_on(f: Control, round_hits: Dictionary) -> Control:
	f.set("round_hits", round_hits)
	f.call("_paint_skin")
	f.queue_redraw()
	var layer := new()
	layer.name = "RoundHits"
	layer.fig = f
	layer.hits = round_hits
	layer.mouse_filter = MOUSE_FILTER_IGNORE
	layer.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	f.add_child(layer)
	return layer


func _ready() -> void:
	resized.connect(queue_redraw)


## Each hot spot's count ON the spot: a number in a small dark badge, nothing else (S426 operator on "3 hits to the head":
## "the number on the head implies that the hit is in the head, no need for text"). The place is the place it sits on.
func _draw() -> void:
	drawn.clear()
	if fig == null or fig.get("_tex") == null:
		return
	var font := get_theme_default_font()
	var fs := size_px + 5
	for key in WORDS:
		var n := int(hits.get(key, 0))
		if n <= 0:
			continue
		var text := str(n)
		var g: Dictionary = fig.call("_geom_px", key)
		var c: Vector2 = g["c"]
		var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var r := maxf(float(fs) * 0.8, w * 0.5 + 5.0)
		var mid := Vector2(clampf(c.x, r + 1.0, maxf(r + 1.0, size.x - r - 1.0)), c.y)
		var col := tint(n).lerp(Color.WHITE, 0.35)
		col.a = 1.0
		var pic: Texture2D = _clear_pic(key) if icons else null
		if pic != null:
			# S444 (operator C331: "instead of empty circle use the organ icon"). S448 (operator on Q-208: "try outline the
			# region instead of using bubbles, and the number should be without background"): the organ as a lit outline -
			# its own shape traced in the hit colour, the inside dark - and the bare count beside it, no badge.
			# S452 (operator C362 "wtf is that on the head ?", C363 "fix the head and make it a bit bigger so ribs and liver
			# read clean"): each organ is sized to its own place, inside the body - the brain fits inside her head (her
			# head's outline stays a head), ribs and liver each keep their own half of the chest - and the count stands
			# outside the body on the organ's outer side.
			var fit := 2.0 * maxf(float(g["rx"]), float(g["ry"]))
			var side_px := clampf(fit * (0.85 if key == "head" else 1.3), 12.0, r * 2.6)
			var box := Rect2(mid - Vector2(side_px, side_px) * 0.5, Vector2(side_px, side_px))
			for k in 12:
				var a := TAU * float(k) / 12.0
				draw_texture_rect(pic, Rect2(box.position + Vector2(cos(a), sin(a)) * 1.5, box.size), false, col)
			draw_texture_rect(pic, box, false, Color(0.03, 0.05, 0.08, 0.82))
			var right: bool = key == "head" or mid.x >= size.x * 0.5
			var nx: float = mid.x + side_px * 0.5 + 4.0 if right else mid.x - side_px * 0.5 - 4.0 - w
			var at2 := Vector2(nx, mid.y + float(fs) * 0.35)
			draw_string_outline(font, at2, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 5, Color(0, 0, 0, 0.85))
			draw_string(font, at2, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
			drawn.append([text, at2])
			continue
		draw_circle(mid, r, Color(0, 0, 0, 0.72))
		draw_arc(mid, r, 0.0, TAU, 24, col, 2.0, true)
		var at := Vector2(mid.x - w * 0.5, mid.y + float(fs) * 0.35)
		draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
		drawn.append([text, at])
