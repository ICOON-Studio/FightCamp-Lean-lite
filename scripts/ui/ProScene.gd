extends RefCounted
## S544 (owner on the turning pro pop-up: "looks like spreadheet you need to use art"): the turning-pro moments are SCENES.
## The left of each pop-up is one picture: the signing office (assets/ui/art/sign_office.jpg, the belts on the wall, the
## ring behind the glass), the boxer standing in it (the full-body cut-out the roster uses), the promoter's ticket pinned
## top-left with who is calling, and the boxer's name and record on a plate at the foot. The right side holds the choice
## cards (ProOffer) or what changed (ProNews).
##   art(f, caption, size, ticket) -> Control      fact(icon, colour, big, small, tip) -> Control (a picture fact row)
##   header(path, title, colour, height) -> Control (a choice card's picture strip with its title over it)

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const ResultTiles := preload("res://scripts/ui/ResultTiles.gd")

const OFFICE := "res://assets/ui/art/sign_office.jpg"
const TICKET := "res://assets/ui/art/promoters/bow.png"
const RING := "res://assets/ui/art/title_ring.jpg"
const GYM := "res://assets/ui/art/gym_main.jpg"
const EMPTY_GYM := "res://assets/ui/art/gym_empty.jpg"


static func art(f: Dictionary, caption: String, size: Vector2, ticket: bool = true) -> Control:
	var box := Control.new()
	box.name = "ProSceneArt"
	box.custom_minimum_size = size
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.clip_contents = true
	box.add_child(MenuFx.art(OFFICE))
	box.add_child(_shade(0.30, 0.96))
	var body: Control = RosterCards.stance_body(f)
	if body != null:
		box.add_child(body)
		body.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		body.offset_top = 64.0
		body.offset_bottom = -64.0
		body.offset_left = -70.0
		body.offset_right = 70.0
		body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(_shade(0.72, 0.94))
	var top := UI.hbox(12)
	top.position = Vector2(18, 16)
	if ticket and ResourceLoader.exists(TICKET):
		var t := TextureRect.new()
		t.name = "PromoterTicket"
		t.texture = load(TICKET)
		t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		t.custom_minimum_size = Vector2(62, 92)
		t.rotation_degrees = -5.0
		top.add_child(t)
	var cap := UI.label(caption, UI.SMALL, Palette.TEXT, "caps", true)
	cap.name = "SceneCaption"
	cap.custom_minimum_size.x = size.x - 130.0   # beside the ticket, wrapped inside the picture
	cap.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	top.add_child(cap)
	box.add_child(top)
	var plate := UI.vbox(0)
	plate.name = "NamePlate"
	plate.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	plate.offset_left = 20.0
	plate.offset_right = -12.0
	plate.offset_top = -86.0
	plate.offset_bottom = -12.0
	var nm := str(f["name"]).to_upper()
	plate.add_child(UI.display(nm, clampi(int((size.x - 32.0) / (float(nm.length()) * 0.60)), 26, 44), Palette.TEXT))
	var rec := "Pro %d-%d  ·  amateur %d-%d" % [int(f.get("pro_w", 0)), int(f.get("pro_l", 0)), int(f["w"]), int(f["l"])] if bool(f.get("pro", false)) \
		else "Amateur %d-%d  ·  %s" % [int(f["w"]), int(f["l"]), str(f.get("wc", ""))]
	plate.add_child(UI.label(rec, UI.BODY, Palette.MUTED, "semi"))
	box.add_child(plate)
	return box


## A dark fade from `from` of the height down to the foot (the picture stays bright above it).
static func _shade(from: float, strength: float) -> TextureRect:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, from, 1.0])
	g.colors = PackedColorArray([Palette.alpha(Palette.PAGE, 0.0), Palette.alpha(Palette.PAGE, 0.0), Palette.alpha(Palette.PAGE, strength)])
	var tex := GradientTexture2D.new()
	tex.gradient = g
	tex.fill_from = Vector2(0, 0)
	tex.fill_to = Vector2(0, 1)
	tex.width = 8
	tex.height = 256
	var r := TextureRect.new()
	r.texture = tex
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_SCALE
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


## A choice card's picture strip: the painting, darkened at the foot, the choice's name over it.
static func header(path: String, title: String, colour: Color, height: float = 132.0) -> Control:
	var box := Control.new()
	box.name = "ChoiceArt"
	box.custom_minimum_size = Vector2(0, height)
	box.clip_contents = true
	if ResourceLoader.exists(path):
		box.add_child(MenuFx.art(path))
	box.add_child(_shade(0.15, 0.92))
	var t := UI.display(title, 38, colour)
	t.name = "ChoiceTitle"
	t.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	t.offset_left = 16.0
	t.offset_top = -52.0
	t.offset_bottom = -6.0
	box.add_child(t)
	return box


## One fact of a choice: a line icon, the fact big, one plain line under it; the detail is the hover.
static func fact(icon: String, colour: Color, big: String, small: String, tip: String = "") -> HBoxContainer:
	var h := UI.hbox(14)
	h.mouse_filter = Control.MOUSE_FILTER_STOP if tip != "" else Control.MOUSE_FILTER_IGNORE
	h.tooltip_text = tip
	h.add_child(ResultTiles.icon(icon, 34, colour))
	var v := UI.vbox(0)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var b := UI.label(big, 24, colour, "bold")
	b.name = "Big"
	v.add_child(b)
	if small != "":
		v.add_child(UI.label(small, UI.SMALL, Palette.MUTED, "semi", true))
	h.add_child(v)
	return h
