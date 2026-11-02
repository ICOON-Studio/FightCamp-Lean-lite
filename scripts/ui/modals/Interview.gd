extends PanelContainer
## The walk-in at reception: her stats, pick three week cards, sign her on the club stipend.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(980, 0)
	var a: Dictionary = main.career.applicant
	var picks: Array = m["picks"]
	var v := UI.vbox(10)
	add_child(v)
	v.add_child(UI.caps("AT RECEPTION"))
	v.add_child(UI.display(str(a["name"]).to_upper(), 48))
	v.add_child(UI.muted("%d, %s, %s, amateur %d-%d, %s" % [a["age"], str(a["wc"]).to_lower(), a["stance"], a["w"], a["l"],
		str(a["style"]).to_lower()], UI.BODY))
	v.add_child(UI.label("\"I've had four fights at a church hall. I want a proper gym and a proper coach.\"", UI.BODY, UI.FG, "italic", true))
	var grid := UI.hbox(24)
	v.add_child(grid)
	var stats := UI.vbox(6)
	stats.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stats.size_flags_stretch_ratio = 1.4
	for key in Data.STATS:
		stats.add_child(UI.stat_row(Data.LABEL[key], float(a["stats"][key])))
	grid.add_child(stats)
	var right := UI.vbox(10)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_child(UI.caps("PICK HER THREE WEEK CARDS"))
	var cards := GridContainer.new()
	cards.columns = 2
	cards.add_theme_constant_override("h_separation", 8)
	cards.add_theme_constant_override("v_separation", 8)
	for card in Data.CARDS:
		var b := UI.button(card, "ChoiceOn" if picks.has(card) else "Choice", main.act.bind("pickcard", card))
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		cards.add_child(b)
	right.add_child(cards)
	right.add_child(UI.muted("Terms: club stipend, $250 a week.", UI.SMALL))
	grid.add_child(right)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	foot.add_child(UI.button("Not now", "BtnQuiet", main.act.bind("decline", "")))
	var ready := picks.size() == 3
	var sign_why := "Pick %d more week cards before signing" % (3 - picks.size())
	var sign := UI.button("Sign " + str(a["first"]) if ready else "Sign: pick %d more" % (3 - picks.size()), "BtnSolid",
		main.act.bind("sign", ""), not ready, sign_why if not ready else "")
	sign.name = "Sign"
	foot.add_child(sign)
	v.add_child(foot)
