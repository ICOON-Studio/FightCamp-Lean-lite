extends SceneTree
## S387 MENUREVIEW1 stills of the week review (WeekRead rows): a week with a crossed point, a week with none, the same
## scrolled to its end, a booked camp week, a gym below $0 and two fighters. Prints REVIEW_STILL lines: the body's height
## against the screen and every row that runs off the modal.
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/review_read_still.gd -- <out_dir>

const Roster := preload("res://scripts/state/Roster.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

var main: Node
var out_dir := "user://review_read"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("newcareer")
	main.act("quick")
	main.act("guideskip")
	main.close_modal()
	main.career.seed = 1
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("hire", "reid")
	await _wait(2)
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	# A week with a crossed point (the first that has one), then a week with none (every stat set just past a whole point).
	await _review("crossed", func(): _nudge(f, 0.9))
	await _review("none", func(): _nudge(f, 0.02))
	await _review("none_end", func(): _nudge(f, 0.02), true)
	# A camp: the pads train its stat, the bars read the weeks to fight night; the gym low on cash.
	f["camp"] = {"focus": "technique", "protocol": 2, "start": c.day}
	c.cash = 900
	await _review("camp_low_cash", func(): _nudge(f, 0.8))
	c.cash = -6000
	c.weeks_below = 3
	f["camp"] = {}
	await _review("below_zero", func(): _nudge(f, 0.5), true)
	c.cash = 20000
	c.weeks_below = 0
	var p := Roster.prospect(c, "danny")
	p["state"] = "invited"
	Roster.sign_prospect(c, "danny", ["signature"])
	await _review("two_fighters", func(): _nudge(f, 0.9))
	print("REVIEW_STILL done")
	quit(0)


func _nudge(f: Dictionary, frac: float) -> void:
	for k in f["stats"]:
		f["stats"][k] = floorf(float(f["stats"][k])) + frac
	f["week_start"] = (f["stats"] as Dictionary).duplicate()


## Runs to the next review (Monday's nudge first), lands everything and saves the still.
func _review(tag: String, before: Callable, to_end := false) -> void:
	var c: Career = main.career
	before.call()
	for i in 12:
		main.run_to_stop()
		if c.review_pending:
			break
		_tidy(c)
	main.act("review")
	await _wait(6)
	var rv: Node = main.modal_node()
	rv.finish()
	await _wait(8)
	var sc := rv.find_child("ReviewScroll", true, false) as ScrollContainer
	sc.scroll_vertical = 100000 if to_end else 0   # finish() leaves it on the sticky note
	await _wait(4)
	var body := sc.get_child(0) as Control
	print("REVIEW_STILL %s: crossed=%d headlines=%s body_h=%d shown_h=%d modal=%s" % [tag, int(rv.crossed), JSON.stringify(rv.headlines), int(body.size.y), int(sc.size.y), str(rv.get_global_rect())])
	var frame: Rect2 = rv.get_global_rect()
	for n in rv.find_children("*", "Label", true, false):
		var l := n as Label
		if l.is_visible_in_tree() and l.get_global_rect().end.x > frame.end.x + 1.0:
			print("REVIEW_STILL   past the modal: ", l.name, " '", l.text.left(60), "'")
	for n in ["Goal_", "Rank_", "Runway"]:
		for k in rv.find_children(n + "*", "", true, false):
			var t := k.find_child(str(k.name) + "_text", true, false) as Label
			if t != null:
				print("REVIEW_STILL   ", k.name, ": ", t.text)
	for k in rv.find_children("Why_*", "", true, false):
		print("REVIEW_STILL   ", k.name, ": ", (k as Label).text)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("%s/review_%s.png" % [out_dir, tag])
	main.act("close")
	await _wait(2)


func _tidy(c: Career) -> void:
	for f in c.fighters:
		for o in f["offers"]:
			if not bool(o["answered"]):
				main.act("declineOffer", str(o["id"]))
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")
	if not main.modal.is_empty() and str(main.modal.get("type", "")) != "review":
		main.act("close")


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
