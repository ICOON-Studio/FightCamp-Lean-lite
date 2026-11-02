extends RefCounted
## Sport-free plan list for a move map: caps, arrow count, coverage, rows, first validate error.

const UI := preload("res://scripts/ui/UI.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const Icons := preload("res://scripts/ui/Icons.gd")


## `words` names an arrow's when ({"press": "she presses"}): a branch row reads "If she presses: Step back ...".
static func build(map: Array, plan: Array, limit: int, drilled: Array, place_name: Callable, on_remove: Callable, words := {}) -> VBoxContainer:
	var box := UI.vbox(8)
	# S342 trim: one header line (arrows used, map covered - the why on hover), one line an arrow.
	var head := UI.hbox(8)
	head.add_child(UI.caps("THE PLAN"))
	var cov := PlanBoard.coverage(plan, map)
	var used := UI.label("%d / %d arrows  ·  covers %d%%" % [plan.size(), limit, int(round(cov * 100.0))], UI.SMALL, UI.MUTED)
	head.add_child(Icons.tip(used, "The coach can teach %d arrows.\nCovers: the share of the map's positions that have an arrow - where there is no arrow, the fighter improvises." % limit))
	box.add_child(head)
	for i in plan.size():
		box.add_child(_arrow_row(map, plan, i, drilled, place_name, on_remove, words))
	var v := PlanBoard.validate(plan, map, limit, words)
	if not v["ok"] and not v["problems"].is_empty():
		box.add_child(UI.label(str(v["problems"][0]), UI.TINY, UI.GOLD, "body", true))
	return box


static func _arrow_row(map: Array, plan: Array, index: int, drilled: Array, place_name: Callable, on_remove: Callable, words := {}) -> Control:
	var move_id := str(plan[index]["move"])
	var row := PlanBoard.row(map, move_id)
	var from_name: String = place_name.call(str(row.get("from", "?")))
	var to_name: String = place_name.call(str(row.get("to", "?")))
	var move_name := str(row.get("name", move_id))
	var h := UI.hbox(6)
	var w := str(plan[index].get("when", ""))
	if w != "":
		h.add_child(Icons.icon("branch", 16, UI.AMBER, "Only if %s" % str(words.get(w, w))))
	else:
		h.add_child(Icons.icon("play", 14, UI.GREEN, "Any time"))
	var name := UI.label(move_name, UI.SMALL, UI.FG, "semi")
	h.add_child(Icons.tip(name, ("If %s: " % str(words.get(w, w)) if w != "" else "Any time: ") + "%s, %s to %s" % [move_name, from_name, to_name]))
	var path := UI.label("%s > %s" % [from_name, to_name], UI.TINY, UI.MUTED, "body", true)
	path.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(path)
	if PlanBoard.rate(move_id, drilled) < 1.0:
		h.add_child(Icons.icon("info", 16, UI.AMBER, "Untrained: she lands it 80% as well until she drills it on the pads."))
	var idx := index
	h.add_child(Icons.button("x", "Remove this arrow", func(): on_remove.call(idx), UI.MUTED, 16))
	return h
