extends SceneTree
## TASK DEALBLIND1: blind contract test for the club week's coached-morning deal (CoachedMornings).
## Written from the CONTRACT in ops/research/TASK_DEALBLIND1.md and the ## header comments plus
## CONSTANTS of scripts/rules/CoachedMornings.gd only. The function bodies and
## tests/coached_mornings_test.gd, tests/morning_deal_test.gd, tests/club_deal_test.gd and
## scripts/state/MorningWire.gd were not read. Where the code disagrees with the contract, one of
## the two is wrong; any such check is kept and reported, not weakened.

const CM := preload("res://scripts/rules/CoachedMornings.gd")
const EPS := 0.001
const STATS_B := {"power": 20.0, "speed": 21.0, "technique": 22.0, "defense": 23.0, "conditioning": 24.0, "fight_iq": 25.0}
const STATS_C := {"power": 25.0, "speed": 24.0, "technique": 23.0, "defense": 22.0, "conditioning": 21.0, "fight_iq": 20.0}
const STATS_WEAK_POWER := {"power": 10.0, "speed": 20.0, "technique": 20.0, "defense": 20.0, "conditioning": 20.0, "fight_iq": 20.0}
const STATS_P := {"power": 10.0, "speed": 20.0, "technique": 30.0, "defense": 40.0, "conditioning": 50.0, "fight_iq": 60.0}
const STATS_Q := {"power": 15.0, "speed": 25.0, "technique": 35.0, "defense": 45.0, "conditioning": 55.0, "fight_iq": 65.0}
const STATS_R := {"power": 5.0, "speed": 20.0, "technique": 30.0, "defense": 40.0, "conditioning": 50.0, "fight_iq": 60.0}
const STATS_S := {"power": 25.0, "speed": 12.0, "technique": 30.0, "defense": 40.0, "conditioning": 50.0, "fight_iq": 60.0}
const STATS_T := {"power": 10.0, "speed": 60.0, "technique": 20.0, "defense": 30.0, "conditioning": 40.0, "fight_iq": 50.0}
const STATS_WEAK_TECH := {"power": 20.0, "speed": 20.0, "technique": 10.0, "defense": 20.0, "conditioning": 20.0, "fight_iq": 20.0}
const STATS_WEAK_SPEED := {"power": 20.0, "speed": 10.0, "technique": 20.0, "defense": 20.0, "conditioning": 20.0, "fight_iq": 20.0}

var failures: int = 0

func _initialize() -> void:
	_test_weak_spot()
	_test_shared_focus()
	_test_owned_and_small()
	_test_two_no_overlap()
	_test_shared()
	_test_one_shared()
	_test_shared_priority()
	_test_weak_solo()
	_test_four_fulltime()
	_test_empty_boxer()
	_test_day_mult_tile()
	_test_deterministic()
	if failures == 0:
		print("DEAL_CONTRACT PASS fails=0")
	else:
		print("DEAL_CONTRACT FAIL fails=%d" % failures)
	quit(1 if failures > 0 else 0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("ok  " + label)
	else:
		failures += 1
		print("FAIL " + label)

func _close(a: float, b: float) -> bool:
	return absf(a - b) < EPS

func _row(id: String, stats: Dictionary, days: Array) -> Dictionary:
	return {"id": id, "stats": stats, "days": days}

func _entry(d: Dictionary, id: String, dow: String) -> Dictionary:
	if not d.has(id):
		return {}
	var e: Dictionary = d[id]
	if not e.has(dow):
		return {}
	return e[dow]

func _shared_count(entry: Dictionary) -> int:
	var n: int = 0
	for k in entry:
		var m: Dictionary = entry[k]
		if String(m.get("use", "")) == "shared":
			n += 1
	return n

func _solo_count(entry: Dictionary) -> int:
	var n: int = 0
	for k in entry:
		var m: Dictionary = entry[k]
		if String(m.get("use", "")) == "solo":
			n += 1
	return n

func _count_mult(entry: Dictionary, target: float) -> int:
	var n: int = 0
	for k in entry:
		var m: Dictionary = entry[k]
		if _close(float(m.get("mult", 0.0)), target):
			n += 1
	return n

func _shared_dow(entry: Dictionary) -> String:
	for k in entry:
		var m: Dictionary = entry[k]
		if String(m.get("use", "")) == "shared":
			return String(k)
	return ""

func _slots(d: Dictionary) -> int:
	var solos: int = 0
	var shareds: int = 0
	for id in d:
		var e: Dictionary = d[id]
		solos += _solo_count(e)
		shareds += _shared_count(e)
	return solos + int(shareds / 2)

func _invariants(d: Dictionary, rows: Array, expected_slots: int, label: String) -> void:
	var ids: Array = []
	var days_of: Dictionary = {}
	var stats_of: Dictionary = {}
	for r in rows:
		var row: Dictionary = r
		ids.append(String(row["id"]))
		days_of[String(row["id"])] = row["days"]
		stats_of[String(row["id"])] = row["stats"]
	var keys_ok: bool = true
	for id in ids:
		if not d.has(id):
			keys_ok = false
	_check(keys_ok, label + ": key for every row id")
	var shape_ok: bool = true
	var trained_ok: bool = true
	var mult_ok: bool = true
	var mate_ok: bool = true
	var one_shared_ok: bool = true
	for id in ids:
		if not d.has(id):
			continue
		var e: Dictionary = d[id]
		if _shared_count(e) > 1:
			one_shared_ok = false
		var days: Array = days_of[id]
		var weak: String = CM.weak_spot(stats_of[id])
		for dow in e:
			if typeof(dow) != TYPE_STRING:
				shape_ok = false
			var ds: String = String(dow)
			if not ["0", "1", "2", "3", "4", "5", "6"].has(ds):
				shape_ok = false
			var m: Dictionary = e[dow]
			if not (m.has("use") and m.has("mult") and m.has("ability") and m.has("mate")):
				shape_ok = false
			var ab: String = String(m.get("ability", ""))
			if ab == "":
				trained_ok = false
			if int(ds) < 0 or int(ds) > 6:
				trained_ok = false
			elif ab != String(days[int(ds)]):
				trained_ok = false
			var use: String = String(m.get("use", ""))
			if use == "solo":
				if String(m.get("mate", "")) != "":
					mate_ok = false
				var want: float = 1.4 if (weak != "" and ab == weak) else 1.25
				if not _close(float(m.get("mult", 0.0)), want):
					mult_ok = false
			elif use == "shared":
				if not _close(float(m.get("mult", 0.0)), 1.15):
					mult_ok = false
				var mate: String = String(m.get("mate", ""))
				if not ids.has(mate) or mate == id:
					mate_ok = false
				else:
					var me: Dictionary = d[mate]
					if not me.has(ds):
						mate_ok = false
					else:
						var mm: Dictionary = me[ds]
						if String(mm.get("ability", "")) != ab or String(mm.get("mate", "")) != id or String(mm.get("use", "")) != "shared":
							mate_ok = false
			else:
				shape_ok = false
	_check(shape_ok, label + ": entries have use/mult/ability/mate, dow Strings 0..6")
	_check(trained_ok, label + ": only trained mornings dealt, ability matches days")
	_check(mult_ok, label + ": solo x1.25 (x1.4 on weak spot), shared x1.15")
	_check(mate_ok, label + ": shared mates name each other, solo mate empty")
	_check(one_shared_ok, label + ": at most one shared per boxer")
	_check(_slots(d) == expected_slots, label + ": slots used == %d" % expected_slots)

func _test_weak_spot() -> void:
	_check(CM.weak_spot(STATS_WEAK_POWER) == "power", "weak_spot: clear hole is power")
	_check(CM.weak_spot(STATS_B) == "", "weak_spot: gap 2.5 is no hole")
	_check(CM.weak_spot(STATS_C) == "", "weak_spot: mirrored gap 2.5 is no hole")
	_check(CM.weak_spot({"power": 10.0, "speed": 14.0, "technique": 14.0, "defense": 14.0, "conditioning": 14.0, "fight_iq": 12.0}) == "power", "weak_spot: exactly WEAK_GAP below mean counts")
	_check(CM.weak_spot({"power": 10.0, "speed": 14.0, "technique": 14.0, "defense": 14.0, "conditioning": 13.0, "fight_iq": 12.0}) == "", "weak_spot: just under WEAK_GAP is no hole")
	_check(CM.weak_spot({"power": 0.0, "speed": 5.0, "technique": 20.0, "defense": 20.0, "conditioning": 20.0, "fight_iq": 20.0}) == "power", "weak_spot: lowest ability wins")
	_check(CM.weak_spot({"power": 20.0, "speed": 20.0, "technique": 20.0, "defense": 20.0, "conditioning": 20.0, "fight_iq": 20.0}) == "", "weak_spot: level six is no hole")

func _test_shared_focus() -> void:
	var f1: Dictionary = CM.shared_focus(STATS_P, STATS_Q)
	_check(String(f1.get("ability", "")) == "power" and _close(float(f1.get("a", -1.0)), 10.0) and _close(float(f1.get("b", -1.0)), 15.0), "shared_focus: both rank power lowest")
	var f2: Dictionary = CM.shared_focus(STATS_Q, STATS_P)
	_check(String(f2.get("ability", "")) == "power" and _close(float(f2.get("a", -1.0)), 15.0) and _close(float(f2.get("b", -1.0)), 10.0), "shared_focus: a and b follow argument order")
	var f3: Dictionary = CM.shared_focus(STATS_R, STATS_S)
	_check(String(f3.get("ability", "")) == "power" and _close(float(f3.get("a", -1.0)), 5.0) and _close(float(f3.get("b", -1.0)), 25.0), "shared_focus: rank tie broken by lower summed value")
	_check(CM.shared_focus({}, STATS_P).is_empty(), "shared_focus: no stats a is {}")
	_check(CM.shared_focus(STATS_P, {}).is_empty(), "shared_focus: no stats b is {}")
	_check(CM.shared_focus({}, {}).is_empty(), "shared_focus: no stats either is {}")

func _test_owned_and_small() -> void:
	_check(CM.owned("sessional") == 6, "owned: sessional is 6")
	_check(CM.owned("full_time") == 7, "owned: full_time is 7")
	_check(CM.owned("none") == 4, "owned: none is 4")
	_check(CM.week_deal([], "sessional") == {}, "week_deal: no rows is {}")
	var one: Array = [_row("ana", STATS_B, ["power", "speed", "technique", "defense", "conditioning", "fight_iq", ""])]
	_check(CM.week_deal(one, "sessional") == {}, "week_deal: one boxer is {} (sessional)")
	_check(CM.week_deal(one, "full_time") == {}, "week_deal: one boxer is {} (full_time)")
	_check(CM.week_deal(one, "none") == {}, "week_deal: one boxer is {} (none)")

func _test_two_no_overlap() -> void:
	var rows: Array = [
		_row("ana", STATS_B, ["power", "speed", "technique", "defense", "conditioning", "fight_iq", ""]),
		_row("bea", STATS_C, ["speed", "technique", "power", "fight_iq", "defense", "conditioning", ""]),
	]
	var d: Dictionary = CM.week_deal(rows, "sessional")
	_invariants(d, rows, 6, "two-no-overlap")
	_check(_solo_count(d["ana"]) == 3 and _solo_count(d["bea"]) == 3, "two-no-overlap: three solos each")
	_check(_shared_count(d["ana"]) == 0 and _shared_count(d["bea"]) == 0, "two-no-overlap: no shared without overlap")
	_check(String(_entry(d, "ana", "0").get("ability", "")) == "power", "two-no-overlap: ana solo on lowest power dow0")
	_check(String(_entry(d, "ana", "1").get("ability", "")) == "speed", "two-no-overlap: ana second solo speed dow1")
	_check(String(_entry(d, "ana", "2").get("ability", "")) == "technique", "two-no-overlap: ana third solo technique dow2")
	_check(String(_entry(d, "bea", "3").get("ability", "")) == "fight_iq", "two-no-overlap: bea solo on lowest fight_iq dow3")
	_check(String(_entry(d, "bea", "5").get("ability", "")) == "conditioning", "two-no-overlap: bea second solo conditioning dow5")
	_check(String(_entry(d, "bea", "4").get("ability", "")) == "defense", "two-no-overlap: bea third solo defense dow4")
	_check(not d["ana"].has("6") and not d["bea"].has("6"), "two-no-overlap: rest day dow6 never dealt")

func _test_shared() -> void:
	var rows: Array = [
		_row("ana", STATS_P, ["power", "speed", "technique", "defense", "conditioning", "fight_iq", ""]),
		_row("bea", STATS_Q, ["power", "technique", "speed", "fight_iq", "defense", "conditioning", ""]),
	]
	var d: Dictionary = CM.week_deal(rows, "sessional")
	_invariants(d, rows, 6, "shared")
	var a0: Dictionary = _entry(d, "ana", "0")
	_check(String(a0.get("use", "")) == "shared" and _close(float(a0.get("mult", 0.0)), 1.15) and String(a0.get("ability", "")) == "power" and String(a0.get("mate", "")) == "bea", "shared: ana dow0 shared power with bea")
	var b0: Dictionary = _entry(d, "bea", "0")
	_check(String(b0.get("use", "")) == "shared" and _close(float(b0.get("mult", 0.0)), 1.15) and String(b0.get("ability", "")) == "power" and String(b0.get("mate", "")) == "ana", "shared: bea dow0 shared power with ana")
	_check(_solo_count(d["ana"]) == 3 and _solo_count(d["bea"]) == 2, "shared: solos fill remaining slots")
	_check(String(_entry(d, "ana", "1").get("ability", "")) == "speed", "shared: ana solo speed dow1 (power taken)")
	_check(String(_entry(d, "bea", "2").get("ability", "")) == "speed", "shared: bea solo speed dow2")

func _test_one_shared() -> void:
	var rows: Array = [
		_row("ana", STATS_P, ["power", "power", "speed", "technique", "defense", "conditioning", "fight_iq"]),
		_row("bea", STATS_Q, ["power", "power", "technique", "speed", "fight_iq", "defense", "conditioning"]),
	]
	var d: Dictionary = CM.week_deal(rows, "sessional")
	_invariants(d, rows, 6, "one-shared")
	_check(_shared_count(d["ana"]) == 1, "one-shared: ana has exactly one shared")
	_check(_shared_count(d["bea"]) == 1, "one-shared: bea has exactly one shared")
	var sd: String = _shared_dow(d["ana"])
	_check(sd != "", "one-shared: ana shared dow found")
	var m: Dictionary = _entry(d, "ana", sd)
	_check(String(m.get("ability", "")) == "power" and _close(float(m.get("mult", 0.0)), 1.15) and String(m.get("mate", "")) == "bea", "one-shared: shared is power x1.15 with bea")

func _test_shared_priority() -> void:
	var rows: Array = [
		_row("ana", STATS_P, ["power", "speed", "technique", "defense", "conditioning", "fight_iq", ""]),
		_row("cy", STATS_T, ["technique", "speed", "defense", "conditioning", "fight_iq", "power", ""]),
		_row("bea", STATS_Q, ["power", "technique", "speed", "fight_iq", "defense", "conditioning", ""]),
	]
	var d: Dictionary = CM.week_deal(rows, "none")
	_invariants(d, rows, 4, "priority")
	var a0: Dictionary = _entry(d, "ana", "0")
	_check(String(a0.get("use", "")) == "shared" and String(a0.get("mate", "")) == "bea" and String(a0.get("ability", "")) == "power", "priority: ana shares power with bea (focus pair)")
	_check(_shared_count(d["cy"]) == 0, "priority: cy gets no shared")
	_check(_shared_count(d["ana"]) == 1 and _shared_count(d["bea"]) == 1, "priority: one shared each for ana and bea")

func _test_weak_solo() -> void:
	var rows: Array = [
		_row("ana", STATS_WEAK_POWER, ["power", "speed", "technique", "defense", "conditioning", "fight_iq", ""]),
		_row("bea", STATS_B, ["speed", "technique", "power", "fight_iq", "defense", "conditioning", ""]),
	]
	var d: Dictionary = CM.week_deal(rows, "none")
	_invariants(d, rows, 4, "weak-solo")
	var a0: Dictionary = _entry(d, "ana", "0")
	_check(String(a0.get("use", "")) == "solo" and String(a0.get("ability", "")) == "power" and _close(float(a0.get("mult", 0.0)), 1.4), "weak-solo: ana weak power solo is x1.4")
	var b2: Dictionary = _entry(d, "bea", "2")
	_check(String(b2.get("use", "")) == "solo" and String(b2.get("ability", "")) == "power" and _close(float(b2.get("mult", 0.0)), 1.25), "weak-solo: bea power solo is x1.25 (no weak spot)")
	_check(_count_mult(d["ana"], 1.4) == 1, "weak-solo: ana has exactly one x1.4")
	_check(_count_mult(d["bea"], 1.4) == 0, "weak-solo: bea has no x1.4")

func _test_four_fulltime() -> void:
	var rows: Array = [
		_row("ana", STATS_B, ["power", "speed", "technique", "defense", "conditioning", "fight_iq", ""]),
		_row("bea", STATS_C, ["speed", "technique", "defense", "conditioning", "fight_iq", "power", ""]),
		_row("cy", STATS_WEAK_TECH, ["technique", "defense", "conditioning", "fight_iq", "power", "speed", ""]),
		_row("di", STATS_WEAK_SPEED, ["defense", "conditioning", "fight_iq", "power", "speed", "technique", ""]),
	]
	var d: Dictionary = CM.week_deal(rows, "full_time")
	_invariants(d, rows, 7, "four-fulltime")
	_check(d.has("ana") and d.has("bea") and d.has("cy") and d.has("di"), "four-fulltime: key for every id")
	_check(_solo_count(d["ana"]) == 2 and _solo_count(d["bea"]) == 2 and _solo_count(d["cy"]) == 2 and _solo_count(d["di"]) == 1, "four-fulltime: solos round-robin 2,2,2,1")
	_check(String(_entry(d, "ana", "0").get("ability", "")) == "power", "four-fulltime: ana lowest power dow0")
	_check(String(_entry(d, "bea", "4").get("ability", "")) == "fight_iq", "four-fulltime: bea lowest fight_iq dow4")
	var cy0: Dictionary = _entry(d, "cy", "0")
	_check(String(cy0.get("ability", "")) == "technique" and _close(float(cy0.get("mult", 0.0)), 1.4), "four-fulltime: cy weak technique solo x1.4")
	var di4: Dictionary = _entry(d, "di", "4")
	_check(String(di4.get("ability", "")) == "speed" and _close(float(di4.get("mult", 0.0)), 1.4), "four-fulltime: di weak speed solo x1.4")

func _test_empty_boxer() -> void:
	var rows: Array = [
		_row("ana", STATS_B, ["power", "speed", "technique", "defense", "conditioning", "fight_iq", ""]),
		_row("bea", STATS_B, ["", "", "", "", "", "", ""]),
	]
	var d: Dictionary = CM.week_deal(rows, "sessional")
	_invariants(d, rows, 6, "empty-boxer")
	_check(d.has("bea") and (d["bea"] as Dictionary).is_empty(), "empty-boxer: rest-only boxer gets {}")
	_check(_solo_count(d["ana"]) == 6, "empty-boxer: all six slots go to ana")

func _test_day_mult_tile() -> void:
	var c1: Dictionary = {"0": {"use": "solo", "mult": 1.25, "ability": "power", "mate": ""}}
	_check(_close(CM.day_mult(c1, 0, "power"), 1.25), "day_mult: dealt day on this ability")
	_check(_close(CM.day_mult(c1, 0, "speed"), 1.0), "day_mult: dealt day on another ability is 1.0")
	_check(_close(CM.day_mult(c1, 1, "power"), 1.0), "day_mult: undealt day is 1.0")
	_check(_close(CM.day_mult({}, 0, "power"), 1.0), "day_mult: empty coached is 1.0")
	var c2: Dictionary = {"2": {"use": "shared", "mult": 1.15, "ability": "conditioning", "mate": "bea"}}
	_check(_close(CM.day_mult(c2, 2, "conditioning"), 1.15), "day_mult: shared day on this ability")
	_check(_close(CM.day_mult(c2, 2, "power"), 1.0), "day_mult: shared day on another ability is 1.0")
	_check(CM.tile_word({}) == "", "tile_word: {} is empty")
	_check(CM.tile_word({"use": "solo", "mult": 1.25, "ability": "power", "mate": ""}) == "Coached 1-to-1: Power (x1.25)", "tile_word: solo power")
	_check(CM.tile_word({"use": "shared", "mult": 1.15, "ability": "conditioning", "mate": "bea"}) == "Shared: Stamina (x1.15)", "tile_word: shared stamina")
	_check(CM.tile_word({"use": "solo", "mult": 1.25, "ability": "defense", "mate": ""}) == "Coached 1-to-1: Defence (x1.25)", "tile_word: solo defence")
	_check(CM.tile_word({"use": "shared", "mult": 1.15, "ability": "fight_iq", "mate": "ana"}) == "Shared: Fight IQ (x1.15)", "tile_word: shared fight iq")
	_check(CM.tile_word({"use": "solo", "mult": 1.25, "ability": "speed", "mate": ""}) == "Coached 1-to-1: Speed (x1.25)", "tile_word: solo speed")
	_check(CM.tile_word({"use": "solo", "mult": 1.25, "ability": "technique", "mate": ""}) == "Coached 1-to-1: Technique (x1.25)", "tile_word: solo technique")
	var rows: Array = [
		_row("ana", STATS_P, ["power", "speed", "technique", "defense", "conditioning", "fight_iq", ""]),
		_row("bea", STATS_Q, ["power", "technique", "speed", "fight_iq", "defense", "conditioning", ""]),
	]
	var d: Dictionary = CM.week_deal(rows, "sessional")
	var a0: Dictionary = _entry(d, "ana", "0")
	_check(CM.tile_word(a0) == "Shared: Power (x1.15)", "tile_word: dealt shared reads Shared Power")
	_check(_close(CM.day_mult(d["ana"], 0, "power"), 1.15), "day_mult: dealt shared day on this ability")
	_check(_close(CM.day_mult(d["ana"], 0, "speed"), 1.0), "day_mult: dealt shared day on another ability is 1.0")
	_check(_close(CM.day_mult(d["ana"], 6, "power"), 1.0), "day_mult: dealt entry undealt day is 1.0")

func _test_deterministic() -> void:
	var rows: Array = [
		_row("ana", STATS_P, ["power", "speed", "technique", "defense", "conditioning", "fight_iq", ""]),
		_row("bea", STATS_Q, ["power", "technique", "speed", "fight_iq", "defense", "conditioning", ""]),
	]
	var d1: Dictionary = CM.week_deal(rows, "sessional")
	var d2: Dictionary = CM.week_deal(rows, "sessional")
	_check(d1 == d2, "deterministic: same rows give same deal")
