extends SceneTree
## S486 R58 LEAVE1: a boxer leaves the club (Leaving) - the place frees, the boxer boxes on for Eastside ABC, reputation and
## team-mates pay, a bout inside 14 days is boxed first, a professional's manager pays the release fee, and the Monday in
## the real day loop removes a boxer whose loyalty fell under 25 after two words.

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const Leaving := preload("res://scripts/state/Leaving.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _club() -> Career:
	var c := Career.quick_start()
	c.seed = 11
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	Roster.sign_fighter(c, Data.PROSPECTS[0], [])
	return c


func _initialize() -> void:
	# 1. Leaving with no bout booked.
	var c := _club()
	var lucy: Dictionary = c.fighter()
	var kira: Dictionary = c.fighters[c.fighters.size() - 1]
	var kid := str(kira["id"])
	lucy["loyalty"] = 45
	c.reputation = 24
	var used := GymSpend.used(c)
	var r := Leaving.leave(c, kid)
	_check(bool(r["ok"]) and not bool(r["deferred"]), "the boxer leaves at once with no bout booked")
	_check(c.fighter_by_id(kid).is_empty(), "gone from the club's fighters")
	_check(GymSpend.used(c) == used - 1, "the place frees (%d -> %d)" % [used, GymSpend.used(c)])
	var row := c.rival(str(kira["name"]))
	_check(str(row.get("club", "")) == "Eastside ABC" and int(row.get("left", -1)) == c.day, "boxes on for Eastside ABC (%s)" % str(row.get("club", "")))
	_check(c.reputation == 22, "reputation -2 for an unranked boxer (24 -> %d)" % c.reputation)
	_check(Loyalty.value(lucy) == 43, "a team-mate under 50 minds it: 45 -> %d" % Loyalty.value(lucy))
	_check(str(c.news[0]["t"]).contains("leaves for Eastside ABC"), "the news says it (%s)" % str(c.news[0]["t"]))
	_check(not Leaving.leave(c, kid)["ok"], "a boxer already gone cannot leave twice")

	# 2. A bout inside 14 days is boxed first; the Monday after it, the boxer leaves.
	c = _club()
	kira = c.fighters[c.fighters.size() - 1]
	kid = str(kira["id"])
	kira["bout"] = {"day": c.day + 10, "done": false}
	r = Leaving.leave(c, kid)
	_check(bool(r["deferred"]) and not c.fighter_by_id(kid).is_empty(), "a bout in 10 days: boxed first, still in the club")
	_check(int(kira.get("leaves_after", -1)) == c.day + 10, "leaves after the bout day")
	c.day += 11
	Leaving.monday(c)
	_check(c.fighter_by_id(kid).is_empty(), "the Monday after the bout: gone")
	# A bout further off goes with them.
	c = _club()
	kira = c.fighters[c.fighters.size() - 1]
	kid = str(kira["id"])
	kira["bout"] = {"day": c.day + 20, "done": false}
	r = Leaving.leave(c, kid)
	_check(not bool(r["deferred"]) and c.fighter_by_id(kid).is_empty(), "a bout 20 days out is withdrawn with them")

	# 3. A professional: the manager pays the release fee, no amateur rival row, the bigger reputation cost.
	c = _club()
	kira = c.fighters[c.fighters.size() - 1]
	kid = str(kira["id"])
	kira["pro"] = true
	c.reputation = 30
	c.ledger.push_front({"d": c.day, "t": "Purse share: Kira's debut", "amount": 5000})
	var cash := c.cash
	r = Leaving.leave(c, kid)
	_check(int(r["fee"]) == 2000 and c.cash == cash + 2000, "release fee 40%% of $5,000 = $2,000 (%d)" % int(r["fee"]))
	_check(c.reputation == 25, "a professional leaving costs 5 reputation (30 -> %d)" % c.reputation)
	_check(c.rival(str(kira["name"])).is_empty(), "a professional is not an amateur rival row")
	c = _club()
	kira = c.fighters[c.fighters.size() - 1]
	kira["pro"] = true
	_check(Leaving.release_fee(c, kira) == Leaving.FEE_MIN, "no purse this year: the fee floor $500")

	# 4. Let go by the player: the smaller cost; refused while a bout is booked.
	c = _club()
	kira = c.fighters[c.fighters.size() - 1]
	kid = str(kira["id"])
	c.reputation = 24
	kira["bout"] = {"day": c.day + 5, "done": false}
	_check(str(Leaving.let_go_price(c, kid)["why_not"]) == "a bout is booked", "cannot let go with a bout booked")
	kira["bout"] = {}
	var price := Leaving.let_go_price(c, kid)
	_check(int(price["rep"]) == -1 and str(price["why_not"]) == "", "let go: reputation -1 for an unranked boxer")
	r = Leaving.let_go(c, kid)
	_check(c.fighter_by_id(kid).is_empty() and c.reputation == 23, "let go: gone, reputation 24 -> %d" % c.reputation)
	_check(str(r["line"]).contains("let go"), "the news says let go (%s)" % str(r["line"]))

	# 5. On their own: loyalty under 25 after two words, through the real day loop.
	c = _club()
	kira = c.fighters[c.fighters.size() - 1]
	kid = str(kira["id"])
	kira["loyalty"] = 30
	Loyalty.apply(kira, "wants_sponsor", c.day)          # 27
	Loyalty.apply(kira, "talk_straight_failed", c.day)   # 23, the first word under 25
	Loyalty.apply(kira, "talk_straight_failed", c.day)   # 19, the second word
	_check(Loyalty.leaves(kira, c.day), "under 25 with two words: leaves (%d)" % Loyalty.value(kira))
	var start := c.day
	while c.day < start + 8:
		Sim.step_day(c)
		c.review_pending = false
	_check(c.fighter_by_id(kid).is_empty(), "the day loop's Monday removes the boxer")
	_check(not c.fighters.is_empty(), "the gym keeps its other boxer")
	# The game runs on after a leave (a second week through the loop).
	start = c.day
	while c.day < start + 7:
		Sim.step_day(c)
		c.review_pending = false
	_check(c.day >= start + 7, "the week runs on after the leave")

	print("LEAVING %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
