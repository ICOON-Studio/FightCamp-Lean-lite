extends SceneTree
## S531 the fit-out loan on the real Money page: a full gym that cannot pay the $12,000 move (before), then the move on the
## loan (after: the week's costs carry "Fit-out loan"). Real pictures on the never-shown desktop:
##   python ops/Tools/godot_slot.py run --who loanstill -- python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . \
##       --windowed --resolution 1920x1080 --script res://tools/loan_still.gd -- <out_dir>

const GymSpend := preload("res://scripts/state/GymSpend.gd")

var main: Node
var out_dir := "user://loan_still"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	if DisplayServer.get_name() == "headless":
		print("LOAN_STILL needs a real window (the hidden desktop); nothing drawn")
		quit(1)
		return
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	main.act("quick")
	var c: Career = main.career
	c.cash = 6000
	c.reputation = 120
	c.members = GymSpend.member_cap(c)
	main.act("go", "money:0")
	await _settle(8)
	_no_guide()
	var btn := main.find_child("MoveLoan", true, false) as Button
	print("LOAN_STILL loan button %s disabled=%s room=%s" % [btn != null, btn.disabled if btn != null else true, GymSpend.room_line(c)])
	await _shot("loan_before")
	main.act("moveloan", "")
	await _settle(8)
	main.act("go", "money:0")
	await _settle(8)
	_no_guide()
	print("LOAN_STILL after premises=%d fitout_weeks=%d cash=%d" % [c.premises, c.fitout_weeks, c.cash])
	await _shot("loan_after")
	quit(0)


func _no_guide() -> void:
	var g := main.find_child("FirstWeekStrip", true, false) as CanvasItem
	if g != null:
		g.visible = false


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(4)
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + "_real.png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
