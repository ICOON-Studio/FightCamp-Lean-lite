extends RefCounted
## S413 operator, Q-S294-140 "Yes, build him": the guide is a person. Since S533 (Q-S294-287 "C clipboard") his clipboard: the stage's jobs ticked off (GuideClipboard), his line (GuideLines),
## its button beside it, and a warm light marks the thing to touch (GuideLight). The what and the why stay as the bubble's tooltip.
## It shows only while Career.guide is set; Skip ends the guide for this career.
## S397 rank 5 (ops/research/RANK5_FIRST_HOUR_S397.md): three stages - FIRST WEEK, FIRST FIGHT, THE CLUB (FirstWeek.STAGES).
## Every reason is a rule the game runs: the coach share (Sim.NO_COACH_RATING), the show's weight forecast (Sim.weigh_forecast),
## the assistant's plan at the bell (CoachPlan), the club tasks (FirstHour.tasks).

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const GuideLines := preload("res://scripts/rules/GuideLines.gd")
const GuideLight := preload("res://scripts/ui/GuideLight.gd")
const Lessons := preload("res://scripts/rules/Lessons.gd")
const Tip := preload("res://scripts/ui/Tip.gd")
const Board := preload("res://scripts/ui/GuideClipboard.gd")   # S533 Q-287 "C clipboard"

const PORTRAIT := "res://assets/ui/art/guide_trainer.png"
const FACE_PX := 92.0   # S533 clipboard: a small round face on the board (was a 190 px portrait beside a bubble)
const BUBBLE_TEXT_W := 400.0




const PREP_TAB := 5   # FighterPage "Fight prep"
const PLAYBOOK_TAB := 7
const PLAN_PTAB := 1   # the Playbook's game plan

static var _page := ""   # the page the strip was last drawn on: leaving it is what teaches its line
static var _page_career := 0   # ... in this career (another career starts clean)


static func make(main: Node) -> Control:
	var c: Career = main.career
	FirstWeek.sync(c)
	var light := GuideLight.new()
	light.name = "FirstWeekStrip"
	light.main = main
	light.names = GuideLines.target_names(c)
	light.step = c.guide   # S532 GUIDETIPS1: explore first - the light waits for SHOW ME (GuideLight.show_step)
	var page := Lessons.page_id(main.route)
	if _page_career != c.get_instance_id():
		_page_career = c.get_instance_id()
		_page = ""
	if page != _page:
		Lessons.left(c.lessons, _page)
		_page = page
	var corner := UI.hbox(0)
	corner.name = "GuideCorner"
	corner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	corner.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	corner.offset_left = 14.0
	corner.offset_bottom = -14.0
	corner.grow_vertical = Control.GROW_DIRECTION_BEGIN
	light.add_child(corner)
	var board := UI.vbox(-16)   # S533 Q-287: the trainer's clipboard - the clip sits over the top edge
	board.mouse_filter = Control.MOUSE_FILTER_IGNORE
	board.size_flags_vertical = Control.SIZE_SHRINK_END
	board.add_child(_bubble(main, c))
	board.add_child(Board.clip())
	board.move_child(board.get_child(1), 0)
	corner.add_child(board)
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


static func _bubble(main: Node, c: Career) -> Control:
	var panel := PanelContainer.new()
	panel.name = "GuideBubble"
	panel.size_flags_vertical = Control.SIZE_SHRINK_END
	panel.add_theme_stylebox_override("panel", Board.paper())
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var why_text := why(c)
	panel.tooltip_text = what(c) + ("\n" + why_text if why_text != "" else "")
	var v := UI.vbox(10)
	panel.add_child(v)
	var head := UI.hbox(12)
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(head)
	var t := UI.label(Board.title(c), 34, Board.RED, "marker")
	t.name = "GuideTitle"
	t.size_flags_vertical = Control.SIZE_SHRINK_END
	head.add_child(t)
	head.add_child(UI.spacer())
	head.add_child(Board.face(PORTRAIT, FACE_PX))
	v.add_child(Board.job_list(c))
	var rule := ColorRect.new()
	rule.color = Board.FADED
	rule.custom_minimum_size = Vector2(0, 2)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(rule)
	var for_page := Lessons.page_line(c.lessons, main.route)   # S532: on a first visit, what this page is FOR
	if for_page != "":
		var pg := UI.label(for_page, 19, Board.FADED, "hand", true)
		pg.name = "GuidePage"
		pg.custom_minimum_size = Vector2(BUBBLE_TEXT_W, 0)
		v.add_child(pg)
	var said := UI.label(GuideLines.line(c), 25, Board.INK, "handbold", true)
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
	if not GuideLines.target_names(c).is_empty():   # S532: help is asked for - the ring and the dim come with this button
		var step := c.guide
		var show_me := UI.button("Hide it" if GuideLight.show_step == step else "Show me", "BtnQuiet", func():
			GuideLight.show_step = "" if GuideLight.show_step == step else step
			refresh(main))
		show_me.name = "GuideShow"
		show_me.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		Tip.button(show_me, "Lights up the thing to click for this job.")
		row.add_child(show_me)
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
			return "Prepare your boxer for the bout."
		"fight":
			return "Weigh-in Friday, fight Saturday."
		"club":
			return "Three jobs for the club, in any order."
	return "Run the week."


## Why it matters and how to do it.
static func why(c: Career) -> String:
	var f := c.fighter()
	match c.guide:
		"sign":
			if c.applicant.is_empty():
				return "No boxer, no fights. Find a fighter tab: trials are free."   # TIPFIX2: the bubble's card, 14 words with what()
			return "No boxer, no fights. Read the reception card, then sign."
		"coach":
			return "Without one, missed sessions run at 60% and no classes."
		"week":
			# S416 operator: no fight, no cut talk. The boxer starts nearer the limit, so a cut from the offer makes weight.
			return "Sessions raise attributes; the days wait until the week is locked."
		"offer":
			return _weight_line(c, f, FirstHour.SHOW_DAY)
		"prep":
			var b: Dictionary = f.get("bout", {})
			var bits: Array = []
			if Bouts.camp_due(c, f):   # S532 operator on "Camp: no time for one" beside an amateur bout 19 days out: amateur bouts run on a fight week, no camp (S428)
				bits.append("Set the camp on Fight prep.")
			if (f.get("arrows", []) as Array).is_empty():
				# S398 round 4: the Playbook shows starting lines before any are saved, so the line asks for one of the player's own.
				bits.append("In the Playbook, make one line against the opponent your own; whatever is left to chance, your assistant fills at the bell.")
			return " ".join(bits)
		"fight":
			return "CONTINUE runs to the weigh-in; between rounds the corner minute is yours, and the result says why."
		"club":
			return "A second fighter, two camps at once and a goal that fits after a fight: running a club, not one boxer."
	return "CONTINUE plays the days. The review then shows what training gained and where the money went."


## "Your boxer is 1.4 kg over the 60.0 kg limit. On the coach's weeks the scale reads 60.1 kg on the morning: 0.1 over."
static func _weight_line(c: Career, f: Dictionary, day: int) -> String:
	if f.is_empty():
		return ""
	var over := float(f["weight"]) - float(f["limit"])
	if over <= 0.0:
		return "Your boxer is inside the %.1f kg limit." % f["limit"]
	var fc := Sim.weigh_forecast(c, f, day)
	# S397 round 1 (blind: "a paragraph of kg arithmetic"): one line - now, the morning, the limit, the verdict.
	# TIPFIX2 (owner Q-283 "Shorter cards"): the morning against the limit, then the verdict - two numbers a sentence.
	var line := "Morning weight %.1f kg, limit %.1f." % [float(fc["day"]), float(f["limit"])]
	if bool(fc["ok"]):
		return line + " Made, %.1f to spare." % maxf(0.0, float(f["limit"]) - float(fc["day"]))
	# S397 round 2: honest - once the camp cuts from today, nothing in this hour adds more; declining brings another offer.
	return line + " Over after the cut: risk it, or decline."


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
