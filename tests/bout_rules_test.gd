extends SceneTree
## BoutRules: camp cost and gain, the weigh-in line, the night's strength, rounds, cards and the reasons. Population: Lucy
## Jackson (lean Data.lucy(), 3-1 out-boxer) against the three legal opponents and the 14-2 mismatch from Data.

const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Data := preload("res://scripts/state/Data.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_camp()
	_test_weigh()
	_test_power()
	_test_rounds()
	_test_cards_and_why()
	print("BOUT_RULES checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


func _test_camp() -> void:
	_check(BoutRules.camp_cost(1, false) == 0, "a light camp without film is free")
	_check(BoutRules.camp_cost(2, true) == 450, "standard + film = $300 + $150")
	_check(BoutRules.camp_cost(3, false) == 700, "a hard camp is $700")
	var camp := {"focus": "conditioning", "protocol": 3}
	_check(is_equal_approx(BoutRules.camp_gain_mult(camp, "conditioning"), 1.35), "a hard camp trains its focus x1.35")
	_check(is_equal_approx(BoutRules.camp_gain_mult(camp, "power"), 1.0), "off the focus the camp adds nothing")
	_check(is_equal_approx(BoutRules.camp_gain_mult({}, "conditioning"), 1.0), "no camp, no multiplier")
	# S380 the protocol's evenings and heavy legs
	var ev0 := BoutRules.camp_evening({})
	var ev3 := BoutRules.camp_evening({"focus": "power", "protocol": 3})
	var ev1 := BoutRules.camp_evening({"focus": "power", "protocol": 1})
	_check(float(ev0["drill"]) == 0.0 and float(ev0["load"]) == 1.0, "no camp: plain evenings")
	_check(str(ev3["stat"]) == "power" and is_equal_approx(float(ev3["drill"]), 0.09) and is_equal_approx(float(ev3["load"]), 1.2),
		"a Hard camp's pads drill its stat at 0.09, evenings x1.2")
	_check(float(ev1["drill"]) == 0.0 and is_equal_approx(float(ev1["load"]), 0.75), "a Light camp keeps plain pads, evenings x0.75")
	_check(BoutRules.stale_energy(50.0) == 0.0 and is_equal_approx(BoutRules.stale_energy(54.0), 8.0) and BoutRules.stale_energy(75.0) == 20.0,
		"heavy legs: 0 at 50 fatigue, 8 at 54, capped 20")
	_check(BoutRules.stale_energy(70.0, {}) == 0.0 and BoutRules.stale_energy(70.0, {"protocol": 0}) == 0.0, "no camp, no heavy legs")
	_check(BoutRules.camp_level(3) == "hard" and BoutRules.camp_level(1) == "light" and BoutRules.camp_level(2) == "normal", "camp levels")


func _test_weigh() -> void:
	_check(BoutRules.made_weight(61.2, 61.2), "on the limit makes weight")
	_check(BoutRules.made_weight(61.25, 61.2), "within 0.05 kg makes weight")
	_check(not BoutRules.made_weight(61.4, 61.2), "0.2 kg over misses")


func _test_power() -> void:
	var s: Dictionary = Data.lucy()["stats"]
	var bare := BoutRules.fight_power(s, {}, 1, "")
	var camped := BoutRules.fight_power(s, {"focus": "conditioning", "protocol": 2}, 3, "")
	_check(camped - bare > 3.0, "a standard camp + full film is worth over 3 points on the night (%.2f)" % (camped - bare))
	_check(BoutRules.fight_power(s, {}, 1, "calm") > bare, "a corner call always helps a little")
	# Lucy: technique 60.1 (not above 61) and power 58.4 (not above 60): both calls are the weak kind for her today.
	_check(is_equal_approx(BoutRules.fight_power(s, {}, 1, "long") - bare, BoutRules.CORNER_WEAK), "long with 60 technique is the small edge")
	var sharp := s.duplicate()
	sharp["technique"] = 63.0
	_check(is_equal_approx(BoutRules.fight_power(sharp, {}, 1, "long") - BoutRules.fight_power(sharp, {}, 1, ""), BoutRules.CORNER_STRONG),
		"long with 63 technique is the full edge")
	_check(BoutRules.auto_corner(sharp) == "long" and BoutRules.auto_corner(s) == "long", "sim picks her better tool")


func _test_rounds() -> void:
	var s: Dictionary = Data.lucy()["stats"]
	var camp := {"focus": "conditioning", "protocol": 2}
	var maria: Dictionary = Data.OPPONENTS[0]
	var r := BoutRules.play_round(1, s, camp, 3, "", maria, 0.5, 0.5)
	_check(bool(r["won"]) == (float(r["mine"]) >= float(r["theirs"])), "a round goes to the higher score")
	var r3 := BoutRules.play_round(3, s, camp, 3, "", maria, 0.5, 0.5)
	_check(float(r3["theirs"]) < float(r["theirs"]), "Maria fades in round 3")
	_check(float(r3["mine"]) < float(r["mine"]), "Lucy (conditioning under 64) fades in round 3 too")
	# Across a spread of rolls: a prepared Lucy beats Maria more often than not, and the mismatch beats her almost always.
	var wins_maria := 0
	var wins_dana := 0
	var n := 0
	for a in 10:
		for b in 10:
			n += 1
			if bool(BoutRules.play_round(1, s, camp, 3, "", maria, a / 10.0 + 0.05, b / 10.0 + 0.05)["won"]):
				wins_maria += 1
			if bool(BoutRules.play_round(1, s, camp, 3, "", Data.MISMATCH, a / 10.0 + 0.05, b / 10.0 + 0.05)["won"]):
				wins_dana += 1
	_check(wins_maria > n / 2 and wins_maria < n, "prepared Lucy wins most rounds against Maria, not all (%d of %d)" % [wins_maria, n])
	# S305 J-UPSETS1: with ROUND_SPREAD 27, even a strong mismatch can lose a round sometimes (upsets are possible).
	_check(wins_dana < n * 0.40, "against the 14-2 mismatch she wins few rounds (%d of %d, S305: was 0 at spread 6)" % [wins_dana, n])


func _test_cards_and_why() -> void:
	_check(BoutRules.scorecards(3) == ["30-27", "30-27", "29-28"], "three rounds: 30-27 30-27 29-28")
	_check(BoutRules.scorecards(1)[0] == "28-29", "one round: she loses 28-29")
	var rounds := [{"n": 1, "won": true, "corner": ""}, {"n": 2, "won": true, "corner": "body"}, {"n": 3, "won": false, "corner": "calm"}]
	var why := BoutRules.why(rounds, true, 2, "Conditioning", 3, "left hook to the body", "Lucy")
	_check(why.size() == 3, "three reasons")
	_check(str(why[0]).contains("film study") and str(why[1]).contains("conditioning") and str(why[2]).contains("round 2"),
		"film, camp, then the corner call that won a round: %s" % str(why))
	var bare := BoutRules.why([{"n": 1, "won": false, "corner": ""}], false, 0, "", 1, "x", "Lucy")
	_check(bare.size() == 1 and str(bare[0]).begins_with("No camp"), "no camp says so")
