extends Node
## S405 the holo on each side of the live round is back (operator: "i told you to put the holo on each side and blink the area
## that gets hit, on critical hits pop up the right organ flashing, and the wholo changes colors on the damaged or tired
## areas"; the S318-S379 panels came out at S381 HOLOOFF, this is their return).
## Each boxer's muscle holo stands at her own edge of the screen under her rings. A landed punch blinks the struck place. A
## critical hit (a big punch, or a place dropping a band) pops that place's organ out, flashing. The figure keeps the colours:
## this round's hits, the damage bands, and the tired parts (BodyBurn's track).
##   attach(view, live) -> BodyPanels   struck(side, before, lost, move, big)   critical_place(before, after, lost, big)

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const BodyTurn := preload("res://scripts/ui/BodyTurn.gd")
const BodyTip := preload("res://scripts/ui/BodyTip.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")
const RoundHits := preload("res://scripts/ui/RoundHits.gd")
const UI := preload("res://scripts/ui/TV.gd")   # the fight's graphics keep the dark TV look

const FIG_SIZE := Vector2(340, 420)
const TOP := 322.0   # clear of her ring meters (HudBars), and it still ends above the shout bar
const EDGE := 28.0
const CORNER := ["red", "blue"]
const CORNER_WHO := ["a", "b"]
const PAINT_S := 0.5   # the corner's jobs and the tired parts change between punches
const KEY_WORDS := "Own colours = fresh. Green = warm, yellow = hot, red = burning: how hard that part has worked.\nRed skin on the face or ribs = hurt there."

var view: Control
var live: Node   # BodyLive: the bout's map, what each place took, the punch stats
var figures: Array = []
var panels: Array = []
var words: Array = []   # S405 the number of punches per area this round, over each figure (RoundHits)
var _paint_left := 0.0


static func attach(v: Control, bl: Node) -> Node:
	var p := new()
	p.name = "BodyPanels"
	p.view = v
	p.live = bl
	v.add_child(p)
	p._build()
	return p


func _build() -> void:
	for side in 2:
		var panel := PanelContainer.new()
		panel.name = "BodyPanel%d" % side
		panel.visible = false   # up with the scorebug (_process)
		panel.mouse_filter = Control.MOUSE_FILTER_PASS
		panel.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.05, 0.28), Color(0, 0, 0, 0), 10, 0, 8, 6))
		var fig: Control = BodyFigure.new()
		fig.custom_minimum_size = FIG_SIZE
		fig.set("blink", true)
		var glb := str(view.get("bodies")[side]) if view.get("bodies") != null else ""
		var still: Dictionary = BodyFigure.portrait_for(glb, CORNER[side])
		if still.get("holo", false) or not BodyTurn.attach(fig, glb, CORNER[side]):
			fig.set_portrait(still)
		panel.add_child(fig)
		fig.tip_fn = _fig_tip.bind(fig, side)
		BodyTip.attach(fig)
		words.append(RoundHits.lay_on(fig, {}))   # S405 operator: "a number on each part ... how many hits each area has received"
		var co := BodyCallouts.attach(fig, still, -1.0 if side == 0 else 1.0, _place_tip.bind(side))
		if co != null:
			co.set("line_fn", _spot_line.bind(side))
			co.set("marks", live.map[CORNER_WHO[side]])
			co.call("go_live")
		view.add_child(panel)
		if side == 0:
			panel.position = Vector2(EDGE, TOP)
		else:
			panel.anchor_left = 1.0
			panel.anchor_right = 1.0
			panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
			panel.offset_left = -EDGE
			panel.offset_right = -EDGE
			panel.offset_top = TOP
		panels.append(panel)
		figures.append(fig)
	_repaint(0)
	_repaint(1)


## The place whose organ pops: on a big punch the place that lost most, otherwise a place that just dropped a damage band;
## "" when neither. Pure.
static func critical_place(before: Dictionary, after: Dictionary, lost: Dictionary, big: bool) -> String:
	var worst := ""
	for p in lost:
		if worst == "" or float(lost[p]) > float(lost[worst]):
			worst = str(p)
	if big:
		return worst
	for p in lost:
		if BodyMap.band(float(after.get(p, 100.0))) != BodyMap.band(float(before.get(p, 100.0))):
			return str(p)
	return ""


## A landed punch on boxer `side`: every struck place blinks, the colours update, and a critical hit pops its organ.
func struck(side: int, before: Dictionary, lost: Dictionary, move: String, big: bool) -> void:
	if figures.size() < 2:
		return
	var fig: Control = figures[side]
	for p in lost:
		fig.hit(p, move.replace("_", " "))
	_repaint(side)
	var co: Node = fig.get_node_or_null("BodyCallouts")
	if co == null:
		return
	var after := {}
	for p in lost:
		after[p] = BodyMap.value(live.map, CORNER_WHO[side], p)
	var place := critical_place(before, after, lost, big)
	if place != "":
		co.call("struck", place)


func _repaint(side: int) -> void:
	var fig: Control = figures[side]
	var round_n := int(view.get("round_n")) if view.get("round_n") != null else 1
	var hits: Dictionary = live.round_hits(side, round_n)
	fig.set("round_hits", hits)
	words[side].set("hits", hits)
	(words[side] as Control).queue_redraw()
	var burn: Node = view.get("burn")
	if burn != null:
		fig.set_track(burn.track(side))
	var vals := {}
	for p in BodyMap.PLACES:
		vals[p] = BodyMap.value(live.map, CORNER_WHO[side], p)
	fig.set_values(vals)
	var st: Dictionary = live.stats[side]
	var acc := 0 if int(st["thrown"]) == 0 else int(round(100.0 * int(st["landed"]) / int(st["thrown"])))
	fig.set("extra_tip", "%s\nLANDED %d/%d %d%%\nJABS   %d/%d\nPOWER  %d/%d\nBODY   %d\n\n%s" % [
		str(view.get("_names")[side]).to_upper(), st["landed"], st["thrown"], acc,
		st["jab_l"], st["jab_t"], st["pow_l"], st["pow_t"], st["body"], KEY_WORDS])


func _place_tip(place: String, side: int) -> String:
	return live.place_tip(live.map, CORNER_WHO[side], live.taken[side], place)


## The figure's tooltip on a place: none where a close-up covers it (that card is the tooltip).
func _fig_tip(place: String, fig: Control, side: int) -> String:
	if fig.get_node_or_null("BodyCallouts") != null and BodyCallouts.spot_of(place) >= 0:
		return ""
	return _place_tip(place, side)


func _spot_line(s: Dictionary, side: int) -> String:
	return live.spot_line(live.map, CORNER_WHO[side], live.taken[side], s)


func _process(delta: float) -> void:
	for p in panels:
		(p as Control).visible = view._bug_box.visible   # they come and go with the scorebug (intro, corner minute, result)
	_paint_left -= delta
	if _paint_left > 0.0 or figures.size() < 2:
		return
	_paint_left = PAINT_S
	_repaint(0)
	_repaint(1)
