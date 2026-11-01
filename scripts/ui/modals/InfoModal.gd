extends PanelContainer
## A plain message: a title, a line, Close - or its own buttons (S324 the close screen: [[label, act, arg], ...]).

const UI := preload("res://scripts/ui/UI.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const OppFileCard := preload("res://scripts/ui/OppFileCard.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(760, 0)
	var v := UI.vbox(12)
	add_child(v)
	v.add_child(UI.display(str(m["title"]).to_upper(), 48))
	v.add_child(UI.label(m["body"], UI.BODY, UI.FG, "body", true))
	# S341 a rival's file from the rankings: what the career has found of her, and every bout with us.
	if m.has("rival"):
		var c: Career = main.career
		v.add_child(OppFileCard.build(c.rival(str(m["rival"])), false, OppFile.history(c.results, str(m["rival"]))))
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
