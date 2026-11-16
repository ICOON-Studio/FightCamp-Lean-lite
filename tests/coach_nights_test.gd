extends SceneTree
## S498 (his Q-S294-260 "full pads, no sharing"): every boxer on the pads a night gets the coach's FULL session, however
## many are on the pads that night - the week's drilling (DrillWeek.inputs -> PadWeek.night_minutes) and the Training
## screen's coach row (ClubWeek.coach_cell) both read a whole night. An old save that still carries the S496 dragged
## minutes (f["coach_min"]) loads and drills a whole night. Population: the TEST CLUB's three boxers on shared nights, the
## walk-in alone.

const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const ClubWeek := preload("res://scripts/state/ClubWeek.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")

var _fails := 0


func _initialize() -> void:
	var c := Career.quick_start("Anvil Street Gym", "London")
	TestClub.make(c)
	var boxers: Array = c.fighters
	_check(boxers.size() >= 3, "the test club has three boxers (%d)" % boxers.size())
	var shared := -1
	for d in 6:
		if DrillWeek.on_pads(c, d).size() >= 2:
			shared = d
			break
	_check(shared >= 0, "a night with two or more boxers on the pads (day %d)" % shared)
	if shared >= 0:
		var ids := DrillWeek.on_pads(c, shared)
		for id in ids:
			var f := c.fighter_by_id(str(id))
			var mins := PadWeek.night_minutes(DrillWeek.inputs(c, f)["nights"], shared)
			_check(is_equal_approx(mins, PadWeek.PAD_NIGHT_MINUTES), "%d on the pads night %d: %s drills a whole night (%.0f of %.0f)"
				% [ids.size(), shared, str(id), mins, PadWeek.PAD_NIGHT_MINUTES])
		var cell := ClubWeek.coach_cell(c, shared, -1)
		_check(str(cell["kind"]) == "pads" and (cell["boxers"] as Array).size() == ids.size(), "the coach row shows each boxer on the pads (%s)" % str(cell))
		for s in cell.get("boxers", []):
			_check(is_equal_approx(float(s["min"]), ClubWeek.PAD_MIN), "the coach row: %s gets the full %d minutes" % [str(s["fid"]), int(ClubWeek.PAD_MIN)])
		var f0 := c.fighter_by_id(str(ids[0]))
		var card := ClubWeek.card(c, f0)
		var nights := (PadWeek.nights_of(f0).get("pads", []) as Array).size()
		_check(int(card["coach_min"]) == roundi(ClubWeek.PAD_MIN * nights), "her card: %d pad nights x %d = %s" % [nights, int(ClubWeek.PAD_MIN), str(card["note"])])
		# an S496 save with the dragged split still on the boxers: loads, ignored, a whole night
		for id in ids:
			c.fighter_by_id(str(id))["coach_min"] = {str(shared): 10.0}
		var back: Career = SaveGame.from_dict(bytes_to_var(var_to_bytes(SaveGame.to_dict(c))))   # as SaveGame.save / load_career store it
		_check(back != null and back.fighters.size() == boxers.size(), "the old save loads")
		if back == null:
			_end()
			return
		var g := back.fighter_by_id(str(ids[0]))
		var mins_old := PadWeek.night_minutes(DrillWeek.inputs(back, g)["nights"], shared)
		_check(is_equal_approx(mins_old, PadWeek.PAD_NIGHT_MINUTES), "an old save with 10 dragged minutes still drills a whole night (%.0f)" % mins_old)
	var solo := Career.quick_start("Anvil Street Gym", "London")
	load("res://scripts/state/Sim.gd").sign(solo, TestClub.PICKS.duplicate())
	_check(solo.fighters.size() == 1, "the walk-in signed alone")
	if not solo.fighters.is_empty():
		var s: Dictionary = solo.fighters[0]
		var sp: Array = PadWeek.nights_of(s).get("pads", [])
		if not sp.is_empty():
			_check(is_equal_approx(PadWeek.night_minutes(DrillWeek.inputs(solo, s)["nights"], int(sp[0])), PadWeek.PAD_NIGHT_MINUTES), "one boxer: a whole night")
	_end()


func _end() -> void:
	print("COACH_NIGHTS failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok   " + what)
	else:
		_fails += 1
		print("  FAIL " + what)
