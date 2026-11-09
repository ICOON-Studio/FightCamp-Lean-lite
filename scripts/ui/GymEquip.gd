extends RefCounted
## S415 operator on the weights area: "why there is no menu on this area ? what can be used for ?", and on the gym: "Yes, start small".
## The pieces a club owns stand on the empty room; in Equip mode the rest show as ghosts with a price, on the spot where they go.
##   GymEquip.standing(hub, c) -> Array   the owned pieces
##   GymEquip.ghosts(main, hub, c) -> Array   the rest, as buttons
##   GymEquip.bar(main, hub, c)   the strip that says what the floor holds, with Done
##   GymEquip.lay(items, corner, k)   each stands where it does on the picture

const UI := preload("res://scripts/ui/UI.gd")
const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymPlaces := preload("res://scripts/rules/GymPlaces.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")

const DIR := "res://assets/ui/art/gym_slots/%s.png"
const NAVY := Color(0.09, 0.14, 0.26, 0.92)
const GHOST := 0.38
const GHOST_HOT := 0.85


static func standing(hub: Control, c: Career) -> Array:
	var out: Array = []
	var have: Array = GymSlots.owned(c.gym_slots, c.day)
	for s in GymSlots.all():
		if have.has(str(s["id"])):
			var t := _picture(s)
			t.name = "Piece_" + str(s["id"])
			hub.add_child(t)
			out.append(t)
	return out


static func ghosts(main: Node, hub: Control, c: Career) -> Array:
	var out: Array = []
	var have: Array = GymSlots.owned(c.gym_slots, c.day)
	var coming: Array = GymSlots.fitting(c.gym_slots, c.day)
	for s in GymSlots.all():
		var id := str(s["id"])
		if not have.has(id):
			var g := _ghost(main, c, s, coming.has(id))
			hub.add_child(g)
			out.append(g)
	return out


static func lay(items: Array, corner: Vector2, k: float) -> void:
	for n in items:
		var s: Dictionary = n.get_meta("slot")
		n.position = corner + Vector2(float(s["x"]), float(s["y"])) * k
		n.size = Vector2(float(s["w"]), float(s["h"])) * k


static func bar(main: Node, hub: Control, c: Career) -> void:
	var plate := PanelContainer.new()
	plate.name = "EquipBar"
	var look := StyleBoxFlat.new()
	look.bg_color = NAVY
	look.set_corner_radius_all(8)
	look.set_content_margin_all(10)
	look.content_margin_left = 18
	look.content_margin_right = 12
	plate.add_theme_stylebox_override("panel", look)
	plate.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	plate.grow_horizontal = Control.GROW_DIRECTION_BOTH
	plate.offset_top = 10
	hub.add_child(plate)
	var row := UI.hbox(18)
	plate.add_child(row)
	row.add_child(UI.label("Equip the gym", 22, Color.WHITE, "bold"))
	var room := UI.label(_room(c), 17, Color.WHITE)
	room.name = "EquipRoom"
	room.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(room)
	var done := UI.button("Done", "Btn", main.act.bind("equipgym", "off"))
	done.name = "EquipDone"
	row.add_child(done)


static func _room(c: Career) -> String:
	var words := "%d places hold %d members. You have %d." % [GymSlots.places(c.gym_slots, c.day), GymSlots.member_room(c.gym_slots, c.day), c.members]
	if GymSpend.member_limit(c) == "equipment":
		words += " Your floor is full: nobody else can join."
	return words


static func _picture(s: Dictionary) -> TextureRect:
	var t := TextureRect.new()
	t.texture = load(DIR % str(s["id"]))
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_SCALE
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.set_meta("slot", s)
	return t


static func _ghost(main: Node, c: Career, s: Dictionary, coming: bool) -> Button:
	var id := str(s["id"])
	var why := "the fitters are in" if coming else GymSlots.blocked(id, c.gym_slots, c.cash)
	var b := UI.button("", "", main.act.bind("buyslot", id) if why == "" else func(): main.toast("Not now: %s." % why))
	b.name = "Ghost_" + id
	b.set_meta("slot", s)
	var none := StyleBoxEmpty.new()
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		b.add_theme_stylebox_override(state, none)
	var pic := _picture(s)
	pic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pic.modulate.a = GHOST
	b.add_child(pic)
	b.add_child(_price(s, why, coming))
	var more := int(s["places"])
	b.tooltip_text = "%s: %d more place%s, room for %d more members. The fitters take a week." % [s["name"], more, "" if more == 1 else "s", more * GymPlaces.MEMBERS_PER_PLACE]
	if why != "":
		b.tooltip_text += "\nNot now: %s." % why
	b.mouse_entered.connect(func(): pic.modulate.a = GHOST_HOT)
	b.mouse_exited.connect(func(): pic.modulate.a = GHOST)
	return b


static func _price(s: Dictionary, why: String, coming: bool) -> Control:
	var plate := PanelContainer.new()
	var look := StyleBoxFlat.new()
	look.bg_color = UI.RED if why != "" and not coming else NAVY
	look.set_corner_radius_all(6)
	look.content_margin_left = 8
	look.content_margin_right = 8
	look.content_margin_top = 2
	look.content_margin_bottom = 2
	plate.add_theme_stylebox_override("panel", look)
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	plate.grow_horizontal = Control.GROW_DIRECTION_BOTH
	plate.grow_vertical = Control.GROW_DIRECTION_BOTH
	plate.add_child(UI.label("Fitters in" if coming else UI.money(int(s["price"])), 16, Color.WHITE, "bold"))
	return plate
