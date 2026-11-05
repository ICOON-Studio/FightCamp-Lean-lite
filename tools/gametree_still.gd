extends SceneTree
## S384 GAMETREE1 stage 1 item 6: stills of Ana's Playbook page - the three columns (moves list with Links, the centre
## column: goal row, plan strip, ANA'S GAME map, leaks; the mat), Goal_back clicked, a plan card hovered (EdgeTip + the
## mat playing it), a map position selected, and the Systems modal.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/gametree_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")

var main: Node
var out_dir := "user://gametree_still"


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
	await _shot("gt_1_page.png")
	var g := root.find_child("Goal_back", true, false) as Button
	if g != null:
		g.pressed.emit()
	await create_timer(1.0).timeout
	await _shot("gt_2_goal_back.png")
	var card := root.find_child("Plan_1", true, false)
	if card == null:
		card = root.find_child("Plan_0", true, false)
	var b := card.find_child("Edge_*", true, false) as Button if card != null else null
	print("CARD ", b != null)
	if b != null:
		b.mouse_entered.emit()
	await create_timer(2.0).timeout
	await _shot("gt_3_hover.png")
	if b != null:
		b.mouse_exited.emit()
	var m := root.find_child("Goal_mount", true, false) as Button
	if m != null:
		m.pressed.emit()
	await create_timer(1.0).timeout
	await _shot("gt_4_goal_mount.png")
	var sys := root.find_child("Systems", true, false) as Button
	if sys != null:
		sys.pressed.emit()
	await create_timer(1.0).timeout
	await _shot("gt_5_systems.png")
	quit(0)


func _shot(name: String) -> void:
	main.clear_toast()
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name))
	print("STILL ", name)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
