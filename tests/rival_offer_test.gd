extends SceneTree
## RIVALOFFER1 - tests for rival offer pure rules: who_offers, answer, ducked, owed, owed_answer, season_reset.

var _pass := true
var _fails: int = 0

func _check(cond: bool, msg: String) -> void:
	if not cond:
		print("FAIL: %s" % msg)
		_pass = false
		_fails += 1

func _init() -> void:
	var RO := preload("res://scripts/rules/RivalOffer.gd")

	# --- Constants ---
	_check(RO.PASS_COST == 2, "PASS_COST = %d want 2" % RO.PASS_COST)
	_check(RO.COOLDOWN_WEEKS == 8, "COOLDOWN_WEEKS = %d want 8" % RO.COOLDOWN_WEEKS)
	_check(RO.OWED_SCORE == 95, "OWED_SCORE = %d want 95" % RO.OWED_SCORE)
	_check(RO.OWED_PAY == 3, "OWED_PAY = %d want 3" % RO.OWED_PAY)
	_check(RO.DUCK_WINDOW == 8, "DUCK_WINDOW = %d want 8" % RO.DUCK_WINDOW)
	_check(RO.DUCK_RANK_GAP == 8, "DUCK_RANK_GAP = %d want 8" % RO.DUCK_RANK_GAP)

	# --- who_offers: picks highest-rep eligible rival ---
	var mine := {"rep": 50, "free": true}
	var rivals := [
		{"name": "Alpha", "rep": 30, "last_offer_week": -1, "booked": false},
		{"name": "Bravo", "rep": 40, "last_offer_week": -1, "booked": false},
		{"name": "Charlie", "rep": 35, "last_offer_week": -1, "booked": false},
	]
	var w1: Dictionary = RO.who_offers(mine, rivals, 10)
	_check(w1.get("name", "") == "Bravo", "who_offers picks highest rep: got '%s' want Bravo" % w1.get("name", ""))

	# --- who_offers: skips booked rival ---
	var rivals2 := [
		{"name": "Alpha", "rep": 45, "last_offer_week": -1, "booked": true},
		{"name": "Bravo", "rep": 40, "last_offer_week": -1, "booked": false},
	]
	var w2: Dictionary = RO.who_offers(mine, rivals2, 10)
	_check(w2.get("name", "") == "Bravo", "who_offers skips booked: got '%s' want Bravo" % w2.get("name", ""))

	# --- who_offers: skips rival with rep >= mine ---
	var rivals3 := [
		{"name": "Alpha", "rep": 50, "last_offer_week": -1, "booked": false},
		{"name": "Bravo", "rep": 55, "last_offer_week": -1, "booked": false},
		{"name": "Charlie", "rep": 40, "last_offer_week": -1, "booked": false},
	]
	var w3: Dictionary = RO.who_offers(mine, rivals3, 10)
	_check(w3.get("name", "") == "Charlie", "who_offers skips above-me: got '%s' want Charlie" % w3.get("name", ""))

	# --- who_offers: skips rival out of reach ---
	# mine rep=50, reach_up(30)=16, so rival at rep 30 can reach up to 46. my_rep=50 > 46 -> out of reach.
	var mine_low := {"rep": 80, "free": true}
	var rivals4 := [
		{"name": "Alpha", "rep": 30, "last_offer_week": -1, "booked": false},
	]
	var w4: Dictionary = RO.who_offers(mine_low, rivals4, 10)
	_check(w4.is_empty(), "who_offers skips out-of-reach: got empty=%s" % str(w4.is_empty()))

	# --- who_offers: skips rival still in cooldown ---
	var rivals5 := [
		{"name": "Alpha", "rep": 40, "last_offer_week": 5, "booked": false},
	]
	var w5: Dictionary = RO.who_offers(mine, rivals5, 10)
	_check(w5.is_empty(), "who_offers skips cooling down (week 10 - last 5 = 5 < 8): empty=%s" % str(w5.is_empty()))

	# --- who_offers: allows rival after cooldown ---
	var rivals6 := [
		{"name": "Alpha", "rep": 40, "last_offer_week": 2, "booked": false},
	]
	var w6: Dictionary = RO.who_offers(mine, rivals6, 10)
	_check(w6.get("name", "") == "Alpha", "who_offers allows after cooldown (10-2=8): got '%s'" % w6.get("name", ""))

	# --- who_offers: ties by name (deterministic) ---
	var rivals7 := [
		{"name": "Zulu", "rep": 40, "last_offer_week": -1, "booked": false},
		{"name": "Alpha", "rep": 40, "last_offer_week": -1, "booked": false},
	]
	var w7: Dictionary = RO.who_offers(mine, rivals7, 10)
	_check(w7.get("name", "") == "Alpha", "who_offers tie by name: got '%s' want Alpha" % w7.get("name", ""))

	# --- who_offers: {} when none eligible ---
	var rivals8 := [
		{"name": "Alpha", "rep": 60, "last_offer_week": -1, "booked": false},
	]
	var w8: Dictionary = RO.who_offers(mine, rivals8, 10)
	_check(w8.is_empty(), "who_offers none eligible: empty=%s" % str(w8.is_empty()))

	# --- answer: accept books ---
	var st := {"free": true, "not_this_show_used": false, "week": 10}
	var a1: Dictionary = RO.answer("accept", st)
	_check(a1["booked"] == true, "accept booked=true")
	_check(a1["my_delta"] == 0, "accept my_delta=0")
	_check(a1["their_delta"] == 0, "accept their_delta=0")
	_check(a1["next_offer_week"] == 18, "accept next_offer_week=18 (10+8)")
	_check(a1["not_this_show_used"] == false, "accept does not change not_this_show_used")

	# --- answer: not_this_show free once ---
	var a2: Dictionary = RO.answer("not_this_show", st)
	_check(a2["booked"] == false, "not_this_show booked=false")
	_check(a2["not_this_show_used"] == true, "not_this_show sets used=true")
	_check(a2["my_delta"] == 0, "not_this_show my_delta=0")
	_check(a2["their_delta"] == 0, "not_this_show their_delta=0")

	# --- answer: not_this_show already used -> counts as pass ---
	var st_used := {"free": true, "not_this_show_used": true, "week": 10}
	var a3: Dictionary = RO.answer("not_this_show", st_used)
	_check(a3["my_delta"] == -2, "not_this_show already used -> pass my_delta=-2, got %d" % a3["my_delta"])
	_check(a3["their_delta"] == 2, "not_this_show already used -> pass their_delta=+2, got %d" % a3["their_delta"])
	_check(a3["next_offer_week"] == 18, "not_this_show already used -> next_offer_week=18")

	# --- answer: pass -2 / +2 ---
	var a4: Dictionary = RO.answer("pass", st)
	_check(a4["my_delta"] == -2, "pass my_delta=-2, got %d" % a4["my_delta"])
	_check(a4["their_delta"] == 2, "pass their_delta=+2, got %d" % a4["their_delta"])
	_check(a4["next_offer_week"] == 18, "pass next_offer_week=18")

	# --- answer: pass free when not free ---
	var st_busy := {"free": false, "not_this_show_used": false, "week": 10}
	var a5: Dictionary = RO.answer("pass", st_busy)
	_check(a5["my_delta"] == 0, "pass not free my_delta=0, got %d" % a5["my_delta"])
	_check(a5["their_delta"] == 0, "pass not free their_delta=0, got %d" % a5["their_delta"])

	# --- ducked: edges ---
	_check(RO.ducked(0, true, true) == true, "ducked gap=0, said_no, hot -> true")
	_check(RO.ducked(8, true, true) == true, "ducked gap=8, said_no, hot -> true")
	_check(RO.ducked(9, true, true) == false, "ducked gap=9 -> false (out of range)")
	_check(RO.ducked(-1, true, true) == false, "ducked gap=-1 -> false (she's below)")
	_check(RO.ducked(4, false, true) == false, "ducked said_yes -> false")
	_check(RO.ducked(4, true, false) == false, "ducked not hot -> false")

	# --- owed: 1 duck -> false ---
	_check(RO.owed([15], 20) == false, "owed 1 duck -> false")

	# --- owed: 2 in window -> true ---
	_check(RO.owed([15, 17], 20) == true, "owed 2 ducks in window -> true")

	# --- owed: 2 with one outside window -> false ---
	_check(RO.owed([10, 18], 20) == false, "owed 2 ducks one outside (20-10=10 >= 8) -> false")

	# --- owed: exactly at boundary ---
	# week=20, DUCK_WINDOW=8: duck at week 12 -> 20-12=8, NOT < 8 -> outside
	_check(RO.owed([12, 18], 20) == false, "owed duck at exact boundary (diff=8) -> outside")
	# duck at week 13 -> 20-13=7 < 8 -> inside
	_check(RO.owed([13, 18], 20) == true, "owed duck at week 13 (diff=7) -> inside")

	# --- owed_answer: both ways ---
	var oa1: Dictionary = RO.owed_answer(true, 50)
	_check(oa1["score"] == 95, "owed_answer owed=true score=95, got %d" % oa1["score"])
	_check(oa1["no_pays"] == 3, "owed_answer owed=true no_pays=3, got %d" % oa1["no_pays"])
	var oa2: Dictionary = RO.owed_answer(false, 50)
	_check(oa2["score"] == 50, "owed_answer owed=false score=50, got %d" % oa2["score"])
	_check(oa2["no_pays"] == 0, "owed_answer owed=false no_pays=0, got %d" % oa2["no_pays"])

	# --- season_reset: clears only not_this_show_used ---
	var rival := {"name": "Alpha", "rep": 40, "last_offer_week": 5, "not_this_show_used": true, "duck_weeks": [3, 7]}
	var sr: Dictionary = RO.season_reset(rival)
	_check(sr["not_this_show_used"] == false, "season_reset clears not_this_show_used")
	_check(sr["last_offer_week"] == 5, "season_reset keeps last_offer_week")
	_check(sr["duck_weeks"] == [3, 7], "season_reset keeps duck_weeks")
	_check(rival["not_this_show_used"] == true, "season_reset does not mutate original")

	# --- Final verdict ---
	if _pass:
		print("RIVAL_OFFER failures=0")
	else:
		print("RIVAL_OFFER failures=%d" % _fails)
	quit(0 if _pass else 1)
