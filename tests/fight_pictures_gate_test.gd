extends SceneTree
## PICSFIX1 (S543, owner: "why fighters are entagled like that on the left and on the right the punch does not touch the
## opponent"): the fight pictures' own gate, read from each set's contacts.json (tools/pics2d_set.gd writes it from
## tools/pics2d_gate.gd at the saved frame). Red on the S540 sets: no block_m (a blocked glove 0.28-0.38 m from anything) and
## no apart_m (bodies through bodies). Checks, for both sets: the 58 pictures exist; every landed hit_m <= LAND_M with the
## glove on the near side; every blocked block_m <= BLOCK_M; every missed glove clear of head and gloves; every punch and the
## clinch over APART_MIN_M; the clinch carries its own check; no entry carries a failed measure.

const Gate := preload("res://tools/pics2d_gate.gd")
const FAMS := ["jab", "cross", "lead_hook", "rear_hook", "body_hook", "body_cross", "lead_uppercut", "rear_uppercut"]

var failures := 0


func _initialize() -> void:
	for s in ["w", "m"]:
		_one_set(s)
	print("FIGHT_PICTURES_GATE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL " + label)


func _names() -> Array:
	var out: Array = ["guard", "clinch"]
	for c in ["red", "blue"]:
		for f in FAMS:
			for r in ["landed", "blocked", "missed"]:
				out.append("%s_%s_%s" % [c, f, r])
		for k in 3:
			out.append("%s_knockdown_%d" % [c, k + 1])
		out.append(c + "_corner")
	return out


## A missing measure fails both ways: INF for an at-most bar, -INF for an at-least bar.
func _num(e: Dictionary, k: String, missing := INF) -> float:
	return float(e[k]) if e.has(k) else missing


func _one_set(s: String) -> void:
	var dir := "res://assets/ui/fight_pictures/%s/" % s
	var names := _names()
	_check(names.size() == 58, "%s: 58 names listed (%d)" % [s, names.size()])
	var cj = JSON.parse_string(FileAccess.get_file_as_string(dir + "contacts.json"))
	var c: Dictionary = cj if cj is Dictionary else {}
	_check(not c.is_empty(), "%s: contacts.json read" % s)
	var n := {"landed": 0, "blocked": 0, "missed": 0}
	for nm in names:
		_check(FileAccess.file_exists(dir + nm + ".png"), "%s: %s.png exists" % [s, nm])
		var e: Dictionary = c.get(nm, {})
		_check(c.has(nm), "%s: %s in contacts.json" % [s, nm])
		_check((e.get("fails", []) as Array).is_empty(), "%s: %s carries no failed measure %s" % [s, nm, str(e.get("fails", []))])
		var res := str(e.get("result", ""))
		if res != "":
			n[res] += 1
			_check(_num(e, "apart_m", -INF) >= Gate.APART_MIN_M, "%s: %s apart_m %s >= %.2f" % [s, nm, str(e.get("apart_m", "none")), Gate.APART_MIN_M])
		if res == "landed":
			_check(_num(e, "hit_m") <= Gate.LAND_M, "%s: %s hit_m %s <= %.2f" % [s, nm, str(e.get("hit_m", "none")), Gate.LAND_M])
			_check(e.has("near_m") and float(e["near_m"]) >= Gate.NEAR_MIN_M, "%s: %s near_m %s >= %.2f (near side)" % [s, nm, str(e.get("near_m", "none")), Gate.NEAR_MIN_M])
		elif res == "blocked":
			_check(_num(e, "block_m") <= Gate.BLOCK_M, "%s: %s block_m %s <= %.2f" % [s, nm, str(e.get("block_m", "none")), Gate.BLOCK_M])
		elif res == "missed":
			_check(e.has("clear_m") and float(e["clear_m"]) >= Gate.MISS_PX_M - 0.005, "%s: %s clear_m %s" % [s, nm, str(e.get("clear_m", "none"))])
			_check(e.has("clear_hand_m") and float(e["clear_hand_m"]) >= Gate.MISS_HAND_M - 0.005, "%s: %s clear_hand_m %s" % [s, nm, str(e.get("clear_hand_m", "none"))])
	_check(n["landed"] == 16 and n["blocked"] == 16 and n["missed"] == 16, "%s: 16 landed, 16 blocked, 16 missed (%s)" % [s, str(n)])
	var cl: Dictionary = c.get("clinch", {})
	for k in ["apart_m", "chest_m", "head_m", "arm_m"]:
		_check(cl.has(k), "%s: the clinch carries %s" % [s, k])
	_check(_num(cl, "apart_m", -INF) >= Gate.CLINCH_APART_M, "%s: clinch apart_m %s >= %.2f" % [s, str(cl.get("apart_m", "none")), Gate.CLINCH_APART_M])
	_check(_num(cl, "chest_m") <= Gate.CLINCH_CHEST_M, "%s: clinch chest_m %s <= %.2f" % [s, str(cl.get("chest_m", "none")), Gate.CLINCH_CHEST_M])
	_check(cl.has("head_m") and float(cl["head_m"]) >= Gate.HEAD_APART_M, "%s: clinch head_m %s" % [s, str(cl.get("head_m", "none"))])
	_check(cl.has("arm_m") and float(cl["arm_m"]) >= Gate.ARM_OFF_M, "%s: clinch arm_m %s" % [s, str(cl.get("arm_m", "none"))])
	print("FIGHT_PICTURES_GATE set=%s checked %d pictures" % [s, names.size()])
