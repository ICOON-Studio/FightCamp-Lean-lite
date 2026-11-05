extends SceneTree
## S384 GAMETREE1 stage 1 item 6 (design 10.3): Ana's Playbook is ONE page - the moves list (MatBook, with the Links
## group), the centre column (MatTree: goal tiles, plan strip, map, leaks) and the mat (MatPlayer). No TabContainer.
## Clicking every control never swaps the column; hovering an exact-film edge starts its clip on MatPlayer; an unfilmed
## edge shows its two poses, never a clip; no caption says she / her. Plus the pure words behind it: the chip word bands
## (60 / 35), the costly corner, the coach's fill per goal, the leaks, the Systems modal and the swap cycle.
## Population: a quick-start career (Lucy signed, Ana Ribeiro on the mat), Ana's start (design 4.2).

const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const Info := preload("res://scripts/ui/MatTreeInfo.gd")
const PRONOUN := "\\b(she|her|hers|herself)\\b"

var _fails := 0
var main: Node


func _initialize() -> void:
	BjjTree.reset_tuning()
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	main.act("quick")
	main.act("guideskip")
	main.close_modal()
	FirstWeek.ana_joins(main.career)
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var c: Career = main.career
	var f: Dictionary = c.grappler_by_id("ana")
	_check(not f.is_empty(), "Ana is on the mat")
	_pure(f, c)

	Playbook.pick = "ana"
	main.act("go", "playbook:0")
	await _frames(6)
	var col := main.find_child("MatTree", true, false)
	_check(main.find_children("*", "TabContainer", true, false).is_empty(), "one page: no TabContainer")
	for n in ["MatTree", "MatBook", "MatPlayer", "Goal_back", "Goal_mount", "Goal_legs", "Goal_points", "Systems", "Plan_route",
			"Tree_standing", "Leaks", "Leak_0", "LeakDrill_0", "TreeMap"]:
		_check(main.find_child(n, true, false) != null, "%s is on the page" % n)
	_check(main.find_child("Mat_snap_down", true, false) != null, "the Links group lists the class-taught tree moves (snap down)")
	_check(main.find_child("Drill_snap_down", true, false) != null, "a Links row has its Drill")

	# Every control in the centre column: the column (and the page's columns) stay.
	var t0 := Time.get_ticks_msec()
	for g in Info.GOALS:
		var b := main.find_child("Goal_" + g, true, false) as Button
		if b != null:
			b.pressed.emit()
			await _frames(1)
		_check(_same(col), "Goal_%s: the column stays" % g)
	(main.find_child("Goal_back", true, false) as Button).pressed.emit()
	var plan: Dictionary = f.get("bjj_plan", {})
	_check(str(plan.get("goal", "")) == "back" and str(BjjTree.edge(str(plan["steps"][-1] if not (plan.get("steps", []) as Array).is_empty() else "")).get("ok", "")) in ["back_top", "tap_win"],
		"Goal_back fills a route to the back (%s)" % str(plan.get("steps", [])))
	await _frames(2)
	print("  (4 goals + refresh: %d ms)" % (Time.get_ticks_msec() - t0))
	var strip := main.find_child("Plan_route", true, false)
	var edge0 := strip.find_child("Edge_*", true, false) as Button if strip != null else null
	_check(edge0 != null, "the plan strip has edge cards")
	if edge0 != null:
		var before := str((f["bjj_plan"]["steps"] as Array)[0])
		edge0.pressed.emit()
		await _frames(1)
		_check(_same(col), "an edge card click (swap) keeps the column")
		var alts := Info.alternatives(f, before)
		_check(alts.size() < 2 or str((f["bjj_plan"]["steps"] as Array)[0]) != before, "the swap took the next alternative at the fork (%s -> %s)" % [before, str(f["bjj_plan"]["steps"][0])])
	var undo := main.find_child("Plan_undo", true, false) as Button
	var n0 := (f["bjj_plan"]["steps"] as Array).size()
	undo.pressed.emit()
	await _frames(1)
	_check(_same(col) and (Info.plan_steps(f).size() < n0 or n0 == 1), "Undo drops the last step (%d -> %d), the column stays (%s)" % [n0, Info.plan_steps(f).size(), _same(col)])
	for k in main.find_child("TreeMap", true, false).get_children():
		if k is Button and str(k.name).begins_with("Tree_"):
			(k as Button).pressed.emit()
			await _frames(1)
			break
	_check(_same(col), "a map position click keeps the column")
	var me: Button = null
	for k in main.find_child("TreeMap", true, false).get_children():
		if k is Button and str(k.name).begins_with("MapEdge_"):
			me = k
	if me != null:
		me.pressed.emit()
		await _frames(1)
	_check(_same(col), "a map arrow click keeps the column")

	# Hover: an exact-film edge plays its clip; an unfilmed one shows two poses, never a clip.
	var mat := main.find_child("MatPlayer", true, false)
	await _frames(4)
	var exact := ""
	var unfilmed := ""
	for eid in BjjTree.data()["edge_ids"]:
		var fm: Variant = BjjTree.edge(eid).get("film")
		if exact == "" and fm is Dictionary and str(fm.get("fit", "")) == "exact" and fm.get("transition") != null:
			exact = eid
		if unfilmed == "" and not (fm is Dictionary and str(fm.get("fit", "")) == "exact"):
			unfilmed = eid
	var pb := main.find_child("MatBook", true, false)
	while pb != null and not pb.has_method("_play_edge"):
		pb = pb.get_parent()
	_check(pb != null and mat != null, "the Playbook and its mat are found")
	if pb != null and mat != null:
		pb._play_edge(exact)
		_check(str(mat.mode) == "clip" and int(mat._seq) == int(BjjTree.edge(exact)["film"]["transition"]),
			"hover an exact edge (%s): the mat plays its clip (%s, seq %d)" % [exact, mat.mode, mat._seq])
		pb._play_edge(unfilmed)
		_check(str(mat.mode) == "poses" and int(mat._seq) == -1 and (mat._poses as Array).size() >= 1,
			"hover an unfilmed edge (%s): two poses, never a clip (%s, %d poses)" % [unfilmed, mat.mode, (mat._poses as Array).size()])
	var card := main.find_child("Plan_0", true, false) as Control
	var cb := card.find_child("Edge_*", true, false) as Button if card != null else null
	if cb != null:
		cb.mouse_entered.emit()
		await _frames(1)
		var tip := main.find_child("EdgeTip", true, false) as Control
		_check(tip != null and tip.visible and _has_text(tip, "%"), "a plan card hover shows EdgeTip with its chance")
		_check(str(mat.mode) in ["clip", "poses"], "the plan card hover plays on the mat (%s)" % mat.mode)
		cb.mouse_exited.emit()
		await _frames(1)
		_check(not tip.visible, "leave: EdgeTip hides")

	# Leak Drill: sets the drill only when pressed.
	var d0 := str(f.get("drill", ""))
	var ld := main.find_child("LeakDrill_0", true, false) as Button
	ld.pressed.emit()
	await _frames(3)
	var d1 := str(f.get("drill", ""))
	_check(d1 != d0 and (BjjTree.is_tree_plan(d1) or d1.begins_with("move:")),
		"LeakDrill_0 sets the week's drill (%s -> %s)" % [d0, str(f.get("drill", ""))])
	_check(main.find_child("MatTree", true, false) != null and main.find_children("*", "TabContainer", true, false).is_empty(),
		"after Drill the page is still one page")

	# Systems: a modal of the 8 route cards; Use fills the plan.
	(main.find_child("Systems", true, false) as Button).pressed.emit()
	await _frames(2)
	var mn: Node = main.modal_node()
	_check(mn != null and mn.find_child("SystemCards", true, false) != null and mn.find_child("SystemCards", true, false).get_child_count() == 8,
		"Systems opens the 8 route cards")
	var use: Button = null
	for k in (mn.find_children("Use_*", "Button", true, false) if mn != null else []):
		if not (k as Button).disabled and use == null:
			use = k
	_check(use != null, "a route card can be used")
	if use != null:
		var rid := str(use.name).trim_prefix("Use_")
		use.pressed.emit()
		await _frames(2)
		_check(f["bjj_plan"]["steps"] == BjjTree.route(rid)["steps"] and main.modal.is_empty(),
			"Use: the plan is the %s route, the modal closed" % rid)
	_captions_clean(main.find_child("MatTree", true, false))
	print("BJJ_TREE_UI failures=%d" % _fails)
	_end()


func _pure(f: Dictionary, c: Career) -> void:
	_check(BjjTree.chip_word(0.60) == "LIKELY" and BjjTree.chip_word(0.59) == "EVEN" and BjjTree.chip_word(0.34) == "LONG SHOT",
		"chip words: 0.60 LIKELY, 0.59 EVEN, 0.34 LONG SHOT")
	var back := Info.fill(f, "back")
	_check(not (back["steps"] as Array).is_empty() and BjjTree.route_ok(back["steps"]) and Info.count_steps(back["steps"]) <= Info.MAX_STEPS,
		"the back's fill chains, at most %d moves (%s)" % [Info.MAX_STEPS, str(back["steps"])])
	var legs := Info.fill(f, "legs")
	_check(str(legs["line"]) == "IBJJF: straight ankle only" or not (legs["steps"] as Array).is_empty(), "white Legs: %s" % legs["line"])
	var mount := Info.fill(f, "mount")
	_check(not (mount["steps"] as Array).is_empty(), "the mount's fill: %s (%s)" % [str(mount["steps"]), mount["line"]])
	# Costly corner: only when the miss lands in a hole or gives 2+ (vs the field the answer is owned, P_bad 1).
	var holes := BjjTree.holes(f, Info.rules(f))
	var costly_ok := true
	for eid in BjjTree.data()["edge_ids"]:
		var e := BjjTree.edge(eid)
		var inf := Info.step_info(f, [eid], 0, holes)
		var want: bool = not bool(inf["base"]) and str(e["bad"]) != str(e["from"]) and (holes.has(str(e["bad"])) or int(e["bad_gives"]) >= 2)
		if bool(inf["costly"]) != want:
			costly_ok = false
	_check(costly_ok, "the costly corner: a miss into a hole or 2+ points, never a reset")
	var one := Info.fill(f, "back", true)
	_check((one["steps"] as Array) != (back["steps"] as Array) or (back["steps"] as Array).size() <= 1, "one step off: the scouted fill differs (%s)" % str(one["steps"]))
	var t0 := Time.get_ticks_msec()
	var lk := Info.leaks(f, c.day)
	print("  (leaks: %d walks in %d ms)" % [Info.LEAK_WALKS, Time.get_ticks_msec() - t0])
	_check(lk.size() == Info.LEAK_N and lk.all(func(x): return holes.has(str(x["node"])) and str(x["move"]) != ""),
		"3 leaks, each a hole with a move to drill (%s)" % str(lk.map(func(x): return "%s/%s" % [x["node"], x["move"]])))
	_check(Info.leaks(f, c.day) == lk, "the leaks are the same on a second look (seeded, cached)")
	_check(Info.links(f).size() == 20, "Links: 20 class-taught white tree moves (%d)" % Info.links(f).size())


func _same(col: Node) -> bool:
	return is_instance_valid(col) and col.is_inside_tree() and main.find_child("MatTree", true, false) == col \
		and main.find_child("MatBook", true, false) != null and main.find_children("*", "TabContainer", true, false).is_empty()


## Every caption on Ana's Playbook page (its three columns and the EdgeTip).
func _captions_clean(col: Node) -> void:
	var re := RegEx.create_from_string(PRONOUN)
	var bad: Array = []
	var page: Node = col.get_parent().get_parent() if col != null else root
	for n in page.find_children("*", "", true, false):
		var t := ""
		if n is Label or n is Button:
			t = str(n.text)
		if t != "" and re.search(t.to_lower()) != null:
			bad.append(t)
	_check(bad.is_empty(), "no she / her on any caption (%s)" % str(bad.slice(0, 3)))


func _has_text(n: Node, s: String) -> bool:
	for k in n.find_children("*", "Label", true, false):
		if str((k as Label).text).contains(s):
			return true
	return false


func _end() -> void:
	quit(1 if _fails > 0 else 0)


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
