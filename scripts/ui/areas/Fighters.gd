extends VBoxContainer
## FIGHTERS: Roster, Training (each week on the fighter page: WeekBoard), Fight camps, Scouting
## (prospects: a scouted range, invite to a trial). A fighter's name opens her page.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const StatBlock := preload("res://scripts/rules/StatBlock.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FighterCard := preload("res://scripts/ui/FighterCard.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const FIGHTER_PAGE_SCRIPT := preload("res://scripts/ui/areas/FighterPage.gd")
const FIGHTER_PAGE := preload("res://scenes/areas/FighterPage.tscn")
const GrapplerPage := preload("res://scripts/ui/areas/GrapplerPage.gd")
const FilmEdge := preload("res://scripts/rules/FilmEdge.gd")
const RosterRows := preload("res://scripts/ui/RosterRows.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")


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
	if c.fighters.is_empty():
		var empty := UI.hbox(12)
		empty.add_child(UI.label("No boxer signed yet.", UI.BODY, WoodKit.SOFT))
		empty.add_child(UI.button("Meet the walk-in", "Btn", main.act.bind("interview", ""), c.applicant.is_empty(),
			"Nobody is waiting at reception. Try the Find a fighter tab."))
		add_child(empty)
		if c.grapplers.is_empty():
			return
	# S440: with no boxer yet, the no-gi athlete still gets her painted row below (was the S362 mat card).
	# PAGES2B: painted rows from RosterRow.row (the default view since S440). The old Needs-you chips and WhoIsBooked line are gone:
	# each row's badge, DO NEXT pin and NEXT FIGHT column already say those things. Rows sit on a dark slate plate.
	# S397 blind round 4 ("Find a fighter is both a tab and a button"): the tab is the way; the foot line says what waits there.
	var open := c.prospects.filter(func(p): return str(p.get("state", "")) != "signed").size()
	var scout_line := "%d prospect%s scouted, waiting under Find a fighter." % [open, "" if open == 1 else "s"] if open > 0 \
		else "No prospects scouted yet: Find a fighter sends the scout."
	add_theme_constant_override("separation", 4)   # S440 round 2: the first row near the painting's y 190
	var rows := RosterRows.build(main, c, scout_line)
	rows.name = "Roster"
	add_child(rows)


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
		# S443 one set of numbers (UX_AUDIT_S442 proposal A): the short form the roster and the fighter page use, each a
		# scouted range (a copy: the prospect's own dict is not given attributes by a page draw)
		for gr in StatBlock.groups(Data.fighter_state(p.duplicate(true), c.day)):   # as the reception reads the walk-in
			var r := UI.hbox(10)
			var lab := UI.label(str(gr["name"]), UI.SMALL, UI.FG)
			lab.custom_minimum_size = Vector2(110, 0)
			r.add_child(lab)
			var mid := float(StatBlock.shown(float(gr["value"])))
			r.add_child(UI.meter((mid + Data.SCOUT_SPREAD) / 100.0, UI.GOLD, [(mid - Data.SCOUT_SPREAD) / 100.0], 150.0))
			r.add_child(UI.mono("%d-%d" % [int(mid) - Data.SCOUT_SPREAD, int(mid) + Data.SCOUT_SPREAD], UI.SMALL, UI.FG))
			v.add_child(r)
		if str(p["state"]) == "scout":
			var b := UI.button("Invite to a trial", "Btn", main.act.bind("invite", p["id"]))
			b.name = "Invite_" + str(p["id"])
			b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			v.add_child(b)
		grid.add_child(pc)
	card[1].add_child(grid)
	card[1].add_child(UI.muted("Scouted ranges: a club fighter reads about 50-60. A trial is free: the fighter comes in on the Monday. Signing costs the %s club stipend a week." % UI.money(250), UI.SMALL, true))
