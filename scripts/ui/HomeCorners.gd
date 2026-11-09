extends RefCounted
## S413 operator (on Home): "i dont like the design there is so much unused space and the playable area seems tiny". S414: "why you
## do not use it exactly as it is ?": the picture is the screen, so nothing lies over its rooms. One low shelf stands on the pavement
## at the picture's bottom edge: the job, the mail, the way down. The week's news and money are under the gym (HomeSide).
## Bottom left stays free: the old trainer stands there in the first hour.
##   HomeCorners.add(hub, main, career)

const UI := preload("res://scripts/ui/UI.gd")
const HomeMatch := preload("res://scripts/ui/HomeMatch.gd")
const HomeSide := preload("res://scripts/ui/HomeSide.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")

const NAVY := Color(0.09, 0.14, 0.26, 0.92)
const HEIGHT := 44.0
const MARGIN := 8.0
const WORDS_MIN_WIDTH := 1500.0   # a narrower window keeps the date and drops the sentence, which stays on the hover


static func add(hub: Control, main: Node, c: Career) -> void:
	var shelf := UI.hbox(10)
	shelf.name = "HomeShelf"
	shelf.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	shelf.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	shelf.grow_vertical = Control.GROW_DIRECTION_BEGIN
	shelf.offset_right = -MARGIN
	shelf.offset_bottom = -MARGIN
	hub.add_child(shelf)
	var job := _job(main, c)
	shelf.add_child(job)
	var more := UI.button("More below", "Btn", func(): _scroll_down(hub))
	more.name = "HomeMore"
	more.custom_minimum_size = Vector2(0, HEIGHT)
	shelf.add_child(more)
	var words := job.find_child("JobWords", true, false) as Control
	var fit := func(): words.visible = hub.size.x >= WORDS_MIN_WIDTH
	hub.resized.connect(fit)
	fit.call()


## The job until the first bout, then the next fight. A click goes to Fights, where either is settled.
static func _job(main: Node, c: Career) -> Control:
	var plate := PanelContainer.new()
	plate.name = "HomeJob"
	var look := StyleBoxFlat.new()
	look.bg_color = NAVY
	look.set_corner_radius_all(8)
	look.content_margin_left = 14
	look.content_margin_right = 14
	look.content_margin_top = 6
	look.content_margin_bottom = 6
	plate.add_theme_stylebox_override("panel", look)
	plate.custom_minimum_size = Vector2(0, HEIGHT)
	plate.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	plate.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			main.act("area", "fights"))
	var row := UI.hbox(12)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.add_child(row)
	var words := _words(c)
	if str(words[0]) != "":
		row.add_child(UI.chip(str(words[0]), "gold"))
	var said := UI.label(str(words[1]), 17, Color.WHITE, "bold")
	said.name = "JobWords"
	said.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(said)
	plate.tooltip_text = str(words[1])
	return plate


## [the date tag, the sentence].
static func _words(c: Career) -> Array:
	if FirstHour.quiet(c):
		var days := int(c.first_hour.get("show", FirstHour.SHOW_DAY)) - c.day
		var tag := "SHOW IN %d DAY%s" % [days, "" if days == 1 else "S"] if days > 0 else "SHOW TODAY"
		var lines := FirstHour.goal_lines(c, GymBills.CLOSE_AFTER_WEEKS, Clock.fmt(int(c.first_hour.get("show", FirstHour.SHOW_DAY))),
			str(ClubStart.card(c.start)["bite"]))
		return [tag, str(lines[mini(1, lines.size() - 1)])]
	var f := HomeMatch.hero(c)
	var b: Dictionary = f.get("bout", {}) if not f.is_empty() else {}
	if b.has("opp") and b.has("day"):
		return ["NEXT FIGHT", "%s vs %s, %s" % [f["first"], b["opp"]["name"], Clock.fmt(int(b["day"]))]]
	return ["", "No fight booked. Offers come in on Fights."]


## The rest of Home waits under the gym.
static func _scroll_down(hub: Control) -> void:
	var n: Node = hub
	while n != null and not n is ScrollContainer:
		n = n.get_parent()
	if n != null:
		(n as ScrollContainer).scroll_vertical = int(hub.size.y)
