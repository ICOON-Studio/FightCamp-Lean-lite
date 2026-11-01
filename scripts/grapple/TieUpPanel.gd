extends RefCounted
## Tie-ups tab: WrestleChains on the ground-move browser (standing chain wrestling whiteboard).

const UI := preload("res://scripts/ui/UI.gd")
const WC := preload("res://scripts/rules/WrestleChains.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")

const NO_CLIP := "No clip of this yet"


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


static func show_tie(browser, tie_id: String) -> void:
	var info: Dictionary = WC.tie(tie_id)
	if info.is_empty():
		return
	UI.clear(browser._side)
	browser._side.add_child(UI.caps("TIE-UP"))
	browser._side.add_child(UI.label(str(info["name"]), 28, UI.FG, "bold", true))
	for row in WC.answers(tie_id):
		_answer_row(browser, row)


static func _answer_row(browser, row: Dictionary) -> void:
	var clips: Array = WC.clip_for(row, browser.graph.transitions)
	var pts: int = int(row["points"])
	var sub := "if she %s -> %s" % [row["reaction"], row["finish"]]
	if pts > 0:
		sub += " (+%d)" % pts
	var disabled := clips.is_empty()
	var r: Dictionary = row
	var main := UI.button2(str(row["technique"]), sub, "Choice",
		func(): play_answer(browser, r), Vector2(browser.PANEL_W - 50, 58), UI.FG, UI.MUTED, disabled, UI.SMALL, UI.TINY, NO_CLIP)
	browser._side.add_child(main)
	var link_id := str(row["link"])
	if link_id != "":
		var linked: Dictionary = WC.tie(link_id)
		var lname := str(linked["name"]) if not linked.is_empty() else link_id
		browser._side.add_child(UI.button("-> %s" % lname, "BtnQuiet", func(): pick(browser, link_id)))


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
