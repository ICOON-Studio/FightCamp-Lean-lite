extends Control
## S348 (operator's reference pictures for the holo, after C199 "mouse over head or liver to show stats like damage taken"):
## the anatomy-chart callouts - round close-ups of her OWN body (her still portrait, cut at the place) in the free strip
## beside the figure, a thin leader line to the place, the ring and number in the place's band colour, a white flash when a
## punch lands there. Pointing at a close-up gives the place's tooltip (BodyTip).
## S379 (operator: "can you make these popout outlined only when a hit lands showing the region of the hit and a short
## summary of the organ condition and also show up as a tooltip when player moves mouse over the each body area"): hidden
## until wanted. A punch landing on a close-up's place (struck) pops that one close-up - it grows and fades in over POP_S
## with its band-colour ring, the flash and the condition line under it (line_fn: CalloutLine) - holds HOLD_S (a new hit
## there restarts the hold), then fades out over FADE_S. The mouse on a body place (BodyTip.hover) shows that place's
## close-up while it stays there: the card is the place's tooltip (BodyLive gives the figure no text tooltip on a place a
## close-up covers). Pop and fade are tweens (operator: "every bar tweens"); the card is clamped inside the picture.
##   BodyCallouts.attach(figure, portrait {"tex", "anchors"}, outer: -1 left / +1 right, tip: Callable(place) -> String)
##   struck(place)   spot_of(place) -> k   shown(k)   line_of(k)   centre(k)

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
const RING_W := 3.5
const POP_S := 0.15      # grow + fade in
const HOLD_S := 2.5      # a hit's card stays this long
const FADE_S := 0.45     # fade out
const POP_FROM := 0.55   # the scale a card grows from
const BUMP := 1.14       # a new hit on a card already out swells it once
const PLATE_H := 22.0    # the condition line's plate under the card
const PLATE_GAP := 5.0
const EDGE_M := 4.0      # the card keeps this far inside the picture

var fig: Control
var tex: Texture2D
var face: Texture2D   # S353 her headshot (BodyHolo): the HEAD close-up shows HER over the holo's ecorche head
const FACE_UV := Vector3(0.53, 0.37, 0.24)   # centre u, v and radius (of the width) of her face in the headshot
var anchors := {}
var face_uv := {}   # S380 her promo shot's eyes and nose (BodyHolo.portrait "face_uv"): the close-up and its marks follow them
var marks := {}   # S354 C202 her side of the body map ({"cuts", "closed"}): cuts and swelling drawn on her face close-up
var outer := -1.0
var tip := Callable()
var line_fn := Callable()   # Callable(spot) -> String, the condition line (BodyLive); else "<NAME> <value>"
var _bubbles: Array = []   # a card per spot (mouse + tooltip + its drawing)
var _hold := [0.0, 0.0, 0.0]


class Bubble extends Control:
	var spot := {}
	var owner_tip := Callable()
	var co: Control
	var pic: Control   # her cut-out, drawn behind the ring (its own shader)
	var line := ""
	var want := false
	var over := false
	var tw: Tween

	func _get_tooltip(_p: Vector2) -> String:
		return str(owner_tip.call(spot))

	func _make_custom_tooltip(t: String) -> Object:
		return BodyTip.panel(t)

	func _draw() -> void:
		co._draw_card(self)


static func attach(f: Control, portrait: Dictionary, side_out: float, tip_fn: Callable) -> Control:
	if portrait.get("tex") == null:
		return null
	var c := new()
	c.name = "BodyCallouts"
	c.fig = f
	c.tex = portrait["tex"]
	c.face = portrait.get("face") as Texture2D
	c.face_uv = portrait.get("face_uv", {})
	c.anchors = portrait.get("anchors", {})
	c.outer = side_out
	c.tip = tip_fn
	c.mouse_filter = MOUSE_FILTER_IGNORE
	c.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	f.add_child(c)
	var mat := ShaderMaterial.new()
	mat.shader = KIT_SHADER
	mat.set_shader_parameter("holo", 1.0 if portrait.get("holo", false) else 0.0)
	for s in SPOTS:
		var b := Bubble.new()
		b.name = "Card%s" % str(s["name"]).capitalize()
		b.spot = s
		b.co = c
		b.owner_tip = c._spot_tip
		b.size = Vector2(R * 2.0, R * 2.0)
		b.pivot_offset = Vector2(R, R)
		b.mouse_filter = MOUSE_FILTER_STOP
		b.tooltip_text = " "   # a tooltip exists (the text comes from _get_tooltip)
		b.modulate.a = 0.0
		b.visible = false   # S379 hidden until a hit or the mouse wants it
		b.mouse_entered.connect(func() -> void: b.over = true)
		b.mouse_exited.connect(func() -> void: b.over = false)
		b.pic = Control.new()
		b.pic.name = "Pic"
		b.pic.mouse_filter = MOUSE_FILTER_IGNORE
		b.pic.show_behind_parent = true
		b.pic.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
		b.pic.material = mat
		b.pic.draw.connect(c._draw_pic.bind(b))
		b.add_child(b.pic)
		c.add_child(b)
		c._bubbles.append(b)
	return c


## The close-up showing `place` (its index in SPOTS), -1 when none does.
static func spot_of(place: String) -> int:
	for k in SPOTS.size():
		if place in SPOTS[k]["places"]:
			return k
	return -1


## A punch landed on `place`: its close-up pops out and holds HOLD_S (a new hit restarts the hold and swells it once).
func struck(place: String) -> void:
	var k := spot_of(place)
	if k < 0 or k >= _bubbles.size():
		return
	_hold[k] = HOLD_S
	var b: Bubble = _bubbles[k]
	b.line = _line(k)
	if b.want:
		_tween(b, true, true)


func shown(k: int) -> bool:
	return k >= 0 and k < _bubbles.size() and (_bubbles[k] as Control).visible


func line_of(k: int) -> String:
	return str((_bubbles[k] as Bubble).line) if k >= 0 and k < _bubbles.size() else ""


## The worst place of a close-up: its tooltip is that place's (a face place adds her head).
func _spot_tip(s: Dictionary) -> String:
	return str(tip.call(_worst(s))) if tip.is_valid() else ""


func _worst(s: Dictionary) -> String:
	var best := str(s["places"][0])
	for p in s["places"]:
		if float(fig._values.get(p, 100.0)) < float(fig._values.get(best, 100.0)):
			best = str(p)
	return best


func _line(k: int) -> String:
	var s: Dictionary = SPOTS[k]
	if line_fn.is_valid():
		return str(line_fn.call(s))
	return "%s %d" % [s["name"], int(round(float(fig._values.get(_worst(s), 100.0))))]


## Where close-up k sits (its centre, local px): the outer strip, spread down beside her head and ribs, then moved so the
## card and its line stay inside the picture (the right boxer's strip is at the screen's right edge).
func centre(k: int) -> Vector2:
	var head: Vector2 = fig.call("_geom_px", "head")["c"]
	var ribs: Vector2 = fig.call("_geom_px", "right_ribs")["c"]
	var x := PAD + R if outer < 0.0 else size.x - PAD - R
	var y0 := maxf(R + 6.0, head.y)   # a little air above the HEAD ring (the panel's top edge)
	var y := y0 if k == 0 else maxf(y0 + GAP_Y * k, ribs.y + GAP_Y * (k - 1.5))
	var c := Vector2(x, y)
	if not is_inside_tree():
		return c
	var r := Rect2(c - Vector2(R, R), Vector2(R, R) * 2.0).merge(_plate_rect(c, _plate_w(k)))
	var xf := get_global_transform()
	var g := Rect2(xf * r.position, xf.basis_xform(r.size))
	var vis := get_viewport_rect().grow(-EDGE_M)
	var shift := Vector2(maxf(0.0, vis.position.x - g.position.x) - maxf(0.0, g.end.x - vis.end.x),
		maxf(0.0, vis.position.y - g.position.y) - maxf(0.0, g.end.y - vis.end.y))
	return c + xf.affine_inverse().basis_xform(shift)


## The condition line's plate under a card centred at `c` (local px), on the card's outer edge, growing inward.
func _plate_rect(c: Vector2, w: float) -> Rect2:
	var x := c.x - R if outer < 0.0 else c.x + R - w
	return Rect2(x, c.y + R + PLATE_GAP, w, PLATE_H)


func _plate_w(k: int) -> float:
	var t := line_of(k)
	if t == "":
		return 0.0
	return UI.font("bold").get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY).x + 14.0


func _process(delta: float) -> void:
	var bt := fig.get_node_or_null("BodyTip")
	var hk := spot_of(str(bt.get("hover"))) if bt != null else -1
	var real := delta / maxf(0.05, Engine.time_scale)   # the hold is the player's time (2x pace, slow-mo close-ups)
	for k in _bubbles.size():
		var b: Bubble = _bubbles[k]
		_hold[k] = maxf(0.0, float(_hold[k]) - real)
		var want := float(_hold[k]) > 0.0 or hk == k or (b.over and b.visible)
		if want:
			b.line = _line(k)
		if want != b.want:
			_tween(b, want)
		b.position = centre(k) - Vector2(R, R)
		b.visible = want or b.modulate.a > 0.01
		if b.visible:
			b.queue_redraw()
			b.pic.queue_redraw()
	queue_redraw()


## Pop out (grow from POP_FROM with a small overshoot, fade in over POP_S) or fade away (FADE_S); `bump` swells a card
## that is already out.
func _tween(b: Bubble, on: bool, bump: bool = false) -> void:
	b.want = on
	if b.tw != null and b.tw.is_valid():
		b.tw.kill()
	b.tw = b.create_tween().set_parallel(true).set_ignore_time_scale(true)
	if on:
		if bump:
			b.scale = Vector2.ONE * BUMP
		elif b.modulate.a < 0.05:
			b.scale = Vector2.ONE * POP_FROM
		b.visible = true
		b.tw.tween_property(b, "modulate:a", 1.0, POP_S)
		b.tw.tween_property(b, "scale", Vector2.ONE, POP_S * (2.0 if bump else 1.0)).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		b.tw.tween_property(b, "modulate:a", 0.0, FADE_S).set_ease(Tween.EASE_IN)
		b.tw.tween_property(b, "scale", Vector2.ONE * 0.9, FADE_S)


## A close-up's ring colour: its worst place's band (fine is green), whitened by a fresh hit's flash.
func _colour(s: Dictionary) -> Color:
	var col: Color = BodyTip.BAND_COLOURS[BM.band(float(fig._values.get(_worst(s), 100.0)))]
	var fl := 0.0
	for p in s["places"]:
		fl = maxf(fl, float(fig._flash.get(p, 0.0)))
	return col.lerp(Color.WHITE, fl)


## Her own picture cut round the card's place (drawn on its Pic, behind the ring).
func _draw_pic(b: Bubble) -> void:
	var s: Dictionary = b.spot
	var a: Array = anchors.get(str(s["at"]), [])
	if a.size() < 4:
		return
	var c := Vector2(R, R)
	var t := tex
	var cuv := Vector3(float(a[0]), float(a[1]), float(a[2]) * float(s["crop"]))
	var asp := tex.get_size().x / tex.get_size().y
	if str(s["at"]) == "head" and face != null:
		t = face
		asp = face.get_size().x / face.get_size().y
		var lay := FaceMarks.layout(face_uv, asp)
		cuv = lay["cuv"] if not lay.is_empty() else FACE_UV
	var pts := PackedVector2Array()
	var uvs := PackedVector2Array()
	for i in 32:
		var ang := TAU * i / 32.0
		pts.append(c + Vector2(cos(ang), sin(ang)) * R)
		uvs.append(Vector2(cuv.x + cos(ang) * cuv.z, cuv.y + sin(ang) * cuv.z * asp))
	b.pic.draw_polygon(pts, PackedColorArray([Color.WHITE]), uvs, t)


## One card (its local px, centre R,R): a hurt place's tint, her face marks, the outline ring, the condition line's plate.
func _draw_card(b: Bubble) -> void:
	var s: Dictionary = b.spot
	var c := Vector2(R, R)
	var col := _colour(s)
	var band := BM.band(float(fig._values.get(_worst(s), 100.0)))
	if band != "fine":
		b.draw_circle(c, R, Color(col, 0.22))   # a hurt place's close-up takes its colour
	if str(s["at"]) == "head" and face != null:
		var lay := FaceMarks.layout(face_uv, face.get_size().x / face.get_size().y)
		FaceMarks.paint(b, c, R, fig._values, marks, lay["at"] if not lay.is_empty() else FaceMarks.AT)
	b.draw_arc(c, R + 1.0, 0.0, TAU, 48, Color(0, 0, 0, 0.6), RING_W + 3.0, true)
	b.draw_arc(c, R, 0.0, TAU, 48, col, RING_W, true)
	var t := str(b.line)
	if t == "":
		return
	var bold: Font = UI.font("bold")
	var w := bold.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY).x + 14.0
	var pr := _plate_rect(c, w)
	b.draw_style_box(UI.box(Color(0.06, 0.05, 0.05, 0.88), Color(col, 0.8), 6, 1, 0, 0), pr)
	# Its name and number in the band colour, the words after them in the HUD's light text.
	var cut := t.find(" - ")
	var lead := t if cut < 0 else t.substr(0, cut)
	var at := pr.position + Vector2(7.0, 16.0)
	b.draw_string(bold, at, lead, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, col)
	if cut >= 0:
		var lw := bold.get_string_size(lead, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY).x
		b.draw_string(bold, at + Vector2(lw, 0.0), t.substr(cut), HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, UI.FG)


## The leader line from each card out now to its place on her body (under the cards, faded with them).
func _draw() -> void:
	for k in _bubbles.size():
		var b: Bubble = _bubbles[k]
		if not b.visible:
			continue
		var s: Dictionary = b.spot
		var col := _colour(s)
		var a := b.modulate.a
		var c := b.position + Vector2(R, R)
		var to: Vector2 = fig.call("_geom_px", str(s["at"]))["c"]
		var from := c + (to - c).normalized() * R * b.scale.x
		draw_line(from, to, Color(0, 0, 0, 0.45 * a), 3.5, true)
		draw_line(from, to, Color(col, 0.8 * a), 1.5, true)
		draw_circle(to, 4.0, Color(0, 0, 0, 0.5 * a))
		draw_circle(to, 3.0, Color(col, a))
