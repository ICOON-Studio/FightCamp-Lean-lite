extends SceneTree
## FightLog test (TASK FIGHTLOG1): the punch list of the fight analysis page.
## Hand-built exchanges covering every PUNCH move, every result rule, skip rules,
## after/seen rules, ordering, clock, words, filter, count_line, seen_count, exchange_line.

const FL := preload("res://scripts/rules/FightLog.gd")

var failures := 0


func _initialize() -> void:
	_test_empty()
	_test_lines()
	_test_order()
	_test_tie_across_exchanges()
	_test_clock()
	_test_words()
	_test_filter()
	_test_count_line()
	_test_seen_count()
	_test_exchange_line()
	print("FIGHT_LOG failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)


func _exchanges() -> Array:
	# Exchange 0: at 0.0, mode "pressure", place 1 (pocket), not pinned, won, landed [3, 2].
	# Beats include: jab (a, lands, big), cross (b, lands), lead_hook (a, blocked),
	#   body_hook (b, misses, def slip), rear_uppercut (a, misses), lead_uppercut (b, misses, def block),
	#   rear_hook (a, lands), body_cross (b, misses),
	#   say (skip), step_in (skip), unknown_move (skip),
	#   a beat with after (must stay ""), b beat with after but seen false (must stay ""),
	#   b beat with after+seen (shows word),
	#   out-of-order t (a late beat with t=5.0 before an earlier t=2.0).
	var ex0 := {
		"i": 0, "at": 0.0, "mode": "pressure", "place": 1, "pinned": false, "won": true, "landed": [3, 2],
		"beats": [
			{"t": 5.0, "who": "a", "move": "rear_hook", "result": "lands", "big": false, "def": ""},
			{"t": 1.0, "who": "a", "move": "jab", "result": "lands", "big": true, "def": ""},
			{"t": 2.0, "who": "b", "move": "cross", "result": "lands", "big": false, "def": ""},
			{"t": 3.0, "who": "a", "move": "lead_hook", "result": "blocked", "big": false, "def": ""},
			{"t": 4.0, "who": "b", "move": "body_hook", "result": "misses", "big": false, "def": "slip"},
			{"t": 6.0, "who": "a", "move": "rear_uppercut", "result": "misses", "big": false, "def": ""},
			{"t": 7.0, "who": "b", "move": "lead_uppercut", "result": "misses", "big": false, "def": "block"},
			{"t": 8.0, "who": "b", "move": "body_cross", "result": "misses", "big": false, "def": ""},
			{"t": 9.0, "who": "a", "move": "say", "result": "none", "big": false, "def": ""},
			{"t": 10.0, "who": "b", "move": "step_in", "result": "none", "big": false, "def": ""},
			{"t": 11.0, "who": "a", "move": "unknown_move", "result": "lands", "big": false, "def": ""},
			{"t": 12.0, "who": "a", "move": "jab", "result": "lands", "big": false, "def": "", "after": "guard_up"},
			{"t": 13.0, "who": "b", "move": "cross", "result": "lands", "big": false, "def": "", "after": "right_low"},
			{"t": 14.0, "who": "b", "move": "jab", "result": "lands", "big": false, "def": "", "after": "left_low", "seen": false},
		]
	}
	# Exchange 1: at 30.0, mode "long", place 0 (long range), pinned true, won false, landed [1, 4].
	# One punch beat: jab by b, lands.
	var ex1 := {
		"i": 1, "at": 30.0, "mode": "long", "place": 0, "pinned": true, "won": false, "landed": [1, 4],
		"beats": [
			{"t": 2.0, "who": "b", "move": "jab", "result": "lands", "big": false, "def": ""},
		]
	}
	return [ex0, ex1]


func _test_empty() -> void:
	var r1: Array = FL.lines([], 1)
	_check(r1.size() == 0, "lines([], 1) gives []")
	# Exchange with no beats key.
	var ex_no_beats: Array = [{"i": 0, "at": 0.0, "mode": "calm", "place": 0, "pinned": false, "won": true, "landed": [0, 0]}]
	var r2: Array = FL.lines(ex_no_beats, 1)
	_check(r2.size() == 0, "exchange with no beats key gives []")


func _test_lines() -> void:
	var all: Array = FL.lines(_exchanges(), 1)
	# Expected punch beats from ex0 (in input order within exchange, then sorted by t):
	# t=1.0 a jab lands big -> Clean, lead, jab, head, long->mid (place 1)
	# t=2.0 b cross lands -> Landed, rear, cross, head, mid
	# t=3.0 a lead_hook blocked -> Blocked, lead, hook, head, mid
	# t=4.0 b body_hook misses def slip -> Slipped, lead, hook, body, mid
	# t=5.0 a rear_hook lands -> Landed, rear, hook, head, mid
	# t=6.0 a rear_uppercut misses -> Missed, rear, uppercut, head, mid
	# t=7.0 b lead_uppercut misses def block -> Blocked, lead, uppercut, head, mid
	# t=8.0 b body_cross misses -> Missed, rear, cross, body, mid
	# t=12.0 a jab lands (after guard_up but who=a -> after="")
	# t=13.0 b cross lands (after right_low, seen missing -> default false -> after="")
	# t=14.0 b jab lands (after left_low, seen=false -> after="")
	# ex1: t=32.0 b jab lands, range "ropes" (pinned)
	# Total: 12 lines
	_check(all.size() == 12, "lines: 12 punch lines (got %d)" % all.size())
	# Assert every field of line 0 (a jab Clean at t=1.0)
	var l0: Dictionary = all[0]
	_check(float(l0["t"]) == 1.0, "line 0 t=1.0 (got %s)" % str(l0["t"]))
	_check(int(l0["round"]) == 1, "line 0 round=1")
	_check(str(l0["who"]) == "a", "line 0 who=a")
	_check(str(l0["hand"]) == "lead", "line 0 hand=lead")
	_check(str(l0["punch"]) == "jab", "line 0 punch=jab")
	_check(str(l0["target"]) == "head", "line 0 target=head")
	_check(str(l0["result"]) == "Clean", "line 0 result=Clean (lands+big)")
	_check(str(l0["range"]) == "mid", "line 0 range=mid (place 1)")
	_check(str(l0["after"]) == "", "line 0 after='' (who a, no after)")
	_check(str(l0["sit"]) == "pressure", "line 0 sit=pressure")
	_check(int(l0["ex"]) == 0, "line 0 ex=0")
	# Line 1: b cross Landed at t=2.0
	var l1: Dictionary = all[1]
	_check(str(l1["who"]) == "b" and str(l1["hand"]) == "rear" and str(l1["punch"]) == "cross" and str(l1["result"]) == "Landed",
		"line 1: b rear cross Landed")
	# Line 3: b body_hook misses def slip -> Slipped
	var l3: Dictionary = all[3]
	_check(str(l3["punch"]) == "hook" and str(l3["target"]) == "body" and str(l3["result"]) == "Slipped",
		"line 3: body_hook Slipped (misses + def slip)")
	# Line 5: a rear_uppercut misses -> Missed
	var l5: Dictionary = all[5]
	_check(str(l5["punch"]) == "uppercut" and str(l5["hand"]) == "rear" and str(l5["result"]) == "Missed",
		"line 5: rear_uppercut Missed")
	# Line 6: b lead_uppercut misses def block -> Blocked
	var l6: Dictionary = all[6]
	_check(str(l6["result"]) == "Blocked" and str(l6["hand"]) == "lead" and str(l6["punch"]) == "uppercut",
		"line 6: lead_uppercut Blocked (misses + def block)")
	# Line 7: b body_cross misses -> Missed
	var l7: Dictionary = all[7]
	_check(str(l7["hand"]) == "rear" and str(l7["punch"]) == "cross" and str(l7["target"]) == "body" and str(l7["result"]) == "Missed",
		"line 7: body_cross Missed")
	# Line 8: a jab at t=12.0, after="" (who a)
	var l8: Dictionary = all[8]
	_check(str(l8["who"]) == "a" and str(l8["after"]) == "", "line 8: a jab after='' (who a blocks after)")
	# Line 9: b cross at t=13.0, after="" (seen missing = false)
	var l9: Dictionary = all[9]
	_check(str(l9["who"]) == "b" and str(l9["after"]) == "", "line 9: b cross after='' (seen missing)")
	# Line 10: b jab at t=14.0, after="" (seen false)
	var l10: Dictionary = all[10]
	_check(str(l10["who"]) == "b" and str(l10["after"]) == "", "line 10: b jab after='' (seen false)")
	# Line 11: ex1 b jab at t=32.0, range "ropes" (pinned)
	var l11: Dictionary = all[11]
	_check(float(l11["t"]) == 32.0 and str(l11["range"]) == "ropes" and str(l11["sit"]) == "long" and int(l11["ex"]) == 1,
		"line 11: ex1 b jab t=32.0 range=ropes sit=long ex=1")
	# Line 2: a lead_hook blocked
	var l2: Dictionary = all[2]
	_check(str(l2["result"]) == "Blocked" and str(l2["hand"]) == "lead" and str(l2["punch"]) == "hook",
		"line 2: lead_hook Blocked (result blocked)")


func _test_order() -> void:
	var all: Array = FL.lines(_exchanges(), 1)
	# Check that times are ascending.
	var ordered := true
	for i in range(1, all.size()):
		if float(all[i]["t"]) < float(all[i - 1]["t"]):
			ordered = false
	_check(ordered, "lines are sorted by t ascending")


func _test_tie_across_exchanges() -> void:
	# Claude S495: a beat at t 30 of exchange 0 and a beat at t 0 of exchange 1 (at 30) share 0:30 - the one given
	# first (exchange 0) must stay first; a per-exchange counter put exchange 1 first.
	var ex: Array = [
		{"i": 0, "at": 0.0, "mode": "long", "place": 0, "pinned": false, "won": true, "landed": [1, 0],
			"beats": [{"t": 5.0, "who": "a", "move": "jab", "result": "misses", "big": false, "def": ""},
				{"t": 30.0, "who": "a", "move": "jab", "result": "lands", "big": false, "def": ""}]},
		{"i": 1, "at": 30.0, "mode": "long", "place": 0, "pinned": false, "won": true, "landed": [0, 1],
			"beats": [{"t": 0.0, "who": "b", "move": "cross", "result": "lands", "big": false, "def": ""}]},
	]
	var all: Array = FL.lines(ex, 1)
	_check(all.size() == 3 and str(all[1]["who"]) == "a" and str(all[2]["who"]) == "b",
		"a tie across exchanges keeps input order (exchange 0 first)")


func _test_clock() -> void:
	_check(FL.clock(0.0) == "0:00", "clock(0.0) = '0:00' (got '%s')" % FL.clock(0.0))
	_check(FL.clock(59.99) == "0:59", "clock(59.99) = '0:59' (got '%s')" % FL.clock(59.99))
	_check(FL.clock(95.4) == "1:35", "clock(95.4) = '1:35' (got '%s')" % FL.clock(95.4))
	_check(FL.clock(180.0) == "3:00", "clock(180.0) = '3:00' (got '%s')" % FL.clock(180.0))


func _test_words() -> void:
	var line := {"t": 95.4, "who": "b", "hand": "rear", "punch": "cross", "target": "head", "result": "Clean", "after": ""}
	var w: String = FL.words(line)
	_check(w == "1:35  rear cross to the head - Clean", "words no after: '%s'" % w)
	var line2 := {"t": 10.0, "who": "a", "hand": "lead", "punch": "jab", "target": "head", "result": "Landed", "after": "guard up"}
	var w2: String = FL.words(line2)
	_check(w2 == "0:10  lead jab to the head - Landed  (guard up)", "words with after: '%s'" % w2)


func _test_filter() -> void:
	var all: Array = FL.lines(_exchanges(), 1)
	# corner "a"
	var fa: Array = FL.filter(all, {"corner": "a"})
	_check(fa.size() == 5, "filter corner=a: 5 (got %d)" % fa.size())
	# corner "b"
	var fb: Array = FL.filter(all, {"corner": "b"})
	_check(fb.size() == 7, "filter corner=b: 7 (got %d)" % fb.size())
	# hand "lead" (jab x4 + lead_hook + lead_uppercut + body_hook = 7)
	var fl: Array = FL.filter(all, {"hand": "lead"})
	_check(fl.size() == 7, "filter hand=lead: 7 (got %d)" % fl.size())
	# punch "jab"
	var fj: Array = FL.filter(all, {"punch": "jab"})
	_check(fj.size() == 4, "filter punch=jab: 4 (got %d)" % fj.size())
	# target "body"
	var ftb: Array = FL.filter(all, {"target": "body"})
	_check(ftb.size() == 2, "filter target=body: 2 (got %d)" % ftb.size())
	# result "Clean"
	var fc: Array = FL.filter(all, {"result": "Clean"})
	_check(fc.size() == 1, "filter result=Clean: 1 (got %d)" % fc.size())
	# result "Landed" (b cross, a rear_hook, a jab, b cross, b jab, b jab = 6)
	var fcl: Array = FL.filter(all, {"result": "Landed"})
	_check(fcl.size() == 6, "filter result=Landed: 6 (got %d)" % fcl.size())
	# range "ropes"
	var fr: Array = FL.filter(all, {"range": "ropes"})
	_check(fr.size() == 1, "filter range=ropes: 1 (got %d)" % fr.size())
	# round 1
	var fr1: Array = FL.filter(all, {"round": 1})
	_check(fr1.size() == 12, "filter round=1: 12 (got %d)" % fr1.size())
	# round 0 (any)
	var fr0: Array = FL.filter(all, {"round": 0})
	_check(fr0.size() == 12, "filter round=0 (any): 12 (got %d)" % fr0.size())
	# game "pressure"
	var fg: Array = FL.filter(all, {"game": "pressure"})
	_check(fg.size() == 11, "filter game=pressure: 11 (got %d)" % fg.size())
	# game "long"
	var fgl: Array = FL.filter(all, {"game": "long"})
	_check(fgl.size() == 1, "filter game=long: 1 (got %d)" % fgl.size())
	# after "" (matches all since no after words present in test data)
	var faft: Array = FL.filter(all, {"after": ""})
	_check(faft.size() == 12, "filter after='' (any): 12 (got %d)" % faft.size())
	# Two filters together: corner "a" + result "Landed"
	var f2: Array = FL.filter(all, {"corner": "a", "result": "Landed"})
	_check(f2.size() == 2, "filter corner=a + result=Landed: 2 (got %d)" % f2.size())
	# Two filters: corner "b" + target "head"
	var f3: Array = FL.filter(all, {"corner": "b", "target": "head"})
	_check(f3.size() == 5, "filter corner=b + target=head: 5 (got %d)" % f3.size())


func _test_count_line() -> void:
	# Build a synthetic set: 36 shown, 164 all, 9 landed (2 clean).
	var shown: Array = []
	for i in 9:
		var r: String = "Clean" if i < 2 else "Landed"
		shown.append({"result": r})
	for i in 27:
		shown.append({"result": "Missed"})
	var all_arr: Array = []
	for i in 164:
		all_arr.append({"result": "x"})
	var cl: String = FL.count_line(shown, all_arr)
	_check(cl == "36 lines of 164 - landed 9 of 36, clean 2", "count_line example: '%s'" % cl)


func _test_seen_count() -> void:
	# Build lines with who "b" having various punches and after words.
	var all: Array = [
		{"who": "a", "punch": "jab", "after": "right low"},
		{"who": "b", "punch": "jab", "after": "right low"},
		{"who": "b", "punch": "jab", "after": ""},
		{"who": "b", "punch": "jab", "after": "right low"},
		{"who": "b", "punch": "cross", "after": "right low"},
		{"who": "b", "punch": "cross", "after": ""},
		{"who": "b", "punch": "hook", "after": "right low"},
	]
	var sc: Dictionary = FL.seen_count(all, "jab", "right low")
	# k: b+jab+right_low = 2, n: b+jab = 3, k_other: b+not_jab+right_low = 2 (cross + hook), n_other: b+not_jab = 3 (2 cross + 1 hook)
	_check(int(sc["k"]) == 2, "seen_count k=2 (got %d)" % int(sc["k"]))
	_check(int(sc["n"]) == 3, "seen_count n=3 (got %d)" % int(sc["n"]))
	_check(int(sc["k_other"]) == 2, "seen_count k_other=2 (got %d)" % int(sc["k_other"]))
	_check(int(sc["n_other"]) == 3, "seen_count n_other=3 (got %d)" % int(sc["n_other"]))


func _test_exchange_line() -> void:
	# Won exchange: at 90, game "They walked you down", landed [4, 2] -> winner first (a=4, b=2)
	var rec_win := {"at": 90.0, "won": true, "landed": [4, 2]}
	var w1: String = FL.exchange_line(rec_win, "They walked you down")
	_check(w1 == "1:30 They walked you down - you won it, 4 to 2", "exchange_line won: '%s'" % w1)
	# Lost exchange: at 60, game "Pressure", landed [3, 5] -> winner first (b=5, a=3)
	var rec_lose := {"at": 60.0, "won": false, "landed": [3, 5]}
	var w2: String = FL.exchange_line(rec_lose, "Pressure")
	_check(w2 == "1:00 Pressure - they won it, 5 to 3", "exchange_line lost: '%s'" % w2)
