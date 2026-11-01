extends SceneTree
## S340 stills of the fight flow (FlowView) on the never-shown desktop: Lucy's plan lit after a real bout against Maria
## Ortega, and a wrestling tie-up flow. Usage (hidden desktop, Lean CLAUDE.md):
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/flow_still.gd -- <out_dir>

const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const FlowView := preload("res://scripts/ui/FlowView.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const TieUpPanel := preload("res://scripts/grapple/TieUpPanel.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightNight := preload("res://scripts/ui/modals/FightNight.gd")


func _initialize() -> void:
	var out := "user://flow"
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out = args[0]
	DirAccess.make_dir_recursive_absolute(out)
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 44
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0}
	f["arrows"] = [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}, {"move": "slip 2-3@own_ropes"}]
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	var box := {"place_name": func(id: String) -> String: return str(StrikeMap.card(id).get("name", id)),
		"move_name": func(id: String) -> String: return str(StrikeMap.move(id).get("name", id))}
	await _shot(FightNight.lit_flow(m), box.merged({"title": "THE FLOW: LUCY vs MARIA", "sub": "each arrow: won / tried", "lit": true}), out + "/flow_boxing_lit.png")
	await _shot(FightFlow.build(f["arrows"], StrikeMap.MOVES, "long"), box.merged({"title": "THE FLOW: LUCY JACKSON", "sub": "5 arrows, read top to bottom"}), out + "/flow_boxing_plan.png")
	var map := TieUpPanel.plan_map()
	var wplan := [{"move": "collar_tie:leans in on the tie"}, {"move": "collar_tie:pushes hard"}, {"move": "front_headlock:digs for a leg"}, {"move": "front_headlock:stays flat on the mat"}]
	await _shot(FightFlow.build(wplan, map, "collar_tie"), {"title": "THE FLOW: TIE-UPS", "sub": "4 answers", "place_name": TieUpPanel._place_name,
		"move_name": func(id: String) -> String: return str(FightFlow.PlanBoard.row(map, id).get("name", id))}, out + "/flow_wrestling.png")
	quit(0)


func _shot(flow: Dictionary, opts: Dictionary, path: String) -> void:
	var v := FlowView.new()
	v.setup(flow, opts)
	root.add_child(v)
	for i in 6:
		await process_frame
	root.get_viewport().get_texture().get_image().save_png(path)
	print("FLOW_STILL " + path)
	v.queue_free()
	await process_frame
