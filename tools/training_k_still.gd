extends SceneTree
## S496 TRAININGK1: stills of TRAINING (Training K v6c) for the operator - the TEST CLUB (TestJump club4: three boxers + the
## grappler) with each boxer selected, a shared evening opened, and a normal start (the walk-in alone). Clean stills only
## (ONELOOK rule: no guide strip, no toast, no open modal). Run on the never-shown desktop:
##   python ops/Tools/godot_slot.py run --who trainingk -- python tools/hidden_desktop.py run --timeout=400 --log=<file> \
##       <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/training_k_still.gd \
##       -- <out_dir> text=<0-3>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")
const Settings := preload("res://scripts/state/Settings.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")

var main: Node
var out_dir := "user://training_k"
var text_i := 1


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("text="):
			text_i = clampi(int(str(a).substr(5)), 0, 3)
		elif not str(a).contains("="):
			out_dir = str(a)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	TextScale.use(self, float(Settings.TEXT_SIZES[text_i][1]))
	TestJump.run(main, "club4")
	var c: Career = main.career
	c.guide = ""
	main.modal = {}
	var tag := "t%d" % text_i
	main.act("area", "home")
	await _shot("gym_floor_pin_%s" % tag)
	for f in c.fighters:
		main.nav({"area": "training", "fighter": str(f["id"])})
		await _shot("club4_%s_%s" % [str(f["id"]), tag])
	# the first shared pad night opened, its line dragged toward the selected boxer
	var f0: Dictionary = c.fighters[0]
	for d in 6:
		var ids := DrillWeek.on_pads(c, d)
		if ids.size() >= 2:
			main.act("tkday", str(d))
			main.act("tksplit", "%d|0|55" % d)
			break
	main.nav({"area": "training", "fighter": str(f0["id"])})
	await _shot("club4_split_%s" % tag)
	main.act("quick")
	await _wait(2)
	main.career.guide = ""
	main.modal = {}
	Sim_sign(main.career)
	main.nav({"area": "training"})
	await _shot("normal_start_%s" % tag)
	TestJump.run(main, "camp")   # a booked bout: the bout panel, the scale and the first bell
	main.career.guide = ""
	main.nav({"area": "training"})
	await _shot("camp_%s" % tag)
	print("TRAINING_K_STILL wrote ", out_dir, " text=", text_i)
	quit(0)


func Sim_sign(c: Career) -> void:
	load("res://scripts/state/Sim.gd").sign(c, TestClub.PICKS.duplicate())


func _shot(name: String) -> void:
	main.modal = {}
	main.clear_toast()
	main.render()
	await create_timer(0.9).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
