extends RefCounted
## The Game plan's ROUNDS and GO-TO rows (moved out of GamePlan in S397 to keep it under 500 lines). `gp` is the GamePlan:
## its fighter (gp.f), booked bout (gp._bout()) and redraw (gp._refresh()).
##   GamePlanRows.rounds(gp) -> Control   GamePlanRows.go_to(gp) -> Control

const UI := preload("res://scripts/ui/UI.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")


## S375 SCOUTPLAN1 the ROUND row: the pace each round opens on (push / steady / save; none picked = steady),
## with what the file says about the rounds.
static func rounds(gp) -> Control:
	var f: Dictionary = gp.f
	var box := UI.vbox(4)
	box.name = "PlanRounds"
	var row := UI.hbox(8)
	row.add_child(UI.caps("ROUNDS"))
	var n_rounds := int(gp._bout().get("rounds", BoutRules.ROUNDS)) if not gp._bout().is_empty() else BoutRules.ROUNDS
	for n in range(1, n_rounds + 1):
		var nn: int = n
		row.add_child(UI.label("R%d" % nn, UI.SMALL, UI.FG, "bold"))
		var now := PlanFile.pace_for(f, nn)
		var shown := now if now != "" else "steady"   # S397 blind round 4: none picked is steady, so Steady shows as picked
		for pace in PlanFile.PACES:
			var pp := str(pace)
			var b := UI.button(pp.capitalize(), "PillOn" if pp == shown else "Pill", func():
				f["round_pace"] = PlanFile.set_pace(f.get("round_pace", []), nn, "" if pp == now else pp)
				gp._refresh())
			b.name = "Pace_%d_%s" % [nn, pp]
			row.add_child(b)
	box.add_child(row)
	var hints := PlanFile.round_hints(gp._bout()["opp"]) if not gp._bout().is_empty() else {}
	for k in hints:
		var h: Array = hints[k]
		var done := PlanFile.pace_for(f, int(k)) == str(h[0])
		box.add_child(UI.label(("Done: " if done else "") + str(h[1]), UI.TINY, UI.GREEN if done else UI.GOLD, "body", true))
	if hints.is_empty():
		box.add_child(UI.muted("Push throws more and tires the fighter faster; Save gets the breath back. The tape on the opponent tells you when to push.", UI.TINY, true))
	return box


## S378 PLANCOMBO1 the GO-TO row: one of his own drilled combinations named on the card (f["plan_combo"]). In the bout it
## decides OwnCombos.NAMED_SHARE of his combination exchanges instead of USE_SHARE while he still throws it whole, and the
## ring throws it more often; the rounds it holds whole are the trade. A second click clears it.
static func go_to(gp) -> Control:
	var f: Dictionary = gp.f
	var box := UI.vbox(4)
	box.name = "PlanGoTo"
	var row := UI.hbox(8)
	row.add_child(UI.caps("GO-TO COMBINATION"))
	var named := OwnCombos.named(f)
	var go_id := str(named.get("id", ""))
	var any := false
	for e in OwnCombos.entries(f):
		if not OwnCombos.usable(f, e):
			continue
		any = true
		var id := str(e["id"])
		var words := str(e["name"]).capitalize() + ("  (signature)" if OwnCombos.signature(f, e) else "")
		var b := UI.button(words, "PillOn" if id == go_id else "Pill", func():
			f["plan_combo"] = "" if id == go_id else id
			gp._refresh())
		b.name = "GoTo_" + id.replace(":", "_")
		row.add_child(b)
	box.add_child(row)
	if not any:
		box.add_child(UI.muted("None of your boxer's own combinations is drilled yet (book ones like the 1-2 are thrown as they come). Build one under Combos and put it on the pads.", UI.TINY, true))
		return box
	var share := "%d%% of the combination exchanges instead of %d%%" % [roundi(100.0 * OwnCombos.NAMED_SHARE), roundi(100.0 * OwnCombos.USE_SHARE)]
	if named.is_empty():
		box.add_child(UI.muted("Name one and your boxer reaches for it far more often, while the legs can still throw it whole.", UI.TINY, true))
		return box
	var per_round: Array = []
	var whole := OwnCombos.whole_by_round(f, named)
	for i in whole.size():
		per_round.append("R%d %s" % [i + 1, "whole" if bool(whole[i]) else "too tired"])
	var col: Color = UI.GREEN if bool(whole[0]) else UI.RED
	var said := UI.label("Your boxer reaches for it far more often while it is thrown whole:  %s" % "  ·  ".join(per_round), UI.TINY, col, "body", true)
	said.name = "GoToRounds"
	said.mouse_filter = Control.MOUSE_FILTER_PASS
	said.tooltip_text = "It decides %s." % share   # S397: the number on hover, words on the card
	box.add_child(said)
	return box
