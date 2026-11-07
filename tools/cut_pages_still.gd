extends SceneTree
## S396 screen cut: a still of every cut page from a mid-season career (TestJump "nationals"), for the blind review.
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/cut_pages_still.gd -- <out_dir>
## Prints CUT_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://cut_pages_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("CUT_STILL jump: ", TestJump.run(main, "nationals"))
	if not main.modal.is_empty():
		main.act("close")
	main.clear_toast()
	for r in [["fighters:0", "roster"], ["fighters:3", "find"], ["fights:0", "fights"], ["gym:1", "club_people"],
			["money:0", "club_money"], ["gym:4", "club_records"], ["world:0", "world_news"], ["world:1", "world_rankings"],
			["world:2", "world_championships"]]:
		main.act("go", r[0])
		await _shot(r[1])
	var f: Dictionary = main.career.fighter()
	main.act("fighter", str(f["id"]))
	await _shot("fighter_overview")
	for t in [["3", "fighter_week"], ["5", "fighter_prep"], ["4", "fighter_history"]]:
		if t[0] == "5" and (f["bout"] as Dictionary).is_empty() and (f["camp"] as Dictionary).is_empty():
			continue   # S397: Fight prep shows only with a bout or a camp
		main.act("ftab", t[0])
		await _shot(t[1])
	# S396 (operator: "have they been reviewed and judged?"): the Playbook's four tabs join the blind review.
	for p in [["0", "playbook_moves"], ["1", "playbook_plan"], ["2", "playbook_combos"], ["3", "playbook_escapes"]]:
		main.act("ptab", p[0])
		await _shot(p[1])
	main.act("handbook")
	await _shot("handbook")
	main.act("close")
	main.act("settings")
	await _shot("settings")
	quit(0)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("CUT_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
