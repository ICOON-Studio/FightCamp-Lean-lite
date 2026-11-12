extends VBoxContainer
## FIGHTS, one page (S396): the offers with each fighter's standing, the calendar, the results. An offer's Open goes to its
## bout page.

const OfferCard := preload("res://scripts/ui/OfferCard.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Fixtures := preload("res://scripts/ui/Fixtures.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
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


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	if str(main.route.get("bout", "")) != "":
		var page := BOUT_PAGE.instantiate()
		add_child(page)
		page.build(main, str(main.route["bout"]))
		return
	AreaHead.add(self, main, "fights")
	# S396 screen cut: Offers, Calendar and Results are one page (docs/STRUCTURE_DESIGN_S395.md 5.4).
	_offers(main, c)
	for f in c.fighters:   # S397 rank 4: a pro's offers, the road and the asks
		if ProLadder.on_ladder(c, f):
			add_child(ProFights.section(main, c, f))
	for g in c.grapplers:   # S396 blind round 2: the no-gi athlete's opens belong on Fights too
		add_child(MatOpens.card(main, c, g, "%s: NO-GI OPENS" % str(g["first"]).to_upper()))
	_calendar(c)
	_results(c)


func _offers(main: Node, c: Career) -> void:
	if not c.fighters.is_empty() and c.fighters.all(func(x): return ProLadder.on_ladder(c, x)):
		return   # S397 rank 4: a pro-only gym gets the promoter's cards below, not an empty amateur board
	# S369 (S367 critic: "a list in the top fifth of an empty page"): the offers on the left, each fighter's standing on
	# the right - her face, record, what she has booked and her last results - so an empty week still reads.
	var cols := UI.hbox(16)
	cols.name = "OfferCols"
	add_child(cols)
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
	var open := Bouts.open_offers(c)
	if open.is_empty():
		if c.fighters.is_empty():
			card[1].add_child(UI.muted("Sign a fighter to get offers.", UI.BODY, true))
			return
		card[1].add_child(UI.muted("No offers right now.", UI.BODY, true))
		# S369: when each one's next offer can come (Bouts.day_events' own rule), not "every couple of weeks".
		for bf in c.fighters:
			card[1].add_child(UI.label(next_offer_line(c, bf), UI.BODY, UI.FG, "bold", true))
		return
	# S387 a card per offer (OfferCard): the opponent's face, record, win band and the chips, ready to decide on.
	for fo in open:
		card[1].add_child(OfferCard.make(main, c, fo[0], fo[1]))
	# S442 owner: the offer waiting for an answer draws the eye - the first safe one's Open breathes, never two.
	for b in card[1].find_children("Open_*", "Button", true, false):
		if (b as Button).theme_type_variation == "BtnSolid":
			Pulse.breathe(b)
			break


## When her next offer can come, by Bouts.day_events' rule: none while booked or in the championships, else from her
## next_offer_day.
static func next_offer_line(c: Career, f: Dictionary) -> String:
	var fb: Dictionary = f["bout"]
	if not fb.is_empty():
		return "Booked: %s vs %s, %s." % [f["first"], fb["opp"]["name"], Clock.fmt(int(fb["day"]))]
	if Champs.active(f):
		return "%s: no other offers during the championships." % f["first"]
	if bool(f.get("pro", false)):
		return "%s: pro fights come from the promoter, below." % f["first"] if ProLadder.on_ladder(c, f) else 			"%s: the pro debut comes first." % f["first"]
	var days := int(f.get("next_offer_day", c.day)) - c.day
	if days > 0:
		return "%s: the next offer can come from %s (in %d day%s)." % [f["first"], Clock.fmt(int(f["next_offer_day"])), days, "" if days == 1 else "s"]
	return "%s: an offer can come any day now." % f["first"]


## One fighter's standing: booked or free, then her road's next step - with Enter when the nationals are open to her
## (S397 blind round 3: her last result was on this card and in Results below; the step is what the page lacked).
func _standing(main: Node, c: Career, f: Dictionary) -> Control:
	var fc := FighterCard.build(main, f, "Standing")
	var v: VBoxContainer = fc[1]
	var fb: Dictionary = f["bout"]
	if fb.is_empty():
		v.add_child(UI.label("No bout booked", UI.BODY, UI.GREEN, "bold"))
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
		var go := UI.button("Enter %s for the nationals" % f["first"], "Link", main.act.bind("go", "world:2"))
		go.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		v.add_child(go)
	return fc[0]


## S398: the one fixture list (Fixtures), the same as World's.
func _calendar(c: Career) -> void:
	add_child(Fixtures.card(c)[0])


func _results(c: Career) -> void:
	var card := UI.card("RESULTS")
	add_child(card[0])
	if c.results.is_empty():
		card[1].add_child(UI.muted("No bouts yet.", UI.BODY))
		return
	var rows: Array = []
	for r in c.results:
		var won := str(r.get("outcome", "win" if bool(r["win"]) else "loss"))
		rows.append(UI.row("%s %s %s, %s%s" % [r.get("who", ""), {"win": "beat", "loss": "lost to", "draw": "drew with"}[won], r["opp"], r["cards"], " (pro)" if bool(r.get("pro", false)) else ""],
			"%s. %s" % [Clock.fmt(int(r["d"])), str(r["why"]).get_slice(":", 0)], UI.GREEN if bool(r["win"]) else (UI.MUTED if won == "draw" else UI.RED)))   # S397: no camp jargon
	UI.add_rows(card[1], rows)
