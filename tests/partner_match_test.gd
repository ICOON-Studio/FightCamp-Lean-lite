extends SceneTree
## PartnerMatch: how well a sparring partner matches the coming opponent - points, word, lines
## readied, round-1 edge, level, the partner list, the cost and the ranking (map
## DESIGN_AMATEURWEEK1_V9_REVISE_KALLI_KALLI section 4.1 "CHOOSE A SPARRING PARTNER").
## The six rows below are the drawing's six rows against the same opponent card.

const PartnerMatch := preload("res://scripts/rules/PartnerMatch.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_six_rows()
	_test_unknown_facts_never_score()
	_test_best_possible_and_film()
	_test_word_and_lines_cap()
	_test_level_words()
	_test_listable()
	_test_cost()
	_test_rank()
	print("PARTNER_MATCH checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


## A person dictionary exactly as the module documents it.
func _person(sex: String, div_kg: float, style: String, stance: String, reach_cm: float, level: int, tells: Array) -> Dictionary:
	return {
		"sex": sex,
		"div_kg": div_kg,
		"style": style,
		"stance": stance,
		"reach_cm": reach_cm,
		"level": level,
		"tells": tells,
	}


## The drawing's opponent card: what is known - style, stance, reach and one filmed tell.
func _opp() -> Dictionary:
	return _person("m", 60.0, "Counter", "orthodox", 174.0, 40, ["drops_right_after_jab"])


func _same(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false
	for i in a.size():
		if int(a[i]) != int(b[i]):
			return false
	return true


func _test_six_rows() -> void:
	var opp := _opp()
	# Row 1: club boxer 57 kg - the opponent's twin: 5 points, CLOSE, 3 lines of 3, edge 1.0.
	var twin := _person("m", 57.0, "Counter", "orthodox", 172.0, 40, ["drops_right_after_jab"])
	var twin_pts := PartnerMatch.points(twin, opp)
	_check(int(twin_pts.get("total", -1)) == 5, "the club twin scores 5 points (got %d)" % int(twin_pts.get("total", -1)))
	_check(int(twin_pts.get("style", -1)) == PartnerMatch.PT_STYLE, "the twin's style is worth 2")
	_check(int(twin_pts.get("stance", -1)) == 1, "the twin's stance is worth 1")
	_check(int(twin_pts.get("reach", -1)) == 1, "172 against 174 reach is within 5 cm: 1 point")
	_check(int(twin_pts.get("tells", -1)) == 1, "the filmed tell the twin also does: 1 point")
	_check(PartnerMatch.word(5) == "CLOSE", "5 points is CLOSE")
	var twin_night := PartnerMatch.night(twin, opp, 40, 3)
	_check(str(twin_night.get("word", "")) == "CLOSE", "the twin's night word is CLOSE")
	_check(int(twin_night.get("lines", -1)) == 3, "a CLOSE night readies 3 lines of 3")
	_check(is_equal_approx(float(twin_night.get("edge", -1.0)), 1.0), "a CLOSE night gives the round-1 edge 1.0")
	_check(is_equal_approx(float(twin_night.get("injury_mult", -1.0)), 1.0), "a level partner adds no injury risk")
	_check(bool(twin_night.get("beats_it_known", false)), "a CLOSE night knows beats-it")
	_check(not bool(twin_night.get("test_likely", true)), "a CLOSE night's test is not marked likely")

	# Row 2: partner at another club, level above - 4 points, PART, 2 lines, injury 1.15.
	var outside := _person("m", 60.0, "Counter", "orthodox", 175.0, 46, [])
	_check(int(PartnerMatch.points(outside, opp).get("total", -1)) == 4, "the outside partner scores 4 points")
	var outside_night := PartnerMatch.night(outside, opp, 40, 3)
	_check(str(outside_night.get("word", "")) == "PART", "4 points is PART")
	_check(int(outside_night.get("lines", -1)) == 2, "a PART night readies 2 lines")
	_check(is_equal_approx(float(outside_night.get("edge", -1.0)), 0.5), "a PART night gives the round-1 edge 0.5")
	_check(is_equal_approx(float(outside_night.get("injury_mult", -1.0)), PartnerMatch.INJURY_ABOVE), "a level-above partner lifts injury risk to 1.15")
	_check(bool(outside_night.get("test_likely", false)), "a PART night's test is marked likely")
	_check(bool(outside_night.get("beats_it_known", false)), "a PART night knows beats-it")

	# Row 3: another club, southpaw - style and reach only: 3 points, PART.
	var southpaw := _person("m", 60.0, "Counter", "southpaw", 170.0, 40, [])
	var southpaw_pts := PartnerMatch.points(southpaw, opp)
	_check(int(southpaw_pts.get("total", -1)) == 3, "the southpaw partner scores 3 points")
	_check(int(southpaw_pts.get("stance", -1)) == 0, "southpaw against orthodox scores no stance point")
	_check(int(southpaw_pts.get("reach", -1)) == 1, "170 against 174 reach is within 5 cm")
	_check(str(PartnerMatch.night(southpaw, opp, 40, 3).get("word", "")) == "PART", "3 points is PART")

	# Row 4: club boxer 63 kg, never met these facts - 0 points, LOOSE, 1 line, beats-it unknown.
	var wrong := _person("m", 63.0, "Pressure", "southpaw", 180.0, 40, [])
	_check(int(PartnerMatch.points(wrong, opp).get("total", -1)) == 0, "a Pressure southpaw 6 cm longer scores 0")
	var wrong_night := PartnerMatch.night(wrong, opp, 40, 3)
	_check(str(wrong_night.get("word", "")) == "LOOSE", "0 points is LOOSE")
	_check(int(wrong_night.get("lines", -1)) == 1, "a LOOSE night readies 1 line")
	_check(is_equal_approx(float(wrong_night.get("edge", -1.0)), 0.0), "a LOOSE night gives no round-1 edge")
	_check(not bool(wrong_night.get("beats_it_known", true)), "a LOOSE night does not know beats-it")

	# Row 5: club member, stance only, level below - 1 point, LOOSE, flatters.
	var member := _person("m", 60.0, "", "orthodox", 0.0, 30, [])
	var member_pts := PartnerMatch.points(member, opp)
	_check(int(member_pts.get("total", -1)) == 1, "the club member scores 1 point")
	_check(int(member_pts.get("style", -1)) == 0, "an unknown style scores nothing")
	_check(int(member_pts.get("reach", -1)) == 0, "an unknown reach scores nothing")
	var member_night := PartnerMatch.night(member, opp, 40, 3)
	_check(str(member_night.get("word", "")) == "LOOSE", "the club member's night is LOOSE")
	_check(bool(member_night.get("flatters", false)), "a level-below partner may flatter: flatters is true")
	_check(not bool(member_night.get("test_likely", true)), "the club member's test is not marked likely")
	_check(is_equal_approx(float(member_night.get("injury_mult", -1.0)), 1.0), "a level-below partner adds no injury risk")

	# The opponent's own level never scores and an unknown boxer level reads level.
	_check(str(PartnerMatch.level_word(40, 0)) == "level", "an unknown boxer level is level")


func _test_unknown_facts_never_score() -> void:
	var twin := _person("m", 57.0, "Counter", "orthodox", 172.0, 40, ["drops_right_after_jab"])
	var no_style := _person("m", 60.0, "", "orthodox", 174.0, 40, ["drops_right_after_jab"])
	_check(int(PartnerMatch.points(twin, no_style).get("style", -1)) == 0, "an unknown opponent style gives no style point to anyone")
	_check(int(PartnerMatch.points(twin, no_style).get("total", -1)) == 3, "style unknown: stance, reach and the tell still score 3")
	var no_reach := _person("m", 60.0, "Counter", "orthodox", 0.0, 40, ["drops_right_after_jab"])
	_check(int(PartnerMatch.points(twin, no_reach).get("reach", -1)) == 0, "an unknown opponent reach never scores reach")
	_check(int(PartnerMatch.points(twin, no_reach).get("total", -1)) == 4, "reach unknown: style, stance and the tell score 4")
	var no_stance := _person("m", 60.0, "Counter", "", 174.0, 40, ["drops_right_after_jab"])
	_check(int(PartnerMatch.points(twin, no_stance).get("stance", -1)) == 0, "an unknown opponent stance never scores stance")
	var other_tell := _person("m", 60.0, "Counter", "orthodox", 174.0, 40, ["drops_left_after_jab"])
	_check(int(PartnerMatch.points(twin, other_tell).get("tells", -1)) == 0, "a tell the partner does not do scores nothing")
	var both_tells := _person("m", 60.0, "Counter", "orthodox", 174.0, 40, ["drops_right_after_jab", "head_up_on_exit"])
	var twin_both := _person("m", 57.0, "Counter", "orthodox", 172.0, 40, ["drops_right_after_jab", "head_up_on_exit"])
	_check(int(PartnerMatch.points(twin_both, both_tells).get("tells", -1)) == 2, "two shared tells score 2 points")


func _test_best_possible_and_film() -> void:
	var opp := _opp()
	_check(PartnerMatch.best_possible(opp) == 5, "with one filmed tell the best match possible is 5")
	_check(not PartnerMatch.needs_film(opp), "with 5 possible no film is needed")
	var unfilmed := _person("m", 60.0, "Counter", "orthodox", 174.0, 40, [])
	_check(PartnerMatch.best_possible(unfilmed) == 4, "with no filmed tell the best match possible is 4")
	_check(PartnerMatch.needs_film(unfilmed), "with 4 possible the screen says film a tell")
	var style_only := _person("m", 60.0, "Counter", "", 0.0, 40, [])
	_check(PartnerMatch.best_possible(style_only) == 2, "with only the style known the best match possible is 2")
	_check(PartnerMatch.needs_film(style_only), "with only the style known a film is needed")
	var nothing := _person("m", 60.0, "", "", 0.0, 0, [])
	_check(PartnerMatch.best_possible(nothing) == 0, "with nothing known the best match possible is 0")
	_check(PartnerMatch.needs_film(nothing), "with nothing known a film is needed")


func _test_word_and_lines_cap() -> void:
	_check(PartnerMatch.word(7) == "CLOSE", "7 points is CLOSE")
	_check(PartnerMatch.word(4) == "PART", "4 points is PART")
	_check(PartnerMatch.word(3) == "PART", "3 points is PART")
	_check(PartnerMatch.word(2) == "LOOSE", "2 points is LOOSE")
	_check(PartnerMatch.word(0) == "LOOSE", "0 points is LOOSE")
	var opp := _opp()
	var twin := _person("m", 57.0, "Counter", "orthodox", 172.0, 40, ["drops_right_after_jab"])
	var capped := PartnerMatch.night(twin, opp, 40, 2)
	_check(int(capped.get("lines", -1)) == 2, "a CLOSE night never readies more than the 2 lines picked")
	_check(is_equal_approx(float(capped.get("edge", -1.0)), 1.0), "capping the lines leaves the CLOSE edge at 1.0")
	_check(int(PartnerMatch.night(twin, opp, 40, 0).get("lines", -1)) == 0, "with no lines picked a CLOSE night readies none")
	var wrong := _person("m", 63.0, "Pressure", "southpaw", 180.0, 40, [])
	_check(int(PartnerMatch.night(wrong, opp, 40, 0).get("lines", -1)) == 0, "with no lines picked a LOOSE night readies none")


func _test_level_words() -> void:
	_check(PartnerMatch.level_word(46, 40) == "above", "6 levels above is above")
	_check(PartnerMatch.level_word(45, 40) == "level", "5 levels above is still level")
	_check(PartnerMatch.level_word(40, 40) == "level", "the same level is level")
	_check(PartnerMatch.level_word(35, 40) == "level", "5 levels below is still level")
	_check(PartnerMatch.level_word(34, 40) == "below", "6 levels below is below")
	_check(PartnerMatch.level_word(0, 40) == "level", "an unknown partner level is level")


func _test_listable() -> void:
	var boxer := _person("m", 60.0, "Counter", "orthodox", 174.0, 40, [])
	var woman := _person("f", 60.0, "Counter", "orthodox", 174.0, 40, [])
	_check(not PartnerMatch.listable(woman, boxer), "a female partner is never listed for a male boxer")
	_check(not PartnerMatch.listable(boxer, woman), "a male partner is never listed for a female boxer")
	var heavy := _person("m", 75.0, "Counter", "orthodox", 174.0, 40, [])
	_check(not PartnerMatch.listable(heavy, boxer), "60 kg against 75 kg is more than one class")
	var close := _person("m", 65.0, "Counter", "orthodox", 174.0, 40, [])
	_check(PartnerMatch.listable(close, boxer), "60 kg against 65 kg is within one class")
	var edge_class := _person("m", 52.5, "Counter", "orthodox", 174.0, 40, [])
	_check(PartnerMatch.listable(edge_class, boxer), "7.5 kg away is still within one class")
	var too_far := _person("m", 52.0, "Counter", "orthodox", 174.0, 40, [])
	_check(not PartnerMatch.listable(too_far, boxer), "8 kg away is more than one class")
	var her_partner := _person("f", 57.0, "Counter", "orthodox", 172.0, 40, [])
	var her_boxer := _person("f", 57.0, "Counter", "orthodox", 172.0, 40, [])
	_check(PartnerMatch.listable(her_partner, her_boxer), "the same sex and the same class is listed")


func _test_cost() -> void:
	var ours := PartnerMatch.cost(true, 0, 0)
	_check(int(ours.get("cash", -1)) == 0, "our own club is free")
	_check(bool(ours.get("payable", false)), "our own club is always payable")
	_check(str(ours.get("reason", "x")) == "", "our own club carries no reason")
	var broke := PartnerMatch.cost(false, 0, 100)
	_check(int(broke.get("cash", -1)) == PartnerMatch.OUTSIDE_FEE, "another club costs the $160 fee")
	_check(not bool(broke.get("favour_ok", true)), "with no favours favour_ok is false")
	_check(not bool(broke.get("payable", true)), "0 favours and $100 cannot pay for another club")
	_check(str(broke.get("reason", "")) == "cash under $160", "the reason is cash under $160")
	var exact := PartnerMatch.cost(false, 0, 160)
	_check(bool(exact.get("payable", false)), "$160 exactly pays for another club")
	_check(str(exact.get("reason", "x")) == "", "a payable outside partner carries no reason")
	var favour := PartnerMatch.cost(false, 1, 0)
	_check(bool(favour.get("payable", false)), "1 favour with the host pays for another club")
	_check(bool(favour.get("favour_ok", false)), "1 favour makes favour_ok true")
	_check(str(favour.get("reason", "x")) == "", "a favour-paid partner carries no reason")


func _test_rank() -> void:
	var opp := _opp()
	var twin := _person("m", 57.0, "Counter", "orthodox", 172.0, 40, ["drops_right_after_jab"])
	var outside := _person("m", 60.0, "Counter", "orthodox", 175.0, 46, [])
	var southpaw := _person("m", 60.0, "Counter", "southpaw", 170.0, 40, [])
	var wrong := _person("m", 63.0, "Pressure", "southpaw", 180.0, 40, [])
	# Input order: LOOSE (0), CLOSE (5), PART (3), PART (4).
	_check(_same(PartnerMatch.rank([wrong, twin, southpaw, outside], opp), [1, 3, 2, 0]),
		"the best match comes first and the worst last")
	var twin_copy := _person("m", 57.0, "Counter", "orthodox", 172.0, 40, ["drops_right_after_jab"])
	_check(_same(PartnerMatch.rank([twin, twin_copy], opp), [0, 1]), "a tie keeps the input order")
	_check(_same(PartnerMatch.rank([outside, twin], opp), [1, 0]), "a tie does not reorder the better input row late")
	var loose_a := _person("m", 63.0, "Pressure", "southpaw", 180.0, 40, [])
	var loose_b := _person("m", 60.0, "", "southpaw", 0.0, 40, [])
	_check(_same(PartnerMatch.rank([loose_a, twin, loose_b], opp), [1, 0, 2]), "a tie between 0-point rows keeps their order")
	_check(_same(PartnerMatch.rank([], opp), []), "no partners rank as nothing")
