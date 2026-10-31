extends SceneTree
## S320 (operator Q-S294-31: "upload a short video to judge"): the fight as he would see it after the board's
## 'Test: fight night WITH film study' button - the intro, then round 1 at 1x up to `secs=` of round time (default 60).
## Run under Godot's movie writer on the never-shown desktop, then make an mp4 for the board (ffmpeg):
##   python tools/hidden_desktop.py run --timeout=600 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --audio-driver Dummy --fixed-fps 30 --write-movie <out>.avi --script res://tools/judge_film.gd -- [secs=60]
## Prints JUDGE_FILM done t=<round seconds> (fails loudly if the round never started).

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node


func _initialize() -> void:
	var secs := 60.0
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("secs="):
			secs = float(str(a).trim_prefix("secs="))
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("JUDGE_FILM reached fight night: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	if not bool(view.playing):
		print("JUDGE_FILM FAIL the round never started")
		quit(1)
		return
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
