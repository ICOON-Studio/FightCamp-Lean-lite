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
		var p: Vector3 = bx[i]["pos"]
		if last_pos.size() == 2:
			travel[i] += p.distance_to(last_pos[i])
	last_pos = [a, b]


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
	print("RANGE_PROBE in-round %.0f s (%d frames)" % [secs, n])
	print("RANGE_PROBE gap median %.2f m (p10 %.2f - p90 %.2f), sd %.2f m, min %.2f" % [s[n / 2], s[n / 10], s[n * 9 / 10], sd, min_gap])
	print("RANGE_PROBE range mix inside %.0f %% / mid %.0f %% / long %.0f %%" % [100.0 * inside / n, 100.0 * (n - inside - long) / n, 100.0 * long / n])
	print("RANGE_PROBE swings %d (%.1f a minute)" % [swings, swings / (secs / 60.0)])
	print("RANGE_PROBE ropes bowed > 3 cm in %d frames, deepest %.2f m at round time %.1f s" % [bow_frames, bow_max, bow_at])
	print("RANGE_PROBE feet moving red %.0f %% blue %.0f %%, travel red %.1f m blue %.1f m (per round: x %.2f)" % [
		100.0 * feet[0] / n, 100.0 * feet[1] / n, travel[0], travel[1], 180.0 / secs])


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
