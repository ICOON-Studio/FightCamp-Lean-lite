extends SceneTree
## Headless layout check (nothing opens on screen): plays to a few moments and draws each one as a wireframe PNG - panels
## and buttons as their colours, text as bars the width of the real shaped text. Also prints any control that runs off
## the 1920x1080 frame. Usage:
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tools/layout_snapshot.gd -- <out_dir>
## Real pictures (<name>_real.png), rendered on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/layout_snapshot.gd -- <out_dir>

const W := 1920
const H := 1080

const Bouts := preload("res://scripts/state/Bouts.gd")
const Needs := preload("res://scripts/state/Needs.gd")

var main: Node
var out_dir := "user://layout"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	# Headless has no real window: pin the game to a 1920x1080 frame.
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(W, H)
	await _settle()
	await _shot("01_title")
	main.act("newcareer")
	await _shot("02_create")
	main.act("quick")
	await _shot("03_home_start")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	await _shot("04_interview")
	main.act("sign")
	main.act("go", "gym:1")
	await _shot("05_gym_staff")
	main.act("hire", "reid")
	main.act("go", "fighters:1")
	await _shot("06_training")
	main.run_to_stop()
	main.act("area", "home")
	await _shot("07_home_week1")
	main.act("review")
	await _settle(80)
	await _shot("08_review")
	main.act("close")
	main.act("fighter", "lucy")
	await _shot("09_fighter")
	# Week 2: offer -> bout page -> camp -> weigh-in -> fight night -> result -> office.
	var c: Career = main.career
	_run_until(func(): return not (c.fighter()["offers"] as Array).is_empty())
	main.act("go", "fights:0")
	await _shot("10_offers")
	main.act("openBout", "lucy:m8")
	await _shot("11_bout_unsafe")
	main.act("openBout", "lucy:o8")
	await _shot("12_bout")
	main.act("accept", "lucy:o8")
	await _shot("13_home_booked")
	main.act("camp", "lucy")
	await _shot("14_camp")
	main.act("startcamp")
	main.act("go", "fighters:2")
	await _shot("15_fight_camps")
	_run_until(func(): return Bouts.weigh_in_today(c, c.fighter()))
	main.act("weighin", "lucy")
	await _shot("16_weighin")
	main.act("doWeigh")
	main.run_to_stop()
	main.act("area", "home")
	await _shot("17_home_fightnight")
	main.act("go_btn")
	await _shot("18_tape")
	main.act("fightstep", "start")
	await _shot("19_round1")
	# S303: the corner screens between rounds (energy at the bell + Kalli's corner line).
	main.act("fightwatched", "1")
	await _shot("19b_corner1")
	main.act("fightstep", "corner:body")
	main.act("fightwatched", "2")
	await _shot("19c_corner2")
	main.act("fightstep", "corner:long")
	await _shot("20_round3")
	main.act("fightstep", "end")
	await _shot("21_result")
	main.act("afterfight")
	main.act("goaltalk", "lucy")
	main.act("pickgoal", "five_round_engine")
	await _shot("22_goaltalk")
	main.act("setgoal")
	main.act("fighter", "lucy")
	main.act("ftab", "3")
	await _shot("23_record")
	main.act("ftab", "0")
	await _shot("23b_coach_notes")
	main.act("ftab", "1")
	await _shot("23c_combos")
	main.act("go", "fighters:1")
	await _shot("23d_training_combo")
	# S351 the Miro loop board (operator: "menus/submenus/modals/tooltips"): two tooltips on the training board, the
	# Playbook's four tabs, the top bar's Mail and Gear menu.
	if await _hover("Load_lucy"):
		await _shot("23e_tip_load")
	if await _hover("More_heavy_bag_lucy"):
		await _shot("23f_tip_more_time")
	for i in 4:
		main.act("go", "playbook:%d" % i)
		await _shot("23%s_playbook_%s" % [["g", "h", "i", "j"][i], ["moves", "plans", "combos", "escapes"][i]])
	main.act("mail", "")
	await _shot("23k_mail")
	main.act("close")
	var gear := main.find_child("Gear", true, false) as Button
	if gear != null:
		gear.pressed.emit()
		await _shot("23l_gear_menu")
		var esc := InputEventKey.new()
		esc.keycode = KEY_ESCAPE
		esc.pressed = true
		root.push_input(esc)
		await _settle()
	# Week 3: MONEY, GYM, WORLD live; save and the title's Resume.
	main.act("go", "money:3")
	main.act("deal", "ironclad")
	await _shot("24_deals")
	main.act("go", "gym:3")
	await _shot("25_facilities")
	main.act("repair", "bags")
	_run_until(func(): return c.day >= 40)
	main.act("go", "money:0")
	await _shot("26_money")
	main.act("go", "money:2")
	await _shot("27_bills")
	main.act("go", "gym:2")
	await _shot("28_members")
	main.act("go", "world:0")
	await _shot("29_news")
	main.act("go", "world:1")
	await _shot("30_rankings")
	# S341 a rival's file from the rankings (the opponent Lucy fought: her file open, the bout under WITH US).
	main.act("rivalfile", str(c.results[0]["opp"]) if not c.results.is_empty() else "Maria Ortega")
	await _shot("30b_rival_file")
	main.act("close")
	main.act("go", "world:2")
	await _shot("31_events")
	main.act("go", "world:3")
	var box: LineEdit = main._shell.find_child("SearchBox", true, false)
	box.text = "ri"
	box.text_changed.emit("ri")
	await _shot("32_search")
	main.save_path = "user://layout_snapshot.save"
	main.act("save")
	main.act("title")
	await _shot("33_title_resume")
	main.act("load")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(main.save_path))
	# Week 4: scouting, a trial, two fighters, moves, the week review for both, a pro offer.
	c = main.career
	main.act("go", "fighters:3")
	await _shot("34_scouting")
	main.act("invite", "kira")
	_run_until(func(): return not Needs.blockers(c).is_empty() and str(Needs.blockers(c)[0]["act"]) == "trial")
	main.act("trial", "kira")
	for card in ["Jab and move", "Body work", "Pad rounds"]:
		main.act("trialcard", card)
	await _shot("35_trial")
	main.act("signprospect")
	main.act("go", "fighters:0")
	await _shot("36_roster")
	main.act("go", "fighters:1")
	await _shot("37_training")
	main.act("fighter", "kira")
	main.act("ftab", "1")
	await _shot("38_moves")
	var weeks := c.cash_history.size()
	_run_until(func(): return c.cash_history.size() >= weeks + 2, false)
	main.act("area", "home")
	main.act("review")
	await _settle(80)
	await _shot("39_review_two")
	main.act("close")
	c.fighter()["w"] = 9
	_run_until(func(): return not c.pro_offer.is_empty())
	main.act("prooffer")
	await _shot("40_prooffer")
	main.act("turnpro")
	main.act("area", "home")
	await _shot("41_home_two")
	quit(0)


## Runs CONTINUE like a steady player until until() is true: reviews closed (when close_reviews), offers declined, office talks settled, weigh-ins stepped, fight nights simmed.
func _run_until(until: Callable, close_reviews: bool = true) -> void:
	var c: Career = main.career
	for i in 40:
		if until.call():
			return
		for f in c.fighters:
			for o in f["offers"]:
				if not bool(o["answered"]) and not bool(o["mismatch"]):
					main.act("declineOffer", str(o["id"]))
			if Bouts.weigh_in_today(c, f):
				main.act("weighin", f["id"])
				main.act("doWeigh")
			if Bouts.fight_day(c, f):
				main.act("fightnight")
				main.act("fightstep", "sim")
				main.act("afterfight")
			if bool(f["goal_talk"]):
				main.act("goaltalk", f["id"])
				main.act("pickgoal", "five_round_engine")
				main.act("setgoal")
		if until.call():
			return
		if c.review_pending and close_reviews:
			main.act("review")
			main.act("close")
		main.run_to_stop()


## The mouse rests on a control long enough for its tooltip (a real window only; false when it is missing or headless).
func _hover(name: String) -> bool:
	var n := main.find_child(name, true, false) as Control
	if n == null or DisplayServer.get_name() == "headless":
		print("HOVER skipped ", name)
		return false
	var ev := InputEventMouseMotion.new()
	ev.position = n.get_global_rect().get_center()
	ev.global_position = ev.position
	root.push_input(ev, true)   # viewport coords (the hidden desktop maximises the window: window coords are scaled)
	await _settle(60)
	print("HOVER %s -> %s" % [name, root.gui_get_hovered_control()])
	return true


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle()
	if DisplayServer.get_name() != "headless":
		# A real window (on the hidden desktop): save the true picture too.
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
		print("wrote ", out_dir.path_join(name + "_real.png"))
	var img := Image.create(W, H, false, Image.FORMAT_RGBA8)
	img.fill(Color("#1d1714"))
	_draw_tree(img, main)
	img.save_png(out_dir.path_join(name + ".png"))
	print("wrote ", out_dir.path_join(name + ".png"))


func _draw_tree(img: Image, node: Node) -> void:
	if node is CanvasItem and not (node as CanvasItem).is_visible_in_tree():
		return
	if node is Control:
		_draw_control(img, node)
	for child in node.get_children():
		_draw_tree(img, child)


func _draw_control(img: Image, c: Control) -> void:
	var r := Rect2i(c.get_global_rect())
	if r.size.x <= 0 or r.size.y <= 0:
		return
	if r.end.x > W + 1 or r.end.y > H + 1 and not _in_scroll(c):
		print("  OFF FRAME: %s %s" % [c.get_path(), r])
	var a := c.modulate.a
	if c is ColorRect:
		_fill(img, r, (c as ColorRect).color, a)
	elif c.get_script() != null and c.get("frac") is float and c.get("track") != null:   # S342: AttrRadar has a static frac()
		_fill(img, r, c.get("track"), a)
		_fill(img, Rect2i(r.position, Vector2i(int(r.size.x * float(c.get("frac"))), r.size.y)), c.get("fill"), a)
	elif c is PanelContainer:
		_style(img, r, c.get_theme_stylebox("panel"), a)
	elif c is Button:
		var b := c as Button
		_style(img, r, b.get_theme_stylebox("disabled" if b.disabled else "normal"), a)
		if b.text != "":
			_text(img, r, b.text, b.get_theme_font("font"), b.get_theme_font_size("font_size"),
				b.get_theme_color("font_disabled_color" if b.disabled else "font_color"), b.alignment, a)
	elif c is LineEdit:
		_style(img, r, c.get_theme_stylebox("normal"), a)
	elif c is Label:
		var l := c as Label
		var lines := maxi(1, l.get_line_count())
		var lh := l.get_line_height()
		for i in lines:
			var line_r := Rect2i(r.position + Vector2i(0, i * lh), Vector2i(r.size.x, lh))
			if lines == 1:
				_text(img, line_r, l.text, l.get_theme_font("font"), l.get_theme_font_size("font_size"),
					l.get_theme_color("font_color"), l.horizontal_alignment, a)
			else:
				var h := maxi(2, int(l.get_theme_font_size("font_size") * 0.55))
				var wl := r.size.x if i < lines - 1 else r.size.x / 3
				_fill(img, Rect2i(r.position.x, line_r.position.y + (lh - h) / 2, wl, h), l.get_theme_color("font_color"), a * 0.85)


func _in_scroll(c: Control) -> bool:
	var p := c.get_parent()
	while p != null:
		if p is ScrollContainer:
			return true
		p = p.get_parent()
	return false


func _style(img: Image, r: Rect2i, sb: StyleBox, a: float) -> void:
	if sb is StyleBoxFlat:
		var f := sb as StyleBoxFlat
		if f.border_width_left + f.border_width_top > 0 and f.border_color.a > 0.0:
			_fill(img, r, f.border_color, a)
			_fill(img, r.grow(-maxi(1, f.border_width_left)), f.bg_color if f.bg_color.a > 0.0 else Color("#1d1714"), a)
		elif f.border_width_bottom > 0:
			_fill(img, r, f.bg_color, a)
			_fill(img, Rect2i(r.position.x, r.end.y - 1, r.size.x, 1), f.border_color, a)
		elif f.border_width_right > 0:
			_fill(img, r, f.bg_color, a)
			_fill(img, Rect2i(r.end.x - 1, r.position.y, 1, r.size.y), f.border_color, a)
		else:
			_fill(img, r, f.bg_color, a)


func _text(img: Image, r: Rect2i, text: String, font: Font, size: int, colour: Color, align: int, a: float) -> void:
	var w := int(font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x)
	var x := r.position.x
	if align == HORIZONTAL_ALIGNMENT_CENTER:
		x += (r.size.x - w) / 2
	elif align == HORIZONTAL_ALIGNMENT_RIGHT:
		x = r.end.x - w
	if w > r.size.x + 2:
		print("  TEXT CLIPPED: '%s' needs %d px, has %d" % [text.left(40), w, r.size.x])
	var h := maxi(2, int(size * 0.55))
	_fill(img, Rect2i(x, r.position.y + (r.size.y - h) / 2, mini(w, r.size.x), h), colour, a * 0.85)


func _fill(img: Image, r: Rect2i, colour: Color, a: float) -> void:
	if colour.a <= 0.0:
		return
	var clip := r.intersection(Rect2i(0, 0, W, H))
	if clip.size.x <= 0 or clip.size.y <= 0:
		return
	var col := Color(colour, colour.a * a)
	if col.a >= 0.99:
		img.fill_rect(clip, col)
		return
	for y in range(clip.position.y, clip.end.y):
		for x in range(clip.position.x, clip.end.x):
			img.set_pixel(x, y, img.get_pixel(x, y).blend(col))
