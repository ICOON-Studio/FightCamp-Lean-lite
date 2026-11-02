extends SceneTree
## S362 stills on the never-shown desktop: Ana's belt road (the Record tab as approved in Q-S294-80), the same page after
## seven weeks on the mat (a stripe due), the roster's ON THE MAT row, and Lucy's whiteboard after the WeekCamp split.
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/s362_stills.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const W := 1920
const H := 1080

var main: Node
var out_dir := "user://s362"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	print("S362 jump ok=%s" % TestJump.run(main, "camp"))
	var c: Career = main.career
	if c.grapplers.is_empty():
		c.grapplers = [NoGi.athlete()]
	main.act("go", "fighters:0")
	await _shot("s362_roster")
	main.act("fighter", "ana")
	await _shot("s362_belt_road")
	var f := c.grappler_by_id("ana")
	for k in 7:
		NoGi.week(f)
	main.render()
	await _shot("s362_belt_road_stripe_due")
	main.act("fighter", str(c.fighter()["id"]))
	main.act("ftab", "3")
	await _shot("s362_whiteboard")
	quit(0)


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(6)
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
