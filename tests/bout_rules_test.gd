extends SceneTree
## BoutRules: camp cost and gain, the weigh-in line, the night's strength, rounds, cards and the reasons. Population: Lucy
## Jackson (lean Data.lucy(), 3-1 out-boxer) against the three legal opponents and the 14-2 mismatch from Data.

const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Data := preload("res://scripts/state/Data.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_camp()
	_test_weigh()
	_test_power()
	_test_rounds()
	_test_cards_and_why()
	_test_southpaw()
	print("BOUT_RULES checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


func _test_camp() -> void:
	# S381 C229 stage 2: the club's own nights are free; the outside sparring partner is the only cash ($40 x 4 visits).
	_check(BoutRules.camp_cost(1, false) == 0 and BoutRules.camp_cost(2, false) == 0 and BoutRules.camp_cost(3, false) == 0,
		"Light / Standard / Hard cost the club nothing")
	_check(BoutRules.partner_fee() == 160 and BoutRules.camp_cost(2, true) == 160 and BoutRules.camp_cost(3, true) == 160,
		"the outside partner: $40 a visit x 4 = $160, the only camp cash")
	_check(BoutRules.partner_word({"stance": "southpaw", "style": "Pressure fighter"}) == "southpaw mate"
		and BoutRules.partner_word({"stance": "orthodox", "style": "Pressure fighter"}) == "pressure mate"
		and BoutRules.partner_word({"stance": "orthodox", "style": "Out-boxer"}) == "sparring mate", "the partner copies her stance, then her style")
	var camp := {"focus": "conditioning", "protocol": 3}
	_check(is_equal_approx(BoutRules.camp_gain_mult(camp, "conditioning"), 1.35), "a hard camp trains its focus x1.35")
	_check(is_equal_approx(BoutRules.camp_gain_mult(camp, "power"), 1.0), "off the focus the camp adds nothing")
	_check(is_equal_approx(BoutRules.camp_gain_mult({}, "conditioning"), 1.0), "no camp, no multiplier")
	# S380 the protocol's evenings and heavy legs
	var ev0 := BoutRules.camp_evening({})
	var ev3 := BoutRules.camp_evening({"focus": "power", "protocol": 3})
	var ev1 := BoutRules.camp_evening({"focus": "power", "protocol": 1})
	_check(float(ev0["drill"]) == 0.0 and float(ev0["load"]) == 1.0, "no camp: plain evenings")
	# S382 EVENINGS1: per pad night (the strip's 3 Hard nights, not 5); Hard's volume is its third night, not a x1.2
	_check(str(ev3["stat"]) == "power" and is_equal_approx(float(ev3["drill"]), 0.14) and is_equal_approx(float(ev3["load"]), 1.0),
		"a Hard camp's pad nights drill its stat at 0.14, evenings x1.0")
	_check(float(ev1["drill"]) == 0.0 and is_equal_approx(float(ev1["load"]), 0.75), "a Light camp keeps plain pads, evenings x0.75")
	_check(BoutRules.tank(50.0) == 0.0 and is_equal_approx(BoutRules.tank(54.0), 8.0) and BoutRules.tank(75.0) == 20.0,
		"the Tank's tiredness part: 0 at 50, 8 at 54, capped 20")
	# S433 NOCAMP1 + TANK1: the scale (same day 1 a 0.1 kg, 2 past 0.5; the day before 1 a 0.2 kg), the last bout, cap 25
	_check(is_equal_approx(BoutRules.tank(40.0, 0.3), 3.0) and is_equal_approx(BoutRules.tank(40.0, 0.7), 9.0)
		and is_equal_approx(BoutRules.tank(40.0, 0.4, -1, false), 2.0), "the scale: 0.3 kg 3, 0.7 kg 9 on the day, 0.4 kg 2 the day before")
	_check(BoutRules.tank(40.0, 0.0, 7) == 8.0 and BoutRules.tank(40.0, 0.0, 14) == 4.0 and BoutRules.tank(40.0, 0.0, 15) == 0.0
		and BoutRules.tank(80.0, 0.5, 3) == BoutRules.TANK_MAX, "the last bout 8 / 4 / 0; all together at most 25")
	_check(BoutRules.days_since_bout([{"d": 10, "fid": "a"}, {"d": 3, "fid": "a"}, {"d": 12, "fid": "b"}], "a", 17) == 7
		and BoutRules.days_since_bout([], "a", 17) == -1, "days since her own newest bout")
	_check(BoutRules.camp_level(3) == "hard" and BoutRules.camp_level(1) == "light" and BoutRules.camp_level(2) == "normal", "camp levels")


## S381 C229 stage 3: an orthodox boxer facing a southpaw with no southpaw in her camp loses 0.6 in round 1 only; the
## southpaw mate (or a lefty week) takes it away and adds nothing; a southpaw herself is never caught out.
func _test_southpaw() -> void:
	var sp := {"stance": "southpaw", "style": "Pressure fighter"}
	var orth := {"stance": "orthodox", "style": "Pressure fighter"}
	var none := {"protocol": 2, "partner": false}
	var mate := {"protocol": 2, "partner": true}
	_check(BoutRules.never_faced("orthodox", sp, none) and BoutRules.never_faced("", sp, {}), "orthodox vs a southpaw, no mate: never faced one")
	_check(is_equal_approx(BoutRules.stance_edge(1, "orthodox", sp, none), -0.6), "round 1 costs 0.6")
	_check(BoutRules.stance_edge(2, "orthodox", sp, none) == 0.0 and BoutRules.stance_edge(3, "orthodox", sp, none) == 0.0,
		"rounds 2 and 3 cost nothing")
	_check(BoutRules.stance_edge(1, "orthodox", sp, mate) == 0.0 and not BoutRules.never_faced("orthodox", sp, mate),
		"the southpaw mate takes it away")
	_check(BoutRules.stance_edge(1, "orthodox", sp, none, true) == 0.0, "a lefty week takes it away too")
	_check(BoutRules.stance_edge(1, "orthodox", orth, none) == 0.0, "an orthodox opponent costs nothing")
	_check(BoutRules.stance_edge(1, "southpaw", orth, none) == 0.0 and BoutRules.stance_edge(1, "southpaw", sp, none) == 0.0,
		"the mirror: a southpaw spars orthodox club mates every night - never caught out")
	var plus := false
	for n in [1, 2, 3]:
		for st in ["orthodox", "southpaw"]:
			for o in [sp, orth]:
				for cp in [none, mate, {}]:
					plus = plus or BoutRules.stance_edge(n, st, o, cp) > 0.0
	_check(not plus, "no plus edge anywhere")
	_check(BoutRules.partner_matches(sp) and BoutRules.partner_matches(orth)
		and not BoutRules.partner_matches({"stance": "orthodox", "style": "Out-boxer"}), "the mate matches her stance or style")


func _test_weigh() -> void:
	_check(BoutRules.made_weight(61.2, 61.2), "on the limit makes weight")
	_check(BoutRules.made_weight(61.25, 61.2), "within 0.05 kg makes weight")
	_check(not BoutRules.made_weight(61.4, 61.2), "0.2 kg over misses")


func _test_power() -> void:
	var s: Dictionary = Data.lucy()["stats"]
	var bare := BoutRules.fight_power(s, {}, 0, "")
	var camped := BoutRules.fight_power(s, {"focus": "conditioning", "protocol": 2}, 3, "")
	# S381 C229 stage 4: Standard 0.6 + three answered tells 1.2 = 1.8; S433 NOCAMP1: an amateur with no camp pays no
	# NO_CAMP_EDGE (a professional with no camp still does: -1.5).
	_check(is_equal_approx(camped - bare, 1.8), "a standard camp + three answered tells is worth 1.8 points on the night (%.2f)" % (camped - bare))
	_check(is_equal_approx(BoutRules.fight_power(s, {}, 0, "", true) - bare, BoutRules.NO_CAMP_EDGE)
		and is_equal_approx(BoutRules.night_edge({}, 0), 0.0), "no camp: the professional pays NO_CAMP_EDGE, the amateur nothing")
	_check(is_equal_approx(BoutRules.fight_power(s, {}, 1, "") - bare, BoutRules.FILM_PER_ANSWER), "one answered tell: +0.4")
	_check(is_equal_approx(BoutRules.film_edge(0), 0.0) and is_equal_approx(BoutRules.film_edge(2), 0.8)
		and is_equal_approx(BoutRules.film_edge(5), BoutRules.FILM_EDGE_MAX), "film: 0.4 a tell answered, at most 1.2")
	var edges: Array = BoutRules.PROTOCOLS.map(func(p): return float(p["edge"]))
	_check(edges == [0.0, 0.25, 0.6, 1.0] and is_equal_approx(BoutRules.NO_CAMP_EDGE, -1.5),
		"the flat camp edges halved: Light 0.25 / Standard 0.6 / Hard 1.0, no camp still -1.5 (%s)" % str(edges))
	_check(BoutRules.fight_power(s, {}, 0, "calm") > bare, "a corner call always helps a little")
	# Lucy: technique 60.1 (not above 61) and power 58.4 (not above 60): both calls are the weak kind for her today.
	_check(is_equal_approx(BoutRules.fight_power(s, {}, 0, "long") - bare, BoutRules.CORNER_WEAK), "long with 60 technique is the small edge")
	var sharp := s.duplicate()
	sharp["technique"] = 63.0
	_check(is_equal_approx(BoutRules.fight_power(sharp, {}, 0, "long") - BoutRules.fight_power(sharp, {}, 0, ""), BoutRules.CORNER_STRONG),
		"long with 63 technique is the full edge")
	_check(BoutRules.auto_corner(sharp) == "long" and BoutRules.auto_corner(s) == "long", "sim picks her better tool")


func _test_rounds() -> void:
	# S434 CARDIO1: the round reads her Stamina (Attrs.of, as the game signs her), never a missing key read as 0.
	var lucy := Data.lucy()
	var s: Dictionary = (lucy["stats"] as Dictionary).duplicate()
	s["stamina"] = float(Attrs.of(lucy)["stamina"])
	var camp := {"focus": "conditioning", "protocol": 2}
	var maria: Dictionary = Data.OPPONENTS[0]
	var r := BoutRules.play_round(1, s, camp, 3, "", maria, 0.5, 0.5)
	_check(bool(r["won"]) == (float(r["mine"]) >= float(r["theirs"])), "a round goes to the higher score")
	var r3 := BoutRules.play_round(3, s, camp, 3, "", maria, 0.5, 0.5)
	_check(float(r3["theirs"]) < float(r["theirs"]), "Maria fades in round 3")
	_check(s["stamina"] < BoutRules.FADE_STAMINA and is_equal_approx(float(r["mine"]) - float(r3["mine"]), BoutRules.own_fade(float(s["stamina"])))
		and float(r3["mine"]) < float(r["mine"]), "Lucy (Stamina %.1f, under %.0f) fades %.2f in round 3 too" % [s["stamina"],
		BoutRules.FADE_STAMINA, float(r["mine"]) - float(r3["mine"])])
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
	# S440: the third judge differs only on a close round (every 2-1 fight read as a split before).
	var clear21 := [{"won": true, "won_n": 5, "mine": 6.0}, {"won": true, "won_n": 4, "mine": 3.0}, {"won": false, "won_n": 1, "mine": -7.0}]
	_check(BoutRules.cards_of(clear21) == ["29-28", "29-28", "29-28"], "a clear 2-1: three same cards, unanimous (%s)" % str(BoutRules.cards_of(clear21)))
	var close21 := [{"won": true, "won_n": 3, "mine": 0.4}, {"won": true, "won_n": 5, "mine": 5.0}, {"won": false, "won_n": 2, "mine": -2.0}]
	_check(BoutRules.cards_of(close21) == ["29-28", "29-28", "28-29"], "a 2-1 with a 3-3 round she took: the third judge gives it away, split (%s)" % str(BoutRules.cards_of(close21)))
	var close_lost := [{"won": true, "won_n": 4, "mine": 2.0}, {"won": true, "won_n": 5, "mine": 5.0}, {"won": false, "won_n": 3, "mine": -0.3}]
	_check(BoutRules.cards_of(close_lost) == ["29-28", "29-28", "30-27"], "a 2-1 whose lost round was 3-3: the third judge gives it to her (%s)" % str(BoutRules.cards_of(close_lost)))
	var two_close := [{"won": true, "won_n": 3, "mine": 1.5}, {"won": false, "won_n": 3, "mine": -0.2}, {"won": true, "won_n": 6, "mine": 8.0}]
	_check(BoutRules.cards_of(two_close)[2] == "30-27", "two close rounds: the third judge flips the closest one only (%s)" % str(BoutRules.cards_of(two_close)))
	for rs in [clear21, close21, close_lost, two_close]:
		var won_n := (rs as Array).filter(func(r): return bool(r["won"])).size()
		_check(BoutRules.verdict(BoutRules.cards_of(rs)) == BoutRules.verdict(BoutRules.scorecards(won_n, 3)), "the verdict does not change")
	# S440 (the logic check): the result page's round chips flip the SAME round as the cards, so each judge's chips add
	# up to that judge's card - a 2-1 win whose LOST round was 3-3 gives judge 3 a 30-27, never 28-29 chips.
	for rs in [clear21, close21, close_lost, two_close]:
		var cards := BoutRules.cards_of(rs)
		var per: Array = Broadcast.judge_rounds(rs, cards)
		for j in 3:
			var hers := 0
			var theirs := 0
			for w in per[j]:
				hers += 10 if w else 9
				theirs += 9 if w else 10
			_check("%d-%d" % [hers, theirs] == str(cards[j]), "judge %d's round chips add up to the card %s (%d-%d)" % [j + 1, cards[j], hers, theirs])
	var harness := [{"won": true, "mine": 50.0, "theirs": 40.0}, {"won": false, "mine": 40.0, "theirs": 41.0}, {"won": true, "mine": 45.0, "theirs": 30.0}]
	_check(BoutRules.cards_of(harness) == ["29-28", "29-28", "30-27"], "harness rounds: close means a gap under CLOSE_MARGIN (%s)" % str(BoutRules.cards_of(harness)))
	var rounds := [{"n": 1, "won": true, "corner": ""}, {"n": 2, "won": true, "corner": "body"}, {"n": 3, "won": false, "corner": "calm"}]
	var why := BoutRules.why(rounds, true, 2, "Conditioning", 3, "left hook to the body", "Lucy")
	# S433 NOCAMP1: the canned camp, no-camp and corner-call lines are gone; the film line stays.
	_check(why.size() == 1 and str(why[0]).contains("film study"), "only the film line: %s" % str(why))
	var bare := BoutRules.why([{"n": 1, "won": false, "corner": ""}], false, 0, "", 0, "x", "Lucy")
	_check(bare.is_empty(), "no camp: no canned 'a step slow' line (%s)" % str(bare))
