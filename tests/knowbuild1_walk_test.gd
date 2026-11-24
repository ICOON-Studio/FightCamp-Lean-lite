extends SceneTree
## KNOWBUILD1 (S545, owner interview S543 K1-K4 on map v9, ops/research/TASK_KNOWBUILD1.md step 0): the signing card walked
## through the real buttons. A scouted prospect arrives with a bout date and the rival club's window; the card shows the read
## as RANGES (never one number); three endings: (a) Sign now on the first look - the profile opens and says what changed,
## nothing left open; (b) Start the trial, pick tomorrow's question twice, sign on trial day 3 with narrower ranges than day
## 0; (c) Wait - the rival's window runs out: the news line and the got-away list carry the name and the date, the place is
## free. Pass once (no news line). A prospect half way through a trial survives save and load. Then a two-year career at
## always-sign-on-the-first-look prints how many names it sees and signs, the places flops hold, and the level's drift.
## Last line: KNOWBUILD1_WALK failures=<n>.

const PW := preload("res://scripts/state/ProspectWire.gd")
const PC := preload("res://scripts/rules/ProspectClock.gd")
const KR := preload("res://scripts/rules/KnowReads.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const Leaving := preload("res://scripts/state/Leaving.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	await _sign_now()
	await _trial_three_days()
	await _wait_out()
	await _pass_once()
	await _save_mid_trial()
	await _two_years()
	print("KNOWBUILD1_WALK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _fresh() -> Career:
	if main != null:
		main.queue_free()
		await process_frame
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.save_path = "user://knowbuild1_walk.save"
	main.quiet_moments = true
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	c.first_hour = {}
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	FirstWeek.skip(c)
	main.clear_toast()
	return c


## A named prospect brought in today whose rival window opens far enough off for the walk (the scout's own arrival rule).
func _arrive_far(c: Career, gap: int, bout_first: bool = false) -> Dictionary:
	for id in ["kira", "samira", "tess", "danny", "josh"]:
		var p: Dictionary = PW.arrive(c, id)
		if not p.is_empty() and int(p.get("window_from", -1)) > c.day + gap and int(p.get("bout_day", 999)) < int(p["window_to"]) \
				and (not bout_first or int(p["bout_day"]) < int(p["rival_day"])):
			return p
	return {}


func _settle(c: Career) -> void:
	if c.review_pending:
		main.act("review")
		main.act("close")
	for f in c.fighters:
		for o in f["offers"]:
			if not bool(o["answered"]) and not bool(o["mismatch"]):
				main.act("declineOffer", str(o["id"]))
		if bool(f["goal_talk"]):
			main.act("goaltalk", f["id"])
			main.act("pickgoal", "five_round_engine")
			main.act("setgoal")
	if not c.pro_offer.is_empty():
		main.act("prooffer")
		main.act("declinepro")
	if not main.modal.is_empty() and str(main.modal.get("type", "")) not in ["trial", "prospect"]:
		main.act("close")
	main.clear_toast()


func _range_labels(prefix: String) -> Array:
	var out: Array = []
	for g in ["body", "skills", "ceiling"]:
		var l: Node = main.find_child(prefix + g, true, false)
		if l != null:
			out.append(str((l as Label).text))
	return out


func _width(r: Dictionary) -> float:
	var w := 0.0
	for g in ["body", "skills", "ceiling"]:
		w += float(r[g]["hi"]) - float(r[g]["lo"])
	return w


func _press(n: String) -> bool:
	var b: Node = main.find_child(n, true, false)
	if b == null or not (b is BaseButton) or (b as BaseButton).disabled:
		print("  (no button %s)" % n)
		return false
	(b as BaseButton).pressed.emit()
	return true


# (a) Sign now on the first look.
func _sign_now() -> void:
	var c: Career = await _fresh()
	var p := _arrive_far(c, 2)
	_check(not p.is_empty() and int(p["bout_day"]) > c.day and int(p["window_to"]) >= int(p["window_from"]) and int(p["window_to"]) - int(p["window_from"]) == PC.WINDOW - 1,
		"a: a scouted prospect arrives with a bout day %s and a 7-day rival window %s-%s" % [p.get("bout_day", "-"), p.get("window_from", "-"), p.get("window_to", "-")])
	if p.is_empty():
		return
	main.act("prospect", str(p["id"]))
	await process_frame
	_check(str(main.modal.get("type", "")) == "prospect", "a: the signing card opens")
	var labels := _range_labels("Range_")
	_check(labels.size() == 3 and labels.all(func(t): return str(t).contains("-")), "a: the read is three ranges, never one number (%s)" % ", ".join(labels))
	_check(main.find_child("DayStrip", true, false) != null and main.find_child("StripBout", true, false) != null and main.find_child("StripWindow", true, false) != null,
		"a: the 21-day strip carries the bout and the rival's window")
	_check(main.find_child("CallSign", true, false) != null and main.find_child("CallTrial", true, false) != null and main.find_child("CallWait", true, false) != null
		and main.find_child("PassProspect", true, false) != null, "a: three call cards (sign, trial, wait) and Pass")
	var places_before := GymSpend.used(c)
	_check(_press("SignNow"), "a: Sign now pressed")
	await process_frame
	var f: Dictionary = c.fighter_by_id(str(p["id"]))
	_check(not f.is_empty() and str(p["state"]) == "signed" and GymSpend.used(c) == places_before + 1, "a: signed on the first look, one more place taken")
	_check(main.modal.is_empty() and str(main.route.get("area", "")) == "fighters" and str(main.route.get("fighter", "")) == str(p["id"])
		and main.find_child("NewsTitle", true, false) != null and main.find_child("Fact_place", true, false) != null and main.find_child("NewChip", true, false) != null,
		"a: no pop-up - the new boxer's profile says what changed (the place, NEW)")
	_check(int(f.get("held_to", -1)) > c.day and str(Leaving.let_go_price(c, str(f["id"]))["why_not"]) != "",
		"a: held to the season's end (%s): Let go is not offered before it (%s)" % [Clock.fmt(int(f.get("held_to", 0))), Leaving.let_go_price(c, str(f["id"]))["why_not"]])
	_check(_press("NewsGo") and main.modal.is_empty(), "a: the one pulsing action leaves nothing open")


# (b) Start the trial, pick tomorrow's question twice, sign on trial day 3.
func _trial_three_days() -> void:
	var c: Career = await _fresh()
	var p := _arrive_far(c, 5)
	if p.is_empty():
		_check(false, "b: no prospect with a window 5+ days off")
		return
	var r0: Dictionary = PW.card(c, p)["ranges"]
	var cash0 := c.cash
	main.act("prospect", str(p["id"]))
	_check(_press("StartTrial") and str(p["state"]) == "trial" and main.modal.is_empty(), "b: Start the trial (tomorrow: the fitness test)")
	var picks := ["skills", "pads"]
	for day_n in [1, 2, 3]:
		for i in 12:
			if PW.evening(p):
				break
			_settle(c)
			main.run_to_stop(1)
		_check(PW.evening(p) and int(p["trial"]["days"]) == day_n and Needs.blockers(c).any(func(n): return str(n["t"]) == "Trial day %d: decide tonight" % day_n),
			"b: trial evening %d stops time: \"Trial day %d: decide tonight\"" % [day_n, day_n])
		main.act("trial", str(p["id"]))
		await process_frame
		_check(str(main.modal.get("type", "")) == "trial" and main.find_child("Before_" + str(p["trial"]["last"]["q"]), true, false) != null
			and main.find_child("After_" + str(p["trial"]["last"]["q"]), true, false) != null and main.find_child("Why", true, false) != null,
			"b: evening %d shows before -> after for %s with its why line" % [day_n, p["trial"]["last"]["q"]])
		if day_n < 3:
			var qs := main.find_children("Q_*", "BaseButton", true, false)
			_check(qs.size() >= 2 and qs.size() <= 4 and main.find_child("Odds", true, false) != null, "b: %d picture questions for tomorrow and tonight's rival odds" % qs.size())
			_check(_press("Q_" + picks[day_n - 1]) and main.modal.is_empty(), "b: tomorrow's question: %s" % picks[day_n - 1])
	var r3: Dictionary = PW.card(c, p)["ranges"]
	var paid := int(p["trial"]["paid"])
	_check(_press("TrialSign") and str(p["state"]) == "signed", "b: signed on trial day 3")
	_check(_width(r3) < _width(r0), "b: the ranges narrowed: %.1f wide on day 0 -> %.1f on day 3" % [_width(r0), _width(r3)])
	_check(paid == 3 * KR.PRICE_TRIAL_DAY, "b: three trial days cost %s (%d)" % [UI_money(3 * KR.PRICE_TRIAL_DAY), paid])
	print("  b: day 0 %s | day 3 %s" % [_rtext(r0), _rtext(r3)])
	_check(c.cash < cash0, "b: the days were paid")


# (c) Wait: the window runs out, the rival signs.
func _wait_out() -> void:
	var c: Career = await _fresh()
	var p := _arrive_far(c, 2, true)
	if p.is_empty():
		_check(false, "c: no prospect whose bout comes before the rival's day")
		return
	var saw_bout := false
	var saw_window := false
	for i in 80:
		if str(p["state"]) != "scout":
			break
		if c.day == int(p["bout_day"]) and Needs.needs(c).any(func(n): return str(n["t"]) == "The prospect boxes tonight"):
			saw_bout = true
		if c.day == int(p["window_from"]) and Needs.needs(c).any(func(n): return str(n["t"]).ends_with("decide from today")):
			saw_window = true
		_settle(c)
		main.run_to_stop(1)
	_check(saw_bout, "c: Continue stopped on the bout day: \"The prospect boxes tonight\"")
	_check(saw_window, "c: Continue stopped on the window's first day: \"<club> decide from today\"")
	var gone: Dictionary = p.get("gone", {})
	_check(str(p["state"]) == "gone" and int(gone.get("d", -1)) == int(p["rival_day"]) and int(gone["d"]) <= int(p["window_to"]),
		"c: the rival signed on day %s, inside the window" % str(gone.get("d", "-")))
	var line := "%s sign the prospect %s" % [str(p["club"]), str(p["name"])]
	_check(c.news.any(func(n): return str(n["t"]).begins_with(line) and int(n["d"]) == int(gone.get("d", -1)) and bool(n["own"])), "c: the news line in Mail: %s" % line)
	var row: Array = PW.got_away(c).filter(func(x): return str(x["name"]) == str(p["name"]))
	_check(row.size() == 1 and int(row[0]["d"]) == int(gone["d"]) and str(row[0]["club"]) == str(p["club"]) and str(row[0]["look"]).contains("-") and not bool(row[0]["passed"]),
		"c: the got-away row: who, where, the date and the last look (%s)" % (str(row[0]) if row.size() == 1 else "none"))
	_check(c.fighter_by_id(str(p["id"])).is_empty() and PW.free_places(c) == GymSpend.places(c) - GymSpend.used(c), "c: the place is free (the prospect never held one)")
	_check(c.rivals.any(func(r): return str(r["name"]) == str(p["name"]) and str(r["club"]) == str(p["club"])), "c: the prospect boxes on at the rival club (a region row)")


func _pass_once() -> void:
	var c: Career = await _fresh()
	var p := _arrive_far(c, 0)
	if p.is_empty():
		_check(false, "pass: no prospect")
		return
	var news := c.news.size()
	main.act("prospect", str(p["id"]))
	_check(_press("PassProspect") and str(p["state"]) == "passed" and main.modal.is_empty(), "pass: Pass frees the slot")
	_check(c.news.size() == news, "pass: no news line")
	_check(PW.got_away(c).any(func(x): return str(x["name"]) == str(p["name"]) and bool(x["passed"])), "pass: on the got-away list, marked passed")


func _save_mid_trial() -> void:
	var c: Career = await _fresh()
	var p := _arrive_far(c, 4)
	if p.is_empty():
		_check(false, "save: no prospect")
		return
	PW.start_trial(c, str(p["id"]))
	for i in 3:
		Sim.step_day(c)
	var path := "user://knowbuild1_mid_trial.save"
	SaveGame.save(c, path)
	var back: Career = SaveGame.load_career(path)
	var q: Dictionary = {}
	for x in back.prospects:
		if str(x["id"]) == str(p["id"]):
			q = x
	_check(not q.is_empty() and str(q["state"]) == "trial" and int(q["trial"]["days"]) == int(p["trial"]["days"]) and int(q["trial"]["days"]) >= 1
		and absf(float(q["know"]["body"]) - float(p["know"]["body"])) < 0.001 and int(q["window_to"]) == int(p["window_to"]),
		"save: a prospect %d days into a trial survives save and load" % int(p["trial"]["days"]))


## Two years at always-sign-on-the-first-look (a place free) or else let the window run (the feedback loops' prints).
func _two_years() -> void:
	var c: Career = await _fresh()
	PW.restart(c)   # the first two names were drawn before the test fixed the seed: draw them again on seed 1
	var lvl0 := PW.region_level(c)
	var seen := {}
	var signed: Array = []
	var flop_days := 0
	for d in 728:
		for p in c.prospects:
			if str(p["state"]) in ["scout", "trial"] and p.has("arrived"):
				seen[str(p["id"])] = true
				if str(p["state"]) == "scout" and PW.free_places(c) > 0 and not p.has("home"):
					var f := PW.sign(c, str(p["id"]))
					if not f.is_empty():
						signed.append({"id": str(p["id"]), "flop": PC.merit(p) < PW.level(c, str(p["div"])), "d": c.day})
		for s in signed:
			if bool(s["flop"]) and not c.fighter_by_id(str(s["id"])).is_empty():
				flop_days += 1
		Sim.step_day(c)
		c.review_pending = false
	var gone := c.prospects.filter(func(p): return str(p["state"]) == "gone").size()
	var flops := signed.filter(func(s): return bool(s["flop"])).size()
	var lvl1 := PW.region_level(c)
	print("WALK2Y names seen %d, signed %d (%.1f a year), flops %d, gone to rivals %d; the gym's places %d (boxers and the mat)" % [seen.size(), signed.size(), signed.size() / 2.0, flops, gone, GymSpend.places(c)])
	print("WALK2Y places blocked by flops: %d place-days (%.1f place-years) for a gym that always signs on the first look" % [flop_days, flop_days / 364.0])
	print("WALK2Y region level %.2f -> %.2f (drift %+.2f)" % [lvl0, lvl1, lvl1 - lvl0])
	_check(seen.size() >= 12, "two years: %d names seen (one every 4-6 weeks)" % seen.size())
	_check(absf(lvl1 - lvl0) < 2.0, "two years: the level drifts under 2 points (%+.2f)" % (lvl1 - lvl0))


func _rtext(r: Dictionary) -> String:
	return ", ".join(["body", "skills", "ceiling"].map(func(g): return "%s %d-%d" % [g, int(r[g]["lo"]), int(r[g]["hi"])]))


func UI_money(n: int) -> String:
	return "$%d" % n


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
