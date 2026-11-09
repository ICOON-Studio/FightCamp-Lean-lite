extends SceneTree
## S411 (operator Q-S294-135: "fewer words and bigger pictures, like Fighters") that sentence as numbers, so a seat that cannot see
## images can be held to it. read(root) walks what is really on the screen:
##   words   = words in visible Labels, Buttons and rich text (tooltips do not count; scrolled-off rows do not count)
##   pic_pct = the share of the screen covered by people and move pictures (the painted wall and paper do not count)
##   tallest = the tallest person on the page, px
##   <godot.exe> --headless --path . --audio-driver Dummy --fixed-fps 30 --script res://tools/page_ink.gd
## Headless, because it reads the layout, not the pixels. With -- <out_dir>, on the hidden desktop, it also saves a still per page.

const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const SCREEN := Rect2(0, 0, 1920, 1080)
const PERSON := ["/fullbody/", "/face/"]


static func read(root_node: Node) -> Dictionary:
	var out := {"words": 0, "area": 0.0, "tallest": 0.0}
	_walk(root_node, SCREEN, out)
	return {
		"words": int(out["words"]),
		"pic_pct": 100.0 * float(out["area"]) / (SCREEN.size.x * SCREEN.size.y),
		"tallest": float(out["tallest"]),
	}


static func _walk(n: Node, clip: Rect2, out: Dictionary) -> void:
	var here := clip
	if n is CanvasItem and not (n as CanvasItem).is_visible_in_tree():
		return
	if n is Control:
		var c := n as Control
		var rect := c.get_global_rect()
		if c is ScrollContainer or c.clip_contents:
			here = clip.intersection(rect)
		var seen := here.intersection(rect)
		if seen.size.x > 1.0 and seen.size.y > 1.0:
			_count(c, seen, out)
	for k in n.get_children():
		_walk(k, here, out)


static func _count(c: Control, seen: Rect2, out: Dictionary) -> void:
	if c is Label:
		out["words"] = int(out["words"]) + _words((c as Label).text)
	elif c is RichTextLabel:
		out["words"] = int(out["words"]) + _words((c as RichTextLabel).get_parsed_text())
	elif c is Button:
		out["words"] = int(out["words"]) + _words((c as Button).text)
	elif c is SubViewportContainer:
		out["area"] = float(out["area"]) + seen.get_area()
	elif c is TextureRect and (c as TextureRect).texture != null:
		var path := (c as TextureRect).texture.resource_path
		for mark in PERSON:
			if path.contains(mark):
				out["area"] = float(out["area"]) + seen.get_area()
				out["tallest"] = maxf(float(out["tallest"]), seen.size.y)
				return
		if path.contains("/moves/"):
			out["area"] = float(out["area"]) + seen.get_area()


static func _words(s: String) -> int:
	var n := 0
	for w in s.split(" ", false):
		for line in w.split("\n", false):
			if RegEx.create_from_string("[A-Za-z]").search(line) != null:
				n += 1
	return n


var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	c.guide = ""
	main.act("go", "fighters:0")
	await _show("fighters, two boxers")
	var base: Dictionary = c.fighters[0]
	for i in 6:
		var f: Dictionary = base.duplicate(true)
		f["id"] = "extra_%d" % i
		f["bout"] = {}
		f["camp"] = {}
		f["offers"] = []
		c.fighters.append(f)
	main.act("go", "fighters:0")
	await _show("fighters, eight boxers")
	var opp: Dictionary = (load("res://scripts/state/Data.gd").OPPONENTS[0] as Dictionary).duplicate(true)
	base["offers"].append(load("res://scripts/state/Bouts.gd")._offer("lucy:ink", opp, c.day + 30, c.day + 6, 4))
	main.act("openBout", "lucy:ink")
	await _show("versus")
	main.act("close")
	main.act("area", "home")
	await _show("home")
	main.act("fighter", "lucy")
	main.act("ftab", "3")
	await _show("fighter week")
	main.act("ftab", "7")
	await _show("playbook")
	print("PAGE_INK done")
	quit(0)


func _show(page: String) -> void:
	for i in 6:
		await process_frame
	var r := read(root)
	print("PAGE_INK %-24s words=%4d pictures=%5.1f%% tallest=%4.0f px" % [page, r["words"], r["pic_pct"], r["tallest"]])
	if not OS.get_cmdline_user_args().is_empty():
		var out: String = OS.get_cmdline_user_args()[0]
		DirAccess.make_dir_recursive_absolute(out)
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(out.path_join(page.replace(" ", "_").replace(",", "") + ".png"))
