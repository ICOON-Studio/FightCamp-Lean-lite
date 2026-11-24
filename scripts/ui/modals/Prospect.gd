extends PanelContainer
## S545 KNOWBUILD1 (owner interview S543 K2-K3: "a prospect is a moment ... shown like the pro offer"; map v9 3A-3B; owner
## S544/S545: a decision screen is a SCENE, little text, the how and why in the hover). The signing card:
## left, the prospect painted in the gym (ProspectScene.art); right, the read as three RANGES drawn as bands against the
## level (body, skills, ceiling: never single numbers), the 21-day strip with the bout and the rival's window (a name with
## no dates has no strip), and the calls as CARDS - SIGN NOW, START THE TRIAL, WAIT FOR THE BOUT (only with a bout) - each
## a painting, at most four facts, its own button. Pass is a plain button at the foot.

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const ProScene := preload("res://scripts/ui/ProScene.gd")
const ProspectScene := preload("res://scripts/ui/ProspectScene.gd")
const ProspectWire := preload("res://scripts/state/ProspectWire.gd")
const PC := preload("res://scripts/rules/ProspectClock.gd")
const KR := preload("res://scripts/rules/KnowReads.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")

const READS := [["body", "BODY", "Strength, speed and engine, as the scout saw them. The white tick is the level of the region's boxers in this class."],
	["skills", "SKILLS", "Accuracy, timing, defence and footwork. The white tick is the level."],
	["ceiling", "CEILING", "How far the prospect could go. Only the pad test narrows it."]]


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	var c: Career = main.career
	var p := ProspectWire.by_id(c, str(m["pid"]))
	var d := ProspectWire.card(c, p)
	custom_minimum_size = Vector2(1560, 0)
	var row := UI.hbox(22)
	add_child(row)
	var cap := "THE SCOUT SAW THEM AT THE REGION SHOW" if bool(d["dated"]) else "AT THE GYM"
	row.add_child(ProspectScene.art(p, cap, Vector2(420, 760)))
	var v := UI.vbox(14)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(v)
	var top := UI.hbox(16)
	top.add_child(UI.display("SIGN THE PROSPECT?", 46))
	top.add_child(UI.spacer())
	var back := UI.button("Back", "BtnQuiet", main.act.bind("close", ""))
	back.name = "CloseCard"
	back.tooltip_text = "The card stays on Find a fighter until the rival club decides."
	top.add_child(back)
	v.add_child(top)
	var reads := UI.hbox(34)
	reads.name = "Reads"
	var r: Dictionary = d["ranges"]
	for g in READS:
		reads.add_child(ProspectScene.read_col(str(g[0]), str(g[1]), r[g[0]], float(d["level"]), str(g[2]), 250.0))
	v.add_child(reads)
	var s := ProspectScene.strip(c, p)
	if s != null:
		v.add_child(s)
	var cards := UI.hbox(16)
	cards.name = "Calls"
	cards.add_child(_sign_card(main, c, p, d))
	cards.add_child(_trial_card(main, c, p, d))
	if int(d["bout"]) > c.day and int(d["bout"]) <= int(d["to"]):
		cards.add_child(_wait_card(main, c, p, d))
	v.add_child(cards)
	var foot := UI.hbox(12)
	foot.add_child(UI.spacer())
	var pass_b := UI.button("Pass", "BtnQuiet", main.act.bind("prospectpass", str(p["id"])))
	pass_b.name = "PassProspect"
	pass_b.tooltip_text = "Not for the gym: the name leaves the list today and boxes on at %s. No news, no cost." % str(d["club"] if str(d["club"]) != "" else "another club")
	foot.add_child(pass_b)
	v.add_child(foot)


func _card(node_name: String, art: String, title: String, tone: Color, facts: Array, button: Button) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = node_name
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(Palette.alpha(Palette.TEXT, 0.05), Palette.alpha(tone, 0.55), 8, 2, 0, 0))
	var v := UI.vbox(0)
	p.add_child(v)
	var head := ProScene.header(art, title, tone, 104.0)
	var tl := head.find_child("ChoiceTitle", false, false) as Label
	if tl != null:   # three cards share the width the pro call's two had: the title one size down, never cut
		tl.add_theme_font_size_override("font_size", 30)
	v.add_child(head)
	var pad := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		pad.add_theme_constant_override("margin_" + side, 14)
	pad.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(pad)
	var inner := UI.vbox(10)
	pad.add_child(inner)
	for x in facts:
		inner.add_child(x)
	var gap := UI.spacer()
	gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	inner.add_child(gap)
	button.size_flags_horizontal = Control.SIZE_FILL
	button.custom_minimum_size.y = 52.0
	inner.add_child(button)
	return p


func _sign_card(main: Node, c: Career, p: Dictionary, d: Dictionary) -> Control:
	var full := int(d["free"]) <= 0
	var facts: Array = [
		ProScene.fact("user", Palette.HEADER, "Place %d of %d" % [int(d["used"]) + 1, int(d["places"])], "",
			"A signing holds one of the gym's places for the season. A wrong one holds it too: there is no letting go before the season ends."),
		ProScene.fact("calendar", Palette.ACCENT, "Held to %s" % Clock.fmt(int(d["held_to"])), "", "The season's national final. Let go opens after it."),
		ProScene.fact("ticket", Palette.WARN, "%s a week" % GameMoney.text(GameMoney.FIGHTER_STIPEND), "", "The gym stipend, from this week."),
		ProScene.fact("target", Palette.BAD, PC.SIGN_ODDS, "end under the level",
			"Of first looks like this one, about 1 in 3 turn out under the level once the gym has seen more. Measured on 20,000 scouted names."),
	]
	var go := UI.button("Sign now", "Go", main.act.bind("prospectsign", str(p["id"])), full, "Every place is taken." if full else "")
	go.name = "SignNow"
	if not full:
		go.tooltip_text = "Signs today. The new boxer's profile opens with what changed."
	return _card("CallSign", ProScene.OFFICE, "SIGN NOW", Palette.HEADER, facts, go)


func _trial_card(main: Node, c: Career, p: Dictionary, d: Dictionary) -> Control:
	var full := int(d["free"]) <= 0
	var club := str(d["club"]) if str(d["club"]) != "" else "The rival club"
	var facts: Array = [
		ProScene.fact("ticket", Palette.WARN, "%s a day" % GameMoney.text(KR.PRICE_TRIAL_DAY), "",
			"Up to %d days (%s). Each day is paid as it is used; refunded if %s sign first." % [KR.TRIAL_MAX_DAYS, GameMoney.text(KR.PRICE_TRIAL_DAY * KR.TRIAL_MAX_DAYS), club]),
		ProScene.fact("target", Palette.ACCENT, "Tomorrow: body", "",
			"The fitness test. Each evening you pick the next day's question: body, skills, the pad test or the hard spar. Sign, send home or another day."),
		ProScene.fact("user", Palette.HEADER, "Holds a place", "", "A place is kept for the prospect while the trial runs."),
	]
	if bool(d["dated"]):
		var o: Array = PC.odds_tomorrow(c.day, int(d["from"]), int(d["to"]))
		facts.append(ProScene.fact("x", Palette.BAD, "%s: %d in %d" % [club, int(o[0]), int(o[1])], "may decide tomorrow",
			"%s decide between %s and %s, whatever the trial does." % [club, Clock.fmt(int(d["from"])), Clock.fmt(int(d["to"]))]))
	var go := UI.button("Start the trial", "Btn", main.act.bind("prospecttrial", str(p["id"])), full, "Every place is taken." if full else "")
	go.name = "StartTrial"
	return _card("CallTrial", ProScene.GYM, "START THE TRIAL", Palette.ACCENT, facts, go)


func _wait_card(main: Node, c: Career, p: Dictionary, d: Dictionary) -> Control:
	var club := str(d["club"])
	var ob: Array = d["before_bout"]
	var facts: Array = [
		ProScene.fact("ticket", Palette.GOOD, "Free", "", "Your evening at the region show."),
		ProScene.fact("play", Palette.ACCENT, "Boxes %s" % Clock.fmt(int(d["bout"])), "", "Continue stops on the night. Until then the prospect trains in the open sessions: body and skills narrow a little each week."),
		ProScene.fact("flame", Palette.HEADER, "Under fire: rough", "", "The bout opens the under-fire read, about 23 wide, and moves the record."),
		ProScene.fact("x", Palette.BAD, "%s: %d in %d" % [club, int(ob[0]), int(ob[1])], "may sign before it",
			"Of the window's %d days, %d fall before the bout." % [PC.WINDOW, int(ob[0])]),
	]
	var go := UI.button("Wait for the bout", "BtnQuiet", main.act.bind("close", ""))
	go.name = "WaitBout"
	return _card("CallWait", ProScene.RING, "WAIT FOR THE BOUT", Palette.GOOD, facts, go)
