extends VBoxContainer
## S384 GAMETREE1 stage 1 item 6 (ops/research/GAMETREE1_DESIGN_S384.md section 7, docs/mockups/S384_gametree.png): Ana's
## Playbook centre column, between the moves list (MatBook) and the mat (MatPlayer). One page, no tabs, nothing opens on
## its own.
##   GOAL   four fixed tiles (Goal_back / Goal_mount / Goal_legs / Goal_points): a click fills the plan with the coach's
##          fill (MatTreeInfo.fill); a goal with no usable route shows its first missing move as a Drill chip. Systems
##          opens the route cards (a modal, clicked only). OppChip: the next opponent of an entered open, style word.
##   PLAN   Plan_route: node cards and edge cards alternating. An edge card (Plan_<i>, its button Edge_<eid>) shows its
##          step, its picture (a shipped ink PNG, else a glyph tile + "card pending"), the name, ONE word (LIKELY / EVEN /
##          LONG SHOT), its points and a short miss line; a red dashed corner when a miss is costly. Hover: EdgeTip with
##          the four numbers, and the mat plays the edge (exact film) or its two poses. Click: the next owned or felt
##          alternative at that fork (the rest of the route re-filled to the goal).
##   MAP    MatMap ("ANA'S GAME"): the plan's positions and the selected one's ring; a click on a position selects it, a
##          click on an arrow out of the plan's end adds it.
##   LEAKS  the 3 holes the next field walks Ana into (Leak_<n>), each with one Drill (LeakDrill_<n>).
##   MatTree.make(main, f, day, play_edge: Callable(eid), width) -> VBoxContainer

const UI := preload("res://scripts/ui/UI.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const Info := preload("res://scripts/ui/MatTreeInfo.gd")
const MatGlyph := preload("res://scripts/ui/MatGlyph.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const MatCard := preload("res://scripts/ui/MatCard.gd")
const MatMap := preload("res://scripts/ui/MatMap.gd")
const PICS := "res://assets/ui/moves/%s.png"
const CHARCOAL := Color("#26272b")
const GOAL_GLYPH := {"back": "back_take", "mount": "transition", "legs": "submission", "points": "takedown"}
const WORD_CHIP := {"LIKELY": "green", "EVEN": "amber", "LONG SHOT": "red"}
const NODE_W := 66.0
const STRIP_H := 176.0
const MAP_H := 430.0
const TIP_W := 320.0

static var _sel := {}   # fighter id -> the selected position (kept across re-renders)

var main: Node
var f: Dictionary = {}
var day := 0
var width := 830.0
var play_edge: Callable
var steps: Array = []
var _holes: Array = []
var _goals: HBoxContainer
var _strip: ScrollContainer
var _map: MatMap
var _leaks: HBoxContainer
var _hint: Label
var _tip: PanelContainer
var _fills := {}   # goal -> MatTreeInfo.fill, made once a refresh


static func make(m: Node, fd: Dictionary, today: int, play_cb: Callable, w: float = 830.0) -> VBoxContainer:
	var t = load("res://scripts/ui/MatTree.gd").new()
	t.name = "MatTree"
	t.main = m
	t.f = fd
	t.day = today
	t.play_edge = play_cb
	t.width = w
	t._build()
	return t


static func card_pic(move_id: String) -> String:
	var p := PICS % move_id
	return p if ResourceLoader.exists(p) else ""


func _build() -> void:
	add_theme_constant_override("separation", 10)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size = Vector2(width, 0)
	_goals = UI.hbox(8)
	_goals.name = "GoalRow"
	add_child(_goals)
	_strip = ScrollContainer.new()
	_strip.name = "PlanStrip"
	_strip.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_strip.custom_minimum_size = Vector2(0, STRIP_H)
	add_child(_strip)
	_hint = UI.label("", UI.TINY, UI.MUTED, "semi")
	_hint.name = "TreeHint"
	add_child(_hint)
	_map = MatMap.new()
	_map.name = "TreeMap"
	_map.custom_minimum_size = Vector2(0, MAP_H)
	_map.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(_map)
	_leaks = UI.hbox(10)
	_leaks.name = "Leaks"
	add_child(_leaks)
	_tip = PanelContainer.new()
	_tip.name = "EdgeTip"
	_tip.top_level = true
	_tip.visible = false
	_tip.z_index = 20
	_tip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tip.custom_minimum_size = Vector2(TIP_W, 0)
	var sb := UI.box(UI.PANEL, UI.FG, 8, 2, 12, 8)
	sb.shadow_color = Color(0, 0, 0, 0.2)
	sb.shadow_size = 8
	_tip.add_theme_stylebox_override("panel", sb)
	add_child(_tip)
	refresh()


## Rebuilds the goal row, the strip, the map and the leaks from f (the column itself stays).
func refresh() -> void:
	steps = Info.plan_steps(f)
	_holes = BjjTree.holes(f, Info.rules(f))
	_tip.visible = false
	_fills = {}
	for g in Info.GOALS:
		_fills[g] = Info.fill(f, str(g))
	_goal_row()
	_plan_strip()
	_map.setup(f, Info.map_nodes(f, steps, sel()), steps, sel(), _holes, _on_node, _on_map_edge, _hover)
	_leak_row()
	if BjjTree.is_ending(_end_node()):
		_hint.text = "The plan ends in a tap. Undo drops its last step; click a card to swap it. Hover a card: its odds, and the mat plays it."
	else:
		_hint.text = "Click an arrow out of %s on the map to add it. Hover a card: its odds, and the mat plays it." % \
			str(BjjTree.node(_end_node()).get("name", "the last position")).to_lower()


func sel() -> String:
	return str(_sel.get(str(f.get("id", "")), "standing"))


func _end_node() -> String:
	return str(BjjTree.edge(str(steps[-1]))["ok"]) if not steps.is_empty() else "standing"


func _apply_plan(goal: String, st: Array) -> void:
	Info.set_plan(f, goal, st)
	refresh()


# --- goal row ----------------------------------------------------------------------------------------------------------

func _goal_row() -> void:
	UI.clear(_goals)
	var cap := UI.caps("GOAL")
	cap.custom_minimum_size = Vector2(44, 0)
	_goals.add_child(cap)
	var cur := Info.plan_goal(f)
	for g in Info.GOALS:
		_goals.add_child(_goal_tile(str(g), cur == str(g)))
	var sys := UI.button2("Systems", "%d routes" % BjjTree.data()["routes"].size(), "Btn", _systems, Vector2(96, 64), UI.FG, UI.MUTED)
	sys.name = "Systems"
	_goals.add_child(sys)
	var opp := Info.next_opp(f, day)
	if not opp.is_empty():
		var chip := PanelContainer.new()
		chip.name = "OppChip"
		chip.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 14, 1, 10, 4)); Halo.ring(chip, UI.GOLD, 14.0)
		var v := UI.vbox(0)
		v.add_child(UI.label("R1 %s" % str(opp.get("name", "")), UI.SMALL, UI.FG, "bold"))
		v.add_child(UI.muted(str(opp.get("style", "")), UI.TINY))
		chip.add_child(v)
		_goals.add_child(chip)


func _mark(host: Control, on: bool, tint: Color, radius: float, hover_ok: bool) -> void:
	if on:
		Halo.ring(host, tint, radius)
	elif hover_ok:
		Halo.hover(host, tint, radius)

func _goal_tile(g: String, on: bool) -> Control:
	var fl: Dictionary = _fills[g]
	var b := Button.new()
	b.name = "Goal_" + g
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.custom_minimum_size = Vector2(132, 64)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sb := UI.box(UI.PANEL, UI.LINE, 8, 1, 6, 6); _mark(b, on, UI.GOLD, 8.0, true)
	for st in ["normal", "hover", "pressed"]:
		b.add_theme_stylebox_override(st, sb)
	var h := UI.hbox(6)
	h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	h.offset_left = 6
	h.offset_top = 6
	h.offset_right = -6
	h.offset_bottom = -6
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(MatGlyph.make(str(GOAL_GLYPH[g]), Vector2(44, 44)))
	var v := UI.vbox(0)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(UI.label(str(Info.GOAL_NAME[g]).to_upper(), 17, UI.FG, "display"))
	var red := (fl["steps"] as Array).is_empty() and not str(fl["line"]).begins_with("Union rules")
	var line := UI.label(str(fl["line"]), 12, UI.RED if red else UI.MUTED, "semi", true)
	line.custom_minimum_size = Vector2(70, 0)
	v.add_child(line)
	h.add_child(v)
	b.add_child(h)
	b.pressed.connect(func(): _pick_goal(g))
	if (fl["steps"] as Array).is_empty() and str(fl["missing"]) != "":
		var plan := BjjTree.drill_plan_for(f, str(fl["missing"]))
		var d := UI.button("Drill", "BtnSolid" if str(f.get("drill", "")) == plan else "Btn", _drill.bind(plan, str(fl["missing"])))
		d.name = "GoalDrill_" + g
		d.add_theme_font_size_override("font_size", 12)
		d.anchor_left = 1.0
		d.anchor_right = 1.0
		d.offset_left = -50.0
		d.offset_right = -4.0
		d.offset_top = 4.0
		d.offset_bottom = 28.0
		b.add_child(d)
	return b


func _pick_goal(g: String) -> void:
	var fl: Dictionary = _fills[g]
	if (fl["steps"] as Array).is_empty():
		_hint.text = "No usable route to the %s yet: %s." % [str(Info.GOAL_NAME[g]).to_lower(), str(fl["line"]).to_lower()]
		return
	_apply_plan(g, fl["steps"])


func _systems() -> void:
	main.open_modal({"type": "info", "title": "Systems", "body": "The coach's routes. Use one and it fills the plan.",
		"systems": str(f.get("id", ""))})


func _drill(plan: String, mv: String) -> void:
	main.act("gdrill", "%s|%s" % [str(f.get("id", "")), plan])
	main.toast("%s's classes drill the %s." % [str(f.get("first", "")), BjjTree.move_name(mv).to_lower()])


# --- plan strip --------------------------------------------------------------------------------------------------------

func _plan_strip() -> void:
	UI.clear(_strip)
	var h := UI.hbox(6)
	h.name = "Plan_route"
	_strip.add_child(h)
	var ne := steps.size()
	var ew := clampf((width - 84.0 - (ne + 1) * NODE_W - ne * 2 * 6.0) / maxf(1.0, ne), 112.0, 176.0)
	var at := "standing" if steps.is_empty() else str(BjjTree.edge(str(steps[0]))["from"])
	h.add_child(_node_card(at, 0))
	for i in ne:
		h.add_child(_edge_card(i, ew))
		h.add_child(_node_card(str(BjjTree.edge(str(steps[i]))["ok"]), i + 1))
	var tools := UI.vbox(6)
	tools.alignment = BoxContainer.ALIGNMENT_CENTER
	var undo := UI.button("Undo", "Btn", _undo, steps.is_empty())
	undo.name = "Plan_undo"
	tools.add_child(undo)
	h.add_child(tools)


func _node_card(n: String, k: int) -> Control:
	var p := PanelContainer.new()
	p.name = "PlanNode_%d" % k
	p.custom_minimum_size = Vector2(NODE_W, STRIP_H - 14.0)
	var on := n == sel()
	p.add_theme_stylebox_override("panel", UI.box(CHARCOAL, Color(0, 0, 0, 0), 8, 2, 4, 8)); _mark(p, on, Color("#ffd54a"), 8.0, true)
	var v := UI.vbox(8)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(MatGlyph.make(MatGlyph.node_kind(n, str(BjjTree.node(n).get("side", ""))), Vector2(NODE_W - 8.0, 56)))
	var nm := "ANA WINS BY TAP" if n == "tap_win" else str(BjjTree.node(n).get("name", n)).to_upper()
	var l := UI.label(nm, 11, Color("#eef0f3"), "display", true)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(l)
	p.add_child(v)
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	p.gui_input.connect(func(ev: InputEvent):
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
			_on_node(n))
	return p


func _edge_card(i: int, ew: float) -> Control:
	var inf := Info.step_info(f, steps, i, _holes)
	var card := MatCard.new()
	card.name = "Plan_%d" % i
	card.corner = bool(inf["costly"])
	card.custom_minimum_size = Vector2(ew, STRIP_H - 14.0)
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 8, 2, 0, 0)); _mark(card, not bool(inf["base"]), Color("#ffd54a"), 8.0, false)
	var b := Button.new()
	b.name = "Edge_" + str(inf["id"])
	b.flat = true
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var v := UI.vbox(2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var pic := Control.new()
	pic.custom_minimum_size = Vector2(ew - 4.0, 80)
	pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var path := card_pic(str(inf["move"]))
	if path != "":
		var bg := ColorRect.new()
		bg.color = CHARCOAL
		bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.add_child(bg)
		var tr := TextureRect.new()
		tr.texture = load(path)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tr.name = "Pic"
		pic.add_child(tr)
	else:
		var g := MatGlyph.make(str(BjjTree.edge(str(inf["id"]))["odds"]), Vector2(ew - 4.0, 80), true)
		g.name = "Pending"
		g.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		pic.add_child(g)
	if str(inf["state"]) == "felt":
		var fc := UI.chip("felt", "amber")
		fc.position = Vector2(ew - 52.0, 6)
		pic.add_child(fc)
	if not bool(inf["base"]):
		var num := PanelContainer.new()
		num.add_theme_stylebox_override("panel", UI.box(Color("#ffd54a"), CHARCOAL, 11, 2, 6, 0))
		num.add_child(UI.label(str(inf["step"]), 13, CHARCOAL, "bold"))
		num.position = Vector2(6, 6)
		num.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.add_child(num)
	v.add_child(pic)
	var body := UI.vbox(1)
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pad := MarginContainer.new()
	pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["left", "right"]:
		pad.add_theme_constant_override("margin_" + side, 8)
	pad.add_child(body)
	v.add_child(pad)
	var top := UI.hbox(4)
	var nm := UI.label(str(inf["name"]).to_upper(), 13, UI.FG, "display")
	nm.clip_text = true
	nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(nm)
	if bool(inf["swap"]):
		# swap-pair: another owned or felt move leaves the same position (a click cycles them)
		var sw := MatGlyph.make("swap", Vector2(26, 20))
		sw.name = "Swap"
		sw.position = Vector2(ew - 34.0, 56)
		pic.add_child(sw)
	body.add_child(top)
	var row := UI.hbox(4)
	var st := str(inf["state"])
	if st == "learning" or st == "ahead":
		row.add_child(UI.chip("learning %d" % int(inf["m"]), ""))
	else:
		row.add_child(UI.chip(str(inf["word"]), str(WORD_CHIP[str(inf["word"])])))
	row.add_child(UI.spacer())
	row.add_child(UI.label("tap" if bool(inf["tap"]) else "+%d" % int(inf["pts"]), UI.SMALL, UI.GREEN if bool(inf["tap"]) else UI.FG, "bold"))
	body.add_child(row)
	var miss := UI.label(str(inf["miss"]), 12, UI.RED if bool(inf["costly"]) else UI.MUTED, "italic")
	miss.clip_text = true
	body.add_child(miss)
	b.add_child(v)
	card.add_child(b)
	b.pressed.connect(func(): _swap(i))
	b.mouse_entered.connect(func(): _hover(str(inf["id"]), card, i))
	b.mouse_exited.connect(func(): _hover("", card))
	return card


## Next owned or felt alternative at the fork; the rest re-filled from where it lands.
func _swap(i: int) -> void:
	var eid := str(steps[i])
	var alts := Info.alternatives(f, eid)
	if alts.size() < 2:
		_hint.text = "No other owned or felt move from %s." % str(BjjTree.node(str(BjjTree.edge(eid)["from"])).get("name", "")).to_lower()
		return
	var goal := Info.plan_goal(f)
	var head: Array = []
	# swap-pairs lead to the same goal: the next alternative whose rest still gets there, else simply the next one
	for k in range(1, alts.size()):
		var nxt := str(alts[(alts.find(eid) + k) % alts.size()])
		var h: Array = steps.slice(0, i)
		h.append(nxt)
		var to := str(BjjTree.edge(nxt)["ok"])
		var rest: Array = []
		if not BjjTree.is_ending(to) and Info.count_steps(h) < Info.MAX_STEPS:
			rest = Info.complete_from(f, to, goal, Info.MAX_STEPS - Info.count_steps(h))
		if head.is_empty():
			head = h + rest
		if not rest.is_empty() or to == "tap_win" or to == str(Info.GOAL_NODE.get(goal, "")):
			head = h + rest
			break
	_apply_plan(goal, head)


func _undo() -> void:
	if steps.is_empty():
		return
	var st := steps.slice(0, steps.size() - 1)
	if st.is_empty():
		f.erase("bjj_plan")
		refresh()
		return
	_apply_plan(Info.plan_goal(f), st)


# --- map ---------------------------------------------------------------------------------------------------------------

func _on_node(n: String) -> void:
	_sel[str(f.get("id", ""))] = n
	refresh()


## An arrow out of the plan's end joins the plan; any other arrow selects where it lands.
func _on_map_edge(eid: String) -> void:
	var e := BjjTree.edge(eid)
	var st := Info.edge_state(f, e, Info.rules(f))
	if str(e["from"]) == _end_node() and not BjjTree.is_ending(_end_node()):
		if st in ["learning", "ahead", "illegal"]:
			_hint.text = "%s %d: %s - drill it to felt (%d) before it goes in the plan." % [BjjTree.move_name(str(e["move"])),
				int(BjjTree.mastery(f, str(e["move"]))), "Union rules: not at this belt" if st == "illegal" else st, int(BjjTree.T["FELT"])]
			return
		if Info.count_steps(steps) >= Info.MAX_STEPS and not BjjTree.is_base(str(e["move"])):
			_hint.text = "The plan holds %d moves." % Info.MAX_STEPS
			return
		var st2 := steps.duplicate()
		st2.append(eid)
		_sel[str(f.get("id", ""))] = str(e["ok"])
		_apply_plan(Info.plan_goal(f), st2)
		return
	_on_node(str(e["ok"]))


func _hover(eid: String, c: Control, i: int = -1) -> void:
	if eid == "":
		_tip.visible = false
		return
	var inf := Info.step_info(f, steps, i, _holes) if i >= 0 else Info.step_info(f, [eid], 0, _holes)
	UI.clear(_tip)
	var v := UI.vbox(4)
	v.name = "TipBody"
	var title := str(inf["name"]) + (" - step %d" % int(inf["step"]) if i >= 0 and not bool(inf["base"]) else "")
	v.add_child(UI.label(title.to_upper(), 17, UI.FG, "display"))
	for line in Info.tip_lines(inf):
		var l := UI.label(str(line), UI.SMALL, UI.RED if str(line).contains("(a hole)") else UI.FG, "semi")
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size = Vector2(TIP_W - 24.0, 0)
		v.add_child(l)
	var st := str(inf["state"])
	if st != "base":
		v.add_child(UI.muted("%s %d - %s" % [BjjTree.move_name(str(inf["move"])), int(inf["m"]), st], UI.TINY))
	_tip.add_child(v)
	_tip.size = Vector2(TIP_W, 0)
	_tip.reset_size()
	var vp := get_viewport_rect().size
	var pos := c.global_position + Vector2(c.size.x * 0.5 - 150.0, c.size.y + 6.0)
	_tip.global_position = Vector2(clampf(pos.x, 4.0, vp.x - 310.0), clampf(pos.y, 4.0, vp.y - 160.0))
	_tip.visible = true
	if play_edge.is_valid():
		play_edge.call(eid)


# --- leaks -------------------------------------------------------------------------------------------------------------

func _leak_row() -> void:
	UI.clear(_leaks)
	var cap := UI.caps("LEAKS")
	cap.custom_minimum_size = Vector2(52, 0)
	_leaks.add_child(cap)
	var lks := Info.leaks(f, day)
	for n in lks.size():
		_leaks.add_child(_leak_tile(n, lks[n]))
	if lks.is_empty():
		_leaks.add_child(UI.muted("No hole cost anything in the field's walks.", UI.SMALL))


func _leak_tile(n: int, lk: Dictionary) -> Control:
	var card := MatCard.new()
	card.name = "Leak_%d" % n
	card.dash = true
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size = Vector2(0, 96)
	card.add_theme_stylebox_override("panel", UI.box(UI.PANEL, Color(0, 0, 0, 0), 8, 0, 8, 8))
	var h := UI.hbox(8)
	var node := str(lk["node"])
	h.add_child(MatGlyph.make(MatGlyph.node_kind(node, str(BjjTree.node(node).get("side", ""))), Vector2(64, 64)))
	var v := UI.vbox(2)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(UI.label(str(BjjTree.node(node).get("name", node)).to_upper(), 15, UI.FG, "display"))
	var line := UI.label(Info.leak_line(f, lk), 12, UI.FG, "italic", true)
	v.add_child(line)
	var plan := BjjTree.drill_plan_for(f, str(lk["move"]))
	var on := str(f.get("drill", "")) == plan
	var d := UI.button("Drilling" if on else "Drill", "BtnSolid" if on else "Btn", _drill.bind(plan, str(lk["move"])))
	d.name = "LeakDrill_%d" % n
	d.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(d)
	h.add_child(v)
	card.add_child(h)
	return card

