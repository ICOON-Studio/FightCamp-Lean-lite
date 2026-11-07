extends RefCounted
## S384 GAMETREE1: the Systems modal's route cards for Ana's Playbook (design 6, 7) - picture, name, one line
## ("4 steps - 2 owned - long: gets read"), Use (act gplan). Opened only from the Systems button (InfoModal "systems").
##   MatSystems.cards(main, f) -> GridContainer "SystemCards", one Sys_<route> card each, its button Use_<route>

const UI := preload("res://scripts/ui/UI.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const Info := preload("res://scripts/ui/MatTreeInfo.gd")
const MatGlyph := preload("res://scripts/ui/MatGlyph.gd")
const MatTree := preload("res://scripts/ui/MatTree.gd")


static func cards(m: Node, fd: Dictionary) -> Control:
	var grid := GridContainer.new()
	grid.name = "SystemCards"
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	var cur: Array = Info.plan_steps(fd)
	for rid in BjjTree.data()["routes"]:
		var r := BjjTree.route(str(rid))
		var steps: Array = r["steps"]
		var p := PanelContainer.new()
		p.name = "Sys_" + str(rid)
		p.custom_minimum_size = Vector2(360, 0)
		p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD if cur == steps else UI.LINE, 8, 2 if cur == steps else 1, 8, 8))
		var h := UI.hbox(10)
		var first := ""
		for id in steps:
			if not BjjTree.is_base(str(BjjTree.edge(str(id))["move"])):
				first = str(BjjTree.edge(str(id))["move"])
				break
		var path := MatTree.card_pic(first)
		if path != "":
			var tr := TextureRect.new()
			tr.texture = load(path)
			tr.custom_minimum_size = Vector2(72, 72)
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			h.add_child(tr)
		else:
			h.add_child(MatGlyph.make(str(BjjTree.edge(str(steps[0]))["odds"]) if first == "" else str(BjjTree.move(first).get("kind", "")), Vector2(72, 72), true))
		var v := UI.vbox(2)
		v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		v.add_child(UI.label(str(r["name"]).to_upper(), 17, UI.FG, "display"))
		v.add_child(UI.label(Info.route_line(fd, str(rid)), UI.TINY, UI.MUTED, "semi", true))
		var legal := BjjTree.route_legal(steps, Info.rules(fd))
		var use := UI.button("In the plan" if cur == steps else "Use", "BtnSolid" if cur == steps else "Btn",
			m.act.bind("gplan", "%s|route:%s" % [str(fd.get("id", "")), str(rid)]), not legal or cur == steps,
			"Union rules: not at this belt" if not legal else "")
		use.name = "Use_" + str(rid)
		use.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		v.add_child(use)
		h.add_child(v)
		p.add_child(h)
		grid.add_child(p)
	return grid
