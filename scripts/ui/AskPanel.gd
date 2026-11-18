extends RefCounted
## S512 ASKFIGHT1 (owner "Yes, build it"; map v4 + round-4 critics Dola 7/7, Goose 7/7): ASK FOR A BOUT, one fighter.
## Top: the next two club shows side by side - what each date leaves time for (AskDates.prep's checks), the scale forecast,
## a night one of ours already holds. Then one card per answer (the sheet's name, a step up, names you pick) with an Ask
## button per date; the answers that are missing say why; the Wait line last. Raw facts only: no best badge, no score.
## Opened from Fights (route {"area": "fights", "ask": fid}). Game text never says he, she, her or him.

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")
const AskDates := preload("res://scripts/rules/AskDates.gd")
const OfferCard := preload("res://scripts/ui/OfferCard.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const Faces := preload("res://scripts/rules/Faces.gd")


static func build(main: Node, parent: Control, fid: String) -> void:
	var c: Career = main.career
	var f := _fighter(c, fid)
	var head := UI.hbox(12)
	head.add_child(UI.display("ASK FOR A BOUT: %s" % str(f.get("first", "")).to_upper(), 34))
	head.add_child(UI.spacer())
	var back := UI.button("Back to Fights", "Btn", func(): main.nav({"area": "fights", "tab": 0}))
	back.name = "AskBack"
	head.add_child(back)
	parent.add_child(head)
	if f.is_empty():
		return
	var gate := AskFlow.open(c, f)
	if not bool(gate["open"]):
		var card := UI.card("ASKING IS CLOSED")
		card[1].add_child(UI.label(str(gate["why"]), UI.BODY, Palette.TEXT, "semi", true))
		if int(gate["opens_day"]) >= 0:
			card[1].add_child(UI.muted("It opens on %s." % Clock.fmt(int(gate["opens_day"])), UI.SMALL))
		parent.add_child(card[0])
		return
	var run := AskFlow.HotStreak.words(c, f)   # S518 R6: once, under the title - a boxer on a run scares corners 0-8 points above
	if run != "":
		var rl := UI.label(run + " Corners up to 8 points above lean No; a No from one of them is a duck.", UI.BODY, Palette.GOOD, "semi", true)
		rl.name = "AskRun"
		parent.add_child(rl)
	var shows := AskFlow.shows(c, f)
	parent.add_child(_dates(shows))
	var ans := AskFlow.answers(c, f)
	for a in ans["cards"]:
		parent.add_child(_answer(main, c, f, a, shows))
	for miss in ans["absent"]:
		parent.add_child(UI.muted("%s: %s" % [AskFlow.AskBout.label(str(miss["kind"]), int(f["w"]) >= AskFlow.Region.RANK_MIN_WINS),
			str(miss["why"])], UI.SMALL, true))
	var wait := UI.card("OR WAIT")
	wait[1].add_child(UI.label(AskDates.wait_words(), UI.BODY, Palette.TEXT, "body", true))
	parent.add_child(wait[0])


static func _fighter(c: Career, fid: String) -> Dictionary:
	for f in c.fighters:
		if str(f["id"]) == fid:
			return f
	return {}


## The two dates side by side: date, days away, the prep checks, the scale, a held night.
static func _dates(shows: Array) -> Control:
	var row := UI.hbox(16)
	row.name = "AskDates"
	for i in shows.size():
		var s: Dictionary = shows[i]
		var card := UI.card("THE SOONEST SHOW" if i == 0 else "THE SHOW AFTER")
		card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card[0].name = "AskDate%d" % i
		var v: VBoxContainer = card[1]
		v.add_child(UI.label("%s, in %d days" % [str(s["date_words"]), int(s["days_away"])], UI.BODY, Palette.HEADER, "bold"))
		var prep: Dictionary = s["prep"]
		v.add_child(UI.muted(str(prep.get("camp_words", "")), UI.SMALL, true))
		for chk in prep.get("checks", []):
			var on := bool(chk["on"])
			v.add_child(UI.label(("Yes  " if on else "No   ") + str(chk["words"]), UI.SMALL, Palette.GOOD if on else Palette.MUTED, "semi", true))
		var fc: Dictionary = s["forecast"]
		v.add_child(UI.label("Scale on the day: %.1f kg for %.1f kg" % [float(fc.get("day", 0.0)), float(fc.get("limit", 0.0))],
			UI.SMALL, Palette.TEXT if bool(s["weight_ok"]) else Palette.BAD, "body", true))
		if bool(s.get("in_gap", false)):
			v.add_child(UI.label("Over the class limit, but inside the club-show weight gap: it boxes.", UI.SMALL, Palette.TEXT, "body", true))
		if not bool(s["weight_ok"]):
			v.add_child(UI.label("Weight at risk: no ask on this date.", UI.SMALL, Palette.BAD, "semi", true))
		if str(s.get("holder", "")) != "":
			v.add_child(UI.label("%s is already on this show." % str(s["holder"]), UI.SMALL, Palette.WARN, "semi", true))
		row.add_child(card[0])
	return row


## One answer: the opponent's face and facts (the offer card's own reads), the two words, the gate, an Ask per date.
static func _answer(main: Node, c: Career, f: Dictionary, a: Dictionary, shows: Array) -> Control:
	var opp: Dictionary = a["opp"]
	var cd: Dictionary = a["card"]
	var card := PanelContainer.new()
	card.name = "Ask_%s_%s" % [str(a["kind"]), str(opp["name"]).replace(" ", "_")]
	card.theme_type_variation = "Card"
	var h := UI.hbox(16)
	card.add_child(h)
	var photo := PromoShot.picture(str(Faces.pair(f, opp)[1]), OfferCard.PHOTO)
	if photo != null:
		h.add_child(photo)
	var who := UI.vbox(2)
	who.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	who.add_child(UI.caps(str(cd["label"]).to_upper()))
	who.add_child(UI.display(str(opp["name"]).to_upper(), 28))
	who.add_child(UI.label("%s, %s%s" % [str(cd["record"]), str(opp.get("style", "")).to_lower(),
		", " + str(cd["place"]) if str(cd["place"]) != "" else ""], UI.SMALL, Palette.TEXT, "semi", true))
	who.add_child(UI.label(OfferCard._bio(opp), UI.SMALL, Palette.MUTED, "body", true))
	who.add_child(UI.label(OfferCard._read(opp), UI.SMALL, Palette.TEXT, "body", true))
	who.add_child(UI.label("This fight %s." % str(a["teaches"]), UI.SMALL, Palette.TEXT, "semi", true))
	var stop := str(cd.get("stoppage", ""))
	if stop != "":
		var sl := UI.label("Getting stopped: %s." % stop, UI.SMALL, Palette.WARN if stop == "a real risk" else Palette.TEXT, "semi", true)
		sl.name = "AskStop"
		who.add_child(sl)
	who.add_child(UI.label("Win: %s. Loss: %s. Stopped: %s." % [", ".join(AskDates.trade("win")), ", ".join(AskDates.trade("loss")),
		", ".join(AskDates.trade("stopped"))], UI.SMALL, Palette.MUTED, "body", true))
	who.add_child(UI.label(str(cd["gate"]), UI.SMALL, Palette.WARN if str(a["kind"]) == "name" else Palette.MUTED, "body", true))
	var lad: Dictionary = a.get("ladder", {})
	if not lad.is_empty():   # S516 LADDERWIRE stage 2: points, the price in points, the reach, will they say yes
		var lp := UI.label("%s %s" % [str(lad["points"]), str(lad["price"])], UI.SMALL, Palette.TEXT, "semi", true)
		lp.name = "AskLadder"
		who.add_child(lp)
		if str(a["kind"]) != "sheet":   # the sheet's name is the host's own offer: no lean, never out of reach
			var ll := UI.label(str(lad["reach"]) if not bool(lad["askable"]) else str(lad["lean"]), UI.SMALL,
				Palette.WARN if not bool(lad["askable"]) or not bool(lad["yes"]) else Palette.TEXT, "semi", true)
			ll.name = "AskLean"
			who.add_child(ll)
			if str(lad.get("chip", "")) != "":   # S518 R6 DUCKED / OWED
				var dc := UI.label(str(lad["chip"]), UI.SMALL, Palette.HEADER if bool(lad.get("owed", false)) else Palette.WARN, "bold", true)
				dc.name = "AskDuck"
				who.add_child(dc)
		else:
			lad = {}
	h.add_child(who)
	var o := {"opp": opp, "day": int(shows[0]["day"]) if not shows.is_empty() else c.day + 14}
	h.add_child(OfferCard._band(c, f, o))
	var btns := UI.vbox(8)
	btns.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	for s in shows:
		var arg := "%s|%s|%s|%d" % [f["id"], a["kind"], opp["name"], int(s["day"])]
		var why := "" if bool(s["can_ask"]) else ("Weight at risk on this date." if not bool(s["weight_ok"]) else "One of ours holds this show.")
		var can := bool(s["can_ask"]) and bool(lad.get("askable", true))
		if bool(s["can_ask"]) and not can:
			why = str(lad["reach"])
		var b := UI.button("Ask for %s" % str(s["date_words"]), "BtnSolid" if can else "Btn", main.act.bind("askbout", arg),
			not can, why)
		b.name = "AskBtn_%d" % int(s["day"])
		btns.add_child(b)
	h.add_child(btns)
	return card
