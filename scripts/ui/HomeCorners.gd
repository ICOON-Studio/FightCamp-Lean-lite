extends RefCounted
## S413 operator (on Home, with a screenshot): "i dont like the design there is so much unused space and the playable area seems
## tiny". The gym now fills the window, and the few things that belong on top of it sit in the empty corners its diamond leaves.
## Bottom left stays free: the old trainer stands there in the first hour.
##   HomeCorners.add(hub, main, career)

const UI := preload("res://scripts/ui/UI.gd")
const HomeSide := preload("res://scripts/ui/HomeSide.gd")
const HomeMatch := preload("res://scripts/ui/HomeMatch.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")

const WIDTH := 400.0


static func add(hub: Control, main: Node, c: Career) -> void:
	var left := _column(hub, "CornerTopLeft", Control.PRESET_TOP_LEFT)
	left.add_child(_job(c))
	var right := _column(hub, "CornerTopRight", Control.PRESET_TOP_RIGHT)
	right.add_child(HomeSide._since(main, c))
	var low := _column(hub, "CornerBottomRight", Control.PRESET_BOTTOM_RIGHT)
	low.add_child(HomeSide._club(c))
	var more := UI.button("More below", "Btn", func(): _scroll_down(hub))
	more.name = "HomeMore"
	low.add_child(more)


static func _column(hub: Control, id: String, preset: int) -> VBoxContainer:
	var v := UI.vbox(10)
	v.name = id
	v.custom_minimum_size = Vector2(WIDTH, 0)
	v.set_anchors_and_offsets_preset(preset)
	if preset == Control.PRESET_TOP_RIGHT or preset == Control.PRESET_BOTTOM_RIGHT:
		v.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	if preset == Control.PRESET_BOTTOM_RIGHT:
		v.grow_vertical = Control.GROW_DIRECTION_BEGIN
	hub.add_child(v)
	return v


## The job until the first bout, then the next fight.
static func _job(c: Career) -> Control:
	var card := UI.card("")
	(card[0] as Control).name = "HomeJob"
	var head := UI.hbox(10)
	card[1].add_child(head)
	if FirstHour.quiet(c):
		head.add_child(UI.caps("THE JOB"))
		head.add_child(UI.spacer())
		var days := int(c.first_hour.get("show", FirstHour.SHOW_DAY)) - c.day
		head.add_child(UI.chip("SHOW IN %d DAY%s" % [days, "" if days == 1 else "S"] if days > 0 else "SHOW TODAY", "gold"))
		var lines := FirstHour.goal_lines(c, GymBills.CLOSE_AFTER_WEEKS, Clock.fmt(int(c.first_hour.get("show", FirstHour.SHOW_DAY))),
			str(ClubStart.card(c.start)["bite"]))
		card[1].add_child(UI.label(str(lines[mini(1, lines.size() - 1)]), UI.BODY, UI.FG, "bold", true))
		return card[0]
	head.add_child(UI.caps("NEXT FIGHT"))
	var f := HomeMatch.hero(c)
	var b: Dictionary = f.get("bout", {}) if not f.is_empty() else {}
	var words := "No fight booked. Offers come in on Fights."
	if b.has("opp") and b.has("day"):
		words = "%s vs %s, %s" % [f["first"], b["opp"]["name"], Clock.fmt(int(b["day"]))]
	card[1].add_child(UI.label(words, UI.BODY, UI.FG, "bold", true))
	return card[0]


## The rest of Home waits under the gym.
static func _scroll_down(hub: Control) -> void:
	var n: Node = hub
	while n != null and not n is ScrollContainer:
		n = n.get_parent()
	if n != null:
		(n as ScrollContainer).scroll_vertical = int(hub.size.y)
