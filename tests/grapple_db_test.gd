extends SceneTree
## S335 GrappleMap decode (GrappleMapDB): the whole file reads as 601 positions + 1,485 transitions (counted in S334 by a
## separate script, BJJ_SOURCES_S334.md), every frame keeps the data's fixed limb lengths and stays on or above the mat.
## A wrong digit table, a wrong -2 offset or a joint-order slip breaks the lengths at once. The data itself is soft:
## measured S335, legs stretch past 1 cm in ~7% of frames (arms 0.1-2%), so the bar is each limb's MEAN within 5 mm and
## under 1% of all limbs more than 4 cm off; the pose solver's IK absorbs the stretch.

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")

var failures := 0


func _initialize() -> void:
	var db: Array = DB.load_db()
	var positions := db.filter(func(s): return not DB.is_transition(s)).size()
	var transitions := db.filter(func(s): return DB.is_transition(s)).size()
	_check(positions == 601 and transitions == 1485, "%d positions, %d transitions (601 / 1,485)" % [positions, transitions])
	var limbs := 0
	var off := 0
	var worst := 0.0
	var sums := {}
	var low := 10.0
	var frames := 0
	for s in db:
		for f in s["frames"]:
			frames += 1
			for man in f:
				var p: PackedVector3Array = man
				for l in DB.LIMBS:
					var d := absf(p[DB.joint(l[0])].distance_to(p[DB.joint(l[1])]) - float(l[2]))
					limbs += 1
					worst = maxf(worst, d)
					sums[l[0] + l[1]] = float(sums.get(l[0] + l[1], 0.0)) + p[DB.joint(l[0])].distance_to(p[DB.joint(l[1])])
					if d > 0.04:
						off += 1
				for v in p:
					low = minf(low, v.y)
	_check(frames >= 8000, "%d keyframes decoded" % frames)
	var means_ok := true
	for l in DB.LIMBS:
		var mean := float(sums[l[0] + l[1]]) / (frames * 2)
		if absf(mean - float(l[2])) > 0.005:
			means_ok = false
			print("  %s-%s mean %.3f vs %.3f" % [l[0], l[1], mean, l[2]])
	_check(means_ok, "every limb's mean length within 5 mm of the data's constant")
	_check(float(off) / limbs < 0.01, "limbs more than 4 cm off: %d of %d (worst %.3f m)" % [off, limbs, worst])
	_check(low > -0.02 and low < 0.10, "lowest joint %.3f m (on the mat, no sinking)" % low)
	var kimura: Dictionary = DB.find(db, "full guard kimura")
	_check(not kimura.is_empty() and (kimura["tags"] as PackedStringArray).has("kimura"), "'full guard kimura' found with its tags")
	_check(DB.tagged(db, ["mount"]).size() >= 10, "%d sequences tagged mount" % DB.tagged(db, ["mount"]).size())
	print("FAIL %d" % failures if failures else "PASS grapple_db_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1
