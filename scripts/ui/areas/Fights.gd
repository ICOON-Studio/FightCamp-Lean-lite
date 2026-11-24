extends VBoxContainer
## FIGHTS, one page (S396): the offers with each fighter's standing, the calendar, the results. An offer's Open goes to its
## bout page.
## S545 (owner C498: "shouldnt this be inside the computer in the offece menu ?"): the list is the FIGHTS window of the
## office computer (Office.host builds the desktop round it; `_into` = the window's list). A bout page and the Ask panel
## stay whole pages. The route stays `fights`.

const OfferCard := preload("res://scripts/ui/OfferCard.gd")
const AskPanel := preload("res://scripts/ui/AskPanel.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Fixtures := preload("res://scripts/ui/Fixtures.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const BOUT_PAGE := preload("res://scenes/areas/BoutPage.tscn")
const FighterCard := preload("res://scripts/ui/FighterCard.gd")
const BoutCompare := preload("res://scripts/ui/BoutCompare.gd")
const MatOpens := preload("res://scripts/ui/MatOpens.gd")
const NationalsView := preload("res://scripts/ui/NationalsView.gd")
const NextStep := preload("res://scripts/rules/NextStep.gd")
const FighterPage := preload("res://scripts/ui/areas/FighterPage.gd")
const ProFights := preload("res://scripts/ui/ProFights.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const OFFICE := preload("res://scenes/areas/Office.tscn")

var _into: Container = self


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	if str(main.route.get("bout", "")) != "":
		var page := BOUT_PAGE.instantiate()
		add_child(page)
		page.build(main, str(main.route["bout"]))
		return
	if str(main.route.get("ask", "")) != "":   # S512 ASKFIGHT1: the Ask panel for one fighter
		AskPanel.build(main, self, str(main.route["ask"]))
		return
	add_theme_constant_override("separation", 0)
	var desk := OFFICE.instantiate()
	add_child(desk)
	_into = desk.host(main, "fights")
	# S396 screen cut: Offers, Calendar and Results are one page (docs/STRUCTURE_DESIGN_S395.md 5.4).
	# S545: two bouts waiting to be picked (S543, pro fights 1-6) are the decision: they lead the window, nothing cut.
	var picking := c.fighters.filter(func(x): return not (x.get("pro_pair", {}) as Dictionary).is_empty())
	for f in picking:
		_into.add_child(ProFights.section(main, c, f))
	_offers(main, c)
	for f in c.fighters:   # S397 rank 4: a pro's offers, the road and the asks
		if ProLadder.on_ladder(c, f) and not picking.has(f):
			_into.add_child(ProFights.section(main, c, f))
	for g in c.grapplers:   # S396 blind round 2: the no-gi athlete's opens belong on Fights too
		_into.add_child(MatOpens.card(main, c, g, "%s: NO-GI OPENS" % str(g["first"]).to_upper()))
	_calendar(c)
	_results(c)


func _offers(main: Node, c: Career) -> void:
	if not c.fighters.is_empty() and c.fighters.all(func(x): return ProLadder.on_ladder(c, x)):
		return   # S397 rank 4: a pro-only gym gets the promoter's cards below, not an empty amateur board
	# S369 (S367 critic: "a list in the top fifth of an empty page"): the offers on the left, each fighter's standing on
	# the right - her face, record, what she has booked and her last results - so an empty week still reads.
	var open := Bouts.open_offers(c)
	if open.is_empty() and not c.fighters.is_empty():
		# S546 (owner C503 on the "next offer can come from Tue 13 Jan" lines: "why you tell the player when the next offer
		# is ? the player should be able to book a fight any time his fighters are ready"): with nothing on the table the
		# page is the boxers themselves, two across, each with its own Ask for a bout. No waiting line.
		var grid := GridContainer.new()
		grid.name = "Standing"
		grid.columns = 2
		grid.add_theme_constant_override("h_separation", 16)
		grid.add_theme_constant_override("v_separation", 16)
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_into.add_child(grid)
		for f in c.fighters:
			grid.add_child(_standing(main, c, f))
		return
	var cols := UI.hbox(16)
	cols.name = "OfferCols"
	_into.add_child(cols)
	var card := UI.card("OFFERS ON THE TABLE")
	card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card[0].size_flags_stretch_ratio = 3.0
	card[0].size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	cols.add_child(card[0])
	if not c.fighters.is_empty():
		var side := UI.vbox(16)
		side.name = "Standing"
		side.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		side.size_flags_stretch_ratio = 2.0
		cols.add_child(side)
		for f in c.fighters:
			side.add_child(_standing(main, c, f))
	if open.is_empty():
		card[1].add_child(UI.muted("Sign a fighter to book bouts.", UI.BODY, true))
		return
	# S387 a card per offer (OfferCard): the opponent's face, record, win band and the chips, ready to decide on.
	for fo in open:
		card[1].add_child(OfferCard.make(main, c, fo[0], fo[1]))
	# S442 owner: the offer waiting for an answer draws the eye - the first safe one's Open breathes, never two.
	for b in card[1].find_children("Open_*", "Button", true, false):
		if (b as Button).theme_type_variation == "BtnSolid":
			Pulse.breathe(b)
			break


## One fighter's standing: booked or free, then her road's next step - with Enter when the nationals are open to her
## (S397 blind round 3: her last result was on this card and in Results below; the step is what the page lacked).
func _standing(main: Node, c: Career, f: Dictionary) -> Control:
	var fc := FighterCard.build(main, f, "Standing")
	var v: VBoxContainer = fc[1]
	var fb: Dictionary = f["bout"]
	if fb.is_empty():
		v.add_child(UI.label("No bout booked", UI.BODY, UI.GREEN, "bold"))
		var ask := AskFlow.open(c, f)   # S512 ASKFIGHT1: ask the host for a bout, or why not yet
		if bool(ask["open"]):
			var b := UI.button("Ask for a bout", "BtnSolid", main.act.bind("ask", str(f["id"])))
			b.name = "AskFor_" + str(f["id"])
			b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
			v.add_child(b)
		elif not bool(f.get("pro", false)):
			v.add_child(UI.label(str(ask["why"]) + (" Asking opens %s." % Clock.fmt(int(ask["opens_day"])) if int(ask["opens_day"]) >= 0 else ""),
				UI.SMALL, UI.MUTED, "body", true))
	else:
		v.add_child(UI.label("Booked: vs %s, %s" % [fb["opp"]["name"], Clock.fmt(int(fb["day"]))], UI.BODY, UI.GOLD, "bold"))
		var acts := UI.hbox(8)   # S416 operator on this page: "there is nothing to do in this menu wtf?"
		var fid := str(f["id"])
		acts.add_child(UI.button("Fight prep", "BtnSolid", func(): main.nav({"area": "fighters", "tab": 0, "fighter": fid, "ftab": 5})))
		acts.add_child(UI.button("Game plan", "Btn", func(): main.nav({"area": "fighters", "tab": 0, "fighter": fid, "ftab": FighterPage.PLAYBOOK_TAB, "ptab": 1})))
		v.add_child(acts)
	var road: Dictionary = NextStep.road(FighterPage._road_input(c, f), c.day)
	if int(road["lit"]) >= 0:
		v.add_child(UI.caps("NEXT ON THE ROAD"))
		v.add_child(UI.label("%s. %s" % [str(road["steps"][int(road["lit"])]["name"]), str(road.get("need", ""))], UI.SMALL, UI.FG, "body", true))
	if NationalsView.enter_button(main, c, f) != null:   # S397 blind round 4: the Enter button lives on Championships
		var go := UI.button("Enter for the nationals", "Link", main.act.bind("go", "world:2"))
		go.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		v.add_child(go)
	return fc[0]


## S398: the one fixture list (Fixtures), the same as World's.
func _calendar(c: Career) -> void:
	_into.add_child(Fixtures.card(c)[0])


func _results(c: Career) -> void:
	var card := UI.card("RESULTS")
	_into.add_child(card[0])
	if c.results.is_empty():
		card[1].add_child(UI.muted("No bouts yet.", UI.BODY))
		return
	var rows: Array = []
	for r in c.results:
		var won := str(r.get("outcome", "win" if bool(r["win"]) else "loss"))
		rows.append(UI.row("%s %s %s, %s%s" % [r.get("who", ""), {"win": "beat", "loss": "lost to", "draw": "drew with"}[won], r["opp"], r["cards"], " (pro)" if bool(r.get("pro", false)) else ""],
			"%s. %s" % [Clock.fmt(int(r["d"])), str(r["why"]).get_slice(":", 0)], UI.GREEN if bool(r["win"]) else (UI.MUTED if won == "draw" else UI.RED)))   # S397: no camp jargon
	UI.add_rows(card[1], rows)
