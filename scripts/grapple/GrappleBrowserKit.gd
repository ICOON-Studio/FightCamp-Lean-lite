extends RefCounted
## SPLIT500B: the browser's panels and list building lifted out of GrappleBrowser.gd (the 500-line rule) - the top bar,
## the side panel, the position/move lists, the tie-up plan bar and the flow view. Every function is static and takes
## `br: Node` (the GrappleBrowser instance) for the state it needs; the browser keeps the names other scripts call as
## one-line forwards. The Kit never preloads its owner.

const UI := preload("res://scripts/ui/UI.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")
const TieUpPanel := preload("res://scripts/grapple/TieUpPanel.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const FlowView := preload("res://scripts/ui/FlowView.gd")


static func top_bar(br: Node) -> Control:
	var bar := PanelContainer.new()
	bar.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 10))
	var h := UI.hbox(6)
	bar.add_child(h)
	h.add_child(UI.label("GROUND MOVES", 22, UI.FG, "bold"))
	h.add_child(UI.muted("  prototype  "))
	for f in Graph.FAMILIES:
		var tag := str(f[1])
		h.add_child(UI.button(str(f[0]), "Tab", func(): family(br, tag)))
	h.add_child(UI.button("Tie-ups", "Tab", func(): open_ties(br)))
	# S379 the Grappling theatre: whole chains of moves played straight, filmed like a documentary.
	h.add_child(UI.button("Theatre", "Btn", func(): br.get_tree().change_scene_to_file("res://scenes/dev/GrappleTheatre.tscn")))
	br._plan_toggle = UI.button("Build plan", "Btn", func(): set_plan_mode(br, not br.plan_mode))
	br._plan_toggle.visible = false
	h.add_child(br._plan_toggle)
	br._start_again = UI.button("Start again", "BtnQuiet", func(): br.plan.clear(); refresh(br))
	br._start_again.visible = false
	h.add_child(br._start_again)
	br._flow_btn = UI.button("See the flow", "Btn", func(): show_flow(br))   # S340 the tie-up plan as a flow on the whiteboard
	br._flow_btn.visible = false
	h.add_child(br._flow_btn)
	h.add_child(UI.spacer())
	br._search = LineEdit.new()
	br._search.placeholder_text = "find a position"
	br._search.custom_minimum_size = Vector2(220, 0)
	br._search.text_changed.connect(func(words: String): find(br, words))
	h.add_child(br._search)
	return bar


static func panel(br: Node) -> Control:
	var p := PanelContainer.new()
	p.custom_minimum_size = Vector2(br.PANEL_W, 0)
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 14))
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	p.add_child(scroll)
	var v := UI.vbox(10)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(v)
	br._side = UI.vbox(8)
	br._side.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(br._side)
	v.add_child(UI.sep())
	br._list_hdr = UI.caps("POSITIONS")
	v.add_child(br._list_hdr)
	br._list = UI.vbox(4)
	br._list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(br._list)
	return p


## S340 the wrestling plan as a flow (FightFlow): from the tie-up the first arrow leaves, each answer labelled with the
## reaction it answers ("if she leans in on the tie: Snapdown").
static func show_flow(br: Node) -> void:
	var map := TieUpPanel.plan_map()
	var first: Array = map.filter(func(r): return not br.plan.is_empty() and str(r["id"]) == str(br.plan[0]["move"]))
	var start: String = str(first[0]["from"]) if not first.is_empty() else br._tie_open
	var v := FlowView.new()
	v.setup(FightFlow.build(br.plan, map, start), {"title": "THE FLOW: TIE-UPS", "sub": "%d answers, read top to bottom" % br.plan.size(),
		"place_name": TieUpPanel._place_name,
		"move_name": func(id: String) -> String: return str(FightFlow.PlanBoard.row(map, id).get("name", id))})
	br.add_child(v)


static func set_plan_mode(br: Node, on: bool) -> void:
	br.plan_mode = on
	refresh(br)


static func remove_plan_arrow(br: Node, index: int) -> void:
	if index < 0 or index >= br.plan.size():
		return
	br.plan.remove_at(index)
	refresh(br)


static func sync_plan_bar(br: Node) -> void:
	if br._plan_toggle == null:
		return
	var show: bool = br._tie_open != "" and br.moving.is_empty()
	br._plan_toggle.visible = show
	br._start_again.visible = show and br.plan_mode
	br._flow_btn.visible = show and br.plan_mode and not br.plan.is_empty()
	if show:
		br._plan_toggle.text = "Done" if br.plan_mode else "Build plan"


static func refresh(br: Node) -> void:
	UI.clear(br._side)
	if not br.moving.is_empty():
		br._side.add_child(UI.caps("NOW PLAYING"))
		br._side.add_child(UI.label(Graph.clean(str(br.moving["t"]["title"])), 26, UI.GOLD, "bold", true))
		br._side.add_child(UI.button("Skip to the end", "BtnQuiet", func(): br.player.seek(br.player.length_s())))
		sync_plan_bar(br)
		return
	if br._tie_open != "":
		TieUpPanel.show_tie(br, br._tie_open)
		sync_plan_bar(br)
		return
	var pos: Dictionary = br.db[br.current]
	br._side.add_child(UI.caps("POSITION"))
	br._side.add_child(UI.label(Graph.clean(str(pos["title"])), 28, UI.FG, "bold", true))
	br._side.add_child(UI.muted(", ".join(Array(pos["tags"]).map(func(t): return str(t).replace("_", " "))), UI.TINY, true))
	moves(br, "MOVES OUT", br.graph.outs(br.current), true)
	moves(br, "MOVES IN", br.graph.ins(br.current), false)
	sync_plan_bar(br)


static func moves(br: Node, title: String, list: Array, out: bool) -> void:
	br._side.add_child(UI.sep())
	br._side.add_child(UI.caps("%s  (%d)" % [title, list.size()]))
	if list.is_empty():
		br._side.add_child(UI.muted("none recorded", UI.TINY))
	for mv in list:
		var other: Variant = Graph.lands(mv) if out else (mv["t"]["to"] if bool(mv["reverse"]) else mv["t"]["from"])
		var where := Graph.clean(str(br.db[int(other)]["title"])) if other != null else "?"
		var m: Dictionary = mv
		var b := UI.button2(Graph.clean(str(mv["t"]["title"])), ("to " if out else "from ") + where, "Choice",
			(func(): br.play_out(m)) if out else (func(): br.play_in(m)), Vector2(br.PANEL_W - 50, 58), UI.FG, UI.MUTED, false, UI.SMALL, UI.TINY)
		br._side.add_child(b)


static func family(br: Node, tag: String) -> void:
	br._tie_open = ""
	br._list_hdr.text = "POSITIONS"
	fill(br, br.graph.family(tag).slice(0, 40))


static func open_ties(br: Node) -> void:
	br._tie_open = ""
	br._list_hdr.text = "TIE-UPS"
	TieUpPanel.fill_list(br)
	refresh(br)


static func find(br: Node, words: String) -> void:
	if words.strip_edges().length() >= 2:
		br._tie_open = ""
		br._list_hdr.text = "POSITIONS"
		fill(br, br.graph.search(words).slice(0, 40))


static func fill(br: Node, list: Array) -> void:
	UI.clear(br._list)
	for p in list:
		var id := int(p["id"])
		var n: int = br.graph.outs(id).size() + br.graph.ins(id).size()
		br._list.add_child(UI.button2(Graph.clean(str(p["title"])), "%d moves" % n, "Choice", func(): br.go_position(id),
			Vector2(br.PANEL_W - 50, 50), UI.FG, UI.MUTED, false, UI.SMALL, UI.TINY))
