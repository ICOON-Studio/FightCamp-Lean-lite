extends SceneTree
## Every purchased Punch PRO clip must preserve the raw FBX's planted feet and
## leg smoothness after retargeting, allowing only the contract's small margin.

const Compare := preload("res://tools/retarget_compare.gd")


func _initialize() -> void:
	var result := Compare.compare_all()
	var failures := int(result["failures"])
	for line in Compare.failure_lines(result["rows"]):
		print(line)
	print("RETARGET_FIDELITY failures=%d" % failures)
	quit(1 if failures > 0 else 0)
