extends Node
## S318 the body map live (operator S316: "a body visual ... real time interactive on where the hits are being taken and
## changing colour on that area"; plan Q-S294-29 "Yes, build it", Game Godot/research/S316_BODY_MAP_PLAN.md step 2).
## Keeps the bout's BodyMap (six places a boxer, over all its rounds) and a BodyFigure per boxer in the scorebug panel:
## a landed punch takes its points at the glove's contact and the struck place flashes, then holds its band colour.
##   attach(view) -> BodyLive   land(beat, at_s)   bell()   map (the corner card reads it)

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const BodyFigure := preload("res://scripts/ui/BodyFigure.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

## The figure beside each name in the scorebug (BodyFigure keeps its 90:150 shape inside it).
const FIG_SIZE := Vector2(54, 90)

var view: Control
var map: Dictionary = BodyMap.fresh()
var figures: Array = []


static func attach(v: Control) -> Node:
	var bl := new()
	bl.name = "BodyLive"
	bl.view = v
	v.add_child(bl)
	bl._build()
	return bl


func _build() -> void:
	var box: VBoxContainer = view._bug_box.get_child(0) if view._bug_box.get_child_count() > 0 else null
	if box == null:
		return
	var row := UI.hbox(18)
	for side in 2:
		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 2)
		var fig: Control = BodyFigure.new()
		fig.custom_minimum_size = FIG_SIZE
		fig.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		col.add_child(fig)
		var who := UI.label(str(view._names[side]).get_slice(" ", 0).to_upper(), UI.TINY, Color(0.95, 0.4, 0.35) if side == 0 else Color(0.5, 0.65, 1.0), "bold")
		who.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(who)
		row.add_child(col)
		figures.append(fig)
	box.add_child(row)


## A beat FightView fires; a landed punch reaches the other boxer `at_s` from now (its contact).
func land(b: Dictionary, at_s: float) -> void:
	if str(b.get("result", "")) != "lands" or not str(b.get("move", "")) in BodyMap.PUNCHES:
		return
	get_tree().create_timer(maxf(0.0, at_s)).timeout.connect(_apply.bind(b))


func _apply(b: Dictionary) -> void:
	var def := "b" if str(b["who"]) == "a" else "a"
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


## SKIP ROUND: the round is settled (Bouts "round_out"); its unwatched exchanges are built into the view's beats and
## every punch not yet played lands on the map now, so a skipped round still leaves its marks.
func catch_up() -> void:
	for k in range(int(view._ex_done), Exchanges.EXCHANGES):
		view._queue(view.main.modal, k)
	var rest: Array = (view.beats as Array).slice(int(view.next))
	for b in rest:
		if str(b.get("result", "")) == "lands" and str(b.get("move", "")) in BodyMap.PUNCHES:
			_apply(b)
	view.next = (view.beats as Array).size()


## The round's bell: the corner's one-round fixes run out (BodyMap.end_round).
func bell() -> void:
	BodyMap.end_round(map)


## The corner's jobs (CornerOverlay.apply_body) change the map between punches: repaint twice a second.
var _paint_left := 0.0


func _process(delta: float) -> void:
	_paint_left -= delta
	if _paint_left > 0.0 or figures.size() < 2:
		return
	_paint_left = 0.5
	for side in 2:
		var vals := {}
		for p in BodyMap.PLACES:
			vals[p] = BodyMap.value(map, "a" if side == 0 else "b", p)
		figures[side].set_values(vals)
