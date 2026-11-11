extends SceneTree
## HUMANFIGHT1 (operator S430: "i see some animations the fighters are off the ground flying"): films the bout the player
## sees from the game's OWN camera (TestJump men_fight: Danny Osei's first bout, two different male MetaHumans; `women` =
## TestJump fight, Lucy) and logs, every drawn frame and whoever has the legs (rig, clip, FootPlant, a captured take played
## pure), each boxer's body AS SHOWN in the world (after every modifier): hips, head, knees, ankles, toes, hands, plus the
## clip, its speed, the rig's weight, the pure weight and the fight's place. tools/human_fight_report.py reads the csv.
## The existing foot rulers only read frames where the footwork rig has the legs and only the plan's planted foot - a boxer
## in a captured take, a punch or a reaction is never read. This one reads every in-round frame.
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1280x720 --fixed-fps 30 \
##       --write-movie <out>.avi --audio-driver Dummy --script res://tools/human_fight_film.gd -- <out_dir> [women] [secs=60] [seed=7] [wide]
## No film, the same log: the same line without --write-movie. NOT --headless (S435: the 3D fight only exists with a
## picture; headless the view has no stage and this tool stops with a script error).
## Prints BEAT_TALLY and BEAT_FALLBACKS (BeatTally.gd) for the bout: what each punch beat really got.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const FastDraw := preload("res://tools/fast_draw.gd")
const BeatTally := preload("res://scripts/fight3d/BeatTally.gd")
const BONES := ["Hips", "Head", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot", "LeftToes", "RightToes", "LeftHand", "RightHand"]

var main: Node
var out_dir := "user://human_fight_film"
var _log: FileAccess
var _frame := 0
var _lens_side := Vector3.ZERO
var _lens_mid := Vector3.ZERO


func _initialize() -> void:
	FightIntro.from_corners = not OS.get_cmdline_user_args().has("walkin")
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	var secs := 60.0
	var sd := 7
	for a in args:
		if str(a).begins_with("secs="):
			secs = float(str(a).substr(5))
		if str(a).begins_with("seed="):
			sd = int(str(a).substr(5))
	seed(sd)   # two arms of a film must play the same fight
	FastDraw.begin()   # `fastdraw`: a long log without a picture (clips, bones, modifiers and hits still run every frame)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1280, 720)
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	BeatTally.reset()
	print("HUMANFIGHT jump ", TestJump.run(main, "fight" if args.has("women") else "men_fight"), " seed ", sd, " args ", args)
	seed(sd)   # again: the career's days before the bout drew from it
	main.act("fightstep", "start")
	for i in 4:
		await process_frame
	var view: Node = main._fight_layer.get_child(0)
	# Read on skeleton_updated (after every modifier), never through a modifier of our own: RkPure switches every modifier
	# off while a captured take plays, and a tap modifier then keeps its last pose for seconds (the first HUMANFIGHT1 log
	# read 14 s of one frozen pose that way; tools/pose_tap.gd has that hole).
	for bx in view.stage.boxers:
		var sk0: Skeleton3D = bx["skel"]
		var ids: Array = BONES.map(func(b): return sk0.find_bone(str(b)))
		bx["hf_shown"] = {}
		sk0.skeleton_updated.connect(func():
			var d: Dictionary = bx["hf_shown"]
			for k in BONES.size():
				d[BONES[k]] = sk0.get_bone_global_pose(int(ids[k])).origin)
		print("HUMANFIGHT boxer ", (view.stage.boxers as Array).find(bx), " ", (bx["node"] as Node3D).name, " scale ", (bx["node"] as Node3D).scale.x,
			" south ", bx.get("south", false), " look ", str(bx.get("look", {})).left(120))
	# The absolute floor: the canvas is y 0 (RingSet), a body's ball and ankle joints stand at their rest heights x her scale.
	var floors := []
	for bx in view.stage.boxers:
		var sk: Skeleton3D = bx["skel"]
		var sc: float = (bx["node"] as Node3D).scale.x
		var fl := {"scale": sc}
		for b in ["LeftToes", "RightToes", "LeftFoot", "RightFoot"]:
			fl[b] = sk.get_bone_global_rest(sk.find_bone(b)).origin.y * sc
		floors.append(fl)
	var ff := FileAccess.open(out_dir.path_join("floor.json"), FileAccess.WRITE)
	ff.store_string(JSON.stringify(floors))
	ff.close()
	_log = FileAccess.open(out_dir.path_join("shown.csv"), FileAccess.WRITE)
	_log.store_line("frame,film_s,t,who,clip,speed,clip_t,rig_w,pure,scene,hold,shout,phase,vel,move_left,aim_dir,hold_m,pos_x,pos_z,node_x,node_y,node_z," + ",".join(BONES.map(func(b): return "%s_x,%s_y,%s_z" % [b, b, b])))
	var t0 := Time.get_ticks_msec()
	while not bool(view.playing) and Time.get_ticks_msec() - t0 < 120000:
		await process_frame
	if args.has("wide"):
		var wide := Camera3D.new()
		wide.fov = 42.0
		(view.stage as Node).add_child(wide)
		for c in view.find_children("*", "Camera3D", true, false):
			if c != wide:
				c.set_process(false)
				c.set_physics_process(false)
		wide.current = true
		RenderingServer.frame_pre_draw.connect(_aim.bind(view, wide))
	var start := _frame
	while _frame - start < int(secs * 30.0) and is_instance_valid(view):
		await process_frame
		_frame += 1
		_row(view)
	_log.close()
	print(BeatTally.line())   # S435: what the punch beats of this bout really got
	print(BeatTally.fallback_line())
	print("HUMANFIGHT filmed frames ", _frame - start, " fight t ", float(view.t) if is_instance_valid(view) else -1.0)
	quit(0)


func _row(view: Node) -> void:
	if not is_instance_valid(view) or view.stage == null:
		return
	var st: Node = view.stage
	for i in (st.boxers as Array).size():
		var bx: Dictionary = st.boxers[i]
		var ap: AnimationPlayer = bx.get("ap")
		var skel: Skeleton3D = bx["skel"]
		var node: Node3D = bx["node"]
		var rig: Node = bx.get("rig")
		var pos: Vector3 = bx["pos"]
		var cells: Array = [str(_frame), "%.3f" % (Engine.get_frames_drawn() / 30.0), "%.3f" % float(view.t), str(i), str(ap.current_animation), "%.2f" % ap.get_playing_speed(),
			"%.3f" % (ap.current_animation_position if ap.current_animation != "" else 0.0),
			"%.2f" % (float(rig.w) if rig != null else -1.0), "%.2f" % float(bx.get("rk_pure", 0.0)),
			"1" if bool(st.scene) else "0", "1" if float(st._hold_left) > 0.0 else "0",
			"1" if view.get("_shouting") != null or float(view.get("_bell_left")) >= 0.0 else "0", str(st.feet.phase()),
			"%.2f" % (bx["vel"] as Vector3).length(), "%.2f" % float(bx["move_left"]), "%.0f" % float(bx.get("aim_dir", 0.0)), "%.2f" % float(bx.get("hold_m", 0.0)),
			"%.3f" % pos.x, "%.3f" % pos.z, "%.3f" % node.global_position.x, "%.3f" % node.global_position.y, "%.3f" % node.global_position.z]
		var shown: Dictionary = bx["hf_shown"]
		var xf := skel.global_transform
		for b in BONES:
			var p: Vector3 = xf * (shown.get(b, Vector3.ZERO) as Vector3)
			cells.append_array(["%.4f" % p.x, "%.4f" % p.y, "%.4f" % p.z])
		_log.store_line(",".join(cells))


func _aim(view: Node, wide: Camera3D) -> void:
	var a: Vector3 = (view.stage.boxers[0]["node"] as Node3D).global_position
	var b: Vector3 = (view.stage.boxers[1]["node"] as Node3D).global_position
	var mid := (a + b) * 0.5
	var side := (b - a).cross(Vector3.UP).normalized()
	if _lens_side == Vector3.ZERO or side.dot(_lens_side) < -0.2:
		_lens_side = side
		_lens_mid = mid
	_lens_side = _lens_side.lerp(side, 0.012).normalized()
	_lens_mid = _lens_mid.lerp(mid, 0.05)
	wide.current = true
	wide.global_position = _lens_mid + _lens_side * 4.2 + Vector3.UP * 0.95
	wide.look_at(_lens_mid + Vector3.UP * 0.85, Vector3.UP)
