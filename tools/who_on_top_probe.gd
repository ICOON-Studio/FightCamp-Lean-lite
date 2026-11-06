extends "res://tools/bjj_drawn_bars.gd"
## S390 (reviewer, once the two women had different skin: "the label says Nadia on top, but Ana is on top", in both matches): who the rules
## think is on top against whose hips are drawn higher, on every settled ground frame.
var _same := 0
var _diff := 0
var _rawdiff := 0


func _process(delta: float) -> bool:
	var m: Node = b.get_node_or_null("BeltMatch")
	if m != null and (_cache[0] as Dictionary).size() > 10 and (b.get("moving") as Dictionary).is_empty():
		var pos_c: String = BjjMatch.classify(m.call("_tags", int(b.get("current"))))
		if pos_c in ["side_control", "mount", "half_guard", "guard"]:
			var top: int = int(m.call("_top", pos_c))
			var h0: float = ((_cache[0] as Dictionary)["Hips"] as Vector3).y
			var h1: float = ((_cache[1] as Dictionary)["Hips"] as Vector3).y
			if absf(h0 - h1) > 0.08:
				var drawn := 0 if h0 > h1 else 1
				if drawn == top:
					_same += 1
				else:
					_diff += 1
	var done: bool = super._process(delta)
	if done:
		print("TOP same=%d diff=%d" % [_same, _diff])
	return done
