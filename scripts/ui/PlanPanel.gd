extends RefCounted
## Sport-free plan list for a move map: caps, arrow count, coverage, rows, first validate error.

const UI := preload("res://scripts/ui/UI.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")


static func build(map: Array, plan: Array, limit: int, drilled: Array, place_name: Callable, on_remove: Callable) -> VBoxContainer:
	var box := UI.vbox(8)
	box.add_child(UI.caps("THE PLAN"))
	box.add_child(UI.label("Arrows %d / %d" % [plan.size(), limit], UI.SMALL, UI.FG, "body", true))
	var cov := PlanBoard.coverage(plan, map)
	box.add_child(UI.label("Covers %d%% of her map" % int(round(cov * 100.0)), UI.SMALL, UI.MUTED, "body", true))
	for i in plan.size():
		box.add_child(_arrow_row(map, plan, i, drilled, place_name, on_remove))
	var v := PlanBoard.validate(plan, map, limit)
	if not v["ok"] and not v["problems"].is_empty():
		box.add_child(UI.label(str(v["problems"][0]), UI.TINY, UI.GOLD, "body", true))
	return box


static func _arrow_row(map: Array, plan: Array, index: int, drilled: Array, place_name: Callable, on_remove: Callable) -> Control:
	var move_id := str(plan[index]["move"])
	var row := PlanBoard.row(map, move_id)
	var from_name: String = place_name.call(str(row.get("from", "?")))
	var to_name: String = place_name.call(str(row.get("to", "?")))
	var move_name := str(row.get("name", move_id))
	var h := UI.hbox(8)
	h.add_child(UI.label("%s  %s -> %s" % [move_name, from_name, to_name], UI.TINY, UI.FG, "body", true))
	if PlanBoard.rate(move_id, drilled) < 1.0:
		h.add_child(UI.label("untrained (80%)", UI.TINY, UI.GOLD, "body"))
	h.add_child(UI.spacer())
	var idx := index
	h.add_child(UI.button("Remove", "BtnQuiet", func(): on_remove.call(idx)))
	return h
