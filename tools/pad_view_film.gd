extends SceneTree
## S393 PADVIEW1: the pad-work view as the player meets it, for eyes. A quick career, then Watch on the pads for one combo.
##   python tools/hidden_desktop.py run --timeout=200 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --write-movie <out>/pad.avi --script res://tools/pad_view_film.gd -- combo=1-2-3

const PadView := preload("res://scripts/ui/PadView.gd")
const FILM_FRAMES := 360

var combo_id := "1-2-3"


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("combo="):
			combo_id = str(a).trim_prefix("combo=")
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("newcareer")
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	await process_frame
	PadView.open(main, main.career.fighters[0], combo_id)
	for i in FILM_FRAMES:
		await process_frame
	print("PAD_VIEW_FILM done")
	quit(0)
