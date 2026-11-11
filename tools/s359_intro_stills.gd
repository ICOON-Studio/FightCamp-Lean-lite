extends SceneTree
## S359 the intro's glove raise on its own camera (operator on the S358 film: "wtf is this ??"): fight night from the board's
## jump, the intro played, a still of each corner's raise at its height (red orthodox, blue southpaw) and one at the touch.
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/s359_intro_stills.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")

var main: Node
var out_dir := "user://s359_intro"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	print("INTRO jump: ", TestJump.run(main, "fight"))
	await _settle(4)
	main.act("fightstep", "start")
	var fi: Node = null
	for k in 600:
		await process_frame
		fi = _intro()
		if fi != null:
			break
	if fi == null:
		print("INTRO no FightIntro")
		quit(1)
		return
	for shot in [["s359_raise_red", FightIntro.T_RED + 1.5], ["s359_raise_blue", FightIntro.T_BLUE + 1.5], ["s359_touch", FightIntro.T_TOUCH + 0.5]]:
		while is_instance_valid(fi) and float(fi.t) < float(shot[1]):
			await process_frame
		await _shot(str(shot[0]))
	quit(0)


func _intro() -> Node:
	for n in root.find_children("*", "Node", true, false):
		if n.get_script() == FightIntro:
			return n
	return null


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await process_frame
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
