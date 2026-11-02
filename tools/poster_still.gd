extends SceneTree
## S361 the fight poster (FightPoster) on the never-shown desktop: the board's jump=camp (a bout booked), Home with the
## poster pinned, the poster alone at full size, and her ask (PushBack) on the whiteboard; prints POSTER lines.
##   python tools/hidden_desktop.py run --timeout=200 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/poster_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const FightPoster := preload("res://scripts/ui/FightPoster.gd")
const W := 1920
const H := 1080

var main: Node
var out_dir := "user://poster"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	var ok := TestJump.run(main, "camp")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	print("POSTER jump ok=%s bout vs %s on day %d" % [ok, str(f["bout"]["opp"]["name"]), int(f["bout"]["day"])])
	if not main.modal.is_empty():
		main.act("close")
	main.act("area", "home")
	await _shot("poster_home")
	var layer := ColorRect.new()
	layer.color = Color("#cfe0ea")
	layer.size = Vector2(W, H)
	root.add_child(layer)
	var p := FightPoster.build(c, f, 600.0)
	layer.add_child(p)
	p.position = Vector2((W - 600) * 0.5, 50)
	print("POSTER built=%s size=%s" % [p != null, str(p.custom_minimum_size) if p != null else "-"])
	await _shot("poster_full")
	layer.queue_free()
	# S361 her ask on the whiteboard (PushBack's card in the twist's place).
	const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
	f["twist"] = "ask_spar"
	f["twist_locked"] = false
	f.erase("twist_pick")
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	print("POSTER ask card: %s" % WeekTwist.card_for(f)["name"])
	await _shot("ask_whiteboard")
	quit(0)


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(8)
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))
