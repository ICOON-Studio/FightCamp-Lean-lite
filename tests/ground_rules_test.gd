extends SceneTree
## GroundRules test: positions, moves, odds, and three fight pairings.
## Research: topics/ground.md, G141, G142, G143, G144, G92, G75.
##
## Real anchors (topics/ground.md, Q165):
##   UFC LW ~17% ground control; 15-25% ground time; 2.5-3.0 TD att/15 min;
##   sub att 0.5-1.0 per fighter per fight (G92: 1.65 was per BOUT).
## Stuffed shots (G141): FHL 15-25%, turtle 10-15%.
## Skill gap (G144): d20 = (actor - opp) / 20; mult = base^d20, capped.
## 55% seat-mass cap (G144 section 4).

const GR := preload("res://scripts/rules/GroundRules.gd")

var failures := 0


func _initialize() -> void:
	_test_1_structure()
	_test_2_pairings()
	if failures == 0:
		print("GROUND_RULES failures=0")
	else:
		print("GROUND_RULES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok   ", label)
	else:
		failures += 1
		print("  FAIL ", label)


func _test_1_structure() -> void:
	var pos_set := {}
	for p in GR.POSITIONS:
		pos_set[str(p)] = true
	_check(pos_set.has("standing"), "standing is a position")
	_check(pos_set.has("back"), "back is a position")
	_check(GR.POSITIONS.size() == 9, "9 positions")
	for m in GR.MOVES:
		var ok := pos_set.has(str(m["from"])) and pos_set.has(str(m["to"]))
		_check(ok, "move '%s' from/to are positions" % str(m["id"]))
	var reachable := _reachable_from_standing()
	for p in GR.POSITIONS:
		_check(reachable.has(str(p)), "position '%s' reachable from standing" % str(p))
	for m in GR.MOVES:
		if str(m["kind"]) == "sweep":
			var fake_state := {"pos": str(m["from"]), "top": "a"}
			var r := GR._apply_success(fake_state, m, "b", "a")
			_check(str(r["top"]) == "b", "sweep '%s' flips top" % str(m["id"]))
	var r1 := GR.simulate(_f("allround1"), _f("allround2"), 900.0, 42)
	var r2 := GR.simulate(_f("allround1"), _f("allround2"), 900.0, 42)
	_check(r1["ground_s"] == r2["ground_s"], "same seed same result (ground_s)")
	_check(r1["finish"] == r2["finish"], "same seed same result (finish)")


func _test_2_pairings() -> void:
	var w := _f("wrestler")
	var s := _f("striker")
	var b := _f("bjj")
	var a1 := _f("allround1")
	var a2 := _f("allround2")
	var ws := _run_pairing(w, s, 400)
	print("  WS avg: gnd=%.1f%% ctrl_a=%.1fs(%.1f%%) ctrl_b=%.1fs(%.1f%%) td_a=%.1f td_b=%.1f sub_a=%.2f sub_b=%.2f fin=%.1f%%" % [
		ws["ground_pct"], ws["ctrl_a"], ws["ctrl_a"] / 900.0 * 100.0,
		ws["ctrl_b"], ws["ctrl_b"] / 900.0 * 100.0,
		ws["td_a"], ws["td_b"], ws["sub_a"], ws["sub_b"], ws["fin_pct"]])
	if ws["ctrl_a"] > 0.01:
		_check(ws["ctrl_a"] / maxf(0.01, ws["ctrl_b"]) >= 3.0,
			"WS: wrestler ctrl >= 3x striker ctrl (%.1fs vs %.1fs)" % [ws["ctrl_a"], ws["ctrl_b"]])
	else:
		_check(false, "WS: wrestler ctrl too low")
	_check(ws["striker_ups"] > 0, "WS: striker stands up in some fights (%d)" % ws["striker_ups"])
	var bw := _run_pairing(b, w, 400)
	print("  BW avg: gnd=%.1f%% ctrl_a=%.1fs(%.1f%%) ctrl_b=%.1fs(%.1f%%) td_a=%.1f td_b=%.1f sub_a=%.2f sub_b=%.2f fin=%.1f%%" % [
		bw["ground_pct"], bw["ctrl_a"], bw["ctrl_a"] / 900.0 * 100.0,
		bw["ctrl_b"], bw["ctrl_b"] / 900.0 * 100.0,
		bw["td_a"], bw["td_b"], bw["sub_a"], bw["sub_b"], bw["fin_pct"]])
	_check(bw["sub_a"] > bw["sub_b"],
		"BW: BJJ more sub att than wrestler (%.2f vs %.2f)" % [bw["sub_a"], bw["sub_b"]])
	_check(bw["td_b"] > bw["td_a"],
		"BW: wrestler more TD att than BJJ (%.2f vs %.2f)" % [bw["td_b"], bw["td_a"]])
	var aa := _run_pairing(a1, a2, 400)
	print("  AA avg: gnd=%.1f%% ctrl_a=%.1fs(%.1f%%) ctrl_b=%.1fs(%.1f%%) td_a=%.1f td_b=%.1f sub_a=%.2f sub_b=%.2f fin=%.1f%%" % [
		aa["ground_pct"], aa["ctrl_a"], aa["ctrl_a"] / 900.0 * 100.0,
		aa["ctrl_b"], aa["ctrl_b"] / 900.0 * 100.0,
		aa["td_a"], aa["td_b"], aa["sub_a"], aa["sub_b"], aa["fin_pct"]])
	_check(aa["ground_pct"] >= 10.0 and aa["ground_pct"] <= 30.0,
		"AA: ground time 10-30%% (%.1f%%)" % aa["ground_pct"])
	_check(aa["td_a"] >= 1.5 and aa["td_a"] <= 4.5,
		"AA: a1 TD att 1.5-4.5/15min (%.2f)" % aa["td_a"])
	_check(aa["td_b"] >= 1.5 and aa["td_b"] <= 4.5,
		"AA: a2 TD att 1.5-4.5/15min (%.2f)" % aa["td_b"])
	_check(aa["sub_a"] >= 0.3 and aa["sub_a"] <= 1.3,
		"AA: a1 sub att 0.3-1.3/fight (%.2f)" % aa["sub_a"])
	_check(aa["sub_b"] >= 0.3 and aa["sub_b"] <= 1.3,
		"AA: a2 sub att 0.3-1.3/fight (%.2f)" % aa["sub_b"])
	_check(ws["fin_pct"] < 35.0, "WS: finishes < 35%% (%.1f%%)" % ws["fin_pct"])
	_check(bw["fin_pct"] < 35.0, "BW: finishes < 35%% (%.1f%%)" % bw["fin_pct"])
	_check(aa["fin_pct"] < 35.0, "AA: finishes < 35%% (%.1f%%)" % aa["fin_pct"])
	_check(aa["fin_pct"] >= 8.0 and aa["fin_pct"] <= 25.0,
		"AA: sub finishes 8-25%% (%.1f%%)" % aa["fin_pct"])
	_check(bw["fin_pct"] > ws["fin_pct"],
		"BW more sub finishes than WS (%.1f%% vs %.1f%%)" % [bw["fin_pct"], ws["fin_pct"]])
	var md := GR._move_def("pass_half")
	var top80 := {"name": "T80", "wrestling": 80, "bjj": 50, "strength": 50, "cardio": 50}
	var bot40 := {"name": "B40", "wrestling": 40, "bjj": 50, "strength": 50, "cardio": 50}
	var c_hi := GR.chance(md, top80, bot40)
	var c_lo := GR.chance(md, bot40, top80)
	_check(c_hi >= 1.8 * c_lo,
		"skill matters: pass_half 80vs40 >= 1.8x 40vs80 (%.3f vs %.3f)" % [c_hi, c_lo])


func _reachable_from_standing() -> Dictionary:
	var pos_set := {}
	for p in GR.POSITIONS:
		pos_set[str(p)] = true
	var adj := {}
	for p in GR.POSITIONS:
		adj[str(p)] = []
	for m in GR.MOVES:
		adj[str(m["from"])].append(str(m["to"]))
	var visited := {"standing": true}
	var queue := ["standing"]
	while not queue.is_empty():
		var cur: String = queue.pop_front()
		for nxt in adj[cur]:
			if not visited.has(nxt):
				visited[nxt] = true
				queue.append(nxt)
	return visited


func _f(kind: String) -> Dictionary:
	match kind:
		"wrestler": return {"name": "Wrestler", "wrestling": 85, "bjj": 50, "strength": 70, "cardio": 65}
		"striker": return {"name": "Striker", "wrestling": 35, "bjj": 30, "strength": 55, "cardio": 70}
		"bjj": return {"name": "BJJ", "wrestling": 45, "bjj": 90, "strength": 50, "cardio": 60}
		"allround1": return {"name": "All1", "wrestling": 60, "bjj": 55, "strength": 60, "cardio": 60}
		"allround2": return {"name": "All2", "wrestling": 55, "bjj": 60, "strength": 55, "cardio": 65}
	return {"name": "?", "wrestling": 50, "bjj": 50, "strength": 50, "cardio": 50}


func _run_pairing(fa: Dictionary, fb: Dictionary, n: int) -> Dictionary:
	var tot_ground := 0.0
	var ctrl_a := 0.0
	var ctrl_b := 0.0
	var td_a := 0.0
	var td_b := 0.0
	var sub_a := 0.0
	var sub_b := 0.0
	var fins := 0
	var striker_ups := 0
	for i in n:
		var r := GR.simulate(fa, fb, 900.0, i + 1)
		tot_ground += float(r["ground_s"])
		ctrl_a += float(r["control_s"]["a"])
		ctrl_b += float(r["control_s"]["b"])
		td_a += float(r["td_att"]["a"])
		td_b += float(r["td_att"]["b"])
		sub_a += float(r["sub_att"]["a"])
		sub_b += float(r["sub_att"]["b"])
		if str(r["finish"]) != "":
			fins += 1
		for entry in r["log"]:
			if str(entry.get("move", "")) == "get_up" and str(entry.get("who", "")) == "b":
				striker_ups += 1
	var ng := float(n)
	var min15 := 900.0 / 900.0
	return {
		"ground_pct": tot_ground / ng / 900.0 * 100.0,
		"ctrl_a": ctrl_a / ng,
		"ctrl_b": ctrl_b / ng,
		"td_a": td_a / ng / min15,
		"td_b": td_b / ng / min15,
		"sub_a": sub_a / ng,
		"sub_b": sub_b / ng,
		"fin_pct": float(fins) / ng * 100.0,
		"striker_ups": striker_ups,
	}
