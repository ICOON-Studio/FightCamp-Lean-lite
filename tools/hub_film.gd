extends SceneTree
## S409 a short film of Home's gym, for checking the people walk the right way round.
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy \
##       --fixed-fps 30 --write-movie <out>.avi --script res://tools/hub_film.gd

const MAIN := preload("res://scenes/Main.tscn")
const SECONDS := 14


func _initialize() -> void:
	var main := MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	await process_frame
	await process_frame
	var f := main.find_child("HubFigures", true, false)
	for p in f.people:
		p["wait"] = randf() * 3.0   # everyone sets off inside the film
	for _i in SECONDS * 30:
		await process_frame
	quit(0)
