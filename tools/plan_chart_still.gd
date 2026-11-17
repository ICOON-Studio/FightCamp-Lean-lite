extends SceneTree
## S482 PLANFLOW1: stills of PLAYBOOK > Game plan as the chart (his Q-240) - the tape-room jump (a booked opponent with the
## whole file open), then: the chart, the + Add an IF list, an IF's answer list. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 ##       --audio-driver Dummy --script res://tools/plan_chart_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanChart := preload("res://scripts/ui/PlanChart.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")

var main: Node
var out_dir := "user://plan_chart_still"


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
		if ch.name == "FightAnalysis":
			main.remove_child(ch)
			ch.queue_free()
	var f: Dictionary = (main.career as Career).fighter()
	var opp: Dictionary = f["bout"]["opp"]
	for id in OppFile.hidden(opp):
		OppFile.open(opp, str(id))
	print("OPP ", opp.get("first", ""), " | ", opp.get("style", ""), " | ", opp.get("threat", ""), " | ", opp.get("weak", ""))
	if not main.modal.is_empty():
		main.act("close")
	PlanChart.open = ""
	PlanChart.adding = ""
	PlanChart.adding_if = false
	main.act("go", "playbook:1")
	await _shot("plan_chart.png")
	var gp := root.find_child("GamePlan", true, false)
	(gp.find_child("AddIf", true, false)).on_click.call()
	await _shot("plan_chart_add_if.png")
	gp = root.find_child("GamePlan", true, false)
	var picks := gp.find_children("AddIf_*", "Button", true, false)
	if not picks.is_empty():
		(picks[0] as Button).pressed.emit()
	await _shot("plan_chart_answers.png")
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
