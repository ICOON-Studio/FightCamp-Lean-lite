extends PanelContainer
## The weigh-in, the day before: her weight against the limit, then the scale. Missed weight calls the bout off.

const UI := preload("res://scripts/ui/UI.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(760, 0)
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var made := BoutRules.made_weight(float(f["weight"]), float(f["limit"]))
	var v := UI.vbox(12)
	add_child(v)
	v.add_child(UI.caps("THE DAY BEFORE"))
	v.add_child(UI.display("WEIGH-IN", 48))
	v.add_child(UI.mono("%.1f kg" % f["weight"], 56, UI.GREEN if made else UI.RED))
	var line := "Limit %.1f kg. " % f["limit"]
	if made:
		line += "She is on the mark."
	else:
		line += "She is %.1f kg over. %s" % [float(f["weight"]) - float(f["limit"]),
			"" if not (f["camp"] as Dictionary).is_empty() else "No camp, no cut."]
	v.add_child(UI.label(line, UI.BODY, UI.FG, "body", true))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var step := UI.button("Step on the scale", "BtnSolid", main.act.bind("doWeigh", ""))
	step.name = "Scale"
	foot.add_child(step)
	v.add_child(foot)
