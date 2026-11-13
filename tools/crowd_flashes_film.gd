extends SceneTree
## S447 CrowdFlashes film: the game's ring and crowd from FightStage's broadcast camera, both boxers in guard, 4 s at 30 fps
## with a big-shot burst at 1.5 s (CrowdFlashes.burst(9), as HitImpact fires it) - frames for the operator's eye.
## Hidden desktop only:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 --fixed-fps 30 \
##       --audio-driver Dummy --script res://tools/crowd_flashes_film.gd -- <out_dir>
## Writes <out_dir>/f%04d.png and prints CROWD_FLASHES_FILM frames=<n> fired=<n>.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FRAMES := 120
const BURST_AT := 45

var stage: Node3D


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var out_dir: String = args[0] if args.size() > 0 else "user://crowd_flashes_film"
	DirAccess.make_dir_recursive_absolute(out_dir)
	stage = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "blue"})
	for i in 20:
		await process_frame
	var fl: Node = stage.get_node("RingSet").get("flashes")
	for f in FRAMES:
		if f == BURST_AT:
			fl.burst(9)
		if f % 5 == 0:
			print("CROWD_FLASHES_FILM f=%d fired=%d active=%d" % [f, int(fl.get("fired")), int(fl.call("active"))])
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(out_dir.path_join("f%04d.png" % f))
	print("CROWD_FLASHES_FILM frames=%d fired=%d" % [FRAMES, int(fl.get("fired"))])
	quit(0)
