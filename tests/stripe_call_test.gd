extends SceneTree
## StripeCall + Ana's week in the review (S363, Kalli K-BELTROAD1 "my one first change", SQ26).
## Population: Ana Ribeiro (NoGi.athlete(): white belt 2 stripes, 130 classes, morale and loyalty 60) on the quick-start
## career; her 3rd stripe brought due by drilling weeks.
##   1. the calls: nothing due = now/hold off, early open only half way to the next stripe; due = now/hold, early off.
##   2. NOW +6 morale +3 loyalty; HOLD -8/-5, drills x1.15 until given, once per stripe, a news line under 50 loyalty;
##      the 2nd EARLY stripe costs 2 members and seeds her next open tough (-0.05 a match).
##   3. the coach's advice follows her: hungry (70+) = hold, low morale or loyalty = now.
##   4. morale reads in the opens (100 = +0.10 a match) and her results move it.
##   5. the week review: the classes, the drilled move (a new weapon is the headline), her open, the stripe calls in the
##      review itself (HOLD swaps the buttons for what happened).

const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const StripeCall := preload("res://scripts/rules/StripeCall.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const Clock := preload("res://scripts/state/Clock.gd")
const ReviewReveal := preload("res://scripts/rules/ReviewReveal.gd")

var _fails := 0


func _initialize() -> void:
	_calls()
	_advice()
	_opens()
	await _review()
	print("STRIPE_CALL %s failures=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)


## Ana with her 3rd stripe due (drilled weeks, day 70).
func _due() -> Dictionary:
	var f := NoGi.athlete()
	for i in 20:
		if NoGi.stripes_due(f, 70) > 0:
			break
		NoGi.week(f)
	return f


func _calls() -> void:
	var f := NoGi.athlete()
	var o := StripeCall.options(f, 0)
	_check(o["now"] != "" and o["hold"] != "", "nothing due: give-now and hold are off")
	var share := float(BeltRoad.readiness(f, f["bjj"], 0)["share"])
	_check((o["early"] == "") == (share * 4 - 2 >= 0.5), "early is open only half way to stripe 3 (share %.2f)" % share)
	var young := f.duplicate(true)
	young["mat_classes"] = 105   # 0.525 of 200: just past stripe 2
	_check(StripeCall.options(young, 0)["early"] != "", "early is off just past a stripe")
	var d := _due()
	_check(NoGi.stripes_due(d, 70) == 1, "the 3rd stripe comes due by drilling")
	o = StripeCall.options(d, 70)
	_check(o["now"] == "" and o["hold"] == "" and o["early"] != "", "due: now and hold open, early off")
	var a := d.duplicate(true)
	var r := StripeCall.apply(a, "now", 70)
	_check(bool(r["ok"]) and int(a["stripes"]) == 3 and int(a["morale"]) == 66 and int(a["loyalty"]) == 63, "NOW: stripe 3, morale 66, loyalty 63")
	var h := d.duplicate(true)
	r = StripeCall.apply(h, "hold", 70)
	_check(bool(r["ok"]) and int(h["stripes"]) == 2 and int(h["held"]) == 3 and int(h["morale"]) == 52 and int(h["loyalty"]) == 55 and str(r["news"]) == "", "HOLD: no stripe, morale 52, loyalty 55, no news above 50")
	_check(not bool(StripeCall.apply(h, "hold", 70)["ok"]), "one hold per stripe")
	var m := NoGi.drilling(h)
	var before := float(h["bjj"][m])
	NoGi.week(h)
	_check(is_equal_approx(float(h["bjj"][m]) - before, NoGi.DRILL_GAIN * NoGi.HUNGRY), "held: she drills 15%% harder (+%.2f)" % (float(h["bjj"][m]) - before))
	_check(bool(StripeCall.apply(h, "now", 70)["ok"]) and not h.has("held"), "giving it later ends the hold")
	var thin := d.duplicate(true)
	thin["loyalty"] = 52
	r = StripeCall.apply(thin, "hold", 70)
	_check(str(r["news"]).contains("another club"), "under 50 loyalty a hold sends her to look at another club")
	var c := Career.quick_start()
	var e := c.grappler_by_id("ana")
	var mem := int(c.bjj_side["members"])   # S365 the BJJ members see the grading standard
	var r1 := Grapplers.stripe(c, "ana", "early")
	_check(bool(r1["ok"]) and int(e["stripes"]) == 3 and int(e["morale"]) == 70 and int(c.bjj_side["members"]) == mem, "the 1st early stripe: morale 70, members kept")
	for i in 30:
		if StripeCall.options(e, c.day)["early"] == "":
			break
		NoGi.week(e)
	var p0 := NoGi.win_chance(e, c.day)
	var r2 := Grapplers.stripe(c, "ana", "early")
	_check(bool(r2["ok"]) and int(c.bjj_side["members"]) == mem - 2 and bool(e.get("tough_next", false)), "the 2nd early stripe: BJJ members -2, a tough next bracket")
	_check(is_equal_approx(NoGi.win_chance(e, c.day), p0 + StripeCall.EARLY_MORALE / NoGi.MORALE_SPAN - NoGi.TOUGH),
		"morale +10 (+0.025) and the tough bracket (-0.05): %.3f -> %.3f" % [p0, NoGi.win_chance(e, c.day)])
	_check(str((e["belt_log"] as Array).back()["note"]) == "given early", "the belt log says given early")


func _advice() -> void:
	var d := _due()
	_check(StripeCall.options(d, 70)["pick"] == "now", "morale 60: the coach says give it")
	d["morale"] = 75
	_check(StripeCall.options(d, 70)["pick"] == "hold", "hungry at 75: the coach says hold it")
	d["loyalty"] = 45
	_check(StripeCall.options(d, 70)["pick"] == "now", "thin loyalty beats hunger: give it")
	d["loyalty"] = 60
	d["morale"] = 40
	_check(StripeCall.options(d, 70)["pick"] == "now", "low morale: give it")


func _opens() -> void:
	var f := NoGi.athlete()
	var p := NoGi.win_chance(f, 0)
	f["morale"] = 100
	_check(is_equal_approx(NoGi.win_chance(f, 0), p + 0.10), "morale 100 adds 0.10 a match (%.3f -> %.3f)" % [p, NoGi.win_chance(f, 0)])
	f["morale"] = 20
	_check(is_equal_approx(NoGi.win_chance(f, 0), p - 0.10), "morale 20 takes 0.10")
	var c := Career.quick_start()
	var a := c.grappler_by_id("ana")
	a["tough_next"] = true
	Grapplers.enter(c, "ana", 33)
	for d in range(1, 34):
		c.day = d
		Grapplers.day(c)
	var ow: Dictionary = a.get("open_week", {})
	var want := 0
	for m in ow.get("matches", []):
		want += NoGi.WIN_MORALE if bool(m["win"]) else (-NoGi.TAP_MORALE if str(m["how"]).begins_with("submission") else -NoGi.LOSS_MORALE)
	_check(not ow.is_empty() and int(a["morale"]) == 60 + want and int(ow["morale"]) == want, "her open moved morale %+d (60 -> %d)" % [want, int(a["morale"])])
	_check(not a.has("tough_next"), "the tough bracket is spent on one open")


func _review() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	main.act("quick")
	var c: Career = main.career
	while c.day < 7:
		Clock.step(c)
	var gr: Array = c.last_report.get("grapplers", [])
	_check(gr.size() == 1 and int(gr[0]["classes"]) == 3 and str(gr[0]["move"]) == "armbar_guard", "week 1: the report has Ana's 3 classes and the armbar drilled")
	_check(gr.size() == 1 and bool(gr[0]["owned"]) and ReviewReveal.grappler_headline(gr[0], "Armbar from guard")["kind"] == "weapon", "28 -> 31.2: the armbar is her new weapon, the headline")
	_check(not c.grapplers[0].has("mat_week"), "the week's marks are cleared")
	main.act("review")
	for i in 3:
		await process_frame
	var rv: Node = main.modal_node()
	_check(rv != null and rv.find_child("Drill_ana", true, false) != null and rv.find_child("Headline_ana", true, false) != null, "the review draws the drilled move and her headline")
	_check(rv != null and rv.find_child("Stripe_ana", true, false) == null, "no stripe due in week 1: no stripe calls")
	main.act("close")
	# Her 3rd stripe due: the calls in the review itself.
	var f := c.grappler_by_id("ana")
	for i in 20:
		if NoGi.stripes_due(f, c.day + 7) > 0:
			break
		NoGi.week(f)
	while c.day < 14:
		Clock.step(c)
	gr = c.last_report.get("grapplers", [])
	_check(gr.size() == 1 and int(gr[0]["due"]) == 1, "week 2: the report says stripe 3 is due")
	main.act("review")
	for i in 3:
		await process_frame
	rv = main.modal_node()
	var hold: Button = rv.find_child("HoldStripe", true, false) as Button if rv != null else null
	_check(hold != null and not hold.disabled and rv.find_child("GiveStripe", true, false) != null, "the review offers the stripe calls")
	if hold != null:
		hold.pressed.emit()
		for i in 3:
			await process_frame
		var done := rv.find_child("StripeDone", true, false) as Label
		_check(done != null and done.text.contains("held back") and int(f["held"]) == 3 and rv.find_child("HoldStripe", true, false) == null, "HOLD in the review: the buttons give way to what happened")
		var mood := rv.find_child("Mood_ana", true, false) as Label
		_check(rv.find_child("Headline_ana", true, false) == null and mood != null and mood.text.begins_with("Morale 52"), "the 'your call' note goes, the mood line reads morale 52")


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
