extends RefCounted
## S410 operator, Q-S294-134: "Build it like the right, painted surfaces" (docs/mockups/s409/concepts/roster_painted.png).
## FIGHTERS > Roster as a line of full-body cards on the painted gym, the corner flag saying what needs the player, and the
## scouted prospects underneath. The S396 sortable table stays one click away (Rank, The Road and Goal live there).
##   RosterCards.head(parent, main, c)   RosterCards.build(main, c)   RosterCards.body(stem)

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const RosterTable := preload("res://scripts/ui/RosterTable.gd")
const RosterFlag := preload("res://scripts/rules/RosterFlag.gd")
const CoachCheck := preload("res://scripts/rules/CoachCheck.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")

const BACKDROP := "res://assets/ui/art/gym_backdrop.jpg"
const CARD_PAINT := "res://assets/ui/art/card_paint.jpg"
const BODY_PATH := "res://assets/ui/art/fullbody/%s.png"

const CARD := Vector2(226, 524)
const ART_H := 330.0
const SHOWN_PROSPECTS := 4
## One colour per weight class, so a class reads at a glance.
const PALETTE := [Color("#c23b2e"), Color("#2a62c9"), Color("#b7791f"), Color("#178a96"), Color("#1c8a4b"), Color("#7a3fb0")]
const PAINT_LIFT := 1.75   # the paint is greyscale and multiplied: above 1 keeps the spot light bright
const PAPER := Color("#fff8ee")
const PAPER_DEEP := Color("#f4e9d7")
const EDGE := Color("#cdbba3")
const INK := Color("#231f1b")
const INK_SOFT := Color("#6e6256")
const CREAM := Color("#e9dfd2")
## tone -> [tile, ink]
const TILE := {
	"good": [Color("#dcf1e0"), Color("#1a7a42")], "ok": [Color("#dcf1e0"), Color("#1a7a42")],
	"watch": [Color("#fdecc9"), Color("#a96a08")], "bad": [Color("#f9d7d2"), Color("#bd2e22")],
	"muted": [Color("#efe7da"), Color("#6e6256")],
}

## "cards" or "table"; kept while the game runs.
static var view := "cards"


## The page's head on the painted gym: a white title, the tabs, and on the Roster the count and the Cards / Table switch.
static func head(parent: Container, main: Node, c: Career) -> void:
	var row := UI.hbox(14)
	row.name = "FightersHead"
	row.add_child(UI.display("Fighters", 56, Color.WHITE))
	var tabs: Array = Data.area("fighters")["tabs"]
	var now := int(main.route["tab"])
	for i in tabs.size():
		if str(tabs[i]) != "":
			row.add_child(_tab(str(tabs[i]), now == i, main.act.bind("tab", str(i))))
	row.add_child(UI.spacer())
	var count := c.fighters.size() + c.grapplers.size()
	if now == 0 and count > 0:
		var n := UI.label("%d fighter%s" % [count, "" if count == 1 else "s"], UI.BODY, CREAM, "semi")
		n.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(n)
		for pair in [["cards", "Cards"], ["table", "Table"]]:
			var b := _tab(str(pair[1]), view == str(pair[0]), _set_view.bind(main, str(pair[0])))
			b.name = "View_" + str(pair[0])
			row.add_child(b)
	parent.add_child(row)


static func _tab(text: String, on: bool, press: Callable) -> Button:
	var b := UI.button(text, "TabOn" if on else "Tab", press)
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if not on:   # the off tab's dark ink is lost on the painted gym
		b.add_theme_color_override("font_color", CREAM)
		b.add_theme_color_override("font_hover_color", Color.WHITE)
	return b


static func _set_view(main: Node, to: String) -> void:
	view = to
	main.render()


static func build(main: Node, c: Career) -> VBoxContainer:
	var v := UI.vbox(14)
	var line := HFlowContainer.new()
	line.name = "CardLine"
	line.add_theme_constant_override("h_separation", 8)
	line.add_theme_constant_override("v_separation", 12)
	for r in RosterTable.rows(c):
		line.add_child(_card(main, c, r))
	v.add_child(line)
	v.add_child(_scouted(main, c))
	return v


static func _card(main: Node, c: Career, r: Dictionary) -> Button:
	var id := str(r["id"])
	var grappler := bool(r["grappler"])
	var f: Dictionary = c.grappler_by_id(id) if grappler else c.fighter_by_id(id)
	var cells: Dictionary = r["cells"]
	var b := Button.new()   # S396's Row_<id>: the whole card opens the fighter's page
	b.name = "Row_" + id
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.custom_minimum_size = CARD
	b.pressed.connect(main.act.bind("fighter", id))
	for st in ["normal", "hover", "pressed", "focus"]:
		b.add_theme_stylebox_override(st, UI.box(PAPER, EDGE if st != "hover" else Color("#f2c14e"), 10, 3))
	MenuFx.hover_grow(b, 1.02)
	var v := UI.vbox(0)
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.offset_left = 3
	v.offset_top = 3
	v.offset_right = -3
	v.offset_bottom = -3
	v.add_child(_art(main, c, f, grappler, str(cells["rank"][0])))
	v.add_child(_plate(f, cells, grappler))
	v.add_child(_tiles(cells, grappler))
	v.add_child(_next(c, f, cells, grappler))
	b.add_child(v)
	_quiet(v)
	return b


## Only a tooltip or a button listens; everything else lets the click through to the card.
static func _quiet(root: Control) -> void:
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for n in root.find_children("*", "Control", true, false):
		if n is Button:
			continue
		(n as Control).mouse_filter = Control.MOUSE_FILTER_PASS if (n as Control).tooltip_text != "" else Control.MOUSE_FILTER_IGNORE


static func _art(main: Node, c: Career, f: Dictionary, grappler: bool, rank: String) -> Control:
	var art := Control.new()
	art.name = "Art"
	art.custom_minimum_size = Vector2(0, ART_H)
	art.clip_contents = true
	var wc := "No-gi" if grappler else str(f["wc"])
	var paint := _picture(CARD_PAINT, TextureRect.STRETCH_KEEP_ASPECT_COVERED)
	paint.name = "Paint"
	paint.modulate = weight_colour(wc) * Color(PAINT_LIFT, PAINT_LIFT, PAINT_LIFT, 1.0)
	art.add_child(paint)
	var pic := body(Faces.stem(f), Vector2(CARD.x, ART_H))
	if pic != null:
		pic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		pic.offset_top = 8
		art.add_child(pic)
	var tag := UI.label(wc.to_upper() + ("  " + rank if rank.begins_with("#") else ""), UI.TINY, Color.WHITE, "caps")
	tag.position = Vector2(9, 8)
	art.add_child(tag)
	if not grappler:
		var flag := RosterFlag.pick(CoachCheck.rows(c, f))
		if not flag.is_empty():
			art.add_child(_flag(main, f, flag))
	return art


static func _flag(main: Node, f: Dictionary, flag: Dictionary) -> Button:
	var b := UI.button(str(flag["word"]), "FlagRed" if bool(flag["red"]) else "Flag", func():
		if str(flag["act"]) == "ftab":
			main.route["fighter"] = str(f["id"])
		main.act(str(flag["act"]), str(flag["arg"])))
	b.name = "Flag_" + str(f["id"])
	b.anchor_left = 1.0
	b.anchor_right = 1.0
	b.offset_top = 36
	b.offset_right = -6
	b.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	return b


## The class's colour; a class not seen before still gets a steady one.
static func weight_colour(wc: String) -> Color:
	return PALETTE[absi(hash(wc)) % PALETTE.size()]


## Her full-body picture, or the face shot when the body has not been baked.
static func body(stem: String, size: Vector2 = Vector2.ZERO) -> Control:
	var path := BODY_PATH % stem
	if ResourceLoader.exists(path):
		var pic := _picture(path, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		pic.name = "Body"
		pic.custom_minimum_size = size
		return pic
	return PromoShot.picture(stem, size)


static func _picture(path: String, stretch: int) -> TextureRect:
	var r := TextureRect.new()
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = stretch
	r.texture = load(path)
	r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return r


static func _plate(f: Dictionary, cells: Dictionary, grappler: bool) -> Control:
	var v := UI.vbox(0)
	var nm := UI.label(str(f["name"]), 20, INK, "bold")
	nm.clip_text = true
	nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(nm)
	var third := str(f.get("belt", "white")).capitalize() + " belt" if grappler else str(f["stance"]).capitalize()
	v.add_child(UI.label("%s · %d · %s" % [str(cells["record"][0]), int(f.get("age", 0)), third], 15, INK_SOFT, "semi"))
	return _inset(v, 12, 8, 6)


static func _tiles(cells: Dictionary, grappler: bool) -> Control:
	var h := UI.hbox(4)
	h.name = "Tiles"
	var w: Array = cells["weight"]
	h.add_child(_tile("fresh", str(cells["condition"][0]), str(cells["condition"][2]), "Condition"))
	h.add_child(_tile("mood", str(cells["mood"][0]), str(cells["mood"][2]), "Mood"))
	if not grappler:
		h.add_child(_tile("weight", str(w[0]), str(w[2]), "kg against the class limit"))
	return _inset(h, 8, 2, 4)


static func _tile(icon: String, word: String, tone: String, what: String) -> Control:
	var look: Array = TILE.get(tone, TILE["ok"])
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(look[0], Color(0, 0, 0, 0), 8, 0, 2, 4))
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.custom_minimum_size = Vector2(0, 62)
	p.tooltip_text = "%s: %s" % [what, word.to_lower()]
	var v := UI.vbox(0)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	var ic := KitIcon.icon(icon, 20, look[1], p.tooltip_text)
	ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(ic)
	var l := UI.label(word, 13 if word.length() > 8 else UI.TINY, look[1], "bold")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.clip_text = true
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(l)
	p.add_child(v)
	return p


static func _next(c: Career, f: Dictionary, cells: Dictionary, grappler: bool) -> Control:
	var words := next_words(c, f, cells, grappler)
	var v := UI.vbox(0)
	v.name = "Next"
	v.add_child(UI.label(str(words[0]), 17, INK, "bold"))
	var small := UI.label(str(words[1]), UI.SMALL, INK_SOFT)
	small.clip_text = true
	small.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	small.tooltip_text = Injuries.line(c, f) if str(words[0]) == "Injured" else str(words[1])
	v.add_child(small)
	return _inset(v, 12, 4, 8)


## [bold line, small line] under the tiles.
static func next_words(c: Career, f: Dictionary, cells: Dictionary, grappler: bool) -> Array:
	if grappler:
		return [str(cells["next"][0]), str(cells["road"][0])]
	if Injuries.out(c, f):
		return ["Injured", "Back %s" % Clock.fmt(int(f["injury"]["until_day"]))]
	var b: Dictionary = f.get("bout", {})
	if b.has("day") and b.has("opp"):
		return ["%s · %d days" % [Clock.fmt(int(b["day"])), int(b["day"]) - c.day], "vs %s" % str(b["opp"]["name"])]
	for o in f.get("offers", []):
		if not bool(o["answered"]) and not bool(o["mismatch"]):
			return ["No bout", "Offer waiting"]
	return ["No bout", "Open Fights"]


static func _inset(child: Control, side: int, top: int, bottom: int) -> MarginContainer:
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", side)
	m.add_theme_constant_override("margin_right", side)
	m.add_theme_constant_override("margin_top", top)
	m.add_theme_constant_override("margin_bottom", bottom)
	m.add_child(child)
	return m


## The prospects waiting under Find a fighter; a click goes there (the invite and the ranges stay on that tab).
static func _scouted(main: Node, c: Career) -> Control:
	var p := PanelContainer.new()
	p.name = "ScoutedStrip"
	p.add_theme_stylebox_override("panel", UI.box(PAPER, EDGE, 10, 3))
	var h := UI.hbox(12)
	p.add_child(_inset(h, 16, 10, 10))
	var title := UI.display("Scouted\nfor you", 30, INK)
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(title)
	var open := c.prospects.filter(func(x): return str(x.get("state", "")) in ["scout", "invited"])
	for x in open.slice(0, SHOWN_PROSPECTS):
		h.add_child(_prospect(main, x))
	if open.is_empty():
		var none := UI.label("No prospects yet: Find a fighter sends the scout.", UI.BODY, INK_SOFT)
		none.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(none)
	return p


static func _prospect(main: Node, x: Dictionary) -> Button:
	var b := Button.new()
	b.name = "Scout_" + str(x["id"])
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.custom_minimum_size = Vector2(0, 156)
	b.pressed.connect(main.act.bind("go", "fighters:3"))
	for st in ["normal", "hover", "pressed", "focus"]:
		b.add_theme_stylebox_override(st, UI.box(PAPER_DEEP, Color(0, 0, 0, 0) if st != "hover" else EDGE, 10, 2))
	var h := UI.hbox(10)
	h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var pic := body(Faces.stem(x), Vector2(112, 150))
	if pic != null:
		pic.set_anchors_preset(Control.PRESET_TOP_LEFT)
		h.add_child(pic)
	var v := UI.vbox(1)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(UI.label(str(x["name"]), 20, INK, "bold"))
	v.add_child(UI.label("%d, %s, %d-%d" % [int(x["age"]), str(x["wc"]), int(x["w"]), int(x["l"])], 15, INK_SOFT))
	var note := UI.label(str(x["note"]), 15, INK_SOFT, "body", true)
	note.max_lines_visible = 2
	note.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(note)
	var invited := str(x.get("state", "")) == "invited"
	var pill := UI.chip("Trial %s" % Clock.fmt(int(x["trial_day"])) if invited else str(x["style"]), "gold")
	pill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(pill)
	h.add_child(v)
	if not invited:   # a trial is free, so it can be asked for from here; the ranges stay on Find a fighter
		var ask := UI.button("Invite to a trial", "BtnSolid", main.act.bind("invite", str(x["id"])))
		ask.name = "StripInvite_" + str(x["id"])
		ask.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(ask)
	b.add_child(h)
	_quiet(h)
	return b
