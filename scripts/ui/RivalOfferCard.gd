extends RefCounted
## S517b LADDERWIRE stage 3 R9: a rival gym's offer at the top of the boxer's Overview while it waits (RivalOfferWire.is_open).
## The club and the show in the header, then the three answers side by side with what each does to the ladder points:
## Accept = the bout at that show (the points it can win or lose, LadderRep.price); Not this show = free, once a season
## with that rival; Pass = the challenger takes 2 points (free while hurt or booked). Names only in the header (S448).
## The actions: rivaloffer (open the Overview), rivalanswer (a confirm) -> rivaldo (RivalOfferWire.answer).

const UI := preload("res://scripts/ui/UI.gd")
const ApproachCard := preload("res://scripts/ui/ApproachCard.gd")
const RivalOfferWire := preload("res://scripts/state/RivalOfferWire.gd")
const LadderRep := preload("res://scripts/rules/LadderRep.gd")


## The card's words (also what the test reads): {head, sub, cols: [{id, word, rows: [text]}]}.
static func view(c: Career, f: Dictionary) -> Dictionary:
	var v := RivalOfferWire.view(c, f)
	var r: Dictionary = v["rival"]
	var win := LadderRep.change(int(v["my_rep"]), int(v["their_rep"]), "win", "ud")
	var loss := LadderRep.change(int(v["my_rep"]), int(v["their_rep"]), "loss", "ud")
	var accept: Array = [
		"Ladder points on a win %+d, on a loss %+d" % [win, loss],
		"The opponent: %d-%d, %s, %d ladder points (yours %d)" % [int(r.get("w", 0)), int(r.get("l", 0)),
			str(r.get("style", "")).to_lower(), int(v["their_rep"]), int(v["my_rep"])],
		"A fight week, no camp: the show is in %d days" % (int(v["show"]) - c.day),
	]
	var nts: Array = ["Nothing changes this time", "Once a season with this rival: %s" % ("still free" if bool(v["nts_left"]) else "used - it counts as a pass")]
	var pas: Array = ["The challenger takes %d ladder points from your boxer" % int(v["pass_cost"]) if int(v["pass_cost"]) > 0
		else "Free: your boxer is hurt or already booked", "This rival will not ring again for %d weeks" % RivalOfferWire.RivalOffer.COOLDOWN_WEEKS]
	return {"head": "%s WANTS %s" % [str(v["club"]).to_upper(), str(f["name"]).to_upper()],
		"sub": "A boxer below yours on the ladder asks for the bout at the show on %s. Answer by %s." % [Clock.fmt(int(v["show"])),
			Clock.fmt(int(v["expires"]))],
		"cols": [{"id": "accept", "word": "Accept", "rows": accept}, {"id": "not_this_show", "word": "Not this show", "rows": nts},
			{"id": "pass", "word": "Pass", "rows": pas}]}


## Fills `card` ([panel, vbox] from DarkOverview.panel) and returns the panel.
static func fill(card: Array, main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var v := view(c, f)
	var box: VBoxContainer = card[1]
	card[0].name = "RivalOfferCard"
	box.add_child(UI.label(str(v["head"]), 24, ApproachCard.HEAD, "bold"))
	box.add_child(UI.label(str(v["sub"]), UI.BODY, ApproachCard.INK, "semi", true))
	var row := UI.hbox(10)
	for col in v["cols"]:
		var cv := UI.vbox(6)
		cv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var bt := UI.button(str(col["word"]), "Btn", main.act.bind("rivalanswer", "%s|%s" % [f["id"], col["id"]]), false, "")
		bt.name = "Btn_rival_" + str(col["id"])
		cv.add_child(bt)
		for t in col["rows"]:
			cv.add_child(UI.label(str(t), 16, ApproachCard.INK, "body", true))
		row.add_child(cv)
	box.add_child(row)
	return card[0]


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"rivaloffer":
			main.nav({"area": "fighters", "tab": 0, "fighter": arg, "ftab": 0})
		"rivalanswer":
			var kv := arg.split("|")
			var f := c.fighter_by_id(kv[0])
			var club := str((f.get("rival_offer", {}) as Dictionary).get("club", "The rival gym"))
			var body := {"accept": "Accept: book the bout at that show?", "not_this_show": "Not this show: turn it down, no cost?",
				"pass": "Pass: turn it down and let the challenger take the points?"}
			main.open_modal({"type": "info", "title": "%s wants %s" % [club, f.get("first", "")], "body": str(body.get(kv[1], "")),
				"buttons": [["Yes", "rivaldo", arg], ["No", "close", ""]]})
		"rivaldo":
			var kv2 := arg.split("|")
			main.close_modal()
			var why := RivalOfferWire.answer(c, kv2[0], kv2[1])
			main.toast("Done." if why == "" else "Not possible: %s." % why)
			main.render()
		_:
			return false
	return true
