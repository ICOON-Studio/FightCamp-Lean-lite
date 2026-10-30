extends SceneTree
## S316 smoothness instrument (operator: "the animations look so much better here [the board's raw mocap takes], but in the
## fight are nowhere near that smooth"). Plays the build to fight night and, from the pose AS SHOWN (tools/pose_tap.gd, the
## last modifier), follows both boxers' hands and head relative to her hips for STOP_S of round time. A kink is a frame
## whose second difference |p(t+1) - 2 p(t) + p(t-1)| tops KINK_M (at 30 fps 0.02 m = 18 m/s^2 off the path in one
## frame - a hand thrown on a smooth path stays under it between its wind-up and its contact). Reports kinks per minute per
## point, the share at a clip change (+-1 frame), and by clip. Run it once plain and once per control arm (`-- noguard`,
## `noreach`, `nosnap`, `noglove`, `nojoin`, `nofeet`, or several) to see which layer kinks the motion.
##   python tools/hidden_desktop.py run --timeout=600 --log=<log> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/smooth_probe.gd [-- <arms>]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const STOP_S := 90.0
const KINK_M := 0.02
const POINTS := ["Head", "LeftHand", "RightHand"]
const BONES := ["Hips", "Head", "LeftHand", "RightHand"]

var main: Node
var view: Node
var taps: Array = []
var hist := [[], []]          # per boxer: last 3 frames {point: Vector3}
var clips := [[], []]         # per boxer: last 3 frames' clip
var frames := 0
var kinks := {}               # point -> count
var at_change := 0
var by_clip := {}
var changes := 0
var to_clip := {}             # clip started -> times
var played := {}              # clip -> [seconds it played before the next change]
var _since := [0, 0]
var acc: Array = []           # every second difference (all points), for the percentiles


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("SMOOTH reached fight night: ", TestJump.run(main, "fight"), " arms ", OS.get_cmdline_user_args())
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
	await _until(func(): return not bool(view.playing) or float(view.t) > STOP_S, 420.0)
	_report()
	quit(0)


func _log() -> void:
	if not is_instance_valid(view) or view.stage == null or not bool(view.playing) or bool(view.stage.scene):
		for i in 2:
			hist[i].clear()
			clips[i].clear()
		return
	frames += 1
	for i in 2:
		var sh: Dictionary = taps[i].shown
		if sh.size() < BONES.size():
			continue
		var sk: Transform3D = (view.stage.boxers[i]["skel"] as Skeleton3D).global_transform
		var hips: Vector3 = sk * (sh["Hips"] as Vector3)
		var now := {}
		for p in POINTS:
			now[p] = sk * (sh[p] as Vector3) - hips
		hist[i].append(now)
		clips[i].append(str((view.stage.boxers[i]["ap"] as AnimationPlayer).current_animation))
		if hist[i].size() > 3:
			hist[i].pop_front()
			clips[i].pop_front()
		_since[i] += 1
		if clips[i].size() >= 2 and clips[i][-1] != clips[i][-2]:
			changes += 1
			to_clip[clips[i][-1]] = int(to_clip.get(clips[i][-1], 0)) + 1
			if not played.has(clips[i][-2]):
				played[clips[i][-2]] = []
			played[clips[i][-2]].append(_since[i] / 30.0)
			_since[i] = 0
		if hist[i].size() < 3:
			continue
		var changed: bool = clips[i][0] != clips[i][1] or clips[i][1] != clips[i][2]
		for p in POINTS:
			var d: float = ((hist[i][2][p] as Vector3) - 2.0 * (hist[i][1][p] as Vector3) + (hist[i][0][p] as Vector3)).length()
			acc.append(d)
			if d > KINK_M:
				kinks[p] = int(kinks.get(p, 0)) + 1
				if changed:
					at_change += 1
				var c: String = clips[i][1]
				by_clip[c] = int(by_clip.get(c, 0)) + 1


func _report() -> void:
	var mins := float(frames) / 30.0 / 60.0
	var total := 0
	for p in kinks:
		total += int(kinks[p])
	acc.sort()
	var pc := func(q: float) -> float: return float(acc[int(acc.size() * q)]) if not acc.is_empty() else 0.0
	print("SMOOTH frames %d (%.1f min) | clip changes %.0f/min | kinks > %.2f m: %.0f/min (head %d, left %d, right %d), at a clip change %d of %d" % [
		frames, mins, changes / maxf(mins, 0.01), KINK_M, total / maxf(mins, 0.01), int(kinks.get("Head", 0)),
		int(kinks.get("LeftHand", 0)), int(kinks.get("RightHand", 0)), at_change, total])
	print("SMOOTH second difference m: p50 %.4f p90 %.4f p99 %.4f max %.4f" % [pc.call(0.5), pc.call(0.9), pc.call(0.99), acc[-1] if not acc.is_empty() else 0.0])
	var top := by_clip.keys()
	top.sort_custom(func(a, b): return int(by_clip[a]) > int(by_clip[b]))
	var parts := []
	for c in top.slice(0, 10):
		parts.append("%s %d" % [c, by_clip[c]])
	print("SMOOTH kinks by clip: ", ", ".join(parts))
	var starts := to_clip.keys()
	starts.sort_custom(func(a, b): return int(to_clip[a]) > int(to_clip[b]))
	parts = []
	for c in starts.slice(0, 14):
		var pl: Array = played.get(c, [0.0])
		pl.sort()
		parts.append("%s %d (plays %.2f s)" % [c, to_clip[c], pl[pl.size() / 2]])
	print("SMOOTH clips started (median time before the next change): ", ", ".join(parts))


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
