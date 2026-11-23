extends PanelContainer
## The weigh-in, the day before: her weight against the limit, then the scale. Missed weight calls the bout off.

const UI := preload("res://scripts/ui/UI.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Pulse := preload("res://scripts/ui/Pulse.gd")
const WeighMiss := preload("res://scripts/rules/WeighMiss.gd")
const WeighMissWire := preload("res://scripts/state/WeighMissWire.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(760, 0)
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var made := BoutRules.made_weight(float(f["weight"]), float(f["limit"]))
	var v := UI.vbox(12)
	add_child(v)
	if WeighMissWire.pending(f):
		_miss(main, f, v)
		return
	v.add_child(UI.caps("THE DAY BEFORE"))
	v.add_child(UI.display("WEIGH-IN", 48))
	v.add_child(UI.mono("%.1f kg" % f["weight"], 56, UI.GREEN if made else UI.RED))
	var line := "Limit %.1f kg. " % f["limit"]
	if made:
		line += "On the mark."
	else:
		line += "%.1f kg over. %s" % [float(f["weight"]) - float(f["limit"]),
			"" if not (f["camp"] as Dictionary).is_empty() else "No camp, no cut."]
	v.add_child(UI.label(line, UI.BODY, UI.FG, "body", true))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var step := UI.button("Step on the scale", "BtnSolid", main.act.bind("doWeigh", ""))
	step.name = "Scale"
	Pulse.breathe(step)   # S442 owner: the one thing to do the day before; the clock waits on it
	foot.add_child(step)
	v.add_child(foot)


## S539 a pro miss: the other corner's answer, then box (pay the share, box drained) or pull out.
func _miss(main: Node, f: Dictionary, v: VBoxContainer) -> void:
	var m: Dictionary = f["bout"]["miss"]
	var ans := str(m["ans"])
	v.add_child(UI.caps("MISSED WEIGHT"))
	v.add_child(UI.display("THEIR CORNER ANSWERS", 40))
	v.add_child(UI.mono("%.1f kg" % f["weight"], 56, UI.RED))
	var line := UI.label(WeighMiss.words(ans, float(m["over"]), int(m["cost"])), UI.BODY, UI.FG, "body", true)
	line.name = "MissAnswer"
	v.add_child(line)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var pull := UI.button("Bout off" if not WeighMiss.can_box(ans) else "Pull out", "Btn", main.act.bind("missPull", ""))
	pull.name = "MissPull"
	pull.tooltip_text = WeighMiss.TIP_PULL
	foot.add_child(pull)
	if WeighMiss.can_box(ans):
		var box := UI.button("Box anyway: pay %s" % UI.money(int(m["cost"])), "BtnSolid", main.act.bind("missBox", ""))
		box.name = "MissBox"
		box.tooltip_text = WeighMiss.TIP_BOX
		Pulse.breathe(box)
		foot.add_child(box)
	v.add_child(foot)
