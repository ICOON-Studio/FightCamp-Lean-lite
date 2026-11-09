extends SceneTree
## The books page on a real quick start. Panels by name, in and out adding up, the top bar's cash, the tag
## order, a grey tag's reason, the coaches warn mark, and every buy the old page still offered.

const UI := preload("res://scripts/ui/UI.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const MoneyTags := preload("res://scripts/ui/MoneyTags.gd")
const MAIN := preload("res://scenes/Main.tscn")

const PANELS := ["BooksPage", "CashbookPage", "InWeek", "OutWeek", "PriceTags", "FightersMoney", "ContractTalks", "CoachesPanel", "BillsPanel", "SponsorsPanel", "StaffPanel", "DuesBoard", "KitBoard", "CashChart", "PageCash", "BooksTab", "CashbookTab"]
const ACTIONS := ["Deal_ironclad", "MovePremises", "Dues_cheap", "Dues_standard", "Dues_premium", "EveningAdd", "Buy_mats", "Buy_strength", "Buy_fitkit", "Buy_youth", "Kit_low", "Kit_standard", "Kit_good", "GrantBid", "BookShow", "Repair_bags"]

var failures := 0


func _initialize() -> void:
	_rank()
	var main := MAIN.instantiate()
	root.add_child(main)
	await process_frame
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	main.act("quick")
	main.act("go", "money:0")
	await process_frame
	_page(main)
	await _fit(main)
	print("MENU_MONEY failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)


func _rank() -> void:
	var ranked: Array = MoneyTags.rank([
		{"id": "grey", "grey": true, "affordable": false, "price": 1},
		{"id": "cheap", "affordable": true, "earn": 0, "price": 200},
		{"id": "big", "affordable": true, "earn": 50, "price": 900},
		{"id": "small", "affordable": true, "earn": 5, "price": 100},
		{"id": "cage", "unbuilt": true, "affordable": false, "price": 0},
	])
	var ids: Array = []
	for it in ranked:
		ids.append(str(it["id"]))
	_check(ids == ["small", "big", "cheap", "grey", "cage"], "rank puts earners first, then cheaper, grey, then unbuilt (%s)" % str(ids))


func _page(main: Node) -> void:
	for n in PANELS:
		_check(main.find_child(n, true, false) != null, "panel " + n)
	var c: Career = main.career
	_sums(main, "InWeek", "InLine", "InTotal", int(Sim.weekly_income(c)["total"]))
	_sums(main, "OutWeek", "OutLine", "OutTotal", int(Sim.weekly_costs(c)["total"]))
	var page := main.find_child("PageCash", true, false) as Label
	var top := main.find_child("Cash", true, false)
	var top_text := ""
	if top != null and top.get_child_count() > 0 and top.get_child(0) is Label:
		top_text = (top.get_child(0) as Label).text
	_check(page != null and page.text == UI.money(c.cash) and page.text == top_text, "top bar cash matches the page (%s / %s)" % [top_text, page.text if page != null else "missing"])
	var tags := main.find_child("PriceTags", true, false)
	if tags == null or tags.get_child_count() < 2:
		_check(false, "price tags")
	else:
		var first := tags.get_child(0)
		var last := tags.get_child(tags.get_child_count() - 1)
		_check(bool(first.get_meta("affordable", false)), "the first tag is one the gym can afford")
		_check(not bool(last.get_meta("affordable", false)), "the worst tag is last")
		var greys := 0
		for t in tags.get_children():
			if not bool(t.get_meta("grey", false)):
				continue
			greys += 1
			_check(str(t.get_meta("reason", "")).length() >= 12, "grey tag has a reason")
			_check(t.find_child("Pin", true, false) == null, "grey tag has no pin")
		_check(greys > 0, "a grey tag")
	var coaches := main.find_child("CoachesPanel", true, false)
	if coaches == null:
		_check(false, "CoachesPanel")
	else:
		var warn := coaches.find_child("WarnIcon", true, false)
		_check(warn != null and str(warn.tooltip_text).find("Not built") >= 0, "coaches header has the warn icon")
		var buttons := coaches.find_children("*", "Button", true, false)
		_check(buttons.size() > 0, "coaches have buttons")
		for b in buttons:
			_check((b as Button).disabled, "coach button is off")
	for n in ACTIONS:
		var node := main.find_child(n, true, false)
		_check(node is Button, "action " + n)
	var deal := main.find_child("Deal_ironclad", true, false) as Button
	var repair := main.find_child("Repair_bags", true, false) as Button
	var book := main.find_child("BookShow", true, false) as Button
	var youth := main.find_child("Buy_youth", true, false) as Button
	_check(deal != null and not deal.disabled, "Ironclad can be signed")
	_check(repair != null and not repair.disabled, "the worn bags can be repaired")
	_check(book != null and not book.disabled, "the club show can be booked")
	_check(youth != null and not youth.disabled, "the youth section can be bought")
	var grant := main.find_child("GrantBid", true, false) as Button
	_check(grant != null and grant.disabled and grant.tooltip_text.length() >= 12, "the grant says why it is off")
	var tab := main.find_child("CashbookTab", true, false) as Button
	if tab != null:
		tab.emit_signal("pressed")
		var cashbook := main.find_child("CashbookPage", true, false)
		var books := main.find_child("BooksPage", true, false)
		_check(cashbook != null and cashbook.visible and books != null and not books.visible, "Cashbook opens")


func _sums(main: Node, box_name: String, line_name: String, total_name: String, expect: int) -> void:
	var box := main.find_child(box_name, true, false)
	var total := main.find_child(total_name, true, false)
	if box == null or total == null:
		_check(false, box_name + " rows")
		return
	var got := 0
	var lines := box.find_children(line_name + "*", "", true, false)
	_check(lines.size() > 0, box_name + " has rows")
	for line in lines:
		if not line.has_meta("amount"):
			continue
		var amount := int(line.get_meta("amount"))
		got += amount
		_check(_shown(line, amount), "%s shows %s" % [line.name, UI.money(amount)])
	_check(got == int(total.get_meta("amount", -1)) and got == expect, "%s rows %d vs total %d (week %d)" % [box_name, got, int(total.get_meta("amount", -1)), expect])
	_check(_shown(total, expect), box_name + " total is shown")


func _fit(main: Node) -> void:
	main.career.day = 40
	main.act("go", "money:0")
	await process_frame
	_hide_guide(main)
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	await process_frame
	await process_frame
	var c: Career = main.career
	var bills := main.find_child("NextBills", true, false) as Label
	_check(bills != null, "next bills line")
	if bills != null:
		var when := int(bills.get_meta("day", 0))
		var amount := int(bills.get_meta("amount", 0))
		_check(when > c.day and amount > 0, "mid-week next bill is after today and more than $0 (day %d, %d)" % [when, amount])
		var tile := ""   # S408: the bills are a tile now: the date in its caption, the amount as its number
		for l in bills.get_parent().get_children():
			tile += (l as Label).text + " " if l is Label else ""
		_check(tile.to_upper().find(Clock.fmt(when).to_upper()) >= 0 and bills.text.find(UI.money(amount)) >= 0, "the bill tile shows that date and amount (%s)" % tile)
	var scroll := _page_scroll(main)
	_check(scroll != null, "page scroll")
	if scroll != null:
		var content_h: float = scroll.get_child(0).get_combined_minimum_size().y
		_check(content_h <= scroll.size.y + 1.0, "content height %.0f <= visible %.0f at %s" % [content_h, scroll.size.y, str(root.size)])
		var view := scroll.get_global_rect()
		for n in ["DuesBoard", "KitBoard"]:
			var board := main.find_child(n, true, false) as Control
			_check(board != null and _inside(board, view), "%s is on screen" % n)
	var tags := main.find_child("PriceTags", true, false) as GridContainer
	_check(tags != null and tags.columns == 2, "price tags in two columns")
	if tags != null:
		for t in tags.get_children():
			_check((t as Control).size.y <= 130.0, "%s is %.0f px tall" % [t.name, (t as Control).size.y])
			var pin := t.find_child("Pin", true, false) as Control
			if bool(t.get_meta("grey", false)):
				_check(pin == null, t.name + " has no pin")
			elif pin != null:
				_check(pin.position.x <= 40.0 and pin.position.y <= 12.0, "%s pin sits at the top-left (%s)" % [t.name, str(pin.position)])
	var head := main.find_child("ClubHead", true, false) as Control
	_check(head != null and head.size.y <= 48.0, "club row is one line of at most 48 px (%.0f)" % (head.size.y if head != null else -1))
	var chart := main.find_child("CashChart", true, false)
	var legend := main.find_child("ChartLegend", true, false)
	_check(chart != null and legend != null, "chart and its list")
	if chart != null and legend != null:
		var marks: Array = []
		for child in chart.get_children():
			if str(child.name).begins_with("Mark"):
				marks.append(child)
		_check(chart.events.size() >= 1, "the chart has a known event")
		_check(marks.size() == chart.events.size() and legend.get_child_count() == chart.events.size(),
			"one numbered mark per event (%d marks, %d events, %d listed)" % [marks.size(), chart.events.size(), legend.get_child_count()])
		for e in chart.events:
			var n := int(e["n"])
			var mark := chart.get_node_or_null("Mark%d" % n) as Label
			_check(mark != null and mark.text == str(n), "mark %d" % n)
			var listed := false
			for lab in legend.get_children():
				if lab is Label and str((lab as Label).text).begins_with("%d  " % n):
					listed = true
			_check(listed, "the list names event %d" % n)
	await _narrow(main)


func _narrow(main: Node) -> void:
	root.size = Vector2i(1280, 720)
	await process_frame
	await process_frame
	var pairs := [["BooksBoard", "BooksSide"], ["DuesBoard", "KitBoard"], ["PriceTags", "DuesBoard"], ["ClubHead", "BooksBoard"]]
	for pair in pairs:
		var a := main.find_child(str(pair[0]), true, false) as Control
		var b := main.find_child(str(pair[1]), true, false) as Control
		_check(a != null and b != null and not _overlaps(a, b), "%s overlaps %s at 1280x720" % [pair[0], pair[1]])


func _hide_guide(main: Node) -> void:
	var strip := main.find_child("FirstWeekStrip", true, false) as CanvasItem
	if strip == null:
		return
	strip.visible = false
	var host := strip.get_parent() as CanvasItem
	if host != null:
		host.visible = false


func _page_scroll(main: Node) -> ScrollContainer:
	var page := main.find_child("BooksPage", true, false)
	var at := page
	while at != null and not (at is ScrollContainer):
		at = at.get_parent()
	return at as ScrollContainer


func _inside(node: Control, view: Rect2) -> bool:
	var r := node.get_global_rect()
	return r.position.y >= view.position.y - 1.0 and r.end.y <= view.end.y + 1.0 and r.position.x >= view.position.x - 1.0 and r.end.x <= view.end.x + 1.0


func _overlaps(a: Control, b: Control) -> bool:
	var ra := a.get_global_rect()
	var rb := b.get_global_rect()
	if ra.size.x < 2.0 or ra.size.y < 2.0 or rb.size.x < 2.0 or rb.size.y < 2.0:
		return false
	if not ra.intersects(rb, true):
		return false
	var hit := ra.intersection(rb)
	return hit.size.x > 2.0 and hit.size.y > 2.0


func _shown(node: Node, amount: int) -> bool:
	var needle := UI.money(amount)
	if node is Label and str((node as Label).text).find(needle) >= 0:
		return true
	for lab in node.find_children("*", "Label", true, false):
		if str((lab as Label).text).find(needle) >= 0:
			return true
	return false
