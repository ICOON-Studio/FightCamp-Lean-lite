extends RefCounted
## The head of every area: big name, an optional extra, then its one row of tabs (S331: no job line - operator "remove these texts").

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")

const CLUB := ["gym", "money"]


## S384 `tab_row` false: no tab row at all (Ana's Playbook is one page, design GAMETREE1 7).
## `one_row` (Money only): the area name and its tabs share one row, at most 48 px. Every other area stays as it is.
static func add(parent: Container, main: Node, area_id: String, extra: Array = [], tabs_on: bool = true, tab_row: bool = true, one_row: bool = false) -> void:
	if one_row:
		_one_row(parent, main, area_id, tabs_on)
		return
	var a := Data.area(area_id)
	var head := UI.hbox(16)
	var h1 := UI.display(a["name"], 52)
	head.add_child(h1)
	for e in extra:
		(e as Control).size_flags_vertical = Control.SIZE_SHRINK_CENTER
		head.add_child(e)
	parent.add_child(head)
	var tabs: Array = a["tabs"]
	if tabs.is_empty() or not tab_row:
		return
	var row := UI.hbox(4)
	if CLUB.has(area_id):
		_club_tabs(row, main, tabs_on)
	else:
		for i in tabs.size():
			if str(tabs[i]) == "":   # S396 a folded tab (Routes.gd)
				continue
			var on: bool = tabs_on and int(main.route["tab"]) == i and str(main.route.get("fighter", "")) == ""
			row.add_child(UI.button(tabs[i], "TabOn" if on else "Tab", main.act.bind("tab", str(i))))
	parent.add_child(row)
	var line := ColorRect.new()
	line.color = UI.LINE
	line.custom_minimum_size = Vector2(0, 1)
	parent.add_child(line)


## S394 PLAYER_PATH 6: one Club on the rail. The gym's and the money's tabs sit in one row and keep their routes (gym:1, money:0).
## S396 screen cut: People | Money | Records, in that order across the two areas.
const CLUB_ORDER := [["gym", 1], ["money", 0], ["gym", 4]]


## CLUB and People, Money, Records on one short row. Used only by the books page.
static func _one_row(parent: Container, main: Node, area_id: String, tabs_on: bool) -> void:
	var a := Data.area(area_id)
	var row := UI.hbox(8)
	row.name = "ClubHead"
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.custom_minimum_size = Vector2(0, 32)
	var title := UI.label(str(a["name"]), 20, UI.FG, "display")
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(title)
	if tabs_on and CLUB.has(area_id):
		_club_tabs(row, main, true)
	elif tabs_on:
		var tabs: Array = a["tabs"]
		for i in tabs.size():
			if str(tabs[i]) == "":
				continue
			var on: bool = int(main.route["tab"]) == i and str(main.route.get("fighter", "")) == ""
			row.add_child(UI.button(tabs[i], "TabOn" if on else "Tab", main.act.bind("tab", str(i))))
	for child in row.get_children():
		if child is Button:
			_short_tab(child as Button)
	parent.add_child(row)


static func _short_tab(b: Button) -> void:
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	b.add_theme_font_size_override("font_size", 15)
	b.ready.connect(func(): _tighten_tab(b), CONNECT_ONE_SHOT)   # the theme is only reachable in the tree


static func _tighten_tab(b: Button) -> void:
	for state in ["normal", "hover", "pressed", "disabled"]:
		var sb := b.get_theme_stylebox(state)
		if sb is StyleBoxFlat:
			var copy := (sb as StyleBoxFlat).duplicate() as StyleBoxFlat
			copy.content_margin_top = 2
			copy.content_margin_bottom = 2
			copy.content_margin_left = 10
			copy.content_margin_right = 10
			b.add_theme_stylebox_override(state, copy)


static func _club_tabs(row: Container, main: Node, tabs_on: bool) -> void:
	for pair in CLUB_ORDER:
		var id := str(pair[0])
		var i := int(pair[1])
		var tabs: Array = Data.area(id)["tabs"]
		var now := int(main.route["tab"])
		var on: bool = tabs_on and main.route["area"] == id and (now == i or (id == "gym" and now == 0 and i == 1))
		row.add_child(UI.button(tabs[i], "TabOn" if on else "Tab", main.act.bind("go", "%s:%d" % [id, i])))


## "Comes in week N" placeholder card.
static func placeholder(parent: Container, title: String, text: String) -> void:
	var c := UI.card(title)
	c[1].add_child(UI.muted(text, UI.BODY, true))
	parent.add_child(c[0])
