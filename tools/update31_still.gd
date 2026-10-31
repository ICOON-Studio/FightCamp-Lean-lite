extends SceneTree
## S329 update 31 stills: TestJump "pro" -> the promoter's offer (her debut tickets, what the gym pays now); sign -> her
## debut camp, weigh-in, fight night simmed in words -> the result page (tickets sold, the gym's share) and MONEY.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/update31_still.gd -- <out_dir>
## Prints UPDATE31_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Roster := preload("res://scripts/state/Roster.gd")

var main: Node
var out_dir := "user://update31_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("UPDATE31_STILL pro jump: ", TestJump.run(main, "pro"))
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	print("UPDATE31_STILL members %d, sheet %s" % [c.members, str(Roster.debut_sheet(c, f, 1.0))])
	await _shot("pro_offer")
	main.act("turnpro")
	main.clear_toast()
	main.act("camp", str(f["id"]))
	main.act("startcamp")
	for i in 60:
		if Bouts.weigh_in_today(c, f):
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	main.act("weighin", str(f["id"]))
	main.act("doWeigh")
	main.run_to_stop()
	main.act("fightnight")
	main.act("fightstep", "sim")
	await _until(func(): return str(main.modal.get("step", "")) == "result", 30.0)
	print("UPDATE31_STILL debut: %s, tickets %s" % [main.modal.get("outcome", "?"), str(main.modal.get("tickets", {}))])
	main.redraw_modal()
	await _shot("debut_result")
	main.act("afterfight", "")
	if not main.modal.is_empty():
		main.act("close")
	main.clear_toast()
	main.act("go", "money:0")
	await _shot("money_after_debut")
	quit(0)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("UPDATE31_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
