extends VBoxContainer
## The game shell: top bar (back / forward, gym, date, speed, flags, decisions, cash, CONTINUE, menu), the left rail of five
## areas (PLAYER_PATH 6) with the club's mark, and one content pane holding the current area's scene.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const TopCards := preload("res://scripts/ui/TopCards.gd")
const FirstWeekStrip := preload("res://scripts/ui/FirstWeekStrip.gd")

const AREA_SCENES := {
	"home": preload("res://scenes/areas/Home.tscn"),
	"fighters": preload("res://scenes/areas/Fighters.tscn"),
	"fights": preload("res://scenes/areas/Fights.tscn"),
	"gym": preload("res://scenes/areas/Gym.tscn"),
	"money": preload("res://scenes/areas/Money.tscn"),
	"world": preload("res://scenes/areas/World.tscn"),
}

const HomeRows := preload("res://scripts/ui/HomeRows.gd")
const HomeNeeds := preload("res://scripts/ui/HomeNeeds.gd")
const RAIL_W := 214.0
const BADGE := "res://assets/ui/club_badge.svg"
const RAIL := [["home", "Home"], ["fighters", "Fighters"], ["fights", "Fights"], ["gym", "Club"], ["world", "World"]]

var _top: PanelContainer
var _guide: VBoxContainer   # S387 FirstWeekStrip, only while the first-week guide runs
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
	_guide = UI.vbox(0)
	var body := UI.hbox(0)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(body)
	var rail_panel := PanelContainer.new()
	rail_panel.theme_type_variation = "RailPanel"
	rail_panel.custom_minimum_size = Vector2(RAIL_W, 0)
	body.add_child(rail_panel)
	_rail = UI.vbox(4)
	rail_panel.add_child(_rail)
	# S397 rank 5 round 1 (blind: the guide strip ran the full width above the rail - double chrome): the guide is an inset
	# banner at the top of the workspace column, right of the rail.
	var col := UI.vbox(0)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(col)
	col.add_child(_guide)
	_scroll = ScrollContainer.new()
	_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(_scroll)
	_content = MarginContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for side in ["left", "right"]:
		_content.add_theme_constant_override("margin_" + side, 28)
	_content.add_theme_constant_override("margin_top", 22)
	_content.add_theme_constant_override("margin_bottom", 48)
	_scroll.add_child(_content)
	_gear_menu = PopupMenu.new()
	for item in ["Mail", "Save", "Load", "Settings", "Handbook", "Quit to title"]:
		_gear_menu.add_item(item)
	_gear_menu.id_pressed.connect(_on_gear)
	add_child(_gear_menu)


func refresh(main: Node) -> void:
	_main = main
	var scroll := _scroll.scroll_vertical
	_build_top(main)
	UI.clear(_guide)
	if main.career.guide != "":
		_guide.add_child(FirstWeekStrip.make(main))
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
	var h := UI.hbox(14)
	_top.add_child(h)
	# S398 menus (first-hour critics: "Back / Fwd look like a browser"): two small arrows, the words on hover.
	for nav in [["back", "<", "Back: the last page", "Nothing to go back to"], ["fwd", ">", "Forward again", "Nothing forward"]]:
		var nb := UI.button(str(nav[1]), "Ghost", main.act.bind(str(nav[0]), ""), (main.past if nav[0] == "back" else main.ahead).is_empty(), str(nav[3]))
		nb.name = "Nav_" + str(nav[0])
		nb.custom_minimum_size = Vector2(36, 36)
		nb.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		nb.add_theme_font_size_override("font_size", 20)
		if not nb.disabled:
			nb.tooltip_text = str(nav[2])
		h.add_child(nb)
	var gym := UI.label(c.gym_name, 32, UI.GOLD, "marker")
	gym.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(gym)
	var date := VBoxContainer.new()
	date.add_theme_constant_override("separation", 0)
	date.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	date.add_child(UI.label(Clock.fmt_long(c.day), UI.BODY, UI.FG, "semi"))
	date.add_child(UI.label("Week %d" % Clock.week_of(c.day), 15, UI.MUTED))
	date.name = "Date"
	date.custom_minimum_size = Vector2(176, 0)   # the speed buttons stay put as the date's length changes
	Tips.card(date, func(): return TopCards.date(main.career))   # S362 J90 6g
	h.add_child(date)
	# S397 blind rounds 3-4 ("Pause/1x/2x/3x beside CONTINUE reads as two time systems"): one clock - CONTINUE runs the
	# days and pauses them; how fast it runs is a setting (Menu > Settings, "Days run at").
	# S394 HOME shows every need itself, so the flags stay for the other pages.
	# S397 rank 5 round 1 (blind: "three alarm pills for one task"): while the guide runs, its banner owns the next step.
	if main.route["area"] != "home" and c.guide == "":
		for f in Needs.flags(c):
			var flag := UI.button(f["t"], "FlagRed" if f["red"] else "Flag", main.act.bind(f["act"], str(f.get("arg", ""))))
			flag.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			h.add_child(flag)
			_pulse(flag)
	h.add_child(UI.spacer())
	h.add_child(_cash(c))
	var g: Dictionary = Needs.go_state(c, main.running)
	var ink := Color.WHITE if g["cls"] == "GoBlock" else UI.GOLD_INK
	var cls: String = g["cls"]
	if cls == "GoBlock" and c.guide != "":   # S398 menus: while the guide runs it says the need; the button is not a red alarm
		cls = "Go"
		ink = UI.GOLD_INK
	if cls == "Go" and main.route["area"] == "home" and not HomeNeeds.pressing(c).is_empty():
		cls = "Btn"   # HOME's top need holds the page's one filled button; the clock still runs from here
		ink = UI.GOLD
	var go := UI.button2(g["t"], g["s"], cls, main.act.bind("go_btn", ""), Vector2(270, 54), ink, ink, false, UI.BODY, UI.TINY)
	go.name = "Go"
	# A long need ("Answer a bout offer: ...") trims with an ellipsis inside the button instead of running into the cash.
	for l in go.find_children("*", "Label", true, false):
		(l as Label).clip_text = true
		(l as Label).text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	go.tooltip_text = "%s: %s" % [g["t"], g["s"]]
	go.tooltip_text += "
Click again to pause. How fast the days run: Menu > Settings."
	h.add_child(go)
	_gear_menu.set_item_text(0, "Mail (%d new)" % c.unread if c.unread > 0 else "Mail")
	var gear := UI.button("Menu", "Ghost", _open_gear)   # S381 operator on "Gear": "???" - it is save/load/settings, not boxing gear
	gear.name = "Gear"
	gear.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(gear)
	for child in h.get_children():
		if child is Button and child.custom_minimum_size.y == 0:
			child.size_flags_vertical = Control.SIZE_SHRINK_CENTER


func _cash(c: Career) -> Control:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var ms := Needs.money_status(c)   # S324: coloured by GymBills (runway under 8 weeks amber, below $0 red)
	var cash := UI.label(UI.money(c.cash), 24, UI.RED if ms == "red" or ms == "closed" else (UI.AMBER if ms == "warn" else UI.GREEN), "bold")
	cash.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	v.add_child(cash)
	var net := Needs.money_net(c)
	# S397 blind round 5 ("$287 down this week" while the chart shows the week up): it is the running rate, said so.
	var line := UI.label("running %s%s a week" % ["+" if net >= 0 else "-", UI.money(absi(net))], 15, UI.MUTED)
	line.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	v.add_child(line)
	v.name = "Cash"
	Tips.card(v, func(): return TopCards.money(_main.career))   # S362 J90 6g: the week's money, Two Point's praised hover
	return v


func _pulse(node: CanvasItem) -> void:
	var t := node.create_tween().set_loops()
	t.tween_property(node, "modulate", Color(1, 1, 1, 0.7), 1.2).set_trans(Tween.TRANS_SINE)
	t.tween_property(node, "modulate", Color(1, 1, 1, 1.0), 1.2).set_trans(Tween.TRANS_SINE)


func _open_gear() -> void:
	var gear: Control = _top.find_child("Gear", true, false)
	var at := gear.get_screen_position() + Vector2(gear.size.x - 220, gear.size.y + 6)
	_gear_menu.popup(Rect2i(Vector2i(at), Vector2i(220, 0)))


func _on_gear(id: int) -> void:
	_main.act(["mail", "save", "load", "settings", "handbook", "title"][id], "")


func _build_rail(main: Node) -> void:
	UI.clear(_rail)
	var area: String = main.route["area"]
	for r in RAIL:
		var id: String = r[0]
		var on: bool = area == id or (id == "gym" and area == "money")
		var b := UI.button(r[1], "RailOn" if on else "Rail", main.act.bind("go", "gym:1") if id == "gym" else main.act.bind("area", id))
		b.name = "Rail_" + id
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.custom_minimum_size = Vector2(0, 52)
		b.add_theme_font_size_override("font_size", 19)
		_rail.add_child(b)
		if id == "fights":
			_offer_badge(b, main.career)
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 28)
	_rail.add_child(gap)
	_rail.add_child(_club_mark(main.career))


## The offers still to answer, a count on the Fights button.
func _offer_badge(b: Button, c: Career) -> void:
	var n := 0
	for f in c.fighters:
		n += HomeRows.open_offers(f).size()
	if n == 0:
		return
	var pill := PanelContainer.new()
	pill.theme_type_variation = "Badge"
	pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var l := UI.label(str(n), UI.TINY, Color.WHITE, "bold")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pill.add_child(l)
	pill.custom_minimum_size = Vector2(22, 22)
	pill.position = Vector2(RAIL_W - 50, 18)
	b.add_child(pill)


func _club_mark(c: Career) -> Control:
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 24)
	m.add_theme_constant_override("margin_right", 14)
	m.add_theme_constant_override("margin_bottom", 10)
	var v := UI.vbox(4)
	m.add_child(v)
	var badge := TextureRect.new()
	badge.texture = load(BADGE)
	badge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	badge.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	badge.custom_minimum_size = Vector2(74, 74)
	badge.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(badge)
	# S398 (operator: nothing the player cannot act on): the name is the top bar's, the members People's - the crest stays
	badge.tooltip_text = "%s, %d members" % [c.gym_name, c.members]
	badge.mouse_filter = Control.MOUSE_FILTER_STOP
	return m
