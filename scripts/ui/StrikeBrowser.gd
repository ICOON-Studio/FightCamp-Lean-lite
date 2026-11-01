extends Control
## S337 the boxing move map (operator Q-S294-61 "Yes, in that order", step 2): StrikeMap's 8 position cards drawn as a map, an
## arrow for every move between them; pick a card and its MOVES OUT (what she can throw or do from here, and where it lands)
## and MOVES IN show beside it, a move she cannot use yet greyed with its reason. Clicking a move walks to its card and adds it
## to the route along the bottom - the start of the coach's whiteboard plan (step 4). Open with `FightCamp.exe -- jump=strikemap`.

const UI := preload("res://scripts/ui/UI.gd")
const Map := preload("res://scripts/rules/StrikeMap.gd")
const PANEL_W := 470
## Her punches for the prototype (mastery 0-100; a combo opens when each of its punches reaches Combos.LEARN_AT, 30).
const DEMO_MASTERY := {"Jab": 60.0, "Cross": 55.0, "Lead hook": 45.0, "Body hook": 25.0, "Uppercut": 10.0, "Check hook": 0.0}
## Where each card sits on the map (0..1 of the map's size): the ranges left to right, the ring places below.
const SPOT := {"outside": Vector2(0.10, 0.28), "long": Vector2(0.30, 0.28), "mid": Vector2(0.50, 0.28), "inside": Vector2(0.70, 0.28),
	"clinch": Vector2(0.90, 0.28), "own_ropes": Vector2(0.22, 0.74), "opp_ropes": Vector2(0.55, 0.74), "corner": Vector2(0.86, 0.74)}
const CARD := Vector2(236, 92)

var current := "outside"
var route: Array = []      # [card, move name, card, ...] as walked
var _map: Control
var _side: VBoxContainer
var _route_label: Label


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
	go(current)


func _top_bar() -> Control:
	var bar := PanelContainer.new()
	bar.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 10))
	var h := UI.hbox(6)
	bar.add_child(h)
	h.add_child(UI.label("BOXING MOVE MAP", 22, UI.FG, "bold"))
	h.add_child(UI.muted("  prototype - her punches: Jab 60, Cross 55, Lead hook 45, Body hook 25, Uppercut 10  "))
	h.add_child(UI.spacer())
	h.add_child(UI.button("Start again", "BtnQuiet", func(): route.clear(); go("outside")))
	return bar


func _panel() -> Control:
	var p := PanelContainer.new()
	p.custom_minimum_size = Vector2(PANEL_W, 0)
	p.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.LINE, 0, 1, 18, 14))
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	p.add_child(scroll)
	_side = UI.vbox(8)
	_side.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_side)
	return p


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
	_moves("MOVES OUT", Map.outs(card_id), true)
	_moves("MOVES IN", Map.ins(card_id), false)
	_route_label.text = "YOUR ROUTE:  " + "  >  ".join(route)


func _moves(title: String, rows: Array, out: bool) -> void:
	_side.add_child(UI.sep())
	_side.add_child(UI.caps("%s  (%d)" % [title, rows.size()]))
	for row in rows:
		var m: Dictionary = row
		var other: String = str(m["to"]) if out else str(m["from"])
		var why := Map.grey_reason(m, DEMO_MASTERY) if out else ""
		var small := ("to " if out else "from ") + str(Map.card(other)["name"]) + ("" if str(m["kind"]) == "combo" else "  (" + str(m["kind"]) + ")")
		var b := UI.button2(str(m["name"]), small, "Choice", func(): _take(m, out), Vector2(PANEL_W - 50, 58), UI.FG, UI.MUTED,
			why != "", UI.SMALL, UI.TINY)
		if why != "":
			b.tooltip_text = why
			_side.add_child(b)
			_side.add_child(UI.label("    " + why, UI.TINY, UI.GOLD, "body", true))
		else:
			_side.add_child(b)


## A move out walks to where it lands (the route grows); a move in jumps back to where it starts.
func _take(m: Dictionary, out: bool) -> void:
	if out:
		route.append(str(m["name"]))
		route.append(str(Map.card(str(m["to"]))["name"]))
		go(str(m["to"]))
	else:
		route.clear()
		go(str(m["from"]))


## ---------- the map ----------

func _layout() -> void:
	if _map == null:
		return
	UI.clear(_map)
	for c in Map.CARDS:
		var id := str(c["id"])
		var at: Vector2 = SPOT[id] * _map.size - CARD * 0.5
		var lit := id == current
		var b := UI.button2(str(c["name"]), "%d out  %d in" % [Map.outs(id).size(), Map.ins(id).size()], "ChoiceOn" if lit else "Choice",
			func(): route.clear(); go(id), CARD, UI.FG, UI.MUTED, false, UI.BODY, UI.TINY)
		b.position = at
		_map.add_child(b)
	_map.queue_redraw()


## An arrow for every move between two cards; the lit card's moves out drawn in gold.
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
		var edge := minf(CARD.x * 0.5 / maxf(absf(dir.x), 1e-3), CARD.y * 0.5 / maxf(absf(dir.y), 1e-3)) + 4.0
		var p0 := a + dir * edge + side
		var p1 := b - dir * edge + side
		_map.draw_line(p0, p1, col, 3.0 if out else 1.5, true)
		_map.draw_colored_polygon(PackedVector2Array([p1, p1 - dir * 14.0 + Vector2(-dir.y, dir.x) * 7.0,
			p1 - dir * 14.0 - Vector2(-dir.y, dir.x) * 7.0]), col)
