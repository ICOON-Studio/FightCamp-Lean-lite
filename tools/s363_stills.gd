extends SceneTree
## S363 stills on the never-shown desktop: Ana's week in the week review (week 1: the armbar becomes a weapon), her
## page's COACH'S CALL with the three stripe calls when stripe 3 is due, the review offering the calls, and the review after
## HOLD IT BACK.
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/s363_stills.gd -- docs/playtest/S363

const Clock := preload("res://scripts/state/Clock.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const W := 1920
const H := 1080

var main: Node
var out_dir := "user://s363"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	main.act("quick")
	var c: Career = main.career
	while c.day < 7:
		Clock.step(c)
	await _review("s363_review_week1")
	main.act("close")
	var f := c.grappler_by_id("ana")
	for i in 20:
		if NoGi.stripes_due(f, c.day + 7) > 0:
			break
		NoGi.week(f)
	while c.day < 14:
		Clock.step(c)
	main.act("go", "fighters:0")
	main.act("fighter", "ana")
	await _shot("s363_page_stripe_due")
	await _review("s363_review_stripe_due")
	var hold := main.modal_node().find_child("HoldStripe", true, false) as Button
	if hold != null:
		hold.pressed.emit()
	await _shot("s363_review_held")
	main.act("close")
	main.render()
	await _shot("s363_page_held")
	# S364 what the classes drill: for the next open (the Spring Open leans on passes and sweeps).
	main.act("gdrill", "ana|open")
	await _shot("s364_page_drill_open")
	quit(0)


func _review(name: String) -> void:
	main.act("review")
	await _settle(4)
	main.modal_node().finish()
	await _shot(name)


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(6)
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
