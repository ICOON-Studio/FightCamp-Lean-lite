extends SceneTree
## S539 PLANREADSHOW1 stills: the Game plan chart with a MAIN BET, the last bout's uses and the saved plans open, and the
## result page's Plan tab judging the bet. The bout is the game's own (tools/result_dump.gd: Lucy v Priya Nair).
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/planreadshow1_still.gd -- <out_dir>

const Data := preload("res://scripts/state/Data.gd")
const UI := preload("res://scripts/ui/UI.gd")
const GamePlan := preload("res://scripts/ui/GamePlan.gd")
const PlanChart := preload("res://scripts/ui/PlanChart.gd")
const PlanBet := preload("res://scripts/ui/PlanBet.gd")
const PlanSaves := preload("res://scripts/ui/PlanSaves.gd")
const ResultTabs := preload("res://scripts/ui/ResultTabs.gd")
const Dump := preload("res://tools/result_dump.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")

var main: Node
var out_dir := "user://planreadshow1"


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
	# A plan that leans on one answer: three of its four lines are the one-two. The chart warns.
	f["arrows"] = [{"move": "1-2"}, {"move": "1-2", "when": "press"}, {"move": "1-2", "when": "counter"}, {"move": "step_back", "when": "press"}]
	PlanChart.adding_if = false
	GamePlan.open = ""
	main.act("go", "playbook:1")
	await _shot("planreadshow1_chart_lean_chip")
	# A round where the answers were already spent: the opponent has read them (the game's own exchange path).
	var ranger: Dictionary = Data.RIVALS.filter(func(r): return str(r["style"]) == "Out-boxer")[0]
	var c2 := Career.quick_start()
	c2.fighters.append(Data.fighter_state(Data.lucy(), c2.day))
	c2.day = 41
	var f2: Dictionary = c2.fighter()
	f2["camp"] = {}
	f2["combos"] = {"1-1": 50.0, "1-2": 50.0, "1-1-2": 50.0, "2-3": 40.0}
	f2["arrows"] = PlanTemplates.load(PlanTemplates.boxing("t_walk"), PlanBoard.TOP_COACH)
	f2["bout"] = {"opp": ranger.duplicate(true), "day": c2.day, "weighed": true, "made": true, "done": false, "film": 3}
	OppFile.open_all(f2["bout"]["opp"])
	var m2 := {"fid": f2["id"], "step": "tape", "total": 3, "round": 1, "rounds": []}
	LiveRound.open(c2, f2, m2, 1, "", BoutNight._energy(f2, 1, ""))
	var spent := {}
	for a in f2["bout"]["arrows"]:
		spent[str(a["move"])] = 3
	LiveRound.live(m2)["answer_uses"] = spent
	while not LiveRound.live(m2).is_empty():
		var r := LiveRound.exchange(c2, f2, m2, "")
		if not r.is_empty():
			(m2["rounds"] as Array).append(r)
	var feed := ""
	for x in (m2["rounds"][0] as Dictionary)["exchanges"]:
		feed += str(x.get("read_line", ""))
	print("FEED_LINE ", feed)
	(main as CanvasItem).visible = false
	var bg := PanelContainer.new()
	bg.add_theme_stylebox_override("panel", UI.box(UI.PANEL, UI.GOLD, 10, 1, 28, 24))
	bg.position = Vector2(60, 60)
	bg.size = Vector2(1800, 960)
	root.add_child(bg)
	bg.add_child(ResultTabs.plan(m2, [str(f2["first"]), str(f2["bout"]["opp"]["first"])]))
	await _shot("planreadshow1_result_plan_tab")
	quit(0)


func _shot(name: String) -> void:
	await _wait(8)
	await create_timer(0.6).timeout
	if DisplayServer.get_name() == "headless":
		print("PLANREADSHOW1_STILL (headless, no picture) ", name)
		return
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(p)
	print("PLANREADSHOW1_STILL wrote ", p)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
