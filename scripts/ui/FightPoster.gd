extends RefCounted
## S361 a fight poster for every bout (Q-S294-86 "Yes, build them", Miro top-5 card 5). Drawn from the bout's own data the
## day it is booked: the two faces in halftone (assets/ui/halftone.gdshader), the names, VS in red, records and styles, the
## rules line, and a ticket-stub date bar. Look: the old boxing bill poster - cream paper, black ink, one red, halftone
## portraits, a ticket-stub date bar (Maria M32/M34 "B Fight poster", Game/Godot/research/M34_PITCH_PRESENTATION.md).
## Our corner is red on the left, the opponent blue on the right, turned to face her (the headshots are all shot 3/4 to
## the viewer's right).
##   build(c, f, w) -> Control (w wide, 1.45 x w tall) or null with no bout booked

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const HALFTONE := preload("res://assets/ui/halftone.gdshader")
const BEBAS := "res://assets/fonts/BebasNeue-Regular.ttf"
const FACES := "res://assets/ui/face"

const PAPER := Color("#f3ead6")
const INK := Color("#1b1918")
const RED := Color("#c8302a")
const TALL := 1.45


static func build(c: Career, f: Dictionary, w: float = 380.0) -> Control:
	var b: Dictionary = f.get("bout", {})
	if b.is_empty() or bool(b.get("done", false)):
		return null
	if not b.has("opp"):
		# S364 a bout with no opponent crashed grey_reason_test once in ~12 runs (writer not found yet): no poster, and the
		# keys go to the log so the next sighting names the writer.
		push_warning("FightPoster: %s's bout has no opponent: %s" % [f.get("first", "?"), b.keys()])
		return null
	var opp: Dictionary = b["opp"]
	var k := w / 380.0   # every size below is for a 380 px poster
	var p := PanelContainer.new()
	p.name = "FightPoster"
	p.custom_minimum_size = Vector2(w, w * TALL)
	p.add_theme_stylebox_override("panel", UI.box(PAPER, INK, 2, roundi(3 * k), roundi(18 * k), roundi(14 * k)))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := UI.vbox(roundi(4 * k))
	p.add_child(v)
	v.add_child(_text("%s PRESENTS" % c.gym_name.to_upper(), 15 * k, INK, true))
	v.add_child(_text("AMATEUR BOXING", 34 * k, RED, true))
	var faces := Faces.pair(f, opp)
	var row := UI.hbox(roundi(6 * k))
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_child(_face(str(faces[0]), false, 168 * k))
	row.add_child(_face(str(faces[1]), true, 168 * k))
	v.add_child(row)
	var names := UI.hbox(0)
	names.add_child(_side(str(f["name"]), "%d-%d  %s" % [int(f.get("w", 0)), int(f.get("l", 0)), str(f.get("style", ""))], k))
	var vs := _text("VS", 44 * k, RED, true)
	vs.custom_minimum_size = Vector2(46 * k, 0)
	names.add_child(vs)
	names.add_child(_side(str(opp["name"]), "%d-%d  %s" % [int(opp.get("w", 0)), int(opp.get("l", 0)), str(opp.get("style", ""))], k))
	v.add_child(names)
	var div: Dictionary = Data.DIVISIONS.get(f.get("div", ""), {})
	var sex := "MEN'S" if str(div.get("sex", "f")) == "m" else "WOMEN'S"
	v.add_child(_text("3 X 3 MIN  -  %s %s" % [sex, str(div.get("short", "%.0f KG" % float(f.get("limit", 0.0)))).to_upper()], 17 * k, INK, true))
	var gap := Control.new()
	gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(gap)
	v.add_child(_stub(Clock.fmt_long(int(b["day"])).to_upper(), "%s  -  doors 6 pm" % c.city, k))
	return p


## A halftone headshot; the blue corner flipped to face the red one.
static func _face(stem: String, flip: bool, size: float) -> Control:
	var r := TextureRect.new()
	r.custom_minimum_size = Vector2(size, size * 1.2)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var path := FACES.path_join(stem + ".jpg")
	if ResourceLoader.exists(path):
		r.texture = load(path)
	var m := ShaderMaterial.new()
	m.shader = HALFTONE
	m.set_shader_parameter("flip", flip)
	m.set_shader_parameter("cells", clampf(size / 3.2, 34.0, 90.0))   # a dot ~3 px wide at any poster size
	m.set_shader_parameter("paper", PAPER)
	m.set_shader_parameter("ink", INK)
	r.material = m
	return r


## A name in big condensed capitals over the record and style.
static func _side(name: String, sub: String, k: float) -> VBoxContainer:
	var s := UI.vbox(0)
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s.add_child(_text(name.to_upper().replace(" ", "\n"), 34 * k, INK, true))
	s.add_child(_text(sub, 13 * k, INK, false))
	return s


## The ticket stub: a dashed tear line, the date big, the place small.
static func _stub(date: String, place: String, k: float) -> VBoxContainer:
	var s := UI.vbox(roundi(2 * k))
	var tear := _text("- - - - - - - - - - - - - - - - - - - - - - - - -", 12 * k, INK, false)
	tear.clip_text = true
	s.add_child(tear)
	var band := PanelContainer.new()
	band.add_theme_stylebox_override("panel", UI.box(INK, Color(0, 0, 0, 0), 0, 0, roundi(10 * k), roundi(6 * k)))
	var bv := UI.vbox(0)
	band.add_child(bv)
	bv.add_child(_text(date, 26 * k, PAPER, true))
	bv.add_child(_text(place.to_upper(), 13 * k, Color(PAPER, 0.8), false))
	s.add_child(band)
	return s


static func _text(t: String, size: float, col: Color, display: bool) -> Label:
	var l := Label.new()
	l.text = t
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_color_override("font_color", col)
	l.add_theme_font_size_override("font_size", maxi(8, roundi(size)))
	l.add_theme_font_override("font", load(BEBAS) if display else UI.font("caps"))
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l
