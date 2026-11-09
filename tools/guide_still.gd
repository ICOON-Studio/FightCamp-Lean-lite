extends SceneTree
## S413 stills of the old trainer on the first hour's pages, real flow.
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 --script res://tools/guide_still.gd -- <out_dir>

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")

var main: Node
var out := "user://guide_stills"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		out = str(args[0])
	DirAccess.make_dir_recursive_absolute(out)
	MenuFx.instant = true
	main = MAIN.instantiate()
	root.add_child(main)
	await _wait(10)
	main.act("quick")
	var c: Career = main.career
	await _shot("1_sign_home")
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	main.close_modal()
	main.render()
	await _shot("2_coach_home")
	main.act("go", "gym:1")
	await _shot("3_coach_people")
	main.act("hire", "reid")
	main.on_go()
	await _shot("4_week")
	main.on_go()
	await _shot("5_go")
	quit(0)


func _wait(n: int) -> void:
	for i in n:
		await process_frame


func _shot(id: String) -> void:
	await _wait(24)
	var img := root.get_texture().get_image()
	img.save_png("%s/%s.png" % [out, id])
	print("GUIDE_STILL ", id, " ", img.get_size())
