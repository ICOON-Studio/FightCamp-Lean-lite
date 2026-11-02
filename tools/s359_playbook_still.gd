extends SceneTree
## S359 the Playbook's Moves tab (operator still: the move map's side panel and scrollbar drawn over the player column):
## one still after a move is picked, and the map's right edge measured against the player column's left edge.
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/s359_playbook_still.gd -- <out_dir>

var main: Node
var out_dir := "user://s359_playbook"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("go", "playbook:0")
	await _settle(10)
	var sb := main.find_child("*StrikeBrowser*", true, false) as Control
	if sb == null:
		for n in main.find_children("*", "Control", true, false):
			if str((n as Control).get_script().resource_path if (n as Control).get_script() else "").ends_with("StrikeBrowser.gd"):
				sb = n
	var mp := main.find_child("MovePlayer", true, false) as Control
	if sb != null and mp != null:
		var col := mp.get_parent().get_parent() as Control
		var over := 0.0
		for k in sb.find_children("*", "Control", true, false):
			var c := k as Control
			if c.is_visible_in_tree():
				over = maxf(over, c.get_global_rect().end.x - col.get_global_rect().position.x)
		print("PLAYBOOK map %s, player column from x=%.0f; map content past it by %.0f px (clipped: %s)" % [
			str(sb.get_global_rect()), col.get_global_rect().position.x, over, sb.clip_contents])
	await _shot("s359_playbook")
	quit(0)


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(6)
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
