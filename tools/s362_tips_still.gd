extends SceneTree
## S362 stills of the top bar's money card with the Runway sticky note open (J90 6c/6g), and the gym's members card,
## each pinned (Tips.pin: the hidden desktop's pointer is not the player's).
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/s362_tips_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Tips := preload("res://scripts/ui/Tips.gd")
const TopCards := preload("res://scripts/ui/TopCards.gd")

var main: Node
var out_dir := "user://s362"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	print("S362 jump ok=%s" % TestJump.run(main, "camp"))
	main.act("go", "home:0")
	await _settle(6)
	Tips.pin(main.find_child("Cash", true, false), func(): return TopCards.money(main.career))
	await _settle(4)
	Tips.pin_note("runway")
	await _shot("s362_money_card")
	Tips.close_all()
	main.act("go", "gym:2")
	await _settle(6)
	Tips.pin(main.find_child("Members", true, false), func(): return TopCards.members(main.career))
	await _settle(4)
	Tips.pin_note("reputation")
	await _shot("s362_members_card")
	quit(0)



func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(6)
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
