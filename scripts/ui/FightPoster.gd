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
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Region := preload("res://scripts/state/Region.gd")
const HALFTONE := preload("res://assets/ui/halftone.gdshader")
const BEBAS := "res://assets/fonts/BebasNeue-Regular.ttf"
const FACES := "res://assets/ui/face/poster"   # S387 tools/poster_faces.py: head and shoulders, backdrop keyed out, tones stretched

const INK := Color("#1b1918")
const TALL := 1.45
## S391 C237 ("needs some more info displayed like the rankings, and also a bit of variety like the ufc posters"): each bout
## draws its own paper, accent, headline and layout from its names, so a run of cards does not look like one card.
const LOOKS := [
	{"paper": Color("#f3ead6"), "accent": Color("#c8302a"), "head": "AMATEUR BOXING", "names_first": false},
	{"paper": Color("#e6ebee"), "accent": Color("#1f4f9c"), "head": "FIGHT NIGHT", "names_first": true},
	{"paper": Color("#f2e3b8"), "accent": Color("#1b1918"), "head": "%s FIGHT NIGHT", "names_first": false},
	{"paper": Color("#efe2dc"), "accent": Color("#8a1f3d"), "head": "MAIN EVENT", "names_first": true},
]
static var PAPER := Color("#f3ead6")
static var RED := Color("#c8302a")


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
	var look: Dictionary = LOOKS[posmod(hash(str(f.get("name", "")) + str(opp.get("name", "")) + str(b.get("day", 0))), LOOKS.size())]
	PAPER = look["paper"]
	RED = look["accent"]
	var k := w / 380.0   # every size below is for a 380 px poster
	var p := PanelContainer.new()
	p.name = "FightPoster"
	p.custom_minimum_size = Vector2(w, w * TALL)
	p.add_theme_stylebox_override("panel", UI.box(PAPER, INK, 2, roundi(3 * k), roundi(18 * k), roundi(14 * k)))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := UI.vbox(roundi(4 * k))
	p.add_child(v)
	v.add_child(_text("%s PRESENTS" % c.gym_name.to_upper(), 15 * k, INK, true))
	var head := "PRO DEBUT" if bool(f.get("pro", false)) and int(f.get("pro_w", 0)) + int(f.get("pro_l", 0)) == 0 else ("PROFESSIONAL BOXING" if bool(f.get("pro", false)) else str(look["head"]))
	v.add_child(_text((head % str(c.city).to_upper()) if head.contains("%s") else head, 34 * k, RED, true))
	var faces := Faces.pair(f, opp)
	var row := UI.hbox(roundi(6 * k))
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_child(_face(str(faces[0]), false, 168 * k))
	row.add_child(_face(str(faces[1]), true, 168 * k))
	var ranks := Region.rankings(c, str(f.get("div", "")))
	var names := UI.hbox(0)
	names.add_child(_side(str(f["name"]), _line(ranks, f), k))
	var vs := _text("VS", 44 * k, RED, true)
	vs.custom_minimum_size = Vector2(46 * k, 0)
	names.add_child(vs)
	names.add_child(_side(str(opp["name"]), _line(ranks, opp), k))
	for part in ([names, row] if bool(look["names_first"]) else [row, names]):
		v.add_child(part)
	var div: Dictionary = Data.DIVISIONS.get(f.get("div", ""), {})
	var sex := "MEN'S" if str(div.get("sex", "f")) == "m" else "WOMEN'S"
	v.add_child(_text("%d X 3 MIN  -  %s %s" % [int(b.get("rounds", BoutRules.ROUNDS)), sex, str(div.get("short", "%.0f KG" % float(f.get("limit", 0.0)))).to_upper()], 17 * k, INK, true))
	v.add_child(_text("CLUB TICKET CUT %s" % UI.money(BoutRules.TICKET_CUT), 15 * k, RED, true))
	var gap := Control.new()
	gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(gap)
	v.add_child(_stub(Clock.fmt_long(int(b["day"])).to_upper(), "%s  -  doors 6 pm" % c.city, k))
	return p


## Rank, record and style under a name.
static func _line(ranks: Array, who: Dictionary) -> String:
	var at := BoutRead.rank_of(ranks, str(who.get("name", "")))
	# S429 operator: "poster isnot centered correctly" - one long line a side made the poster wider than its slot, so the
	# right half was cut. The style goes on its own line and the line may wrap.
	var rec := "%d-%d
%s" % [int(who.get("w", 0)), int(who.get("l", 0)), str(who.get("style", ""))]
	return ("#%d  %s" % [at, rec]) if at > 0 else ("UNRANKED  %s" % rec)


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
	var under := _text(sub, 13 * k, INK, false)
	under.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	under.custom_minimum_size = Vector2(1, 0)
	s.add_child(under)
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
