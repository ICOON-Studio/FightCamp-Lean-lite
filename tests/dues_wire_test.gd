extends SceneTree
## DUESWIRE1: the dues price shows on Home, the month's books, the dues boards and the week review.
## Walks the real screens through Main.act. Numbers come from Membership.intake_chance.
##   Godot --headless --audio-driver Dummy --path . --script res://tests/dues_wire_test.gd

const Membership := preload("res://scripts/rules/Membership.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")
const HomeJuniors := preload("res://scripts/state/HomeJuniors.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const DuesWire := preload("res://scripts/ui/DuesWire.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	var main_scene: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main_scene)
	main = main_scene
	await process_frame
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1920, 1080)
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(1920, 1080)
	for _i in 3:
		await process_frame
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	await _no_youth(c)
	await _with_youth(c)
	await _home_row(c)
	await _month_line(c)
	await _intake_card(c)
	_intake_words()
	print("DUES_WIRE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _no_youth(c: Career) -> void:
	main.act("area", "home")
	for _i in 3:
		await process_frame
	_check(main.find_child("JuniorTrial", true, false) == null, "no juniors' row without a youth section")
	await _open_dues()
	for band in Membership.DUES_ORDER:
		var board := main.find_child("Dues_" + str(band), true, false) as Control
		_check(board != null, "board %s" % band)
		if board == null:
			continue
		_check(_texts(board).has("0"), "%s reads 0 home-grown boxers without a youth section" % band)
		var line := _hands(board)
		var tip := "" if line == null else str(line.tooltip_text)
		_check(tip.find("The books") >= 0, "%s hover says how to open a youth section (%s)" % [band, tip])
		var zero := board.find_child("HomeGrown", true, false) as Control
		if zero != null:
			_on_screen(zero, "HomeGrown_" + str(band))


func _with_youth(c: Career) -> void:
	main.act("buyup", "youth")
	for o in c.upgrades:
		if str(o["id"]) == "youth":
			o["day"] = -120
	_check(GymSpend.youth_on(c), "the youth section is open")
	main.act("go", "money:0")
	for _i in 4:
		await process_frame
	await _open_dues()
	var phrase := _trial_phrase(c.day)
	_check(phrase == "next trial: 5 January", "day 0's next trial is 5 January (%s)" % phrase)
	var rects: Array[Control] = []
	for band in Membership.DUES_ORDER:
		var board := main.find_child("Dues_" + str(band), true, false) as Control
		_check(board != null, "youth board %s" % band)
		if board == null:
			continue
		var lab := board.find_child("NextTrial", true, false) as Label
		_check(lab != null and lab.text == phrase, "%s links the boxers to %s (%s)" % [band, phrase, "" if lab == null else lab.text])
		var line := _hands(board)
		_check(line != null and str(line.tooltip_text) == phrase, "%s hover is the next trial" % band)
		if lab != null:
			_on_screen(lab, "NextTrial_" + str(band))
			_px(lab, 20)
			rects.append(lab)
	_no_overlap(rects, "next trial")


func _home_row(c: Career) -> void:
	c.day = 224
	main.act("area", "home")
	for _i in 4:
		await process_frame
	var row := main.find_child("JuniorTrial", true, false) as Control
	_check(row != null and row.is_visible_in_tree(), "two weeks before the intake, Home shows the trial row")
	if row == null:
		return
	var want := "Juniors' trial in 14 days: %s at today's dues" % _one_in(c.dues_band, HomeJuniors.chance(c.staff_roles.has("assistant"), c.dues_band))
	var lab := row.find_child("JuniorTrialLine", true, false) as Label
	_check(lab != null and lab.text == want, "the row reads the dues chance (%s)" % ("" if lab == null else lab.text))
	var btn := row.find_child("JuniorDues", true, false) as Button
	_check(btn != null, "the row has one button")
	_on_screen(row, "JuniorTrial")
	if lab != null:
		_on_screen(lab, "JuniorTrialLine")
		_px(lab, 20)
	if btn != null:
		_on_screen(btn, "JuniorDues")
		_px(btn, 20)
		_no_overlap([lab, btn], "home row")
		btn.emit_signal("pressed")
	for _i in 4:
		await process_frame
	var dues := main.find_child("DuesBoard", true, false) as Control
	_check(dues != null and dues.visible, "the button opens Club > Money > Dues")


func _month_line(c: Career) -> void:
	await _open_dues()
	var cheap := main.find_child("Dues_cheap", true, false) as Button
	_check(cheap != null, "cheap board to pick")
	if cheap != null:
		cheap.emit_signal("pressed")
	for _i in 2:
		await process_frame
	var yes := main.find_child("Btn_dues", true, false) as Button
	_check(yes != null, "changing the price asks once")
	if yes != null:
		yes.emit_signal("pressed")
	for _i in 4:
		await process_frame
	_check(c.dues_band == "standard" and c.dues_band_next == "cheap", "cheap waits for the month (%s / %s)" % [c.dues_band, c.dues_band_next])
	c.day = 245
	GymSpend.end_week(c)
	_check(c.dues_band == "cheap" and c.dues_band_next == "", "from this month cheap is in force")
	main.act("go", "money:0")
	for _i in 4:
		await process_frame
	var line := main.find_child("InLine0", true, false) as Control
	_check(line != null, "the dues line is on the books")
	if line == null:
		return
	var mark := line.find_child("DuesMark", true, false) as TextureRect
	_check(mark != null and mark.texture != null, "the dues line carries the cheap picture")
	var from := line.find_child("DuesMonth", true, false) as Label
	var mem := line.find_child("DuesMembers", true, false) as Label
	var delta := _member_delta(c, "cheap", "standard")
	_check(from != null and from.text == "from this month: Cheap", "the month names the price (%s)" % ("" if from == null else from.text))
	_check(mem != null and mem.text == _member_words(delta), "the month names the members (%s, want %s)" % ["" if mem == null else mem.text, _member_words(delta)])
	_on_screen(line, "DuesLine")
	if mark != null:
		_on_screen(mark, "DuesMark")
	if from != null:
		_on_screen(from, "DuesMonth")
		_px(from, 20)
	if mem != null:
		_on_screen(mem, "DuesMembers")
		_px(mem, 20)
	_no_overlap([mark, from, mem], "dues line")


func _intake_card(c: Career) -> void:
	c.day = 364
	for o in c.upgrades:
		if str(o["id"]) == "youth":
			o["day"] = c.day - 200
	# S434 collect: a price change that starts this same Monday lands after the roll; the card shows the roll's price.
	c.dues_band_next = "premium"
	Sim.end_week(c)
	_check(c.dues_band == "premium", "the January change came in on the intake Monday (%s)" % c.dues_band)
	main.act("review")
	for _i in 4:
		await process_frame
	var card := main.find_child("YouthIntake", true, false) as Control
	_check(card != null and card.is_visible_in_tree(), "the intake week review shows the youth card")
	if card == null:
		return
	var words := _blob(card)
	_check(words.find("Came up through the youth section") >= 0, "the card says the youth section")
	var want := _one_in("cheap", HomeJuniors.chance(c.staff_roles.has("assistant"), "cheap"))
	_check(words.find(want) >= 0, "the card shows the chance the roll had at cheap dues (%s in %s)" % [want, words])
	var passed := words.find("asks for a trial") >= 0
	var missed := words.find("not this time") >= 0
	_check(passed != missed, "the card shows one result (%s)" % words)
	var news_pass := false
	for item in c.news:
		if int(item["d"]) == c.day and str(item["t"]).find(" asks for a trial") >= 0:
			news_pass = true
	_check(passed == news_pass, "the result matches the week (card pass %s, news %s)" % [passed, news_pass])
	var face := card.find_child("JuniorFace", true, false) as Control
	var chance := card.find_child("IntakeChance", true, false) as Label
	var result := card.find_child("IntakeResult", true, false) as Label
	var pic := card.find_child("DuesMark", true, false) as TextureRect
	_check(face != null, "the card has the junior's face slot")
	_check(pic != null and pic.texture != null, "the card shows the price in force")
	_on_screen(card, "YouthIntake")
	if pic != null:
		_on_screen(pic, "IntakeMark")
	if face != null:
		_on_screen(face, "JuniorFace")
	if chance != null:
		_on_screen(chance, "IntakeChance")
		_px(chance, 20)
	if result != null:
		_on_screen(result, "IntakeResult")
		_px(result, 20)
	_no_overlap([face, chance, result, pic], "intake card")


## S434 collect: both intake news lines read back (the seeded week above shows only one of them).
func _intake_words() -> void:
	var c2 := Career.quick_start()
	var mia: Dictionary = HomeJuniors.JUNIORS[0]
	c2.news = [{"d": c2.day, "t": "%s from the juniors: not this time. The next intake is in the new term." % mia["first"], "band": "cheap", "chance": 0.6}]
	var no: Dictionary = DuesWire._intake(c2)
	_check(not no.is_empty() and not bool(no["passed"]) and str(no["who"].get("id", "")) == str(mia["id"]) and str(no["band"]) == "cheap"
		and absf(float(no["chance"]) - 0.6) < 1e-6, "a missed intake reads back: %s, cheap, 0.6 (%s)" % [mia["first"], no])
	c2.news = [{"d": c2.day, "t": "Came up through the youth section: %s asks for a trial (Fighters > Find a fighter). Half the stipend for a year." % mia["name"], "band": "premium", "chance": 0.2}]
	var yes: Dictionary = DuesWire._intake(c2)
	_check(not yes.is_empty() and bool(yes["passed"]) and str(yes["who"].get("id", "")) == str(mia["id"]) and str(yes["band"]) == "premium",
		"a passed intake reads back: %s, premium (%s)" % [mia["name"], yes])
	c2.news = [{"d": c2.day - 7, "t": "%s from the juniors: not this time. The next intake is in the new term." % mia["first"]}]
	_check(DuesWire._intake(c2).is_empty(), "last week's intake news makes no card this week")


func _open_dues() -> void:
	var tab := main.find_child("DuesTab", true, false) as Button
	if tab == null:
		main.act("go", "money:0")
		for _i in 4:
			await process_frame
		tab = main.find_child("DuesTab", true, false) as Button
	_check(tab != null, "the Dues tab is on the money page")
	if tab != null:
		tab.emit_signal("pressed")
	for _i in 3:
		await process_frame


func _one_in(band: String, chance: float = -1.0) -> String:
	if chance < 0.0:
		chance = Membership.intake_chance(band)
	var n := 1.0 / chance
	var whole := roundi(n)
	if absf(n - float(whole)) > 0.02:
		return "about 1 in %d" % whole
	return "1 in %d" % whole


func _member_delta(c: Career, now: String, old: String) -> int:
	var mult := GymBonus.members(c.gym_plan)
	var cap := GymSpend.member_cap(c)
	var youth := GymSpend.youth_on(c)
	var a := int(Membership.band_preview(c.reputation, cap, now, mult, youth)["members"])
	var b := int(Membership.band_preview(c.reputation, cap, old, mult, youth)["members"])
	return a - b


func _member_words(delta: int) -> String:
	if delta > 0:
		return "about +%d members" % delta
	return "about %d members" % delta


func _trial_phrase(day: int) -> String:
	var d := day
	if posmod(d, 7) != 0:
		d += 7 - posmod(d, 7)
	elif d > 0:
		d += 7
	for _i in 54:
		if HomeJuniors.INTAKE_WEEKS.has(HomeJuniors.week_of_year(d)):
			break
		d += 7
	var when := Clock._date(d)
	var months := ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	return "next trial: %d %s" % [int(when["day"]), months[int(when["month"]) - 1]]


func _hands(board: Node) -> Control:
	for lab in board.find_children("*", "Label", true, false):
		var t := str((lab as Label).text)
		if t == "5 years" or t == "needs a youth section":
			return lab.get_parent() as Control
	return null


func _texts(node: Node) -> PackedStringArray:
	var out: PackedStringArray = []
	for lab in node.find_children("*", "Label", true, false):
		out.append(str((lab as Label).text))
	return out


func _blob(node: Node) -> String:
	var bits := ""
	for lab in node.find_children("*", "Label", true, false):
		bits += (lab as Label).text + " "
	return bits


func _on_screen(node: Control, what: String) -> void:
	var r := node.get_global_rect()
	print("DUES_WIRE rect %s %.0f,%.0f %.0fx%.0f" % [what, r.position.x, r.position.y, r.size.x, r.size.y])
	_check(r.size.x > 2.0 and r.size.y > 2.0, "%s has a size" % what)
	_check(r.position.x >= -1.0 and r.position.y >= -1.0 and r.end.x <= 1921.0 and r.end.y <= 1081.0, "%s stays on the 1920x1080 screen (%.0f,%.0f %.0fx%.0f)" % [what, r.position.x, r.position.y, r.size.x, r.size.y])


func _no_overlap(nodes: Array, what: String) -> void:
	for i in nodes.size():
		if nodes[i] == null:
			continue
		for j in range(i + 1, nodes.size()):
			if nodes[j] == null:
				continue
			var a := (nodes[i] as Control).get_global_rect()
			var b := (nodes[j] as Control).get_global_rect()
			if not a.intersects(b, true):
				continue
			var hit := a.intersection(b)
			_check(hit.size.x <= 1.0 or hit.size.y <= 1.0, "%s overlap %s / %s" % [what, str((nodes[i] as Node).name), str((nodes[j] as Node).name)])


func _px(node: CanvasItem, min_px: int) -> void:
	var px := 0
	if node is Label:
		px = (node as Label).get_theme_font_size("font_size")
	elif node is Button:
		px = (node as Button).get_theme_font_size("font_size")
	_check(px >= min_px, "%s is %d px" % [str(node.name), px])


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
