extends RefCounted
## S443 R29 THE JUDGES, shown: three cards side by side, each with the judge's lean (what that judge counts double), a chip a
## round with that judge's score in the colour of the boxer it went to (hover: why), the total and the ONE reason the card
## went that way. A component for the result page (the result page session places it in its tab); reads m["judges"]
## (JudgeNight). A stopped bout shows the cards up to the stoppage. Hidden while the judges do not decide the result
## (JudgeNight.decides(): S443 HOLD until JUDGES1), so the page never shows cards that disagree with the verdict.

const UI := preload("res://scripts/ui/TV.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const JudgeNight := preload("res://scripts/state/JudgeNight.gd")


## The judges' block; hidden (visible false) when the bout was not judged or the judges do not decide yet.
static func build(m: Dictionary, names: Array) -> VBoxContainer:
	var v := UI.vbox(10)
	v.name = "JudgeCards"
	var j: Dictionary = m.get("judges", {})
	if j.is_empty() or not bool(j.get("decides", false)):
		v.visible = false
		return v
	var head := UI.hbox(14)
	var title := UI.caps("THE JUDGES")
	title.add_theme_color_override("font_color", UI.GOLD)
	head.add_child(title)
	var words := JudgeNight.verdict_words(m)
	if str(m.get("stopped", "")) != "":
		words = "Cards when it was stopped"
	head.add_child(UI.label(words, UI.BODY, UI.FG, "bold"))
	v.add_child(head)
	var row := UI.hbox(12)
	row.name = "JudgeRow"
	for k in 3:
		row.add_child(_card(j, k, names))
	v.add_child(row)
	return v


static func _card(j: Dictionary, k: int, names: Array) -> PanelContainer:
	var lean := str((j.get("leans", []) as Array)[k]) if k < (j.get("leans", []) as Array).size() else ""
	var tot: Array = (j["cards"] as Array)[k]
	var a := int(tot[0])
	var b := int(tot[1])
	var col: Color = Broadcast.HERS if a > b else (Broadcast.THEIRS if b > a else UI.MUTED)
	var p := PanelContainer.new()
	p.name = "Judge%d" % (k + 1)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(Color(1, 1, 1, 0.05), col.darkened(0.2), 6, 2, 16, 12))
	var v := UI.vbox(8)
	p.add_child(v)
	var top := UI.hbox(10)
	top.add_child(UI.label("JUDGE %d" % (k + 1), UI.SMALL, UI.MUTED, "bold"))
	var lw := UI.label(str(JudgeNight.LEAN_WORD.get(lean, lean)), UI.SMALL, UI.GOLD, "bold")
	lw.tooltip_text = "This judge counts double: " + str(JudgeNight.LEAN_TIP.get(lean, ""))
	lw.mouse_filter = Control.MOUSE_FILTER_STOP
	top.add_child(lw)
	v.add_child(top)
	var chips := UI.hbox(4)
	var by_round: Array = j.get("by_round", [])
	for i in by_round.size():
		var sc: Dictionary = (by_round[i] as Array)[k]
		var ours := int(sc["a"]) > int(sc["b"])
		var chip := PanelContainer.new()
		chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var cc: Color = Broadcast.HERS if ours else Broadcast.THEIRS
		chip.add_theme_stylebox_override("panel", UI.box(cc.darkened(0.35), cc, 3, 1, 4, 2))
		chip.tooltip_text = "Round %d: %s" % [i + 1, str(sc["reason"])]
		chip.mouse_filter = Control.MOUSE_FILTER_STOP
		var l := UI.mono("%d-%d" % [int(sc["a"]), int(sc["b"])], UI.TINY, Color.WHITE)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		chip.add_child(l)
		chips.add_child(chip)
	v.add_child(chips)
	var total := UI.label("%d-%d" % [a, b], 30, col.lightened(0.3) if a != b else UI.FG, "display")
	total.tooltip_text = "%s %d, %s %d" % [str(names[0]) if names.size() > 0 else "Red", a, str(names[1]) if names.size() > 1 else "Blue", b]
	v.add_child(total)
	var why := str((j.get("reasons", ["", "", ""]) as Array)[k]) if k < (j.get("reasons", []) as Array).size() else ""
	v.add_child(UI.label(why if why != "" else "A level card.", UI.SMALL, UI.FG, "body", true))
	return p
