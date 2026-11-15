extends SceneTree
## S488 R58 HOMEBOUT1: PROMISE: OUR SHOW books a real bout - a legal novice on the show's night, no ticket cut (the gate
## is ours) - and the promise is kept by boxing it, broken when the bout never happens (missed weight). Run:
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/home_bout_test.gd

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")
const HomeBout := preload("res://scripts/state/HomeBout.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


## As approach_wire_test: a stipend holder and an unhappy prospect on a day job, stepped to the Monday the approach opens.
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
	return [c, kid]


## Steps to the show's night, weighing in when due (at `kg` on the scale). Stops ON the night, before the fight.
func _to_night(c: Career, kid: Dictionary, night: int, kg: float) -> void:
	for i in 60:
		if c.day >= night:
			break
		kid["weight"] = kg
		if not (kid["bout"] as Dictionary).is_empty() and Bouts.weigh_in_today(c, kid):
			Bouts.weigh(c, kid)
		Sim.step_day(c)
		c.review_pending = false
	kid["weight"] = kg
	if not (kid["bout"] as Dictionary).is_empty() and Bouts.weigh_in_today(c, kid):
		Bouts.weigh(c, kid)


func _initialize() -> void:
	# KEPT: promised, booked a legal novice on the night, boxed, no ticket cut, the promise kept.
	var r := _approached()
	var c: Career = r[0]
	var kid: Dictionary = r[1]
	_check(ApproachWire.is_open(kid), "the approach is open (day %d)" % c.day)
	_check(bool(ApproachWire.answer_view(c, kid)["can_book"]), "the card offers PROMISE: OUR SHOW (nothing booked, a legal novice exists)")
	_check(ApproachWire.answer(c, str(kid["id"]), "promise") == "", "PROMISE: OUR SHOW taken")
	var night := int(c.show["day"])
	var b: Dictionary = kid["bout"]
	_check(HomeBout.is_home(kid) and int(b.get("day", -1)) == night, "a home bout booked for the show's night (day %d)" % night)
	var opp: Dictionary = b.get("opp", {})
	var own := AmateurBooking.bouts_of(int(kid["w"]), int(kid["l"]))
	_check(not opp.is_empty() and AmateurBooking.experience_match_ok(own, AmateurBooking.bouts_of(int(opp["w"]), int(opp["l"]))),
		"the opponent is a legal match (%s, %d-%d)" % [opp.get("name", "?"), int(opp.get("w", 0)), int(opp.get("l", 0))])
	var lb := Loyalty.value(kid)
	_to_night(c, kid, night, float(kid["limit"]))
	_check(c.day == night and Bouts.fight_day(c, kid), "on the night the bout is on (weighed, made weight)")
	_check(str(c.promises[0]["state"]) == "open", "the promise waits for the fight (not resolved at the show's open)")
	_check(int(c.show.get("last", -1)) == night, "the show's night ran (tickets and raffle paid)")
	var cash := c.cash
	var m := {"fid": kid["id"], "step": "tape", "total": Bouts.rounds_of(kid)}
	Bouts.fight_step(c, kid, m, "sim")
	_check(str(m.get("outcome", "")) != "", "the home bout was boxed: %s" % m.get("outcome", ""))
	_check(int(m.get("club_cut", -1)) == 0 and c.cash == cash, "no ticket cut on our own show (cut %d, cash %d -> %d)" % [int(m.get("club_cut", -1)), cash, c.cash])
	_check(str(c.promises[0]["state"]) == "kept" and Loyalty.value(kid) > lb, "kept by boxing it: %s, loyalty %d -> %d" % [c.promises[0]["state"], lb, Loyalty.value(kid)])
	Bouts.after_fight(c, kid)
	Sim.step_day(c)
	_check(str(c.promises[0]["state"]) == "kept" and not kid.has("leaves_after"), "the next day the promise stays kept and the boxer stays")

	# BROKEN: promised, then misses weight - no bout on the night, the promise broken, the boxer leaves.
	r = _approached()
	c = r[0]
	kid = r[1]
	_check(ApproachWire.answer(c, str(kid["id"]), "promise") == "", "PROMISE: OUR SHOW taken (second club)")
	night = int(c.show["day"])
	_to_night(c, kid, night, float(kid["limit"]) + 6.0)
	_check((kid["bout"] as Dictionary).is_empty(), "missed weight: the home bout is off")
	Sim.step_day(c)
	_check(str(c.promises[0]["state"]) == "broken" and str(kid.get("leaves_why", "")) == "promise",
		"no bout boxed on the night: broken (%s), the boxer leaves" % c.promises[0]["state"])

	# REFUSED: a boxer with a bout already booked cannot be promised the top of our show; nothing is paid.
	r = _approached()
	c = r[0]
	kid = r[1]
	kid["bout"] = {"opp": {"name": "x"}, "day": c.day + 14, "weighed": false, "made": false, "done": false}
	cash = c.cash
	_check(not bool(ApproachWire.answer_view(c, kid)["can_book"]), "the card greys PROMISE: OUR SHOW when a bout is booked")
	var why := ApproachWire.answer(c, str(kid["id"]), "promise")
	_check(why != "" and c.cash == cash and c.promises.is_empty(), "refused (%s), the show not paid" % why)

	print("HOME_BOUT %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
