extends RefCounted
## S341 HER FILE (OppFile): what the coach knows of the opponent, what is still hidden and how to find it. One builder for
## the bout offer, the fighter's Camp tab and fight night. A found tell shows its answer (the counter) in green.
## S341: `history` (OppFile.history of Career.results) adds WITH US - every bout our gym has had with her.
##   build(opp, film_bought, history) -> VBoxContainer   hint(opp) -> String

const UI := preload("res://scripts/ui/UI.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const RECORD_ROWS := 6

const HOW := {"tape": "tape study in camp finds it"}


## film_bought: her camp has tape study (the hidden rows say it is coming, not how to get it).
static func build(opp: Dictionary, film_bought := false, history: Array = []) -> VBoxContainer:
	var box := UI.vbox(8)
	var found := OppFile.found(opp).size()
	var all := found + OppFile.hidden(opp).size()
	box.add_child(UI.caps("HER FILE  -  %d OF %d FOUND" % [found, all]))
	for t in OppFile.tells(opp):
		var id := str(t["id"])
		var row := UI.vbox(2)
		if OppFile.known(opp, id):
			row.add_child(UI.kv(str(t["what"]), str(t["value"])))
			if str(t["counter"]) != "" and str(t["how"]) != "booking":
				row.add_child(UI.label("Answer: " + str(t["counter"]), UI.SMALL, UI.GREEN, "body", true))
		else:
			row.add_child(UI.kv(str(t["what"]), "?", UI.MUTED))
			var how := "on tape in this camp" if film_bought else str(HOW.get(str(t["how"]), "the fight shows it"))
			row.add_child(UI.muted(how, UI.TINY, true))
		box.add_child(row)
	var h := hint(opp)
	if h != "":
		box.add_child(UI.muted(h, UI.SMALL, true))
	# S341 her record, bout by bout (RivalPast): newest first; a bout against our gym in gold.
	var past := RivalPast.shown(opp, RECORD_ROWS)
	if not past.is_empty():
		box.add_child(UI.caps("HER RECORD  -  %d-%d" % [int(opp.get("w", 0)), int(opp.get("l", 0))]))
		for b in past:
			var col := UI.GOLD if bool(b.get("ours", false)) else (UI.GREEN if bool(b["win"]) else UI.FG)
			var verb := "Drew with" if str(b["how"]) == "a draw" else ("Beat" if bool(b["win"]) else "Lost to")
			var line := "%s %s (%s)" % [verb, b["vs"], b["vs_club"]]
			var row := UI.hbox(10)
			var left := UI.label(line, UI.SMALL, col, "body", true)
			left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(left)
			row.add_child(UI.muted("%s, %s" % [b["how"], Clock.fmt(int(b["d"]))], UI.TINY))
			box.add_child(row)
		var more := (opp.get("bouts", []) as Array).size() - past.size()
		if more > 0:
			box.add_child(UI.muted("and %d older bouts" % more, UI.TINY))
	if not history.is_empty():
		box.add_child(UI.caps("WITH US"))
		for r in history:
			var res := "drew" if str(r.get("outcome", "")) == "draw" else ("beat her" if bool(r["win"]) else "lost to her")
			box.add_child(UI.kv("%s %s" % [r["who"], res], "%s, %s" % [Clock.fmt(int(r["d"])), r.get("cards", "")], UI.GREEN if bool(r["win"]) else UI.FG, "body"))
	return box


## One line on how to open the rest of the file ("" when it is all found).
static func hint(opp: Dictionary) -> String:
	var left := OppFile.hidden(opp).size()
	if left == 0:
		return ""
	return "%d still hidden. Tape study in her camp opens one every %d days; the fight shows the rest." % [left, OppFile.TAPE_EVERY]
