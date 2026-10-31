extends SceneTree
## S322 "the body is the track" step 2: plays fight night (round 1 for 12 s, the rest of it skipped, the corner, round 2
## skipped, round 3 for 20 s) and reports BodyBurn per boxer at each round start (busiest part, guard drop, step scale,
## power) and the SHOWN guard: her lead glove's height under her face (glove node vs FightStage.target_point) while she
## stands in her guard, round 1 against round 3. `-- noburn` is the control arm (no effect: the round 3 guard must read as
## round 1's). Saves round 3's still (the game camera). Run windowed on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=600 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/burn_probe.gd -- <out_dir> [noburn]
## Prints BURN lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const BodyLoad := preload("res://scripts/rules/BodyLoad.gd")
const FightView := preload("res://scripts/fight3d/FightView.gd")

var main: Node
var out_dir := "user://burn_probe"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty() and not str(args[0]).contains("noburn"):
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("BURN reached fight night: ", TestJump.run(main, "fight"), " arms ", args)
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _wait(2)
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	await _until(func(): return bool(view.playing), 60.0)
	var low := {}
	for n in [1, 2, 3]:
		await _until(func(): return bool(view.playing) and int(view.round_n) == n, 90.0)
		_report(view, n)
		if n == 2:
			view.skip_round()
		else:
			if n == 3:
				FightView.fast = true   # 2x: round 3 to 2:30 in ~75 s
				view._toggle_speed()
				view._toggle_speed()
			low[n] = await _guard_low(view, 2.0 if n == 1 else 120.0, 12.0 if n == 1 else 150.0)
			if n == 3:
				await RenderingServer.frame_post_draw
				var path := out_dir.path_join("burn_round3.png")
				root.get_texture().get_image().save_png(path)
				print("BURN wrote ", path)
				break
			view.skip_round()
		await _corner(view)
	print("BURN shown lead glove under her face (m, in her guard): round 1 %.3f -> round 3 %.3f (drop %+.3f) | red %s" % [
		float(low.get(1, [0.0])[0]), float(low.get(3, [0.0])[0]), float(low.get(3, [0.0])[0]) - float(low.get(1, [0.0])[0]),
		"blue %.3f -> %.3f" % [float(low.get(1, [0, 0.0])[1]), float(low.get(3, [0, 0.0])[1])]])
	quit(0)


func _report(view: Node, n: int) -> void:
	var ld: Dictionary = view.burn.load
	for side in ["a", "b"]:
		var parts := []
		for p in BodyLoad.PARTS:
			parts.append("%s %d" % [p, int(round(float(ld[side][p])))])
		print("BURN round %d start %s: %s | guard drop %.2f steps %.2f power %.2f" % [n, side, ", ".join(parts),
			BodyLoad.guard_drop(ld, side), BodyLoad.step_scale(ld, side), BodyLoad.power_scale(ld, side)])


## Mean height of each boxer's lead glove under her face from round time t0 to t1, counting only frames she stands in
## her guard (the shout bar is answered as it comes).
func _guard_low(view: Node, t0: float, t1: float) -> Array:
	var sums := [0.0, 0.0]
	var counts := [0, 0]
	while bool(view.playing) and float(view.t) < t1:
		await process_frame
		if view._shouting != null:
			view._shouting._pick("")
			continue
		if float(view.t) < t0:
			continue
		var st: Node = view.stage
		for i in 2:
			var tuck: Node = st.boxers[i].get("tuck")
			var ap: AnimationPlayer = st.boxers[i]["ap"]
			if tuck == null or not (tuck.get("guards") as Array).has(str(ap.assigned_animation)):
				continue
			var lead: String = st.hand_of(i, "LeftHand")
			sums[i] += (st.target_point(i, false) as Vector3).y - (st.glove_front(i, lead) as Vector3).y
			counts[i] += 1
	var tk: Dictionary = view.stage.boxers[0]["tuck"].tired
	print("BURN at %.0f s: red glove drop lead %.2f rear %.2f, legs %.2f | %d / %d guard frames" % [float(view.t), float(tk["lead"]), float(tk["rear"]),
		float(view.stage.boxers[0].get("legs", 1.0)), counts[0], counts[1]])
	return [sums[0] / maxf(1.0, counts[0]), sums[1] / maxf(1.0, counts[1])]


func _corner(view: Node) -> void:
	await _wait(2)
	var cm: Node = null
	for ch in view.get_children():
		if ch.has_method("cue_walk_out"):
			cm = ch
	if cm == null:
		return
	await _until(func(): return cm.ui != null and cm.ui._card.visible, 40.0)
	cm._pick("lead")
	cm.finish()
	await _wait(2)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
