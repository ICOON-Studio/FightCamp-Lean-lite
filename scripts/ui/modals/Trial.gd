extends PanelContainer
## A prospect's trial at the gym: what she is, her stats (exact now), the coach's verdict, pick her three week cards,
## sign her on the club stipend or pass.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const RecruitPanel := preload("res://scripts/ui/RecruitPanel.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")
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
	var coach := "%s" % c.coach.get("name", "The coach")
	v.add_child(UI.label("%s: \"%s\"" % [coach, read["verdict"]], UI.BODY, UI.GOLD if bool(read["good"]) else UI.FG, "italic", true))
	# S354 the trial as an RPG recruit (RecruitPanel), one starting focus.
	v.add_child(RecruitPanel.build(main, c, p, picks, "trialcard"))
	v.add_child(UI.muted("Terms: club stipend, %s a week." % UI.money(GameMoney.FIGHTER_STIPEND), UI.SMALL))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var pass_b := UI.button("Pass", "BtnQuiet", main.act.bind("passprospect", ""))
	pass_b.name = "PassProspect"
	foot.add_child(pass_b)
	var focus := RecruitPanel.focus_of(picks)
	var ready := focus != "" or picks.size() == 3
	var sign := UI.button("Sign %s - %s" % [p["first"], str(Recruit.FOCUS[focus]["name"]).to_lower()] if focus != "" else
		("Sign " + str(p["first"]) if ready else "Sign: choose a starting focus"), "BtnSolid",
		main.act.bind("signprospect", ""), not ready, "Choose one starting focus first" if not ready else "")
	sign.name = "SignProspect"
	foot.add_child(sign)
	v.add_child(foot)
