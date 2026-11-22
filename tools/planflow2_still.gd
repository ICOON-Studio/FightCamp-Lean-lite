extends SceneTree
## S538 PLANFLOW2 stills: the Game plan chart with a MAIN BET, the last bout's uses and the saved plans open, and the
## result page's Plan tab judging the bet. The bout is the game's own (tools/result_dump.gd: Lucy v Priya Nair).
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/planflow2_still.gd -- <out_dir>

const Data := preload("res://scripts/state/Data.gd")
const UI := preload("res://scripts/ui/UI.gd")
const GamePlan := preload("res://scripts/ui/GamePlan.gd")
const PlanChart := preload("res://scripts/ui/PlanChart.gd")
const PlanBet := preload("res://scripts/ui/PlanBet.gd")
const PlanSaves := preload("res://scripts/ui/PlanSaves.gd")
const ResultTabs := preload("res://scripts/ui/ResultTabs.gd")
const Dump := preload("res://tools/result_dump.gd")

var main: Node
var out_dir := "user://planflow2"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var c: Career = main.career
	c.guide = ""
	var f: Dictionary = c.fighters[0]
	f["bout"] = {"opp": (Data.OPPONENTS[1] as Dictionary).duplicate(true), "day": c.day + 14, "weighed": false, "made": false, "done": false, "film": 1}
	# The bout already fought on this plan, its first line the bet (two bouts on record: last bout + all bouts chips).
	var cf: Array = Dump._setup(44)
	cf[1]["plan_bet"] = "long|"
	var m: Dictionary = Dump._fight(cf[0], cf[1], PlanBet.stamp(Dump.PLAN.duplicate(true), cf[1]), true)
	var rec: Dictionary = (cf[0] as Career).results[0]
	c.results.push_front(rec.merged({"fid": f["id"]}, true))
	c.results.push_back(rec.merged({"fid": f["id"]}, true))
	var combos: Dictionary = f.get_or_add("combos", {})
	for k in (cf[1]["combos"] as Dictionary):
		combos[k] = cf[1]["combos"][k]
	for k in (f.get("steps", {}) as Dictionary):
		f["steps"][k] = 60.0
	f["plan_bet"] = "long|"
	f["arrows"] = PlanBet.stamp(Dump.PLAN.duplicate(true), f)
	PlanSaves.save(c, "Box the counter", f["arrows"], f)
	PlanSaves.save(c, "Walk her down", [{"move": "1-2-3"}, {"move": "step_in"}], f)
	PlanChart.adding_if = false
	GamePlan.open = ""
	PlanSaves.open = false
	main.act("go", "playbook:1")
	await _shot("planflow2_chart_bet_uses")
	PlanSaves.open = true
	main.act("go", "playbook:1")
	await _shot("planflow2_chart_saves_open")
	PlanSaves.open = false
	# The result page's Plan tab on that bout.
	(main as CanvasItem).visible = false
	var bg := PanelContainer.new()
	bg.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD, 10, 1, 28, 24))
	bg.position = Vector2(60, 60)
	bg.size = Vector2(1800, 960)
	root.add_child(bg)
	bg.add_child(ResultTabs.plan(m, [str(cf[1]["first"]), str(cf[1]["bout"]["opp"]["first"])]))
	await _shot("planflow2_result_plan_tab")
	quit(0)


func _shot(name: String) -> void:
	await _wait(8)
	await create_timer(0.6).timeout
	if DisplayServer.get_name() == "headless":
		print("PLANFLOW2_STILL (headless, no picture) ", name)
		return
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(p)
	print("PLANFLOW2_STILL wrote ", p)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
