extends SceneTree
## POWER1 step 2: landed jabs and crosses in the PLAYED fight (the real game to fight night, FightView's own beats), every
## drawn frame from 0.30 s before the hit to 0.40 s after, cropped round the pair. The hit frame is the one HitImpact.hit
## fires on (the thud, the freeze, the head snap): the frame PunchRange.record writes the landed contact. Real pictures
## only - run it on the never-shown desktop:
##   python E:/FightCamp/Lean/ops/Tools/godot_slot.py run --who claude -- python tools/hidden_desktop.py run --timeout=600 \
##       <godot.exe> --path . --windowed --resolution 960x540 --audio-driver Dummy --fixed-fps 60 \
##       --script res://tools/hit_frame_film.gd -- <out_dir> [jabs=2] [crosses=2] [uppercuts=0] [seed=<n>]
## POWER1 step 4: uppercuts=<n> films n landed lead and n landed rear uppercuts; they are rare in a plain bout, so of the
## landed jabs, crosses and lead hooks not yet thrown every second one goes to a lead or a rear uppercut in turn (3D only).
## seed=<n> seeds the global random numbers first, so the career, the bout and its beats are the same on every run: film the
## old code and the new with the same seed to see the same punches.
## Writes <out_dir>/<nn>_<move>/fNN.png (the hit is the frame named in hits.txt) and prints HIT_FRAME_FILM shots=<n>.

const Bouts := preload("res://scripts/state/Bouts.gd")
const ClashMeter := preload("res://tools/clash_meter.gd")   # S468 C394: gloves and forearms through each other, as drawn
const W := 960
const H := 540
const PRE_F := 18
const POST_F := 24
const CROP := Vector2i(400, 320)
const GIVE_UP_S := 240.0
const CLASH_M := 0.02   # padding gives a little; deeper reads as one glove inside the other

var main: Node
var view: Node
var stage: Node3D
var out_dir := "user://hit_frame_film"
var want := {"jab": 2, "cross": 2, "lead_uppercut": 0, "rear_uppercut": 0}
var mix_n := 0
var ring: Array = []
var gring: Array = []      # per drawn frame: both boxers' glove fronts and faces (world), for the speed table
var seen_gaps := 0
var shots: Array = []      # {dir, left, label}
var labels: Array = []
var shot_n := 0
var picked := {}
var _clock := 0.0
var _go := false
## POWER1 step 4 review round 1 ("the before and after films use different camera sides"): side=1 films through a camera of
## its own, square to the line between the two, boxer 0 always on the left of the frame, so two runs film the same view.
var side := false
var side_cam: Camera3D = null
const SIDE_M := 2.6


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("jabs="):
			want["jab"] = int(s.get_slice("=", 1))
		elif s.begins_with("crosses="):
			want["cross"] = int(s.get_slice("=", 1))
		elif s.begins_with("uppercuts="):
			want["lead_uppercut"] = int(s.get_slice("=", 1))
			want["rear_uppercut"] = int(s.get_slice("=", 1))
		elif s == "trace=1":
			trace = true
		elif s == "side=1":
			side = true
		elif s.begins_with("seed="):
			# Review round 1: the same career (and so the same bout, beat for beat) before and after a change.
			seed(int(s.get_slice("=", 1)))
		elif not s.begins_with("no"):   # POWER1 step 3: `nofastdrive` (and the other control flags) are not the folder
			out_dir = s
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		_tidy(c)
		main.run_to_stop()
	var offer: Dictionary = {}
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			offer = o
	main.act("accept", str(offer["id"]))
	main.act("camp", str(f["id"]))
	main.act("startcamp")
	for i in 60:
		if Bouts.weigh_in_today(c, f):
			break
		_tidy(c)
		main.run_to_stop()
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	main.act("fightnight")
	await _wait(4)
	if main.modal.is_empty() or str(main.modal.get("type", "")) != "fight":
		print("HIT_FRAME_FILM_FAIL no fight modal")
		quit(1)
		return
	main.act("fightstep", "start")
	await _wait(2)
	view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	if view != null:
		for ch in view.get_children():
			if ch.has_method("cue_touch"):
				ch.finish()
	print("HIT_FRAME_FILM start: %s vs %s" % [str(f["name"]), str(f["bout"]["opp"]["name"])])
	_go = true


func _process(delta: float) -> bool:
	if not _go:
		return false
	_clock += delta
	if view == null or not is_instance_valid(view):
		view = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
		return _clock > GIVE_UP_S
	if stage == null:
		stage = view.get("stage")
		if stage == null:
			return false
		seen_gaps = (stage.hit_gaps as Array).size()
		var order := []
		for ch in (stage.boxers[0]["skel"] as Skeleton3D).get_children():
			if ch is SkeletonModifier3D:
				order.append(str(ch.name))
		print("HIT_FRAME_FILM modifier order: ", ", ".join(order))
	_drive()
	_mix()
	if side:
		_side_cam()
	_grab()
	_catch()
	if _clock > GIVE_UP_S or (want.values().all(func(n): return int(n) <= 0) and shots.is_empty()):
		_finish()
		return true
	return false


## POWER1 step 4: every second landed jab, cross or lead hook not yet fired goes to a lead or a rear uppercut in turn, while
## uppercuts are wanted.
func _mix() -> void:
	if int(want["lead_uppercut"]) <= 0 and int(want["rear_uppercut"]) <= 0:
		return
	var beats: Array = view.beats
	for i in range(int(view.next), beats.size()):
		var b: Dictionary = beats[i]
		if b.has("_film_mix"):
			continue
		b["_film_mix"] = true
		if str(b.get("move", "")) in ["jab", "cross", "lead_hook"] and str(b.get("result", "")) == "lands" and not bool(b.get("big", false)):
			mix_n += 1
			if mix_n % 2 == 0:
				b["move"] = "lead_uppercut" if mix_n % 4 == 0 else "rear_uppercut"
				b.erase("tell")


## trace=1: what drives the hitting arm on each frame after a hit (the clip, its time and speed, the reach, the cut to guard).
var trace := false
var _prev_at := Vector3.ZERO
func _trace(s: Dictionary, f: int) -> void:
	var who := int(s["hitter"])
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	var pr: Node = stage.boxers[who].get("reach")
	var hand := str(s["hand"])
	var skel: Skeleton3D = stage.boxers[who]["skel"]
	var head := skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head")).origin
	print("HIT_FRAME_FILM trace %s f%02d clip %s at %.3f speed %.2f | reach clip %s w %.2f fades %s | cut %s | glove over her head %.3f m" % [
		str(s["dir"]).get_file(), f, ap.current_animation, ap.current_animation_position, ap.speed_scale, str(pr.get("_clip")),
		float(pr.get("_w_now")), str((pr.get("_fades") as Dictionary).keys()), str(stage._cut[who]), stage.glove_front(who, hand).y - head.y])
	# S448 diagnosis: is the drawn glove on the reach's aim, and can the arm reach it?
	pr.set_meta("dbg", true)
	print("HIT_FRAME_FILM frame %s f%02d k%d" % [str(s["dir"]).get_file(), f, Engine.get_process_frames()])
	var at: Vector3 = pr.get("_last_at")
	if not at.is_finite():
		at = pr.get("_aim_w")
	var ids = (pr.get("_arms") as Dictionary).get(str(pr.get("_hand")), [])
	if not (at.is_finite() and ids != null and ids.size() >= 3):
		print("HIT_FRAME_FILM aim %s f%02d none: last_at %s aim_w %s hand %s arms %s" % [str(s["dir"]).get_file(), f, str(pr.get("_last_at")), str(pr.get("_aim_w")), str(pr.get("_hand")), str((pr.get("_arms") as Dictionary).keys())])
	else:
		var sh := skel.global_transform * skel.get_bone_global_pose(int(ids[0])).origin
		var el := skel.global_transform * skel.get_bone_global_pose(int(ids[1])).origin
		var wr := skel.global_transform * skel.get_bone_global_pose(int(ids[2])).origin
		print("HIT_FRAME_FILM aim %s f%02d drawn-to-aim %.3f m | shoulder-to-aim %.3f m arm %.3f m | aim moved %.3f m | lastw %.2f" % [
			str(s["dir"]).get_file(), f, stage.glove_front(who, hand).distance_to(at), sh.distance_to(at),
			sh.distance_to(el) + el.distance_to(wr), at.distance_to(_prev_at), float(pr.get("_last_w"))])
		var sc: Vector3 = pr.get("_shown_cur")
		var mods := []
		for c in skel.get_children():
			if c is SkeletonModifier3D and (c as SkeletonModifier3D).active:
				mods.append(c.name)
		print("HIT_FRAME_FILM shown %s f%02d reach-shown-to-aim %.3f m | mods %s" % [str(s["dir"]).get_file(), f, sc.distance_to(at) if sc.is_finite() else -1.0, str(mods) if f == 19 else ""])
		_prev_at = at


## side=1: the camera square to the pair's line, boxer 0 on the left (set each frame before the stage draws).
func _side_cam() -> void:
	if side_cam == null:
		side_cam = Camera3D.new()
		side_cam.fov = 58.0
		stage.add_child(side_cam)
	var a: Vector3 = (stage.boxers[0]["node"] as Node3D).global_position
	var b: Vector3 = (stage.boxers[1]["node"] as Node3D).global_position
	var line := Vector3(b.x - a.x, 0.0, b.z - a.z).normalized()
	var mid := (a + b) * 0.5
	var out := line.cross(Vector3.UP)   # boxer 0 on the left as seen from here
	side_cam.global_position = mid - out * SIDE_M + Vector3.UP * 1.75   # over the top rope
	side_cam.look_at(mid + Vector3.UP * 1.15, Vector3.UP)
	side_cam.current = true


## The frame drawn now, cropped round the pair (the midpoint of the two heads as the camera shows it).
func _grab() -> void:
	# The ring is drawn in its own viewport (the fight layer's SubViewport), through the stage's broadcast camera.
	var cam: Camera3D = side_cam if side_cam != null else stage.camera
	var vp: Viewport = stage.get_viewport()
	if cam == null or vp == null:
		return
	var mid := Vector3.ZERO
	for bx in stage.boxers:
		var skel: Skeleton3D = bx["skel"]
		mid += skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head")).origin
	var p := cam.unproject_position(mid * 0.5 + Vector3.DOWN * 0.25)
	var img := vp.get_texture().get_image()
	if img == null or img.get_width() < CROP.x or img.get_height() < CROP.y:
		return
	var x := clampi(int(p.x) - CROP.x / 2, 0, img.get_width() - CROP.x)
	var y := clampi(int(p.y) - CROP.y / 2, 0, img.get_height() - CROP.y)
	var cut := img.get_region(Rect2i(Vector2i(x, y), CROP))
	ring.append(cut)
	var at := []
	for i in 2:
		at.append({"LeftHand": stage.glove_front(i, "LeftHand"), "RightHand": stage.glove_front(i, "RightHand"),
			"face": stage.target_point(i, false)})
	at.append(ClashMeter.worst(stage))
	gring.append(at)
	if ring.size() > PRE_F + 1:
		ring.pop_front()
		gring.pop_front()
	for s in shots:
		if int(s["left"]) > 0:
			if trace:
				_trace(s, PRE_F + 1 + POST_F - int(s["left"]))
			cut.save_png("%s/f%02d.png" % [s["dir"], PRE_F + 1 + POST_F - int(s["left"])])
			(s["pts"] as Array).append(at)
			s["left"] = int(s["left"]) - 1
			if int(s["left"]) == 0:
				_speeds(s)
	shots = shots.filter(func(s): return int(s["left"]) > 0)


## The hitting glove front as drawn, frame by frame: its speed and how far it is from her face (the hit is f<PRE_F+1>).
func _speeds(s: Dictionary) -> void:
	var pts: Array = s["pts"]
	var who := int(s["hitter"])
	var hand := str(s["hand"])
	var rows := PackedStringArray()
	var peak := 0.0
	var at_hit := 0.0
	for i in range(1, pts.size()):
		var a: Vector3 = (pts[i - 1] as Array)[who][hand]
		var b: Vector3 = (pts[i] as Array)[who][hand]
		var v := a.distance_to(b) * 60.0
		var f := int(s["first"]) + i
		if f <= PRE_F + 1:
			peak = maxf(peak, v)
		if f == PRE_F + 1:
			at_hit = v
		rows.append("f%02d %.1f m/s %.3f m" % [f, v, b.distance_to((pts[i] as Array)[1 - who]["face"])])
	var line := "HIT_FRAME_FILM %s speeds (glove front as drawn, m/s, distance to her face): %s" % [str(s["dir"]).get_file(), ", ".join(rows)]
	print(line)
	print("HIT_FRAME_FILM %s top speed before the hit %.1f m/s, arriving on the hit frame %.1f m/s (%.0f%%)" % [str(s["dir"]).get_file(),
		peak, at_hit, 100.0 * at_hit / maxf(peak, 0.001)])
	# S468 C394: the deepest any glove or forearm of one is inside the other's, per drawn frame (tools/clash_meter.gd).
	var crow := PackedStringArray()
	var deep := 0
	var worst := -9.0
	var worst_f := 0
	for i in pts.size():
		var cl: Dictionary = (pts[i] as Array)[2]
		var f := int(s["first"]) + i
		if f < PRE_F + 1:
			continue   # his marks are from the hit on
		if float(cl["depth"]) > CLASH_M:
			deep += 1
			crow.append("f%02d %.3f %s drift w %.3f e %.3f" % [f, float(cl["depth"]), str(cl["pair"]), (cl["drift"] as Vector2).x, (cl["drift"] as Vector2).y])
			print("HIT_FRAME_FILM clashdbg f%02d depth %.3f %s
    0: %s
    1: %s" % [f, float(cl["depth"]), str(cl["pair"]), str(cl.get("dbg0", "")), str(cl.get("dbg1", ""))])
		if float(cl["depth"]) > worst:
			worst = float(cl["depth"])
			worst_f = f
	var cline := "HIT_FRAME_FILM %s CLASH frames deeper than %.2f m from the hit on: %d, worst %.3f m at f%02d | %s" % [str(s["dir"]).get_file(), CLASH_M, deep, worst, worst_f, ", ".join(crow)]
	print(cline)
	labels.append("   " + cline.substr(15))
	labels.append("   " + line.substr(15))
	labels.append("   top %.1f m/s, on the hit frame %.1f m/s (%.0f%%)" % [peak, at_hit, 100.0 * at_hit / maxf(peak, 0.001)])


## A landed jab or cross: the contact PunchRange.record just wrote (HitImpact.hit, this frame). The ring holds this frame
## last: it is saved as f<PRE_F>, the frames before it under it.
func _catch() -> void:
	var gaps: Array = stage.hit_gaps
	while seen_gaps < gaps.size():
		var g: Dictionary = gaps[seen_gaps]
		seen_gaps += 1
		var move := str(g.get("move", ""))
		if bool(g.get("cut", false)) or not want.has(move) or int(want[move]) <= 0 or not shots.is_empty():
			continue
		want[move] = int(want[move]) - 1
		var dir := "%s/%02d_%s" % [out_dir, shot_n, move]
		DirAccess.make_dir_recursive_absolute(dir)
		var first := PRE_F + 1 - ring.size()
		for i in ring.size():
			(ring[i] as Image).save_png("%s/f%02d.png" % [dir, first + i])
		var label := "%02d %s clip=%s contact=%.3f speed=%.2f glove-off-face=%.3f m hit=f%02d t=%.2f" % [shot_n, move,
			str(g.get("clip", "")), float(g.get("contact", 0.0)), float(g.get("speed", 1.0)), float(g.get("miss", 0.0)), PRE_F + 1, _clock]
		labels.append(label)
		shot_n += 1
		print("HIT_FRAME_FILM ", label)
		var hitter := 0 if str((stage.boxers[0]["ap"] as AnimationPlayer).assigned_animation) == str(g.get("clip", "")) else 1
		var pr: Node = stage.boxers[hitter].get("reach")
		var hand := str(pr.get("_hand")) if pr != null and str(pr.get("_hand")) != "" else "LeftHand"
		shots.append({"dir": dir, "left": POST_F, "pts": gring.duplicate(), "first": first, "hitter": hitter, "hand": hand})


func _finish() -> void:
	var f := FileAccess.open(out_dir + "/hits.txt", FileAccess.WRITE)
	for l in labels:
		f.store_line(str(l))
	f.close()
	print("HIT_FRAME_FILM shots=%d" % shot_n)


## The corner's shout bar and the corner minute: picked as a player would, so the rounds run on.
func _drive() -> void:
	var bar: Node = view.get("_shouting")
	if bar != null and is_instance_valid(bar):
		if not picked.has(bar.get_instance_id()):
			picked[bar.get_instance_id()] = true
			bar.call("_pick", "body" if bar.find_child("Shout_body", true, false) != null else "")
		return
	if bool(view.playing):
		return
	for ch in view.get_children():
		if not ch.has_method("cue_walk_out") or picked.has(ch.get_instance_id()):
			continue
		var ui: Node = ch.get("ui")
		var card: Node = ui.get("_card") if ui != null else null
		if card == null or not bool(card.get("visible")):
			return
		picked[ch.get_instance_id()] = true
		ch.call("_pick", "body")
		ch.call("finish")


func _tidy(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
