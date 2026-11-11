extends RefCounted
## DUESWIRE1: the dues price on the week review, Home, the month's books and the dues boards.
## Pictures come from the boards. The 1-in number is the roll's own: HomeJuniors.chance (a second club coach adds to it).

const UI := preload("res://scripts/ui/UI.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const HomeLook := preload("res://scripts/ui/HomeLook.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")
const HomeJuniors := preload("res://scripts/state/HomeJuniors.gd")

const PAINT := "res://assets/ui/dues/dues_%s_cut.png"
const MONTHS := ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
const OPEN_YOUTH := "Buy the Youth section on Money, The books."


static func one_in(band: String, chance: float = -1.0) -> String:
	if chance < 0.0:
		chance = Membership.intake_chance(band)
	if chance <= 0.0:
		return "0"
	var n := 1.0 / chance
	var whole := roundi(n)
	if absf(n - float(whole)) > 0.02:
		return "about 1 in %d" % whole
	return "1 in %d" % whole


static func member_words(delta: int) -> String:
	if delta > 0:
		return "about +%d members" % delta
	return "about %d members" % delta


## The Monday a junior can ask. Day 0 is the first one: 5 January.
static func next_trial_day(day: int) -> int:
	var d := day
	if posmod(d, 7) != 0:
		d += 7 - posmod(d, 7)
	elif d > 0:
		d += 7
	for _i in 54:
		if HomeJuniors.INTAKE_WEEKS.has(HomeJuniors.week_of_year(d)):
			return d
		d += 7
	return d


static func trial_phrase(day: int) -> String:
	var when := Clock._date(next_trial_day(day))
	return "next trial: %d %s" % [int(when["day"]), MONTHS[int(when["month"]) - 1]]


static func trial_soon(c: Career) -> bool:
	if not GymSpend.youth_on(c):
		return false
	if HomeJuniors.section_days(c) < HomeJuniors.MIN_DAYS - HomeJuniors.PREVIEW_WEEKS * 7:
		return false
	if HomeJuniors.next_junior(c).is_empty():
		return false
	var w := HomeJuniors.week_of_year(c.day)
	return HomeJuniors.INTAKE_WEEKS.has(posmod(w + HomeJuniors.PREVIEW_WEEKS - 1, 52) + 1)


static func trial_row(main: Node, c: Career) -> Control:
	if not trial_soon(c):
		return null
	var row := PanelContainer.new()
	row.name = "JuniorTrial"
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_stylebox_override("panel", UI.box(Color("#fbf7ee"), Color(0, 0, 0, 0), 8, 0, 12, 8))
	var h := UI.hbox(12)
	row.add_child(h)
	var odds := HomeJuniors.chance(c.staff_roles.has("assistant"), c.dues_band)
	var words := "Juniors' trial in %d days: %s at today's dues" % [next_trial_day(c.day) - c.day, one_in(c.dues_band, odds)]
	var lab := UI.label(words, 22, UI.FG, "bold")
	lab.name = "JuniorTrialLine"
	lab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(lab)
	var b := UI.button("Dues", "Btn", open_dues.bind(main))
	b.name = "JuniorDues"
	b.custom_minimum_size = Vector2(96, 44)
	b.add_theme_font_size_override("font_size", 22)
	b.tooltip_text = "Club, Money, Dues."
	h.add_child(b)
	return row


static func open_dues(main: Node) -> void:
	main.act("go", "money:0")
	_press_dues.call_deferred(main)


static func _press_dues(main: Node) -> void:
	var tab := main.find_child("DuesTab", true, false) as Button
	if tab != null:
		tab.pressed.emit()


## Empty when this calendar month did not put a new price in force.
static func month_shift(c: Career) -> Dictionary:
	var band := "standard"
	var old := ""
	var saw := false
	var rows: Array = c.news.duplicate()
	rows.reverse()
	for item in rows:
		var t := str(item["t"])
		if not t.begins_with("Dues are now"):
			continue
		var now := _band_in_parens(t)
		if now == "":
			continue
		if _same_month(int(item["d"]), c.day):
			old = band
			saw = true
		band = now
	if not saw or old == "" or old == c.dues_band:
		return {}
	var mult := GymBonus.members(c.gym_plan)
	var cap := GymSpend.member_cap(c)
	var youth := GymSpend.youth_on(c)
	var a := int(Membership.band_preview(c.reputation, cap, c.dues_band, mult, youth)["members"])
	var b := int(Membership.band_preview(c.reputation, cap, old, mult, youth)["members"])
	return {"name": str(Membership.DUES[c.dues_band]["name"]), "delta": a - b}   # at today's reputation: an estimate


static func mark(band: String, px: int) -> TextureRect:
	var pic := TextureRect.new()
	pic.name = "DuesMark"
	pic.custom_minimum_size = Vector2(px, px)
	pic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	pic.texture = _paint(band)
	pic.mouse_filter = Control.MOUSE_FILTER_STOP
	pic.tooltip_text = str((Membership.DUES.get(band, Membership.DUES["standard"]) as Dictionary)["name"])
	Halo.cutout(pic)
	return pic


static func trial_card(_main: Node, c: Career) -> Control:
	var found := _intake(c)
	if found.is_empty():
		return null
	var band := str(found["band"])
	var passed: bool = found["passed"]
	var card := PanelContainer.new()
	card.name = "YouthIntake"
	card.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.06), Color(0, 0, 0, 0), 10, 0, 14, 10))   # no flat border (S427)
	var h := UI.hbox(14)
	card.add_child(h)
	h.add_child(_face(found["who"]))
	var v := UI.vbox(6)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(v)
	var title := UI.label("Came up through the youth section", 22, UI.FG, "bold")
	title.name = "YouthTitle"
	v.add_child(title)
	var nums := UI.hbox(10)
	v.add_child(nums)
	nums.add_child(mark(band, 40))
	var mid := Membership.intake_chance("standard")
	var mine := float(found["chance"])
	var col := UI.FG
	if mine > mid:
		col = UI.GREEN
	elif mine < mid:
		col = UI.RED
	var chance := UI.label(one_in(band, mine), 28, col, "bold")
	chance.name = "IntakeChance"
	chance.mouse_filter = Control.MOUSE_FILTER_STOP
	chance.tooltip_text = str(Membership.DUES[band]["name"])
	nums.add_child(chance)
	var result := UI.label("asks for a trial" if passed else "not this time", 22, UI.GREEN if passed else UI.RED, "bold")
	result.name = "IntakeResult"
	nums.add_child(result)
	return card


## Stamps the boards once Money has mounted them. One retry if the tab is still waiting.
static func mark_boards(main: Node) -> void:
	if main == null or main.career == null:
		return
	if main.find_child("Dues_cheap", true, false) == null:
		if bool(main.get_meta("dues_mark_wait", false)):
			main.remove_meta("dues_mark_wait")
			return
		main.set_meta("dues_mark_wait", true)
		mark_boards.call_deferred(main)
		return
	if main.has_meta("dues_mark_wait"):
		main.remove_meta("dues_mark_wait")
	var c: Career = main.career
	var youth := GymSpend.youth_on(c)
	var phrase := trial_phrase(c.day)
	for band in Membership.DUES_ORDER:
		var board := main.find_child("Dues_" + str(band), true, false)
		if board == null:
			continue
		var line := _hands(board)
		if line == null:
			continue
		line.mouse_filter = Control.MOUSE_FILTER_STOP
		var col := line.get_parent()
		if youth:
			line.tooltip_text = phrase
			_date_line(col, phrase)
		else:
			line.tooltip_text = OPEN_YOUTH
			_zero(line)
			var old := col.find_child("NextTrial", true, false) if col != null else null
			if old != null:
				old.queue_free()


static func _face(who: Dictionary) -> Control:
	var slot := PanelContainer.new()
	slot.name = "JuniorFace"
	slot.custom_minimum_size = Vector2(84, 84)
	slot.add_theme_stylebox_override("panel", UI.box(Color(0.16, 0.18, 0.22), Color(0, 0, 0, 0), 8, 0, 0, 0))
	var face := HomeLook.face(Faces.stem(who), Vector2(84, 84))
	if face != null:
		slot.add_child(face)
	return slot


static func _intake(c: Career) -> Dictionary:
	for item in c.news:
		if int(item["d"]) != c.day:
			continue
		var t := str(item["t"])
		var band := str(item.get("band", c.dues_band))
		var odds := float(item.get("chance", Membership.intake_chance(band)))
		if t.begins_with("Came up through the youth section: ") and t.find(" asks for a trial") >= 0:
			var name := t.trim_prefix("Came up through the youth section: ").get_slice(" asks for a trial", 0)
			var who := _by_name(name)
			return {"who": who if not who.is_empty() else {"name": name}, "passed": true, "band": band, "chance": odds}
		if t.find(" from the juniors: not this time.") >= 0:
			var first := t.get_slice(" from the juniors: not this time.", 0)
			var who := _by_first(first)
			return {"who": who if not who.is_empty() else {"name": first}, "passed": false, "band": band, "chance": odds}
	return {}


static func _by_name(name: String) -> Dictionary:
	for j in HomeJuniors.JUNIORS:
		if str(j["name"]) == name:
			return j
	return {}


static func _by_first(first: String) -> Dictionary:
	for j in HomeJuniors.JUNIORS:
		if str(j["first"]) == first:
			return j
	return {}


static func _hands(board: Node) -> Control:
	for lab in board.find_children("*", "Label", true, false):
		var t := str((lab as Label).text)
		if t == "5 years" or t == "needs a youth section":
			return lab.get_parent() as Control
	return null


static func _zero(line: Control) -> void:
	if line.find_child("HomeGrown", true, false) != null:
		return
	var col := WoodKit.SOFT
	for lab in line.get_children():
		if lab is Label:
			col = (lab as Label).get_theme_color("font_color")
	var z := UI.label("0", 32, col, "bold")
	z.name = "HomeGrown"
	line.add_child(z)
	line.move_child(z, mini(1, line.get_child_count() - 1))


static func _date_line(col: Node, phrase: String) -> void:
	if col == null:
		return
	var lab := col.find_child("NextTrial", true, false) as Label
	if lab == null:
		lab = UI.label(phrase, 24, WoodKit.INK, "bold")
		lab.name = "NextTrial"
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_child(lab)
	lab.text = phrase
	lab.tooltip_text = phrase
	lab.mouse_filter = Control.MOUSE_FILTER_STOP


static func _paint(band: String) -> Texture2D:
	if ResourceLoader.exists(PAINT % band):
		return load(PAINT % band) as Texture2D
	var img := Image.new()
	if img.load(ProjectSettings.globalize_path(PAINT % band)) != OK:
		return null
	return ImageTexture.create_from_image(img)


static func _band_in_parens(t: String) -> String:
	var a := t.rfind("(")
	var b := t.rfind(")")
	if a < 0 or b <= a:
		return ""
	var name := t.substr(a + 1, b - a - 1).strip_edges()
	for id in Membership.DUES.keys():
		if str(Membership.DUES[id]["name"]).to_lower() == name.to_lower():
			return str(id)
	return ""


static func _same_month(a: int, b: int) -> bool:
	var da := Clock._date(a)
	var db := Clock._date(b)
	return int(da["year"]) == int(db["year"]) and int(da["month"]) == int(db["month"])
