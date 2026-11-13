extends SceneTree
## S458 PROREAD1 - professionals get read: the target line, the split, the feint, the season proof.
## Hand-made bout records only; no fixtures.

const P := preload("res://scripts/rules/ProRead.gd")

var _fails := 0


func _initialize() -> void:
	# Empty history -> {}.
	_check(P.target([], {}).is_empty(), "empty history -> {}")

	# Amateur-only history -> {}.
	var amat := [{"pro": false, "fired": {"1-2": 20}}]
	_check(P.target(amat, {}).is_empty(), "amateur-only history -> {}")

	# One pro bout as the ONLY bout -> target from it (the second pro bout is read on the first's tape).
	var one := [{"pro": true, "fired": {"1-2": 10, "Jab": 3}}]
	var t1 := P.target(one, {})
	_check(t1.get("line") == "1-2" and t1.get("count") == 10, "one pro bout: the most fired line")

	# Last two pro bouts: {"1-2": 10, "Jab": 4} + {"1-2": 6, "Body hook": 5} -> line "1-2" (16), no split.
	var two := [
		{"pro": true, "fired": {"1-2": 10, "Jab": 4}},
		{"pro": true, "fired": {"1-2": 6, "Body hook": 5}},
	]
	var t2 := P.target(two, {})
	_check(t2.get("line") == "1-2" and t2.get("count") == 16, "last two pro bouts: 1-2 at 16")
	_check(not t2.get("split", false), "no split when second is not a held tier")

	# An OLDER third pro bout with {"Jab": 50} is ignored.
	var three := [
		{"pro": true, "fired": {"Jab": 50}},
		{"pro": true, "fired": {"1-2": 10, "Jab": 4}},
		{"pro": true, "fired": {"1-2": 6, "Body hook": 5}},
	]
	var t3 := P.target(three, {})
	_check(t3.get("line") == "1-2" and t3.get("count") == 16, "older third pro bout ignored")

	# Split: {"1-2": 10, "Lead hook": 9}, tiers {"Lead hook": "Sharp"} -> split, second "Lead hook".
	var sp := [
		{"pro": true, "fired": {"1-2": 10, "Lead hook": 9}},
	]
	var tsp := P.target(sp, {"Lead hook": "Sharp"})
	_check(tsp.get("split", false) and tsp.get("second") == "Lead hook", "split when second is Sharp and >= 0.8 x first")

	# Same counts with tiers {"Lead hook": "Usable"} -> no split.
	var tsp2 := P.target(sp, {"Lead hook": "Usable"})
	_check(not tsp2.get("split", false), "no split when tier is Usable")

	# {"Lead hook": 7} Sharp (0.7) -> no split (below 0.8 x 10).
	var low := [{"pro": true, "fired": {"1-2": 10, "Lead hook": 7}}]
	var tlow := P.target(low, {"Lead hook": "Sharp"})
	_check(not tlow.get("split", false), "no split when count is below SPLIT_AT x first")

	# Tie {"Cross": 5, "1-2": 5} -> "1-2" (alphabetical).
	var tie := [{"pro": true, "fired": {"Cross": 5, "1-2": 5}}]
	var ttie := P.target(tie, {})
	_check(ttie.get("line") == "1-2", "tie broken alphabetically: 1-2 before Cross")

	# round_line: split -> R1 line, R2 second, R3 line; not split -> line every round.
	var split_t := {"line": "1-2", "second": "Lead hook", "split": true, "count": 19}
	_check(P.round_line(split_t, 1) == "1-2", "split R1: line")
	_check(P.round_line(split_t, 2) == "Lead hook", "split R2: second")
	_check(P.round_line(split_t, 3) == "1-2", "split R3: line")
	var flat_t := {"line": "1-2", "second": "", "split": false, "count": 16}
	_check(P.round_line(flat_t, 1) == "1-2" and P.round_line(flat_t, 4) == "1-2", "not split: line every round")
	_check(P.round_line({}, 1) == "", "empty target -> empty round_line")

	# share: off-target line 0; on target 1; split 0.5; feinted + roll 0.3 -> 0; feinted + roll 0.7 -> 1.
	_check(P.share(flat_t, 1, "Jab", false, 0.5) == 0.0, "off-target line -> 0")
	_check(P.share(flat_t, 1, "1-2", false, 0.5) == 1.0, "on target, no split -> 1")
	_check(P.share(split_t, 1, "1-2", false, 0.5) == 0.5, "on target, split -> 0.5")
	_check(P.share(flat_t, 1, "1-2", true, 0.3) == 0.0, "feinted + roll 0.3 < 0.5 -> 0")
	_check(P.share(flat_t, 1, "1-2", true, 0.7) == 1.0, "feinted + roll 0.7 >= 0.5 -> 1")
	_check(P.share({}, 1, "1-2", false, 0.5) == 0.0, "empty target -> share 0")

	# proof: two read pro bouts {fired 3, won 2} + {fired 4, won 2} -> true.
	var pr1 := [
		{"pro": true, "fired": {"1-2": 10}, "read": {"fired_in_read": 3, "won_in_read": 2, "split": false, "line": "1-2"}},
		{"pro": true, "fired": {"1-2": 8}, "read": {"fired_in_read": 4, "won_in_read": 2, "split": false, "line": "1-2"}},
	]
	_check(P.proof(pr1), "two read pro bouts with fired>=3 and won*2>=fired -> true")

	# {fired 2, won 2} -> false (fired < 3).
	var pr2 := [
		{"pro": true, "fired": {"1-2": 10}, "read": {"fired_in_read": 3, "won_in_read": 2, "split": false, "line": "1-2"}},
		{"pro": true, "fired": {"1-2": 8}, "read": {"fired_in_read": 2, "won_in_read": 2, "split": false, "line": "1-2"}},
	]
	_check(not P.proof(pr2), "fired_in_read 2 < 3 -> false")

	# One split bout + one {3, 2} -> true (split passes regardless).
	var pr3 := [
		{"pro": true, "fired": {"1-2": 10}, "read": {"fired_in_read": 1, "won_in_read": 0, "split": true, "line": "1-2"}},
		{"pro": true, "fired": {"1-2": 8}, "read": {"fired_in_read": 3, "won_in_read": 2, "split": false, "line": "1-2"}},
	]
	_check(P.proof(pr3), "one split bout + one passing bout -> true")

	# Only one read bout -> false.
	var pr4 := [
		{"pro": true, "fired": {"1-2": 10}, "read": {"fired_in_read": 3, "won_in_read": 2, "split": false, "line": "1-2"}},
		{"pro": true, "fired": {"1-2": 8}},
	]
	_check(not P.proof(pr4), "only one read bout -> false")

	# Amateur bouts between them do not count.
	var pr5 := [
		{"pro": true, "fired": {"1-2": 10}, "read": {"fired_in_read": 3, "won_in_read": 2, "split": false, "line": "1-2"}},
		{"pro": false, "fired": {"1-2": 20}, "read": {"fired_in_read": 10, "won_in_read": 0, "split": false, "line": "1-2"}},
		{"pro": true, "fired": {"1-2": 8}, "read": {"fired_in_read": 4, "won_in_read": 2, "split": false, "line": "1-2"}},
	]
	_check(P.proof(pr5), "amateur bouts between do not count")

	# words: contains the line; split names both; no pronoun.
	var w1 := P.words(flat_t)
	_check(w1.contains("1-2"), "words contains line")
	_check(not _has_pronoun(w1), "words has no he/she/his/her pronoun")
	var w2 := P.words(split_t)
	_check(w2.contains("1-2") and w2.contains("Lead hook"), "split words names both lines")
	_check(P.words({}) == "", "empty target -> empty words")

	# Two different histories give different targets (the module reads the record, not a constant).
	var ha := [{"pro": true, "fired": {"Jab": 20}}]
	var hb := [{"pro": true, "fired": {"Cross": 20}}]
	var ta := P.target(ha, {})
	var tb := P.target(hb, {})
	_check(ta.get("line") != tb.get("line"), "different histories give different targets")

	print("PRO_READ failures=%d" % _fails)
	quit(_fails)


func _check(cond: bool, _msg: String) -> void:
	if not cond:
		_fails += 1
		print("FAIL: ", _msg)


func _has_pronoun(s: String) -> bool:
	var padded := " " + s.to_lower() + " "
	return padded.contains(" he ") or padded.contains(" she ") or padded.contains(" his ") or padded.contains(" her ")
