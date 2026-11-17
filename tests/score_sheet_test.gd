extends SceneTree
## SCORESHEET1 the official scorecard as data: build(j, meta) -> {header, judges[3], result}.
## Hand-built j dictionaries; every check that passes with a_corner "red" is repeated with "blue" and columns swap.

const ScoreSheet := preload("res://scripts/rules/ScoreSheet.gd")

var failures := 0
var checks := 0


func _initialize() -> void:
	_test_empty_input()
	_test_unanimous_30_27_red()
	_test_unanimous_30_27_blue_swap()
	_test_split_decision()
	_test_knockdown_10_8()
	_test_deduction_round()
	_test_stoppage_round_2()
	_test_draw_all_level()
	_test_draw_split()
	_test_judge_names_deterministic()
	_test_no_names_in_words()
	_test_from_rounds()
	print("SCORE_SHEET checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("  FAIL: %s" % label)


## Three rounds, all 10-9 to a on every card -> 30-27 unanimous to a (red corner).
func _j_unanimous_a() -> Dictionary:
	var by_round: Array = []
	for ri in 3:
		var row: Array = []
		for ji in 3:
			row.append({"a": 10, "b": 9, "reason": "Clean: your boxer landed more.", "part": "clean"})
		by_round.append(row)
	return {"cards": [[30, 27], [30, 27], [30, 27]], "by_round": by_round, "running": [],
		"verdict": "unanimous", "winner": "a", "names": ["Lucy", "Priya"]}


func _meta_red() -> Dictionary:
	return {"a_corner": "red", "date": "2026-11-14", "venue": "York Hall", "weight_class": "Lightweight",
		"referee": "Dave Brown", "bout_no": 7, "rounds_scheduled": 3, "stopped": false,
		"stop_round": 0, "stop_time": "", "stop_winner": "", "judge_seed": 42,
		"leans": ["Clean punches", "Ring control", "Clean punches"]}


func _test_empty_input() -> void:
	var r := ScoreSheet.build({}, {})
	_check(r.is_empty(), "empty j -> empty result")
	var r2 := ScoreSheet.build({"cards": [[10, 9]]}, {})
	_check(r2.is_empty(), "no by_round -> empty result")


func _test_unanimous_30_27_red() -> void:
	var j := _j_unanimous_a()
	var meta := _meta_red()
	var s := ScoreSheet.build(j, meta)
	_check(not s.is_empty(), "unanimous red: build returns non-empty")
	var hdr: Dictionary = s["header"]
	_check(str(hdr["date"]) == "2026-11-14", "header date")
	_check(str(hdr["venue"]) == "York Hall", "header venue")
	_check(int(hdr["bout_no"]) == 7, "header bout_no")
	_check(int(hdr["rounds_scheduled"]) == 3, "header rounds_scheduled")
	var judges: Array = s["judges"]
	_check(judges.size() == 3, "three judges")
	for ji in 3:
		var jd: Dictionary = judges[ji]
		_check(int(jd["total_red"]) == 30, "judge %d total_red = 30" % ji)
		_check(int(jd["total_blue"]) == 27, "judge %d total_blue = 27" % ji)
		_check(str(jd["card_winner"]) == "red", "judge %d card_winner = red" % ji)
		var rows: Array = jd["rows"]
		_check(rows.size() == 3, "judge %d has 3 rows" % ji)
		for ri in 3:
			var row: Dictionary = rows[ri]
			_check(int(row["red"]) == 10, "judge %d round %d red = 10" % [ji, ri + 1])
			_check(int(row["blue"]) == 9, "judge %d round %d blue = 9" % [ji, ri + 1])
			_check(int(row["red_ded"]) == 0, "judge %d round %d red_ded = 0" % [ji, ri + 1])
			_check(int(row["blue_ded"]) == 0, "judge %d round %d blue_ded = 0" % [ji, ri + 1])
	var res: Dictionary = s["result"]
	_check(str(res["kind"]) == "decision", "unanimous red: kind = decision")
	_check(str(res["words"]) == "Winner by unanimous decision", "unanimous red: words")
	_check(str(res["winner"]) == "red", "unanimous red: winner = red")


func _test_unanimous_30_27_blue_swap() -> void:
	var j := _j_unanimous_a()
	var meta := _meta_red()
	meta["a_corner"] = "blue"
	var s := ScoreSheet.build(j, meta)
	var judges: Array = s["judges"]
	for ji in 3:
		var jd: Dictionary = judges[ji]
		_check(int(jd["total_red"]) == 27, "blue swap: judge %d total_red = 27 (opponent)" % ji)
		_check(int(jd["total_blue"]) == 30, "blue swap: judge %d total_blue = 30 (player)" % ji)
		_check(str(jd["card_winner"]) == "blue", "blue swap: judge %d card_winner = blue" % ji)
		var rows: Array = jd["rows"]
		for ri in 3:
			var row: Dictionary = rows[ri]
			_check(int(row["red"]) == 9, "blue swap: judge %d round %d red = 9" % [ji, ri + 1])
			_check(int(row["blue"]) == 10, "blue swap: judge %d round %d blue = 10" % [ji, ri + 1])
	var res: Dictionary = s["result"]
	_check(str(res["winner"]) == "blue", "blue swap: the player won from the BLUE corner -> winner blue (S503 collect)")


func _test_split_decision() -> void:
	# Judge 0: 29-28 a (R1 10-9, R2 10-9, R3 9-10)
	# Judge 1: 28-29 b (R1 9-10, R2 9-10, R3 10-9)
	# Judge 2: 29-28 a (R1 10-9, R2 10-9, R3 9-10)
	var by_round: Array = []
	for ri in 3:
		var row: Array = []
		for ji in 3:
			row.append({"a": 10, "b": 9, "reason": "", "part": "clean"})
		by_round.append(row)
	# Judge 0 round 3: b wins
	(by_round[2] as Array)[0]["a"] = 9
	(by_round[2] as Array)[0]["b"] = 10
	# Judge 1 rounds 1,2: b wins; round 3: a wins
	(by_round[0] as Array)[1]["a"] = 9
	(by_round[0] as Array)[1]["b"] = 10
	(by_round[1] as Array)[1]["a"] = 9
	(by_round[1] as Array)[1]["b"] = 10
	(by_round[2] as Array)[1]["a"] = 10
	(by_round[2] as Array)[1]["b"] = 9
	# Judge 2 round 3: b wins
	(by_round[2] as Array)[2]["a"] = 9
	(by_round[2] as Array)[2]["b"] = 10
	var j := {"cards": [[29, 28], [28, 29], [29, 28]], "by_round": by_round, "running": [],
		"verdict": "split", "winner": "a", "names": ["Lucy", "Priya"]}
	var meta := _meta_red()
	var s := ScoreSheet.build(j, meta)
	var judges: Array = s["judges"]
	_check(int((judges[0] as Dictionary)["total_red"]) == 29, "split: judge 0 total_red = 29")
	_check(int((judges[1] as Dictionary)["total_red"]) == 28, "split: judge 1 total_red = 28")
	_check(int((judges[2] as Dictionary)["total_red"]) == 29, "split: judge 2 total_red = 29")
	var res: Dictionary = s["result"]
	_check(str(res["kind"]) == "decision", "split: kind = decision")
	_check(str(res["words"]) == "Winner by split decision", "split: words")
	_check(str(res["winner"]) == "red", "split: winner = red")


func _test_knockdown_10_8() -> void:
	var by_round: Array = []
	# Round 1: 10-8 to a (knockdown), rounds 2-3: 10-9 to a -> total 30-26
	for ri in 3:
		var row: Array = []
		for ji in 3:
			var sa := 10
			var sb := 9 if ri > 0 else 8
			row.append({"a": sa, "b": sb, "reason": "Count." if ri == 0 else "Clean.", "part": "count" if ri == 0 else "clean"})
		by_round.append(row)
	var j := {"cards": [[30, 26], [30, 26], [30, 26]], "by_round": by_round, "running": [],
		"verdict": "unanimous", "winner": "a", "names": ["Lucy", "Priya"]}
	var meta := _meta_red()
	var s := ScoreSheet.build(j, meta)
	var judges: Array = s["judges"]
	var rows0: Array = (judges[0] as Dictionary)["rows"]
	_check(int((rows0[0] as Dictionary)["red"]) == 10, "10-8 round: red = 10")
	_check(int((rows0[0] as Dictionary)["blue"]) == 8, "10-8 round: blue = 8")
	_check(int((judges[0] as Dictionary)["total_red"]) == 30, "10-8 total_red = 30 (10+10+10)")
	_check(int((judges[0] as Dictionary)["total_blue"]) == 26, "10-8 total_blue = 26 (8+9+9)")


func _test_deduction_round() -> void:
	var by_round: Array = []
	for ri in 3:
		var row: Array = []
		for ji in 3:
			row.append({"a": 10, "b": 9, "reason": "Clean.", "part": "clean"})
		by_round.append(row)
	var j := {"cards": [[30, 27], [30, 27], [30, 27]], "by_round": by_round, "running": [],
		"verdict": "unanimous", "winner": "a", "names": ["Lucy", "Priya"]}
	var meta := _meta_red()
	# Round 1: a has 1 point deduction -> shows 9 in score, 1 in ded column
	meta["deductions"] = [[1, 0], [0, 0], [0, 0]]
	var s := ScoreSheet.build(j, meta)
	var judges: Array = s["judges"]
	var rows0: Array = (judges[0] as Dictionary)["rows"]
	var r1: Dictionary = rows0[0]
	_check(int(r1["red"]) == 9, "deduction: round 1 red = 9 (10 - 1)")
	_check(int(r1["red_ded"]) == 1, "deduction: round 1 red_ded = 1")
	_check(int(r1["blue"]) == 9, "deduction: round 1 blue = 9 (unchanged)")
	_check(int(r1["blue_ded"]) == 0, "deduction: round 1 blue_ded = 0")
	# Totals follow the shown scores: 9+10+10 = 29 red, 9+9+9 = 27 blue
	_check(int((judges[0] as Dictionary)["total_red"]) == 29, "deduction: total_red = 29")
	_check(int((judges[0] as Dictionary)["total_blue"]) == 27, "deduction: total_blue = 27")
	# Blue swap: deduction follows the corner
	meta["a_corner"] = "blue"
	meta["deductions"] = [[1, 0], [0, 0], [0, 0]]
	var s2 := ScoreSheet.build(j, meta)
	var judges2: Array = s2["judges"]
	var r1b: Dictionary = (judges2[0] as Dictionary)["rows"][0]
	_check(int(r1b["blue"]) == 9, "deduction blue swap: blue = 9 (player's ded)")
	_check(int(r1b["blue_ded"]) == 1, "deduction blue swap: blue_ded = 1")
	_check(int(r1b["red"]) == 9, "deduction blue swap: red = 9")
	_check(int(r1b["red_ded"]) == 0, "deduction blue swap: red_ded = 0")


func _test_stoppage_round_2() -> void:
	var by_round: Array = []
	for ri in 3:
		var row: Array = []
		for ji in 3:
			row.append({"a": 10, "b": 9, "reason": "Clean.", "part": "clean"})
		by_round.append(row)
	var j := {"cards": [[30, 27], [30, 27], [30, 27]], "by_round": by_round, "running": [],
		"verdict": "unanimous", "winner": "a", "names": ["Lucy", "Priya"]}
	var meta := _meta_red()
	meta["stopped"] = true
	meta["stop_round"] = 2
	meta["stop_time"] = "2:14"
	meta["stop_winner"] = "a"
	var s := ScoreSheet.build(j, meta)
	var judges: Array = s["judges"]
	for ji in 3:
		var jd: Dictionary = judges[ji]
		var rows: Array = jd["rows"]
		_check(rows.size() == 2, "stoppage: judge %d has 2 rows (stopped in round 2)" % ji)
		_check(int((rows[0] as Dictionary)["round"]) == 1, "stoppage: first row is round 1")
		_check(int((rows[1] as Dictionary)["round"]) == 2, "stoppage: second row is round 2")
		_check(int(jd["total_red"]) == 20, "stoppage: judge %d total_red = 20 (10+10)" % ji)
		_check(int(jd["total_blue"]) == 18, "stoppage: judge %d total_blue = 18 (9+9)" % ji)
	var res: Dictionary = s["result"]
	_check(str(res["kind"]) == "stoppage", "stoppage: kind = stoppage")
	_check(str(res["words"]) == "Winner by stoppage, round 2 (2:14)", "stoppage: words")
	_check(str(res["winner"]) == "red", "stoppage: winner = red (a won)")


func _test_draw_all_level() -> void:
	var by_round: Array = []
	for ri in 3:
		var row: Array = []
		for ji in 3:
			row.append({"a": 10, "b": 10, "reason": "Even round.", "part": "last"})
		by_round.append(row)
	var j := {"cards": [[30, 30], [30, 30], [30, 30]], "by_round": by_round, "running": [],
		"verdict": "draw", "winner": "", "names": ["Lucy", "Priya"]}
	var meta := _meta_red()
	var s := ScoreSheet.build(j, meta)
	var res: Dictionary = s["result"]
	_check(str(res["kind"]) == "draw", "all level: kind = draw")
	_check(str(res["words"]) == "Draw", "all level: words = 'Draw'")
	_check(str(res["winner"]) == "", "all level: winner = ''")


func _test_draw_split() -> void:
	# Judge 0: 29-28 a (R1 10-9, R2 10-9, R3 9-10)
	# Judge 1: 28-29 b (R1 9-10, R2 9-10, R3 10-9)
	# Judge 2: 28-28 level (R1 10-9, R2 9-10, R3 9-9)
	var by_round: Array = []
	for ri in 3:
		var row: Array = []
		for ji in 3:
			row.append({"a": 10, "b": 9, "reason": "", "part": "clean"})
		by_round.append(row)
	# Judge 0 round 3: b wins -> 10+10+9=29, 9+9+10=28
	(by_round[2] as Array)[0]["a"] = 9
	(by_round[2] as Array)[0]["b"] = 10
	# Judge 1 rounds 1,2: b wins; round 3: a wins -> 9+9+10=28, 10+10+9=29
	(by_round[0] as Array)[1]["a"] = 9
	(by_round[0] as Array)[1]["b"] = 10
	(by_round[1] as Array)[1]["a"] = 9
	(by_round[1] as Array)[1]["b"] = 10
	(by_round[2] as Array)[1]["a"] = 10
	(by_round[2] as Array)[1]["b"] = 9
	# Judge 2 round 2: b wins; round 3: 9-9 -> 10+9+9=28, 9+10+9=28
	(by_round[1] as Array)[2]["a"] = 9
	(by_round[1] as Array)[2]["b"] = 10
	(by_round[2] as Array)[2]["a"] = 9
	(by_round[2] as Array)[2]["b"] = 9
	var j := {"cards": [[29, 28], [28, 29], [28, 28]], "by_round": by_round, "running": [],
		"verdict": "draw", "winner": "", "names": ["Lucy", "Priya"]}
	var meta := _meta_red()
	var s := ScoreSheet.build(j, meta)
	var res: Dictionary = s["result"]
	_check(str(res["kind"]) == "draw", "split draw: kind = draw")
	_check(str(res["words"]) == "Draw (split)", "split draw: words = 'Draw (split)'")
	_check(str(res["winner"]) == "", "split draw: winner = ''")


func _test_judge_names_deterministic() -> void:
	var j := _j_unanimous_a()
	var meta := _meta_red()
	meta["judge_seed"] = 7
	var s1 := ScoreSheet.build(j, meta)
	var s2 := ScoreSheet.build(j, meta)
	var n1: String = (s1["judges"][0] as Dictionary)["name"]
	var n2: String = (s1["judges"][1] as Dictionary)["name"]
	var n3: String = (s1["judges"][2] as Dictionary)["name"]
	_check(n1 != n2 and n2 != n3 and n1 != n3, "three different names: %s, %s, %s" % [n1, n2, n3])
	# S506 (owner's still: two Dohertys on one panel): no surname twice, over many seeds.
	var twice := 0
	for sd in 300:
		var names := ScoreSheet._judge_names(sd)
		var lasts := {}
		for nm in names:
			lasts[str(nm).get_slice(" ", 1)] = true
		if lasts.size() < 3:
			twice += 1
	_check(twice == 0, "no surname twice on a panel over 300 seeds (%d panels had one)" % twice)
	var m1: String = (s2["judges"][0] as Dictionary)["name"]
	var m2: String = (s2["judges"][1] as Dictionary)["name"]
	var m3: String = (s2["judges"][2] as Dictionary)["name"]
	_check(n1 == m1 and n2 == m2 and n3 == m3, "seed 7 twice -> same panel")
	meta["judge_seed"] = 8
	var s3 := ScoreSheet.build(j, meta)
	var o1: String = (s3["judges"][0] as Dictionary)["name"]
	var o2: String = (s3["judges"][1] as Dictionary)["name"]
	var o3: String = (s3["judges"][2] as Dictionary)["name"]
	_check(not (n1 == o1 and n2 == o2 and n3 == o3), "seed 8 -> different panel")


func _test_no_names_in_words() -> void:
	var by_round: Array = []
	for ri in 3:
		var row: Array = []
		for ji in 3:
			row.append({"a": 10, "b": 9, "reason": "Clean: Lucy landed more.", "part": "clean"})
		by_round.append(row)
	var j := {"cards": [[30, 27], [30, 27], [30, 27]], "by_round": by_round, "running": [],
		"verdict": "unanimous", "winner": "a", "names": ["Lucy Jackson", "Priya Nair"]}
	var meta := _meta_red()
	var s := ScoreSheet.build(j, meta)
	var res: Dictionary = s["result"]
	var words: String = str(res["words"])
	_check(not words.contains("Lucy"), "no 'Lucy' in result words: '%s'" % words)
	_check(not words.contains("Priya"), "no 'Priya' in result words: '%s'" % words)
	_check(not words.contains("Jackson"), "no 'Jackson' in result words: '%s'" % words)
	_check(not words.contains("Nair"), "no 'Nair' in result words: '%s'" % words)
	# Stoppage words also name-free
	meta["stopped"] = true
	meta["stop_round"] = 2
	meta["stop_time"] = "1:30"
	meta["stop_winner"] = "b"
	var s2 := ScoreSheet.build(j, meta)
	var words2: String = str(s2["result"]["words"])
	_check(not words2.contains("Lucy") and not words2.contains("Priya"),
		"stoppage words name-free: '%s'" % words2)


## S503: today's cards (BoutRules.cards_of: 10-9 a round to its winner, judge 3 flips round `flip`) -> the sheet agrees.
func _test_from_rounds() -> void:
	_check(ScoreSheet.from_rounds([], -1).is_empty(), "from_rounds: no rounds -> {}")
	var wwl := [{"won": true}, {"won": true}, {"won": false}]
	var j := ScoreSheet.from_rounds(wwl, -1)
	_check(str(j["verdict"]) == "unanimous" and str(j["winner"]) == "a", "from_rounds: won 2 of 3, no flip -> unanimous a")
	_check((j["cards"] as Array)[2] == [29, 28], "from_rounds: each card 29-28")
	j = ScoreSheet.from_rounds(wwl, 0)
	_check((j["cards"] as Array)[2] == [28, 29] and str(j["verdict"]) == "split" and str(j["winner"]) == "a",
		"from_rounds: judge 3 flips a won round -> 29-28, 29-28, 28-29 split a")
	_check(int(((j["by_round"] as Array)[0] as Array)[2]["b"]) == 10, "from_rounds: the flipped round is 9-10 on card 3")
	j = ScoreSheet.from_rounds(wwl, 2)
	_check((j["cards"] as Array)[2] == [30, 27] and str(j["verdict"]) == "unanimous", "from_rounds: flipping her lost round -> 30-27 unanimous")
	j = ScoreSheet.from_rounds([{"won": false}, {"won": false}, {"won": true}], 1)
	_check(str(j["verdict"]) == "split" and str(j["winner"]) == "b", "from_rounds: she lost 2 of 3, judge 3 flips one -> split b")
	var four := [{"won": true}, {"won": false}, {"won": true}, {"won": false}]
	j = ScoreSheet.from_rounds(four, -1)
	_check(str(j["verdict"]) == "draw" and str(j["winner"]) == "", "from_rounds: 2-2 over four -> draw")
	j = ScoreSheet.from_rounds(four, 1)
	_check(str(j["verdict"]) == "draw", "from_rounds: one card off a 2-2 -> still a draw (majority)")
	var sheet := ScoreSheet.build(j, _meta_red())
	_check(str((sheet["result"] as Dictionary)["words"]) == "Draw (majority)", "from_rounds -> build: 'Draw (majority)'")
	# the sheet's verdict is the announced one: BoutRules.cards_of's three texts
	var BR = load("res://scripts/rules/BoutRules.gd")
	for rs in [wwl, [{"won": false}, {"won": true}, {"won": false}], four]:
		var flip: int = BR.flip_round(rs)
		var texts: Array = BR.cards_of(rs)
		var jj := ScoreSheet.from_rounds(rs, flip)
		var mine: Array = (jj["cards"] as Array).map(func(c): return "%d-%d" % [int(c[0]), int(c[1])])
		_check(mine == texts, "from_rounds agrees with BoutRules.cards_of: %s == %s" % [str(mine), str(texts)])
