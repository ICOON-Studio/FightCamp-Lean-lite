extends SceneTree
## S360 stills of the rebuilt Playbook (Q-S294-91): Moves as a move book, Game plan as lines against a booked opponent
## (TestJump camp: Lucy booked, camp started), one line open with its rated answers, then the Real fight plans list.
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/s360_playbook_stills.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const GamePlan := preload("res://scripts/ui/GamePlan.gd")

var main: Node
var out_dir := "user://s360_playbook"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	TestJump.run(main, "camp")
	await _settle(8)
	for n in main.get_children():
		if n is Control and str(n.name).begins_with("Twist"):
			n.queue_free()
	# Q-S294-90: the whiteboard with the opponent's line, evenings as text, the More row (camp week 1).
	main.career.fighters[0]["board_taught"] = true
	main.render()
	await _shot("s360_whiteboard")
	main.act("go", "playbook:0")
	await _shot("s360_moves")
	GamePlan.open = ""
	GamePlan.vs = ""
	main.act("go", "playbook:1")
	await _shot("s360_plan")
	var gp := main.find_child("GamePlan", true, false)
	if gp != null:
		gp.open = "mid|"
		gp._refresh()
		var b := gp.find_child("Opt_step_back", true, false) as Button
		if b != null:
			b.mouse_entered.emit()
		await _shot("s360_plan_open")
		gp._pick("mid", "", "step_back", false)
		gp.open = ""
		GamePlan.plans = true
		gp._refresh()
		var sc := gp.get_parent() as ScrollContainer
		if sc != null:
			await _settle(3)
			sc.scroll_vertical = 2000
		await _shot("s360_plan_real_plans")
		var bout: Dictionary = main.career.fighters[0].get("bout", {})
		print("BOUT opp=%s game=%s arrows=%s" % [bout.get("opp", {}).get("first", "?"), gp._game(), main.career.fighters[0].get("arrows", [])])
	quit(0)


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(10)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
