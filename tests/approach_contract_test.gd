extends SceneTree
## S487 R58 APPROACH2: blind contract test for ApproachWire.gd from TASK_APPROACH2.md,
## R58_MAP_S439.md (section 4 M4 + M5), and ApproachWire.gd's header comment alone.

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Region := preload("res://scripts/state/Region.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")

var failures: int = 0


func _check(ok: bool, what: String) -> void:
	print(("ok  " if ok else "FAIL ") + what)
	if not ok:
		failures += 1


func _club(seed_val: int = 11) -> Career:
	var c: Career = Career.quick_start()
	c.seed = seed_val
	c.cash = 30000
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	Roster.sign_fighter(c, Data.PROSPECTS[0], [])
	(c.fighters[0] as Dictionary)["loyalty"] = 64
	return c


func _step_days(c: Career, n: int) -> void:
	for _i in range(n):
		Sim.step_day(c)
		c.review_pending = false


func _monday_with(patch: Dictionary, day_job: bool = true) -> Career:
	var c: Career = _club()
	var kira: Dictionary = c.fighters[1]
	if day_job:
		GymSpend.set_stipend(c, kira, false)
	kira.merge(patch, true)
	Region.update_rank(c, kira)
	_step_days(c, 7)
	return c


func _ap(f: Dictionary) -> Dictionary:
	var raw: Variant = f.get("approach", {})
	return raw if raw is Dictionary else {}


func _is_open(c: Career, fid: String) -> bool:
	for item in ApproachWire.open_for(c):
		var f: Dictionary = item
		if str(f.get("id", "")) == fid:
			return true
	return false


func _has_blocker(c: Career, fid: String) -> bool:
	for item in Needs.blockers(c):
		var row: Dictionary = item
		if str(row.get("act", "")) == "approach" and (fid == "" or str(row.get("arg", "")) == fid):
			return true
	return false


func _has_approached_flag(c: Career) -> bool:
	for item in Needs.flags(c):
		var row: Dictionary = item
		if str(row.get("t", "")) == "APPROACHED":
			return true
	return false


func _talk_call_ok(r: Variant, expect_word: bool) -> bool:
	var res: bool = false
	if r is bool:
		res = bool(r)
	elif r is Dictionary:
		var d: Dictionary = r
		if d.has("ok"):
			res = bool(d["ok"])
		else:
			res = str(d["why"]) == "" if d.has("why") else not d.is_empty()
	elif r is String:
		var s: String = r
		var word_ok: bool = s == "landed" or s == "failed"
		res = word_ok if expect_word else (s == "" or word_ok)
	return res


func _second_talk_refused(r1: Variant, r2: Variant) -> bool:
	var expect_word: bool = r1 is String and (str(r1) == "landed" or str(r1) == "failed")
	return not _talk_call_ok(r2, expect_word)


func _roll_talk(coachability: int, want: String) -> Array:
	for try_i in range(1, 64):
		var c: Career = _club(try_i * 23 + coachability)
		c.day = try_i * 7 - 1
		var kira: Dictionary = c.fighters[1]
		GymSpend.set_stipend(c, kira, false)
		kira["loyalty"] = 30
		var pers_raw: Variant = kira.get("personality", {})
		if pers_raw is Dictionary:
			(pers_raw as Dictionary)["coachability"] = coachability
		_step_days(c, 1)
		var r1: Variant = ApproachWire.talk(c, str(kira["id"]))
		if str(_ap(kira).get("talk", "")) == want:
			return [c, r1]
	return []


func _promise_count(c: Career, fid: String, state: String) -> int:
	var n: int = 0
	for item in c.promises:
		var p: Dictionary = item
		if str(p.get("fid", "")) == fid and str(p.get("kind", "")) == "show_top":
			if str(p.get("state", "")) == state:
				n += 1
	return n


func _initialize() -> void:
	_test_monday_and_eligibility()
	_test_groups_and_holder()
	_test_needs_and_flags()
	_test_match()
	_test_talk_and_half()
	_test_move()
	_test_promise()
	_test_let_go_and_unanswered()
	print("APPROACH_CONTRACT %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)


func _test_monday_and_eligibility() -> void:
	var c: Career = _club()
	var lucy: Dictionary = c.fighters[0]
	var kira: Dictionary = c.fighters[1]
	var kid: String = str(kira["id"])
	GymSpend.set_stipend(c, kira, false)
	kira["loyalty"] = 30
	_step_days(c, 6)
	_check(not _is_open(c, kid), "non-Monday days 1..6 do not open an approach")
	_step_days(c, 1)
	var ap: Dictionary = _ap(kira)
	var shape_ok: bool = (
		_is_open(c, kid) and bool(ApproachWire.is_open(kira))
		and ap.has("day") and int(ap["day"]) == 7 and ap.has("group") and str(ap["group"]) == "keep"
		and ap.has("line") and str(ap["line"]) != "" and ap.has("ends") and int(ap["ends"]) == 14
		and ap.has("talk") and str(ap["talk"]) == "" and ap.has("holder") and str(ap["holder"]) == "lucy"
	)
	_check(shape_ok, "Monday opens f['approach'] with day, group, line, ends=day+7, talk='', holder")

	_check(str(ApproachWire.answer(c, kid, "match")) == "", "cooldown setup: first approach closed")
	var opened_early: bool = false
	while c.day < 84:
		lucy["loyalty"] = 70
		kira["loyalty"] = 30
		_step_days(c, 1)
		opened_early = opened_early or _is_open(c, kid)
	_check(c.day == 84 and not opened_early, "no second approach inside 84 days (checked to day 84)")
	for _k in range(7):
		lucy["loyalty"] = 70
		kira["loyalty"] = 30
		_step_days(c, 1)
	_check(c.day == 91 and _is_open(c, kid), "new approach opens once 84 days pass (day 91 = +84d)")

	var cr: Career = _monday_with({"pot": 70, "w": 10, "l": 1, "loyalty": 30})
	var kr_f: Dictionary = cr.fighters[1]
	_check(Region.our_rank(cr, kr_f) <= 5 and _is_open(cr, "kira"), "regional top 5 qualifies")
	var cp: Career = _monday_with({"pot": 70, "pro": true, "loyalty": 30}, false)
	_check(_is_open(cp, "kira"), "professional boxer under 35 loyalty qualifies")
	_check(not _is_open(_monday_with({"loyalty": 40}), "kira"), "loyalty 40 never gets an approach")
	var c35: Career = _monday_with({"pro": true, "loyalty": 35}, false)
	_check(not _is_open(c35, "kira"), "loyalty 35 (not under 35) never gets an approach")
	var cu: Career = _monday_with({"pot": 70, "w": 1, "l": 0, "loyalty": 28})
	_check(not _is_open(cu, "kira"), "potential 70 and unranked never gets an approach")


func _test_groups_and_holder() -> void:
	var c1: Career = _monday_with({"loyalty": 30}, false)
	var ap1: Dictionary = _ap(c1.fighters[1])
	var no_job_ok: bool = str(ap1.get("group", "")) != "keep" and str(ap1.get("holder", "x")) == ""
	_check(_is_open(c1, "kira") and no_job_ok, "no day job: group != 'keep' and holder == ''")

	var c2: Career = _club()
	var k2: Dictionary = c2.fighters[1]
	GymSpend.set_stipend(c2, k2, false)
	for _i in range(4):
		Loyalty.apply(k2, "offer_passed", c2.day)
	k2["loyalty"] = 30
	_step_days(c2, 7)
	var ap2: Dictionary = _ap(k2)
	var bout_ok: bool = str(ap2.get("group", "")) == "bout" and str(ap2.get("holder", "x")) == ""
	_check(bout_ok, "bout group: holder is '' even when a team-mate holds the stipend")

	var c3: Career = _club()
	(c3.fighters[0] as Dictionary)["loyalty"] = 62
	var k3: Dictionary = c3.fighters[1]
	GymSpend.set_stipend(c3, k3, false)
	k3["loyalty"] = 30
	Roster.sign_fighter(c3, Data.PROSPECTS[1], [])["loyalty"] = 82
	Roster.sign_fighter(c3, Data.PROSPECTS[2], []).merge({"loyalty": 95, "pro": true}, true)
	Roster.sign_fighter(c3, Data.PROSPECTS[3], []).merge(
		{"loyalty": 92, "day_job": true, "weekly_salary": 0}, true
	)
	Roster.sign_fighter(c3, Data.PROSPECTS[4], []).merge({"loyalty": 90, "weekly_salary": 0}, true)
	_step_days(c3, 7)
	var ap3: Dictionary = _ap(k3)
	var keep_holder_ok: bool = (
		str(ap3.get("group", "")) == "keep" and str(ap3.get("holder", "")) == "samira"
	)
	_check(keep_holder_ok, "keep group: holder is most loyal stipend team-mate (not pro/day_job/$0)")

	var c4: Career = _club()
	var l4: Dictionary = c4.fighters[0]
	GymSpend.set_stipend(c4, l4, false)
	l4["loyalty"] = 70
	var k4: Dictionary = c4.fighters[1]
	GymSpend.set_stipend(c4, k4, false)
	k4["loyalty"] = 30
	_step_days(c4, 7)
	var ap4: Dictionary = _ap(k4)
	var none_ok: bool = str(ap4.get("group", "")) == "keep" and str(ap4.get("holder", "x")) == ""
	_check(none_ok, "keep group with no stipend team-mate: holder is ''")


func _test_needs_and_flags() -> void:
	var c: Career = _club()
	_check(not _has_blocker(c, "") and not _has_approached_flag(c), "closed: no blocker or flag")
	c = _monday_with({"loyalty": 30})
	_check(_has_blocker(c, "kira"), "while open: Needs.blockers(c) holds act 'approach'")
	_check(_has_approached_flag(c), "while open: Needs.flags(c) holds 'APPROACHED'")
	var err: String = str(ApproachWire.answer(c, "kira", "match"))
	_check(err == "" and not _has_blocker(c, "") and not _has_approached_flag(c), "closed on answer")


func _test_match() -> void:
	var c: Career = _monday_with({"loyalty": 30})
	var kira: Dictionary = c.fighters[1]
	var kid: String = str(kira["id"])
	var open_day: int = c.day
	_check(str(ApproachWire.answer(c, kid, "bogus")) != "", "unknown answer returns reason")
	var k_before: int = Loyalty.value(kira)
	_check(str(ApproachWire.answer(c, kid, "match")) == "" and not _is_open(c, kid), "match: closes")
	_check(str(ApproachWire.answer(c, kid, "match")) != "", "closed approach refuses second answer")
	var on_keep: bool = int(kira["weekly_salary"]) == 250 and not bool(kira.get("day_job", false))
	_check(on_keep and Loyalty.value(kira) == k_before + 12, "match ('keep'): $250 stipend, +12")
	_check(GymSpend.set_stipend(c, kira, false).begins_with("held to"), "match: stipend locked now")
	while c.day < open_day + 83:
		kira["loyalty"] = 60
		_step_days(c, 1)
	_check(
		GymSpend.set_stipend(c, kira, false).begins_with("held to"),
		"match: set_stipend(false) refused ('held to ...') until day + 84 (at day + 83)"
	)
	kira["loyalty"] = 60
	_step_days(c, 1)
	_check(GymSpend.set_stipend(c, kira, false) == "", "match: set_stipend(false) allowed at day + 84")


func _test_talk_and_half() -> void:
	var c: Career = _monday_with({"loyalty": 30})
	var lucy: Dictionary = c.fighters[0]
	var kira: Dictionary = c.fighters[1]
	var kid: String = str(kira["id"])
	var full_gain: float = GymSpend.gain(c, "conditioning", lucy)
	var k_before: int = Loyalty.value(kira)
	var l_before: int = Loyalty.value(lucy)
	_check(str(ApproachWire.answer(c, kid, "half")) == "" and not _is_open(c, kid), "half: closes")
	var both_125: bool = (
		int(kira["weekly_salary"]) == 125 and int(lucy["weekly_salary"]) == 125
		and not bool(kira.get("day_job", false)) and not bool(lucy.get("day_job", false))
	)
	_check(both_125, "half: both on $125 with no day job")
	var kr: float = GymSpend.gain(c, "conditioning", kira) / full_gain
	var lr: float = GymSpend.gain(c, "conditioning", lucy) / full_gain
	_check(is_equal_approx(kr, 0.925) and is_equal_approx(lr, 0.925), "half: both train at 92.5%")
	var half_loy_ok: bool = Loyalty.value(kira) == k_before + 6 and Loyalty.value(lucy) == l_before - 4
	_check(half_loy_ok, "half: boxer +6, holder -4")

	var hit: Array = _roll_talk(100, "landed")
	_check(not hit.is_empty(), "talk: observed 'landed' outcome")
	if not hit.is_empty():
		var ct: Career = hit[0]
		var r1: Variant = hit[1]
		var lt: Dictionary = ct.fighters[0]
		var kt: Dictionary = ct.fighters[1]
		var ktid: String = str(kt["id"])
		_check(_talk_call_ok(r1, false), "talk: first call ok and sets 'landed' or 'failed'")
		var pers_raw: Variant = kt.get("personality", {})
		if pers_raw is Dictionary:
			(pers_raw as Dictionary)["coachability"] = 0
		var loy_after: int = Loyalty.value(kt)
		var r2: Variant = ApproachWire.talk(ct, ktid)
		_check(_second_talk_refused(r1, r2), "talk: second call on same approach is refused")
		var unchanged: bool = str(_ap(kt).get("talk", "")) == "landed" and Loyalty.value(kt) == loy_after
		_check(unchanged, "talk: refused second call leaves state and loyalty unchanged")
		var l_pre: int = Loyalty.value(lt)
		var h_err: String = str(ApproachWire.answer(ct, ktid, "half"))
		var landed_ok: bool = Loyalty.value(kt) == loy_after + 10 and Loyalty.value(lt) == l_pre - 4
		_check(h_err == "" and landed_ok, "half after landed talk: boxer +10, holder -4")

	var miss: Array = _roll_talk(0, "failed")
	_check(not miss.is_empty(), "talk: observed 'failed' outcome")
	if not miss.is_empty():
		var cf: Career = miss[0]
		var rf1: Variant = miss[1]
		var kfid: String = str((cf.fighters[1] as Dictionary)["id"])
		var rf2: Variant = ApproachWire.talk(cf, kfid)
		_check(_talk_call_ok(rf1, false) and _second_talk_refused(rf1, rf2), "talk: 'failed' once")
		_check(str(ApproachWire.answer(cf, kfid, "half")) != "", "half: refused after failed talk")


func _test_move() -> void:
	var c: Career = _monday_with({"loyalty": 30})
	var lucy: Dictionary = c.fighters[0]
	var kira: Dictionary = c.fighters[1]
	var kid: String = str(kira["id"])
	var k_before: int = Loyalty.value(kira)
	var l_before: int = Loyalty.value(lucy)
	_check(str(ApproachWire.answer(c, kid, "move")) == "" and not _is_open(c, kid), "move: closes")
	_check(bool(lucy.get("day_job", false)) and int(lucy["weekly_salary"]) == 0, "move: holder on $0")
	_check(Loyalty.value(lucy) == l_before - 12, "move: holder loyalty -12")
	var moved_ok: bool = not bool(kira.get("day_job", false)) and int(kira["weekly_salary"]) == 250
	_check(moved_ok and Loyalty.value(kira) == k_before + 12, "move: boxer on $250 stipend, +12")


func _test_promise() -> void:
	var c: Career = _club()
	var kira: Dictionary = c.fighters[1]
	var kid: String = str(kira["id"])
	GymSpend.set_stipend(c, kira, false)
	kira.merge({"loyalty": 30, "weight": float(kira["limit"]), "next_offer_day": 6}, true)
	_step_days(c, 7)
	var cash_before: int = c.cash
	_check(str(ApproachWire.answer(c, kid, "promise")) == "" and not _is_open(c, kid), "promise: ok")
	var show_day: int = int(c.show.get("day", -1))
	_check(c.cash == cash_before - 3500 and show_day > c.day, "promise: $3,500 paid and show booked")
	_check(_promise_count(c, kid, "open") == 1, "promise: one open 'show_top' row in c.promises")
	var loy_open: int = Loyalty.value(kira)
	for o_item in kira["offers"]:
		var offer: Dictionary = o_item
		if not bool(offer.get("mismatch", false)) and not bool(offer.get("answered", true)):
			Bouts.decline(c, str(offer["id"]))
	Bouts.passed(c, kira)
	_check(Loyalty.value(kira) == loy_open, "promise: while open, bout offer passes cost no loyalty")
	while c.day < show_day - 1:
		_step_days(c, 1)
	kira.merge({"injury": {}, "weight": float(kira["limit"])}, true)
	var loy_pre_night: int = Loyalty.value(kira)
	_step_days(c, 1)
	var kept_ok: bool = (
		_promise_count(c, kid, "kept") == 1 and Loyalty.value(kira) == loy_pre_night + 10
	)
	_check(c.day == show_day and kept_ok, "promise: on the night a fit boxer's row is 'kept' (+10)")


func _test_let_go_and_unanswered() -> void:
	var c: Career = _monday_with({"loyalty": 30})
	var kira: Dictionary = c.fighters[1]
	var kid: String = str(kira["id"])
	var kname: String = str(kira["name"])
	_check(str(ApproachWire.answer(c, kid, "let_go")) == "" and not _is_open(c, kid), "let_go: ok")
	_step_days(c, 6)
	_check(c.day == 13 and not c.fighter_by_id(kid).is_empty(), "let_go: in c.fighters until Monday")
	_step_days(c, 1)
	var lg_ok: bool = (
		c.fighter_by_id(kid).is_empty() and str(c.rival(kname).get("club", "")) == "Eastside ABC"
	)
	_check(c.day == 14 and lg_ok, "let_go: gone on next Monday and in c.rivals at Eastside ABC")

	c = _monday_with({"loyalty": 30})
	kira = c.fighters[1]
	kid = str(kira["id"])
	kname = str(kira["name"])
	var ends_day: int = int(_ap(kira).get("ends", -1))
	_step_days(c, 6)
	_check(c.day == ends_day - 1 and not c.fighter_by_id(kid).is_empty(), "unanswered: stays pre-ends")
	_step_days(c, 1)
	var ua_ok: bool = (
		c.fighter_by_id(kid).is_empty() and str(c.rival(kname).get("club", "")) == "Eastside ABC"
	)
	_check(c.day == ends_day and ua_ok, "unanswered: on Monday at or after ends the boxer is gone")
