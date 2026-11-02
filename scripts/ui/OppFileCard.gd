extends RefCounted
## S341 HER FILE (OppFile): what the coach knows of the opponent, what is still hidden and how to find it. One builder for
## the bout offer, the fighter's Camp tab and fight night. A found tell shows its answer (the counter) in green.
## S341: `history` (OppFile.history of Career.results) adds WITH US - every bout our gym has had with her.
## S342 trim (operator S341: "trim the text walls, use modals/tooltips and smarter use of space (icons)"): one icon row a
## tell, its answer behind a green check (tooltip); a hidden tell is a lock; HER RECORD is a row of W/L chips, each bout in
## its chip's tooltip; WITH US one line. What she IS stays on screen (J52: vital-to-act never only in a tooltip).
##   build(opp, film_bought, history) -> VBoxContainer   hint(opp) -> String

const UI := preload("res://scripts/ui/UI.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const RECORD_ROWS := 12

const HOW := {"tape": "tape study in camp finds it"}
## The icon a tell's row carries, by the first part of its id.
const KIND_ICON := {"look": "user", "style": "footprints", "weapon": "hand-fist", "habit": "refresh-cw", "weakness": "trending-down"}


## film_bought: her camp has tape study (the hidden rows say it is coming, not how to get it).
static func build(opp: Dictionary, film_bought := false, history: Array = []) -> VBoxContainer:
	var box := UI.vbox(6)
	var found := OppFile.found(opp).size()
	var all := found + OppFile.hidden(opp).size()
	var head := UI.hbox(10)
	head.add_child(UI.caps("HER FILE"))
	var tip := "%d of %d found." % [found, all]
	if hint(opp) != "":
		tip += "\n" + hint(opp)
	head.add_child(Icons.pips(found, all, tip))
	box.add_child(head)
	for t in OppFile.tells(opp):
		box.add_child(_tell_row(opp, t, film_bought))
	var past := RivalPast.shown(opp, RECORD_ROWS)
	if not past.is_empty():
		box.add_child(_record(opp, past))
	if not history.is_empty():
		box.add_child(_with_us(history))
	return box


## One line: icon, what, value; a found answer is a green check, a hidden tell a lock (how to find it on hover).
static func _tell_row(opp: Dictionary, t: Dictionary, film_bought: bool) -> HBoxContainer:
	var id := str(t["id"])
	var kind := id.get_slice(":", 0)
	var row := UI.hbox(8)
	var known := OppFile.known(opp, id)
	row.add_child(Icons.icon(str(KIND_ICON.get(kind, "info")), 18, UI.FG if known else UI.MUTED, str(t["what"])))
	var what := UI.label(str(t["what"]), UI.SMALL, UI.MUTED if not known else UI.FG)
	what.custom_minimum_size.x = 120
	row.add_child(what)
	if known:
		var value := UI.label(str(t["value"]), UI.SMALL, UI.FG, "bold", true)
		value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(value)
		if str(t["counter"]) != "" and str(t["how"]) != "booking":
			row.add_child(Icons.icon("circle-check", 18, UI.GREEN, "Answer: " + str(t["counter"])))
	else:
		var how := "on tape in this camp" if film_bought else str(HOW.get(str(t["how"]), "the fight shows it"))
		how = how[0].to_upper() + how.substr(1) + "."
		var q := UI.label("?", UI.SMALL, UI.MUTED, "bold")
		q.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(q)
		row.add_child(Icons.icon("lock", 16, UI.MUTED, how))
	return row


## HER RECORD 4-2 and one chip a bout, newest left; a bout against our gym is blue. "+n" for older bouts.
static func _record(opp: Dictionary, past: Array) -> HBoxContainer:
	var row := UI.hbox(4)
	var cap := UI.caps("HER RECORD %d-%d" % [int(opp.get("w", 0)), int(opp.get("l", 0))])
	cap.custom_minimum_size.x = 156
	row.add_child(cap)
	for b in past:
		var draw := str(b["how"]) == "a draw"
		var letter := "D" if draw else ("W" if bool(b["win"]) else "L")
		var colour := "gold" if bool(b.get("ours", false)) else ("" if draw else ("green" if bool(b["win"]) else "red"))
		var verb := "Drew with" if draw else ("Beat" if bool(b["win"]) else "Lost to")
		var chip := UI.chip(letter, colour)
		row.add_child(Icons.tip(chip, "%s %s (%s)\n%s, %s" % [verb, b["vs"], b["vs_club"], b["how"], Clock.fmt(int(b["d"]))]))
	var more := (opp.get("bouts", []) as Array).size() - past.size()
	if more > 0:
		row.add_child(UI.muted("+%d" % more, UI.TINY))
	return row


## WITH US on one line: who met her and the result; the date and cards on hover.
static func _with_us(history: Array) -> HBoxContainer:
	var row := UI.hbox(8)
	var cap := UI.caps("WITH US")
	cap.custom_minimum_size.x = 156
	row.add_child(cap)
	for r in history:
		var res := "drew" if str(r.get("outcome", "")) == "draw" else ("won" if bool(r["win"]) else "lost")
		var l := UI.label("%s %s" % [r["who"], res], UI.SMALL, UI.GREEN if bool(r["win"]) else UI.FG, "bold")
		row.add_child(Icons.tip(l, "%s  %s" % [Clock.fmt(int(r["d"])), r.get("cards", "")]))
	return row


## One line on how to open the rest of the file ("" when it is all found).
static func hint(opp: Dictionary) -> String:
	var left := OppFile.hidden(opp).size()
	if left == 0:
		return ""
	return "%d still hidden. Tape study in camp opens one every %d days; the fight shows the rest." % [left, OppFile.TAPE_EVERY]
