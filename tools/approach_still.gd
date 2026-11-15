extends SceneTree
## S487 R58 APPROACHWIRE1: a still of the approach card on the boxer's Overview - quick start, the prospect signed and put
## on a day job at loyalty 30, the club's stipend holder at 64, stepped to the Monday Eastside ABC comes, then the Overview.
## Also writes the Home page (the red need). Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/approach_still.gd -- <out_dir>

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")

var main: Node
var out_dir := "user://approach_still"


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
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	Roster.sign_fighter(c, Data.PROSPECTS[0], [])
	c.cash = 40000
	var holder: Dictionary = c.fighter()
	var kid: Dictionary = c.fighters[c.fighters.size() - 1]
	holder["loyalty"] = 64
	holder["day_job"] = false
	holder["weekly_salary"] = 250
	GymSpend.set_stipend(c, kid, false)
	kid["loyalty"] = 30
	for i in 8:
		Sim.step_day(c)
		if ApproachWire.is_open(kid):
			break
	main.modal = {}
	main.act("go", "home:0")
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join("approach_home.png"))
	main.act("fighter", str(kid["id"]))
	main.act("ftab", "0")
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join("approach_overview.png")
	root.get_texture().get_image().save_png(p)
	print("APPROACH_STILL wrote ", p, " open=", ApproachWire.is_open(kid), " day=", c.day)
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
