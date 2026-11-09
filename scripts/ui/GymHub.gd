extends RefCounted
## S408 operator: "Yes, paint it", then "you need to make the gym make sense": the gym is the menu, drawn from its plan
## (GymPlan, IsoGym), so a door can only be where the plan puts it. Each place carries a pin and its name; clicking it goes
## there; a red pin says the place needs the player.
##   GymHub.build(main, career) -> Control   (S413: fills the window under the top bar)

const UI := preload("res://scripts/ui/UI.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const GymPlan := preload("res://scripts/rules/GymPlan.gd")
const IsoGym := preload("res://scripts/ui/IsoGym.gd")
const HubFigures := preload("res://scripts/ui/HubFigures.gd")
const GymPeople := preload("res://scripts/rules/GymPeople.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const HomeCorners := preload("res://scripts/ui/HomeCorners.gd")

const MIN_HEIGHT := 560.0
const ABOVE := 100.0   # the top bar and the page's top margin: the gym takes the rest of the window
const PIN := 56.0
const NAVY := Color(0.09, 0.14, 0.26, 0.92)
const TAG := Vector2(170, 104)
## S414 the owner: "why you do not use it exactly as it is ?", then "yes": the owner's own picture is the main screen, unchanged.
## The drawn gym (IsoGym) stays in the tree, hidden: GymPlan and the people still read it until the pin-and-slot build.
const PICTURE := "res://assets/ui/art/gym_main.jpg"
const PICTURE_SIZE := Vector2(1672, 941)
## Where each pin stands on the picture, as a share of its width and height.
const PIN_AT := {"reception": Vector2(0.2, 0.47), "training": Vector2(0.51, 0.63), "playbook": Vector2(0.855, 0.29),
	"fights": Vector2(0.685, 0.29), "office": Vector2(0.13, 0.32), "world": Vector2(0.27, 0.32)}
## id, name, icon, the zone kind the pin stands on ("" = the noticeboard).
const PLACES := [
	["reception", "Reception", "members", "reception"], ["training", "Fighters", "bag", "bags"], ["playbook", "Playbook", "mat", "mats"],
	["fights", "Fights", "champion", "ring"], ["office", "Club office", "money", "office"], ["world", "World", "up", ""],
]


static func build(main: Node, c: Career) -> Control:
	var hub := Control.new()
	hub.name = "GymHub"
	hub.custom_minimum_size = Vector2(0, maxf(MIN_HEIGHT, main.get_viewport().get_visible_rect().size.y - ABOVE))
	hub.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hub.clip_contents = true
	var plan: Dictionary = GymBonus.plan(c.gym_plan)
	var iso: Control = IsoGym.new()
	iso.name = "IsoGym"
	iso.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	iso.plan = plan
	iso.visible = false
	var picture := TextureRect.new()
	picture.name = "GymPicture"
	picture.texture = load(PICTURE)
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	picture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hub.add_child(picture)
	hub.add_child(iso)
	var figures: Control = HubFigures.new()
	figures.name = "HubFigures"
	figures.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var stems: Array = []
	for f in c.fighters:
		stems.append(Faces.stem(f))
	figures.setup(iso, plan, GymPeople.crowd(c.members, stems), hash(str(plan["id"])))
	figures.visible = false   # they walk the drawn floor, not the picture
	figures.process_mode = Node.PROCESS_MODE_DISABLED
	hub.add_child(figures)
	hub.add_child(MenuFx.dust(30))
	var spots: Array = []
	for p in PLACES:
		var s := _spot(main, c, p, iso, _zone(plan, str(p[3])))
		hub.add_child(s)
		spots.append(s)
	HomeCorners.add(hub, main, c)
	hub.resized.connect(func(): _lay(hub, spots))
	MenuFx.arrive(spots, 0.1, 0.05)
	return hub


static func _zone(plan: Dictionary, kind: String) -> Dictionary:
	for z in plan["zones"]:
		if str(z["kind"]) == kind:
			return z
	return {}


## The pins stand on the picture's rooms; the picture covers the hub, centred, so they follow it at any window size.
static func _lay(hub: Control, spots: Array) -> void:
	var k: float = maxf(hub.size.x / PICTURE_SIZE.x, hub.size.y / PICTURE_SIZE.y)
	var corner: Vector2 = (hub.size - PICTURE_SIZE * k) * 0.5
	for i in spots.size():
		var at: Vector2 = corner + (PIN_AT[str(PLACES[i][0])] as Vector2) * PICTURE_SIZE * k
		var s: Control = spots[i]
		s.size = TAG
		s.position = (at - TAG * 0.5).clamp(Vector2.ZERO, (hub.size - TAG).max(Vector2.ZERO))   # a window of another shape crops the picture: pins stay reachable


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


## One place: a pin and its name; under the mouse the pin grows and its zone lights up.
static func _spot(main: Node, c: Career, p: Array, iso: Control, z: Dictionary) -> Button:
	var id := str(p[0])
	var b := UI.button("", "", func(): _go(main, c, id))
	b.name = "Place_" + id
	var none := StyleBoxEmpty.new()
	for s in ["normal", "hover", "pressed", "focus", "disabled"]:
		b.add_theme_stylebox_override(s, none)
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
		iso.hot = str(z.get("id", "")) if on else ""
		pin.create_tween().tween_property(pin, "scale", Vector2.ONE * (1.18 if on else 1.0), 0.12).set_trans(Tween.TRANS_SINE)
	b.mouse_entered.connect(hover.bind(true))
	b.mouse_exited.connect(hover.bind(false))
	return b


## A round pin with the place's icon; red and pulsing when the place needs the player.
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
