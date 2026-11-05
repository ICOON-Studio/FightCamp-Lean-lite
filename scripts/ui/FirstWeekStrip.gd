extends RefCounted
## S387 the guide's strip under the top bar: the four first-week steps, the one being done lit, what to do and why (S388), and its
## button. It shows only while Career.guide is set; Skip ends the guide for this career.

const UI := preload("res://scripts/ui/UI.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")


static func make(main: Node) -> Control:
	var c: Career = main.career
	FirstWeek.sync(c)
	var at := FirstWeek.index(c)
	var panel := PanelContainer.new()
	panel.name = "FirstWeekStrip"
	panel.theme_type_variation = "TopBar"
	var v := UI.vbox(8)
	panel.add_child(v)
	var h := UI.hbox(12)
	v.add_child(h)
	var title := UI.caps("FIRST WEEK")
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(title)
	for i in FirstWeek.STEPS.size():
		var txt := "%d  %s" % [i + 1, _word(c, FirstWeek.STEPS[i])]
		var chip := UI.chip(txt, "green" if i < at else ("gold" if i == at else ""))
		chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(chip)
	h.add_child(UI.spacer())
	var skip := UI.button("Skip the guide", "BtnQuiet", main.act.bind("guideskip", ""))
	skip.name = "GuideSkip"
	skip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(skip)
	# S388 operator: "there should be a guid explainaing to player what and why to do": the step, then the reason, on every screen.
	var row := UI.hbox(12)
	v.add_child(row)
	var say := UI.vbox(2)
	say.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(say)
	var what_line := UI.label(what(c), UI.BODY, UI.FG, "bold", true)
	what_line.name = "GuideWhat"
	say.add_child(what_line)
	var why_line := UI.muted(why(c), UI.SMALL, true)
	why_line.name = "GuideWhy"
	say.add_child(why_line)
	if c.guide != "go":
		var b := UI.button(_button(main, c), "BtnSolid", main.on_go)
		b.name = "GuideStep"
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(b)
	return panel


## What to do now, in one short line.
static func what(c: Career) -> String:
	match c.guide:
		"sign":
			return "Sign your first boxer."
		"coach":
			return "Hire a coach."
		"week":
			return "Set week 1."
	return "Run the week."


## Why it matters and how to do it; every reason is a rule the game really runs (coach 60%: Sim.NO_COACH_RATING, Needs).
static func why(c: Career) -> String:
	var who := str(c.applicant.get("first", c.fighter().get("first", "The boxer")))
	match c.guide:
		"sign":
			return "No boxer, no fights: the gym needs someone to train and book. %s is at reception: read the card, pick one starting focus, sign." % who
		"coach":
			return "Without a coach, %s trains at 60%%. A coach also runs the evening classes, which bring money in. Pick one of two: Gym, then Staff." % who
		"week":
			return "Sessions are what raise %s's attributes, and the days wait until this plan is locked. Change the sessions if you want, then lock it." % who
	return "CONTINUE plays the days. The review then shows what training gained and where the money went."


static func _word(c: Career, step: String) -> String:
	match step:
		"sign":
			return "Sign %s" % str(c.applicant.get("first", c.fighter().get("first", "the boxer")))
		"coach":
			return "Hire a coach"
		"week":
			return "Set week 1"
	return "Continue"


static func _button(main: Node, c: Career) -> String:
	match c.guide:
		"sign":
			return "Meet the walk-in"
		"coach":
			return "Open Staff"
	return "Lock in week 1" if main.on_week_tab() else "Open the week"
