extends PanelContainer
## The week review, per fighter: each stat's bar fills toward the next whole point and turns gold when it ticks over,
## the moves she drilled, a new weapon, her ranking change; planned vs actual (S355); then money and the coach's word.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const TwistCard := preload("res://scripts/ui/TwistCard.gd")

const BODY_W := 940.0
## The review's body at most this tall (1080 less the modal's margins and the Next week row); past it, it scrolls.
const MAX_BODY_H := 880.0

## How many stats crossed a whole point this week (the golden-path test reads it).
var crossed := 0


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(980, 0)
	var r: Dictionary = m["r"]
	var c: Career = main.career
	# S356 the body scrolls and Next week stays pinned (a twist card a fighter made the review taller than the screen).
	var outer := UI.vbox(8)
	add_child(outer)
	var sc := ScrollContainer.new()
	sc.name = "ReviewScroll"
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer.add_child(sc)
	var v := UI.vbox(8)
	v.custom_minimum_size = Vector2(BODY_W, 0)   # fixed width: the scrollbar keeps its own 28 px beside it
	sc.add_child(v)
	v.add_child(UI.caps("END OF WEEK %d" % int(r["week"])))
	v.add_child(UI.display("WEEK REVIEW", 48))
	var reports: Array = r.get("fighters", [])
	var grow: Array = []
	if reports.is_empty():
		v.add_child(UI.muted("No fighter trained this week.", UI.BODY))
	var two_up := reports.size() > 1
	for fr in reports:
		v.add_child(UI.caps("%s: BARS FILL TO THE NEXT POINT" % str(fr["name"]).to_upper()))
		var stats := GridContainer.new()
		stats.columns = 2 if two_up else 1
		stats.add_theme_constant_override("h_separation", 28)
		stats.add_theme_constant_override("v_separation", 4)
		for x in fr["rows"]:
			var before := float(x["before"])
			var after := float(x["after"])
			var tick := TrainingPreview.crossed_point(before, after)
			if tick:
				crossed += 1
			var row := UI.stat_row(Data.LABEL[x["st"]], after, tick, UI.GOLD if tick else UI.FG, UI.gain_text(after - before))
			row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			var bar: Control = row.get_meta("bar")
			bar.frac = 0.0 if tick else TrainingPreview.progress_to_next(before)
			grow.append([bar, TrainingPreview.progress_to_next(after)])
			stats.add_child(row)
		v.add_child(stats)
		var notes: Array = []
		var moved: Array = []
		for mv in fr.get("moves", []):
			if float(mv["after"]) - float(mv["before"]) >= 0.5:
				moved.append("%s %d -> %d" % [mv["name"], roundi(float(mv["before"])), roundi(float(mv["after"]))])
		if not moved.is_empty():
			notes.append("Moves: " + ", ".join(moved))
		if str(fr.get("new_weapon", "")) != "":
			notes.append("New weapon: the %s." % str(fr["new_weapon"]).to_lower())
		var rb := int(fr.get("rank_before", 0))
		var ra := int(fr.get("rank_after", 0))
		if ra != rb:
			notes.append("Ranked %s in the %s rankings%s." % [str(ra) if ra > 0 else "out", fr.get("div", ""),
				(" (was %d)" % rb) if rb > 0 else ", a first ranking"])
		if not notes.is_empty():
			var line := UI.label("   ".join(notes), UI.SMALL, UI.GOLD if str(fr.get("new_weapon", "")) != "" or ra != rb else UI.MUTED, "body", true)
			line.name = "Notes_" + str(fr["id"])
			v.add_child(line)
		if str(fr.get("peak", "")) != "":
			var pk := UI.label(str(fr["peak"]), UI.BODY, UI.GOLD if str(fr["peak"]).begins_with("Peak") else UI.MUTED, "bold", true)
			pk.name = "Peak_" + str(fr["id"])
			v.add_child(pk)
		if not (fr.get("plan", {}) as Dictionary).is_empty():
			v.add_child(_plan_block(fr, fr["plan"]))
		# S356 next week's twist card is drawn here: answer it now (or on the Training tab before Monday).
		var nf := c.fighter_by_id(str(fr["id"]))
		if not nf.is_empty():
			v.add_child(TwistCard.build(main, nf, "NEXT WEEK'S TWIST"))
	var grid := UI.hbox(16)
	var money := UI.card("MONEY")
	UI.add_rows(money[1], [
		UI.kv("In this week", UI.signed(int(r["money"]["in"])), UI.GREEN, "mono"),
		UI.kv("Running costs (on the bill)", UI.signed(-int(r["money"].get("costs", 0))), UI.FG, "mono"),
		UI.kv("Paid out this week", UI.signed(-int(r["money"]["out"])), UI.FG, "mono"),
		UI.kv("Cash now", UI.money(c.cash), UI.FG, "mono"),
		UI.kv("Members", "%d (%+d)" % [int(r.get("members", c.members)), int(r.get("members_delta", 0))], UI.FG, "mono"),
	])
	var paid: Array = r["money"].get("paid", [])
	if not paid.is_empty():
		var what := UI.label("(" + "; ".join(paid) + ")", UI.SMALL, UI.MUTED, "body", true)
		what.name = "PaidOut"
		money[1].add_child(what)
	grid.add_child(money[0])
	var coach := UI.card("THE COACH")
	coach[1].add_child(UI.label(r["coach"], UI.BODY, UI.FG, "italic", true))
	grid.add_child(coach[0])
	v.add_child(grid)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	foot.add_child(UI.button("Next week", "BtnSolid", main.act.bind("close", "")))
	outer.add_child(foot)
	sc.custom_minimum_size = Vector2(BODY_W + 28, minf(v.get_combined_minimum_size().y, MAX_BODY_H))   # + the scrollbar
	if not grow.is_empty():
		var t := create_tween().set_parallel(true)
		for g in grow:
			t.tween_property(g[0], "frac", g[1], 0.9).set_delay(0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


## S355 CORE3 step 2 (WeekActual): Monday's plan against the week she ran, the reason, and the coach's one change.
func _plan_block(fr: Dictionary, plan: Dictionary) -> VBoxContainer:
	var box := UI.vbox(4)
	box.name = "Plan_" + str(fr["id"])
	var tw := str(plan.get("twist", ""))
	box.add_child(UI.caps("PLANNED VS ACTUAL" + ("   (THE TWIST: %s)" % tw.to_upper() if tw != "" else "")))
	var g := GridContainer.new()
	g.columns = 4
	g.add_theme_constant_override("h_separation", 28)
	for r in plan["rows"]:
		var ok := bool(r["ok"])
		g.add_child(UI.label(str(r["label"]), UI.BODY, UI.FG, "bold"))
		g.add_child(UI.label("planned " + _num(r, float(r["plan"])), UI.BODY, UI.MUTED, "mono"))
		g.add_child(UI.label("actual " + _num(r, float(r["actual"])), UI.BODY, UI.GREEN if ok else UI.AMBER, "mono"))
		g.add_child(UI.label("on plan" if ok else "off plan", UI.SMALL, UI.GREEN if ok else UI.AMBER, "body"))
	box.add_child(g)
	box.add_child(UI.label(str(plan["reason"]), UI.SMALL, UI.MUTED, "body", true))
	box.add_child(UI.label("Coach: \"%s\"" % str(plan["change"]), UI.SMALL, UI.GOLD, "italic", true))
	return box


static func _num(r: Dictionary, x: float) -> String:
	match str(r["unit"]):
		"kg":
			return "%+.2f kg" % x
		"fatigue":
			return "%d" % int(round(x))
	return "%+.2f" % x
