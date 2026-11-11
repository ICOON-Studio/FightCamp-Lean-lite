extends SceneTree
## CAMLINE2 the fight camera's ruler on the GAME PATH (the maths: scripts/fight3d/CamLine.gd). It plays fight night the
## way tools/fight3d_play.gd does (the same acts, through TestJump.run so the career's seed is pinned and a later run
## plays the same bout): the walk-in, the rounds with the corner's shouts, the corner minute; and reads the live lens.
## Run it windowed on the never-shown desktop, through the queue, at a fixed 60 frames a second:
##   python ops/Tools/godot_slot.py run --who <seat> -- python tools/hidden_desktop.py run --timeout=580 <godot.exe>
##       --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --log-file <log>
##       --script res://tools/cam_line_probe.gd -- bout=fight rounds=2 out=<dir>
## bout=fight | men_fight (two men, another pair); rounds watched at 2x as fight3d_play; out = stills of flagged frames;
## headless with `show3d` it reads the same geometry without pictures.
## EVERY frame: HIDDEN (CamLine.hidden: the head-and-chest box covered by the other body) and BEHIND
## (TvShot.behind_deg); every 0.1 s: the ropes as the game hands them to RingCamera.clear_view (FightStage._ring_side).
## Prints the worst 30 frames (CAMLINE), every shot kind seen (CAMKIND; one never seen is named VOID), the bars (CAMBAR),
## `CAMLINE2 frames=.. hidden_share=.. longest_hidden_s=.. behind_share=.. split_ropes=.. shots=..`, CAM_LINE_PROBE failures=.
## `glove` (with or without `noblur`): THE GLOVES. Round 1 at the game's own 1x pace (pace=2 for 2x); at each punch's
## fastest kept frame the picture as played and the SAME pose drawn with the tree paused (nothing moves, so no motion
## blur can act) are compared along the glove's travel (CamLine.smear):
##   GLOVEBLUR punch=<clip> speed_m_s=<x> smear_px=<x> noblur_px=<x> bleeds=<0|1> ...   then GLOVEBLUR_SUM.

const CamLine := preload("res://scripts/fight3d/CamLine.gd")
const TvShot := preload("res://scripts/fight3d/TvShot.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")
const PoseTap := preload("res://tools/pose_tap.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")

const BONES := ["Head", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "Hips"]
const FPS := 60.0
const ROPE_EVERY := 6          # frames between rope reads (0.1 s)
const KINDS := ["main", "apron", "clinch", "close", "film", "film:intro", "film:corner", "replay"]
const PUNCH_WORDS := ["jab", "cross", "hook", "uppercut", "overhand", "body_shot"]
const PUNCH_M_S := 5.0         # a glove this fast is a punch at speed
const ARM_M_S := 2.5           # pictures are kept from this speed on
const RING_FRAMES := 10
const REACH := 260

var main: Node
var view: Node
var st: Node
var out_dir := ""
var bout := "fight"
var rounds := 2
var pace := 0
var glove := false
var punches := 10
var phase := "intro"
var rows: Array = []           # one per frame read
var rope_n := 0
var rope_stat := {}            # rope id -> [reads faded, faded but not between, split]
var _taps: Array = []
var _cuts := -1
var _cut_age := 9.0
var _last := {"faded_nb": 0, "faded_nb_view": 0, "split": 0, "split_view": 0, "far_head": 0, "far_blur": 0.0, "far_faded": 0}
var _stills := {}
var _best := {"hid": 0.25, "behind": 70.0}
var failures := 0


func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		var s := str(arg)
		if s.begins_with("bout="):
			bout = s.trim_prefix("bout=")
		elif s.begins_with("rounds="):
			rounds = int(s.trim_prefix("rounds="))
		elif s.begins_with("pace="):
			pace = int(s.trim_prefix("pace="))
		elif s.begins_with("punches="):
			punches = int(s.trim_prefix("punches="))
		elif s.begins_with("out="):
			out_dir = s.trim_prefix("out=")
		elif s == "glove":
			glove = true
	if pace == 0:
		pace = 1 if glove else 2
	if out_dir != "":
		DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await _frames(4, false)
	var reached := TestJump.run(main, bout)
	if not reached:
		print("CAMLINE2 bout=%s did not reach fight night" % bout)
		quit(2)
		return
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(main.modal["fid"]))
	if bout == "fight":   # the coach's plan tools/fight3d_play.gd boxes on (it ties up and pivots: the clinch lens is seen)
		f["arrows"] = [{"move": "1-1"}, {"move": "step_back"}, {"move": "tie_up"}, {"move": "pivot_out"}]
	await _frames(4, false)
	main.act("fightstep", "start")
	await _frames(2, false)
	view = main._fight_layer.get_child(0)
	st = view.stage
	var vp := st.get_viewport() as SubViewport
	if DisplayServer.get_name() == "headless":
		if vp.get_parent() is SubViewportContainer:
			(vp.get_parent() as SubViewportContainer).stretch = false
		vp.size = Vector2i(1920, 1080)
	for i in 2:
		var tap: SkeletonModifier3D = PoseTap.new()
		tap.setup(st.boxers[i]["skel"], BONES)
		(st.boxers[i]["skel"] as Skeleton3D).add_child(tap)
		_taps.append(tap)
	var opp: Dictionary = f["bout"]["opp"]
	print("CAMLINE2 bout=%s red=%s (%s, body x%.3f) blue=%s (%s, body x%.3f) picture=%s fps=%d pace=%dx blur=%s" % [bout,
		f["name"], f.get("stance", "orthodox"), (st.boxers[0]["node"] as Node3D).scale.x, opp["name"], opp.get("stance", "orthodox"),
		(st.boxers[1]["node"] as Node3D).scale.x, vp.size, int(FPS), pace, "on" if st.camera.get("_blur") != null else "off"])
	await _frames(150)   # the walk-in's film shots
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	await _frames(2, false)
	if pace == 2:
		FightView.fast = true
		view._toggle_speed()
		view._toggle_speed()
	if glove:
		await _glove_round(vp)
	else:
		await _rounds()
		_totals()
	quit(0 if failures == 0 else 1)


## The rounds, read every frame; the corner's call is picked at each shout (after 0.75 s of the slowed ring).
func _rounds() -> void:
	for r in range(1, rounds + 1):
		phase = "round"
		var held := 0
		while bool(view.playing) and int(view.round_n) == r:
			await process_frame
			_sample()
			if view._shouting != null:
				held += 1
				if held >= 45:
					held = 0
					view._shouting._pick(str(LiveRound.preview(main.career.fighter_by_id(str(view.fid)), main.modal).get("coach", "")))
		print("CAMLINE2 round %d read: %d frames so far%s" % [r, rows.size(), "" if str(view._stop) == "" else " (stopped: %s)" % view._stop])
		if r == rounds or str(view._stop) != "":
			return
		phase = "corner"
		var cm: Node = null
		for ch in view.get_children():
			if ch.has_method("cue_walk_out"):
				cm = ch
		if cm == null:
			print("CAMLINE2 no corner minute after round %d" % r)
			return
		var waited := 0
		while waited < 3000 and not (cm.ui != null and cm.ui._card.visible):
			waited += 1
			await process_frame
			_sample()
		await _frames(60)
		cm._pick("lead")
		cm.finish()
		await _frames(2, false)


func _body(i: int) -> Dictionary:
	var tap: SkeletonModifier3D = _taps[i]
	var xf := tap.get_skeleton().global_transform
	var sh: Dictionary = tap.shown
	var s := float((st.boxers[i]["node"] as Node3D).scale.x)
	var hips: Vector3 = xf * (sh["Hips"] as Vector3)
	var out := {"scale": s, "head": xf * (sh["Head"] as Vector3), "sh_l": xf * (sh["LeftUpperArm"] as Vector3),
		"sh_r": xf * (sh["RightUpperArm"] as Vector3), "el_l": xf * (sh["LeftLowerArm"] as Vector3),
		"el_r": xf * (sh["RightLowerArm"] as Vector3), "hips": hips, "feet": Vector3(hips.x, 0.0, hips.z)}
	var gl: Dictionary = (st.boxers[i]["gloves"] as Node).gloves
	for side in ["l", "r"]:
		var g: Node3D = gl.get(side)
		if g != null:   # the glove's middle: from the wrist along its long axis
			out["hand_" + side] = g.global_position + g.global_transform.basis.y.normalized() * float(st.boxers[i]["front"]) * 0.55 * s
		else:
			out["hand_" + side] = xf * (sh["LeftHand" if side == "l" else "RightHand"] as Vector3)
	return out


func _sample() -> void:
	var cam: Camera3D = st.get_viewport().get_camera_3d()
	if cam == null or _taps.is_empty() or not (_taps[0].shown as Dictionary).has("Head") or not (_taps[1].shown as Dictionary).has("Head"):
		return
	var on_stage: bool = cam == st.camera
	var live: bool = on_stage and bool(view.playing) and not bool(st.scene) and float(view._bell_left) < 0.0
	var kind := "replay"
	if on_stage:
		kind = str(cam.get("shot_name"))
		if not live:
			kind += ":" + ("bell" if bool(view.playing) and not bool(st.scene) else phase)
		_cut_age = 0.0 if int(cam.get("cuts")) != _cuts else _cut_age + 1.0 / FPS
		_cuts = int(cam.get("cuts"))
	var xf := cam.global_transform
	var aspect := TvShot.aspect_of(cam)
	var a := _body(0)
	var b := _body(1)
	var ha := CamLine.hidden(xf, cam.fov, aspect, a, b)
	var hb := CamLine.hidden(xf, cam.fov, aspect, b, a)
	if live and rows.size() % ROPE_EVERY == 0:
		_ropes(cam, xf, aspect, a, b)
	var row := {"f": rows.size(), "r": int(view.round_n), "t": float(view.t), "kind": kind, "live": live, "hid": maxf(ha, hb),
		"face": maxf(CamLine.hidden(xf, cam.fov, aspect, a, b, 1), CamLine.hidden(xf, cam.fov, aspect, b, a, 1)),
		"who": "red" if ha >= hb else "blue", "behind": TvShot.behind_deg(a["hips"], b["hips"], xf.origin),
		"cap": str(view._caption.text) != "", "shout": view._shouting != null, "cut": on_stage and _cut_age < 0.4}
	row.merge(_last)
	rows.append(row)
	if live:
		_flag_stills(row)


## The ropes this 0.1 s, as the game faded them: per rope faded / truly between / two alphas; and the far ropes at the
## height of a head (their alpha and the lens's far blur at their distance).
func _ropes(cam: Camera3D, xf: Transform3D, aspect: float, a: Dictionary, b: Dictionary) -> void:
	var rr := CamLine.rope_rows(st._ring_side)
	var read := CamLine.ropes_read(rr, xf.origin, [a["feet"], b["feet"]])
	var heads: Array = [CamLine.parts(xf, cam.fov, aspect, a)[0]["rect"], CamLine.parts(xf, cam.fov, aspect, b)[0]["rect"]]
	var far_m := maxf(CamLine.project(xf, cam.fov, aspect, a["hips"]).z, CamLine.project(xf, cam.fov, aspect, b["hips"]).z) + 0.3
	var far := CamLine.far_ropes(rr, xf, cam.fov, aspect, heads, far_m, cam.attributes as CameraAttributesPractical)
	rope_n += 1
	_last = {"faded_nb": 0, "faded_nb_view": 0, "split": 0, "split_view": 0, "far_head": far["at_head"], "far_blur": far["blur"], "far_faded": far["faded"]}
	for id in read:
		var r: Dictionary = read[id]
		if not rope_stat.has(id):
			rope_stat[id] = [0, 0, 0]
		var lohi: Array = far["seen"].get(id, [1.0, 1.0])
		if int(r["faded"]) > 0:
			rope_stat[id][0] += 1
			if not bool(r["between"]):
				rope_stat[id][1] += 1
				_last["faded_nb"] += 1
				_last["faded_nb_view"] += 1 if float(lohi[0]) < CamLine.FADED_AT else 0
		if bool(r["split"]):
			rope_stat[id][2] += 1
			_last["split"] += 1
			_last["split_view"] += 1 if float(lohi[1]) - float(lohi[0]) > CamLine.SPLIT_AT else 0


## Stills of what the ruler flags, so its numbers can be checked against the picture (windowed runs only).
func _flag_stills(row: Dictionary) -> void:
	if out_dir == "" or DisplayServer.get_name() == "headless":
		return
	var tag := ""
	if float(row["hid"]) >= float(_best["hid"]) + 0.08:
		_best["hid"] = float(row["hid"])
		tag = "hidden"
	elif float(row["behind"]) <= float(_best["behind"]) - 4.0:
		_best["behind"] = float(row["behind"])
		tag = "behind"
	elif float(row["behind"]) < 58.0 and int(row["f"]) % 300 == 0:
		tag = "band"
	elif int(row["far_faded"]) > 0 and int(row["f"]) % 240 == 0:
		tag = "ropefade"
	if tag == "" or int(_stills.get(tag, 0)) >= 6:
		return
	_stills[tag] = int(_stills.get(tag, 0)) + 1
	var path := out_dir.path_join("%s_r%d_f%05d_%s_hid%.2f_face%.2f_behind%.0f.png" % [bout, row["r"], row["f"], tag, row["hid"], row["face"], row["behind"]])
	(st.get_viewport() as SubViewport).get_texture().get_image().save_png(path)
	print("CAMSTILL %s shot=%s t=%.1f hidden=%.2f (%s) face=%.2f behind_deg=%.0f" % [path, row["kind"], row["t"], row["hid"], row["who"], row["face"], row["behind"]])


func _totals() -> void:
	var live: Array = rows.filter(func(r: Dictionary) -> bool: return bool(r["live"]))
	var n := maxf(1.0, live.size())
	var worst: Array = live.duplicate()
	worst.sort_custom(func(x: Dictionary, y: Dictionary) -> bool: return float(x["hid"]) > float(y["hid"]))
	for i in mini(30, worst.size()):
		var w: Dictionary = worst[i]
		print("CAMLINE shot=%s r=%d t=%.1f hidden=%.2f behind_deg=%.0f faded_far_ropes=%d far_rope_at_head=%d far_blur=%.3f" % [
			w["kind"], w["r"], w["t"], w["hid"], w["behind"], w["far_faded"], w["far_head"], w["far_blur"]])
	var kinds := {}
	for r in rows:
		var k := str(r["kind"])
		if not kinds.has(k):
			kinds[k] = [0, 0, 0, 180.0, 0.0]
		kinds[k][0] += 1
		kinds[k][1] += 1 if float(r["hid"]) >= CamLine.HIDDEN_AT else 0
		kinds[k][2] += 1 if float(r["behind"]) < CamLine.BEHIND_DEG else 0
		kinds[k][3] = minf(float(kinds[k][3]), float(r["behind"]))
		kinds[k][4] = maxf(float(kinds[k][4]), float(r["hid"]))
	for k in kinds:
		print("CAMKIND kind=%s frames=%d (%.1f s) hidden=%.2f%% behind_under_%d=%.2f%% lowest_behind=%.0f highest_hidden=%.2f" % [k, kinds[k][0],
			kinds[k][0] / FPS, 100.0 * kinds[k][1] / kinds[k][0], int(CamLine.BEHIND_DEG), 100.0 * kinds[k][2] / kinds[k][0], kinds[k][3], kinds[k][4]])
	print("CAMVOID shot kinds never seen in this run (the ruler is VOID for them): %s" % [KINDS.filter(func(k: String) -> bool: return not kinds.has(k))])
	for flag in ["cap", "shout", "cut"]:
		var fl: Array = live.filter(func(r: Dictionary) -> bool: return bool(r[flag]))
		print("CAMFLAG %s frames=%d hidden=%.2f%% highest_hidden=%.2f lowest_behind=%.0f" % [
			{"cap": "caption_on", "shout": "corner_call_open", "cut": "first_0.4s_of_a_cut"}[flag], fl.size(),
			100.0 * _count(fl, "hid", CamLine.HIDDEN_AT, true) / maxf(1.0, fl.size()),
			fl.reduce(func(m: float, r: Dictionary) -> float: return maxf(m, float(r["hid"])), 0.0),
			fl.reduce(func(m: float, r: Dictionary) -> float: return minf(m, float(r["behind"])), 180.0)])
	# The ladder: the same reads at other lines than the bars', so the reader sees where the lens spends its time.
	for step in [["hid", 0.2, true], ["hid", 0.4, true], ["hid", 0.6, true], ["face", 0.6, true], ["behind", 30.0, false], ["behind", 45.0, false],
			["behind", 58.0, false], ["behind", 64.0, false], ["behind", 75.0, false]]:
		var lr := CamLine.longest_run(rows, step[0], step[1], step[2])
		var end: Dictionary = rows[int(lr[1])] if int(lr[1]) >= 0 else {}
		print("CAMLADDER %s %s %.1f: %.2f%% of live frames, longest run %.2f s%s" % [{"hid": "hidden", "face": "head_covered", "behind": "behind_deg"}[step[0]],
			"at least" if bool(step[2]) else "under", step[1], 100.0 * _count(live, step[0], step[1], step[2]) / n, int(lr[0]) / FPS,
			"" if end.is_empty() else " (ends %s r%d t=%.1f)" % [end["kind"], end["r"], end["t"]]])
	var reads: Array = live.filter(func(r: Dictionary) -> bool: return int(r["f"]) % ROPE_EVERY == 0)
	var at_head: Array = reads.filter(func(r: Dictionary) -> bool: return int(r["far_head"]) == 1)
	for id in rope_stat:
		print("CAMROPE rope=%d (%s side, %.2f m) faded in %d of %d reads, faded but NOT between the lens and a boxer in %d, two alphas in %d" % [
			id, ["north", "east", "south", "west"][int(id) % 4], [0.45, 0.85, 1.25][int(id) / 4], rope_stat[id][0], rope_n, rope_stat[id][1], rope_stat[id][2]])
	print("CAMROPES reads=%d faded_not_between=%d (in the picture %d) split_ropes=%d (in the picture %d) | a far rope at head height in %d reads: faded there in %d, far blur there highest %.3f mean %.3f (the lens's full blur %.2f)" % [
		reads.size(), _count(reads, "faded_nb", 1.0, true), _count(reads, "faded_nb_view", 1.0, true), _count(reads, "split", 1.0, true),
		_count(reads, "split_view", 1.0, true), at_head.size(), _count(at_head, "far_faded", 1.0, true),
		at_head.reduce(func(m: float, r: Dictionary) -> float: return maxf(m, float(r["far_blur"])), 0.0),
		at_head.reduce(func(m: float, r: Dictionary) -> float: return m + float(r["far_blur"]), 0.0) / maxf(1.0, at_head.size()),
		(st.camera.attributes as CameraAttributesPractical).dof_blur_amount])
	var hidden_share := 100.0 * _count(live, "hid", CamLine.HIDDEN_AT, true) / n
	var hid_run := int(CamLine.longest_run(rows, "hid", CamLine.HIDDEN_AT, true)[0]) / FPS
	_bar("hidden_share", hidden_share, CamLine.HIDDEN_SHARE_MAX * 100.0, "%")
	_bar("longest_hidden_s", hid_run, CamLine.HIDDEN_RUN_MAX_S, " s")
	_bar("longest_behind_s", int(CamLine.longest_run(rows, "behind", CamLine.BEHIND_DEG, false)[0]) / FPS, CamLine.BEHIND_RUN_MAX_S, " s")
	_bar("faded_not_between", _count(reads, "faded_nb", 1.0, true), 0.5, " reads")
	_bar("split_ropes", _count(reads, "split", 1.0, true), 0.5, " reads")
	print("CAMLINE2 frames=%d hidden_share=%.2f%% longest_hidden_s=%.2f behind_share=%.2f%% split_ropes=%d shots=%s" % [live.size(), hidden_share,
		hid_run, 100.0 * _count(live, "behind", CamLine.BEHIND_DEG, false) / n, _count(reads, "split", 1.0, true), kinds.keys()])
	print("CAM_LINE_PROBE failures=%d" % failures)


func _count(list: Array, key: String, at: float, at_least: bool) -> int:
	var k := 0
	for r in list:
		if (float(r[key]) >= at) == at_least:
			k += 1
	return k


func _bar(name: String, value: float, under: float, unit: String) -> void:
	var ok := value < under
	print("CAMBAR %s %.2f%s bar: under %.2f -> %s" % [name, value, unit, under, "PASS" if ok else "FAIL (red)"])
	if not ok:
		failures += 1


## THE GLOVES: round 1, every frame after it is drawn; from ARM_M_S on the picture is kept twice (as played, and the
## same pose with the tree paused two frames); the kept frame nearest a glove's peak speed is measured.
func _glove_round(vp: SubViewport) -> void:
	if DisplayServer.get_name() == "headless":
		print("GLOVEBLUR needs a picture (run windowed)")
		failures = 1
		return
	var ring: Array = []
	var prev: Array = []
	var track: Array = [{}, {}, {}, {}]   # per glove (red l, red r, blue l, blue r) while a punch is tracked: {max, kept, id}
	var cool := [0.0, 0.0, 0.0, 0.0]
	var recs: Array = []
	var skipped := 0
	var id := 0
	var since := 9   # frames played since the last paused one
	var drawn := Time.get_ticks_usec()
	while recs.size() < punches and bool(view.playing) and id < 60000:
		await RenderingServer.frame_post_draw
		var ms := (Time.get_ticks_usec() - drawn) / 1000.0
		drawn = Time.get_ticks_usec()
		id += 1
		since += 1
		if view._shouting != null:
			view._shouting._pick(str(LiveRound.preview(main.career.fighter_by_id(str(view.fid)), main.modal).get("coach", "")))
		var cam: Camera3D = vp.get_camera_3d()
		var live: bool = cam == st.camera and not bool(st.scene) and float(view._bell_left) < 0.0 and absf(Engine.time_scale - pace) < 0.01
		var dt := root.get_process_delta_time()
		if not live or dt <= 0.0 or not (_taps[0].shown as Dictionary).has("Head"):
			prev = []
			continue
		var e := {"id": id, "ms": ms, "pos": [], "px": [], "w": [], "clip": [], "shot": str(cam.get("shot_name")), "t": float(view.t)}
		var right := cam.global_transform.basis.x.normalized()
		var bodies := [_body(0), _body(1)]
		for i in 2:
			e["clip"].append(str((st.boxers[i]["ap"] as AnimationPlayer).current_animation))
			for side in ["l", "r"]:
				var p: Vector3 = bodies[i]["hand_" + side]
				var r := right * CamLine.GLOVE_R_M * float(bodies[i]["scale"])
				e["pos"].append(p)
				e["px"].append(cam.unproject_position(p))
				e["w"].append(cam.unproject_position(p + r).distance_to(cam.unproject_position(p - r)))
		var speeds: Array = []
		var fastest := 0.0
		for g in 4:
			speeds.append((e["pos"][g] as Vector3).distance_to(prev[g]) / dt if prev.size() == 4 else 0.0)
			fastest = maxf(fastest, float(speeds[g]))
		prev = e["pos"]
		# A played frame carries its whole motion blur only when the frame before it was played too (the renderer keeps a
		# skinned body's last pose for one frame): the pictures are kept on every second fast frame.
		if since >= 2 and (fastest >= ARM_M_S or track.any(func(x: Dictionary) -> bool: return not x.is_empty())):
			e["m"] = vp.get_texture().get_image()
			e["marks"] = _marks(cam, right, bodies)
			paused = true
			for k in 2:
				await RenderingServer.frame_post_draw
			drawn = Time.get_ticks_usec()
			e["s"] = vp.get_texture().get_image()
			paused = false
			since = 0
		ring.append(e)
		if ring.size() > RING_FRAMES:
			ring.pop_front()
		for g in 4:
			cool[g] = float(cool[g]) - dt
			var v := float(speeds[g])
			if (track[g] as Dictionary).is_empty():
				if v < PUNCH_M_S or float(cool[g]) > 0.0:
					continue
				track[g] = {"max": 0.0, "kept": 0.0, "id": -1}
			var tr: Dictionary = track[g]
			tr["max"] = maxf(float(tr["max"]), v)
			if e.has("s") and v > float(tr["kept"]):
				tr["kept"] = v
				tr["id"] = id
			if v < float(tr["max"]) * 0.7:
				var rec := _glove_read(ring, int(tr["id"]), g, float(tr["kept"]), float(tr["max"]), recs.size() + 1)
				if rec.is_empty():
					skipped += 1
				else:
					recs.append(rec)
				track[g] = {}
				cool[g] = 0.3
	var ratios: Array = recs.map(func(r: Dictionary) -> float: return float(r["ratio"]))
	ratios.sort()
	print("GLOVEBLUR_SUM punches=%d pace=%dx fps=%d blur=%s smear_over_glove median=%.2f highest=%.2f over_%.1fx=%d bleeds=%d ghosts=%d skipped=%d mean_frame_ms=%.1f" % [
		recs.size(), pace, int(FPS), "on" if st.camera.get("_blur") != null else "off",
		float(ratios[ratios.size() / 2]) if not ratios.is_empty() else 0.0, float(ratios[-1]) if not ratios.is_empty() else 0.0, CamLine.SMEAR_MAX,
		recs.filter(func(r: Dictionary) -> bool: return float(r["ratio"]) > CamLine.SMEAR_MAX).size(),
		recs.filter(func(r: Dictionary) -> bool: return int(r["bleeds"]) == 1).size(),
		recs.filter(func(r: Dictionary) -> bool: return int(r["ghosts"]) > 0).size(), skipped,
		recs.reduce(func(m: float, r: Dictionary) -> float: return m + float(r["ms"]), 0.0) / maxf(1.0, recs.size())])
	_bar("glove_smear_highest", float(ratios[-1]) if not ratios.is_empty() else 0.0, CamLine.SMEAR_MAX + 0.005, " x the glove")
	_bar("glove_bleeds", recs.filter(func(r: Dictionary) -> bool: return int(r["bleeds"]) == 1).size(), 0.5, " punches")
	_bar("punches_not_measured", punches - recs.size(), 0.5, "")


## What lies behind a glove in the picture: both heads (middle, radius in pixels) and every solid rope piece (its two
## ends, half its thickness in pixels).
func _marks(cam: Camera3D, right: Vector3, bodies: Array) -> Dictionary:
	var heads: Array = []
	for body in bodies:
		var s := float(body["scale"])
		var at: Vector3 = (body["head"] as Vector3) + Vector3.UP * CamLine.HEAD_UP_M * s
		heads.append([cam.unproject_position(at), cam.unproject_position(at + right * CamLine.HEAD_R_M * s).distance_to(cam.unproject_position(at))])
	var ropes: Array = []
	for row in CamLine.rope_rows(st._ring_side):
		if int(row["rope"]) < 0 or float(row["alpha"]) < 0.5 or cam.is_position_behind(row["a"]) or cam.is_position_behind(row["b"]):
			continue
		var a := cam.unproject_position(row["a"])
		ropes.append([a, cam.unproject_position(row["b"]), cam.unproject_position((row["a"] as Vector3) + right * 0.018).distance_to(a) + 1.5])
	return {"heads": heads, "ropes": ropes}


## One punch (glove g) at the kept frame nearest its peak speed `top`: the smear along its travel. {} when it cannot
## be read (and says why).
func _glove_read(ring: Array, peak: int, g: int, speed: float, top: float, n: int) -> Dictionary:
	var e: Dictionary = {}
	var before: Dictionary = {}
	for x in ring:
		if int(x["id"]) == peak:
			e = x
		elif int(x["id"]) < peak:
			before = x
	var who := g / 2
	var clip := str(e["clip"][who]) if not e.is_empty() else "?"
	var why := ""
	if e.is_empty() or before.is_empty() or not e.has("s") or speed < 0.8 * top:
		why = "no kept frame near the peak (kept at %.1f of %.1f m/s)" % [speed, top]
	elif not PUNCH_WORDS.any(func(w: String) -> bool: return clip.contains(w)) or clip.contains("hit"):
		why = "not a punch clip"
	var at: Vector2 = e["px"][g] if why == "" else Vector2.ZERO
	var dir: Vector2 = at - (before["px"][g] as Vector2) if why == "" else Vector2.RIGHT
	if why == "" and dir.length() < 2.0:
		why = "no travel on screen (%.1f px a frame)" % dir.length()
	var res: Dictionary = CamLine.smear(e["s"], e["m"], at, dir, 6, REACH) if why == "" else {}
	if why == "":
		var col: Color = res["glove"]
		var wide := float(e["w"][g])
		if (who == 0 and col.r < 1.4 * maxf(col.g, col.b)) or (who == 1 and col.b < 1.2 * maxf(col.r, col.g)):
			why = "the glove's middle is covered (colour there %s)" % col.to_html(false)
		elif float(res["still_px"]) < 0.4 * wide or float(res["still_px"]) > 2.2 * wide:
			why = "the glove's edge cannot be told from what is behind it (%d px read, the glove is %.0f px)" % [res["still_px"], wide]
	if why != "":
		print("GLOVESKIP clip=%s glove=%s %s speed_m_s=%.1f: %s" % [clip, ["red", "blue"][who], ["l", "r"][g % 2], speed, why])
		return {}
	var on: Array = CamLine.bleed(res, at, dir, e["marks"]["heads"], e["marks"]["ropes"])
	var ratio := float(res["smear_px"]) / float(res["still_px"])
	var bleeds := 1 if int(on[0]) + int(on[1]) >= 4 else 0
	var box := Rect2i(Vector2i(at) - Vector2i(240, 150), Vector2i(480, 300)).intersection(Rect2i(Vector2i.ZERO, (e["m"] as Image).get_size()))
	print("GLOVEBLUR punch=%s speed_m_s=%.1f smear_px=%d noblur_px=%d bleeds=%d | n=%d glove=%s %s ratio=%.2f peak_m_s=%.1f glove_width_px=%.0f travel_px_a_frame=%.1f core=%.2f ghosts=%d on_face_px=%d on_rope_px=%d picture_gap=%.4f shot=%s t=%.1f frame_ms=%.1f" % [
		clip, speed, res["smear_px"], res["still_px"], bleeds, n, ["red", "blue"][who], ["l", "r"][g % 2], ratio, top, e["w"][g], dir.length(),
		res["core"], res["ghosts"], on[0], on[1], CamLine.picture_gap(e["s"], e["m"], box), e["shot"], e["t"], e["ms"]])
	if out_dir != "":
		(e["m"] as Image).get_region(box).save_png(out_dir.path_join("glove%02d_%s_played.png" % [n, clip]))
		(e["s"] as Image).get_region(box).save_png(out_dir.path_join("glove%02d_%s_still.png" % [n, clip]))
	return {"ratio": ratio, "bleeds": bleeds, "ghosts": int(res["ghosts"]), "ms": float(e["ms"])}


func _frames(n: int, read: bool = true) -> void:
	for i in n:
		await process_frame
		if read:
			_sample()
