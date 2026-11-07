extends VBoxContainer
## A no-gi athlete's page: the Record tab as approved (S362, operator Q-S294-80 "Yes, build both";
## docs/mockups/S355_record_bjj.png). Top: THE ROAD TO BLACK BELT, five belts with her stripes. Then three cards: TO <NEXT>
## BELT (mat time, moves owned, the syllabus move by move), COACH'S CALL (give the stripe that is due, promote, the next
## opens to enter, the rules) and her RECORD in opens with the belts and stripes so far.
##   GrapplerPage.make(main, f) -> VBoxContainer   GrapplerPage.act(main, name, arg) -> handled

const UI := preload("res://scripts/ui/UI.gd")
const Bar := preload("res://scripts/ui/Bar.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const StripeCall := preload("res://scripts/rules/StripeCall.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const MatTreeInfo := preload("res://scripts/ui/MatTreeInfo.gd")

const BELT_COLOR := {"white": Color("#f4f5f6"), "blue": Color("#2f5fd0"), "purple": Color("#7b3fc4"),
	"brown": Color("#7a4a25"), "black": Color("#151515")}
const BELT_SUB := {"blue": "no minimum at white, age 16+", "purple": "2 years at blue", "brown": "1.5 years at purple, 18+",
	"black": "1 year at brown, 19+"}
const ORDINAL := ["", "1st", "2nd", "3rd", "4th"]
const RECORD_ROWS := 8


static func make(main: Node, f: Dictionary) -> VBoxContainer:
	var p := new()
	p.name = "GrapplerPage"
	p.add_theme_constant_override("separation", 14)
	p._build(main, main.career, f)
	return p


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	var why := ""
	match name:
		"gstripe":   # "id|now" / "id|hold" / "id|early" (S363 StripeCall)
			var kv := arg.split("|")
			var res := Grapplers.stripe(c, kv[0], kv[1] if kv.size() > 1 else "now")
			why = str(res["why"]) if not bool(res["ok"]) else ""
			if bool(res["ok"]):
				main.toast(str(res["line"]))
		"gdrill":   # "id|coach" / "id|open" / "id|fav" (S364, what the classes drill)
			var kv := arg.split("|")
			var gf := c.grappler_by_id(kv[0])
			if not gf.is_empty() and (NoGi.DRILLS.has(kv[1]) or kv[1].begins_with("move:")   # S375 "move:<id>" = the player's pick
					or (BjjTree.is_tree_plan(kv[1]) and not BjjTree.drill_target(gf, kv[1]).is_empty())):   # S384 tree:/route:/ahead:
				gf["drill"] = kv[1]
		"gplan":   # "id|route:<route id>" / "id|goal:<goal>" (S384 GAMETREE1, the Playbook's plan strip)
			var kv := arg.split("|")
			var gf := c.grappler_by_id(kv[0])
			if not gf.is_empty() and kv.size() > 1:
				var key := kv[1].get_slice(":", 1)
				if kv[1].begins_with("route:") and not BjjTree.route(key).is_empty():
					MatTreeInfo.set_plan(gf, MatTreeInfo.plan_goal(gf), BjjTree.route(key)["steps"])
				elif kv[1].begins_with("goal:") and MatTreeInfo.GOALS.has(key):
					var fl := MatTreeInfo.fill(gf, key)
					if (fl["steps"] as Array).is_empty():
						why = str(fl["line"])
					else:
						MatTreeInfo.set_plan(gf, key, fl["steps"])
			if not main.modal.is_empty():
				if why != "":
					main.toast(why)
				main.close_modal()
				return true
		"gteach":   # "id|1" / "id|0" (S365, the beginners' class)
			var kv := arg.split("|")
			why = Grapplers.teach(c, kv[0], kv.size() > 1 and kv[1] == "1")
		"gpromote":
			why = Grapplers.promote(c, arg)
		"genter":
			var kv := arg.split("|")
			why = Grapplers.enter(c, kv[0], int(kv[1]))
		_:
			return false
	if why != "":
		main.toast(why)
	main.render()
	return true


func _build(main: Node, c: Career, f: Dictionary) -> void:
	var belt := str(f["belt"])
	var nxt := BeltRoad.next_belt(belt)
	var r := BeltRoad.readiness(f, f.get("bjj", {}), c.day)
	add_child(UI.muted("FIGHTERS / Roster / %s" % f["name"], UI.SMALL))
	var head := UI.hbox(16)
	head.add_child(UI.display(str(f["name"]).to_upper(), 52))
	var sub := UI.muted("%s, %d, %s belt %d stripe%s, %d-%d in opens" % [f["wc"], int(f["age"]), belt, int(f["stripes"]),
		"" if int(f["stripes"]) == 1 else "s", int(f["w"]), int(f["l"])], UI.BODY)
	sub.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(sub)
	add_child(head)
	var tabs := UI.hbox(4)
	tabs.add_child(UI.button("Record", "TabOn", func(): pass))
	add_child(tabs)
	var line := ColorRect.new()
	line.color = UI.LINE
	line.custom_minimum_size = Vector2(0, 1)
	add_child(line)
	add_child(_road(f))
	var row := UI.hbox(16)
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(row)
	if nxt != "":
		row.add_child(_syllabus(main, f, nxt, r))
	row.add_child(_call(main, c, f, nxt, r))
	var side := UI.vbox(16)
	side.add_child(_body(f))
	side.add_child(_classes(main, c, f))
	side.add_child(_record(f))
	row.add_child(side)


## THE ROAD TO BLACK BELT: a bar per belt, hers outlined, her stripes on its tip.
func _road(f: Dictionary) -> Control:
	var card := UI.card("THE ROAD TO BLACK BELT - THE COACH PROMOTES; THE GRAPPLING UNION SETS THE MINIMUMS")
	card[0].name = "BeltRoad"
	var h := UI.hbox(18)
	card[1].add_child(h)
	var mine := BeltRoad.rank(str(f["belt"]))
	for i in BeltRoad.BELTS.size():
		var b: String = BeltRoad.BELTS[i]
		var col := UI.vbox(4)
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_child(_belt_bar(b, int(f["stripes"]) if i == mine else 0, i == mine))
		var name := UI.label(b.to_upper(), UI.BODY, UI.FG, "bold")
		name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(name)
		var s := UI.muted("now, %d of %d stripes" % [int(f["stripes"]), BeltRoad.STRIPES] if i == mine else str(BELT_SUB.get(b, "")), UI.TINY)
		s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(s)
		h.add_child(col)
	card[1].add_child(UI.muted("An adult world champion at the belt skips the minimum time. A typical road takes 8 to 12 years; a prodigy about 5.", UI.TINY))
	return card[0]


func _belt_bar(belt: String, stripes: int, mine: bool) -> Control:
	var hold := PanelContainer.new()
	hold.name = "Belt_" + belt
	hold.add_theme_stylebox_override("panel", UI.box(BELT_COLOR[belt], UI.GOLD if mine else UI.LINE, 4, 3 if mine else 1, 0, 0))
	hold.custom_minimum_size = Vector2(0, 36)
	var h := UI.hbox(0)
	hold.add_child(h)
	h.add_child(UI.spacer())
	var tip := PanelContainer.new()
	tip.add_theme_stylebox_override("panel", UI.box(Color("#c62832") if belt == "black" else Color("#151515"), Color(0, 0, 0, 0), 0, 0, 8, 6))
	tip.custom_minimum_size = Vector2(76, 0)
	var sh := UI.hbox(5)
	sh.alignment = BoxContainer.ALIGNMENT_CENTER
	tip.add_child(sh)
	if belt != "black":
		for k in BeltRoad.STRIPES:
			var s := ColorRect.new()
			s.color = Color.WHITE if k < stripes else Color("#4a4a4a")
			s.custom_minimum_size = Vector2(7, 22)
			s.name = "Stripe_%d" % k
			sh.add_child(s)
	h.add_child(tip)
	var end := Control.new()
	end.custom_minimum_size = Vector2(10, 0)
	h.add_child(end)
	return hold


## TO <NEXT> BELT: mat time and moves owned, then every syllabus move with its tick at a weapon.
func _syllabus(main: Node, f: Dictionary, nxt: String, r: Dictionary) -> Control:
	var syl: Dictionary = BeltRoad.SYLLABUS[str(f["belt"])]
	var card := UI.card("TO %s BELT - %s" % [nxt.to_upper(), str(syl["title"]).to_upper()])
	card[0].name = "Syllabus"
	card[0].size_flags_stretch_ratio = 1.3
	card[1].add_theme_constant_override("separation", 3)   # 20 rows fit 1080 under the belt road
	card[1].add_child(_progress("Mat time", "%d of %d classes" % [r["mat"][0], r["mat"][1]], float(r["mat"][0]) / maxf(1.0, r["mat"][1])))
	card[1].add_child(_progress("Moves owned (a weapon at the tick)", "%d of %d" % [r["moves"][0], r["moves"][1]],
		float(r["moves"][0]) / maxf(1.0, r["moves"][1])))
	var day: int = main.career.day
	card[1].add_child(_drill_pick(main, f, day))
	var drill := NoGi.drilling(f, day)
	for g in syl["groups"]:
		card[1].add_child(UI.caps(str(g[0]).to_upper()))
		for m in g[1]:
			var v := float((f.get("bjj", {}) as Dictionary).get(m, 0.0))
			var h := UI.hbox(12)
			h.name = "Move_" + str(m)
			var l := UI.label(NoGi.move_name(m) + ("  (drilling)" if m == drill else ""), UI.SMALL, UI.GOLD if m == drill else UI.FG)
			l.custom_minimum_size = Vector2(230, 0)
			h.add_child(l)
			var bar: Control = Bar.new()
			bar.frac = v / 100.0
			bar.fill = Color("#2a9d8f")
			bar.custom_minimum_size = Vector2(130, 8)
			bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			var tick := ColorRect.new()   # the weapon line (OWNED_AT)
			tick.color = UI.FG
			tick.anchor_left = BeltRoad.OWNED_AT / 100.0
			tick.anchor_right = tick.anchor_left
			tick.anchor_bottom = 1.0
			tick.offset_left = -1
			tick.offset_right = 1
			tick.offset_top = -3
			tick.offset_bottom = 3
			bar.add_child(tick)
			h.add_child(bar)
			var own := v >= BeltRoad.OWNED_AT
			var sig := v >= NoGi.SIGNATURE
			h.add_child(UI.label("signature" if sig else ("owned %d" % int(v) if own else "%d/%d" % [int(v), int(BeltRoad.OWNED_AT)]), UI.TINY,
				UI.GOLD if sig else (UI.GREEN if own else UI.MUTED), "bold" if own else "body"))
			card[1].add_child(h)
	return card[0]


## S364 WHAT THE CLASSES DRILL (Kalli K-BELTROAD1 part 2): the coach's pick stands until you change it; "the next open"
## drills the group that open leans on; her favourite pushes an owned move to a signature.
func _drill_pick(main: Node, f: Dictionary, day: int) -> Control:
	var box := UI.vbox(4)
	box.name = "DrillPick"
	box.add_child(UI.caps("WHAT THE CLASSES DRILL"))
	var plan := str(f.get("drill", "coach"))
	var btns := UI.hbox(8)
	var fid := str(f["id"])
	for p in NoGi.DRILLS:
		var m := NoGi.drilling_for(f, p, day)
		var text: String = {"coach": "Coach's pick", "open": "For the next open", "fav": "Favourite"}[p]
		var b := UI.button(text, "BtnSolid" if p == plan else "Btn", main.act.bind("gdrill", "%s|%s" % [fid, p]), false,
			NoGi.move_name(m) if m != "" else "Nothing left to drill")
		b.name = "Drill_" + p
		btns.add_child(b)
	# S375 the player's own pick from PLAYBOOK > her mat (Drill it), or the way there.
	if plan.begins_with("move:"):
		btns.add_child(UI.button("Your pick: %s" % NoGi.move_name(plan.trim_prefix("move:")), "BtnSolid", func(): pass))
	btns.add_child(UI.button("Pick a move on the mat", "Btn", func():
		Playbook.pick = fid
		main.act("go", "playbook:0")))
	box.add_child(btns)
	var m := NoGi.drilling(f, day)
	var why := ""
	match plan:
		"open":
			var o: Dictionary = NoGi.opens_after(day + 1, 1)[0]
			var g := NoGi.lean_group(f, o)
			if not g.is_empty():
				why = "the %s (%s) is decided on %s" % [o["name"], Clock.fmt(int(o["d"])), str(g[0]).to_lower()]
		"fav":
			why = "an owned move pushed to a signature at %d (+%d%% a match where its group decides)" % [int(NoGi.SIGNATURE), int(NoGi.SIGNATURE_BONUS * 100)]
	if why == "":
		why = "the move closest to a weapon"
	if m != "":
		box.add_child(UI.label("%s, +%.1f a week: %s." % [NoGi.move_name(m), NoGi.DRILL_GAIN, why], UI.SMALL, UI.FG, "body", true))
	return box


func _progress(title: String, value: String, frac: float) -> Control:
	var v := UI.vbox(4)
	var h := UI.hbox(8)
	var t := UI.label(title, UI.SMALL)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(t)
	h.add_child(UI.label(value, UI.SMALL, UI.FG, "bold"))
	v.add_child(h)
	v.add_child(UI.meter(clampf(frac, 0.0, 1.0), UI.GOLD, [], 260.0))   # S375 short meter, not a card-wide line
	return v


## COACH'S CALL: the stripe that is due, the promotion, the next opens, the rules.
func _call(main: Node, c: Career, f: Dictionary, nxt: String, r: Dictionary) -> Control:
	var card := UI.card("COACH'S CALL")
	card[0].name = "CoachCall"
	var v: VBoxContainer = card[1]
	var fid := str(f["id"])
	var due := NoGi.stripes_due(f, c.day)
	if nxt == "":
		v.add_child(UI.label("%s is a black belt. Time to teach the road now." % f["first"], UI.BODY, UI.FG, "body", true))
	else:
		var given := int(f["stripes"])
		var head := "Ready for a %s stripe: %s's %s are solid." % [ORDINAL[mini(given + 1, 4)], f["first"], best_words(f)] if due > 0 \
			else ("Ready for %s belt." % nxt if bool(r["ready"]) else "The next stripe comes at %d%% of the way to %s." % [
				int(round(100.0 * (given + 1) / BeltRoad.STRIPES)), nxt])
		v.add_child(UI.label(head, UI.BODY, UI.FG, "body", true))
		var wk := NoGi.weeks_to_ready(f, c.day)
		v.add_child(UI.label("%s belt in about %s at this week's plan (%d classes a week)." % [nxt.capitalize(),
			("%d weeks" % wk) if wk < 9 else ("%d months" % int(round(wk / 4.35))), NoGi.classes_of(f)], UI.BODY, UI.FG, "body", true))
		v.add_child(UI.label("Morale %d   Loyalty %d%s" % [int(f.get("morale", NoGi.MORALE_START)), int(f.get("loyalty", NoGi.MORALE_START)),
			("   (stripe %d held back: drilling hungry)" % int(f["held"])) if int(f.get("held", 0)) > 0 else ""], UI.SMALL, UI.MUTED, "mono"))
		v.add_child(stripe_buttons(main, f, c.day, func(call): main.act("gstripe", "%s|%s" % [fid, call])))
		var btns := UI.hbox(10)
		var floor_why := "" if bool(r["floor_ok"]) else (("%d more days at %s (the Grappling Union minimum)" % [r["days_left"], f["belt"]]) if int(r["days_left"]) > 0 \
			else "Too young for %s: the Grappling Union minimum is %d" % [nxt, BeltRoad.MIN_AGE[nxt]])
		var pro := UI.button("Promote to %s%s" % [nxt, "" if bool(r["ready"]) else " (not ready)"], "Btn", main.act.bind("gpromote", fid),
			floor_why != "", floor_why)
		pro.name = "Promote"
		btns.add_child(pro)
		v.add_child(btns)
		v.add_child(UI.muted("Promote early and %s starts %s owing a quarter of its mat time, and meets %s belts before earning one." % [
			f["first"], nxt, nxt], UI.TINY, true))
	v.add_child(UI.caps("NEXT OPENS (NO-GI, %s BELT ADULT, %s)" % [str(f["belt"]).to_upper(), str(f["wc"]).get_slice(" ", 0).to_upper()]))
	var entered: Array = f.get("entered", [])
	for o in NoGi.opens_after(c.day + 1, 2):
		var d := int(o["d"])
		var right: Control
		if entered.has(d):
			right = UI.label("Entered", UI.SMALL, UI.GREEN, "bold")
		else:
			right = UI.button("Enter", "Link", main.act.bind("genter", "%s|%d" % [fid, d]), c.cash < int(o["fee"]), "Not enough cash for the entry")
		right.name = "Enter_%d" % d
		var lg := NoGi.lean_group(f, o)
		var lean := (" - decided on %s" % str(lg[0]).to_lower()) if not lg.is_empty() else ""
		var word := NoGi.chance_word(NoGi.win_chance(f, c.day, o))
		var wl := UI.label(word, UI.SMALL, UI.GREEN if word == "FAVOURITE" else (UI.RED if word == "LONG SHOT" else UI.FG), "bold")
		wl.tooltip_text = "%s's chance in the first match (the coach's read)" % f["first"]
		wl.mouse_filter = Control.MOUSE_FILTER_STOP
		var row := UI.row(str(o["name"]), "%s - %d entrants - $%d%s" % [Clock.fmt(d), NoGi.BRACKET, int(o["fee"]), lean],
			Color(0, 0, 0, 0), [wl, right])
		row.name = "Open_%d" % d
		v.add_child(row)
		if entered.has(d):
			v.add_child(field_chips(f, d))
	v.add_child(UI.caps("THE RULES (ADULT NO-GI)"))
	var mm := BeltRoad.MATCH_MIN
	v.add_child(UI.label("%d min at white (%d blue, %d purple, %d brown, %d black). Mount or back %d, guard pass %d, takedown, sweep or knee on belly %d. A submission ends it. No-gi only." % [
		mm["white"], mm["blue"], mm["purple"], mm["brown"], mm["black"], BeltRoad.POINTS["mount"], BeltRoad.POINTS["pass"],
		BeltRoad.POINTS["takedown"]], UI.SMALL, UI.FG, "body", true))
	return card[0]


## S363 the stripe as a choice (StripeCall): the coach's advice, then GIVE IT NOW / HOLD IT BACK / GIVE IT EARLY, each with its
## cost on hover; the coach's pick is the solid button. `on_call(call)` runs the call. Shared by the page and the week review.
static func stripe_buttons(main: Node, f: Dictionary, today: int, on_call: Callable) -> VBoxContainer:
	var box := UI.vbox(6)
	box.name = "StripeCall"
	var opt := StripeCall.options(f, today)
	if str(opt["why"]) != "":
		box.add_child(UI.label("Coach: \"%s\"" % opt["why"], UI.SMALL, UI.GOLD, "italic", true))
	var btns := UI.hbox(10)
	var n := int(f.get("stripes", 0)) + 1
	for call in ["now", "hold", "early"]:
		var text: String = {"now": "Give stripe %d now" % n, "hold": "Hold it back", "early": "Give stripe %d early" % n}[call]
		var why := str(opt[call])
		var b := UI.button(text, "BtnSolid" if call == str(opt["pick"]) else "Btn", on_call.bind(call), why != "",
			why if why != "" else str(StripeCall.TIPS[call]))
		b.name = {"now": "GiveStripe", "hold": "HoldStripe", "early": "EarlyStripe"}[call]
		btns.add_child(b)
	box.add_child(btns)
	return box


## The coach's words for her best syllabus group ("escapes", "passes and sweeps").
static func best_words(f: Dictionary) -> String:
	var g := NoGi.best_group(f).to_lower()
	return g.get_slice(" and survival", 0) if g.begins_with("escapes") else g


## S365 THE BJJ CLASSES (Kalli K-BELTROAD1 part 4): the gym's no-gi side as a business - members on their own dues, the hired
## coach's classes, what her medals and belt bring in, and (from blue) the beginners' class as her call: money against her
## own mat time, both shown in numbers.
func _classes(main: Node, c: Career, f: Dictionary) -> Control:
	var card := UI.card("THE BJJ CLASSES - THE GYM'S NO-GI SIDE")
	card[0].name = "BjjClasses"
	card[0].custom_minimum_size = Vector2(380, 0)
	var v: VBoxContainer = card[1]
	var teaches := bool(f.get("teaches", false))
	var m := BjjSide.money(c.bjj_side, c.bjj_teaches())
	UI.add_rows(v, [
		UI.kv("Members (%s a month each)" % UI.money(BjjSide.FEE_MONTH), str(int(m["members"])), UI.FG, "mono"),
		UI.kv("Dues a week", UI.money(int(m["dues"])), UI.GREEN, "mono"),
		UI.kv("Hired coach (%d classes x %s)" % [int(m["coach"]) / BjjSide.COACH_CLASS, UI.money(BjjSide.COACH_CLASS)], UI.signed(-int(m["coach"])), UI.FG, "mono"),
		UI.kv("The classes make a week", UI.signed(int(m["net"])), UI.GREEN if int(m["net"]) >= 0 else UI.RED, "mono")])
	v.add_child(UI.muted("A gold medal brings %d members, silver %d; a blue belt brings %d. About a third leave in a year." % [
		int(BjjSide.MEDAL_MEMBERS["gold"]), int(BjjSide.MEDAL_MEMBERS["silver"]), BjjSide.BLUE_MEMBERS], UI.TINY, true))
	v.add_child(UI.caps("THE BEGINNERS' CLASS"))
	var fid := str(f["id"])
	var why := BjjSide.can_teach(f)
	var cost := "Saves %s a week; %d classes a week on the mat instead of %d." % [UI.money(BjjSide.teach_saves()),
		NoGi.CLASSES_PER_WEEK - NoGi.TEACH_CLASSES, NoGi.CLASSES_PER_WEEK]
	v.add_child(UI.label(("%s teaches it. " % f["first"] if teaches else "The hired coach teaches it. ") + cost, UI.SMALL, UI.FG, "body", true))
	var btns := UI.hbox(10)
	var hire := UI.button("Hired coach", "BtnSolid" if not teaches else "Btn", main.act.bind("gteach", "%s|0" % fid), false,
		"The coach takes all %d classes; %s trains in %d." % [BjjSide.ADULT_CLASSES + BjjSide.BEGINNER_CLASSES, f["first"], NoGi.CLASSES_PER_WEEK])
	hire.name = "TeachHire"
	btns.add_child(hire)
	var mine := UI.button("%s teaches" % f["first"], "BtnSolid" if teaches else "Btn", main.act.bind("gteach", "%s|1" % fid), why != "",
		why if why != "" else cost)
	mine.name = "TeachHer"
	btns.add_child(mine)
	v.add_child(btns)
	return card[0]


## S369 HER BODY: strength and cardio in whole points, trained by her classes (NoGi.body_gain), and what each does in a
## belt match.
func _body(f: Dictionary) -> Control:
	var card := UI.card("BODY - TRAINED ON THE MAT")
	card[0].name = "BjjBody"
	var v: VBoxContainer = card[1]
	var stats: Dictionary = f.get("stats", {})
	for row in [["Strength", "strength", "takedowns, passes, escapes, taking mount"], ["Cardio", "cardio", "how fast the tank empties in a match"]]:
		var key := str(row[1])
		var val := float(stats.get(key, NoGi.BODY_START))
		var gain := NoGi.body_gain(f, key)
		var weeks := ceili((floorf(val) + 1.0 - val) / gain) if gain > 0.0 else 0
		v.add_child(_progress(str(row[0]), "%d" % int(floor(val)), val / 100.0))
		var what := str(row[2]).left(1).to_upper() + str(row[2]).substr(1)
		v.add_child(UI.muted("%s. Next point in %d week%s at %d classes." % [what, weeks, "" if weeks == 1 else "s",
			NoGi.classes_of(f)] if gain > 0.0 else "%s. At the ceiling." % what, UI.TINY, true))
	return card[0]


## RECORD: her opens, newest first, then the belts and stripes so far.
func _record(f: Dictionary) -> Control:
	var card := UI.card("RECORD - NO-GI OPENS %d-%d" % [int(f["w"]), int(f["l"])])
	card[0].name = "OpensRecord"
	card[0].custom_minimum_size = Vector2(380, 0)
	card[0].size_flags_horizontal = Control.SIZE_FILL
	var rows: Array = []
	var opens: Array = f.get("opens", [])
	for i in mini(RECORD_ROWS, opens.size()):
		var o: Dictionary = opens[i]
		var won := bool(o["win"])
		rows.append(UI.row("%s - %s, %s" % ["Won" if won else "Lost", o["opp"], o["how"]], "%s, %s" % [Clock.fmt(int(o["d"])), o["open"]],
			Color(0, 0, 0, 0), [UI.label("W" if won else "L", UI.BODY, UI.GREEN if won else UI.RED, "bold")]))
	if rows.is_empty():
		card[1].add_child(UI.muted("The opens show here.", UI.BODY))
	UI.add_rows(card[1], rows)
	card[1].add_child(UI.caps("BELTS AND STRIPES SO FAR"))
	for b in f.get("belt_log", []):
		var d := Time.get_datetime_dict_from_unix_time(int(Time.get_unix_time_from_datetime_dict({"year": 2026, "month": 1, "day": 5, "hour": 12})) + int(b["d"]) * 86400)
		var note := str(b.get("note", ""))
		card[1].add_child(UI.label("%s - %s %d%s" % [b["t"], Clock.MONTHS[int(d["month"]) - 1], int(d["year"]), (" (%s)" % note) if note != "" else ""],
			UI.SMALL, UI.FG, "body", true))
	return card[0]


## S384 GAMETREE1: the bracket path drawn at entry - one chip per round, the opponent and the one free style word.
static func field_chips(f: Dictionary, d: int) -> HBoxContainer:
	var h := UI.hbox(8)
	h.name = "Field_%d" % d
	var fl: Array = (f.get("field", {}) as Dictionary).get(d, [])
	for i in fl.size():
		var chip := UI.label("R%d %s - %s" % [i + 1, str(fl[i]["name"]), str(fl[i]["style"])], UI.TINY, UI.MUTED, "mono")
		chip.name = "FieldOpp_%d" % i
		h.add_child(chip)
	return h
