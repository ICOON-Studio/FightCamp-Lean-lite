extends SceneTree
## S439 DAMAGESHOW1: the result page's figure shows the bout's marks (ResultMarks + BodyCallouts.pin).
## Two different boxers' maps: hers with a cut left eye, a sore nose and a badly hurt liver; the opponent's with one sore nose.

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const ResultMarks := preload("res://scripts/ui/ResultMarks.gd")
const BodyCallouts := preload("res://scripts/ui/BodyCallouts.gd")

var _fails := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print("%s %s" % ["ok  " if ok else "FAIL", what])


func _initialize() -> void:
	var map := BodyMap.fresh()
	map["a"]["places"] = {"head": 58.0, "left_eye": 31.0, "right_eye": 52.0, "nose": 44.0, "left_ribs": 71.0, "right_ribs": 33.0}
	map["a"]["cuts"] = {"left_eye": true}
	map["b"]["places"] = {"head": 74.0, "left_eye": 88.0, "right_eye": 80.0, "nose": 49.0, "left_ribs": 90.0, "right_ribs": 62.0}
	var S: Array = BodyCallouts.SPOTS
	_check(ResultMarks.line(map, "a", S[0]) == "LEFT EYE 31 - badly hurt, cut", "her head card names its worst place and the cut (%s)" % ResultMarks.line(map, "a", S[0]))
	_check(ResultMarks.line(map, "a", S[1]) == "LIVER 33 - badly hurt", "the liver card (%s)" % ResultMarks.line(map, "a", S[1]))
	_check(ResultMarks.line(map, "b", S[0]) == "NOSE 49 - sore", "the opponent's head card (%s)" % ResultMarks.line(map, "b", S[0]))
	_check(ResultMarks.figure({}, "a", "", "red") == null, "no map: no figure")
	var glb := Faces.glb("mh_boxer_11")
	for side in ["a", "b"]:
		var fig: Control = ResultMarks.figure(map, side, glb, "red" if side == "a" else "blue")
		_check(fig != null, "%s: a figure" % side)
		if fig == null:
			continue
		fig.size = ResultMarks.SIZE
		root.add_child(fig)
		var co: Control = fig.get_node_or_null("BodyCallouts")
		if co == null:
			print("note: no baked portrait for %s here, the clean figure is shown" % glb)
			continue
		var want := [true, true, false] if side == "a" else [true, false, false]
		var got := [bool(co.call("marked", 0)), bool(co.call("marked", 1)), bool(co.call("marked", 2))]
		_check(got == want, "%s: the marked close-ups are head/liver/ribs %s (%s)" % [side, want, got])
		_check(bool(co.get("pinned")) and is_equal_approx(float((co.get("_bubbles")[0] as Control).size.x), ResultMarks.HEAD_R * 2.0),
			"%s: pinned, her face card is %d px across" % [side, int(ResultMarks.HEAD_R * 2.0)])
		await process_frame
		await process_frame
		_check(bool(co.call("shown", 0)) == want[0] and bool(co.call("shown", 1)) == want[1] and bool(co.call("shown", 2)) == want[2],
			"%s: a marked close-up is out with no mouse on it, a clean one is not" % side)
		var c0: Vector2 = co.call("centre", 0)
		_check((c0.x < fig.size.x * 0.3) == (side == "a"), "%s: the cards stand on the outer side of the body (x %.0f)" % [side, c0.x])
		fig.queue_free()
	# A clean boxer: nothing pinned.
	var clean: Control = ResultMarks.figure(BodyMap.fresh(), "a", glb, "red")
	var cc: Control = clean.get_node_or_null("BodyCallouts") if clean != null else null
	if cc != null:
		_check(not bool(cc.call("marked", 0)) and not bool(cc.call("marked", 1)) and not bool(cc.call("marked", 2)), "a clean boxer: no close-up marked")
	print("RESULT_MARKS failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)
