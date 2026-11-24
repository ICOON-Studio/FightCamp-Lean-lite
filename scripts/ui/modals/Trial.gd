extends PanelContainer
## S545 KNOWBUILD1 (owner interview S543 K4: "each trial evening the player picks tomorrow's question"; map v9 3B, 0.8):
## the trial evening. Left, the prospect in the gym (ProspectScene.art). Right: TRIAL DAY n; what today's question
## narrowed as two bands, before -> after, with the one "why" line; the read as it stands; tomorrow's question as up to
## four picture buttons (ANOTHER DAY), each saying what it narrows, and tonight's rival odds; SIGN and SEND HOME.
## (The S354 Monday trial with its three week cards is gone: signing now starts on the boxer's style cards.)

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const ProspectScene := preload("res://scripts/ui/ProspectScene.gd")
const ProspectWire := preload("res://scripts/state/ProspectWire.gd")
const PC := preload("res://scripts/rules/ProspectClock.gd")
const KR := preload("res://scripts/rules/KnowReads.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")

const GROUP_WORD := {"body": "Body", "skills": "Skills", "ceiling": "Ceiling", "fire": "Under fire"}


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(1500, 0)
	var c: Career = main.career
	var p := ProspectWire.by_id(c, str(m["pid"]))
	var t: Dictionary = p.get("trial", {})
	var days := int(t.get("days", 0))
	var d := ProspectWire.card(c, p)
	var level := float(d["level"])
	var row := UI.hbox(22)
	add_child(row)
	row.add_child(ProspectScene.art(p, "TRIAL AT %s - DAY %d, THE EVENING" % [c.gym_name.to_upper(), days], Vector2(400, 720)))
	var v := UI.vbox(16)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(v)
	v.add_child(UI.display("TRIAL DAY %d" % days if days > 0 else "THE TRIAL", 50))
	var last: Dictionary = t.get("last", {})
	if not last.is_empty():
		v.add_child(_before_after(last, level))
		if str(last["q"]) == "spar":
			var tr: Array = Recruit.traits(p.get("personality", {}))
			var pl := UI.label("Under pressure: %s" % str(tr[0] if float(PC.truths(p)["fire"]) >= level else tr[1]), UI.BODY + 2, Palette.HEADER, "bold")
			pl.name = "Pressure"
			pl.mouse_filter = Control.MOUSE_FILTER_STOP
			pl.tooltip_text = "What the hard spar showed of the prospect under fire. Tonight: injury twice as likely, +15 tiredness."
			v.add_child(pl)
	var reads := UI.hbox(30)
	reads.name = "Reads"
	for g in [["body", "BODY"], ["skills", "SKILLS"], ["ceiling", "CEILING"]]:
		reads.add_child(ProspectScene.read_col(str(g[0]), str(g[1]), d["ranges"][g[0]], level, "The read after %d trial day%s. The white tick is the level." % [days, "" if days == 1 else "s"], 220.0))
	v.add_child(reads)
	var can_more := days < KR.TRIAL_MAX_DAYS and ProspectWire.evening(p)
	var head := UI.hbox(14)
	head.add_child(UI.label("ANOTHER DAY: TOMORROW'S QUESTION" if can_more else "THE LAST TRIAL DAY", 20, Palette.MUTED, "caps"))
	head.add_child(UI.spacer())
	if bool(d["dated"]):
		var o: Array = PC.odds_tomorrow(c.day, int(d["from"]), int(d["to"]))
		var odds := UI.label("%s may decide tomorrow: %d in %d" % [str(d["club"]), int(o[0]), int(o[1])], UI.BODY, Palette.BAD if int(o[0]) > 0 else Palette.GOOD, "bold")
		odds.name = "Odds"
		odds.mouse_filter = Control.MOUSE_FILTER_STOP
		odds.tooltip_text = "%s decide between %s and %s. If they sign during the trial, its days are refunded." % [str(d["club"]), Clock.fmt(int(d["from"])), Clock.fmt(int(d["to"]))]
		head.add_child(odds)
	v.add_child(head)
	var qs := UI.hbox(14)
	qs.name = "Questions"
	var asks: Dictionary = (p["know"] as Dictionary).get("asks", {})
	for q in KR.QUESTIONS:
		qs.add_child(ProspectScene.question(main, str(p["id"]), q, int(asks.get(q, 0)), can_more, Faces.stem(p)))
	v.add_child(qs)
	var foot := UI.hbox(12)
	var paid := UI.label("Paid so far: %s" % UI.money(int(t.get("paid", 0))), UI.BODY, Palette.MUTED, "semi")
	paid.name = "Paid"
	foot.add_child(paid)
	foot.add_child(UI.spacer())
	var home := UI.button("Send home", "BtnQuiet", main.act.bind("prospecthome", str(p["id"])))
	home.name = "SendHome"
	home.tooltip_text = "The trial ends; the name stays on Find a fighter until %s decide." % str(d["club"] if str(d["club"]) != "" else "the rival club")
	foot.add_child(home)
	var sign := UI.button("Sign", "Go", main.act.bind("prospectsign", str(p["id"])))
	sign.name = "TrialSign"
	sign.custom_minimum_size = Vector2(240, 54)
	sign.tooltip_text = "Signs tonight for the season. The new boxer's profile opens with what changed."
	Pulse.breathe(sign)
	foot.add_child(sign)
	v.add_child(foot)


## Today's question: the group's band before and after, and why it matters ("Body 56-72 -> 61-69: now clear of the level").
func _before_after(last: Dictionary, level: float) -> Control:
	var g := str(last["g"])
	var q := str(last["q"])
	var box := UI.vbox(6)
	box.name = "Narrowed"
	var h := UI.hbox(18)
	var bv := UI.vbox(2)
	bv.name = "Before_" + q
	bv.add_child(UI.label("%s BEFORE" % str(GROUP_WORD[g]).to_upper(), 15, Palette.MUTED, "caps"))
	bv.add_child(UI.label(ProspectScene.range_text(last["before"]), 26, Palette.MUTED, "bold"))
	bv.add_child(ProspectScene.band(float(last["before"]["lo"]), float(last["before"]["hi"]), level, Palette.alpha(Palette.MUTED, 0.8), 300.0))
	h.add_child(bv)
	var arrow := UI.label("→", 40, Palette.TEXT, "bold")
	arrow.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(arrow)
	var av := UI.vbox(2)
	av.name = "After_" + q
	av.add_child(UI.label("%s TONIGHT" % str(GROUP_WORD[g]).to_upper(), 15, Palette.HEADER, "caps"))
	av.add_child(UI.label(ProspectScene.range_text(last["after"]), 26, Palette.TEXT, "bold"))
	av.add_child(ProspectScene.band(float(last["after"]["lo"]), float(last["after"]["hi"]), level, ProspectScene.tone_of(last["after"], level), 300.0))
	h.add_child(av)
	box.add_child(h)
	var why := UI.label("%s %s → %s: %s" % [str(GROUP_WORD[g]), ProspectScene.range_text(last["before"]), ProspectScene.range_text(last["after"]),
		PC.why(last["before"], last["after"], level)], UI.BODY + 2, Palette.TEXT, "italic")
	why.name = "Why"
	box.add_child(why)
	return box
