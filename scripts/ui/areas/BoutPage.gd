extends VBoxContainer
## One bout offer: the tale of the tape, the opponent report, the terms, accept or decline. An unsafe mismatch shows why
## the federation would not sanction it, and cannot be accepted.

const UI := preload("res://scripts/ui/UI.gd")
const Tape := preload("res://scripts/ui/Tape.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")


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
	add_child(UI.muted("FIGHTS / Offers / %s vs %s" % [f["name"], opp["name"]], UI.SMALL))
	var head := UI.hbox(16)
	head.add_child(UI.display("THE BOUT", 52))
	head.add_child(UI.chip("Not safe" if bool(o["mismatch"]) else "Legal, even match", "red" if bool(o["mismatch"]) else "green"))
	add_child(head)
	add_child(Tape.make(f["name"], "your fighter", [
		["Record", "%d-%d AM" % [f["w"], f["l"]]], ["Age, stance", "%d, %s" % [f["age"], f["stance"]]], ["Style", f["style"]],
	], opp["name"], opp["club"], [
		["Record", "%d-%d AM" % [opp["w"], opp["l"]]], ["Age, stance", "%d, %s" % [opp["age"], opp["stance"]]], ["Style", opp["style"]],
	]))
	var grid := UI.hbox(16)
	add_child(grid)
	var report := UI.card("OPPONENT REPORT")
	UI.add_rows(report[1], [UI.kv("Biggest threat", opp["threat"]), UI.kv("Weakness", opp["weak"]),
		UI.kv("Film on her", "2 bouts, depth %d of 3" % BoutRules.FILM_DEPTH_DEFAULT)])
	report[1].add_child(UI.muted("A camp with film study raises the depth to 3.", UI.SMALL, true))
	grid.add_child(report[0])
	var weeks := int((int(o["day"]) - c.day) / 7.0)
	var terms := UI.card("TERMS")
	UI.add_rows(terms[1], [
		UI.kv("Date", "%s, 3 x 3 min" % Clock.fmt(int(o["day"]))),
		UI.kv("Weight", "%.1f kg" % f["limit"], UI.FG, "mono"),
		UI.kv("Purse", "none, amateur"),
		UI.kv("Club ticket cut", UI.money(BoutRules.TICKET_CUT), UI.GREEN, "mono"),
		UI.kv("Time for a camp", "yes, %d weeks" % weeks if weeks >= 1 else "no"),
		UI.kv("Answer by", Clock.fmt(int(o["expires"]))),
	])
	grid.add_child(terms[0])
	for child in grid.get_children():
		(child as Control).size_flags_vertical = Control.SIZE_FILL
	var foot := UI.hbox(10)
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
	var decline := UI.button("Decline", "BtnQuiet", main.act.bind("declineOffer", offer_id), not open, decline_why)
	decline.name = "Decline"
	foot.add_child(decline)
	if bool(o["mismatch"]):
		var why := UI.muted("The federation would not sanction it: a novice (%d bouts) may not meet an open fighter (%d bouts; novice ends at %d)." % [
			int(o["own_bouts"]), int(o["their_bouts"]), AmateurBooking.NOVICE_MAX_BOUTS], UI.SMALL, true)
		why.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		foot.add_child(why)
	elif not open:
		foot.add_child(UI.muted("Answered.", UI.SMALL))
	add_child(foot)
