extends SceneTree
## MATRECEIPT1: the mat plan's receipt per line after an open (scripts/rules/MatReceipt.gd).
## Prints MAT_RECEIPT PASS or FAIL n.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const MatLines := preload("res://scripts/rules/MatLines.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const BjjOpen := preload("res://scripts/rules/BjjOpen.gd")
const MatReceipt := preload("res://scripts/rules/MatReceipt.gd")

var _fails := 0


func _initialize() -> void:
	BjjTree.reset_tuning()
	BjjOpp.reset_tuning()
	_hand_made()
	_opponent_not_counted()
	_live_row_skipped()
	_receipt_order()
	_season_add_and_verdict()
	_teach()
	_real_open()
	if _fails == 0:
		print("MAT_RECEIPT PASS")
	else:
		print("MAT_RECEIPT FAIL %d" % _fails)
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1


## Hand-made rows: a line tried 3 / landed 2 -> "2 of 3"; a line never reached -> "never reached".
func _hand_made() -> void:
	var line_sc := {"at": "side_control_bottom", "edge": "e046", "timing": "at_once"}
	var line_back := {"at": "back_bottom", "edge": "e031", "timing": "at_once"}
	# Row 1: Ana tries e046 three times: hit, miss, hit. Also tries e031 once: hit.
	var row1 := {"path": [
		["e046", 0, "hit", 30.0],
		["e046", 0, "miss", 60.0],
		["e031", 0, "hit", 90.0],
		["e046", 0, "hit", 120.0]]}
	# Row 2: Ana tries e046 once more: reset.
	var row2 := {"path": [
		["e046", 0, "reset", 150.0]]}
	var rows := [row1, row2]
	var r_sc: Dictionary = MatReceipt.line_receipt(line_sc, rows)
	_check(int(r_sc["tried"]) == 4, "side control escape: tried 4 (%d)" % int(r_sc["tried"]))
	_check(int(r_sc["landed"]) == 2, "side control escape: landed 2 (%d)" % int(r_sc["landed"]))
	_check(int(r_sc["missed"]) == 1, "side control escape: missed 1 (%d)" % int(r_sc["missed"]))
	_check(int(r_sc["reset"]) == 1, "side control escape: reset 1 (%d)" % int(r_sc["reset"]))
	_check(is_equal_approx(float(r_sc["first_t"]), 30.0), "side control escape: first_t 30 (%.1f)" % float(r_sc["first_t"]))
	_check(str(r_sc["words"]).contains("2 of 4"), "side control escape words: '%s'" % str(r_sc["words"]))
	var r_back: Dictionary = MatReceipt.line_receipt(line_back, rows)
	_check(int(r_back["tried"]) == 1 and int(r_back["landed"]) == 1, "back escape: 1 of 1")
	# A line never reached.
	var line_mount := {"at": "mount_bottom", "edge": "e037", "timing": "frame_first"}
	var r_mount: Dictionary = MatReceipt.line_receipt(line_mount, rows)
	_check(int(r_mount["tried"]) == 0, "mount escape: never reached (tried 0)")
	_check(str(r_mount["words"]).contains("never reached"), "mount escape words: '%s'" % str(r_mount["words"]))


## The opponent's (actor 1) tries of the same edge are not counted.
func _opponent_not_counted() -> void:
	var line := {"at": "side_control_bottom", "edge": "e046", "timing": "at_once"}
	var rows := [{"path": [
		["e046", 1, "hit", 10.0],
		["e046", 0, "hit", 20.0],
		["e046", 1, "miss", 30.0]]}]
	var r: Dictionary = MatReceipt.line_receipt(line, rows)
	_check(int(r["tried"]) == 1, "only Ana's tries counted: 1 (%d)" % int(r["tried"]))
	_check(int(r["landed"]) == 1, "only Ana's landed counted: 1 (%d)" % int(r["landed"]))


## A live row (no path key, or path not an array) is skipped.
func _live_row_skipped() -> void:
	var line := {"at": "side_control_bottom", "edge": "e046", "timing": "at_once"}
	var rows := [
		{"live": true, "landed": ["americana"]},
		{"path": [["e046", 0, "hit", 10.0]]}]
	var r: Dictionary = MatReceipt.line_receipt(line, rows)
	_check(int(r["tried"]) == 1, "live row skipped: only the sim row counts (%d)" % int(r["tried"]))


## receipt keeps the brought order and drops a not-brought line.
func _receipt_order() -> void:
	var ana := NoGi.athlete()
	var rules := BjjTree.rules_for("white")
	# Give Ana mastery of rear_naked_choke so the finish line is valid.
	ana["bjj"]["rear_naked_choke"] = 30.0
	var plan := {"lines": [
		{"at": "side_control_bottom", "edge": "e046", "timing": "at_once"},
		{"at": "back_bottom", "edge": "e031", "timing": "at_once"},
		{"at": "mount_bottom", "edge": "e037", "timing": "frame_first"},
		{"at": "mount_top", "edge": "e032", "timing": "set_up"}]}
	var rows := [{"path": [
		["e046", 0, "hit", 10.0],
		["e031", 0, "miss", 20.0]]}]
	var recs: Array = MatReceipt.receipt(plan, ana, rows, rules)
	# White brings 3: back_bottom, mount_bottom, side_control_bottom (escape order).
	_check(recs.size() == 3, "white brings 3 lines (%d)" % recs.size())
	if recs.size() >= 3:
		_check(str(recs[0]["edge"]) == "e031", "first brought: back escape (%s)" % str(recs[0]["edge"]))
		_check(str(recs[1]["edge"]) == "e037", "second brought: mount escape (%s)" % str(recs[1]["edge"]))
		_check(str(recs[2]["edge"]) == "e046", "third brought: side control escape (%s)" % str(recs[2]["edge"]))
	# The mount_top finish (e032) is not brought at white (only 3 hand size) - dropped.
	for r in recs:
		_check(str(r["edge"]) != "e032", "the not-brought finish is dropped")


## season_add over two opens sums; verdict "too early" under 6 tries, "works" at 4 of 6, "fails" at 2 of 6.
func _season_add_and_verdict() -> void:
	var book := {}
	var recs1 := [{"edge": "e046", "tried": 3, "landed": 2, "missed": 1, "reset": 0}]
	var recs2 := [{"edge": "e046", "tried": 3, "landed": 2, "missed": 0, "reset": 1}]
	MatReceipt.season_add(book, recs1)
	_check(book.has("e046"), "book has e046 after first open")
	_check(int(book["e046"][0]) == 3 and int(book["e046"][1]) == 2, "after first open: used 3, won 2")
	MatReceipt.season_add(book, recs2)
	_check(int(book["e046"][0]) == 6 and int(book["e046"][1]) == 4, "after second open: used 6, won 4")
	# Too early: under 6 tries.
	var book2 := {"e046": [5, 3]}
	_check(MatReceipt.verdict_of(book2, "e046") == "too early", "too early under 6 tries")
	# Works: 4 of 6 = 0.667 >= 0.55.
	var book3 := {"e046": [6, 4]}
	_check(MatReceipt.verdict_of(book3, "e046") == "works", "works at 4 of 6 (%.3f)" % (4.0 / 6.0))
	# Fails: 2 of 6 = 0.333 <= 0.35.
	var book4 := {"e046": [6, 2]}
	_check(MatReceipt.verdict_of(book4, "e046") == "fails", "fails at 2 of 6 (%.3f)" % (2.0 / 6.0))
	# Even: 3 of 6 = 0.5, between 0.35 and 0.55.
	var book5 := {"e046": [6, 3]}
	_check(MatReceipt.verdict_of(book5, "e046") == "even", "even at 3 of 6")
	# Missing edge: too early.
	_check(MatReceipt.verdict_of(book5, "e999") == "too early", "missing edge: too early")


## teach caps at 3 and counts 0.5 a miss.
func _teach() -> void:
	# 2 landed + 1 miss = 2 + 0.5 = 2.5.
	var recs := [{"edge": "e046", "tried": 3, "landed": 2, "missed": 1, "reset": 0}]
	var t: Dictionary = MatReceipt.teach(recs)
	_check(is_equal_approx(float(t.get("frame_recover_guard", 0.0)), 2.5),
		"teach: 2 landed + 1 miss = 2.5 (%.1f)" % float(t.get("frame_recover_guard", 0.0)))
	# Cap at 3: 4 landed = 4 -> capped to 3.
	var recs2 := [{"edge": "e046", "tried": 4, "landed": 4, "missed": 0, "reset": 0}]
	var t2: Dictionary = MatReceipt.teach(recs2)
	_check(is_equal_approx(float(t2.get("frame_recover_guard", 0.0)), 3.0),
		"teach caps at 3 (%.1f)" % float(t2.get("frame_recover_guard", 0.0)))
	# 0.5 a reset.
	var recs3 := [{"edge": "e046", "tried": 2, "landed": 0, "missed": 0, "reset": 2}]
	var t3: Dictionary = MatReceipt.teach(recs3)
	_check(is_equal_approx(float(t3.get("frame_recover_guard", 0.0)), 1.0),
		"teach: 2 resets = 1.0 (%.1f)" % float(t3.get("frame_recover_guard", 0.0)))
	# Nothing tried: no entry.
	var recs4 := [{"edge": "e046", "tried": 0, "landed": 0, "missed": 0, "reset": 0}]
	var t4: Dictionary = MatReceipt.teach(recs4)
	_check(not t4.has("frame_recover_guard"), "teach: nothing tried = no entry")


## ONE real open: NoGi.athlete with a plan whose lines come from MatLines.draft, BjjOpen.run_open on a seeded rng:
## the receipt's tried counts equal a direct count of the rows' paths.
func _real_open() -> void:
	var ana := NoGi.athlete()
	var rules := BjjTree.rules_for("white")
	# Give Ana a plan with drafted lines.
	ana["bjj"]["rear_naked_choke"] = 30.0
	var leaks := ["back_bottom", "side_control_bottom"]
	var plan := MatLines.draft(ana, leaks, rules)
	ana["bjj_plan"] = plan
	# Run a real open.
	var rng := RandomNumberGenerator.new()
	rng.seed = 5150
	var o := {"name": "Test Open"}
	var res: Dictionary = BjjOpen.run_open(ana, o, 100, rng)
	var rows: Array = res.get("matches", [])
	_check(rows.size() > 0, "real open has %d bout rows" % rows.size())
	# Build the receipt.
	var recs: Array = MatReceipt.receipt(plan, ana, rows, rules)
	_check(recs.size() > 0, "receipt has %d entries" % recs.size())
	# Verify each receipt's tried count matches a direct count of the rows' paths.
	for r in recs:
		var edge_id: String = str(r["edge"])
		var direct := 0
		for row in rows:
			var path: Variant = (row as Dictionary).get("path", [])
			if not (path is Array):
				continue
			for p in path:
				if not (p is Array) or p.size() < 4:
					continue
				if int(p[1]) == 0 and str(p[0]) == edge_id:
					direct += 1
		_check(int(r["tried"]) == direct,
			"real open: %s tried %d matches direct count %d" % [edge_id, int(r["tried"]), direct])
	# Season add and teach on the real receipts.
	var book := {}
	MatReceipt.season_add(book, recs)
	_check(not book.is_empty(), "season book is not empty after real open")
	var t: Dictionary = MatReceipt.teach(recs)
	# Teach should have entries only for moves that were tried.
	for mv_id in t:
		_check(float(t[mv_id]) > 0.0 and float(t[mv_id]) <= 3.0 * float(recs.size()),
			"teach: %s gain %.1f in range" % [str(mv_id), float(t[mv_id])])
