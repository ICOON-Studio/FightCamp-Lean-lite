extends VBoxContainer
## FIGHTERS: Roster, Training (each week on the fighter page: WeekBoard), Fight camps, Scouting
## (prospects: a scouted range, invite to a trial). A fighter's name opens her page.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FighterTile := preload("res://scripts/ui/FighterTile.gd")
const FighterCard := preload("res://scripts/ui/FighterCard.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const FIGHTER_PAGE_SCRIPT := preload("res://scripts/ui/areas/FighterPage.gd")
const FIGHTER_PAGE := preload("res://scenes/areas/FighterPage.tscn")
const GrapplerPage := preload("res://scripts/ui/areas/GrapplerPage.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const FilmEdge := preload("res://scripts/rules/FilmEdge.gd")
const RosterSummary := preload("res://scripts/ui/RosterSummary.gd")
const RosterTable := preload("res://scripts/ui/RosterTable.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	var page_f := c.fighter_by_id(str(main.route.get("fighter", "")))
	if not page_f.is_empty():
		var page := FIGHTER_PAGE.instantiate()
		add_child(page)
		page.build(main, page_f)
		return
	var page_g := c.grappler_by_id(str(main.route.get("fighter", "")))
	if not page_g.is_empty():
		if int(main.route.get("ftab", 0)) == FIGHTER_PAGE_SCRIPT.PLAYBOOK_TAB:   # S387 the mat, from the rail or the page's button
			add_child(UI.display(str(page_g["name"]).to_upper(), 36))
			var book: Node = FIGHTER_PAGE_SCRIPT.PLAYBOOK.instantiate()
			add_child(book)
			book.build(main)
			return
		add_child(GrapplerPage.make(main, page_g))
		return
	MenuFx.set_wall(main, RosterCards.BACKDROP)   # S410 Q-S294-134: the painted gym
	RosterCards.head(self, main, c)
	match int(main.route["tab"]):
		0:
			_roster(main, c)
		1:
			if c.fighters.is_empty():
				AreaHead.placeholder(self, "TRAINING", "Sign a fighter first.")
			# S354 C204 ("this should be like a sub tab in the players profile"): the board lives on her page's Training
			# tab; here each fighter's line opens it.
			_training(main, c)
		2:
			_camps(main, c)
		3:
			_scouting(main, c)


func _training(main: Node, c: Career) -> void:
	# S369 (S367 critic: "a list in the top fifth of an empty page"): a face card per fighter, two to a row - her main
	# session, the move she is learning in whole points to a weapon, her condition; the week itself is on her page.
	var card := UI.card("TRAINING - EACH FIGHTER'S WEEK IS ON THE FIGHTER'S PAGE")
	add_child(card[0])
	var grid := FighterCard.grid("Training")
	for f in c.fighters:
		var fc := FighterCard.build(main, f, "TrainCard")
		var v: VBoxContainer = fc[1]
		var main_s := str(Data.LABEL.get(str(f.get("focus", "")), f.get("focus", "")))
		var line := UI.hbox(10)
		line.add_child(UI.caps("MAIN SESSION"))
		line.add_child(UI.label(main_s if main_s != "" else "not set", UI.BODY, UI.FG, "bold"))
		v.add_child(line)
		var learn := str(f.get("learning", ""))
		if learn == "":
			v.add_child(UI.muted("Learning: the coach picks the next move this week.", UI.SMALL))
		else:
			# The bar runs to her next tier (MoveMastery: RAW < 30 = a weapon, USABLE < 60, SHARP < 85), whole points.
			# Once every move is a weapon, pad time sharpens her weakest (Sim) - the head says so.
			var moves: Dictionary = f["moves"]
			var m := int(floor(float(moves.get(learn, 0.0))))
			var sharpening := true
			for k in moves:
				if float(moves[k]) < BoutRules.WEAPON_MASTERY:
					sharpening = false
			var from := 0
			var to := 30
			for edge in [30, 60, 85, 100]:
				if m < edge:
					to = edge
					break
				from = edge
			var tier := MoveMastery.word(float(m))
			var next_word: String = {30: "Usable", 60: "Sharp", 85: "Signature"}.get(to, "")
			var note := ("%s - %d to %s" % [tier, to - m, next_word]) if next_word != "" else tier
			v.add_child(FighterCard.meter("SHARPENING" if sharpening else "LEARNING", learn,
				float(m - from) / float(maxi(to - from, 1)), note, UI.GOLD))
		var fat := int(FighterProfile.fatigue(f))
		v.add_child(FighterCard.meter("CONDITION", "%d" % (100 - fat), (100.0 - fat) / 100.0,
			"fresh" if fat < 30 else ("tired" if fat < 60 else "worn out"), UI.GREEN if fat < 30 else (UI.AMBER if fat < 60 else UI.RED)))
		var open := UI.button("Open training", "BtnSolid", func():
			main.act("fighter", str(f["id"]))
			main.act("ftab", str(FIGHTER_PAGE_SCRIPT.TRAINING_TAB)))
		open.name = "OpenTraining_" + str(f["id"])
		open.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		v.add_child(open)
		grid.add_child(fc[0])
	card[1].add_child(grid)


func _roster(main: Node, c: Career) -> void:
	if RosterCards.view == "cards" and not (c.fighters.is_empty() and c.grapplers.is_empty()):
		var cards := RosterCards.build(main, c)
		cards.name = "Roster"
		add_child(cards)
		return
	var card := UI.card()
	add_child(card[0])
	if c.fighters.is_empty():
		var h := UI.hbox(12)
		h.add_child(UI.muted("Nobody signed yet.", UI.BODY))
		h.add_child(UI.button("Meet the walk-in", "Btn", main.act.bind("interview", ""), c.applicant.is_empty(),
			"Nobody is waiting at reception. Try the Find a fighter tab."))
		card[1].add_child(h)
		_mat(main, c, card[1])
		return
	# S396 screen cut (mock-up #roster): one sortable table, a row per fighter and the no-gi athlete, built for eight; the
	# tall tiles (S330, S387) fitted two to a screen and repeated the eight-line checklist on each. Her page has the detail.
	var table := RosterTable.build(main, c)
	table.name = "Roster"
	card[1].add_child(table)
	# S397 blind round 4 ("Find a fighter is both a tab and a button"): the tab is the way; this line says what waits there.
	var open := c.prospects.filter(func(p): return str(p.get("state", "")) != "signed").size()
	card[1].add_child(UI.muted("%d prospect%s scouted, waiting under Find a fighter." % [open, "" if open == 1 else "s"] if open > 0
		else "No prospects scouted yet: Find a fighter sends the scout.", UI.SMALL, true))


## S387 (operator: "an overview so players knows whos has booked fight"): one line, every boxer and the fight in front of them.
func _fight_card(c: Career) -> Control:
	var row := UI.hbox(8)
	row.name = "WhoIsBooked"
	row.add_child(UI.caps("BOOKED FIGHTS"))
	for f in c.fighters:
		var b: Dictionary = f.get("bout", {})
		if b.has("day") and b.has("opp"):
			row.add_child(UI.chip("%s vs %s, %s" % [f["first"], str(b["opp"]["name"]), Clock.fmt(int(b["day"]))], "green"))
		else:
			row.add_child(UI.chip("%s: no fight booked" % str(f["first"]), "amber"))
	return row


func _camps(main: Node, c: Career) -> void:
	# S369: a face card per fighter (two to a row): her camp, or what opens one, and the button that does it.
	var card := UI.card("FIGHT CAMPS")
	add_child(card[0])
	if c.fighters.is_empty():
		card[1].add_child(UI.muted("Camps open once a bout is booked.", UI.BODY))
		return
	var grid := FighterCard.grid("Camps")
	for f in c.fighters:
		var fc := FighterCard.build(main, f, "CampCard")
		var v: VBoxContainer = fc[1]
		var camp: Dictionary = f["camp"]
		var fb: Dictionary = f["bout"]
		if not camp.is_empty():
			v.add_child(UI.label("%s focus, %s protocol" % [Data.LABEL[camp["focus"]], str(BoutRules.PROTOCOLS[int(camp["protocol"])]["name"]).to_lower()],
				UI.BODY, UI.GREEN, "bold"))
			v.add_child(UI.label("vs %s, %s" % [fb["opp"]["name"], Clock.fmt(int(fb["day"]))], UI.BODY))
			var fs := FilmEdge.summary(f)   # S381 C229 stage 4: the found tells her plan answers
			v.add_child(FighterCard.meter("FILM", "%d of %d" % [int(fs["n"]), int(fs["of"])], float(fs["n"]) / maxf(1.0, float(fs["of"])),
				"tells answered in the plan", UI.GOLD))
			var over := float(f["weight"]) - float(f["limit"])
			v.add_child(UI.label("%.1f of %.1f kg" % [f["weight"], f["limit"]], UI.SMALL, UI.GREEN if over <= 0.0 else UI.AMBER, "bold"))
		elif not fb.is_empty():
			var days_to_bout := int(fb["day"]) - c.day
			var camp_locked := days_to_bout < BoutRules.CAMP_MIN_DAYS
			var camp_why := "Bout in %d days - a camp needs at least %d days before fight night" % [days_to_bout, BoutRules.CAMP_MIN_DAYS]
			v.add_child(UI.label("No camp yet", UI.BODY, UI.AMBER, "bold"))
			v.add_child(UI.label("vs %s, %s - %d days out" % [fb["opp"]["name"], Clock.fmt(int(fb["day"])), days_to_bout], UI.BODY))
			var set_camp := UI.button("Set camp", "BtnSolid", main.act.bind("camp", f["id"]), camp_locked, camp_why)
			set_camp.name = "SetCamp"
			set_camp.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			v.add_child(set_camp)
		else:
			v.add_child(UI.label("No bout booked", UI.BODY, UI.FG, "bold"))
			v.add_child(UI.muted("A camp opens once a fight is on the calendar.", UI.SMALL, true))
			var find := UI.button("See offers", "Btn", main.act.bind("go", "fights:0"))
			find.name = "SeeOffers_" + str(f["id"])
			find.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			v.add_child(find)
		grid.add_child(fc[0])
	card[1].add_child(grid)


func _scouting(main: Node, c: Career) -> void:
	# S376 (operator's S375 playtest: "scouting rows text-only and the scouted ranges vanish after invite"): a face card per
	# prospect, two to a row; the scouted range of each stat stays on the card through trial and signing (a pip meter to
	# the top of the range, the bottom marked).
	var card := UI.card("PROSPECTS NEAR %s" % c.city.to_upper())
	add_child(card[0])
	var grid := FighterCard.grid("Prospects")
	for p in c.prospects:
		var pc := PanelContainer.new()
		pc.theme_type_variation = "Card"
		pc.name = "Prospect_" + str(p["id"])
		pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var h := UI.hbox(18)
		pc.add_child(h)
		h.add_child(FighterCard.face(p))
		var v := UI.vbox(6)
		v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(v)
		var top := UI.hbox(12)
		var nm := UI.label(str(p["name"]), UI.BODY + 5, UI.FG, "bold")
		top.add_child(nm)
		top.add_child(UI.label("%d-%d amateur" % [int(p["w"]), int(p["l"])], 22, UI.GOLD, "bold"))
		top.add_child(UI.spacer())
		match str(p["state"]):
			"invited":
				top.add_child(UI.chip("trial %s" % Clock.fmt(int(p["trial_day"])), "gold"))
			"signed":
				top.add_child(UI.chip("signed", "green"))
			"passed":
				top.add_child(UI.chip("passed", ""))
		v.add_child(top)
		v.add_child(UI.muted("%d, %s, %s: %s" % [p["age"], str(p["wc"]).to_lower(), str(p["style"]).to_lower(), p["note"]], UI.SMALL, true))
		v.add_child(UI.caps("SCOUTED"))
		for k in ["power", "speed", "technique", "defense"]:
			var r := UI.hbox(10)
			var lab := UI.label(str(Data.LABEL[k]), UI.SMALL, UI.FG)
			lab.custom_minimum_size = Vector2(110, 0)
			r.add_child(lab)
			var mid := float(p["stats"][k])
			r.add_child(UI.meter((mid + Data.SCOUT_SPREAD) / 100.0, UI.GOLD, [(mid - Data.SCOUT_SPREAD) / 100.0], 150.0))
			r.add_child(UI.mono(Roster.scouted_range(p, k), UI.SMALL, UI.FG))
			v.add_child(r)
		if str(p["state"]) == "scout":
			var b := UI.button("Invite to a trial", "Btn", main.act.bind("invite", p["id"]))
			b.name = "Invite_" + str(p["id"])
			b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			v.add_child(b)
		grid.add_child(pc)
	card[1].add_child(grid)
	card[1].add_child(UI.muted("Scouted ranges: a club fighter reads about 50-60. A trial is free: the fighter comes in on the Monday. Signing costs the %s club stipend a week." % UI.money(250), UI.SMALL, true))


## S362 the no-gi athletes on the mat: belt, stripes, opens record; the name opens her belt road.
func _mat(main: Node, c: Career, parent: Container) -> void:
	if c.grapplers.is_empty():
		return
	# S376 (operator's S375 playtest: "Ana a text row on Roster"): a no-gi athlete gets the boxers' face card - her belt,
	# opens record, classes this belt, the move her classes drill, and her mat in the Playbook.
	parent.add_child(UI.caps("ON THE MAT - NO-GI"))
	var grid := FighterCard.grid("MatCards")
	grid.columns = 1   # S388 C236 a summary row, the full width like the boxers
	for g in c.grapplers:
		var fc := FighterCard.build(main, g, "Grappler")
		var v: VBoxContainer = fc[1]
		var stripes := int(g["stripes"])
		v.add_child(UI.label("%s belt, %d stripe%s" % [str(g["belt"]).capitalize(), stripes, "" if stripes == 1 else "s"], UI.BODY, UI.FG, "bold"))
		v.add_child(UI.label("%d classes this belt" % int(g.get("mat_classes", 0)), UI.BODY))
		var drill := NoGi.drilling(g, c.day)
		if drill != "":
			v.add_child(UI.label("Drilling: %s" % NoGi.move_name(drill).to_lower(), UI.SMALL, UI.GREEN, "bold"))
		v.add_child(RosterSummary.grappler(c, g))
		var id := str(g["id"])
		var mat := UI.button("%s's mat: Playbook" % str(g["first"]), "Btn", func():
			Playbook.pick = id
			main.act("go", "playbook:0"))
		mat.name = "Mat_" + id
		mat.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		v.add_child(mat)
		grid.add_child(fc[0])
	parent.add_child(grid)
