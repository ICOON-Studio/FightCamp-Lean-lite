extends SceneTree
## S356 stills of update 59 on the never-shown desktop: the Training tab (the camp's phase writes the week, one card a day,
## a changed day marked YOURS, the twist card's two answers), the plan board after Test it, the week review (next week's twist).
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/s356_stills.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const W := 1920
const H := 1080

var main: Node
var out_dir := "user://s356"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	TestJump.run(main, "taperoom")   # quick start, Lucy signed, a coach, a bout booked, the camp started with film
	var room := main.get_node_or_null("TapeRoom")
	if room:
		room.queue_free()
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	for i in 14:   # to the next Monday the phase writes the week on
		if posmod(c.day, 7) == 1 and f.has("phase"):
			break
		main.run_to_stop()
		if c.review_pending:
			main.act("review")
			main.act("close")
	WeekTwist.deal(f, WeekTwist.card("tight_knee"))
	main.act("wday", "%s|3|intervals|hard" % f["id"])
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _shot("s356_training")
	main.act("plan", str(f["id"]))
	await _settle(4)
	for n in main.get_children():
		if n.has_method("for_fighter"):
			n._test_it()
	await _shot("s356_plan_test")
	for n in main.get_children():
		if n.has_method("for_fighter"):
			n.queue_free()
	await _settle(2)
	for i in 10:
		if c.review_pending:
			break
		main.run_to_stop()
	main.act("review")
	await _settle(80)
	await _shot("s356_review")
	print("S356_STILLS done day %d phase %s twist %s" % [c.day, str(f.get("phase", "")), str(f.get("twist", ""))])
	quit(0)


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(6)
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
