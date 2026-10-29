extends PanelContainer
## A plain message: a title, a line, Close.

const UI := preload("res://scripts/ui/UI.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(760, 0)
	var v := UI.vbox(12)
	add_child(v)
	v.add_child(UI.display(str(m["title"]).to_upper(), 48))
	v.add_child(UI.label(m["body"], UI.BODY, UI.FG, "body", true))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	foot.add_child(UI.button("Close", "BtnSolid", main.act.bind("close", "")))
	v.add_child(foot)
