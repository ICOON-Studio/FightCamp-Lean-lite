extends PanelContainer
## The walk-in at reception: the fighter as an RPG recruit (RecruitPanel), one starting focus, sign on the club stipend.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const RecruitPanel := preload("res://scripts/ui/RecruitPanel.gd")
const Recruit := preload("res://scripts/rules/Recruit.gd")


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
	# S354 the reception as an RPG recruit (operator: "get it more rpg elements to this"): RecruitPanel.
	v.add_child(RecruitPanel.build(main, main.career, a, picks, "pickcard"))
	v.add_child(UI.muted("Terms: club stipend, $250 a week.", UI.SMALL))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	foot.add_child(UI.button("Not now", "BtnQuiet", main.act.bind("decline", "")))
	var focus := RecruitPanel.focus_of(picks)
	var ready := focus != "" or picks.size() == 3
	var sign := UI.button("Sign %s - %s" % [a["first"], str(Recruit.FOCUS[focus]["name"]).to_lower()] if focus != "" else
		("Sign " + str(a["first"]) if ready else "Sign: choose a starting focus"), "BtnSolid",
		main.act.bind("sign", ""), not ready, "Choose one starting focus first" if not ready else "")
	sign.name = "Sign"
	foot.add_child(sign)
	v.add_child(foot)
