extends RefCounted
## The books' side column, the fighter money table and the kit chalkboard. Dues has its own tab.
## Coaches are drawn and not built: one warn mark, the buttons off. Numbers are the gym's, not the mockup's examples.

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const CashForecast := preload("res://scripts/rules/CashForecast.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const DuesBoards := preload("res://scripts/ui/DuesBoards.gd")
const StarDeal := preload("res://scripts/rules/StarDeal.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const HomeLook := preload("res://scripts/ui/HomeLook.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const NAME_W := 130
const STIPEND_W := 150
const EARNS_W := 96
const COACHES := [
	["Striking", "Jab, cross, hooks, uppercut"],
	["Wrestling", "Single leg, double leg, ground and pound, takedown defence"],
	["BJJ", "Armbar, triangle, rear naked choke, sweeps"],
	["Muay Thai", "Knee, elbow, teep, low kick, body kick"],
]


static func side(main: Node, c: Career, ahead: Array) -> Control:
	var slate := PanelContainer.new()
	slate.name = "BooksSide"
	slate.custom_minimum_size = Vector2(200, 0)
	slate.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slate.size_flags_stretch_ratio = 0.34
	# The column had no frame. Pad is the 22 px frame, so the outer size does not grow past it.
	slate.add_theme_stylebox_override("panel", WoodKit.slate(22, 22))
	var col := UI.vbox(4)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(_talks(main, c))
	col.add_child(_coaches())
	col.add_child(_bills(ahead))
	col.add_child(_sponsors(main, c))
	col.add_child(_staff(main, c))
	slate.add_child(col)
	return slate


static func fighters(main: Node, c: Career) -> Control:
	var card := _paper("Fighters and money", "money", "Stipend, pay and what each fighter earns the gym")
	card[0].name = "FightersMoney"
	var scroll := ScrollContainer.new()
	scroll.name = "FightersScroll"
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.custom_minimum_size = Vector2(0, 64)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	card[1].add_child(scroll)
	var list := UI.vbox(2)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	if c.fighters.is_empty():
		list.add_child(UI.label("Nobody on the books yet.", 14, UI.MUTED, "body"))
		return card[0]
	var head := UI.hbox(6)
	for pair in [["", 20], ["Fighter", NAME_W], ["Stipend", STIPEND_W], ["Earns the gym", EARNS_W], ["Next money", 0]]:
		var word := UI.label(str(pair[0]), 12, UI.MUTED, "bold")
		word.custom_minimum_size = Vector2(int(pair[1]), 0)
		head.add_child(word)
	list.add_child(head)
	for f in c.fighters:
		list.add_child(_fighter(main, c, f))
	return card[0]


static func chalk(main: Node, c: Career, _inc: Dictionary) -> Control:
	# The board is still entering the tree here, so the tab is added on the next idle, once add_child is allowed.
	(func() -> void: _mount_dues(main, c)).call_deferred()
	return _kit(main, c)


static func _talks(main: Node, c: Career) -> Control:
	var card := _paper("Contract talks", "contract", "A contract or offer is answered on the fighter page. The keep or drop choice is on Cashbook.")
	card[0].name = "ContractTalks"
	var any := false
	for f in c.fighters:
		var t: Dictionary = f.get("talks", {})
		if t.is_empty():
			continue
		any = true
		var terms: Dictionary = StarDeal.terms(f, str(t["step"]), int(t.get("take", 0)))
		var row := UI.hbox(8)
		row.add_child(UI.label(str(f["name"]), 15, UI.FG, "bold"))
		var line := UI.label("%s. Answer by %s." % [str(terms["words"]), Clock.fmt(int(t["until"]))], 14, UI.FG, "body", true)
		line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(line)
		var open := UI.button("Open the talk", "Btn", main.act.bind("fighter", str(f["id"])))
		open.name = "OpenTalk_" + str(f["id"])
		row.add_child(open)
		card[1].add_child(row)
	if not any:
		card[1].add_child(UI.label("No talks open.", 14, UI.MUTED, "body"))
	return card[0]


static func _coaches() -> Control:
	var card := _paper("Coaches, a week", "coach", "Not built yet")
	card[0].name = "CoachesPanel"
	var warn := KitIcon.icon("warn", 18, Color("C9770F"), "Not built yet")
	warn.name = "WarnIcon"
	card[1].get_child(0).add_child(warn)
	for pair in COACHES:
		var row := UI.hbox(8)
		var name := UI.label(str(pair[0]), 14, UI.FG, "bold")
		name.custom_minimum_size = Vector2(88, 0)
		row.add_child(name)
		var moves := UI.label(str(pair[1]), 13, UI.MUTED, "body", true)
		moves.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(moves)
		var b := UI.button("Not built yet", "Btn", func(): pass, true, "Not built yet")
		b.name = "CoachHire_" + str(pair[0])
		row.add_child(b)
		card[1].add_child(row)
	return card[0]


static func _bills(ahead: Array) -> Control:
	var split: Dictionary = CashForecast.bill_split(ahead)
	var when := "Bills %s, %s" % [Clock.fmt(int(split["day"])), UI.money(int(split["amount"]))]
	var card := _paper(when, "money", "Wages and upkeep are billed every 28 days")
	card[0].name = "BillsPanel"
	var row := UI.hbox(8)
	card[1].add_child(row)
	for pair in [["Coach", int(split["coach"])], ["Rent", int(split["rent"])], ["Staff", int(split["staff"])], ["Power, kit, fees", int(split["other"])]]:
		var bit := UI.vbox(0)
		bit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bit.add_child(UI.label(str(pair[0]), 12, UI.MUTED, "body"))
		bit.add_child(UI.label(UI.money(int(pair[1])), 14, UI.FG, "bold"))
		row.add_child(bit)
	if int(split["stipends"]) > 0:
		card[1].add_child(UI.label("Stipends in that bill: %s" % UI.money(int(split["stipends"])), 13, UI.FG, "body"))
	return card[0]


static func _sponsors(main: Node, c: Career) -> Control:
	var card := _paper("Sponsors", "reputation", "Deals: sponsors pay every week. Bigger ones come with a bigger gym.")
	card[0].name = "SponsorsPanel"
	for d in c.deals:
		var row := UI.hbox(8)
		var text := UI.vbox(0)
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		text.add_child(UI.label(str(d["name"]), 14, UI.FG, "bold"))
		var state := str(d["state"])
		var sub := "%s, %s a week" % [str(d["what"]), UI.money(int(d["per"]))]
		if state == "locked":
			sub += ". Comes after the first win."
		text.add_child(UI.label(sub, 13, UI.GREEN if state == "signed" else UI.MUTED, "body", true))
		row.add_child(text)
		if state == "offer":
			var b := UI.button("Sign", "Btn", main.act.bind("deal", str(d["id"])))
			b.name = "Deal_" + str(d["id"])
			row.add_child(b)
		elif state == "signed":
			row.add_child(UI.label("signed", 13, UI.GREEN, "bold"))
		else:
			row.add_child(UI.label("after a win", 13, UI.MUTED, "bold"))
		card[1].add_child(row)
	return card[0]


static func _staff(main: Node, c: Career) -> Control:
	var card := _paper("Staff", "members", "Staff jobs: hire for a weekly wage. Roster places: %d of %d." % [GymSpend.used(c), GymSpend.places(c)])
	card[0].name = "StaffPanel"
	for r in StaffRoles.LIST:
		var id := str(r["id"])
		var on := c.staff_roles.has(id)
		var pay := "%s a pro night" % UI.money(int(r["per_bout"])) if int(r["per_bout"]) > 0 else "%s a week" % UI.money(int(r["wage"]))
		pay = pay.replace(" a pro night", " a night").replace(" a week", "")
		var row := UI.hbox(6)
		var label := UI.label("%s: %s" % [str(r["name"]).get_slice(",", 0), str(r["effect"])], 13, UI.FG, "body", true)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(label)
		var b := UI.button("Let go" if on else "Hire %s" % pay, "Btn", main.act.bind("letgorole" if on else "hirerole", id))
		b.name = ("LetGo_" if on else "Hire_") + id
		row.name = "Role_" + id
		row.add_child(b)
		card[1].add_child(row)
	return card[0]


## The books row is The books / Cashbook. Dues is the third, and it takes the whole board.
static func _mount_dues(main: Node, c: Career) -> void:
	var books_tab := main.find_child("BooksTab", true, false) as Button
	if books_tab == null:
		return
	var top := books_tab.get_parent()
	if top.get_node_or_null("DuesTab") != null:
		return
	var host: Node = books_tab
	while host.get_parent() != null and str(host.get_parent().name) != "BooksBoard":
		host = host.get_parent()
	if host.get_parent() == null:
		return
	var dues_tab := UI.button("Dues", "Btn", func() -> void: _open_dues(main))
	dues_tab.name = "DuesTab"
	top.add_child(dues_tab)
	books_tab.pressed.connect(func() -> void: _shut_dues(main))
	var cash_tab := top.get_node_or_null("CashbookTab") as Button
	if cash_tab != null:
		cash_tab.pressed.connect(func() -> void: _shut_dues(main))
	var page := DuesBoards.build(main, c)
	page.visible = false
	page.resized.connect(func() -> void: _park(page))
	host.add_child(page)
	_park(page)


## A hidden page cannot shrink below its boards, so the row is hidden too and the rect stays empty.
static func _park(page: Control) -> void:
	if page.visible:
		return
	if page.get_child_count() > 0:
		var row := page.get_child(0) as CanvasItem
		if row != null:
			row.visible = false
	if page.size != Vector2.ZERO:
		page.size = Vector2.ZERO


static func _open_dues(main: Node) -> void:
	_page(main, "BooksPage", false)
	_page(main, "CashbookPage", false)
	var dues := main.find_child("DuesBoard", true, false) as Control
	if dues != null:
		if dues.get_child_count() > 0:
			(dues.get_child(0) as CanvasItem).visible = true
		dues.visible = true
	_tab(main, "BooksTab", false)
	_tab(main, "CashbookTab", false)
	_tab(main, "DuesTab", true)


static func _shut_dues(main: Node) -> void:
	var dues := main.find_child("DuesBoard", true, false) as Control
	if dues != null:
		dues.visible = false
		_park(dues)
	_tab(main, "DuesTab", false)


static func _page(main: Node, node_name: String, on: bool) -> void:
	var node := main.find_child(node_name, true, false) as CanvasItem
	if node != null:
		node.visible = on


static func _tab(main: Node, node_name: String, on: bool) -> void:
	var b := main.find_child(node_name, true, false) as Button
	if b != null:
		b.theme_type_variation = "BtnSolid" if on else "Btn"


static func _kit(main: Node, c: Career) -> Control:
	var board := _chalk("KIT BUDGET - A WEEK")
	board[0].name = "KitBoard"
	board[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 4)
	row.add_theme_constant_override("v_separation", 2)
	board[1].add_child(row)
	for k in GymSpend.KIT_ORDER:
		var kb: Dictionary = GymSpend.KIT[k]
		var b := UI.button("%s %s" % [kb["name"], UI.money(int(kb["week"]))], "ChoiceOn" if c.kit_level == k else "Choice", main.act.bind("kitbudget", k))
		b.name = "Kit_" + str(k)
		_short_button(b)
		row.add_child(b)
	var r := GymSpend.train_risk(c)
	var level := "low" if r <= 0.8 else ("high" if r > 1.05 else "standard")
	board[1].add_child(UI.label("Injury risk now: %s." % level, 13, UI.FG, "hand", true))
	return board[0]


static func _fighter(main: Node, c: Career, f: Dictionary) -> Control:
	var row := UI.hbox(6)
	row.name = "FighterMoney_" + str(f["id"])
	var face := HomeLook.face(Faces.stem(f), Vector2(20, 24))
	if face != null:
		row.add_child(face)
	var who := UI.label(str(f["name"]), 13, UI.FG, "bold")
	who.custom_minimum_size = Vector2(NAME_W, 0)
	row.add_child(who)
	var stipend := UI.hbox(4)
	stipend.custom_minimum_size = Vector2(STIPEND_W, 0)
	row.add_child(stipend)
	if bool(f.get("pro", false)):
		stipend.add_child(UI.label("purse", 12, UI.MUTED, "bold"))
	else:
		var job := bool(f.get("day_job", false))
		stipend.add_child(UI.label("off" if job else "on", 12, UI.MUTED, "bold"))
		var b := UI.button("Start %s" % UI.money(GameMoney.FIGHTER_STIPEND) if job else "Stop the stipend", "Btn",
			main.act.bind("stipend", "%s|%s" % [f["id"], "on" if job else "off"]))
		b.name = "Stipend_" + str(f["id"])
		_short_button(b)
		stipend.add_child(b)
	var earns := UI.label(_earns(f), 13, UI.GREEN if _earns(f) != "none" else UI.MUTED, "body")
	earns.custom_minimum_size = Vector2(EARNS_W, 0)
	row.add_child(earns)
	row.add_child(UI.label(_next(f), 13, UI.FG, "body"))
	return row


static func _earns(f: Dictionary) -> String:
	var b: Dictionary = f.get("bout", {})
	if b.is_empty() or bool(b.get("done", false)) or b.has("champ"):
		return "none"
	return "+%s" % UI.money(BoutRules.TICKET_CUT)


static func _next(f: Dictionary) -> String:
	var b: Dictionary = f.get("bout", {})
	if not b.is_empty() and not bool(b.get("done", false)):
		return Clock.fmt(int(b.get("day", 0)))
	var t: Dictionary = f.get("talks", {})
	if not t.is_empty():
		return "answer by %s" % Clock.fmt(int(t["until"]))
	return "nothing due"


static func _paper(title: String, icon: String, tip: String) -> Array:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# Was 10+8 on torn paper. 5+4 pays back the column frame (22 px a side) across the five cards.
	var sb := UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, 8, 5)
	sb.content_margin_bottom = 4
	p.add_theme_stylebox_override("panel", sb)
	var v := UI.vbox(2)
	p.add_child(v)
	var cap := UI.hbox(6)
	if KitIcon.has_icon(icon):
		cap.add_child(KitIcon.icon(icon, 16, WoodKit.SOFT, tip))
	var lab := UI.label(title, 13, UI.MUTED, "bold")
	lab.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cap.add_child(lab)
	v.add_child(cap)
	return [p, v]


static func _chalk(title: String) -> Array:
	var p := PanelContainer.new()
	var sb := UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, 8, 8)
	sb.content_margin_bottom = 6
	p.add_theme_stylebox_override("panel", sb)
	var v := UI.vbox(2)
	p.add_child(v)
	v.add_child(UI.label(title, 14, UI.FG, "handbold"))
	return [p, v]


static func _short_button(b: Button) -> void:
	b.add_theme_font_size_override("font_size", 16)
	b.ready.connect(func(): _tighten(b), CONNECT_ONE_SHOT)   # the theme is only reachable in the tree


static func _tighten(b: Button) -> void:
	for state in ["normal", "hover", "pressed", "disabled"]:
		var sb := b.get_theme_stylebox(state)
		if sb is StyleBoxFlat:
			var flat := (sb as StyleBoxFlat).duplicate() as StyleBoxFlat
			flat.content_margin_top = 1
			flat.content_margin_bottom = 1
			flat.content_margin_left = 6
			flat.content_margin_right = 6
			b.add_theme_stylebox_override(state, flat)
		elif sb is StyleBoxTexture:
			var tex := (sb as StyleBoxTexture).duplicate() as StyleBoxTexture
			# Choice is taller than the old plank. Clamp it back so the row does not grow.
			if tex.content_margin_top > 8:
				tex.content_margin_top = 8
			if tex.content_margin_bottom > 10:
				tex.content_margin_bottom = 10
			b.add_theme_stylebox_override(state, tex)
