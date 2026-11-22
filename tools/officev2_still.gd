extends SceneTree
## OFFICEV2 (S538): stills of the office's GOALS panel and its Fighters / Staff sheets from the real game, on the TEST CLUB
## (four fighters, so every row is full). Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/officev2_still.gd -- <out_dir>
## Writes office_goals_real.png, office_goals_tip_real.png, office_sheets_real.png, office_sheets_columns_real.png,
## office_sheets_menu_real.png, office_staff_menu_real.png.

const Sim := preload("res://scripts/state/Sim.gd")
const OfficeSheet := preload("res://scripts/ui/OfficeSheet.gd")
const OfficeMenu := preload("res://scripts/ui/OfficeMenu.gd")
const OfficeDesk := preload("res://scripts/ui/OfficeDesk.gd")
const Tips := preload("res://scripts/ui/Tips.gd")

var main: Node
var out_dir := "user://office"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	main.create = {"test_club": "1"}
	main._start_career("Anvil Street Gym", "London")
	await _settle()
	var c: Career = main.career
	var days := 12
	for a in args:
		if str(a).begins_with("days="):
			days = int(str(a).substr(5))
	for i in days:
		Sim.step_day(c)
	main.modal = {}
	main.nav({"area": "office", "tab": 0})
	await _shot("office_goals")
	var want := main.find_child("Want_" + str(c.fighters[0]["id"]), true, false) as Control
	if want != null and want.has_meta(Tips.META_SPEC):
		Tips.pin(want, want.get_meta(Tips.META_SPEC))   # the card the hover opens, pinned for the still
		await _settle(20)
		await _shot("office_goals_tip")
		Tips.close_all()
	(main.find_child("App_fighters", true, false) as Button).pressed.emit()
	await _shot("office_sheets")
	var pick := main.find_child("Columns_fighters", true, false) as Button
	pick.pressed.emit()
	await _shot("office_sheets_columns")
	OfficeMenu.close(main)
	var id := str(c.fighters[0]["id"])
	for f in c.fighters:   # the fighter with an open offer shows the fullest menu
		if not OfficeDesk.RosterRow._open_offer(f).is_empty():
			id = str(f["id"])
	await _menu("Row_fighters_" + id)
	await _shot("office_sheets_menu")
	OfficeMenu.close(main)
	await _menu("Row_staff_physio")
	await _shot("office_staff_menu")
	quit(0)


func _menu(row_name: String) -> void:
	var row := main.find_child(row_name, true, false) as Control
	var ev := InputEventMouseButton.new()
	ev.button_index = MOUSE_BUTTON_RIGHT
	ev.pressed = true
	ev.global_position = row.get_global_rect().position + Vector2(150, 24)
	row.gui_input.emit(ev)
	await _settle()


func _shot(name: String) -> void:
	await _settle()
	if DisplayServer.get_name() == "headless":
		print("headless: no picture for ", name)
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + "_real.png"))
	print("wrote ", out_dir.path_join(name + "_real.png"))


func _settle(n: int = 6) -> void:
	for i in n:
		await process_frame
