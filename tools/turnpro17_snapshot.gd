extends "res://tools/layout_snapshot.gd"
## S543 TURNPROBUILD17 step 5: the four turning pro v17 screens as stills (layout_snapshot's frame and _shot: a wireframe
## always, the real picture on the never-shown desktop). 01 the pro offer pop-up, 01b the rival gym's call, 02 the boxer
## card after a Not yet (patience marks, CONFIDENCE and HUNGER), 03 the booking of pro fight 1 (SAFE and RISKY side by
## side), 04 the result page with the bar line. Run:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/turnpro17_snapshot.gd -- docs/playtest/s543_turnpro17 noguide

const Roster := preload("res://scripts/state/Roster.gd")


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(W, H)
	await _settle()
	main.act("newcareer")
	main.act("quick")
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	f["w"] = 9
	f["l"] = 1
	f["offers"] = []
	c.pro_offer = {}
	Roster.check_pro(c)
	main.act("prooffer")
	await _shot("01_pro_offer")
	main.act("declinepro")
	main.clear_toast()
	main.act("fighter", str(f["id"]))
	main.act("ftab", "0")
	await _shot("02_boxer_card")
	c.day += 28
	Roster.check_pro(c)
	main.act("prooffer")
	main.act("declinepro")
	c.day += 28
	Roster.check_pro(c)
	main.act("prooffer")
	await _shot("01b_rival_call")
	main.act("turnpro")
	main.clear_toast()
	main.act("go", "fights:0")
	await _shot("03_booking_pair")
	main.act("propair", "%s:risky" % str(f["id"]))
	main.clear_toast()
	f["bout"]["day"] = c.day
	f["bout"]["weighed"] = true
	f["bout"]["made"] = true
	main.act("fightnight")
	main.act("fightstep", "sim")
	await _settle(10)
	var see := main.find_child("HeadlineGo", true, false) as Button
	if see != null:
		see.emit_signal("pressed")
	await _shot("04_result")
	print("TURNPRO17_SNAPSHOT bar_line=%s" % str(main.modal.get("bar_line", "")))
	quit(0)
