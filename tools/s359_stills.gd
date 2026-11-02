extends SceneTree
## S359 stills of Kalli SQ25's whiteboard clarity fixes on the never-shown desktop (jump=camp): the first open (grid dimmed,
## START HERE on the twist), hovering an answer (the goal lines preview), the twist answered (the grid lit), a day changed
## (its 'undo', the goal lines pulsing their delta).
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/s359_stills.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const W := 1920
const H := 1080

var main: Node
var out_dir := "user://s359"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	print("S359 jump ok=%s" % TestJump.run(main, "camp"))
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	var fid := str(f["id"])
	f.erase("board_taught")
	f.erase("twist_pick")
	main.act("fighter", fid)
	main.act("ftab", "3")
	await _shot("s359_first_open")
	var b := main.find_child("WeekBoard", true, false)
	b._preview("b")
	await _shot("s359_hover_answer")
	b._preview_off()
	main.act("twistpick", "%s|a" % fid)
	await _shot("s359_answered")
	main.act("wday", "%s|6|intervals|hard" % fid)
	await _settle(8)   # mid-pulse
	await _shot("s359_day_changed")
	quit(0)


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(6)
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
