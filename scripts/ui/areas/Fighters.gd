extends VBoxContainer
## FIGHTERS: Roster, Training (her week on TrainingBoard: eight sessions round her body), Fight camps, Scouting
## (prospects: a scouted range, invite to a trial). A fighter's name opens her page.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FighterTile := preload("res://scripts/ui/FighterTile.gd")
const FIGHTER_PAGE_SCRIPT := preload("res://scripts/ui/areas/FighterPage.gd")
const FIGHTER_PAGE := preload("res://scenes/areas/FighterPage.tscn")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	var page_f := c.fighter_by_id(str(main.route.get("fighter", "")))
	if not page_f.is_empty():
		var page := FIGHTER_PAGE.instantiate()
		add_child(page)
		page.build(main, page_f)
		return
	AreaHead.add(self, main, "fighters")
	match int(main.route["tab"]):
		0:
			_roster(main, c)
		1:
			if c.fighters.is_empty():
				AreaHead.placeholder(self, "TRAINING", "Sign a fighter first.")
			# S349 (Q-S294-72): her week as his home-training picture - eight sessions round her body (TrainingBoard).
			# S354 C204 ("this should be like a sub tab in the players profile"): the board lives on her page's Training
			# tab; here each fighter's line opens it.
			_training(main, c)
		2:
			_camps(main, c)
		3:
			_scouting(main, c)


func _training(main: Node, c: Career) -> void:
	var card := UI.card("TRAINING - EACH FIGHTER'S WEEK IS ON THE FIGHTER'S PAGE")
	add_child(card[0])
	for f in c.fighters:
		var row := UI.hbox(14)
		var who := UI.button(str(f["name"]), "BtnQuiet", main.act.bind("fighter", str(f["id"])))
		row.add_child(who)
		var main_s := str(Data.LABEL.get(str(f.get("focus", "")), f.get("focus", "")))
		var learn := str(f.get("learning", ""))
		var sub := UI.muted("Main session: %s%s" % [main_s, ("   Learning: %s" % learn) if learn != "" else ""], UI.BODY)
		sub.size_flags_vertical = Control.SIZE_SHRINK_CENTER   # S354 C206: the button sits by its line, not at the far edge
		row.add_child(sub)
		var open := UI.button("Open training", "Btn", func():
			main.act("fighter", str(f["id"]))
			main.act("ftab", str(FIGHTER_PAGE_SCRIPT.TRAINING_TAB)))
		open.name = "OpenTraining_" + str(f["id"])
		row.add_child(open)
		card[1].add_child(row)


func _roster(main: Node, c: Career) -> void:
	var card := UI.card()
	add_child(card[0])
	if c.fighters.is_empty():
		var h := UI.hbox(12)
		h.add_child(UI.muted("Nobody signed yet.", UI.BODY))
		h.add_child(UI.button("Meet the walk-in", "Btn", main.act.bind("interview", ""), c.applicant.is_empty(),
			"No walk-in at reception - press CONTINUE and someone may show up"))
		card[1].add_child(h)
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
	var scouting := UI.button("Find another fighter: Scouting", "Btn", main.act.bind("tab", "3"))
	scouting.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	card[1].add_child(scouting)


func _camps(main: Node, c: Career) -> void:
	var card := UI.card("FIGHT CAMPS")
	add_child(card[0])
	var rows: Array = []
	for f in c.fighters:
		var camp: Dictionary = f["camp"]
		var fb: Dictionary = f["bout"]
		if not camp.is_empty():
			rows.append(UI.row("%s: %s focus, %s protocol" % [f["name"], Data.LABEL[camp["focus"]], str(BoutRules.PROTOCOLS[int(camp["protocol"])]["name"]).to_lower()],
				"vs %s, %s; film depth %d of 3; %.1f of %.1f kg" % [fb["opp"]["name"], Clock.fmt(int(fb["day"])), int(fb["film"]), f["weight"], f["limit"]], UI.GREEN))
		elif not fb.is_empty():
			var days_to_bout := int(fb["day"]) - c.day
			var camp_locked := days_to_bout < BoutRules.CAMP_MIN_DAYS
			var camp_why := "Bout in %d days - a camp needs at least %d days before fight night" % [days_to_bout, BoutRules.CAMP_MIN_DAYS]
			rows.append(UI.row("No camp yet for %s" % f["name"], "bout on %s" % Clock.fmt(int(fb["day"])), UI.AMBER,
				[UI.button("Set camp", "BtnSolid", main.act.bind("camp", f["id"]), camp_locked, camp_why)]))
		else:
			rows.append(UI.row(f["name"], "no bout booked: camps open once one is"))
	if rows.is_empty():
		rows.append(UI.muted("Camps open once a bout is booked.", UI.BODY))
	UI.add_rows(card[1], rows)


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
