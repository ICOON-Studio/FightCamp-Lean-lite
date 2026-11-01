extends Control
## S337 the boxing move map (operator Q-S294-61 "Yes, in that order", step 2): StrikeMap's 8 position cards drawn as a map, an
## arrow for every move between them; pick a card and its MOVES OUT (what she can throw or do from here, and where it lands)
## and MOVES IN show beside it, a move she cannot use yet greyed with its reason. Clicking a move walks to its card and adds it
## to the route along the bottom - the start of the coach's whiteboard plan (step 4). Open with `FightCamp.exe -- jump=strikemap`.
## Plan mode (step 4): Build plan adds arrows on the map; `-- jump=strikemap plan=1` opens in plan mode.
## S339 her plan: for_fighter() opens it over the game for one fighter - her punches, her pad time, the gym coach's arrow
## limit, her saved plan (or the coach's starter); one arrow per card (a new move from a card replaces its arrow); Save
## plan writes it on her (f["arrows"], PlanFight in the bout), Back leaves it as it was.
## S341 branches (fight flows step 2): the WHEN picker sets the opponent's game the next arrow answers ("Any time" or "If
## she presses", "If she tires"...); a card holds one arrow per situation plus one any-time arrow, PlanFight throws the
## situation's.

const UI := preload("res://scripts/ui/UI.gd")
const Map := preload("res://scripts/rules/StrikeMap.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanPanel := preload("res://scripts/ui/PlanPanel.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const FlowView := preload("res://scripts/ui/FlowView.gd")
const Data := preload("res://scripts/state/Data.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const MapLegend := preload("res://scripts/ui/MapLegend.gd")
const PANEL_W := 470
## Her punches for the prototype (mastery 0-100; a combo opens when each of its punches reaches Combos.LEARN_AT, 30).
const DEMO_MASTERY := {"Jab": 60.0, "Cross": 55.0, "Lead hook": 45.0, "Body hook": 25.0, "Uppercut": 10.0, "Check hook": 0.0}
## Prototype coach skill for arrow limit (`-- coach=<0-100>` overrides).
const DEMO_COACH := 55.0
## Where each card sits on the map (0..1 of the map's size): the ranges left to right, the ring places below.
const SPOT := {"outside": Vector2(0.10, 0.28), "long": Vector2(0.30, 0.28), "mid": Vector2(0.50, 0.28), "inside": Vector2(0.70, 0.28),
	"clinch": Vector2(0.90, 0.28), "own_ropes": Vector2(0.22, 0.74), "opp_ropes": Vector2(0.55, 0.74), "corner": Vector2(0.86, 0.74)}
const CARD := Vector2(236, 92)

## S348 the Playbook (Q-S294-71) holds this map as a part of its page: a picked move plays on its player; no Back (the page
## has the menu); `start_plan` false = the Moves tab (walk the map), true = the Plans tab (her board).
signal move_picked(move_id: String)
var embedded := false
var start_plan := true

var current := "outside"
var route: Array = []      # [card, move name, card, ...] as walked
var plan: Array = []       # [{"move": row id, "when": situation (optional)}, ...]
var when := ""             # S341 the situation the next arrow answers ("" = any time)
var templates := false     # S341 the side panel lists the real fight plans (PlanTemplates) instead of the card's moves
var plan_mode := false
var coach_skill := DEMO_COACH
var mastery: Dictionary = DEMO_MASTERY
var combos: Dictionary = {}
var fighter: Dictionary = {}
var main: Node = null
var _map: Control
var _side: VBoxContainer
var _route_label: Label
var _plan_toggle: Button


func _ready() -> void:
	theme = UI.theme()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = UI.BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var rows := UI.vbox(0)
	rows.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(rows)
	rows.add_child(_top_bar())
	var body := UI.hbox(0)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rows.add_child(body)
	_map = Control.new()
	_map.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_map.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_map.draw.connect(_draw_arrows)
	_map.resized.connect(_layout)
	body.add_child(_map)
	body.add_child(_panel())
	var foot := PanelContainer.new()
	foot.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 10))
	_route_label = UI.label("", UI.SMALL, UI.FG, "body", true)
	foot.add_child(_route_label)
	rows.add_child(foot)
	for arg in OS.get_cmdline_user_args():
		var s := str(arg)
		if s.begins_with("coach="):
			coach_skill = clampf(float(s.get_slice("=", 1)), 0.0, 100.0)
	go(current)
	if OS.get_cmdline_user_args().has("plan=1") or (not fighter.is_empty() and start_plan):
		_set_plan_mode(true)


## Opens the board on one fighter's plan (call before adding it to the tree). m = Main.
func for_fighter(m: Node, f: Dictionary) -> void:
	main = m
	fighter = f
	mastery = f.get("moves", {})
	combos = f.get("combos", {})
	coach_skill = float((m.career as Career).coach.get("rating", 0.0))
	var saved: Array = f.get("arrows", [])
	plan = (saved if not saved.is_empty() else PlanFight.starter()).duplicate(true)
	current = "long"


func _top_bar() -> Control:
	var bar := PanelContainer.new()
	bar.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 10))
	var h := UI.hbox(6)
	bar.add_child(h)
	if fighter.is_empty():
		h.add_child(UI.label("BOXING MOVE MAP", 22, UI.FG, "bold"))
		h.add_child(UI.muted("  prototype - her punches: Jab 60, Cross 55, Lead hook 45, Body hook 25, Uppercut 10  "))
		h.add_child(UI.spacer())
		_plan_toggle = UI.button("Build plan", "Btn", func(): _set_plan_mode(not plan_mode))
		h.add_child(_plan_toggle)
		h.add_child(UI.button("Start again", "BtnQuiet", func(): route.clear(); plan.clear(); go("outside")))
		return bar
	var title := ("HER MOVES" if not start_plan else "HER PLAN") if embedded else "THE PLAN: %s" % str(fighter["name"]).to_upper()
	h.add_child(UI.label(title, 22, UI.FG, "bold"))
	var punches := PackedStringArray()
	for mv in Data.MOVES:
		punches.append("%s %d" % [mv, int(float(mastery.get(mv, 0.0)))])
	h.add_child(UI.muted("  her punches: " + ", ".join(punches) + "  "))
	h.add_child(UI.spacer())
	h.add_child(UI.button("Real fight plans", "Btn", func(): templates = not templates; go(current)))
	h.add_child(UI.button("See the flow", "Btn", show_flow))
	h.add_child(UI.button("Clear", "BtnQuiet", func(): plan.clear(); go(current)))
	if not embedded:
		h.add_child(UI.button("Back", "Btn", _close))
	if start_plan or not embedded:
		h.add_child(UI.button("Save plan", "BtnSolid", _save))
	return bar


## S340 the plan as a flow on the whiteboard (FightFlow): from long range, where a bout opens, in the order she gets there.
func show_flow() -> void:
	var v := FlowView.new()
	v.setup(FightFlow.build(plan, Map.MOVES, "long"), {"title": "THE FLOW: %s" % (str(fighter["name"]).to_upper() if not fighter.is_empty() else "THE PLAN"),
		"sub": "%d arrows, read top to bottom" % plan.size(), "place_name": _place_name,
		"move_name": func(id: String) -> String: return str(Map.move(id).get("name", id)),
		"try": _try_combos})
	add_child(v)


## S349 C201: the flow's Try combos opens the Playbook's Combos tab (a full-screen plan board closes first).
func _try_combos() -> void:
	if not embedded:
		_close()
	main.act("go", "playbook:2")


## Writes the plan on her when it is legal (else says why); she fights to it from her next bout.
func _save() -> void:
	var v := PlanBoard.validate(plan, Map.MOVES, _arrow_limit(), FightFlow.WHEN_WORDS)
	if not v["ok"]:
		main.toast(str(v["problems"][0]))
		return
	fighter["arrows"] = plan.duplicate(true)
	_close()
	main.toast("%s's plan saved: %d arrows. She fights to it from her next bout; the corner can change one a round." % [
		fighter["first"], plan.size()])


func _close() -> void:
	if not embedded:
		queue_free()
	if main != null:
		main.render()


func _set_plan_mode(on: bool) -> void:
	plan_mode = on
	if _plan_toggle:
		_plan_toggle.text = "Done" if plan_mode else "Build plan"
	go(current)


func _panel() -> Control:
	var p := PanelContainer.new()
	p.custom_minimum_size = Vector2(_pw(), 0)
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 14))
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	p.add_child(scroll)
	_side = UI.vbox(8)
	_side.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_side)
	return p


func _arrow_limit() -> int:
	return PlanBoard.arrow_limit(coach_skill)


func _drilled() -> Array:
	var ids: Array = []
	for m in Map.MOVES:
		var id := str(m["id"])
		# Her board: a combination counts as drilled with its pad time (Combos.LEARN_AT); the prototype: every move she can throw.
		if (PlanFight.rate(id, combos) >= 1.0 and Map.grey_reason(m, mastery) == "") if not fighter.is_empty() else Map.grey_reason(m, mastery) == "":
			ids.append(id)
	return ids


## The plan's arrow from this card for the picked situation (one per card and when), or -1.
func _arrow_at(card_id: String) -> int:
	for i in plan.size():
		if str(PlanBoard.row(Map.MOVES, str(plan[i]["move"])).get("from", "")) == card_id and str(plan[i].get("when", "")) == when:
			return i
	return -1


## S341 the WHEN picker: which of the opponent's games the next arrow answers.
func _when_picker() -> Control:
	var box := UI.vbox(6)
	var head := UI.hbox(6)
	head.add_child(UI.caps("WHEN"))
	head.add_child(Icons.icon("info", 16, UI.MUTED, "The next move you pick is her answer to this.\nAny time: she throws it whatever the opponent does."))
	box.add_child(head)
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 4)
	flow.add_theme_constant_override("v_separation", 4)
	box.add_child(flow)
	var ids: Array = [""] + FightFlow.WHEN_WORDS.keys()
	for id in ids:
		var key := str(id)
		var words := "Any time" if key == "" else str(FightFlow.WHEN_WORDS[key])
		flow.add_child(UI.button(words, "PillOn" if key == when else "Pill", func(): when = key; go(current)))
	# S344 (operator C174 on the WHEN pills: "make it clear to the player what it does"): what the pick does, said live.
	var said := "Your next move: she throws it any time here." if when == "" else \
		"Your next move: she throws it only when %s - her answer to that." % str(FightFlow.WHEN_WORDS.get(when, when))
	var line := UI.label(said, UI.SMALL, UI.GOLD, "semi", true)
	line.name = "WhenSays"
	box.add_child(line)
	return box


func _place_name(id: String) -> String:
	return str(Map.card(id).get("name", id))


func _remove_arrow(index: int) -> void:
	if index < 0 or index >= plan.size():
		return
	plan.remove_at(index)
	go(current)


## Show a card: the map lit on it, its moves out and in on the right.
func go(card_id: String) -> void:
	current = card_id
	if route.is_empty():
		route.append(Map.card(card_id)["name"])
	_layout()
	UI.clear(_side)
	var c := Map.card(card_id)
	_side.add_child(UI.caps("POSITION"))
	_side.add_child(UI.label(str(c["name"]), 28, UI.FG, "bold", true))
	var r: Array = c["range_m"]
	_side.add_child(UI.muted(str(c["what"]) + ("" if r.is_empty() else "  (%.2f - %.2f m apart)" % [r[0], r[1]]), UI.TINY, true))
	if plan_mode and templates:
		_side.add_child(UI.sep())
		_side.add_child(_template_list())
		_route_label.text = "YOUR ROUTE:  " + "  >  ".join(route)
		return
	if plan_mode:
		_side.add_child(UI.sep())
		_side.add_child(_when_picker())
		_side.add_child(UI.sep())
		_side.add_child(PlanPanel.build(Map.MOVES, plan, _arrow_limit(), _drilled(), _place_name, _remove_arrow, FightFlow.WHEN_WORDS))
		_side.add_child(UI.sep())
	_moves("MOVES OUT", Map.outs(card_id), true)
	_moves("MOVES IN", Map.ins(card_id), false)
	_route_label.text = "YOUR ROUTE:  " + "  >  ".join(route)


func _moves(title: String, rows: Array, out: bool) -> void:
	_side.add_child(UI.sep())
	_side.add_child(UI.caps("%s  (%d)" % [title, rows.size()]))
	var limit := _arrow_limit()
	var full_reason := "The plan is full (%d arrows for this coach)" % limit
	for row in rows:
		var m: Dictionary = row
		var other: String = str(m["to"]) if out else str(m["from"])
		var mastery_why := Map.grey_reason(m, mastery) if out else ""
		var why := mastery_why
		if out and plan_mode and why == "" and plan.size() >= limit and not plan.any(func(a): return _same(a, str(m["id"]))) \
				and (fighter.is_empty() or _arrow_at(str(m["from"])) < 0):
			why = full_reason
		var small := ("to " if out else "from ") + str(Map.card(other)["name"]) + ("" if str(m["kind"]) == "combo" else "  (" + str(m["kind"]) + ")")
		var disabled := why != ""
		var b := UI.button2(str(m["name"]), small, "Choice", func(): _take(m, out), Vector2(_pw() - 50, 58), UI.FG, UI.MUTED,
			disabled, UI.SMALL, UI.TINY, why)
		# S338: button2 already writes the reason under the name (GREYWHY1); a second label repeated it.
		_side.add_child(b)


## A move out walks to where it lands (the route grows); a move in jumps back to where it starts.
## In plan mode a move out adds a plan arrow and walks without growing the route.
func _take(m: Dictionary, out: bool) -> void:
	move_picked.emit(str(m["id"]))
	if out and plan_mode:
		# S338 still: the same move went on the plan twice; a planned move just walks.
		var planned := plan.any(func(a): return _same(a, str(m["id"])))
		var here := _arrow_at(str(m["from"])) if not fighter.is_empty() else -1
		if not planned and here >= 0:
			plan = PlanBoard.change_one(plan, here, str(m["id"]))   # S339 her board: one arrow per card
		elif not planned and plan.size() >= _arrow_limit():
			return
		elif not planned:
			plan.append({"move": str(m["id"]), "when": when} if when != "" else {"move": str(m["id"])})
		go(str(m["to"]))
		return
	if out:
		route.append(str(m["name"]))
		route.append(str(Map.card(str(m["to"]))["name"]))
		go(str(m["to"]))
	else:
		route.clear()
		go(str(m["from"]))


## S341 the real fight plans (PlanTemplates, REALPLANS_S341.md): name, the fights it comes from, the coach's idea, Load.
## The ones made for her next opponent's game (her file's free "Her game" tell) come first, marked.
func _template_list() -> Control:
	var box := UI.vbox(10)
	box.add_child(UI.caps("REAL FIGHT PLANS"))
	var opp: Dictionary = (fighter.get("bout", {}) as Dictionary).get("opp", {})
	var game := OppFile.main_game(opp) if not opp.is_empty() else ""
	var mine: Array = PlanTemplates.for_game(game)
	if game != "":
		box.add_child(UI.muted("Her next opponent, %s: %s." % [opp.get("first", "?"), str(OppFile.GAME_WORDS.get(game, game))], UI.SMALL, true))
	var rows: Array = PlanTemplates.BOXING.duplicate()
	rows.sort_custom(func(a, b): return mine.has(a["id"]) and not mine.has(b["id"]))
	for t in rows:
		var tt: Dictionary = t
		var n := mini((t["arrows"] as Array).size(), _arrow_limit())
		var row := UI.hbox(6)
		var is_mine: bool = mine.has(t["id"])
		row.add_child(Icons.icon("target" if is_mine else "play", 16, UI.GOLD if is_mine else UI.LINE, "Made for her next opponent's game." if is_mine else ""))
		var name := UI.label(str(t["name"]), UI.SMALL, UI.GOLD if is_mine else UI.FG, "semi", true)
		name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(Icons.tip(name, "From %s\n%s" % [t["from"], t["idea"]]))
		row.add_child(Icons.button("load", "Load it: %d arrows onto her board" % n, func():
			plan = PlanTemplates.load(tt, _arrow_limit(), plan, Map.MOVES)
			templates = false
			go(current)))
		box.add_child(row)
	return box


## This arrow is the move for the picked situation.
func _same(a: Dictionary, move_id: String) -> bool:
	return str(a["move"]) == move_id and str(a.get("when", "")) == when


## ---------- the map ----------

## S348 a card never wider than its slot (five range cards share a row): the Playbook's map is narrower than the full screen.
## The ring places' row holds three cards, so they may be wider (arrows reach them from above: the height sets the edge).
func _card(id := "") -> Vector2:
	var share := 0.28 if id in ["own_ropes", "opp_ropes", "corner"] else 0.18
	return Vector2(minf(CARD.x, _map.size.x * share), CARD.y) if _map != null else CARD


func _pw() -> int:
	return 360 if embedded else PANEL_W


func _layout() -> void:
	if _map == null:
		return
	UI.clear(_map)
	for c in Map.CARDS:
		var id := str(c["id"])
		var at: Vector2 = SPOT[id] * _map.size - _card(id) * 0.5
		var lit := id == current
		var b := UI.button2(str(c["name"]), "%d out  %d in" % [Map.outs(id).size(), Map.ins(id).size()], "ChoiceOn" if lit else "Choice",
			func(): route.clear(); go(id), _card(id), UI.FG, UI.MUTED, false, UI.BODY, UI.TINY)
		b.position = at
		b.tooltip_text = "%d moves start here, %d end here" % [Map.outs(id).size(), Map.ins(id).size()]
		_map.add_child(b)
	# S342 the key (operator C161 "can we have more explaining on this"), in the map's empty bottom-left.
	var key := MapLegend.build(plan_mode)
	_map.add_child(key)
	key.anchor_top = 1.0
	key.anchor_bottom = 1.0
	key.grow_vertical = Control.GROW_DIRECTION_BEGIN
	key.offset_left = 16.0
	key.offset_bottom = -16.0
	_map.queue_redraw()


func _draw_plan_arrow(from_id: String, to_id: String, branch := false) -> void:
	var a: Vector2 = SPOT[from_id] * _map.size
	var b: Vector2 = SPOT[to_id] * _map.size
	# S338: the plan in the coach's marker green, apart from the lit card's blue moves; a move that stays on its card
	# (8 of 30: feints, combos that end where they start) is a loop over the card, else it never shows on the map.
	# S341: a branch (an arrow for one of her games) is a lighter, thinner line beside the any-time arrow.
	var col := Color(UI.GREEN, 0.55) if branch else UI.GREEN
	var w := 3.0 if branch else 5.0
	if a == b:
		var c := a - Vector2(0, _card().y * 0.5 + 16.0)
		_map.draw_arc(c, 14.0, PI * 0.15, PI * 1.85, 24, col, 4.0, true)
		var tip := c + Vector2(cos(PI * 0.15), sin(PI * 0.15)) * 14.0
		_map.draw_colored_polygon(PackedVector2Array([tip + Vector2(0, 7), tip + Vector2(-8, -3), tip + Vector2(8, -3)]), col)
		return
	var dir := (b - a).normalized()
	var side := Vector2(-dir.y, dir.x) * (18.0 if branch else 10.0)
	var edge := minf(_card().x * 0.5 / maxf(absf(dir.x), 1e-3), _card().y * 0.5 / maxf(absf(dir.y), 1e-3)) + 4.0
	var p0 := a + dir * edge + side
	var p1 := b - dir * edge + side
	_map.draw_line(p0, p1, col, w, true)
	_map.draw_colored_polygon(PackedVector2Array([p1, p1 - dir * 16.0 + Vector2(-dir.y, dir.x) * 8.0,
		p1 - dir * 16.0 - Vector2(-dir.y, dir.x) * 8.0]), col)


## An arrow for every move between two cards; the lit card's moves out drawn in gold; plan arrows drawn thick on top.
func _draw_arrows() -> void:
	for m in Map.MOVES:
		var a: Vector2 = SPOT[str(m["from"])] * _map.size
		var b: Vector2 = SPOT[str(m["to"])] * _map.size
		if a == b:
			continue
		# Her own moves out of the lit card in blue ink; what happens TO her (forced) stays grey.
		var out := str(m["from"]) == current and str(m["kind"]) != "forced"
		var col := UI.GOLD if out else Color(UI.MUTED, 0.35)
		var dir := (b - a).normalized()
		# Start and end just outside the card edges, nudged sideways so a pair of opposite moves do not overlap.
		var side := Vector2(-dir.y, dir.x) * 6.0
		var edge := minf(_card().x * 0.5 / maxf(absf(dir.x), 1e-3), _card().y * 0.5 / maxf(absf(dir.y), 1e-3)) + 4.0
		var p0 := a + dir * edge + side
		var p1 := b - dir * edge + side
		_map.draw_line(p0, p1, col, 3.0 if out else 1.5, true)
		_map.draw_colored_polygon(PackedVector2Array([p1, p1 - dir * 14.0 + Vector2(-dir.y, dir.x) * 7.0,
			p1 - dir * 14.0 - Vector2(-dir.y, dir.x) * 7.0]), col)
	for arrow in plan:
		var row := PlanBoard.row(Map.MOVES, str(arrow["move"]))
		if row.is_empty():
			continue
		_draw_plan_arrow(str(row["from"]), str(row["to"]), str(arrow.get("when", "")) != "")
