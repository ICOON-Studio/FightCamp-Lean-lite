extends SceneTree
## S320 (operator: "some hits seem to register even when opponent is way to far"): plays fight night like the board's
## 'Test: fight night WITH film study' and reports, for every landed punch, how far the striking glove is from the place
## it lands at the contact (FightStage.hit_gaps), by range phase and by punch. A real landed punch touches: > MISS_M reads
## as a hit from too far. Run windowed on the never-shown desktop (the poses need a picture):
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/hit_gap_probe.gd [-- secs=150 <arms>]
## Prints HIT_GAP lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FastDraw := preload("res://tools/fast_draw.gd")
const LayerTrace := preload("res://tools/layer_trace.gd")
const MISS_M := 0.15

var main: Node


func _initialize() -> void:
	var secs := 150.0
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("secs="):
			secs = float(str(a).trim_prefix("secs="))
	FastDraw.begin()
	root.size = Vector2i(1280, 720)
	## S379 (operator: "the holo head pointer is cut"): the hidden desktop gives a 1920x1009 window, the expanded picture
	## was 2055 wide and the 1920 movie cut ~65 px off each side - keep the picture 16:9 for films.
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("HIT_GAP reached fight night: ", TestJump.run(main, "fight"), " arms ", OS.get_cmdline_user_args())
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	# S470: for every punch shown far off, name each layer that moved the hitter's hands on the frame of the hit.
	LayerTrace.attach(view.stage)
	var seen := [0]
	await _until(func():
		var hg: Array = view.stage.hit_gaps
		while seen[0] < hg.size():
			var r: Dictionary = hg[seen[0]]
			seen[0] += 1
			# S470: PunchRange.record reads the glove when the hit fires, BEFORE that frame's arm layers run - the glove of
			# the frame before. A cross at 5 m/s read 0.17 m short that was 0.05 m off in the picture drawn for the hit.
			# `shown` = the same glove against the same aim after the frame's layers: what the viewer sees on the hit.
			r["at_event"] = float(r["miss"])
			var prh: Node = view.stage.boxers[int(r["hitter"])].get("reach")
			if prh != null and str(prh.get("_hand")) != "" and (prh.get("_target") as Callable).is_valid():
				r["drawn"] = (view.stage.glove_front(int(r["hitter"]), str(prh.get("_hand"))) as Vector3).distance_to((prh.get("_target") as Callable).call())
				# ... but on that frame her head has started to snap away (a clean uppercut read 0.01 then 0.18): the punch
				# touches when EITHER frame has the glove on the target. miss = the nearer of the two.
				r["miss"] = minf(float(r["miss"]), float(r["drawn"]))
			if float(r["miss"]) > MISS_M and not bool(r.get("cut", false)):
				print("HIT_GAP arm %s: %s" % [r["move"], _arm(view.stage, int(r["hitter"]))])
				print("HIT_GAP range %s: at arming [gap shown, need, lunge, step-in rest, time to hit] %s, gap at the hit %.2f, hitter still stepping %.2f s, aim_m %.2f" % [r["move"], str(r.get("dbg", [])), float(r["gap"]), float(view.stage.boxers[int(r["hitter"])].get("move_left", -1.0)), float(view.stage.boxers[int(r["hitter"])].get("aim_m", -1.0))])
				print("HIT_GAP layers %s miss %.2f t %.1f target y %.2f glove y %.2f: %s" % [r["move"], r["miss"], float(view.t), float(r.get("ty", -1.0)), float(r.get("gy", -1.0)), LayerTrace.trail(view.stage, int(r["hitter"]))])
		return not bool(view.playing) or float(view.t) > secs, secs * 2.0 + 30.0)
	# S321: a punch cut off before it arrived shows no hit (FightStage.hit) - only the hits the viewer sees count.
	var all_rows: Array = view.stage.hit_gaps
	var rows: Array = all_rows.filter(func(r): return not bool(r.get("cut", false)))
	print("HIT_GAP cut off (no hit shown, not counted): %d of %d" % [all_rows.size() - rows.size(), all_rows.size()])
	var misses: Array = rows.map(func(r): return float(r["miss"]))
	misses.sort()
	var pc := func(q: float) -> float: return float(misses[int(misses.size() * q)]) if not misses.is_empty() else -1.0
	var far := rows.filter(func(r): return float(r["miss"]) > MISS_M)
	print("HIT_GAP landed %d in %.0f s | glove to target at contact m: p50 %.3f p90 %.3f max %.3f | > %.2f m: %d (%.0f %%)" % [
		rows.size(), float(view.t), pc.call(0.5), pc.call(0.9), misses[-1] if not misses.is_empty() else -1.0, MISS_M, far.size(),
		100.0 * far.size() / maxf(1.0, rows.size())])
	for key in ["phase", "move"]:
		var d := {}
		for r in rows:
			var k := str(r[key])
			if not d.has(k):
				d[k] = [0, 0, 0.0]
			d[k][0] += 1
			d[k][1] += 1 if float(r["miss"]) > MISS_M else 0
			d[k][2] = maxf(float(d[k][2]), float(r["miss"]))
		var parts := []
		for k in d:
			parts.append("%s %d far %d max %.2f" % [k, d[k][0], d[k][1], d[k][2]])
		print("HIT_GAP by %s: %s" % [key, ", ".join(parts)])
	for r in far.slice(0, 12):
		var lf: Array = r.get("land_f", [])
		if lf.size() == 3:
			print("HIT_GAP timing: armed at clip %.2f s, hit due %.2f s later, came %.2f s later (%d frames)" % [float(lf[2]), float(lf[1]), (int(r["now_f"]) - int(lf[0])) / 30.0, int(r["now_f"]) - int(lf[0])])
		print("HIT_GAP far: %s %s miss %.2f m (when the hit fired %.2f, drawn that frame %.2f; then: ahead %+.2f left %+.2f up %+.2f) pelvis gap %.2f m reach weight %.2f glove pushes %d | clip %s at %.2f s, contact %.2f s, speed %.2f" % [
			r["move"], r["phase"], r["miss"], r.get("at_event", -1.0), r.get("drawn", -1.0), r.get("fwd", 0.0), r.get("side", 0.0), r.get("up", 0.0), r["gap"], r.get("w", -1.0), r.get("push", -1), r.get("clip", "?"), r.get("pos", -1.0), r.get("contact", -1.0), r.get("speed", -1.0)])
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0


## S470: is the hitter's arm out of length, or is the reach held back? Shoulder-to-wrist against the arm's two bones,
## the elbow's angle, and how far the glove stands from the clip's own glove (the cap is ReachLimit.CORR_M).
func _arm(stage: Node, h: int) -> String:
	var pr: Node = stage.boxers[h].get("reach")
	var skel: Skeleton3D = stage.boxers[h]["skel"]
	var hand := str(pr.get("_hand"))
	if hand == "":
		return "no hand armed"
	var ids: Array = (pr.get("_arms") as Dictionary)[hand]
	var s := skel.get_bone_global_pose(int(ids[0])).origin
	var e := skel.get_bone_global_pose(int(ids[1])).origin
	var w := skel.get_bone_global_pose(int(ids[2])).origin
	var sc := skel.global_transform.basis.get_scale().x
	var l1 := s.distance_to(e) * sc
	var l2 := e.distance_to(w) * sc
	var g: Vector3 = stage.glove_front(h, hand)
	# the range model's parts (RangeTable.clip_m) against the live fight, along the hitter's front
	var node: Node3D = stage.boxers[h]["node"]
	var fwd: Vector3 = node.global_transform.basis.orthonormalized().z
	var s_w: Vector3 = skel.global_transform * s
	var aim: Callable = pr.get("_target")
	var tp: Vector3 = aim.call() if aim.is_valid() else Vector3.INF
	var parts: Dictionary = (stage.boxers[h].get("range_parts", {}) as Dictionary).get(str(pr.get("_clip")), {})
	var live := "shoulder ahead of her place %.3f (model %.3f), target ahead of the other's place %.3f (model %.3f), shoulder to target %.3f (model reach %.3f, side %.3f up %.3f; live side %.3f up %.3f)" % [
		(s_w - (node.global_position)).dot(fwd), float(parts.get("s_fwd", -9.0)), ((stage.boxers[1 - h]["node"] as Node3D).global_position - tp).dot(fwd), float(parts.get("face_fwd", -9.0)),
		s_w.distance_to(tp), float(parts.get("reach", -9.0)), float(parts.get("side", -9.0)), float(parts.get("up", -9.0)), absf((tp - s_w).dot(fwd.cross(Vector3.UP))), tp.y - s_w.y]
	var cg: Vector3 = pr.get_meta("cg_w", Vector3.INF)
	return "shoulder to wrist %.3f of %.3f m (elbow %.0f deg), glove %.3f m from the clip glove, carried %.3f, hit_w set %s" % [
		s.distance_to(w) * sc, l1 + l2, rad_to_deg((s - e).angle_to(w - e)), g.distance_to(cg) if cg.is_finite() else -1.0,
		float(pr.call("_carried", 0.0)) if pr.has_method("_carried") else -1.0, str((pr.get("_hit_w") as Vector3).is_finite())] + " | " + live + " | shoulder to glove front %.3f, wrist to glove front %.3f (front %.3f), glove front to target now %.3f" % [s_w.distance_to(g), (skel.global_transform * w).distance_to(g), float(pr.get("_front")), g.distance_to(tp)]
