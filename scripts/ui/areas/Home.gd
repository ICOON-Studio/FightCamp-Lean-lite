extends VBoxContainer
## HOME: what needs me. Needs you, your fighters | next up, money this week, news and mail.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	AreaHead.add(self, main, "home", [UI.muted("%s, %s" % [c.gym_name, Clock.fmt_long(c.day)], UI.BODY)])
	var grid := UI.hbox(16)
	add_child(grid)
	var left := UI.vbox(16)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 1.6
	var right := UI.vbox(16)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(left)
	grid.add_child(right)

	var n := Needs.needs(c)
	var needs_card := UI.card("NEEDS YOU (%d)" % n.size())
	var items: Array = []
	for x in n.slice(0, 5):
		items.append(UI.row(x["t"], x["s"], UI.RED if x["red"] else UI.AMBER,
			[UI.button(x["label"], "Btn", main.act.bind(x["act"], x["arg"]))]))
	if items.is_empty():
		items.append(UI.muted("Nothing needs you. Press CONTINUE.", UI.BODY))
	UI.add_rows(needs_card[1], items)
	left.add_child(needs_card[0])

	var fighters_card := UI.card("YOUR FIGHTERS")
	if c.fighters.is_empty():
		fighters_card[1].add_child(UI.muted("No fighters yet. Someone is waiting at reception.", UI.BODY))
	var frows: Array = []
	for f in c.fighters:
		var g := Sim.goal_read(c, f)
		var h := UI.hbox(14)
		var t := UI.vbox(1)
		t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var name_line := UI.hbox(0)
		name_line.add_child(UI.button(f["name"], "Link", main.act.bind("fighter", f["id"])))
		var record := "pro %d-%d" % [int(f.get("pro_w", 0)), int(f.get("pro_l", 0))] if bool(f.get("pro", false)) else "%d-%d" % [f["w"], f["l"]]
		name_line.add_child(UI.label(", %s %s" % [str(f["wc"]).to_lower(), record]))
		t.add_child(name_line)
		var sub := "%.1f of %.1f kg, %s" % [f["weight"], f["limit"], "fresh" if int(f["fatigue"]) < 30 else "tired"]
		if int(f.get("rank", 0)) > 0:
			sub += ", ranked %d" % int(f["rank"])
		if not g.is_empty():
			sub += ", goal: " + str(g["title"]).to_lower()
		t.add_child(UI.muted(sub, UI.SMALL, true))
		h.add_child(t)
		if not g.is_empty():
			h.add_child(UI.chip(g["status"], g["cls"]))
		var fb: Dictionary = f["bout"]
		var bout := UI.mono("bout " + Clock.fmt(int(fb["day"])) if not fb.is_empty() else "no bout", UI.SMALL, UI.MUTED)
		bout.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(bout)
		frows.append(h)
	UI.add_rows(fighters_card[1], frows)
	left.add_child(fighters_card[0])

	var next := UI.card("NEXT UP")
	var stop: Dictionary = Clock.next_stop(c)
	next[1].add_child(UI.display(Clock.fmt(int(stop["d"])), 38))
	next[1].add_child(UI.muted(stop["r"], UI.BODY))
	right.add_child(next[0])

	var money := UI.card("MONEY THIS WEEK")
	var inc: Dictionary = Sim.weekly_income(c)
	var cost: Dictionary = Sim.weekly_costs(c)
	UI.add_rows(money[1], [
		UI.kv("Cash", UI.money(c.cash), UI.FG, "mono"),
		UI.kv("Weekly in", UI.signed(int(inc["total"])), UI.GREEN, "mono"),
		UI.kv("Weekly costs, billed monthly", UI.signed(-int(cost["total"])), UI.FG, "mono"),
		UI.kv("Owed so far, billed %s" % Clock.fmt(GameMoney.next_bill_day(c.day)), UI.money(c.accrued), UI.FG, "mono"),
	])
	right.add_child(money[0])

	var news := UI.card("NEWS AND MAIL")
	var rows: Array = []
	for x in c.news.slice(0, 2):
		rows.append(UI.row(x["t"], Clock.fmt(int(x["d"]))))
	UI.add_rows(news[1], rows)
	var all := UI.button("All news", "BtnQuiet", main.act.bind("mail", ""))
	all.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	news[1].add_child(all)
	right.add_child(news[0])
