extends SceneTree
## S361 the week review's headline (ReviewReveal):
##   1. the order: injury > new weapon > peak camp > ranking won or climbed > biggest stat tick > nothing,
##   2. a ranking that dropped, a "No peak bonus" line and a stat that moved without ticking are not headlines,
##   3. the stat headline names the stat that gained the most among those that ticked a point, and its new whole value.
## Population: Lucy Jackson (out-boxer, 54 kg) and Maria Ortega (pressure fighter) as week reports.

const Data := preload("res://scripts/state/Data.gd")
const ReviewReveal := preload("res://scripts/rules/ReviewReveal.gd")

var _fails := 0


func _initialize() -> void:
	var rows := [{"st": "power", "before": 55.8, "after": 56.1}, {"st": "technique", "before": 61.2, "after": 62.4},
		{"st": "chin", "before": 50.0, "after": 50.6}]
	var lucy := {"name": "Lucy Jackson", "rows": rows, "new_weapon": "Left hook", "rank_before": 5, "rank_after": 3,
		"div": "54 kg", "peak": "Peak camp: Lucy met all three goal lines - +1 to every stat tonight.",
		"injury": "Sore hand (minor) - heals in 1 week, fit on 14 Mar"}
	var h := ReviewReveal.headline(lucy, Data.LABEL)
	_check(h["kind"] == "injury" and str(h["text"]).begins_with("Hurt: Sore hand"), "an injury beats everything: %s" % h["text"])
	lucy["injury"] = ""
	h = ReviewReveal.headline(lucy, Data.LABEL)
	_check(h["kind"] == "weapon" and h["text"] == "NEW WEAPON: the left hook.", "then a new weapon: %s" % h["text"])
	lucy["new_weapon"] = ""
	_check(ReviewReveal.headline(lucy, Data.LABEL)["kind"] == "peak", "then a peak camp")
	lucy["peak"] = "No peak bonus: Lucy missed (weight)."
	h = ReviewReveal.headline(lucy, Data.LABEL)
	_check(h["kind"] == "rank" and str(h["text"]).contains("(up from 5)"), "a missed peak is no headline; the climb is: %s" % h["text"])
	var maria := {"name": "Maria Ortega", "rows": rows, "rank_before": 0, "rank_after": 7, "div": "57 kg"}
	_check(str(ReviewReveal.headline(maria, Data.LABEL)["text"]).ends_with("a first ranking."), "a first ranking")
	maria["rank_before"] = 4
	h = ReviewReveal.headline(maria, Data.LABEL)
	_check(h["kind"] == "stat" and h["text"] == "Technique up to 62.", "a drop is no headline; the biggest tick is: %s" % h["text"])
	maria["rows"] = [{"st": "power", "before": 55.1, "after": 55.9}, {"st": "chin", "before": 50.0, "after": 50.4}]
	h = ReviewReveal.headline(maria, Data.LABEL)
	_check(h["kind"] == "" and h["text"] == "", "+0.8 that crossed no point: a quiet week, no headline")
	print("REVIEW_REVEAL %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
