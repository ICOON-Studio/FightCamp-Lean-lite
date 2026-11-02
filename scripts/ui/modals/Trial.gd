extends PanelContainer
## A prospect's trial at the gym: what she is, her stats (exact now), the coach's verdict, pick her three week cards,
## sign her on the club stipend or pass.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(1000, 0)
	var c: Career = main.career
	var p := Roster.prospect(c, str(m["pid"]))
	var read := Roster.trial_read(c, p)
	var picks: Array = m["picks"]
	var v := UI.vbox(10)
	add_child(v)
	v.add_child(UI.caps("TRIAL AT %s" % c.gym_name.to_upper()))
	v.add_child(UI.display(str(p["name"]).to_upper(), 48))
	v.add_child(UI.muted("%d, %s, %s, amateur %d-%d, %s" % [p["age"], str(p["wc"]).to_lower(), p["stance"], p["w"], p["l"],
		str(p["style"]).to_lower()], UI.BODY))
	v.add_child(UI.label(read["open"], UI.BODY, UI.FG, "body", true))
	var grid := UI.hbox(24)
	v.add_child(grid)
	var stats := UI.vbox(6)
	stats.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stats.size_flags_stretch_ratio = 1.3
	for key in Data.STATS:
		stats.add_child(UI.stat_row(Data.LABEL[key], float(p["stats"][key]), key == read["best"]))
	var pot := int(p["pot"])
	stats.add_child(UI.muted("Potential: %s" % ("high" if pot >= 85 else ("good" if pot >= 80 else "limited")), UI.SMALL))
	grid.add_child(stats)
	var right := UI.vbox(10)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var coach := "%s" % c.coach.get("name", "The coach")
	right.add_child(UI.caps("%s SAYS" % coach.to_upper()))
	right.add_child(UI.label("\"%s\"" % read["verdict"], UI.BODY, UI.GOLD if bool(read["good"]) else UI.FG, "italic", true))
	right.add_child(UI.caps("PICK THREE WEEK CARDS"))
	var cards := GridContainer.new()
	cards.columns = 2
	cards.add_theme_constant_override("h_separation", 8)
	cards.add_theme_constant_override("v_separation", 8)
	for card in Data.CARDS:
		var b := UI.button(card, "ChoiceOn" if picks.has(card) else "Choice", main.act.bind("trialcard", card))
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		cards.add_child(b)
	right.add_child(cards)
	right.add_child(UI.muted("Terms: club stipend, %s a week." % UI.money(GameMoney.FIGHTER_STIPEND), UI.SMALL))
	grid.add_child(right)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var pass_b := UI.button("Pass", "BtnQuiet", main.act.bind("passprospect", ""))
	pass_b.name = "PassProspect"
	foot.add_child(pass_b)
	var ready := picks.size() == 3
	var sign_why := "Pick %d more week cards before signing" % (3 - picks.size())
	var sign := UI.button("Sign " + str(p["first"]) if ready else "Sign: pick %d more" % (3 - picks.size()), "BtnSolid",
		main.act.bind("signprospect", ""), not ready, sign_why if not ready else "")
	sign.name = "SignProspect"
	foot.add_child(sign)
	v.add_child(foot)
