extends PanelContainer
## S389 BJJWIRE: the day of an open she entered. One bout at a time: who is next, how the two compare, then FIGHT IT (the 3D belt
## match, the player calls the moves) or SIMULATE (the walk). When the run ends: the medal, and what it did for the next belt.

const UI := preload("res://scripts/ui/UI.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const BjjOpen := preload("res://scripts/rules/BjjOpen.gd")
const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")

const ROUND_NAMES := ["QUARTER-FINAL", "SEMI-FINAL", "FINAL"]


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(900, 0)
	var c: Career = main.career
	var f: Dictionary = c.grappler_by_id(str(m["fid"]))
	var run: Dictionary = f["open_run"]
	var v := UI.vbox(12)
	add_child(v)
	v.add_child(UI.caps(str(run["name"]).to_upper()))
	var rows: Array = run["rows"]
	if bool(run["over"]):
		_done(main, v, c, f, run)
	else:
		v.add_child(UI.display(str(ROUND_NAMES[rows.size()]), 48))
		_next(main, v, c, f, rows.size())
	_so_far(v, rows)


func _next(main: Node, v: VBoxContainer, c: Career, f: Dictionary, bout: int) -> void:
	var opp := Grapplers.next_opp(c, f)
	var o := BjjOpen.match_opp(opp)
	v.add_child(UI.label("%s against %s, %s belt, %s." % [f["first"], opp["name"], str(opp.get("belt", "white")), str(opp.get("style", "")).to_lower()],
		UI.BODY + 2, UI.FG, "bold", true))
	var minutes := BeltRoad.match_minutes(str(f.get("belt", "white")))
	v.add_child(UI.muted("%d minutes. Takedown 2, sweep 2, pass 3, mount or back 4. A submission ends it." % minutes, UI.BODY, true))
	v.add_child(_compare(f, o))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var sim := UI.button("Simulate this bout", "BtnQuiet", main.act.bind("opensim", str(f["id"])))
	sim.name = "OpenSim"
	foot.add_child(sim)
	var live := UI.button("Fight it: you call the moves", "BtnSolid", main.act.bind("openlive", str(f["id"])), not FightView.enabled(),
		"The match needs a screen")
	live.name = "OpenLive"
	foot.add_child(live)
	v.add_child(foot)


## The three numbers the match reads, side by side.
func _compare(f: Dictionary, o: Dictionary) -> Control:
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 40)
	grid.add_theme_constant_override("v_separation", 6)
	for t in ["", str(f["first"]).to_upper(), str(o["first"]).to_upper()]:
		grid.add_child(UI.caps(t))
	var rows := [["Technique", BjjMatch.skill_of(f), float(o["skill"])],
		["Strength", BjjMatch.stat(f, "strength"), BjjMatch.stat(o, "strength")],
		["Cardio", BjjMatch.stat(f, "cardio"), BjjMatch.stat(o, "cardio")]]
	for r in rows:
		grid.add_child(UI.label(str(r[0]), UI.BODY, UI.FG, "body"))
		for k in [1, 2]:
			var better := float(r[k]) > float(r[3 - k])
			grid.add_child(UI.label("%d" % int(r[k]), UI.BODY + 2, UI.GREEN if better else UI.FG, "bold"))
	return grid


func _done(main: Node, v: VBoxContainer, c: Career, f: Dictionary, run: Dictionary) -> void:
	var wins := int(run["wins"])
	var medal := str(BjjOpen.result(f, run)["medal"])
	v.add_child(UI.display(("%s MEDAL" % medal.to_upper()) if medal != "" else "OUT IN ROUND ONE", 48, UI.GOLD if medal != "" else UI.FG))
	var bouts := (run["rows"] as Array).size()
	var credit := bouts * BjjOpen.BOUT_CLASSES
	var r := BeltRoad.readiness(f, f.get("bjj", {}), c.day)
	var nxt := BeltRoad.next_belt(str(f.get("belt", "white")))
	v.add_child(UI.label("%d-%d on the day." % [wins, bouts - wins], UI.BODY + 2, UI.FG, "bold"))
	if nxt != "":
		v.add_child(UI.muted("%d bouts count as %d classes towards %s belt: %d of %d after today." % [bouts, credit, nxt,
			int(r["mat"][0]) + credit, int(r["mat"][1])], UI.BODY, true))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var done := UI.button("Back to the gym", "BtnSolid", main.act.bind("openclose", str(f["id"])))
	done.name = "OpenClose"
	foot.add_child(done)
	v.add_child(foot)


func _so_far(v: VBoxContainer, rows: Array) -> void:
	if rows.is_empty():
		return
	v.add_child(UI.caps("TODAY"))
	for i in rows.size():
		v.add_child(UI.muted(BjjOpen.path_line(rows[i], i), UI.BODY, true))
