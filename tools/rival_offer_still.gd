extends SceneTree
## S518 R9 play-check: a still of the rival gym's offer card on the boxer's Overview, and the Home page with its red need.
## Quick start, Lucy made 6-1 on 40 ladder points (ranked), a Monday with a show 7-21 days out, RivalOfferWire.monday
## (the real Monday path). Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/rival_offer_still.gd -- <out_dir>

const Data := preload("res://scripts/state/Data.gd")
const RivalOfferWire := preload("res://scripts/state/RivalOfferWire.gd")

var main: Node
var out_dir := "user://rival_offer_still"


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
	c.seed = 41
	c.guide = ""
	c.applicant = {}
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighters[0]
	f["w"] = 6
	f["l"] = 1
	f["rep"] = 40
	f["offers"] = []
	f["next_offer_day"] = 9999
	var d := maxi(7, int(c.day / 7) * 7 + 7)
	while RivalOfferWire._show_after(d) < 0:
		d += 7
	c.day = d
	var lines := RivalOfferWire.monday(c)
	main.modal = {}
	main.act("go", "home:0")
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join("rival_offer_home.png"))
	main.act("fighter", str(f["id"]))
	main.act("ftab", "0")
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join("rival_offer_overview.png")
	root.get_texture().get_image().save_png(p)
	print("RIVAL_OFFER_STILL wrote ", p, " open=", RivalOfferWire.is_open(f), " day=", c.day, " lines=", lines)
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
