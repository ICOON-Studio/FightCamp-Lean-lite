extends SceneTree
## S543 TURNPROBUILD17 step 5: the walk of turning pro v17 through the game's own state (map DESIGN_TURNPRO1_V17.md, the
## owner's Q-S294-320 "Yes, build it" and Q-S294-323 "Yes, build v17 now"). Written first, red on the branch before step 2.
## Walk 1: a career reaches the offer; Not yet (a mark gone, hunger 55, the offer back four weeks later, no morale, loyalty
## or wins added); Not yet again; the rival gym's call; Turn pro now; the debut booking shows two bouts with both chances
## inside their bands; the risky bout is fought; the result page carries the bar line; bookings 2-6 offer two bouts; the
## booking after fight 6 is the normal one (ProLadder's offers). Save and load keep the state.
## Walk 2: six safe wins take hunger 70 -> 10; a boxer at 0 gets two warnings at two bookings, then leaves at the third.
## Walk 3: refusing the rival gym's call sends the boxer away for good (the game's leaving path, one news line).
## Prints TURNPRO17_WALK failures=<n>.

const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const ProStart := preload("res://scripts/rules/ProStart.gd")
const ProPair := preload("res://scripts/state/ProPair.gd")
const ResultPage := preload("res://scripts/ui/ResultPage.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _career(seed_value: int) -> Career:
	var c := Career.quick_start()
	c.seed = seed_value
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["w"] = 9
	f["l"] = 1
	f["offers"] = []
	f["loyalty"] = 60
	return c


func _fight(c: Career, f: Dictionary) -> Dictionary:
	f["bout"]["day"] = c.day
	f["bout"]["weighed"] = true
	f["bout"]["made"] = true
	var m := {"fid": f["id"], "step": "tape", "total": int(f["bout"].get("rounds", 4))}
	Bouts.fight_step(c, f, m, "sim")
	Bouts.after_fight(c, f)
	return m


func _days_until(c: Career, cond: Callable, most: int) -> int:
	for i in most:
		if cond.call():
			return i
		Sim.step_day(c)
		c.review_pending = false
	return -1


func _in(x: float, band: Vector2) -> bool:
	return x >= band.x - 0.0001 and x <= band.y + 0.0001


func _pair_ok(c: Career, f: Dictionary, n: int) -> bool:
	var p: Dictionary = f.get("pro_pair", {})
	if p.is_empty() or int(p.get("fight", 0)) != n:
		return false
	var ok := true
	var coach := float(c.coach.get("rating", 0.0))
	for kind in ProStart.KINDS:
		var b: Dictionary = p[kind]
		var band: Vector2 = ProStart.SAFE_BAND if kind == "safe" else ProStart.RISKY_BAND
		ok = ok and _in(float(b["raw"]), band) and absf(float(b["chance"]) - float(b["raw"])) <= ProStart.CONF_SHIFT_MAX + 0.02
		ok = ok and is_equal_approx(float(b["chance"]), ProPair.read(f, b["opp"], coach, float(b["edge"])))
		ok = ok and int(b["name"]) == ProStart.name_gain(kind) and str(b["opp"]["name"]) != ""
	return ok and str(p["safe"]["opp"]["name"]) != str(p["risky"]["opp"]["name"])


func _initialize() -> void:
	_walk_one()
	_walk_hunger()
	_walk_rival_refused()
	print("TURNPRO17_WALK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _walk_one() -> void:
	var c := _career(7)
	var f: Dictionary = c.fighter()
	Roster.check_pro(c)
	_check(not c.pro_offer.is_empty() and not bool(c.pro_offer.get("rival", false)), "at 9-1 the promoter calls")
	_check(f.has("pro_start") and int(f["pro_start"]["patience"]) == 3, "the boxer carries the pro start state from the first offer, three marks")
	_check(not c.pro_offer.has("offers") and not c.pro_offer.has("asked"), "one promoter, one offer: no two houses, no asks")
	var p_now: Dictionary = c.pro_offer.get("pair_now", {})
	var p_later: Dictionary = c.pro_offer.get("pair_later", {})
	_check(not p_now.is_empty() and not p_later.is_empty(), "the offer carries fight 1's two chances today and four weeks on")
	# Not yet, once
	var morale := float(f.get("morale", 0.0))
	var loyalty := int(f.get("loyalty", 0))
	var wins := int(f["w"])
	var day0 := c.day
	Roster.decline_pro(c)
	var s: Dictionary = f["pro_start"]
	_check(int(s["patience"]) == 2 and int(s["hunger"]) == 55, "Not yet: a mark gone, hunger 55 (%d, %d)" % [int(s["patience"]), int(s["hunger"])])
	_check(is_equal_approx(float(f.get("morale", 0.0)), morale) and int(f.get("loyalty", 0)) == loyalty and int(f["w"]) == wins,
		"Not yet costs no morale, no loyalty and moves no line")
	_check(c.pro_offer.is_empty(), "the offer goes for now")
	c.day = day0 + ProStart.NOT_YET_WEEKS * 7 - 1
	Roster.check_pro(c)
	_check(c.pro_offer.is_empty(), "no call before four weeks")
	c.day = day0 + ProStart.NOT_YET_WEEKS * 7
	Roster.check_pro(c)
	_check(not c.pro_offer.is_empty() and not bool(c.pro_offer.get("rival", false)), "the offer is back four weeks later")
	# Not yet, twice
	var day1 := c.day
	Roster.decline_pro(c)
	_check(int(s["patience"]) == 1 and int(s["hunger"]) == 40, "the second Not yet: one mark left, hunger 40")
	c.day = day1 + ProStart.NOT_YET_WEEKS * 7
	Roster.check_pro(c)
	_check(bool(c.pro_offer.get("rival", false)), "the third call is the rival gym's")
	Roster.decline_pro(c)
	_check(not c.pro_offer.is_empty() and int(s["patience"]) == 1, "no Not yet on the rival gym's call")
	# Save and load keep the state
	var c2 := SaveGame.from_dict(JSON.parse_string(JSON.stringify(SaveGame.to_dict(c))))
	var f2: Dictionary = c2.fighter_by_id(str(f["id"]))
	_check(int(f2.get("pro_start", {}).get("patience", 0)) == 1 and int(f2["pro_start"]["hunger"]) == 40 and bool(c2.pro_offer.get("rival", false)),
		"save and load keep the marks, the hunger and the rival call")
	# Turn pro now
	Roster.turn_pro(c)
	_check(bool(f.get("pro", false)) and (f["bout"] as Dictionary).is_empty(), "turned pro; nothing booked before the pick")
	_check(_pair_ok(c, f, 1), "the debut booking offers two bouts, both chances inside their bands")
	var p1: Dictionary = f["pro_pair"]
	_check(int(p1["risky"]["purse"]) == ProStart.purse(Roster.PRO_PURSE, "risky") and int(p1["safe"]["purse"]) == Roster.PRO_PURSE,
		"the purses: safe %d, risky %d" % [int(p1["safe"]["purse"]), int(p1["risky"]["purse"])])
	var rep := c.reputation
	_check(ProPair.book(c, f, "risky"), "the risky bout is booked")
	_check(str(f["bout"].get("pair_kind", "")) == "risky" and int(f["bout"]["rounds"]) == 4 and int(f["bout"]["purse"]) == int(p1["risky"]["purse"]),
		"the booked bout is the risky one, four rounds, its purse")
	_check(int(f["bout"]["day"]) == Roster.debut_day(c.day) or int(f["bout"]["day"]) >= c.day + 7, "the debut is about four weeks out")
	var m := _fight(c, f)
	_check(int(s["fights"]) == 1, "the debut counts as fight 1 of six")
	var line := str(m.get("bar_line", ""))
	_check(line.contains("Hunger") and line.contains("→"), "the fight's bar line: %s" % line)
	var row := ResultPage.bar_row(m)
	_check(row != null and str(row.get("text") if row is Label else row.find_child("BarLine", true, false).text).contains("Hunger"), "the result page carries the bar line")
	if row != null:
		row.free()
	var won := str(m.get("outcome", "")) == "win"
	_check(not won or c.reputation >= rep + ProStart.name_gain("risky"), "a risky win adds the name to the gym's reputation (%d -> %d)" % [rep, c.reputation])
	# bookings 2-6
	for n in range(2, 7):
		var waited := _days_until(c, func(): return not (f.get("pro_pair", {}) as Dictionary).is_empty() or not c.fighters.has(f), 20)
		if not c.fighters.has(f):
			_check(false, "the boxer left before fight %d" % n)
			return
		_check(waited >= 0 and _pair_ok(c, f, n), "booking %d offers two bouts" % n)
		_check((f.get("pro_offers", []) as Array).is_empty(), "booking %d: no ladder offers beside the pair" % n)
		ProPair.book(c, f, "safe")
		_fight(c, f)
	_check(not ProStart.on(s), "after fight 6 the two-bout booking is over")
	var normal := _days_until(c, func(): return not (f.get("pro_offers", []) as Array).is_empty(), 90)
	_check(normal >= 0 and (f.get("pro_pair", {}) as Dictionary).is_empty(), "the booking after fight 6 is the normal one (%d days)" % normal)


func _walk_hunger() -> void:
	var c := _career(21)
	var f: Dictionary = c.fighter()
	Roster.check_pro(c)
	Roster.turn_pro(c)
	var s: Dictionary = f["pro_start"]
	for i in 6:
		ProStart.after_fight(s, "safe", "win")
	_check(int(s["hunger"]) == 10, "six safe wins take hunger 70 -> 10 (%d)" % int(s["hunger"]))
	var c2 := _career(22)
	var g: Dictionary = c2.fighter()
	Roster.check_pro(c2)
	Roster.turn_pro(c2)
	ProPair.book(c2, g, "safe")
	g["pro_start"]["hunger"] = 0
	ProPair.after_bout(c2, g, "safe", "points")
	g["bout"] = {}
	c2.day += 1
	ProPair.day_events(c2)
	_check(int(g["pro_start"]["warn"]) == 1 and c2.fighters.has(g) and not (g.get("pro_pair", {}) as Dictionary).is_empty(), "hunger 0: the first warning, the booking still comes")
	_check(ProPair.warning_line(g).contains("1 of 2"), "the boxer card's warning: %s" % ProPair.warning_line(g))
	ProPair.book(c2, g, "safe")
	ProPair.after_bout(c2, g, "safe", "points")
	g["bout"] = {}
	c2.day += 1
	ProPair.day_events(c2)
	_check(int(g["pro_start"]["warn"]) == 2 and c2.fighters.has(g), "the second warning")
	ProPair.book(c2, g, "safe")
	ProPair.after_bout(c2, g, "safe", "points")
	g["bout"] = {}
	c2.day += 1
	ProPair.day_events(c2)
	_check(not c2.fighters.has(g), "the third booking at 0: the boxer is gone")


func _walk_rival_refused() -> void:
	var c := _career(33)
	var f: Dictionary = c.fighter()
	Roster.check_pro(c)
	f["pro_start"]["patience"] = 1
	c.pro_offer = {}
	Roster.check_pro(c)
	_check(bool(c.pro_offer.get("rival", false)), "with no mark left the call is the rival gym's")
	var news := c.news.size()
	Roster.refuse_rival(c)
	_check(not c.fighters.has(f) and c.pro_offer.is_empty(), "Let the boxer go: the boxer leaves for good")
	_check(c.news.size() == news + 1, "one news line (%d new)" % (c.news.size() - news))
