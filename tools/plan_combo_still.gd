extends SceneTree
## S378 PLANCOMBO1: a still of PLAYBOOK > Game plan's GO-TO COMBINATION row - the camp jump (Lucy booked), two of her own
## combinations drilled (a 3-punch signature named as the go-to, a jab-cross), then the Game plan tab scrolled to the row.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/plan_combo_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")

var main: Node
var out_dir := "user://plan_combo_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("JUMP ", TestJump.run(main, "taperoom"))
	for ch in main.get_children():
		if ch.name == "TapeRoom":
			main.remove_child(ch)
			ch.queue_free()
	var f: Dictionary = (main.career as Career).fighter()
	for mv in ["Jab", "Cross", "Lead hook"]:
		f["moves"][mv] = maxf(float(f["moves"].get(mv, 0.0)), 70.0)
	f["book"] = [{"name": "jab, cross, lead hook", "chain": ["jab", "cross", "lead_hook"], "score": 72},
		{"name": "jab, cross", "chain": ["jab", "cross"], "score": 62}]
	OwnCombos.ensure_ids(f)
	f["own_combos"] = {"own:1": ComboWords.SIGNATURE_AT, "own:2": 55.0}
	f["plan_combo"] = "own:1"
	print("GOTO ", OwnCombos.named(f).get("name", "-"), " whole ", OwnCombos.whole_by_round(f, OwnCombos.named(f)))
	if not main.modal.is_empty():
		main.act("close")
	main.act("go", "playbook:1")
	await _wait(6)
	var row := root.find_child("PlanGoTo", true, false) as Control
	if row != null:
		var scroll: ScrollContainer = null
		var p := row.get_parent()
		while p != null and scroll == null:
			scroll = p as ScrollContainer
			p = p.get_parent()
		if scroll != null:
			scroll.ensure_control_visible(row)
	await _shot("plan_combo_goto.png")
	quit(0)


func _shot(name: String) -> void:
	main.clear_toast()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name))
	print("STILL ", name)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
