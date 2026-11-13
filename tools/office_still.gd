extends SceneTree
## S453 a still of the office desktop with four fighters (his C367 "populate it with more fighters"; made-up states, only
## for looking at the page - the game's own four starters come with FOURSTART1):
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy \
##       --script res://tools/office_still.gd -- <out_dir>
## Writes <out_dir>/office_real.png.

const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Sim := preload("res://scripts/state/Sim.gd")

## name, sex, weight class, w, l, morale
const LINE := [["Megan Hughes", "f", "Featherweight", 5, 1, 38.0], ["Danny Osei", "m", "Lightweight", 3, 0, 82.0],
	["Josh Harper", "m", "Middleweight", 11, 4, 55.0]]


func _initialize() -> void:
	MenuFx.instant = true
	var out := "E:/FightCamp/tmp/s453_office"
	if not OS.get_cmdline_user_args().is_empty():
		out = OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	c.guide = ""
	var base: Dictionary = c.fighters[0]
	for row in LINE:
		var f: Dictionary = base.duplicate(true)
		f["id"] = str(row[0]).to_lower().replace(" ", "_")
		f["name"] = row[0]
		f["first"] = str(row[0]).get_slice(" ", 0)
		f["sex"] = row[1]
		f["wc"] = row[2]
		f["w"] = row[3]
		f["l"] = row[4]
		f["morale"] = row[5]
		f["bout"] = {}
		f["camp"] = {}
		f["offers"] = []
		c.fighters.append(f)
	c.fighter_by_id("danny_osei")["bout"] = {"day": c.day + 9, "weighed": false, "made": false, "done": false,
		"opp": {"name": "Rosa Ferrer", "first": "Rosa", "w": 5, "l": 1, "stance": "Orthodox", "style": "Pressure", "height": 171, "reach": 174}}
	main.act("go", "office:0")
	for i in 8:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out.path_join("office_real.png"))
	print("OFFICE_STILL wrote ", out)
	quit(0)
