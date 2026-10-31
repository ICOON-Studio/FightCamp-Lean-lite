extends VBoxContainer
## The game shell: top bar (back / forward, gym, flags, date, speed, CONTINUE, cash, mail, gear), the left rail of six
## areas, and one content pane holding the current area's scene.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Needs := preload("res://scripts/state/Needs.gd")

const AREA_SCENES := {
	"home": preload("res://scenes/areas/Home.tscn"),
	"fighters": preload("res://scenes/areas/Fighters.tscn"),
	"fights": preload("res://scenes/areas/Fights.tscn"),
	"gym": preload("res://scenes/areas/Gym.tscn"),
	"money": preload("res://scenes/areas/Money.tscn"),
	"world": preload("res://scenes/areas/World.tscn"),
}

var _top: PanelContainer
var _rail: VBoxContainer
var _scroll: ScrollContainer
var _content: MarginContainer
var _gear_menu: PopupMenu
var _main: Node


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_theme_constant_override("separation", 0)
	_top = PanelContainer.new()
	_top.theme_type_variation = "TopBar"
	add_child(_top)
	var body := UI.hbox(0)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(body)
	var rail_panel := PanelContainer.new()
	rail_panel.theme_type_variation = "RailPanel"
	rail_panel.custom_minimum_size = Vector2(214, 0)
	body.add_child(rail_panel)
	_rail = UI.vbox(4)
	rail_panel.add_child(_rail)
	_scroll = ScrollContainer.new()
	_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	body.add_child(_scroll)
	_content = MarginContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for side in ["left", "right"]:
		_content.add_theme_constant_override("margin_" + side, 28)
	_content.add_theme_constant_override("margin_top", 22)
	_content.add_theme_constant_override("margin_bottom", 48)
	_scroll.add_child(_content)
	_gear_menu = PopupMenu.new()
	for item in ["Save", "Load", "Settings", "Handbook", "Quit to title"]:
		_gear_menu.add_item(item)
	_gear_menu.id_pressed.connect(_on_gear)
	add_child(_gear_menu)


func refresh(main: Node) -> void:
	_main = main
	var scroll := _scroll.scroll_vertical
	_build_top(main)
	_build_rail(main)
	UI.clear(_content)
	var area: Node = AREA_SCENES[main.route["area"]].instantiate()
	_content.add_child(area)
	area.build(main)
	_scroll.set_deferred("scroll_vertical", scroll)


func scroll_top() -> void:
	_scroll.set_deferred("scroll_vertical", 0)


func _build_top(main: Node) -> void:
	UI.clear(_top)
	var c: Career = main.career
	var h := UI.hbox(12)
	_top.add_child(h)
	h.add_child(UI.button("Back", "Ghost", main.act.bind("back", ""), main.past.is_empty()))
	h.add_child(UI.button("Fwd", "Ghost", main.act.bind("fwd", ""), main.ahead.is_empty()))
	var gym := UI.display(c.gym_name.to_upper(), 30)
	gym.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(gym)
	for f in Needs.flags(c):
		var flag := UI.button(f["t"], "FlagRed" if f["red"] else "Flag", main.act.bind(f["act"], str(f.get("arg", ""))))
		flag.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(flag)
		_pulse(flag)
	h.add_child(UI.spacer())
	var date := VBoxContainer.new()
	date.add_theme_constant_override("separation", 0)
	date.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var d1 := UI.mono(Clock.fmt_long(c.day), UI.BODY)
	d1.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	date.add_child(d1)
	var d2 := UI.label("Week %d" % Clock.week_of(c.day), UI.TINY, UI.MUTED)
	d2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	date.add_child(d2)
	h.add_child(date)
	var speed := UI.hbox(4)
	speed.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var pause_b := UI.button("II", "Speed" if main.running else "SpeedOn", main.act.bind("pausebtn", ""))
	pause_b.custom_minimum_size = Vector2(40, 0)
	speed.add_child(pause_b)
	for n in [1, 2, 3]:
		var sb := UI.button(">".repeat(n), "SpeedOn" if main.speed == n else "Speed", main.act.bind("speed", str(n)))
		sb.custom_minimum_size = Vector2(40, 0)
		speed.add_child(sb)
	h.add_child(speed)
	var g: Dictionary = Needs.go_state(c, main.running)
	var ink := Color.WHITE if g["cls"] == "GoBlock" else UI.GOLD_INK
	var go := UI.button2(g["t"], g["s"], g["cls"], main.act.bind("go_btn", ""), Vector2(290, 58), ink, ink, false, UI.BODY, UI.TINY)
	go.name = "Go"
	# A long need ("Answer a bout offer: ...") trims with an ellipsis inside the button instead of running into the cash.
	for l in go.find_children("*", "Label", true, false):
		(l as Label).clip_text = true
		(l as Label).text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	go.tooltip_text = "%s: %s" % [g["t"], g["s"]]
	h.add_child(go)
	var ms := Needs.money_status(c)   # S324: coloured by GymBills (runway under 8 weeks amber, below $0 red)
	var cash := UI.mono(UI.money(c.cash), 21, UI.RED if ms == "red" or ms == "closed" else (UI.AMBER if ms == "warn" else UI.FG))
	cash.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(cash)
	var mail := UI.button("Mail", "Ghost", main.act.bind("mail", ""))
	if c.unread > 0:
		# The count sits in a red pill inside the button, right of the word.
		mail.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var pill := PanelContainer.new()
		pill.theme_type_variation = "Badge"
		pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var n := UI.label(str(c.unread), UI.TINY, Color.WHITE, "bold")
		n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		pill.add_child(n)
		pill.custom_minimum_size = Vector2(22, 20)
		mail.add_child(pill)
		mail.custom_minimum_size = Vector2(86, 0)
		pill.position = Vector2(56, 9)
	mail.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(mail)
	var gear := UI.button("Gear", "Ghost", _open_gear)
	gear.name = "Gear"
	gear.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(gear)
	for child in h.get_children():
		if child is Button and child.custom_minimum_size.y == 0:
			child.size_flags_vertical = Control.SIZE_SHRINK_CENTER


func _pulse(node: CanvasItem) -> void:
	var t := node.create_tween().set_loops()
	t.tween_property(node, "modulate", Color(1, 1, 1, 0.7), 1.2).set_trans(Tween.TRANS_SINE)
	t.tween_property(node, "modulate", Color(1, 1, 1, 1.0), 1.2).set_trans(Tween.TRANS_SINE)


func _open_gear() -> void:
	var gear: Control = _top.find_child("Gear", true, false)
	var at := gear.get_screen_position() + Vector2(gear.size.x - 220, gear.size.y + 6)
	_gear_menu.popup(Rect2i(Vector2i(at), Vector2i(220, 0)))


func _on_gear(id: int) -> void:
	_main.act(["save", "load", "settings", "handbook", "title"][id], "")


func _build_rail(main: Node) -> void:
	UI.clear(_rail)
	for a in Data.AREAS:
		var on: bool = main.route["area"] == a["id"]
		var b := UI.button2(a["name"], a["job"], "RailOn" if on else "Rail", main.act.bind("area", a["id"]), Vector2(0, 62),
			UI.GOLD if on else UI.MUTED, UI.MUTED, false, 17, UI.TINY)
		_rail.add_child(b)
