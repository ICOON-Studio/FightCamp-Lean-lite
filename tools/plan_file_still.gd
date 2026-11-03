extends SceneTree
## S375 SCOUTPLAN1: a still of PLAYBOOK > Game plan with the tape's file rated against the plan and the ROUND row - the
## camp jump (Lucy booked, camp started), the tape opens her whole file, then the Game plan tab; a second still scrolled
## to the file panel. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/plan_file_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

var main: Node
var out_dir := "user://plan_file_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("JUMP ", TestJump.run(main, "taperoom"))
	for ch in main.get_children():
		if ch.name == "TapeRoom":
			main.remove_child(ch)
			ch.queue_free()
	var f: Dictionary = (main.career as Career).fighter()
	var opp: Dictionary = f["bout"]["opp"]
	for id in OppFile.hidden(opp):
		OppFile.open(opp, str(id))
	print("OPP ", opp.get("first", ""), " | ", opp.get("style", ""), " | ", opp.get("threat", ""), " | ", opp.get("weak", ""))
	if not main.modal.is_empty():
		main.act("close")
	main.act("go", "playbook:1")
	await _shot("plan_file_top.png")
	var sc := root.find_child("PlanFile", true, false) as Control
	if sc != null:
		var scroll: ScrollContainer = null
		var p := sc.get_parent()
		while p != null and scroll == null:
			scroll = p as ScrollContainer
			p = p.get_parent()
		if scroll != null:
			scroll.ensure_control_visible(sc)
	await _shot("plan_file_panel.png")
	quit(0)


func _shot(name: String) -> void:
	main.clear_toast()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name))
	print("STILL ", name)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
