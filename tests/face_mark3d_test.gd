extends SceneTree
## FACE3D1: contract tests for the pure 3D face-mark rule, including agreement with the existing
## 2D marks.

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const FaceMarks := preload("res://scripts/ui/FaceMarks.gd")
const FaceMark3D := preload("res://scripts/rules/FaceMark3D.gd")
const BandWords := preload("res://scripts/rules/BandWords.gd")

var failures: int = 0


func _initialize() -> void:
	_test_agreement()
	_test_steps()
	_test_specs_and_lids()
	_test_order_and_changes()
	_test_summary()
	_test_mutants()
	print("FACE_MARK3D failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _test_agreement() -> void:
	var levels: Array = [100.0, 55.0, 54.0, 35.0, 34.0, 15.0, 0.0]
	var places: Array = ["right_eye", "left_eye", "nose"]
	var comparisons: int = 0
	var found_disagreement: bool = false
	for ri in range(levels.size()):
		for li in range(levels.size()):
			for ni in range(levels.size()):
				var vals: Dictionary = {
					"right_eye": float(levels[ri]),
					"left_eye": float(levels[li]),
					"nose": float(levels[ni])
				}
				for cut_mask in range(8):
					for closed_mask in range(8):
						var cuts: Dictionary = {}
						var closed: Dictionary = {}
						for pi in range(places.size()):
							var place: String = str(places[pi])
							if (cut_mask & (1 << pi)) != 0:
								cuts[place] = true
							if (closed_mask & (1 << pi)) != 0:
								closed[place] = true
						var side: Dictionary = {"cuts": cuts, "closed": closed}
						var expected: Array = _mark_keys(FaceMarks.marks(vals, side))
						var actual: Array = _spec_keys(FaceMark3D.specs(vals, side))
						if not _same_sorted(expected, actual) and not found_disagreement:
							found_disagreement = true
							_fail(
								(
									"2D/3D disagreement #%d vals=%s side=%s FaceMarks=%s FaceMark3D=%s"
									% [
										comparisons,
										str(vals),
										str(side),
										str(expected),
										str(actual)
									]
								)
							)
						comparisons += 1
	_check(comparisons >= 60, "agreement exercised %d unique generated inputs" % comparisons)


func _test_steps() -> void:
	var previous_band: String = BodyMap.band(100.0)
	var previous_step: int = FaceMark3D.steps(100.0)
	_check(previous_step == 0, "fine face has step zero")
	var i: int = 1
	while i <= 200:
		var v: float = 100.0 - float(i) * 0.5
		var band_now: String = BodyMap.band(v)
		var step_now: int = FaceMark3D.steps(v)
		_check(
			(band_now != previous_band) == (step_now != previous_step),
			"step boundary agrees with BodyMap.band at %.1f" % v
		)
		previous_band = band_now
		previous_step = step_now
		i += 1
	_check(
		FaceMark3D.steps(55.0) == 1 and FaceMark3D.steps(35.0) == 2 and FaceMark3D.steps(15.0) == 3,
		"steps include exact hurt, critical and doctor boundaries"
	)


func _test_specs_and_lids() -> void:
	var none: Array = FaceMark3D.specs({}, {})
	var untouched_lids: Dictionary = FaceMark3D.lids({}, {})
	_check(none.is_empty(), "untouched face has no marks")
	_check(
		(
			float(untouched_lids.get("left", -1.0)) == 0.0
			and float(untouched_lids.get("right", -1.0)) == 0.0
		),
		"untouched lids are open"
	)
	_check(FaceMark3D.summary({}, {}) == "", "untouched face summary is empty")
	var sizes: Array = [0.0, 0.030, 0.036, 0.042]
	var nose_sizes: Array = [0.0, 0.024, 0.028, 0.032]
	var strengths: Array = [0.0, 0.45, 0.75, 1.0]
	for step in range(1, 4):
		var v: float = [100.0, 55.0, 35.0, 15.0][step]
		var eye_marks: Array = FaceMark3D.specs(
			{"left_eye": v, "right_eye": 100.0, "nose": 100.0}, {}
		)
		_check(eye_marks.size() == 1, "eye step %d produces one swell" % step)
		if eye_marks.size() == 1:
			var eye: Dictionary = eye_marks[0]
			_check(
				str(eye.get("kind", "")) == "swell" and str(eye.get("spot", "")) == "eye_l",
				"left-eye swell uses the left eye anchor"
			)
			_check(
				(
					int(eye.get("step", -1)) == step
					and is_equal_approx(float(eye.get("k", -1.0)), float(strengths[step]))
					and is_equal_approx(float(eye.get("size_m", -1.0)), float(sizes[step]))
				),
				"eye step %d uses its stepped strength and size" % step
			)
		var nose_marks: Array = FaceMark3D.specs({"nose": v}, {})
		_check(nose_marks.size() == 1, "nose step %d produces one mark" % step)
		if nose_marks.size() == 1:
			var nose_mark: Dictionary = nose_marks[0]
			_check(
				(
					str(nose_mark.get("kind", "")) == "nose"
					and str(nose_mark.get("spot", "")) == "nose_bridge"
				),
				"nose uses nose-bridge anchor"
			)
			_check(
				(
					int(nose_mark.get("step", -1)) == step
					and is_equal_approx(float(nose_mark.get("k", -1.0)), float(strengths[step]))
					and is_equal_approx(
						float(nose_mark.get("size_m", -1.0)), float(nose_sizes[step])
					)
				),
				"nose step %d uses its stepped strength and size" % step
			)
	var shut_side: Dictionary = {"closed": {"left_eye": true}, "cuts": {}}
	var shut_marks: Array = FaceMark3D.specs({"left_eye": 0.0}, shut_side)
	var shut_lids: Dictionary = FaceMark3D.lids({"left_eye": 0.0}, shut_side)
	_check(
		(
			shut_marks.size() == 1
			and str(shut_marks[0].get("kind", "")) == "shut"
			and int(shut_marks[0].get("step", -1)) == 3
			and is_equal_approx(float(shut_marks[0].get("k", -1.0)), 1.0)
			and is_equal_approx(float(shut_marks[0].get("size_m", -1.0)), 0.042)
		),
		"shut eye replaces the swell with the fixed shut mark"
	)
	_check(
		(
			is_equal_approx(float(shut_lids.get("left", -1.0)), 1.0)
			and is_equal_approx(float(shut_lids.get("right", -1.0)), 0.0)
		),
		"closed left eye leaves right lid independent"
	)
	var lid_vals: Dictionary = {"left_eye": 35.0, "right_eye": 15.0}
	var both_lids: Dictionary = FaceMark3D.lids(lid_vals, {})
	_check(
		(
			is_equal_approx(float(both_lids.get("left", -1.0)), 0.5)
			and is_equal_approx(float(both_lids.get("right", -1.0)), 0.7)
		),
		"both eyelids map their own damage steps"
	)
	var cut_marks: Array = FaceMark3D.specs(
		{"right_eye": 0.0, "nose": 0.0}, {"cuts": {"right_eye": true, "nose": true}}
	)
	var cut_eye: Dictionary = cut_marks[1]
	var cut_nose: Dictionary = cut_marks[3]
	_check(
		(
			str(cut_eye.get("kind", "")) == "cut"
			and str(cut_eye.get("spot", "")) == "brow_r"
			and bool(cut_eye.get("bleeding", false))
			and is_equal_approx(float(cut_eye.get("size_m", -1.0)), 0.022)
		),
		"eye cut is bleeding on the boxer-right brow"
	)
	_check(
		(
			str(cut_nose.get("kind", "")) == "cut"
			and str(cut_nose.get("spot", "")) == "nose_bridge"
			and bool(cut_nose.get("bleeding", false))
		),
		"nose cut is bleeding on the bridge"
	)
	_check(
		(
			FaceMark3D.SPOTS.keys().size() == 6
			and FaceMark3D.SPOTS.has("brow_l")
			and FaceMark3D.SPOTS.has("brow_r")
			and FaceMark3D.SPOTS.has("eye_l")
			and FaceMark3D.SPOTS.has("eye_r")
			and FaceMark3D.SPOTS.has("nose_bridge")
			and FaceMark3D.SPOTS.has("nose_tip")
		),
		"SPOTS contains the six contracted head anchors"
	)


func _test_order_and_changes() -> void:
	var vals: Dictionary = {"nose": 0.0, "left_eye": 0.0, "right_eye": 0.0}
	var side: Dictionary = {
		"cuts": {"nose": true, "left_eye": true, "right_eye": true}, "closed": {"left_eye": true}
	}
	var ordered: Array = FaceMark3D.specs(vals, side)
	_check(
		(
			_spec_order_keys(ordered)
			== [
				"swell:right_eye",
				"cut:right_eye",
				"shut:left_eye",
				"cut:left_eye",
				"nose:nose",
				"cut:nose"
			]
		),
		"spec ordering is right eye, left eye, nose; swelling/shut before cut"
	)
	var before: Array = [{"kind": "swell", "place": "right_eye", "step": 1}]
	_check(
		FaceMark3D.changed(before, [{"kind": "swell", "place": "right_eye", "step": 1}]).is_empty(),
		"unchanged spec is not redrawn"
	)
	var stronger: Array = FaceMark3D.changed(
		before, [{"kind": "swell", "place": "right_eye", "step": 2}]
	)
	_check(
		stronger.size() == 1 and int(stronger[0].get("step", -1)) == 2,
		"changed returns spec when step increases"
	)
	var switched: Array = FaceMark3D.changed(
		before, [{"kind": "shut", "place": "right_eye", "step": 3}]
	)
	_check(
		switched.size() == 1 and str(switched[0].get("kind", "")) == "shut",
		"swell-to-shut is matched as one changed eye family"
	)
	var new_cut: Array = FaceMark3D.changed(
		[{"kind": "swell", "place": "nose", "step": 1}],
		[{"kind": "swell", "place": "nose", "step": 1}, {"kind": "cut", "place": "nose", "step": 3}]
	)
	_check(
		new_cut.size() == 1 and str(new_cut[0].get("kind", "")) == "cut",
		"a new cut returns only the cut spec"
	)


func _test_summary() -> void:
	var vals: Dictionary = {"left_eye": 15.0, "right_eye": 34.0, "nose": 54.0}
	var side: Dictionary = {"closed": {"left_eye": true}, "cuts": {"right_eye": true}}
	var text: String = FaceMark3D.summary(vals, side)
	_check(text.begins_with("Left eye shut"), "summary names the worst place first: %s" % text)
	# DEFECTS1: the summary speaks the result page's words (BandWords.word), never BodyMap.band's own names.
	_check(
		(
			text.find("cut over the right eye") >= 0
			and text.find("right eye " + BandWords.word(34.0)) >= 0
			and text.find("nose " + BandWords.word(54.0)) >= 0
		),
		"summary uses the result page's band words (BandWords.word): %s" % text
	)
	var nose_first: String = FaceMark3D.summary(
		{"left_eye": 55.0, "right_eye": 100.0, "nose": 0.0}, {}
	)
	_check(
		nose_first.begins_with("Nose " + BandWords.word(0.0)),
		"worst nose is first and named with the result page's word: %s" % nose_first
	)
	for v in [54.0, 35.0, 34.0, 15.0, 0.0]:
		var one: String = FaceMark3D.summary({"left_eye": float(v)}, {})
		_check(
			one == "Left eye " + BandWords.word(float(v)),
			"left eye at %.0f reads '%s' (%s)" % [float(v), BandWords.word(float(v)), one]
		)
		for internal in ["critical", "doctor"]:
			_check(one.find(str(internal)) < 0, "no internal band name '%s' in '%s'" % [internal, one])


func _test_mutants() -> void:
	var caught_boundary: bool = false
	for i in range(201):
		var v: float = 100.0 - float(i) * 0.5
		if _mutant_steps(v) != FaceMark3D.steps(v):
			caught_boundary = true
			break
	if caught_boundary:
		print("MUTANT caught: off-by-one steps boundary")
	else:
		_fail("MUTANT escaped: off-by-one steps boundary")
	var vals: Dictionary = {"left_eye": 0.0}
	var side: Dictionary = {"closed": {"left_eye": true}}
	var mutant: Array = _mutant_specs_keeps_swell(vals, side)
	if not _no_swell_beside_shut(mutant):
		print("MUTANT caught: swell retained beside shut eye")
	else:
		_fail("MUTANT escaped: swell retained beside shut eye")


func _mutant_steps(v: float) -> int:
	if v > BodyMap.HURT:
		return 0
	if v > BodyMap.CRITICAL + 1.0:
		return 1
	if v > BodyMap.DOCTOR:
		return 2
	return 3


func _mutant_specs_keeps_swell(vals: Dictionary, side: Dictionary) -> Array:
	var out: Array = FaceMark3D.specs(vals, side)
	var closed: Dictionary = side.get("closed", {})
	for place in ["right_eye", "left_eye"]:
		var v: float = float(vals.get(place, 100.0))
		if bool(closed.get(place, false)) and v <= BodyMap.HURT:
			var spot: String = "eye_l" if place == "left_eye" else "eye_r"
			var step: int = FaceMark3D.steps(v)
			out.append({"kind": "swell", "place": place, "spot": spot, "step": step})
	return out


func _no_swell_beside_shut(marks: Array) -> bool:
	var shut_places: Dictionary = {}
	for item in marks:
		var spec: Dictionary = item
		if str(spec.get("kind", "")) == "shut":
			shut_places[str(spec.get("place", ""))] = true
	for item in marks:
		var spec: Dictionary = item
		if str(spec.get("kind", "")) == "swell" and shut_places.has(str(spec.get("place", ""))):
			return false
	return true


func _mark_keys(marks: Array) -> Array:
	var out: Array = []
	for item in marks:
		var mark: Dictionary = item
		out.append("%s:%s" % [str(mark.get("kind", "")), str(mark.get("place", ""))])
	out.sort()
	return out


func _spec_keys(specs: Array) -> Array:
	var out: Array = []
	for item in specs:
		var spec: Dictionary = item
		out.append("%s:%s" % [str(spec.get("kind", "")), str(spec.get("place", ""))])
	out.sort()
	return out


func _spec_order_keys(specs: Array) -> Array:
	var out: Array = []
	for item in specs:
		var spec: Dictionary = item
		out.append("%s:%s" % [str(spec.get("kind", "")), str(spec.get("place", ""))])
	return out


func _same_sorted(a: Array, b: Array) -> bool:
	var aa: Array = a.duplicate()
	var bb: Array = b.duplicate()
	aa.sort()
	bb.sort()
	return aa == bb


func _check(ok: bool, label: String) -> void:
	if not ok:
		_fail(label)


func _fail(label: String) -> void:
	failures += 1
	print("FAIL ", label)
