extends SceneTree
## S397 rank 4 screens: stills of a pro's Fights page for the blind review - just after the debut (offers, unranked), the
## same after a scout, and after three step-ups (a place on the table).
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/pro_fights_still.gd -- <out_dir>
## Prints PRO_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")

var main: Node
var out_dir := "user://pro_fights_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	for jump in ["proladder", "proranked"]:
		if main != null:
			main.queue_free()
			await _wait(2)
		main = load("res://scenes/Main.tscn").instantiate()
		root.add_child(main)
		await _wait(4)
		print("PRO_STILL jump %s: %s" % [jump, TestJump.run(main, jump)])
		if not main.modal.is_empty():
			main.act("close")
		main.clear_toast()
		main.act("go", "fights:0")
		await _shot(jump + "_fights")
		await _scroll_shot(jump + "_fights_low")
		if jump == "proladder":
			var f: Dictionary = main.career.fighter()
			var rows := ProLadder.offer_rows(main.career, f)
			if not rows.is_empty():
				main.act("proscout", "%s:%d" % [f["id"], int(rows[-1]["opp"]["id"])])
				main.clear_toast()
				await _shot("proladder_scouted")
	quit(0)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame


func _scroll_shot(name: String) -> void:
	var sc := _scroller(main)
	if sc != null:
		sc.scroll_vertical = 100000
	await _shot(name)
	if sc != null:
		sc.scroll_vertical = 0


func _scroller(n: Node) -> ScrollContainer:
	for ch in n.get_children():
		if ch is ScrollContainer and (ch as ScrollContainer).visible:
			return ch
		var r := _scroller(ch)
		if r != null:
			return r
	return null


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var img := root.get_texture().get_image()
	var path := "%s/%s.png" % [out_dir, name]
	img.save_png(path)
	print("PRO_STILL wrote ", path)
