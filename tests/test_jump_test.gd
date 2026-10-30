extends SceneTree
## S310: the ops board's Play buttons start the build at the part to test. Both jumps reach fight night through the real
## buttons - with film study (the coach's pick shows) and without - on their own save slot, never his career save.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")

var failures := 0


func _initialize() -> void:
	_check(TestJump.wanted(PackedStringArray(["jump=fight"])) == "fight" and TestJump.wanted(PackedStringArray(["jump=fight_nofilm"])) == "fight_nofilm"
		and TestJump.wanted(PackedStringArray([])) == "" and TestJump.wanted(PackedStringArray(["jump=rm -rf"])) == "", "only the two named jumps are read")
	for jump in TestJump.JUMPS:
		var main: Node = load("res://scenes/Main.tscn").instantiate()
		root.add_child(main)
		await process_frame
		var ok := TestJump.run(main, jump)
		var f: Dictionary = main.career.fighter() if main.career != null else {}
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
