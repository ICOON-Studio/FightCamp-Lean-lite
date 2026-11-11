extends SceneTree
## S435: stills of the fight INTRO as the player sees it (the real game: Main.tscn, TestJump to fight night, start the
## bout), one every STEP_S seconds from the first frame, on the game's own intro cameras. For reading an intro change
## (INTROCORNER1: each boxer their own warm-up and name call). Real pictures only, on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=240 --log=<log> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/intro_shots.gd -- <out_dir> [women] [secs=24] [step=1.5]
## Prints INTRO_SHOT lines (time, each boxer's clip) and INTRO_SHOTS saved=<n>.

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var out_dir := str(args[0]) if not args.is_empty() else "user://intro_shots"
	var secs := 24.0
	var step := 1.5
	for a in args:
		if str(a).begins_with("secs="):
			secs = float(str(a).substr(5))
		if str(a).begins_with("step="):
			step = float(str(a).substr(5))
	seed(7)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	print("INTRO_SHOTS jump ", TestJump.run(main, "fight" if args.has("women") else "men_fight"))
	main.act("fightstep", "start")
	for i in 4:
		await process_frame
	var view: Node = main._fight_layer.get_child(0)
	var saved := 0
	var t := 0.0
	while t <= secs and is_instance_valid(view):
		await RenderingServer.frame_post_draw
		var path := "%s/intro_%02d_%04.1fs.png" % [out_dir, saved, t]
		root.get_texture().get_image().save_png(path)
		var clips: Array = []
		for bx in view.stage.boxers:
			clips.append(str((bx["ap"] as AnimationPlayer).current_animation))
		# S435: extend with game time, camera name, and cue name
		var intro_t: float = view.get("t") if view.get("t") != null else 0.0
		var shot: String = str(view.get("_shot")) if view.get("_shot") != null else ""
		var cue_i: int = int(view.get("_cue_i")) if view.get("_cue_i") != null else 0
		print("INTRO_SHOT %02d t=%.1f game_t=%.2f cam=%s cue_i=%d clips=%s playing=%s" % [saved, t, intro_t, shot, cue_i, clips, str(view.get("playing"))])
		saved += 1
		await create_timer(step).timeout
		t += step
	print("INTRO_SHOTS saved=%d" % saved)
	quit(0)
