extends SceneTree
## S505 (operator: "the game run but its not responding", picture of the hub's Training pin): times the Training pin on a
## quick-start club and on the test club - the nav call itself and the next frames. A hang shows as a huge ms or no DONE.
##   <godot> --headless --audio-driver Dummy --path . --script res://tools/training_open_probe.gd

var main: Node


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	for club in ["quick", "test"]:
		main = load("res://scenes/Main.tscn").instantiate()
		root.add_child(main)
		await _settle(4)
		main.act("newcareer")
		await _settle(2)
		main.act("quick")
		await _settle(4)
		if club == "test":
			load("res://scripts/state/TestClub.gd").make(main.career)
			main.resume(main.career)
			await _settle(4)
		if club == "test":
			_parts(main.career)
		var t0 := Time.get_ticks_msec()
		main.nav({"area": "training"})
		var t1 := Time.get_ticks_msec()
		var worst := 0
		for i in 30:
			var a := Time.get_ticks_msec()
			await process_frame
			worst = maxi(worst, Time.get_ticks_msec() - a)
		if club == "test":
			for f in main.career.fighters:
				main.act("tkpick", str(f["id"]))
				await _settle(3)
				var tr: Node = main.find_child("Training", true, false)
				var sel := str(tr.model.get("sel", "?")) if tr != null and tr.get("model") is Dictionary else "no Training screen"
				print("TRAINING_PICK want=%s (%s) shown=%s route=%s cards=%s" % [str(f["id"]), str(f["name"]), sel, str(main.route), str(tr.find_child("TrainCards", true, false).get_child_count()) if tr != null else "-"])
		if club == "test":
			main.act("tkpick", "lucy")
			await _settle(3)
			for target in ["kira", "josh"]:
				for spot in [0.08, 0.5, 0.9]:
					main.act("tkpick", "lucy")
					await _settle(3)
					var tr2: Node = main.find_child("Training", true, false)
					var cardn: Control = tr2.find_child("Card_" + target, true, false)
					var r := cardn.get_global_rect()
					var at := Vector2(r.position.x + r.size.x * spot, r.position.y + r.size.y * 0.5)
					var hit: Control = root.gui_get_hovered_control() if false else null
					for pressed in [true, false]:
						var ev := InputEventMouseButton.new()
						ev.button_index = MOUSE_BUTTON_LEFT
						ev.pressed = pressed
						ev.position = at
						ev.global_position = at
						root.push_input(ev)
						await _settle(2)
					await _settle(3)
					var tr3: Node = main.find_child("Training", true, false)
					print("TRAINING_CLICK %s at %.0f%% of the card (%s): shown=%s" % [target, spot * 100.0, str(at), str(tr3.model.get("sel", "?"))])
		if club == "test":
			main.act("tkpick", "lucy")
			await _settle(3)
			var bk: Control = main.find_child("BackToGym", true, false)
			var br := bk.get_global_rect()
			for pressed in [true, false]:
				var ev2 := InputEventMouseButton.new()
				ev2.button_index = MOUSE_BUTTON_LEFT
				ev2.pressed = pressed
				ev2.position = br.get_center()
				ev2.global_position = br.get_center()
				root.push_input(ev2)
				await _settle(2)
			await _settle(3)
			print("TRAINING_CONTROL click Gym floor at %s: area now %s" % [str(br.get_center()), str(main.route.get("area"))])
			main.nav({"area": "training"})
			await _settle(3)
			var tr4: Node = main.find_child("Training", true, false)
			var c4: Control = tr4.find_child("Card_kira", true, false)
			print("TRAINING_CARD kira class=%s filter=%d on_click=%s rect=%s" % [c4.get_class(), c4.mouse_filter, str(c4.get("on_click")), str(c4.get_global_rect())])
			var hov := c4.get_viewport().gui_get_hovered_control()
		print("TRAINING_OPEN club=%s nav_ms=%d worst_frame_ms=%d fighters=%d" % [club, t1 - t0, worst, (main.career.fighters as Array).size() if main.get("career") != null else -1])
		main.queue_free()
		await _settle(2)
	print("TRAINING_OPEN DONE")
	quit(0)


func _settle(n: int) -> void:
	for i in n:
		await process_frame


## Each piece of Training.build on its own, so the slow one is named.
func _parts(c: Career) -> void:
	var CW := load("res://scripts/state/ClubWeek.gd")
	var S := load("res://scripts/state/Sim.gd")
	var f: Dictionary = CW.pick(c, "")
	var t := Time.get_ticks_msec()
	var m: Dictionary = CW.model(c, str(f["id"]), -1)
	var t_model := Time.get_ticks_msec() - t
	t = Time.get_ticks_msec()
	S.week_ctx(c, f)
	var t_ctx := Time.get_ticks_msec() - t
	var parts := {}
	for n in ["TrainCards", "TrainGrid", "TrainTired", "TrainSide"]:
		parts[n] = load("res://scripts/ui/%s.gd" % n)
	t = Time.get_ticks_msec()
	parts["TrainCards"].make(m, func(_id: String): pass)
	var t_cards := Time.get_ticks_msec() - t
	t = Time.get_ticks_msec()
	parts["TrainGrid"].make(m, {"am_drop": func(_a, _b): pass, "pm_drop": func(_a, _b): pass, "level": func(_a, _b): pass, "day": func(_a): pass}, -1, f)
	var t_grid := Time.get_ticks_msec() - t
	print("TRAINING_PARTS model_ms=%d week_ctx_ms=%d cards_ms=%d grid_ms=%d" % [t_model, t_ctx, t_cards, t_grid])
