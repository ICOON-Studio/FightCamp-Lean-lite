extends RefCounted
## STAFFCARDS1 (S547): the drawing of one Staff card (StaffDesk builds the specs). After docs/mockups/s546/staff_cards.html:
## a picture strip (the face, or a grey silhouette drawn here for a job nobody holds), the name over its foot in the hand
## font, a tag top-right and NEW top-left; then the job in plain words, at most four facts as dots (green = what it gives,
## gold = money, grey = a plain line) and one button. An open job is a dashed card. The hover is the card's Tip.
##   StaffDeskCard.card(spec, width, hover) -> PanelContainer "StaffCard_<id>"     section(text) -> the gold row title
## spec = {id, inner, face, name, tag, role, facts: [[text, "good" | "", hover?] or ["You pay:", "$450 a week"]], open, new,
##   button: {text, name, solid, press, tip, pulse}}

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Tip := preload("res://scripts/ui/Tip.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")

const W := 320.0
const H := 330.0
const PIC_H := 146.0
## FaceFrame keeps the whole head (face_frame_test): a strip wider than this for its height would need more picture than a
## 704 px portrait has, so a wide card shows the face centred, at most this wide.
const FACE_ASPECT := 2.15
const INK := Palette.TEXT
const SOFT := Palette.MUTED
const GOOD := Palette.GOOD
const GOLD := Palette.HEADER


static func section(text: String) -> Label:
	var l := UI.label(text, 17, GOLD, "caps")
	l.name = "Head_" + text.replace(" ", "")
	return l


static func card(s: Dictionary, w: float, hover: Dictionary) -> PanelContainer:
	var open := bool(s.get("open", false))
	var fresh := bool(s.get("new", false))
	var narrow := w < 280.0
	var p := PanelContainer.new()
	p.name = "StaffCard_" + str(s["id"])
	p.custom_minimum_size = Vector2(w, H)
	p.clip_contents = true
	var edge := Palette.WARN if fresh else (Palette.CLEAR if open else Palette.alpha(INK, 0.16))
	p.add_theme_stylebox_override("panel", UI.box(Palette.alpha(Palette.PAGE, 0.28 if open else 0.55), edge, 8, 0 if open and not fresh else 2, 0, 0))
	var v := UI.vbox(0)
	v.name = str(s.get("inner", "Card"))
	p.add_child(v)
	v.add_child(_picture(s, w, narrow, open, fresh))
	var m := MarginContainer.new()
	m.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for side in ["left", "right"]:
		m.add_theme_constant_override("margin_" + side, 12 if narrow else 14)
	m.add_theme_constant_override("margin_top", 8)
	m.add_theme_constant_override("margin_bottom", 12)
	v.add_child(m)
	var body := UI.vbox(4)
	m.add_child(body)
	if str(s.get("role", "")) != "":
		body.add_child(UI.label(str(s["role"]), 14 if narrow else 16, SOFT, "semi"))
	var facts: Array = s.get("facts", [])
	for i in mini(4, facts.size()):
		body.add_child(_fact(facts[i], i, narrow))
	var fill := Control.new()
	fill.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(fill)
	var bs: Dictionary = s.get("button", {})
	var b: Button = null
	if not bs.is_empty():
		b = UI.button(str(bs["text"]), "BtnSolid" if bool(bs.get("solid", false)) else "Btn", bs["press"])
		b.name = str(bs["name"])
		b.custom_minimum_size = Vector2(0, 40)
		body.add_child(b)
	if open:
		var d := Dashed.new()
		d.ink = Palette.LINE
		p.add_child(d)
	_quiet(p)
	if not hover.is_empty():
		Tip.explain(p, hover)
	for h in body.get_children():   # a fact with its own hover (the promises on your card)
		if h.has_meta("fact_tip"):
			(h as Control).mouse_filter = Control.MOUSE_FILTER_STOP
			Tip.explain(h, h.get_meta("fact_tip"))
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	if b != null:
		if str(bs.get("tip", "")) != "":
			Tip.button(b, str(bs["tip"]))
		if bool(bs.get("pulse", false)):
			Pulse.breathe(b)
	return p


## The strip on top: the face (or a silhouette), a fade to the card, the name on the fade, the tag and NEW.
static func _picture(s: Dictionary, w: float, narrow: bool, open: bool, fresh: bool) -> Control:
	var box := Control.new()
	box.name = "Picture"
	box.custom_minimum_size = Vector2(w, PIC_H)
	box.clip_contents = true
	var bg := ColorRect.new()
	bg.color = Palette.alpha(Palette.PAGE, 0.25) if open else Palette.alpha(Palette.TILE, 0.65)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.add_child(bg)
	var stem := str(s.get("face", ""))
	var face: TextureRect = PromoShot.picture(stem, Vector2(minf(w, PIC_H * FACE_ASPECT), PIC_H)) if stem != "" else null   # the mockup's cover crop
	if face != null:
		face.position = Vector2((w - face.custom_minimum_size.x) * 0.5, 0.0)
		box.add_child(face)
	else:
		var sil := Silhouette.new()
		sil.name = "Silhouette"
		sil.ink = Palette.alpha(Palette.TILE, 0.95)
		sil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		box.add_child(sil)
	box.add_child(_shade())
	var nm := UI.display(str(s.get("name", "")), 23 if narrow else 28, INK)
	nm.name = "CardName"
	nm.clip_text = true
	nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	nm.add_theme_color_override("font_shadow_color", Palette.alpha(Palette.PAGE, 0.9))
	nm.add_theme_constant_override("shadow_offset_y", 2)
	nm.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	nm.offset_left = 12.0
	nm.offset_right = -8.0
	nm.offset_top = -46.0
	nm.offset_bottom = -2.0
	box.add_child(nm)
	var top := UI.hbox(6)
	top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top.offset_left = 10.0
	top.offset_right = -10.0
	top.offset_top = 10.0
	top.offset_bottom = 36.0
	if fresh:
		top.add_child(_tag("NEW", Palette.WARN, Palette.PAGE, "NewTag"))
	top.add_child(UI.spacer())
	if str(s.get("tag", "")) != "":
		top.add_child(_tag(str(s["tag"]), Palette.PAGE, SOFT, "Tag"))
	box.add_child(top)
	return box


static func _tag(text: String, bg: Color, ink: Color, name: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = name
	p.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	p.add_theme_stylebox_override("panel", UI.box(bg, Palette.LINE if bg == Palette.PAGE else Palette.CLEAR, 4, 1, 8, 1))
	p.add_child(UI.label(text, 14, ink, "bold"))
	return p


## A fact: a dot and the words. Money: the label in the text ink, the sum in gold (the mockup's "You pay: $450 a week").
static func _fact(f: Array, i: int, narrow: bool) -> Control:
	var h := UI.hbox(9)
	h.name = "Fact_%d" % i
	if f.size() > 2 and f[2] is Dictionary:
		h.name = "Fact_%d_%s" % [i, str((f[2] as Dictionary).get("node", ""))]
		h.set_meta("fact_tip", f[2])
	var money := str(f[1]) != "good" and str(f[1]) != ""
	var col := GOLD if money else (GOOD if str(f[1]) == "good" else SOFT)
	var size := 15 if narrow else 16
	var dm := MarginContainer.new()
	dm.add_theme_constant_override("margin_top", 7)
	dm.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var dot := Panel.new()
	dot.custom_minimum_size = Vector2(9, 9)
	dot.add_theme_stylebox_override("panel", UI.box(col, Palette.CLEAR, 5, 0, 0, 0))
	dm.add_child(dot)
	h.add_child(dm)
	if money:
		h.add_child(UI.label(str(f[0]), size, INK, "semi"))
		h.add_child(UI.label(str(f[1]), size, GOLD, "bold"))
		return h
	var l := UI.label(str(f[0]), size, GOOD if str(f[1]) == "good" else INK, "semi", true)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(l)
	return h


static func _shade() -> TextureRect:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 0.35, 1.0])
	g.colors = PackedColorArray([Palette.alpha(Palette.PAGE, 0.0), Palette.alpha(Palette.PAGE, 0.0), Palette.alpha(Palette.PAGE, 0.85)])
	var tex := GradientTexture2D.new()
	tex.gradient = g
	tex.fill_from = Vector2(0, 0)
	tex.fill_to = Vector2(0, 1)
	tex.width = 8
	tex.height = 128
	var r := TextureRect.new()
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_SCALE
	r.texture = tex
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return r


## Everything but the button passes the pointer to the card, so the card's hover opens anywhere on it.
static func _quiet(n: Node) -> void:
	for ch in n.get_children():
		if ch is Control and not (ch is BaseButton):
			(ch as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
			_quiet(ch)


## A job nobody holds: a head and shoulders in grey (no borrowed face).
class Silhouette extends Control:
	var ink := Color.TRANSPARENT

	func _ready() -> void:
		resized.connect(queue_redraw)

	func _draw() -> void:
		var cx := size.x * 0.5
		var r := minf(size.y * 0.19, 30.0)
		var head_y := size.y * 0.10 + r
		draw_circle(Vector2(cx, head_y), r, ink)
		var top := head_y + r + 8.0
		var rw := r * 2.2
		var rh := size.y - top + 12.0
		var pts := PackedVector2Array()
		for i in 17:
			var a := PI + PI * float(i) / 16.0
			pts.append(Vector2(cx + cos(a) * rw, top + rh + sin(a) * rh))
		draw_colored_polygon(pts, ink)


## The open job's dashed edge (a StyleBox has no dashes).
class Dashed extends Control:
	var ink := Color.TRANSPARENT

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)

	func _draw() -> void:
		var a := Vector2(1, 1)
		var b := size - Vector2(1, 1)
		for e in [[a, Vector2(b.x, a.y)], [Vector2(b.x, a.y), b], [b, Vector2(a.x, b.y)], [Vector2(a.x, b.y), a]]:
			draw_dashed_line(e[0], e[1], ink, 2.0, 8.0)
