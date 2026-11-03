extends SceneTree
## S375: stills of Ana's mat in the Playbook - her syllabus beside the mat player, the drilled move playing, then a kimura
## (Watch); S376 BJJCOACH1: the coach's steps under the mat - step 3 clicked at 0.5x and held, a leg lock's steps.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/bjj_mat_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Playbook := preload("res://scripts/ui/areas/Playbook.gd")

var main: Node
var out_dir := "user://bjj_mat_still"


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
	await _shot("mat_1_drilled.png")
	var w := root.find_child("Watch_kimura", true, false) as Button
	print("WATCH ", w != null)
	if w != null:
		w.emit_signal("pressed")
	await create_timer(1.6).timeout
	await _shot("mat_2_kimura_a.png")
	await create_timer(1.4).timeout
	await _shot("mat_3_kimura_b.png")
	var steps := root.find_child("CoachSteps", true, false)
	var slow := root.find_child("Speed_slow", true, false) as Button
	print("STEPS ", steps != null, " ", slow != null)
	if steps != null and slow != null:
		slow.emit_signal("pressed")
		steps.play_step(2)
		await create_timer(2.5).timeout
		await _shot("mat_4_step3_held.png")
	for id in ["straight_ankle_lock", "outside_heel_hook", "triangle"]:
		var b := root.find_child("Watch_" + id, true, false) as Button
		if b != null:
			b.emit_signal("pressed")
			await create_timer(2.0).timeout
			await _shot("mat_5_%s.png" % id)
			break
	quit(0)


func _shot(name: String) -> void:
	main.clear_toast()
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name))
	print("STILL ", name)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
