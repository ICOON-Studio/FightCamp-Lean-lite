extends SceneTree
## S375 COMBOPLAN1: a still of the combo planner on Danny's Training tab - three combinations of his own (a signature, one
## on the pads, one waiting on a punch). The men jump signs Danny. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/combo_plan_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")

var main: Node
var out_dir := "user://combo_plan_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("JUMP ", TestJump.run(main, "men"))
	var f: Dictionary = (main.career as Career).fighter_by_id("danny")
	f["book"] = [{"name": "jab, jab, step in, lead hook", "chain": ["jab", "jab", "step_in", "lead_hook"], "score": 76},
		{"name": "slip, cross, lead hook, step back", "chain": ["slip", "cross", "lead_hook", "step_back"], "score": 80},
		{"name": "jab, cross, body hook, lead hook", "chain": ["jab", "cross", "body_hook", "lead_hook"], "score": 72}]
	OwnCombos.ensure_ids(f)
	f["own_combos"] = {"own:1": 88.0, "own:2": 41.0}
	f["combo_learning"] = "own:2"
	if not main.modal.is_empty():
		main.act("close")
	main.act("fighter", "danny")
	main.act("ftab", "3")
	await create_timer(0.6).timeout
	var card := root.find_child("ComboPlanner", true, false) as Control
	var p: Node = card.get_parent() if card != null else null
	while p != null and not (p is ScrollContainer):
		p = p.get_parent()
	if p != null:
		(p as ScrollContainer).ensure_control_visible(card)
	main.clear_toast()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join("combo_planner.png"))
	print("STILL combo_planner.png card=", card != null)
	quit(0)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
