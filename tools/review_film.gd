extends SceneTree
## S361 the week review's reveal (ReviewReveal) filmed on the never-shown desktop: a fresh career played week by week, each
## review's first 5 s saved as frames (10 a second at --fixed-fps 30) plus a still once it has all landed; prints
## REVIEW_FILM lines (week, headlines). ffmpeg joins the frames into an mp4 afterwards.
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 --fixed-fps 30 \
##       --script res://tools/review_film.gd -- <out_dir> [weeks]

const Bouts := preload("res://scripts/state/Bouts.gd")
const W := 1920
const H := 1080

var main: Node
var out_dir := "user://review_film"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	var weeks := int(args[1]) if args.size() > 1 else 3
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	main.act("newcareer")
	main.act("quick")
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("hire", "reid")
	await _settle(4)
	var c: Career = main.career
	var frame := 0
	for w in weeks:
		for i in 40:
			if c.review_pending:
				break
			_steady(c)
			main.run_to_stop()
		if not c.review_pending:
			print("REVIEW_FILM week %d: no review (day %d)" % [w + 1, c.day])
			break
		main.act("review")
		var rv: Node = _find_review(main)
		for f in 50:   # 5 s at 10 frames a second
			await _settle(3)
			root.get_texture().get_image().save_png(out_dir.path_join("f_%04d.png" % frame))
			frame += 1
		print("REVIEW_FILM week %d: revealed=%s headlines=%s" % [w + 1, rv != null and bool(rv.revealed),
			"[]" if rv == null else JSON.stringify(rv.headlines)])
		root.get_texture().get_image().save_png(out_dir.path_join("review_w%d_real.png" % (w + 1)))
		main.act("close")
		await _settle(2)
	print("REVIEW_FILM frames=%d" % frame)
	quit(0)


## A steady player between reviews (layout_snapshot's _run_until): offers declined, weigh-ins stepped, fight nights simmed.
func _steady(c: Career) -> void:
	for f in c.fighters:
		for o in f["offers"]:
			if not bool(o["answered"]) and not bool(o["mismatch"]):
				main.act("declineOffer", str(o["id"]))
		if Bouts.weigh_in_today(c, f):
			main.act("weighin", f["id"])
			main.act("doWeigh")
		if Bouts.fight_day(c, f):
			main.act("fightnight")
			main.act("fightstep", "sim")
			main.act("afterfight")
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")
	if not main.modal.is_empty() and str(main.modal.get("type", "")) != "review":
		main.act("close")


func _find_review(n: Node) -> Node:
	if n.get("headlines") != null:
		return n
	for ch in n.get_children():
		var r := _find_review(ch)
		if r != null:
			return r
	return null


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame
