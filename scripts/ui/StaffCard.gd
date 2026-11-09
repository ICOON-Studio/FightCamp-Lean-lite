extends RefCounted
## CLUB > People (S411). A coach card in the Fighters and Versus look: the face, one bar per area
## with the lift against training alone, and the boxer's real week from WeekPlan. Staff jobs are
## the same kind of card, smaller. Node names Hire_<id> stay, the first week presses them.

const UI := preload("res://scripts/ui/UI.gd")
const Bar := preload("res://scripts/ui/Bar.gd")
const KitIcon := preload("res://scripts/ui/KitIcon.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const TopCards := preload("res://scripts/ui/TopCards.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const CoachAreas := preload("res://scripts/rules/CoachAreas.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")

const TABS := [["People", "gym", 1], ["Money", "money", 0], ["Records", "gym", 4]]
const ROLE_WORD := {"assistant": "Second", "strength": "Strength", "physio": "Physio", "cutman": "Cutman"}
const ROLE_ICON := {"assistant": "members", "strength": "weights", "physio": "Recovery", "cutman": "ice"}
const INK := RosterCards.INK
const SOFT := RosterCards.INK_SOFT
const GREEN := Color("#1a7a42")


static func page(parent: Container, main: Node, c: Career) -> void:
	var root := UI.vbox(10)
	root.name = "PeoplePage"
	parent.add_child(root)
	root.add_child(_head(main))
	if not c.head.is_empty():
		root.add_child(_you(c))
	if c.coach.is_empty():
		var pair := UI.hbox(12)
		pair.name = "CoachCompare"
		for coach in Data.COACHES:
			pair.add_child(_coach(main, c, coach, false))
		root.add_child(pair)
	else:
		root.add_child(_coach(main, c, c.coach, true))
	var bjj := _bjj(c)
	if bjj != null:
		root.add_child(bjj)
	root.add_child(_roles(main, c))
	root.add_child(_members(c))


static func _head(main: Node) -> Control:
	var row := UI.hbox(14)
	row.name = "PeopleHead"
	var title := UI.display("Club", 48, Color.WHITE)
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.55))
	title.add_theme_constant_override("shadow_offset_y", 3)
	row.add_child(title)
	var now_a := str(main.route["area"])
	var now_t := int(main.route["tab"])
	for t in TABS:
		var area := str(t[1])
		var tab := int(t[2])
		var on := now_a == area and now_t == tab
		if str(t[0]) == "People":
			on = now_a == "gym" and now_t <= 2
		var b := UI.button(str(t[0]), "TabOn" if on else "Tab", main.act.bind("go", "%s:%d" % [area, tab]))
		b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		if not on:
			b.add_theme_color_override("font_color", RosterCards.CREAM)
			b.add_theme_color_override("font_hover_color", Color.WHITE)
			b.add_theme_color_override("font_pressed_color", Color.WHITE)
		row.add_child(b)
	return row


static func _you(c: Career) -> Control:
	var cd := HeadCoach.card(HeadCoach.of(c.head))
	var p := _paper(false)
	p.name = "HeadCoachRow"
	p.tooltip_text = "%s. %s %s" % [cd.get("edge", ""), cd.get("chip", ""), cd.get("plain", "")]
	var h := UI.hbox(12)
	p.add_child(h)
	var pic := PromoShot.picture(str(cd.get("photo", "")), Vector2(84, 96))
	if pic != null:
		h.add_child(pic)
	var v := UI.vbox(2)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var top := UI.hbox(8)
	var nm := UI.display(str(c.head.get("name", HeadCoach.DEFAULT_NAME)), 32, INK)
	top.add_child(nm)
	top.add_child(_tag("You"))
	v.add_child(top)
	v.add_child(UI.label(str(cd.get("edge", "")), 16, GREEN, "bold"))
	h.add_child(v)
	return p


static func _coach(main: Node, c: Career, coach: Dictionary, wide: bool) -> Control:
	var who := _with_areas(coach)
	var p := _paper(wide)
	p.name = "Assistant_" + str(who.get("id", ""))
	var h := UI.hbox(14)
	p.add_child(h)
	var face := Vector2(280, 320) if wide else Vector2(160, 210)
	var pic := PromoShot.picture(_photo(c, str(who.get("id", ""))), face)
	if pic != null:
		h.add_child(pic)
	var v := UI.vbox(6)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var top := UI.hbox(8)
	var nm := UI.display(str(who.get("name", "")), 36, INK)
	nm.clip_text = true
	nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nm.tooltip_text = "%s. %s, %s." % [who.get("kind", ""), who.get("spec", ""), who.get("note", "")]
	nm.mouse_filter = Control.MOUSE_FILTER_STOP
	top.add_child(nm)
	top.add_child(_tag("Full-time" if str(who.get("kind", "")).begins_with("Full") else "Sessional"))
	v.add_child(top)
	v.add_child(_bars(who))
	var f := c.fighter()
	if not f.is_empty():
		v.add_child(_boxer(c, f, who))
	v.add_child(_facts(who, not _hired(c, who)))
	if not _hired(c, who):
		var b := UI.button("Hire", "BtnSolid", main.act.bind("hire", str(who.get("id", ""))))
		b.name = "Hire_" + str(who.get("id", ""))
		b.tooltip_text = "Hire %s. %s to sign." % [who.get("name", ""), UI.money(GameMoney.COACH_SIGNING_FEE)]
		v.add_child(b)
	h.add_child(v)
	return p


static func _hired(c: Career, coach: Dictionary) -> bool:
	return str(c.coach.get("id", "")) == str(coach.get("id", "")) and not c.coach.is_empty()


static func _with_areas(coach: Dictionary) -> Dictionary:
	var areas: Dictionary = coach.get("areas", {})
	if areas.size() >= CoachAreas.AREAS.size():
		return coach
	var fresh := Data.coach(str(coach.get("id", "")))
	if fresh.is_empty() or not fresh.has("areas"):
		return coach
	var c := coach.duplicate(true)
	c["areas"] = (fresh["areas"] as Dictionary).duplicate(true)
	if not c.has("rating"):
		c["rating"] = fresh["rating"]
	return c


static func _bars(coach: Dictionary) -> Control:
	var box := UI.vbox(4)
	box.name = "AreaBars"
	var rows := CoachAreas.ranked(coach)
	for i in rows.size():
		var id := str(rows[i]["id"])
		var rating := float(rows[i]["rating"])
		var best := i == 0
		var row := UI.hbox(8)
		row.name = "AreaBar_" + id
		row.set_meta("area", id)
		row.set_meta("rating", rating)
		row.custom_minimum_size = Vector2(0, 30)
		var ink := GREEN if best else INK
		var q := roundi((0.5 + rating * 0.7 / 100.0) * 100.0)
		row.tooltip_text = "%s, rating %d. Session quality %d%% (alone 60%%). %s against training alone." % [
			CoachAreas.label(id), roundi(rating), q, CoachAreas.pct_for(id, rating)]
		if id == "pads":   # S413 pad nights teach moves, not attribute points
			row.tooltip_text = "%s, rating %d. Moves are learned %s faster than with no coach." % [CoachAreas.label(id), roundi(rating), CoachAreas.pct_for(id, rating)]
		row.mouse_filter = Control.MOUSE_FILTER_STOP
		var ic := KitIcon.icon(CoachAreas.icon(id), 22, ink, row.tooltip_text)
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(ic)
		var nm := UI.label(CoachAreas.short(id), 16, ink, "bold")
		nm.custom_minimum_size = Vector2(118, 0)
		nm.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(nm)
		if best:
			var mark := UI.label("Best at", 16, GREEN, "bold")
			mark.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			row.add_child(mark)
		var bar := Bar.new()
		bar.frac = rating / 100.0
		bar.fill = ink
		bar.custom_minimum_size = Vector2(80, 12)
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(bar)
		var pct := UI.label(CoachAreas.pct_for(id, rating), 26, ink, "bold")
		pct.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(pct)
		box.add_child(row)
	return box


static func _boxer(c: Career, f: Dictionary, coach: Dictionary) -> Control:
	var area := CoachAreas.best(coach)
	var pads := area == "pads"   # S413 ("Lucy, pad work: +0.00"): pad nights teach moves, so that is what this line counts
	var alone := DrillWeek.week_moves(c, f, 0.0) if pads else _points(c, f, {}, area)
	var coached := DrillWeek.week_moves(c, f, CoachAreas.rating_for(coach, "pads")) if pads else _points(c, f, coach, area)
	var first := str(f.get("first", ""))
	var text := CoachAreas.move_line(first, area, alone, coached) if pads else CoachAreas.line(first, area, alone, coached)
	var l := UI.label(text, 16, INK, "bold")
	l.name = "BoxerLine"
	l.clip_text = true
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	l.mouse_filter = Control.MOUSE_FILTER_STOP
	l.tooltip_text = text + " From this week's plan, against training alone."
	if absf(alone) < 0.0005 and absf(coached) < 0.0005:
		l.tooltip_text += " No attribute points from this area this week."
	return l


static func _points(c: Career, f: Dictionary, coach: Dictionary, area: String) -> float:
	var ctx: Dictionary = Sim.week_ctx(c, f)
	ctx["coach"] = coach
	return WeekPlan.area_week(WeekPlan.days_of(f), PadWeek.evenings(f), ctx, area)


static func _facts(coach: Dictionary, show_sign: bool) -> Control:
	var rating := float(coach.get("rating", 0.0))
	var limit := PlanBoard.arrow_limit(rating)
	var salary := int(coach.get("salary", 0))
	var classes := GameMoney.CLASSES_WITH_COACH
	var net := salary - classes
	var h := UI.hbox(6)
	h.name = "CoachTiles"
	h.add_child(_tile("coach", "%d lines" % limit, "How many lines you can write in a plan"))
	h.add_child(_tile("money", UI.money(salary), "Cost a week"))
	h.add_child(_tile("members", "+%s" % UI.money(classes), "Evening classes, a week", GREEN))
	h.add_child(_tile("runway", UI.money(-net), "Net a week, after evening classes", UI.RED if net > 0 else GREEN))
	if show_sign:
		h.add_child(_tile("contract", UI.money(GameMoney.COACH_SIGNING_FEE), "To sign"))
	return h


static func _roles(main: Node, c: Career) -> Control:
	var row := UI.hbox(8)
	row.name = "StaffJobs"
	for r in StaffRoles.LIST:
		row.add_child(_role(main, c, r))
	var places := KitIcon.icon("members", 22, SOFT, "Roster places: %d of %d used" % [GymSpend.used(c), GymSpend.places(c)])
	places.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(places)
	return row


static func _role(main: Node, c: Career, r: Dictionary) -> Control:
	var id := str(r["id"])
	var on := c.staff_roles.has(id)
	var p := _paper(on)
	p.name = "Role_" + id
	var pay := "%s a pro night" % UI.money(int(r["per_bout"])) if int(r["per_bout"]) > 0 else "%s a week" % UI.money(int(r["wage"]))
	p.tooltip_text = "%s. %s. %s." % [r["name"], r["effect"], pay]
	var h := UI.hbox(8)
	p.add_child(h)
	var ic := KitIcon.icon(str(ROLE_ICON.get(id, "coach")), 36, GREEN if on else INK, p.tooltip_text)
	ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(ic)
	var v := UI.vbox(2)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(UI.label(str(ROLE_WORD.get(id, id)), 16, INK, "bold"))
	var fig := UI.label(_figure(id), 22, GREEN if on else INK, "bold")
	fig.tooltip_text = str(r["effect"])
	fig.mouse_filter = Control.MOUSE_FILTER_STOP
	v.add_child(fig)
	var b := UI.button("Let go" if on else "Hire", "Btn", main.act.bind("letgorole" if on else "hirerole", id))
	b.name = ("LetGo_" if on else "Hire_") + id
	if on and StaffRoles.notice(id) > 0:
		b.tooltip_text = "Let go. A week's pay, %s." % UI.money(StaffRoles.notice(id))
	elif on:
		b.tooltip_text = "Let go."
	else:
		b.tooltip_text = "Hire. %s." % pay
	v.add_child(b)
	h.add_child(v)
	return p


static func _figure(id: String) -> String:
	match id:
		"assistant":
			return "+%d" % StaffRoles.places(["assistant"])
		"strength":
			return "-%d%%" % roundi((1.0 - StaffRoles.STRENGTH_RISK) * 100.0)
		"physio":
			return "-%d%%" % roundi((1.0 - StaffRoles.PHYSIO_DAYS) * 100.0)
		"cutman":
			return "%d%%" % roundi(StaffRoles.CUTMAN_KEEP * 100.0)
	return ""


static func _bjj(c: Career) -> Control:
	if c.grapplers.is_empty():
		return null
	var money := int(Sim.bjj_money(c)["coach"])
	var p := _paper(false)
	p.name = "BjjCoach"
	p.tooltip_text = "No-gi classes' coach, by the class. %s a class, %s a week." % [UI.money(BjjSide.COACH_CLASS), UI.money(money)]
	var h := UI.hbox(8)
	p.add_child(h)
	h.add_child(KitIcon.icon("mat", 28, INK, p.tooltip_text))
	h.add_child(UI.label("No-gi", 16, INK, "bold"))
	h.add_child(UI.label(UI.money(money), 16, INK, "bold"))
	return p


static func _members(c: Career) -> Control:
	var target := GymSpend.member_target(c)
	var drift := "steady" if target == c.members else ("growing toward %d" % target if target > c.members else "falling toward %d" % target)
	var rep := "known locally" if c.reputation < 30 else ("known in the region" if c.reputation < 60 else "a name in the sport")
	var rep_word := "Local" if c.reputation < 30 else ("Region" if c.reputation < 60 else "Name")
	var band := str((Membership.DUES.get(c.dues_band, Membership.DUES["standard"]) as Dictionary)["name"]).to_lower()
	var h := UI.hbox(8)
	h.name = "Members"
	Tips.card(h, func(): return TopCards.members(c))
	h.add_child(_tile("members", str(c.members), "On the books: %d, %s." % [c.members, drift]))
	h.add_child(_tile("reputation", rep_word, "Reputation: %s. Grows with wins (+%d each) and a well-kept gym." % [rep, BoutRules.WIN_REPUTATION]))
	h.add_child(_tile("money", UI.money(Membership.fee(c.dues_band)), "Dues, %s a month each (%s, set on Money)." % [UI.money(Membership.fee(c.dues_band)), band]))
	if c.coach.is_empty():
		h.add_child(_tile("coach", "Need", "Evening classes need a coach."))
	return h


static func _tile(icon: String, word: String, tip: String, ink: Color = INK) -> Control:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.custom_minimum_size = Vector2(0, 56)
	p.tooltip_text = tip
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	p.add_theme_stylebox_override("panel", UI.box(RosterCards.PAPER_DEEP, Color(0, 0, 0, 0), 8, 0, 4, 4))
	var v := UI.vbox(0)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	var ic := KitIcon.icon(icon, 18, ink, tip)
	ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(ic)
	var l := UI.label(word, 14, ink, "bold")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.clip_text = true
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(l)
	p.add_child(v)
	return p


static func _tag(text: String) -> Control:
	var p := PanelContainer.new()
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.add_theme_stylebox_override("panel", UI.box(RosterCards.PAPER_DEEP, RosterCards.EDGE, 8, 1, 8, 3))
	p.add_child(UI.label(text, 16, SOFT, "bold"))
	return p


static func _paper(hired: bool) -> PanelContainer:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var edge := GREEN if hired else RosterCards.EDGE
	p.add_theme_stylebox_override("panel", UI.box(RosterCards.PAPER, edge, 12, 2 if hired else 1, 14, 12))
	return p


static func _photo(c: Career, id: String) -> String:
	var mine := str(HeadCoach.card(HeadCoach.of(c.head)).get("photo", ""))
	if id == "reid":
		return "mh_boxer_07"
	return "mh_boxer_08" if mine == "mh_staff_trainer" else "mh_staff_trainer"
