extends SceneTree
## S322 (S320 film ~1:10: the referee drifts between the boxers in quiet spells): plays fight night like the board's
## 'Test: fight night WITH film study' and logs, every frame of the round, where the referee stands against the boxers'
## line. "Between" = his feet project onto the middle of the segment between their pelvises (0.15..0.85 of it) less than
## BETWEEN_M off it. Also counts how often his side of the line flips and the frames he walks across the line.
## Run windowed on the never-shown desktop (the camera needs a picture):
##   python tools/hidden_desktop.py run --timeout=600 --log=<f> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/ref_probe.gd [-- secs=150]
## Prints REF lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const BETWEEN_M := 0.5

var main: Node


func _initialize() -> void:
	var secs := 150.0
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("secs="):
			secs = float(str(a).trim_prefix("secs="))
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("REF reached fight night: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	var frames := 0
	var between := 0
	var flips := 0
	var crossings := 0
	var last_side := 0.0
	var last_sign := 0.0
	var spells: Array = []   # [start_t, end_t, min_perp]
	var in_spell := false
	while bool(view.playing) and float(view.t) <= secs:
		await process_frame
		var st: Node = view.stage
		var ref: Node = st.get("referee")
		if ref == null or bool(st.get("scene")):
			in_spell = false
			continue
		frames += 1
		var a: Vector3 = st.boxers[0]["pos"]
		var b: Vector3 = st.boxers[1]["pos"]
		var p: Vector3 = (ref.get("body") as Node3D).position
		var seg := Vector2(b.x - a.x, b.z - a.z)
		var rel := Vector2(p.x - a.x, p.z - a.z)
		var u := clampf(rel.dot(seg) / maxf(seg.length_squared(), 0.0001), -1.0, 2.0)
		var perp: float = (seg.x * rel.y - seg.y * rel.x) / maxf(seg.length(), 0.0001)
		var side: float = float(ref.get("_side"))
		if last_side != 0.0 and side != last_side:
			flips += 1
		last_side = side
		var sgn := signf(perp)
		if last_sign != 0.0 and sgn != 0.0 and sgn != last_sign and u > 0.0 and u < 1.0:
			crossings += 1
		if sgn != 0.0:
			last_sign = sgn
		var is_between := u > 0.15 and u < 0.85 and absf(perp) < BETWEEN_M
		if is_between:
			between += 1
			if not in_spell:
				spells.append([float(view.t), float(view.t), absf(perp), str(ref.get("_mode")), seg.length()])
			spells[-1][1] = float(view.t)
			spells[-1][2] = minf(float(spells[-1][2]), absf(perp))
		in_spell = is_between
	print("REF frames %d | between the boxers %d (%.1f %%) in %d spells | side flips %d | walks across their line %d" % [
		frames, between, 100.0 * between / maxf(1.0, frames), spells.size(), flips, crossings])
	for s in spells.slice(0, 15):
		print("REF between: %.1f-%.1f s, closest %.2f m off their line, mode %s, pelvis gap %.2f m" % [s[0], s[1], s[2], s[3], s[4]])
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
