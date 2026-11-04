extends PanelContainer
## SET CAMP. S379 CAMPCARDS (operator on docs/mockups/fight_camp_cards.png: "looks ok, build it in the game"): the fighter
## on the left (CampSide: face, record, the six stats with the camp's stat and its fight-night forecast, fatigue, weight);
## five camp cards on the right, one per BoutRules.CAMP_FOCUSES (CampCard: the station picture, "<Stat> ++", now -> fight
## night); the protocol row (cost, the training load it sets, the edge on the night) and film study under them; one summary
## line and Later / Start in the footer. The picks go through BoutActs as before (cfocus / cproto / cfilm / startcamp,
## Bouts.start_camp writes the camp); the forecasts are CampForecast's dry run of the real training days. A pick redraws
## the modal and every number that changed counts on from what was shown (operator: animated meters).

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")
const CampCard := preload("res://scripts/ui/CampCard.gd")
const CampSide := preload("res://scripts/ui/CampSide.gd")
const WB := preload("res://scripts/ui/WhiteboardKit.gd")

const W := 1620.0
const OPTION_H := 112.0
const KICKER := Color("#3b4250")

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
	var fc := CampForecast.all(c, f, proto)
	var mine: Dictionary = fc[focus] if fc.has(focus) else CampForecast.run(c, f, focus, proto)
	var before: Dictionary = _shown if is_same(m, _last_m) else {}
	_last_m = m
	var v := UI.vbox(0)
	add_child(v)
	v.add_child(UI.label("%s VS %s, %s" % [str(f["name"]).to_upper(), str(opp["name"]).to_upper(), Clock.fmt(int(f["bout"]["day"])).to_upper()],
		15, KICKER, "caps"))
	v.add_child(UI.display("FIGHT CAMP", 46))
	v.add_child(UI.label("%d days to fight night. Pick what the camp builds - it also cuts %s to %.1f kg (%.1f kg now)." % [
		int(mine["days"]), f["first"], f["limit"], f["weight"]], 19, CampCard.SUB, "body", true))
	_gap(v, 16)
	var grid := UI.hbox(34)
	v.add_child(grid)
	grid.add_child(CampSide.make(f, focus, mine, before))
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
	right.add_child(_options(main, c, f, opp, focus, proto, film, mine))
	_gap(v, 26)
	var rule := ColorRect.new()   # 2 px: a 1-px line can vanish when the window scales the frame down
	rule.color = UI.LINE
	rule.custom_minimum_size = Vector2(0, 2)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(rule)
	_gap(v, 18)
	var cost := BoutRules.camp_cost(proto, film)
	v.add_child(_footer(main, f, focus, proto, film, int(mine["days"]), float(before.get("cost", cost))))
	_shown = {"cards": ends, "peak": float(mine["peak"]), "kg": float(mine["kg"]), "cost": cost, "focus": focus,
		"band": str(WB.fatigue_word(float(mine["peak"]), false)[0])}


## Light / Standard / Hard (cost, S380 her fatigue on fight night - fresh or heavy legs - and the camp's injury risk from
## its own forecast, the edge on the night) and the film study switch.
func _options(main: Node, c: Career, f: Dictionary, opp: Dictionary, focus: String, proto: int, film: bool, mine: Dictionary) -> HBoxContainer:
	var row := UI.hbox(14)
	row.name = "Protocols"
	for i in [1, 2, 3]:
		var p: Dictionary = BoutRules.PROTOCOLS[i]
		var parts := str(p["blurb"]).split(", ")
		var fi: Dictionary = mine if i == proto else CampForecast.run(c, f, focus, i)
		var st := float(fi["stale"])
		var night := "fight night %d, %s" % [int(round(float(fi["fatigue_end"]))), "fresh" if st <= 0.0 else "heavy legs -%d energy" % int(round(st))]
		var inj := float(fi["injury"])
		var risk_col: Color = UI.RED if inj >= 0.08 else (UI.AMBER if st > 0.0 or inj >= 0.05 else CampCard.SUB)
		var b := CampCard.option("Protocol_%d" % i, str(p["name"]), " - ".join(parts.slice(0, 2)),
			"%s - injury %d%% - edge +%.1f" % [night, int(round(inj * 100.0)), float(p["edge"])], risk_col, proto == i,
			main.act.bind("cproto", str(i)), OPTION_H)
		row.add_child(b)
	var fb := CampCard.option("Film", "Film study on %s: %s" % [opp["name"], "yes, %s" % UI.money(BoutRules.FILM_COST) if film else "no"],
		"the opponent's past bouts in the tape room - answer them in the plan (click to switch)", "", CampCard.SUB, film,
		main.act.bind("cfilm", ""), OPTION_H)
	fb.size_flags_stretch_ratio = 1.25
	row.add_child(fb)
	return row


## "Conditioning camp, Standard - 25 days - $450 (camp $300 + film $150)" and Later / Start the camp, $<cost>.
func _footer(main: Node, f: Dictionary, focus: String, proto: int, film: bool, days: int, cost_was: float) -> HBoxContainer:
	var foot := UI.hbox(12)
	foot.name = "Footer"
	var camp_cost := int(BoutRules.PROTOCOLS[proto]["cost"])
	var cost := BoutRules.camp_cost(proto, film)
	var head := "%s camp, %s - %d days - " % [Data.LABEL[focus], BoutRules.PROTOCOLS[proto]["name"], days]
	var sum := UI.label("", 27, UI.FG, "handbold")
	sum.name = "Summary"
	CampCard.count(sum, cost_was, cost, func(x: float) -> String: return head + _money(x))
	foot.add_child(sum)
	var why := "camp %s" % (UI.money(camp_cost) if camp_cost > 0 else "free")
	why += (" + film %s" % UI.money(BoutRules.FILM_COST)) if film else ", no film study"
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
