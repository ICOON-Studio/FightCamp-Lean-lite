extends SceneTree
## PICS2D2 (S540): a contact sheet of ONE real round in the pictures view. Plays the real game to fight night (the route
## of tools/pics2d_round.gd: quick start, sign, camp, weigh-in; seed=<n>), fights round 1 from the shout bar (the coach's
## read each time, as golden_path_test), opens the round page's "Watch it in pictures" view and photographs each picture
## (0.2 s in: the pop settled, the ring or streak showing) into a grid; writes <out>/contact_sheet.png and shows.json.
##   python tools/hidden_desktop.py run --timeout=600 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/pics2d_sheet.gd -- <out> no3d seed=7
## Prints PICS2D_SHEET pictures=<n> done.

const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const FightPictures := preload("res://scripts/ui/FightPictures.gd")
const TILE := Vector2i(480, 270)
const COLS := 4

var out_dir := "user://pics2d_sheet"
var main: Node


func _arg(key: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with(key + "="):
			return str(a).substr(key.length() + 1)
	return def


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	seed(int(_arg("seed", "7")))
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
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
	if offer.is_empty():
		print("PICS2D_SHEET FAIL no bout offer")
		quit(1)
		return
	main.act("accept", str(offer["id"]))
	if bool(offer.get("camp", true)):
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
	main.act("fightstep", "start")
	await _wait(2)
	for i in 8:
		if LiveRound.live(main.modal).is_empty():
			break
		var pv := LiveRound.preview(c.fighter_by_id(str(main.modal["fid"])), main.modal)
		var b := _modal_button("SayNothing" if i == 2 else "Shout_" + str(pv["coach"]))
		if b == null:
			break
		b.emit_signal("pressed")
		await _wait(2)
	var pb := _modal_button("Pictures")
	if pb == null:
		print("PICS2D_SHEET FAIL no Pictures button on the round page (step %s)" % str(main.modal.get("step", "")))
		quit(1)
		return
	pb.emit_signal("pressed")
	await _wait(3)
	var v: Node = main.get_node_or_null("FightPictures")
	var pics: Array = v.pics
	var rows := int(ceil(pics.size() / float(COLS)))
	var sheet := Image.create(TILE.x * COLS, TILE.y * rows, false, Image.FORMAT_RGB8)
	sheet.fill(Color(0.06, 0.06, 0.08))
	for i in pics.size():
		v.show_pic(i)
		v.u = 0.2
		v._frame()
		v.playing = false
		await _wait(2)
		await RenderingServer.frame_post_draw
		var img := root.get_texture().get_image()
		img.convert(Image.FORMAT_RGB8)
		img.resize(TILE.x, TILE.y, Image.INTERPOLATE_BILINEAR)
		sheet.blit_rect(img, Rect2i(Vector2i.ZERO, TILE), Vector2i((i % COLS) * TILE.x, (i / COLS) * TILE.y))
		print("PICS2D_SHEET %d %s  %s" % [i, str(pics[i]["pic"]), str(v._what.text)])
	sheet.save_png(out_dir.path_join("contact_sheet.png"))
	var fh := FileAccess.open(out_dir.path_join("shows.json"), FileAccess.WRITE)
	fh.store_string(JSON.stringify({"names": v.names, "set": v.set_id, "shows": pics}, "  "))
	fh.close()
	print("PICS2D_SHEET pictures=%d done" % pics.size())
	quit(0)


func _modal_button(name: String) -> Button:
	var m: Node = main.modal_node()
	return null if m == null else m.find_child(name, true, false) as Button


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
