extends SceneTree
## S357 stills + a camp played through on the never-shown desktop: the board's jump=camp (Lucy in camp, the short-notice
## swap dealt), the whiteboard after Monday took the swap (the new opponent circled), then the camp run to fight night and
## the bout simmed - the update 60 path end to end, printed as S357_CAMP lines.
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/s357_stills.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const W := 1920
const H := 1080

var main: Node
var out_dir := "user://s357"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	var ok := TestJump.run(main, "camp")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	var was := str(f["bout"]["opp"]["name"])
	print("S357_CAMP jump ok=%s day %d twist %s vs %s on day %d" % [ok, c.day, f.get("twist", ""), was, int(f["bout"]["day"])])
	await _shot("s357_swap_card")
	for i in 14:   # to Monday: the coach's call takes the fight
		if bool(f.get("twist_locked", false)):
			break
		_tidy(c)
		main.run_to_stop(1)
	print("S357_CAMP monday day %d: %s -> %s, short_notice %s, tapes %s" % [c.day, was, str(f["bout"]["opp"]["name"]),
		bool(f["bout"].get("short_notice", false)), str((f["camp"] as Dictionary).get("tapes", "-"))])
	_tidy(c)
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _shot("s357_after_swap")
	var rep := c.reputation
	for i in 60:
		if Bouts.fight_day(c, f) or (f["bout"] as Dictionary).is_empty():
			break
		_tidy(c)
		if Bouts.weigh_in_today(c, f):
			main.act("weighin", str(f["id"]))
			main.act("doWeigh")
		main.run_to_stop()
	if not (f["bout"] as Dictionary).is_empty() and Bouts.fight_day(c, f):
		main.act("fightnight")
		main.act("fightstep", "sim")
		print("S357_CAMP fight day %d vs %s: %s, reputation %+d, peak %s" % [c.day, str(f["bout"]["opp"]["name"]),
			str(main.modal.get("outcome", "?")), c.reputation - rep, str(main.modal.get("peak", false))])
	else:
		print("S357_CAMP no fight: day %d, bout %s" % [c.day, str(f.get("bout", {}))])
	quit(0)


func _tidy(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	if not main.modal.is_empty() and str(main.modal.get("type", "")) != "fight":
		main.act("close")


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(6)
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
