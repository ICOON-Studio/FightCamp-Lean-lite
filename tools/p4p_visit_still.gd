extends SceneTree
## S533 P4PBUILD1 stage 1 stills, THE VISIT: reception with the visitor (the three answers and their cost), Home with its
## need, and reception again after the trial Monday. A quick-start club with Lucy; the bout's rounds are written by hand
## (the same planned line winning twice on the ropes) and handed to the real VisitWire.after_bout on the first seed that
## brings the visit. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/p4p_visit_still.gd -- <out_dir>

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Region := preload("res://scripts/state/Region.gd")
const VisitWire := preload("res://scripts/state/VisitWire.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

var main: Node
var out_dir := "user://p4p_visit_still"


func _x(at: String, won: bool, arrow: String = "") -> Dictionary:
	return {"at": at, "pinned": false, "won": won, "arrow": arrow, "planned": arrow != "", "arrow_fit": "best" if arrow != "" else "none",
		"shout": false, "call": "", "fit": "none"}


func _rounds() -> Array:
	var out: Array = []
	var n := 1
	for exs in [[_x("long", true, "1-2"), _x("own_ropes", true, "pivot_out"), _x("mid", false)], [_x("own_ropes", true, "pivot_out"), _x("long", true, "1-2")]]:
		out.append({"n": n, "won": true, "exchanges": exs, "arrows": PlanFight.tally(exs), "plan": []})
		n += 1
	return out


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for k in 4:
		await process_frame
	main.act("quick")
	var c: Career = main.career
	c.guide = ""
	c.applicant = {}
	c.first_hour = {}
	c.reputation = 40
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day += 5   # a Saturday show: the Monday trial falls inside the visit
	var f: Dictionary = c.fighters[0]
	var r: Dictionary = (c.rivals.filter(func(x): return str(x["div"]) == str(f["div"])) as Array)[2]
	Region.record(r, false)
	for s in range(1, 600):
		c.seed = s
		c.results.push_front({"d": c.day, "fid": str(f["id"])})
		VisitWire.after_bout(c, f, {"damage": {"a": 4.0, "b": 9.0}}, r, true, false, _rounds())
		if not c.applicant.is_empty():
			break
		c.results.pop_front()
	print("P4P_VISIT_STILL seed=", c.seed, " visitor=", c.applicant.get("name", "NONE"), " until=", c.applicant.get("expires", -1))
	main.modal = {}
	main.act("go", "home:0")
	main.render()
	await _save("visit_1_home_need")
	main.act("interview")
	await _save("visit_2_reception")
	main.act("trialvisit")
	while c.day < int(c.applicant.get("trial_day", c.day)):
		Sim.step_day(c)
	main.modal = {}
	main.act("go", "home:0")
	main.render()
	await _save("visit_3_home_trial_day")
	main.act("interview")
	await _save("visit_4_reception_after_trial")
	quit(0)


func _save(name: String) -> void:
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(p)
	print("P4P_VISIT_STILL wrote ", p)
