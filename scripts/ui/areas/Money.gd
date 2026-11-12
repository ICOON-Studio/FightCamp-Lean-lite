extends VBoxContainer
## The books (S403). Cash, the week in and out, what is worth buying, and the ledgers on Cashbook.
## Repairs and the contract answers moved to Cashbook. S443 proposal B (his Q-S294-198, "check markup"): four groups on one
## 1920x1080 screen - the books (tiles), in and out a week, what you can buy now, deals and staff. The in and out lines are a
## name and a signed amount, no bars (his markup: "these bars look stupid do not fit here"). Not-built rows are gone.

const UI := preload("res://scripts/ui/UI.gd")
const Tally := preload("res://scripts/ui/Tally.gd")
const WarmKit := preload("res://scripts/ui/WarmKit.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const CashChart := preload("res://scripts/ui/CashChart.gd")
const CashForecast := preload("res://scripts/rules/CashForecast.gd")
const MoneyTags := preload("res://scripts/ui/MoneyTags.gd")
const MoneyPanels := preload("res://scripts/ui/MoneyPanels.gd")
const ClubSpend := preload("res://scripts/ui/areas/ClubSpend.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const WeekRead := preload("res://scripts/rules/WeekRead.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const DuesWire := preload("res://scripts/ui/DuesWire.gd")

var _books: Control
var _cashbook: Control
var _books_tab: Button
var _cash_tab: Button


func build(main: Node) -> void:
	var wall := WarmKit.wall()
	var holder := get_parent()
	if holder != null:
		holder.add_child(wall)
		holder.move_child(wall, 0)
	add_theme_constant_override("separation", 2)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	var c: Career = main.career
	AreaHead.add(self, main, "money", [], true, true, true)
	var inc: Dictionary = Sim.weekly_income(c)
	var cost: Dictionary = Sim.weekly_costs(c)
	var ahead: Array = CashForecast.project(c, 8)
	var row := UI.hbox(8)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(row)
	row.add_child(_board(main, c, inc, cost, ahead))
	row.add_child(MoneyPanels.side(main, c, ahead))
	DuesWire.mark_boards.call_deferred(main)


func _board(main: Node, c: Career, inc: Dictionary, cost: Dictionary, ahead: Array) -> Control:
	var board := PanelContainer.new()
	board.name = "BooksBoard"
	board.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	# The old sheet inset 30+22. The frame is 22 px, so the pad is the frame and the page stays inside 1080.
	board.add_theme_stylebox_override("panel", WoodKit.slate(30, 22))
	var v := UI.vbox(2)
	board.add_child(v)
	v.add_child(_head(c, inc, cost, ahead))
	_books = _books_page(main, c, inc, cost, ahead)
	_cashbook = ClubSpend.cashbook(main, c)
	_cashbook.visible = false
	v.add_child(_books)
	v.add_child(_cashbook)
	return board


func _head(c: Career, inc: Dictionary, cost: Dictionary, ahead: Array) -> Control:
	var box := UI.vbox(2)
	var top := UI.hbox(8)
	var title := UI.label("The books, week %d" % Clock.week_of(c.day), 28, WoodKit.INK, "marker")
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title)
	_books_tab = UI.button("The books", "BtnSolid", func(): _show_books(true))
	_books_tab.name = "BooksTab"
	var lines := 0
	for e in c.ledger:
		if c.day - int(e["d"]) > ClubSpend.LEDGER_DAYS:
			break
		lines += 1
	_cash_tab = UI.button("Cashbook, %d lines" % lines, "Btn", func(): _show_books(false))
	_cash_tab.name = "CashbookTab"
	top.add_child(_books_tab)
	top.add_child(_cash_tab)
	box.add_child(top)
	box.add_child(_kpis(c, inc, cost, ahead))
	return box


func _kpis(c: Career, inc: Dictionary, cost: Dictionary, ahead: Array) -> Control:
	var net := int(inc["total"]) - int(cost["total"])
	var split: Dictionary = CashForecast.bill_split(ahead)
	var rw: Dictionary = WeekRead.runway(c.cash, c.accrued, int(inc["total"]), int(cost["total"]), c.day, c.weeks_below)
	var weeks := int(rw["weeks"])
	var hand := "grows" if weeks < 0 else "%d weeks" % weeks
	# S408 operator on a line of handwritten numbers: "this is not how games present data": labelled tiles.
	var row := UI.hbox(8)
	row.name = "MoneyTiles"
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var cash_col := UI.GREEN if c.cash >= 0 else UI.RED
	var cash := UI.label(UI.money(c.cash), 26, cash_col, "bold")
	cash.name = "PageCash"
	Tally.number(cash, "money:cash:%d" % c.get_instance_id(), c.cash, UI.money)   # S442: numbers that change roll to their new value
	row.add_child(_tile("money", "CASH", cash, "Cash in the tin", cash_col))
	var net_col := UI.GREEN if net >= 0 else UI.RED
	var net_lab := UI.label(UI.signed(net), 26, net_col, "bold")
	Tally.number(net_lab, "money:net:%d" % c.get_instance_id(), net, UI.signed)
	row.add_child(_tile("money", "NET A WEEK", net_lab, "Left over each week", net_col))
	var runway_col := UI.AMBER if weeks >= 0 and weeks < GymBills.WARN_RUNWAY_WEEKS else WoodKit.INK
	var runway := UI.label(hand, 26, runway_col, "bold")
	row.add_child(_tile("runway", "MONEY LASTS", runway, "Runway: weeks of costs the tin covers. Under 8 weeks warns. " + GymBills.line(c.cash, net, c.weeks_below), runway_col))
	var bills := UI.label(UI.money(int(split["amount"])), 26, UI.RED, "bold")
	bills.name = "NextBills"
	Tally.number(bills, "money:bills:%d" % c.get_instance_id(), int(split["amount"]), UI.money)
	bills.set_meta("day", int(split["day"]))
	bills.set_meta("amount", int(split["amount"]))
	row.add_child(_tile("calendar", "NEXT BILL %s" % Clock.fmt(int(split["day"])).to_upper(), bills, _bill_tip(c, split), UI.RED))
	var members := UI.label("%d / %d" % [c.members, GymSpend.member_cap(c)], 26, WoodKit.INK, "bold")
	var cap := GymSpend.member_cap(c)
	Tally.number(members, "money:members:%d" % c.get_instance_id(), c.members, func(n: int) -> String: return "%d / %d" % [n, cap])
	var even := _break_even(c, inc, cost)
	row.add_child(_tile("members", "MEMBERS", members, "Break-even: %d of your %d members cover what the other income leaves" % [even, c.members], WoodKit.INK))
	return row


func _books_page(main: Node, c: Career, inc: Dictionary, cost: Dictionary, ahead: Array) -> Control:
	var page := UI.hbox(14)
	page.name = "BooksPage"
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var left := UI.vbox(4)
	left.name = "InOutColumn"
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 0.8
	left.add_child(UI.label("IN AND OUT, A WEEK", UI.SMALL, UI.GOLD, "bold"))
	left.add_child(_chart(c, ahead))
	left.add_child(_io(c, inc, cost))
	left.add_child(MoneyPanels.fighters(main, c))
	page.add_child(left)
	var right := UI.vbox(4)
	right.name = "BooksRight"
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var cap := UI.hbox(10)
	cap.add_child(UI.label("WHAT YOU CAN BUY NOW", UI.SMALL, UI.GOLD, "bold"))
	cap.add_child(UI.label("net a week after it", UI.SMALL, UI.MUTED, "body"))
	right.add_child(cap)
	MoneyTags.draw(right, MoneyTags.rank(ClubSpend.items(main, c)))
	right.add_child(MoneyPanels.chalk(main, c, inc))
	page.add_child(right)
	return page


func _chart(c: Career, ahead: Array) -> Control:
	var box := UI.vbox(2)
	var past: Array = c.cash_history.slice(-12)
	if past.is_empty() or int(past[-1]["c"]) != c.cash:
		past = past.slice(-11) + [{"w": Clock.week_of(c.day), "c": c.cash}]
	var from_w := int(past[0]["w"]) if not past.is_empty() else Clock.week_of(c.day)
	var to_w := int(ahead[-1]["w"]) if not ahead.is_empty() else from_w
	var cap := UI.hbox(8)
	cap.add_child(UI.label("Cash, week %d to %d" % [from_w, to_w], 16, UI.FG, "bold"))
	cap.add_child(UI.label("dotted: if you do nothing", 16, UI.MUTED, "body"))
	box.add_child(cap)
	var chart := CashChart.new()
	chart.name = "CashChart"
	chart.points = past
	chart.future = ahead
	chart.events = CashForecast.markers(c, past.size(), ahead)
	box.add_child(chart)
	var legend := GridContainer.new()
	legend.name = "ChartLegend"
	legend.columns = 2
	legend.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	legend.add_theme_constant_override("h_separation", 8)
	legend.add_theme_constant_override("v_separation", 0)
	for e in chart.events:
		var lab := UI.label("%d  %s" % [int(e["n"]), str(e["text"])], 12, UI.FG, "hand", true)
		legend.add_child(lab)
	box.add_child(legend)
	return box


## One list: the money in (green) then out (red), a name and a signed amount each, then the totals and the week.
func _io(c: Career, inc: Dictionary, cost: Dictionary) -> Control:
	var box := UI.vbox(0)
	box.name = "InOut"
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(_col(c, "InWeek", "InLine", _in_lines(inc), true))
	box.add_child(_col(c, "OutWeek", "OutLine", _out_lines(cost), false))
	var sums := UI.hbox(8)
	sums.add_child(UI.spacer())
	sums.add_child(_sum("In", "InTotal", int(inc["total"]), true))
	sums.add_child(_sum("   Out", "OutTotal", int(cost["total"]), false))
	box.add_child(sums)
	box.add_child(_net(int(inc["total"]) - int(cost["total"])))
	return box


func _col(c: Career, box_name: String, line_name: String, lines: Array, inn: bool) -> Control:
	var box := UI.vbox(0)
	box.name = box_name
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var i := 0
	for pair in lines:
		var amount := int(pair[1])
		if amount == 0 and str(pair[0]) != "Members' dues":
			continue   # a line that is $0 this week says nothing: it comes back the week it costs or pays
		var line := UI.hbox(6)
		line.name = "%s%d" % [line_name, i]
		line.set_meta("amount", amount)
		i += 1
		if str(pair[0]) == "Members' dues":
			_fill_dues(c, line, amount)
			box.add_child(_ruled(line))
			continue
		var what := UI.label(str(pair[0]), 16, UI.FG, "body")
		what.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.add_child(what)
		line.add_child(UI.label(("+" if inn else "-") + UI.money(amount), 16, UI.GREEN if inn else UI.RED, "bold"))
		box.add_child(_ruled(line))
	return box


## A line with a faint rule under it, like a cash book.
func _ruled(line: Control) -> Control:
	var p := PanelContainer.new()
	var sb := UI.box(Color(0, 0, 0, 0), Color(0, 0, 0, 0), 0, 0, 0, 1)
	sb.border_width_bottom = 1
	sb.border_color = Color(WoodKit.SOFT, 0.18)
	p.add_theme_stylebox_override("panel", sb)
	p.add_child(line)
	return p


func _sum(word: String, node_name: String, total: int, inn: bool) -> Control:
	var row := UI.hbox(6)
	row.add_child(UI.label(word, 16, UI.MUTED, "bold"))
	var tot := UI.label(("+" if inn else "-") + UI.money(total), 16, UI.GREEN if inn else UI.RED, "bold")
	tot.name = node_name
	tot.set_meta("amount", total)
	row.add_child(tot)
	return row


func _fill_dues(c: Career, line: HBoxContainer, amount: int) -> void:
	var mark := DuesWire.mark(c.dues_band, 24)
	mark.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	line.add_child(mark)
	var words := UI.vbox(0)
	words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var title := UI.label("Members' dues", 16, UI.FG, "body")
	title.name = "DuesTitle"
	words.add_child(title)
	var shift := DuesWire.month_shift(c)
	if not shift.is_empty():
		var from := UI.label("from this month: %s" % str(shift["name"]), 20, UI.FG, "bold")
		from.name = "DuesMonth"
		words.add_child(from)
		var delta := int(shift["delta"])
		var mem := UI.label(DuesWire.member_words(delta), 20, UI.GREEN if delta >= 0 else UI.RED, "bold")
		mem.name = "DuesMembers"
		words.add_child(mem)
	line.add_child(words)
	var shown := UI.label("+" + UI.money(amount), 16, UI.GREEN, "bold")
	shown.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	line.add_child(shown)


func _in_lines(inc: Dictionary) -> Array:
	var lines: Array = [
		["Members' dues", int(inc.get("dues", 0))],
		["Fitness classes", int(inc.get("fitness", 0))],
		["Sponsors", int(inc.get("sponsors", 0))],
		["Evening classes", int(inc.get("classes", 0))],
	]
	if int(inc.get("bjj", 0)) > 0:
		lines.append(["No-gi classes", int(inc["bjj"])])
	if int(inc.get("juniors", 0)) > 0:
		lines.append(["Juniors' dues", int(inc["juniors"])])
	return lines


func _out_lines(cost: Dictionary) -> Array:
	var other := int(cost.get("fees", 0)) + int(cost.get("power", 0)) + int(cost.get("kit", 0)) + int(cost.get("upgrades", 0)) + int(cost.get("bjj", 0)) + int(cost.get("juniors_coach", 0)) + int(cost.get("loan", 0))
	var lines: Array = [
		["Coach", int(cost.get("staff", 0))],
		["Rent", int(cost.get("rent", 0))],
		["Staff", int(cost.get("staff_roles", 0))],
		["Stipends", int(cost.get("fighters", 0))],
		["Power, kit, fees", other],
	]
	return lines


func _net(net: int) -> Control:
	var row := UI.hbox(8)
	row.name = "WeekNet"
	var word := UI.label("Each week", 18, UI.FG, "bold")
	word.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(word)
	row.add_child(UI.label(UI.signed(net), 22, UI.GREEN if net >= 0 else UI.RED, "bold"))
	return row


## One number on a dark plate: an icon, what it is, the number. The plate stays dark, with a chalk outline.
func _tile(icon: String, caption: String, lab: Control, tip: String, col: Color) -> Control:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.tooltip_text = tip
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("#1b2740")
	sb.border_color = Color(WoodKit.SOFT, 0.35)
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(10)
	sb.set_content_margin_all(9)
	sb.content_margin_left = 13
	p.add_theme_stylebox_override("panel", sb)
	var h := UI.hbox(12)
	p.add_child(h)
	h.add_child(KitIcon.icon(icon, 34, col, tip))
	var v := UI.vbox(0)
	h.add_child(v)
	v.add_child(UI.label(caption, UI.SMALL, WoodKit.SOFT, "bold"))
	lab.tooltip_text = tip
	v.add_child(lab)
	return p


## What the next bill is made of (the old bills card, now the tile's hover).
func _bill_tip(c: Career, split: Dictionary) -> String:
	var tip := "Bills are paid every 28 days. Run up so far: %s." % UI.money(c.accrued)
	for pair in [["Coach", "coach"], ["Rent", "rent"], ["Staff", "staff"], ["Power, kit, fees", "other"], ["Stipends", "stipends"]]:
		if int(split.get(pair[1], 0)) > 0:
			tip += "\n%s %s" % [pair[0], UI.money(int(split[pair[1]]))]
	return tip


func _break_even(c: Career, inc: Dictionary, cost: Dictionary) -> int:
	var need := int(cost["total"]) - int(inc["total"]) + int(inc["dues"])
	var per := float(Membership.fee(c.dues_band)) / GymBills.WEEKS_A_MONTH
	if per <= 0.0:
		return 0
	return int(ceil(float(maxi(0, need)) / per))


func _show_books(on: bool) -> void:
	if _books != null:
		_books.visible = on
	if _cashbook != null:
		_cashbook.visible = not on
	if _books_tab != null:
		_books_tab.theme_type_variation = "BtnSolid" if on else "Btn"
	if _cash_tab != null:
		_cash_tab.theme_type_variation = "Btn" if on else "BtnSolid"
