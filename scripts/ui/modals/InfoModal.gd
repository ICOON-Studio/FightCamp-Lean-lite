extends PanelContainer
## A plain message: a title, a line, Close - or its own buttons (S324 the close screen: [[label, act, arg], ...]).

const UI := preload("res://scripts/ui/UI.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const OppFileCard := preload("res://scripts/ui/OppFileCard.gd")
const MatSystems := preload("res://scripts/ui/MatSystems.gd")
const SettingsPanel := preload("res://scripts/ui/SettingsPanel.gd")
const HandbookPanel := preload("res://scripts/ui/HandbookPanel.gd")
const CreditsPanel := preload("res://scripts/ui/CreditsPanel.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(760, 0)
	var v := UI.vbox(12)
	add_child(v)
	v.add_child(UI.display(str(m["title"]).to_upper(), 48))
	if str(m["body"]) != "":
		v.add_child(UI.label(m["body"], UI.BODY, UI.FG, "body", true))
	# S396 P15: Settings and the Handbook (they were "not built yet" pop-ups).
	if m.has("settings"):
		v.add_child(SettingsPanel.build(main))
	if m.has("handbook"):
		custom_minimum_size = Vector2(920, 0)
		v.add_child(HandbookPanel.build(main))
	if m.has("credits"):   # S396 Steam: the licences' credits
		custom_minimum_size = Vector2(920, 0)
		v.add_child(CreditsPanel.build(main))
	# S341 a rival's file from the rankings: what the career has found of her, and every bout with us.
	if m.has("rival"):
		var c: Career = main.career
		v.add_child(OppFileCard.build(c.rival(str(m["rival"])), false, OppFile.history(c.results, str(m["rival"]))))
	# S384 GAMETREE1: Ana's route cards (the Systems button on her Playbook page).
	if m.has("systems"):
		var gf: Dictionary = main.career.grappler_by_id(str(m["systems"]))
		if not gf.is_empty():
			custom_minimum_size = Vector2(780, 0)
			v.add_child(MatSystems.cards(main, gf))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var buttons: Array = m.get("buttons", [])
	if buttons.is_empty():
		foot.add_child(UI.button("Close", "BtnSolid", main.act.bind("close", "")))
	for i in buttons.size():
		var b: Array = buttons[i]
		var btn := UI.button(str(b[0]), "BtnSolid" if i == 0 else "Btn", main.act.bind(str(b[1]), str(b[2])))
		btn.name = "Btn_" + str(b[1])
		foot.add_child(btn)
	v.add_child(foot)
