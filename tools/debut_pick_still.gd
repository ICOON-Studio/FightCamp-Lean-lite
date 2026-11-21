extends SceneTree
## DEBUTPICK1 (S533) stills of the real pro offer with both houses calling: the "Picked to ..." line under each house's
## terms, and its hover card. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/debut_pick_still.gd -- <out_dir>

const Roster := preload("res://scripts/state/Roster.gd")
const Tips := preload("res://scripts/ui/Tips.gd")

var main: Node
var out_dir := "user://debut_pick_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	load("res://scripts/ui/MenuFx.gd").instant = true
	main = load("res://scenes/Main.tscn").instantiate()
	main.jump_override = "pro"
	root.add_child(main)
	await _wait(30)
	var c: Career = main.career
	c.members = 60   # the ticket forecast within 15 of break-even: both houses call
	c.pro_offer = {}
	Roster.check_pro(c)
	main.act("prooffer")
	await _wait(20)
	for t in c.pro_offer.get("offers", []):
		print("OFFER %s gap %.1f target %.3f picked %s" % [t["key"], float(t["opp_gap"]), float(t.get("opp_target", 0.0)), str(t.get("opp_picked", false))])
	var modal := main.find_child("House_bow", true, false) as Control
	if modal != null:
		var top: Control = modal
		while top.get_parent() is Control and not (top is PanelContainer and top.theme_type_variation == "Modal"):
			top = top.get_parent()
		print("MODAL rect %s (frame 1920x1080) fits=%s" % [str(top.get_global_rect()), str(top.get_global_rect().end.y <= 1080.0 and top.get_global_rect().position.y >= 0.0)])
	await _save("prooffer_picked")
	var lab := main.find_child("Picked_hf", true, false) as Control
	if lab != null and DisplayServer.get_name() != "headless":
		Tips.pin(lab, lab.get_meta(Tips.META_SPEC))   # the hover card, opened as Shift pins it
		await _wait(20)
		await _save("prooffer_picked_tip")
	quit(0)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame


func _save(name: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	print("wrote ", out_dir.path_join(name + ".png"))
