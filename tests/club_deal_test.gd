extends SceneTree
## R73DEAL1: the club week's coach hours - pad places, coached mornings, Coach's evenings as pads or a class,
## and who goes short. One pure rule module (ClubDeal.gd) + this test.
## Every counter is FIGHTER-SESSIONS (asked, covered, short), never nights or hours.
## A shared morning is 2 covered, not 1. Covered pads never exceed owned.

const ClubDeal := preload("res://scripts/rules/ClubDeal.gd")
const DuesLevers := preload("res://scripts/rules/DuesLevers.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")

var failures := 0


func _initialize() -> void:
	_all_pads_8_places()
	_two_class_nights()
	_quiet_week_short()
	_covered_never_exceeds_owned()
	_nth_value()
	_holder_must_be_loyal_with_6_bouts()
	_mornings_pairing()
	_coach_order()
	_round_robin()
	_coach_evenings()
	_causes_and_words()
	_mutants()
	print("CLUB_DEAL failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _week_three(a_pads: int, b_pads: int, c_pads: int, a_mornings: Array, b_mornings: Array, c_mornings: Array) -> Dictionary:
	return {
		"fighters": [
			{"id": "A", "pads": a_pads, "mornings": a_mornings, "loyal": false, "bouts": 2, "first": false,
				"short_last_week": false, "fight_week": false, "target_day": -1},
			{"id": "B", "pads": b_pads, "mornings": b_mornings, "loyal": false, "bouts": 5, "first": false,
				"short_last_week": false, "fight_week": false, "target_day": 20},
			{"id": "C", "pads": c_pads, "mornings": c_mornings, "loyal": false, "bouts": 8, "first": false,
				"short_last_week": false, "fight_week": false, "target_day": 14},
		],
		"evenings": ["pads", "pads", "pads"],
		"own_evening": "pads",
		"holder": "",
		"cash": 1000,
		"net": -50,
	}


func _all_pads_8_places() -> void:
	var w := _week_three(3, 4, 3,
		["roadwork", "heavy_bag", "speed_bag"],
		["roadwork", "heavy_bag", "slip_rope", "shadow"],
		["roadwork", "strength", "neck"])
	var r := ClubDeal.deal(w)
	var pad_owned: int = int(r["pads"]["owned"])
	_check(pad_owned == 8, "all evenings on pads: 8 pad places (got %d)" % pad_owned)


func _two_class_nights() -> void:
	var w := _week_three(2, 2, 2,
		["roadwork", "heavy_bag"],
		["roadwork", "speed_bag"],
		["heavy_bag", "strength"])
	w["evenings"] = ["pads", "class", "class"]
	w["own_evening"] = "pads"
	var r := ClubDeal.deal(w)
	var pad_owned: int = int(r["pads"]["owned"])
	_check(pad_owned == 4, "two class nights: 4 pad places (got %d)" % pad_owned)
	var want_cash: int = 2 * roundi(float(DuesLevers.CLASS_WEEKLY) / 3.0)
	_check(int(r["cash"]) == want_cash, "cash = 2 x round(350/3) = %d (got %d)" % [want_cash, int(r["cash"])])
	_check(is_equal_approx(float(r["members_4w"]), 0.5), "members_4w = 0.5 (got %.2f)" % float(r["members_4w"]))


func _quiet_week_short() -> void:
	var w := _week_three(3, 3, 4,
		["roadwork", "heavy_bag", "speed_bag"],
		["roadwork", "slip_rope", "shadow"],
		["roadwork", "heavy_bag", "strength", "neck"])
	var r := ClubDeal.deal(w)
	var asked: int = int(r["pads"]["asked"])
	var covered: int = int(r["pads"]["covered"])
	var short: int = int(r["pads"]["short"])
	_check(asked == 10, "quiet week: 10 asked (got %d)" % asked)
	_check(covered == 8, "covered 8 (got %d)" % covered)
	_check(short == 2, "short 2 (got %d)" % short)
	# REVIEW3: words() exactly, numbers included (was: only that the three words appear).
	_check(ClubDeal.words(r) == "Pad places: 10 asked, 8 covered, 2 short", "words() line exact: '%s'" % ClubDeal.words(r))


func _covered_never_exceeds_owned() -> void:
	var rng := RandomNumberGenerator.new()
	for i in 200:
		rng.seed = i * 7919 + 31
		var a_ask: int = 1 + rng.randi() % 6
		var b_ask: int = 1 + rng.randi() % 6
		var c_ask: int = 1 + rng.randi() % 6
		var w := _week_three(a_ask, b_ask, c_ask,
			_range_sessions(a_ask, rng), _range_sessions(b_ask, rng), _range_sessions(c_ask, rng))
		# REVIEW3: class nights and a holder vary too (the delivery only ever dealt 8 places).
		w["evenings"] = [["pads", "class"][rng.randi() % 2], ["pads", "class"][rng.randi() % 2], "pads"]
		if rng.randi() % 2 == 0:
			w["fighters"][2]["loyal"] = true
			w["holder"] = "C"
		var r := ClubDeal.deal(w)
		var owned: int = int(r["pads"]["owned"])
		var covered: int = int(r["pads"]["covered"])
		var row_sum := 0
		for row in r["rows"]:
			row_sum += int(row["pads_got"])
			if int(row["pads_got"]) > ClubDeal.NTH_VALUE.size():
				_check(false, "seed %d: a 6th pad place dealt" % i)
				return
		var m_cov: int = int(r["mornings"]["covered"])
		if covered > owned or covered > int(r["pads"]["asked"]) or row_sum != covered or m_cov > 2 * ClubDeal.MORNING_SLOTS \
				or m_cov > int(r["mornings"]["asked"]):
			_check(false, "seed %d: covered %d owned %d rows %d mornings %d" % [i, covered, owned, row_sum, m_cov])
			return
	_check(true, "200 seeded weeks: covered never exceeds owned")


func _range_sessions(n: int, rng: RandomNumberGenerator) -> Array:
	const ALL := ["roadwork", "heavy_bag", "speed_bag", "slip_rope", "shadow", "strength", "neck"]
	var out: Array = []
	for i in n:
		out.append(ALL[i % ALL.size()])
	return out


func _nth_value() -> void:
	var w := _week_three(5, 1, 1,
		["roadwork", "heavy_bag", "speed_bag", "slip_rope", "shadow"],
		["roadwork"], ["heavy_bag"])
	var r := ClubDeal.deal(w)
	var rows: Array = r["rows"]
	var a_row: Dictionary = _row_by_id(rows, "A")
	var pads_got: int = int(a_row["pads_got"])
	var pads_val: float = float(a_row["pads_value"])
	_check(pads_got == 5, "A gets 5 pads (got %d)" % pads_got)
	var want_val: float = 1.0 + 1.0 + 1.0 + 0.7 + 0.5
	_check(is_equal_approx(pads_val, want_val), "5 pads value = %.1f (got %.1f)" % [want_val, pads_val])
	var w2 := _week_three(6, 1, 1,
		["roadwork", "heavy_bag", "speed_bag", "slip_rope", "shadow", "strength"],
		["roadwork"], ["heavy_bag"])
	var r2 := ClubDeal.deal(w2)
	var a2: Dictionary = _row_by_id(r2["rows"], "A")
	_check(int(a2["pads_got"]) == 5, "6th pad is never dealt (got %d)" % int(a2["pads_got"]))
	# REVIEW3: the 6th asked still counts as asked and short (the delivery capped asked at 5 while the row said short).
	_check(int(r2["pads"]["asked"]) == 8 and int(r2["pads"]["short"]) == 1 and bool(a2["short"]),
		"a 6th pad place asked: asked 8, short 1, the row short (got %d, %d)" % [int(r2["pads"]["asked"]), int(r2["pads"]["short"])])


func _holder_must_be_loyal_with_6_bouts() -> void:
	var w := _week_three(3, 3, 3,
		["roadwork", "heavy_bag", "speed_bag"],
		["roadwork", "slip_rope", "shadow"],
		["roadwork", "heavy_bag", "strength"])
	w["fighters"][2]["loyal"] = true
	w["fighters"][2]["bouts"] = 5
	w["holder"] = "C"
	var r := ClubDeal.deal(w)
	var owned: int = int(r["pads"]["owned"])
	_check(owned == 8, "loyal with 5 bouts adds nothing (owned %d)" % owned)
	var c_row: Dictionary = _row_by_id(r["rows"], "C")
	_check(not bool(c_row["holding"]), "holder with 5 bouts: holding false")
	w["fighters"][2]["bouts"] = 6
	var r2 := ClubDeal.deal(w)
	var owned2: int = int(r2["pads"]["owned"])
	_check(owned2 == 9, "loyal with 6 bouts: pool is 9 (got %d)" % owned2)
	var c2: Dictionary = _row_by_id(r2["rows"], "C")
	_check(bool(c2["holding"]), "holder with 6 bouts: holding true")
	# REVIEW3: the held place (the 9th, dealt last) is worth 0.7 to whoever TAKES it, never an extra 0.7 on the holder.
	# Coach's order here is C (target 14), B (20), A (none): C, B, A three times = 8, then the held place goes to A.
	var a2: Dictionary = _row_by_id(r2["rows"], "A")
	var b2: Dictionary = _row_by_id(r2["rows"], "B")
	_check(int(r2["pads"]["covered"]) == 9, "held place dealt: covered 9 (got %d)" % int(r2["pads"]["covered"]))
	_check(is_equal_approx(float(a2["pads_value"]), 2.7) and int(a2["pads_got"]) == 3,
		"the taker of the held place: 3 places worth 2.7 (got %d, %.2f)" % [int(a2["pads_got"]), float(a2["pads_value"])])
	_check(is_equal_approx(float(c2["pads_value"]), 3.0) and is_equal_approx(float(b2["pads_value"]), 3.0),
		"the holder gets no extra 0.7 (holder %.2f, B %.2f)" % [float(c2["pads_value"]), float(b2["pads_value"])])
	_check(not (_row_by_id(r["rows"], "C")["causes"] as Array).has("held_pads"), "5 bouts: no held_pads cause")
	_check((c2["causes"] as Array).has("held_pads"), "cause held_pads for holder")


func _mornings_pairing() -> void:
	var w := _week_three(1, 1, 1,
		["roadwork"], ["roadwork"], ["heavy_bag"])
	var r := ClubDeal.deal(w)
	var m_owned: int = int(r["mornings"]["owned"])
	var m_asked: int = int(r["mornings"]["asked"])
	var m_covered: int = int(r["mornings"]["covered"])
	_check(m_owned == 6, "mornings owned = 6 (got %d)" % m_owned)
	_check(m_asked == 3, "mornings asked = 3 (got %d)" % m_asked)
	_check(m_covered == 3, "two boxers share roadwork at 0.8 each: 3 covered (got %d)" % m_covered)
	var rows: Array = r["rows"]
	var a_row: Dictionary = _row_by_id(rows, "A")
	var b_row: Dictionary = _row_by_id(rows, "B")
	_check(is_equal_approx(float(a_row["mornings_value"]), 0.8), "A shares: morning value 0.8 (got %.1f)" % float(a_row["mornings_value"]))
	_check(is_equal_approx(float(b_row["mornings_value"]), 0.8), "B shares: morning value 0.8 (got %.1f)" % float(b_row["mornings_value"]))
	var w2 := _week_three(2, 2, 2,
		["roadwork", "roadwork"], ["roadwork", "roadwork"], ["roadwork", "roadwork"])
	var r2 := ClubDeal.deal(w2)
	var m2_covered: int = int(r2["mornings"]["covered"])
	_check(m2_covered == 6, "three boxers asking roadwork twice: all 6 asks covered (got %d)" % m2_covered)
	# REVIEW3: six slots cover 12 only when all are paired (the brief's assert; the delivery never built it).
	var six := ["s1", "s2", "s3", "s4", "s5", "s6"]
	var w3 := _week_three(1, 1, 1, six, six, ["s7"])
	var r3 := ClubDeal.deal(w3)
	_check(int(r3["mornings"]["covered"]) == 12, "six pairs: 12 fighter-sessions covered (got %d)" % int(r3["mornings"]["covered"]))
	var w4 := _week_three(1, 1, 1, six, ["t1", "t2", "t3", "t4", "t5", "t6"], ["s1"])
	var r4 := ClubDeal.deal(w4)
	_check(int(r4["mornings"]["covered"]) == 7, "pairs first: the s1 pair takes one slot, 5 singles the rest: 7 (got %d)"
		% int(r4["mornings"]["covered"]))


func _coach_order() -> void:
	var w := _week_three(3, 3, 3,
		["roadwork", "heavy_bag", "speed_bag"],
		["roadwork", "slip_rope", "shadow"],
		["roadwork", "heavy_bag", "strength"])
	w["fighters"][0]["first"] = true
	w["fighters"][1]["fight_week"] = true
	var order := ClubDeal.coach_order(w)
	var a_idx: int = order.find("A")
	var b_idx: int = order.find("B")
	_check(a_idx >= 0 and a_idx < b_idx and order.size() == 3, "first boxer (A) dealt before fight-week boxer (B) (order: %s)" % str(order))
	# REVIEW3: the tiers cascade: two fight-week boxers go by the nearer target day (C 14 before B 20), not by id.
	w["fighters"][0]["first"] = false
	w["fighters"][2]["fight_week"] = true
	_check(ClubDeal.coach_order(w) == ["C", "B", "A"], "fight weeks by nearest target: C, B, A (got %s)" % str(ClubDeal.coach_order(w)))
	var w2 := _week_three(3, 3, 3,
		["roadwork", "heavy_bag", "speed_bag"],
		["roadwork", "slip_rope", "shadow"],
		["roadwork", "heavy_bag", "strength"])
	w2["fighters"][0]["short_last_week"] = true
	var r2 := ClubDeal.deal(w2)
	var a_row: Dictionary = _row_by_id(r2["rows"], "A")
	_check(not bool(a_row["short"]), "A short last week: not short again under Coach's order (short=%s)" % str(bool(a_row["short"])))


## REVIEW3: the brief's case - 5 places (two pad evenings + a held place), two boxers asking 4 each: 3 and 2.
func _rr_week() -> Dictionary:
	return {
		"fighters": [
			{"id": "X", "pads": 4, "mornings": [], "loyal": false, "bouts": 0, "first": false,
				"short_last_week": false, "fight_week": false, "target_day": -1},
			{"id": "Y", "pads": 4, "mornings": [], "loyal": false, "bouts": 3, "first": false,
				"short_last_week": false, "fight_week": false, "target_day": -1},
			{"id": "Z", "pads": 0, "mornings": [], "loyal": true, "bouts": 9, "first": false,
				"short_last_week": false, "fight_week": false, "target_day": -1},
		],
		"evenings": ["pads", "pads", "class"],
		"own_evening": "class",
		"holder": "Z",
		"cash": 1000,
		"net": -50,
	}


func _split_ok(r: Dictionary) -> bool:
	var x: int = int(_row_by_id(r["rows"], "X")["pads_got"])
	var y: int = int(_row_by_id(r["rows"], "Y")["pads_got"])
	return x == 3 and y == 2


func _round_robin() -> void:
	var r := ClubDeal.deal(_rr_week())
	_check(int(r["pads"]["owned"]) == 5, "round-robin week: 5 places (got %d)" % int(r["pads"]["owned"]))
	_check(_split_ok(r), "round-robin: 5 places, two boxers asking 4: X 3, Y 2 (got %d and %d)"
		% [int(_row_by_id(r["rows"], "X")["pads_got"]), int(_row_by_id(r["rows"], "Y")["pads_got"])])


func _coach_evenings() -> void:
	var evs8 := ClubDeal.coach_evenings(800, -100)
	_check(evs8.count("pads") == 3, "runway 8 weeks: three pads (got %s)" % str(evs8))
	var rw: int = GymBills.runway_weeks(700, -100)
	_check(rw == 7, "test setup: runway is 7 (got %d)" % rw)
	var evs7 := ClubDeal.coach_evenings(700, -100)
	_check(evs7[0] == "class", "runway 7 weeks: first is class (got %s)" % str(evs7))
	var want_cash: int = roundi(float(DuesLevers.CLASS_WEEKLY) / 3.0)
	_check(ClubDeal.class_cash(1) == want_cash, "class_cash(1) = %d (got %d)" % [want_cash, ClubDeal.class_cash(1)])


func _causes_and_words() -> void:
	var w := _week_three(3, 3, 3,
		["roadwork", "heavy_bag", "speed_bag"],
		["roadwork", "slip_rope", "shadow"],
		["roadwork", "heavy_bag", "strength"])
	var r := ClubDeal.deal(w)
	var rows: Array = r["rows"]
	for row in rows:
		var got_pads: int = int(row["pads_got"])
		var got_morn: int = int(row["mornings_got"])
		var asked_pads: int = 3
		var asked_morn: int = 3
		var is_short: bool = bool(row["short"])
		var causes: Array = row["causes"]
		if got_pads < asked_pads or got_morn < asked_morn:
			_check(is_short, "row %s is short" % str(row["id"]))
			_check(causes.has("short") and not causes.has("full_week"), "cause 'short' only (got %s)" % str(causes))
		else:
			_check(not is_short and causes.has("full_week") and not causes.has("short"), "cause 'full_week' only (got %s)" % str(causes))
	var line: String = ClubDeal.words(r)
	_check(line.contains("asked") and line.contains("covered") and line.contains("short"),
		"words() names asked, covered, short: '%s'" % line)


## REVIEW3: each mutant now FAILS the same assert the real deal passes (_split_ok, _nth_ok), on the same week.
func _nth_ok(r: Dictionary) -> bool:
	return is_equal_approx(float(_row_by_id(r["rows"], "A")["pads_value"]), 1.0 + 1.0 + 1.0 + 0.7 + 0.5)


func _mutants() -> void:
	var w := _rr_week()
	_check(_split_ok(ClubDeal.deal(w)), "real deal passes the round-robin assert")
	var greedy_fails := not _split_ok(_mutant_deal_greedy(w))
	_check(greedy_fails, "MUTANT greedy fails the round-robin assert")
	if greedy_fails:
		print("  MUTANT caught: greedy")
	var w2 := _week_three(5, 1, 1,
		["roadwork", "heavy_bag", "speed_bag", "slip_rope", "shadow"],
		["roadwork"], ["heavy_bag"])
	_check(_nth_ok(ClubDeal.deal(w2)), "real deal passes the NTH_VALUE assert")
	var flat_fails := not _nth_ok(_mutant_deal_flat(w2))
	_check(flat_fails, "MUTANT flat fails the NTH_VALUE assert")
	if flat_fails:
		print("  MUTANT caught: flat value")


func _mutant_deal_greedy(w: Dictionary) -> Dictionary:
	var order: Array = ClubDeal.coach_order(w)
	var pad_owned: int = int(ClubDeal.deal(w)["pads"]["owned"])
	var asks: Dictionary = {}
	for f in w["fighters"]:
		asks[f["id"]] = int(f["pads"])
	var got: Dictionary = {}
	for fid in order:
		got[fid] = 0
	var remaining: int = pad_owned
	for fid in order:
		while got[fid] < asks[fid] and remaining > 0:
			got[fid] += 1
			remaining -= 1
	var rows: Array = []
	for f in w["fighters"]:
		var fid: String = str(f["id"])
		var g: int = int(got.get(fid, 0))
		var val: float = 0.0
		for i in g:
			val += ClubDeal.NTH_VALUE[mini(i, ClubDeal.NTH_VALUE.size() - 1)]
		rows.append({"id": fid, "pads_got": g, "pads_value": val, "mornings_got": 0, "mornings_value": 0.0,
			"short": g < int(f["pads"]), "holding": false, "causes": []})
	return {"pads": {"owned": pad_owned, "asked": _sum_asks(w), "covered": mini(_sum_asks(w), pad_owned), "short": maxi(0, _sum_asks(w) - pad_owned)},
		"mornings": {"owned": 6, "asked": 0, "covered": 0, "short": 0}, "cash": 0, "members_4w": 0.0, "rows": rows}


func _mutant_deal_flat(w: Dictionary) -> Dictionary:
	var order: Array = ClubDeal.coach_order(w)
	var pad_owned: int = int(ClubDeal.deal(w)["pads"]["owned"])
	var asks: Dictionary = {}
	for f in w["fighters"]:
		asks[f["id"]] = int(f["pads"])
	var got: Dictionary = {}
	for fid in order:
		got[fid] = 0
	var remaining: int = pad_owned
	var idx: int = 0
	while remaining > 0:
		var fid: String = str(order[idx % order.size()])
		if got[fid] < asks[fid]:
			got[fid] += 1
			remaining -= 1
		idx += 1
		if idx > order.size() * 10:
			break
	var rows: Array = []
	for f in w["fighters"]:
		var fid: String = str(f["id"])
		var g: int = int(got.get(fid, 0))
		var val: float = float(g)
		rows.append({"id": fid, "pads_got": g, "pads_value": val, "mornings_got": 0, "mornings_value": 0.0,
			"short": g < int(f["pads"]), "holding": false, "causes": []})
	return {"pads": {"owned": pad_owned, "asked": _sum_asks(w), "covered": mini(_sum_asks(w), pad_owned), "short": maxi(0, _sum_asks(w) - pad_owned)},
		"mornings": {"owned": 6, "asked": 0, "covered": 0, "short": 0}, "cash": 0, "members_4w": 0.0, "rows": rows}


func _sum_asks(w: Dictionary) -> int:
	var total := 0
	for f in w["fighters"]:
		total += int(f["pads"])
	return total


func _row_by_id(rows: Array, fid: String) -> Dictionary:
	for r in rows:
		if str(r["id"]) == fid:
			return r
	return {}


func _check(ok: bool, label: String) -> void:
	if ok:
		print("  PASS  ", label)
	else:
		failures += 1
		print("  FAIL  ", label)
