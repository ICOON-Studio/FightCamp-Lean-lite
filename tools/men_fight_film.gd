extends SceneTree
## S376 (operator: "i watch the fight of men it is pretty bad their leg animation are broken completely their punch speed
## feels very fast along with their body movement and it is very unatural"): films the men's bout the player sees -
## TestJump men_fight (Danny Osei's first men's bout, the male MetaHumans) - round 1 live, logging each boxer's clip and
## leg bones every frame (joins=<csv>, the shape fight3d_film's joins probe writes). Women's control: `women` as an arg
## films TestJump fight (Lucy). Run under the movie writer on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --fixed-fps 30 --write-movie <out>.avi --audio-driver Dummy --script res://tools/men_fight_film.gd -- <out_dir> [women]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const BONES := ["Hips", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightHand", "Head"]
const SECONDS := 20.0

var main: Node
var out_dir := "user://men_fight_film"
var _log: FileAccess
var _frame := 0


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	var women := args.has("women")
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	print("JUMP ", TestJump.run(main, "fight" if women else "men_fight"))
	main.act("fightstep", "start")
	for i in 4:
		await process_frame
	var view: Node = main._fight_layer.get_child(0)
	for bx in view.stage.boxers:
		var tap: SkeletonModifier3D = load("res://tools/pose_tap.gd").new()
		tap.setup(bx["skel"], BONES)
		(bx["skel"] as Skeleton3D).add_child(tap)
		bx["tap"] = tap
		print("BOXER ", i_of(view, bx), " ", (bx["node"] as Node3D).name)
	_log = FileAccess.open(out_dir.path_join("legs.csv"), FileAccess.WRITE)
	_log.store_line("frame,who,clip,speed," + ",".join(BONES.map(func(b): return "%s_x,%s_y,%s_z" % [b, b, b])))
	var t0 := Time.get_ticks_msec()
	while not bool(view.playing) and Time.get_ticks_msec() - t0 < 120000:
		await process_frame
	# `wide`: a fixed side-on lens 4.2 m out at hip height, whole bodies in frame (the broadcast lenses sit at the chest).
	var wide: Camera3D = null
	if args.has("wide"):
		wide = Camera3D.new()
		wide.fov = 42.0
		(view.stage as Node).add_child(wide)
		for c in view.find_children("*", "Camera3D", true, false):
			if c != wide:
				c.set_process(false)
				c.set_physics_process(false)
		wide.current = true
		# Set just before each draw, after the ring camera's own _process (which takes the view back on its cuts).
		RenderingServer.frame_pre_draw.connect(_aim.bind(view, wide))
	var start := _frame
	while _frame - start < int(SECONDS * 30.0):
		await process_frame
		_frame += 1
		_row(view)
	_log.close()
	print("FILMED frames ", _frame - start)
	quit(0)


func _row(view: Node) -> void:
	for i in (view.stage.boxers as Array).size():
		var bx: Dictionary = view.stage.boxers[i]
		var ap: AnimationPlayer = bx.get("ap")
		var clip: String = str(ap.current_animation) if ap != null else ""
		var spd: float = ap.get_playing_speed() if ap != null else 0.0
		var cells: Array = [str(_frame), str(i), clip, "%.2f" % spd]
		var pos: Dictionary = bx["tap"].shown
		for b in BONES:
			var p: Vector3 = pos.get(b, Vector3.ZERO)
			cells.append_array(["%.3f" % p.x, "%.3f" % p.y, "%.3f" % p.z])
		_log.store_line(",".join(cells))


func i_of(view: Node, bx: Dictionary) -> int:
	return (view.stage.boxers as Array).find(bx)


func _aim(view: Node, wide: Camera3D) -> void:
	var a: Vector3 = (view.stage.boxers[0]["node"] as Node3D).global_position
	var b: Vector3 = (view.stage.boxers[1]["node"] as Node3D).global_position
	var mid := (a + b) * 0.5
	var side := (b - a).cross(Vector3.UP).normalized()
	wide.current = true
	wide.global_position = mid + side * 4.2 + Vector3.UP * 0.95
	wide.look_at(mid + Vector3.UP * 0.85, Vector3.UP)
