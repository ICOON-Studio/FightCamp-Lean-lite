extends Node
## S318 the body map live (operator S316: "a body visual ... real time interactive on where the hits are being taken and
## changing colour on that area"; plan Q-S294-29 "Yes, build it", Game Godot/research/S316_BODY_MAP_PLAN.md step 2).
## Keeps the bout's BodyMap (six places a boxer, over all its rounds) and a BodyFigure per boxer in the scorebug panel:
## a landed punch takes its points at the glove's contact and the struck place flashes, then holds its band colour.
##   attach(view) -> BodyLive   land(beat, at_s)   bell()   map (the corner card reads it)

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const BodyTrack := preload("res://scripts/rules/BodyTrack.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

## S320 (operator C145: "each of these needs to be on each fighters side"): each boxer's figure stands at her own edge
## of the screen - hers (red) on the left under the scorebug, the opponent's (blue) on the right - drawn on her own body
## (C146: "we have real andropoid,use it"; BodyFigure.portrait_for).
const FIG_SIZE := Vector2(210, 294)   # S324 C149 "needs to be bigger" (was 150 x 210)
const TOP := 214.0
const EDGE := 28.0
const CORNER := ["red", "blue"]

var view: Control
var map: Dictionary = BodyMap.fresh()
var figures: Array = []
var panels: Array = []   # S320 the two side panels (FightView.hide_hud hides them with the rest)
## S320 (operator: "key stats shown during the fight would be nice so the player can push his strategy according to
## those"): TV punch stats (CompuBox style) under each figure, the fight so far: thrown/landed, jabs, power, to the body.
var stats := [{"thrown": 0, "landed": 0, "jab_t": 0, "jab_l": 0, "pow_t": 0, "pow_l": 0, "body": 0},
	{"thrown": 0, "landed": 0, "jab_t": 0, "jab_l": 0, "pow_t": 0, "pow_l": 0, "body": 0}]
var _stat_labels: Array = []


static func attach(v: Control) -> Node:
	var bl := new()
	bl.name = "BodyLive"
	bl.view = v
	v.add_child(bl)
	bl._build()
	return bl


func _build() -> void:
	# S320 the round and result pages draw the bout's body map too (RoundGraphics.body): the modal shares the map.
	if view.get("main") != null:
		view.main.modal["body_map"] = map
		view.main.modal["bodies"] = view.get("bodies")
	for side in 2:
		var panel := PanelContainer.new()
		panel.name = "BodyPanel%d" % side
		panel.add_theme_stylebox_override("panel", UI.box(Color(0.06, 0.05, 0.05, 0.72), UI.LINE, 6, 1, 8, 6))
		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 2)
		panel.add_child(col)
		var fig: Control = BodyFigure.new()
		fig.custom_minimum_size = FIG_SIZE
		fig.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		fig.set_portrait(BodyFigure.portrait_for(str(view.get("bodies")[side]) if view.get("bodies") != null else "", CORNER[side]))
		col.add_child(fig)
		col.add_child(_track_key())
		var who := UI.label(str(view._names[side]).get_slice(" ", 0).to_upper(), UI.TINY, Color(0.95, 0.4, 0.35) if side == 0 else Color(0.5, 0.65, 1.0), "bold")
		who.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(who)
		var st := UI.mono("", UI.TINY, UI.FG)
		st.add_theme_constant_override("line_spacing", -2)
		col.add_child(st)
		_stat_labels.append(st)
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
	_paint_stats()


## S323 playtest ("blue = fresh is not obvious"): the body view's key under each figure, in its own colours.
func _track_key() -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 5)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	for pair in [["FRESH", 12.0], ["WARM", 37.5], ["HOT", 62.5], ["BURNING", 87.5]]:
		# S324: a fresh part shows her own skin (BodyFigure.FRESH_END), so FRESH reads in plain grey.
		var c: Color = Color(0.78, 0.78, 0.8) if str(pair[0]) == "FRESH" else BodyTrack.colour(float(pair[1]))
		row.add_child(UI.label(str(pair[0]), 12, c, "bold"))
	return row


## A beat FightView fires; a landed punch reaches the other boxer `at_s` from now (its contact).
func land(b: Dictionary, at_s: float) -> void:
	if not str(b.get("move", "")) in BodyMap.PUNCHES:
		return
	var st: Dictionary = stats[0 if str(b["who"]) == "a" else 1]
	var jab := str(b["move"]) == "jab"
	st["thrown"] += 1
	st["jab_t" if jab else "pow_t"] += 1
	_paint_stats()
	if str(b.get("result", "")) != "lands":
		return
	get_tree().create_timer(maxf(0.0, at_s)).timeout.connect(_apply.bind(b))


func _apply(b: Dictionary) -> void:
	var def := "b" if str(b["who"]) == "a" else "a"
	var st: Dictionary = stats[0 if def == "b" else 1]
	st["landed"] += 1
	st["jab_l" if str(b["move"]) == "jab" else "pow_l"] += 1
	if str(b["move"]).contains("body"):
		st["body"] += 1
	_paint_stats()
	var before := {}
	for p in BodyMap.PLACES:
		before[p] = BodyMap.value(map, def, p)
	var stage: Node = view.stage
	BodyMap.add_beats(map, [b], {"a": bool(stage.boxers[0].get("south", false)), "b": bool(stage.boxers[1].get("south", false))})
	if figures.size() < 2:
		return
	var fig: Control = figures[0 if def == "a" else 1]
	var vals := {}
	for p in BodyMap.PLACES:
		vals[p] = BodyMap.value(map, def, p)
		if float(vals[p]) < float(before[p]):
			fig.hit(p, str(b["move"]).replace("_", " "))
	fig.set_values(vals)


## The two stat blocks: landed/thrown and accuracy, jabs, power punches, to the body.
func _paint_stats() -> void:
	for side in mini(2, _stat_labels.size()):
		var st: Dictionary = stats[side]
		var acc := 0 if int(st["thrown"]) == 0 else int(round(100.0 * int(st["landed"]) / int(st["thrown"])))
		(_stat_labels[side] as Label).text = "LANDED %d/%d %d%%
JABS   %d/%d
POWER  %d/%d
BODY   %d" % [st["landed"], st["thrown"], acc,
			st["jab_l"], st["jab_t"], st["pow_l"], st["pow_t"], st["body"]]


## SKIP ROUND: the round is settled (Bouts "round_out"); its unwatched exchanges are built into the view's beats and
## every punch not yet played lands on the map now, so a skipped round still leaves its marks.
func catch_up() -> void:
	for k in range(int(view._ex_done), Exchanges.EXCHANGES):
		view._queue(view.main.modal, k)
	var rest: Array = (view.beats as Array).slice(int(view.next))
	for b in rest:
		if str(b.get("move", "")) in BodyMap.PUNCHES:
			var st: Dictionary = stats[0 if str(b["who"]) == "a" else 1]
			st["thrown"] += 1
			st["jab_t" if str(b["move"]) == "jab" else "pow_t"] += 1
		if str(b.get("result", "")) == "lands" and str(b.get("move", "")) in BodyMap.PUNCHES:
			_apply(b)
	_paint_stats()
	view.next = (view.beats as Array).size()


## The round's bell: the corner's one-round fixes run out (BodyMap.end_round).
func bell() -> void:
	BodyMap.end_round(map)


## The corner's jobs (CornerOverlay.apply_body) change the map between punches: repaint twice a second.
var _paint_left := 0.0


func _process(delta: float) -> void:
	for p in panels:   # the side panels come and go with the scorebug (intro, corner minute, the result)
		(p as Control).visible = view._bug_box.visible
	_paint_left -= delta
	if _paint_left > 0.0 or figures.size() < 2:
		return
	_paint_left = 0.5
	for side in 2:
		var vals := {}
		for p in BodyMap.PLACES:
			vals[p] = BodyMap.value(map, "a" if side == 0 else "b", p)
		figures[side].set_values(vals)
