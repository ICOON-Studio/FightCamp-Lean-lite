extends SceneTree
## NoGi + Grapplers + the belt road page (S362, Q-S294-80 "Yes, build both").
## Population: Ana Ribeiro (NoGi.athlete(): no-gi featherweight, white belt 2 stripes, 130 classes, 9 of 14 moves owned)
## against the white-belt field of the opens; the quick-start career for the page.
##   1. the week: 3 classes, the move she is closest to owning gains, a stripe comes due in weeks, not months.
##   2. the opens: the calendar; her match odds bounded; 400 opens average about one win, points read winner first.
##   3. the career: entering pays the fee; the open runs on its Saturday; stripes and promotion with the IBJJF floor.
##   4. the save: an old save gains Ana; a round trip keeps her.
##   5. the page: belt road, stripes drawn, Give stripe off until due, Enter pays and reads Entered; the roster lists her.

const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")

var _fails := 0


func _initialize() -> void:
	_week()
	_opens()
	_career()
	_save()
	await _page()
	print("NO_GI %s failures=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)


func _week() -> void:
	var f := NoGi.athlete()
	var r := BeltRoad.readiness(f, f["bjj"], 0)
	_check(int(r["moves"][0]) == 9 and int(r["moves"][1]) == 14 and int(r["stripes"]) == 2, "Ana starts 9 of 14 moves owned, 2 stripes earned (%s)" % [r])
	_check(NoGi.stripes_due(f, 0) == 0, "no stripe due at the start")
	_check(NoGi.drilling(f) == "armbar_guard", "the class drills the move she is closest to owning (%s)" % NoGi.drilling(f))
	var m := NoGi.week(f)
	_check(m == "armbar_guard" and int(f["mat_classes"]) == 133 and is_equal_approx(float(f["bjj"]["armbar_guard"]), 31.2), "a week: 3 classes, +3.2 on the drilled move")
	_check(NoGi.drilling(f) == "seatbelt_escape", "an owned move hands the drill to the next closest")
	var weeks := 1
	while NoGi.stripes_due(f, weeks * 7) == 0 and weeks < 60:
		NoGi.week(f)
		weeks += 1
	_check(weeks >= 4 and weeks <= 12, "the 3rd stripe comes due in %d weeks (4-12)" % weeks)
	var g := NoGi.athlete()
	var wk := NoGi.weeks_to_ready(g, 0)
	_check(wk >= 13 and wk <= 52, "blue belt in %d weeks at 3 classes a week (3-12 months)" % wk)
	_check(NoGi.move_name("seatbelt_escape") == "Seatbelt escape" and NoGi.move_name("armbar_guard") == "Armbar from guard", "move names read as words")


func _opens() -> void:
	var o := NoGi.opens_after(1, 2)
	_check(int(o[0]["d"]) == 33 and str(o[0]["name"]) == "Regional No-Gi Open" and int(o[0]["fee"]) == 95, "first open Sat 7 Feb, $95")
	_check(int(o[1]["d"]) == 68 and int(o[1]["fee"]) == 110, "then the Spring Open, 5 weeks on, $110")
	_check(posmod(int(o[0]["d"]), 7) == 5 and posmod(int(o[1]["d"]), 7) == 5, "opens are on Saturdays")
	_check(NoGi.open_on(33).size() > 0 and NoGi.open_on(34).is_empty(), "open_on finds only the day")
	var f := NoGi.athlete()
	var p := NoGi.win_chance(f, 0)
	_check(p > 0.5 and p < 0.6, "a white belt 64%% of the way to blue wins %.2f of matches vs her belt" % p)
	var fresh := f.duplicate(true)
	fresh["mat_classes"] = 0
	_check(NoGi.win_chance(fresh, 0) < p and NoGi.win_chance(fresh, 0) >= NoGi.WIN_RANGE.x, "a fresh white belt wins less (%.2f)" % NoGi.win_chance(fresh, 0))
	var plain: Dictionary = o[0].duplicate()
	plain.erase("lean")   # S364: the base odds here; the lean's edge is drill_pick_test's
	var rng := RandomNumberGenerator.new()
	var wins := 0
	var golds := 0
	var bad := 0
	for i in 400:
		rng.seed = i
		var res := NoGi.run_open(f, plain, 33, rng)
		wins += int(res["wins"])
		golds += 1 if str(res["medal"]) == "gold" else 0
		for row in res["matches"]:
			var how := str(row["how"])
			if how.begins_with("points"):
				var sc := how.trim_prefix("points ").split("-")
				if (int(sc[0]) > int(sc[1])) != bool(row["win"]):
					bad += 1
	var mean := wins / 400.0
	_check(mean > 0.7 and mean < 1.4, "mean wins per open %.2f (0.7-1.4 at p %.2f)" % [mean, p])
	_check(golds > 40 and golds < 120, "golds %d of 400 (p^3 = %.0f)" % [golds, 400.0 * pow(p, 3)])
	_check(bad == 0, "every points line reads her score first and the winner higher (%d bad)" % bad)


func _career() -> void:
	var c := Career.quick_start()
	_check(c.grapplers.size() == 1 and str(c.grapplers[0]["id"]) == "ana", "a new career has Ana on the mat")
	var cash := c.cash
	_check(Grapplers.enter(c, "ana", 33) == "" and c.cash == cash - 95, "entering the Regional pays $95")
	_check(Grapplers.enter(c, "ana", 33) != "", "entering twice is refused")
	_check(Grapplers.enter(c, "ana", 34) != "", "no open on a Sunday")
	var f := c.grappler_by_id("ana")
	_check(int(Clock.next_stop(c)["d"]) <= 33 and (int(Clock.next_stop(c)["d"]) < 33 or str(Clock.next_stop(c)["r"]) == "Ana's open"), "the open is a stop on the calendar")
	var before := (f["opens"] as Array).size()
	var w0 := int(f["w"]) + int(f["l"])
	var stopped := false
	for d in range(1, 34):
		c.day = d
		stopped = Grapplers.day(c)
	_check(stopped, "the open's Saturday stops the clock")
	_check((f["opens"] as Array).size() > before and int(f["w"]) + int(f["l"]) > w0, "the open ran on its Saturday (%d matches)" % ((f["opens"] as Array).size() - before))
	_check(int(f["mat_classes"]) == 130 + 3 * 4, "four Sundays, 12 classes (%d)" % int(f["mat_classes"]))
	_check(str(c.news[0]["t"]).contains("Regional No-Gi Open") or str(c.news[1]["t"]).contains("Regional No-Gi Open"), "the news says how she did")
	_check(not bool(Grapplers.stripe(c, "ana")["ok"]) or NoGi.stripes_due(f, c.day) > 0, "no stripe given while none is due")
	for k in 12:
		NoGi.week(f)
	_check(NoGi.stripes_due(f, c.day) >= 1 and bool(Grapplers.stripe(c, "ana")["ok"]) and int(f["stripes"]) == 3, "the due stripe is given: 3 stripes")
	_check(str((f["belt_log"] as Array).back()["t"]) == "Stripe 3", "the belt log has stripe 3")
	_check(Grapplers.promote(c, "ana") == "" and str(f["belt"]) == "blue" and int(f["stripes"]) == 0 and int(f["mat_classes"]) == 0, "promoted to blue, stripes reset")
	_check(int(f["mat_debt"]) == int(round(0.25 * 450)), "promoted before ready: she owes a quarter of blue's mat time (%d)" % int(f["mat_debt"]))
	_check(Grapplers.promote(c, "ana") != "", "blue to purple refused under the 2-year floor")


func _save() -> void:
	var c := Career.quick_start()
	var d := SaveGame.to_dict(c)
	(d["props"] as Dictionary).erase("grapplers")
	_check(SaveGame.from_dict(d).grapplers.size() == 1, "a save from before the belt road gains Ana")
	c.grapplers[0]["stripes"] = 3
	_check(int(SaveGame.from_dict(SaveGame.to_dict(c)).grapplers[0]["stripes"]) == 3, "a round trip keeps her stripes")


func _page() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	main.act("quick")
	main.act("go", "fighters:0")
	for i in 3:
		await process_frame
	_check(main.find_child("Grappler_ana", true, false) != null, "the roster lists Ana on the mat")
	main.act("fighter", "ana")
	for i in 3:
		await process_frame
	var p := main.find_child("GrapplerPage", true, false)
	_check(p != null, "Ana's name opens her belt road")
	if p == null:
		return
	_check(p.find_child("BeltRoad", true, false) != null and p.find_child("Belt_black", true, false) != null, "five belts drawn")
	var white := p.find_child("Belt_white", true, false)
	var lit := 0
	for k in 4:
		var s := white.find_child("Stripe_%d" % k, true, false) as ColorRect
		if s != null and s.color == Color.WHITE:
			lit += 1
	_check(lit == 2, "two stripes on her white belt (%d)" % lit)
	_check((p.find_child("GiveStripe", true, false) as Button).disabled, "Give stripe is off until one is due")
	_check(not (p.find_child("Promote", true, false) as Button).disabled, "Promote is open above the floor (early)")
	_check(p.find_child("Move_armbar_guard", true, false) != null and p.find_child("OpensRecord", true, false) != null, "the syllabus and the record are drawn")
	var cash: int = main.career.cash
	(p.find_child("Enter_33", true, false) as Button).pressed.emit()
	for i in 3:
		await process_frame
	p = main.find_child("GrapplerPage", true, false)
	var e := p.find_child("Enter_33", true, false)
	_check(main.career.cash == cash - 95 and e is Label and (e as Label).text == "Entered", "Enter pays the fee and reads Entered")


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
