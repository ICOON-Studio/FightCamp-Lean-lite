extends SceneTree
## S391 the footwork rig in a real fight (RingFeet.gd): plays fight night and reads the DRAWN legs (skeleton_updated, after every
## modifier) each in-round frame. One RING_FEET line a boxer, plus glove-to-target at contact (the arms' IK must still land):
##   rig share (frames the rig has the legs), feet moving share (either foot in a swing; real boxers 53-56 %), step pairs a minute,
##   planted skate (drawn toes moving while the plan holds that foot: mm a frame p50/p99, m/s max), planted lift (toes over their
##   standing height, cm p99), feet crossed (frames the two balls swap sides in her frame), knee (inner angle p50/p99, locked
##   > 170 deg share, shake = RMS 2nd difference of the bend, deg), shown off her place (m p50/p90/max), ball-to-ball in/across.
##   python tools/hidden_desktop.py run --timeout=590 <godot.exe> --path . --windowed --resolution 1280x720 --audio-driver Dummy \
##       --fixed-fps 30 --script res://tools/ring_feet_probe.gd [-- secs=120 fastdraw <arms>]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FastDraw := preload("res://tools/fast_draw.gd")
const MISS_M := 0.15
const TOES := ["LeftToes", "RightToes"]
const LEGS := [["LeftUpperLeg", "LeftLowerLeg", "LeftFoot"], ["RightUpperLeg", "RightLowerLeg", "RightFoot"]]

var main: Node
var view: Node
var st: Array = [{}, {}]


const BOOT_TOUCH_M := 0.09
var boots_frames := 0
var boots_min := 9.0
var boots_by := {}
var boots_clips := {}
var gaps := {}


func _initialize() -> void:
	var secs := 120.0
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("secs="):
			secs = float(str(a).trim_prefix("secs="))
	FastDraw.begin()
	root.size = Vector2i(1280, 720)
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	var jump := "men_fight" if OS.get_cmdline_user_args().has("men") else "fight"
	print("RING_FEET reached fight night: ", TestJump.run(main, jump), " arms ", OS.get_cmdline_user_args())
	await _wait(4)
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	for i in 2:
		st[i] = {"frames": 0, "rig": 0, "moving": 0, "pairs": 0, "skate": [], "lift": [], "crossed": 0,
			"knee": [], "off": [], "along": [], "across": [],
			"shake": 0.0, "shake_n": 0, "prev": [null, null], "k": [[], []], "maxv": 0.0, "pairs_seen": 0, "worst": "", "by": {}}
		(view.stage.boxers[i]["skel"] as Skeleton3D).skeleton_updated.connect(_log.bind(i))
	await _until(func(): return not bool(view.playing) or float(view.t) > secs, secs * 2.0 + 30.0)
	_report()
	quit(0)


func _log(i: int) -> void:
	if not is_instance_valid(view) or view.stage == null or not bool(view.playing) or bool(view.stage.scene):
		return
	if view._shouting != null or float(view._bell_left) >= 0.0:
		return
	var f := Engine.get_process_frames()
	var d: Dictionary = st[i]
	if int(d.get("f", -1)) == f:
		return
	if f - int(d.get("f", -1)) > 1:
		d["prev"] = [null, null]   # the shout bar's frames are not read: no skate across them
	d["f"] = f
	var bx: Dictionary = view.stage.boxers[i]
	var skel: Skeleton3D = bx["skel"]
	var xf := skel.global_transform
	if i == 0:
		_boots()
	d["frames"] = int(d["frames"]) + 1
	var rig: Node = bx.get("rig")
	var on: bool = rig != null and float(rig.w) >= 0.99
	if on:
		d["rig"] = int(d["rig"]) + 1
	var plan: RefCounted = rig.plan if rig != null else null
	var toes: Array = []
	for k in 2:
		toes.append(xf * skel.get_bone_global_pose(skel.find_bone(TOES[k])).origin)
		var ga := skel.get_bone_global_pose(skel.find_bone(LEGS[k][0])).origin
		var gb := skel.get_bone_global_pose(skel.find_bone(LEGS[k][1])).origin
		var gc := skel.get_bone_global_pose(skel.find_bone(LEGS[k][2])).origin
		var ang := rad_to_deg((ga - gb).angle_to(gc - gb))
		var ky := (xf * gb).y   # S392: how close a knee comes to the canvas, and in which clip
		if ky < float(d.get("knee_low", 9.0)):
			d["knee_low"] = ky
			d["knee_low_clip"] = str((view.stage.boxers[i]["ap"] as AnimationPlayer).current_animation)
		(d["knee"] as Array).append(ang)
		var hist: Array = d["k"][k]
		hist.append(ang)
		if hist.size() >= 3:
			var s2 := float(hist[-1]) - 2.0 * float(hist[-2]) + float(hist[-3])
			d["shake"] = float(d["shake"]) + s2 * s2
			d["shake_n"] = int(d["shake_n"]) + 1
			hist.pop_front()
			# S391: the tremble bar is the leg standing still under her (a swinging leg's knee is meant to bend fast)
			var pk: int = k if plan == null or float(plan.side) > 0.0 else 1 - k
			if plan != null and (plan.feet[pk]["swing"] as Dictionary).is_empty():
				d["shake_p"] = float(d.get("shake_p", 0.0)) + s2 * s2
				d["shake_pn"] = int(d.get("shake_pn", 0)) + 1
	if on and plan != null:
		var lead_left: bool = float(plan.side) > 0.0   # plan foot 0 = lead: the left leg on an orthodox
		var moving := false
		for k in 2:
			var pi: int = (0 if lead_left else 1) if k == 0 else (1 if lead_left else 0)
			var planted: bool = (plan.feet[pi]["swing"] as Dictionary).is_empty()
			moving = moving or not planted
			var prev: Variant = d["prev"][k]
			if planted and prev != null:
				var mv := Vector2((toes[k] as Vector3).x - (prev as Vector3).x, (toes[k] as Vector3).z - (prev as Vector3).z).length()
				(d["skate"] as Array).append(mv * 1000.0)
				if mv > 0.005:
					var ck := str((bx["ap"] as AnimationPlayer).current_animation) + (" stretched" if float(rig.last[pi].get("knee_deg", 0.0)) > 158.0 else "")
					d["by"][ck] = int(d["by"].get(ck, 0)) + 1
				if mv * 30.0 > float(d["maxv"]):
					d["maxv"] = mv * 30.0
					d["worst"] = "%s t=%.1f" % [str((bx["ap"] as AnimationPlayer).current_animation), float(view.t)]
				(d["lift"] as Array).append((toes[k] as Vector3).y * 100.0)
			d["prev"][k] = toes[k] if planted else null
		if moving:
			d["moving"] = int(d["moving"]) + 1
		d["pairs"] = (plan.done_pairs as Array).size()
		var a: Vector2 = plan.feet[0]["at"]
		var b: Vector2 = plan.feet[1]["at"]
		var rel: Vector2 = plan.unrot(a - b, float(plan.yaw))
		if rel.x * float(plan.side) < 0.05:
			d["crossed"] = int(d["crossed"]) + 1
		if not moving:
			(d["along"] as Array).append(absf(rel.y))
			(d["across"] as Array).append(absf(rel.x))
		var orig: Node = view.stage.boxers[1 - i]["rig"]
		var close := 9.0
		for k in 2:
			for m in 2:
				# standing feet only: a foot in the air passing over the other's is not boot in boot
				if (plan.feet[k]["swing"] as Dictionary).is_empty() and (orig.plan.feet[m]["swing"] as Dictionary).is_empty():
					close = minf(close, (plan.feet[k]["at"] as Vector2).distance_to(orig.plan.feet[m]["at"]))
		if float(orig.w) >= 0.99:
			d["boots"] = minf(float(d.get("boots", 9.0)), close)
			if close < 0.2:
				d["boots_n"] = int(d.get("boots_n", 0)) + 1
				var phk := str(view.stage.feet.phase())
				d["boots_by"] = str(d.get("boots_by", "")) if str(d.get("boots_by", "")).contains(phk) else str(d.get("boots_by", "")) + " " + phk
		var sh: Vector3 = view.stage.RingFeet.shown(view.stage, bx)
		(d["off"] as Array).append(Vector2(sh.x - bx["pos"].x, sh.z - bx["pos"].z).length())


func _pc(a: Array, q: float) -> float:
	if a.is_empty():
		return -1.0
	var s := a.duplicate()
	s.sort()
	return s[mini(int(s.size() * q), s.size() - 1)]


func _report() -> void:
	var secs: float = float(view.t)
	for i in 2:
		var d: Dictionary = st[i]
		var n := maxf(1.0, float(d["frames"]))
		var knee: Array = d["knee"]
		var locked := 0
		for v in knee:
			if v > 170.0:
				locked += 1
		print("RING_FEET %d frames %d rig %.0f %% | feet moving %.0f %% | pairs %.0f a minute" % [i, int(d["frames"]), 100.0 * int(d["rig"]) / n,
			100.0 * int(d["moving"]) / n, 60.0 * int(d["pairs"]) / maxf(1.0, secs)])
		print("RING_FEET %d planted skate mm/frame p50 %.2f p99 %.2f max %.2f m/s (%s) | toes y cm p50 %.1f p99 %.1f | crossed frames %d | stance along p50 %.2f across %.2f" % [
			i, _pc(d["skate"], 0.5), _pc(d["skate"], 0.99), float(d["maxv"]), str(d["worst"]), _pc(d["lift"], 0.5), _pc(d["lift"], 0.99), int(d["crossed"]), _pc(d["along"], 0.5), _pc(d["across"], 0.5)])
		print("RING_FEET %d skate frames by clip: %s | closest ball to the other's %.2f m, under 0.2 m %d frames in%s" % [i, str(d["by"]).left(90), float(d.get("boots", -1.0)), int(d.get("boots_n", 0)), str(d.get("boots_by", ""))])
		var kinds := {}
		var plan: RefCounted = view.stage.boxers[i]["rig"].plan if view.stage.boxers[i].get("rig") != null else null
		if plan != null:
			for dp in plan.done_pairs:
				var m := (dp["centre1"] as Vector2).distance_to(dp["centre0"])
				var k := str(dp["dir"]) if m > 0.03 else "turn"
				if not kinds.has(k):
					kinds[k] = [0, 0.0]
				kinds[k][0] += 1
				kinds[k][1] += m
			for k in kinds:
				kinds[k][1] = snappedf(float(kinds[k][1]) / int(kinds[k][0]), 0.01)
		print("RING_FEET %d pairs by way [count, mean m]: %s" % [i, str(kinds)])
		print("RING_FEET %d knee deg p50 %.0f p99 %.0f locked>170 %.1f %% shake %.2f planted leg %.2f | shown off place m p50 %.3f p90 %.3f max %.3f" % [i, _pc(knee, 0.5), _pc(knee, 0.99),
			100.0 * locked / maxf(1.0, knee.size()), sqrt(float(d["shake"]) / maxf(1.0, int(d["shake_n"]))), sqrt(float(d.get("shake_p", 0.0)) / maxf(1.0, int(d.get("shake_pn", 0)))), _pc(d["off"], 0.5), _pc(d["off"], 0.9), _pc(d["off"], 1.0)])
	for ph in gaps:
		var g: Dictionary = gaps[ph]
		print("RING_FEET gap %s (%d frames): place p5 %.2f p50 %.2f | shown p5 %.2f p50 %.2f min %.2f | chest p5 %.2f p50 %.2f min %.2f | head p5 %.2f p50 %.2f min %.2f" % [ph, (g["pos"] as Array).size(), _pc(g["pos"], 0.05), _pc(g["pos"], 0.5), _pc(g["shown"], 0.05), _pc(g["shown"], 0.5), _pc(g["shown"], 0.0), _pc(g["chest"], 0.05), _pc(g["chest"], 0.5), _pc(g["chest"], 0.0), _pc(g["head"], 0.05), _pc(g["head"], 0.5), _pc(g["head"], 0.0)])
	var over := 0
	for key in boots_by:
		over += int(boots_by[key][0])
	print("RING_FEET boots drawn: inside %.2f m %d of %d frames (%.1f %%), closest %.3f m" % [BOOT_TOUCH_M, over, boots_frames, 100.0 * over / maxf(1.0, boots_frames), boots_min])
	for key in boots_by:
		print("RING_FEET boots by %s: %d frames, mean gap %.2f m" % [key, int(boots_by[key][0]), float(boots_by[key][1]) / maxf(1.0, int(boots_by[key][0]))])
	var top: Array = boots_clips.keys()
	top.sort_custom(func(a, b): return int(boots_clips[a]) > int(boots_clips[b]))
	print("RING_FEET boots clips: ", top.slice(0, 6).map(func(c): return "%s %d" % [c, int(boots_clips[c])]))
	for i in 2:
		print("RING_FEET %d lowest knee %.3f m in %s" % [i, float(st[i].get("knee_low", 9.0)), str(st[i].get("knee_low_clip", ""))])
	var rows: Array = view.stage.hit_gaps.filter(func(r): return not bool(r.get("cut", false)))
	var miss: Array = rows.map(func(r): return float(r["miss"]))
	var far := rows.filter(func(r): return float(r["miss"]) > MISS_M).size()
	print("RING_FEET landed %d in %.0f s | glove to target m p50 %.3f p90 %.3f max %.3f | > %.2f m: %d (%.0f %%)" % [rows.size(), secs, _pc(miss, 0.5), _pc(miss, 0.9), _pc(miss, 1.0), MISS_M, far, 100.0 * far / maxf(1.0, rows.size())])


## S392 (two blind judges: "lead boots share the same floor space") the boots as DRAWN, every frame, whoever has the legs: each
## boot a line from the ankle past the toes on the canvas plan. Under BOOT_TOUCH_M two boots are inside each other.
func _boot(bx: Dictionary, k: int) -> Array:
	var skel: Skeleton3D = bx["skel"]
	var xf := skel.global_transform
	var a: Vector3 = xf * skel.get_bone_global_pose(skel.find_bone(LEGS[k][2])).origin
	var b: Vector3 = xf * skel.get_bone_global_pose(skel.find_bone(TOES[k])).origin
	var tip := b + (b - a) * 0.45
	return [Vector2(a.x, a.z), Vector2(tip.x, tip.z), minf(a.y, b.y)]


static func _seg(a: Vector2, b: Vector2, c: Vector2, d: Vector2) -> float:
	var best := 9.0
	for n in 9:
		var p := a.lerp(b, n / 8.0)
		var q := Geometry2D.get_closest_point_to_segment(p, c, d)
		best = minf(best, p.distance_to(q))
		var p2 := c.lerp(d, n / 8.0)
		best = minf(best, p2.distance_to(Geometry2D.get_closest_point_to_segment(p2, a, b)))
	return best


## S392 how close the bodies come, by phase: the fight's place (pos), the body as shown (the node), chest to chest as drawn.
func _gaps(b0: Dictionary, b1: Dictionary) -> void:
	var a: Vector3 = b0["pos"]
	var b: Vector3 = b1["pos"]
	var na := (b0["node"] as Node3D).position
	var nb := (b1["node"] as Node3D).position
	var s0: Skeleton3D = b0["skel"]
	var s1: Skeleton3D = b1["skel"]
	var ca: Vector3 = s0.global_transform * s0.get_bone_global_pose(s0.find_bone("Chest")).origin
	var cb: Vector3 = s1.global_transform * s1.get_bone_global_pose(s1.find_bone("Chest")).origin
	var ph := str(view.stage.feet.phase())
	if not gaps.has(ph):
		gaps[ph] = {"pos": [], "shown": [], "chest": [], "head": []}
	(gaps[ph]["pos"] as Array).append(Vector2(a.x - b.x, a.z - b.z).length())
	(gaps[ph]["shown"] as Array).append(Vector2(na.x - nb.x, na.z - nb.z).length())
	(gaps[ph]["chest"] as Array).append(Vector2(ca.x - cb.x, ca.z - cb.z).length())
	var ha: Vector3 = s0.global_transform * s0.get_bone_global_pose(s0.find_bone("Head")).origin
	var hb: Vector3 = s1.global_transform * s1.get_bone_global_pose(s1.find_bone("Head")).origin
	(gaps[ph]["head"] as Array).append(ha.distance_to(hb))


func _boots() -> void:
	var b0: Dictionary = view.stage.boxers[0]
	var b1: Dictionary = view.stage.boxers[1]
	_gaps(b0, b1)
	var close := 9.0
	for k in 2:
		for m in 2:
			var s0 := _boot(b0, k)
			var s1 := _boot(b1, m)
			if absf(float(s0[2]) - float(s1[2])) < 0.12:   # one boot in the air over the other is not boot in boot
				close = minf(close, _seg(s0[0], s0[1], s1[0], s1[1]))
	boots_frames += 1
	boots_min = minf(boots_min, close)
	if close >= BOOT_TOUCH_M:
		return
	var r0: Node = b0.get("rig")
	var r1: Node = b1.get("rig")
	var legs := "rig+rig" if r0 != null and r1 != null and float(r0.w) >= 0.99 and float(r1.w) >= 0.99 else ("clip+clip" if r0 == null or r1 == null or (float(r0.w) <= 0.01 and float(r1.w) <= 0.01) else "mixed")
	var gap := (b0["node"] as Node3D).position.distance_to((b1["node"] as Node3D).position)
	var key := "%s %s" % [str(view.stage.feet.phase()), legs]
	var row: Array = boots_by.get(key, [0, 0.0])
	boots_by[key] = [int(row[0]) + 1, float(row[1]) + gap]
	var c0 := str((b0["ap"] as AnimationPlayer).current_animation)
	var c1 := str((b1["ap"] as AnimationPlayer).current_animation)
	boots_clips[c0] = int(boots_clips.get(c0, 0)) + 1
	boots_clips[c1] = int(boots_clips.get(c1, 0)) + 1


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
