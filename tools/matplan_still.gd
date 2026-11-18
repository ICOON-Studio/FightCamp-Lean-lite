extends SceneTree
## S515 MATPLANUI1: a still of Ana's plan lines (MatPlanPanel) under the A-game on her Playbook page.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/matplan_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")

var main: Node
var out_dir := "user://matplan_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("JUMP ", TestJump.run(main, "belt"))
	if not main.modal.is_empty():
		main.act("close")
	Playbook.pick = "ana"
	main.act("go", "playbook:0")
	await create_timer(2.5).timeout
	var panel := root.find_child("MatPlanPanel", true, false) as Control
	print("PANEL ", panel != null)
	var sc: ScrollContainer = null
	var p: Node = panel
	while p != null and sc == null:
		p = p.get_parent()
		if p is ScrollContainer:
			sc = p
	if sc != null and panel != null:
		sc.scroll_vertical = int(panel.global_position.y - 200.0)
	await create_timer(1.0).timeout
	await _shot("mp_1_lines.png")
	quit(0)

func _shot(name: String) -> void:
	main.clear_toast()
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name))
	print("STILL ", name)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
