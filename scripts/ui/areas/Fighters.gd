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
		add_child(GrapplerPage.make(main, page_g))
		return
	AreaHead.add(self, main, "fighters")
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
			var tier := MoveMastery.tier(float(m))
			var next_word: String = {30: "a weapon", 60: "SHARP", 85: "SIGNATURE"}.get(to, "")
			var note := ("%s - %d to %s" % [tier, to - m, next_word]) if next_word != "" else tier
			v.add_child(FighterCard.meter("SHARPENING" if sharpening else "LEARNING", learn,
				float(m - from) / float(maxi(to - from, 1)), note, UI.GOLD))
		var fat := int(f["fatigue"])
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
	var card := UI.card()
	add_child(card[0])
	if c.fighters.is_empty():
		var h := UI.hbox(12)
		h.add_child(UI.muted("Nobody signed yet.", UI.BODY))
		h.add_child(UI.button("Meet the walk-in", "Btn", main.act.bind("interview", ""), c.applicant.is_empty(),
			"No walk-in at reception - press CONTINUE and someone may show up"))
		card[1].add_child(h)
		_mat(main, c, card[1])
		return
	# S330 (MENULOOK1): a tile per fighter - rings for weight, condition, goal and her next bout - two to a row.
	var grid := GridContainer.new()
	grid.name = "Roster"
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 16)
	for f in c.fighters:
		grid.add_child(FighterTile.build(main, c, f))
	card[1].add_child(grid)
	_mat(main, c, card[1])
	var scouting := UI.button("Find another fighter: Scouting", "Btn", main.act.bind("tab", "3"))
	scouting.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	card[1].add_child(scouting)


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
			v.add_child(FighterCard.meter("FILM", "%d of 3" % int(fb["film"]), float(fb["film"]) / 3.0, "depth on the opponent", UI.GOLD))
			var over := float(f["weight"]) - float(f["limit"])
			v.add_child(UI.label("%.1f of %.1f kg" % [f["weight"], f["limit"]], UI.SMALL, UI.GREEN if over <= 0.0 else UI.AMBER, "bold"))
		elif not fb.is_empty():
			var days_to_bout := int(fb["day"]) - c.day
			var camp_locked := days_to_bout < BoutRules.CAMP_MIN_DAYS
			var camp_why := "Bout in %d days - a camp needs at least %d days before fight night" % [days_to_bout, BoutRules.CAMP_MIN_DAYS]
			v.add_child(UI.label("No camp yet", UI.BODY, UI.AMBER, "bold"))
			v.add_child(UI.label("vs %s, %s - %d days out" % [fb["opp"]["name"], Clock.fmt(int(fb["day"])), days_to_bout], UI.BODY))
			var set_camp := UI.button("Set camp", "BtnSolid", main.act.bind("camp", f["id"]), camp_locked, camp_why)
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
	var card := UI.card("PROSPECTS NEAR %s" % c.city.to_upper())
	add_child(card[0])
	var rows: Array = []
	for p in c.prospects:
		var right: Array = []
		var sub := "%d, %s, %s, amateur %d-%d: %s" % [p["age"], str(p["wc"]).to_lower(), str(p["style"]).to_lower(), p["w"], p["l"], p["note"]]
		match str(p["state"]):
			"scout":
				var ranges: Array = []
				for k in ["power", "speed", "technique", "defense"]:
					ranges.append("%s %s" % [str(Data.LABEL[k]).to_lower(), Roster.scouted_range(p, k)])
				sub += ". Scouted: " + ", ".join(ranges)
				var b := UI.button("Invite to a trial", "Btn", main.act.bind("invite", p["id"]))
				b.name = "Invite_" + str(p["id"])
				right.append(b)
			"invited":
				right.append(UI.chip("trial %s" % Clock.fmt(int(p["trial_day"])), "gold"))
			"signed":
				right.append(UI.chip("signed", "green"))
			"passed":
				right.append(UI.chip("passed", ""))
		rows.append(UI.row(p["name"], sub, Color(0, 0, 0, 0), right))
	UI.add_rows(card[1], rows)
	card[1].add_child(UI.muted("A trial is free: the fighter comes in on the Monday. Signing costs the %s club stipend a week." % UI.money(250), UI.SMALL, true))


## S362 the no-gi athletes on the mat: belt, stripes, opens record; the name opens her belt road.
func _mat(main: Node, c: Career, parent: Container) -> void:
	if c.grapplers.is_empty():
		return
	parent.add_child(UI.caps("ON THE MAT - NO-GI"))
	for g in c.grapplers:
		var row := UI.hbox(14)
		row.name = "Grappler_" + str(g["id"])
		row.add_child(UI.button(str(g["name"]), "BtnQuiet", main.act.bind("fighter", str(g["id"]))))
		var sub := UI.muted("%s belt, %d stripe%s - %d-%d in opens - %d classes this belt" % [str(g["belt"]).capitalize(), int(g["stripes"]),
			"" if int(g["stripes"]) == 1 else "s", int(g["w"]), int(g["l"]), int(g.get("mat_classes", 0))], UI.BODY)
		sub.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(sub)
		parent.add_child(row)
