extends SceneTree
## S532 GUIDETIPS1 stills (VISUAL: yes): the real game with each new card pinned open, and the guide before and after
## SHOW ME. Rendered on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/tip_stills.gd -- <out_dir>

const Tips := preload("res://scripts/ui/Tips.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")
const GuideLight := preload("res://scripts/ui/GuideLight.gd")

var main: Node
var out_dir := "user://tip_stills"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(6)
	main.act("newcareer")
	main.act("quick")
	await _settle(30)
	await _shot("01_guide_explore_first")
	var show := main.find_child("GuideShow", true, false) as Button
	if show != null:
		show.pressed.emit()
	await _settle(30)
	await _shot("02_guide_show_me")
	GuideLight.show_step = ""
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("go", "gym:1")
	await _settle(10)
	var tiles: Array = []
	for box in main.find_children("CoachTiles", "", true, false):
		tiles.append_array(box.get_children())
	if tiles.size() >= 6:
		await _pin(tiles[2], "03_coach_pay")
		await _pin(tiles[4], "04_coach_real_cost")
		Tips.pin(tiles[2], (tiles[2] as Control).get_meta(Tips.META_SPEC))
		await _settle(3)
		Tips.pin_note("classes")
		await _settle(6)
		await _shot("05_coach_pay_note")
		Tips.close_all()
		await _pin(tiles[5], "06_signing_fee")
	main.act("hire", "reid")
	await process_frame
	main.act("go", "fighters:0")
	await _settle(10)
	await _pin(main.find_child("Col_tiredness", true, false), "07_roster_tiredness")
	TestJump.run(main, "club4")
	if not main.modal.is_empty():
		main.act("close")
	main.nav({"area": "training"})
	await _settle(12)
	for b in main.find_children("Bar_*", "Control", true, false):
		if not ("ghost" in b):
			continue
		var n: Node = b
		while n != null and not (n is Control and (n as Control).has_meta(Tips.META_SPEC)):
			n = n.get_parent()
		if n != null:
			await _pin(n, "08_training_mastery")
			break
	for n in main.find_children("*", "Control", true, false):
		var c := n as Control
		if c.is_visible_in_tree() and c.tooltip_text.contains("injury roll"):
			Tips.plain_under(c)
			Tips.pin(c, func(): return Tips.plain_spec(c))
			await _settle(4)
			await _shot("09_plain_line_wrapped")
			Tips.close_all()
			break
	quit(0)


func _pin(n: Node, name: String) -> void:
	var c := n as Control
	if c == null or not c.has_meta(Tips.META_SPEC):
		print("TIP_STILLS no card for ", name)
		return
	Tips.pin(c, c.get_meta(Tips.META_SPEC))
	await _settle(4)
	await _shot(name)
	Tips.close_all()
	await _settle(2)


func _shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	print("TIP_STILLS ", name)


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame
