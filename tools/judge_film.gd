extends SceneTree
## S320 (operator Q-S294-31: "upload a short video to judge"): the fight as he would see it after the board's
## 'Test: fight night WITH film study' button - the intro, then round 1 at 1x up to `secs=` of round time (default 60).
## Run under Godot's movie writer on the never-shown desktop, then make an mp4 for the board (ffmpeg):
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --write-movie <out>.avi --script res://tools/judge_film.gd -- [secs=60]
## Prints JUDGE_FILM done t=<round seconds> (fails loudly if the round never started). S376 knockdown=<s>: a knockdown at that
## round time (shot, fall, replay, on the canvas) so the judge sees the knockdown clips too.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")

var main: Node


func _initialize() -> void:
	# S379 (operator: "skip the walk in for the clips"): the film opens with both boxers in their corners (CornerStart);
	# `walkin` films the game's full intro.
	FightIntro.from_corners = not OS.get_cmdline_user_args().has("walkin")
	var secs := 60.0
	var jump := "fight"   # S372 fightjump=men_fight films Danny's bout (not jump=: Main runs that one itself)
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("secs="):
			secs = float(str(a).trim_prefix("secs="))
		if str(a).begins_with("fightjump="):
			jump = str(a).trim_prefix("fightjump=")
	root.size = Vector2i(1280, 720)
	## S379 (operator: "the holo head pointer is cut"): the hidden desktop gives a 1920x1009 window, the expanded picture
	## was 2055 wide and the 1920 movie cut ~65 px off each side - keep the picture 16:9 for films.
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("JUDGE_FILM reached fight night: ", TestJump.run(main, jump))
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	if not bool(view.playing):
		print("JUDGE_FILM FAIL the round never started")
		quit(1)
		return
	var kd := -1.0
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("knockdown="):
			kd = float(str(a).trim_prefix("knockdown="))
	if kd > 0.0 and kd < secs:
		# S376 knockdown=<s>: at that round time the next beats are a big landing cross and the count - the knockdown the round
		# script puts in its last exchange. The judge sees the shot, the fall, the slow-motion replay, the boxer on the canvas
		# (KnockdownReplay, FloorClear) and S377 the count (KnockdownCount: neutral corner, the number, he gets up, BOX!); the
		# round clock holds through the count, and the round's later beats play on after it.
		await _until(func(): return float(view.t) >= kd, kd * 2.0 + 30.0)
		var t0 := float(view.t)
		var bs: Array = view.beats
		while int(view.next) < bs.size() and float(bs[int(view.next)]["t"]) < t0 + 0.35:
			view.next = int(view.next) + 1   # nothing else fires between the shot and its count
		view._fire({"t": t0, "who": "a", "move": "cross", "result": "lands", "big": true, "knockback": true, "caption": "", "def": ""})
		await _until(func(): return float(view.t) >= t0 + 0.35, 10.0)
		view._fire({"t": t0 + 0.35, "who": "b", "move": "count", "result": "none", "big": false, "knockback": false, "caption": "", "def": ""})
		print("JUDGE_FILM knockdown at t=%.1f" % t0)
	await _until(func(): return not bool(view.playing) or float(view.t) > secs, secs * 2.0 + 30.0)
	print("JUDGE_FILM done t=%.1f" % float(view.t))
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
