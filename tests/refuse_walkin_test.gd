extends SceneTree
## Operator S405 ("yes"): refusing the first walk-in sends Lucy away for good and brings Danny in, who wants to turn pro but
## starts amateur. Refusing Danny too leaves reception empty and the guide points at Find a fighter.

const Sim := preload("res://scripts/state/Sim.gd")
const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const FirstWeekStrip := preload("res://scripts/ui/FirstWeekStrip.gd")
const Needs := preload("res://scripts/state/Needs.gd")

var failures := 0


func _initialize() -> void:
	_refused_lucy()
	_signs_danny()
	_refused_both()
	_debt_start()
	print("REFUSE_WALKIN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1


func _career() -> Career:
	var c := Career.quick_start()
	c.seed = 7
	return c


func _refused_lucy() -> void:
	var c := _career()
	_check(str(c.applicant.get("id", "")) == "lucy", "Lucy opens at reception")
	var msg := FirstHour.refuse(c)
	_check(str(c.applicant.get("id", "")) == "danny", "Danny takes her place (%s)" % str(c.applicant.get("id", "")))
	_check(str(c.applicant.get("quote", "")).contains("pro"), "Danny says he wants to turn pro")
	_check(int(c.applicant.get("w", -1)) == 2 and int(c.applicant.get("l", -1)) == 1, "Danny keeps his amateur record")
	_check(msg.contains("Lucy") and msg.contains("Danny"), "the message names both (%s)" % msg)
	var m := FirstHour.monday(c)
	_check(str(m["walkin"]) == "", "no second walk-in comes later")
	_check(not bool(m["teaser"]), "Ana's teaser still waits for the first bout")


func _signs_danny() -> void:
	var c := _career()
	FirstHour.refuse(c)
	Sim.sign(c, ["signature"])
	FirstWeek.sync(c)
	var f: Dictionary = c.fighter()
	_check(str(f.get("sex", "")) == "m" and str(f.get("id", "")) == "danny", "Danny is signed as the first boxer")
	_check(c.applicant.is_empty() and c.guide != "sign", "the guide moves on (%s)" % c.guide)
	_check(str(Roster.prospect(c, "danny").get("state", "")) == "signed", "he leaves the prospects list")
	for i in 40:
		if not (f.get("offers", []) as Array).is_empty():
			break
		Sim.step_day(c)
	var offers: Array = f.get("offers", [])
	_check(not offers.is_empty(), "a bout offer arrives for him")
	if not offers.is_empty():
		var opp: Dictionary = offers[0]["opp"]
		_check(str(opp.get("sex", "m")) == "m", "his opponent is a man (%s)" % str(opp.get("name", "")))


func _refused_both() -> void:
	var c := _career()
	c.guide = "sign"   # quick_start skips the guide; a new career opens on this step
	FirstHour.refuse(c)
	var msg := FirstHour.refuse(c)
	_check(c.applicant.is_empty(), "refusing Danny empties reception")
	_check(msg.contains("Find a fighter"), "the message says where to look (%s)" % msg)
	_check(str(Roster.prospect(c, "danny").get("state", "")) == "passed", "Danny is gone from the prospects")
	_check(Needs.needs(c).all(func(n): return str(n.get("act", "")) != "interview"), "no reception row is left")
	_check(c.guide == "sign" and preload("res://scripts/rules/GuideLines.gd").line(c).contains("find a fighter"), "the guide's line says to find a fighter")
	_check(FirstWeekStrip.why(c).contains("Find a fighter"), "the guide says where (%s)" % FirstWeekStrip.why(c))
	_check(Roster.invite(c, "josh"), "a prospect can still be invited")
	for i in 14:
		if int(Roster.prospect(c, "josh")["trial_day"]) <= c.day:
			break
		Sim.step_day(c)
	_check(int(Roster.prospect(c, "josh")["trial_day"]) <= c.day, "the trial day comes with nobody on the books")
	_check(Needs.needs(c).any(func(n): return str(n.get("act", "")) == "trial"), "and asks to be watched")
	var f := Roster.sign_prospect(c, "josh", ["signature"])
	FirstWeek.sync(c)
	_check(not f.is_empty() and c.guide != "sign", "signing from Find a fighter moves the guide on (%s)" % c.guide)


func _debt_start() -> void:
	var plain := _career()
	FirstHour.refuse(plain)
	_check(is_equal_approx(float(plain.applicant["weight"]), 61.6), "a normal start leaves his weight alone")
	var c := _career()
	c.start = "debt"
	FirstHour.refuse(c)
	_check(int(c.applicant["pot"]) == 90, "the debt start's walk-in is the best prospect, whoever it is")
	_check(is_equal_approx(float(c.applicant["weight"]), 62.2), "and is 2.2 kg over (%.1f)" % float(c.applicant["weight"]))
