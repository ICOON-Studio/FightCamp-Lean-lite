extends SceneTree
## S310: the ops board's Play buttons start the build at the part to test. Both jumps reach fight night through the real
## buttons - with film study (the coach's pick shows) and without - on their own save slot, never his career save.

const Champs := preload("res://scripts/state/Champs.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")

var failures := 0


func _initialize() -> void:
	_check(TestJump.wanted(PackedStringArray(["jump=fight"])) == "fight" and TestJump.wanted(PackedStringArray(["jump=fight_nofilm"])) == "fight_nofilm"
		and TestJump.wanted(PackedStringArray([])) == "" and TestJump.wanted(PackedStringArray(["jump=rm -rf"])) == "", "only named jumps are read")
	for jump in TestJump.JUMPS:
		var main: Node = load("res://scenes/Main.tscn").instantiate()
		root.add_child(main)
		await process_frame
		var ok := TestJump.run(main, jump)
		var f: Dictionary = main.career.fighter() if main.career != null else {}
		if jump == "injury":
			# S327 (Q-S294-46): in camp, a hand injury past her bout opens the choice over her fighter page; the bout keeps.
			_check(ok and not (f["bout"] as Dictionary).is_empty() and str((f.get("injury", {}) as Dictionary).get("type", "")) == "hand"
				and (main.modal.get("buttons", []) as Array).size() == 2, "injury: the hand injury asks pull out or fight hurt")
			_check(str(main.route.get("fighter", "")) == str(f["id"]) and main.save_path == TestJump.SAVE_PATH, "injury: her fighter page, its own save slot")
			main.queue_free()
			await process_frame
			continue
		if jump == "nationals":
			# S328 update 30: the career plays on until she can enter; WORLD > Nationals, then Enter books her regional.
			_check(ok and str(main.route.get("area", "")) == "world" and int(main.route.get("tab", -1)) == 4, "nationals: eligible, on WORLD > Nationals (day %d, %d-%d)" % [main.career.day, f["w"], f["l"]])
			main.act("enterchamp", str(f["id"]))
			var nb: Dictionary = f["bout"]
			_check(Champs.active(f) and (int(nb.get("champ", -1)) >= 0 or int(nb.get("day", 999)) < Champs.stage_day(int(f["champ"]["close"]), 0)),
				"nationals: Enter books her regional round (or it follows the bout she already has, %s)" % str(nb.get("day", "-")))
			main.queue_free()
			await process_frame
			continue
		if jump == "pro":
			# S329 update 31: the offer opens; signing pays her licence and books the ticket debut.
			_check(ok and main.modal.get("type", "") == "prooffer", "pro: the promoter's offer is open")
			var cash: int = main.career.cash
			main.act("turnpro")
			_check(bool(f.get("pro", false)) and bool(f["bout"].get("tickets", false)) and main.career.cash < cash,
				"pro: signed, the gym paid her licence, a ticket debut is booked")
			main.queue_free()
			await process_frame
			continue
		var film := int((f.get("bout", {}) as Dictionary).get("film", 0))
		_check(ok and str(main.modal.get("type", "")) == "fight", "%s: fight night is open" % jump)
		_check(film == (BoutRules.FILM_DEPTH_DEFAULT if jump == "fight_nofilm" else BoutRules.FILM_DEPTH_WITH_STUDY), "%s: film depth %d" % [jump, film])
		if jump == "corner":
			_check((f.get("combos", {}) as Dictionary).size() == 2, "corner: two drilled combinations for the set-up")
		_check(main.save_path == TestJump.SAVE_PATH and main.save_path != SaveGame.PATH, "%s: its own save slot, never his career save" % jump)
		main.act("fightstep", "start")
		var pv := LiveRound.preview(f, main.modal) if not LiveRound.live(main.modal).is_empty() else {}
		if not pv.is_empty():
			_check((str(pv["mark"]) != "") == (jump != "fight_nofilm"), "%s: coach's pick on the shout bar %s" % [jump, "is hidden" if jump == "fight_nofilm" else "shows"])
		main.queue_free()
		await process_frame
	print("TESTJUMP failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
