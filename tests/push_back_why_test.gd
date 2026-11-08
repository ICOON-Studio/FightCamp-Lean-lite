extends SceneTree
## R11D: every ask says why it came up. PushBack.why(id, f, peak) is pure; TwistCard shows it on an AskWhy label
## above AskTrust, only when the clause is non-empty. No extra rng, no pronouns.

const PushBack := preload("res://scripts/rules/PushBack.gd")
const TwistCard := preload("res://scripts/ui/TwistCard.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

var failures := 0


func _initialize() -> void:
	_test_ask_rest()
	_test_ask_easy_peak()
	_test_ask_easy_discipline()
	_test_ask_spar_confidence()
	_test_ask_spar_temper()
	_test_ask_spar_habit()
	_test_ask_road()
	_test_ask_bag_style()
	_test_ask_bag_habit()
	_test_unknown_id()
	_test_every_reason_gets_clause()
	_test_twist_card_askwhy_above_asktrust()
	_test_twist_card_no_askwhy_when_empty()
	print("PUSH_BACK_WHY failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _test_ask_rest() -> void:
	var f := {"id": "x", "personality": {}, "habits": [], "style": ""}
	var w := PushBack.why("ask_rest", f, 80.0)
	_check(w == "last week's fatigue peaked at 80", "ask_rest peak 80: '%s'" % w)


func _test_ask_easy_peak() -> void:
	var f := {"id": "x", "personality": {"discipline": 60.0}, "habits": [], "style": ""}
	var w := PushBack.why("ask_easy", f, 70.0)
	_check(w == "last week's fatigue peaked at 70", "ask_easy peak >= 68: '%s'" % w)


func _test_ask_easy_discipline() -> void:
	var f := {"id": "x", "personality": {"discipline": 40.0}, "habits": [], "style": ""}
	var w := PushBack.why("ask_easy", f, 50.0)
	_check(w == "not one for hard mornings", "ask_easy low discipline, low peak: '%s'" % w)


func _test_ask_spar_confidence() -> void:
	var f := {"id": "x", "personality": {"confidence": 70.0, "temper": 40.0}, "habits": [], "style": ""}
	var w := PushBack.why("ask_spar", f, 50.0)
	_check(w == "confident and wants rounds", "ask_spar confidence: '%s'" % w)


func _test_ask_spar_temper() -> void:
	var f := {"id": "x", "personality": {"confidence": 40.0, "temper": 70.0}, "habits": [], "style": ""}
	var w := PushBack.why("ask_spar", f, 50.0)
	_check(w == "hot-headed and wants rounds", "ask_spar temper: '%s'" % w)


func _test_ask_spar_habit() -> void:
	var f := {"id": "x", "personality": {"confidence": 40.0, "temper": 40.0}, "habits": ["chases_stoppage"], "style": ""}
	var w := PushBack.why("ask_spar", f, 50.0)
	_check(w == "likes a scrap", "ask_spar habit: '%s'" % w)


func _test_ask_road() -> void:
	var f := {"id": "x", "personality": {}, "habits": ["fades_late"], "style": ""}
	var w := PushBack.why("ask_road", f, 50.0)
	_check(w == "fades late in fights", "ask_road habit: '%s'" % w)


func _test_ask_bag_style() -> void:
	var f := {"id": "x", "personality": {}, "habits": [], "style": "Pressure fighter"}
	var w := PushBack.why("ask_bag", f, 50.0)
	_check(w == "a pressure fighter wants the bag", "ask_bag style: '%s'" % w)


func _test_ask_bag_habit() -> void:
	var f := {"id": "x", "personality": {}, "habits": ["loads_up_when_hurt"], "style": ""}
	var w := PushBack.why("ask_bag", f, 50.0)
	_check(w == "wants more power work", "ask_bag habit: '%s'" % w)


func _test_unknown_id() -> void:
	var f := {"id": "x", "personality": {}, "habits": [], "style": ""}
	var w := PushBack.why("ask_unknown", f, 50.0)
	_check(w == "", "unknown id returns empty: '%s'" % w)


func _test_every_reason_gets_clause() -> void:
	var lucy := {"id": "lucy", "first": "Lucy", "personality": {"discipline": 40.0, "confidence": 50.0, "temper": 40.0, "coachability": 30.0, "heart": 60.0}, "habits": ["fades_late", "low_lead_hand"], "style": ""}
	var days := [["roadwork", "normal"], ["heavy_bag", "hard"], ["intervals", "normal"], ["speed_bag", "light"],
		["shadow", "normal"], ["slip_rope", "light"], ["rest", "normal"]]
	var evs := WeekPlan.evenings_for(1)
	var reasons := PushBack.reasons(lucy, days, evs, 50.0)
	var ok := true
	for id in reasons:
		if PushBack.why(id, lucy, 50.0) == "":
			ok = false
			break
	_check(ok, "every reason reasons() returns gets a non-empty clause: %s" % str(reasons))
	var slugger := {"id": "s", "first": "S", "personality": {"confidence": 70.0, "temper": 70.0, "discipline": 60.0}, "habits": ["chases_stoppage", "fades_late", "loads_up_when_hurt"], "style": "Slugger"}
	var reasons2 := PushBack.reasons(slugger, days, evs, 80.0)
	var ok2 := true
	for id in reasons2:
		if PushBack.why(id, slugger, 80.0) == "":
			ok2 = false
			break
	_check(ok2, "every reason for a full fighter: %s" % str(reasons2))


func _test_twist_card_askwhy_above_asktrust() -> void:
	var f := {"id": "lucy", "first": "Lucy", "twist": "ask_rest", "morale": 60.0,
		"personality": {"discipline": 40.0, "confidence": 50.0, "temper": 40.0, "coachability": 30.0},
		"habits": ["fades_late"], "style": "", "week_peak": 80.0}
	var root := _MockMain.new()
	var box := TwistCard.build(root, f, "Week")
	var why_idx := -1
	var trust_idx := -1
	for i in box.get_child_count():
		var c: Node = box.get_child(i)
		if c.name == "AskWhy":
			why_idx = i
		if c.name == "AskTrust":
			trust_idx = i
	_check(why_idx >= 0 and trust_idx >= 0 and why_idx < trust_idx,
		"AskWhy (%d) above AskTrust (%d)" % [why_idx, trust_idx])
	if why_idx >= 0:
		var lbl: Label = box.get_child(why_idx)
		_check(lbl.text.begins_with("Why:"), "AskWhy starts with 'Why:': '%s'" % lbl.text)
	root.free()


func _test_twist_card_no_askwhy_when_empty() -> void:
	var f := {"id": "lucy", "first": "Lucy", "twist": "ask_easy", "morale": 60.0,
		"personality": {"discipline": 60.0, "confidence": 50.0, "temper": 40.0, "coachability": 30.0},
		"habits": ["fades_late"], "style": ""}
	var root := _MockMain.new()
	var box := TwistCard.build(root, f, "Week")
	var has_why := false
	for i in box.get_child_count():
		if box.get_child(i).name == "AskWhy":
			has_why = true
	_check(not has_why, "ask_easy with high discipline and low peak -> no AskWhy label")
	root.free()


class _MockMain extends Node:
	func act(_what: String, _data: String) -> void:
		pass
