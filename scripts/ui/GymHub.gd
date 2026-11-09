extends RefCounted
## S408 operator: "Yes, paint it": the gym is the menu. A painted side-on view of the club leads Home; each place carries a
## pin and its name, and clicking it goes there. The sunlight and dust move; a red count says a place needs you. The detail
## pages stay behind the places.
##   GymHub.build(main, career) -> Control   (fills the width, HEIGHT tall)

const UI := preload("res://scripts/ui/UI.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Settings := preload("res://scripts/state/Settings.gd")

const HEIGHT := 720.0
const ART_HIGH := 1344.0 / 2352.0   # the painting's height over its width
const PIN := 56.0
const EDGE := 150.0
const NAVY := Color(0.09, 0.14, 0.26, 0.92)
## id, name, icon, then the place on the painting as shares of its width and height: x, y, w, h.
const PLACES := [
	["reception", "Reception", "members"], ["training", "Fighters", "bag"], ["playbook", "Playbook", "mat"],
	["fights", "Fights", "champion"], ["office", "Club office", "money"], ["world", "World", "up"],
]
## S408 operator: "all 4 look nice", "maybe add option for player to select": four buildings, each with its places in PLACES' order.
const LAYOUTS := [
	[[0.10, 0.60, 0.11, 0.17], [0.53, 0.15, 0.115, 0.15], [0.46, 0.70, 0.18, 0.24], [0.40, 0.315, 0.205, 0.315], [0.21, 0.26, 0.11, 0.18], [0.365, 0.13, 0.105, 0.13]],
	[[0.29, 0.80, 0.08, 0.13], [0.17, 0.11, 0.25, 0.24], [0.58, 0.17, 0.18, 0.18], [0.385, 0.315, 0.24, 0.33], [0.17, 0.54, 0.10, 0.15], [0.03, 0.37, 0.135, 0.22]],
	[[0.62, 0.60, 0.13, 0.17], [0.21, 0.05, 0.25, 0.20], [0.13, 0.50, 0.22, 0.24], [0.39, 0.21, 0.22, 0.31], [0.68, 0.42, 0.20, 0.20], [0.03, 0.30, 0.17, 0.20]],
	[[0.28, 0.80, 0.10, 0.11], [0.56, 0.185, 0.19, 0.22], [0.615, 0.48, 0.18, 0.22], [0.29, 0.26, 0.23, 0.31], [0.05, 0.35, 0.16, 0.26], [0.44, 0.72, 0.115, 0.185]],
]


static func build(main: Node, c: Career) -> Control:
	var hub := Control.new()
	hub.name = "GymHub"
	hub.custom_minimum_size = Vector2(0, HEIGHT)
	hub.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hub.clip_contents = true
	var paper := ColorRect.new()   # the painting's own pale background, carried out to the page's edges
	paper.color = Color(0.93, 0.91, 0.95)
	paper.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hub.add_child(paper)
	var art := TextureRect.new()
	art.name = "Painting"
	var which := posmod(int(Settings.read()["gym_layout"]), LAYOUTS.size())
	art.texture = load("res://assets/ui/art/gym_hub_%d.jpg" % (which + 1))
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_SCALE
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hub.add_child(art)
	hub.add_child(_edge("EdgeL", paper.color, false))
	hub.add_child(_edge("EdgeR", paper.color, true))
	hub.add_child(MenuFx.rays(0.14))
	hub.add_child(MenuFx.dust(36))
	var spots: Array = []
	for p in PLACES:
		var s := _spot(main, c, p)
		hub.add_child(s)
		spots.append(s)
	var pick := UI.button("Layout %d of %d" % [which + 1, LAYOUTS.size()], "Btn", func():
		var d := Settings.read()
		d["gym_layout"] = (which + 1) % LAYOUTS.size()
		Settings.write(d)
		main.render())
	pick.name = "GymLayout"
	pick.tooltip_text = "Choose how your club is laid out"
	pick.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	pick.offset_left = -170
	pick.offset_top = 14
	pick.offset_right = -14
	hub.add_child(pick)
	hub.resized.connect(func(): _lay(hub, art, spots, which))
	MenuFx.arrive(spots, 0.1, 0.05)
	return hub


static func _edge(id: String, col: Color, flip: bool) -> TextureRect:
	var g := Gradient.new()
	g.colors = PackedColorArray([col, Color(col, 0.0)])
	var t := GradientTexture1D.new()
	t.gradient = g
	var r := TextureRect.new()
	r.name = id
	r.texture = t
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_SCALE
	r.flip_h = flip
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


static func _lay(hub: Control, art: Control, spots: Array, which: int) -> void:
	# The whole building shows: the painting fits the height and sits in the middle.
	var h := hub.size.y
	var w := h / ART_HIGH
	var x0 := (hub.size.x - w) * 0.5
	art.position = Vector2(x0, 0)
	art.size = Vector2(w, h)
	var edge := hub.find_child("EdgeL", false, false) as Control
	if edge != null:   # the painting's sides melt into the page
		edge.position = Vector2(x0 - 1.0, 0)
		edge.size = Vector2(EDGE, h)
		var right := hub.find_child("EdgeR", false, false) as Control
		right.position = Vector2(x0 + w - EDGE + 1.0, 0)
		right.size = Vector2(EDGE, h)
	for i in spots.size():
		var p: Array = LAYOUTS[which][i]
		var s: Control = spots[i]
		s.position = Vector2(x0 + float(p[0]) * w, float(p[1]) * h)
		s.size = Vector2(float(p[2]) * w, float(p[3]) * h)


static func _go(main: Node, c: Career, id: String) -> void:
	match id:
		"reception":
			if not c.applicant.is_empty():
				main.act("interview", "")
			else:
				main.nav({"area": "gym", "tab": 0})
		"training":
			main.act("area", "fighters")
		"playbook":
			main.act("area", "playbook")
		"fights":
			main.act("area", "fights")
		"office":
			main.nav({"area": "gym", "tab": 1})
		"world":
			main.nav({"area": "world", "tab": 1})


## How many things at this place want the player now.
static func needs(c: Career, id: String) -> int:
	return 1 if id == "reception" and not c.applicant.is_empty() else 0


## One place: the whole area lights up under the mouse; a pin and the place's name always show.
static func _spot(main: Node, c: Career, p: Array) -> Button:
	var id := str(p[0])
	var b := UI.button("", "", func(): _go(main, c, id))
	b.name = "Place_" + id
	var none := StyleBoxEmpty.new()
	for s in ["normal", "hover", "pressed", "focus", "disabled"]:
		b.add_theme_stylebox_override(s, none)
	var glow := Panel.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 1, 0.2)
	sb.border_color = Color.WHITE
	sb.set_border_width_all(4)
	sb.set_corner_radius_all(14)
	glow.add_theme_stylebox_override("panel", sb)
	glow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	glow.modulate.a = 0.0
	b.add_child(glow)
	var tag := UI.vbox(4)
	tag.alignment = BoxContainer.ALIGNMENT_CENTER
	tag.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	tag.grow_horizontal = Control.GROW_DIRECTION_BOTH
	tag.grow_vertical = Control.GROW_DIRECTION_BOTH
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(tag)
	var pin := _pin(str(p[2]), needs(c, id))
	pin.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	tag.add_child(pin)
	var plate := PanelContainer.new()
	var ps := StyleBoxFlat.new()
	ps.bg_color = NAVY
	ps.set_corner_radius_all(8)
	ps.set_content_margin_all(5)
	ps.content_margin_left = 12
	ps.content_margin_right = 12
	plate.add_theme_stylebox_override("panel", ps)
	plate.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.add_child(UI.label(str(p[1]), 22, Color.WHITE, "bold"))
	tag.add_child(plate)
	var hover := func(on: bool):
		var t := b.create_tween().set_parallel().set_trans(Tween.TRANS_SINE)
		t.tween_property(glow, "modulate:a", 1.0 if on else 0.0, 0.12)
		t.tween_property(pin, "scale", Vector2.ONE * (1.18 if on else 1.0), 0.12)
	b.mouse_entered.connect(hover.bind(true))
	b.mouse_exited.connect(hover.bind(false))
	return b


## A round pin with the place's icon; a red count when the place needs the player, and then it pulses.
static func _pin(icon: String, count: int) -> Control:
	var pin := Panel.new()
	pin.custom_minimum_size = Vector2(PIN, PIN)
	pin.pivot_offset = Vector2(PIN, PIN) * 0.5
	pin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = UI.RED if count > 0 else NAVY
	sb.border_color = Color.WHITE
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(int(PIN / 2.0))
	pin.add_theme_stylebox_override("panel", sb)
	var mark := KitIcon.icon(icon, 34, Color.WHITE)
	mark.position = Vector2(PIN - 34.0, PIN - 34.0) * 0.5
	mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pin.add_child(mark)
	if count > 0 and not MenuFx.instant:
		pin.ready.connect(func():
			var t := pin.create_tween().set_loops().set_trans(Tween.TRANS_SINE)
			t.tween_property(pin, "scale", Vector2.ONE * 1.14, 0.55)
			t.tween_property(pin, "scale", Vector2.ONE, 0.55))
	return pin
