extends SceneTree
## S311 real-fight gap 1 instrument: plays the build to fight night (TestJump "fight"), watches round 1 and measures, from
## the stage's own positions, what Game Godot/research/S310_REAL_FIGHT_GAPS.md measured on real bouts and on ours:
## the pelvis gap (median, p10-p90, sd), the range mix (inside < 0.65 m / mid / long > 1.1 m), range swings (> 0.45 m
## within 1.5 s), feet moving (a step clip playing) and ring travel per boxer. Before S311 (8b96fa5): gap 0.95 m
## (0.88-1.01), sd 0.04 NA = 0.06 m, long 1 %, 0 swings, feet 8-9 %, travel ~10 m a round.
## Run on the never-shown desktop (3D needs a picture):
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --fixed-fps 30 --script res://tools/range_probe.gd

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Footwork := preload("res://scripts/fight3d/Footwork.gd")

var main: Node
var view: Node
var gaps: PackedFloat32Array = []
var feet := [0, 0]
var travel := [0.0, 0.0]
var last_pos: Array = []
var frames := 0
var min_gap := 99.0
var bow_frames := 0           # S311 ropes: frames with a rope bowed > 3 cm, the deepest bow and when
var bow_max := 0.0
var bow_at := 0.0
var cl_starts := 0            # S313 clinch: clinches started / tied up, frames tied, the gap while tied, referee spacing
var cl_tied := 0
var cl_frames := 0
var cl_gap := 0.0
var _was := [-1, false]
var ref_min := 99.0
var ref_frames_near := 0
var ref_blocks := 0
var stagger := [PackedFloat32Array(), PackedFloat32Array()]   # S314 gap 7: feet front-back as shown (FootPlant targets), m
var in_spells := 0            # S314 inside range: InsideBeats spells started, frames in one, the gap during them
var in_frames := 0
var in_gap := 0.0
var _was_in := false


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("RANGE_PROBE reached fight night: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0)
	process_frame.connect(_log)
	# Round 1 opens with the intro (FightCast.intro): the round starts when it hands the ring back.
	await _until(func(): return bool(view.playing), 120.0)
	await _until(func(): return not bool(view.playing), 420.0)
	_report()
	quit(0)


## Every in-round frame (not the intro or corner scene, not while the shout bar holds the clock).
func _log() -> void:
	if not is_instance_valid(view) or view.stage == null or not bool(view.playing) or bool(view.stage.scene):
		return
	if view._shouting != null or float(view._bell_left) >= 0.0:
		return
	var bx: Array = view.stage.boxers
	var a: Vector3 = bx[0]["pos"]
	var b: Vector3 = bx[1]["pos"]
	gaps.append(a.distance_to(b))
	min_gap = minf(min_gap, a.distance_to(b))
	frames += 1
	var bow: float = view.stage._ropes.max_bow()
	if bow > 0.03:
		bow_frames += 1
	if bow > bow_max:
		bow_max = bow
		bow_at = float(view.t)
	for i in 2:
		if Footwork.STRIDE.has(str((bx[i]["ap"] as AnimationPlayer).current_animation)):
			feet[i] += 1
		var fp: Node = bx[i]["feet"]
		if fp != null:
			var fwd: Vector3 = (bx[i]["node"] as Node3D).global_transform.basis.z
			fwd = Vector3(fwd.x, 0.0, fwd.z).normalized()
			var lt: Array = fp.last_target
			stagger[i].append(absf(((lt[0] as Vector3) - (lt[1] as Vector3)).dot(fwd)))
		var p: Vector3 = bx[i]["pos"]
		if last_pos.size() == 2:
			travel[i] += p.distance_to(last_pos[i])
	last_pos = [a, b]
	var cl: Node = view.stage.clinch
	if int(cl.holder) >= 0 and int(_was[0]) < 0:
		cl_starts += 1
	if bool(cl.engaged) and not bool(_was[1]):
		cl_tied += 1
	if bool(cl.engaged):
		cl_frames += 1
		cl_gap += a.distance_to(b)
	_was = [int(cl.holder), bool(cl.engaged)]
	var now_in: bool = str(view.stage.feet.phase()) == "inside"
	if now_in and not _was_in:
		in_spells += 1
	if now_in:
		in_frames += 1
		in_gap += a.distance_to(b)
	_was_in = now_in
	var ref: Node3D = view.stage.referee
	if ref != null:
		var rp: Vector3 = ref.body.position
		var near := minf(Vector2(rp.x - a.x, rp.z - a.z).length(), Vector2(rp.x - b.x, rp.z - b.z).length())
		ref_min = minf(ref_min, near)
		if near < 0.45:
			ref_frames_near += 1
		# S314 still: the referee between the lens and the boxers (within 0.35 m of the camera -> pair line, nearer than them).
		var cam: Camera3D = view.stage.get("camera")
		if cam != null:
			var c := Vector2(cam.global_position.x, cam.global_position.z)
			var m := Vector2((a.x + b.x) * 0.5, (a.z + b.z) * 0.5)
			var r := Vector2(rp.x, rp.z)
			var u := clampf((r - c).dot(m - c) / maxf(0.01, (m - c).length_squared()), 0.0, 1.0)
			if u < 0.9 and (c + (m - c) * u).distance_to(r) < 0.35:
				ref_blocks += 1


func _report() -> void:
	var s := Array(gaps)
	s.sort()
	var n := s.size()
	if n == 0:
		print("RANGE_PROBE no in-round frames")
		return
	var mean := 0.0
	for g in s:
		mean += float(g)
	mean /= n
	var sd := 0.0
	for g in s:
		sd += pow(float(g) - mean, 2)
	sd = sqrt(sd / n)
	var inside := s.filter(func(g): return float(g) < 0.65).size()
	var long := s.filter(func(g): return float(g) > 1.1).size()
	# Swings: the gap changes by > 0.45 m within 1.5 s (45 frames at 30 fps); one per 1.5 s window at most.
	var swings := 0
	var i := 0
	while i + 45 < n:
		var lo := 99.0
		var hi := -99.0
		for k in range(i, i + 45):
			lo = minf(lo, gaps[k])
			hi = maxf(hi, gaps[k])
		if hi - lo > 0.45:
			swings += 1
			i += 45
		else:
			i += 5
	var secs := n / 30.0
	print("RANGE_PROBE clinches started %d, tied up %d, tied %.1f s (%.0f %% of the round), gap while tied %.2f m (real: 2.5 a round in R1)" % [
		cl_starts, cl_tied, cl_frames / 30.0, 100.0 * cl_frames / n, cl_gap / maxf(1.0, cl_frames)])
	var plan := ""
	var plan_s := 0.0
	for bt in view._round_beats:
		if str(bt["move"]) == "inside":
			plan += " %.1f-%.1f" % [float(bt["t"]), float(bt["end_t"])]
			plan_s += float(bt["end_t"]) - float(bt["t"])
	print("RANGE_PROBE inside spells planned %.1f s:%s" % [plan_s, plan])
	print("RANGE_PROBE inside spells %d, %.1f s (%.0f %% of the round), gap during them %.2f m" % [
		in_spells, in_frames / 30.0, 100.0 * in_frames / n, in_gap / maxf(1.0, in_frames)])
	print("RANGE_PROBE referee nearest a boxer %.2f m, within 0.45 m in %d frames, in front of the boxers in %d frames (%.1f s)" % [
		ref_min, ref_frames_near, ref_blocks, ref_blocks / 30.0])
	print("RANGE_PROBE in-round %.0f s (%d frames)" % [secs, n])
	print("RANGE_PROBE gap median %.2f m (p10 %.2f - p90 %.2f), sd %.2f m, min %.2f" % [s[n / 2], s[n / 10], s[n * 9 / 10], sd, min_gap])
	print("RANGE_PROBE range mix inside %.0f %% / mid %.0f %% / long %.0f %%" % [100.0 * inside / n, 100.0 * (n - inside - long) / n, 100.0 * long / n])
	print("RANGE_PROBE swings %d (%.1f a minute)" % [swings, swings / (secs / 60.0)])
	print("RANGE_PROBE ropes bowed > 3 cm in %d frames, deepest %.2f m at round time %.1f s" % [bow_frames, bow_max, bow_at])
	var ropes: Node = view.stage._ropes
	print("RANGE_PROBE body through the ropes: deepest %.2f m past the line by %s (cap %.2f m)" % [
		float(ropes.through_m), str(ropes.through_who) if str(ropes.through_who) != "" else "nobody", float(ropes.MAX_BOW_M)])
	print("RANGE_PROBE feet moving red %.0f %% blue %.0f %%, travel red %.1f m blue %.1f m (per round: x %.2f)" % [
		100.0 * feet[0] / n, 100.0 * feet[1] / n, travel[0], travel[1], 180.0 / secs])
	# NA = nose to ankle, 1.48 m for a 1.67 m woman (S310's metres conversion); real median 0.30-0.34 NA, ours was 0.26.
	for who in 2:
		var st := Array(stagger[who])
		st.sort()
		if st.size() > 0:
			print("RANGE_PROBE stance stagger %s median %.2f m = %.2f NA (p90 %.2f NA)" % [["red", "blue"][who],
				st[st.size() / 2], st[st.size() / 2] / 1.48, st[st.size() * 9 / 10] / 1.48])


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
