extends SceneTree
## S395 what is on screen under the corner minute, frame by frame. Plays to fight night, skips two rounds and logs, each
## frame of each corner: is the minute alive, is the round running, and which HUD pieces show.
##   corner 1 "player": the minute runs to its own end, as in the game.
##   corner 2 "film":   fight3d_film.gd's way, fightstep 45 frames after the bell while the minute is still running.
## A piece showing while the minute lives is the fault. Needs the never-shown desktop (the stage draws):
##   python tools/hidden_desktop.py run --timeout=400 --log=<log> <godot.exe> --path . --windowed --resolution 1280x720 \
##       --fixed-fps 30 --script res://tools/hud_corner_probe.gd
## Prints HUD_CORNER <arm> frames=<n> overlap=<n> ... and HUD_CORNER failures=<n> (the player arm must be 0).

const Bouts := preload("res://scripts/state/Bouts.gd")
const CornerMinute := preload("res://scripts/fight3d/CornerMinute.gd")

var main: Node
var view: Node
var arm := ""
var rows := {}


func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	await _to_fight_night()
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	print("HUD_CORNER round 1 playing, banner=", view._banner.text)
	process_frame.connect(_log)

	await _wait(30)
	arm = "player"
	view.skip_round()
	await _until(func(): return _minute() != null, 5.0)
	await _until(func(): return _minute() == null, 90.0)
	await _until(func(): return bool(view.playing), 10.0)
	await _wait(10)
	arm = ""
	print("HUD_CORNER after the minute round=", view.round_n, " playing=", view.playing)

	await _wait(30)
	arm = "film"
	view.skip_round()
	await _until(func(): return _minute() != null, 5.0)
	await _wait(45)
	main.act("fightstep", "corner:body")
	await _wait(120)
	arm = ""

	var failures := 0
	for k in rows:
		var r: Dictionary = rows[k]
		print("HUD_CORNER %s frames=%d minute=%d overlap=%d playing=%d bug=%d buttons=%d rings=%d banner=%d" % [k, r["frames"], r["minute"],
			r["overlap"], r["playing"], r["bug"], r["buttons"], r["rings"], r["banner"]])
	if int((rows.get("player", {"overlap": 1}) as Dictionary)["overlap"]) > 0:
		failures += 1
	print("HUD_CORNER failures=", failures)
	quit(failures)


func _log() -> void:
	if arm == "" or not is_instance_valid(view):
		return
	if not rows.has(arm):
		rows[arm] = {"frames": 0, "minute": 0, "overlap": 0, "playing": 0, "bug": 0, "buttons": 0, "rings": 0, "banner": 0}
	var r: Dictionary = rows[arm]
	var alive := _minute() != null
	var bug: bool = view._bug_box.is_visible_in_tree()
	var buttons: bool = view._buttons.is_visible_in_tree()
	var rings := false
	for b in view.bars.blocks:
		rings = rings or (b as Control).is_visible_in_tree()
	var banner: bool = str(view._banner.text) != ""
	r["frames"] += 1
	r["minute"] += int(alive)
	r["playing"] += int(bool(view.playing))
	if alive:
		r["bug"] += int(bug)
		r["buttons"] += int(buttons)
		r["rings"] += int(rings)
		r["banner"] += int(banner)
		r["overlap"] += int(bug or buttons or rings or banner)


func _minute() -> Node:
	for c in view.get_children():
		if c is CornerMinute and not c.is_queued_for_deletion():
			return c
	return null


func _to_fight_night() -> void:
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		_tidy(c)
		main.run_to_stop()
	var offer: Dictionary = {}
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			offer = o
	main.act("accept", str(offer["id"]))
	main.act("camp", str(f["id"]))
	main.act("startcamp")
	for i in 60:
		if Bouts.weigh_in_today(c, f):
			break
		_tidy(c)
		main.run_to_stop()
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	main.act("fightnight")
	await _wait(4)


func _tidy(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
