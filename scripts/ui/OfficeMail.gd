extends RefCounted
## S544 (owner on the S544 build: "i click mail and i am not inside the computer in the office screen ?"): Mail is a WINDOW
## of the office computer, like the Fighters and Staff sheets (OfficeSheet), not a jump to World > News. Two columns in
## the desktop window: INBOX (the club's own mail, newest first; what arrived since the last look carries a blue dot and
## bold ink) and AROUND THE REGION (the other clubs' stories). Names in a line are links (NameLinks), as on every page.
##   rows(c, fresh) -> {inbox: [{line, d, unread}], region: [{line, d}]}   (pure)       build(main, c, fresh) -> Control
## `fresh` = how many of the newest club mails were unread when Mail was opened (the act zeroes Career.unread).

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const NameLinks := preload("res://scripts/ui/NameLinks.gd")
const ResultTiles := preload("res://scripts/ui/ResultTiles.gd")

const SHOWN := 60   ## lines a column lists (the career keeps more; the oldest scroll off the list)


static func rows(c: Career, fresh: int) -> Dictionary:
	var inbox: Array = []
	var region: Array = []
	var left := fresh
	for n in c.news:
		if bool(n.get("own", false)):
			if inbox.size() < SHOWN:
				inbox.append({"line": str(n["t"]), "d": int(n["d"]), "unread": left > 0})
			left -= 1
		elif region.size() < SHOWN:
			region.append({"line": str(n["t"]), "d": int(n["d"])})
	return {"inbox": inbox, "region": region}


static func build(main: Node, c: Career, fresh: int) -> Control:
	var data := rows(c, fresh)
	var h := UI.hbox(16)
	h.name = "OfficeMail"
	h.size_flags_vertical = Control.SIZE_EXPAND_FILL
	h.custom_minimum_size.y = 730.0   # the mail window fills the desktop, as the dashboard does
	var unread := (data["inbox"] as Array).filter(func(x): return bool(x["unread"])).size()
	h.add_child(_column(main, c, "Inbox", "MailInbox", "%d new" % unread if unread > 0 else "nothing new", data["inbox"], 3.0,
		"No mail yet. Offers, results and the week's news arrive here."))
	h.add_child(_column(main, c, "Around the region", "MailRegion", "the other clubs", data["region"], 2.0, "Nothing from the other clubs yet."))
	return h


static func _column(main: Node, c: Career, title: String, node_name: String, sub: String, items: Array, ratio: float, empty: String) -> Control:
	var p := PanelContainer.new()
	p.name = node_name
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	p.size_flags_stretch_ratio = ratio
	p.add_theme_stylebox_override("panel", UI.box(Palette.CARD, Palette.LINE, 10, 1, 16, 14))
	var v := UI.vbox(10)
	p.add_child(v)
	var head := UI.hbox(10)
	head.add_child(ResultTiles.icon("clipboard-pen" if node_name == "MailInbox" else "tv", 24, Palette.HEADER))
	head.add_child(UI.label(title.to_upper(), 20, Palette.HEADER, "caps"))
	head.add_child(UI.label(sub, 16, Palette.MUTED, "semi"))
	v.add_child(head)
	var scroll := ScrollContainer.new()
	scroll.name = "MailScroll"
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	var list := UI.vbox(10)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	if items.is_empty():
		list.add_child(UI.muted(empty, UI.BODY, true))
	var last_day := -1
	for m in items:
		if int(m["d"]) != last_day:   # one date line per day, not a date on every row
			last_day = int(m["d"])
			list.add_child(UI.label(Clock.fmt(last_day).to_upper(), 14, Palette.MUTED, "caps"))
		var row := UI.hbox(10)
		row.name = "MailRow"
		var dot := Panel.new()
		dot.custom_minimum_size = Vector2(10, 10)
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		dot.add_theme_stylebox_override("panel", UI.box(Palette.ACCENT if bool(m.get("unread", false)) else Palette.CLEAR, Palette.CLEAR, 5, 0, 0, 0))
		row.add_child(dot)
		row.add_child(NameLinks.label(main, c, str(m["line"]), UI.BODY, Palette.TEXT if bool(m.get("unread", false)) else Palette.MUTED))
		list.add_child(row)
	return p
