extends Control
## The title. S408 operator: "wtf is this screen", "make the fucking game look like a game not a website form", "do not make the
## gym like an old garage": a painted modern club fills the screen, sun and dust move in it, the name lands, the menu arrives
## on slanted plates that answer the mouse. No save: New career leads. With a save: Resume leads. The note on an item shows on hover.

const UI := preload("res://scripts/ui/UI.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")

const ITEM := Vector2(520, 66)
const NAVY := Color(0.09, 0.14, 0.26, 0.86)
const SLANT := 26.0


func build(main: Node) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(MenuFx.art("res://assets/ui/art/title_ring.jpg"))
	add_child(MenuFx.rays(0.2))
	add_child(MenuFx.dust())
	var col := UI.vbox(10)
	col.name = "TitleMenu"
	col.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	col.offset_left = 96
	col.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(col)
	var logo := UI.display("FIGHTCAMP", 138, UI.GOLD)
	logo.name = "Logo"
	logo.add_theme_color_override("font_outline_color", Color.WHITE)
	logo.add_theme_constant_override("outline_size", 14)
	logo.add_theme_color_override("font_shadow_color", Color(0.05, 0.08, 0.18, 0.55))
	logo.add_theme_constant_override("shadow_offset_x", 6)
	logo.add_theme_constant_override("shadow_offset_y", 8)
	col.add_child(logo)
	var line := UI.label("RUN A BOXING GYM.  BUILD A FIGHTER.  WIN ON SATURDAY.", 24, UI.FG, "bold")
	line.name = "Tagline"
	col.add_child(line)
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 22)
	col.add_child(gap)
	var saved := SaveGame.summary(main.save_path)
	var items: Array = [line]
	if saved != "":
		items.append(_item("Resume", "RESUME CAREER", saved, true, main.act.bind("load", "")))
	items.append(_item("NewCareer", "NEW CAREER", "your past, then your club", saved == "", main.act.bind("newcareer", "")))
	items.append(_item("QuickStart", "QUICK START", "a ready club in London", false, main.act.bind("quick", "")))
	if saved != "":
		items.append(_item("LoadCareer", "LOAD CAREER", "", false, main.act.bind("load", "")))
	items.append(_item("Settings", "SETTINGS", "", false, main.act.bind("settings", "")))
	items.append(_item("Credits", "CREDITS", "", false, main.act.bind("credits", "")))
	items.append(_item("Quit", "QUIT", "", false, main.act.bind("quit", "")))
	for it in items.slice(1):
		col.add_child(it)
	var tag := UI.label("EARLY ACCESS", 18, UI.FG, "bold")
	tag.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	tag.offset_left = 96
	tag.offset_top = -48
	add_child(tag)
	MenuFx.slam(logo)
	MenuFx.arrive(items, 0.42, 0.06)


## One menu line: a slanted plate; under the mouse a red plate sweeps across it, the words step right and the note fades in.
func _item(id: String, big: String, note: String, lead: bool, cb: Callable) -> Button:
	var b := UI.button("", "", cb)
	b.name = id
	b.custom_minimum_size = ITEM
	b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	var none := StyleBoxEmpty.new()
	for s in ["normal", "hover", "pressed", "focus", "disabled"]:
		b.add_theme_stylebox_override(s, none)
	var points := PackedVector2Array([Vector2.ZERO, Vector2(ITEM.x, 0), Vector2(ITEM.x - SLANT, ITEM.y), Vector2(0, ITEM.y)])
	var plate := Polygon2D.new()
	plate.polygon = points
	plate.color = UI.RED if lead else NAVY
	b.add_child(plate)
	var hot := Polygon2D.new()
	hot.polygon = points
	hot.color = UI.GOLD if lead else UI.RED
	hot.scale = Vector2(0.0, 1.0)
	b.add_child(hot)
	var words := UI.label(big, 34, Color.WHITE, "bold")
	words.position = Vector2(26, 11)
	words.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(words)
	var small := UI.label(note, 19, Color.WHITE, "semi")
	small.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
	small.offset_left = -300
	small.offset_right = -44
	small.grow_vertical = Control.GROW_DIRECTION_BOTH
	small.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	small.mouse_filter = Control.MOUSE_FILTER_IGNORE
	small.modulate.a = 0.0
	b.add_child(small)
	var go := func(on: bool):
		var t := b.create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		t.tween_property(hot, "scale:x", 1.0 if on else 0.0, 0.16)
		t.tween_property(words, "position:x", 44.0 if on else 26.0, 0.16)
		t.tween_property(small, "modulate:a", 1.0 if on else 0.0, 0.16)
	b.mouse_entered.connect(go.bind(true))
	b.mouse_exited.connect(go.bind(false))
	return b
