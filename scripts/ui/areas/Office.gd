extends VBoxContainer
## OFFICE1 (S450, TASK_OFFICE1; operator Q-S294-213 "A, full screen"): the club office as the office computer's desktop, drawn
## after docs/mockups/s449/office/office_a.html (sizes in px from it). A dark desktop on the dimmed gym photo: the club's own top
## line, a dock of 7 apps, and the Desktop window "This week at the club" with five panels and the staff strip. Every value
## comes from OfficeDesk (a pure read of the career). One pulsing button: the first need (S442). Numbers carry a HoverLabel
## saying where they come from. Until their own tasks land, the apps open the pages the game has (section 2).
## OFFICEV2 (S538, owner Q-S294-302 / Q-304 "Yes, build them"): the dashboard carries the GOALS panel (OfficeGoals) and the
## fighters shrink to a strip of chips; the Fighters and Staff icons open the two sheets INSIDE the desktop (OfficeSheet,
## right-click = OfficeMenu). `view` says which of the two the window shows; the hub's pin always lands on the dashboard.

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")   # S493 Q-251: the gym look, no navy of its own
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const HoverLabel := preload("res://scripts/ui/HoverLabel.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const OfficeDesk := preload("res://scripts/ui/OfficeDesk.gd")
const CashChart := preload("res://scripts/ui/CashChart.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const Tip := preload("res://scripts/ui/Tip.gd")
const Bar := preload("res://scripts/ui/Bar.gd")
const OfficeGoals := preload("res://scripts/ui/OfficeGoals.gd")
const OfficeSheet := preload("res://scripts/ui/OfficeSheet.gd")
const OfficeMail := preload("res://scripts/ui/OfficeMail.gd")   # S544: Mail is a window of this computer

const BG := Palette.PAGE
const PANEL := Palette.CARD
const PANEL2 := Palette.TILE
const LINE := Palette.LINE
const INK := Palette.TEXT
const DIM := Palette.MUTED
const HEAD := Palette.HEADER
const RED := Palette.BAD_FILL
const GREEN := Palette.GOOD
const AMBER := Palette.WARN
const BLUE := Palette.ACCENT
const CREST := "res://assets/ui/club_badge.svg"
## [label, KitIcon, act, arg]: section 2's routes. Mail is the game's news list (Main's "mail": World > News, read).
const APPS := [["Desktop", "booked", "go", "office:0"], ["Mail", "offer", "mail", ""], ["Fights", "calendar", "go", "fights:0"],
	["Fighters", "hands", "sheets", ""], ["Staff", "coach", "sheets", ""], ["Finance", "money", "go", "money:0"],
	["Records", "contract", "go", "gym:4"]]
const SHEET_APPS := ["Fighters", "Staff"]
const TONE := {"r": RED, "a": AMBER, "g": GREEN, "b": BLUE}
const CHIP := {"bout": [RED, INK], "fight_week": [Palette.SECOND, Palette.HEADER], "show": [RED, INK],
	"open": [BLUE, BG], "champs": [AMBER, BG]}
const CARD_W := 196
const MAX_CHIPS := 4
const MAX_STAFF := 3
const FOOT := "Click an app or any card to open it. The one pulsing button is the decision due first."
const MAIL_FOOT := "A blue dot is mail that arrived since your last look. Click a name to open that boxer or club."
const SHEET_FOOT := "Click a heading to sort. Right-click a name for what you can do."

## S544: `open_as` = the window the next build opens on ("mail": Main's "mail" act, from the top bar or anywhere), and
## `mail_fresh` = how many club mails were unread when Mail was opened (the dots; the act zeroes Career.unread).
static var open_as := ""
static var mail_fresh := 0
## "desk" (the dashboard), "sheets" or "mail"; `_seen` = how long Main's history was at the last build (a fresh arrival from the
## gym shows the dashboard; Back from a page the sheet opened returns to the sheet).
static var view := "desk"
static var _seen := 0
var hosted := ""   ## S545 (owner C498 "shouldnt this be inside the computer"): "fights" while the Fights area hosts this desktop
var host_box: Container   ## where that list goes

func host(main: Node, what: String) -> Container:
	hosted = what
	build(main)
	return host_box

func _shown() -> String: return hosted if hosted != "" else view

## Main's "mail" act: the next build opens on the Mail window; the unread count becomes the blue dots and is cleared.
static func open_mail(c: Career) -> void:
	mail_fresh = c.unread
	open_as = "mail"
	c.unread = 0

func build(main: Node) -> void:
	var c: Career = main.career
	var trail: Array = main.past
	if hosted == "":
		if trail.size() > _seen and not trail.is_empty() and str(trail[-1].get("area", "")) != "office":
			view = "desk"
		_seen = trail.size()
		if open_as != "":
			view = open_as
			open_as = ""
	add_theme_constant_override("separation", 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# S498 ONELOOK1 (operator: "how do you call this consistent ?"): the office sits on the one gym wall like every page -
	# no desk of its own, no second photo behind it (was gym_main.jpg at 0.22 on a page-coloured desk).
	var desk := _panel("OfficeDesktop", StyleBoxEmpty.new(), Control.SIZE_EXPAND_FILL)
	add_child(desk)
	var v := UI.vbox(0)
	desk.add_child(v)
	v.add_child(_top(c))
	var body := UI.hbox(0)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(body)
	var cards: Array = OfficeDesk.fighter_cards(c)
	body.add_child(_dock(main, c, cards))
	var pad := _margin(28, 18, 28, 10)
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(pad)
	pad.add_child(_window(main, c, cards))
	var fm := _margin(136, 0, 0, 10)
	var foot := _panel("OfficeFootBack", UI.box(Palette.alpha(BG, 0.85), Palette.CLEAR, 6, 0, 12, 4), Control.SIZE_SHRINK_BEGIN)   # S545: on the bare floor photo half the line could not be read
	foot.add_child(_nm(UI.label({"desk": FOOT, "mail": MAIL_FOOT, "fights": "Scroll the window for the calendar and the results."}.get(_shown(), SHEET_FOOT), 16, DIM), "OfficeFoot"))
	fm.add_child(foot)
	v.add_child(fm)

## The OS strip: crest, club name, date and week, cash.
func _top(c: Career) -> Control:
	var p := _panel("OfficeTop", UI.box(Palette.alpha(BG, 0.92), Palette.CLEAR, 0, 0, 22, 4), Control.SIZE_FILL, Vector2(0, 46))
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
	var p := _panel("OfficeDock", UI.box(Palette.alpha(BG, 0.85), Palette.CLEAR, 0, 0, 15, 18), Control.SIZE_FILL, Vector2(108, 0))
	var col := UI.vbox(12)
	p.add_child(col)
	var flagged := cards.filter(func(x): return str(x["tone"]) == "r").size()
	for a in APPS:
		var word := str(a[0])
		var on := SHEET_APPS.has(word) if _shown() == "sheets" else (word == "Mail" if _shown() == "mail" else (word == "Fights" if _shown() == "fights" else word == "Desktop"))
		var b := _button(word, PANEL2, AMBER if on else LINE, 16, 2 if on else 1, AMBER if on else DIM, 2)
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		b.name = "App_" + word.to_lower()
		b.custom_minimum_size = Vector2(78, 78)
		b.icon = KitIcon.tex(str(a[1]), 34)
		b.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		b.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		if str(a[2]) == "sheets":
			b.pressed.connect(_show.bind(main, "sheets"))
		elif word == "Desktop":
			b.pressed.connect(func():
				view = "desk"
				main.act("go", "office:0"))
		else:
			b.pressed.connect(main.act.bind(str(a[2]), str(a[3])))
		var count := c.unread if word == "Mail" else (flagged if word == "Fighters" else 0)
		if count > 0:
			b.add_child(_badge(count, RED if word == "Mail" else AMBER, "unread mail" if word == "Mail" else "fighters with a red flag"))
		col.add_child(b)
	return p

func _badge(n: int, col: Color, why: String) -> Control:
	var p := _panel("Badge", UI.box(col, BG, 12, 2, 6, 0))
	p.position = Vector2(60, -6)
	var l := _num(str(n), 16, INK, why)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	p.add_child(l)
	return p

## The Fighters and Staff icons: the sheets inside the desktop (no page change).
func _show(main: Node, what: String) -> void:
	view = what
	if str(main.route.get("area", "")) != "office":   # S545: from the Fights window the sheets open on the office route
		open_as = what
		main.nav({"area": "office", "tab": 0})
		return
	main.render()

## The Desktop window: its bar, then needs | calendar | mail, goals | club, fighters | staff - or the two sheets.
func _window(main: Node, c: Career, cards: Array) -> Control:
	var sb := UI.WoodKit.slate(0, 0)   # S498 ONELOOK1: the house panel
	var win := _panel("DesktopWindow", sb, Control.SIZE_EXPAND_FILL)
	var v := UI.vbox(0)
	win.add_child(v)
	var bar := _panel("WindowBar", UI.box(BG, LINE, 0, 0, 18, 6), Control.SIZE_FILL, Vector2(0, 44))
	var bh := UI.hbox(14)
	bar.add_child(bh)
	bh.add_child(UI.label({"desk": "THIS WEEK AT THE CLUB", "mail": "MAIL", "fights": "FIGHTS"}.get(_shown(), "FIGHTERS AND STAFF"), 20, INK, "caps"))
	v.add_child(bar)
	var grid := _margin(18, 14, 18, 14)
	v.add_child(grid)
	var rows := UI.vbox(14)
	grid.add_child(rows)
	if hosted == "fights" or view == "mail":   # a window that fills the desktop
		for n: Control in [win, grid, rows]:
			n.size_flags_vertical = Control.SIZE_EXPAND_FILL
	if hosted == "fights":   # S545: the Fights window; the Fights area fills `host_box`
		var sc := ScrollContainer.new()
		sc.name = "FightsScroll"
		sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
		sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		sc.custom_minimum_size.y = 730.0   # as the Mail window
		host_box = UI.vbox(14)
		host_box.name = "FightsList"
		host_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sc.add_child(host_box)
		rows.add_child(sc)
		return win
	if view == "mail":   # S544: the mail window, inside the desktop
		rows.add_child(OfficeMail.build(main, c, mail_fresh))
		return win
	if view == "sheets":
		bh.add_child(UI.label("sheets inside the desktop", 16, DIM, "semi"))
		rows.add_child(OfficeSheet.build(main))
		return win
	for line in [[_needs(main, c), _calendar(c), _mail(c)], [OfficeGoals.panel(main, c), _money(c)], [_fighters(main, cards), _staff(c)]]:
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
		var ic := _panel("Icon", UI.box(Palette.alpha(tone, 0.18), Palette.CLEAR, 9, 0, 8, 8))
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		ic.add_child(_mute(KitIcon.icon(str(x["icon"]), 26, tone)))   # S533 TIPFIX3: the row's words say it; the icon's name was all
		h.add_child(ic)
		var tx := UI.vbox(2)
		tx.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tx.add_child(UI.label(str(x["t"]), 18, INK, "bold", true))
		tx.add_child(UI.label(str(x["s"]).replace("\n", ", "), 16, DIM, "body", true))
		h.add_child(tx)
		var go := _button(str(x["label"]), Palette.ACTION if hot else Palette.SECOND, Palette.ACTION if hot else LINE, 8, 1)
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
		var p := _panel("Day_%d" % int(cell["d"]), UI.box(PANEL2, Palette.CHOSEN if today else LINE, 6, 2 if today else 1, 4, 2), Control.SIZE_EXPAND_FILL, Vector2(0, 46))   # OFFICEV2: 54 -> 46, the goals row needs the height
		var cv := UI.vbox(0)
		p.add_child(cv)
		cv.add_child(UI.label(str(cell["n"]), 16, INK if today else DIM))
		var chips: Array = cell["chips"]
		if not chips.is_empty():
			var ch: Dictionary = chips[0]
			var cols: Array = CHIP.get(str(ch["kind"]), [PANEL2, INK])
			var chip := _panel("Chip", UI.box(cols[0], Palette.CLEAR, 4, 0, 4, 0))
			chip.add_child(_clip(UI.label(str(ch["t"]), 16, cols[1], "bold")))
			cv.add_child(chip)
			Tip.explain(p, OfficeDesk.day_card(cell))   # S533 TIPFIX3: the day's card (was every chip's line, piled)
		g.add_child(p)
	return card[0]

func _mail(c: Career) -> Control:
	var card := _card("MailPanel", "Mail", "%d unread" % c.unread, 420.0)
	for m in OfficeDesk.mail(c):
		var h := UI.hbox(10)
		var dot := _panel("Dot", UI.box(BLUE if bool(m["unread"]) else Palette.CLEAR, Palette.CLEAR, 5, 0, 0, 0), Control.SIZE_FILL, Vector2(10, 10))
		dot.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		h.add_child(dot)
		var tx := UI.vbox(0)
		tx.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tx.add_child(UI.label(str(m["sender"]), 16, INK, "bold"))
		# S533 TIPFIX3: the whole line, wrapped (was cut, with the news itself, names and all, as its hover)
		var line := UI.label(str(m["line"]), 16, DIM, "body", true)
		line.custom_minimum_size = Vector2(340, 0)
		tx.add_child(line)
		h.add_child(tx)
		card[1].add_child(h)
	return card[0]

func _fighters(main: Node, cards: Array) -> Control:
	var card := _card("FightersPanel", "Fighters", "the flag is the one thing each needs \u00b7 the Fighters icon opens the sheet")
	var row := UI.hbox(10)
	card[1].add_child(row)
	if cards.is_empty():
		row.add_child(UI.label("No fighters yet: the walk-in waits at reception.", 17, DIM))
	for x in cards.slice(0, MAX_CHIPS):
		row.add_child(_fighter(main, x))
	if cards.size() > MAX_CHIPS:
		row.add_child(UI.label("+%d more" % (cards.size() - MAX_CHIPS), 16, DIM, "semi"))
	return card[0]

## OFFICEV2: a fighter as a chip - face, class (S448: names only in headers), the flag, Stamina and Mood. The big picture
## cards went; the whole list is the Fighters sheet.
func _fighter(main: Node, x: Dictionary) -> Control:
	var p := _panel("Card_" + str(x["id"]), UI.box(PANEL2, LINE, 8, 1, 10, 8), Control.SIZE_SHRINK_BEGIN, Vector2(CARD_W, 0))
	p.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	p.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed and (ev as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
			main.act("fighter", str(x["id"])))
	var v := UI.vbox(4)
	p.add_child(v)
	var top := UI.hbox(8)
	var face: TextureRect = PromoShot.picture(str(x["face"]), Vector2(36, 42))
	if face != null:
		top.add_child(face)
	var tx := UI.vbox(1)
	tx.add_child(UI.label(str(x["header"]), 16, INK, "bold"))
	var tag := _tag(str(x["flag"]), TONE.get(str(x["tone"]), BLUE), INK if str(x["tone"]) == "r" else BG)
	tag.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	tx.add_child(tag)
	top.add_child(tx)
	v.add_child(top)
	v.add_child(_hbar("Stamina", int(x["stamina"]), "Stamina, 0-100: how long the fighter holds the pace"))
	v.add_child(_hbar("Mood", int(x["mood"]), "Mood, 0-100: Fired up, Steady, Flat or Low"))
	return p

## One short bar: the word, the bar, the number (its hover says what it is).
func _hbar(word: String, n: int, why: String) -> Control:
	var h := UI.hbox(8)
	var w := UI.label(word, 16, DIM)
	w.custom_minimum_size = Vector2(64, 0)
	h.add_child(w)
	var bar := Bar.new()
	bar.custom_minimum_size = Vector2(60, 8)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bar.track = BG
	bar.fill = Palette.GOOD_FILL if n >= 70 else (AMBER if n >= 50 else Palette.BAD_FILL)
	bar.frac = float(n) / 100.0
	h.add_child(bar)
	h.add_child(_num(str(n), 16, INK, why))
	return h

## S459 (operator C380: "money is shown top, maybe show something else here"): the club - members now and the room the gym
## has, where the Money page's forecast takes them week by week, and the bills coming by date (each one's split on hover).
func _money(c: Career) -> Control:
	var m: Dictionary = OfficeDesk.club_ahead(c)
	var card := _card("MoneyPanel", "Club", "members and bills", 420.0)
	var top := UI.hbox(10)
	top.add_child(_num(str(int(m["members"])), 40, INK, "Members paying dues today", "bold"))
	top.add_child(_num("of %d room" % int(m["cap"]), 18, DIM, "The most members the gym holds now: floor space, coaches and kit"))
	card[1].add_child(top)
	var ahead: Array = m["ahead"]
	var bars := UI.hbox(6)
	bars.name = "MembersAhead"
	for k in ahead.size():
		var n := int(ahead[k])
		var col := Control.new()
		col.custom_minimum_size = Vector2(30, 64)
		col.tooltip_text = "Week %d: %d members (the Money page's forecast)" % [k + 1, n]
		var fill := ColorRect.new()
		fill.color = Palette.GOOD_FILL if n >= int(m["members"]) else Palette.BAD_FILL
		var hgt := 60.0 * clampf(float(n) / float(maxi(1, int(m["cap"]))), 0.05, 1.0)
		fill.position = Vector2(4, 64.0 - hgt)
		fill.size = Vector2(22, hgt)
		fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_child(fill)
		bars.add_child(col)
	card[1].add_child(bars)
	if not ahead.is_empty():
		var d := int(ahead[-1]) - int(m["members"])
		card[1].add_child(_num("%d members in %d weeks (%s)" % [int(ahead[-1]), ahead.size(), UI.signed(d).replace("$", "")], 16,
			GREEN if d >= 0 else Palette.BAD, "Where the forecast takes the members: dues, reputation and room"))
	card[1].add_child(UI.label("BILLS COMING", 16, HEAD, "caps"))
	for b in m["bills"]:
		var h := UI.hbox(8)
		h.add_child(UI.label(Clock.fmt(int(b["day"])), 16, INK, "body", true))
		h.add_child(_num("-" + UI.money(int(b["amount"])), 16, Palette.BAD, str(b["tip"]), "bold"))
		card[1].add_child(h)
	return card[0]

func _staff(c: Career) -> Control:
	var p := _panel("StaffPanel", UI.box(PANEL, LINE, 10, 1, 16, 14), Control.SIZE_EXPAND_FILL)
	var v := UI.vbox(10)
	p.add_child(v)
	var all: Array = OfficeDesk.staff(c)
	var th := UI.hbox(10)
	th.add_child(UI.label("STAFF", 20, HEAD, "caps"))
	if all.size() > MAX_STAFF:
		th.add_child(_nm(UI.label("+%d more on the Staff sheet" % (all.size() - MAX_STAFF), 16, DIM, "semi"), "Sub"))
	v.add_child(th)
	var h := UI.hbox(22)
	v.add_child(h)
	for r in all.slice(0, MAX_STAFF):
		var st := UI.hbox(10)
		st.name = "Staff_%d" % h.get_child_count()
		st.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if bool(r["empty"]):
			st.modulate = Palette.fade(0.55)
		var ph := _panel("Face", UI.box(PANEL2, Palette.WOOD, 32, 2, 5, 5), Control.SIZE_FILL, Vector2(64, 64))
		ph.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		if str(r["face"]) != "":
			ph.add_child(_tex(str(r["face"]), Vector2.ZERO, TextureRect.STRETCH_KEEP_ASPECT_COVERED))
		elif not bool(r["empty"]):
			ph.add_child(_mute(KitIcon.icon("coach", 38, DIM)))
		st.add_child(ph)
		var tx := UI.vbox(0)
		tx.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tx.add_child(UI.label(str(r["role"]), 17, INK, "bold"))
		var line := UI.label(str(r["line"]), 16, DIM, "body", true)
		line.max_lines_visible = 2   # the strip stays three lines tall; the Staff sheet has the whole line
		line.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		tx.add_child(line)
		if str(r["pay"]) != "":
			tx.add_child(_num(str(r["pay"]), 16, DIM, "Weekly pay, on the month bill"))
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
	var p := _panel("Tag", UI.box(bg, LINE, 6, 1, 7, 2))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(UI.label(text, 16, ink, "bold"))
	return p

func _nm(n: Control, node_name: String) -> Control:
	n.name = node_name
	return n

func _mute(c: Control) -> Control:
	c.tooltip_text = ""
	return c

func _clip(l: Label) -> Label:
	l.clip_text = true
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	return l

func _margin(l: int, t: int, r: int, b: int) -> MarginContainer:
	var m := MarginContainer.new()
	for side in [["left", l], ["top", t], ["right", r], ["bottom", b]]:
		m.add_theme_constant_override("margin_" + str(side[0]), int(side[1]))
	return m
