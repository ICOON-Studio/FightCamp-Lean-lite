extends SceneTree
## S516 LADDERWIRE stage 2 stills: the Ask panel (points, price in points, reach, Leans Yes / No) and World > Rankings
## (the Points column), on the TEST CLUB with its first boxer at 4-3. Real pictures only on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/ladder_still.gd -- <out_dir>

const TestClub := preload("res://scripts/state/TestClub.gd")
const LadderPoints := preload("res://scripts/state/LadderPoints.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

var main: Node
var out_dir := "user://ladder_still"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	main.act("newcareer")
	main.act("quick")
	await _settle()
	var c: Career = main.career
	TestClub.make(c)
	var f: Dictionary = TestClub.boxers(c)[0]
	f["w"] = 4
	f["l"] = 3
	f["rep"] = LadderPoints.seed_of(4, 3)
	f["last_bout_day"] = c.day - Bouts.AFTER_FIGHT
	f["injury"] = {}
	f["bout"] = {}
	f["offers"] = []
	main.act("ask", str(f["id"]))
	await _shot("ladder_ask")
	main.act("go", "world:1")
	await _shot("ladder_rankings")
	print("LADDER_STILL done")
	quit(0)


func _settle() -> void:
	for i in 6:
		await process_frame


func _shot(name: String) -> void:
	await _settle()
	var g := main.find_child("FirstWeekStrip", true, false)
	if g != null:
		(g as CanvasItem).visible = false
	if DisplayServer.get_name() == "headless":
		print("headless: no picture for ", name)
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
