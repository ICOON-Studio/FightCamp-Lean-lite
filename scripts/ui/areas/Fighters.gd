extends VBoxContainer
## FIGHTERS: Roster, Training (a plan per fighter: focus, weight, the move she is learning), Fight camps, Scouting
## (prospects: a scouted range, invite to a trial). A fighter's name opens her page.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
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
			for f in c.fighters:
				_training(main, c, f)
		2:
			_camps(main, c)
		3:
			_scouting(main, c)


func _roster(main: Node, c: Career) -> void:
	var card := UI.card()
	add_child(card[0])
	if c.fighters.is_empty():
		var h := UI.hbox(12)
		h.add_child(UI.muted("Nobody signed yet.", UI.BODY))
		h.add_child(UI.button("Meet the walk-in", "Btn", main.act.bind("interview", ""), c.applicant.is_empty()))
		card[1].add_child(h)
		return
	var grid := GridContainer.new()
	grid.name = "Roster"
	grid.columns = 8
	grid.add_theme_constant_override("h_separation", 28)
	grid.add_theme_constant_override("v_separation", 10)
	for head in ["FIGHTER", "CLASS", "RECORD", "RANK", "WEIGHT", "MOOD", "GOAL", "NEXT BOUT"]:
		grid.add_child(UI.caps(head))
	for f in c.fighters:
		grid.add_child(UI.button(f["name"], "Link", main.act.bind("fighter", f["id"])))
		grid.add_child(UI.label(f["wc"]))
		var pro := bool(f.get("pro", false))
		grid.add_child(UI.mono("%d-%d %s" % [f.get("pro_w", 0), f.get("pro_l", 0), "PRO"] if pro else "%d-%d AM" % [f["w"], f["l"]]))
		grid.add_child(UI.mono(str(f["rank"]) if int(f.get("rank", 0)) > 0 else "-"))
		grid.add_child(UI.mono("%.1f / %.1f" % [f["weight"], f["limit"]]))
		grid.add_child(_mood(f))
		var g: Dictionary = f.get("goal", {})
		grid.add_child(UI.label(g.get("title", "talk in the office" if bool(f["goal_talk"]) else "none")))
		var fb: Dictionary = f["bout"]
		grid.add_child(UI.mono(Clock.fmt(int(fb["day"])) if not fb.is_empty() else "none"))
	card[1].add_child(grid)
	var scouting := UI.button("Find another fighter: Scouting", "Btn", main.act.bind("tab", "3"))
	scouting.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	card[1].add_child(scouting)


## Her mood word (fight model: one stored morale) in its colour; the reason it moved last rides the tooltip.
func _mood(f: Dictionary) -> Label:
	var word := FighterProfile.mood(float(f.get("morale", FighterProfile.MORALE_START)))
	var col: Color = {"Fired up": UI.GREEN, "Steady": UI.FG, "Flat": UI.AMBER, "Low": UI.RED}[word]
	var l := UI.label(word, UI.BODY, col)
	l.name = "Mood_" + str(f["id"])
	l.tooltip_text = str(f.get("mood_reason", ""))
	l.mouse_filter = Control.MOUSE_FILTER_STOP
	return l


func _training(main: Node, c: Career, f: Dictionary) -> void:
	var fid := str(f["id"])
	var card := UI.card("THIS WEEK'S PLAN: %s" % str(f["name"]).to_upper())
	add_child(card[0])
	var camp: Dictionary = f["camp"]
	var in_camp := not camp.is_empty()
	var focus := OptionButton.new()
	focus.name = "Focus_" + fid
	for i in Data.STATS.size():
		focus.add_item(Data.LABEL[Data.STATS[i]], i)
	focus.select(Data.STATS.find(Sim.focus_of(c, f)))
	focus.item_selected.connect(func(i): main.act("focus", "%s|%s" % [fid, Data.STATS[i]]))
	focus.custom_minimum_size = Vector2(240, 0)
	focus.disabled = in_camp
	var diet := OptionButton.new()
	diet.add_item("Hold weight", 0)
	diet.add_item("Cut toward the limit", 1)
	diet.select(1 if str(f["diet"]) == "cut" or in_camp else 0)
	diet.item_selected.connect(func(i): main.act("diet", "%s|%s" % [fid, "cut" if i == 1 else "hold"]))
	diet.custom_minimum_size = Vector2(240, 0)
	diet.disabled = in_camp
	var learn := OptionButton.new()
	learn.name = "Learn_" + fid
	var moves: Dictionary = f["moves"]
	var options: Array = []
	for mv in Data.MOVES:
		options.append(mv)
		learn.add_item("%s (%s)" % [mv, MoveMastery.tier(float(moves[mv])).to_lower()], options.size() - 1)
	learn.select(maxi(0, options.find(str(f.get("learning", "")))))
	learn.item_selected.connect(func(i): main.act("learn", "%s|%s" % [fid, options[i]]))
	learn.custom_minimum_size = Vector2(240, 0)
	# S302 combos: the combo she drills on the pads (only those whose every punch is a weapon).
	var combo_box := OptionButton.new()
	combo_box.name = "Combo_" + fid
	var ids: Array = Combos.unlocked(moves)
	var drilling := str(f.get("combo_learning", ""))
	if drilling == "" and not ids.is_empty():
		drilling = Combos.next_to_learn(moves, f.get("combos", {}))
	for id in ids:
		combo_box.add_item("%s (%s)" % [id, MoveMastery.tier(float((f.get("combos", {}) as Dictionary).get(id, 0.0))).to_lower()])
	combo_box.select(maxi(0, ids.find(drilling)))
	combo_box.item_selected.connect(func(i): main.act("combo", "%s|%s" % [fid, ids[i]]))
	combo_box.custom_minimum_size = Vector2(240, 0)
	combo_box.disabled = ids.is_empty()
	if drilling != "":
		combo_box.tooltip_text = "Coach: \"%s\"" % ComboWords.line(drilling, "coach_learning", str(f["first"]), c.day / 7)
	if ids.is_empty():
		combo_box.add_item("none yet")
	if in_camp:
		card[1].add_child(UI.muted("In camp: the camp sets her focus (%s) and cuts her weight." % Data.LABEL[camp["focus"]], UI.BODY, true))
	var coach_right: Array = []
	if c.coach.is_empty():
		coach_right.append(UI.button("Hire one", "Btn", main.act.bind("go", "gym:1")))
	var cards: Array = f["cards"]
	UI.add_rows(card[1], [
		UI.row("Focus", "the stat this week trains most; its partner trains a little", Color(0, 0, 0, 0), [focus]),
		UI.row("Weight", "%.1f kg, limit %.1f kg" % [f["weight"], f["limit"]], Color(0, 0, 0, 0), [diet]),
		UI.row("Learning", "pad time on one new move a week: a weapon in 2-3 weeks", Color(0, 0, 0, 0), [learn]),
		UI.row("Combo", "pad time on one combination: she can learn it once every punch in it is a weapon" if not ids.is_empty()
			else "she needs two weapons (a jab and a cross) for her first combination", Color(0, 0, 0, 0), [combo_box]),
		UI.row("Coach", ("%s, %s" % [c.coach["name"], str(c.coach["spec"]).to_lower()]) if not c.coach.is_empty()
			else "none: training runs at 60%", Color(0, 0, 0, 0), coach_right),
		UI.row("Her week cards", ", ".join(cards) if not cards.is_empty() else "none picked"),
	])
	card[1].add_child(UI.caps("EXPECTED THIS WEEK"))
	var gain := Sim.daily_gain(c, f)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 28)
	for key in Data.STATS:
		var row := UI.stat_row(Data.LABEL[key], float(f["stats"][key]), key == Sim.focus_of(c, f), UI.FG, UI.gain_text(float(gain[key]) * 7.0))
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		grid.add_child(row)
	card[1].add_child(grid)


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
			rows.append(UI.row("No camp yet for %s" % f["name"], "bout on %s" % Clock.fmt(int(fb["day"])), UI.AMBER,
				[UI.button("Set camp", "BtnSolid", main.act.bind("camp", f["id"]), int(fb["day"]) - c.day < BoutRules.CAMP_MIN_DAYS)]))
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
	card[1].add_child(UI.muted("A trial is free: she comes in on the Monday. Sign her and she costs the %s club stipend a week." % UI.money(250), UI.SMALL, true))
