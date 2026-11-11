extends SceneTree
## S433 REST1: a rest morning adds Recovery and takes nothing off Stamina. The taper week's three rest mornings
## (Wed, Sat, Sun) must leave Stamina alone, let Conditioning rise by half the Recovery gain, and return no "stamina"
## key. The week's Stamina delta equals the sum of the non-rest mornings' "stamina" values. At the cap (Recovery 99)
## a rest morning still leaves Stamina unchanged. A mobility morning guards the cut (Flexibility up, nothing else).

const Attrs := preload("res://scripts/rules/Attrs.gd")
const WP := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")

var failures := 0
var checks := 0


func _initialize() -> void:
	_taper_rest_mornings()
	_week_stamina_sum()
	_cap_rest()
	_mobility_guard()
	print("REST_KEEPS_STAMINA checks=%d failures=%d" % [checks, failures])
	quit(0 if failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	checks += 1
	if ok:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)


func _ctx(f: Dictionary) -> Dictionary:
	return {"stats": f["stats"], "pot": 80, "coach": 60.0, "weight": 61.0, "diet": "hold"}


func _box(id: String) -> Dictionary:
	var stats := {}
	for k in Attrs.LEGACY:
		stats[k] = 55.0
	return {"id": id, "name": id, "style": "Out-boxer", "stats": stats, "personality": {"heart": 55.0, "temper": 55.0},
		"moves": {"Jab": 55.0, "Cross": 55.0, "Lead hook": 55.0, "Body hook": 55.0, "Uppercut": 55.0}, "footwork": 55.0}


func _taper_rest_mornings() -> void:
	var f := _box("taper")
	Attrs.of(f)
	var taper: Array = WeekPhase.WEEKS["taper"]
	var rest_indices := [2, 5, 6]
	var day_names := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
	var fatigue := 20.0
	for i in taper.size():
		var d: Array = taper[i]
		var r: Dictionary = WP.full_day(str(d[0]), str(d[1]), "rest", _ctx(f), fatigue)
		fatigue = float(r["fatigue"])
		var rest_out := {}
		var road_out := {}
		if str(r["stat"]) != "":
			var g: float = float(r["gain"])
			road_out = Attrs.apply_session(f, str(d[0]), str(r["stat"]), g)
		if float(r["attr_gain"]) > 0.0:
			var ag: float = float(r["attr_gain"])
			var st0: float = float(Attrs.of(f)["stamina"])
			var rec0: float = float(Attrs.of(f)["recovery"])
			var cond0: float = float(f["stats"]["conditioning"])
			rest_out = Attrs.apply_session(f, str(d[0]), "", ag)
			var st1: float = float(Attrs.of(f)["stamina"])
			var rec1: float = float(Attrs.of(f)["recovery"])
			var cond1: float = float(f["stats"]["conditioning"])
			if i in rest_indices:
				var ag_pre: float = float(r["attr_gain"])
				_check(ag_pre > 0.0, "%s rest attr_gain > 0 (%.4f)" % [day_names[i], ag_pre])
				var rec_delta: float = rec1 - rec0
				_check(rec_delta > 0.0, "%s rest Recovery rose %.4f -> %.4f (+%.4f)" % [day_names[i], rec0, rec1, rec_delta])
				var st_delta: float = st1 - st0
				_check(absf(st_delta) < 0.0001, "%s rest keeps Stamina %.3f -> %.3f (delta %.4f)" % [day_names[i], st0, st1, st_delta])
				var cond_delta: float = cond1 - cond0
				var expected_cond: float = rec_delta * 0.5
				_check(absf(cond_delta - expected_cond) < 0.0001, "%s rest Conditioning +%.4f (half Recovery +%.4f)" % [day_names[i], cond_delta, rec_delta])
				_check(not rest_out.has("stamina"), "%s rest out has no stamina key (has: %s)" % [day_names[i], str(rest_out.has("stamina"))])


func _week_stamina_sum() -> void:
	var f := _box("week")
	Attrs.of(f)
	var taper: Array = WeekPhase.WEEKS["taper"]
	var st_start: float = float(Attrs.of(f)["stamina"])
	var expected_stamina_delta: float = 0.0
	var fatigue := 20.0
	for i in taper.size():
		var d: Array = taper[i]
		var r: Dictionary = WP.full_day(str(d[0]), str(d[1]), "rest", _ctx(f), fatigue)
		fatigue = float(r["fatigue"])
		var is_rest := str(d[0]) == "rest"
		if str(r["stat"]) != "":
			var g: float = float(r["gain"])
			var out: Dictionary = Attrs.apply_session(f, str(d[0]), str(r["stat"]), g)
			if not is_rest:
				expected_stamina_delta += float(out.get("stamina", 0.0))
		if float(r["attr_gain"]) > 0.0:
			var ag: float = float(r["attr_gain"])
			Attrs.apply_session(f, str(d[0]), "", ag)
	var st_end: float = float(Attrs.of(f)["stamina"])
	var actual_delta: float = st_end - st_start
	_check(absf(actual_delta - expected_stamina_delta) < 0.0001, "week Stamina delta %.4f == non-rest sum %.4f" % [actual_delta, expected_stamina_delta])


func _cap_rest() -> void:
	var f := _box("cap")
	var a := Attrs.of(f)
	a["recovery"] = 99.0
	Attrs.sync(f)
	var st0: float = float(Attrs.of(f)["stamina"])
	var r: Dictionary = WP.full_day("rest", "normal", "rest", _ctx(f), 20.0)
	var ag: float = float(r["attr_gain"])
	if ag > 0.0:
		Attrs.apply_session(f, "rest", "", ag)
	var st1: float = float(Attrs.of(f)["stamina"])
	var delta: float = st1 - st0
	_check(absf(delta) < 0.0001, "cap rest keeps Stamina %.3f -> %.3f (Recovery at 99)" % [st0, st1])


func _mobility_guard() -> void:
	var f := _box("mob")
	Attrs.of(f)
	var st0: float = float(Attrs.of(f)["stamina"])
	var rec0: float = float(Attrs.of(f)["recovery"])
	var flex0: float = float(Attrs.of(f)["flexibility"])
	var r: Dictionary = WP.full_day("mobility", "normal", "rest", _ctx(f), 20.0)
	var ag: float = float(r["attr_gain"])
	if ag > 0.0:
		Attrs.apply_session(f, "mobility", "", ag)
	var st1: float = float(Attrs.of(f)["stamina"])
	var rec1: float = float(Attrs.of(f)["recovery"])
	var flex1: float = float(Attrs.of(f)["flexibility"])
	_check(absf(st1 - st0) < 0.0001 and absf(rec1 - rec0) < 0.0001 and float(flex1) > float(flex0),
		"mobility keeps Stamina %.3f -> %.3f, Recovery %.3f -> %.3f, Flexibility %.3f -> %.3f" % [st0, st1, rec0, rec1, flex0, flex1])
