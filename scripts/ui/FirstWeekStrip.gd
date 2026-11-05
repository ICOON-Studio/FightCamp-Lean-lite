extends RefCounted
## S387 the guide's strip under the top bar: the four first-week steps, the one being done lit, and its button. It shows only while
## Career.guide is set; Skip ends the guide for this career.

const UI := preload("res://scripts/ui/UI.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")


static func make(main: Node) -> Control:
	var c: Career = main.career
	FirstWeek.sync(c)
	var at := FirstWeek.index(c)
	var panel := PanelContainer.new()
	panel.name = "FirstWeekStrip"
	panel.theme_type_variation = "TopBar"
	var h := UI.hbox(12)
	panel.add_child(h)
	var title := UI.caps("FIRST WEEK")
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(title)
	for i in FirstWeek.STEPS.size():
		var txt := "%d  %s" % [i + 1, _word(c, FirstWeek.STEPS[i])]
		var chip := UI.chip(txt, "green" if i < at else ("gold" if i == at else ""))
		chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(chip)
	h.add_child(UI.spacer())
	var line := UI.muted(_line(c), UI.SMALL)
	line.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(line)
	if c.guide != "go":
		var b := UI.button(_button(main, c), "BtnSolid", main.on_go)
		b.name = "GuideStep"
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(b)
	var skip := UI.button("Skip the guide", "BtnQuiet", main.act.bind("guideskip", ""))
	skip.name = "GuideSkip"
	skip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(skip)
	return panel


static func _word(c: Career, step: String) -> String:
	match step:
		"sign":
			return "Sign %s" % str(c.applicant.get("first", c.fighter().get("first", "the boxer")))
		"coach":
			return "Hire a coach"
		"week":
			return "Set week 1"
	return "Continue"


static func _line(c: Career) -> String:
	match c.guide:
		"sign":
			return "The walk-in at reception is the first fighter."
		"coach":
			return "Pick one of two coaches: Gym, then Staff."
		"week":
			return "Change the sessions if you want, then lock the week."
	return "Press CONTINUE: the week runs to the review."


static func _button(main: Node, c: Career) -> String:
	match c.guide:
		"sign":
			return "Meet the walk-in"
		"coach":
			return "Open Staff"
	return "Lock in week 1" if main.on_week_tab() else "Open the week"
