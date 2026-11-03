extends SceneTree
## S376: stills of the S375 playtest findings on Danny's career (TestJump men): FIGHTERS > Roster, Fight camps, Scouting,
## and Danny's own page. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/s376_findings_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://s376_findings"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	print("JUMP ", TestJump.run(main, "men"))
	if not main.modal.is_empty():
		main.act("close")
	for t in [["fighters:0", "1_roster"], ["fighters:2", "2_camps"], ["fighters:3", "3_scouting"]]:
		main.act("go", t[0])
		await create_timer(1.0).timeout
		await _shot(t[1] + ".png")
	main.act("invite", "kira")
	main.act("go", "fighters:3")
	await create_timer(1.0).timeout
	await _shot("3b_scouting_after_invite.png")
	var f: Dictionary = main.career.fighters[0]
	f["book"] = [{"name": "jab, jab, cross", "chain": ["jab", "jab", "cross"], "score": 72}]
	load("res://scripts/ui/areas/Playbook.gd").pick = str(f["id"])
	main.act("go", "playbook:2")
	await create_timer(1.5).timeout
	await _shot("6_combos_own.png")
	main.act("fighter", "danny")
	await create_timer(1.0).timeout
	await _shot("4_danny.png")
	main.act("fighter", "lucy")
	await create_timer(1.0).timeout
	await _shot("5_lucy.png")
	quit(0)


func _shot(name: String) -> void:
	main.clear_toast()
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name))
	print("STILL ", name)
