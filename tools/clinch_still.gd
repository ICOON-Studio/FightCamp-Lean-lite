extends SceneTree
## S313 visual gate for the clinch (real-fight gap 4): plays the build to fight night (TestJump "fight") and, on the
## game's own broadcast camera, saves a still 0.8 s into each tie-up and 0.3 s into each referee break, rounds 1-2,
## plus (gap 5, guard by range) one still 1.2 s into a spell at long range and one in the pocket.
## Run on the never-shown desktop (3D needs a picture):
##   python tools/hidden_desktop.py run --timeout=900 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/clinch_still.gd -- <out_dir> [max_stills]

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var view: Node
var out_dir := "user://clinch"
var max_stills := 6
var saved := 0
var _tied_s := 0.0
var _part_s := 0.0
var _shot_tie := false
var _shot_part := false
var _busy := false
var _rest_s := 0.0
var _range_done := false
var _pocket_done := false
var _inside_only := false
var _in_s := 0.0
var _pv_s := -1.0             # S315: time since a pivot out began (inside mode also shoots it 0, 0.5 and 1.1 s in)


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		out_dir = args[0]
	if args.size() > 1:
		max_stills = int(args[1])
	_inside_only = args.size() > 2 and args[2] == "inside"
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("CLINCH_STILL reached fight night: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0)
	process_frame.connect(_watch)
	var left := 840.0
	while saved < max_stills and left > 0.0:
		await process_frame
		left -= 1.0 / 30.0
	print("CLINCH_STILL saved %d" % saved)
	quit(0)


func _watch() -> void:
	if _busy or not is_instance_valid(view) or view.stage == null or not bool(view.playing) or bool(view.stage.scene):
		return
	var ph: String = view.stage.feet.phase()
	# S314 inside range (`-- <out_dir> <max> inside`): only inside spells, 0.9 s and 1.7 s in (the punches land there).
	if _inside_only:
		_in_s = _in_s + 1.0 / 30.0 if ph == "inside" else 0.0
		if (absf(_in_s - 0.9) < 0.017 or absf(_in_s - 1.7) < 0.017):
			_shot("inside")
		if ph == "pivot" and _pv_s < 0.0:
			_pv_s = 0.0
		if _pv_s >= 0.0:
			for at in [0.0, 0.5, 1.1]:
				if absf(_pv_s - at) < 0.017:
					_shot("pivot%.1f" % at)
			_pv_s = _pv_s + 1.0 / 30.0 if _pv_s < 1.2 else -1.0
		return
	_rest_s = _rest_s + 1.0 / 30.0 if ph == "rest" else 0.0
	if _rest_s >= 1.2 and not _range_done and float(view.t) > 5.0:
		_range_done = true
		_shot("range")
		return
	if ph == "pocket" and not _pocket_done and float(view.t) > 5.0:
		_pocket_done = true
		_shot("pocket")
		return
	var cl: Node = view.stage.clinch
	var ref: Node = view.stage.referee
	if bool(cl.engaged):
		_tied_s += 1.0 / 30.0
		if _tied_s >= 0.8 and not _shot_tie:
			_shot_tie = true
			_shot("tie")
	else:
		_tied_s = 0.0
		_shot_tie = false
	if ref != null and str(ref._mode) == "part":
		_part_s += 1.0 / 30.0
		if _part_s >= 0.3 and not _shot_part:
			_shot_part = true
			_shot("break")
	else:
		_part_s = 0.0
		_shot_part = false


func _shot(kind: String) -> void:
	_busy = true
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join("c%02d_r%d_%s_%.1fs.png" % [saved + 1, int(view.round_n), kind, float(view.t)])
	root.get_texture().get_image().save_png(path)
	var a: Vector3 = view.stage.boxers[0]["pos"]
	var b: Vector3 = view.stage.boxers[1]["pos"]
	print("CLINCH_STILL wrote %s gap %.2f m holder %d" % [path, a.distance_to(b), int(view.stage.clinch.holder)])
	saved += 1
	_busy = false


func _wait(n: int) -> void:
	for k in n:
		await process_frame
