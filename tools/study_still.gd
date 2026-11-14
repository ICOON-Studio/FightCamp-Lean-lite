extends SceneTree
## S463 LEARNPICK1 still: her page scrolled to WHAT TO LEARN NEXT, before and after a Study click. Hidden desktop only:
## python ops/Tools/godot_slot.py run --who <x> -- python tools/hidden_desktop.py run --timeout=180 <godot> --path . --windowed
##   --resolution 1920x1080 --audio-driver Dummy --script res://tools/study_still.gd -- <out_dir>

var main: Node


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var out := OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "user://study"
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 3:
		await process_frame
	main.act("quick")
	main.career.seed = 1
	main.act("go_btn")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("fighter", str(main.career.fighter()["id"]))
	main.act("ftab", "0")
	var g := main.find_child("FirstWeekStrip", true, false)
	if g != null:
		(g as CanvasItem).visible = false
	for b in main.find_children("*", "Button", true, false):   # S465: the coach guide covered the card
		if str((b as Button).text) == "Skip the guide":
			(b as Button).emit_signal("pressed")
	await _shot(out, "s463_study_card")
	for b in main.find_children("*", "Button", true, false):
		if str((b as Button).text).begins_with("Study ") and not (b as Button).disabled and not str((b as Button).text).contains("hook"):
			(b as Button).emit_signal("pressed")
			break
	await _shot(out, "s463_study_picked")
	quit(0)


func _shot(out: String, name: String) -> void:
	for i in 4:
		await process_frame
	var lbl: Control = null
	for n in main.find_children("*", "Label", true, false):
		if str((n as Label).text) == "WHAT TO LEARN NEXT":
			lbl = n
	var sc: Node = lbl.get_parent() if lbl != null else null
	while sc != null and not (sc is ScrollContainer):
		sc = sc.get_parent()
	if sc != null and lbl != null:
		var panel := lbl.get_parent().get_parent() as Control
		(sc as ScrollContainer).ensure_control_visible(panel)
		for i in 3:
			await process_frame
		(sc as ScrollContainer).scroll_vertical = int(panel.global_position.y - (sc as Control).global_position.y) + (sc as ScrollContainer).scroll_vertical - 20
	for n in main.find_children("*", "PanelContainer", true, false):   # S465: the sign toast sat on the tiles
		if (n as Control).theme_type_variation == "Toast":
			(n as CanvasItem).visible = false
	print("STUDY_STILL label=%s scroll=%s" % [lbl != null, sc != null])
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out.path_join(name + ".png"))
