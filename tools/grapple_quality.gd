extends SceneTree
## S390 (three blind judges on the belt match: Beth standing inverted, limbs through bodies, a pair floating apart): a scan of
## every GrappleMap move on its RAW keyframes, so a match can refuse the ones that cannot look right, instead of patching them
## one film at a time. Writes assets/data/grapple_curated.json. Run:
##   --headless --path . --script res://tools/grapple_quality.gd
## Faults per move: wip (the data's own title says unfinished), inverted, float, apart, inside, pop.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const OUT := "res://assets/data/grapple_curated.json"
const INVERT_M := 0.30   # pelvis this far above the neck, with the head low, for more than a passing moment
const FLOAT_M := 0.16    # a body's lowest joint this far off the mat with no touch on the other body
const APART_M := 0.22    # the closest surfaces this far apart while either is on the ground
const INSIDE_M := 0.15   # capsule into capsule on the trunk
const POP_M := 1.3       # a joint moving this far between two keyframes
const WIP := ["todo: wip", " wip", "stub", "need source"]
## Trunk and thigh capsules [joint a, joint b, radius].
const CAPS := [["Core", "Neck", 0.14], ["Neck", "Head", 0.10], ["LeftHip", "LeftKnee", 0.09], ["RightHip", "RightKnee", 0.09]]
const LIMBS := [["LeftShoulder", "LeftElbow", 0.05], ["RightShoulder", "RightElbow", 0.05], ["LeftElbow", "LeftWrist", 0.04],
	["RightElbow", "RightWrist", 0.04], ["LeftKnee", "LeftAnkle", 0.06], ["RightKnee", "RightAnkle", 0.06]]


func _seg(p1: Vector3, q1: Vector3, p2: Vector3, q2: Vector3) -> float:
	var pts := Geometry3D.get_closest_points_between_segments(p1, q1, p2, q2)
	return pts[0].distance_to(pts[1])


## [deepest trunk overlap, closest surface gap] between the two men in one frame.
func _pair(f: Array) -> Vector2:
	var a: PackedVector3Array = f[0]
	var b: PackedVector3Array = f[1]
	var deep := -INF
	var gap := INF
	for ca in CAPS + LIMBS:
		for cb in CAPS + LIMBS:
			var d := _seg(a[DB.joint(ca[0])], a[DB.joint(ca[1])], b[DB.joint(cb[0])], b[DB.joint(cb[1])]) - float(ca[2]) - float(cb[2])
			gap = minf(gap, d)
			if CAPS.has(ca) and CAPS.has(cb):
				deep = maxf(deep, -d)
	return Vector2(deep, gap)


func _low(m: PackedVector3Array) -> float:
	var y := INF
	for p in m:
		y = minf(y, p.y)
	return y


func _faults(frames: Array) -> Dictionary:
	var out := {"inverted": 0, "float": 0, "apart": 0, "inside": 0.0, "pop": 0.0}
	for k in frames.size():
		var f: Array = frames[k]
		var pr := _pair(f)
		out["inside"] = maxf(float(out["inside"]), pr.x)
		var ground := false
		for mm in 2:
			var m: PackedVector3Array = f[mm]
			var pel: float = (m[DB.joint("LeftHip")].y + m[DB.joint("RightHip")].y) * 0.5
			if pel - m[DB.joint("Neck")].y > INVERT_M and m[DB.joint("Head")].y < 0.4:
				out["inverted"] = int(out["inverted"]) + 1
			if _low(m) > FLOAT_M and pr.y > 0.03:
				out["float"] = int(out["float"]) + 1
			if m[DB.joint("Core")].y < 0.55:
				ground = true
		if ground and pr.y > APART_M:
			out["apart"] = int(out["apart"]) + 1
		if k > 0:
			for mm in 2:
				var m0: PackedVector3Array = frames[k - 1][mm]
				var m1: PackedVector3Array = f[mm]
				for j in m1.size():
					out["pop"] = maxf(float(out["pop"]), m0[j].distance_to(m1[j]))
	return out


func _initialize() -> void:
	var db: Array = DB.load_db()
	var blocked := {}
	var counts := {"tap": 0, "bad_landing": 0, "wip": 0, "inverted": 0, "float": 0, "apart": 0, "inside": 0, "pop": 0}
	var moves := 0
	# A position nobody can stand in: a move that lands there is refused too.
	var bad_pos := {}
	for i in db.size():
		var pf: Array = db[i]["frames"]
		if pf.size() == 1:
			var pq := _faults(pf)
			if int(pq["inverted"]) >= 1 or float(pq["inside"]) > INSIDE_M:
				bad_pos[i] = true
	var graph: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/grapplemap/graph.json"))
	var lands := {}
	for t in graph["transitions"]:
		lands[int(t["id"])] = [t.get("to"), t.get("from") if bool(t.get("bidirectional", false)) else null]
	for i in db.size():
		var e: Dictionary = db[i]
		var frames: Array = e["frames"]
		if frames.size() < 2:
			continue
		moves += 1
		var why: Array = []
		var title := str(e.get("title", "")).to_lower()
		for w in WIP:
			if title.contains(w):
				why.append("wip")
				break
		var q := _faults(frames)
		if int(q["inverted"]) >= 2:
			why.append("inverted")
		if int(q["float"]) >= 2:
			why.append("float")
		if int(q["apart"]) >= 2:
			why.append("apart")
		if float(q["inside"]) > INSIDE_M:
			why.append("inside")
		if float(q["pop"]) > POP_M:
			why.append("pop")
		# GrappleMap's "tap" is the match ending: the pair lets go and stands apart. Played mid-match it is a reset nobody earned.
		if title.begins_with("tap") and not title.contains("through"):
			why.append("tap")
		for l in lands.get(i, []):
			if l != null and bad_pos.has(int(l)) and not why.has("bad_landing"):
				why.append("bad_landing")
		for w in why:
			counts[w] = int(counts[w]) + 1
		if not why.is_empty():
			blocked[str(i)] = why
	var fa := FileAccess.open(OUT, FileAccess.WRITE)
	fa.store_string(JSON.stringify({"_doc": "S390 tools/grapple_quality.gd: GrappleMap moves a match refuses, id -> faults.", "blocked": blocked}, " ", false))
	fa.close()
	print("QUALITY moves=%d blocked=%d bad_positions=%d %s" % [moves, blocked.size(), bad_pos.size(), JSON.stringify(counts)])
	quit(0)
