extends SceneTree
## S328 update 30 stills: TestJump "nationals" (a known career played until Lucy can enter) -> WORLD > Nationals (the road,
## Enter), HOME (the Enter row, her season line), Enter -> WORLD > Nationals (her road, the regional draw), FIGHTS >
## Calendar; then her rounds are settled as wins (a stills tool, not the game) -> the national draw, and the title.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/update30_still.gd -- <out_dir>
## Prints UPDATE30_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

var main: Node
var out_dir := "user://update30_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("UPDATE30_STILL nationals jump: ", TestJump.run(main, "nationals"))
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	print("UPDATE30_STILL day %d (%s), %d-%d, joined %d, home line: %s" % [c.day, Clock.fmt(c.day), f["w"], f["l"], int(f.get("joined", -1)), Champs.home_line(c, f)])
	if not main.modal.is_empty():
		main.act("close")
	main.act("go", "world:4")
	await _shot("nationals_road")
	main.act("go", "home:0")
	await _shot("home_season")
	main.act("enterchamp", str(f["id"]))
	main.clear_toast()
	main.act("go", "world:4")
	await _shot("nationals_entered")
	main.act("go", "fights:1")
	await _shot("calendar")
	main.act("go", "home:0")
	await _shot("home_entered")
	for i in 2:
		_win(c, f)
	print("UPDATE30_STILL after the regional: level %s, size %d, stage %d" % [f["champ"]["level"], int(f["champ"]["national_size"]), int(f["champ"]["stage"])])
	main.act("go", "world:4")
	await _shot("national_draw")
	for i in 6:
		if not Champs.active(f):
			break
		if (f["bout"] as Dictionary).is_empty():
			c.day = Champs.stage_day(int(f["champ"]["close"]), int(f["champ"]["stage"]))
			Champs.day_events(c)
			continue
		_win(c, f)
	print("UPDATE30_STILL result: ", f["champ"]["result"], " titles ", f.get("titles", []))
	main.act("go", "world:4")
	await _shot("national_champion")
	quit(0)


func _win(c: Career, f: Dictionary) -> void:
	if (f["bout"] as Dictionary).is_empty():
		return
	c.day = int(f["bout"]["day"])
	f["bout"]["done"] = true
	f["w"] = int(f["w"]) + 1
	c.results.push_front({"d": c.day, "fid": f["id"], "who": f["first"], "opp": f["bout"]["opp"]["name"], "win": true,
		"outcome": "win", "pro": false, "cards": "30-27, 30-27, 29-28", "why": ""})
	Bouts.after_fight(c, f)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("UPDATE30_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
