extends SceneTree
## ONELOOK1 (S496, operator: "Everymenu i loook is designed differently ... the colour pallette should be in effect"):
## one still of EVERY page the player sees, on the TEST CLUB (TestJump club4: every menu populated), at one Text size.
## A still is clean: no guide strip, no toast, no open modal (except the modal shots, named *_modal). Each still's mean
## brightness is printed (ONELOOK_LUMA <name> <0-255>) so "darker than others" is a number. Run on the never-shown desktop:
##   python ops/Tools/godot_slot.py run --who onelook1 -- python tools/hidden_desktop.py run --timeout=600 --log=<file> \
##       <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/onelook_stills.gd \
##       -- <out_dir> text=<0-3>
## text: 0 Small, 1 Medium (default), 2 Large, 3 Largest (the operator's own setting).

const TestJump := preload("res://scripts/ui/TestJump.gd")
const TextScale := preload("res://scripts/ui/TextScale.gd")
const Settings := preload("res://scripts/state/Settings.gd")

var main: Node
var out_dir := "user://onelook"
var text_i := 1


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true   # a still shows a screen at rest
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
	await _shot("00_title")
	var ok := TestJump.run(main, "club4")
	var c: Career = main.career
	c.guide = ""
	main.modal = {}
	var pages := [["01_home", "home:0"], ["02_fighters_roster", "fighters:0"], ["03_fighters_find", "fighters:3"],
		["04_fights", "fights:0"], ["05_gym_people", "gym:1"], ["06_gym_records", "gym:4"], ["07_money", "money:0"],
		["08_office", "office:0"], ["09_world_news", "world:0"], ["10_world_rankings", "world:1"],
		["11_world_championships", "world:2"]]
	for page in pages:
		main.act("go", str(page[1]))
		await _shot(str(page[0]))
	var first := ""
	for f in c.fighters:
		var fid := str((f as Dictionary)["id"])
		main.act("fighter", fid)
		if first == "":
			first = fid
			for t in [[0, "overview"], [3, "training"], [4, "history"], [5, "fightprep"]]:
				main.act("ftab", str(t[0]))
				await _shot("20_%s_%s" % [fid, t[1]])
			for p in 4:
				main.act("go", "playbook:%d" % p)
				await _shot("21_%s_playbook_%d" % [fid, p])
		else:
			main.act("ftab", "0")
			await _shot("22_%s_overview" % fid)
			main.act("ftab", "3")
			await _shot("23_%s_training" % fid)
	for g in c.grapplers:
		var gid := str((g as Dictionary).get("id", ""))
		if gid != "":
			main.act("fighter", gid)
			await _shot("24_%s_mat" % gid)
	print("ONELOOK wrote ", out_dir, " ok=", ok, " text=", text_i, " fighters=", c.fighters.size())
	quit(0)


func _shot(name: String, keep_modal: bool = false) -> void:
	if main.career != null and not keep_modal:
		main.modal = {}
	if main.has_method("clear_toast"):
		main.clear_toast()
	main.render()
	await create_timer(0.8).timeout
	var g := main.find_child("FirstWeekStrip", true, false)   # the guide stays off a still (operator S415)
	if g != null:
		(g as CanvasItem).visible = false
	await RenderingServer.frame_post_draw
	var img := root.get_texture().get_image()
	img.save_png(out_dir.path_join(name + ".png"))
	var small := img.duplicate() as Image
	small.resize(96, 54, Image.INTERPOLATE_BILINEAR)
	var sum := 0.0
	for y in 54:
		for x in 96:
			var p := small.get_pixel(x, y)
			sum += 0.2126 * p.r + 0.7152 * p.g + 0.0722 * p.b
	print("ONELOOK_LUMA %s %.1f" % [name, sum / (96.0 * 54.0) * 255.0])
	_census(name)
	if name != "00_title":   # S498: the one-look check beside every still (the title is a picture, not a page)
		var found: Array = load("res://scripts/ui/LookCheck.gd").faults(main)
		print("ONELOOK_CHECK %s faults=%d" % [name, found.size()])
		for f in found.slice(0, 8):
			print("ONELOOK_FAULT %s %s" % [name, f])
	for o in TextScale.overflow(main):
		print("TEXTFIT %s %s \"%s\" needs %.0f has %.0f" % [name, o["name"], o["text"], o["need"], o["have"]])


## What the page is built from: kit pieces by name, hand-made boxes, fonts and sizes, and colours that are not one of the
## palette's 19 (rgb only - a see-through token still counts as the token).
func _census(name: String) -> void:
	var pal: Array = load("res://scripts/ui/Palette.gd").all().values()
	var kinds := {}
	var fonts := {}
	var sizes := {}
	var off := {}
	var hand := 0
	var stack: Array = [main]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is CanvasItem and not (n as CanvasItem).is_visible_in_tree():
			continue
		stack.append_array(n.get_children())
		if not n is Control:
			continue
		var c := n as Control
		if (c is PanelContainer or c is Button) and str(c.theme_type_variation) != "":
			kinds[str(c.theme_type_variation)] = int(kinds.get(str(c.theme_type_variation), 0)) + 1
		for key in ["panel", "normal"]:
			if c.has_theme_stylebox_override(key):
				hand += 1
				var sb := c.get_theme_stylebox(key)
				if sb is StyleBoxFlat:
					_off(off, (sb as StyleBoxFlat).bg_color, pal)
		if c is Label:
			var f := c.get_theme_font("font")
			var fname := str(f.resource_path.get_file()) if f.resource_path != "" else (str((f as FontVariation).base_font.resource_path.get_file()) if f is FontVariation and (f as FontVariation).base_font != null else "variation")
			fonts[fname] = int(fonts.get(fname, 0)) + 1
			var px := c.get_theme_font_size("font_size")
			sizes[px] = int(sizes.get(px, 0)) + 1
			_off(off, c.get_theme_color("font_color"), pal)
	print("ONELOOK_CENSUS %s %s" % [name, JSON.stringify({"kit": kinds, "hand_boxes": hand, "fonts": fonts, "sizes": sizes, "off_palette": off})])


func _off(off: Dictionary, col: Color, pal: Array) -> void:
	if col.a < 0.05:
		return
	for p in pal:
		if absf(p.r - col.r) < 0.012 and absf(p.g - col.g) < 0.012 and absf(p.b - col.b) < 0.012:
			return
	var h := col.to_html(false)
	off[h] = int(off.get(h, 0)) + 1


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
