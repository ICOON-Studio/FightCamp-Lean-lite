extends SceneTree
## S488 R58 APPROACHUI2 (map section 7): the approach and its answers on the other menus, read through each menu's data
## function - Roster flag APPROACHED (CoachCheck + RosterFlag), the offer card's Pass price (Bouts.pass_price), Money's
## stipend "held to" (GymSpend.stipend_held), Club > People PROMISES OPEN (Promises.open_rows), Records' People rows for a
## promise and a leaving (Records.kind_of), Rankings' "(left us ...)" tag (Region.left_tag). Run:
## godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/approach_ui_test.gd

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Region := preload("res://scripts/state/Region.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")
const CoachCheck := preload("res://scripts/rules/CoachCheck.gd")
const RosterFlag := preload("res://scripts/rules/RosterFlag.gd")
const Promises := preload("res://scripts/rules/Promises.gd")
const Records := preload("res://scripts/rules/Records.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


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
	_check(ApproachWire.is_open(kid), "the approach is open (day %d)" % c.day)
	# Roster: the coach's first check and the card's corner flag.
	var rows := CoachCheck.rows(c, kid)
	_check(str(rows[0]["key"]) == "approach" and str(rows[0]["act"]) == "approach" and str(rows[0]["word"]).begins_with("wants an answer by"),
		"Roster checklist: the approach row first (%s)" % rows[0]["word"])
	var flag := RosterFlag.pick(rows)
	_check(str(flag.get("word", "")) == "APPROACHED" and bool(flag.get("red", false)), "Roster card flag: APPROACHED in red")
	_check(CoachCheck.rows(c, holder).size() == 8, "a boxer with no approach keeps the eight checks")
	# Fights > offer: Pass shows its loyalty price; a mismatch costs nothing.
	var legal := {"mismatch": false}
	_check(Bouts.pass_price(c, holder, legal) == -3, "offer card: Pass reads loyalty -3 (got %d)" % Bouts.pass_price(c, holder, legal))
	_check(Bouts.pass_price(c, holder, {"mismatch": true}) == 0, "offer card: passing a mismatch costs nothing")
	# Money: MATCH holds the stipend to the answer's end day.
	_check(GymSpend.stipend_held(c, kid) == "", "Money: no 'held to' before an answer")
	_check(ApproachWire.answer(c, str(kid["id"]), "match") == "", "MATCH THE OFFER taken")
	var held := GymSpend.stipend_held(c, kid)
	_check(held.begins_with("held to "), "Money: the stipend row reads '%s'" % held)
	_check(CoachCheck.rows(c, kid).size() == 8 and RosterFlag.pick(CoachCheck.rows(c, kid)).get("word", "") != "APPROACHED",
		"answered: the APPROACHED flag is gone")

	# Club > People: PROMISES OPEN; Records: the promise is a People row.
	r = _approached()
	c = r[0]
	kid = r[1]
	_check(ApproachWire.answer(c, str(kid["id"]), "promise") == "", "PROMISE: OUR SHOW taken")
	var pr := Promises.open_rows(c)
	_check(pr.size() == 1 and str(pr[0]["name"]) == str(kid["name"]) and str(pr[0]["line"]).begins_with("Top of our show on "),
		"People: PROMISES OPEN lists it (%s)" % (pr[0] if pr.size() > 0 else {}))
	_check(not str(pr[0]["line"]).contains(str(kid["first"])) if pr.size() > 0 else false, "the row's line has no name (the name is its header)")
	var promised := Records.rows(c).filter(func(x): return str(x["t"]).begins_with("You promise"))
	_check(promised.size() == 1 and str(promised[0]["kind"]) == "People", "Records: the promise is a People row")

	# Let go: Records' leaving row; Rankings tags the leaver at the new club.
	r = _approached()
	c = r[0]
	kid = r[1]
	var kname := str(kid["name"])
	_check(ApproachWire.answer(c, str(kid["id"]), "let_go") == "", "LET THEM GO taken")
	for i in 8:
		Sim.step_day(c)
	var rv := c.rival(kname)
	_check(not rv.is_empty() and Region.left_tag(rv).begins_with("(left us "), "Rankings: the leaver reads %s" % Region.left_tag(rv))
	_check(Region.left_tag(c.rivals[0]) == "" or c.rivals[0]["name"] == kname, "a rival who never boxed for us has no tag")
	var gone := Records.rows(c).filter(func(x): return str(x["t"]).contains(kname) and str(x["t"]).contains("leaves"))
	_check(gone.size() >= 1 and gone.all(func(x): return str(x["kind"]) == "People"), "Records: the leaving is a People row (%d)" % gone.size())

	print("APPROACH_UI %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
