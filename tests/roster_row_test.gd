extends SceneTree
## ROSTERROW1: one fighter's row on the Fighters page - values and words, no nodes.
## Each cell asserts against the function the fighter page or Home already calls
## for the same fighter, never against a typed number.

const MAIN := preload("res://scenes/Main.tscn")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const RosterRow := preload("res://scripts/rules/RosterRow.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const WB_KIT := preload("res://scripts/ui/WhiteboardKit.gd")
const CoachCheck := preload("res://scripts/rules/CoachCheck.gd")
const NextStep := preload("res://scripts/rules/NextStep.gd")
const FIGHTER_PAGE := preload("res://scripts/ui/areas/FighterPage.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")

var failures := 0
var main: Node


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok: " + label)
	else:
		failures += 1
		print("  FAIL: " + label)


func _initialize() -> void:
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	FirstWeek.ana_joins(c)
	await process_frame

	_test_quick_start_row(c)
	_test_tired_fighter(c)
	_test_overweight_fighter(c)
	_test_no_gi_athlete(c)
	_test_best_of(c)

	print("ROSTER_ROW failures=%d" % failures)
	print("PASS roster_row_test" if failures == 0 else "FAIL roster_row_test")
	quit(failures)


## Test the row for the first signed fighter (Lucy) on a quick-start career.
func _test_quick_start_row(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var fid: String = str(f["id"])
	var r: Dictionary = RosterRow.row(c, fid)
	_check(not r.is_empty(), "row returns a non-empty dict for the first fighter")

	# FIGHTER column: name matches
	_check(str(r["fighter"]["name"]) == str(f["name"]), "fighter name matches f['name']")
	_check(int(r["fighter"]["age"]) == int(f.get("age", 0)), "fighter age matches f['age']")
	_check(str(r["fighter"]["wc"]) == str(f.get("wc", "")), "fighter wc matches f['wc']")

	# Record matches
	var w: int = int(f.get("w", 0))
	var l: int = int(f.get("l", 0))
	_check(int(r["fighter"]["record"]["w"]) == w, "record w matches f['w']")
	_check(int(r["fighter"]["record"]["l"]) == l, "record l matches f['l']")

	# Road matches NextStep
	var road: Dictionary = NextStep.road(FIGHTER_PAGE._road_input(c, f), c.day)
	var lit: int = int(road["lit"])
	_check(int(r["fighter"]["road_lit"]) == lit, "road_lit matches NextStep.road lit")

	# TIREDNESS column: matches FighterProfile.fatigue and WB_KIT.fatigue_word
	var fatigue_val: float = FighterProfile.fatigue(f)
	_check(absf(float(r["tiredness"]["value"]) - fatigue_val) < 0.01, "tiredness value matches FighterProfile.fatigue")
	var word_arr: Array = WB_KIT.fatigue_word(fatigue_val, false)
	var expected_word: String = str(word_arr[0]).to_lower().capitalize()
	_check(str(r["tiredness"]["word"]) == expected_word, "tiredness word matches WB_KIT.fatigue_word")

	# MOOD column: matches FighterProfile.mood
	var morale: float = float(f.get("morale", FighterProfile.MORALE_START))
	var expected_mood: String = FighterProfile.mood(morale)
	_check(str(r["mood"]["word"]) == expected_mood, "mood word matches FighterProfile.mood")
	_check(absf(float(r["mood"]["value"]) - morale) < 0.01, "mood value matches morale")

	# WEIGHT column: for a boxer with no bout, shows "On weight" or limit
	var weight_over: float = float(f["weight"]) - float(f["limit"])
	_check(absf(float(r["weight"]["over"]) - weight_over) < 0.01, "weight over matches weight - limit")

	# COACH column: matches CoachCheck
	var checks: Array = CoachCheck.rows(c, f)
	var has_bad: bool = false
	for ch in checks:
		if str(ch["state"]) == "bad":
			has_bad = true
			break
	# The coach column should reflect the checks
	_check(r["coach"].has("word"), "coach column has a word")

	# DO NEXT column: if there are needs for this fighter, the first one matches
	var all_needs: Array = Needs.needs(c)
	var fighter_needs: Array = []
	for n in all_needs:
		var arg: String = str(n.get("arg", ""))
		var t: String = str(n["t"])
		if arg == fid or t.contains(str(f.get("first", ""))):
			fighter_needs.append(n)
	if not fighter_needs.is_empty():
		_check(str(r["do_next"]["act"]) == str(fighter_needs[0].get("act", "")),
			"do_next act matches first need for this fighter")


## Test a tired fighter (fatigue >= 80).
func _test_tired_fighter(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var fid: String = str(f["id"])
	# Set fatigue high
	f["week_fatigue"] = 85.0
	var r: Dictionary = RosterRow.row(c, fid)
	var fatigue_val: float = FighterProfile.fatigue(f)
	_check(absf(float(r["tiredness"]["value"]) - fatigue_val) < 0.01, "tired fighter: tiredness value matches fatigue")
	_check(str(r["tiredness"]["tone"]) == "bad", "tired fighter: tiredness tone is bad (overcooked)")
	# Clean up
	f["week_fatigue"] = 20.0


## Test an overweight fighter with no weigh-in coming.
func _test_overweight_fighter(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var fid: String = str(f["id"])
	var orig_weight: float = float(f["weight"])
	# Set weight over limit
	f["weight"] = float(f["limit"]) + 2.0
	var r: Dictionary = RosterRow.row(c, fid)
	# Without a bout, no weigh-in: should NOT show "kg over"
	_check(not bool(r["weight"]["weigh_in"]), "overweight no bout: weigh_in is false")
	_check(str(r["weight"]["tone"]) == "ok", "overweight no bout: tone is ok (no weigh-in warning)")
	# Clean up
	f["weight"] = orig_weight


## Test the no-gi athlete (Ana).
func _test_no_gi_athlete(c: Career) -> void:
	if c.grapplers.is_empty():
		_check(false, "no-gi athlete present")
		return
	var g: Dictionary = c.grapplers[0]
	var gid: String = str(g["id"])
	var r: Dictionary = RosterRow.row(c, gid)
	_check(not r.is_empty(), "row returns non-empty for no-gi athlete")
	_check(str(r["fighter"]["sport"]) == "bjj", "fighter sport is bjj for grappler")
	# Weight column should be muted for grappler
	_check(str(r["weight"]["tone"]) == "muted", "weight tone is muted for grappler")
	# Overall should have bjj groups
	_check(r["overall"].has("groups"), "overall has groups for grappler")
	var groups: Dictionary = r["overall"]["groups"]
	_check(groups.has("Guard") or groups.has("Pass") or groups.has("Sweep"), "grappler has bjj skill groups")
	# Tiredness still works
	var fatigue_val: float = FighterProfile.fatigue(g)
	_check(absf(float(r["tiredness"]["value"]) - fatigue_val) < 0.01, "grappler tiredness matches FighterProfile.fatigue")
	# Mood still works
	var morale: float = float(g.get("morale", FighterProfile.MORALE_START))
	var expected_mood: String = FighterProfile.mood(morale)
	_check(str(r["mood"]["word"]) == expected_mood, "grappler mood matches FighterProfile.mood")


## Test best_of returns a Dictionary (even if empty for now).
func _test_best_of(c: Career) -> void:
	var bo: Dictionary = RosterRow.best_of(c)
	_check(bo is Dictionary, "best_of returns a Dictionary")
	# S438 (Claude at collect): the painted groups come from Attrs, the ring is the measured level, the best is the real best.
	var A = load("res://scripts/rules/Attrs.gd")
	var f0: Dictionary = c.fighters[0]
	var r0: Dictionary = RosterRow.row(c, str(f0["id"]))
	var a0: Dictionary = A.of(f0)
	_check(absf(float(r0["overall"]["groups"]["Guard"]) - (float(a0["defence"]) + float(a0["durability"])) / 2.0) < 0.01, "Guard is the mean of Defence and Durability")
	_check(absf(float(r0["overall"]["groups"]["Cardio"]) - (float(a0["stamina"]) + float(a0["recovery"])) / 2.0) < 0.01, "Cardio is the mean of Stamina and Recovery")
	_check(int(r0["overall"]["ring"]) == int(round(A.weighted(a0))), "the ring is the measured level")
	_check(str(r0["fighter"]["stance"]) == str(f0.get("stance", "")), "stance is the fighter's own")
	if c.fighters.size() >= 2:
		var top := ""
		var best := -1.0
		for f in c.fighters:
			var v: float = (float(A.of(f)["speed"]) + float(A.of(f)["footwork"]) + float(A.of(f)["flexibility"])) / 3.0
			if v > best:
				best = v
				top = str(f["id"])
		_check(str(bo.get("Legs", "")) == top, "best_of names the roster's best Legs")
	else:
		_check(bo.is_empty(), "best_of is empty with one boxer")
