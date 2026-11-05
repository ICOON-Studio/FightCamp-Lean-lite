extends SceneTree
## S382 CARDFLIP1: the week review's PADS row filmed on the never-shown desktop - the jump=camp career, her 1-1 at 28.0 split
## 50/50 with the Uppercut on her first pad night; the week runs to its review, which is filmed frame by frame (every frame at
## --fixed-fps 30, jpg) from the moment it opens until it has all landed plus a second, then a still. ffmpeg joins the frames.
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 --fixed-fps 30 \
##       --script res://tools/cardflip_film.gd -- <frames_dir> <still.png>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const W := 1920
const H := 1080

var main: Node


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var out_dir: String = args[0] if not args.is_empty() else "user://cardflip_film"
	var still: String = args[1] if args.size() > 1 else out_dir.path_join("cardflip_review.png")
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	if not TestJump.run(main, "camp"):
		print("CARDFLIP_FILM jump=camp failed")
		quit(1)
		return
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	f["combos"]["1-1"] = 28.0
	var nights := PadWeek.nights_of(f)
	var d := int((nights["pads"] as Array)[0])
	PadEdit.clear(f, nights, d)
	PadEdit.place(f, nights, d, "combo:1-1")
	PadEdit.place(f, nights, d, "move:Uppercut")
	for i in 14:
		if c.review_pending:
			break
		main.run_to_stop()
	main.act("review")
	var rv: Node = main.modal_node()
	var frame := 0
	var after := 0
	while frame < 450 and after < 30:
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_jpg(out_dir.path_join("f_%04d.jpg" % frame), 0.92)
		frame += 1
		if rv != null and bool(rv.get("revealed")):
			after += 1
	var card = null if rv == null else rv.find_child("PadCard_combo_1-1", true, false)
	print("CARDFLIP_FILM frames=%d revealed=%s gold=%s" % [frame, rv != null and bool(rv.get("revealed")),
		card != null and bool(card.gold)])
	root.get_texture().get_image().save_png(still)
	quit(0)


func _frames(n: int) -> void:
	for i in n:
		await process_frame
