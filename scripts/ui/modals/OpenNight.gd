extends PanelContainer
## S389 BJJWIRE: the day of an open she entered. One bout at a time: who is next, how the two compare, then FIGHT IT (the 3D belt
## match, the player calls the moves) or SIMULATE (the walk). When the run ends: the medal, and what it did for the next belt.

const UI := preload("res://scripts/ui/UI.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const BjjOpen := preload("res://scripts/rules/BjjOpen.gd")
const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const MatLines := preload("res://scripts/rules/MatLines.gd")
const MatPrice := preload("res://scripts/rules/MatPrice.gd")
const MatReceipt := preload("res://scripts/rules/MatReceipt.gd")   # S516 MATRECEIPT1

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
	_plan_line(v, f, opp)
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


## S515 MATPLANUI1 (MATPLAN_MAP_S433 section 6, Open night): YOUR PLAN in one line - the route, each brought line with its
## chance against this opponent, the scoreboard. Set on the Playbook page; the simulated bout plays it (BjjBeat).
func _plan_line(v: VBoxContainer, f: Dictionary, opp: Dictionary) -> void:
	var plan: Dictionary = f.get("bjj_plan", {})
	var rl := BjjTree.rules_for(str(f.get("belt", "white")))
	var parts: Array = []
	for l in MatLines.brought(f, plan, rl):
		var pr := MatPrice.price(f, opp, l, rl)
		var mv := BjjTree.move_name(str(BjjTree.edge(str(l["edge"])).get("move", "")))
		parts.append("%s (%s%s)" % [mv, str(MatLines.TIMING_WORDS.get(str(l["timing"]), "")).to_lower(),
			"" if pr.is_empty() or str(l["timing"]) == "sit_tight" else ", %d in 100" % roundi(float(pr["chance_timed"]) * 100.0)])
	var board: Dictionary = plan.get("board", {})
	var line := "YOUR PLAN: %s." % str(plan.get("name", "the coach's route"))
	if not parts.is_empty():
		line += " Lines: %s." % ", ".join(parts)
	if not board.is_empty():
		line += " Level %s, ahead %s, behind %s." % [str(board.get("level", "steady")).capitalize(), str(board.get("ahead", "save")).capitalize(),
			str(board.get("behind", "push")).capitalize()]
	var lb := UI.label(line, UI.BODY, UI.GOLD, "semi", true)
	lb.name = "OpenPlan"
	v.add_child(lb)


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
		["Stamina", BjjMatch.stat(f, "cardio"), BjjMatch.stat(o, "cardio")]]
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
	# S516 MATRECEIPT1 (map 4.6): the coach goes down the plan - each brought line, tried and worked, or never reached.
	var rec := MatReceipt.receipt(f.get("bjj_plan", {}), f, run["rows"], BjjTree.rules_for(str(f.get("belt", "white"))))
	if not rec.is_empty():
		v.add_child(UI.caps("YOUR PLAN, LINE BY LINE"))
		for x in rec:
			var l := UI.muted(str(x["words"]) + ("" if int(x["tried"]) == 0 else " worked"), UI.BODY, true)
			l.name = "Receipt_%s" % str(x["edge"])
			v.add_child(l)
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
