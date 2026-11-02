extends Control
## S348 (operator's reference pictures for the holo, after C199 "mouse over head or liver to show stats like damage taken"):
## the anatomy-chart callouts - round close-ups of her OWN body (her still portrait, cut at the place) in the free strip
## beside the figure, a thin leader line to the place, the ring and number in the place's band colour, a white flash when a
## punch lands there. Pointing at a close-up gives the place's tooltip (BodyTip).
##   BodyCallouts.attach(figure, portrait {"tex", "anchors"}, outer: -1 left / +1 right, tip: Callable(place) -> String)

const BM := preload("res://scripts/rules/BodyMap.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const UI := preload("res://scripts/ui/TV.gd")
const KIT_SHADER := preload("res://scripts/ui/callout_kit.gdshader")
const FaceMarks := preload("res://scripts/ui/FaceMarks.gd")   # her kit neutral in the close-ups, as on the body view

## Each close-up: its name, the places it shows (the worst of them is its number), where it cuts her picture.
const SPOTS := [
	{"name": "HEAD", "places": ["head", "left_eye", "right_eye", "nose"], "at": "head", "crop": 1.25},
	{"name": "LIVER", "places": ["right_ribs"], "at": "right_ribs", "crop": 1.7},
	{"name": "RIBS", "places": ["left_ribs"], "at": "left_ribs", "crop": 1.7},
]
const R := 30.0          # a close-up's radius, px
const PAD := 6.0         # from the panel's outer edge
const GAP_Y := 86.0      # the close-ups' spacing down the strip
const RING_W := 3.0

var fig: Control
var tex: Texture2D
var face: Texture2D   # S353 her headshot (BodyHolo): the HEAD close-up shows HER over the holo's ecorche head
const FACE_UV := Vector3(0.53, 0.37, 0.24)   # centre u, v and radius (of the width) of her face in the headshot
var anchors := {}
var marks := {}   # S354 C202 her side of the body map ({"cuts", "closed"}): cuts and swelling drawn on her face close-up
var outer := -1.0
var tip := Callable()
var _bubbles: Array = []   # Control per spot (mouse + tooltip)
var _pics: Control         # the cut-outs, drawn behind the rings (their own shader)


class Bubble extends Control:
	var spot := {}
	var owner_tip := Callable()

	func _get_tooltip(_p: Vector2) -> String:
		return str(owner_tip.call(spot))

	func _make_custom_tooltip(t: String) -> Object:
		return BodyTip.panel(t)


static func attach(f: Control, portrait: Dictionary, side_out: float, tip_fn: Callable) -> Control:
	if portrait.get("tex") == null:
		return null
	var c := new()
	c.name = "BodyCallouts"
	c.fig = f
	c.tex = portrait["tex"]
	c.face = portrait.get("face") as Texture2D
	c.anchors = portrait.get("anchors", {})
	c.outer = side_out
	c.tip = tip_fn
	c.mouse_filter = MOUSE_FILTER_IGNORE
	c.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	f.add_child(c)
	c._pics = Control.new()
	c._pics.name = "Pics"
	c._pics.mouse_filter = MOUSE_FILTER_IGNORE
	c._pics.show_behind_parent = true
	c._pics.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	var mat := ShaderMaterial.new()
	mat.shader = KIT_SHADER
	mat.set_shader_parameter("holo", 1.0 if portrait.get("holo", false) else 0.0)
	c._pics.material = mat
	c._pics.draw.connect(c._draw_pics)
	c.add_child(c._pics)
	for s in SPOTS:
		var b := Bubble.new()
		b.spot = s
		b.owner_tip = c._spot_tip
		b.size = Vector2(R * 2.0, R * 2.0 + 18.0)
		b.mouse_filter = MOUSE_FILTER_STOP
		b.tooltip_text = " "   # a tooltip exists (the text comes from _get_tooltip)
		c.add_child(b)
		c._bubbles.append(b)
	return c


## The worst place of a close-up: its tooltip is that place's (a face place adds her head).
func _spot_tip(s: Dictionary) -> String:
	return str(tip.call(_worst(s))) if tip.is_valid() else ""


func _worst(s: Dictionary) -> String:
	var best := str(s["places"][0])
	for p in s["places"]:
		if float(fig._values.get(p, 100.0)) < float(fig._values.get(best, 100.0)):
			best = str(p)
	return best


## Where close-up k sits (its centre, local px): the outer strip, spread down beside her head and ribs.
func centre(k: int) -> Vector2:
	var head: Vector2 = fig.call("_geom_px", "head")["c"]
	var ribs: Vector2 = fig.call("_geom_px", "right_ribs")["c"]
	var x := PAD + R if outer < 0.0 else size.x - PAD - R
	var y0 := maxf(R + 2.0, head.y)
	var y := y0 if k == 0 else maxf(y0 + GAP_Y * k, ribs.y + GAP_Y * (k - 1.5))
	return Vector2(x, y)


func _process(_d: float) -> void:
	for k in _bubbles.size():
		(_bubbles[k] as Control).position = centre(k) - Vector2(R, R)
	queue_redraw()
	if _pics != null:
		_pics.queue_redraw()


## Her own picture, cut round each place (drawn on _pics, behind the rings).
func _draw_pics() -> void:
	var ts := tex.get_size()
	for k in SPOTS.size():
		var s: Dictionary = SPOTS[k]
		var a: Array = anchors.get(str(s["at"]), [])
		if a.size() < 4:
			continue
		var c := centre(k)
		var t := tex
		var cuv := Vector3(float(a[0]), float(a[1]), float(a[2]) * float(s["crop"]))
		var asp := ts.x / ts.y
		if str(s["at"]) == "head" and face != null:
			t = face
			cuv = FACE_UV
			asp = face.get_size().x / face.get_size().y
		var pts := PackedVector2Array()
		var uvs := PackedVector2Array()
		for i in 32:
			var ang := TAU * i / 32.0
			pts.append(c + Vector2(cos(ang), sin(ang)) * R)
			uvs.append(Vector2(cuv.x + cos(ang) * cuv.z, cuv.y + sin(ang) * cuv.z * asp))
		_pics.draw_polygon(pts, PackedColorArray([Color.WHITE]), uvs, t)


func _draw() -> void:
	var font: Font = UI.font("bold")
	for k in SPOTS.size():
		var s: Dictionary = SPOTS[k]
		var c := centre(k)
		var place := _worst(s)
		var v := float(fig._values.get(place, 100.0))
		var band := BM.band(v)
		var col: Color = BodyTip.BAND_COLOURS[band] if band != "fine" else Color(1, 1, 1, 0.75)
		var fl := 0.0
		for p in s["places"]:
			fl = maxf(fl, float(fig._flash.get(p, 0.0)))
		col = col.lerp(Color.WHITE, fl)
		# The leader line from the close-up's edge to the place on her body.
		var g: Dictionary = fig.call("_geom_px", str(s["at"]))
		var to: Vector2 = g["c"]
		var from := c + (to - c).normalized() * R
		draw_line(from, to, Color(col, 0.55), 1.5, true)
		draw_circle(to, 3.0, col)
		if band != "fine":
			draw_circle(c, R, Color(col, 0.22))   # a hurt place's close-up takes its colour
		if str(s["at"]) == "head" and face != null:
			FaceMarks.paint(self, c, R, fig._values, marks)
		draw_arc(c, R, 0.0, TAU, 40, Color(0, 0, 0, 0.55), RING_W + 2.0, true)
		draw_arc(c, R, 0.0, TAU, 40, col, RING_W, true)
		# Its name and number under it.
		var words := "%s %d" % [s["name"], int(round(v))]
		var w := font.get_string_size(words, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY).x
		draw_string(font, c + Vector2(-w * 0.5 + 1.0, R + 15.0), words, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, Color(0, 0, 0, 0.7))
		draw_string(font, c + Vector2(-w * 0.5, R + 14.0), words, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, col)
