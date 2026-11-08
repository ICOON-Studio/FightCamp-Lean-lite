extends VBoxContainer
## The books (S403). Cash, the week in and out, what is worth buying, and the ledgers on Cashbook.
## Repairs and the contract answers moved to Cashbook. The cage and the coach list are not built.

const UI := preload("res://scripts/ui/UI.gd")
const WarmKit := preload("res://scripts/ui/WarmKit.gd")
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


func _board(main: Node, c: Career, inc: Dictionary, cost: Dictionary, ahead: Array) -> Control:
	var board := WarmKit.panel("board")
	board.name = "BooksBoard"
	board.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_inset(board, 30, 22, 32)   # clear of the aluminium frame
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
	var title := UI.label("The books, week %d" % Clock.week_of(c.day), 28, UI.GOLD, "marker")
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
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 12)
	row.add_theme_constant_override("v_separation", 2)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var cash := UI.label(UI.money(c.cash), 15, UI.GREEN if c.cash >= 0 else UI.RED, "handbold")
	cash.name = "PageCash"
	row.add_child(_bit("money", cash, "Cash in the tin", UI.GREEN if c.cash >= 0 else UI.RED))
	var members := UI.label("%d of %d members" % [c.members, GymSpend.member_cap(c)], 14, UI.FG, "handbold")
	var even := _break_even(c, inc, cost)
	row.add_child(_bit("members", members, "Break-even: %d of your %d members cover what the other income leaves" % [even, c.members], UI.FG))
	var runway := UI.label("%s in hand" % hand, 14, UI.AMBER if weeks >= 0 and weeks < GymBills.WARN_RUNWAY_WEEKS else UI.FG, "handbold")
	row.add_child(_bit("runway", runway, "Runway: weeks of costs the tin covers. Under 8 weeks warns. " + GymBills.line(c.cash, net, c.weeks_below), UI.FG))
	var net_lab := UI.label("Net %s a week" % UI.signed(net), 14, UI.GREEN if net >= 0 else UI.RED, "handbold")
	row.add_child(_bit("money", net_lab, "Left over each week", UI.GREEN if net >= 0 else UI.RED))
	var bills := UI.label("Next bills %s, %s" % [Clock.fmt(int(split["day"])), UI.money(int(split["amount"]))], 14, UI.RED, "handbold")
	bills.name = "NextBills"
	bills.set_meta("day", int(split["day"]))
	bills.set_meta("amount", int(split["amount"]))
	row.add_child(_bit("calendar", bills, "Bills are paid every 28 days. Run up so far: %s." % UI.money(c.accrued), UI.RED))
	return row


func _books_page(main: Node, c: Career, inc: Dictionary, cost: Dictionary, ahead: Array) -> Control:
	var page := UI.hbox(10)
	page.name = "BooksPage"
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var left := UI.vbox(2)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 1.05
	left.add_child(_chart(c, ahead))
	left.add_child(_io(inc, cost))
	left.add_child(_net(int(inc["total"]) - int(cost["total"])))
	left.add_child(MoneyPanels.fighters(main, c))
	page.add_child(left)
	var right := UI.vbox(2)
	right.name = "BooksRight"
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var cap := UI.hbox(8)
	cap.add_child(UI.label("Price tags, what fits now first", 16, UI.GOLD, "handbold"))
	cap.add_child(UI.label("Red pin: buy. Green: ours. Grey: not usable now.", 12, UI.MUTED, "body"))
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
	cap.add_child(UI.label("Cash, week %d to %d" % [from_w, to_w], 16, UI.GOLD, "handbold"))
	cap.add_child(UI.label("dotted: if you do nothing", 12, UI.MUTED, "hand"))
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


func _io(inc: Dictionary, cost: Dictionary) -> Control:
	var row := UI.hbox(10)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var scale := 1   # the bars compare the lines with each other: the biggest line is the longest bar
	for pair in _in_lines(inc) + _out_lines(cost):
		scale = maxi(scale, int(pair[1]))
	row.add_child(_col("In, a week", "InWeek", "InLine", "InTotal", _in_lines(inc), int(inc["total"]), scale, true))
	row.add_child(_col("Out, a week", "OutWeek", "OutLine", "OutTotal", _out_lines(cost), int(cost["total"]), scale, false))
	return row


func _col(title: String, box_name: String, line_name: String, total_name: String, lines: Array, total: int, scale: int, inn: bool) -> Control:
	var box := UI.vbox(1)
	box.name = box_name
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(UI.label(title, 15, UI.GOLD, "handbold"))
	var i := 0
	for pair in lines:
		var amount := int(pair[1])
		var line := UI.hbox(6)
		line.name = "%s%d" % [line_name, i]
		line.set_meta("amount", amount)
		var name := UI.label(str(pair[0]), 13, UI.FG, "hand")
		name.custom_minimum_size = Vector2(96, 0)
		line.add_child(name)
		var bar := ColorRect.new()
		bar.custom_minimum_size = Vector2(maxf(4.0, 90.0 * float(amount) / float(scale)) if amount > 0 else 0.0, 6)
		bar.color = UI.GREEN if inn else UI.RED
		bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		line.add_child(bar)
		var shown := UI.label(("+" if inn else "-") + UI.money(amount), 13, UI.GREEN if inn else UI.RED, "handbold")
		shown.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		shown.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		line.add_child(shown)
		box.add_child(line)
		i += 1
	if not inn:
		var mma := UI.hbox(6)
		mma.name = "MmaLine"
		mma.add_child(UI.label("MMA fees, travel", 13, UI.MUTED, "body"))
		mma.add_child(UI.label("unpriced", 13, UI.MUTED, "body"))
		mma.add_child(KitIcon.icon("warn", 16, Color("C9770F"), "Not built yet"))
		box.add_child(mma)
	var sum := UI.hbox(8)
	var word := UI.label("in" if inn else "out", 16, UI.FG, "handbold")
	word.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sum.add_child(word)
	var tot := UI.label(("+" if inn else "-") + UI.money(total), 16, UI.GREEN if inn else UI.RED, "handbold")
	tot.name = total_name
	tot.set_meta("amount", total)
	sum.add_child(tot)
	box.add_child(sum)
	return box


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
	row.add_child(UI.label("Each week the tin grows" if net >= 0 else "Each week the tin shrinks", 16, UI.FG, "hand"))
	var ring := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, 0)
	sb.border_color = UI.GREEN if net >= 0 else UI.RED
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(14)
	sb.content_margin_left = 8
	sb.content_margin_right = 8
	ring.add_theme_stylebox_override("panel", sb)
	ring.add_child(UI.label(UI.signed(net), 18, UI.GREEN if net >= 0 else UI.RED, "handbold"))
	row.add_child(ring)
	return row


func _bit(icon: String, lab: Control, tip: String, col: Color) -> Control:
	var h := UI.hbox(4)
	h.tooltip_text = tip
	h.add_child(KitIcon.icon(icon, 20, col, tip))
	lab.tooltip_text = tip
	h.add_child(lab)
	return h


func _break_even(c: Career, inc: Dictionary, cost: Dictionary) -> int:
	var need := int(cost["total"]) - int(inc["total"]) + int(inc["dues"])
	var per := float(Membership.fee(c.dues_band)) / GymBills.WEEKS_A_MONTH
	if per <= 0.0:
		return 0
	return int(ceil(float(maxi(0, need)) / per))


func _inset(panel: PanelContainer, top: float, bottom: float, side: float) -> void:
	var src := panel.get_theme_stylebox("panel")
	if not (src is StyleBoxTexture):
		return
	var copy := (src as StyleBoxTexture).duplicate() as StyleBoxTexture
	copy.content_margin_top = top
	copy.content_margin_bottom = bottom
	copy.content_margin_left = side
	copy.content_margin_right = side
	panel.add_theme_stylebox_override("panel", copy)


func _show_books(on: bool) -> void:
	if _books != null:
		_books.visible = on
	if _cashbook != null:
		_cashbook.visible = not on
	if _books_tab != null:
		_books_tab.theme_type_variation = "BtnSolid" if on else "Btn"
	if _cash_tab != null:
		_cash_tab.theme_type_variation = "Btn" if on else "BtnSolid"
