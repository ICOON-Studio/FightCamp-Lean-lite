extends SceneTree
## S337 WrestleChains: six tie-ups, 30 answers, opponent's reaction picks the technique.
## Pure data module; graph.json is read here and passed into clip_for.

const WrestleChains := preload("res://scripts/rules/WrestleChains.gd")

var failures := 0


func _initialize() -> void:
	var ties: Array = WrestleChains.TIES
	_check(ties.size() == 6, "6 ties")
	var expected_order := ["collar_tie", "underhook", "wrist_control", "two_on_one", "russian_tie", "front_headlock"]
	for i in expected_order.size():
		_check(ties[i]["id"] == expected_order[i], "tie %d is %s" % [i, expected_order[i]])

	var answers: Array = WrestleChains.ANSWERS
	_check(answers.size() == 30, "30 answers")

	var tie_ids := {}
	for t in ties:
		tie_ids[t["id"]] = true

	for a in answers:
		_check(tie_ids.has(a["tie"]), "answer tie '%s' is a tie id" % a["tie"])
		_check(a["points"] == 0 or a["points"] == 2, "points in {0,2}: %s = %d" % [a["technique"], a["points"]])
		if a["link"] != "":
			_check(tie_ids.has(a["link"]), "link '%s' is a tie id" % a["link"])
			_check(a["points"] == 0, "link answer has 0 points: %s" % a["technique"])

	var by_tie := {}
	for a in answers:
		if not by_tie.has(a["tie"]):
			by_tie[a["tie"]] = []
		by_tie[a["tie"]].append(a)

	for tid in by_tie:
		_check(by_tie[tid].size() >= 3, "%s has >= 3 answers (%d)" % [tid, by_tie[tid].size()])
		var reactions := {}
		for a in by_tie[tid]:
			_check(not reactions.has(a["reaction"]), "%s: no duplicate reaction '%s'" % [tid, a["reaction"]])
			reactions[a["reaction"]] = true

	var reachable := []
	var queue := ["collar_tie", "wrist_control"]
	var seen := {"collar_tie": true, "wrist_control": true}
	while queue.size() > 0:
		var cur: String = queue.pop_front()
		reachable.append(cur)
		for lnk in WrestleChains.links(cur):
			if not seen.has(lnk):
				seen[lnk] = true
				queue.append(lnk)
	print("  reach order: %s" % str(reachable))
	_check(reachable.size() == 6, "all 6 ties reachable from openings (%d)" % reachable.size())

	var dbl := WrestleChains.answer_for("russian_tie", "pulls her arm away")
	_check(dbl["technique"] == "Double leg", "russian_tie + pulls her arm away -> Double leg")
	var none := WrestleChains.answer_for("russian_tie", "does a backflip")
	_check(none.is_empty(), "unknown reaction -> {}")

	var graph_text := FileAccess.get_file_as_string("res://assets/grapplemap/graph.json")
	var graph: Dictionary = JSON.parse_string(graph_text)
	var transitions: Array = graph["transitions"]

	var clip_hits := 0
	var clip_misses := []
	print("  -- clip table --")
	for a in answers:
		var keywords: Array = a["clip"]
		if keywords.is_empty():
			continue
		var clips: Array = WrestleChains.clip_for(a, transitions)
		if clips.size() > 0:
			clip_hits += 1
			print("  %-22s %2d clips  first: %s" % [a["technique"], clips.size(), clips[0]["title"]])
		else:
			clip_misses.append(a["technique"])
			print("  %-22s  0 clips  (needs our own clip)" % a["technique"])
	_check(clip_hits >= 18, "at least 18 answers with keywords find a clip (%d)" % clip_hits)
	if clip_misses.size() > 0:
		print("  needs our own clip: %s" % str(clip_misses))

	print("FAIL %d" % failures if failures else "PASS wrestle_chains_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
