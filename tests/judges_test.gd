extends SceneTree
## R29JUDGES1 the judges: three cards scored like judges, each with a lean, 10-8 for a count, a running card and one reason.
## RED ON MAIN before S443: scripts/rules/Judges.gd did not exist, so the preload failed. Rewritten at the S443 collect
## (ops/research/R29JUDGES1_REVIEW_S443.md): every expected card below is summed by hand in the comments from the records
## built here, never from the module's own functions. Lucy = a (our side), Priya = b.

const Judges := preload("res://scripts/rules/Judges.gd")
const L := 0   # Duels.LONG
const P := 1   # Duels.POCKET
const I := 2   # Duels.INSIDE
const NAMES := ["Lucy", "Priya"]

var failures := 0


func _initialize() -> void:
	_test_clean_lands_more()
	_test_lean_decides_close_round()
	_test_counts()
	_test_level_rules()
	_test_forward_exchanges()
	_test_big_shots()
	_test_work_only_pro()
	_test_panel()
	_test_cards()
	_test_majority_and_draw()
	_test_mutants()
	print("JUDGES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: %s" % label)


func _ex(won: bool, la: int, lb: int, place: int, wa: int, wb: int, more := {}) -> Dictionary:
	var e := {"won": won, "landed": [la, lb], "place": place, "wa": wa, "wb": wb, "setup": "", "read": {}, "perks": [],
		"after": {"hurt": [false, false]}}
	e.merge(more, true)
	return e


func _round(exs: Array, counts := [0, 0], pace := [50, 50]) -> Dictionary:
	return {"exs": exs, "counts": counts, "pace": pace}


## a lands 12 to 9, nothing else differs: all at LONG, both want INSIDE (no ring), no forward step, b wins the last.
func _r_clean() -> Dictionary:
	return _round([_ex(true, 2, 1, L, I, I), _ex(false, 1, 2, L, I, I), _ex(true, 3, 1, L, I, I),
		_ex(false, 1, 2, L, I, I), _ex(true, 3, 1, L, I, I), _ex(false, 2, 2, L, I, I)])


## b lands 11 to 8, nothing else differs.
func _r_b_clean() -> Dictionary:
	return _round([_ex(false, 1, 2, L, I, I), _ex(true, 2, 1, L, I, I), _ex(false, 1, 3, L, I, I),
		_ex(false, 1, 2, L, I, I), _ex(true, 2, 2, L, I, I), _ex(false, 1, 1, L, I, I)])


## The close round: b out-lands a 11 to 10, a keeps the pocket it wanted and wins 4 of 6 (ring a 4, b 2 at range).
func _r_close() -> Dictionary:
	return _round([_ex(false, 1, 2, L, P, L), _ex(true, 2, 1, P, P, L), _ex(true, 2, 2, P, P, L),
		_ex(true, 2, 2, P, P, L), _ex(true, 2, 1, P, P, L), _ex(false, 1, 3, L, P, L)])


func _real(p: Dictionary, lean: String, counts: Array, pro: bool) -> Dictionary:
	return Judges.score_round(p, lean, counts, pro, NAMES)


func _test_clean_lands_more() -> void:
	var p := Judges.parts(_r_clean())
	_check(p["clean"] == [12, 9] and p["ring"] == [0, 0] and p["initiative"] == [0, 0] and p["big"] == [0, 0],
		"clean round parts: %s" % str(p))
	for pro in [false, true]:
		for lean in (Judges.PRO_LEANS if pro else Judges.AMATEUR_LEANS):
			var sc := _real(p, lean, [0, 0], pro)
			_check(int(sc["a"]) == 10 and int(sc["b"]) == 9, "a lands more: 10-9 to a on the %s card (pro %s)" % [lean, pro])
			_check(str(sc["reason"]) == "Clean: your boxer landed 12 to 9.", "clean reason: %s" % sc["reason"])


func _test_lean_decides_close_round() -> void:
	var p := Judges.parts(_r_close())
	_check(p["clean"] == [10, 11] and p["ring"] == [4, 2], "close round parts: %s" % str(p))
	# pro, ring card: a 10 + 4x2 = 18, b 11 + 2x2 = 15 -> a. clean card: a 10x2 + 4 = 24, b 11x2 + 2 = 24 -> level, the
	# lean (clean) is b's 11 to 10 -> b. work card (pace level): a 14, b 13 -> a.
	var ring := _real(p, "ring", [0, 0], true)
	var clean := _real(p, "clean", [0, 0], true)
	_check(int(ring["a"]) == 10 and int(ring["b"]) == 9, "close round: the ring card goes to a")
	_check(int(clean["a"]) == 9 and int(clean["b"]) == 10, "close round: the clean card goes to b")
	_check(str(ring["reason"]) == "Ring: your boxer kept the fight in the pocket, 4 exchanges.", "ring reason: %s" % ring["reason"])
	_check(str(clean["reason"]) == "Clean: the opponent landed 11 to 10.", "clean reason (b first): %s" % clean["reason"])


func _test_counts() -> void:
	var p := Judges.parts(_r_clean())   # a won the parts 12 to 9 on every card
	for lean in Judges.AMATEUR_LEANS:
		var one := _real(p, lean, [1, 0], false)
		var two := _real(p, lean, [2, 0], false)
		var each := _real(p, lean, [1, 1], false)
		var theirs := _real(p, lean, [0, 1], false)
		_check(int(one["a"]) == 8 and int(one["b"]) == 10, "one count on a: 10-8 to b (%s)" % lean)
		_check(int(two["a"]) == 7 and int(two["b"]) == 10, "two counts on a: 10-7 to b (%s)" % lean)
		_check(int(each["a"]) == 10 and int(each["b"]) == 9, "a count each: 10-9 by the parts (%s)" % lean)
		_check(int(theirs["a"]) == 10 and int(theirs["b"]) == 8, "one count on b: 10-8 to a (%s)" % lean)
		_check(str(one["reason"]) == "Count: your boxer took a count." and str(two["reason"]) == "Count: your boxer took 2 counts.",
			"count reasons: %s / %s" % [one["reason"], two["reason"]])


func _test_level_rules() -> void:
	# a keeps 1 exchange at range (wa LONG), b keeps none (wb INSIDE); a lands 3, b 5; no forward step.
	# ring card: a 3 + 1x2 = 5, b 5 -> level; the lean's part ring is a's 1 to 0 -> a.
	# clean card: a 6 + 1 = 7, b 10 -> b. initiative card: a 3 + 1 = 4, b 5 -> b.
	var p := Judges.parts(_round([_ex(true, 2, 1, L, L, I), _ex(false, 1, 4, L, L, I)]))
	_check(int(_real(p, "ring", [0, 0], false)["a"]) == 10, "a level total goes to the lean's side (ring, a)")
	_check(int(_real(p, "clean", [0, 0], false)["b"]) == 10, "the same round on a clean card goes to b")
	# initiative card where totals are level and the lean's part is 0-0 (S444 weights: ring 2): a ring 1x2 + clean 3 = 5,
	# b clean 5 -> clean -> b. The second exchange is fought where a did not want it (wa INSIDE), so no ring point.
	var q := Judges.parts(_round([_ex(true, 2, 2, L, L, I), _ex(true, 1, 3, L, I, I)]))
	var sc := _real(q, "initiative", [0, 0], false)
	_check(int(sc["b"]) == 10 and str(sc["reason"]) == "Clean: the opponent landed 5 to 3.", "level, lean 0-0: clean decides (%s)" % sc["reason"])
	# level on everything: the side that won the last exchange.
	var r1 := Judges.parts(_round([_ex(false, 1, 2, L, I, L), _ex(true, 2, 1, L, L, I)]))
	var r2 := Judges.parts(_round([_ex(true, 2, 1, L, L, I), _ex(false, 1, 2, L, I, L)]))
	var s1 := _real(r1, "ring", [0, 0], false)
	var s2 := _real(r2, "ring", [0, 0], false)
	_check(int(s1["a"]) == 10 and str(s1["reason"]) == "Even round: your boxer won the last exchange.", "even round, a last: %s" % s1["reason"])
	_check(int(s2["b"]) == 10 and str(s2["reason"]) == "Even round: the opponent won the last exchange.", "even round, b last: %s" % s2["reason"])


func _test_forward_exchanges() -> void:
	# 1 pocket, forward, a won and wanted it -> a. 2 inside, forward, a won but wanted the pocket; b wanted inside but lost
	# -> nobody. 3 back to range. 4 inside, forward, b won and wanted it -> b. 5 inside again: not forward.
	var p := Judges.parts(_round([_ex(true, 1, 0, P, P, L), _ex(true, 1, 0, I, P, I), _ex(false, 0, 1, L, L, L),
		_ex(false, 0, 1, I, L, I), _ex(false, 0, 1, I, L, I)]))
	_check(p["initiative"] == [1, 1], "forward exchanges count only for the side that wanted the place and won: %s" % str(p["initiative"]))


func _test_big_shots() -> void:
	var hb := {"after": {"hurt": [false, true]}}
	var p := Judges.parts(_round([_ex(true, 1, 0, L, I, I, {"setup": "landed"}), _ex(true, 1, 0, L, I, I, {"read": {"result": "landed"}}),
		_ex(true, 1, 0, L, I, I, {"perks": ["counter_sense"]}), _ex(true, 1, 0, L, I, I, hb), _ex(true, 1, 0, L, I, I, hb),
		_ex(true, 1, 0, L, I, I, {"setup": "missed", "read": {"result": "missed"}, "perks": ["hand_speed"]})]))
	_check(p["big"] == [4, 0], "set-up, Read, counter sense, fresh hurt add one each; held hurt and misses nothing: %s" % str(p["big"]))
	var ha := {"after": {"hurt": [true, false]}}
	var q := Judges.parts(_round([_ex(false, 0, 1, L, I, I, ha), _ex(false, 0, 1, L, I, I, ha)]))
	_check(q["big"] == [0, 1], "a fresh hurt on a is one big shot for b: %s" % str(q["big"]))
	var carried := _round([_ex(false, 0, 1, L, I, I, ha)])
	carried["start"] = {"hurt": [true, false]}
	_check(Judges.parts(carried)["big"] == [0, 0], "a hurt carried over the bell is not a fresh one")
	# big counts WEIGHTS.big on the card (S444: clean 1, big 12, lean x5): ring card a 1 landed + 1 big x12 = 13 against b's 4
	# landed -> a, by the big shot. clean card: a 1x5 + 12 = 17, b 4x5 = 20 -> b: the clean judge's lean outweighs the big shot.
	var r := Judges.parts(_round([_ex(true, 1, 4, L, I, I, {"setup": "landed"})]))
	var big_ring := _real(r, "ring", [0, 0], false)
	_check(int(big_ring["a"]) == 10 and str(big_ring["reason"]) == "Big shots: your boxer landed 1 to 0.", "a big shot outweighs one landed punch (%s)" % big_ring["reason"])
	_check(int(_real(r, "clean", [0, 0], false)["b"]) == 10, "a clean judge's lean on the landed punches outweighs one big shot")


func _test_work_only_pro() -> void:
	# level 6-6, nothing else, pace 70 to 50 (work a 2.0), b wins the last exchange.
	var p := Judges.parts(_round([_ex(true, 3, 3, L, I, I), _ex(false, 3, 3, L, I, I)], [0, 0], [70, 50]))
	var pro := _real(p, "clean", [0, 0], true)
	var am := _real(p, "clean", [0, 0], false)
	_check(int(pro["a"]) == 10 and str(pro["reason"]) == "Work: your boxer set the busier pace, 70 to 50.", "pro: work decides (%s)" % pro["reason"])
	_check(int(am["b"]) == 10 and str(am["reason"]) == "Even round: the opponent won the last exchange.", "amateur ignores work (%s)" % am["reason"])


func _test_panel() -> void:
	_check(Judges.panel(42, false) == Judges.panel(42, false), "the same seed gives the same three")
	var seen := {}
	var panels := {}
	for s in 60:
		var am: Array = Judges.panel(s, false)
		var pr: Array = Judges.panel(s, true)
		_check(am.size() == 3 and pr.size() == 3, "three judges")
		_check(not am.has("work") and not pr.has("initiative"), "amateur never work, pro never initiative (seed %d)" % s)
		for w in am + pr:
			seen[w] = true
		panels[str(am)] = true
	_check(seen.size() == 4, "every lean is drawn over 60 seeds: %s" % str(seen.keys()))
	_check(panels.size() > 5, "different seeds give different panels")


func _test_cards() -> void:
	var rounds := [_r_clean(), _r_b_clean(), _r_close()]
	# pro. R1 a on every card, R2 b on every card, R3 a on ring and work cards, b on clean cards.
	var mixed := Judges.cards(rounds, ["ring", "clean", "clean"], true, NAMES)
	_check(mixed["cards"] == [[29, 28], [28, 29], [28, 29]], "cards: %s" % str(mixed["cards"]))
	_check(str(mixed["verdict"]) == "split" and str(mixed["winner"]) == "b", "mixed leans: split to b")
	_check(mixed["running"] == [[[10, 9], [10, 9], [10, 9]], [[19, 19], [19, 19], [19, 19]], [[29, 28], [28, 29], [28, 29]]],
		"running card after each round: %s" % str(mixed["running"]))
	var three := Judges.cards(rounds, ["clean", "clean", "clean"], true, NAMES)
	_check(str(three["verdict"]) == "unanimous" and str(three["winner"]) == "b", "three clean leans: unanimous b")
	var ring2 := Judges.cards(rounds, ["ring", "ring", "clean"], true, NAMES)
	_check(str(ring2["verdict"]) == "split" and str(ring2["winner"]) == "a", "two ring judges: split to a")
	var re := RegEx.new()
	re.compile("\\b(he|she|they|her|his|him|them|their)\\b")
	for row in mixed["by_round"]:
		for sc in row:
			var t := str((sc as Dictionary)["reason"])
			_check(t.contains("your boxer") or t.contains("the opponent") or t.contains("Your boxer") or t.contains("The opponent"), "reason says whose (S448: the role): %s" % t)
			_check(re.search(t.to_lower()) == null, "no pronoun: %s" % t)
	# card reasons: the ring judge's card moved 1 point by clean (R1) and 1 by ring (R3): the tie goes to the lean.
	_check(Judges.card_reason(mixed, 0) == "Ring: your boxer kept the fight in the pocket, 4 exchanges (round 3)",
		"ring card reason: %s" % Judges.card_reason(mixed, 0))
	_check(Judges.card_reason(mixed, 1) == "Clean: the opponent landed more in rounds 2 and 3.", "clean card reason: %s" % Judges.card_reason(mixed, 1))


func _test_majority_and_draw() -> void:
	var rounds := [_r_clean(), _r_close()]
	# ring cards 20-18 to a; clean cards 19-19 level.
	var maj := Judges.cards(rounds, ["ring", "ring", "clean"], true, NAMES)
	_check(str(maj["verdict"]) == "majority" and str(maj["winner"]) == "a", "two cards for a and one level: majority a (%s)" % maj["verdict"])
	var drawn := Judges.cards(rounds, ["ring", "clean", "clean"], true, NAMES)
	_check(str(drawn["verdict"]) == "draw" and str(drawn["winner"]) == "", "one card for a and two level: a draw (%s)" % drawn["verdict"])
	_check(Judges.card_reason(drawn, 1) == "", "a level card has no reason")
	var two_counts := _r_clean()
	two_counts["counts"] = [1, 0]
	var c := Judges.cards([two_counts, _r_close()], ["ring", "ring", "ring"], true, NAMES)
	_check(c["cards"] == [[18, 19], [18, 19], [18, 19]], "a count in round 1 on every card: %s" % str(c["cards"]))


## The same asserts against any scorer; the real one passes, each mutant must fail.
func _score_ok(scorer: Callable) -> int:
	var bad := 0
	var close := Judges.parts(_r_close())
	var clean := Judges.parts(_r_clean())
	var r: Dictionary = scorer.call(close, "ring", [0, 0], true)
	var c: Dictionary = scorer.call(close, "clean", [0, 0], true)
	bad += 0 if (int(r["a"]) == 10 and int(c["b"]) == 10) else 1
	var one: Dictionary = scorer.call(clean, "ring", [1, 0], false)
	var two: Dictionary = scorer.call(clean, "clean", [2, 0], false)
	bad += 0 if (int(one["a"]) == 8 and int(one["b"]) == 10 and int(two["a"]) == 7) else 1
	return bad


func _no_mult(p: Dictionary, _lean: String, counts: Array, pro: bool) -> Dictionary:
	var ta := 0.0
	var tb := 0.0
	for part in Judges.counted(pro):
		ta += float((p[part] as Array)[0]) * float(Judges.WEIGHTS[part])
		tb += float((p[part] as Array)[1]) * float(Judges.WEIGHTS[part])
	var sa := 10 if ta >= tb else 9
	var sb := 19 - sa
	if int(counts[0]) > int(counts[1]):
		return {"a": 9 - (int(counts[0]) - int(counts[1])), "b": 10}
	return {"a": sa, "b": sb}


func _no_counts(p: Dictionary, lean: String, _counts: Array, pro: bool) -> Dictionary:
	return Judges.score_round(p, lean, [0, 0], pro, NAMES)


func _test_mutants() -> void:
	_check(_score_ok(Callable(self, "_real")) == 0, "the real scorer passes the mutant asserts")
	for m in ["_no_mult", "_no_counts"]:
		var bad := _score_ok(Callable(self, m))
		_check(bad > 0, "MUTANT %s survived" % m)
		if bad > 0:
			print("MUTANT caught: %s" % m)
