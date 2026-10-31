extends SceneTree
## S316 smoothness instrument (operator: "the animations look so much better here [the board's raw mocap takes], but in the
## fight are nowhere near that smooth"). Plays the build to fight night and, from the pose AS SHOWN (tools/pose_tap.gd, the
## last modifier), follows both boxers' hands and head relative to her hips for STOP_S of round time. A kink is a frame
## whose second difference |p(t+1) - 2 p(t) + p(t-1)| tops KINK_M (at 30 fps 0.02 m = 18 m/s^2 off the path in one
## frame - a hand thrown on a smooth path stays under it between its wind-up and its contact). Reports kinks per minute per
## point, the share at a clip change (+-1 frame), and by clip. Run it once plain and once per control arm (`-- noguard`,
## `noreach`, `nosnap`, `noglove`, `nojoin`, `nofeet`, or several) to see which layer kinks the motion.
## S317 RAW BASELINE: a hook's hand legitimately tops 2 cm/frame, so after the fight the probe freezes the stage, switches
## every modifier off and plays each kinked clip alone on the same body (manual seeks, RAW_STEP_S apart), then measures the
## same second difference at the fight's clip time and playing speed. A kink counts as OURS only when the fight's value
## tops the raw clip's by KINK_M; the rest are the clip's own motion.
##   python tools/hidden_desktop.py run --timeout=600 --log=<log> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/smooth_probe.gd [-- <arms>]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const STOP_S := 90.0
const KINK_M := 0.02
const POINTS := ["Head", "LeftHand", "RightHand"]
const BONES := ["Hips", "Head", "LeftHand", "RightHand"]
const RAW_STEP_S := 1.0 / 60.0

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
var poss := [[], []]          # per boxer: last 3 frames' [clip position, playing speed]
var events: Array = []        # every kink: [boxer, clip, position, speed, point, d, at a change]
var raw := {}                 # "boxer|clip" -> Array of {point: Vector3} every RAW_STEP_S
## S320 frame by frame: every frame's clip time and each modifier's live state per boxer, so the OURS kinks of the focus
## clips (`-- focus=a,b`, default the S319 top two) print with the frames around them.
var flog := [[], []]
var focus: Array = ["pro_left_hook_v2", "retreat"]
const MOD_PROPS := ["last_weight", "pushes", "head_pushes", "_t", "_bt", "_low", "inner", "_w_now"]


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("focus="):
			focus = str(a).trim_prefix("focus=").split(",")
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
	process_frame.disconnect(_log)
	var none := events.filter(func(e): return str(e[1]) == "").size()
	print("SMOOTH kinks with no clip playing: %d" % none)
	await _raw_baseline()
	_report_raw()
	quit(0)


func _log() -> void:
	if not is_instance_valid(view) or view.stage == null or not bool(view.playing) or bool(view.stage.scene):
		for i in 2:
			hist[i].clear()
			clips[i].clear()
			poss[i].clear()
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
		var ap: AnimationPlayer = view.stage.boxers[i]["ap"]
		clips[i].append(str(ap.current_animation))
		poss[i].append([ap.current_animation_position if ap.current_animation != "" else 0.0, ap.get_playing_speed()])
		var mods := {}
		for m in (view.stage.boxers[i]["skel"] as Skeleton3D).get_children():
			if m is SkeletonModifier3D and m != taps[i]:
				for k in MOD_PROPS:
					var v = m.get(k)
					if v != null:
						mods["%s.%s" % [m.name, k]] = snappedf(float(v), 0.001)
		flog[i].append({"clip": clips[i][-1], "pos": poss[i][-1][0], "spd": poss[i][-1][1], "pt": now, "mods": mods})
		if hist[i].size() > 3:
			hist[i].pop_front()
			clips[i].pop_front()
			poss[i].pop_front()
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
				events.append([i, c, float(poss[i][1][0]), float(poss[i][1][1]), p, d, changed, flog[i].size() - 2])


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


func _raw_baseline() -> void:
	# Freeze the fight: nothing under the stage runs its script, no modifier but the tap, the players advance only on seek.
	view.set_process(false)
	for n in [view.stage] + view.stage.find_children("*", "", true, false):
		n.set_process(false)
		n.set_physics_process(false)
	var want := {}
	for e in events:
		if str(e[1]) != "":
			want["%d|%s" % [e[0], e[1]]] = true
	for i in 2:
		var skel: Skeleton3D = view.stage.boxers[i]["skel"]
		for m in skel.get_children():
			if m is SkeletonModifier3D and m != taps[i]:
				(m as SkeletonModifier3D).active = false
		(view.stage.boxers[i]["ap"] as AnimationPlayer).callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	for key in want:
		var i := int(str(key).get_slice("|", 0))
		var clip := str(key).get_slice("|", 1)
		var ap: AnimationPlayer = view.stage.boxers[i]["ap"]
		if not ap.has_animation(clip):
			continue
		var sk: Transform3D = (view.stage.boxers[i]["skel"] as Skeleton3D).global_transform
		ap.play(clip, 0.0)
		ap.pause()
		var rows := []
		var x := 0.0
		var length := ap.get_animation(clip).length
		while x <= length + 0.0001:
			ap.seek(minf(x, length), true)
			await _wait(2)
			var sh: Dictionary = taps[i].shown
			var hips: Vector3 = sk * (sh["Hips"] as Vector3)
			var row := {}
			for p in POINTS:
				row[p] = sk * (sh[p] as Vector3) - hips
			rows.append(row)
			x += RAW_STEP_S
		raw[key] = rows


func _raw_at(rows: Array, x: float, p: String) -> Vector3:
	var f := clampf(x / RAW_STEP_S, 0.0, float(rows.size() - 1))
	var a := int(floor(f))
	var b := mini(a + 1, rows.size() - 1)
	return (rows[a][p] as Vector3).lerp(rows[b][p] as Vector3, f - a)


func _report_raw() -> void:
	var mins := float(frames) / 30.0 / 60.0
	var ours := 0
	var own := 0
	var ours_change := 0
	var ours_clip := {}
	var own_clip := {}
	for e in events:
		var key := "%d|%s" % [e[0], e[1]]
		var d_raw := 0.0
		if raw.has(key):
			var dt := float(e[3]) / 30.0
			var x := float(e[2])
			var rows: Array = raw[key]
			d_raw = (_raw_at(rows, x + dt, e[4]) - 2.0 * _raw_at(rows, x, e[4]) + _raw_at(rows, x - dt, e[4])).length()
		if float(e[5]) - d_raw > KINK_M:
			ours += 1
			ours_clip[e[1]] = int(ours_clip.get(e[1], 0)) + 1
			if e[6]:
				ours_change += 1
		else:
			own += 1
			own_clip[e[1]] = int(own_clip.get(e[1], 0)) + 1
	_report_frames()
	print("SMOOTH RAW baseline: %d clips sampled | kinks OURS (fight tops the raw clip by > %.2f m): %.0f/min (%d, %d at a clip change) | the clip's own: %.0f/min (%d)" % [
		raw.size(), KINK_M, ours / maxf(mins, 0.01), ours, ours_change, own / maxf(mins, 0.01), own])
	for pair in [["OURS by clip", ours_clip], ["clip's own by clip", own_clip]]:
		var d: Dictionary = pair[1]
		var top := d.keys()
		top.sort_custom(func(a, b): return int(d[a]) > int(d[b]))
		var parts := []
		for c in top.slice(0, 10):
			parts.append("%s %d" % [c, d[c]])
		print("SMOOTH RAW %s: %s" % [pair[0], ", ".join(parts)])


## The focus clips' OURS kinks, each with frames -3..+2: clip time, the kinked point's step and second difference, and
## every modifier value that changed across those frames (a layer switching on or off at the kink names itself).
func _report_frames() -> void:
	var shown := {}
	for e in events:
		var c := str(e[1])
		if not c in focus or int(shown.get(c, 0)) >= 12:
			continue
		var key := "%d|%s" % [e[0], c]
		var d_raw := 0.0
		if raw.has(key):
			var dt := float(e[3]) / 30.0
			d_raw = (_raw_at(raw[key], float(e[2]) + dt, e[4]) - 2.0 * _raw_at(raw[key], float(e[2]), e[4]) + _raw_at(raw[key], float(e[2]) - dt, e[4])).length()
		if float(e[5]) - d_raw <= KINK_M:
			continue
		shown[c] = int(shown.get(c, 0)) + 1
		var fl: Array = flog[int(e[0])]
		var k := int(e[7])
		print("SMOOTH KINK %s boxer %d %s at %.3f s x%.2f d %.3f raw %.3f%s" % [c, e[0], e[4], e[2], e[3], e[5], d_raw, " (clip change)" if e[6] else ""])
		var keys := {}
		for j in range(maxi(0, k - 3), mini(fl.size(), k + 3)):
			for mk in fl[j]["mods"]:
				if j > maxi(0, k - 3) and fl[j]["mods"][mk] != fl[j - 1]["mods"].get(mk):
					keys[mk] = true
		for j in range(maxi(0, k - 3), mini(fl.size(), k + 3)):
			var r: Dictionary = fl[j]
			var step := 0.0
			if j > 0:
				step = ((r["pt"][e[4]] as Vector3) - (fl[j - 1]["pt"][e[4]] as Vector3)).length()
			var parts := []
			for mk in keys:
				parts.append("%s=%s" % [mk, r["mods"].get(mk)])
			print("   %s f%+d %s %.3f x%.2f step %.3f | %s" % [">" if j == k else " ", j - k, r["clip"], r["pos"], r["spd"], step, " ".join(parts)])


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
