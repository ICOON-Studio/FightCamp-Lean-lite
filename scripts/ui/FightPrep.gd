extends RefCounted
## S398 Fight prep (the first hour's landing page after Accept; first-hour critics 4/10 five rounds running). Built in two
## rounds: v1 from a free seat's draft (agy), blind 6.4 / 6.3; v2 on the operator's rule (S398: "i do not want stupid and
## unecessary information to be displayed unless the player can really do something about it") and the critics' faults -
## no status pills that repeat the panels, no weeks strip, one call to action with its deadline, every opponent trait next
## to the answer the plan can give it. Top to bottom:
##   head      VS <opponent> (club, record, game), "19 days" to fight night and the weigh-in, the ONE primary button
##   tale      the one tape (TapeRows), drawn like the versus card, and the win chance with how sure it is
##   answers   WHAT YOUR PLAN SHOULD ANSWER: each trait found with its answer and "Write it"; hidden ones say what opens
##             them; lines written of the coach's limit and the sparring nights left to test them
##   camp      CAMP AND WEIGHT: the goal attribute's line to fight night, the scale with its margin
## Attribute names come from the lines (WeekPlan.goal_lines through WeekBoard.plan_of), never a fixed stat list.
##   FightPrep.make(main, career, fighter) -> VBoxContainer "FightPrep"   next_step(career, fighter) -> [label, act, arg]

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const SparNights := preload("res://scripts/rules/SparNights.gd")
const WeekBoard := preload("res://scripts/ui/WeekBoard.gd")
const MatchupCards := preload("res://scripts/ui/MatchupCards.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const TapeRows := preload("res://scripts/rules/TapeRows.gd")
const VersusPanel := preload("res://scripts/ui/VersusPanel.gd")

## Under this many kg to spare on the scale the forecast is a warning, not a pass.
const SCALE_MARGIN := 0.5


static func make(main: Node, c: Career, f: Dictionary) -> VBoxContainer:
	var page := UI.vbox(14)
	page.name = "FightPrep"
	var fb: Dictionary = f.get("bout", {})
	if fb.is_empty() or not fb.has("day"):
		page.add_child(UI.muted("No fight booked: Fight prep opens with the next bout.", UI.BODY))
		return page
	var opp: Dictionary = fb.get("opp", {})
	var bout_day := int(fb["day"])
	var spars := _spars(c, f)
	page.add_child(_head(main, c, f, opp, bout_day))
	page.add_child(MatchupCards.make(main, c, f, opp, spars))   # S398: the plan's matchup in pictures, first (operator: "add graphics")
	var row := UI.hbox(16)
	row.add_child(_tale(c, f, opp, bout_day))
	row.add_child(_camp_card(main, c, f, bout_day))
	page.add_child(row)
	return page


## The sparring nights still free to test the plan (SparNights, less the ones a test used).
static func _spars(c: Career, f: Dictionary) -> Array:
	var bout: Dictionary = f.get("bout", {})
	return SparNights.unused(SparNights.nights(bout, c.day), bout.get("plan_test_nights", []))


## The next step, and the one filled button that takes it: [label, act, arg].
static func next_step(c: Career, f: Dictionary) -> Array:
	var fb: Dictionary = f.get("bout", {})
	var camp: Dictionary = f.get("camp", {})
	var opp: Dictionary = fb.get("opp", {})
	var days := int(fb.get("day", c.day)) - c.day
	if Bouts.weigh_in_today(c, f):
		return ["Step on the scale", "weighin", str(f["id"])]
	if camp.is_empty() and days >= BoutRules.CAMP_MIN_DAYS:
		return ["Set the camp", "camp", str(f["id"])]
	if (f.get("arrows", []) as Array).is_empty():
		var sp := _spars(c, f)
		return ["Write the game plan" + (" before %s sparring" % Clock.fmt(int(sp[0])) if not sp.is_empty() else ""), "ptab", "1"]
	if bool(camp.get("film", false)) and OppFile.has_tape(opp) and not OppFile.hidden(opp).is_empty():
		return ["Watch the tape", "taperoom", str(f["id"])]
	return ["Check the week", "ftab", "3"]


static func _head(main: Node, c: Career, f: Dictionary, opp: Dictionary, bout_day: int) -> PanelContainer:
	var card := UI.card()
	card[0].name = "PrepHead"
	var h := UI.hbox(32)
	card[1].add_child(h)
	var who := UI.vbox(2)
	who.add_child(UI.display("VS %s" % str(opp.get("name", "the opponent")).to_upper(), 40))
	who.add_child(UI.label(str(opp.get("club", "")), 17, UI.MUTED, "body"))   # record and style are the tape's
	h.add_child(who)
	var days := bout_day - c.day
	var count := UI.vbox(0)
	count.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var big := UI.label("%d day%s" % [days, "" if days == 1 else "s"], 34, UI.FG, "bold")
	big.name = "Countdown"
	count.add_child(big)
	count.add_child(UI.label("to fight night, %s - weigh-in %s" % [Clock.fmt(bout_day), Clock.fmt(bout_day - 1)], 15, UI.MUTED, "body"))
	h.add_child(count)
	# S398 critics: the two numbers that can go wrong before the night, up here as chips (the details stay below)
	var chips := UI.vbox(6)
	chips.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var wf := Sim.weigh_forecast(c, f, bout_day)
	var spare := float(f["limit"]) - float(wf["day"])
	chips.add_child(UI.chip("Scale: %.1f kg %s" % [absf(spare), "to spare" if spare >= 0.0 else "over"], "red" if not bool(wf["ok"]) else ("amber" if spare < SCALE_MARGIN else "green")))
	for ln in WeekBoard.plan_of(c, f)["lines"]:
		var id := str(ln.get("id", ""))
		if (f.get("stats", {}) as Dictionary).has(id) and ln.has("target"):
			chips.add_child(UI.chip("%s %.1f of %d on the night" % [str(Data.LABEL.get(id, id)), float(ln["end"]), roundi(float(ln["target"]))], "green" if bool(ln.get("ok", false)) else "amber"))
	h.add_child(chips)
	h.add_child(UI.spacer())
	var step := next_step(c, f)
	var b := UI.button(str(step[0]), "BtnSolid", main.act.bind(str(step[1]), str(step[2])))
	b.name = "PrepNext"
	b.custom_minimum_size = Vector2(240, 48)
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(b)
	return card[0]


static func tape_rows(f: Dictionary, opp: Dictionary, her_cm: float = 0.0) -> Array:
	return TapeRows.rows(f, opp, her_cm)


## The tale of the tape, the same rows and the same drawing as the versus card. Fight night is not one click away
## while the camp is on, so the numbers stay on this page. The win chance sits under them.
static func _tale(c: Career, f: Dictionary, opp: Dictionary, bout_day: int) -> PanelContainer:
	var card := UI.card("THE TALE OF THE TAPE")
	card[0].name = "PrepTale"
	card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for r in tape_rows(f, opp, Faces.cm(Faces.stem(f))):
		var row: Dictionary = r
		VersusPanel.draw_fact(card[1], row, str(row["label"]).to_upper())
	# S434 fight night's Tank (her forecast, the Training tab's number), not today's tiredness
	var b := BoutRead.band(CampForecast.for_read(c, f, opp), opp, BoutRead.camp_for(f, bout_day - c.day), c.seed, float(c.coach.get("rating", 0.0)))
	var lo := roundi(float(b["lo"]) * 100.0)
	var hi := roundi(float(b["hi"]) * 100.0)
	var mid := roundi((lo + hi) / 2.0)
	var sure := "a rough guess" if hi - lo >= 30 else ("fairly sure" if hi - lo >= 12 else "sure")
	var wc := UI.label("Win chance about %d%% (%s: %d to %d%%) - scouting narrows it" % [mid, sure, lo, hi], 16, UI.FG, "semi", true)
	wc.name = "PrepChance"
	card[1].add_child(wc)
	return card[0]


## CAMP AND WEIGHT: the goal attribute's line to fight night and the scale (amber under SCALE_MARGIN kg to spare).
static func _camp_card(main: Node, c: Career, f: Dictionary, bout_day: int) -> PanelContainer:
	var card := UI.card("CAMP AND WEIGHT")
	card[0].name = "PrepCamp"
	card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v: VBoxContainer = card[1]
	var camp: Dictionary = f.get("camp", {})
	if camp.is_empty():
		v.add_child(UI.label("No camp yet: until one is set the weeks run the base plan.", 16, UI.FG, "body", true))
	var rows: Array = []
	for ln in WeekBoard.plan_of(c, f)["lines"]:
		var id := str(ln.get("id", ""))
		if not (f.get("stats", {}) as Dictionary).has(id) or not ln.has("target"):
			continue
		rows.append(UI.kv(str(Data.LABEL.get(id, str(ln.get("label", id)))), "%.1f now -> %.1f on fight night, target %d" % [float(ln["now"]), float(ln["end"]), roundi(float(ln["target"]))],
			UI.GREEN if bool(ln.get("ok", false)) else UI.AMBER))
	var wf := Sim.weigh_forecast(c, f, bout_day)
	var spare := float(f["limit"]) - float(wf["day"])
	rows.append(UI.kv("On the scale", "%.1f now -> %.1f on the morning, limit %.1f%s" % [float(wf["now"]), float(wf["day"]), float(f["limit"]),
		" (%.1f kg to spare)" % spare if spare >= 0.0 else " (%.1f kg over)" % -spare], UI.RED if not bool(wf["ok"]) else (UI.AMBER if spare < SCALE_MARGIN else UI.GREEN)))
	UI.add_rows(v, rows)
	var week := UI.button("Change the week", "Link", main.act.bind("ftab", "3"))
	week.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(week)
	return card[0]
