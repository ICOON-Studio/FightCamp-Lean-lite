extends PanelContainer
## SET CAMP (S381 G2: the weeks strip to fight night top right, WeekStrip). S379 CAMPCARDS (operator on docs/mockups/fight_camp_cards.png: "looks ok, build it in the game"): the fighter
## on the left (CampSide: face, record, the six stats with the camp's stat and its fight-night forecast, S382 G4 the gauge
## row LEGS / SCALE / RISK);
## five camp cards on the right, one per BoutRules.CAMP_FOCUSES (CampCard: the station picture, "<Stat> ++", now -> fight
## night); the protocol row (nights a week and the edge on the night; its legs and injury on the hover), the Partner card (S381 C229
## stage 3, CampMatch: club mates or the outside mate) and film under them; one summary line and Later / Start in the
## footer. The picks go through BoutActs as before (cfocus / cproto / cfilm / cpartner / startcamp,
## Bouts.start_camp writes the camp); the forecasts are CampForecast's dry run of the real training days. A pick redraws
## the modal and every number that changed counts on from what was shown (operator: animated meters).
## S382 G5 (gym idea 2, hover ghosts): hovering a focus card, a protocol, the Partner card or Film ghosts that pick's dry run
## on the gauge row (GaugeRow.preview: ghost needles and +N / -N in GHOST_S); the click commits, no confirm.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")
const CampCard := preload("res://scripts/ui/CampCard.gd")
const CampSide := preload("res://scripts/ui/CampSide.gd")
const CampMatch := preload("res://scripts/ui/CampMatch.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const TrainingLoad := preload("res://scripts/rules/TrainingLoad.gd")
const FilmEdge := preload("res://scripts/rules/FilmEdge.gd")
const WeekStrip := preload("res://scripts/ui/WeekStrip.gd")
const GaugeRow := preload("res://scripts/ui/GaugeRow.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

const W := 1620.0
const OPTION_H := 132.0
const KICKER := UI.MUTED   # S419: a paper ink the slate pass turns to chalk (it was a fixed dark blue, unreadable on slate)

## The modal dict the last draw showed and its numbers: a pick redraws with the same dict, a new SET CAMP opens a new one.
static var _last_m: Dictionary = {}
static var _shown: Dictionary = {}


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(W, 0)
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var opp: Dictionary = f["bout"]["opp"]
	var focus := str(m["focus"])
	var proto := int(m["protocol"])
	var film := bool(m["film"])
	var partner := bool(m.get("partner", false))
	var fc := CampForecast.all(c, f, proto, film)
	var mine: Dictionary = fc[focus] if fc.has(focus) else CampForecast.run(c, f, focus, proto, film)
	var before: Dictionary = _shown if is_same(m, _last_m) else {}
	_last_m = m
	var v := UI.vbox(0)
	add_child(v)
	var top := UI.hbox(24)   # S381 G2: the title on the left, the weeks strip to fight night on the right
	v.add_child(top)
	var head := UI.vbox(0)
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(head)
	var bout_day := int(f["bout"]["day"])
	head.add_child(UI.label("%s VS %s, %s" % [str(f["name"]).to_upper(), str(opp["name"]).to_upper(), Clock.fmt(bout_day).to_upper()],
		15, KICKER, "caps"))
	head.add_child(UI.display("FIGHT CAMP", 46))
	# S382 G4: the cut to the limit is the SCALE dial's (the gauge row), no longer said here
	head.add_child(UI.label("%d days to fight night. Pick what the camp builds." % int(mine["days"]), 19, CampCard.SUB, "body", true))
	top.add_child(WeekStrip.make(f, opp, bout_day, c.day, int((f.get("camp", {}) as Dictionary).get("start", c.day)), focus, film,
		-1, proto))   # S382 EVENINGS1 review: a week's peek shows the picked protocol's nights (CampForecast runs proto too)
	_gap(v, 16)
	var grid := UI.hbox(34)
	v.add_child(grid)
	var side := CampSide.make(f, focus, mine, before, c.day)
	grid.add_child(side)
	var right := UI.vbox(0)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(right)
	right.add_child(UI.label("WHAT THE CAMP BUILDS", 14, KICKER, "caps"))
	_gap(right, 10)
	var cards := UI.hbox(16)
	cards.name = "Cards"
	right.add_child(cards)
	var ends := {}
	var was: Dictionary = before.get("cards", {})
	for key in BoutRules.CAMP_FOCUSES:
		var now := float(f["stats"].get(key, 0.0))
		var end := float((fc[key]["stats"] as Dictionary).get(key, now))
		ends[key] = end
		cards.add_child(CampCard.card(main, f, key, key == focus, now, end, float(was.get(key, now)),
			str(before.get("focus", "")) != focus))
	_gap(right, 22)
	right.add_child(_options(main, c, f, opp, focus, proto, film, partner, mine))
	_gap(v, 26)
	var rule := ColorRect.new()   # 2 px: a 1-px line can vanish when the window scales the frame down
	rule.color = UI.LINE
	rule.custom_minimum_size = Vector2(0, 2)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(rule)
	_gap(v, 18)
	var cost := BoutRules.camp_cost(proto, partner)
	v.add_child(_footer(main, f, opp, focus, proto, partner, int(mine["days"]), float(before.get("cost", cost))))
	var gauge := side.find_child("Gauges", true, false)
	_shown = {"cards": ends, "cost": cost, "focus": focus, "gauges": gauge.call("values")}
	_ghosts(c, f, opp, focus, proto, film, fc, mine, gauge)


## S382 G5: each pick but the current one ghosts its forecast on the gauge row while the cursor is on it (the dry run is
## run once, on the first hover). The Partner card changes who she spars, not the training days: its ghost reads "same".
func _ghosts(c: Career, f: Dictionary, opp: Dictionary, focus: String, proto: int, film: bool, fc: Dictionary, mine: Dictionary,
		gauge: Node) -> void:
	for key in BoutRules.CAMP_FOCUSES:
		if key != focus:
			_ghost(find_child("Focus_" + key, true, false), gauge, f, c.day, func() -> Dictionary: return fc[key])
	for i in [1, 2, 3]:
		if i != proto:
			_ghost(find_child("Protocol_%d" % i, true, false), gauge, f, c.day,
				func() -> Dictionary: return CampForecast.run(c, f, focus, i, film))
	_ghost(find_child("Partner", true, false), gauge, f, c.day, func() -> Dictionary: return mine)
	if OppFile.has_tape(opp):
		_ghost(find_child("Film", true, false), gauge, f, c.day, func() -> Dictionary: return CampForecast.run(c, f, focus, proto, not film))


static func _ghost(b: Control, gauge: Node, f: Dictionary, day: int, dry: Callable) -> void:
	if b == null or gauge == null:
		return
	var held: Array = []
	b.mouse_entered.connect(func() -> void:
		if held.is_empty():
			held.append(GaugeRow.read(dry.call(), f, day))
		gauge.call("preview", held[0]))
	b.mouse_exited.connect(func() -> void: gauge.call("preview_off"))


## Light / Standard / Hard (S381 C229 stage 2: no prices - the club's own nights are free) in nights a week and the edge on
## the night; S382 G4 their fight-night legs and injury risk moved to the gauge row (the picked one; the others ghost there
## on the hover, G5), so the Hard card's red risk line is gone. The film switch is free; it takes a Build-week pad night, so its
## forecast is in every number on the modal.
func _options(main: Node, c: Career, f: Dictionary, opp: Dictionary, focus: String, proto: int, film: bool, partner: bool,
		mine: Dictionary) -> HBoxContainer:
	var row := UI.hbox(14)
	row.name = "Protocols"
	for i in [1, 2, 3]:
		var p: Dictionary = BoutRules.PROTOCOLS[i]
		var line := str(p["blurb"])
		if str(p["level"]) == "hard":   # S381 C229: the dose as a coach says it - nights and hours against her usual
			line = "%s, %d h (usual %d)" % [line, int(round(TrainingLoad.hours("hard"))), int(round(Injuries.chronic(f)))]
		# BoutRules.night_edge: this number is added on fight night, not a bonus to every training gain.
		var b := CampCard.option("Protocol_%d" % i, str(p["name"]), line, "night bonus +%s" % _num(float(p["edge"])), CampCard.SUB,
			proto == i, main.act.bind("cproto", str(i)), OPTION_H)
		# S382 proof stills: no tooltip - the hover ghosts the legs and the risk on the gauge row (_ghosts); a tooltip said
		# the same numbers a second time over the row below
		row.add_child(b)
	var pc := CampMatch.partner_card(main, f, opp, partner, OPTION_H)   # S381 C229 stage 3: who plays her in sparring
	pc.size_flags_stretch_ratio = 1.6
	row.add_child(pc)
	row.add_child(_film_card(main, f, opp, film))
	for b in row.get_children():
		(b as Control).resized.connect(func() -> void: _fit.call_deferred(row))
		for k in (b as Node).get_children():
			if k is MarginContainer:
				(k as Control).minimum_size_changed.connect(func() -> void: _fit.call_deferred(row))
	return row


## S382 proof stills: a Button does not grow to its words, so the row takes its tallest card's words (the Film card's
## answered line ran past its frame): every card in the row gets the height the tallest needs at its laid-out width.
static func _fit(row: Variant) -> void:
	if not is_instance_valid(row):   # the modal redrew before the deferred call
		return
	var need := OPTION_H
	for b in row.get_children():
		for k in (b as Node).get_children():
			if k is MarginContainer:
				need = maxf(need, (k as Control).get_combined_minimum_size().y)
	for b in row.get_children():   # set, not only grown: a first pass at no width wraps every word onto its own line
		if absf((b as Control).custom_minimum_size.y - need) > 0.5:
			(b as Control).custom_minimum_size.y = need


## S381 C229 stage 4: film is earned - "N/M answered" (the found tells her Playbook plan or a drilled combination answers,
## FilmEdge) and what that is worth on the night; "no tape" for an opponent with no bouts on her record.
func _film_card(main: Node, f: Dictionary, opp: Dictionary, film: bool) -> Button:
	var s := FilmEdge.summary(f)
	var tape := bool(s["tape"])
	var head := "Film on %s: %s" % [opp["name"], ("yes, free" if film else "no") if tape else "no tape"]
	var line := "phone video - 1 pad night - answer the tells in the Playbook" if tape else "no video of any bout - nothing to study"
	var risk := "%d/%d answered - +%s on the night" % [int(s["n"]), int(s["of"]), _num(float(s["edge"]))] if tape else ""
	var fb := CampCard.option("Film", head, line, risk, UI.GREEN if int(s["n"]) > 0 else CampCard.SUB, film and tape,
		main.act.bind("cfilm", ""), OPTION_H)
	fb.size_flags_stretch_ratio = 1.5
	return fb


## 0.25 -> "0.25", 0.6 -> "0.6", 1.0 -> "1.0": the design values as written.
static func _num(x: float) -> String:
	return "%.1f" % x if is_equal_approx(snappedf(x, 0.1), x) else "%.2f" % x


## "Power camp, Standard, southpaw mate - 25 days - $160 (partner)" (S381 C229 stage 2: the outside sparring partner is the
## only camp cash; "club mates - free (the club's own nights)" without one) and Later / Start the camp, $<cost>.
func _footer(main: Node, f: Dictionary, opp: Dictionary, focus: String, proto: int, partner: bool, days: int, cost_was: float) -> HBoxContainer:
	var foot := UI.hbox(12)
	foot.name = "Footer"
	var cost := BoutRules.camp_cost(proto, partner)
	var head := "%s camp, %s, %s - %d days - " % [Data.LABEL[focus], BoutRules.PROTOCOLS[proto]["name"],
		BoutRules.partner_word(opp) if partner else "club mates", days]
	var sum := UI.label("", 27, UI.FG, "handbold")
	sum.name = "Summary"
	CampCard.count(sum, cost_was, cost, func(x: float) -> String: return head + _money(x))
	foot.add_child(sum)
	var why := "partner" if partner else "the club's own nights"
	var parts := UI.label("(%s)" % why, 21, UI.MUTED, "hand")
	parts.name = "SummaryParts"
	parts.size_flags_vertical = Control.SIZE_SHRINK_END
	foot.add_child(parts)
	if not is_equal_approx(cost_was, float(cost)):
		CampCard.pulse(sum)
	foot.add_child(UI.spacer())
	var later := UI.button("Later", "BtnQuiet", main.act.bind("close", ""))
	later.name = "Later"
	foot.add_child(_big(later))
	var start := UI.button("", "BtnSolid", main.act.bind("startcamp", ""))
	start.name = "StartCamp"
	start.tooltip_text = "%s's camp starts today: %s" % [f["first"], why]
	CampCard.count(start, cost_was, cost, func(x: float) -> String:
		return "Start the camp" + (", " + UI.money(int(round(x))) if int(round(x)) > 0 else ""))
	foot.add_child(_big(start))
	return foot


static func _money(x: float) -> String:
	var n := int(round(x))
	return UI.money(n) if n > 0 else "free"


static func _big(b: Button) -> Button:
	b.add_theme_font_size_override("font_size", 18)
	b.custom_minimum_size = Vector2(0, 48)
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return b


static func _gap(box: Container, h: int) -> void:
	var g := Control.new()
	g.custom_minimum_size = Vector2(0, h)
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(g)
