extends VBoxContainer
## One fighter's page: Overview, Attributes and moves, Body, Record, Camp, Contract and goals.

const AwardCard := preload("res://scripts/ui/AwardCard.gd")
const UI := preload("res://scripts/ui/UI.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const CoachNotes := preload("res://scripts/rules/CoachNotes.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const NextStep := preload("res://scripts/rules/NextStep.gd")
const AttrBoard := preload("res://scripts/ui/AttrBoard.gd")
const WeekBoard := preload("res://scripts/ui/WeekBoard.gd")
const FightPrep := preload("res://scripts/ui/FightPrep.gd")
const PerkRoad := preload("res://scripts/rules/PerkRoad.gd")
const OppFileCard := preload("res://scripts/ui/OppFileCard.gd")
const MoveTip := preload("res://scripts/ui/MoveTip.gd")
const FilmEdge := preload("res://scripts/rules/FilmEdge.gd")

## S354 C204 (operator on the training board: "this should be like a sub tab in the players profile , to see an an overview
## of the training"): the week board (WeekBoard; S356 TrainingBoard deleted) is the page's Training tab.
## S387 (operator: "maybe it is good idea to put playbook in the fighter page"): the Playbook is tab 7, drawn beside Training.
## S396 screen cut: 5 tabs shown (TAB_ORDER); 1, 2 and 6 fold into Overview, their indices kept for old links (Routes.gd).
const TABS := ["Overview", "Attributes and moves", "Body", "Training", "History", "Fight prep", "Contract and goals", "Playbook"]
const TAB_ORDER := [0, 3, 5, 7, 4]
const TRAINING_TAB := 3
const PLAYBOOK_TAB := 7
const PLAYBOOK := preload("res://scenes/areas/Playbook.tscn")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const WB_KIT := preload("res://scripts/ui/WhiteboardKit.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const NationalsView := preload("res://scripts/ui/NationalsView.gd")
const BoutHistory := preload("res://scripts/ui/BoutHistory.gd")
const StudyWeek := preload("res://scripts/rules/StudyWeek.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const DarkOverview := preload("res://scripts/ui/DarkOverview.gd")

## S414 operator on Q-S294-143: "Show me one real page first". On until the dark-or-cream answer; false draws the old page.
static var dark_overview := true
var _dark := false


func build(main: Node, f: Dictionary) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	var g := Sim.goal_read(c, f)
	var t := int(main.route.get("ftab", 0))
	_dark = dark_overview and t == 0
	# S397 blind round 4 ("Fight prep is 60% empty and repeats other pages"): the tab shows only with a bout or a camp to prep.
	var prep := not (f.get("bout", {}) as Dictionary).is_empty() or not (f.get("camp", {}) as Dictionary).is_empty()
	if t == 5 and not prep:
		t = 0
	var tabs := UI.hbox(4)
	for i in TAB_ORDER.filter(func(i): return i != 5 or prep):
		tabs.add_child(UI.button(TABS[i], "TabOn" if t == i else "Tab", main.act.bind("ftab", str(i))))
	var sub := UI.muted("%s, %d, %s, amateur %d-%d" % [f["wc"], f["age"], f["stance"], f["w"], f["l"]], UI.BODY)
	# S396 blind round 2 ("the Week header differs from the other fighter tabs"): one header on every tab - the compact row
	# (S382: it keeps the week strip above the fold), with her goal chip.
	# S382 training final proof: the week strip is the screen (TRAINING_SCREEN_S381.md section 3, the mockup's one
	# title row) - name, her line and the tabs share one row so the PM nights sit above the fold at 1080.
	var row := UI.hbox(24)
	if _dark:   # the boxer's name and line stand over the full-height picture instead
		DarkOverview.dim_wall(main)
	else:
		_photo(row, f, Vector2(64, 80))
		var who := UI.vbox(0)
		who.add_child(UI.display(str(f["name"]).to_upper(), 36))
		who.add_child(sub)
		row.add_child(who)
	tabs.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(tabs)
	if not g.is_empty() and t == 0 and not _dark:   # S398 critics: on Week / Fight prep the goal chip met other deadlines
		# S398 critics ("next bout inside a month, at risk" beside a booked bout): the chip says what the goal asks
		var miss: Array = []   # what is still missing, in words ("Conditioning 62.9 of 65.1"); a met part is not repeated
		for tg in g.get("targets", []):
			if not bool(tg.get("met", false)):
				miss.append("a fight booked" if str(tg["key"]) == "booked_fight" else "%s %.1f of %.1f" % [str(Data.LABEL.get(str(tg["key"]), str(tg.get("label", tg["key"])))), float(tg["current"]), float(tg["target"])])
		var gc := UI.chip("Goal, %d days: %s" % [g["left"], ("still needs " + ", ".join(miss) + " - " + str(g["status"]).to_lower()) if not miss.is_empty() else "met"], g["cls"])
		gc.tooltip_text = str(g["title"])
		gc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(gc)
	add_child(row)
	# S396 screen cut (Routes.gd): Overview carries the stats and moves, the body and the contract; 5 tabs, not 8.
	for k in ([0, 1, 6] if t == 0 else [t]):   # Overview has its own body panel and radar: 2 and 1's board would repeat
		_tab(main, c, f, g, k, t == 0)
	if _dark:
		DarkOverview.ink(self)


func _tab(main: Node, c: Career, f: Dictionary, g: Dictionary, t: int, folded: bool = false) -> void:
	match t:
		PLAYBOOK_TAB:
			var book := PLAYBOOK.instantiate()
			add_child(book)
			book.build(main)
		0:
			_overview(main, c, f, g)
		1:
			if not folded:
				add_child(AttrBoard.build(f))
			# S354 the perk road (RPG layer): what training is opening.
			var perk_card := _card("THE PERK ROAD - PERKS OPEN AS TRAINING BUILDS THE ATTRIBUTES")
			for ps in PerkRoad.status(f):
				perk_card.add_child(UI.row(str(ps["name"]) + ("  (open)" if bool(ps["open"]) else ""), "%s - needs %s" % [ps["effect"], ps["need"]],
					UI.GREEN if bool(ps["open"]) else (UI.AMBER if bool(ps["near"]) else UI.LINE)))
			var mv_card := _card("MOVES: BAR = MASTERY, A WEAPON FROM USABLE (30)")
			var moves: Dictionary = f["moves"]
			for mv in Data.MOVES:
				var mm := float(moves[mv])
				var learning := str(f.get("learning", "")) == mv
				var row := UI.stat_row(mv + ("  (learning)" if learning else ""), mm, mm >= BoutRules.WEAPON_MASTERY, UI.FG,
					"  " + MoveMastery.word(mm).to_lower())
				var bar: Control = row.get_meta("bar")
				bar.frac = mm / 100.0
				bar.marks = [BoutRules.WEAPON_MASTERY / 100.0]   # S375 the tick where a move becomes a weapon
				bar.custom_minimum_size.y = UI.METER_H + 2.0
				MoveTip.attach(row, mv, f)   # S382 MOVETIP1: hover a move bar and the hover card plays it on her body
				mv_card.add_child(row)
			_combos(f, moves)
			mv_card.add_child(UI.muted("Gold bar = a weapon. Pad time goes to the move being learned; the week cards keep theirs sharp (%s). Weapons on the night: %d (+%.1f)." % [
				", ".join(f["cards"]),
				BoutRules.weapons(moves).size(), BoutRules.weapons_edge(BoutRules.weapons(moves))], UI.SMALL, true))
			_study_card(main, f)
		2:
			var card := _card("BODY")
			UI.add_rows(card, [UI.kv("Weight", "%.1f kg" % f["weight"], UI.FG, "mono"), UI.kv("Class limit", "%.1f kg" % f["limit"], UI.FG, "mono"),
				UI.kv("Plan", "cutting" if str(f["diet"]) == "cut" else "holding")] + _injury_rows(main.career, f))
		3:
			# S354 CORE3: the week planner (WeekBoard) replaces the session-blocks board - the week now drives the sim.
			# S382 DRILLCARD1: the tab opens on the week strip and its drill tray (the tray replaced the S375 combo planner);
			# her road (the skills awards, S370 GOALTESTS1) sits below it.
			add_child(WeekBoard.make(main, c, f))
			add_child(AwardCard.make(c, f))
		4:
			# S397 blind round 3 ("History is one row"): every bout, the ones she brought too, as a table (BoutHistory).
			add_child(BoutHistory.make(main, c, f))
		5:
			# S398 Fight prep rebuilt (first-hour critics 4/10): countdown, the road, camp and weight, the file, the plan.
			add_child(FightPrep.make(main, c, f))
		6:
			var card := _card("CONTRACT")
			UI.add_rows(card, [UI.kv("Terms", "Club stipend, $250 a week"), UI.kv("Until", "turning pro")])
			card.add_child(UI.caps("GOALS SO FAR"))
			var done: Array = f.get("history", [])
			if done.is_empty():
				card.add_child(UI.muted("Each finished goal shows here.", UI.BODY))
			for h in done:
				card.add_child(UI.row(h["title"], "%s, %s" % ["met" if bool(h["met"]) else "not met", Clock.fmt(int(h["d"]))],
					UI.GREEN if bool(h["met"]) else UI.RED))


## S463 LEARNPICK1 (greybox, Q-S294-221): what she studies next. The slot row says how far it is and how long it takes on
## this week's pad nights; the coach's cards (LearnSlots.cards) each say why, and a click studies it.
func _study_card(main: Node, f: Dictionary) -> void:
	## S465 C388 ("doesnt look good, needs redesign"): the study slot as one progress bar, the coach's cards side by side as
	## tiles (move, kind, weeks to usable, why, one Study button) instead of page-wide buttons with the reason under them.
	var card := _card("WHAT TO LEARN NEXT")
	var pads := (PadWeek.nights_of(f).get("pads", []) as Array).size()
	var slot: Array = f.get("learning_slots", [])
	if slot.is_empty():
		card.add_child(UI.muted("Study slot free: pick one of the coach's cards below. Her pad nights then work on it.", UI.SMALL, true))
	for id in slot:
		var sid := str(id)
		var m := StudyWeek.MoveTree.mastery(f, sid)
		var r := UI.stat_row("Studying " + StudyWeek.name_of(sid), m, false, UI.FG, "  of 30, " + _weeks_word(f, sid, pads))
		(r.get_meta("bar") as Control).set("frac", clampf(m / StudyWeek.USABLE, 0.0, 1.0))
		card.add_child(r)
	if not slot.is_empty():
		card.add_child(UI.muted("On %d pad night%s a week. At 30 a fight plan can use it; the slot then frees." % [pads, "" if pads == 1 else "s"], UI.SMALL, true))
	var full := slot.size() >= StudyWeek.slot_count(f)
	var tiles := UI.hbox(14)
	card.add_child(tiles)
	for c in StudyWeek.cards(f):
		tiles.add_child(_study_tile(main, f, c, full, pads))


func _weeks_word(f: Dictionary, id: String, pads: int) -> String:
	var w := StudyWeek.weeks_left(f, id, pads)
	return "needs pad nights" if w < 0 else ("about %d week%s" % [w, "" if w == 1 else "s"])


## One coach's card: what the move is, how long to usable, why the coach picks it, and the one Study button.
func _study_tile(main: Node, f: Dictionary, c: Dictionary, full: bool, pads: int) -> Control:
	var id := str(c["id"])
	var punch := StudyWeek.MoveTree.PUNCH_IDS.has(id)
	var now := punch and str(f.get("learning", "")) == id
	var held := "Already the pad move being learned" if now else ("Slot taken until the move in it is usable" if full and not punch else "")
	var tile := PanelContainer.new()
	tile.custom_minimum_size = Vector2(380, 0)
	tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 1, 0.05)
	sb.border_color = Color(1, 1, 1, 0.18)
	sb.set_border_width_all(1)
	sb.border_width_top = 3
	sb.set_corner_radius_all(4)
	sb.set_content_margin_all(14)
	tile.add_theme_stylebox_override("panel", sb)
	var v := UI.vbox(6)
	tile.add_child(v)
	v.add_child(UI.label(StudyWeek.name_of(id), 22, UI.FG, "bold"))
	var kind := "Punch, learned on the pads" if punch else ("Footwork" if str(StudyWeek.MoveTree._node(id).get("branch", "")) == "footwork" else "Defence")
	var m := StudyWeek.MoveTree.mastery(f, id)
	var how := "takes the pad move's place" if punch else "%d of 30 now, %s" % [int(m), _weeks_word(f, id, pads)]
	v.add_child(UI.muted("%s  ·  %s" % [kind, how], UI.SMALL, true))
	for reason in (c["reasons"] as Array):
		if str(reason).ends_with("to Usable"):   # the line above already says how long
			continue
		var words := str(reason)
		for n in StudyWeek.MoveTree.NODES:   # "Opens push_off" -> "Opens Push off": game words, never ids
			words = words.replace(str(n["id"]), StudyWeek.name_of(str(n["id"])))
		v.add_child(UI.label("▸ " + words, UI.SMALL, UI.FG, "body", true))
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(spacer)
	var b := UI.button("Study %s" % StudyWeek.name_of(id), "Btn", main.act.bind("study", "%s|%s" % [f["id"], id]), now or (full and not punch), held)
	b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	b.custom_minimum_size.x = 220
	v.add_child(b)
	if held != "":
		v.add_child(UI.muted(held, UI.SMALL, true))   # a grey button says why on screen
	return tile


## S302 combos: her combination book - learned ones as bars (gold = she throws it in fights), locked ones say what they need.
func _combos(f: Dictionary, moves: Dictionary) -> void:
	var card := _card("COMBOS: LEARNED ON THE PADS, GOLD = THROWN IN FIGHTS")
	var combos: Dictionary = f.get("combos", {})
	var drilling := str(f.get("combo_learning", ""))
	for row in Combos.BOOK:
		var id := str(row["id"])
		var need := Combos.missing(id, moves)
		if not need.is_empty():
			card.add_child(UI.row(id, "needs the %s as a weapon" % " and the ".join(need.map(func(x): return str(x).to_lower())), UI.MUTED))
			continue
		var mm := float(combos.get(id, 0.0))
		var r := UI.stat_row(id + ("  (drilling)" if id == drilling else ""), mm, mm >= Combos.LEARN_AT, UI.FG, "  " + MoveMastery.word(mm).to_lower())
		var bar: Control = r.get_meta("bar")
		bar.frac = mm / 100.0
		MoveTip.attach(r, id, f)
		card.add_child(r)
	card.add_child(UI.muted("Each combination in a fight costs energy, longer ones more; conditioning decides how fast the tank empties.", UI.SMALL, true))


## S325 update 28: the injury or suspension, red while the fighter is out. S398 (operator: nothing the player cannot act
## on): no row at all while fit.
func _injury_rows(c: Career, f: Dictionary) -> Array:
	return [UI.kv("Injuries", Injuries.line(c, f), UI.RED)] if Injuries.out(c, f) else []


func _card(title: String, parent: Container = null) -> VBoxContainer:
	var c: Array = DarkOverview.panel(title) if _dark else UI.card(title)
	(parent if parent != null else self).add_child(c[0])
	return c[1]


## S387 operator: the fighter's page carries the face (a breathing head and shoulders, PromoShot).
func _photo(parent: Control, f: Dictionary, size: Vector2) -> void:
	var p := PromoShot.picture(Faces.stem(f), size)
	if p != null:
		parent.add_child(p)


func _overview(main: Node, c: Career, f: Dictionary, g: Dictionary) -> void:
	_next_step_card(main, c, f)
	if _dark:
		DarkOverview.make(self, main, c, f, g)
		return
	# S340 C157: the attributes board runs the page's width (radar + every value the bout reads); body and goal below it.
	add_child(AttrBoard.build(f))
	var grid := UI.hbox(16)
	add_child(grid)
	var body := _card("BODY", grid)
	UI.add_rows(body, [UI.kv("Weight", "%.1f of %.1f kg" % [f["weight"], f["limit"]], UI.FG, "mono"),
		UI.kv("Condition", str(WB_KIT.fatigue_word(FighterProfile.fatigue(f), false)[0]).capitalize())] + _injury_rows(main.career, f))
	body.add_child(UI.caps("COACH SAYS"))
	body.add_child(UI.label(Sim.coach_line(c, f), UI.BODY, UI.FG, "italic", true))
	# S302: what the coach has learned about her so far (fights and sparring fill it in).
	var known := CoachNotes.progress(f)
	body.add_child(UI.caps("COACH'S NOTES, %d OF %d" % [int(known[0]), int(known[1])]))
	var notes := CoachNotes.card(f, Bouts.notes_bank())
	if notes.is_empty():
		body.add_child(UI.muted("Fights and sparring fill this in.", UI.SMALL, true))
	for row in notes:
		body.add_child(UI.label("\"%s\"" % row["line"], UI.SMALL, UI.FG, "italic", true))
	var goal := _card("GOAL", grid)
	if g.is_empty():
		goal.add_child(UI.muted("Waiting in your office for the next goal." if bool(f["goal_talk"]) else "No goal set.", UI.BODY, true))
		if bool(f["goal_talk"]):
			var talk := UI.button("Talk about the next goal", "Btn", main.act.bind("goaltalk", f["id"]))
			talk.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			goal.add_child(talk)
	else:
		goal.add_child(UI.label(g["title"], UI.BODY, UI.FG, "bold"))
		goal.add_child(UI.muted("%s, %d days left" % [g["row"], g["left"]], UI.SMALL, true))
		goal.add_child(UI.meter(float(g["share"])))   # S375 short meter, not a card-wide line
		var chip := UI.chip(g["status"], g["cls"])
		chip.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		goal.add_child(chip)
		goal.add_child(UI.label("\"%s\"" % g["line"], UI.SMALL, UI.MUTED, "italic", true))
	goal.add_child(UI.caps("NEXT BOUT"))
	var nb: Dictionary = f["bout"]
	goal.add_child(UI.muted("vs %s, %s" % [nb["opp"]["name"], Clock.fmt(int(nb["day"]))] if not nb.is_empty() else "None booked.", UI.BODY))
	var buttons := UI.hbox(8)
	var entering := NationalsView.enter_button(main, c, f) != null   # S397: the Enter button above is the page's one filled button
	buttons.add_child(UI.button("Plan the week", "Btn" if entering else "BtnSolid", main.act.bind("ftab", str(TRAINING_TAB))))
	buttons.add_child(UI.button("Fight plan (%d arrows)" % (f.get("arrows", []) as Array).size() if not (f.get("arrows", []) as Array).is_empty()
		else "Fight plan", "Btn", main.act.bind("plan", f["id"])))
	buttons.add_child(UI.button("Find a bout", "Btn", main.act.bind("go", "fights:0")))
	goal.add_child(buttons)
	for child in grid.get_children():
		(child as Control).size_flags_vertical = Control.SIZE_FILL


## Input for NextStep.road from her career state (one source for the card and tests).
static func _road_input(c: Career, f: Dictionary) -> Dictionary:
	var nationals := ""
	if Champs.active(f):
		nationals = "entered"
	else:
		var ch: Dictionary = f.get("champ", {})
		if not ch.is_empty() and bool(ch.get("done", false)):
			nationals = str(ch.get("result", ""))
	var pro_bouts := 0
	for r in c.results:
		if str(r.get("fid", "")) == str(f["id"]) and bool(r.get("pro", false)):
			pro_bouts += 1
	return {"bouts": Champs.bouts(f), "w": int(f["w"]), "reg_days": Champs.club_days(c, f), "age": int(f["age"]),
		"injured": Injuries.out(c, f), "rank": int(f.get("rank", 0)), "pro_declines": int(f.get("pro_declines", 0)),
		"nat_final": bool(f.get("nat_final", false)), "nationals": nationals, "pro": bool(f.get("pro", false)),
		"pro_bouts": pro_bouts}


func _next_step_card(main: Node, c: Career, f: Dictionary) -> void:
	var card := _card("NEXT STEP")
	var road: Dictionary = NextStep.road(_road_input(c, f), c.day)
	if int(road["lit"]) < 0:
		card.add_child(UI.label("Pro - every step done", UI.BODY, UI.FG, "body", true))
		return
	# S398 (operator: nothing the player cannot act on): the step now and what it needs; the whole road on hover
	var lit: Dictionary = road["steps"][int(road["lit"])]
	var now := UI.label("%s: %s" % [str(lit["name"]), str(road["need"])], UI.BODY, UI.FG, "body", true)
	now.name = "NextStepNow"
	now.mouse_filter = Control.MOUSE_FILTER_STOP
	now.tooltip_text = " > ".join((road["steps"] as Array).map(func(st): return ("done: " if bool(st["done"]) else "") + str(st["name"])))
	card.add_child(now)
	var enter := NationalsView.enter_button(main, c, f)   # S397 blind round 3: one main action per state
	if enter != null:
		if _dark:
			DarkOverview.main_style(enter)
		card.add_child(enter)
