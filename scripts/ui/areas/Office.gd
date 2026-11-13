extends VBoxContainer
## OFFICE1 (S450, TASK_OFFICE1; operator Q-S294-213 "A, full screen"): the club office as the office computer's desktop, drawn
## after docs/mockups/s449/office/office_a.html (sizes in px from it). A dark desktop on the dimmed gym photo: the club's own top
## line, a dock of 7 apps, and the Desktop window "This week at the club" with five panels and the staff strip. Every value
## comes from OfficeDesk (a pure read of the career). One pulsing button: the first need (S442). Numbers carry a HoverLabel
## saying where they come from. Until their own tasks land, the apps open the pages the game has (section 2).

const UI := preload("res://scripts/ui/UI.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const HoverLabel := preload("res://scripts/ui/HoverLabel.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const OfficeDesk := preload("res://scripts/ui/OfficeDesk.gd")
const CashChart := preload("res://scripts/ui/CashChart.gd")
const Clock := preload("res://scripts/state/Clock.gd")

const BG := Color("#0b0f15")
const PANEL := Color("#121821")
const PANEL2 := Color("#18202b")
const LINE := Color("#283242")
const INK := Color("#e9e4da")
const DIM := Color("#97a1b0")
const HEAD := Color("#c9bfae")
const RED := Color("#d93a3a")
const GREEN := Color("#5fcf7a")
const AMBER := Color("#f2b84b")
const BLUE := Color("#5aa3ff")
const WALL := "res://assets/ui/art/gym_main.jpg"
const CREST := "res://assets/ui/club_badge.svg"
## [label, KitIcon, act, arg]: section 2's routes. Mail is the game's news list (Main's "mail": World > News, read).
const APPS := [["Desktop", "booked", "go", "office:0"], ["Mail", "offer", "mail", ""], ["Schedule", "calendar", "go", "fights:0"],
	["Fighters", "hands", "go", "fighters:0"], ["Staff", "coach", "go", "gym:1"], ["Finance", "money", "go", "money:0"],
	["Records", "contract", "go", "gym:4"]]
const TONE := {"r": RED, "a": AMBER, "g": GREEN, "b": BLUE}
const CHIP := {"bout": [RED, Color.WHITE], "fight_week": [Color("#6d5a2a"), Color("#f6e6bd")], "show": [RED, Color.WHITE],
	"open": [BLUE, BG], "champs": [AMBER, BG]}
const FOOT := "Click an app or any card to open it. The one pulsing button is the decision due first."

func build(main: Node) -> void:
	var c: Career = main.career
	add_theme_constant_override("separation", 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var desk := _panel("OfficeDesktop", UI.box(BG, LINE, 12, 1, 0, 0), Control.SIZE_EXPAND_FILL)
	desk.clip_contents = true
	add_child(desk)
	var wall := _tex(WALL, Vector2.ZERO, TextureRect.STRETCH_KEEP_ASPECT_COVERED)
	wall.modulate = Color(1, 1, 1, 0.22)   # the gym photo, dimmed behind the desktop
	desk.add_child(wall)
	var v := UI.vbox(0)
	desk.add_child(v)
	v.add_child(_top(c))
	var body := UI.hbox(0)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(body)
	var cards: Array = OfficeDesk.fighter_cards(c)
	body.add_child(_dock(main, c, cards))
	var pad := _margin(28, 24, 28, 10)
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(pad)
	pad.add_child(_window(main, c, cards))
	var fm := _margin(136, 0, 0, 10)
	fm.add_child(_nm(UI.label(FOOT, 16, Color("#6f7a8a")), "OfficeFoot"))
	v.add_child(fm)

## The OS strip: crest, club name, date and week, cash.
func _top(c: Career) -> Control:
	var p := _panel("OfficeTop", UI.box(Color(0.03, 0.04, 0.06, 0.92), Color(0, 0, 0, 0), 0, 0, 22, 4), Control.SIZE_FILL, Vector2(0, 46))
	var h := UI.hbox(18)
	p.add_child(h)
	h.add_child(_tex(CREST, Vector2(30, 30), TextureRect.STRETCH_KEEP_ASPECT_CENTERED))
	h.add_child(_nm(UI.label(c.gym_name.to_upper(), 21, INK, "caps"), "OfficeClub"))
	h.add_child(UI.spacer())
	h.add_child(UI.label("%s  \u00b7" % Clock.fmt_long(c.day), 18, INK, "semi"))
	h.add_child(_num("Week %d" % Clock.week_of(c.day), 18, AMBER, "Week of the season, from the club's first Monday"))
	h.add_child(UI.label("Cash", 18, INK, "bold"))
	h.add_child(_nm(_num(UI.money(c.cash), 18, GREEN if c.cash >= 0 else RED, "Cash in the tin today"), "OfficeCash"))
	return p

func _dock(main: Node, c: Career, cards: Array) -> Control:
	var p := _panel("OfficeDock", UI.box(Color(0.03, 0.04, 0.06, 0.85), Color(0, 0, 0, 0), 0, 0, 15, 18), Control.SIZE_FILL, Vector2(108, 0))
	var col := UI.vbox(12)
	p.add_child(col)
	var flagged := cards.filter(func(x): return str(x["tone"]) == "r").size()
	for a in APPS:
		var word := str(a[0])
		var on := word == "Desktop"
		var b := _button(word, PANEL2, AMBER if on else LINE, 16, 2 if on else 1, AMBER if on else DIM, 2)
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		b.name = "App_" + word.to_lower()
		b.custom_minimum_size = Vector2(78, 78)
		b.icon = KitIcon.tex(str(a[1]), 34)
		b.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		b.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		b.pressed.connect(main.act.bind(str(a[2]), str(a[3])))
		var count := c.unread if word == "Mail" else (flagged if word == "Fighters" else 0)
		if count > 0:
			b.add_child(_badge(count, RED if word == "Mail" else Color("#b8862e"), "unread mail" if word == "Mail" else "fighters with a red flag"))
		col.add_child(b)
	return p

func _badge(n: int, col: Color, why: String) -> Control:
	var p := _panel("Badge", UI.box(col, BG, 12, 2, 6, 0))
	p.position = Vector2(60, -6)
	var l := _num(str(n), 16, Color.WHITE, why)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	p.add_child(l)
	return p

## The Desktop window: its bar, then needs | calendar | mail, fighters | money, the staff strip.
func _window(main: Node, c: Career, cards: Array) -> Control:
	var sb := UI.box(Color(0.055, 0.075, 0.105, 0.96), Color("#33404f"), 12, 1, 0, 0)
	sb.shadow_color = Color(0, 0, 0, 0.6)
	sb.shadow_size = 20
	var win := _panel("DesktopWindow", sb, Control.SIZE_EXPAND_FILL)
	var v := UI.vbox(0)
	win.add_child(v)
	var bar := _panel("WindowBar", UI.box(Color("#1a2230"), LINE, 0, 0, 18, 6), Control.SIZE_FILL, Vector2(0, 44))
	bar.add_child(UI.label("THIS WEEK AT THE CLUB", 20, INK, "caps"))
	v.add_child(bar)
	var grid := _margin(18, 18, 18, 18)
	v.add_child(grid)
	var rows := UI.vbox(16)
	grid.add_child(rows)
	for line in [[_needs(main, c), _calendar(c), _mail(c)], [_fighters(main, cards), _money(c)], [_staff(c)]]:
		var r := UI.hbox(16)
		rows.add_child(r)
		for part in line:
			r.add_child(part)
	return win

## [panel, body]: a dark card with its title and the small grey sub-line.
func _card(node_name: String, title: String, sub: String, w: float = 0.0) -> Array:
	var p := _panel(node_name, UI.box(PANEL, LINE, 10, 1, 16, 14), Control.SIZE_EXPAND_FILL if w <= 0.0 else Control.SIZE_FILL, Vector2(w, 0))
	var v := UI.vbox(10)
	p.add_child(v)
	var h := UI.hbox(10)
	h.add_child(UI.label(title.to_upper(), 20, HEAD, "caps"))
	if sub != "":
		h.add_child(_nm(UI.label(sub, 16, DIM, "semi"), "Sub"))
	v.add_child(h)
	return [p, v]

func _needs(main: Node, c: Career) -> Control:
	var n: Array = OfficeDesk.needs(c)
	var card := _card("NeedsPanel", "Needs you", "%d thing%s, most urgent first" % [n.size(), "" if n.size() == 1 else "s"], 600.0)
	if n.is_empty():
		card[1].add_child(UI.label("Nothing needs you. Press Continue when you are ready.", 17, DIM))
	for i in n.size():
		var x: Dictionary = n[i]
		var hot := bool(x["pulse"])
		var row := _panel("Need_%d" % i, UI.box(PANEL2, RED if hot else LINE, 9, 1, 12, 10))
		var h := UI.hbox(12)
		row.add_child(h)
		var tone: Color = [RED, AMBER, BLUE][clampi(int(x["level"]), 0, 2)]
		var ic := _panel("Icon", UI.box(Color(tone, 0.18), Color(0, 0, 0, 0), 9, 0, 8, 8))
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		ic.add_child(KitIcon.icon(str(x["icon"]), 26, tone))
		h.add_child(ic)
		var tx := UI.vbox(2)
		tx.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tx.add_child(UI.label(str(x["t"]), 18, INK, "bold", true))
		tx.add_child(UI.label(str(x["s"]).replace("\n", ", "), 16, DIM, "body", true))
		h.add_child(tx)
		var go := _button(str(x["label"]), RED if hot else Color("#223042"), RED if hot else Color("#3a4a5e"), 8, 1)
		go.size_flags_horizontal = Control.SIZE_SHRINK_END
		go.name = "NeedGo_%d" % i
		go.pressed.connect(main.act.bind(str(x["act"]), str(x["arg"])))
		h.add_child(go)
		if hot:
			Pulse.breathe(go)   # S442: the one pulsing button on the screen, the decision due first
		card[1].add_child(row)
	return card[0]

func _calendar(c: Career) -> Control:
	var card := _card("CalendarPanel", "Next four weeks", "bouts, fight weeks, bills")
	var g := GridContainer.new()
	g.columns = 7
	g.add_theme_constant_override("h_separation", 4)
	g.add_theme_constant_override("v_separation", 4)
	card[1].add_child(g)
	for d in Clock.DAYS:
		var hl := UI.label(str(d), 16, DIM, "bold")
		hl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		g.add_child(hl)
	for cell in OfficeDesk.calendar(c):
		var today := bool(cell["today"])
		var p := _panel("Day_%d" % int(cell["d"]), UI.box(PANEL2, AMBER if today else Color("#222b38"), 6, 2 if today else 1, 4, 2), Control.SIZE_EXPAND_FILL, Vector2(0, 54))
		var cv := UI.vbox(0)
		p.add_child(cv)
		cv.add_child(UI.label(str(cell["n"]), 16, INK if today else DIM))
		var chips: Array = cell["chips"]
		if not chips.is_empty():
			var ch: Dictionary = chips[0]
			var cols: Array = CHIP.get(str(ch["kind"]), [Color("#2c3a4c"), Color("#cfd8e3")])
			var chip := _panel("Chip", UI.box(cols[0], Color(0, 0, 0, 0), 4, 0, 4, 0))
			chip.add_child(_clip(UI.label(str(ch["t"]), 16, cols[1], "bold")))
			cv.add_child(chip)
			p.tooltip_text = "\n".join(chips.map(func(x): return str(x["tip"])))
		g.add_child(p)
	return card[0]

func _mail(c: Career) -> Control:
	var card := _card("MailPanel", "Mail", "%d unread" % c.unread, 420.0)
	for m in OfficeDesk.mail(c):
		var h := UI.hbox(10)
		var dot := _panel("Dot", UI.box(BLUE if bool(m["unread"]) else Color(0, 0, 0, 0), Color(0, 0, 0, 0), 5, 0, 0, 0), Control.SIZE_FILL, Vector2(10, 10))
		dot.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		h.add_child(dot)
		var tx := UI.vbox(0)
		tx.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tx.add_child(UI.label(str(m["sender"]), 16, INK, "bold"))
		var line := _clip(UI.label(str(m["line"]), 16, DIM))
		line.custom_minimum_size = Vector2(340, 0)
		line.tooltip_text = "%s: %s" % [Clock.fmt(int(m["d"])), str(m["line"])]
		line.mouse_filter = Control.MOUSE_FILTER_PASS
		tx.add_child(line)
		h.add_child(tx)
		card[1].add_child(h)
	return card[0]

func _fighters(main: Node, cards: Array) -> Control:
	var card := _card("FightersPanel", "Fighters", "the flag is the one thing each needs")
	var row := UI.hbox(12)
	card[1].add_child(row)
	if cards.is_empty():
		row.add_child(UI.label("No fighters yet: the walk-in waits at reception.", 17, DIM))
	for x in cards:
		row.add_child(_fighter(main, x))
	return card[0]

func _fighter(main: Node, x: Dictionary) -> Control:
	var p := _panel("Card_" + str(x["id"]), UI.box(PANEL2, LINE, 10, 1, 0, 0), Control.SIZE_EXPAND_FILL)
	p.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	p.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed and (ev as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
			main.act("fighter", str(x["id"])))
	var v := UI.vbox(7)
	p.add_child(v)
	var pic := Control.new()
	pic.custom_minimum_size = Vector2(0, 160)
	pic.clip_contents = true
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(pic)
	var face: TextureRect = PromoShot.picture(str(x["face"]), Vector2(220, 160))
	if face != null:
		pic.add_child(face)
	var tags := UI.hbox(6)   # the class chip is the card's header (S448: names only in headers); the flag on the right
	tags.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE, Control.PRESET_MODE_MINSIZE, 8)
	tags.add_child(_tag(str(x["header"]), Color(0.03, 0.04, 0.06, 0.85), INK))
	tags.add_child(UI.spacer())
	tags.add_child(_tag(str(x["flag"]), TONE.get(str(x["tone"]), BLUE), Color.WHITE if str(x["tone"]) == "r" else BG))
	pic.add_child(tags)
	var bd := _margin(12, 0, 12, 12)
	v.add_child(bd)
	var b := UI.vbox(7)
	bd.add_child(b)
	var rk := UI.hbox(6)
	rk.add_child(UI.label(str(x["rank"]), 19, INK, "caps"))
	rk.add_child(UI.label(str(x["rank_sub"]), 16, DIM, "semi"))
	b.add_child(rk)
	b.add_child(_bar("Stamina", int(x["stamina"]), "Stamina, 0-100: how long the fighter holds the pace"))
	b.add_child(_bar("Mood", int(x["mood"]), "Mood, 0-100: Fired up, Steady, Flat or Low"))
	var nx := UI.hbox(6)
	nx.add_child(UI.label("Next:", 16, INK))
	nx.add_child(UI.label(str(x["next"]), 16, AMBER, "bold"))
	b.add_child(nx)
	return p

func _bar(word: String, n: int, why: String) -> Control:
	var h := UI.hbox(8)
	var w := UI.label(word, 16, DIM)
	w.custom_minimum_size = Vector2(66, 0)
	h.add_child(w)
	var bar := ProgressBar.new()
	bar.show_percentage = false
	bar.value = n
	bar.custom_minimum_size = Vector2(40, 8)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_theme_stylebox_override("background", UI.box(Color("#263040"), Color(0, 0, 0, 0), 4, 0, 0, 0))
	bar.add_theme_stylebox_override("fill", UI.box(GREEN if n >= 70 else (AMBER if n >= 50 else Color("#ff7a6a")), Color(0, 0, 0, 0), 4, 0, 0, 0))
	h.add_child(bar)
	var v := _num(str(n), 16, INK, why)
	v.custom_minimum_size = Vector2(30, 0)
	v.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(v)
	return h

func _money(c: Career) -> Control:
	var m: Dictionary = OfficeDesk.money_ahead(c)
	var card := _card("MoneyPanel", "Money", "8 weeks ahead", 420.0)
	card[1].add_child(_num(UI.money(int(m["cash"])), 40, INK, "Cash in the tin today", "bold"))
	var chart := CashChart.new()   # the Money page's own chart: today, then its 8 forecast weeks dotted, the $0 line dashed
	chart.name = "MoneySpark"
	chart.height = 90.0
	chart.points = [{"w": Clock.week_of(c.day), "c": c.cash}]
	chart.future = m["weeks"]
	card[1].add_child(chart)
	for r in m["rows"]:
		var h := UI.hbox(8)
		h.add_child(UI.label(str(r["t"]), 16, INK, "body", true))
		var amt := int(r["amount"])
		h.add_child(_num(UI.signed(amt), 16, GREEN if amt >= 0 else Color("#ff7a6a"), str(r["tip"]), "bold"))
		card[1].add_child(h)
	return card[0]

func _staff(c: Career) -> Control:
	var p := _panel("StaffPanel", UI.box(PANEL, LINE, 10, 1, 16, 10), Control.SIZE_EXPAND_FILL)
	var h := UI.hbox(30)
	p.add_child(h)
	h.add_child(UI.label("STAFF", 20, HEAD, "caps"))
	for r in OfficeDesk.staff(c):
		var st := UI.hbox(12)
		st.name = "Staff_%d" % h.get_child_count()
		if bool(r["empty"]):
			st.modulate = Color(1, 1, 1, 0.55)
		var ph := _panel("Face", UI.box(Color("#1b2230"), Color("#6b5a3a"), 27, 2, 6, 6), Control.SIZE_FILL, Vector2(54, 54))
		if str(r["face"]) != "":
			ph.add_child(_tex(str(r["face"]), Vector2.ZERO, TextureRect.STRETCH_KEEP_ASPECT_COVERED))
		elif not bool(r["empty"]):
			ph.add_child(KitIcon.icon("coach", 30, DIM))
		st.add_child(ph)
		var tx := UI.vbox(0)
		tx.add_child(UI.label(str(r["role"]), 17, INK, "bold"))
		var sub := UI.hbox(6)
		sub.add_child(UI.label(str(r["line"]), 16, DIM))
		if str(r["pay"]) != "":
			sub.add_child(_num("\u00b7 " + str(r["pay"]), 16, DIM, "Weekly pay, on the month bill"))
		tx.add_child(sub)
		st.add_child(tx)
		h.add_child(st)
	return p

## ---------- small parts ----------

## A number: tabular figures and a hover word saying where it comes from (HoverLabel, the rule for secondary info).
func _num(text: String, px: int, col: Color, why: String, kind: String = "mono") -> Label:
	var l := UI.label(text, px, col, kind)
	l.mouse_filter = Control.MOUSE_FILTER_PASS
	HoverLabel.attach(l, why)
	return l

func _button(text: String, bg: Color, edge: Color, radius: int, bw: int, ink: Color = INK, pad := 16) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(0, 40)
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_font_override("font", UI.font("bold"))
	b.add_theme_font_size_override("font_size", 16)
	for st in ["normal", "hover", "pressed"]:
		b.add_theme_stylebox_override(st, UI.box(bg.lightened(0.08) if st == "hover" else bg, edge, radius, bw, pad, 0))
	for k in ["font_color", "font_hover_color", "font_pressed_color"]:
		b.add_theme_color_override(k, ink)
	return b

func _panel(node_name: String, sb: StyleBox, h_flags: int = Control.SIZE_FILL, min_size := Vector2.ZERO) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = node_name
	p.custom_minimum_size = min_size
	p.size_flags_horizontal = h_flags
	p.add_theme_stylebox_override("panel", sb)
	return p

func _tex(path: String, min_size: Vector2, stretch: int) -> TextureRect:
	var t := TextureRect.new()
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = stretch
	t.texture = load(path)
	t.custom_minimum_size = min_size
	return t

func _tag(text: String, bg: Color, ink: Color) -> Control:
	var p := _panel("Tag", UI.box(bg, Color("#3a4658"), 6, 1, 7, 2))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(UI.label(text, 16, ink, "bold"))
	return p

func _nm(n: Control, node_name: String) -> Control:
	n.name = node_name
	return n

func _clip(l: Label) -> Label:
	l.clip_text = true
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	return l

func _margin(l: int, t: int, r: int, b: int) -> MarginContainer:
	var m := MarginContainer.new()
	for side in [["left", l], ["top", t], ["right", r], ["bottom", b]]:
		m.add_theme_constant_override("margin_" + str(side[0]), int(side[1]))
	return m
