extends PanelContainer
## The week review, per fighter: each stat's bar fills toward the next whole point and turns gold when it ticks over,
## the moves she drilled, a new weapon, her ranking change; planned vs actual (S355); then money and the coach's word.
## S361 a reveal (Q-S294-86, ReviewReveal): the rows land one at a time, the week's biggest surprise lands last on a sticky
## note, alone; a click on the review shows everything at once.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const TwistCard := preload("res://scripts/ui/TwistCard.gd")
const ReviewReveal := preload("res://scripts/rules/ReviewReveal.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const PassedStamp := preload("res://scripts/ui/PassedStamp.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const GrapplerPage := preload("res://scripts/ui/areas/GrapplerPage.gd")
const Bar := preload("res://scripts/ui/Bar.gd")

const BODY_W := 940.0
## The review's body at most this tall (1080 less the modal's margins and the Next week row); past it, it scrolls.
const MAX_BODY_H := 880.0

## How many stats crossed a whole point this week (the golden-path test reads it).
var crossed := 0
## The headlines in landing order ({kind, text}); true once everything has landed (tests and the skip read these).
var headlines: Array = []
var revealed := false

var _seq: Array = []      # [Control, seconds] in landing order
var _grow: Array = []     # [bar, frac, seconds]
var _tween: Tween


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(980, 0)
	var r: Dictionary = m["r"]
	var c: Career = main.career
	set_meta("career", c)
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
	if reports.is_empty():
		v.add_child(UI.muted("No fighter trained this week.", UI.BODY))
	var two_up := reports.size() > 1
	var step := ReviewReveal.STEP_TWO if two_up else ReviewReveal.STEP
	var t := 0.3
	for fr in reports:
		var head := ReviewReveal.headline(fr, Data.LABEL)
		headlines.append(head)
		t = _land(v, UI.caps("%s: BARS FILL TO THE NEXT POINT" % str(fr["name"]).to_upper()), t, step)
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
			# S370 (S367 critic: "decimal gains make a week feel like nothing happened"): a crossed point says +1, the rest
			# says how far to the next point, and the sessions that moved it are named under the bar (WeekCause).
			var moved_up := after - before >= 0.005
			var suffix := " +%d" % (int(floorf(after)) - int(floorf(before))) if tick else \
				(" %d%% to %d" % [int(TrainingPreview.progress_to_next(after) * 100.0), int(floorf(after)) + 1] if moved_up else "")
			var row := UI.stat_row(Data.LABEL[x["st"]], after, tick, UI.GOLD if tick else UI.FG, suffix)
			row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			var bar: Control = row.get_meta("bar")
			bar.frac = 0.0 if tick else TrainingPreview.progress_to_next(before)
			_grow.append([bar, TrainingPreview.progress_to_next(after), t])
			var cell := UI.vbox(0)
			cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			cell.add_child(row)
			var why := str(x.get("why", ""))
			if why != "" and moved_up:
				var wl := UI.label(why, UI.TINY, UI.GOLD if tick else UI.MUTED, "body")
				wl.name = "Why_%s" % str(x["st"])
				cell.add_child(wl)
			t = _land(stats, cell, t, step)
		v.add_child(stats)
		var notes: Array = []
		var moved: Array = []
		for mv in fr.get("moves", []):
			if float(mv["after"]) - float(mv["before"]) >= 0.5:
				moved.append("%s %d -> %d" % [mv["name"], roundi(float(mv["before"])), roundi(float(mv["after"]))])
		if not moved.is_empty():
			notes.append("Moves: " + ", ".join(moved))
		if str(fr.get("new_weapon", "")) != "" and head["kind"] != "weapon":
			notes.append("New weapon: the %s." % str(fr["new_weapon"]).to_lower())
		var rb := int(fr.get("rank_before", 0))
		var ra := int(fr.get("rank_after", 0))
		if ra != rb and head["kind"] != "rank":
			notes.append("Ranked %s in the %s rankings%s." % [str(ra) if ra > 0 else "out", fr.get("div", ""),
				(" (was %d)" % rb) if rb > 0 else ", a first ranking"])
		# S370 GOALTESTS1 the Sunday check-in: a grade passed, or how far the next one is; the bleep test before and after.
		var ap: Dictionary = fr.get("award_p", {})
		var passed_now := str(fr.get("award", "")) != ""
		if passed_now:
			notes.append("PASSED the %s award - a medal and a certificate." % str(fr["award"]))
		elif not ap.is_empty() and not bool(ap.get("done", false)):
			var short: Array = (ap.get("moves", []) as Array).filter(func(m): return not bool(m["ok"])).map(
				func(m): return "%s %d/%d" % [m["name"], int(m["now"]), int(m["need"])])
			notes.append("%s award: %d/%d sessions%s." % [ap["award"]["name"], int(ap["sessions"]), int(ap["need"]),
				(", " + ", ".join(short)) if not short.is_empty() else ""])
		var bl: Array = fr.get("bleep", [])
		if bl.size() == 2:
			notes.append("Bleep test %.1f -> %.1f." % [float(bl[0]), float(bl[1])])
		# S371 GOALTESTS1 phase 2: a personal best beaten goes on the records wall (TestDay.record ran on Sunday).
		var bests: Array = fr.get("bests", [])
		for b in bests:
			notes.append("NEW BEST %s: %s (was %s)." % [str(b["name"]).to_lower(), (str(b["fmt"]) % float(b["new"])) + " " + str(b["unit"]),
				str(b["fmt"]) % float(b["old"])])
		if not notes.is_empty():
			var gold := str(fr.get("new_weapon", "")) != "" or ra != rb or passed_now or not bests.is_empty()
			var line := UI.label("   ".join(notes), UI.SMALL, UI.GOLD if gold else UI.MUTED, "body", true)
			line.name = "Notes_" + str(fr["id"])
			t = _land(v, line, t, step)
		if passed_now:
			var pf := c.fighter_by_id(str(fr["id"]))
			if not pf.is_empty():
				t = _land(v, PassedStamp.make(pf, str(fr["award"])), t, step)
		if str(fr.get("peak", "")) != "" and head["kind"] != "peak":
			var pk := UI.label(str(fr["peak"]), UI.BODY, UI.GOLD if str(fr["peak"]).begins_with("Peak") else UI.MUTED, "bold", true)
			pk.name = "Peak_" + str(fr["id"])
			t = _land(v, pk, t, step)
		if not (fr.get("plan", {}) as Dictionary).is_empty():
			t = _land(v, _plan_block(fr, fr["plan"]), t, step)
		if head["kind"] != "":
			var hl := _headline(head)
			hl.name = "Headline_" + str(fr["id"])
			t = _land(v, hl, t + ReviewReveal.HOLD, ReviewReveal.HOLD)
		# S356 next week's twist card is drawn here: answer it now (or on the Training tab before Monday).
		var nf := c.fighter_by_id(str(fr["id"]))
		if not nf.is_empty():
			t = _land(v, TwistCard.build(main, nf, "NEXT WEEK'S TWIST"), t, step)
	for gr in r.get("grapplers", []):
		t = _grappler(main, c, v, gr, t, step)
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
	_land(v, grid, t, step)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	foot.add_child(UI.button("Next week", "BtnSolid", main.act.bind("close", "")))
	outer.add_child(foot)
	# + the scrollbar; S361 as wide as the widest row (a twist card's two buttons pushed past BODY_W and the gains hid under the bar)
	var body := v.get_combined_minimum_size()
	sc.custom_minimum_size = Vector2(maxf(BODY_W, body.x) + 28, minf(body.y, MAX_BODY_H))
	gui_input.connect(_on_click)
	_play()


## Adds `c` to `parent`, hidden until second `at`; returns the next row's second.
func _land(parent: Node, c: Control, at: float, step: float) -> float:
	parent.add_child(c)
	c.modulate.a = 0.0
	_seq.append([c, at])
	return at + step


## The week's surprise on a yellow sticky note, a little askew, in marker: red for an injury, marker blue for the rest.
func _headline(head: Dictionary) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(UI.YELLOW, UI.YELLOW_EDGE, 3, 1, 28, 14))
	p.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var l := UI.label(str(head["text"]), 30, UI.RED if head["kind"] == "injury" else UI.GOLD, "marker", true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.custom_minimum_size = Vector2(620, 0)
	p.add_child(l)
	return p


func _play() -> void:
	_tween = create_tween().set_parallel(true)
	var end := 0.0
	for s in _seq:
		var c: Control = s[0]
		_tween.tween_property(c, "modulate:a", 1.0, ReviewReveal.FADE).set_delay(s[1])
		if c.name.begins_with("Headline_"):
			_tween.tween_callback(_pop.bind(c)).set_delay(s[1])
			_tween.tween_property(c, "scale", Vector2.ONE, 0.35).from(Vector2(1.25, 1.25)).set_delay(s[1]).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		end = maxf(end, float(s[1]))
	for g in _grow:
		_tween.tween_property(g[0], "frac", g[1], 0.6).set_delay(g[2]).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_callback(func(): revealed = true).set_delay(end + ReviewReveal.FADE + 0.4)


## The headline lands: a slight tilt, and the review scrolls to it when it sits below the fold.
func _pop(c: Control) -> void:
	c.pivot_offset = c.size * 0.5
	c.rotation = deg_to_rad(-1.5)
	var sc := find_child("ReviewScroll", true, false) as ScrollContainer
	if sc != null:
		sc.ensure_control_visible(c)


## A click on the review while it plays: everything lands at once (a reveal is never a wait).
func _on_click(e: InputEvent) -> void:
	if not revealed and e is InputEventMouseButton and e.pressed:
		finish()


func finish() -> void:
	if _tween:
		_tween.kill()
	for s in _seq:
		s[0].modulate.a = 1.0
		s[0].scale = Vector2.ONE
		if s[0].name.begins_with("Headline_"):
			_pop(s[0])
	for g in _grow:
		g[0].frac = g[1]
	revealed = true


## S363 the no-gi athlete's week (Grapplers.week_report): the classes and the move drilled (its bar fills toward a
## weapon), her open, morale; a stripe due brings the professor's three calls (StripeCall); the surprise lands last.
func _grappler(main: Node, c: Career, v: VBoxContainer, gr: Dictionary, t: float, step: float) -> float:
	var id := str(gr["id"])
	var st := int(gr["stripes"])
	var head := ReviewReveal.grappler_headline(gr, NoGi.move_name(str(gr["move"])))
	headlines.append(head)
	t = _land(v, UI.caps("%s: ON THE MAT - %s BELT, %d STRIPE%s" % [str(gr["name"]).to_upper(), str(gr["belt"]).to_upper(), st,
		"" if st == 1 else "S"]), t, step)
	if int(gr["classes"]) > 0:
		var mat: Array = gr["mat"]
		var txt := "%d classes this week (%d of %d to %s belt)." % [int(gr["classes"]), int(mat[0]), int(mat[1]), gr["next"]] 			if str(gr["next"]) != "" else "%d classes this week." % int(gr["classes"])
		t = _land(v, UI.label(txt, UI.BODY, UI.FG, "body", true), t, step)
	if str(gr["move"]) != "":
		t = _land(v, _drill_row(gr, t), t, step)
	var o: Dictionary = gr.get("open", {})
	if not o.is_empty():
		var bits: Array = []
		for m in o["matches"]:
			bits.append("%s %s, %s" % ["beat" if bool(m["win"]) else "lost to", m["opp"], m["how"]])
		var w := (o["matches"] as Array).filter(func(m): return bool(m["win"])).size()
		var medal := str(o["medal"])
		var said := "; ".join(bits)
		var ol := UI.label("%s: %s (%d-%d). %s." % [o["name"], medal.to_upper() if medal != "" else "out in round %d" % (w + 1),
			w, (o["matches"] as Array).size() - w, said.left(1).to_upper() + said.substr(1)],
			UI.SMALL, UI.GOLD if medal != "" else UI.MUTED, "body", true)
		ol.name = "Open_" + id
		t = _land(v, ol, t, step)
	var mood := int((o as Dictionary).get("morale", 0))
	var ml := UI.label("Morale %d%s   Loyalty %d%s" % [int(gr["morale"]), (" (%+d at the open)" % mood) if mood != 0 else "",
		int(gr["loyalty"]), ("   Stripe %d held back: drilling hungry" % int(gr["held"])) if int(gr["held"]) > 0 else ""],
		UI.SMALL, UI.MUTED, "mono")
	ml.name = "Mood_" + id
	t = _land(v, ml, t, step)
	var f := c.grappler_by_id(id)
	if int(gr["due"]) > 0 and not f.is_empty():
		var hold := UI.vbox(4)
		hold.name = "Stripe_" + id
		hold.add_child(GrapplerPage.stripe_buttons(main, f, c.day, _on_stripe.bind(main, c, id, hold)))
		t = _land(v, hold, t, step)
	if head["kind"] != "":
		var hl := _headline(head)
		hl.name = "Headline_" + id
		hl.set_meta("kind", head["kind"])
		t = _land(v, hl, t + ReviewReveal.HOLD, ReviewReveal.HOLD)
	return t


## The drilled move's bar fills from last week toward a weapon (BeltRoad.OWNED_AT); gold when it got there.
func _drill_row(gr: Dictionary, at: float) -> HBoxContainer:
	var h := UI.hbox(12)
	var owned := bool(gr["owned"])
	var l := UI.label("Drilled: " + NoGi.move_name(str(gr["move"])), UI.BODY)
	l.custom_minimum_size = Vector2(300, 0)
	h.add_child(l)
	var bar: Control = Bar.new()
	bar.fill = UI.GOLD if owned else UI.GREEN
	bar.frac = clampf(float(gr["before"]) / BeltRoad.OWNED_AT, 0.0, 1.0)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(bar)
	_grow.append([bar, clampf(float(gr["after"]) / BeltRoad.OWNED_AT, 0.0, 1.0), at])
	var n := UI.label("%d / %d  %s" % [int(floorf(float(gr["after"]))), int(BeltRoad.OWNED_AT), UI.gain_text(float(gr["after"]) - float(gr["before"]))],
		UI.BODY, UI.GOLD if owned else UI.FG, "mono")
	n.custom_minimum_size = Vector2(150, 0)
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(n)
	h.name = "Drill_" + str(gr["id"])
	return h


## A stripe call from the review: the buttons give way to what happened (a refusal toasts and leaves them).
func _on_stripe(call: String, main: Node, c: Career, id: String, hold: VBoxContainer) -> void:
	var res := Grapplers.stripe(c, id, call)
	if not bool(res["ok"]):
		main.toast(str(res["why"]))
		return
	_stripe_done.call_deferred(res, call, hold)   # deferred: the pressed button is still inside its own signal


func _stripe_done(res: Dictionary, call: String, hold: VBoxContainer) -> void:
	# The call is answered: the "your call" note goes and the mood line reads the new numbers.
	var id := str(hold.name).trim_prefix("Stripe_")
	var hl := find_child("Headline_" + id, true, false)
	if hl != null and str(hl.get_meta("kind", "")) == "stripe":
		hl.queue_free()
	var f: Dictionary = (get_meta("career") as Career).grappler_by_id(id)
	var ml := find_child("Mood_" + id, true, false) as Label
	if ml != null and not f.is_empty():
		ml.text = "Morale %d   Loyalty %d" % [int(f["morale"]), int(f["loyalty"])]
	UI.clear(hold)
	var l := UI.label(str(res["line"]), UI.BODY, UI.GOLD if call != "hold" else UI.AMBER, "bold", true)
	l.name = "StripeDone"
	hold.add_child(l)
	if str(res["news"]) != "":
		hold.add_child(UI.label(str(res["news"]), UI.SMALL, UI.RED, "body", true))


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
