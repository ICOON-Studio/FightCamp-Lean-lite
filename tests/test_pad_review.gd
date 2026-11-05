extends SceneTree
## S382 CARDFLIP1 (TRAINING_SCREEN_S381.md 5.6): the week review's PADS row from the night log (PadReview, pure).
##   1. rows: one per card in log order, before = its first night's before, after = its last night's after, the pad and
##      sparring nights it got, the tier crossed with the night that did it (two tiers in one week: the higher);
##   2. shown: crossed cards first, then the biggest gains, at most ROW_MAX; nights_text words;
##   3. the real week: Lucy's 1-1 at 25.2 on Monday's pads crosses usable on Monday, and the review row agrees with the
##      card projection (PadEdit.crossing on PadWeek.project - the same run_week).
## Population: Lucy (Data.lucy) with coach Luke (58), as in test_pad_week.

const Data := preload("res://scripts/state/Data.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const PadEdit := preload("res://scripts/rules/PadEdit.gd")
const PadReview := preload("res://scripts/rules/PadReview.gd")

var failures := 0


func _initialize() -> void:
	# 1. rows from a log
	var nights := {"pads": [0, 2, 4], "spar": [3]}
	var log := [[0, "combo:1-1", 25.2, 30.4], [0, "move:Uppercut", 10.0, 14.0], [2, "move:Uppercut", 14.0, 18.5],
		[3, "combo:1-1", 30.4, 31.1], [4, "own:1", 58.0, 61.0], [4, "combo:1-2", 84.0, 85.2]]
	var rows := PadReview.rows(log, nights)
	_check(rows.size() == 4 and str(rows[0]["card"]) == "combo:1-1" and str(rows[1]["card"]) == "move:Uppercut",
		"one row per card in log order (%d)" % rows.size())
	var r11: Dictionary = rows[0]
	_check(is_equal_approx(float(r11["before"]), 25.2) and is_equal_approx(float(r11["after"]), 31.1),
		"1-1: before its first night, after its last (%.1f -> %.1f)" % [float(r11["before"]), float(r11["after"])])
	_check(r11["pads"] == [0] and r11["spar"] == [3], "1-1: Mon pads, Thu spar (%s / %s)" % [str(r11["pads"]), str(r11["spar"])])
	var cr: Dictionary = r11["cross"]
	_check(str(cr.get("tier", "")) == "usable" and int(cr["dow"]) == 0 and str(cr["station"]) == "pads"
		and is_equal_approx(float(cr["before"]), 25.2) and is_equal_approx(float(cr["after"]), 30.4),
		"1-1 crossed usable on Monday's pads 25.2 -> 30.4 (%s)" % str(cr))
	_check((rows[1]["cross"] as Dictionary).is_empty() and rows[1]["pads"] == [0, 2], "Uppercut: Mon Wed, no tier crossed")
	_check(str(rows[2]["cross"].get("tier", "")) == "sharp" and str(rows[3]["cross"].get("tier", "")) == "signature",
		"60 = sharp, 85 = signature")
	var two := PadReview.rows([[0, "combo:1-1", 28.0, 45.0], [2, "combo:1-1", 45.0, 61.0]], nights)
	_check(str(two[0]["cross"].get("tier", "")) == "sharp" and int(two[0]["cross"]["dow"]) == 2, "two tiers in a week: the higher, on its night")
	_check(PadReview.rows([], nights).is_empty(), "no nights drilled: no row")

	# 2. shown + words
	var many := PadReview.rows(log + [[1, "move:Jab", 50.0, 50.4]], nights)
	var sh := PadReview.shown(many)
	_check(sh.size() == PadReview.ROW_MAX, "at most %d cards (%d)" % [PadReview.ROW_MAX, sh.size()])
	_check(sh.slice(0, 3).all(func(x): return not (x["cross"] as Dictionary).is_empty()), "the crossed cards first")
	_check(str(sh[3]["card"]) == "move:Uppercut", "then the biggest gain (the Uppercut +8.5 over the Jab +0.4): %s" % str(sh[3]["card"]))
	_check(PadReview.nights_text(r11) == "Mon pads, Thu spar", "nights words: %s" % PadReview.nights_text(r11))
	_check(PadReview.nights_text(rows[1]) == "Mon Wed pads", "nights words: %s" % PadReview.nights_text(rows[1]))

	# 3. the real week
	var c := Career.quick_start()
	c.coach = Data.coach("reid")
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["combos"] = {"1-1": 25.2}
	var n := PadWeek.nights_for(1, false)
	var week := {"mon": [{"card": "combo:1-1", "share": 1.0}]}
	var proj := PadWeek.project(f, n, week, 58.0, PadWeek.STATION_TIER, 1)
	var want := PadEdit.crossing(f, "combo:1-1", proj["combo:1-1"])
	var ran := PadWeek.run_week(f, n, week, 58.0, PadWeek.STATION_TIER)
	var got: Dictionary = PadReview.rows(ran["log"], n)[0]
	_check(str(got["card"]) == "combo:1-1" and str(got["cross"].get("tier", "")) == "usable" and int(got["cross"]["dow"]) == 0,
		"Lucy's 1-1 crosses usable on Monday's pads (%s)" % str(got["cross"]))
	_check(not want.is_empty() and is_equal_approx(float(want["after"]), float(got["cross"]["after"]))
		and int(want["dow"]) == int(got["cross"]["dow"]), "the review's crossing is the card's projection (%s vs %s)" % [str(want), str(got["cross"])])
	_check(is_equal_approx(float(got["after"]), PadWeek.mastery(f, "combo:1-1")), "after = the mastery the week left")
	print("test_pad_review: %s" % ("PASS" if failures == 0 else "%d FAILED" % failures))
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok   " if ok else "  FAIL ") + label)
