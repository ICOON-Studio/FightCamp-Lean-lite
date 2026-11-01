extends SceneTree
## S349 the training board's stills (Q-S294-72): her week on FIGHTERS > Training, as the player first sees it (main session
## conditioning) and (S351) after she plans it: three more heavy-bag blocks, sparring off. Real pictures only, on the
## never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --log-file <log> --script res://tools/training_still.gd -- <out_dir>

const W := 1920
const H := 1080

var main: Node
var out_dir := "user://training"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(8)
	main.act("newcareer")
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	main.act("go", "fighters:1")
	await _shot("t1_training_week")
	# S351 the player plans her week: three more heavy-bag blocks (1 -> 4), sparring off; the cards must follow.
	var before := _read()
	for i in 3:
		await _press("More_heavy_bag_lucy")
	await _press("Less_sparring_lucy")
	var after := _read()
	print("TRAINING_STILL bag %s -> %s, sparring %s -> %s, power gain %s -> %s, coach's week button %s" % [before["bag"],
		after["bag"], before["spar"], after["spar"], before["power"], after["power"],
		main.find_child("CoachWeek_lucy", true, false) != null])
	await _shot("t2_planned_week")
	quit(0)


func _press(name: String) -> void:
	var b := main.find_child(name, true, false) as Button
	print("TRAINING_STILL press %s: %s" % [name, "ok" if b != null and not b.disabled else "MISSING/DISABLED"])
	if b != null and not b.disabled:
		b.pressed.emit()
	await _settle(3)


func _read() -> Dictionary:
	var f: Dictionary = main.career.fighter_by_id("lucy")
	var gain: Dictionary = load("res://scripts/state/Sim.gd").daily_gain(main.career, f)
	var bag := main.find_child("Amount_heavy_bag_lucy", true, false) as Label
	var spar := main.find_child("Amount_sparring_lucy", true, false) as Label
	return {"bag": bag.text if bag != null else "?", "spar": spar.text if spar != null else "?",
		"power": "%.3f/wk" % (float(gain["power"]) * 7.0)}


func _settle(frames: int = 6) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle()
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
