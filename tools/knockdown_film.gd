extends SceneTree
## S376 KNOCKDOWN1 probe + film: Danny's bout (TestJump men_fight), 6 s into round 1 a big landing cross and the count beat
## are fired through the real beat path (FightView._fire -> BeatFire), as the round script's last exchange does for a
## knockdown. Prints the shot's contact, when the fall starts, how far the downed boxer's head has dropped 0.8 s after the
## shot, and the replay (start, end, count). PASS lines: the fall starts after the contact, the head is down by 0.8 s
## (the scan's 1.8 s -> 2.6 s), one replay plays and the ring comes back live. Film it under the movie writer:
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --fixed-fps 30 --write-movie <out>.avi --audio-driver Dummy --script res://tools/knockdown_film.gd

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var failures := 0


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	print("JUMP ", TestJump.run(main, "men_fight"))
	main.act("fightstep", "start")
	for i in 4:
		await process_frame
	var view: Node = main._fight_layer.get_child(0)
	while not bool(view.playing):
		await process_frame
	while float(view.t) < 6.0:
		await process_frame
	var skel: Skeleton3D = view.stage.boxers[1]["skel"]
	var head := skel.find_bone("Head")
	var head_y0 := (skel.global_transform * skel.get_bone_global_pose(head)).origin.y
	var t0 := float(view.t)
	view.next = (view.beats as Array).size()   # as after a real count: the round's later beats are gone
	view._fire({"t": t0, "who": "a", "move": "cross", "result": "lands", "big": true, "knockback": true, "caption": "", "def": ""})
	var shot := float(view._beat.last_contact[0])
	while float(view.t) < t0 + 0.35:
		await process_frame
	view._fire({"t": t0 + 0.35, "who": "b", "move": "count", "result": "none", "big": false, "knockback": false, "caption": "", "def": ""})
	print("KNOCKDOWN shot contact at view t %.2f (fired %.2f)" % [shot, t0])
	var fall_t := -1.0
	var ap: AnimationPlayer = view.stage.boxers[1]["ap"]
	var head_08 := head_y0
	var replay: Node = view.replay
	var rep_start := -1.0
	var rep_end := -1.0
	var frames := 0
	while frames < 30 * 16:
		await process_frame
		frames += 1
		if fall_t < 0.0 and (str(ap.current_animation).contains("countdown") or str(ap.current_animation).contains("knockout_count")):
			fall_t = float(view.t)
		if head_08 == head_y0 and float(view.t) >= shot + 0.8 and not replay.active():
			head_08 = (skel.global_transform * skel.get_bone_global_pose(head)).origin.y
		if rep_start < 0.0 and replay.active():
			rep_start = frames / 30.0
		if rep_start >= 0.0 and rep_end < 0.0 and not replay.active():
			rep_end = frames / 30.0
	print("KNOCKDOWN fall starts at %.2f (%.2f after contact); head %.2f m -> %.2f m 0.8 s after the shot" % [fall_t, fall_t - shot, head_y0, head_08])
	print("KNOCKDOWN replay %.1f s -> %.1f s (film seconds after the count), replays %d, live again %s" % [rep_start, rep_end, int(replay.count), str(not paused)])
	_check(fall_t >= shot, "the fall starts after the shot lands (%.2f >= %.2f)" % [fall_t, shot])
	_check(head_y0 - head_08 > 0.25, "the head has dropped %.2f m by 0.8 s after the shot" % (head_y0 - head_08))
	_check(int(replay.count) == 1 and rep_end > rep_start and rep_start > 0.0, "one slow-motion replay plays (%.1f s long)" % (rep_end - rep_start))
	_check(not paused and not replay.active(), "the ring is live again after it")
	print("KNOCKDOWN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
