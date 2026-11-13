extends RefCounted
## The Game plan's ROUNDS and GO-TO rows (moved out of GamePlan in S397 to keep it under 500 lines). `gp` is the GamePlan:
## its fighter (gp.f), booked bout (gp._bout()) and redraw (gp._refresh()).
##   GamePlanRows.rounds(gp) -> Control   GamePlanRows.go_to(gp) -> Control   phase_tag(gp, row, i)   last_round(gp, f, n)

const UI := preload("res://scripts/ui/UI.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const PlanPhase := preload("res://scripts/rules/PlanPhase.gd")

const PHASE_NEXT := {"all": "early", "early": "middle", "middle": "late", "late": "all"}
const PHASE_TIP := "Which rounds this line is fought in. Click to change: all rounds, early, middle, late. Outside its rounds your boxer improvises there."


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
	box.add_child(last_round(gp, f, n_rounds))
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


## S460 INTEGRATE1 #3 (PlanPhase): the line's rounds as a pill ("All rounds", "R1", "R2", "R3"); a click moves it on
## all -> early -> middle -> late. The ring fights the line only in those rounds (PlanFile.arrows_for), the forecast too.
static func phase_tag(gp, row: Control, i: int) -> void:
	var arrows: Array = (gp.arrows as Array).duplicate(true)
	var n_rounds := int(gp._bout().get("rounds", BoutRules.ROUNDS)) if not gp._bout().is_empty() else BoutRules.ROUNDS
	var now := str((arrows[i] as Dictionary).get("rounds", "all"))
	var b := UI.button(PlanPhase.words(arrows[i], n_rounds), "PillOn" if now != "all" else "Pill", func():
		arrows[i]["rounds"] = str(PHASE_NEXT.get(now, "all"))
		if str(arrows[i]["rounds"]) == "all":
			(arrows[i] as Dictionary).erase("rounds")
		gp._write(arrows)
		gp._refresh())
	b.name = "Phase_%d" % i
	b.tooltip_text = PHASE_TIP
	row.add_child(b)


## S460 INTEGRATE1 #3 (PlanPhase late states): the last round's pace by the score - "If ahead" and "If behind" (level counts
## as behind). Unset = the round's own pace above. The ring opens the last round on it (PlanFile.pace_for).
static func last_round(gp, f: Dictionary, n_rounds: int) -> Control:
	var row := UI.hbox(8)
	row.name = "PlanLastRound"
	row.add_child(UI.caps("R%d BY THE SCORE" % n_rounds))
	var late: Dictionary = f.get_or_add("late", {})
	for state in ["ahead", "behind"]:
		var st := str(state)
		row.add_child(UI.label("If %s" % st, UI.SMALL, UI.FG, "bold"))
		var now := str((late.get(st, {}) as Dictionary).get("pace", ""))
		for pace in PlanFile.PACES:
			var pp := str(pace)
			var b := UI.button(pp.capitalize(), "PillOn" if pp == now else "Pill", func():
				var d: Dictionary = late.get_or_add(st, {})
				d["pace"] = "" if pp == now else pp
				gp._refresh())
			b.name = "Late_%s_%s" % [st, pp]
			b.tooltip_text = "The last round opens on this pace when your boxer is %s on the rounds so far (level counts as behind)." % st
			row.add_child(b)
	return row
