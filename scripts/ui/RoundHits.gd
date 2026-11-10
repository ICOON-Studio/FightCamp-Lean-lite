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
var drawn: Array = []   # the words this layer drew last ([text, position]) - tests read the drawn state


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
		draw_circle(mid, r, Color(0, 0, 0, 0.72))
		draw_arc(mid, r, 0.0, TAU, 24, col, 2.0, true)
		var at := Vector2(mid.x - w * 0.5, mid.y + float(fs) * 0.35)
		draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
		drawn.append([text, at])
