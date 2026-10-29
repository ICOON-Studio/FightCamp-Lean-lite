extends SceneTree
## RoundScript (Kalli K-FIGHT3D1): the 3D ring shows the round the words settled, never a different one.
##   1. margins from the power gap, 2. landed punches per margin (4-3, 5-2, 6-1) for either winner,
##   3. the winner lands last and only she steps in (an out-boxer winner steps out instead),
##   4. round 2+ opens on the corner call, 5. times run 2 s .. bell - 2 s in order, 6. every word line rides a beat,
##   7. the highlights cut keeps every landed beat, 8. the same seed gives the same script.

const RS := preload("res://scripts/rules/RoundScript.gd")

var failures := 0
const LINES := ["Lucy finds the jab early.", "Holly lands a hook coming in.", "Lucy doubles the jab and walks Holly onto the right hand."]


func _initialize() -> void:
	_check(RS.margin({"mine": 60.0, "theirs": 59.0}) == "close", "a 1.0 gap is a close round")
	_check(RS.margin({"mine": 60.0, "theirs": 62.5}) == "clear", "a 2.5 gap is a clear round")
	_check(RS.margin({"mine": 66.0, "theirs": 61.0}) == "dominant", "a 5.0 gap is a dominant round")
	for case in [[60.0, 59.0, true, [4, 3]], [60.0, 62.5, false, [5, 2]], [66.0, 61.0, true, [6, 1]], [55.0, 61.0, false, [6, 1]]]:
		for seed in [1, 7, 42]:
			var r := {"n": 1, "won": case[2], "mine": case[0], "theirs": case[1], "corner": "", "lines": LINES}
			var s := RS.build(r, "Out-boxer", "Pressure fighter", 40.0, seed)
			var w := "a" if bool(case[2]) else "b"
			var l := "b" if w == "a" else "a"
			var got := RS.landed(s)
			_check(int(got[w]) == int(case[3][0]) and int(got[l]) == int(case[3][1]),
				"%s round, winner %s, seed %d: lands %d-%d (got %d-%d)" % [s["margin"], w, seed, case[3][0], case[3][1], got[w], got[l]])
			var beats: Array = s["beats"]
			var last_land := {}
			for b in beats:
				if str(b["result"]) == "lands":
					last_land = b
			_check(str(last_land["who"]) == w and bool(last_land["big"]), "seed %d: the winner lands last, and it is the round's big shot" % seed)
			var in_by := beats.filter(func(b): return str(b["move"]) == "step_in").map(func(b): return b["who"])
			var expect_in := l if w == "a" else w   # a is the out-boxer: when she wins she steps out, the other comes in
			_check(in_by.size() == 1 and str(in_by[0]) == expect_in, "seed %d: the step in is %s's (out-boxer rule)" % [seed, expect_in])
			var ordered := true
			for i in range(1, beats.size()):
				if float(beats[i]["t"]) <= float(beats[i - 1]["t"]):
					ordered = false
			_check(ordered and float(beats[0]["t"]) >= 2.0 and float(beats[-1]["t"]) <= 38.0, "seed %d: beats in order between 2 s and 38 s" % seed)
			var caps := beats.map(func(b): return str(b["caption"]))
			_check(LINES.all(func(x): return caps.has(x)), "seed %d: every word line is a caption" % seed)
			_check(RS.highlights(s).filter(func(b): return str(b["result"]) == "lands").size() == int(got["a"]) + int(got["b"]),
				"seed %d: the highlights keep every landed punch" % seed)
			_check(beats.size() >= 18 and beats.size() <= 30, "seed %d: 18-30 beats, about a third landing (got %d)" % [seed, beats.size()])
	var r2 := {"n": 2, "won": false, "mine": 60.0, "theirs": 61.0, "corner": "long", "lines": LINES}
	var s2 := RS.build(r2, "Slugger", "Slugger", 40.0, 3)
	_check(str(s2["beats"][0]["who"]) == "a" and str(s2["beats"][0]["move"]) == "jab" and str(s2["beats"][1]["move"]) == "jab",
		"round 2 with 'stay long': she opens with two jabs")
	_check(str(s2["beats"][0]["caption"]).begins_with("Stay long"), "the call's caption runs over its first beat")
	var g := RS.landed(s2)
	_check(int(g["b"]) == 4 and int(g["a"]) == 3, "the call's landed jab counts: a close round she loses stays 3-4 (got %d-%d)" % [g["a"], g["b"]])
	_check(JSON.stringify(RS.build(r2, "Slugger", "Slugger", 40.0, 3)) == JSON.stringify(s2), "the same seed gives the same script")
	print("ROUND_SCRIPT failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)
