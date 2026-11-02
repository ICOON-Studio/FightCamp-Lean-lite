extends PanelContainer
## In your office after a bout: how her last goal went, then pick her next one.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(900, 0)
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var v := UI.vbox(12)
	add_child(v)
	v.add_child(UI.caps("IN YOUR OFFICE"))
	v.add_child(UI.display("%s'S NEXT GOAL" % str(f["first"]).to_upper(), 48))
	var history: Array = f.get("history", [])
	var said := "The last bout is done. Time for a new target."
	if not history.is_empty():
		var last: Dictionary = history[history.size() - 1]
		said = "Last goal, %s: %s. Time for a new target." % [str(last["title"]).to_lower(),
			"met" if bool(last["met"]) else "not met"]
	v.add_child(UI.muted(said, UI.BODY, true))
	for g in Bouts.goal_choices(c, f):
		var targets: Array = []
		for k in (g["targets"] as Dictionary).keys():
			if k != "booked_fight":
				targets.append("%s to %.1f" % [Data.LABEL.get(k, k), float(g["targets"][k])])
		var days := int(g["deadline_day"]) - int(g["start_day"])
		var on := str(m["pick"]) == str(g["id"])
		var b := UI.button2("%s, %d days" % [g["title"], days], "%s. \"%s\"" % [", ".join(targets), g["persona_line"]],
			"ChoiceOn" if on else "Choice", main.act.bind("pickgoal", g["id"]), Vector2(0, 70), UI.FG, UI.MUTED)
		b.name = "Goal_" + str(g["id"])
		v.add_child(b)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	foot.add_child(UI.button("Later", "BtnQuiet", main.act.bind("close", "")))
	var set_b := UI.button("Set goal", "BtnSolid", main.act.bind("setgoal", ""), str(m["pick"]) == "",
		"Pick one of the goal options above, then set it")
	set_b.name = "SetGoal"
	foot.add_child(set_b)
	v.add_child(foot)
