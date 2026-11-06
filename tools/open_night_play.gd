extends SceneTree
## S389 BJJWIRE: the career route to a live BJJ bout, by the real buttons: enter an open, reach its Saturday, go to the mats,
## fight bout 1 live (the plan takes every call), simulate the rest, close. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=500 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/open_night_play.gd -- out=<dir> auto=1
## Prints OPEN_NIGHT lines and writes open_*.png.

var main: Node
var out_dir := "user://open_night"
var _step := 0
var _t := 0.0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("out="):
			out_dir = str(a).substr(4)
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)


func _shot(name: String) -> void:
	root.get_texture().get_image().save_png("%s/%s.png" % [out_dir, name])


func _process(delta: float) -> bool:
	_t += delta
	match _step:
		0:
			if _t > 1.0:
				main.act("quick")
				var NoGi := load("res://scripts/rules/NoGi.gd")
				if main.career.grapplers.is_empty():
					main.career.grapplers = [NoGi.athlete()]
				main.career.cash = 20000
				var ana: Dictionary = main.career.grapplers[0]
				var d := int(NoGi.opens_after(main.career.day + 1, 1)[0]["d"])
				var why: String = load("res://scripts/state/Grapplers.gd").enter(main.career, str(ana["id"]), d)
				print("OPEN_NIGHT entered day %d why='%s' live=%s" % [d, why, str(load("res://scripts/state/Grapplers.gd").live)])
				main.career.day = d - 1
				var stopped: bool = load("res://scripts/state/Clock.gd").step(main.career)
				print("OPEN_NIGHT day %d stopped=%s" % [main.career.day, str(stopped)])
				_step = 1
				_t = 0.0
		1:
			if _t > 0.5:
				var b: Array = load("res://scripts/state/Needs.gd").blockers(main.career)
				var need: Array = b.filter(func(n): return str(n["act"]) == "opennight")
				print("OPEN_NIGHT need %s" % str(need.size()))
				if need.is_empty():
					print("OPEN_NIGHT FAIL no need")
					return true
				main.act("opennight", str(need[0]["arg"]))
				_step = 2
				_t = 0.0
		2:
			if _t > 1.0:
				_shot("open_1_card")
				main.act("openlive", str(main.modal["fid"]))
				_step = 3
				_t = 0.0
		3:
			var layer: Control = main.get("_mat_layer")
			var b: Node = layer.get_child(0) if layer.get_child_count() > 0 else null
			var m: Node = b.get_node_or_null("BeltMatch") if b != null else null
			if _t > 20.0 and _t - delta <= 20.0:
				_shot("open_2_live")
			if m != null and bool(m.get("_ended")):
				_shot("open_3_end")
				print("OPEN_NIGHT result %s" % str(m.call("result")))
				var go := m.get("_offers").get_node_or_null("MatchContinue") as Button
				if go == null:
					print("OPEN_NIGHT FAIL no continue")
					return true
				go.pressed.emit()
				_step = 4
				_t = 0.0
			elif _t > 400.0:
				print("OPEN_NIGHT FAIL match never ended")
				return true
		4:
			if _t > 1.0:
				var f: Dictionary = main.career.grappler_by_id(str(main.modal["fid"]))
				var run: Dictionary = f["open_run"]
				_shot("open_4_after_bout")
				print("OPEN_NIGHT rows %d over %s" % [(run["rows"] as Array).size(), str(run["over"])])
				if bool(run["over"]):
					_shot("open_5_medal")
					var before := int(f["mat_classes"])
					main.act("openclose", str(f["id"]))
					print("OPEN_NIGHT closed classes %d -> %d, news: %s" % [before, int(f["mat_classes"]), str(main.career.news[0]["t"])])
					print("OPEN_NIGHT PASS")
					return true
				main.act("opensim", str(f["id"]))
				_t = 0.0
	return false
