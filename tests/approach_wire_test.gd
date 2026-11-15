extends SceneTree
## S487 R58 APPROACHWIRE1: a rival club's approach played through the real day loop (Sim.step_day) - it opens on a
## Monday for an unhappy prospect on a day job, blocks time on Home, sits on top of the Overview with five answers, and
## each answer does what its column says; unanswered, the boxer goes. Run:
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/approach_wire_test.gd

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const ApproachCard := preload("res://scripts/ui/ApproachCard.gd")
const Approach := preload("res://scripts/rules/Approach.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


## A club with a stipend holder (64) and an unhappy prospect on a day job (30), stepped to the Monday the approach opens.
func _approached() -> Array:
	var c := Career.quick_start()
	c.seed = 11
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	Roster.sign_fighter(c, Data.PROSPECTS[0], [])
	c.cash = 40000
	var holder: Dictionary = c.fighter()
	var kid: Dictionary = c.fighters[c.fighters.size() - 1]
	holder["loyalty"] = 64
	holder["day_job"] = false
	holder["weekly_salary"] = 250
	GymSpend.set_stipend(c, kid, false)
	kid["loyalty"] = 30
	for i in 8:
		Sim.step_day(c)
		if ApproachWire.is_open(kid):
			break
	return [c, kid, holder]


func _initialize() -> void:
	var r := _approached()
	var c: Career = r[0]
	var kid: Dictionary = r[1]
	var holder: Dictionary = r[2]
	var kid_id := str(kid["id"])
	_check(ApproachWire.is_open(kid), "a Monday opens the approach for the unhappy prospect (day %d)" % c.day)
	if not ApproachWire.is_open(kid):
		print("APPROACH_WIRE FAIL fails=%d" % (failures))
		quit(1)
		return
	var a: Dictionary = kid["approach"]
	_check(str(a["group"]) == "keep" and str(a["holder"]) == str(holder["id"]), "a stipend offer; the team-mate on the stipend holds it (%s)" % a["group"])
	_check(Needs.blockers(c).any(func(n): return str(n["act"]) == "approach"), "Home: a red need blocks time")
	_check(Needs.flags(c).any(func(x): return str(x["t"]) == "APPROACHED"), "the top bar flags APPROACHED")
	var v := ApproachCard.view(c, kid)
	# S494 his Q-253: three answers on the card (MATCH IT, HALF EACH, LET THEM GO), each with what happens and its loyalty.
	_check((v["cols"] as Array).map(func(col): return str(col["id"])) == ["match", "half", "let_go"] and str(v["head"]).contains(str(kid["name"]).to_upper()),
		"the card: three answers, the name only in the header (%s)" % [(v["cols"] as Array).map(func(col): return str(col["id"]))])
	_check(not str(v["cols"]).contains(str(holder["first"])) and not str(v["cols"]).contains(str(kid["first"])) and not str(v["offer"]).contains(str(kid["first"])),
		"no names in the columns or the offer line")
	_check((v["cols"] as Array).all(func(col): return bool(col["available"])), "all three open on a stipend ask")
	_check(int(v["cols"][0]["to"]) == int(v["cols"][0]["from"]) + int(Approach.GAIN["match"]) and str(v["cols"][0]["outcome"]).ends_with(" stays"),
		"MATCH IT: stays, loyalty %d -> %d" % [v["cols"][0]["from"], v["cols"][0]["to"]])
	_check(bool(v["cols"][2]["leaves"]) and str(v["cols"][2]["outcome"]).ends_with(" leaves Monday"), "LET THEM GO: leaves Monday")
	_check(str(v["cols"][1]["lines"]).contains("their loyalty"), "HALF EACH: the team-mate's loyalty is on the card")

	# The talk: once, then refused.
	var t := ApproachWire.talk(c, kid_id)
	_check(bool(t["ok"]) and str(kid["approach"]["talk"]) != "", "the talk is had (%s)" % kid["approach"]["talk"])
	_check(not bool(ApproachWire.talk(c, kid_id)["ok"]), "a second talk is refused")

	# MATCH IT: the second stipend, held 12 weeks, +12.
	r = _approached()
	c = r[0]; kid = r[1]; holder = r[2]
	var before := Loyalty.value(kid)
	_check(ApproachWire.answer(c, str(kid["id"]), "match") == "", "MATCH IT taken")
	_check(not bool(kid["day_job"]) and int(kid["weekly_salary"]) == 250 and Loyalty.value(kid) == before + 12, "on the stipend, loyalty +12 (%d -> %d)" % [before, Loyalty.value(kid)])
	_check(GymSpend.set_stipend(c, kid, false).begins_with("held to"), "the stipend is held to the end day")
	_check(not ApproachWire.is_open(kid) and not Needs.blockers(c).any(func(n): return str(n["act"]) == "approach"), "answered: the need is gone")

	# HALF EACH: $125 each, both train at 92.5%, the holder -4.
	r = _approached()
	c = r[0]; kid = r[1]; holder = r[2]
	var gain_before := GymSpend.gain(c, "technique", holder)
	var hb := Loyalty.value(holder)
	_check(ApproachWire.answer(c, str(kid["id"]), "half") == "", "HALF EACH taken")
	_check(int(kid["weekly_salary"]) == 125 and int(holder["weekly_salary"]) == 125, "the stipend split $125 + $125")
	_check(is_equal_approx(GymSpend.gain(c, "technique", holder), gain_before * 0.925), "the holder trains at 92.5%")
	_check(Loyalty.value(holder) == hb - 4, "the holder -4 (%d -> %d)" % [hb, Loyalty.value(holder)])

	# MOVE THE STIPEND: the holder to a day job, -12, and a grievance every 4 weeks.
	r = _approached()
	c = r[0]; kid = r[1]; holder = r[2]
	hb = Loyalty.value(holder)
	_check(ApproachWire.answer(c, str(kid["id"]), "move") == "", "MOVE THE STIPEND taken")
	_check(bool(holder["day_job"]) and int(holder["weekly_salary"]) == 0 and int(kid["weekly_salary"]) == 250, "the stipend moved")
	_check(Loyalty.value(holder) == hb - 12 and holder.has("grievance"), "the holder -12 and minds it (%d -> %d)" % [hb, Loyalty.value(holder)])

	# PROMISE: OUR SHOW: booked, promised; kept on the night with the boxer fit (+10).
	r = _approached()
	c = r[0]; kid = r[1]; holder = r[2]
	var cash := c.cash
	_check(ApproachWire.answer(c, str(kid["id"]), "promise") == "", "PROMISE: OUR SHOW taken")
	var night := int(c.show["day"])
	_check(c.cash == cash - 3500 and night > c.day and c.promises.size() == 1, "the show booked for day %d and the promise listed" % night)
	var lb := Loyalty.value(kid)
	while c.day < night:   # S488 HOMEBOUT1: the night's bout is weighed and boxed; boxing it keeps the promise
		kid["weight"] = float(kid["limit"])
		if not (kid["bout"] as Dictionary).is_empty() and Bouts.weigh_in_today(c, kid):
			Bouts.weigh(c, kid)
		Sim.step_day(c)
	if not (kid["bout"] as Dictionary).is_empty() and Bouts.weigh_in_today(c, kid):
		Bouts.weigh(c, kid)
	var fm := {"fid": kid["id"], "step": "tape", "total": Bouts.rounds_of(kid)}
	Bouts.fight_step(c, kid, fm, "sim")
	_check(str(c.promises[0]["state"]) == "kept" and Loyalty.value(kid) >= lb + 10, "kept on the night: %s, loyalty %d -> %d" % [c.promises[0]["state"], lb, Loyalty.value(kid)])

	# LET THEM GO: leaves next Monday.
	r = _approached()
	c = r[0]; kid = r[1]; holder = r[2]
	var kname := str(kid["name"])
	_check(ApproachWire.answer(c, str(kid["id"]), "let_go") == "", "LET THEM GO taken")
	for i in 8:
		Sim.step_day(c)
	_check(c.fighter_by_id(str(kid["id"])).is_empty() and str(c.rival(kname).get("club", "")) == "Eastside ABC", "gone on Monday, boxing for Eastside ABC")

	# Unanswered: the boxer goes on the end day.
	r = _approached()
	c = r[0]; kid = r[1]; holder = r[2]
	for i in 8:
		Sim.step_day(c)
	_check(c.fighter_by_id(str(kid["id"])).is_empty(), "no answer by the end day: the boxer is gone")

	print("APPROACH_WIRE %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
