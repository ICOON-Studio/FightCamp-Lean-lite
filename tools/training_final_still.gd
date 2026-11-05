extends SceneTree
## S382 training final proof stills (TRAINING_SCREEN_S381.md, beside the approved training_mockup.png), one per run:
##   learn  - Lucy between fights (no bout booked): the Training tab as it opens, the LEARN tray
##   camp   - jump=camp: the Training tab in a camp week as it opens
##   plan   - jump=camp with a full Game plan and her file found (S382 PLANTRAY1): THE PLAN vs <her> tray
##   split  - jump=camp, her first pad night split 1-1 / Uppercut (cycled to 70/30), scrolled to the strip
##   review - jump=camp with that split night (70/30), the week run to its review: the PADS row once it has landed
## On the never-shown desktop (the game draws into a 1920x1080 SubViewport; the window there is 1920x1009):
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/training_final_still.gd -- <out_dir> <mode> [prefix, default final_]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")

var main: Node
var out_dir := "user://training_final"
var prefix := "final_"
var vp: SubViewport


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	var mode: String = args[1] if args.size() > 1 else "camp"
	if args.size() > 2:
		prefix = args[2]
	DirAccess.make_dir_recursive_absolute(out_dir)
	# The hidden desktop clamps every window to 1920x1009 (maximized, windowed and borderless alike), so the game renders
	# into a 1920x1080 SubViewport and the still is that viewport's picture.
	vp = SubViewport.new()
	vp.size = Vector2i(1920, 1080)
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	main = load("res://scenes/Main.tscn").instantiate()
	vp.add_child(main)
	await _settle(8)
	if mode == "learn":
		await _learn()
	else:
		await _camp(mode)
	print("window ", root.size, " still ", vp.size)
	quit(0)


## Quick start as TestJump does it, but no bout taken: Lucy between fights.
func _learn() -> void:
	main.save_path = "user://training_final_save.json"
	main.act("quick")
	(main.career as Career).seed = 1
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = (main.career as Career).fighter()
	print("bout ", f.get("bout", null), " offers ", (f.get("offers", []) as Array).size())
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _wait(3.0)
	await _shot(prefix + "learn")


func _camp(mode: String) -> void:
	if not TestJump.run(main, "camp"):
		print("jump=camp failed")
		return
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	var fid := str(f["id"])
	if mode == "plan":
		_plan(f)
	if mode == "camp" or mode == "plan":
		main.act("fighter", fid)
		main.act("ftab", "3")
		await _wait(3.0)
		await _shot(prefix + mode)
		return
	f["combos"]["1-1"] = 28.0
	var nights := PadWeek.nights_of(f)
	var d := int((nights["pads"] as Array)[0])
	PadEdit.clear(f, nights, d)
	PadEdit.place(f, nights, d, "combo:1-1")
	PadEdit.place(f, nights, d, "move:Uppercut")
	main.act("padsplit", "%s|%d" % [fid, d])   # 50/50 -> 70/30: the review runs the night the split still shows
	if mode == "split":
		main.act("fighter", fid)
		main.act("ftab", "3")
		await _wait(0.8)
		_scroll_to(main.find_child("WeekBoard", true, false) as Control, -60.0)
		await _wait(3.0)
		await _shot(prefix + "split")
		return
	for i in 14:
		if c.review_pending:
			break
		main.run_to_stop()
	main.act("review")
	var rv: Node = main.modal_node()
	for i in 200:
		await _wait(0.1)
		if rv != null and bool(rv.get("revealed")):
			break
	await _wait(1.0)
	var row := rv.find_child("PadCard_combo_1-1", true, false) as Control if rv != null else null
	if row != null:
		_scroll_to(row, 440.0)   # the title and the stats heading stay whole above the PADS row
		await _wait(0.4)
	await _shot(prefix + "review")


## S382 PLANTRAY1 "plan": her Game plan with a go-to, an R1 opener, an answer to a found tell and a line whose uppercut
## is raw; the southpaw mate booked (the sparring nights' chip).
func _plan(f: Dictionary) -> void:
	f["book"] = [{"name": "jab, jab, step in, lead hook", "chain": ["jab", "jab", "step_in", "lead_hook"], "score": 70}]
	OwnCombos.ensure_ids(f)
	f["moves"]["Lead hook"] = maxf(float(f["moves"]["Lead hook"]), 37.3)
	f["moves"]["Check hook"] = minf(float(f["moves"]["Check hook"]), 8.0)
	f["plan_combo"] = str(OwnCombos.entries(f)[0]["id"])
	f["own_combos"] = {f["plan_combo"]: 22.0}
	f["combos"]["1-1"] = 26.0
	f["arrows"] = [{"move": "1-1"}, {"move": "slip 2-3", "when": "press"}, {"move": "1-6-3@corner"}, {"move": "step_back"}]
	var opp: Dictionary = f["bout"]["opp"]
	opp["stance"] = "southpaw"
	opp["threat"] = "hooks in close"
	opp["file_found"] = ["weapon"]
	f["camp"]["partner"] = true
	f["pad_week"] = {}


## Scrolls the nearest ScrollContainer so n's top sits `above` px under the container's top.
func _scroll_to(n: Control, above: float) -> void:
	if n == null:
		return
	var sc := n.get_parent()
	while sc != null and not sc is ScrollContainer:
		sc = sc.get_parent()
	if sc != null:
		var s := sc as ScrollContainer
		s.scroll_vertical = int(s.scroll_vertical + n.get_global_rect().position.y - s.get_global_rect().position.y - above)


func _wait(s: float) -> void:
	await create_timer(s).timeout


func _settle(frames: int = 6) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(2)
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	vp.get_texture().get_image().save_png(path)
	print("wrote ", path)
