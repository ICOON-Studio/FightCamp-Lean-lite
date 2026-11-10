extends SceneTree
## S418 World > Rankings on the wood and slate look. The plaster wall and the tan board are gone: the ladder and the
## side-by-side are framed slates, the key and the title route are see-through, chalk words on the dark surface.
##   Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/world_slate_test.gd

const Roster := preload("res://scripts/state/Roster.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const WR := preload("res://scripts/world/WorldRank.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const SlateWalk := preload("res://tests/slate_walk.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	MenuFx.instant = true
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(4)
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(1920, 1080)
	await _settle(2)
	var f := _ranked()
	if f.is_empty():
		_done()
		return
	FirstWeek.skip(main.career)
	main.act("go", "world:1")
	await _settle(4)
	root.size = Vector2i(1920, 1080)
	var page := _node("RankingsPage") as Control
	_check(page != null, "rankings page")
	if page == null:
		_done()
		return
	await _page(page)
	await _file(page)
	_done()


func _page(page: Control) -> void:
	var rows := page.find_child("LadderRows", true, false)
	_check(rows != null and rows.get_child_count() > 0, "the ladder has its rows")
	var you := _own_row(page)
	_check(you != null, "the player's own row is on the ladder")
	var side := page.find_child("SideBySide", true, false) as PanelContainer
	_check(side != null, "the side-by-side panel is on the page")
	_plate(page.find_child("Rankings_wlw", true, false) as PanelContainer, "ladder")
	_plate(side, "side by side")
	if you != null:
		var box := you.get_theme_stylebox("panel") as StyleBoxFlat
		var fill := box.bg_color.a if box != null else -1.0
		var edge := box.border_color.to_html(false) if box != null else "?"
		var w := 0 if box == null else box.get_border_width(SIDE_LEFT)
		print("WORLD_SLATE own row fill a=%.2f edge=%s width=%d" % [fill, edge, w])
		_check(box != null and fill < 0.1, "the player's row is not a pale fill (a=%.2f)" % fill)
		_check(box != null and w == 2 and box.border_color.is_equal_approx(WoodKit.HEAD), "the player's row is a gold outline (%s, %d px)" % [edge, w])
	_see_through(page.find_child("Key", true, false) as PanelContainer, "key")
	_see_through(page.find_child("TitleRoute", true, false) as PanelContainer, "title route")
	WoodKit.ink(page)
	await _settle(3)
	for fault in SlateWalk.faults(page):
		_check(false, str(fault))
	var rect := page.get_global_rect()
	print("WORLD_SLATE the rankings page ends at x %.0f (line 1920), y %.0f (line 1080)" % [rect.end.x, rect.end.y])
	_check(rect.end.x <= 1920.0, "the rankings page stays inside x 1920 (ends at %.0f)" % rect.end.x)
	_check(rect.end.y <= 1080.0, "the rankings page stays inside y 1080 (ends at %.0f)" % rect.end.y)


func _file(page: Control) -> void:
	var box := page.find_child("RegionFiles", true, false)
	var file := null if box == null else box.find_child("File_*", true, false) as Button
	_check(file != null, "a rival's file is a link on the page")
	if file == null:
		return
	file.pressed.emit()
	await _settle(3)
	var pop := main.modal_node() as Control
	_check(pop != null and str(main.modal.get("type", "")) == "info", "the rival's file opens")
	if pop == null:
		return
	root.size = Vector2i(1920, 1080)
	WoodKit.ink(pop)
	await _settle(3)
	for fault in SlateWalk.faults(pop):
		_check(false, "file: " + str(fault))
	var rect := pop.get_global_rect()
	print("WORLD_SLATE the file pop-up ends at x %.0f (line 1920), y %.0f (line 1080)" % [rect.end.x, rect.end.y])
	_check(rect.end.x <= 1920.0, "the file pop-up stays inside x 1920 (ends at %.0f)" % rect.end.x)
	_check(rect.end.y <= 1080.0, "the file pop-up stays inside y 1080 (ends at %.0f)" % rect.end.y)


func _own_row(page: Control) -> PanelContainer:
	for n in page.find_children("LadderRow_*", "PanelContainer", true, false):
		if bool(n.get_meta("mine", false)) and (n as Control).is_visible_in_tree():
			return n
	return null


func _plate(panel: PanelContainer, what: String) -> void:
	if panel == null:
		_check(false, "%s is a framed slate" % what)
		return
	var sb := panel.get_theme_stylebox("panel") as StyleBoxTexture
	var path := "" if sb == null or sb.texture == null else str(sb.texture.resource_path)
	print("WORLD_SLATE %s plate %s" % [what, path])
	_check(path.ends_with("wood/panel.png"), "%s is a framed slate (%s)" % [what, path])


func _see_through(panel: PanelContainer, what: String) -> void:
	if panel == null:
		_check(false, "the %s is see-through" % what)
		return
	var sb := panel.get_theme_stylebox("panel") as StyleBoxFlat
	var fill := sb.bg_color.a if sb != null else -1.0
	print("WORLD_SLATE %s fill a=%.2f" % [what, fill])
	_check(sb != null and fill < 0.5, "the %s is see-through (a=%.2f)" % [what, fill])


## A ranked pro, as menu_world_test opens the page: nine wins, on the lightweight ladder.
func _ranked() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	f["w"] = 9
	f["l"] = 1
	Roster.check_pro(c)
	Roster.turn_pro(c)
	ProLadder.join(c, f)
	f["bout"] = {}
	f["booked_fight"] = false
	var e := ProLadder.entry(c, f)
	var twelfth := {}
	for b in ProLadder.table(c, f):
		if int(b.get("rank", 0)) == 12 and not bool(b.get("player", false)):
			twelfth = b
	_check(not e.is_empty() and not twelfth.is_empty(), "a real pro table")
	if e.is_empty() or twelfth.is_empty():
		return {}
	WR.apply_result_in(e, twelfth, ProLadder.table(c, f))
	_check(int(e.get("rank", 0)) > 0, "the fighter is ranked")
	return f


func _node(name: String) -> Node:
	return null if main._shell == null else main._shell.find_child(name, true, false)


func _settle(frames: int) -> void:
	for _i in frames:
		await process_frame


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _done() -> void:
	print("WORLD_SLATE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
