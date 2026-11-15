extends RefCounted
## S487 R58 APPROACHWIRE1 (map ops/research/R58_MAP_S439.md section 7, "Fighter page > Overview"): the approach card at the
## top of the boxer's Overview while a rival club's approach waits - the offer, the answer-by day, the talk, and the five
## answers side by side, each with what it costs and where loyalty stands 12 weeks on (Approach.answers via ApproachWire).
## Names only in the header (S448). A grey answer says why on screen, in the line under it.
## Also the Overview's "Let go" (map M7: Leaving.let_go_price's confirm) and the actions: approach (open the Overview),
## approachtalk, approachanswer (a confirm) -> approachdo, letgo (a confirm) -> letgodo.
## Fills a panel the caller makes (DarkOverview.panel): no preload of DarkOverview (it preloads this file).

const Palette := preload("res://scripts/ui/Palette.gd")   # S493 Q-251 the one palette
const UI := preload("res://scripts/ui/UI.gd")
const Approach := preload("res://scripts/rules/Approach.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")
const Leaving := preload("res://scripts/state/Leaving.gd")

const INK := Palette.TEXT
const SOFT := Palette.MUTED
const HEAD := Palette.HEADER
const RED := Palette.BAD
const AMBER := Palette.WARN
const GREEN := Palette.GOOD


## The card's rows, in order (also what the test reads): {head, offer, talk, cols: [{id, word, lines, available, why}]}.
static func view(c: Career, f: Dictionary) -> Dictionary:
	var a: Dictionary = f["approach"]
	var cols: Array = []
	for col in ApproachWire.columns(c, f):
		cols.append({"id": str(col["id"]), "word": str(Approach.BUTTON_WORDS[col["id"]]), "lines": _lines(col),
			"available": bool(col["available"]), "why": str(col["why_not"])})
	return {"head": "%s WANTS %s" % [ApproachWire.CLUB.to_upper(), str(f["name"]).to_upper()],
		"offer": "%s. Answer by %s: no answer and the boxer goes." % [a["line"], Clock.fmt(int(a["ends"]))],
		"talk": _talk_line(c, f), "cols": cols}


static func _lines(col: Dictionary) -> Array:
	var id := str(col["id"])
	var out: Array = []
	var cash := int(col["cash"])
	out.append("Cost: nothing" if cash == 0 else "Cost: %s%s" % [UI.money(-cash), " over 12 weeks" if id == "match" else " (the show)"])
	if id == "let_go":
		out.append("Leaves next Monday")
		return out
	var end := int(col["loyalty_end"])
	out.append("Loyalty in 12 weeks: %d (%s)" % [end, Loyalty.band(end)])
	if int(col["holder_end"]) >= 0 and (id == "half" or id == "move"):
		out.append("Team-mate on the stipend: %d" % int(col["holder_end"]))
	var t := float(col["train"])
	var ht := float(col["holder_train"])
	if t < 1.0:
		out.append("Training: %d%% for both" % roundi(t * 100.0) if is_equal_approx(t, ht) else "Training: %d%%" % roundi(t * 100.0))
	elif ht < 1.0:
		out.append("The team-mate takes a day job")
	return out


static func _talk_line(c: Career, f: Dictionary) -> String:
	var talk := str(f["approach"]["talk"])
	if talk == "landed":
		return "The talk landed: HALF EACH counts in full."
	if talk == "failed":
		return "The talk failed: loyalty -4 and HALF EACH is off the card."
	if not Loyalty.can_tell_straight(f, c.day):
		return "Talked in the last 8 weeks: no talk this time."
	var n := roundi(Approach.talk_chance(ApproachWire.coachability(f)) * 10.0)
	return "Tell it straight first (free): lands about %d in 10. Landed, HALF EACH counts in full; failed, loyalty -4 and HALF EACH goes." % n


## Fills `card` ([panel, vbox] from DarkOverview.panel) and returns the panel.
static func fill(card: Array, main: Node, c: Career, f: Dictionary) -> PanelContainer:
	var v := view(c, f)
	var box: VBoxContainer = card[1]
	card[0].name = "ApproachCard"
	box.add_child(UI.label(str(v["head"]), 24, RED, "bold"))
	box.add_child(UI.label(str(v["offer"]), UI.BODY, INK, "semi", true))
	var talk_row := UI.hbox(12)
	var tl := UI.label(str(v["talk"]), UI.BODY, SOFT, "body", true)
	tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	talk_row.add_child(tl)
	if str(f["approach"]["talk"]) == "" and Loyalty.can_tell_straight(f, c.day):
		var tb := UI.button("Tell it straight", "Btn", main.act.bind("approachtalk", str(f["id"])))
		tb.name = "Btn_approachtalk"
		talk_row.add_child(tb)
	box.add_child(talk_row)
	var row := UI.hbox(10)
	for col in v["cols"]:
		var cv := UI.vbox(4)
		cv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var b := UI.button(str(col["word"]), "Btn", main.act.bind("approachanswer", "%s|%s" % [f["id"], col["id"]]), not bool(col["available"]))
		b.name = "Btn_approach_" + str(col["id"])
		cv.add_child(b)
		for line in col["lines"]:
			cv.add_child(UI.label(str(line), 16, INK if bool(col["available"]) else SOFT, "body", true))
		if not bool(col["available"]):
			cv.add_child(UI.label("Not open: " + str(col["why"]), 16, AMBER, "semi", true))
		row.add_child(cv)
	box.add_child(row)
	return card[0]


## The Overview's Let go button: greyed with its reason (Leaving.let_go_price).
static func let_go_button(main: Node, c: Career, f: Dictionary) -> Button:
	var p := Leaving.let_go_price(c, str(f["id"]))
	var b := UI.button("Let go", "Btn", main.act.bind("letgo", str(f["id"])), str(p["why_not"]) != "", str(p["why_not"]))
	b.name = "Btn_letgo"
	return b


static func act(main: Node, name: String, arg: String) -> bool:
	var c: Career = main.career
	match name:
		"approach":
			main.nav({"area": "fighters", "tab": 0, "fighter": arg, "ftab": 0})
		"approachtalk":
			var r := ApproachWire.talk(c, arg)
			main.toast(("The talk landed." if bool(r["landed"]) else "The talk failed: loyalty -4.") if bool(r["ok"]) else "No talk: %s." % r["why"])
			main.render()
		"approachanswer":
			var kv := arg.split("|")
			var f := c.fighter_by_id(kv[0])
			var body := "%s: %s?" % [Approach.BUTTON_WORDS.get(kv[1], kv[1]), _confirm_text(kv[1])]
			main.open_modal({"type": "info", "title": "%s's answer to %s" % [f.get("first", ""), ApproachWire.CLUB], "body": body,
				"buttons": [["Yes", "approachdo", arg], ["No", "close", ""]]})
		"approachdo":
			var kv2 := arg.split("|")
			main.close_modal()
			var why := ApproachWire.answer(c, kv2[0], kv2[1])
			main.toast("Done." if why == "" else "Not possible: %s." % why)
			main.render()
		"letgo":
			var p := Leaving.let_go_price(c, arg)
			if str(p["why_not"]) != "":
				main.toast("Not now: %s." % p["why_not"])
				return true
			var f2 := c.fighter_by_id(arg)
			main.open_modal({"type": "info", "title": "Let %s go?" % f2.get("first", ""),
				"body": "Free in cash; the place frees for a trial. Reputation %d. Team-mates under 50 loyalty lose 2." % int(p["rep"]),
				"buttons": [["Let go", "letgodo", arg], ["Keep", "close", ""]]})
		"letgodo":
			main.close_modal()
			var r2 := Leaving.let_go(c, arg)
			main.toast(str(r2.get("line", "Gone.")))
			main.nav({"area": "fighters", "tab": 0, "fighter": "", "bout": ""})
		_:
			return false
	return true


static func _confirm_text(id: String) -> String:
	match id:
		"match":
			return "pay what they offer, held for 12 weeks"
		"half":
			return "split the stipend in two for 12 weeks; both train a little less"
		"move":
			return "the stipend moves now; the team-mate takes a day job"
		"promise":
			return "book the club show now and put the boxer on top of it; a missed night and the boxer goes"
		"let_go":
			return "the boxer leaves next Monday"
	return ""
