extends SceneTree
## S514 FIGHTWEEK3 favours earned: a still of the late-ask card on the boxer's Overview, and the Home page with its red
## need. Quick start, seed 11, the first show 40+ days on whose host asks (LateAskWire.roll_of), stepped by the real day
## loop to its Monday. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/late_ask_still.gd -- <out_dir>

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Region := preload("res://scripts/state/Region.gd")
const LateAskWire := preload("res://scripts/state/LateAskWire.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")

var main: Node
var out_dir := "user://late_ask_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	var c: Career = main.career
	c.seed = 11
	c.guide = ""
	c.applicant = {}
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	var show := c.day + 40
	while not Region.is_show_day(show) or LateAskWire.roll_of(c.seed, show) >= FightWeekEvents.ASK_CHANCE:
		show += 1
	c.day = FightWeekEvents.roll_day(show) - 1
	Sim.step_day(c)
	main.modal = {}
	main.act("go", "home:0")
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join("late_ask_home.png"))
	main.act("fighter", str(f["id"]))
	main.act("ftab", "0")
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join("late_ask_overview.png")
	root.get_texture().get_image().save_png(p)
	print("LATE_ASK_STILL wrote ", p, " open=", LateAskWire.is_open(f), " day=", c.day, " show=", show)
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
