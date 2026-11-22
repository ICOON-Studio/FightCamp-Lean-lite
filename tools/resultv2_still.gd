extends SceneTree
## S538 RESULTV2: the result page v2 on the real Main scene, one summary still per kind of night - a win, a loss on
## points, a stoppage - found among tools/result_dump.gd's bouts (seeds from 40 up), plus the loss with the bars' tooltip
## open and with the modal THE WHOLE READ open. No sample night ends early, so the stoppage is the same pair with the
## boxer's chin, defence and conditioning halved (a still of the page, not of the balance). Prints cut text and anything past the 1920x1080 window.
## Run on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/resultv2_still.gd -- <out_dir>

const Dump := preload("res://tools/result_dump.gd")
const Tips := preload("res://scripts/ui/Tips.gd")

var main: Node
var out_dir := "user://resultv2"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	for a in OS.get_cmdline_user_args():
		out_dir = str(a)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	var found := {}
	for sd in range(40, 240):
		var cf := Dump._setup(sd)
		var m := Dump._fight(cf[0], cf[1], Dump.PLAN, true)
		var kind := "stoppage" if str(m.get("stopped", "")) != "" else ("win" if bool(m["win"]) else ("loss" if str(m.get("outcome", "loss")) == "loss" else ""))
		if kind != "" and not found.has(kind):
			found[kind] = [sd, cf[0], m]
		if found.size() == 3 or (sd >= 99 and found.size() == 2):
			break
	if not found.has("stoppage"):   # this pair never ends early: the same nights with the boxer's chin and defence halved
		for sd in range(40, 140):
			var cf2 := Dump._setup(sd)
			for k in ["chin", "defense", "conditioning"]:
				cf2[1]["stats"][k] = float(cf2[1]["stats"][k]) * 0.5
			var m2 := Dump._fight(cf2[0], cf2[1], Dump.PLAN, true)
			if str(m2.get("stopped", "")) != "":
				found["stoppage"] = [sd, cf2[0], m2]
				print("RESULTV2_STILL stoppage: from a weakened boxer (chin, defence, conditioning halved)")
				break
	for kind in ["win", "loss", "stoppage"]:
		if not found.has(kind):
			print("RESULTV2_STILL no %s among seeds 40-239" % kind)
			continue
		var m: Dictionary = found[kind][2]
		print("RESULTV2_STILL %s: seed %d outcome %s stopped '%s' cards %s" % [kind, int(found[kind][0]), str(m.get("outcome", "")), str(m.get("stopped", "")), str(m.get("cards", []))])
		m["night_seen"] = true
		main.resume(found[kind][1])
		await _settle()
		main.open_modal(m)
		await _settle(30)
		_check(kind)
		await _save("result_v2_" + kind)
		if kind == "loss":
			var bars: Control = main.modal_node().find_child("FixLadder", true, false)
			if bars != null and bars.has_meta(Tips.META_SPEC):   # the bars' card, pinned open as a hover shows it
				Tips.pin(bars, bars.get_meta(Tips.META_SPEC))
				await _save("result_v2_loss_tooltip")
				Tips.close_all()
			var more: Button = main.modal_node().find_child("WholeRead", true, false)
			if more != null:
				more.emit_signal("pressed")
				await _save("result_v2_loss_modal")
				var read := main.find_child("ResultRead", false, false)
				if read != null:
					read.call("shut")
		main.act("close")
		await _settle()
	quit(0)


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
	print("RESULTV2_STILL %s modal %s cut=%d" % [tab, str(panel.get_global_rect()) if panel else "?", cut.size()])
	for s in cut.slice(0, 12):
		print("  CUT ", s)


func _save(name: String) -> void:
	await _settle(10)
	if DisplayServer.get_name() == "headless":
		print("RESULTV2_STILL headless: no picture for ", name)
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	print("wrote ", out_dir.path_join(name + ".png"))


func _settle(n: int = 6) -> void:
	for i in n:
		await process_frame
