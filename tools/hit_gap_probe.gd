extends SceneTree
## S320 (operator: "some hits seem to register even when opponent is way to far"): plays fight night like the board's
## 'Test: fight night WITH film study' and reports, for every landed punch, how far the striking glove is from the place
## it lands at the contact (FightStage.hit_gaps), by range phase and by punch. A real landed punch touches: > MISS_M reads
## as a hit from too far. Run windowed on the never-shown desktop (the poses need a picture):
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/hit_gap_probe.gd [-- secs=150 <arms>]
## Prints HIT_GAP lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const MISS_M := 0.15

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
	print("HIT_GAP reached fight night: ", TestJump.run(main, "fight"), " arms ", OS.get_cmdline_user_args())
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	await _until(func(): return not bool(view.playing) or float(view.t) > secs, secs * 2.0 + 30.0)
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
		print("HIT_GAP far: %s %s miss %.2f m (ahead %+.2f left %+.2f up %+.2f) pelvis gap %.2f m reach weight %.2f glove pushes %d | clip %s at %.2f s, contact %.2f s, speed %.2f" % [
			r["move"], r["phase"], r["miss"], r.get("fwd", 0.0), r.get("side", 0.0), r.get("up", 0.0), r["gap"], r.get("w", -1.0), r.get("push", -1), r.get("clip", "?"), r.get("pos", -1.0), r.get("contact", -1.0), r.get("speed", -1.0)])
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
