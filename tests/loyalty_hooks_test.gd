extends SceneTree
## S486 R58 LOYALHOOKS1 (map R58_MAP_S439 M1): the game's own moves change loyalty - a legal offer passed (-3, never the
## mismatch, never while injured), the pro call (decline -8, turn pro +5 after the share is set), a signing in the same
## class (-4 each), four idle Mondays (-3), results through the real fight (win +2 / loss -1 / stopped -3, a Loyal boxer at
## half) and the goal (+5 / -4).

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const LoyaltyWire := preload("res://scripts/state/LoyaltyWire.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _club() -> Career:
	var c := Career.quick_start()
	c.seed = 13
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	return c


func _offer(f: Dictionary, id: String, mismatch: bool) -> void:
	f["bout"] = {}
	f["offers"] = [{"id": id, "opp": {"club": "Fisher ABC", "name": "X"}, "day": 99, "expires": 999, "answered": false,
		"accepted": false, "expired": false, "mismatch": mismatch}]


func _initialize() -> void:
	var c := _club()
	var f: Dictionary = c.fighter()
	f["loyalty"] = 55
	_offer(f, "t:o1", false)
	Bouts.decline(c, "t:o1")
	_check(Loyalty.value(f) == 52, "a legal offer passed: 55 -> %d" % Loyalty.value(f))
	_offer(f, "t:m1", true)
	Bouts.decline(c, "t:m1")
	_check(Loyalty.value(f) == 52, "passing the mismatch costs nothing (%d)" % Loyalty.value(f))
	f["injury"] = {"until_day": c.day + 10}
	_offer(f, "t:o2", false)
	Bouts.decline(c, "t:o2")
	_check(Loyalty.value(f) == 52, "injured: passing costs nothing (%d)" % Loyalty.value(f))
	f.erase("injury")
	# Expiry counts the same as a pass.
	_offer(f, "t:o3", false)
	(f["offers"][0] as Dictionary)["expires"] = c.day - 1
	f["next_offer_day"] = c.day + 999
	Bouts.day_events(c)
	_check(Loyalty.value(f) == 49, "a legal offer left to expire: 52 -> %d" % Loyalty.value(f))

	# Results and the Loyal halving (the rule; the real fight runs it in BoutFinish - the golden path plays one).
	var g := {"loyalty": 60}
	Loyalty.apply(g, "bout_won", c.day)
	_check(Loyalty.value(g) == 62, "a win +2 (%d)" % Loyalty.value(g))
	Loyalty.apply(g, "stopped", c.day)
	_check(Loyalty.value(g) == 59, "stopped -3 (%d)" % Loyalty.value(g))
	var h := {"loyalty": 75}
	Loyalty.apply(h, "bout_lost", c.day)
	_check(Loyalty.value(h) == 75, "a Loyal boxer: a loss -1 halves to 0 (%d)" % Loyalty.value(h))
	Loyalty.apply(h, "stopped", c.day)
	_check(Loyalty.value(h) == 74, "a Loyal boxer: stopped -3 halves to -1 (%d)" % Loyalty.value(h))
	Loyalty.apply(h, "goal_missed", c.day)
	_check(Loyalty.value(h) == 70, "a goal missed is not halved: -4 (%d)" % Loyalty.value(h))

	# The pro call.
	c = _club()
	f = c.fighter()
	f["loyalty"] = 60
	f["bout"] = {}
	c.pro_offer = {"fid": f["id"], "promoter": "Test", "purse": 1500, "terms": 1.0, "step": 500, "top": 3000}
	Roster.decline_pro(c)
	_check(Loyalty.value(f) == 52, "declining the pro offer: 60 -> %d" % Loyalty.value(f))
	f["loyalty"] = 48
	c.pro_offer = {"fid": f["id"], "promoter": "Test", "purse": 1500, "terms": 1.0, "step": 500, "top": 3000}
	Roster.turn_pro(c)
	_check(is_equal_approx(float(f.get("gym_share", 0.0)), Loyalty.pro_share({"loyalty": 48})), "turned pro at 48: the outside manager's share (%s)" % str(f.get("gym_share", "")))
	_check(Loyalty.value(f) == 53, "turning pro +5 after the share is set: 48 -> %d" % Loyalty.value(f))

	# A signing in the same class: -4 to each boxer in it, nobody else.
	c = _club()
	f = c.fighter()
	f["loyalty"] = 60
	var same := Data.PROSPECTS.filter(func(p): return str(p.get("div", "")) == str(f["div"]))
	var other := Data.PROSPECTS.filter(func(p): return str(p.get("div", "")) != str(f["div"]))
	if not other.is_empty():
		Roster.sign_fighter(c, other[0], [])
		_check(Loyalty.value(f) == 60, "a signing in another class costs nothing (%d)" % Loyalty.value(f))
	var raw: Dictionary = (same[0] if not same.is_empty() else Data.PROSPECTS[0]).duplicate(true)
	raw["id"] = "same_class"
	raw["div"] = str(f["div"])   # a prospect put in her class
	Roster.sign_fighter(c, raw, [])
	_check(Loyalty.value(f) == 56, "a signing in the same class: 60 -> %d" % Loyalty.value(f))

	# Four idle Mondays: -3 once, then the count restarts; a booked bout resets it.
	c = _club()
	f = c.fighter()
	f["loyalty"] = 40
	f["bout"] = {}
	for i in 3:
		LoyaltyWire.idle_week(c, f)
	_check(Loyalty.value(f) == 40, "three idle Mondays: nothing yet (%d)" % Loyalty.value(f))
	LoyaltyWire.idle_week(c, f)
	_check(Loyalty.value(f) == 37 and int(f["idle_weeks"]) == 0, "the fourth: no_bout -3 (%d)" % Loyalty.value(f))
	LoyaltyWire.idle_week(c, f)
	f["bout"] = {"day": c.day + 14}
	LoyaltyWire.idle_week(c, f)
	_check(int(f["idle_weeks"]) == 0, "a booked bout resets the count")

	print("LOYALTY_HOOKS %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
