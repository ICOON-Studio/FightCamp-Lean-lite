extends RefCounted
## Tie-ups tab: WrestleChains on the ground-move browser (standing chain wrestling whiteboard).

const UI := preload("res://scripts/ui/UI.gd")
const WC := preload("res://scripts/rules/WrestleChains.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanPanel := preload("res://scripts/ui/PlanPanel.gd")

const NO_CLIP := "No clip of this yet"
const DEMO_COACH := 55.0


static func fill_list(browser) -> void:
	UI.clear(browser._list)
	for t in WC.TIES:
		var tid := str(t["id"])
		var n: int = WC.answers(tid).size()
		browser._list.add_child(UI.button2(str(t["name"]), "%d answers" % n, "Choice", func(): pick(browser, tid),
			Vector2(browser.PANEL_W - 50, 50), UI.FG, UI.MUTED, false, UI.SMALL, UI.TINY))


static func pick(browser, tie_id: String) -> void:
	browser._tie_open = tie_id
	# S338 still t01: a tie-up picked over the browser's start left the women lying in mount - stand them where the
	# tie-up's first clip starts (go_position refreshes the panel, which shows the open tie-up).
	for row in WC.answers(tie_id):
		var clips: Array = WC.clip_for(row, browser.graph.transitions)
		if not clips.is_empty() and clips[0]["from"] != null:
			browser.go_position(int(clips[0]["from"]))
			return
	show_tie(browser, tie_id)


static func plan_map() -> Array:
	var map: Array = []
	for a in WC.ANSWERS:
		map.append({
			"id": str(a["tie"]) + ":" + str(a["reaction"]),
			"from": str(a["tie"]),
			"to": str(a["link"]) if str(a["link"]) != "" else "finish",
			"reaction": str(a["reaction"]),
			"name": str(a["technique"]),
		})
	return map


static func show_tie(browser, tie_id: String) -> void:
	var info: Dictionary = WC.tie(tie_id)
	if info.is_empty():
		return
	UI.clear(browser._side)
	browser._side.add_child(UI.caps("TIE-UP"))
	browser._side.add_child(UI.label(str(info["name"]), 28, UI.FG, "bold", true))
	if browser.plan_mode:
		var limit := PlanBoard.arrow_limit(browser.coach_skill)
		browser._side.add_child(PlanPanel.build(plan_map(), browser.plan, limit, _drilled(browser), _place_name, func(i): browser._remove_plan_arrow(i)))
		browser._side.add_child(UI.sep())
	for row in WC.answers(tie_id):
		_answer_row(browser, row)


static func _drilled(browser) -> Array:
	var ids: Array = []
	for a in WC.ANSWERS:
		if not WC.clip_for(a, browser.graph.transitions).is_empty():
			ids.append(str(a["tie"]) + ":" + str(a["reaction"]))
	return ids


static func _place_name(id: String) -> String:
	if id == "finish":
		return "Finish"
	var t: Dictionary = WC.tie(id)
	return str(t["name"]) if not t.is_empty() else id


static func _answer_row(browser, row: Dictionary) -> void:
	var clips: Array = WC.clip_for(row, browser.graph.transitions)
	var pts: int = int(row["points"])
	var sub := "if she %s -> %s" % [row["reaction"], row["finish"]]
	if pts > 0:
		sub += " (+%d)" % pts
	var move_id := str(row["tie"]) + ":" + str(row["reaction"])
	var limit := PlanBoard.arrow_limit(browser.coach_skill)
	var full_reason := "The plan is full (%d arrows for this coach)" % limit
	var planned: bool = browser.plan.any(func(a): return str(a["move"]) == move_id)
	var why := ""
	if browser.plan_mode:
		if not planned and browser.plan.size() >= limit:
			why = full_reason
	else:
		if clips.is_empty():
			why = NO_CLIP
	var disabled := why != ""
	var r: Dictionary = row
	var on_press := func(): _take_answer(browser, r) if browser.plan_mode else play_answer(browser, r)
	var main := UI.button2(str(row["technique"]), sub, "Choice", on_press, Vector2(browser.PANEL_W - 50, 58), UI.FG, UI.MUTED,
		disabled, UI.SMALL, UI.TINY, why)
	browser._side.add_child(main)
	var link_id := str(row["link"])
	if link_id != "":
		var linked: Dictionary = WC.tie(link_id)
		var lname := str(linked["name"]) if not linked.is_empty() else link_id
		browser._side.add_child(UI.button("-> %s" % lname, "BtnQuiet", func(): pick(browser, link_id)))


static func _take_answer(browser, row: Dictionary) -> void:
	var move_id := str(row["tie"]) + ":" + str(row["reaction"])
	if browser.plan.any(func(a): return str(a["move"]) == move_id):
		return
	if browser.plan.size() >= PlanBoard.arrow_limit(browser.coach_skill):
		return
	browser.plan.append({"move": move_id})
	show_tie(browser, browser._tie_open)


static func play_answer(browser, row: Dictionary) -> void:
	var clips: Array = WC.clip_for(row, browser.graph.transitions)
	if clips.is_empty():
		return
	var t: Dictionary = clips[0]
	browser._tie_open = str(row["tie"])
	if t["from"] != null:
		browser.go_position(int(t["from"]))
	else:
		var id := int(t["id"])
		var frames: Array = browser.db[id]["frames"]
		if browser.player.seq.is_empty():
			browser.player.play(browser.db[id], browser.player.men, browser.player.scale, Transform3D.IDENTITY)
		else:
			browser.player.play_frames(Graph.placed(frames, Graph.align(browser.player.shown_frame(), frames[0])))
	browser.play_out({"t": t, "reverse": false})
