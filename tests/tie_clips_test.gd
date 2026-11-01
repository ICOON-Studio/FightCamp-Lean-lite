extends SceneTree
## S340 Tie-clip IDs: the 3 rows that said "No clip of this yet" now point at exact GrappleMap transitions.

const WrestleChains := preload("res://scripts/rules/WrestleChains.gd")

var failures := 0


func _initialize() -> void:
	var graph_text := FileAccess.get_file_as_string("res://assets/grapplemap/graph.json")
	var graph: Dictionary = JSON.parse_string(graph_text)
	var transitions: Array = graph["transitions"]

	# 1. Every ANSWERS row finds >= 1 clip via clip_for.
	var answers: Array = WrestleChains.ANSWERS
	var miss := 0
	for a in answers:
		var clips: Array = WrestleChains.clip_for(a, transitions)
		if clips.size() == 0:
			miss += 1
			print("  MISS %s / %s" % [a["tie"], a["technique"]])
	_check(miss == 0, "every ANSWERS row finds >= 1 clip (%d misses)" % miss)

	# 2. #id syntax: exact match by transition id.
	var exact: Array = WrestleChains.clip_for({"clip": ["#946"]}, transitions)
	_check(exact.size() == 1, "#946 returns exactly 1 transition (%d)" % exact.size())
	if exact.size() == 1:
		_check(str(int(exact[0]["id"])) == "946", "#946 id is 946 (got %s)" % str(int(exact[0]["id"])))

	# 3. Unknown #id returns [].
	var nope: Array = WrestleChains.clip_for({"clip": ["#99999"]}, transitions)
	_check(nope.size() == 0, "#99999 returns [] (%d)" % nope.size())

	# 4. Plain keyword still works.
	var plain: Array = WrestleChains.clip_for({"clip": ["snapdown"]}, transitions)
	_check(plain.size() >= 1, "plain keyword 'snapdown' finds >= 1 (%d)" % plain.size())

	print("FAIL %d" % failures if failures else "PASS tie_clips_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
