extends SceneTree
## S443 real stills of the two builds: the Money page on one screen (proposal B) and the top bar's back arrow with its hover
## word showing. Real pictures only, on the never-shown desktop (nothing opens on the operator's monitors):
##   python ops/Tools/godot_slot.py run --who money -- python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . \
##       --windowed --resolution 1920x1080 --script res://tools/money_hover_still.gd -- <out_dir>
## layout_snapshot.gd plays the whole tour (title to the pro offer) for one page; this one goes straight to the two moments.

const HoverLabel := preload("res://scripts/ui/HoverLabel.gd")

var main: Node
var out_dir := "user://money_still"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true   # a still shows a screen at rest
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	if DisplayServer.get_name() == "headless":
		print("MONEY_STILL needs a real window (the hidden desktop); nothing drawn")
		quit(1)
		return
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	main.act("quick")
	main.act("go", "money:0")
	await _settle(8)
	_no_guide()
	await _shot("money")
	var back := main.find_child("Nav_back", true, false) as Control
	if back == null:
		print("MONEY_STILL no back arrow")
		quit(1)
		return
	var ev := InputEventMouseMotion.new()
	ev.position = back.get_global_rect().get_center()
	ev.global_position = ev.position
	root.push_input(ev, true)
	await _settle(20)
	var tag := back.get_node_or_null("HoverTag") as Control
	var by_mouse := tag != null and tag.visible
	if not by_mouse:
		HoverLabel.open(back)   # the hidden desktop may not route the moved mouse: open it the way mouse_entered does
		await _settle(20)
	print("MONEY_STILL hover tag by mouse %s, shown %s, word %s" % [by_mouse, tag != null and tag.visible, HoverLabel.word(back)])
	await _shot("hover_back")
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
