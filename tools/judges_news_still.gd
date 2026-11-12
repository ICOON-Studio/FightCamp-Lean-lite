extends SceneTree
## S443 stills for R29 THE JUDGES and R85 WORLD NEWS, from the game's own flow:
##   world_news.png         a pro career (TestJump proladder), three pro year ends (ProLadder.year_end), World > News
##   world_rankings.png     World > Rankings: the "new face" mark on the table
##   result_judges.png      quick start -> first bout -> watch round 1 -> SKIP BOUT -> the result page (cards from the judges)
##   judge_cards.png        the JudgeCards component (for the result page's tab) on the same bout, laid over the page
## Run on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/judges_news_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const JudgeCards := preload("res://scripts/ui/JudgeCards.gd")
const TV := preload("res://scripts/ui/TV.gd")

var main: Node
var out_dir := "user://judges_news"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	await _news()
	await _judges()
	quit(0)


func _fresh() -> void:
	if main != null:
		main.queue_free()
		await _settle(2)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(6)


func _news() -> void:
	await _fresh()
	print("STILL jump proladder: %s" % TestJump.run(main, "proladder"))
	var c: Career = main.career
	for y in 3:
		c.day += ProLadder.YEAR_DAYS
		var res := ProLadder.year_end(c)
		print("STILL year %d: retired %d, crowned %d, arrived %d" % [y + 1, (res["retired"] as Array).size(), (res["crowned"] as Array).size(), (res["arrived"] as Array).size()])
	if not main.modal.is_empty():
		main.act("close")
	main.clear_toast()
	main.act("go", "world:0")
	await _save("world_news")
	main.act("go", "world:1")
	await _save("world_rankings")
	var marked := 0
	for d in c.world["divisions"]:
		for b in c.world["divisions"][d]["boxers"]:
			marked += int(bool(b.get("new_face", false)))
	print("STILL new faces marked: %d" % marked)


func _judges() -> void:
	await _fresh()
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
	var j: Dictionary = m.get("judges", {})
	print("STILL result step=%s outcome=%s cards=%s verdict=%s leans=%s" % [m.get("step", ""), m.get("outcome", ""), str(m.get("cards", [])),
		j.get("verdict", "-"), str(j.get("leans", []))])
	for r in j.get("reasons", []):
		print("STILL card reason: %s" % r)
	await _save("result_judges")
	var f: Dictionary = c0.fighter_by_id(str(m["fid"]))
	var names := [str(f.get("first", "")), str(f["bout"].get("opp", {}).get("first", "")) if f.has("bout") else ""]
	if str(names[1]) == "":
		names[1] = str(m.get("opp_name", "the opponent"))
	var layer := CanvasLayer.new()
	layer.layer = 50
	var back := PanelContainer.new()
	back.add_theme_stylebox_override("panel", TV.box(TV.BG, TV.LINE, 8, 2, 24, 20))
	back.position = Vector2(260, 300)
	back.custom_minimum_size = Vector2(1400, 0)
	back.add_child(JudgeCards.build(m, names))
	layer.add_child(back)
	root.add_child(layer)
	await _save("judge_cards")


func _save(name: String) -> void:
	if main.has_method("render"):
		main.render()
	await _settle(30)
	if DisplayServer.get_name() == "headless":
		print("STILL headless: no picture for ", name)
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	print("STILL wrote ", out_dir.path_join(name + ".png"))


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
