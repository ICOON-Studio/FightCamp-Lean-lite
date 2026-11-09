extends RefCounted
## S413 operator, Q-S294-140 "Yes, build him": the guide is a person. An old trainer in the corner says one short line (GuideLines),
## its button beside it, and a warm light marks the thing to touch (GuideLight). The what and the why stay as the bubble's tooltip.
## It shows only while Career.guide is set; Skip ends the guide for this career.
## S397 rank 5 (ops/research/RANK5_FIRST_HOUR_S397.md): three stages - FIRST WEEK, FIRST FIGHT, THE CLUB (FirstWeek.STAGES).
## Every reason is a rule the game runs: the coach share (Sim.NO_COACH_RATING), the show's weight forecast (Sim.weigh_forecast),
## the assistant's plan at the bell (CoachPlan), the club tasks (FirstHour.tasks).

const UI := preload("res://scripts/ui/UI.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GuideLines := preload("res://scripts/rules/GuideLines.gd")
const GuideLight := preload("res://scripts/ui/GuideLight.gd")

const PORTRAIT := "res://assets/ui/art/guide_trainer.png"
const PORTRAIT_PX := 190.0
const TAIL_W := 24.0
const BUBBLE_TEXT_W := 400.0
const BUBBLE := Color("#fbf1df")
const BUBBLE_EDGE := Color("#231f1b")
const BUBBLE_INK := Color("#231f1b")

const PREP_TAB := 5   # FighterPage "Fight prep"
const PLAYBOOK_TAB := 7
const PLAN_PTAB := 1   # the Playbook's game plan


static func make(main: Node) -> Control:
	var c: Career = main.career
	FirstWeek.sync(c)
	var light := GuideLight.new()
	light.name = "FirstWeekStrip"
	light.main = main
	light.names = GuideLines.target_names(c)
	var corner := UI.hbox(0)
	corner.name = "GuideCorner"
	corner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	corner.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	corner.offset_left = 14.0
	corner.offset_bottom = -14.0
	corner.grow_vertical = Control.GROW_DIRECTION_BEGIN
	light.add_child(corner)
	corner.add_child(_portrait())
	corner.add_child(_tail())
	corner.add_child(_bubble(main, c))
	return light


## S416 operator: "there is nothing after you write one line ?": a panel that changes the step without redrawing the page calls this.
static func refresh(main: Node) -> void:
	var old: Node = main.find_child("FirstWeekStrip", true, false)
	if old == null:
		return
	var parent: Node = old.get_parent()
	parent.remove_child(old)
	old.queue_free()
	parent.add_child(make(main))


static func _portrait() -> Control:
	var t := TextureRect.new()
	t.name = "GuideFace"
	t.texture = load(PORTRAIT)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = Vector2(PORTRAIT_PX, PORTRAIT_PX)
	t.size_flags_vertical = Control.SIZE_SHRINK_END
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t


## The speech bubble's point, aimed at the old trainer.
static func _tail() -> Control:
	var slot := Control.new()
	slot.custom_minimum_size = Vector2(TAIL_W, 40)
	slot.size_flags_vertical = Control.SIZE_SHRINK_END
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for layer in [[BUBBLE_EDGE, 4.0], [BUBBLE, 0.0]]:
		var p := Polygon2D.new()
		var g := float(layer[1])
		p.polygon = PackedVector2Array([Vector2(-2.0 - g, 22.0), Vector2(TAIL_W + 3.0, 2.0 - g), Vector2(TAIL_W + 3.0, 38.0 + g)])
		p.color = layer[0]
		slot.add_child(p)
	return slot


static func _bubble(main: Node, c: Career) -> Control:
	var panel := PanelContainer.new()
	panel.name = "GuideBubble"
	panel.size_flags_vertical = Control.SIZE_SHRINK_END
	panel.add_theme_stylebox_override("panel", UI.box(BUBBLE, BUBBLE_EDGE, 24, 3, 22, 14))
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var why_text := why(c)
	panel.tooltip_text = what(c) + ("\n" + why_text if why_text != "" else "")
	var v := UI.vbox(10)
	panel.add_child(v)
	var said := UI.label(GuideLines.line(c), 27, BUBBLE_INK, "handbold", true)
	said.name = "GuideWhat"
	said.custom_minimum_size = Vector2(BUBBLE_TEXT_W, 0)
	v.add_child(said)
	var row := UI.hbox(12)
	v.add_child(row)
	var b := _step_button(main, c)
	if b != null:
		b.name = "GuideStep"
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(b)
	row.add_child(UI.spacer())
	var skip := UI.button("Skip the guide", "BtnQuiet", main.act.bind("guideskip", ""))
	skip.name = "GuideSkip"
	skip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(skip)
	return panel


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
			if c.applicant.is_empty():
				return "No boxer, no fights, and nobody is at reception now. The Find a fighter tab lists boxers looking for a gym: a trial is free."
			return "No boxer, no fights. %s is at reception: read the card, pick one starting focus, sign." % who
		"coach":
			return "You cannot run every session: without an assistant the ones you miss run at 60%, and there are no evening classes."
		"week":
			# S416 operator: no fight, no cut talk. The boxer starts nearer the limit, so a cut from the offer makes weight.
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


## S397 rank 5 round 1 (blind: "one task, five signals"): the banner's button shows only where the open screen does not already
## hold that step's own button (Home's pinned note, People's Hire, the bout page's Accept, Fight prep's camp).
static func _step_button(main: Node, c: Career) -> Button:
	var f := c.fighter()
	var area := str(main.route["area"])
	var ftab := int(main.route.get("ftab", 0))
	match c.guide:
		"sign":
			if c.applicant.is_empty():
				return null if area == "fighters" and int(main.route.get("tab", 0)) == 3 else UI.button("Find a fighter", "BtnSolid", main.act.bind("go", "fighters:3"))
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
