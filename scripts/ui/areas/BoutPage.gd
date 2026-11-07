extends VBoxContainer
## One bout offer: the tale of the tape, the opponent report, the terms, accept or decline. An unsafe mismatch shows why
## the federation would not sanction it, and cannot be accepted.

const UI := preload("res://scripts/ui/UI.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Tape := preload("res://scripts/ui/Tape.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const OppFileCard := preload("res://scripts/ui/OppFileCard.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutCompare := preload("res://scripts/ui/BoutCompare.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")


func build(main: Node, offer_id: String) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	var fo := Bouts.find_offer(c, offer_id)
	var f: Dictionary = fo[0]
	var o: Dictionary = fo[1]
	if o.is_empty() or f.is_empty():
		var gone := UI.card()
		gone[1].add_child(UI.muted("That offer is gone.", UI.BODY))
		add_child(gone[0])
		return
	var opp: Dictionary = o["opp"]
	# S387 once accepted the file fills on the bout's own copy (Bouts.accept, tape_days): read that one.
	var booked: Dictionary = (f["bout"] as Dictionary).get("opp", {})
	if bool(o["accepted"]) and str(booked.get("name", "")) == str(opp["name"]):
		opp = booked
	add_child(UI.muted("FIGHTS / Offers / %s vs %s" % [f["name"], opp["name"]], UI.SMALL))
	# S373 the weigh-in forecast: her weight now and on the scale after a camp cut from tomorrow (Sim.weigh_forecast).
	var wf := Sim.weigh_forecast(c, f, int(o["day"]))
	var head := UI.hbox(16)
	head.add_child(UI.display("THE BOUT", 52))
	# S398 menus (first-hour critics: "Legal, even match" stayed green while the weight missed): the chip says the worst.
	var chip := UI.chip("Not safe" if bool(o["mismatch"]) else ("Weight at risk" if not bool(wf["ok"]) else "Legal, even match"),
		"red" if bool(o["mismatch"]) else ("amber" if not bool(wf["ok"]) else "green"))
	chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(chip)
	head.add_child(UI.spacer())
	add_child(head)
	add_child(Tape.make(f["name"], "your fighter", [
		["Record", "%d-%d amateur" % [f["w"], f["l"]]], ["Age, stance", "%d, %s" % [f["age"], f["stance"]]], ["Style", f["style"]],
	], opp["name"], opp["club"], [
		["Record", "%d-%d amateur" % [opp["w"], opp["l"]]], ["Age, stance", "%d, %s" % [opp["age"], opp["stance"]]], ["Style", opp["style"]],
	], Faces.pair(f, opp)))
	# S387 MENUBOUT the decision on one screen, Accept included: the stats against the estimate, the win band and the ranks
	# at stake (BoutCompare, BoutRead), the file they rest on, then the terms.
	var compare := UI.hbox(16)
	compare.name = "BoutCompare"
	compare.add_child(BoutCompare.stats_card(f, opp, c.seed))
	compare.add_child(BoutCompare.read_card(c, f, opp, BoutRead.camp_for(f, int(o["day"]) - c.day)))
	add_child(compare)
	# S341 scouting in stages: her threat and weakness are no longer handed over - they are in her file, found on tape.
	var report := UI.card("SCOUTING")
	report[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	report[0].size_flags_stretch_ratio = 3.0
	report[1].add_child(OppFileCard.build(opp, false, OppFileCard.OppFile.history(c.results, str(opp["name"]))))
	compare.add_child(report[0])
	var weeks := int((int(o["day"]) - c.day) / 7.0)
	var terms := UI.card("TERMS")
	var cols := UI.hbox(32)
	terms[1].add_child(cols)
	var left := UI.vbox(0)
	var right := UI.vbox(0)
	for col in [left, right]:
		(col as Control).size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cols.add_child(col)
	UI.add_rows(left, [
		UI.kv("Date", "%s, 3 x 3 min" % Clock.fmt(int(o["day"]))),
		UI.kv("Weight", "%.1f kg" % f["limit"], UI.FG, "mono"),
		UI.kv("On the scale", "%.1f now, %.1f on the day" % [float(wf["now"]), float(wf["day"])], UI.GREEN if bool(wf["ok"]) else UI.RED, "mono"),
		UI.kv("Time for a camp", "yes, %d weeks" % weeks if weeks >= 1 else "no"),
	])
	UI.add_rows(right, [
		UI.kv("Purse", "none, amateur"),
		UI.kv("Club ticket cut", UI.money(BoutRules.TICKET_CUT), UI.GREEN, "mono"),
		UI.kv("Answer by", Clock.fmt(int(o["expires"]))),
	])
	add_child(terms[0])
	var foot := UI.hbox(10)
	foot.name = "BoutFoot"
	var open := not bool(o["answered"])
	var accept_off := bool(o["mismatch"]) or not open
	var accept_why := ""
	if bool(o["mismatch"]):
		accept_why = "The federation would not sanction it: a novice (%d bouts) may not meet an open fighter (%d bouts)." % [
			int(o["own_bouts"]), int(o["their_bouts"])]
	elif not open:
		accept_why = "You already answered this offer - pick another from Fights"
	var accept := UI.button("Accept the bout", "BtnSolid", main.act.bind("accept", offer_id), accept_off, accept_why)
	accept.name = "Accept"
	foot.add_child(accept)
	var decline_why := "You already answered this offer - pick another from Fights" if not open else ""
	var decline := UI.button("Pass", "BtnQuiet", main.act.bind("declineOffer", offer_id), not open, decline_why)
	decline.name = "Pass"
	foot.add_child(decline)
	if bool(o["mismatch"]):
		var why := UI.muted("The federation would not sanction it: a novice (%d bouts) may not meet an open fighter (%d bouts; novice ends at %d)." % [
			int(o["own_bouts"]), int(o["their_bouts"]), AmateurBooking.NOVICE_MAX_BOUTS], UI.SMALL, true)
		why.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		foot.add_child(why)
	elif not open:
		foot.add_child(UI.muted("Answered.", UI.SMALL))
	elif not bool(wf["ok"]):
		var heavy := UI.label("%s would come in %.1f kg over even cutting from tomorrow. Missing weight calls the bout off and the club pays %s for the empty slot." % [
			f["first"], float(wf["over"]), UI.money(BoutRules.MISSED_WEIGHT_COST)], UI.SMALL, UI.RED, "body", true)
		heavy.name = "WeightWarn"
		heavy.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		heavy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		foot.add_child(heavy)
	# S398 menus (first-hour critics: Accept sat below the fold at 1080): the decision sits on the title line; the reason
	# lines (weight, sanction) stay under the terms.
	for n in foot.get_children():
		if n is Button:
			foot.remove_child(n)
			(n as Control).size_flags_vertical = Control.SIZE_SHRINK_CENTER
			head.add_child(n)
	if foot.get_child_count() > 0:
		add_child(foot)
