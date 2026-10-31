extends SceneTree
## S319 SHOVEL1 instrument (John J_INSIDE2: inside punches travel 15-30 cm). Plays the build to fight night and, from the
## pose AS SHOWN (tools/pose_tap.gd, the last modifier), follows the punching glove relative to the hips from the frame a
## punch clip starts to its contact (clip_contact.json). Reports the glove's travel per punch, thrown up close (Footwork
## phase "inside") vs at range. `-- noshort` = the control arm (the full clip up close, as before S319).
##   python tools/hidden_desktop.py run --timeout=600 --log=<log> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/shovel_probe.gd [-- noshort] [out=<dir>]
## out=<dir>: a still on the game's camera at the contact of the first MAX_STILLS punches thrown up close (visual gate).

const TestJump := preload("res://scripts/ui/TestJump.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const STOP_S := 180.0
const BONES := ["Hips", "LeftHand", "RightHand"]
const MAX_STILLS := 6

var main: Node
var view: Node
var taps: Array = []
var live := [{}, {}]      # per boxer: the punch being followed {clip, hand, contact, inside, cum, prev}
var last_clip := ["", ""]
var done := {"inside": [], "range": []}   # [clip, travel_m]
var out_dir := ""
var stills := 0


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("out="):
			out_dir = str(a).substr(4)
			DirAccess.make_dir_recursive_absolute(out_dir)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("SHOVEL reached fight night: ", TestJump.run(main, "fight"), " arms ", OS.get_cmdline_user_args())
	await _wait(4)
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	for i in 2:
		var skel: Skeleton3D = view.stage.boxers[i]["skel"]
		var tap: SkeletonModifier3D = load("res://tools/pose_tap.gd").new()
		tap.setup(skel, BONES)
		skel.add_child(tap)
		taps.append(tap)
	process_frame.connect(_log)
	await _until(func(): return not bool(view.playing) or float(view.t) > STOP_S, 600.0)
	_report()
	quit(0)


func _log() -> void:
	if not is_instance_valid(view) or view.stage == null or not bool(view.playing) or bool(view.stage.scene):
		return
	for i in 2:
		var ap: AnimationPlayer = view.stage.boxers[i]["ap"]
		var clip := str(ap.current_animation)
		var sh: Dictionary = taps[i].shown
		if sh.size() < BONES.size():
			continue
		var pos := ap.current_animation_position
		var row := BeatClips.contact_row(clip)
		if clip != last_clip[i]:
			last_clip[i] = clip
			live[i] = {}
			if str(row.get("hand", "")) != "":
				var hand := str(row["hand"])
				live[i] = {"clip": clip, "hand": hand, "contact": float(row["contact_s"]),
					"inside": view.stage.feet.phase() == "inside", "cum": 0.0, "prev": sh[hand] - sh["Hips"], "start": pos}
			continue
		var f: Dictionary = live[i]
		if f.is_empty():
			continue
		var p: Vector3 = sh[str(f["hand"])] - sh["Hips"]
		f["cum"] = float(f["cum"]) + p.distance_to(f["prev"])
		f["prev"] = p
		if pos >= float(f["contact"]):
			done["inside" if bool(f["inside"]) else "range"].append([str(f["clip"]), float(f["cum"]), float(f["start"])])
			if bool(f["inside"]) and out_dir != "" and stills < MAX_STILLS:
				stills += 1
				_shot("s%02d_%s_%.2fm_%.1fs.png" % [stills, str(f["clip"]), float(f["cum"]), float(view.t)])
			live[i] = {}


func _report() -> void:
	for k in ["inside", "range"]:
		var rows: Array = done[k]
		var v: Array = rows.map(func(r): return float(r[1]))
		v.sort()
		if v.is_empty():
			print("SHOVEL %s: no punches" % k)
			continue
		var in_band := v.filter(func(x): return x >= 0.15 and x <= 0.30).size()
		print("SHOVEL %s: %d punches | glove travel m p10 %.2f p50 %.2f p90 %.2f | in 15-30 cm %d (%.0f%%)" % [k, v.size(),
			v[int(v.size() * 0.1)], v[v.size() / 2], v[mini(v.size() - 1, int(v.size() * 0.9))], in_band, 100.0 * in_band / v.size()])
		if k == "inside":
			for r in rows:
				print("SHOVEL   inside %s travel %.2f m, started at %.2fs" % [r[0], r[1], r[2]])


func _shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name))
	print("SHOVEL still ", name)


func _wait(n: int) -> void:
	for i in n:
		await process_frame


func _until(cond: Callable, timeout_s: float) -> void:
	var t0 := Time.get_ticks_msec()
	while not cond.call() and Time.get_ticks_msec() - t0 < timeout_s * 1000.0:
		await process_frame
