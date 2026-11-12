extends SceneTree
## S439 DAMAGESHOW1: the result page with the bout's marks, from the game's own flow (quick start -> sign -> the first
## bout -> watch round 1 -> SKIP BOUT -> result). Two stills:
##   result_real.png    the bout as it was boxed (the map the game built)
##   result_staged.png  the SAME page with a heavier map set by hand (a cut left eye, a sore nose, a badly hurt liver),
##                      so every mark can be judged; its DAMAGE tile is rebuilt from that map by the game's own rule.
## Run on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/damage_result_still.gd -- <out_dir>

const AfterFight := preload("res://scripts/state/AfterFight.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BodyMap := preload("res://scripts/rules/BodyMap.gd")

var main: Node
var out_dir := "user://damage_result"


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
	main.act("newcareer")
	main.act("quick")
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("go", "gym:1")
	main.act("hire", "reid")
	await process_frame
	main.act("go", "fighters:1")
	main.on_go()
	main.on_go()
	main.run_to_stop()
	main.act("area", "home")
	var c0: Career = main.career
	_run_until(func(): return not (c0.fighter()["offers"] as Array).is_empty())
	var safe := ""
	for o in c0.fighter()["offers"]:
		if not bool(o.get("mismatch", false)) and safe == "":
			safe = str(o["id"])
	main.act("openBout", safe)
	main.act("accept", safe)
	main.act("close")
	main.act("camp", "lucy")
	main.act("startcamp")
	_run_until(func(): return Bouts.weigh_in_today(c0, c0.fighter()))
	main.act("weighin", "lucy")
	main.act("doWeigh")
	main.run_to_stop()
	main.act("area", "home")
	main.clear_toast()
	main.act("go_btn")
	await _settle(20)
	main.act("fightstep", "start")
	await _settle(30)
	main.act("fightstep", "round_out")
	main.act("fightwatched", "1")
	main.act("fightskip", "")
	await _settle(40)
	var m: Dictionary = main.modal
	print("DAMAGE_STILL step=%s rounds=%d bells=%d" % [m.get("step", ""), (m.get("rounds", []) as Array).size(), int(m.get("body_bells", 0))])
	_report(m)
	await _save("result_real")
	# The staged map: the same page, heavier marks.
	var map := BodyMap.fresh()
	map["a"]["places"] = {"head": 58.0, "left_eye": 31.0, "right_eye": 52.0, "nose": 44.0, "left_ribs": 71.0, "right_ribs": 33.0}
	map["a"]["cuts"] = {"left_eye": true}
	map["b"]["places"] = {"head": 74.0, "left_eye": 88.0, "right_eye": 80.0, "nose": 49.0, "left_ribs": 90.0, "right_ribs": 62.0}
	m["body_map"] = map
	m["body_bells"] = (m["rounds"] as Array).size()
	var c: Career = main.career
	var f2: Dictionary = c.fighter_by_id(str(m["fid"]))
	var tiles: Array = m["aftermath"]
	var fresh: Array = AfterFight.tiles(c, f2, m, {"morale": 60.0, "mood": "Steady", "rank": 0, "cap": 99.0, "notes": [], "rows": [], "hidden": 0}, {})
	tiles[0] = fresh[0]
	main.redraw_modal()
	await _settle(40)
	_report(m)
	await _save("result_staged")
	quit(0)


func _report(m: Dictionary) -> void:
	var map: Dictionary = m.get("body_map", {})
	var row: PackedStringArray = []
	for p in BodyMap.PLACES:
		row.append("%s %.0f" % [p, BodyMap.value(map, "a", p)])
	var t: Dictionary = (m["aftermath"] as Array)[0]
	print("DAMAGE_STILL hers: %s | tile '%s' / '%s'" % [", ".join(row), t["big"], t["small"]])
	var co := main.find_child("BodyCallouts", true, false)
	print("DAMAGE_STILL callouts on the page: ", co != null)


func _save(name: String) -> void:
	await _settle(20)
	if DisplayServer.get_name() == "headless":
		print("DAMAGE_STILL headless: no picture for ", name)
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	print("wrote ", out_dir.path_join(name + ".png"))


func _settle(n: int = 6) -> void:
	for i in n:
		await process_frame


func _run_until(until: Callable) -> void:
	var c: Career = main.career
	for i in 40:
		if until.call():
			return
		for f in c.fighters:
			for o in f["offers"]:
				if not bool(o["answered"]) and not bool(o["mismatch"]):
					main.act("declineOffer", str(o["id"]))
			if bool(f["goal_talk"]):
				main.act("goaltalk", f["id"])
				main.act("pickgoal", "five_round_engine")
				main.act("setgoal")
		if until.call():
			return
		if c.review_pending:
			main.act("review")
			main.act("close")
		main.run_to_stop()
