extends VBoxContainer
## One fighter's page: Overview, Attributes and moves, Body, Record, Camp, Contract and goals.

const UI := preload("res://scripts/ui/UI.gd")
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

const TABS := ["Overview", "Attributes and moves", "Body", "Record", "Camp", "Contract and goals"]


func build(main: Node, f: Dictionary) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	var g := Sim.goal_read(c, f)
	add_child(UI.muted("FIGHTERS / Roster / %s" % f["name"], UI.SMALL))
	var head := UI.hbox(16)
	head.add_child(UI.display(str(f["name"]).to_upper(), 52))
	var sub := UI.muted("%s, %d, %s, amateur %d-%d" % [f["wc"], f["age"], f["stance"], f["w"], f["l"]], UI.BODY)
	sub.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(sub)
	if not g.is_empty():
		head.add_child(UI.chip("Goal: %s, %d days, %s" % [g["title"], g["left"], str(g["status"]).to_lower()], g["cls"]))
	add_child(head)
	var tabs := UI.hbox(4)
	var t := int(main.route.get("ftab", 0))
	for i in TABS.size():
		tabs.add_child(UI.button(TABS[i], "TabOn" if t == i else "Tab", main.act.bind("ftab", str(i))))
	add_child(tabs)
	var line := ColorRect.new()
	line.color = UI.LINE
	line.custom_minimum_size = Vector2(0, 1)
	add_child(line)
	match t:
		0:
			_overview(main, c, f, g)
		1:
			add_child(AttrBoard.build(f))
			var mv_card := _card("MOVES: BAR = MASTERY, A WEAPON FROM USABLE (30)")
			var moves: Dictionary = f["moves"]
			for mv in Data.MOVES:
				var mm := float(moves[mv])
				var learning := str(f.get("learning", "")) == mv
				var row := UI.stat_row(mv + ("  (learning)" if learning else ""), mm, mm >= BoutRules.WEAPON_MASTERY, UI.FG,
					"  " + MoveMastery.tier(mm).to_lower())
				var bar: Control = row.get_meta("bar")
				bar.frac = mm / 100.0
				mv_card.add_child(row)
			_combos(f, moves)
			mv_card.add_child(UI.muted("Gold bar = a weapon. Pad time goes to the move she is learning; her week cards keep theirs sharp (%s). Weapons on the night: %d (+%.1f)." % [
				", ".join(f["cards"]),
				BoutRules.weapons(moves).size(), BoutRules.weapons_edge(BoutRules.weapons(moves))], UI.SMALL, true))
		2:
			var card := _card("BODY")
			UI.add_rows(card, [UI.kv("Weight", "%.1f kg" % f["weight"], UI.FG, "mono"), UI.kv("Class limit", "%.1f kg" % f["limit"], UI.FG, "mono"),
				UI.kv("Plan", "cutting" if str(f["diet"]) == "cut" else "holding"), _injury_row(main.career, f)])
		3:
			var title := "RECORD: %d-%d AMATEUR" % [f["w"], f["l"]]
			if bool(f.get("pro", false)):
				title += ", %d-%d-%d PRO (%s)" % [int(f.get("pro_w", 0)), int(f.get("pro_l", 0)), int(f.get("pro_d", 0)), f.get("promoter", "")]
			var card := _card(title)
			var mine := c.results.filter(func(r): return str(r.get("fid", f["id"])) == str(f["id"]))
			if mine.is_empty():
				card.add_child(UI.muted("Her bouts for your gym show here.", UI.BODY))
			var rows: Array = []
			for r in mine:
				rows.append(UI.row("%s vs %s, %s" % ["Won" if bool(r["win"]) else "Lost", r["opp"], r["cards"]],
					"%s. %s" % [Clock.fmt(int(r["d"])), r["why"]], UI.GREEN if bool(r["win"]) else UI.RED))
			UI.add_rows(card, rows)
		4:
			var card := _card("CAMP")
			var camp: Dictionary = f["camp"]
			var fb: Dictionary = f["bout"]
			if not camp.is_empty():
				card.add_child(UI.label("%s focus, %s protocol, film depth %d of 3" % [Data.LABEL[camp["focus"]],
					str(BoutRules.PROTOCOLS[int(camp["protocol"])]["name"]).to_lower(), int(fb["film"])], UI.BODY, UI.FG, "body", true))
				# S302: what film study showed of the opponent (Bouts.film_notes).
				var opp: Dictionary = fb.get("opp", {})
				card.add_child(UI.caps("FILM ON %s" % str(opp.get("name", "her")).to_upper()))
				var seen := CoachNotes.card(opp, Bouts.notes_bank())
				if seen.is_empty():
					card.add_child(UI.muted("No film study in this camp: her habits show on the night.", UI.SMALL, true))
				for row in seen:
					card.add_child(UI.label("\"%s\"" % row["line"], UI.SMALL, UI.FG, "italic", true))
			elif not fb.is_empty():
				var days_to_bout := int(fb["day"]) - c.day
				var camp_locked := days_to_bout < BoutRules.CAMP_MIN_DAYS
				var camp_why := "Bout in %d days - a camp needs at least %d days before fight night" % [days_to_bout, BoutRules.CAMP_MIN_DAYS]
				var b := UI.button("Set her camp", "BtnSolid", main.act.bind("camp", f["id"]), camp_locked, camp_why)
				b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
				card.add_child(b)
			else:
				card.add_child(UI.muted("No bout booked.", UI.BODY))
		5:
			var card := _card("CONTRACT")
			UI.add_rows(card, [UI.kv("Terms", "Club stipend, $250 a week"), UI.kv("Until", "she turns pro")])
			card.add_child(UI.caps("GOALS SO FAR"))
			var done: Array = f.get("history", [])
			if done.is_empty():
				card.add_child(UI.muted("Each finished goal shows here.", UI.BODY))
			for h in done:
				card.add_child(UI.row(h["title"], "%s, %s" % ["met" if bool(h["met"]) else "not met", Clock.fmt(int(h["d"]))],
					UI.GREEN if bool(h["met"]) else UI.RED))


## S302 combos: her combination book - learned ones as bars (gold = she throws it in fights), locked ones say what they need.
func _combos(f: Dictionary, moves: Dictionary) -> void:
	var card := _card("COMBOS: LEARNED ON THE PADS, GOLD = SHE THROWS IT IN FIGHTS")
	var combos: Dictionary = f.get("combos", {})
	var drilling := str(f.get("combo_learning", ""))
	for row in Combos.BOOK:
		var id := str(row["id"])
		var need := Combos.missing(id, moves)
		if not need.is_empty():
			card.add_child(UI.row(id, "needs the %s as a weapon" % " and the ".join(need.map(func(x): return str(x).to_lower())), UI.MUTED))
			continue
		var mm := float(combos.get(id, 0.0))
		var r := UI.stat_row(id + ("  (drilling)" if id == drilling else ""), mm, mm >= Combos.LEARN_AT, UI.FG, "  " + MoveMastery.tier(mm).to_lower())
		var bar: Control = r.get_meta("bar")
		bar.frac = mm / 100.0
		card.add_child(r)
	card.add_child(UI.muted("Each combination in a fight costs energy, longer ones more; her conditioning decides how fast she tires.", UI.SMALL, true))


## S325 update 28: her injury or suspension, red while she is out.
func _injury_row(c: Career, f: Dictionary) -> HBoxContainer:
	return UI.kv("Injuries", Injuries.line(c, f), UI.RED if Injuries.out(c, f) else UI.FG)


func _card(title: String, parent: Container = null) -> VBoxContainer:
	var c := UI.card(title)
	(parent if parent != null else self).add_child(c[0])
	return c[1]


func _overview(main: Node, c: Career, f: Dictionary, g: Dictionary) -> void:
	_next_step_card(c, f)
	# S340 C157: the attributes board runs the page's width (radar + every value the bout reads); body and goal below it.
	add_child(AttrBoard.build(f))
	var grid := UI.hbox(16)
	add_child(grid)
	var body := _card("BODY", grid)
	UI.add_rows(body, [UI.kv("Weight", "%.1f of %.1f kg" % [f["weight"], f["limit"]], UI.FG, "mono"),
		UI.kv("Condition", "Fresh" if int(f["fatigue"]) < 30 else "Tired"), _injury_row(main.career, f)])
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
		goal.add_child(UI.muted("Waiting in your office for her next goal." if bool(f["goal_talk"]) else "No goal set.", UI.BODY, true))
		if bool(f["goal_talk"]):
			var talk := UI.button("Talk to her", "Btn", main.act.bind("goaltalk", f["id"]))
			talk.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			goal.add_child(talk)
	else:
		goal.add_child(UI.label(g["title"], UI.BODY, UI.FG, "bold"))
		goal.add_child(UI.muted("%s, %d days left" % [g["row"], g["left"]], UI.SMALL, true))
		var bar: Control = UI.Bar.new()
		bar.frac = float(g["share"])
		goal.add_child(bar)
		var chip := UI.chip(g["status"], g["cls"])
		chip.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		goal.add_child(chip)
		goal.add_child(UI.label("\"%s\"" % g["line"], UI.SMALL, UI.MUTED, "italic", true))
	goal.add_child(UI.caps("NEXT BOUT"))
	var nb: Dictionary = f["bout"]
	goal.add_child(UI.muted("vs %s, %s" % [nb["opp"]["name"], Clock.fmt(int(nb["day"]))] if not nb.is_empty() else "None booked.", UI.BODY))
	var buttons := UI.hbox(8)
	buttons.add_child(UI.button("Plan her week", "BtnSolid", main.act.bind("go", "fighters:1")))
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


func _next_step_card(c: Career, f: Dictionary) -> void:
	var card := _card("NEXT STEP")
	var road: Dictionary = NextStep.road(_road_input(c, f), c.day)
	if int(road["lit"]) < 0:
		card.add_child(UI.label("Pro - every step done", UI.BODY, UI.FG, "body", true))
		return
	var row := UI.hbox(6)
	for s in road["steps"]:
		var name: String = str(s["name"])
		if bool(s["done"]):
			row.add_child(UI.chip("✓ " + name, ""))
		elif bool(s["lit"]):
			row.add_child(UI.chip(name, "gold"))
		else:
			row.add_child(UI.chip(name, ""))
	card.add_child(row)
	card.add_child(UI.label(str(road["need"]), UI.BODY, UI.FG, "body", true))
