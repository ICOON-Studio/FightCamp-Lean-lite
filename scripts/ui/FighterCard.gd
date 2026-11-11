extends RefCounted
## S369 (the S367 critic: "a list in the top fifth of an empty page" - Fighters > Training, Fight camps, Fights > Offers;
## fix 2 "two columns, cards, the fighter's face"): one fighter as a card for a management tab - her face photo on the
## left, her name and record on top, then the tab's own lines under them (build returns the column to fill).

const UI := preload("res://scripts/ui/UI.gd")
const HomeBoard := preload("res://scripts/ui/HomeBoard.gd")
const FaceFrame := preload("res://scripts/ui/FaceFrame.gd")
const Bar := preload("res://scripts/ui/Bar.gd")
const RankRow := preload("res://scripts/ui/RankRow.gd")

const FACE := Vector2(132, 166)


## [the card, the column beside her face to fill]. `tag` names the card (tag_<id>) so tools and tests can find it.
static func build(main: Node, f: Dictionary, tag: String) -> Array:
	var p := PanelContainer.new()
	p.theme_type_variation = "Card"
	p.name = "%s_%s" % [tag, str(f["id"])]
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var h := UI.hbox(18)
	p.add_child(h)
	h.add_child(face(f))
	var v := UI.vbox(10)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(v)
	var top := UI.hbox(12)
	var name := UI.button(str(f["name"]), "Link", main.act.bind("fighter", str(f["id"])))
	name.add_theme_font_size_override("font_size", UI.BODY + 5)
	top.add_child(name)
	top.add_child(UI.label(record(f), 26, UI.GOLD, "bold"))
	top.add_child(UI.spacer())
	if int(f.get("rank", 0)) > 0:
		top.add_child(UI.chip("#%d IN THE REGION" % int(f["rank"]), "gold"))
	v.add_child(top)
	var c: Career = main.get("career")
	var standing: Control = RankRow.build(c, f)
	if standing != null:
		v.add_child(standing)
	return [p, v]


static func record(f: Dictionary) -> String:
	if str(f.get("sport", "")) == "bjj":
		return "%d-%d opens" % [int(f.get("w", 0)), int(f.get("l", 0))]   # S376: a no-gi athlete's record is her opens
	if bool(f.get("pro", false)):
		var pd := int(f.get("pro_d", 0))   # S397: draws count (a 0-0 pro with a draw read as unbeaten and unfought)
		return "%d-%d%s pro" % [int(f.get("pro_w", 0)), int(f.get("pro_l", 0)), "-%d" % pd if pd > 0 else ""]
	return "%d-%d amateur" % [int(f["w"]), int(f["l"])]


## Her face photo (HomeBoard's portrait: the face shot, else a render of her model), the whole head in the frame.
static func face(f: Dictionary) -> Control:
	var r := TextureRect.new()
	r.name = "Face"
	r.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.texture = HomeBoard.portrait(f)
	if r.texture != null:
		FaceFrame.fit(r, FaceFrame.box_for(r.texture), FACE)
		HomeBoard.PromoShot.live(r)
	else:
		r.custom_minimum_size = FACE
	return r


## Two cards to a row.
static func grid(name: String) -> GridContainer:
	var g := GridContainer.new()
	g.name = name
	g.columns = 2
	g.add_theme_constant_override("h_separation", 16)
	g.add_theme_constant_override("v_separation", 16)
	return g


## A caps head, its value in bold, then a bar filled to `frac` with a short note beside it (whole numbers only).
static func meter(head: String, value: String, frac: float, note: String, col: Color) -> VBoxContainer:
	var box := UI.vbox(4)
	var line := UI.hbox(10)
	line.add_child(UI.caps(head))
	line.add_child(UI.label(value, UI.BODY, UI.FG, "bold"))
	box.add_child(line)
	var row := UI.hbox(10)
	var bar := Bar.new()
	bar.custom_minimum_size = Vector2(220, 12)
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bar.fill = col
	bar.name = "Bar"
	# Every meter grows in (operator: animated meters).
	bar.ready.connect(func(): bar.create_tween().tween_property(bar, "frac", clampf(frac, 0.0, 1.0), 0.5).from(0.0))
	row.add_child(bar)
	row.add_child(UI.label(note, UI.SMALL, col if col != UI.MUTED else UI.FG))
	box.add_child(row)
	return box
