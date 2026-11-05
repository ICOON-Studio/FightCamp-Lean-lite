extends SceneTree
## S387 stills of the first-week guide and the Playbook on the fighter page, on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/menu1_still.gd -- <out_dir>

const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")

var main: Node
var out_dir := "user://menu1"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(8)
	await _shot("01_title")
	main.act("quick")
	await _shot("02_opens_on_boxer")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	await _settle(4)
	await _shot("03_home_coach_step")
	main.on_go()
	await _shot("04_staff")
	main.act("hire", "reid")
	await _shot("05_week_step")
	main.on_go()
	await _shot("06_training_lock")
	main.on_go()
	await _shot("07_go_step")
	for i in 4:
		main.act("go", "playbook:%d" % i)
		await _settle(30)
		await _shot("1%d_playbook_boxer" % i)
	FirstWeek.ana_joins(main.career)
	main.act("area", "fighters")
	await _shot("20_roster")
	main.act("fighter", "ana")
	await _shot("21_ana_page")
	main.act("area", "playbook")
	await _settle(30)
	await _shot("22_ana_mat")
	print("MENU1_STILL done")
	quit(0)


func _settle(n: int = 12) -> void:
	for i in n:
		await process_frame


func _shot(name: String) -> void:
	await _settle()
	root.get_texture().get_image().save_png("%s/%s.png" % [out_dir, name])
	print("shot ", name)
