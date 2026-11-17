extends SceneTree
## S443 RESULTTABS: one still per tab of the fight result (summary, the exchanges, the numbers, the plan) from the page's
## sample bout (tools/result_dump.gd seed 44, Lucy v Priya), on the real Main scene. Prints each tab's overflow: any label
## whose text is cut (wider or taller than its box) or any panel past the 1920x1080 window.
## Run on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/result_tabs_still.gd -- <out_dir>

const Dump := preload("res://tools/result_dump.gd")

var main: Node
var out_dir := "user://result_tabs"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	for a in args:   # S504: `text=<0-3>` shoots the tabs at that Text size (the operator plays at Largest, 3)
		if str(a).begins_with("text="):
			load("res://scripts/ui/TextScale.gd").use(self, float(load("res://scripts/state/Settings.gd").TEXT_SIZES[int(str(a).substr(5))][1]))
		else:
			out_dir = str(a)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	var cf := Dump._setup(44)
	var m := Dump._fight(cf[0], cf[1], Dump.PLAN, true)
	m["night_seen"] = true
	main.resume(cf[0])
	await _settle()
	main.open_modal(m)
	for tab in ["summary", "scorecard", "exchanges", "numbers", "plan"]:
		m["result_tab"] = tab
		main.redraw_modal()
		await _settle(30)
		_check(tab)
		await _save("result_" + tab)
		if tab == "scorecard":   # S504 Q-265: the hover on judge 3's round 1 score (the mockup's card)
			await _hover("Score3_1_a")
			await _save("result_scorecard_hover")
			await _hover("")
	quit(0)


## Cut text and overflow: every visible label whose text needs more room than it has, and the modal's bottom edge.
func _check(tab: String) -> void:
	var node: Node = main.modal_node()
	var cut: PackedStringArray = []
	for l in node.find_children("*", "Label", true, false):
		var lb := l as Label
		if not lb.is_visible_in_tree() or lb.text == "":
			continue
		if lb.autowrap_mode == TextServer.AUTOWRAP_OFF and lb.get_minimum_size().x > lb.size.x + 1.0:
			cut.append("'%s' %d>%d" % [lb.text.left(40), int(lb.get_minimum_size().x), int(lb.size.x)])
		var r := lb.get_global_rect()
		if r.end.y > 1080.0 or r.end.x > 1920.0 or r.position.x < 0.0 or r.position.y < 0.0:
			cut.append("off-screen '%s' %s" % [lb.text.left(40), str(r)])
	var panel := node as Control
	print("RESULT_STILL %s modal %s cut=%d" % [tab, str(panel.get_global_rect()) if panel else "?", cut.size()])
	for s in cut.slice(0, 12):
		print("  CUT ", s)


func _save(name: String) -> void:
	await _settle(10)
	if DisplayServer.get_name() == "headless":
		print("RESULT_STILL headless: no picture for ", name)
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	print("wrote ", out_dir.path_join(name + ".png"))


## The mouse over a named control (its centre) and the tooltip's delay waited out; "" moves it away.
func _hover(name: String) -> void:
	var at := Vector2(5, 5)
	if name != "":
		var c: Control = main.modal_node().find_child(name, true, false)
		if c == null:
			print("RESULT_STILL no ", name)
			return
		at = c.get_global_rect().get_center()
	var ev := InputEventMouseMotion.new()
	ev.position = at
	ev.global_position = at
	root.push_input(ev)
	await create_timer(1.2).timeout
	await _settle(6)


func _settle(n: int = 6) -> void:
	for i in n:
		await process_frame
