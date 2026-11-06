extends SceneTree
## S389 CLASH: what the match shows is what was rolled, and both women fight with what they drilled.

const BjjMatch := preload("res://scripts/rules/BjjMatch.gd")
const BjjClash := preload("res://scripts/rules/BjjClash.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)


func _st(gas: float) -> Dictionary:
	return {"skill": [42.0, 30.0], "strength": [60.0, 48.0], "gas": [gas, 1.0], "cardio": [55.0, 50.0]}


func _initialize() -> void:
	# The factors add up to the real odds, for every kind, tired or fresh.
	for kind in BjjMatch.KIND_BASE:
		for gas in [1.0, 0.5, 0.2]:
			for m in [30.0, 60.0]:
				var st := _st(gas)
				var o := {"kind": kind, "m": m, "pts": 2, "odds": BjjMatch.odds(kind, m, 42.0, 30.0, gas, 60.0, 48.0)}
				var sum := 0.0
				for x in BjjClash.factors(st, 0, o):
					sum += float(x["pts"]) / 100.0
				_check(is_equal_approx(clampf(sum, BjjMatch.ODDS_RANGE.x, BjjMatch.ODDS_RANGE.y), float(o["odds"])),
					"%s gas %.1f m %.0f: factors %.3f match odds %.3f" % [kind, gas, m, sum, float(o["odds"])])

	# The reason names the real cause.
	var names := ["Ana", "Kim"]
	var tired := {"kind": "takedown", "m": 30.0, "pts": 2, "odds": 0.2}
	_check(BjjClash.reason(BjjClash.factors({"skill": [30.0, 30.0], "strength": [50.0, 50.0], "gas": [0.1, 1.0]}, 0, tired), 0, false, names).contains("Ana is tiring"),
		"a gassed miss says so")
	var strong := {"kind": "pass", "m": 30.0, "pts": 3, "odds": 0.4}
	_check(BjjClash.reason(BjjClash.factors({"skill": [30.0, 30.0], "strength": [80.0, 50.0], "gas": [1.0, 1.0]}, 0, strong), 0, true, names).contains("Ana is stronger"),
		"a strength win says so")
	var even := {"kind": "advance", "m": 30.0, "pts": 0, "odds": 0.55}
	_check(BjjClash.reason(BjjClash.factors({"skill": [30.0, 30.0], "strength": [50.0, 50.0], "gas": [1.0, 1.0]}, 0, even), 0, true, names).contains("Nothing between them"),
		"an even move does not invent a reason")

	# The words: a landed finish is a tap, a miss is stopped, a score shows its points.
	var st2 := _st(1.0)
	_check(str(BjjClash.read(st2, 0, {"kind": "sub", "m": 30.0, "pts": 0, "odds": 0.2}, true, names)["word"]) == "LOCKED IN", "a landed submission locks in; the bodies tap, then the banner")
	_check(str(BjjClash.read(st2, 0, {"kind": "sweep", "m": 30.0, "pts": 2, "odds": 0.4}, true, names)["word"]) == "+2", "a landed sweep shows its points")
	_check(str(BjjClash.read(st2, 0, {"kind": "sweep", "m": 30.0, "pts": 2, "odds": 0.4}, false, names)["word"]) == "STOPPED", "a miss is stopped")
	_check(str(BjjClash.read(st2, 0, {"kind": "sub", "m": 30.0, "pts": 0, "odds": 0.1}, true, names)["chance"]).begins_with("Long shot"), "an upset says long shot")

	_check(BjjClash.title({"kind": "sweep", "title": "Bottom Rolls Onto Side"}) == "Sweep", "a raw step reads by what it does")
	_check(BjjClash.title({"kind": "pass", "title": "x"}, "Knee cut pass") == "Knee cut pass", "a drilled move reads by name")
	_check(BjjClash.title({"kind": "sub", "title": "Armbar"}) == "Armbar", "a submission keeps its name")

	# Finishes read by the submission, never the raw step name.
	_check(BjjMatch.sub_name(["armbar", "foo"]) == "Armbar" and BjjMatch.sub_name(["foo"]) == "Submission", "sub names come from the tag")

	# Both women are held to what they drilled.
	var st3 := {"skill": [30.0, 30.0], "strength": [50.0, 50.0], "gas": [1.0, 1.0], "cardio": [50.0, 50.0], "calls": 3, "settle_s": 1.0, "init": 1}
	var cand := [{"i": 0, "title": "Bottom Leg Freed", "tags": ["armbar"], "to_c": "guard", "top_after": 1}]
	_check(BjjMatch.offers(st3, {"bjj": {"armbar_guard": 10.0}}, 1, "guard", 1, cand).is_empty(), "a rival who never drilled it cannot try it")
	var got := BjjMatch.offers(st3, {"bjj": {"armbar_guard": 40.0}}, 1, "guard", 1, cand)
	_check(got.size() == 1 and str(got[0]["title"]) == "Armbar", "a rival who owns it can, under its real name")
	_check(BjjMatch.offers(st3, {}, 1, "guard", 1, cand).size() == 1, "a rival with no list stays on the plain moves")

	print("BJJ_CLASH %s failures=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(1 if failures > 0 else 0)
