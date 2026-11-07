extends RefCounted
## S387 the guide's strip under the top bar: the steps of the stage being played, the one being done lit, what to do and why
## (S388), and its button. It shows only while Career.guide is set; Skip ends the guide for this career.
## S397 rank 5 (ops/research/RANK5_FIRST_HOUR_S397.md): three stages - FIRST WEEK, FIRST FIGHT, THE CLUB (FirstWeek.STAGES).
## Every reason is a rule the game runs: the coach share (Sim.NO_COACH_RATING), the show's weight forecast (Sim.weigh_forecast),
## the assistant's plan at the bell (CoachPlan), the club tasks (FirstHour.tasks).

const UI := preload("res://scripts/ui/UI.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const PREP_TAB := 5   # FighterPage "Fight prep"
const PLAYBOOK_TAB := 7
const PLAN_PTAB := 1   # the Playbook's game plan


static func make(main: Node) -> Control:
	var c: Career = main.career
	FirstWeek.sync(c)
	var st := FirstWeek.stage(c)
	# S397 rank 5 round 1 (blind: double chrome above the rail): an inset whiteboard banner in the workspace, blue left edge.
	var outer := MarginContainer.new()
	outer.name = "FirstWeekStrip"
	for side in ["left", "right"]:
		outer.add_theme_constant_override("margin_" + side, 28)
	outer.add_theme_constant_override("margin_top", 18)
	var panel := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = UI.PANEL
	sb.border_color = UI.LINE
	sb.set_border_width_all(1)
	sb.border_width_left = 6
	sb.border_color = UI.GOLD
	sb.set_corner_radius_all(10)
	sb.content_margin_left = 20
	sb.content_margin_right = 16
	sb.content_margin_top = 12
	sb.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel", sb)
	outer.add_child(panel)
	var v := UI.vbox(8)
	panel.add_child(v)
	var h := UI.hbox(12)
	v.add_child(h)
	var title := UI.caps(str(st[0]) if not st.is_empty() else "FIRST WEEK")
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(title)
	if c.guide == "club":
		var done := FirstHour.tasks(c)
		for k in FirstHour.TASKS:
			var chip := UI.chip(("✓  " if bool(done[k]) else "") + str(FirstHour.TASK_WORDS[k]), "green" if bool(done[k]) else "gold")
			chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			h.add_child(chip)
	else:
		var steps: Array = st[1] if not st.is_empty() else []
		var at := steps.find(c.guide)
		for i in steps.size():
			var chip := UI.chip("%d  %s" % [i + 1, _word(c, str(steps[i]))], "green" if i < at else ("gold" if i == at else ""))
			chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			h.add_child(chip)
	h.add_child(UI.spacer())
	var wc := _weight_chip(c)   # S398 round 3 (blind: "the weight sentence pasted onto four screens"): one chip
	if wc != null:
		h.add_child(wc)
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
	var b := _step_button(main, c)
	if b != null:
		b.name = "GuideStep"
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(b)
	return outer


## What to do now, in one short line.
static func what(c: Career) -> String:
	var f := c.fighter()
	match c.guide:
		"sign":
			return "Sign your first boxer."
		"coach":
			return "Hire an assistant coach."
		"week":
			return "Set week 1."
		"offer":
			return "Take the club show." if _show_offer(c).is_empty() == false else "Answer the show's offer."
		"prep":
			return "Prepare %s for %s." % [f.get("first", "the boxer"), _opp(f)]
		"fight":
			return "Weigh-in Friday, fight Saturday."
		"club":
			return "Three jobs for the club, in any order."
	return "Run the week."


## Why it matters and how to do it.
static func why(c: Career) -> String:
	var f := c.fighter()
	var who := str(c.applicant.get("first", f.get("first", "The boxer")))
	match c.guide:
		"sign":
			return "No boxer, no fights. %s is at reception: read the card, pick one starting focus, sign." % who
		"coach":
			return "You cannot run every session: without an assistant the ones you miss run at 60%, and there are no evening classes."
		"week":
			# S397 round 2 (blind: "the weight story steers you into a loss"): the cut is decided HERE, in week 1 - by the show's
			# offer in week 2 the camp's cut alone can no longer make it (tests/first_hour_test.gd: 60.21 vs 59.87).
			if float(f.get("weight", 0.0)) > float(f.get("limit", 99.0)) and str(f.get("diet", "")) != "cut":
				return "%s is %.1f kg over for the show on %s: press Do it on the Week page to start the cut this week, then lock it." % [
					who, float(f["weight"]) - float(f["limit"]), Clock.fmt(FirstHour.SHOW_DAY)]
			return "The sessions raise %s's attributes; the days wait until this week is locked." % who
		"offer":
			return _weight_line(c, f, FirstHour.SHOW_DAY)
		"prep":
			var b: Dictionary = f.get("bout", {})
			var bits: Array = []
			if (f.get("camp", {}) as Dictionary).is_empty():
				bits.append("Set the camp on Fight prep.")
			if (f.get("arrows", []) as Array).is_empty():
				# S398 round 4: the Playbook shows starting lines before any are saved, so the line asks for one of the player's own.
				bits.append("In the Playbook, make one line against %s your own; whatever is left to chance, %s fills at the bell." % [
					_opp(f), str(c.coach.get("name", "your assistant")).get_slice(" ", 0)])
			return " ".join(bits)
		"fight":
			return "CONTINUE runs to the weigh-in; between rounds the corner minute is yours, and the result says why."
		"club":
			return "A second fighter, two camps at once and a goal that fits after a fight: running a club, not one boxer."
	return "CONTINUE plays the days. The review then shows what training gained and where the money went."


## "Lucy is 1.4 kg over the 60.0 kg limit. On the coach's weeks the scale reads 60.1 kg on the morning: 0.1 over."
static func _weight_line(c: Career, f: Dictionary, day: int) -> String:
	if f.is_empty():
		return ""
	var over := float(f["weight"]) - float(f["limit"])
	if over <= 0.0:
		return "%s is inside the %.1f kg limit." % [f["first"], f["limit"]]
	var fc := Sim.weigh_forecast(c, f, day)
	# S397 round 1 (blind: "a paragraph of kg arithmetic"): one line - now, the morning, the limit, the verdict.
	var line := "Weight: %.1f kg now, %.1f kg on the morning, limit %.1f." % [float(f["weight"]), float(fc["day"]), float(f["limit"])]
	if bool(fc["ok"]):
		return line + " Made, %.1f to spare." % maxf(0.0, float(f["limit"]) - float(fc["day"]))
	# S397 round 2: honest - once the camp cuts from today, nothing in this hour adds more; declining brings another offer.
	return line + " %.1f over even with the camp's cut: take the risk, or decline and wait for the next offer." % float(fc["over"])


## The show's weight in one chip while the first fight is on: now -> the morning / the limit, green when made.
static func _weight_chip(c: Career) -> Control:
	var f := c.fighter()
	if f.is_empty() or not ["offer", "prep", "fight"].has(c.guide) or float(f["weight"]) <= float(f["limit"]):
		return null
	var b: Dictionary = f.get("bout", {})
	var fc := Sim.weigh_forecast(c, f, int(b["day"]) if b.has("day") else FirstHour.SHOW_DAY)
	var chip := UI.chip("WEIGHT %.1f KG NOW, %.1f ON FIGHT MORNING, LIMIT %.1f" % [float(f["weight"]), float(fc["day"]), float(f["limit"])],
		"green" if bool(fc["ok"]) else "red")
	chip.name = "WeightChip"
	chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return chip


static func _opp(f: Dictionary) -> String:
	var b: Dictionary = f.get("bout", {})
	if not b.is_empty():
		return str(b["opp"].get("first", "the opponent"))
	return "the opponent"


static func _show_offer(c: Career) -> Dictionary:
	for o in c.fighter().get("offers", []):
		if not bool(o["answered"]) and not bool(o["mismatch"]):
			return o
	return {}


static func _word(c: Career, step: String) -> String:
	match step:
		"sign":
			return "Sign %s" % str(c.applicant.get("first", c.fighter().get("first", "the boxer")))
		"coach":
			return "Hire an assistant"
		"week":
			return "Set week 1"
		"offer":
			return "Take the show"
		"prep":
			return "Camp and plan"
		"fight":
			return "Weigh-in and fight"
	return "Continue"


## S397 rank 5 round 1 (blind: "one task, five signals"): the banner's button shows only where the open screen does not already
## hold that step's own button (Home's pinned note, People's Hire, the bout page's Accept, Fight prep's camp).
static func _step_button(main: Node, c: Career) -> Button:
	var f := c.fighter()
	var area := str(main.route["area"])
	var ftab := int(main.route.get("ftab", 0))
	match c.guide:
		"sign":
			var b := UI.button("Meet the walk-in", "BtnSolid", main.on_go)
			b.visible = main.route["area"] != "home"   # S394 HOME's top card has this same button
			return b
		"coach":
			return null if str(main.route["area"]) == "gym" else UI.button("Open People", "BtnSolid", main.on_go)
		"week":
			return UI.button("Lock in week 1" if main.on_week_tab() else "Open the week", "BtnSolid", main.on_go)
		"offer":
			if _show_offer(c).is_empty() or area == "home" or str(main.route.get("bout", "")) != "":
				return null
			return UI.button("Open the offer", "BtnSolid", main.on_go)
		"prep":
			var fid := str(f.get("id", ""))
			if (f.get("camp", {}) as Dictionary).is_empty():
				if area == "fighters" and ftab == PREP_TAB:
					return null
				return UI.button("Open Fight prep", "BtnSolid", func(): main.nav({"area": "fighters", "tab": 0, "fighter": fid, "ftab": PREP_TAB}))
			if area == "fighters" and ftab == PLAYBOOK_TAB:
				return null
			return UI.button("Open the Playbook", "BtnSolid", func(): main.nav({"area": "fighters", "tab": 0, "fighter": fid, "ftab": PLAYBOOK_TAB, "ptab": PLAN_PTAB}))
		"club":
			if not c.applicant.is_empty() and area != "home":
				return UI.button("Meet the walk-in", "BtnSolid", main.act.bind("interview", ""))
	return null
