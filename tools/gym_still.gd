extends SceneTree
## S415 stills of Home's gym with the guide off (operator on the stills: "why do you have the guide on every screen you draw ?").
##   on the hidden desktop, through godot_slot: --script res://tools/gym_still.gd -- <out_dir>   writes start, equip, full

const MAIN := preload("res://scenes/Main.tscn")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")

var main: Node
var out := "user://gym_stills"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		out = args[0]
	DirAccess.make_dir_recursive_absolute(out)
	MenuFx.instant = true
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	main.career.guide = ""
	main.render()
	await _save("start")
	main.act("equipgym", "on")
	await _save("equip")
	main.act("equipgym", "off")
	main.career.gym_slots = []
	main.render()
	await _save("full")
	quit(0)


func _save(name: String) -> void:
	for i in 30:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("%s/%s.png" % [out, name])
