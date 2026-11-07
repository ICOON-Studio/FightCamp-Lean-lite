extends RefCounted
## S397 rank 5 (docs/STRUCTURE_DESIGN_S395.md 5.5, minute 0-2: "One card with the goal and the clock: keep the doors open; a
## bout on the 14th if you can find a boxer"): HOME's first card until the club's first bout - the job, the show's date and
## the days to it, the start's own stake, and you (the head coach's photo and edge). Every number is one the rules run
## (GymBills.CLOSE_AFTER_WEEKS, FirstHour.SHOW_DAY, ClubStart). Null once the first bout is fought.

const UI := preload("res://scripts/ui/UI.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")

const PHOTO := Vector2(96, 96)


static func build(main: Node, c: Career) -> Control:
	if not FirstHour.quiet(c):
		return _after(main, c)
	var card := UI.card("")
	(card[0] as Control).name = "FirstHourCard"
	# S397 round 1 (designer's 8/10): a marker-blue left bar, and the job as labelled callouts.
	var sb := StyleBoxFlat.new()
	sb.bg_color = UI.PANEL
	sb.border_color = UI.LINE
	sb.set_border_width_all(1)
	sb.border_width_left = 6
	sb.border_color = UI.GOLD
	sb.set_corner_radius_all(12)
	sb.set_content_margin_all(18)
	sb.content_margin_left = 22
	(card[0] as Control).add_theme_stylebox_override("panel", sb)
	var row := UI.hbox(18)
	card[1].add_child(row)
	var left := UI.vbox(6)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(left)
	var head := UI.hbox(10)
	head.add_child(UI.caps("THE JOB"))
	head.add_child(UI.spacer())
	var days := int(c.first_hour.get("show", FirstHour.SHOW_DAY)) - c.day
	head.add_child(UI.chip("SHOW IN %d DAY%s" % [days, "" if days == 1 else "S"] if days > 0 else "SHOW TODAY", "gold"))
	left.add_child(head)
	var lines := FirstHour.goal_lines(c, GymBills.CLOSE_AFTER_WEEKS, Clock.fmt(int(c.first_hour.get("show", FirstHour.SHOW_DAY))),
		str(ClubStart.card(c.start)["bite"]))
	var tags := ["SURVIVAL", "FIRST TARGET", "THE STAKE"]
	for i in lines.size():
		var r := UI.hbox(12)
		var tag := UI.label(str(tags[mini(i, 2)]), UI.TINY, UI.RED if i == 2 else UI.MUTED, "semi")
		tag.custom_minimum_size = Vector2(118, 0)
		tag.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		r.add_child(tag)
		var l := UI.label(str(lines[i]), UI.BODY + (1 if i < 2 else 0), UI.FG if i < 2 else UI.RED, "bold" if i < 2 else "body", true)
		l.custom_minimum_size = Vector2(300, 0)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		r.add_child(l)
		left.add_child(r)
	if not c.head.is_empty():
		row.add_child(_you(c))
	return card[0]


static func _you(c: Career) -> Control:
	var cd := HeadCoach.card(HeadCoach.of(c.head))
	var h := UI.hbox(12)
	h.custom_minimum_size = Vector2(380, 0)
	var pic := PromoShot.picture(str(cd.get("photo", "")), PHOTO)
	if pic != null:
		h.add_child(pic)
	var v := UI.vbox(2)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(UI.caps("YOU"))
	v.add_child(UI.label(str(c.head.get("name", HeadCoach.DEFAULT_NAME)), UI.BODY, UI.FG, "bold"))
	v.add_child(UI.label("%s: %s" % [cd.get("title", ""), str(cd.get("edge", "")).to_lower()], UI.SMALL, UI.GOLD, "bold", true))
	h.add_child(v)
	return h


## S398 round 4 (blind: "the first fight has no outcome on screen the Monday after"): while the club tasks run, the first show's
## result leads Home - who, how, the cards, the ticket cut, and the one line the Why ended on. Null once the guide is over.
static func _after(main: Node, c: Career) -> Control:
	if c.guide != "club" or c.results.is_empty():
		return null
	var r: Dictionary = c.results[c.results.size() - 1]   # the club's first bout (results are newest first)
	var card := UI.card("")
	(card[0] as Control).name = "FirstShowCard"
	var sb := StyleBoxFlat.new()
	sb.bg_color = UI.PANEL
	sb.border_color = UI.LINE
	sb.set_border_width_all(1)
	sb.border_width_left = 6
	sb.border_color = UI.GREEN if bool(r.get("win", false)) else UI.RED
	sb.set_corner_radius_all(12)
	sb.set_content_margin_all(18)
	sb.content_margin_left = 22
	(card[0] as Control).add_theme_stylebox_override("panel", sb)
	var v: VBoxContainer = card[1]
	v.add_child(UI.caps("THE FIRST SHOW, %s" % Clock.fmt(int(r.get("d", c.day))).to_upper()))
	var cards := str(r.get("cards", ""))
	var points := cards.contains("-") and not cards.contains("round")
	var said := "drew with" if str(r.get("outcome", "")) == "draw" else ("beat" if bool(r.get("win", false)) else "lost to")
	v.add_child(UI.label("%s %s %s%s." % [r.get("who", ""), said, r.get("opp", ""), " on points" if points else (", " + cards if cards != "" else "")],
		UI.BODY + 4, UI.GREEN if bool(r.get("win", false)) else UI.RED, "bold", true))
	if points:
		v.add_child(UI.muted("The judges: %s. The club's ticket cut is in either way." % cards, UI.SMALL, true))
	if str(r.get("why", "")) != "":
		v.add_child(UI.label(str(r["why"]), UI.BODY, UI.FG, "body", true))
	return card[0]
