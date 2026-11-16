extends SceneTree
## FIGHT VIDEO DATASET (S495, operator: "make our own labelled clips then"): labelled boxing clips rendered from our own 3D
## ring. Every pixel is ours and every label is exact: the punches are thrown through the fight's own beat switch
## (BeatFire) and logged as they are played, and both boxers' 17 COCO joints are read off the skeletons as drawn.
## One run = one pair of bodies and `clips` clips; each clip gets its own camera, light, room, canvas and kits
## (fight_video_synth_set.gd) and its own exchanges (fight_video_synth_script.gd).
## Windowed, on the never-shown desktop only, ONE render at a time, at a fixed frame step:
##   python tools/hidden_desktop.py run --timeout=1800 --log=<log> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --fixed-fps 50 --audio-driver Dummy --script res://tools/fight_video_synth.gd -- <out_dir> \
##       pair=mh_boxer_01,mh_boxer_03 clips=4 secs=14 seed=1 first=0 [stance=oo|os|so|ss] [scale=1.0,0.97] [fps=50] [size=1280x720]
## Writes <out_dir>/clip_NNNN/000000.jpg ... and <out_dir>/clip_NNNN/labels.json (ops/Tools/fight_video/synth_render.py
## runs the batch and packs the frames into one video per clip). Output belongs OUTSIDE the repository.
## labels.json: fps, size, the clip's plan, both bodies, `punches` (boxer 0|1, hand, lead/rear, type, target, result,
## defence, start / contact / end frame, the clip played, shown, graze, glove_to_target_m) and per frame `joints`
## [boxer][17][x, y, v], `joints3d` (metres), `gloves` (the two glove fronts), `boxes`, and the camera.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const RangeBreath := preload("res://scripts/fight3d/RangeBreath.gd")
const PunchRange := preload("res://scripts/fight3d/PunchRange.gd")
const Exchange := preload("res://tools/fight_video_synth_script.gd")
const ClipSet := preload("res://tools/fight_video_synth_set.gd")
const Pose := preload("res://tools/fight_video_synth_pose.gd")

const WARM_FRAMES := 70       # not saved: the pair settles where the clip starts
const JPG_QUALITY := 0.9
const COCO := ["nose", "left_eye", "right_eye", "left_ear", "right_ear", "left_shoulder", "right_shoulder", "left_elbow",
	"right_elbow", "left_wrist", "right_wrist", "left_hip", "right_hip", "left_knee", "right_knee", "left_ankle", "right_ankle"]


class FakeBody extends RefCounted:
	var host: Object
	func land(b: Dictionary, at: float) -> void:
		host.call("_started", b, at)


## The few things BeatFire reads off the FightView.
class FakeView extends Node:
	var stage: Node3D
	var _amb_rng := RandomNumberGenerator.new()
	var t := 0.0
	var _profiles := {}
	var _stop := ""
	var main: Node = null
	var body := FakeBody.new()
	var last_dt := 0.0
	func _process(delta: float) -> void:
		last_dt = delta


var out_dir := "user://fight_video_synth"
var opt := {"pair": "mh_boxer_11,mh_boxer_10", "clips": "2", "secs": "12", "seed": "1", "first": "0", "stance": "oo",
	"scale": "1.0,1.0", "fps": "50", "size": "1280x720"}
var W := 1280
var H := 720
var fps := 50.0
var stage: Node3D
var view: FakeView
var beat := BeatFire.new()
var pose := Pose.new()
var st := {}                 # the set's state between clips (ClipSet)
var frame := -1              # the frame being played (-1 = warming up)
var punches: Array = []
var _tasks: Array = []


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.contains("="):
			opt[s.get_slice("=", 0)] = s.get_slice("=", 1)
		else:
			out_dir = s
	W = int(str(opt["size"]).get_slice("x", 0))
	H = int(str(opt["size"]).get_slice("x", 1))
	fps = float(opt["fps"])
	DirAccess.make_dir_recursive_absolute(out_dir)
	# The picture is the window's own pixels: a plain window of exactly W x H, no stretch (the project opens maximised
	# and stretched; the first test clip came out 1920 x 1009).
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.size = Vector2i(W, H)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	await process_frame
	DisplayServer.window_set_size(Vector2i(W, H))
	root.size = Vector2i(W, H)
	var pair := str(opt["pair"]).split(",")
	var scales := str(opt["scale"]).split(",")
	var stances := str(opt["stance"])
	stage = Stage.new()
	root.add_child(stage)
	stage.set_process(false)   # nothing ticks before setup() has built it
	await process_frame
	var specs: Array = []
	for i in 2:
		specs.append({"glb": "res://assets/models/metahuman/%s.glb" % pair[i], "corner": "red" if i == 0 else "blue",
			"scale": float(scales[i]), "stance": "southpaw" if stances.substr(i, 1) == "s" else ""})
	stage.setup(specs[0], specs[1])
	stage.set_process(true)
	view = FakeView.new()
	view.stage = stage
	view.body.host = self
	root.add_child(view)
	pose.attach(stage)
	for i in 20:
		await process_frame
	var got := root.get_texture().get_size()
	if int(got.x) != W or int(got.y) != H:
		print("FVSYNTH: the window gave %d x %d, not %d x %d - labels use the real size" % [int(got.x), int(got.y), W, H])
		W = int(got.x)
		H = int(got.y)
	if absf(view.last_dt - 1.0 / fps) > 0.0005:
		push_error("FVSYNTH: the frame step is %.4f s, not 1/%d - run with --fixed-fps %d" % [view.last_dt, int(fps), int(fps)])
		quit(2)
		return
	print("FVSYNTH pair=%s gap_m=%.3f size=%dx%d fps=%d" % [opt["pair"], stage.gap_m, W, H, int(fps)])
	for k in int(opt["clips"]):
		await _clip(int(opt["first"]) + k, specs)
	for id in _tasks:
		WorkerThreadPool.wait_for_task_completion(id)
	print("FVSYNTH DONE")
	quit(0)


## One clip: dress the set, place the pair, play the exchanges, save every frame and the labels.
func _clip(id: int, specs: Array) -> void:
	var began := Time.get_ticks_msec()
	var rng := RandomNumberGenerator.new()
	rng.seed = hash([int(opt["seed"]), id, str(opt["pair"])])
	var plan := ClipSet.plan(rng, id)
	ClipSet.apply(stage, plan, st)
	# Where the pair stands when the clip opens: anywhere in the middle of the ring, on any line.
	var mid := Vector3(rng.randf_range(-0.9, 0.9), 0.0, rng.randf_range(-0.9, 0.9))
	var ang := rng.randf() * TAU
	var half := Vector3(cos(ang), 0.0, sin(ang)) * float(stage.gap_m) * 0.7
	stage.scene_mode(true)
	for i in 2:
		(stage.boxers[i]["node"] as Node3D).position = mid + half * (-1.0 if i == 0 else 1.0)
	await process_frame
	stage.scene_mode(false)
	var secs := float(opt["secs"])
	var beats := Exchange.build(rng, secs)
	var total := int(round(secs * fps))
	var dir := out_dir.path_join("clip_%04d" % id)
	DirAccess.make_dir_recursive_absolute(dir)
	view.t = 0.0
	view._amb_rng.seed = rng.randi()
	beat.reset()
	punches = []
	(stage.hit_gaps as Array).clear()
	var rec := {"joints": [], "joints3d": [], "gloves": [], "boxes": [], "shot": [], "cuts": [], "fov": [], "xform": []}
	var dt := 1.0 / fps
	var clock := 0.0
	var next := 0
	var quiet := 0.0
	var cuts_seen := int(stage.camera.cuts)
	frame = -1
	for f in WARM_FRAMES + total:
		await process_frame
		clock += dt
		ClipSet.camera(stage, plan, st, clock, dt)
		if f >= WARM_FRAMES:
			frame = f - WARM_FRAMES
			view.t += dt
			while next < beats.size() and float(beats[next]["t"]) <= view.t:
				beat.fire(view, beats[next])
				next += 1
				quiet = 0.0
			# Between exchanges the two keep working: a short circle, as FightView._ambient does.
			quiet += dt
			var gap := float(beats[next]["t"]) - view.t if next < beats.size() else 99.0
			if quiet > 1.1 and gap > 1.2 and not stage.feet.phase() in ["clinch", "inside", "pivot"]:
				quiet = 0.0
				if view._amb_rng.randf() < 0.65:
					stage.circle(-1 if view._amb_rng.randf() < 0.5 else 1, view._amb_rng.randf_range(0.3, 0.55))
		stage.aim(RangeBreath.phase(beats, next, view.t))
		await RenderingServer.frame_post_draw
		if frame < 0:
			cuts_seen = int(stage.camera.cuts)
			continue
		_save(root.get_texture().get_image(), dir.path_join("%06d.jpg" % frame))
		var lab := pose.frame(stage, stage.camera, Vector2(W, H))
		for key in ["joints", "joints3d", "gloves", "boxes"]:
			(rec[key] as Array).append(lab[key])
		var cam: Camera3D = stage.camera
		if int(cam.get("cuts")) != cuts_seen:
			cuts_seen = int(cam.get("cuts"))
			(rec["cuts"] as Array).append(frame)
		(rec["shot"] as Array).append(str(cam.get("shot_name")))
		(rec["fov"] as Array).append(snappedf(cam.fov, 0.01))
		var x := cam.get_camera_transform()
		var nums: Array = []
		for v in [x.basis.x, x.basis.y, x.basis.z, x.origin]:
			nums.append_array([snappedf(v.x, 0.0001), snappedf(v.y, 0.0001), snappedf(v.z, 0.0001)])
		(rec["xform"] as Array).append(nums)
		_follow_punches()
	frame = -1
	var kept: Array = []
	for p in punches:
		if int(p["end"]) < 0:
			p["end"] = total - 1
		if int(p["contact"]) < 0:
			p["shown"] = false   # the clip ended before it arrived
		var row := {}
		for key in p:
			if not str(key).begins_with("_"):
				row[key] = p[key]
		kept.append(row)
	var bodies: Array = []
	for i in 2:
		bodies.append({"glb": str(specs[i]["glb"]).get_file().get_basename(), "scale": specs[i]["scale"],
			"stance": "southpaw" if bool(stage.boxers[i].get("south", false)) else "orthodox", "kit": plan["kit"][i]})
	var labels := {"version": 1, "clip": "clip_%04d" % id, "source": "FightCamp Lean synthetic clip (ICOON Studio): rendered from our own game, labels from what was played",
		"fps": fps, "size": [W, H], "frames": total, "seed": int(opt["seed"]), "plan": plan, "boxers": bodies,
		"beats_planned": beats.size(), "punches": kept, "coco": COCO, "joints": rec["joints"], "joints3d": rec["joints3d"],
		"gloves": rec["gloves"], "boxes": rec["boxes"],
		"camera": {"shot": rec["shot"], "cuts": rec["cuts"], "fov": rec["fov"], "xform": rec["xform"]}}
	var file := FileAccess.open(dir.path_join("labels.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify(labels))
	file.close()
	var shown := kept.filter(func(p: Dictionary) -> bool: return bool(p["shown"])).size()
	print("FVSYNTH clip_%04d camera=%s room=%s frames=%d beats=%d started=%d shown=%d in %.0f s" % [id, plan["camera"]["mode"],
		plan["room"], total, beats.size(), kept.size(), shown, (Time.get_ticks_msec() - began) / 1000.0])


## The picture is written on a worker thread; every 100 frames the queue is emptied so it cannot grow.
func _save(img: Image, path: String) -> void:
	_tasks.append(WorkerThreadPool.add_task(func() -> void: img.save_jpg(path, JPG_QUALITY)))
	if _tasks.size() >= 100:
		for id in _tasks:
			WorkerThreadPool.wait_for_task_completion(id)
		_tasks.clear()


## BeatFire started a punch (it calls the body map's land(b, at) the moment the punch clip really starts; a punch the
## stage refuses never gets here): log it and put a timer on its contact beside the fight's own.
func _started(b: Dictionary, at: float) -> void:
	var who := 0 if str(b["who"]) == "a" else 1
	var move := str(b["move"])
	var clip := str(b.get("clip", move))
	var ortho := str(BeatClips.contact_row(clip).get("hand", ""))
	if ortho == "":
		ortho = "LeftHand" if move in Exchange.LEAD else "RightHand"
	var hand: String = stage.hand_of(who, ortho)
	var p := {"boxer": who, "hand": "left" if hand.begins_with("Left") else "right",
		"lead": "lead" if ortho.begins_with("Left") else "rear", "type": Exchange.type_of(move, ortho.begins_with("Left")),
		"target": "body" if move == "body_hook" else "head", "result": Exchange.result_of(str(b["result"])),
		"defence": str(b.get("def", "")), "big": bool(b.get("big", false)), "move": move, "clip": clip,
		"start": frame, "contact": -1, "end": -1, "shown": true, "aimed": true, "graze": false, "glove_to_target_m": -1.0,
		"_pid": int(stage.boxers[who]["play_id"]), "_hg": -1, "_hand": hand}
	punches.append(p)
	if at <= 0.0:
		_contact(p)
	else:
		view.get_tree().create_timer(at).timeout.connect(_contact.bind(p))


## Her glove's contact moment (the same timer the fight puts its hit on; ours was made first, so it runs first).
func _contact(p: Dictionary) -> void:
	p["contact"] = frame
	p["_hg"] = (stage.hit_gaps as Array).size()
	var bx: Dictionary = stage.boxers[int(p["boxer"])]
	if int(bx["play_id"]) != int(p["_pid"]) or str((bx["ap"] as AnimationPlayer).assigned_animation) != str(p["clip"]):
		p["shown"] = false   # her punch clip was replaced before it arrived: no punch to label
	# False = the game's reach was not on this punch at its contact, so its defence clip or hit did not play (the punch did).
	p["aimed"] = not PunchRange.cut_off(stage, int(p["boxer"]), int(p["_pid"]))


## After each drawn frame: the contact frame's measurements and each punch's end (her punch clip is over).
func _follow_punches() -> void:
	for p in punches:
		var who := int(p["boxer"])
		var bx: Dictionary = stage.boxers[who]
		var gone := int(bx["play_id"]) != int(p["_pid"]) or str((bx["ap"] as AnimationPlayer).assigned_animation) != str(p["clip"])
		if int(p["contact"]) == frame:
			var tp: Vector3 = stage.target_point(1 - who, str(p["target"]) == "body")
			p["glove_to_target_m"] = snappedf((stage.glove_front(who, str(p["_hand"])) as Vector3).distance_to(tp), 0.001)
			var gaps: Array = stage.hit_gaps
			if str(p["result"]) == "landed" and gaps.size() > int(p["_hg"]) and int(gaps[int(p["_hg"])]["hitter"]) == who:
				var row: Dictionary = gaps[int(p["_hg"])]
				p["graze"] = bool(row["graze"])   # the game drew it as a glancing touch: the glove ended off her
				if bool(row["cut"]):
					p["shown"] = false
		elif int(p["contact"]) < 0 and gone:
			p["shown"] = false
		if int(p["end"]) < 0 and int(p["contact"]) >= 0 and frame > int(p["contact"]) and gone:
			p["end"] = frame
