extends SceneTree
## S410 a still of Fighters > Roster with a full line of eight (made-up states, only for looking at the page):
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy \
##       --script res://tools/roster_still.gd -- <out_dir>
## Writes <out_dir>/roster_real.png.

const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Sim := preload("res://scripts/state/Sim.gd")

## name, sex, weight class, record, age, stance
const LINE := [
	["Aisha Rahman", "f", "Flyweight", 7, 2, 26, "Southpaw"], ["Maria Ortega", "f", "Flyweight", 9, 3, 28, "Orthodox"],
	["Megan Hughes", "f", "Featherweight", 5, 1, 24, "Orthodox"], ["Danny Osei", "m", "Lightweight", 3, 0, 20, "Orthodox"],
	["Josh Harper", "m", "Middleweight", 11, 4, 27, "Southpaw"], ["Tomas Novak", "m", "Welterweight", 8, 5, 25, "Orthodox"],
	["Kwame Boateng", "m", "Heavyweight", 24, 11, 37, "Orthodox"],
]


func _initialize() -> void:
	MenuFx.instant = true
	var out := "E:/FightCamp/tmp/s410_look/still"
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
	base["bout"] = _bout(c, 33, "Megan Hughes")
	for row in LINE:
		var f: Dictionary = base.duplicate(true)
		f["id"] = str(row[0]).to_lower().replace(" ", "_")
		f["name"] = row[0]
		f["first"] = str(row[0]).get_slice(" ", 0)
		f["sex"] = row[1]
		f["wc"] = row[2]
		f["w"] = row[3]
		f["l"] = row[4]
		f["age"] = row[5]
		f["stance"] = row[6]
		f["bout"] = {}
		f["camp"] = {}
		f["offers"] = []
		c.fighters.append(f)
	c.fighter_by_id("megan_hughes")["morale"] = 20.0
	c.fighter_by_id("megan_hughes")["weight"] = float(base["limit"]) + 1.3
	c.fighter_by_id("danny_osei")["injury"] = {"type": "hand", "until_day": c.day + 12, "days_out": 14}
	c.fighter_by_id("maria_ortega")["bout"] = _bout(c, 40, "Rosa Ferrer")
	c.fighter_by_id("maria_ortega")["camp"] = {"focus": "technique", "protocol": 0}
	main.act("go", "fighters:0")
	for i in 6:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out.path_join("roster_real.png"))
	print("ROSTER_STILL canvas ", root.get_visible_rect().size)
	base["bout"] = {}
	base["camp"] = {}
	var opp: Dictionary = (load("res://scripts/state/Data.gd").OPPONENTS[0] as Dictionary).duplicate(true)
	base["offers"].append(load("res://scripts/state/Bouts.gd")._offer("lucy:still", opp, c.day + 30, c.day + 6, 4))
	main.act("openBout", "lucy:still")
	for i in 6:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out.path_join("versus_real.png"))
	print("ROSTER_STILL wrote ", out)
	quit(0)


func _bout(c: Career, days: int, opp: String) -> Dictionary:
	return {"day": c.day + days, "weighed": false, "made": false, "done": false,
		"opp": {"name": opp, "first": opp.get_slice(" ", 0), "w": 5, "l": 1, "stance": "Orthodox", "style": "Pressure", "height": 171, "reach": 174}}
