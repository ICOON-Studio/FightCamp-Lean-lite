extends SceneTree
## What the classes drill + the opens' lean (S364, Kalli K-BELTROAD1 parts 2-3).
## Population: Ana Ribeiro (NoGi.athlete(): white belt, escapes strong, guillotine 9 / rear naked choke 12 weakest) and a
## copy of her with no takedowns-and-submissions game; the quick-start career for the page.
##   1. the plans: the coach's pick = closest to owned; for the next open = least-owned move of the group it leans on,
##      finished before the next; her favourite = the best owned move under a signature; nothing left = the coach's pick.
##   2. the lean: each open leans on one group in turn; her own there moves the odds +-0.25, a signature adds 0.05;
##      5 weeks drilling for an open beat the coach's pick in that open, and cost time on the belt road.
##   3. the chance in words: LONG SHOT under 0.40, FAVOURITE over 0.60.
##   4. the page: three plan buttons (the chosen one solid), a pick changes the drilled move, each open names its lean and
##      her chance as a word.

const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

var _fails := 0


func _initialize() -> void:
	_plans()
	_lean()
	_words()
	await _page()
	print("DRILL_PICK %s failures=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)


func _plans() -> void:
	var f := NoGi.athlete()
	_check(NoGi.drilling(f) == "armbar_guard", "default = the coach's pick, the armbar at 28")
	_check(NoGi.drilling_for(f, "open", 0) == "seatbelt_escape", "for the Regional (escapes lean): the seatbelt escape (22)")
	_check(NoGi.drilling_for(f, "open", 40) == "knee_cut_pass", "for the Spring Open (passes lean): the knee cut (15)")
	_check(NoGi.drilling_for(f, "fav") == "shrimp_bridge", "her favourite: shrimp and bridge (44), the best owned move under 50")
	f["drill"] = "open"
	var before := float(f["bjj"]["guillotine"])
	_check(NoGi.week(f, 70) == "guillotine" and is_equal_approx(float(f["bjj"]["guillotine"]) - before, NoGi.DRILL_GAIN), "for the takedowns open (Sat 18 Apr): the guillotine +3.2")
	f["bjj"]["rear_naked_choke"] = 5.0
	_check(NoGi.drilling(f, 70) == "guillotine", "a move in progress is finished before the next (rear naked choke now lower)")
	var g := NoGi.athlete()
	for m in ["shrimp_bridge", "frame_recover_guard", "seatbelt_escape", "posture_closed_guard"]:
		g["bjj"][m] = maxf(30.0, float(g["bjj"][m]))
	_check(NoGi.drilling_for(g, "open", 0) == "shrimp_bridge", "the lean's group all owned: its best move toward a signature")
	for m in g["bjj"]:
		g["bjj"][m] = 55.0
	_check(NoGi.drilling_for(g, "fav") == "" and NoGi.drilling_for(g, "coach") == "", "all past a signature: nothing to drill")
	g["bjj"]["kimura"] = 10.0
	_check(NoGi.drilling_for(g, "fav") == "kimura", "no owned move under 50: the favourite falls back to the coach's pick")


func _lean() -> void:
	var o := NoGi.opens_after(1, 3)
	_check(int(o[0]["lean"]) == 0 and int(o[1]["lean"]) == 1 and int(o[2]["lean"]) == 2, "the opens lean on each group in turn")
	var f := NoGi.athlete()
	var td: Dictionary = o[2]
	var base := NoGi.win_chance(f, 0)
	_check(NoGi.win_chance(f, 0, o[0]) > base + 0.1, "her strong escapes help her at the Regional (%.3f vs %.3f)" % [NoGi.win_chance(f, 0, o[0]), base])
	var none := f.duplicate(true)
	for m in ["double_leg", "armbar_guard", "kimura", "americana", "rear_naked_choke", "guillotine"]:
		none["bjj"][m] = 0.0
	_check(is_equal_approx(NoGi.win_chance(none, 0, td) - NoGi.win_chance(none, 0), -0.25), "no game in the lean's group: -0.25")
	var sig := f.duplicate(true)
	sig["bjj"]["kimura"] = 50.0
	_check(is_equal_approx(NoGi.win_chance(sig, 0, td) - NoGi.win_chance(f, 0, td), NoGi.SIGNATURE_BONUS), "a signature kimura adds 0.05 where takedowns and submissions decide")
	_check(NoGi.win_chance(none, 0, td) >= NoGi.WIN_RANGE.x and NoGi.win_chance(sig, 0, o[0]) <= NoGi.WIN_RANGE.y, "the odds stay inside 0.2-0.8")
	# Five weeks before the takedowns open (day 70 -> Sat 18 Apr, day 103): drilling for it against the coach's pick.
	var a := NoGi.athlete()
	var b := NoGi.athlete()
	b["drill"] = "open"
	for w in 5:
		NoGi.week(a, 70 + 7 * w)
		NoGi.week(b, 70 + 7 * w)
	var pa := NoGi.win_chance(a, 103, td)
	var pb := NoGi.win_chance(b, 103, td)
	_check(pb > pa + 0.01, "5 weeks for the open beat the coach's pick in it (%.3f vs %.3f)" % [pb, pa])
	var ra := float(BeltRoad.readiness(a, a["bjj"], 103)["share"])
	var rb := float(BeltRoad.readiness(b, b["bjj"], 103)["share"])
	_check(rb < ra, "and cost time on the belt road (share %.2f vs %.2f)" % [rb, ra])


func _words() -> void:
	_check(NoGi.chance_word(0.35) == "LONG SHOT" and NoGi.chance_word(0.5) == "EVEN" and NoGi.chance_word(0.65) == "FAVOURITE", "the chance in words")


func _page() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	main.act("quick")
	main.act("go", "fighters:0")
	main.act("fighter", "ana")
	for i in 3:
		await process_frame
	var p := main.find_child("GrapplerPage", true, false)
	_check(p != null and p.find_child("DrillPick", true, false) != null, "the page has WHAT THE CLASSES DRILL")
	if p == null:
		return
	var coach := p.find_child("Drill_coach", true, false) as Button
	_check(coach != null and coach.theme_type_variation == "BtnSolid", "the coach's pick is chosen")
	(p.find_child("Drill_open", true, false) as Button).pressed.emit()
	for i in 3:
		await process_frame
	p = main.find_child("GrapplerPage", true, false)
	var f: Dictionary = main.career.grappler_by_id("ana")
	_check(str(f["drill"]) == "open" and (p.find_child("Drill_open", true, false) as Button).theme_type_variation == "BtnSolid", "For the next open pressed: chosen")
	var lab := (p.find_child("Move_seatbelt_escape", true, false) as Node).get_child(0) as Label
	_check(lab.text.contains("(drilling)"), "the syllabus marks the seatbelt escape as drilling (the Regional leans on escapes)")
	var row := p.find_child("Open_33", true, false)
	var txt := ""
	for l in row.find_children("*", "Label", true, false):
		txt += (l as Label).text + " "
	_check(txt.contains("decided on escapes and survival") and (txt.contains("EVEN") or txt.contains("FAVOURITE") or txt.contains("LONG SHOT")), "the open names its lean and her chance (%s)" % txt.strip_edges())


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
