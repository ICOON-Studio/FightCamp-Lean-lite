extends SceneTree
## S382 G3 (gym idea 4): the sparring nights are the Playbook tests (scripts/rules/SparNights.gd, PlanTest, WeekStrip).
##   1. Pure: 25 days out from a Monday = Build Thu + Build Thu + Peak Tue/Thu + no taper night = 4; a 2-week camp = 2;
##      fight week = none; a night gone this week is not counted; her own sparring count rules this week; used nights leave.
##   2. The strip cell a night falls in (to_go), and the tests counted per cell.
##   3. The button: "Test it - Thu spar night (4 left)", then the next free night; none left reads so.
##   4. The range: club mates +-4, the partner who matches her +-2 (one who does not match: still +-4), her file open +-1;
##      a real test on the partner camp shows a 4-wide range holding the true count and takes the first spar night.
##   5. The weeks strip darkens the used glove pip in the right cell.
## Population: Lucy Jackson (Data.lucy) vs Maria Ortega (Data.OPPONENTS[0], southpaw pressure fighter - the partner
## matches her) and Priya Nair (Data.OPPONENTS[1], orthodox counter-puncher - a sparring mate, no match).

const Data := preload("res://scripts/state/Data.gd")
const PlanTest := preload("res://scripts/state/PlanTest.gd")
const SparNights := preload("res://scripts/rules/SparNights.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const WeekStrip := preload("res://scripts/ui/WeekStrip.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const MON := 28   # day 28 is a Monday (Clock.DAYS[posmod(28, 7)])

var _fails := 0


func _initialize() -> void:
	_pure()
	_button()
	_range()
	_strip()
	print("SPAR_NIGHTS %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _pure() -> void:
	_check(Clock.DAYS[posmod(MON, 7)] == "Mon", "day 28 is a Monday")
	var n := SparNights.nights({"day": MON + 25}, MON)
	_check(n == [MON + 3, MON + 10, MON + 15, MON + 17], "25 days out: Thu, Thu, Peak Tue + Thu = 4 (%s)" % str(n))
	_check(SparNights.nights({"day": MON + 14}, MON).size() == 2, "a 2-week camp: the Peak week's 2")
	_check(SparNights.nights({"day": MON + 5}, MON).is_empty(), "fight week: no spar night")
	_check(SparNights.nights({"day": MON + 25, "done": true}, MON).is_empty() and SparNights.nights({}, MON).is_empty(),
		"no bout (or it is fought): no spar night")
	_check(SparNights.nights({"day": MON + 25}, MON + 4) == [MON + 10, MON + 15, MON + 17], "Friday: this Thursday is gone")
	_check(SparNights.nights({"day": MON + 25}, MON + 3).has(MON + 3), "Thursday: tonight still counts")
	_check(SparNights.nights({"day": MON + 25}, MON, "build", 0).size() == 3, "she dropped this week's spar night: 3")
	_check(SparNights.nights({"day": MON + 25}, MON, "build", 2) == [MON + 1, MON + 3, MON + 10, MON + 15, MON + 17],
		"she spars twice this week: 5")
	_check(SparNights.unused(n, [MON + 3]) == [MON + 10, MON + 15, MON + 17], "a used night leaves the free ones")
	var bd := MON + 25
	_check(SparNights.to_go(bd, MON + 3) == 4 and SparNights.to_go(bd, MON + 10) == 3 and SparNights.to_go(bd, MON + 15) == 2
		and SparNights.to_go(bd, MON + 17) == 2, "each night falls in its strip cell (4, 3, 2, 2)")
	_check(SparNights.used_in(bd, [MON + 15, MON + 17], 2) == 2 and SparNights.used_in(bd, [MON + 15], 4) == 0,
		"tests counted per cell")


func _button() -> void:
	var f := {"first": "Lucy", "bout": {"day": MON + 25, "opp": {}}}
	_check(PlanTest.button(f, MON) == "Test it - Thu spar night (4 left)", "the button: '%s'" % PlanTest.button(f, MON))
	f["bout"]["plan_test_nights"] = [MON + 3, MON + 10]
	_check(PlanTest.button(f, MON) == "Test it - Tue spar night (2 left)" and PlanTest.next_night(f, MON) == MON + 15,
		"two used: the Peak Tuesday is next ('%s')" % PlanTest.button(f, MON))
	var fw := {"first": "Lucy", "bout": {"day": MON + 5, "opp": {}}}
	_check(PlanTest.left(fw, MON) == 0 and PlanTest.button(fw, MON) == "Test it - no spar night left", "fight week: greyed words")


func _range() -> void:
	var maria: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var priya: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)
	_check(PlanTest._spread(maria, {}) == PlanTest.SPREAD_UNSEEN and PlanTest.SPREAD_UNSEEN == 4, "club mates: +-4")
	_check(PlanTest._spread(maria, {"partner": true}) == PlanTest.SPREAD_PARTNER and PlanTest.SPREAD_PARTNER == 2,
		"the southpaw mate who matches Maria: +-2")
	_check(PlanTest._spread(priya, {"partner": true}) == PlanTest.SPREAD_UNSEEN, "a mate who does not match Priya: still +-4")
	var open := maria.duplicate(true)
	OppFile.open_all(open)
	_check(PlanTest._spread(open, {}) == PlanTest.SPREAD_SEEN and PlanTest._spread(open, {"partner": true}) == PlanTest.SPREAD_SEEN,
		"her file open: +-1 either way")
	var c := Career.quick_start()
	c.seed = 382
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = MON
	var f: Dictionary = c.fighter()
	f["combos"] = {"1-1": 50.0, "1-2": 50.0}
	f["camp"] = {"focus": "conditioning", "protocol": 1, "film": false, "partner": true, "start": MON}
	f["bout"] = {"opp": maria, "day": MON + 25, "weighed": true, "made": true, "done": false, "film": 1}
	var r := PlanTest.run(c, f, GOOD)
	_check(bool(r["ok"]) and int(r["hi"]) - int(r["lo"]) == 2 * PlanTest.SPREAD_PARTNER and int(r["lo"]) <= int(r["wins"])
		and int(r["wins"]) <= int(r["hi"]), "a test with the matching mate: %d-%d holds %d" % [r.get("lo", -1), r.get("hi", -1), r.get("wins", -1)])
	_check(int(r["night"]) == MON + 3 and int(r["left"]) == 3 and f["bout"]["plan_test_nights"] == [MON + 3],
		"the test took Thursday's spar night; 3 left")


func _strip() -> void:
	var f: Dictionary = Data.fighter_state(Data.lucy(), MON)
	var opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	f["bout"] = {"opp": opp, "day": MON + 25, "plan_test_nights": [MON + 3, MON + 15]}
	var s := WeekStrip.make(f, opp, MON + 25, MON, MON, "power", false)
	var used := {}
	for to_go in [4, 3, 2, 1]:
		var b := s.find_child("Week_%d" % to_go, false, false)
		used[to_go] = int(b.find_child("Pips", true, false).get("used")) if b != null else -1
	_check(used == {4: 1, 3: 0, 2: 1, 1: 0}, "the strip darkens the used pips: this week 1, Peak 1 of 2 (%s)" % str(used))
	s.free()


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
