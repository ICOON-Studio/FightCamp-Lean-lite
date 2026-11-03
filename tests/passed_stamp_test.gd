extends SceneTree
## PASSEDSTAMP1: the stamp card (PassedStamp.make) builds a PanelContainer with a big "PASSED" in the grade's colour,
## the award line, one chip per graded move, and the next grade (or "Every award passed").

const PassedStamp := preload("res://scripts/ui/PassedStamp.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")

var failures := 0


func _initialize() -> void:
	# a. Standard: PASSED label, two chips (Jab, Cross, 8% less gas), Next: Bronze.
	var fa := {"first": "Lucy", "awards": [{"id": "preliminary", "d": 0}, {"id": "standard", "d": 7}], "moves": {}}
	var stamp_a := PassedStamp.make(fa, "Standard")
	var labels_a := _all_labels(stamp_a)
	var has_passed := false
	var has_next_bronze := false
	for l in labels_a:
		if (l as Label).text == "PASSED":
			has_passed = true
		if (l as Label).text.contains("Next: Bronze"):
			has_next_bronze = true
	_check(has_passed, "Standard: has PASSED label")
	_check(has_next_bronze, "Standard: has Next: Bronze label")
	var chip_texts := _chip_labels(stamp_a)
	var has_jab := false
	var has_cross := false
	for ct in chip_texts:
		if str(ct).contains("Jab") and str(ct).contains("8% less gas"):
			has_jab = true
		if str(ct).contains("Cross") and str(ct).contains("8% less gas"):
			has_cross = true
	_check(has_jab and has_cross, "Standard: chips with Jab and Cross and 8%% less gas (got %s)" % str(chip_texts))
	stamp_a.free()
	# b. Preliminary: no "less gas" chip (the grade has no moves).
	var fb := {"first": "Lucy", "awards": [], "moves": {}}
	var stamp_b := PassedStamp.make(fb, "Preliminary")
	var has_less_gas := false
	for ct in _chip_labels(stamp_b):
		if str(ct).contains("less gas"):
			has_less_gas = true
	_check(not has_less_gas, "Preliminary: no less gas chip")
	stamp_b.free()
	# c. Every grade passed: the next line reads "Every award passed".
	var fc := {"first": "Lucy", "awards": [{"id": "preliminary", "d": 0}, {"id": "standard", "d": 7},
		{"id": "bronze", "d": 14}, {"id": "silver", "d": 21}, {"id": "gold", "d": 28}, {"id": "platinum", "d": 35}], "moves": {}}
	var stamp_c := PassedStamp.make(fc, "Platinum")
	var has_every := false
	for l in _all_labels(stamp_c):
		if (l as Label).text.contains("Every award passed"):
			has_every = true
	_check(has_every, "All passed: Every award passed line")
	stamp_c.free()
	# d. The PASSED label colour equals SkillAwards.GRADE_COLOR["standard"].
	var stamp_d := PassedStamp.make(fa, "Standard")
	var color_ok := false
	for l in _all_labels(stamp_d):
		var lab := l as Label
		if lab.text == "PASSED" and lab.get_theme_color("font_color") == SkillAwards.GRADE_COLOR["standard"]:
			color_ok = true
	_check(color_ok, "PASSED label colour matches GRADE_COLOR[standard]")
	stamp_d.free()
	print("PASSED_STAMP failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _all_labels(node: Node) -> Array:
	var out: Array = []
	for child in node.get_children():
		if child is Label:
			out.append(child)
		if child.get_child_count() > 0:
			out.append_array(_all_labels(child))
	return out


func _chip_labels(node: Node) -> Array:
	var out: Array = []
	for child in node.get_children():
		if child is PanelContainer and str(child.theme_type_variation).begins_with("Chip"):
			if child.get_child_count() > 0:
				var lab := child.get_child(0) as Label
				if lab != null:
					out.append(lab.text)
		if child.get_child_count() > 0:
			out.append_array(_chip_labels(child))
	return out


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
