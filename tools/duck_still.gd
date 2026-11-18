extends SceneTree
## S518 R6 still: the Ask panel for a boxer ON A RUN (3 wins, +17 points in 8 weeks), with the step-up name 5 points above
## her already DUCKED once - the green run line, Leans No - your boxer is on a run, and the DUCKED chip. TEST CLUB, first
## boxer at 5-1. Hidden desktop only:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/duck_still.gd -- <out_dir>

const TestClub := preload("res://scripts/state/TestClub.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")
const HotStreak := preload("res://scripts/state/HotStreak.gd")

var main: Node
var out_dir := "user://duck_still"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	main.act("newcareer")
	main.act("quick")
	await _settle()
	var c: Career = main.career
	TestClub.make(c)
	var f: Dictionary = TestClub.boxers(c)[0]
	f["w"] = 5
	f["l"] = 1
	f["rep"] = 25
	f["last_bout_day"] = c.day - Bouts.AFTER_FIGHT
	f["injury"] = {}
	f["bout"] = {}
	f["offers"] = []
	for k in [[40, 6], [25, 5], [Bouts.AFTER_FIGHT, 6]]:
		c.results.push_front({"d": c.day - int(k[0]), "fid": f["id"], "who": f["first"], "opp": "X", "win": true, "pts": int(k[1])})
	var ducked := ""
	for a in AskFlow.answers(c, f)["cards"]:
		if str(a["kind"]) != "sheet":
			HotStreak.duck(c, f, str(a["opp"]["name"]))   # every name she may ask has ducked her once
			ducked = str(a["opp"]["name"])
	main.act("ask", str(f["id"]))
	print("DUCK_STILL pick=", ducked, " rep_now=", c.rival(ducked).get("rep", -1), " lines=", AskFlow.AskLadder.lines(c, f, c.rival(ducked)))
	await _shot("duck_ask")
	for n in main.find_children("*", "ScrollContainer", true, false):
		(n as ScrollContainer).scroll_vertical = 600
	await _shot("duck_ask_lower")
	print("DUCK_STILL done hot=", HotStreak.hot(c, f), " ducked=", ducked)
	quit(0)


func _settle() -> void:
	for i in 6:
		await process_frame


func _shot(name: String) -> void:
	await _settle()
	var g := main.find_child("FirstWeekStrip", true, false)
	if g != null:
		(g as CanvasItem).visible = false
	if DisplayServer.get_name() == "headless":
		print("headless: no picture for ", name)
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
