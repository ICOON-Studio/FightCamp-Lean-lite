extends RefCounted
## S514 FIGHTWEEK3 favours earned (map ops/research/AMATEURWEEK1_MAP_V6_S455.md s7-8): the late-ask card at the top of the
## boxer's Overview while a host one boxer short waits for an answer (LateAskWire.is_open). The host and the show in the
## header, then the two answers side by side with what each gives: Yes = a fight week on short notice, x2 reputation on a
## win, +1 favour with the host (pips to FAVOURS_MAX), the stoppage and teaching words of the Ask card; No = nothing changes.
## Names only in the header (S448): the rows say "your boxer", "the opponent", "the host".
## The actions: lateask (open the Overview), lateanswer (a confirm) -> latedo (LateAskWire.answer).
## Colours are ApproachCard's (the Overview's dark-card palette), the pips FallThroughCard's.

const UI := preload("res://scripts/ui/UI.gd")
const ApproachCard := preload("res://scripts/ui/ApproachCard.gd")
const FallThroughCard := preload("res://scripts/ui/FallThroughCard.gd")
const LateAskWire := preload("res://scripts/state/LateAskWire.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")


## The card's words (also what the test reads): {head, sub, cols: [{id, word, rows: [{text, pips_on, pips_of}]}]}.
static func view(c: Career, f: Dictionary) -> Dictionary:
	var v := LateAskWire.view(c, f)
	var opp: Dictionary = v["opp"]
	var days := int(v["show"]) - c.day
	var yes: Array = [
		{"text": "Favours with the host: %d -> %d" % [int(v["fav_now"]), int(v["fav_after"])], "pips_on": int(v["fav_after"]),
			"pips_of": FightWeekEvents.FAVOURS_MAX},
		{"text": "Reputation on a win x%d" % LateAskWire.REP_X, "pips_on": LateAskWire.REP_X, "pips_of": LateAskWire.REP_X},
		{"text": "The opponent: %d-%d, %s" % [int(opp.get("w", 0)), int(opp.get("l", 0)), str(opp.get("style", "")).to_lower()],
			"pips_on": 0, "pips_of": 0},
		{"text": "This fight %s. Getting stopped: %s." % [str(v["teaches"]), str(v["stop"])], "pips_on": 0, "pips_of": 0},
		{"text": "A fight week on %d days' notice: no camp" % days, "pips_on": 0, "pips_of": 0},
	]
	var no: Array = [
		{"text": "Nothing changes: the host finds another boxer", "pips_on": 0, "pips_of": 0},
		{"text": "Favours with the host stay at %d" % int(v["fav_now"]), "pips_on": int(v["fav_now"]), "pips_of": FightWeekEvents.FAVOURS_MAX},
	]
	return {"head": "%s ASKS FOR %s" % [str(v["host"]).to_upper(), str(f["name"]).to_upper()],
		"sub": "The host is one boxer short for the show on %s and asks your boxer to step in. Answer before the clock runs on." \
			% Clock.fmt(int(v["show"])),
		"cols": [{"id": "yes", "word": "Take the bout", "rows": yes}, {"id": "no", "word": "Say no", "rows": no}]}


## Fills `card` ([panel, vbox] from DarkOverview.panel) and returns the panel.
static func fill(card: Array, main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var v := view(c, f)
	var box: VBoxContainer = card[1]
	card[0].name = "LateAskCard"
	box.add_child(UI.label(str(v["head"]), 24, ApproachCard.HEAD, "bold"))
	box.add_child(UI.label(str(v["sub"]), UI.BODY, ApproachCard.INK, "semi", true))
	var row := UI.hbox(10)
	for col in v["cols"]:
		var cv := UI.vbox(6)
		cv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var bt := UI.button(str(col["word"]), "Btn", main.act.bind("lateanswer", "%s|%s" % [f["id"], col["id"]]), false, "")
		bt.name = "Btn_late_" + str(col["id"])
		cv.add_child(bt)
		for r in col["rows"]:
			var line := UI.hbox(8)
			line.add_child(UI.label(str(r["text"]), 16, ApproachCard.INK, "body", true))
			if int(r["pips_of"]) > 0:
				line.add_child(FallThroughCard._pips(int(r["pips_on"]), int(r["pips_of"]), ApproachCard.HEAD))
			cv.add_child(line)
		row.add_child(cv)
	box.add_child(row)
	return card[0]


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"lateask":
			main.nav({"area": "fighters", "tab": 0, "fighter": arg, "ftab": 0})
		"lateanswer":
			var kv := arg.split("|")
			var f := c.fighter_by_id(kv[0])
			var host := str((f.get("late_ask", {}) as Dictionary).get("host", "the host"))
			main.open_modal({"type": "info", "title": "%s asks for %s" % [host, f.get("first", "")],
				"body": "Take the bout: a short-notice fight week and a favour with the host?" if kv[1] == "yes"
					else "Say no: nothing changes and no favour is earned?",
				"buttons": [["Yes", "latedo", arg], ["No", "close", ""]]})
		"latedo":
			var kv2 := arg.split("|")
			main.close_modal()
			var why := LateAskWire.answer(c, kv2[0], kv2[1] == "yes")
			main.toast("Done." if why == "" else "Not possible: %s." % why)
			main.render()
		_:
			return false
	return true
