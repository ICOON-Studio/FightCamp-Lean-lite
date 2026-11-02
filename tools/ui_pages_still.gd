extends SceneTree
## S369 UI polish: every management tab from a mid-season career (TestJump "nationals"), to find the half-empty pages the
## S367 critic named ("a list in the top fifth of an empty page": Fighters > Training, Fights > Offers, Money). Run:
##   <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/ui_pages_still.gd -- <out_dir> [prefix] [route,route]
## A route is area:tab (e.g. money:0). Prints UI_STILL lines, one per shot, with how far down the page its content reaches.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const ROUTES := ["fighters:0", "fighters:1", "fighters:2", "fighters:3", "fights:0", "fights:1", "fights:2", "gym:1",
	"gym:2", "gym:3", "money:0", "money:1", "money:2", "money:3", "world:0", "world:1", "world:2"]

var main: Node
var out_dir := "user://ui_pages_still"
var prefix := "ui"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	if args.size() > 1:
		prefix = str(args[1])
	var routes: Array = ROUTES
	if args.size() > 2:
		routes = Array(str(args[2]).split(","))
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("UI_STILL jump: ", TestJump.run(main, "nationals"))
	if not main.modal.is_empty():
		main.act("close")
	main.clear_toast()
	for r in routes:
		main.act("go", str(r))
		main.clear_toast()
		await _shot(prefix + "_" + str(r).replace(":", "_"))
	quit(0)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var img := root.get_texture().get_image()
	var path := out_dir.path_join(name + ".png")
	img.save_png(path)
	print("UI_STILL %s fill_to=%.0f%%" % [path, _fill(img) * 100.0])


## The lowest row (below the top bar) whose pixels differ from the page's background: how far down the content reaches.
func _fill(img: Image) -> float:
	var h := img.get_height()
	var w := img.get_width()
	var bg := img.get_pixel(w - 8, h - 8)
	for y in range(h - 1, int(h * 0.12), -4):   # x from 12 %: past the side menu
		for x in range(int(w * 0.12), int(w * 0.95), 16):
			var c := img.get_pixel(x, y)
			if absf(c.r - bg.r) + absf(c.g - bg.g) + absf(c.b - bg.b) > 0.12:
				return float(y) / float(h)
	return 0.0


func _wait(n: int) -> void:
	for k in n:
		await process_frame
