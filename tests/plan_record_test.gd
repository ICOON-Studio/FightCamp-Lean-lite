extends SceneTree
## S370 FLOWBOUT1, the bout's kept plan record (PlanRecord):
##   1. summary folds a bout's closed rounds (LiveRound's "arrows" tallies and "plan") into one record - the counts
##      and each plan line's [won, used] added up, the plan she finished on as bare move ids; a round with no tally
##      is skipped whole, and no tallied rounds at all is {} (one round below is tallied by PlanFight itself).
##   2. rates reads a fighter's kept results back: only her bouts with a non-empty record count, lines sum across
##      nights (bouts = the nights a line appears on), most thrown first and then by move id, rate 0 when unused.
##   3. verdict's edges: 5 thrown is too early and 6 is read; 0.55 works, just under is even; 0.35 fails, just
##      over is even - checked as rows and end to end off rates().
## Population: hand-built rounds and results in LiveRound's / Career.results' own shapes, walker "lucy".

const PlanRecord := preload("res://scripts/rules/PlanRecord.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

var _fails := 0


func _round(used: int, worked: int, improvised: int, moves: Dictionary, plan: Array) -> Dictionary:
	return {"arrows": {"used": used, "worked": worked, "improvised": improvised, "moves": moves}, "plan": plan}


func _row(rows: Array, move: String) -> Dictionary:
	for r in rows:
		if str(r.get("move", "")) == move:
			return r
	return {}


func _initialize() -> void:
	# --- summary: two rounds folded into one bout record ---
	var r1 := _round(4, 3, 2, {"1-2": [2, 3], "step_back": [1, 1]}, [{"move": "1-2"}, {"move": "step_back"}])
	var r2 := _round(5, 2, 1, {"1-2": [1, 2], "tie_up": [1, 3]}, [{"move": "1-2"}, {"move": "tie_up", "when": "press"}])
	var s := PlanRecord.summary([r1, r2])
	_check(int(s.get("used", -1)) == 9 and int(s.get("worked", -1)) == 5 and int(s.get("improvised", -1)) == 3,
		"summary adds the two rounds' counts (used %s, worked %s, improvised %s)" % [s.get("used"), s.get("worked"), s.get("improvised")])
	var lines: Dictionary = s.get("lines", {})
	_check(lines.size() == 3 and lines.get("1-2") == [3, 5] and lines.get("step_back") == [1, 1] and lines.get("tie_up") == [1, 3],
		"each plan line's [won, used] adds across the rounds (%s)" % str(lines))
	_check(s.get("plan") == ["1-2", "tie_up"], "the plan kept is the LAST round's, as move ids in order (%s)" % str(s.get("plan")))

	# --- summary: rounds with no "arrows" are skipped; nothing tallied = {} ---
	var stray := {"plan": [{"move": "herd"}]}
	var mid := PlanRecord.summary([r1, stray, r2])
	var last := PlanRecord.summary([r1, stray])
	_check(int(mid.get("used", -1)) == 9 and mid.get("plan") == ["1-2", "tie_up"], "a round with no tally in the middle adds nothing")
	_check(int(last.get("used", -1)) == 4 and last.get("plan") == ["1-2", "step_back"], "a skipped round does not replace the plan")
	_check(PlanRecord.summary([]) == {}, "no rounds -> {}")
	_check(PlanRecord.summary([{}, stray]) == {}, "rounds but no tallies -> {}")

	# --- summary over a real PlanFight.tally (LiveRound's own producer) ---
	var exs := [{"arrow": "1-2", "planned": true, "won": true}, {"arrow": "1-2", "planned": true, "won": false},
		{"arrow": "step_back", "planned": false, "won": true}, {"arrow": "", "planned": false, "won": false}]
	var st := PlanRecord.summary([{"arrows": PlanFight.tally(exs), "plan": [{"move": "1-2"}]}])
	_check(int(st.get("used", -1)) == 2 and int(st.get("worked", -1)) == 1 and int(st.get("improvised", -1)) == 1
		and (st.get("lines", {}) as Dictionary) == {"1-2": [1, 2]} and st.get("plan") == ["1-2"],
		"a round tallied by PlanFight reads straight into the record (%s)" % str(st))

	# --- rates: only her recorded bouts, summed across nights, sorted ---
	var results := [
		{"fid": "lucy", "plan_rec": {"plan": ["1-2"], "used": 8, "worked": 6, "improvised": 0, "lines": {"1-2": [6, 8], "tie_up": [0, 0]}}},
		{"fid": "lucy", "plan_rec": {"plan": ["1-2", "herd"], "used": 28, "worked": 11, "improvised": 1, "lines": {"1-2": [5, 12], "herd": [4, 8], "step_back": [2, 8]}}},
		{"fid": "other", "plan_rec": {"plan": ["herd"], "used": 99, "worked": 99, "improvised": 0, "lines": {"herd": [99, 99]}}},
		{"fid": "lucy"},
		{"fid": "lucy", "plan_rec": {}},
	]
	var rows := PlanRecord.rates(results, "lucy")
	var r12 := _row(rows, "1-2")
	var herd := _row(rows, "herd")
	_check(rows.size() == 4 and int(herd.get("used", -1)) == 8 and int(herd.get("bouts", -1)) == 1,
		"only the given fighter's recorded bouts count (no 99s from another walker; blank records skipped)")
	_check(int(r12.get("won", -1)) == 11 and int(r12.get("used", -1)) == 20 and int(r12.get("bouts", -1)) == 2,
		"a line sums across two bouts and counts both nights (%s)" % str(r12))
	_check(is_equal_approx(float(r12.get("rate", -1.0)), 0.55), "rate = won / used (11 of 20 = %s)" % str(r12.get("rate")))
	_check(float(_row(rows, "tie_up").get("rate", -1.0)) == 0.0, "a line never thrown rates 0, not a divide by zero")
	_check(rows.map(func(r): return str(r["move"])) == ["1-2", "herd", "step_back", "tie_up"],
		"sorted by used descending, then by move id (herd before step_back on the 8-8 tie)")
	_check(PlanRecord.rates(results, "nobody") == [] and PlanRecord.rates([], "lucy") == [], "no matching results -> no rows")

	# --- verdict: the thresholds themselves ---
	_check(PlanRecord.verdict({"used": 5, "rate": 1.0}) == "too early", "5 thrown, even all won, is too early")
	_check(PlanRecord.verdict({"used": 6, "rate": 1.0}) == "works", "the 6th thrown exchange earns a read")
	_check(PlanRecord.verdict({"used": 6, "rate": 0.55}) == "works" and PlanRecord.verdict({"used": 6, "rate": 0.54}) == "even",
		"0.55 works, just under is even")
	_check(PlanRecord.verdict({"used": 6, "rate": 0.35}) == "fails" and PlanRecord.verdict({"used": 6, "rate": 0.36}) == "even",
		"0.35 fails, just over is even")
	_check(PlanRecord.verdict({"used": 20, "rate": 0.45}) == "even", "the ground between the thresholds is even")
	_check(PlanRecord.verdict({"won": 4, "used": 6}) == "works", "a row without its rate is read off won/used")

	# --- verdict end to end off rates() rows ---
	_check(PlanRecord.verdict(r12) == "works", "the 1-2 at 11 of 20 (0.55) works")
	_check(PlanRecord.verdict(_row(rows, "step_back")) == "fails", "step_back at 2 of 8 (0.25) fails")
	_check(PlanRecord.verdict(herd) == "even", "herd at 4 of 8 (0.50) is even")
	_check(PlanRecord.verdict(_row(rows, "tie_up")) == "too early", "tie_up never thrown is too early")

	print("PLAN_RECORD failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
