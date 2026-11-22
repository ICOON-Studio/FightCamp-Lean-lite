extends RefCounted
## OFFICEV2 (S538, owner Q-S294-302: "the fighters and coaches screens inside the desktop , could they be like excel sheets
## and when plqayer right clicks on a name can do various actions"; mockups ops/previews/s538_look/office_sheets.png and
## office_sheets_menu.png). The two sheets the office's Fighters and Staff icons open inside the desktop: one row a person,
## a click on a heading sorts by it (again = the other way), "Columns" picks which columns show, a right-click on a row
## opens OfficeMenu's actions, a left click opens the page the row already had. Rows come from OfficeDesk (a pure read).
##   build(main) -> "OfficeSheets"     sorted(kind, rows) / shown(kind) / toggle(kind, col) / sort_by(kind, col): the state
##   Nodes: Sheet_<kind>, Sort_<kind>_<col>, Columns_<kind>, Row_<kind>_<id>; the chooser "OfficeColumns" holds Col_<col>.

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const Bar := preload("res://scripts/ui/Bar.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const Tip := preload("res://scripts/ui/Tip.gd")
const OfficeDesk := preload("res://scripts/ui/OfficeDesk.gd")
const OfficeMenu := preload("res://scripts/ui/OfficeMenu.gd")

## kind -> [[id, heading, width]]
const COLS := {
	"fighters": [["fighter", "Fighter", 200], ["class", "Class", 122], ["record", "Record", 84], ["rank", "Rank", 96], ["road", "The road", 130],
		["next", "Next", 180], ["weight", "Weight", 110], ["condition", "Condition", 110], ["stamina", "Stamina", 118], ["mood", "Mood", 108],
		["goal", "Goal", 214], ["stipend", "Stipend", 130], ["rating", "Rating", 78], ["ready", "Ready for the bout", 180], ["age", "Age", 60],
		["style", "Style and stance", 160]],
	"staff": [["name", "Name", 200], ["job", "Job", 316], ["status", "Status", 120], ["pay", "Pay", 230], ["runs", "Runs", 262],
		["areas", "Pads · Bag · Spar · Cond · Str", 240], ["changes", "What it changes", 0]],
}
const AREAS := ["pads", "bag", "sparring", "conditioning", "strength"]
const TONE := {"ok": Palette.TEXT, "good": Palette.GOOD, "watch": Palette.WARN, "bad": Palette.BAD, "muted": Palette.MUTED}
const STATUS_BG := {"good": Palette.GOOD_FILL, "watch": Palette.WARN, "muted": Palette.TILE}
const TITLE := {"fighters": "Fighters", "staff": "Staff"}

## Kept while the game runs ("the sheet remembers").
static var sort := {"fighters": ["next", false], "staff": ["status", false]}
static var hidden := {"fighters": ["rating", "ready", "age", "style"], "staff": []}


static func shown(kind: String) -> Array:
	return (COLS[kind] as Array).filter(func(k): return not (hidden[kind] as Array).has(str(k[0])))


## A column on or off; the first column (the name) always stays.
static func toggle(kind: String, col: String) -> void:
	var off: Array = hidden[kind]
	if off.has(col):
		off.erase(col)
	elif col != str(COLS[kind][0][0]):
		off.append(col)
		if str(sort[kind][0]) == col:
			sort[kind] = [str(COLS[kind][0][0]), false]


static func sort_by(kind: String, col: String) -> void:
	sort[kind] = [col, (not bool(sort[kind][1])) if str(sort[kind][0]) == col else false]


static func sorted(kind: String, rows: Array) -> Array:
	var col := str(sort[kind][0])
	var down := bool(sort[kind][1])
	var out := rows.duplicate()
	out.sort_custom(func(a, b):
		var x: Variant = a["cells"][col][1]
		var y: Variant = b["cells"][col][1]
		if typeof(x) != typeof(y):
			x = str(x)
			y = str(y)
		return (x > y) if down else (x < y))
	return out


static func build(main: Node) -> Control:
	var c: Career = main.career
	var v := UI.vbox(16)
	v.name = "OfficeSheets"
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var fighters: Array = OfficeDesk.fighter_sheet(c)
	v.add_child(_sheet(main, "fighters", fighters, "%d on the books" % fighters.size() if not fighters.is_empty() else "nobody signed yet: the walk-in waits at reception"))
	var staff: Array = OfficeDesk.staff_sheet(c)
	var here := staff.filter(func(r): return str(r["cells"]["status"][0]) == "At the club").size()
	var jobs := staff.filter(func(r): return str(r["cells"]["status"][0]) == "Job open").size()
	var card := _sheet(main, "staff", staff, "%d at the club · %d job%s open" % [here, jobs, "" if jobs == 1 else "s"])
	v.add_child(card)
	return v


static func _sheet(main: Node, kind: String, rows: Array, count: String) -> Control:
	var p := PanelContainer.new()
	p.name = "Sheet_" + kind
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(Palette.CARD, Palette.LINE, 10, 1, 12, 12))
	var v := UI.vbox(6)
	p.add_child(v)
	var cols := shown(kind)
	var head := UI.hbox(10)
	head.add_child(UI.label(str(TITLE[kind]).to_upper(), 20, Palette.HEADER, "caps"))
	var by: Array = (COLS[kind] as Array).filter(func(k): return str(k[0]) == str(sort[kind][0]))
	head.add_child(UI.label("%s · sorted by %s%s" % [count, str(by[0][1]).to_lower() if not by.is_empty() else "", ", high first" if bool(sort[kind][1]) else ""],
		16, Palette.MUTED, "semi"))
	head.add_child(UI.spacer())
	head.add_child(UI.label("%d columns shown of %d" % [cols.size(), (COLS[kind] as Array).size()], 16, Palette.MUTED))
	var pick := _plain_button("Columns ▾", Palette.SECOND, Palette.HEADER)
	pick.name = "Columns_" + kind
	Tip.button(pick, "Pick which columns this sheet shows; it remembers.")
	pick.pressed.connect(func(): open_columns(main, kind, pick.get_global_rect().position + Vector2(pick.size.x - 250.0, pick.size.y + 4.0)))
	head.add_child(pick)
	v.add_child(head)
	var scroll := ScrollContainer.new()
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(scroll)
	var table := UI.vbox(0)
	table.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(table)
	var heads := UI.hbox(0)
	heads.add_child(_fixed(Control.new(), 34))
	for col in cols:
		var id := str(col[0])
		var on := str(sort[kind][0]) == id
		var b := _plain_button(str(col[1]).to_upper() + ((" ▼" if bool(sort[kind][1]) else " ▲") if on else ""), Palette.PAGE, Palette.LINE,
			Palette.HEADER if on else Palette.MUTED)
		b.name = "Sort_%s_%s" % [kind, id]
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.clip_text = true
		_fixed(b, int(col[2]))
		b.pressed.connect(func():
			sort_by(kind, id)
			main.render())
		heads.add_child(b)
	table.add_child(heads)
	var ordered := sorted(kind, rows)
	for i in ordered.size():
		table.add_child(_row(main, kind, ordered[i], i, cols))
	return p


static func _row(main: Node, kind: String, r: Dictionary, i: int, cols: Array) -> Control:
	var p := PanelContainer.new()
	p.name = "Row_%s_%s" % [kind, str(r["id"])]
	var sb := UI.box(Palette.alpha(Palette.TILE, 0.35) if i % 2 == 1 else Palette.CLEAR, Palette.LINE, 0, 0, 0, 3)
	sb.border_width_bottom = 1
	p.add_theme_stylebox_override("panel", sb)
	p.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	p.custom_minimum_size = Vector2(0, 50 if kind == "fighters" else 40)
	var title := str(r["cells"][str(COLS[kind][0][0])][0])
	if kind == "staff":
		title = "%s · %s" % [title, str(r["cells"]["job"][0]).get_slice(",", 0)] if title != "nobody yet" else str(r["cells"]["job"][0]).get_slice(",", 0)
	p.gui_input.connect(func(ev: InputEvent):
		var mb := ev as InputEventMouseButton
		if mb == null or not mb.pressed:
			return
		if mb.button_index == MOUSE_BUTTON_RIGHT:
			OfficeMenu.open(main, mb.global_position, title, items(main.career, kind, r))
		elif mb.button_index == MOUSE_BUTTON_LEFT:
			main.act("fighter" if kind == "fighters" else "go", str(r["id"]) if kind == "fighters" else "gym:1"))
	var h := UI.hbox(0)
	p.add_child(h)
	var num := UI.label(str(i + 1), 16, Palette.MUTED, "mono")
	num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	h.add_child(_fixed(num, 34))
	for col in cols:
		h.add_child(_fixed(_cell(kind, r, str(col[0]), col == cols[0]), int(col[2])))
	return p


## The lines a right-click on this row shows.
static func items(c: Career, kind: String, r: Dictionary) -> Array:
	return OfficeMenu.fighter_items(c, str(r["id"])) if kind == "fighters" else OfficeMenu.staff_items(c, r)


static func _cell(kind: String, r: Dictionary, col: String, first: bool) -> Control:
	var cell: Array = r["cells"][col]
	var ink: Color = TONE.get(str(cell[2]), Palette.TEXT)
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", 8)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var h := UI.hbox(8)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(h)
	if first:
		var pic: Control = PromoShot.picture(str(r["face"]), Vector2(36, 42) if kind == "fighters" else Vector2(30, 34)) if str(r["face"]).get_extension() == "" and str(r["face"]) != "" else null
		if pic != null:
			h.add_child(pic)
		elif ResourceLoader.exists(str(r["face"])):   # a picture file (the head coach)
			var tr := TextureRect.new()
			tr.texture = load(str(r["face"]))
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			tr.custom_minimum_size = Vector2(30, 34)
			tr.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
			h.add_child(tr)
		else:
			var ic := KitIcon.icon("coach", 26, Palette.MUTED if str(cell[2]) == "muted" else Palette.TEXT)
			ic.tooltip_text = ""
			ic.modulate = Palette.fade(0.5) if str(cell[2]) == "muted" else Palette.FULL
			h.add_child(ic)
	if col == "stamina":
		var bar := Bar.new()
		bar.custom_minimum_size = Vector2(64, 8)
		bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		bar.track = Palette.PAGE
		bar.fill = Palette.HEADER
		bar.frac = float(cell[1]) / 100.0
		h.add_child(bar)
		h.add_child(UI.label(str(cell[0]), 16, Palette.TEXT, "mono"))
	elif col == "status":
		var tag := PanelContainer.new()
		tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tag.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		tag.add_theme_stylebox_override("panel", UI.box(STATUS_BG.get(str(cell[2]), Palette.TILE), Palette.CLEAR, 4, 0, 7, 0))
		tag.add_child(UI.label(str(cell[0]), 16, Palette.PAGE if str(cell[2]) == "watch" else Palette.TEXT, "bold"))
		h.add_child(tag)
	elif col == "areas":
		var areas: Dictionary = r["areas"]
		for a in AREAS:
			if areas.has(a):
				var n := int(areas[a])
				var box := PanelContainer.new()
				box.mouse_filter = Control.MOUSE_FILTER_IGNORE
				box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
				box.custom_minimum_size = Vector2(38, 0)
				box.add_theme_stylebox_override("panel", UI.box(Palette.GOOD_FILL if is_equal_approx(float(n), -float(cell[1])) else Palette.PAGE, Palette.CLEAR, 4, 0, 4, 0))
				var l := UI.label(str(n), 16, Palette.TEXT, "mono")
				l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				box.add_child(l)
				h.add_child(box)
	else:
		var tx := UI.vbox(0)
		tx.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tx.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		tx.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tx.add_child(_clip(UI.label(str(cell[0]), 16, ink, "bold" if first or col in ["next", "goal"] else "body")))
		if str(cell[3]) != "":
			tx.add_child(_clip(UI.label(str(cell[3]), 16, Palette.MUTED)))
		h.add_child(tx)
	return m


## The column chooser: a tick a column, on the same floating card as the menu.
static func open_columns(main: Node, kind: String, at: Vector2) -> Control:
	var made := OfficeMenu.layer(main, at, "OfficeColumns")
	var box: VBoxContainer = made[1]
	box.custom_minimum_size = Vector2(250, 0)
	var head := MarginContainer.new()
	head.add_theme_constant_override("margin_left", 8)
	head.add_child(UI.label("SHOW THESE COLUMNS", 16, Palette.HEADER, "caps"))
	box.add_child(head)
	for col in (COLS[kind] as Array).slice(1):
		var id := str(col[0])
		var cb := CheckBox.new()
		cb.name = "Col_" + id
		cb.text = str(col[1])
		cb.focus_mode = Control.FOCUS_NONE
		cb.button_pressed = not (hidden[kind] as Array).has(id)
		cb.add_theme_font_override("font", UI.font("semi"))
		cb.add_theme_font_size_override("font_size", 16)
		for k in ["font_color", "font_hover_color", "font_pressed_color", "font_hover_pressed_color"]:
			cb.add_theme_color_override(k, Palette.TEXT)
		cb.toggled.connect(func(_on: bool):
			toggle(kind, id)
			main.render())
		box.add_child(cb)
	var foot := MarginContainer.new()
	foot.add_theme_constant_override("margin_left", 8)
	foot.add_child(UI.label("The sheet remembers.", 16, Palette.MUTED))
	box.add_child(foot)
	return made[0]


static func _plain_button(text: String, bg: Color, edge: Color, ink: Color = Palette.TEXT) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(0, 34)
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_font_override("font", UI.font("bold"))
	b.add_theme_font_size_override("font_size", 16)
	for st in ["normal", "hover", "pressed"]:
		b.add_theme_stylebox_override(st, UI.box(bg.lightened(0.08) if st == "hover" else bg, edge, 4, 1, 10, 0))
	for k in ["font_color", "font_hover_color", "font_pressed_color"]:
		b.add_theme_color_override(k, ink)
	return b


## A fixed-width cell; width 0 = the column takes what is left.
static func _fixed(n: Control, w: int) -> Control:
	if w > 0:
		n.custom_minimum_size.x = float(w)
	else:
		n.custom_minimum_size.x = 200.0
		n.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return n


static func _clip(l: Label) -> Label:
	l.clip_text = true
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	return l
